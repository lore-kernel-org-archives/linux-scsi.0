From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 1/2] [SCSI] pm: use callbacks from dev_pm_ops for scsi devices
Date: Wed, 10 Oct 2012 15:28:05 +0800
Message-ID: <1349854086-2502-2-git-send-email-aaron.lu@intel.com>
References: <1349854086-2502-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:38350 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab2JJH2e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2012 03:28:34 -0400
In-Reply-To: <1349854086-2502-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

Use of pm_message_t is deprecated and device driver is not supposed
to use that. This patch tries to migrate the SCSI bus level pm callbacks
to call device's pm callbacks defined in its driver's dev_pm_ops.

NO logic changes in scsi_pm.c, a new function called run_dev_callback is
added, which will choose the proper callback for the device based on the
mesg param passed in and then call that chosen callback function with
the help of pm generic function APIs. So run_dev_callback will be used
to replace the previous drv->suspend/drv->resume call.

Since only sd has implemented drv->suspend/drv->resume, and I'll update
sd driver to use the new callbacks in the following patch, there is no
need to fallback to call drv->suspend/drv->resume if dev_pm_ops is NULL.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/scsi_pm.c | 85 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 66 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index dc0ad85..aeb151e 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -16,32 +16,62 @@
 
 #include "scsi_priv.h"
 
+static int run_dev_callback(struct device *dev, pm_message_t mesg)
+{
+	int ret;
+
+	switch (mesg.event) {
+		case PM_EVENT_SUSPEND:
+			ret = pm_generic_suspend(dev);
+			break;
+		case PM_EVENT_RESUME:
+			ret = pm_generic_resume(dev);
+			break;
+		case PM_EVENT_FREEZE:
+			ret = pm_generic_freeze(dev);
+			break;
+		case PM_EVENT_THAW:
+			ret = pm_generic_thaw(dev);
+			break;
+		case PM_EVENT_HIBERNATE:
+			ret = pm_generic_poweroff(dev);
+			break;
+		case PM_EVENT_RESTORE:
+			ret = pm_generic_restore(dev);
+			break;
+		case PM_EVENT_AUTO_SUSPEND:
+			ret = pm_generic_runtime_suspend(dev);
+			break;
+		case PM_EVENT_AUTO_RESUME:
+			ret = pm_generic_runtime_resume(dev);
+			break;
+		default:
+			ret = -1;
+			break;
+	}
+
+	return ret;
+}
+
 static int scsi_dev_type_suspend(struct device *dev, pm_message_t msg)
 {
-	struct device_driver *drv;
 	int err;
 
 	err = scsi_device_quiesce(to_scsi_device(dev));
 	if (err == 0) {
-		drv = dev->driver;
-		if (drv && drv->suspend) {
-			err = drv->suspend(dev, msg);
-			if (err)
-				scsi_device_resume(to_scsi_device(dev));
-		}
+		err = run_dev_callback(dev, msg);
+		if (err)
+			scsi_device_resume(to_scsi_device(dev));
 	}
 	dev_dbg(dev, "scsi suspend: %d\n", err);
 	return err;
 }
 
-static int scsi_dev_type_resume(struct device *dev)
+static int scsi_dev_type_resume(struct device *dev, pm_message_t mesg)
 {
-	struct device_driver *drv;
 	int err = 0;
 
-	drv = dev->driver;
-	if (drv && drv->resume)
-		err = drv->resume(dev);
+	err = run_dev_callback(dev, mesg);
 	scsi_device_resume(to_scsi_device(dev));
 	dev_dbg(dev, "scsi resume: %d\n", err);
 	return err;
@@ -72,7 +102,7 @@ static int scsi_bus_suspend_common(struct device *dev, pm_message_t msg)
 	return err;
 }
 
-static int scsi_bus_resume_common(struct device *dev)
+static int scsi_bus_resume_common(struct device *dev, pm_message_t mesg)
 {
 	int err = 0;
 
@@ -85,7 +115,7 @@ static int scsi_bus_resume_common(struct device *dev)
 	pm_runtime_get_sync(dev->parent);
 
 	if (scsi_is_sdev_device(dev))
-		err = scsi_dev_type_resume(dev);
+		err = scsi_dev_type_resume(dev, mesg);
 	if (err == 0) {
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
@@ -115,23 +145,40 @@ static int scsi_bus_suspend(struct device *dev)
 	return scsi_bus_suspend_common(dev, PMSG_SUSPEND);
 }
 
+static int scsi_bus_resume(struct device *dev)
+{
+	return scsi_bus_resume_common(dev, PMSG_RESUME);
+}
+
 static int scsi_bus_freeze(struct device *dev)
 {
 	return scsi_bus_suspend_common(dev, PMSG_FREEZE);
 }
 
+static int scsi_bus_thaw(struct device *dev)
+{
+	return scsi_bus_resume_common(dev, PMSG_THAW);
+}
+
 static int scsi_bus_poweroff(struct device *dev)
 {
 	return scsi_bus_suspend_common(dev, PMSG_HIBERNATE);
 }
 
+static int scsi_bus_restore(struct device *dev)
+{
+	return scsi_bus_resume_common(dev, PMSG_RESTORE);
+}
+
 #else /* CONFIG_PM_SLEEP */
 
-#define scsi_bus_resume_common		NULL
 #define scsi_bus_prepare		NULL
 #define scsi_bus_suspend		NULL
+#define scsi_bus_resume			NULL
 #define scsi_bus_freeze			NULL
+#define scsi_bus_thaw			NULL
 #define scsi_bus_poweroff		NULL
+#define scsi_bus_restore		NULL
 
 #endif /* CONFIG_PM_SLEEP */
 
@@ -160,7 +207,7 @@ static int scsi_runtime_resume(struct device *dev)
 
 	dev_dbg(dev, "scsi_runtime_resume\n");
 	if (scsi_is_sdev_device(dev))
-		err = scsi_dev_type_resume(dev);
+		err = scsi_dev_type_resume(dev, PMSG_AUTO_RESUME);
 
 	/* Insert hooks here for targets, hosts, and transport classes */
 
@@ -239,11 +286,11 @@ void scsi_autopm_put_host(struct Scsi_Host *shost)
 const struct dev_pm_ops scsi_bus_pm_ops = {
 	.prepare =		scsi_bus_prepare,
 	.suspend =		scsi_bus_suspend,
-	.resume =		scsi_bus_resume_common,
+	.resume =		scsi_bus_resume,
 	.freeze =		scsi_bus_freeze,
-	.thaw =			scsi_bus_resume_common,
+	.thaw =			scsi_bus_thaw,
 	.poweroff =		scsi_bus_poweroff,
-	.restore =		scsi_bus_resume_common,
+	.restore =		scsi_bus_restore,
 	.runtime_suspend =	scsi_runtime_suspend,
 	.runtime_resume =	scsi_runtime_resume,
 	.runtime_idle =		scsi_runtime_idle,
-- 
1.7.12.21.g871e293

