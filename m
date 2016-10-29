From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v5 06/14] blk-mq: Remove blk_mq_cancel_requeue_work()
Date: Fri, 28 Oct 2016 17:20:49 -0700
Message-ID: <7207b8ad-aec9-b7d8-e36b-8c360bf32f06@sandisk.com>
References: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Since blk_mq_requeue_work() no longer restarts stopped queues
canceling requeue work is no longer needed to prevent that a
stopped queue would be restarted. Hence remove this function.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
---
 block/blk-mq.c           | 6 ------
 drivers/md/dm-rq.c       | 2 --
 drivers/nvme/host/core.c | 1 -
 include/linux/blk-mq.h   | 1 -
 4 files changed, 10 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index fe367b5..534128a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -528,12 +528,6 @@ void blk_mq_add_to_requeue_list(struct request *rq, bool at_head)
 }
 EXPORT_SYMBOL(blk_mq_add_to_requeue_list);
 
-void blk_mq_cancel_requeue_work(struct request_queue *q)
-{
-	cancel_delayed_work_sync(&q->requeue_work);
-}
-EXPORT_SYMBOL_GPL(blk_mq_cancel_requeue_work);
-
 void blk_mq_kick_requeue_list(struct request_queue *q)
 {
 	kblockd_schedule_delayed_work(&q->requeue_work, 0);
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 1794de5..2b82496 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -116,8 +116,6 @@ static void dm_mq_stop_queue(struct request_queue *q)
 	queue_flag_set(QUEUE_FLAG_STOPPED, q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	/* Avoid that requeuing could restart the queue. */
-	blk_mq_cancel_requeue_work(q);
 	blk_mq_stop_hw_queues(q);
 }
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 79e679d..ab5f59e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2083,7 +2083,6 @@ void nvme_stop_queues(struct nvme_ctrl *ctrl)
 		queue_flag_set(QUEUE_FLAG_STOPPED, ns->queue);
 		spin_unlock_irq(ns->queue->queue_lock);
 
-		blk_mq_cancel_requeue_work(ns->queue);
 		blk_mq_stop_hw_queues(ns->queue);
 	}
 	mutex_unlock(&ctrl->namespaces_mutex);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index aa93000..a85a20f 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -217,7 +217,6 @@ void __blk_mq_end_request(struct request *rq, int error);
 
 void blk_mq_requeue_request(struct request *rq);
 void blk_mq_add_to_requeue_list(struct request *rq, bool at_head);
-void blk_mq_cancel_requeue_work(struct request_queue *q);
 void blk_mq_kick_requeue_list(struct request_queue *q);
 void blk_mq_delay_kick_requeue_list(struct request_queue *q, unsigned long msecs);
 void blk_mq_abort_requeue_list(struct request_queue *q);
-- 
2.10.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
