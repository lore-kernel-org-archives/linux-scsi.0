From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 1/4] blk-mq: Rename request_queue.mq_freeze_wq into mq_wq
Date: Wed, 10 Jan 2018 10:18:14 -0800
Message-ID: <20180110181817.25166-2-bart.vanassche@wdc.com>
References: <20180110181817.25166-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180110181817.25166-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Rename a waitqueue in struct request_queue since the next patch will
add code that uses this waitqueue outside the request queue freezing
implementation.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Reviewed-by: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Cc: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/blk-core.c       | 10 +++++-----
 block/blk-mq.c         | 10 +++++-----
 include/linux/blkdev.h |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fa1cb95f7f6a..c10b4ce95248 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -377,7 +377,7 @@ void blk_clear_preempt_only(struct request_queue *q)
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	queue_flag_clear(QUEUE_FLAG_PREEMPT_ONLY, q);
-	wake_up_all(&q->mq_freeze_wq);
+	wake_up_all(&q->mq_wq);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 EXPORT_SYMBOL_GPL(blk_clear_preempt_only);
@@ -648,7 +648,7 @@ void blk_set_queue_dying(struct request_queue *q)
 	}
 
 	/* Make blk_queue_enter() reexamine the DYING flag. */
-	wake_up_all(&q->mq_freeze_wq);
+	wake_up_all(&q->mq_wq);
 }
 EXPORT_SYMBOL_GPL(blk_set_queue_dying);
 
@@ -851,7 +851,7 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 		 */
 		smp_rmb();
 
-		ret = wait_event_interruptible(q->mq_freeze_wq,
+		ret = wait_event_interruptible(q->mq_wq,
 				(atomic_read(&q->mq_freeze_depth) == 0 &&
 				 (preempt || !blk_queue_preempt_only(q))) ||
 				blk_queue_dying(q));
@@ -872,7 +872,7 @@ static void blk_queue_usage_counter_release(struct percpu_ref *ref)
 	struct request_queue *q =
 		container_of(ref, struct request_queue, q_usage_counter);
 
-	wake_up_all(&q->mq_freeze_wq);
+	wake_up_all(&q->mq_wq);
 }
 
 static void blk_rq_timed_out_timer(struct timer_list *t)
@@ -948,7 +948,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	q->bypass_depth = 1;
 	__set_bit(QUEUE_FLAG_BYPASS, &q->queue_flags);
 
-	init_waitqueue_head(&q->mq_freeze_wq);
+	init_waitqueue_head(&q->mq_wq);
 
 	/*
 	 * Init percpu_ref in atomic mode so that it's faster to shutdown.
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 29f140b4dbf7..a05ea7e9b415 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -137,16 +137,16 @@ EXPORT_SYMBOL_GPL(blk_freeze_queue_start);
 
 void blk_mq_freeze_queue_wait(struct request_queue *q)
 {
-	wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->q_usage_counter));
+	wait_event(q->mq_wq, percpu_ref_is_zero(&q->q_usage_counter));
 }
 EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_wait);
 
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 				     unsigned long timeout)
 {
-	return wait_event_timeout(q->mq_freeze_wq,
-					percpu_ref_is_zero(&q->q_usage_counter),
-					timeout);
+	return wait_event_timeout(q->mq_wq,
+				  percpu_ref_is_zero(&q->q_usage_counter),
+				  timeout);
 }
 EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_wait_timeout);
 
@@ -185,7 +185,7 @@ void blk_mq_unfreeze_queue(struct request_queue *q)
 	WARN_ON_ONCE(freeze_depth < 0);
 	if (!freeze_depth) {
 		percpu_ref_reinit(&q->q_usage_counter);
-		wake_up_all(&q->mq_freeze_wq);
+		wake_up_all(&q->mq_wq);
 	}
 }
 EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 50fb1c18ec54..2c74c03a9d5f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -638,7 +638,7 @@ struct request_queue {
 	struct throtl_data *td;
 #endif
 	struct rcu_head		rcu_head;
-	wait_queue_head_t	mq_freeze_wq;
+	wait_queue_head_t	mq_wq;
 	struct percpu_ref	q_usage_counter;
 	struct list_head	all_q_node;
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
