From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/12] dm: Use BLK_MQ_S_STOPPED instead of
 QUEUE_FLAG_STOPPED in blk-mq code
Date: Thu, 27 Oct 2016 09:27:16 +0200
Message-ID: <61253bf4-1478-3cfb-7954-1d29997fedd9@suse.de>
References: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
 <a0733adf-065e-2099-3850-cb1c55df1e35@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50541 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934595AbcJ0H1S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Oct 2016 03:27:18 -0400
In-Reply-To: <a0733adf-065e-2099-3850-cb1c55df1e35@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lei <tom.leiming@gmail.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

On 10/27/2016 12:54 AM, Bart Van Assche wrote:
> Instead of manipulating both QUEUE_FLAG_STOPPED and BLK_MQ_S_STOPPED
> in the dm start and stop queue functions, only manipulate the latter
> flag. Change blk_queue_stopped() tests into blk_mq_queue_stopped().
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-rq.c | 18 ++----------------
>  1 file changed, 2 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index fbd37b4..d47a504 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -75,12 +75,6 @@ static void dm_old_start_queue(struct request_queue *q)
>  
>  static void dm_mq_start_queue(struct request_queue *q)
>  {
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(q->queue_lock, flags);
> -	queue_flag_clear(QUEUE_FLAG_STOPPED, q);
> -	spin_unlock_irqrestore(q->queue_lock, flags);
> -
>  	blk_mq_start_stopped_hw_queues(q, true);
>  	blk_mq_kick_requeue_list(q);
>  }
> @@ -105,16 +99,8 @@ static void dm_old_stop_queue(struct request_queue *q)
>  
>  static void dm_mq_stop_queue(struct request_queue *q)
>  {
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(q->queue_lock, flags);
> -	if (blk_queue_stopped(q)) {
> -		spin_unlock_irqrestore(q->queue_lock, flags);
> +	if (blk_mq_queue_stopped(q))
>  		return;
> -	}
> -
> -	queue_flag_set(QUEUE_FLAG_STOPPED, q);
> -	spin_unlock_irqrestore(q->queue_lock, flags);
>  
>  	/* Avoid that requeuing could restart the queue. */
>  	blk_mq_cancel_requeue_work(q);
> @@ -341,7 +327,7 @@ static void __dm_mq_kick_requeue_list(struct request_queue *q, unsigned long mse
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(q->queue_lock, flags);
> -	if (!blk_queue_stopped(q))
> +	if (!blk_mq_queue_stopped(q))
>  		blk_mq_delay_kick_requeue_list(q, msecs);
>  	spin_unlock_irqrestore(q->queue_lock, flags);
>  }
> 
Ah. Right. That answers my previous question.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
