From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 6/9] block: Rename mq_freeze_wq and mq_freeze_depth
Date: Mon, 26 Sep 2016 11:28:08 -0700
Message-ID: <129b2a52-1ff7-7048-dfa3-89416ea42dd2@sandisk.com>
References: <7948dbb8-6333-dc62-2673-4da35b4dfdbc@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <7948dbb8-6333-dc62-2673-4da35b4dfdbc@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

Since these two structure members are now used in blk-mq and !blk-mq
paths, remove the mq_prefix. This patch does not change any
functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 block/blk-core.c       | 20 ++++++++++----------
 block/blk-mq.c         |  4 ++--
 include/linux/blkdev.h |  4 ++--
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5ecc7ab..0ff5d57 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -659,9 +659,9 @@ int blk_queue_enter(struct request_queue *q, bool nowait)
 		if (nowait)
 			return -EBUSY;
 
-		ret = wait_event_interruptible(q->mq_freeze_wq,
-				!atomic_read(&q->mq_freeze_depth) ||
-				blk_queue_dying(q));
+		ret = wait_event_interruptible(q->freeze_wq,
+					       !atomic_read(&q->freeze_depth) ||
+					       blk_queue_dying(q));
 		if (blk_queue_dying(q))
 			return -ENODEV;
 		if (ret)
@@ -679,14 +679,14 @@ static void blk_queue_usage_counter_release(struct percpu_ref *ref)
 	struct request_queue *q =
 		container_of(ref, struct request_queue, q_usage_counter);
 
-	wake_up_all(&q->mq_freeze_wq);
+	wake_up_all(&q->freeze_wq);
 }
 
 void blk_freeze_queue_start(struct request_queue *q)
 {
 	int freeze_depth;
 
-	freeze_depth = atomic_inc_return(&q->mq_freeze_depth);
+	freeze_depth = atomic_inc_return(&q->freeze_depth);
 	if (freeze_depth == 1) {
 		percpu_ref_kill(&q->q_usage_counter);
 		if (q->mq_ops)
@@ -698,12 +698,12 @@ void blk_freeze_queue_start(struct request_queue *q)
 
 void blk_freeze_queue_wait(struct request_queue *q)
 {
-	wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->q_usage_counter));
+	wait_event(q->freeze_wq, percpu_ref_is_zero(&q->q_usage_counter));
 }
 
 /*
  * Guarantee no request is in use, so we can change any data structure of
- * the queue afterward. Increases q->mq_freeze_depth and waits until
+ * the queue afterward. Increases q->freeze_depth and waits until
  * q->q_usage_counter drops to zero.
  */
 void blk_freeze_queue(struct request_queue *q)
@@ -716,11 +716,11 @@ void blk_unfreeze_queue(struct request_queue *q)
 {
 	int freeze_depth;
 
-	freeze_depth = atomic_dec_return(&q->mq_freeze_depth);
+	freeze_depth = atomic_dec_return(&q->freeze_depth);
 	WARN_ON_ONCE(freeze_depth < 0);
 	if (!freeze_depth) {
 		percpu_ref_reinit(&q->q_usage_counter);
-		wake_up_all(&q->mq_freeze_wq);
+		wake_up_all(&q->freeze_wq);
 	}
 }
 
@@ -790,7 +790,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	q->bypass_depth = 1;
 	__set_bit(QUEUE_FLAG_BYPASS, &q->queue_flags);
 
-	init_waitqueue_head(&q->mq_freeze_wq);
+	init_waitqueue_head(&q->freeze_wq);
 
 	/*
 	 * Init percpu_ref in atomic mode so that it's faster to shutdown.
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 50b26df..e17a5bf 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -94,7 +94,7 @@ void blk_mq_wake_waiters(struct request_queue *q)
 	 * dying, we need to ensure that processes currently waiting on
 	 * the queue are notified as well.
 	 */
-	wake_up_all(&q->mq_freeze_wq);
+	wake_up_all(&q->freeze_wq);
 }
 
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *hctx)
@@ -2071,7 +2071,7 @@ void blk_mq_free_queue(struct request_queue *q)
 static void blk_mq_queue_reinit(struct request_queue *q,
 				const struct cpumask *online_mask)
 {
-	WARN_ON_ONCE(!atomic_read(&q->mq_freeze_depth));
+	WARN_ON_ONCE(!atomic_read(&q->freeze_depth));
 
 	blk_mq_sysfs_unregister(q);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c47c358..f08dc65 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -454,7 +454,7 @@ struct request_queue {
 	struct mutex		sysfs_lock;
 
 	int			bypass_depth;
-	atomic_t		mq_freeze_depth;
+	atomic_t		freeze_depth;
 
 #if defined(CONFIG_BLK_DEV_BSG)
 	bsg_job_fn		*bsg_job_fn;
@@ -467,7 +467,7 @@ struct request_queue {
 	struct throtl_data *td;
 #endif
 	struct rcu_head		rcu_head;
-	wait_queue_head_t	mq_freeze_wq;
+	wait_queue_head_t	freeze_wq;
 	struct percpu_ref	q_usage_counter;
 	struct list_head	all_q_node;
 
-- 
2.10.0

