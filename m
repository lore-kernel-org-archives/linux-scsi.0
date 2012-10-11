From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v2 4/5] pm: use callbacks from dev_pm_ops for scsi devices
Date: Thu, 11 Oct 2012 13:08:10 +0800
Message-ID: <1349932091-6856-5-git-send-email-aaron.lu@intel.com>
References: <1349932091-6856-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:3751 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620Ab2JKFIq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2012 01:08:46 -0400
In-Reply-To: <1349932091-6856-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

Use of pm_message_t is deprecated and device driver is not supposed
to use that. This patch tries to migrate the SCSI bus level pm callbacks
to call device's pm callbacks defined in its driver's dev_pm_ops.

This is achieved by finding out which device pm callback should be used
in bus callback function, and then pass that callback function pointer
as a param to scsi_dev_type_suspend/resume.

scsi_bus_suspend_common is gone, as there is a logic to check if the
device is already runtime suspended and if so, based on the system pm
operation we are going through now by the pm message, different things
will be done(do nothing on suspend/hibernate, runtime resume the device
on freeze). With the deleting of the pm message param now, this logic
can no longer be done there, but in individual bus callbacks like
suspend/poweroff/freeze. And this makes the scsi_bus_suspend_common
function useless and thus deleted.

Since only sd has implemented drv->suspend/drv->resume, and I'll update
sd driver to use the new callbacks in the following patch, there is no
need to fallback to call drv->suspend/drv->resume if dev_pm_ops is NULL.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/scsi_pm.c | 126 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 82 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 9923b26..aa97dca 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -16,16 +16,16 @@
 
 #include "scsi_priv.h"
 
-static int scsi_dev_type_suspend(struct device *dev, pm_message_t msg)
+typedef int (*pm_callback_t)(struct device *);
+
+static int scsi_dev_type_suspend(struct device *dev, pm_callback_t callback)
 {
-	struct device_driver *drv;
 	int err;
 
 	err = scsi_device_quiesce(to_scsi_device(dev));
 	if (err == 0) {
-		drv = dev->driver;
-		if (drv && drv->suspend) {
-			err = drv->suspend(dev, msg);
+		if (callback) {
+			err = callback(dev);
 			if (err)
 				scsi_device_resume(to_scsi_device(dev));
 		}
@@ -34,14 +34,12 @@ static int scsi_dev_type_suspend(struct device *dev, pm_message_t msg)
 	return err;
 }
 
-static int scsi_dev_type_resume(struct device *dev)
+static int scsi_dev_type_resume(struct device *dev, pm_callback_t callback)
 {
-	struct device_driver *drv;
 	int err = 0;
 
-	drv = dev->driver;
-	if (drv && drv->resume)
-		err = drv->resume(dev);
+	if (callback)
+		err = callback(dev);
 	scsi_device_resume(to_scsi_device(dev));
 	dev_dbg(dev, "scsi resume: %d\n", err);
 	return err;
@@ -49,35 +47,12 @@ static int scsi_dev_type_resume(struct device *dev)
 
 #ifdef CONFIG_PM_SLEEP
 
-static int scsi_bus_suspend_common(struct device *dev, pm_message_t msg)
-{
-	int err = 0;
-
-	if (scsi_is_sdev_device(dev)) {
-		/*
-		 * sd is the only high-level SCSI driver to implement runtime
-		 * PM, and sd treats runtime suspend, system suspend, and
-		 * system hibernate identically (but not system freeze).
-		 */
-		if (pm_runtime_suspended(dev)) {
-			if (msg.event == PM_EVENT_SUSPEND ||
-			    msg.event == PM_EVENT_HIBERNATE)
-				return 0;	/* already suspended */
-
-			/* wake up device so that FREEZE will succeed */
-			pm_runtime_resume(dev);
-		}
-		err = scsi_dev_type_suspend(dev, msg);
-	}
-	return err;
-}
-
-static int scsi_bus_resume_common(struct device *dev)
+static int scsi_bus_resume_common(struct device *dev, pm_callback_t callback)
 {
 	int err = 0;
 
 	if (scsi_is_sdev_device(dev))
-		err = scsi_dev_type_resume(dev);
+		err = scsi_dev_type_resume(dev, callback);
 
 	if (err == 0) {
 		pm_runtime_disable(dev);
@@ -102,26 +77,87 @@ static int scsi_bus_prepare(struct device *dev)
 
 static int scsi_bus_suspend(struct device *dev)
 {
-	return scsi_bus_suspend_common(dev, PMSG_SUSPEND);
+	int err = 0;
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+
+	if (scsi_is_sdev_device(dev)) {
+		/*
+		 * sd is the only high-level SCSI driver to implement runtime
+		 * PM, and sd treats runtime suspend, system suspend, and
+		 * system hibernate identically.
+		 */
+		if (pm_runtime_suspended(dev))
+			return 0;
+
+		err = scsi_dev_type_suspend(dev, pm ? pm->suspend : NULL);
+	}
+
+	return err;
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
+	int err = 0;
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+
+	if (scsi_is_sdev_device(dev)) {
+		/* wake up device so that FREEZE will succeed */
+		if (pm_runtime_suspended(dev))
+			pm_runtime_resume(dev);
+
+		err = scsi_dev_type_suspend(dev, pm ? pm->freeze : NULL);
+	}
+
+	return err;
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
+	int err = 0;
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+
+	if (scsi_is_sdev_device(dev)) {
+		/*
+		 * sd is the only high-level SCSI driver to implement runtime
+		 * PM, and sd treats runtime suspend, system suspend, and
+		 * system hibernate identically.
+		 */
+		if (pm_runtime_suspended(dev))
+			return 0;
+
+		err = scsi_dev_type_suspend(dev, pm ? pm->poweroff : NULL);
+	}
+
+	return err;
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
 
@@ -130,10 +166,11 @@ static int scsi_bus_poweroff(struct device *dev)
 static int scsi_runtime_suspend(struct device *dev)
 {
 	int err = 0;
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
 	dev_dbg(dev, "scsi_runtime_suspend\n");
 	if (scsi_is_sdev_device(dev)) {
-		err = scsi_dev_type_suspend(dev, PMSG_AUTO_SUSPEND);
+		err = scsi_dev_type_suspend(dev, pm ? pm->runtime_suspend : NULL);
 		if (err == -EAGAIN)
 			pm_schedule_suspend(dev, jiffies_to_msecs(
 				round_jiffies_up_relative(HZ/10)));
@@ -147,10 +184,11 @@ static int scsi_runtime_suspend(struct device *dev)
 static int scsi_runtime_resume(struct device *dev)
 {
 	int err = 0;
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
 	dev_dbg(dev, "scsi_runtime_resume\n");
 	if (scsi_is_sdev_device(dev))
-		err = scsi_dev_type_resume(dev);
+		err = scsi_dev_type_resume(dev, pm ? pm->runtime_resume : NULL);
 
 	/* Insert hooks here for targets, hosts, and transport classes */
 
@@ -229,11 +267,11 @@ void scsi_autopm_put_host(struct Scsi_Host *shost)
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

