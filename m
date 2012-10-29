From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v8 04/11] libata: acpi: move acpi notification code to sata_zpodd
Date: Mon, 29 Oct 2012 17:01:31 +0800
Message-ID: <1351501298-3716-5-git-send-email-aaron.lu@intel.com>
References: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45943 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758395Ab2J2JBy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2012 05:01:54 -0400
In-Reply-To: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Oliver Neukum <oliver@neukum.org>
Cc: Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

Since the ata acpi notification code introduced in commit
3bd46600a7a7e938c54df8cdbac9910668c7dfb0 is solely for zero power ODD,
and we now have a dedicated place for ZPODD, move these code there.

And the add/remove_pm_notifier code is simplified a little bit that it
does not check things like if the handle is NULL and if a corresponding
acpi_device is there for the handle as they are guaranteed by the
ata_acpi_device_poweroff already.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-acpi.c | 71 -----------------------------------------------
 drivers/ata/sata_zpodd.c  | 32 +++++++++++++++++++++
 2 files changed, 32 insertions(+), 71 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 53b2f10..3167fc2 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -971,57 +971,6 @@ void ata_acpi_on_disable(struct ata_device *dev)
 	ata_acpi_clear_gtf(dev);
 }
 
-static void ata_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
-{
-	struct ata_device *ata_dev = context;
-
-	if (event == ACPI_NOTIFY_DEVICE_WAKE && ata_dev &&
-			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev))
-		scsi_autopm_get_device(ata_dev->sdev);
-}
-
-static void ata_acpi_add_pm_notifier(struct ata_device *dev)
-{
-	struct acpi_device *acpi_dev;
-	acpi_handle handle;
-	acpi_status status;
-
-	handle = ata_dev_acpi_handle(dev);
-	if (!handle)
-		return;
-
-	status = acpi_bus_get_device(handle, &acpi_dev);
-	if (ACPI_FAILURE(status))
-		return;
-
-	if (dev->sdev->can_power_off) {
-		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-			ata_acpi_wake_dev, dev);
-		device_set_run_wake(&dev->sdev->sdev_gendev, true);
-	}
-}
-
-static void ata_acpi_remove_pm_notifier(struct ata_device *dev)
-{
-	struct acpi_device *acpi_dev;
-	acpi_handle handle;
-	acpi_status status;
-
-	handle = ata_dev_acpi_handle(dev);
-	if (!handle)
-		return;
-
-	status = acpi_bus_get_device(handle, &acpi_dev);
-	if (ACPI_FAILURE(status))
-		return;
-
-	if (dev->sdev->can_power_off) {
-		device_set_run_wake(&dev->sdev->sdev_gendev, false);
-		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-			ata_acpi_wake_dev);
-	}
-}
-
 static void ata_acpi_register_power_resource(struct ata_device *dev)
 {
 	struct scsi_device *sdev = dev->sdev;
@@ -1081,7 +1030,6 @@ static bool ata_acpi_device_poweroff(struct ata_device *ata_dev)
 
 void ata_acpi_bind(struct ata_device *dev)
 {
-	ata_acpi_add_pm_notifier(dev);
 	ata_acpi_register_power_resource(dev);
 	if (dev->flags & ATA_DFLAG_DA && ata_acpi_device_poweroff(dev))
 		zpodd_init(dev);
@@ -1091,7 +1039,6 @@ void ata_acpi_unbind(struct ata_device *dev)
 {
 	if (zpodd_dev_enabled(dev))
 		zpodd_deinit(dev);
-	ata_acpi_remove_pm_notifier(dev);
 	ata_acpi_unregister_power_resource(dev);
 }
 
@@ -1133,9 +1080,6 @@ static int ata_acpi_bind_device(struct ata_port *ap, struct scsi_device *sdev,
 				acpi_handle *handle)
 {
 	struct ata_device *ata_dev;
-	acpi_status status;
-	struct acpi_device *acpi_dev;
-	struct acpi_device_power_state *states;
 
 	if (ap->flags & ATA_FLAG_ACPI_SATA)
 		ata_dev = &ap->link.device[sdev->channel];
@@ -1147,21 +1091,6 @@ static int ata_acpi_bind_device(struct ata_port *ap, struct scsi_device *sdev,
 	if (!*handle)
 		return -ENODEV;
 
-	status = acpi_bus_get_device(*handle, &acpi_dev);
-	if (ACPI_FAILURE(status))
-		return 0;
-
-	/*
-	 * If firmware has _PS3 or _PR3 for this device,
-	 * and this ata ODD device support device attention,
-	 * it means this device can be powered off
-	 */
-	states = acpi_dev->power.states;
-	if ((states[ACPI_STATE_D3_HOT].flags.valid ||
-			states[ACPI_STATE_D3_COLD].flags.explicit_set) &&
-			ata_dev->flags & ATA_DFLAG_DA)
-		sdev->can_power_off = 1;
-
 	return 0;
 }
 
diff --git a/drivers/ata/sata_zpodd.c b/drivers/ata/sata_zpodd.c
index b37db2f..009b1e4 100644
--- a/drivers/ata/sata_zpodd.c
+++ b/drivers/ata/sata_zpodd.c
@@ -1,9 +1,39 @@
 #include <linux/libata.h>
+#include <linux/pm_runtime.h>
+#include <scsi/scsi_device.h>
 
 struct zpodd {
+	bool from_notify:1;	/* resumed as a result of acpi notification */
+
 	struct ata_device *dev;
 };
 
+static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
+{
+	struct ata_device *ata_dev = context;
+	struct zpodd *zpodd = ata_dev->private_data;
+	struct device *dev = &ata_dev->sdev->sdev_gendev;
+
+	if (event == ACPI_NOTIFY_DEVICE_WAKE && pm_runtime_suspended(dev)) {
+		zpodd->from_notify = true;
+		pm_runtime_resume(dev);
+	}
+}
+
+static void zpodd_acpi_add_pm_notifier(struct ata_device *dev)
+{
+	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->sdev->sdev_gendev);
+	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+				    zpodd_wake_dev, dev);
+	device_set_run_wake(&dev->sdev->sdev_gendev, true);
+}
+
+static void zpodd_acpi_remove_pm_notifier(struct ata_device *dev)
+{
+	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->sdev->sdev_gendev);
+	device_set_run_wake(&dev->sdev->sdev_gendev, false);
+	acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY, zpodd_wake_dev);
+}
 
 void zpodd_init(struct ata_device *dev)
 {
@@ -12,12 +42,14 @@ void zpodd_init(struct ata_device *dev)
 	if (!zpodd)
 		return;
 
+	zpodd_acpi_add_pm_notifier(dev);
 	zpodd->dev = dev;
 	dev->private_data = zpodd;
 }
 
 void zpodd_deinit(struct ata_device *dev)
 {
+	zpodd_acpi_remove_pm_notifier(dev);
 	kfree(dev->private_data);
 	dev->private_data = NULL;
 }
-- 
1.7.12.4

