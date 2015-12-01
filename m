From: Ken Xue <ken.xue@amd.com>
Subject: [PATCH 1/2]Revert "SCSI: Fix NULL pointer dereference in runtime PM"
Date: Tue, 1 Dec 2015 14:45:23 +0800
Message-ID: <1448952323.3603.17.camel@kxue-X58A-UD3R>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Xiangliang.Yu@amd.com, stern@rowland.harvard.edu, JBottomley@Odin.com, SPG_Linux_Kernel@amd.com, axboe@kernel.dk, michael.terry@canonical.com
List-Id: linux-scsi@vger.kernel.org

This reverts commit 49718f0fb8c9 ("SCSI: Fix NULL pointer dereference in
runtime PM")

The old commit may lead to a issue that blk_{pre|post}_runtime_suspend and
blk_{pre|post}_runtime_resume may not be called in pairs.

Take sr device as example, when sr device goes to runtime suspend, 
blk_{pre|post}_runtime_suspend will be called since sr device defined
pm->runtime_suspend. But blk_{pre|post}_runtime_resume will not be called
since sr device doesn't have pm->runtime_resume. so, sr device can not
resume correctly anymore.

More discussion can be found from below link.
http://marc.info/?l=linux-scsi&m=144163730531875&w=2

Signed-off-by: Ken Xue <Ken.Xue@amd.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Xiangliang Yu <Xiangliang.Yu@amd.com>
Cc: James E.J. Bottomley <JBottomley@odin.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Michael Terry <Michael.terry@canonical.com>
Cc: stable@vger.kernel.org

---
 drivers/scsi/scsi_pm.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

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
