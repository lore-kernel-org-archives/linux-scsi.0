From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 07/10] block: introduce preempt version of blk_[freeze|unfreeze]_queue
Date: Mon, 11 Sep 2017 19:10:18 +0800
Message-ID: <20170911111021.25810-8-ming.lei@redhat.com>
References: <20170911111021.25810-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170911111021.25810-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

The two APIs are required to allow request allocation of
RQF_PREEMPT when queue is preempt frozen.

We have to guarantee that normal freeze and preempt freeze
are run exclusive. Because for normal freezing, once
blk_freeze_queue_wait() is returned, no request can enter
queue any more.

Another issue we should pay attention to is that the race
of preempt freeze vs. blk_cleanup_queue(), and it is avoided
by not allowing to preempt freeeze after queue becomes dying,
otherwise preempt freeeze may hang forever.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       |   2 +
 block/blk-mq.c         | 133 +++++++++++++++++++++++++++++++++++++++++++------
 block/blk.h            |  11 ++++
 include/linux/blk-mq.h |   2 +
 include/linux/blkdev.h |   6 +++
 5 files changed, 140 insertions(+), 14 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 04327a60061e..ade9b5484a6e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -905,6 +905,8 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (blkcg_init_queue(q))
 		goto fail_ref;
 
+	spin_lock_init(&q->freeze_lock);
+
 	return q;
 
 fail_ref:
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 358b2ca33010..096c5f0ea518 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -118,19 +118,6 @@ void blk_mq_in_flight(struct request_queue *q, struct hd_struct *part,
 	blk_mq_queue_tag_busy_iter(q, blk_mq_check_inflight, &mi);
 }
 
-void blk_freeze_queue_start(struct request_queue *q)
-{
-	int freeze_depth;
-
-	freeze_depth = atomic_inc_return(&q->freeze_depth);
-	if (freeze_depth == 1) {
-		percpu_ref_kill(&q->q_usage_counter);
-		if (q->mq_ops)
-			blk_mq_run_hw_queues(q, false);
-	}
-}
-EXPORT_SYMBOL_GPL(blk_freeze_queue_start);
-
 void blk_freeze_queue_wait(struct request_queue *q)
 {
 	if (!q->mq_ops)
@@ -148,6 +135,69 @@ int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 }
 EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_wait_timeout);
 
