From: Ken Xue <Ken.Xue@amd.com>
Subject: [PATCH 1/2]Revert "SCSI: Fix NULL pointer dereference in runtime PM"
Date: Thu, 10 Sep 2015 10:23:46 +0800
Message-ID: <1441851826.5845.105.camel@kxue-X58A-UD3R>
References: <1441782131.5845.73.camel@kxue-X58A-UD3R>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0078.outbound.protection.outlook.com ([157.56.111.78]:26945
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752666AbbIJC1p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Sep 2015 22:27:45 -0400
In-Reply-To: <1441782131.5845.73.camel@kxue-X58A-UD3R>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: Shane.Huang@amd.com, Xiangliang.Yu@amd.com, aaron.lu@intel.com, linux-scsi@vger.kernel.org, JBottomley@Odin.com, SPG_Linux_Kernel@amd.com, stable@vger.kernel.org

Revert "SCSI: Fix NULL pointer dereference in runtime PM"

This reverts commit 49718f0fb8c9 ("SCSI: Fix NULL pointer dereference in
runtime PM")

The old commit may lead to a issue that blk_{pre|post}_runtime_suspend and
blk_{pre|post}_runtime_resume can not be called in pairs.

Take sr device as example, when sr device goes to runtime suspend, 
blk_{pre|post}_runtime_suspend will be called since sr device defined
pm->runtime_suspend. But blk_{pre|post}_runtime_resume will not be called
since sr device doesn't have pm->runtime_resume. Then sr device can not
resume correctly anymore.

Signed-off-by: Ken Xue <Ken.Xue@amd.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
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



