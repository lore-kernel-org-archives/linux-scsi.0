Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF49C4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 06:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 504C423B7E
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 06:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgLIGGe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 01:06:34 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:52294 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727651AbgLIGGd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 01:06:33 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607493968; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=0OGOVwNVerfKEFYW/g6j0tRLHGtreXxSJsFwz7NcKNk=;
 b=Sw25nGFLn4SWvtc3fDII3KxJXUhF8L+OYL4TN1Qac17Pp28lzad08gJvoOiZK8ivcMjxCaXQ
 Fuc0x5USMi/nyU19cL1KfKS/SxNJg9c1jqFPpDeDZgf9CkuBtgiE9mMD5V/VT3dMAQbvVcf0
 P90isfFamBZi3HcYrQVybjTinNk=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
 5fd06925395c822bfe457883 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 09 Dec 2020 06:05:25
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1F056C433CA; Wed,  9 Dec 2020 06:05:25 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E7873C433C6;
        Wed,  9 Dec 2020 06:05:20 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 09 Dec 2020 14:05:20 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Stanley Chu <stanley.chu@mediatek.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: Re: [PATCH v5 7/8] block: Remove RQF_PREEMPT and BLK_MQ_REQ_PREEMPT
In-Reply-To: <20201209052951.16136-8-bvanassche@acm.org>
References: <20201209052951.16136-1-bvanassche@acm.org>
 <20201209052951.16136-8-bvanassche@acm.org>
Message-ID: <c96ef8a700f4f3d59872b8a4067762e4@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-09 13:29, Bart Van Assche wrote:
> Remove flag RQF_PREEMPT and BLK_MQ_REQ_PREEMPT since these are no 
> longer
> used by any kernel code.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Can Guo <cang@codeaurora.org>

> Cc: Can Guo <cang@codeaurora.org>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Martin Kepplinger <martin.kepplinger@puri.sm>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-core.c       | 7 +++----
>  block/blk-mq-debugfs.c | 1 -
>  block/blk-mq.c         | 2 --
>  include/linux/blk-mq.h | 2 --
>  include/linux/blkdev.h | 6 +-----
>  5 files changed, 4 insertions(+), 14 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 10696f9fb6ac..a00bce9f46d8 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -424,11 +424,11 @@ EXPORT_SYMBOL(blk_cleanup_queue);
>  /**
>   * blk_queue_enter() - try to increase q->q_usage_counter
>   * @q: request queue pointer
> - * @flags: BLK_MQ_REQ_NOWAIT, BLK_MQ_REQ_PM and/or BLK_MQ_REQ_PREEMPT
> + * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PM
>   */
>  int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
>  {
> -	const bool pm = flags & (BLK_MQ_REQ_PM | BLK_MQ_REQ_PREEMPT);
> +	const bool pm = flags & BLK_MQ_REQ_PM;
> 
>  	while (true) {
>  		bool success = false;
> @@ -630,8 +630,7 @@ struct request *blk_get_request(struct
> request_queue *q, unsigned int op,
>  	struct request *req;
> 
>  	WARN_ON_ONCE(op & REQ_NOWAIT);
> -	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PM |
> -			       BLK_MQ_REQ_PREEMPT));
> +	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PM));
> 
>  	req = blk_mq_alloc_request(q, op, flags);
>  	if (!IS_ERR(req) && q->mq_ops->initialize_rq_fn)
> diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
> index 3094542e12ae..9336a6f8d6ef 100644
> --- a/block/blk-mq-debugfs.c
> +++ b/block/blk-mq-debugfs.c
> @@ -297,7 +297,6 @@ static const char *const rqf_name[] = {
>  	RQF_NAME(MIXED_MERGE),
>  	RQF_NAME(MQ_INFLIGHT),
>  	RQF_NAME(DONTPREP),
> -	RQF_NAME(PREEMPT),
>  	RQF_NAME(FAILED),
>  	RQF_NAME(QUIET),
>  	RQF_NAME(ELVPRIV),
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index b5880a1fb38d..d50504888b68 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -294,8 +294,6 @@ static struct request *blk_mq_rq_ctx_init(struct
> blk_mq_alloc_data *data,
>  	rq->cmd_flags = data->cmd_flags;
>  	if (data->flags & BLK_MQ_REQ_PM)
>  		rq->rq_flags |= RQF_PM;
> -	if (data->flags & BLK_MQ_REQ_PREEMPT)
> -		rq->rq_flags |= RQF_PREEMPT;
>  	if (blk_queue_io_stat(data->q))
>  		rq->rq_flags |= RQF_IO_STAT;
>  	INIT_LIST_HEAD(&rq->queuelist);
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index c00e856c6fb1..88af1df94308 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -446,8 +446,6 @@ enum {
>  	BLK_MQ_REQ_RESERVED	= (__force blk_mq_req_flags_t)(1 << 1),
>  	/* set RQF_PM */
>  	BLK_MQ_REQ_PM		= (__force blk_mq_req_flags_t)(1 << 2),
> -	/* set RQF_PREEMPT */
> -	BLK_MQ_REQ_PREEMPT	= (__force blk_mq_req_flags_t)(1 << 3),
>  };
> 
>  struct request *blk_mq_alloc_request(struct request_queue *q, unsigned 
> int op,
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 639cae2c158b..7d4b746f7e6a 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -79,9 +79,6 @@ typedef __u32 __bitwise req_flags_t;
>  #define RQF_MQ_INFLIGHT		((__force req_flags_t)(1 << 6))
>  /* don't call prep for this one */
>  #define RQF_DONTPREP		((__force req_flags_t)(1 << 7))
> -/* set for "ide_preempt" requests and also for requests for which the 
> SCSI
> -   "quiesce" state must be ignored. */
> -#define RQF_PREEMPT		((__force req_flags_t)(1 << 8))
>  /* vaguely specified driver internal error.  Ignored by the block 
> layer */
>  #define RQF_FAILED		((__force req_flags_t)(1 << 10))
>  /* don't warn about errors */
> @@ -430,8 +427,7 @@ struct request_queue {
>  	unsigned long		queue_flags;
>  	/*
>  	 * Number of contexts that have called blk_set_pm_only(). If this
> -	 * counter is above zero then only RQF_PM and RQF_PREEMPT requests 
> are
> -	 * processed.
> +	 * counter is above zero then only RQF_PM requests are processed.
>  	 */
>  	atomic_t		pm_only;
