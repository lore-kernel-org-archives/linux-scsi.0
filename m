From: Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH v2 6/7] scsi: pm: use runtime resume callback if available
Date: Tue, 24 Jul 2012 17:37:44 +0800
Message-ID: <1343122665-18711-7-git-send-email-aaron.lu@amd.com>
References: <1343122665-18711-1-git-send-email-aaron.lu@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343122665-18711-1-git-send-email-aaron.lu@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Lin Ming <minggr@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Wu <jeff.wu@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@amd.com>
List-Id: linux-scsi@vger.kernel.org

When runtime resume a scsi device, if the device's driver has
implemented runtime resume callback, use that instead of the resume
callback.

sr driver needs this to properly do different things for system resume
and runtime resume.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
---
V2:
Check if the resume callback is NULL before calling it as pointed by
Sergei Shtylyov.

 drivers/scsi/scsi_pm.c | 15 ++++++++++-----
 drivers/scsi/sr.c      | 21 +++++++++++++++++++++
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index a002fbf..717d2c1 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -34,14 +34,19 @@ static int scsi_dev_type_suspend(struct device *dev, pm_message_t msg)
 	return err;
 }
 
-static int scsi_dev_type_resume(struct device *dev)
+static int scsi_dev_type_resume(struct device *dev, bool runtime)
 {
 	struct device_driver *drv;
 	int err = 0;
+	int (*resume)(struct device *);
 
 	drv = dev->driver;
-	if (drv && drv->resume)
-		err = drv->resume(dev);
+	if (runtime && drv && drv->pm && drv->pm->runtime_resume)
+		resume = drv->pm->runtime_resume;
+	else
+		resume = drv ? drv->resume : NULL;
+	if (resume)
+		err = resume(dev);
 	scsi_device_resume(to_scsi_device(dev));
 	dev_dbg(dev, "scsi resume: %d\n", err);
 	return err;
@@ -84,7 +89,7 @@ static int scsi_bus_resume_common(struct device *dev)
 		 * Resume it on behalf of child.
 		 */
 		pm_runtime_get_sync(dev->parent);
-		err = scsi_dev_type_resume(dev);
+		err = scsi_dev_type_resume(dev, false);
 		pm_runtime_put_sync(dev->parent);
 	}
 
@@ -159,7 +164,7 @@ static int scsi_runtime_resume(struct device *dev)
 
 	dev_dbg(dev, "scsi_runtime_resume\n");
 	if (scsi_is_sdev_device(dev))
-		err = scsi_dev_type_resume(dev);
+		err = scsi_dev_type_resume(dev, true);
 
 	/* Insert hooks here for targets, hosts, and transport classes */
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index d6c0574..466ff8e 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -82,6 +82,11 @@ static int sr_remove(struct device *);
 static int sr_done(struct scsi_cmnd *);
 static int sr_suspend(struct device *dev, pm_message_t msg);
 static int sr_resume(struct device *dev);
+static int sr_runtime_resume(struct device *dev);
+
+static struct dev_pm_ops sr_pm_ops = {
+	.runtime_resume = sr_runtime_resume,
+};
 
 static struct scsi_driver sr_template = {
 	.owner			= THIS_MODULE,
@@ -91,6 +96,7 @@ static struct scsi_driver sr_template = {
 		.remove		= sr_remove,
 		.suspend	= sr_suspend,
 		.resume		= sr_resume,
+		.pm		= &sr_pm_ops,
 	},
 	.done			= sr_done,
 };
@@ -211,6 +217,21 @@ static int sr_suspend(struct device *dev, pm_message_t msg)
 
 static int sr_resume(struct device *dev)
 {
+	struct scsi_cd *cd = dev_get_drvdata(dev);
+
+	/*
+	 * If ODD is runtime suspended before system pm, unblock disk
+	 * events now since on system resume, we will fully resume it
+	 * and set its rumtime status to active.
+	 */
+	if (pm_runtime_suspended(dev))
+		disk_unblock_events(cd->disk);
+
+	return 0;
+}
+
+static int sr_runtime_resume(struct device *dev)
+{
 	struct scsi_cd *cd;
 	struct scsi_sense_hdr sshdr;
 
-- 
1.7.11.3
