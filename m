From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v4 2/4] block: add runtime pm helpers
Date: Thu,  5 Jul 2012 15:26:37 +0800
Message-ID: <1341473199-3837-3-git-send-email-ming.m.lin@intel.com>
References: <1341473199-3837-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341473199-3837-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>, Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add runtime pm helper functions:

blk_pm_runtime_init()
blk_pre_runtime_suspend()
blk_post_runtime_suspend()
blk_pre_runtime_resume()
blk_post_runtime_suspend()

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---

v4:
- Adds CONFIG_PM_RUNTIME check

 block/blk-core.c       |   63 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |   27 +++++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3c923a7..b94ec5f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -30,6 +30,7 @@
 #include <linux/list_sort.h>
 #include <linux/delay.h>
 #include <linux/ratelimit.h>
+#include <linux/pm_runtime.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/block.h>
@@ -2982,6 +2983,68 @@ void blk_finish_plug(struct blk_plug *plug)
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
index ba43f40..a5b255e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -346,6 +346,12 @@ struct request_queue {
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
@@ -893,6 +899,27 @@ struct request_queue *blk_alloc_queue_node(gfp_t, int);
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
