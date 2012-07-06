From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v5 2/4] block: add runtime pm helpers
Date: Fri,  6 Jul 2012 12:04:30 +0800
Message-ID: <1341547472-6863-3-git-send-email-ming.m.lin@intel.com>
References: <1341547472-6863-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341547472-6863-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add runtime pm helper functions:

void blk_pm_runtime_init(struct request_queue *q, struct device *dev)
  - Initialization function for drivers to call. It calls
    pm_runtime_use_autosuspend(), pm_runtime_mark_last_busy() and
    pm_runtime_autosuspend().

int blk_pre_runtime_suspend(struct request_queue *q)
  - If any requests are in the queue, return -EBUSY.
    Otherwise set q->rpm_status to RPM_SUSPENDING and return 0.

void blk_post_runtime_suspend(struct request_queue *q, int err)
  - If the suspend succeeded then set q->rpm_status to RPM_SUSPENDED.
    Otherwise set it to RPM_ACTIVE and call pm_runtime_mark_last_busy().

void blk_pre_runtime_resume(struct request_queue *q)
  - Set q->rpm_status to RPM_RESUMING.

void blk_post_runtime_resume(struct request_queue *q, int err)
  - If the resume succeeded then set q->rpm_status to RPM_ACTIVE
    and call pm_runtime_mark_last_busy() and pm_request_autosuspend().
    Otherwise set q->rpm_status to RPM_SUSPENDED.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 block/blk-core.c       |   62 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |   28 ++++++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3c923a7..1cc80ae 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2982,6 +2982,68 @@ void blk_finish_plug(struct blk_plug *plug)
 }
 EXPORT_SYMBOL(blk_finish_plug);
 
+#ifdef CONFIG_PM_RUNTIME
+void blk_pm_runtime_init(struct request_queue *q, struct device *dev)
+{
+	q->dev = dev;
+	q->rpm_status = RPM_ACTIVE;
+
+	pm_runtime_use_autosuspend(q->dev);
+	pm_runtime_mark_last_busy(q->dev);
+	pm_runtime_autosuspend(q->dev);
+}
+EXPORT_SYMBOL(blk_pm_runtime_init);
+
+int blk_pre_runtime_suspend(struct request_queue *q)
+{
+	int ret = 0;
+
+	spin_lock_irq(q->queue_lock);
+	if (q->nr_pending)
+		ret = -EBUSY;
+	else
+		q->rpm_status = RPM_SUSPENDING;
+	spin_unlock_irq(q->queue_lock);
+	return ret;
+}
+EXPORT_SYMBOL(blk_pre_runtime_suspend);
+
+void blk_post_runtime_suspend(struct request_queue *q, int err)
+{
+	spin_lock_irq(q->queue_lock);
+	if (!err)
+		q->rpm_status = RPM_SUSPENDED;
+	else {
+		q->rpm_status = RPM_ACTIVE;
+		pm_runtime_mark_last_busy(q->dev);
+	}
+	spin_unlock_irq(q->queue_lock);
+}
+EXPORT_SYMBOL(blk_post_runtime_suspend);
+
+void blk_pre_runtime_resume(struct request_queue *q)
+{
+	spin_lock_irq(q->queue_lock);
+	q->rpm_status = RPM_RESUMING;
+	spin_unlock_irq(q->queue_lock);
+}
+EXPORT_SYMBOL(blk_pre_runtime_resume);
+
+void blk_post_runtime_resume(struct request_queue *q, int err)
+{
+	spin_lock_irq(q->queue_lock);
+	if (!err) {
+		q->rpm_status = RPM_ACTIVE;
+		__blk_run_queue(q);
+		pm_runtime_mark_last_busy(q->dev);
+		pm_request_autosuspend(q->dev);
+	} else
+		q->rpm_status = RPM_SUSPENDED;
+	spin_unlock_irq(q->queue_lock);
+}
+EXPORT_SYMBOL(blk_post_runtime_resume);
+#endif
+
 int __init blk_dev_init(void)
 {
 	BUILD_BUG_ON(__REQ_NR_BITS > 8 *
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ba43f40..9395d39 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -19,6 +19,7 @@
 #include <linux/gfp.h>
 #include <linux/bsg.h>
 #include <linux/smp.h>
+#include <linux/pm_runtime.h>
 
 #include <asm/scatterlist.h>
 
@@ -346,6 +347,12 @@ struct request_queue {
 	 */
 	struct kobject kobj;
 
+#ifdef CONFIG_PM_RUNTIME
+	struct device		*dev;
+	int			rpm_status;
+	unsigned int		nr_pending;
+#endif
+
 	/*
 	 * queue settings
 	 */
@@ -893,6 +900,27 @@ struct request_queue *blk_alloc_queue_node(gfp_t, int);
 extern void blk_put_queue(struct request_queue *);
 
 /*
+ * block layer runtime pm functions
+ */
+#ifdef CONFIG_PM_RUNTIME
+extern void blk_pm_runtime_init(struct request_queue *q, struct device *dev);
+extern int blk_pre_runtime_suspend(struct request_queue *q);
+extern void blk_post_runtime_suspend(struct request_queue *q, int err);
+extern void blk_pre_runtime_resume(struct request_queue *q);
+extern void blk_post_runtime_resume(struct request_queue *q, int err);
+#else
+static inline void blk_pm_runtime_init(struct request_queue *q,
+	struct device *dev) {}
+static inline int blk_pre_runtime_suspend(struct request_queue *q)
+{
+	return -ENOSYS;
+}
+static inline void blk_post_runtime_suspend(struct request_queue *q, int err) {}
+static inline void blk_pre_runtime_resume(struct request_queue *q) {}
+static inline void blk_post_runtime_resume(struct request_queue *q, int err) {}
+#endif
+
+/*
  * blk_plug permits building a queue of related requests by holding the I/O
  * fragments for a short period. This allows merging of sequential requests
  * into single larger request. As the requests are moved from a per-task list to
-- 
1.7.10
