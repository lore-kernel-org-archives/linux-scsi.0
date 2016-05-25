From: mchristi@redhat.com
Subject: [PATCH 2/5] block: add queue reset support
Date: Wed, 25 May 2016 02:55:00 -0500
Message-ID: <1464162903-14735-3-git-send-email-mchristi@redhat.com>
References: <1464162903-14735-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbcEYHzJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2016 03:55:09 -0400
In-Reply-To: <1464162903-14735-1-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, target-devel@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>

From: Mike Christie <mchristi@redhat.com>

This adds a request_queue/mq_ops callout which when called
should force the completion/failure of requests that have been
dequeued by the driver. Requests can be completed normally
or should be failed with -EINTR.

On success the reset callout should complete/fail dequeued
requests and then return BLK_EH_HANDLED.

If the reset callout fails, it should return BLK_EH_NOT_HANDLED.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 block/blk-core.c       |  8 ++++++
 block/blk-settings.c   |  6 +++++
 block/blk-timeout.c    | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blk-mq.h |  5 ++++
 include/linux/blkdev.h |  8 ++++++
 5 files changed, 95 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2475b1c7..2aeac9c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -575,6 +575,9 @@ void blk_cleanup_queue(struct request_queue *q)
 	if (!q->mq_ops)
 		__blk_drain_queue(q, true);
 	queue_flag_set(QUEUE_FLAG_DEAD, q);
+
+	/* wait for resets that might have started as result of drain */
+	wait_event_lock_irq(q->reset_wq, !blk_queue_resetting(q), *lock);
 	spin_unlock_irq(lock);
 
 	/* for synchronous bio-based driver finish in-flight integrity i/o */
@@ -728,6 +731,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 	kobject_init(&q->kobj, &blk_queue_ktype);
 
+	init_waitqueue_head(&q->reset_wq);
 	mutex_init(&q->sysfs_lock);
 	spin_lock_init(&q->__queue_lock);
 
@@ -850,6 +854,7 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 
 	INIT_WORK(&q->timeout_work, blk_timeout_work);
 	q->request_fn		= rfn;
+	q->reset_fn		= NULL,
 	q->prep_rq_fn		= NULL;
 	q->unprep_rq_fn		= NULL;
 	q->queue_flags		|= QUEUE_FLAG_DEFAULT;
@@ -2619,6 +2624,9 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 		case -ENODATA:
 			error_type = "critical medium";
 			break;
+		case -EINTR:
+			error_type = "critical command";
+			break;
 		case -EIO:
 		default:
 			error_type = "I/O";
diff --git a/block/blk-settings.c b/block/blk-settings.c
index f679ae1..1d529ba 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -71,6 +71,12 @@ void blk_queue_rq_timed_out(struct request_queue *q, rq_timed_out_fn *fn)
 }
 EXPORT_SYMBOL_GPL(blk_queue_rq_timed_out);
 
+void blk_queue_reset(struct request_queue *q, reset_fn *fn)
+{
+	q->reset_fn = fn;
+}
+EXPORT_SYMBOL_GPL(blk_queue_reset);
+
 void blk_queue_lld_busy(struct request_queue *q, lld_busy_fn *fn)
 {
 	q->lld_busy_fn = fn;
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index a30441a..96b73786 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/blkdev.h>
 #include <linux/fault-inject.h>
+#include <linux/delay.h>
 
 #include "blk.h"
 #include "blk-mq.h"
@@ -172,6 +173,73 @@ void blk_abort_request(struct request *req)
 }
 EXPORT_SYMBOL_GPL(blk_abort_request);
 
