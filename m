From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 6/8] block: introduce preempt version of blk_[freeze|unfreeze]_queue
Date: Sat,  2 Sep 2017 21:08:38 +0800
Message-ID: <20170902130840.24609-7-ming.lei@redhat.com>
References: <20170902130840.24609-1-ming.lei@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52034 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752469AbdIBNKA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 2 Sep 2017 09:10:00 -0400
In-Reply-To: <20170902130840.24609-1-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Tejun Heo <tj@kernel.org>, Ming Lei <ming.lei@redhat.com>

The two APIs are required to allow request allocation of
RQF_PREEMPT when queue is preempt frozen.

The following two points have to be guaranteed for one queue:

1) preempt freezing can be started only after all in-progress
normal & preempt freezings are completed

2) normal freezing can be started only if in-progress preempt
freezing is completed

Because for normal freezing, once blk_mq_freeze_queue_wait()
is returned, we have to make sure no request is entering queue
any more.

rwsem should have been perfect for this kind of sync, but we need
to support nested normal freeze, so spin_lock and normal_freezing &
preempt_freezing flag are used for the sync between normal freeze
and preempt freeze.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       |   2 +
 block/blk-mq.c         | 120 +++++++++++++++++++++++++++++++++++++++++++++++--
 block/blk.h            |  16 +++++++
 include/linux/blk-mq.h |   2 +
 include/linux/blkdev.h |   4 ++
 5 files changed, 141 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 85b15833a7a5..2549b0a0535d 100644
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
index 24de78afbe9a..54b8d8b9f40e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -118,16 +118,75 @@ void blk_mq_in_flight(struct request_queue *q, struct hd_struct *part,
 	blk_mq_queue_tag_busy_iter(q, blk_mq_check_inflight, &mi);
 }
 
-void blk_freeze_queue_start(struct request_queue *q)
+static bool queue_freeze_is_over(struct request_queue *q, bool preempt)
+{
+	/*
+	 * For preempt freeze, we simply call blk_queue_enter_live()
+	 * before allocating one request of RQF_PREEMPT, so we have
+	 * to check if queue is dead, otherwise we may hang on dead
+	 * queue.
+	 *
+	 * For normal freeze, no need to check blk_queue_dying()
+	 * because it is checked in blk_queue_enter().
+	 */
+	if (preempt)
+		return !(q->normal_freezing + q->preempt_freezing) ||
+			blk_queue_dying(q);
+	return !q->preempt_freezing;
+}
+
+static bool __blk_freeze_queue_start(struct request_queue *q, bool preempt)
 {
 	int freeze_depth;
+	bool start_freeze = true;
+
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
+	 * but we need to support nested normal freeze, so use
+	 * spin_lock with two flag for syncing between normal
+	 * freeze and preempt freeze.
+	 */
+	spin_lock(&q->freeze_lock);
+	wait_event_cmd(q->mq_freeze_wq,
+		       queue_freeze_is_over(q, preempt),
+		       spin_unlock(&q->freeze_lock),
+		       spin_lock(&q->freeze_lock));
+
+	if (preempt && blk_queue_dying(q)) {
+		start_freeze = false;
+		goto unlock;
+	}
 
 	freeze_depth = atomic_inc_return(&q->mq_freeze_depth);
 	if (freeze_depth == 1) {
+		if (preempt) {
+			q->preempt_freezing = 1;
+			q->preempt_unfreezing = 0;
+		} else
+			q->normal_freezing = 1;
+		spin_unlock(&q->freeze_lock);
+
 		percpu_ref_kill(&q->q_usage_counter);
 		if (q->mq_ops)
 			blk_mq_run_hw_queues(q, false);
-	}
+	} else
+ unlock:
+		spin_unlock(&q->freeze_lock);
+
+	return start_freeze;
+}
+
+void blk_freeze_queue_start(struct request_queue *q)
+{
+	__blk_freeze_queue_start(q, false);
 }
 EXPORT_SYMBOL_GPL(blk_freeze_queue_start);
 
