From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] [PATCH 1/2] blk request timeout handler patches
Date: Fri, 5 Oct 2007 14:50:29 +0200
Message-ID: <20071005125029.GB7863@kernel.dk>
References: <20071004181259.GA16689@us.ibm.com> <20071004181750.GB16689@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:3949 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605AbXJEMtH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Oct 2007 08:49:07 -0400
Content-Disposition: inline
In-Reply-To: <20071004181750.GB16689@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: malahal@us.ibm.com


(resend, with proper CC - stupid mutt)

On Thu, Oct 04 2007, malahal@us.ibm.com wrote:
> Mike Christie's patches refreshed to 2.6.23-rc8-mm1.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> Signed-off-by: Malahal Naineni <malahal@us.ibm.com>
> 
> 
> diff -r 3697367c6e4d block/ll_rw_blk.c
> --- a/block/ll_rw_blk.c	Thu Sep 27 00:12:13 2007 -0700
> +++ b/block/ll_rw_blk.c	Thu Sep 27 00:13:07 2007 -0700
> @@ -181,6 +181,19 @@ void blk_queue_softirq_done(struct reque
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
> +
> +EXPORT_SYMBOL_GPL(blk_queue_rq_timed_out);
> +
>  /**
>   * blk_queue_make_request - define an alternate make_request function for a device
>   * @q:  the request queue for the device to be affected
> @@ -243,7 +256,9 @@ static void rq_init(struct request_queue
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
> @@ -2305,6 +2320,7 @@ EXPORT_SYMBOL(blk_start_queueing);
>   */
>  void blk_requeue_request(struct request_queue *q, struct request *rq)
>  {
> +	blk_delete_timer(rq);
>  	blk_add_trace_rq(q, rq, BLK_TA_REQUEUE);
>  
>  	if (blk_rq_tagged(rq))
> @@ -3647,8 +3663,121 @@ static struct notifier_block blk_cpu_not
>  };
>  
>  /**
> + * blk_delete_timer - Delete/cancel timer for a given function.
> + * @req:	request that we are canceling timer for
> + *
> + * Return value:
> + *     1 if we were able to detach the timer.  0 if we blew it, and the
> + *     timer function has already started to run.
> + **/
> +int blk_delete_timer(struct request *req)
> +{
> +	int rtn;
> +
> +	if (!req->q->rq_timed_out_fn)
> +		return 1;
> +
> +	rtn = del_timer(&req->timer);
> +	req->timer.data = (unsigned long)NULL;
> +	req->timer.function = NULL;
> +
> +	return rtn;
> +}

Hmm, that looks fishy. What if the timer _just_ fired, yet it hasn't
retrieved ->data yet?

> +
> +EXPORT_SYMBOL_GPL(blk_delete_timer);
> +
> +static void blk_rq_timed_out(struct request *req)
> +{
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
> + * req:		pointer to the request of interest
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
> +}
> +
> +EXPORT_SYMBOL_GPL(blk_abort_req);
> +
> +/**
> + * blk_add_timer - Start timeout timer for a single request
> + * @req:	request that is about to start running.
> + *
> + * Notes:
> + *    Each request has its own timer, and as it is added to the queue, we
> + *    set up the timer.  When the request completes, we cancel the timer.
> + **/
> +void blk_add_timer(struct request *req)
> +{
> +	struct request_queue *q = req->q;
> +
> +	/*
> +	 * If the clock was already running for this command, then
> +	 * first delete the timer.  The timer handling code gets rather
> +	 * confused if we don't do this.
> +	 */
> +	if (req->timer.function)
> +		del_timer(&req->timer);
> +
> +	req->timer.data = (unsigned long)req;
> +	if (req->timeout)
> +		req->timer.expires = jiffies + req->timeout;
> +	else
> +		req->timer.expires = jiffies + q->rq_timeout;
> +	req->timer.function = (void (*)(unsigned long))blk_rq_timed_out;

Why the cast?

> +        add_timer(&req->timer);

You have space vs tab issues.

> +}

That's an ugly interface. I'd say it's a bug to call blk_add_timer()
with it already pending, so fix the API.

Apart from that, this has been a TODO item for me for some time. So
thanks for refreshing these, lets see if we can get them beat into
submission and agree on how it should work so we can take this forward.

-- 
Jens Axboe

