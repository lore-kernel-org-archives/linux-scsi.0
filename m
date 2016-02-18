From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 1/7] block: Add blk_set_runtime_active()
Date: Thu, 18 Feb 2016 10:54:11 +0200
Message-ID: <1455785657-22924-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1455785657-22924-1-git-send-email-mika.westerberg@linux.intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1455785657-22924-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If block device is left runtime suspended during system suspend, resume
hook of the driver typically corrects runtime PM status of the device back
to "active" after it is resumed. However, this is not enough as queue's
runtime PM status is still "suspended". As long as it is in this state
blk_pm_peek_request() returns NULL and thus prevents new requests to be
processed.

Add new function blk_set_runtime_active() that can be used to force the
queue status back to "active" as needed.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 block/blk-core.c       | 24 ++++++++++++++++++++++++
 include/linux/blkdev.h |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index b83d29755b5a..d0c6f4c92cb6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -3529,6 +3529,30 @@ void blk_post_runtime_resume(struct request_queue *q, int err)
 	spin_unlock_irq(q->queue_lock);
 }
 EXPORT_SYMBOL(blk_post_runtime_resume);
+
+/**
+ * blk_set_runtime_active - Force runtime status of the queue to be active
+ * @q: the queue of the device
+ *
+ * If the device is left runtime suspended during system suspend the resume
+ * hook typically resumes the device and corrects runtime status
+ * accordingly. However, that does not affect the queue runtime PM status
+ * which is still "suspended". This prevents processing requests from the
+ * queue.
+ *
+ * This function can be used in driver's resume hook to correct queue
+ * runtime PM status and re-enable peeking requests from the queue. It
+ * should be called before first request is added to the queue.
+ */
+void blk_set_runtime_active(struct request_queue *q)
+{
+	spin_lock_irq(q->queue_lock);
+	q->rpm_status = RPM_ACTIVE;
+	pm_runtime_mark_last_busy(q->dev);
+	pm_request_autosuspend(q->dev);
+	spin_unlock_irq(q->queue_lock);
+}
+EXPORT_SYMBOL(blk_set_runtime_active);
 #endif
 
 int __init blk_dev_init(void)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4571ef1a12a9..40c0241a6f28 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1029,6 +1029,7 @@ extern int blk_pre_runtime_suspend(struct request_queue *q);
 extern void blk_post_runtime_suspend(struct request_queue *q, int err);
 extern void blk_pre_runtime_resume(struct request_queue *q);
 extern void blk_post_runtime_resume(struct request_queue *q, int err);
+extern void blk_set_runtime_active(struct request_queue *q);
 #else
 static inline void blk_pm_runtime_init(struct request_queue *q,
 	struct device *dev) {}
@@ -1039,6 +1040,7 @@ static inline int blk_pre_runtime_suspend(struct request_queue *q)
 static inline void blk_post_runtime_suspend(struct request_queue *q, int err) {}
 static inline void blk_pre_runtime_resume(struct request_queue *q) {}
 static inline void blk_post_runtime_resume(struct request_queue *q, int err) {}
+extern inline void blk_set_runtime_active(struct request_queue *q) {}
 #endif
 
 /*
-- 
2.7.0