+static bool queue_freeze_is_over(struct request_queue *q,
+		bool preempt, bool *queue_dying)
+{
+	/*
+	 * preempt freeze has to be prevented after queue is set as
+	 * dying, otherwise we may hang forever
+	 */
+	if (preempt) {
+		spin_lock_irq(q->queue_lock);
+		*queue_dying = !!blk_queue_dying(q);
+		spin_unlock_irq(q->queue_lock);
+
+		return !q->normal_freezing || *queue_dying;
+	}
+	return !q->preempt_freezing;
+}
+
+static void __blk_freeze_queue_start(struct request_queue *q, bool preempt)
+{
+	int freeze_depth;
+	bool queue_dying;
+
+	/*
+	 * Make sure normal freeze and preempt freeze are run
+	 * exclusively, but each kind itself is allowed to be
+	 * run concurrently, even nested.
+	 */
+	spin_lock(&q->freeze_lock);
+	wait_event_cmd(q->freeze_wq,
+		       queue_freeze_is_over(q, preempt, &queue_dying),
+		       spin_unlock(&q->freeze_lock),
+		       spin_lock(&q->freeze_lock));
+
+	if (preempt && queue_dying)
+		goto unlock;
+
+	freeze_depth = atomic_inc_return(&q->freeze_depth);
+	if (freeze_depth == 1) {
+		if (preempt) {
+			q->preempt_freezing = 1;
+			q->preempt_unfreezing = 0;
+		} else
+			q->normal_freezing = 1;
+		spin_unlock(&q->freeze_lock);
+
+		percpu_ref_kill(&q->q_usage_counter);
+		if (q->mq_ops)
+			blk_mq_run_hw_queues(q, false);
+
+		/* have to drain I/O here for preempt quiesce */
+		if (preempt)
+			blk_freeze_queue_wait(q);
+	} else
+ unlock:
+		spin_unlock(&q->freeze_lock);
+}
+
+void blk_freeze_queue_start(struct request_queue *q)
+{
+	__blk_freeze_queue_start(q, false);
+}
+EXPORT_SYMBOL_GPL(blk_freeze_queue_start);
+
 /*
  * Guarantee no request is in use, so we can change any data structure of
  * the queue afterward.
@@ -166,20 +216,75 @@ void blk_freeze_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_freeze_queue);
 
-void blk_unfreeze_queue(struct request_queue *q)
+static void blk_start_unfreeze_queue_preempt(struct request_queue *q)
+{
+	/* no new request can be coming after unfreezing */
+	spin_lock(&q->freeze_lock);
+	q->preempt_unfreezing = 1;
+	spin_unlock(&q->freeze_lock);
+
+	blk_freeze_queue_wait(q);
+}
+
+static void __blk_unfreeze_queue(struct request_queue *q, bool preempt)
 {
 	int freeze_depth;
 
 	freeze_depth = atomic_dec_return(&q->freeze_depth);
 	WARN_ON_ONCE(freeze_depth < 0);
 	if (!freeze_depth) {
+		if (preempt)
+			blk_start_unfreeze_queue_preempt(q);
+
 		percpu_ref_reinit(&q->q_usage_counter);
+
+		/*
+		 * clearing the freeze flag so that any pending
+		 * freeze can move on
+		 */
+		spin_lock(&q->freeze_lock);
+		if (preempt)
+			q->preempt_freezing = 0;
+		else
+			q->normal_freezing = 0;
+		spin_unlock(&q->freeze_lock);
 		wake_up_all(&q->freeze_wq);
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
+ * of RQF_PREEMPT.
+ */
+void blk_freeze_queue_preempt(struct request_queue *q)
+{
+	/*
+	 * If queue isn't in preempt_frozen, the queue has
+	 * to be dying, so do nothing since no I/O can
+	 * succeed any more.
+	 */
+	__blk_freeze_queue_start(q, true);
+}
+EXPORT_SYMBOL_GPL(blk_freeze_queue_preempt);
+
+void blk_unfreeze_queue_preempt(struct request_queue *q)
+{
+	/*
+	 * If queue isn't in preempt_frozen, the queue should
+	 * be dying , so do nothing since no I/O can succeed.
+	 */
+	if (blk_queue_is_preempt_frozen(q))
+		__blk_unfreeze_queue(q, true);
+}
+EXPORT_SYMBOL_GPL(blk_unfreeze_queue_preempt);
+
+/*
  * FIXME: replace the scsi_internal_device_*block_nowait() calls in the
  * mpt3sas driver such that this function can be removed.
  */
diff --git a/block/blk.h b/block/blk.h
index 21eed59d96db..243b2e7e5098 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -79,6 +79,17 @@ static inline void blk_queue_enter_live(struct request_queue *q)
 	percpu_ref_get(&q->q_usage_counter);
 }
 
+static inline bool blk_queue_is_preempt_frozen(struct request_queue *q)
+{
+	bool preempt_frozen;
+
+	spin_lock(&q->freeze_lock);
+	preempt_frozen = q->preempt_freezing && !q->preempt_unfreezing;
+	spin_unlock(&q->freeze_lock);
+
+	return preempt_frozen;
+}
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 void blk_flush_integrity(void);
 bool __bio_integrity_endio(struct bio *);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 62c3d1f7d12a..54b160bcb6a2 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -255,6 +255,8 @@ void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 		busy_tag_iter_fn *fn, void *priv);
 void blk_freeze_queue(struct request_queue *q);
 void blk_unfreeze_queue(struct request_queue *q);
+void blk_freeze_queue_preempt(struct request_queue *q);
+void blk_unfreeze_queue_preempt(struct request_queue *q);
 void blk_freeze_queue_start(struct request_queue *q);
 void blk_freeze_queue_wait(struct request_queue *q);
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 54450715915b..3c14c9588dcf 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -566,6 +566,12 @@ struct request_queue {
 	int			bypass_depth;
 	atomic_t		freeze_depth;
 
+	/* for run normal freeze and preempt freeze exclusive */
+	spinlock_t		freeze_lock;
+	unsigned		normal_freezing:1;
+	unsigned		preempt_freezing:1;
+	unsigned		preempt_unfreezing:1;
+
 #if defined(CONFIG_BLK_DEV_BSG)
 	bsg_job_fn		*bsg_job_fn;
 	struct bsg_class_device bsg_dev;
-- 
2.9.5
