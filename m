From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v4 4/5] pm: use callbacks from dev_pm_ops for scsi devices
Date: Fri,  9 Nov 2012 15:27:54 +0800
Message-ID: <1352446075-1814-5-git-send-email-aaron.lu@intel.com>
References: <1352446075-1814-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34949 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab2KIH2W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Nov 2012 02:28:22 -0500
In-Reply-To: <1352446075-1814-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

Use of pm_message_t is deprecated and device driver is not supposed
to use that. This patch migrates the SCSI bus level pm callbacks
to call device's pm callbacks defined in its driver's dev_pm_ops.

This is achieved by finding out which device pm callback should be used
in bus callback function, and then pass that callback function pointer
as a param to the scsi_bus_{suspend,resume}_common routine, which will
further pass that callback to scsi_dev_type_{suspend,resume} after
proper handling.

The special case for freeze in scsi_bus_suspend_common is not necessary
since there is no high level SCSI driver has implemented freeze, so no
need to runtime resume the device if it is in runtime suspended state
for system freeze, just return like the system suspend/hibernate case.

Since only sd has implemented drv->suspend/drv->resume, and I'll update
sd driver to use the new callbacks in the following patch, there is no
need to fallback to call drv->suspend/drv->resume if dev_pm_ops is NULL.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/scsi/scsi_pm.c | 86 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 53 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 9923b26..8f6b12c 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -16,16 +16,14 @@
 
 #include "scsi_priv.h"
 
-static int scsi_dev_type_suspend(struct device *dev, pm_message_t msg)
+static int scsi_dev_type_suspend(struct device *dev, int (*cb)(struct device *))
 {
-	struct device_driver *drv;
 	int err;
 
 	err = scsi_device_quiesce(to_scsi_device(dev));
 	if (err == 0) {
-		drv = dev->driver;
-		if (drv && drv->suspend) {
-			err = drv->suspend(dev, msg);
+		if (cb) {
+			err = cb(dev);
 			if (err)
 				scsi_device_resume(to_scsi_device(dev));
 		}
@@ -34,14 +32,12 @@ static int scsi_dev_type_suspend(struct device *dev, pm_message_t msg)
 	return err;
 }
 
-static int scsi_dev_type_resume(struct device *dev)
+static int scsi_dev_type_resume(struct device *dev, int (*cb)(struct device *))
 {
-	struct device_driver *drv;
 	int err = 0;
 
-	drv = dev->driver;
-	if (drv && drv->resume)
-		err = drv->resume(dev);
+	if (cb)
+		err = cb(dev);
 	scsi_device_resume(to_scsi_device(dev));
 	dev_dbg(dev, "scsi resume: %d\n", err);
 	return err;
@@ -49,35 +45,33 @@ static int scsi_dev_type_resume(struct device *dev)
 
 #ifdef CONFIG_PM_SLEEP
 
-static int scsi_bus_suspend_common(struct device *dev, pm_message_t msg)
+static int
+scsi_bus_suspend_common(struct device *dev, int (*cb)(struct device *))
 {
 	int err = 0;
 
 	if (scsi_is_sdev_device(dev)) {
 		/*
-		 * sd is the only high-level SCSI driver to implement runtime
-		 * PM, and sd treats runtime suspend, system suspend, and
-		 * system hibernate identically (but not system freeze).
+		 * All the high-level SCSI drivers that implement runtime
+		 * PM treat runtime suspend, system suspend, and system
+		 * hibernate identically.
 		 */
-		if (pm_runtime_suspended(dev)) {
-			if (msg.event == PM_EVENT_SUSPEND ||
-			    msg.event == PM_EVENT_HIBERNATE)
-				return 0;	/* already suspended */
+		if (pm_runtime_suspended(dev))
+			return 0;
 
-			/* wake up device so that FREEZE will succeed */
-			pm_runtime_resume(dev);
-		}
-		err = scsi_dev_type_suspend(dev, msg);
+		err = scsi_dev_type_suspend(dev, cb);
 	}
+
 	return err;
 }
 
-static int scsi_bus_resume_common(struct device *dev)
+static int
+scsi_bus_resume_common(struct device *dev, int (*cb)(struct device *))
 {
 	int err = 0;
 
 	if (scsi_is_sdev_device(dev))
-		err = scsi_dev_type_resume(dev);
+		err = scsi_dev_type_resume(dev, cb);
 
 	if (err == 0) {
 		pm_runtime_disable(dev);
@@ -102,26 +96,49 @@ static int scsi_bus_prepare(struct device *dev)
 
 static int scsi_bus_suspend(struct device *dev)
 {
-	return scsi_bus_suspend_common(dev, PMSG_SUSPEND);
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	return scsi_bus_suspend_common(dev, pm ? pm->suspend : NULL);
+}
+
+static int scsi_bus_resume(struct device *dev)
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	return scsi_bus_resume_common(dev, pm ? pm->resume : NULL);
 }
 
 static int scsi_bus_freeze(struct device *dev)
 {
-	return scsi_bus_suspend_common(dev, PMSG_FREEZE);
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	return scsi_bus_suspend_common(dev, pm ? pm->freeze : NULL);
+}
+
+static int scsi_bus_thaw(struct device *dev)
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	return scsi_bus_resume_common(dev, pm ? pm->thaw : NULL);
 }
 
 static int scsi_bus_poweroff(struct device *dev)
 {
-	return scsi_bus_suspend_common(dev, PMSG_HIBERNATE);
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	return scsi_bus_suspend_common(dev, pm ? pm->poweroff : NULL);
+}
+
+static int scsi_bus_restore(struct device *dev)
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	return scsi_bus_resume_common(dev, pm ? pm->restore : NULL);
 }
 
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
 
@@ -130,10 +147,12 @@ static int scsi_bus_poweroff(struct device *dev)
 static int scsi_runtime_suspend(struct device *dev)
 {
 	int err = 0;
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
 	dev_dbg(dev, "scsi_runtime_suspend\n");
 	if (scsi_is_sdev_device(dev)) {
-		err = scsi_dev_type_suspend(dev, PMSG_AUTO_SUSPEND);
+		err = scsi_dev_type_suspend(dev,
+				pm ? pm->runtime_suspend : NULL);
 		if (err == -EAGAIN)
 			pm_schedule_suspend(dev, jiffies_to_msecs(
 				round_jiffies_up_relative(HZ/10)));
@@ -147,10 +166,11 @@ static int scsi_runtime_suspend(struct device *dev)
 static int scsi_runtime_resume(struct device *dev)
 {
 	int err = 0;
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
 	dev_dbg(dev, "scsi_runtime_resume\n");
 	if (scsi_is_sdev_device(dev))
-		err = scsi_dev_type_resume(dev);
+		err = scsi_dev_type_resume(dev, pm ? pm->runtime_resume : NULL);
 
 	/* Insert hooks here for targets, hosts, and transport classes */
 
@@ -229,11 +249,11 @@ void scsi_autopm_put_host(struct Scsi_Host *shost)
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

