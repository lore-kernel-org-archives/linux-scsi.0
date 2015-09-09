From: Ken Xue <Ken.Xue@amd.com>
Subject: [PATCH]SCSI:Refine the way to fix NULL pointer dereference in
 runtime PM
Date: Wed, 9 Sep 2015 15:02:11 +0800
Message-ID: <1441782131.5845.73.camel@kxue-X58A-UD3R>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0099.outbound.protection.outlook.com ([157.56.110.99]:18974
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751082AbbIIHWe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Sep 2015 03:22:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: Shane.Huang@amd.com, Xiangliang.Yu@amd.com, aaron.lu@intel.com, linux-scsi@vger.kernel.org, JBottomley@Odin.com, SPG_Linux_Kernel@amd.com

>From 844ebfcecad7ddaf7206e0474c600b0146b4ef21 Mon Sep 17 00:00:00 2001
From: Ken Xue <Ken.Xue@amd.com>
Date: Wed, 9 Sep 2015 14:55:21 +0800
Subject: [PATCH] SCSI:Refine the way to fix NULL pointer dereference in
 runtime PM

There was a patch about Bugzilla #101371. That patch introduced a
possibility that can not call blk_{pre|post}_runtime_suspend and
blk_{pre|post}_runtime_resume in pairs.

Signed-off-by: Ken Xue <Ken.Xue@amd.com>
---
 block/blk-core.c       | 12 ++++++++++++
 drivers/scsi/scsi_pm.c | 20 ++++++++++----------
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 60912e9..a07ab18 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -3280,6 +3280,9 @@ int blk_pre_runtime_suspend(struct request_queue *q)
 {
 	int ret = 0;
 
+	if (!q->dev)
+		return ret;
+
 	spin_lock_irq(q->queue_lock);
 	if (q->nr_pending) {
 		ret = -EBUSY;
@@ -3307,6 +3310,9 @@ EXPORT_SYMBOL(blk_pre_runtime_suspend);
  */
 void blk_post_runtime_suspend(struct request_queue *q, int err)
 {
+	if (!q->dev)
+		return;
+
 	spin_lock_irq(q->queue_lock);
 	if (!err) {
 		q->rpm_status = RPM_SUSPENDED;
@@ -3331,6 +3337,9 @@ EXPORT_SYMBOL(blk_post_runtime_suspend);
  */
 void blk_pre_runtime_resume(struct request_queue *q)
 {
+	if (!q->dev)
+		return;
+
 	spin_lock_irq(q->queue_lock);
 	q->rpm_status = RPM_RESUMING;
 	spin_unlock_irq(q->queue_lock);
@@ -3353,6 +3362,9 @@ EXPORT_SYMBOL(blk_pre_runtime_resume);
  */
 void blk_post_runtime_resume(struct request_queue *q, int err)
 {
+	if (!q->dev)
+		return;
+
 	spin_lock_irq(q->queue_lock);
 	if (!err) {
 		q->rpm_status = RPM_ACTIVE;
diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index e4b7998..459abe1 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -219,13 +219,13 @@ static int sdev_runtime_suspend(struct device *dev)
 	struct scsi_device *sdev = to_scsi_device(dev);
 	int err = 0;
 
-	if (pm && pm->runtime_suspend) {
-		err = blk_pre_runtime_suspend(sdev->request_queue);
-		if (err)
-			return err;
+	err = blk_pre_runtime_suspend(sdev->request_queue);
+	if (err)
+		return err;
+	if (pm && pm->runtime_suspend)
 		err = pm->runtime_suspend(dev);
-		blk_post_runtime_suspend(sdev->request_queue, err);
-	}
+	blk_post_runtime_suspend(sdev->request_queue, err);
+
 	return err;
 }
 
@@ -248,11 +248,11 @@ static int sdev_runtime_resume(struct device *dev)
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int err = 0;
 
-	if (pm && pm->runtime_resume) {
-		blk_pre_runtime_resume(sdev->request_queue);
+	blk_pre_runtime_resume(sdev->request_queue);
+	if (pm && pm->runtime_resume)
 		err = pm->runtime_resume(dev);
-		blk_post_runtime_resume(sdev->request_queue, err);
-	}
+	blk_post_runtime_resume(sdev->request_queue, err);
+
 	return err;
 }
 
-- 
1.9.1



