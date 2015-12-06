FROM ubuntu:14.04

RUN \
  apt-get update && apt-get upgrade -y && \
  DEBIAN_FRONTEND=noninteractive

ENV WORKDIR="/src"

WORKDIR $WORKDIR

RUN apt-get install -y wget tar git gcc make gzip bzip2 libmagickwand-dev

RUN \
  git clone https://github.com/cubicdaiya/ngx_small_light.git && \
  cd ngx_small_light && \
  ./setup && \
  ldconfig /usr/local/lib

# nginx

RUN \
  wget http://nginx.org/download/nginx-1.9.7.tar.gz && \
  tar xvzf nginx-1.9.7.tar.gz && \
  cd nginx-1.9.7 && \
  ./configure --add-module=${WORKDIR}/ngx_small_light && \
  make && \
  make install && \
  ln -s /usr/local/nginx/sbin/nginx /usr/sbin/nginx

COPY nginx.conf /usr/local/nginx/conf/nginx.conf
COPY index.html /usr/local/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
