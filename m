From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v5 05/14] blk-mq: Avoid that requeueing starts stopped queues
Date: Fri, 28 Oct 2016 17:20:32 -0700
Message-ID: <8d5b97cb-429a-e451-ad2e-ad63a3f94dfd@sandisk.com>
References: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Since blk_mq_requeue_work() starts stopped queues and since
execution of this function can be scheduled after a queue has
been stopped it is not possible to stop queues without using
an additional state variable to track whether or not the queue
has been stopped. Hence modify blk_mq_requeue_work() such that it
does not start stopped queues. My conclusion after a review of
the blk_mq_stop_hw_queues() and blk_mq_{delay_,}kick_requeue_list()
callers is as follows:
* In the dm driver starting and stopping queues should only happen
  if __dm_suspend() or __dm_resume() is called and not if the
  requeue list is processed.
* In the SCSI core queue stopping and starting should only be
  performed by the scsi_internal_device_block() and
  scsi_internal_device_unblock() functions but not by any other
  function. Although the blk_mq_stop_hw_queue() call in
  scsi_queue_rq() may help to reduce CPU load if a LLD queue is
  full, figuring out whether or not a queue should be restarted
  when requeueing a command would require to introduce additional
  locking in scsi_mq_requeue_cmd() to avoid a race with
  scsi_internal_device_block(). Avoid this complexity by removing
  the blk_mq_stop_hw_queue() call from scsi_queue_rq().
* In the NVMe core only the functions that call
  blk_mq_start_stopped_hw_queues() explicitly should start stopped
  queues.
* A blk_mq_start_stopped_hwqueues() call must be added in the
  xen-blkfront driver in its blkif_recover() function.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Roger Pau Monné <roger.pau-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 block/blk-mq.c               | 6 +-----
 drivers/block/xen-blkfront.c | 1 +
 drivers/md/dm-rq.c           | 7 +------
 drivers/scsi/scsi_lib.c      | 1 -
 4 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c8ae970..fe367b5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -503,11 +503,7 @@ static void blk_mq_requeue_work(struct work_struct *work)
 		blk_mq_insert_request(rq, false, false, false);
 	}
 
-	/*
-	 * Use the start variant of queue running here, so that running
-	 * the requeue work will kick stopped queues.
-	 */
-	blk_mq_start_hw_queues(q);
+	blk_mq_run_hw_queues(q, false);
 }
 
 void blk_mq_add_to_requeue_list(struct request *rq, bool at_head)
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 9908597..60fff99 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2045,6 +2045,7 @@ static int blkif_recover(struct blkfront_info *info)
 		BUG_ON(req->nr_phys_segments > segs);
 		blk_mq_requeue_request(req);
 	}
+	blk_mq_start_stopped_hwqueues(info->rq);
 	blk_mq_kick_requeue_list(info->rq);
 
 	while ((bio = bio_list_pop(&info->bio_list)) != NULL) {
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 1d0d2ad..1794de5 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -338,12 +338,7 @@ static void dm_old_requeue_request(struct request *rq)
 
 static void __dm_mq_kick_requeue_list(struct request_queue *q, unsigned long msecs)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	if (!blk_queue_stopped(q))
-		blk_mq_delay_kick_requeue_list(q, msecs);
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	blk_mq_delay_kick_requeue_list(q, msecs);
 }
 
 void dm_mq_kick_requeue_list(struct mapped_device *md)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2cca9cf..126a784 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1941,7 +1941,6 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 out:
 	switch (ret) {
 	case BLK_MQ_RQ_QUEUE_BUSY:
-		blk_mq_stop_hw_queue(hctx);
 		if (atomic_read(&sdev->device_busy) == 0 &&
 		    !scsi_device_blocked(sdev))
 			blk_mq_delay_queue(hctx, SCSI_QUEUE_DELAY);
-- 
2.10.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
