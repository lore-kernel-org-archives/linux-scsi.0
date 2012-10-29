From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/7] block: Avoid that request_fn is invoked on a dead
 queue
Date: Sun, 28 Oct 2012 18:59:11 -0700
Message-ID: <20121029015911.GF5171@htj.dyndns.org>
References: <508A7B63.60608@acm.org>
 <508A7C21.90505@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37322 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab2J2B7V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Oct 2012 21:59:21 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3908999pbb.19
        for <linux-scsi@vger.kernel.org>; Sun, 28 Oct 2012 18:59:21 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <508A7C21.90505@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

Hello,

On Fri, Oct 26, 2012 at 02:03:45PM +0200, Bart Van Assche wrote:
> A block driver may start cleaning up resources needed by its
> request_fn as soon as blk_cleanup_queue() finished, so request_fn
> must not be invoked after draining finished.

Please be a lot more detailed.  Please describe an example scenario
where things go wrong, explain why that's happening and how it's
fixed.

> +void inline __blk_run_queue_uncond(struct request_queue *q)
> +{
> +	if (unlikely(blk_queue_dead(q)))
> +		return;
> +
> +	q->request_fn(q);
> +}
...
> @@ -510,6 +529,7 @@ void blk_cleanup_queue(struct request_queue *q)
>  	/* drain all requests queued before DYING marking */
>  	spin_lock_irq(lock);
>  	__blk_drain_queue(q, true);
> +	queue_flag_set(QUEUE_FLAG_DEAD, q);
>  	spin_unlock_irq(lock);

And some comments explaining what the dead thing is doing would be
nice too; other than that, looks good to me.

Thanks!

-- 
tejun
