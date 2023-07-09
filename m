Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2414EB64DC
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Jul 2023 14:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbjGIOcs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Jul 2023 10:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjGIOcr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Jul 2023 10:32:47 -0400
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330DCFF;
        Sun,  9 Jul 2023 07:32:42 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-3facc7a4e8aso7776065e9.0;
        Sun, 09 Jul 2023 07:32:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688913160; x=1691505160;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fi8HZWe00as6NY8cKM/Z1+nvL1s7YeXy199NqP9ShII=;
        b=K89d+UCCzmd42gjQKhzLlm8myEIh70D9xjtth7bSvMqFwV76+wWXN2dP324XJjxchV
         pzVBPulXjjGospJHccHvbKHIqMCjnXgSn0wxsvnr6VTkUttkhDHvr+RHqZ+80axTkOTc
         JhCvnYF8JMdNly2e7sHw1wEnSRS6gYxRXJ0arXJmaxKioZn6sr/HQ0kZcMqW/t8xE+0Y
         HAXXLXGnsIQHzURUWC9zCYaERgj4UuxS+6xngyeMWYVD2QcNukDMHFFYiEkavn1GnmpV
         sYGzuHeVK+bqMZCi3mTaMnu6CK/hskzrOZpkL+XxEtdljPBZ3SnJL3/f/MWz6Cnkwu2R
         rrBw==
X-Gm-Message-State: ABy/qLYnRE1kCsNnPD2svDP4PG5zqm+cPZUk+qrW9O/8tdTurWNQzisk
        MmEKrzPXDhqbZaoJ9GxpdHOZ3oqwFY8=
X-Google-Smtp-Source: APBJJlFEIuFofQ1/SqOhdmpRu5JJopAnJyej4izHcf2ZEhE0zRT1k4+hi5QBs39TGI+uQYQcVh3POA==
X-Received: by 2002:a05:600c:4f56:b0:3fb:f025:9372 with SMTP id m22-20020a05600c4f5600b003fbf0259372mr9988489wmq.4.1688913160303;
        Sun, 09 Jul 2023 07:32:40 -0700 (PDT)
Received: from [10.100.102.14] (46-116-229-137.bb.netvision.net.il. [46.116.229.137])
        by smtp.gmail.com with ESMTPSA id m4-20020a05600c280400b003fc07e17d4esm3947099wmb.2.2023.07.09.07.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Jul 2023 07:32:39 -0700 (PDT)
Message-ID: <165eceaa-55d4-f9c7-7e02-18115e6df6fe@grimberg.me>
Date:   Sun, 9 Jul 2023 17:32:38 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: blktests failures with v6.4
Content-Language: en-US
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <lkmloyrqpebispffur5udxdiubmevvodtsvnap3jz7tv5ihstr@jg7ejye3bein>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <lkmloyrqpebispffur5udxdiubmevvodtsvnap3jz7tv5ihstr@jg7ejye3bein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> #3: nvme/003 (fabrics transport)
> 
>     When nvme test group is run with trtype=rdma or tcp, the test case fails
>     due to lockdep WARNING "possible circular locking dependency detected".
>     Reported in May/2023. Bart suggested a fix for trytpe=rdma [4] but it
>     needs more discussion.
> 
>     [4] https://lore.kernel.org/linux-nvme/20230511150321.103172-1-bvanassche@acm.org/

This patch is unfortunately incorrect and buggy.

This will likely make the issue go away, but adds another
old issue where a client can DDOS a target by bombarding it
with connect/disconnect. When releases are async and we don't
have any back-pressure, it is likely to happen.
--
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 4597bca43a6d..8b4f4aa48206 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1582,11 +1582,6 @@ static int nvmet_rdma_queue_connect(struct 
rdma_cm_id *cm_id,
                 goto put_device;
         }

-       if (queue->host_qid == 0) {
-               /* Let inflight controller teardown complete */
-               flush_workqueue(nvmet_wq);
-       }
-
         ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
         if (ret) {
                 /*
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 868aa4de2e4c..c8cfa19e11c7 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1844,11 +1844,6 @@ static u16 nvmet_tcp_install_queue(struct 
nvmet_sq *sq)
         struct nvmet_tcp_queue *queue =
                 container_of(sq, struct nvmet_tcp_queue, nvme_sq);

-       if (sq->qid == 0) {
-               /* Let inflight controller teardown complete */
-               flush_workqueue(nvmet_wq);
-       }
-
         queue->nr_cmds = sq->size * 2;
         if (nvmet_tcp_alloc_cmds(queue))
                 return NVME_SC_INTERNAL;
--
