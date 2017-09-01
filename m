From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 7/8] block: introduce preempt version of blk_[freeze|unfreeze]_queue
Date: Sat,  2 Sep 2017 02:49:57 +0800
Message-ID: <20170901184958.19452-9-ming.lei@redhat.com>
References: <20170901184958.19452-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170901184958.19452-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Tejun Heo <tj@kernel.org>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

The two APIs are required to allow request allocation for
RQF_PREEMPT when queue is frozen.

The following two points have to be guaranteed for one queue:

1) preempt freezing can be started only after all pending
normal & preempt freezing are completed

2) normal freezing can't be started if there is pending
preempt freezing.

Because for normal freezing, once blk_mq_freeze_queue_wait()
is returned, we have to make sure no I/Os are pending.

rwsem should have been perfect for this kind of sync,
but lockdep will complain in case of nested normal freeze.

So spin_lock with freezing status is used for the sync.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       |  2 ++
 block/blk-mq.c         | 72 +++++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/blk-mq.h |  2 ++
 include/linux/blkdev.h |  3 +++
 4 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c199910d4fe1..bbcea07f17da 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -899,6 +899,8 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (blkcg_init_queue(q))
 		goto fail_ref;
 
+	spin_lock_init(&q->freeze_lock);
+
 	return q;
 
 fail_ref:
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 695d2eeaf41a..bf8c057aa50f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -118,16 +118,48 @@ void blk_mq_in_flight(struct request_queue *q, struct hd_struct *part,
 	blk_mq_queue_tag_busy_iter(q, blk_mq_check_inflight, &mi);
 }
 
-void blk_freeze_queue_start(struct request_queue *q)
+static void __blk_freeze_queue_start(struct request_queue *q, bool preempt)
 {
 	int freeze_depth;
 
+	/*
+	 * Wait for completion of another kind of freezing.
+	 *
+	 * We have to sync between normal freeze and preempt
+	 * freeze. preempt freeze can only be started iff all
+	 * pending normal & preempt freezing are completed,
+	 * meantime normal freeze can be started only if there
+	 * isn't pending preempt freezing.
+	 *
+	 * rwsem should have been perfect for this kind of sync,
+	 * but lockdep will complain in case of nested normal freeze.
+	 *
+	 * So we have to use lock to do that manually.
+	 */
+	spin_lock(&q->freeze_lock);
+	wait_event_cmd(q->mq_freeze_wq,
+		       preempt ? !(q->normal_freezing + q->preempt_freezing) : !q->preempt_freezing,
+		       spin_unlock(&q->freeze_lock),
+		       spin_lock(&q->freeze_lock));
+
 	freeze_depth = atomic_inc_return(&q->mq_freeze_depth);
 	if (freeze_depth == 1) {
+		if (preempt)
+			q->preempt_freezing = 1;
+		else
+			q->normal_freezing = 1;
+		spin_unlock(&q->freeze_lock);
+
 		percpu_ref_kill(&q->q_usage_counter);
 		if (q->mq_ops)
 			blk_mq_run_hw_queues(q, false);
-	}
+	} else
+		spin_unlock(&q->freeze_lock);
+}
+
+void blk_freeze_queue_start(struct request_queue *q)
+{
+	__blk_freeze_queue_start(q, false);
 }
 EXPORT_SYMBOL_GPL(blk_freeze_queue_start);
 
@@ -166,20 +198,54 @@ void blk_freeze_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_freeze_queue);
 
-void blk_unfreeze_queue(struct request_queue *q)
+static void __blk_unfreeze_queue(struct request_queue *q, bool preempt)
 {
 	int freeze_depth;
 
 	freeze_depth = atomic_dec_return(&q->mq_freeze_depth);
 	WARN_ON_ONCE(freeze_depth < 0);
 	if (!freeze_depth) {
+		spin_lock(&q->freeze_lock);
+		if (preempt)
+			q->preempt_freezing = 0;
+		else
+			q->normal_freezing = 0;
+		spin_unlock(&q->freeze_lock);
 		percpu_ref_reinit(&q->q_usage_counter);
 		wake_up_all(&q->mq_freeze_wq);
 	}
 }
+
+void blk_unfreeze_queue(struct request_queue *q)
+{
+	__blk_unfreeze_queue(q, false);
+}
 EXPORT_SYMBOL_GPL(blk_unfreeze_queue);
 
 /*
+ * Once this function is returned, only allow to get request
+ * for preempt purpose, such as RQF_PREEMPT.
+ *
+ */
+void blk_freeze_queue_preempt(struct request_queue *q)
+{
+	__blk_freeze_queue_start(q, true);
+	blk_freeze_queue_wait(q);
+}
+EXPORT_SYMBOL_GPL(blk_freeze_queue_preempt);
+
+/*
+ * It is the caller's responsibility to make sure no new
+ * request can be allocated before calling this function.
+ */
+void blk_unfreeze_queue_preempt(struct request_queue *q)
+{
+	blk_freeze_queue_wait(q);
+	__blk_unfreeze_queue(q, true);
+}
+EXPORT_SYMBOL_GPL(blk_unfreeze_queue_preempt);
+
+/*
  * FIXME: replace the scsi_internal_device_*block_nowait() calls in the
  * mpt3sas driver such that this function can be removed.
  */
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 0ba5cb043172..596f433eb54c 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -259,6 +259,8 @@ void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 		busy_tag_iter_fn *fn, void *priv);
 void blk_freeze_queue(struct request_queue *q);
 void blk_unfreeze_queue(struct request_queue *q);
+void blk_freeze_queue_preempt(struct request_queue *q);
+void blk_unfreeze_queue_preempt(struct request_queue *q);
 void blk_freeze_queue_start(struct request_queue *q);
 void blk_freeze_queue_wait(struct request_queue *q);
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a43422f5379a..2d62965e91eb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -565,6 +565,9 @@ struct request_queue {
 
 	int			bypass_depth;
 	atomic_t		mq_freeze_depth;
+	spinlock_t		freeze_lock;
+	unsigned		normal_freezing:1;
+	unsigned		preempt_freezing:1;
 
 #if defined(CONFIG_BLK_DEV_BSG)
 	bsg_job_fn		*bsg_job_fn;
-- 
2.9.5
