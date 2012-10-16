From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/4] block: Avoid that request_fn is invoked on a dead
 queue
Date: Tue, 16 Oct 2012 16:38:29 -0700
Message-ID: <20121016233829.GK16166@google.com>
References: <50758EBE.7050202@acm.org>
 <50758F51.3020601@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44856 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab2JPXie (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2012 19:38:34 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so6411009pad.19
        for <linux-scsi@vger.kernel.org>; Tue, 16 Oct 2012 16:38:34 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <50758F51.3020601@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

Hello,

On Wed, Oct 10, 2012 at 05:08:01PM +0200, Bart Van Assche wrote:
> A block driver may start cleaning up resources needed by its
> request_fn as soon as blk_cleanup_queue() finished, so request_fn
> must not be invoked after draining finished.

Can you please make the commit message more verbose preferably with
example crash trace?  It's difficult to tell what bug it's trying to
fix how.

>  /**
> + * __blk_run_queue_uncond - run a queue whether or not it has been stopped
> + * @q:	The queue to run
> + *
> + * Description:
> + *    Invoke request handling on a queue if there are any pending requests.
> + *    May be used to restart request handling after a request has completed.
> + *    This variant runs the queue whether or not the queue has been
> + *    stopped. Must be called with the queue lock held and interrupts
> + *    disabled. See also @blk_run_queue.
> + */
> +void __blk_run_queue_uncond(struct request_queue *q)
> +{
> +	if (unlikely(blk_queue_dead(q)))
> +		return;
> +
> +	q->request_fn(q);
> +}
> +
> +/**
>   * __blk_run_queue - run a single device queue
>   * @q:	The queue to run
>   *
> @@ -305,7 +324,7 @@ void __blk_run_queue(struct request_queue *q)
>  	if (unlikely(blk_queue_stopped(q)))
>  		return;
>  
> -	q->request_fn(q);
> +	__blk_run_queue_uncond(q);

__blk_run_queue_uncond() is a cold path and I don't think adding a
test there matters but I think it would be better if we avoid an extra
branch if possible for __blk_run_queue().  Can't we merge
blk_queue_stopped/dead() testing?

> @@ -401,6 +420,9 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
>  			}
>  		}
>  
> +		if (!drain && blk_queue_dying(q))
> +			queue_flag_set(QUEUE_FLAG_DEAD, q);
> +

Wouldn't doing this in blk_cleanup_queue() be better?  It may involve
an extra queue locking but I don't think that matter at all in that
path and doing things where they belong is far more important.

Thanks.

-- 
tejun
