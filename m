From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] block: optimizations in blk_rq_timed_out_timer()
Date: Wed, 29 Oct 2008 13:07:05 +0900
Message-ID: <20081029130656G.fujita.tomonori@lab.ntt.co.jp>
References: <20081028182243.GA6716@us.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:36055 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbYJ2EHP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2008 00:07:15 -0400
In-Reply-To: <20081028182243.GA6716@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: malahal@us.ibm.com
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Tue, 28 Oct 2008 11:22:43 -0700
malahal@us.ibm.com wrote:

> Now the rq->deadline can't be zero if the request is in the
> timeout_list, so there is no need to have next_set. There is no need to
> access a request's deadline field if blk_rq_timed_out is called on it.
> 
> Signed-off-by: Malahal Naineni <malahal@us.ibm.com>
> 
> diff -r a6ae42397ede block/blk-timeout.c
> --- a/block/blk-timeout.c	Thu Oct 23 11:48:45 2008 -0700
> +++ b/block/blk-timeout.c	Fri Oct 24 17:08:24 2008 -0700
> @@ -118,7 +118,7 @@
>  void blk_rq_timed_out_timer(unsigned long data)
>  {
>  	struct request_queue *q = (struct request_queue *) data;
> -	unsigned long flags, uninitialized_var(next), next_set = 0;
> +	unsigned long flags, next = 0;
>  	struct request *rq, *tmp;
>  
>  	spin_lock_irqsave(q->queue_lock, flags);
> @@ -133,15 +133,13 @@
>  			if (blk_mark_rq_complete(rq))
>  				continue;
>  			blk_rq_timed_out(rq);
> +		} else {
> +			if (!next || time_after(next, rq->deadline))
> +				next = rq->deadline;

Hmm, blk_rq_timed_out(rq) could put the rq back to q->timeout_list. We
need to take care of the rq->deadline like this?

>  			if (blk_mark_rq_complete(rq))
>  				continue;
>  			blk_rq_timed_out(rq);
> +		}
>
> +		if (!next || time_after(next, rq->deadline))
> +			next = rq->deadline;

But if blk_rq_timed_out calls __blk_complete_request, we don't want to
touch the rq here, I guess.


>  		}
> -		if (!next_set) {
> -			next = rq->deadline;
> -			next_set = 1;
> -		} else if (time_after(next, rq->deadline))
> -			next = rq->deadline;
>  	}
>  
> -	if (next_set && !list_empty(&q->timeout_list))
> +	if (next)
>  		mod_timer(&q->timeout, round_jiffies(next));
>  
>  	spin_unlock_irqrestore(q->queue_lock, flags);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
