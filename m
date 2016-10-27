From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/12] blk-mq: Add a kick_requeue_list argument to
 blk_mq_requeue_request()
Date: Thu, 27 Oct 2016 09:26:24 +0200
Message-ID: <1d22a183-2ef4-65be-f6a1-a008db75e85c@suse.de>
References: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
 <3944826d-bfde-f1e6-40ec-2c9a3c259e3a@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <3944826d-bfde-f1e6-40ec-2c9a3c259e3a@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lei <tom.leiming@gmail.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 10/27/2016 12:53 AM, Bart Van Assche wrote:
> Most blk_mq_requeue_request() and blk_mq_add_to_requeue_list() calls
> are followed by kicking the requeue list. Hence add an argument to
> these two functions that allows to kick the requeue list. This was
> proposed by Christoph Hellwig.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  block/blk-flush.c            |  5 +----
>  block/blk-mq.c               | 10 +++++++---
>  drivers/block/xen-blkfront.c |  2 +-
>  drivers/md/dm-rq.c           |  2 +-
>  drivers/nvme/host/core.c     |  2 +-
>  drivers/scsi/scsi_lib.c      |  4 +---
>  include/linux/blk-mq.h       |  5 +++--
>  7 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index 6a14b68..a834aed 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -134,10 +134,7 @@ static void blk_flush_restore_request(struct request *rq)
>  static bool blk_flush_queue_rq(struct request *rq, bool add_front)
>  {
>  	if (rq->q->mq_ops) {
> -		struct request_queue *q = rq->q;
> -
> -		blk_mq_add_to_requeue_list(rq, add_front);
> -		blk_mq_kick_requeue_list(q);
> +		blk_mq_add_to_requeue_list(rq, add_front, true);
>  		return false;
>  	} else {
>  		if (add_front)
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 4945437..688bcc3 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -492,12 +492,12 @@ static void __blk_mq_requeue_request(struct request *rq)
>  	}
>  }
>  
> -void blk_mq_requeue_request(struct request *rq)
> +void blk_mq_requeue_request(struct request *rq, bool kick_requeue_list)
>  {
>  	__blk_mq_requeue_request(rq);
>  
>  	BUG_ON(blk_queued_rq(rq));
> -	blk_mq_add_to_requeue_list(rq, true);
> +	blk_mq_add_to_requeue_list(rq, true, kick_requeue_list);
>  }
>  EXPORT_SYMBOL(blk_mq_requeue_request);
>  
> @@ -535,7 +535,8 @@ static void blk_mq_requeue_work(struct work_struct *work)
>  	blk_mq_start_hw_queues(q);
>  }
>  
> -void blk_mq_add_to_requeue_list(struct request *rq, bool at_head)
> +void blk_mq_add_to_requeue_list(struct request *rq, bool at_head,
> +				bool kick_requeue_list)
>  {
>  	struct request_queue *q = rq->q;
>  	unsigned long flags;
> @@ -554,6 +555,9 @@ void blk_mq_add_to_requeue_list(struct request *rq, bool at_head)
>  		list_add_tail(&rq->queuelist, &q->requeue_list);
>  	}
>  	spin_unlock_irqrestore(&q->requeue_lock, flags);
> +
> +	if (kick_requeue_list)
> +		blk_mq_kick_requeue_list(q);
>  }
>  EXPORT_SYMBOL(blk_mq_add_to_requeue_list);
>  
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 9908597..1ca702d 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -2043,7 +2043,7 @@ static int blkif_recover(struct blkfront_info *info)
>  		/* Requeue pending requests (flush or discard) */
>  		list_del_init(&req->queuelist);
>  		BUG_ON(req->nr_phys_segments > segs);
> -		blk_mq_requeue_request(req);
> +		blk_mq_requeue_request(req, false);
>  	}
>  	blk_mq_kick_requeue_list(info->rq);
>  
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index dc75bea..fbd37b4 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -354,7 +354,7 @@ EXPORT_SYMBOL(dm_mq_kick_requeue_list);
>  
>  static void dm_mq_delay_requeue_request(struct request *rq, unsigned long msecs)
>  {
> -	blk_mq_requeue_request(rq);
> +	blk_mq_requeue_request(rq, false);
>  	__dm_mq_kick_requeue_list(rq->q, msecs);
>  }
>  
Hmm. __dm_mq_kick_requeue_list() does essentially the same.
Have you checked if you can use 'true' here and drop the call to it?
However, it does take the queue_lock when doing so.
Is that required? None of the other drivers do it ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
