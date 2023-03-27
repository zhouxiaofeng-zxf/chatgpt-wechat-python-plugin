FROM python:3.9.16-alpine

LABEL maintainer="foo@bar.com"
ARG TZ='Asia/Shanghai'

ARG CHATGPT_ON_WECHAT_VER

ENV BUILD_PREFIX=/app 

RUN apk add --no-cache \
        bash \
        curl \
        wget 
ADD .   ${BUILD_PREFIX}       

RUN cd ${BUILD_PREFIX} \
    && cp config-template.json ${BUILD_PREFIX}/config.json \
    && /usr/local/bin/python -m pip install --no-cache --upgrade pip \
    && pip install --no-cache   \
        itchat-uos==1.5.0.dev0  \
        openai                  \
    && apk del curl wget

WORKDIR ${BUILD_PREFIX}

ADD docker/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh \
    && pip3 install itchat-uos==1.5.0.dev0 \
    && pip3 install --upgrade openai \
    && pip3 show openai \
    && adduser -D -h /home/noroot -u 1000 -s /bin/bash noroot \
    && chown -R noroot:noroot ${BUILD_PREFIX}

USER noroot

ENTRYPOINT ["/entrypoint.sh"]
