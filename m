From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/4] Make blk_cleanup_queue() wait until request_fn
 finished
Date: Tue, 16 Oct 2012 16:51:52 -0700
Message-ID: <20121016235152.GL16166@google.com>
References: <50758EBE.7050202@acm.org>
 <50758F90.4020407@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52813 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab2JPXv4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2012 19:51:56 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so6486337pbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 16 Oct 2012 16:51:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <50758F90.4020407@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

Hello,

On Wed, Oct 10, 2012 at 05:09:04PM +0200, Bart Van Assche wrote:
> Some request_fn implementations, e.g. scsi_request_fn(), unlock
> the queue lock. Make sure that blk_cleanup_queue() waits until all
> active request_fn invocations have finished. This fixes a potential
> use-after-free at the end of scsi_request_fn(). Also, change the
> type of the 'drain' variable from bool to int to avoid that the
> highest bits of the request counters get ignored.

Similar comment.  It would be great if you better separate what's
broken and how it's fixed.  Kinda difficult to digest.

> @@ -308,7 +308,9 @@ void __blk_run_queue_uncond(struct request_queue *q)
>  	if (unlikely(blk_queue_dead(q)))
>  		return;
>  
> +	q->driver_active++;
>  	q->request_fn(q);
> +	q->driver_active--;

Maybe q->request_fn_active is a better name?

> -void blk_drain_queue(struct request_queue *q, bool drain_all)
> +static void blk_drain_queue(struct request_queue *q, bool drain_all)
>  {
>  	int i;
>  
>  	while (true) {
> -		bool drain = false;
> +		int drain = 0;

I don't think this is necessary.  bool conversion works fine
regardless how high the bits are.  Isn't avoiding signed/unsigned
autocast maze one of the reasons why we're using bool to begin with?

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f29a1a9..0e15374 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1517,10 +1517,6 @@ static void scsi_request_fn(struct request_queue *q)
>  	struct scsi_cmnd *cmd;
>  	struct request *req;
>  
> -	if(!get_device(&sdev->sdev_gendev))
> -		/* We must be tearing the block queue down already */
> -		return;
> -
>  	/*
>  	 * To start with, we keep looping until the queue is empty, or until
>  	 * the host is no longer able to accept any more requests.
> @@ -1629,11 +1625,7 @@ out_delay:
>  	if (sdev->device_busy == 0)
>  		blk_delay_queue(q, SCSI_QUEUE_DELAY);
>  out:
> -	/* must be careful here...if we trigger the ->remove() function
> -	 * we cannot be holding the q lock */
> -	spin_unlock_irq(q->queue_lock);
> -	put_device(&sdev->sdev_gendev);
> -	spin_lock_irq(q->queue_lock);
> +	;

I think moving this out to a separate patch would be better.

Thanks.

-- 
tejun
