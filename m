From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] [PATCH 1/1] blk request timeout handler patches
Date: Tue, 9 Oct 2007 11:14:51 +0200
Message-ID: <20071009091451.GD5241@kernel.dk>
References: <20071004181259.GA16689@us.ibm.com> <20071004181750.GB16689@us.ibm.com> <20071005124940.GA7863@kernel.dk> <20071009053610.GA17794@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:22746 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbXJIJOF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Oct 2007 05:14:05 -0400
Content-Disposition: inline
In-Reply-To: <20071009053610.GA17794@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: malahal@us.ibm.com

On Mon, Oct 08 2007, malahal@us.ibm.com wrote:
> Thank you Randy, Jens for your suggestions. I folded the second patch as
> it is just a clean up. Here is the fixed one patch version.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> Signed-off-by: Malahal Naineni <malahal@us.ibm.com>
> 
> Thanks, Malahal.
> 
> diff -r 2cd6b249e335 block/ll_rw_blk.c
> --- a/block/ll_rw_blk.c	Thu Sep 27 09:56:25 2007 -0700
> +++ b/block/ll_rw_blk.c	Mon Oct 08 18:30:34 2007 -0700
> @@ -181,6 +181,18 @@ void blk_queue_softirq_done(struct reque
>  
>  EXPORT_SYMBOL(blk_queue_softirq_done);
>  
> +void blk_queue_rq_timeout(struct request_queue *q, unsigned int timeout)
> +{
> +	q->rq_timeout = timeout;
> +}
> +EXPORT_SYMBOL_GPL(blk_queue_rq_timeout);
> +
> +void blk_queue_rq_timed_out(struct request_queue *q, rq_timed_out_fn *fn)
> +{
> +	q->rq_timed_out_fn = fn;
> +}
> +EXPORT_SYMBOL_GPL(blk_queue_rq_timed_out);
> +
>  /**
>   * blk_queue_make_request - define an alternate make_request function for a device
>   * @q:  the request queue for the device to be affected
> @@ -243,7 +255,9 @@ static void rq_init(struct request_queue
>  {
>  	INIT_LIST_HEAD(&rq->queuelist);
>  	INIT_LIST_HEAD(&rq->donelist);
> -
> +	init_timer(&rq->timer);
> +
> +	rq->timeout = 0;
>  	rq->errors = 0;
>  	rq->bio = rq->biotail = NULL;
>  	INIT_HLIST_NODE(&rq->hash);
> @@ -2305,6 +2319,7 @@ EXPORT_SYMBOL(blk_start_queueing);
>   */
>  void blk_requeue_request(struct request_queue *q, struct request *rq)
>  {
> +	blk_delete_timer(rq);
>  	blk_add_trace_rq(q, rq, BLK_TA_REQUEUE);
>  
>  	if (blk_rq_tagged(rq))
> @@ -3647,8 +3662,103 @@ static struct notifier_block blk_cpu_not
>  };
>  
>  /**
> + * blk_delete_timer - Delete/cancel timer for a given function.
> + * @req:	request that we are canceling timer for
> + *
> + * Return value:
> + *     1 if we were able to detach the timer.  0 if we blew it, and the
> + *     timer function has already started to run.
> + */
> +int blk_delete_timer(struct request *req)
> +{
> +	if (!req->q->rq_timed_out_fn)
> +		return 1;
> +
> +	return del_timer(&req->timer);
> +}
> +EXPORT_SYMBOL_GPL(blk_delete_timer);
> +
> +static void blk_rq_timed_out(unsigned long data)
> +{
> +	struct request *req = (struct request *)data;
> +	struct request_queue *q = req->q;
> +
> +	switch (q->rq_timed_out_fn(req)) {
> +	case BLK_EH_HANDLED:
> +		__blk_complete_request(req);
> +		return;
> +	case BLK_EH_RESET_TIMER:
> +		blk_add_timer(req);
> +		return;
> +	case BLK_EH_NOT_HANDLED:
> +		/*
> +		 * LLD handles this for now but in the future
> +		 * we can send a request msg to abort the command
> +		 * and we can move more of the generic scsi eh code to
> +		 * the blk layer.
> +		 */
> +		return;
> +	}
> +}
> +
> +/**
> + * blk_abort_req -- Request request recovery for the specified command
> + * @req:	pointer to the request of interest
> + *
> + * This function requests that the block layer start recovery for the
> + * request by deleting the timer and calling the q's timeout function.
> + * LLDDs who implement their own error recovery MAY ignore the timeout
> + * event if they generated blk_abort_req.
> + */
> +void blk_abort_req(struct request *req)
> +{
> +        if (!blk_delete_timer(req))
> +                return;
> +        blk_rq_timed_out(req);

You didn't do as I described. Did you try to compile this? It'll throw a
warning because of the pointer -> unsigned long cast. You need an extra
function to convert this cleanly. A cast would do of course, but I think
the extra function is a lot cleaner.

-- 
Jens Axboe

