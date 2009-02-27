From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Use list_splice for blk_abort_queue
Date: Fri, 27 Feb 2009 12:40:57 +0100
Message-ID: <20090227114057.GC6602@kernel.dk>
References: <20090227113706.3005518C786@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:42614 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbZB0Lk7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 06:40:59 -0500
Content-Disposition: inline
In-Reply-To: <20090227113706.3005518C786@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Fri, Feb 27 2009, Hannes Reinecke wrote:
> 
> blk_abort_queue takes the queue_lock with spinlock_irqsave and walks
> the timer_list with list_for_each_entry_safe. Since a path to a SCSI
> device just failed, the rport state is FC_PORTSTATE_BLOCKED. This
> rport state triggers blk_add_timer(), which in turn calls
> list_add_tail() to move the request to the end of timer_list. Thus,
> the list_for_each_XXX loop never reaches the end of the timer_list.
> By using list_splice_init() we're breaking the loop and process only
> the requests present on the timeout_list when blk_abort_queue() is
> called.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Tested-by: Christof Schmitt <christof.schmitt@de.ibm.com>
> ---
>  block/blk-timeout.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/block/blk-timeout.c b/block/blk-timeout.c
> index a095353..67bcc3f 100644
> --- a/block/blk-timeout.c
> +++ b/block/blk-timeout.c
> @@ -209,12 +209,15 @@ void blk_abort_queue(struct request_queue *q)
>  {
>  	unsigned long flags;
>  	struct request *rq, *tmp;
> +	LIST_HEAD(list);
>  
>  	spin_lock_irqsave(q->queue_lock, flags);
>  
>  	elv_abort_queue(q);
>  
> -	list_for_each_entry_safe(rq, tmp, &q->timeout_list, timeout_list)
> +	list_splice_init(&q->timeout_list, &list);
> +
> +	list_for_each_entry_safe(rq, tmp, &list, timeout_list)
>  		blk_abort_request(rq);
>  
>  	spin_unlock_irqrestore(q->queue_lock, flags);
> -- 
> 1.5.3.2
> 

Hannes, this fix has been in mainline for about 10 days.

-- 
Jens Axboe

