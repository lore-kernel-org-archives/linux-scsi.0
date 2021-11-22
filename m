Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBEFEC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 08:07:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238829AbhKVIKe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 03:10:34 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:33743 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbhKVIKd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 03:10:33 -0500
Received: by mail-wr1-f54.google.com with SMTP id d24so31103692wra.0;
        Mon, 22 Nov 2021 00:07:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RC3vqKD9hTcCEz5IFzW1f6PPJL6TcyhoZreRczcumkw=;
        b=r1/MLO6ALbJf+0AuVrqaJ90ThYRw4F0pizuvYs7DutsRLBK33cJGFKGbk8GFFZZHYT
         rAopPjZyQm748Dd+aLdjYKbUwblNIPMWT2GpxVrgOKmZ7RtuSiSO37N8HckYarDJhmoQ
         jqg/Ha38ufEnRe0mwFBuzlUJjC53FQ9cpQN0ixBmbNktHYT+sRLBi1zeDr5y0wgTiZ3h
         /ksTZHSTvXTFDUubWzHcIvlHxEQwgTwwje8yWAGIwEZnhNY/mH+fuM2FPqacbd0jvBIA
         4lonvptFtLiBZRBGUDbyEukp17diEMxdZcYFweyvEEBusxOfqVtFpEZcdHmfzKh0s6Jh
         oDRw==
X-Gm-Message-State: AOAM533iRDNmv6WWFVdtkv3ERLtW25qCbQ8l9BqW8iNLRwaYEv2vRbbB
        umKNgSkWyUoWAUjofMY8ZHM=
X-Google-Smtp-Source: ABdhPJxbNRaRTtAyqwOPZ4j2lhyUy3FE9JmpQkWy0BpH4ksV9H6Z70PwoM66ii78SHDO1pIjj879vA==
X-Received: by 2002:a5d:6347:: with SMTP id b7mr34477235wrw.36.1637568446438;
        Mon, 22 Nov 2021 00:07:26 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id j17sm11054638wmq.41.2021.11.22.00.07.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 00:07:26 -0800 (PST)
Subject: Re: [PATCH 4/5] nvme: quiesce namespace queue in parallel
To:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Chao Leng <lengchao@huawei.com>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
 <20211119021849.2259254-5-ming.lei@redhat.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <37036ab3-da87-898e-5af6-1abf228b4390@grimberg.me>
Date:   Mon, 22 Nov 2021 10:07:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211119021849.2259254-5-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 11/19/21 4:18 AM, Ming Lei wrote:
> Chao Leng reported that in case of lots of namespaces, it may take quite a
> while for nvme_stop_queues() to quiesce all namespace queues.
> 
> Improve nvme_stop_queues() by running quiesce in parallel, and just wait
> once if global quiesce wait is allowed.
> 
> Link: https://lore.kernel.org/linux-block/cc732195-c053-9ce4-e1a7-e7f6dcf762ac@huawei.com/
> Reported-by: Chao Leng <lengchao@huawei.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   drivers/nvme/host/core.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 4b5de8f5435a..06741d3ed72b 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -4517,9 +4517,7 @@ static void nvme_start_ns_queue(struct nvme_ns *ns)
>   static void nvme_stop_ns_queue(struct nvme_ns *ns)
>   {
>   	if (!test_and_set_bit(NVME_NS_STOPPED, &ns->flags))
> -		blk_mq_quiesce_queue(ns->queue);
> -	else
> -		blk_mq_wait_quiesce_done(ns->queue);
> +		blk_mq_quiesce_queue_nowait(ns->queue);
>   }
>   
>   /*
> @@ -4620,6 +4618,11 @@ void nvme_stop_queues(struct nvme_ctrl *ctrl)
>   	down_read(&ctrl->namespaces_rwsem);
>   	list_for_each_entry(ns, &ctrl->namespaces, list)
>   		nvme_stop_ns_queue(ns);
> +	list_for_each_entry(ns, &ctrl->namespaces, list) {
> +		blk_mq_wait_quiesce_done(ns->queue);
> +		if (blk_mq_global_quiesce_wait(ns->queue))
> +			break;
> +	}
>   	up_read(&ctrl->namespaces_rwsem);


Can you quantify how much of a difference it is to do rcu_read_unlock()
for every queue? The big improvement here is that it is done in parallel
instead of serially. Just wandering if it is worth the less than elegant
interface...
