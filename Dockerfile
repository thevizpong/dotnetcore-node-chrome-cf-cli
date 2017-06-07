FROM microsoft/dotnet:1-sdk-msbuild
MAINTAINER The Viz Pong <thevizpong@gmail.com>

# Install some utilities for use during after constructing the docker image.
RUN \
  apt-get update \
  && apt-get install -y --no-install-recommends apt-utils \
  && apt-get install -y --no-install-recommends wget bzip2 unzip zip xz-utils gconf2 jq \
  && rm -rf /var/lib/apt/lists/*

### Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/azure-cli/ wheezy main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-key adv --keyserver apt-mo.trafficmanager.net --recv-keys 417A0893 && \
    apt-get update && \
    apt-get install --no-install-recommends -y apt-transport-https && \
    apt-get install --no-install-recommends -y \
        azure-cli \
        nodejs \
        libssl-dev \
        libffi-dev \
        python-dev \
        build-essential && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && apt-get clean

RUN npm i -g --unsafe-perm bower && \
    echo '{ "allow_root": true }' > /root/.bowerrc

### Install Chrome
# Chrome setup code expanded upon from: https://github.com/mark-adams/docker-chromium-xvfb/tree/master/images/base

RUN apt-get update && apt-get install -y xvfb chromium

COPY ./docker-resources/xvfb-chromium /usr/bin/xvfb-chromium
RUN ln -s /usr/bin/xvfb-chromium /usr/bin/google-chrome
RUN ln -s /usr/bin/xvfb-chromium /usr/bin/chromium-browser

RUN \
    curl -O http://chromedriver.storage.googleapis.com/2.26/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && rm chromedriver_linux64.zip
# End install chrome
