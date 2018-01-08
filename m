From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 1/4] blk-mq: Rename request_queue.mq_freeze_wq into mq_wq
Date: Mon,  8 Jan 2018 10:50:08 -0800
Message-ID: <20180108185011.30018-2-bart.vanassche@wdc.com>
References: <20180108185011.30018-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:60235 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755930AbeAHSuR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2018 13:50:17 -0500
In-Reply-To: <20180108185011.30018-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Ming Lei <ming.lei@redhat.com>

Rename a waitqueue in struct request_queue since the next patch will
add code that uses this waitqueue outside the request queue freezing
implementation.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       | 10 +++++-----
 block/blk-mq.c         | 10 +++++-----
 include/linux/blkdev.h |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 8f27ab14abce..605599a2ab3b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -375,7 +375,7 @@ void blk_clear_preempt_only(struct request_queue *q)
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	queue_flag_clear(QUEUE_FLAG_PREEMPT_ONLY, q);
-	wake_up_all(&q->mq_freeze_wq);
+	wake_up_all(&q->mq_wq);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 EXPORT_SYMBOL_GPL(blk_clear_preempt_only);
@@ -651,7 +651,7 @@ void blk_set_queue_dying(struct request_queue *q)
 	}
 
 	/* Make blk_queue_enter() reexamine the DYING flag. */
-	wake_up_all(&q->mq_freeze_wq);
+	wake_up_all(&q->mq_wq);
 }
 EXPORT_SYMBOL_GPL(blk_set_queue_dying);
 
@@ -854,7 +854,7 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 		 */
 		smp_rmb();
 
-		ret = wait_event_interruptible(q->mq_freeze_wq,
+		ret = wait_event_interruptible(q->mq_wq,
 				(atomic_read(&q->mq_freeze_depth) == 0 &&
 				 (preempt || !blk_queue_preempt_only(q))) ||
 				blk_queue_dying(q));
@@ -875,7 +875,7 @@ static void blk_queue_usage_counter_release(struct percpu_ref *ref)
 	struct request_queue *q =
 		container_of(ref, struct request_queue, q_usage_counter);
 
-	wake_up_all(&q->mq_freeze_wq);
+	wake_up_all(&q->mq_wq);
 }
 
 static void blk_rq_timed_out_timer(struct timer_list *t)
@@ -951,7 +951,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	q->bypass_depth = 1;
 	__set_bit(QUEUE_FLAG_BYPASS, &q->queue_flags);
 
-	init_waitqueue_head(&q->mq_freeze_wq);
+	init_waitqueue_head(&q->mq_wq);
 
 	/*
 	 * Init percpu_ref in atomic mode so that it's faster to shutdown.
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 21c21ca13072..8118890fb66f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -138,16 +138,16 @@ EXPORT_SYMBOL_GPL(blk_freeze_queue_start);
 
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
 
@@ -186,7 +186,7 @@ void blk_mq_unfreeze_queue(struct request_queue *q)
 	WARN_ON_ONCE(freeze_depth < 0);
 	if (!freeze_depth) {
 		percpu_ref_reinit(&q->q_usage_counter);
-		wake_up_all(&q->mq_freeze_wq);
+		wake_up_all(&q->mq_wq);
 	}
 }
 EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 742c0d9aed6b..26c4d4343edb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -613,7 +613,7 @@ struct request_queue {
 	struct throtl_data *td;
 #endif
 	struct rcu_head		rcu_head;
-	wait_queue_head_t	mq_freeze_wq;
+	wait_queue_head_t	mq_wq;
 	struct percpu_ref	q_usage_counter;
 	struct list_head	all_q_node;
 
-- 
2.15.1
