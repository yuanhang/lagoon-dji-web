FROM node:17.8-buster as build

WORKDIR /app

ADD . .

RUN npm install

RUN npm run build


FROM nginx:stable as stage

ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /home/vue_server/

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 8080
STOPSIGNAL SIGTERM
CMD ["nginx","-g","daemon off;"]



