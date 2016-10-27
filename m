From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 05/12] blk-mq: Introduce blk_mq_quiesce_queue()
Date: Thu, 27 Oct 2016 07:52:41 +0200
Message-ID: <f1661bd2-12ca-20d1-ece2-5c7fe5987035@suse.de>
References: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
 <5143c240-39af-9fe2-d3e6-ed69f9c20531@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5143c240-39af-9fe2-d3e6-ed69f9c20531-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/27/2016 12:53 AM, Bart Van Assche wrote:
> blk_mq_quiesce_queue() waits until ongoing .queue_rq() invocations
> have finished. This function does *not* wait until all outstanding
> requests have finished (this means invocation of request.end_io()).
> The algorithm used by blk_mq_quiesce_queue() is as follows:
> * Hold either an RCU read lock or an SRCU read lock around
>   .queue_rq() calls. The former is used if .queue_rq() does not
>   block and the latter if .queue_rq() may block.
> * blk_mq_quiesce_queue() calls synchronize_srcu() or
>   synchronize_rcu() to wait for .queue_rq() invocations that
>   started before blk_mq_quiesce_queue() was called.
> * The blk_mq_hctx_stopped() calls that control whether or not
>   .queue_rq() will be called are called with the (S)RCU read lock
>   held. This is necessary to avoid race conditions against
>   the "blk_mq_stop_hw_queues(q); blk_mq_quiesce_queue(q);"
>   sequence from another thread.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
> Cc: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
> ---
>  block/Kconfig          |  1 +
>  block/blk-mq.c         | 69 +++++++++++++++++++++++++++++++++++++++++++++-----
>  include/linux/blk-mq.h |  3 +++
>  include/linux/blkdev.h |  1 +
>  4 files changed, 67 insertions(+), 7 deletions(-)
> 
Hmm. Can't say I like having to have two RCU structure for the same
purpose, but I guess that can't be helped.

Reviewed-by: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare-l3A5Bk7waGM@public.gmane.org			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
