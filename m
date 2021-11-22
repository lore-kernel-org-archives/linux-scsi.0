Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC37C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 08:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238892AbhKVItf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 03:49:35 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4117 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbhKVIte (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 03:49:34 -0500
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HyLPR54T8z67RS4;
        Mon, 22 Nov 2021 16:42:35 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 22 Nov 2021 09:46:26 +0100
Received: from [10.47.91.234] (10.47.91.234) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.20; Mon, 22 Nov
 2021 08:46:25 +0000
Subject: Re: [PATCH v2 01/20] block: Add a flag for internal commands
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-2-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <c2f48945-6e6f-d610-9e56-1546fee07b49@huawei.com>
Date:   Mon, 22 Nov 2021 08:46:21 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20211119195743.2817-2-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.91.234]
X-ClientProxiedBy: lhreml705-chm.china.huawei.com (10.201.108.54) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/11/2021 19:57, Bart Van Assche wrote:
> From: Hannes Reinecke <hare@suse.de> >
> Some drivers use a single tag space for requests submitted by the block
> layer and driver-internal requests. Driver-internal requests will never
> pass through the block layer but require a valid tag. This patch adds a
> new request flag REQ_INTERNAL.

I'm not sure on the name. Don't we already use term "internal" for 
elevator request tag?

> to mark such requests and a terminates any
> such commands in blk_execute_rq_nowait() with a WARN_ON_ONCE() to signal
> such an invalid usage.
FYI, I have been working on a different stream, that allows us to send 
the reserved request through the block layer, as we need it for poll 
mode support. The reason is that we need to send reserved requests on 
specific HW queues, which may be polling. However poll mode support only 
allows us to poll requests with bios, so that's a problem ATM.

> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: John Garry <john.garry@huawei.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> [ bvanassche: modified patch description ]
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   block/blk-exec.c          | 5 +++++
>   include/linux/blk-mq.h    | 5 +++++
>   include/linux/blk_types.h | 2 ++
>   3 files changed, 12 insertions(+)
> 
> diff --git a/block/blk-exec.c b/block/blk-exec.c
> index 1b8b47f6e79b..27d2e3779c13 100644
> --- a/block/blk-exec.c
> +++ b/block/blk-exec.c
> @@ -53,6 +53,11 @@ void blk_execute_rq_nowait(struct gendisk *bd_disk, struct request *rq,
>   	rq->rq_disk = bd_disk;
>   	rq->end_io = done;
>   
> +	if (WARN_ON_ONCE(blk_rq_is_internal(rq))) {
> +		blk_mq_end_request(rq, BLK_STS_NOTSUPP);
> +		return;
> +	}
> +
>   	blk_account_io_start(rq);
>   
>   	/*
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 2949d9ac7484..3b42fcdf0c15 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -208,6 +208,11 @@ static inline bool blk_rq_is_passthrough(struct request *rq)
>   	return blk_op_is_passthrough(req_op(rq));
>   }
>   
> +static inline bool blk_rq_is_internal(struct request *rq)
> +{
> +	return rq->cmd_flags & REQ_INTERNAL;
> +}
> +
>   static inline unsigned short req_get_ioprio(struct request *req)
>   {
>   	return req->ioprio;
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index fe065c394fff..1ae2365e02d1 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -411,6 +411,7 @@ enum req_flag_bits {
>   	/* for driver use */
>   	__REQ_DRV,
>   	__REQ_SWAP,		/* swapping request. */
> +	__REQ_INTERNAL,		/* driver-internal command */
>   	__REQ_NR_BITS,		/* stops here */
>   };
>   
> @@ -435,6 +436,7 @@ enum req_flag_bits {
>   
>   #define REQ_DRV			(1ULL << __REQ_DRV)
>   #define REQ_SWAP		(1ULL << __REQ_SWAP)
> +#define REQ_INTERNAL		(1ULL << __REQ_INTERNAL)
>   
>   #define REQ_FAILFAST_MASK \
>   	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
> .
> 