@@ -166,7 +225,7 @@ void blk_freeze_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_freeze_queue);
 
-void blk_unfreeze_queue(struct request_queue *q)
+static void __blk_unfreeze_queue(struct request_queue *q, bool preempt)
 {
 	int freeze_depth;
 
@@ -174,12 +233,67 @@ void blk_unfreeze_queue(struct request_queue *q)
 	WARN_ON_ONCE(freeze_depth < 0);
 	if (!freeze_depth) {
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
+ * of RQF_PREEMPT.
+ */
+void blk_freeze_queue_preempt(struct request_queue *q)
+{
+	/*
+	 * If queue isn't in preempt_frozen, the queue has
+	 * to be dying, so do nothing since no I/O can
+	 * succeed any more.
+	 */
+	if (__blk_freeze_queue_start(q, true))
+		blk_freeze_queue_wait(q);
+}
+EXPORT_SYMBOL_GPL(blk_freeze_queue_preempt);
+
+/*
+ * It is the caller's responsibility to make sure no new
+ * request is allocated before calling this function.
+ */
+void blk_unfreeze_queue_preempt(struct request_queue *q)
+{
+	/*
+	 * If queue isn't in preempt_frozen, the queue should
+	 * be dying , so do nothing since no I/O can succeed.
+	 */
+	if (blk_queue_is_preempt_frozen(q)) {
+
+		/* no new request can be coming after unfreezing */
+		spin_lock(&q->freeze_lock);
+		q->preempt_unfreezing = 1;
+		spin_unlock(&q->freeze_lock);
+
+		blk_freeze_queue_wait(q);
+		__blk_unfreeze_queue(q, true);
+	}
+}
+EXPORT_SYMBOL_GPL(blk_unfreeze_queue_preempt);
+
+/*
  * FIXME: replace the scsi_internal_device_*block_nowait() calls in the
  * mpt3sas driver such that this function can be removed.
  */
diff --git a/block/blk.h b/block/blk.h
index 242486e26a81..28e9be6a14c6 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -80,6 +80,22 @@ static inline void blk_queue_enter_live(struct request_queue *q)
 	percpu_ref_get(&q->q_usage_counter);
 }
 
+static inline bool blk_queue_is_preempt_frozen(struct request_queue *q)
+{
+	bool preempt_frozen;
+	bool preempt_unfreezing;
+
+	if (!percpu_ref_is_dying(&q->q_usage_counter))
+		return false;
+
+	spin_lock(&q->freeze_lock);
+	preempt_frozen = q->preempt_freezing;
+	preempt_unfreezing = q->preempt_unfreezing;
+	spin_unlock(&q->freeze_lock);
+
+	return preempt_frozen && !preempt_unfreezing;
+}
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 void blk_flush_integrity(void);
 bool __bio_integrity_endio(struct bio *);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index f90d78eb85df..5ae8c82d6273 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -258,6 +258,8 @@ void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 		busy_tag_iter_fn *fn, void *priv);
 void blk_freeze_queue(struct request_queue *q);
 void blk_unfreeze_queue(struct request_queue *q);
+void blk_freeze_queue_preempt(struct request_queue *q);
+void blk_unfreeze_queue_preempt(struct request_queue *q);
 void blk_freeze_queue_start(struct request_queue *q);
 void blk_freeze_queue_wait(struct request_queue *q);
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f45f157b2910..5618d174100a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -565,6 +565,10 @@ struct request_queue {
 
 	int			bypass_depth;
 	atomic_t		mq_freeze_depth;
+	spinlock_t		freeze_lock;
+	unsigned		normal_freezing:1;
+	unsigned		preempt_freezing:1;
+	unsigned		preempt_unfreezing:1;
 
 #if defined(CONFIG_BLK_DEV_BSG)
 	bsg_job_fn		*bsg_job_fn;
-- 
2.9.5
