Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D35C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 06:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FB9D23B7D
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 06:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgLIGHP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 01:07:15 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:40117 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgLIGHP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 01:07:15 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607494011; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=28SENODm6Im8i/+HqRgWU6yL1B/KKG507naoYpEwBs8=;
 b=A5wAP0AWzFX2ApdJ6ksKcPF+DtTV5N0knQOOBhdiodFWkQMc91pQMYHv6rvNVDqAxGk8qMUt
 ODdoQaMDUSfStrUcMP/OjPdhvwFiKMcTTxe8pO3HsWNB9pAmFAnTRJMnVzX0zZPqoGT2BskY
 Nr0VLA4dABt61cdisyENibS1F3k=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5fd0696fc2fb7b0d2b8591b8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 09 Dec 2020 06:06:39
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F31C1C433ED; Wed,  9 Dec 2020 06:06:38 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CC3EAC433CA;
        Wed,  9 Dec 2020 06:06:36 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 09 Dec 2020 14:06:36 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v5 2/8] block: Introduce BLK_MQ_REQ_PM
In-Reply-To: <20201209052951.16136-3-bvanassche@acm.org>
References: <20201209052951.16136-1-bvanassche@acm.org>
 <20201209052951.16136-3-bvanassche@acm.org>
Message-ID: <f78fc7ec9f5f8c88ba298fa00c6fab49@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-09 13:29, Bart Van Assche wrote:
> Introduce the BLK_MQ_REQ_PM flag. This flag makes the request 
> allocation
> functions set RQF_PM. This is the first step towards removing
> BLK_MQ_REQ_PREEMPT.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Can Guo <cang@codeaurora.org>

> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Can Guo <cang@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-core.c       | 7 ++++---
>  block/blk-mq.c         | 2 ++
>  include/linux/blk-mq.h | 2 ++
>  3 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 2db8bda43b6e..10696f9fb6ac 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -424,11 +424,11 @@ EXPORT_SYMBOL(blk_cleanup_queue);
>  /**
>   * blk_queue_enter() - try to increase q->q_usage_counter
>   * @q: request queue pointer
> - * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PREEMPT
> + * @flags: BLK_MQ_REQ_NOWAIT, BLK_MQ_REQ_PM and/or BLK_MQ_REQ_PREEMPT
>   */
>  int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
>  {
> -	const bool pm = flags & BLK_MQ_REQ_PREEMPT;
> +	const bool pm = flags & (BLK_MQ_REQ_PM | BLK_MQ_REQ_PREEMPT);
> 
>  	while (true) {
>  		bool success = false;
> @@ -630,7 +630,8 @@ struct request *blk_get_request(struct
> request_queue *q, unsigned int op,
>  	struct request *req;
> 
>  	WARN_ON_ONCE(op & REQ_NOWAIT);
> -	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PREEMPT));
> +	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PM |
> +			       BLK_MQ_REQ_PREEMPT));
> 
>  	req = blk_mq_alloc_request(q, op, flags);
>  	if (!IS_ERR(req) && q->mq_ops->initialize_rq_fn)
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 1b25ec2fe9be..b5880a1fb38d 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -292,6 +292,8 @@ static struct request *blk_mq_rq_ctx_init(struct
> blk_mq_alloc_data *data,
>  	rq->mq_hctx = data->hctx;
>  	rq->rq_flags = 0;
>  	rq->cmd_flags = data->cmd_flags;
> +	if (data->flags & BLK_MQ_REQ_PM)
> +		rq->rq_flags |= RQF_PM;
>  	if (data->flags & BLK_MQ_REQ_PREEMPT)
>  		rq->rq_flags |= RQF_PREEMPT;
>  	if (blk_queue_io_stat(data->q))
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index b23eeca4d677..c00e856c6fb1 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -444,6 +444,8 @@ enum {
>  	BLK_MQ_REQ_NOWAIT	= (__force blk_mq_req_flags_t)(1 << 0),
>  	/* allocate from reserved pool */
>  	BLK_MQ_REQ_RESERVED	= (__force blk_mq_req_flags_t)(1 << 1),
> +	/* set RQF_PM */
> +	BLK_MQ_REQ_PM		= (__force blk_mq_req_flags_t)(1 << 2),
>  	/* set RQF_PREEMPT */
>  	BLK_MQ_REQ_PREEMPT	= (__force blk_mq_req_flags_t)(1 << 3),
>  };
