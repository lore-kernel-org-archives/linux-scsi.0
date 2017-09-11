From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 05/10] block: rename .mq_freeze_wq and .mq_freeze_depth
Date: Mon, 11 Sep 2017 19:10:16 +0800
Message-ID: <20170911111021.25810-6-ming.lei@redhat.com>
References: <20170911111021.25810-1-ming.lei@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57296 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751013AbdIKLMI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Sep 2017 07:12:08 -0400
In-Reply-To: <20170911111021.25810-1-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Ming Lei <ming.lei@redhat.com>

Both two are used for legacy and blk-mq, so rename them
as .freeze_wq and .freeze_depth for avoiding to confuse
people.

No functional change.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       | 12 ++++++------
 block/blk-mq.c         | 12 ++++++------
 include/linux/blkdev.h |  4 ++--
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2347107eeca4..eec5881a9e74 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -630,7 +630,7 @@ void blk_set_queue_dying(struct request_queue *q)
 	 * We need to ensure that processes currently waiting on
 	 * the queue are notified as well.
 	 */
-	wake_up_all(&q->mq_freeze_wq);
+	wake_up_all(&q->freeze_wq);
 }
 EXPORT_SYMBOL_GPL(blk_set_queue_dying);
 
@@ -793,14 +793,14 @@ int blk_queue_enter(struct request_queue *q, bool nowait)
 		/*
 		 * read pair of barrier in blk_freeze_queue_start(),
 		 * we need to order reading __PERCPU_REF_DEAD flag of
-		 * .q_usage_counter and reading .mq_freeze_depth or
+		 * .q_usage_counter and reading .freeze_depth or
 		 * queue dying flag, otherwise the following wait may
 		 * never return if the two reads are reordered.
 		 */
 		smp_rmb();
 
-		ret = wait_event_interruptible(q->mq_freeze_wq,
-				!atomic_read(&q->mq_freeze_depth) ||
+		ret = wait_event_interruptible(q->freeze_wq,
+				!atomic_read(&q->freeze_depth) ||
 				blk_queue_dying(q));
 		if (blk_queue_dying(q))
 			return -ENODEV;
@@ -819,7 +819,7 @@ static void blk_queue_usage_counter_release(struct percpu_ref *ref)
 	struct request_queue *q =
 		container_of(ref, struct request_queue, q_usage_counter);
 
-	wake_up_all(&q->mq_freeze_wq);
+	wake_up_all(&q->freeze_wq);
 }
 
 static void blk_rq_timed_out_timer(unsigned long data)
@@ -891,7 +891,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	q->bypass_depth = 1;
 	__set_bit(QUEUE_FLAG_BYPASS, &q->queue_flags);
 
-	init_waitqueue_head(&q->mq_freeze_wq);
+	init_waitqueue_head(&q->freeze_wq);
 
 	/*
 	 * Init percpu_ref in atomic mode so that it's faster to shutdown.
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 345943fea998..205ae2d3da14 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -122,7 +122,7 @@ void blk_freeze_queue_start(struct request_queue *q)
 {
 	int freeze_depth;
 
-	freeze_depth = atomic_inc_return(&q->mq_freeze_depth);
+	freeze_depth = atomic_inc_return(&q->freeze_depth);
 	if (freeze_depth == 1) {
 		percpu_ref_kill(&q->q_usage_counter);
 		if (q->mq_ops)
@@ -135,14 +135,14 @@ void blk_freeze_queue_wait(struct request_queue *q)
 {
 	if (!q->mq_ops)
 		blk_drain_queue(q);
-	wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->q_usage_counter));
+	wait_event(q->freeze_wq, percpu_ref_is_zero(&q->q_usage_counter));
 }
 EXPORT_SYMBOL_GPL(blk_freeze_queue_wait);
 
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 				     unsigned long timeout)
 {
-	return wait_event_timeout(q->mq_freeze_wq,
+	return wait_event_timeout(q->freeze_wq,
 					percpu_ref_is_zero(&q->q_usage_counter),
 					timeout);
 }
@@ -170,11 +170,11 @@ void blk_unfreeze_queue(struct request_queue *q)
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
 EXPORT_SYMBOL_GPL(blk_unfreeze_queue);
@@ -2424,7 +2424,7 @@ void blk_mq_free_queue(struct request_queue *q)
 /* Basically redo blk_mq_init_queue with queue frozen */
 static void blk_mq_queue_reinit(struct request_queue *q)
 {
-	WARN_ON_ONCE(!atomic_read(&q->mq_freeze_depth));
+	WARN_ON_ONCE(!atomic_read(&q->freeze_depth));
 
 	blk_mq_debugfs_unregister_hctxs(q);
 	blk_mq_sysfs_unregister(q);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 460294bb0fa5..b8053bcc6b5f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -564,7 +564,7 @@ struct request_queue {
 	struct mutex		sysfs_lock;
 
 	int			bypass_depth;
-	atomic_t		mq_freeze_depth;
+	atomic_t		freeze_depth;
 
 #if defined(CONFIG_BLK_DEV_BSG)
 	bsg_job_fn		*bsg_job_fn;
@@ -576,7 +576,7 @@ struct request_queue {
 	struct throtl_data *td;
 #endif
 	struct rcu_head		rcu_head;
-	wait_queue_head_t	mq_freeze_wq;
+	wait_queue_head_t	freeze_wq;
 	struct percpu_ref	q_usage_counter;
 	struct list_head	all_q_node;
 
-- 
2.9.5
