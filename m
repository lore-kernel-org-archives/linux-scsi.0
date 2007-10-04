From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] [PATCH 1/2] blk request timeout handler patches
Date: Thu, 4 Oct 2007 11:52:12 -0700
Message-ID: <20071004115212.bc6b2f4b.randy.dunlap@oracle.com>
References: <20071004181259.GA16689@us.ibm.com>
	<20071004181750.GB16689@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:36886 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313AbXJDSwS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Oct 2007 14:52:18 -0400
In-Reply-To: <20071004181750.GB16689@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: malahal@us.ibm.com
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Thu, 4 Oct 2007 11:17:50 -0700 malahal@us.ibm.com wrote:

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

Drop that blank line.

> +EXPORT_SYMBOL_GPL(blk_queue_rq_timed_out);
> +
>  /**
>   * blk_queue_make_request - define an alternate make_request function for a device
>   * @q:  the request queue for the device to be affected
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
> +

ditto.

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

s/req:/@req:/

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

drop blank line between closing } of function and the following
EXPORT_SYMBOL...

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

    */

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
> +        add_timer(&req->timer);
> +}
> +

drop blank line.  Please just check the rest of them.

> +EXPORT_SYMBOL_GPL(blk_add_timer);
> +
> +/**
>   * blk_complete_request - end I/O on a request
> - * @req:      the request being processed
> + * @req:	the request being processed
>   *
>   * Description:
>   *     Ends all I/O on a request. It does not handle partial completions,
> @@ -3657,25 +3786,24 @@ static struct notifier_block blk_cpu_not
>   *     through a softirq handler. The user must have registered a completion
>   *     callback through blk_queue_softirq_done().
>   **/

    */

> -
>  void blk_complete_request(struct request *req)
>  {


---
~Randy
