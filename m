From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v6 3/4] block: implement runtime pm strategy
Date: Sun,  6 Jan 2013 16:41:36 +0800
Message-ID: <1357461697-4219-4-git-send-email-aaron.lu@intel.com>
References: <1357461697-4219-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1357461697-4219-1-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

When a request is added:
    If device is suspended or is suspending and the request is not a
    PM request, resume the device.

When the last request finishes:
    Call pm_runtime_mark_last_busy() and pm_runtime_autosuspend().

When pick a request:
    If device is resuming/suspending, then only PM request is allowed to go.
    Return NULL for other cases.

[aaron.lu@intel.com: PM request does not involve nr_pending counting]
[aaron.lu@intel.com: No need to check q->dev]
[aaron.lu@intel.com: Autosuspend when the last request finished]
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 block/blk-core.c       |  7 +++++++
 block/elevator.c       |  4 ++++
 include/linux/blkdev.h | 41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 6fc24bb..93c1461 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1274,6 +1274,8 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 	if (unlikely(--req->ref_count))
 		return;
 
+	blk_pm_put_request(req);
+
 	elv_completed_request(q, req);
 
 	/* this is a bio leak */
@@ -2080,6 +2082,11 @@ struct request *blk_peek_request(struct request_queue *q)
 	int ret;
 
 	while ((rq = __elv_next_request(q)) != NULL) {
+
+		rq = blk_pm_peek_request(q, rq);
+		if (!rq)
+			break;
+
 		if (!(rq->cmd_flags & REQ_STARTED)) {
 			/*
 			 * This is the first time the device driver
diff --git a/block/elevator.c b/block/elevator.c
index 9edba1b..61e9b49 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -544,6 +544,8 @@ void elv_requeue_request(struct request_queue *q, struct request *rq)
 
 	rq->cmd_flags &= ~REQ_STARTED;
 
+	blk_pm_requeue_request(rq);
+
 	__elv_add_request(q, rq, ELEVATOR_INSERT_REQUEUE);
 }
 
@@ -566,6 +568,8 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 {
 	trace_block_rq_insert(q, rq);
 
+	blk_pm_add_request(q, rq);
+
 	rq->q = q;
 
 	if (rq->cmd_flags & REQ_SOFTBARRIER) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a96e144..884c405 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -974,6 +974,40 @@ extern int blk_pre_runtime_suspend(struct request_queue *q);
 extern void blk_post_runtime_suspend(struct request_queue *q, int err);
 extern void blk_pre_runtime_resume(struct request_queue *q);
 extern void blk_post_runtime_resume(struct request_queue *q, int err);
+
+static inline void blk_pm_put_request(struct request *rq)
+{
+	if (!(rq->cmd_flags & REQ_PM) && !--rq->q->nr_pending) {
+		pm_runtime_mark_last_busy(rq->q->dev);
+		pm_runtime_autosuspend(rq->q->dev);
+	}
+}
+
+static inline struct request *blk_pm_peek_request(
+	struct request_queue *q, struct request *rq)
+{
+	if (q->rpm_status == RPM_SUSPENDED ||
+		  (q->rpm_status != RPM_ACTIVE && !(rq->cmd_flags & REQ_PM)))
+		return NULL;
+	else
+		return rq;
+}
+
+static inline void blk_pm_requeue_request(struct request *rq)
+{
+	if (!(rq->cmd_flags & REQ_PM))
+		rq->q->nr_pending--;
+}
+
+static inline void blk_pm_add_request(struct request_queue *q,
+	struct request *rq)
+{
+	if (!(rq->cmd_flags & REQ_PM) &&
+	    q->nr_pending++ == 0 &&
+	    (q->rpm_status == RPM_SUSPENDED ||
+	     q->rpm_status == RPM_SUSPENDING))
+		pm_request_resume(q->dev);
+}
 #else
 static inline void blk_pm_runtime_init(struct request_queue *q,
 	struct device *dev) {}
@@ -984,6 +1018,13 @@ static inline int blk_pre_runtime_suspend(struct request_queue *q)
 static inline void blk_post_runtime_suspend(struct request_queue *q, int err) {}
 static inline void blk_pre_runtime_resume(struct request_queue *q) {}
 static inline void blk_post_runtime_resume(struct request_queue *q, int err) {}
+
+static inline void blk_pm_put_request(struct request *rq) {}
+static inline struct request *blk_pm_peek_request(
+	struct request_queue *q, struct request *rq) { return rq; }
+static inline void blk_pm_requeue_request(struct request *rq) {}
+static inline void blk_pm_add_request(struct request_queue *q,
+	struct request *req) {}
 #endif
 
 /*
-- 
1.7.11.7
