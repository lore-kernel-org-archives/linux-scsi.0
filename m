From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: 16 Jul 2003 15:45:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058395517.2890.1.camel@markh1.pdx.osdl.net>
References: <1058310172.981.7.camel@markh1.pdx.osdl.net>
	 <1058359278.1856.8.camel@mulgrave> <20030716124549.GX833@suse.de>
	 <1058360162.1850.15.camel@mulgrave>  <20030716132036.GB833@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:1720 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S271161AbTGPWag (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2003 18:30:36 -0400
In-Reply-To: <20030716132036.GB833@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Nick Piggin <piggin@cyberone.com.au>, Andrew Morton <akpm@osdl.org>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2003-07-16 at 06:20, Jens Axboe wrote:
> On Wed, Jul 16 2003, James Bottomley wrote:
> > > SCSI does it right, don't worry. It's a block layer problem that we need
> > > to find out how to correctly make sure that we deal it. Basically
> > > elv_next_request() does an implicit elv_started_request(), at least that
> > > is what AS assumes. So request re-adds should notify the scheduler of
> > > that fact.
> > 
> > What about exporting a more generic requeue function (perhaps one that
> > would take care of ending the tag)?
> > 
> > Our current requeue code looks like
> > 
> > 	if (blk_rq_tagged(req))
> > 		blk_queue_end_tag(q, req);
> > 	__elv_add_request(q, req, 0, 0);
> > 
> > which looks slightly fragile given that we have to remember to end the
> > tag and then call a __ function (which are usually private).
> 
> Not usually private, but lockless.
> 
> > If we called an explicit request requeue hook, schedulers that need to
> > adjust for requeueing would have a single place they could plug into?
> 
> blk_insert_request() is close, but it does a little more (it's useful
> another place in the scsi queueing, though). How about something like
> this? Then I can add the 'back on queue but not completed' stuff after
> that.
> 
> ===== drivers/block/ll_rw_blk.c 1.192 vs edited =====
> --- 1.192/drivers/block/ll_rw_blk.c	Sun Jul 13 14:15:43 2003
> +++ edited/drivers/block/ll_rw_blk.c	Wed Jul 16 15:17:23 2003
> @@ -1494,6 +1494,23 @@
>  
>  	return rq;
>  }
> +/**
> + * blk_requeue_request - put a request back on queue
> + * @q:		request queue where request should be inserted
> + * @rq:		request to be inserted
> + *
> + * Description:
> + *    Drivers often keep queueing requests until the hardware cannot accept
> + *    more, when that condition happens we need to put the request back
> + *    on the queue. Must be called with queue lock held.
> + */
> +void blk_requeue_request(request_queue_t *q, struct request *rq)
> +{
> +	if (blk_rq_tagged(rq))
> +		blk_queue_end_tag(q, rq);
> +
> +	__elv_add_request(q, rq, 0, 0);
> +}
>  
>  /**
>   * blk_insert_request - insert a special request in to a request queue
> ===== drivers/scsi/scsi_lib.c 1.99 vs edited =====
> --- 1.99/drivers/scsi/scsi_lib.c	Mon Jun 30 03:14:44 2003
> +++ edited/drivers/scsi/scsi_lib.c	Wed Jul 16 15:17:52 2003
> @@ -444,22 +444,8 @@
>   */
>  static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
>  {
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(q->queue_lock, flags);
> -	cmd->request->special = cmd;
> -	if (blk_rq_tagged(cmd->request))
> -		blk_queue_end_tag(q, cmd->request);
> -
> -	/*
> -	 * set REQ_SPECIAL - we have a command
> -	 * clear REQ_DONTPREP - we assume the sg table has been 
> -	 *	nuked so we need to set it up again.
> -	 */
> -	cmd->request->flags |= REQ_SPECIAL;
>  	cmd->request->flags &= ~REQ_DONTPREP;
> -	__elv_add_request(q, cmd->request, 0, 0);
> -	spin_unlock_irqrestore(q->queue_lock, flags);
> +	blk_insert_request(cmd->request, 1, cmd);

blk_insert_request should have the q pointer as the first arg shouldn't
it?

Mark.


>  
>  	scsi_run_queue(q);
>  }
> @@ -1213,9 +1199,7 @@
>  	 * later time.
>  	 */
>  	spin_lock_irq(q->queue_lock);
> -	if (blk_rq_tagged(req))
> -		blk_queue_end_tag(q, req);
> -	__elv_add_request(q, req, 0, 0);
> +	blk_requeue_request(q, req);
>  	sdev->device_busy--;
>  	if(sdev->device_busy == 0)
>  		blk_plug_device(q);
> ===== include/linux/blkdev.h 1.116 vs edited =====
> --- 1.116/include/linux/blkdev.h	Sat Jul  5 08:52:51 2003
> +++ edited/include/linux/blkdev.h	Wed Jul 16 15:18:06 2003
> @@ -491,6 +491,7 @@
>  extern struct request *blk_get_request(request_queue_t *, int, int);
>  extern void blk_put_request(struct request *);
>  extern void blk_insert_request(request_queue_t *, struct request *, int, void *);
> +extern void blk_requeue_request(request_queue_t *, struct request *);
>  extern void blk_plug_device(request_queue_t *);
>  extern int blk_remove_plug(request_queue_t *);
>  extern void blk_recount_segments(request_queue_t *, struct bio *);
-- 
Mark Haverkamp <markh@osdl.org>