+/**
+ * blk_reset_queue - force completion of requests executing in queue
+ * @q:		request queue to reset
+ *
+ * On success the driver returns BLK_EH_HANDLED from the callout and
+ * either complete requests successfully with 0 or if abnormally completed
+ * with the error code -EINTR.
+ *
+ * On failure the driver returns BLK_EH_NOT_HANDLED, and requests may still
+ * be executing.
+ */
+int blk_reset_queue(struct request_queue *q)
+{
+	enum blk_eh_timer_return eh_rc;
+	int rc;
+
+	spin_lock_irq(q->queue_lock);
+	wait_event_lock_irq(q->reset_wq,
+			    !queue_flag_test_and_set(QUEUE_FLAG_RESETTING, q),
+			    *q->queue_lock);
+	if (blk_queue_dead(q)) {
+		rc = -ENODEV;
+		spin_unlock_irq(q->queue_lock);
+		goto done;
+	}
+	spin_unlock_irq(q->queue_lock);
+
+	if (q->mq_ops) {
+		blk_mq_stop_hw_queues(q);
+		blk_mq_freeze_queue(q);
+
+		eh_rc = q->mq_ops->reset(q);
+
+		blk_mq_unfreeze_queue(q);
+		blk_mq_start_stopped_hw_queues(q, true);
+	} else if (q->reset_fn) {
+		spin_lock_irq(q->queue_lock);
+		blk_stop_queue(q);
+		spin_unlock_irq(q->queue_lock);
+
+		while (q->request_fn_active)
+			msleep(10);
+
+		eh_rc = q->reset_fn(q);
+
+		spin_lock_irq(q->queue_lock);
+		blk_start_queue(q);
+		spin_unlock_irq(q->queue_lock);
+	} else {
+		rc = -EOPNOTSUPP;
+		goto done;
+	}
+
+	if (eh_rc == BLK_EH_HANDLED)
+		rc = 0;
+	else
+		rc = -EIO;
+
+done:
+	spin_lock_irq(q->queue_lock);
+	queue_flag_clear(QUEUE_FLAG_RESETTING, q);
+	spin_unlock_irq(q->queue_lock);
+	wake_up_all(&q->reset_wq);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(blk_reset_queue);
+
 unsigned long blk_rq_timeout(unsigned long timeout)
 {
 	unsigned long maxt;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2498fdf..5d5e55a 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -120,6 +120,11 @@ struct blk_mq_ops {
 	timeout_fn		*timeout;
 
 	/*
+	 * Force executing IO to complete or fail.
+	 */
+	reset_fn		*reset;
+
+	/*
 	 * Called to poll for completion of a specific tag.
 	 */
 	poll_fn			*poll;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1fd8fdf..f030436 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -227,6 +227,7 @@ enum blk_eh_timer_return {
 };
 
 typedef enum blk_eh_timer_return (rq_timed_out_fn)(struct request *);
+typedef enum blk_eh_timer_return (reset_fn)(struct request_queue *);
 
 enum blk_queue_state {
 	Queue_down,
@@ -304,6 +305,7 @@ struct request_queue {
 	unprep_rq_fn		*unprep_rq_fn;
 	softirq_done_fn		*softirq_done_fn;
 	rq_timed_out_fn		*rq_timed_out_fn;
+	reset_fn		*reset_fn;
 	dma_drain_needed_fn	*dma_drain_needed;
 	lld_busy_fn		*lld_busy_fn;
 
@@ -464,6 +466,8 @@ struct request_queue {
 	struct bio_set		*bio_split;
 
 	bool			mq_sysfs_init_done;
+
+	wait_queue_head_t	reset_wq;
 };
 
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
@@ -492,6 +496,7 @@ struct request_queue {
 #define QUEUE_FLAG_WC	       23	/* Write back caching */
 #define QUEUE_FLAG_FUA	       24	/* device supports FUA writes */
 #define QUEUE_FLAG_FLUSH_NQ    25	/* flush not queueuable */
+#define QUEUE_FLAG_RESETTING   26	/* reset callback is executing */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -564,6 +569,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 	__clear_bit(flag, &q->queue_flags);
 }
 
+#define blk_queue_resetting(q)	test_bit(QUEUE_FLAG_RESETTING, &(q)->queue_flags)
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_dying(q)	test_bit(QUEUE_FLAG_DYING, &(q)->queue_flags)
@@ -955,6 +961,7 @@ extern bool __blk_end_request_err(struct request *rq, int error);
 extern void blk_complete_request(struct request *);
 extern void __blk_complete_request(struct request *);
 extern void blk_abort_request(struct request *);
+extern int blk_reset_queue(struct request_queue *);
 extern void blk_unprep_request(struct request *);
 
 /*
@@ -1008,6 +1015,7 @@ extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
 extern void blk_queue_rq_timed_out(struct request_queue *, rq_timed_out_fn *);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
+extern void blk_queue_reset(struct request_queue *, reset_fn *);
 extern void blk_queue_flush_queueable(struct request_queue *q, bool queueable);
 extern void blk_queue_write_cache(struct request_queue *q, bool enabled, bool fua);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
-- 
2.7.2

