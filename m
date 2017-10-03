From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V5 1/7] blk-mq: issue rq directly in
 blk_mq_request_bypass_insert()
Date: Tue, 3 Oct 2017 01:58:50 -0700
Message-ID: <20171003085850.GA21184@infradead.org>
References: <20170930102720.30219-1-ming.lei@redhat.com>
 <20170930102720.30219-2-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39151 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdJCI6x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2017 04:58:53 -0400
Content-Disposition: inline
In-Reply-To: <20170930102720.30219-2-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>

This patch does two many things at once and needs a split. I also
don't really understand why it's in this series and not your dm-mpath
performance one.

> +static void blk_mq_request_direct_insert(struct blk_mq_hw_ctx *hctx,
> +					 struct request *rq)
> +{
> +	spin_lock(&hctx->lock);
> +	list_add_tail(&rq->queuelist, &hctx->dispatch);
> +	spin_unlock(&hctx->lock);
> +
> +	blk_mq_run_hw_queue(hctx, false);
> +}

Why doesn't this share code with blk_mq_sched_bypass_insert?

>  /*
>   * Should only be used carefully, when the caller knows we want to
>   * bypass a potential IO scheduler on the target device.
>   */
> -void blk_mq_request_bypass_insert(struct request *rq)
> +blk_status_t blk_mq_request_bypass_insert(struct request *rq)
>  {
>  	struct blk_mq_ctx *ctx = rq->mq_ctx;
>  	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(rq->q, ctx->cpu);
> +	blk_qc_t cookie;
> +	blk_status_t ret;
>  
> -	spin_lock(&hctx->lock);
> -	list_add_tail(&rq->queuelist, &hctx->dispatch);
> -	spin_unlock(&hctx->lock);
> -
> -	blk_mq_run_hw_queue(hctx, false);
> +	ret = blk_mq_try_issue_directly(hctx, rq, &cookie, true);
> +	if (ret == BLK_STS_RESOURCE)
> +		blk_mq_request_direct_insert(hctx, rq);
> +	return ret;

If you actually insert the request on BLK_STS_RESOURCE why do you
pass the error on?  In general BLK_STS_RESOURCE indicates a failure
to issue.

> +/*
> + * 'dispatch_only' means we only try to dispatch it out, and
> + * don't deal with dispatch failure if BLK_STS_RESOURCE or
> + * BLK_STS_IOERR happens.
> + */
> +static blk_status_t __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
> +		struct request *rq, blk_qc_t *cookie, bool may_sleep,
> +		bool dispatch_only)

This dispatch_only argument that completely changes behavior is a
nightmare.  Try to find a way to have a low-level helper that
always behaves as if dispatch_only is set, and then build another
helper that actually issues/completes around it.
