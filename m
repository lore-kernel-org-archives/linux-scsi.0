From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v11 4/9] libata: move acpi notification code to zpodd
Date: Sun,  6 Jan 2013 10:48:24 +0800
Message-ID: <1357440509-28108-5-git-send-email-aaron.lu@intel.com>
References: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:4032 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889Ab3AFCs1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Jan 2013 21:48:27 -0500
In-Reply-To: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>

Since the ata acpi notification code introduced in commit
3bd46600a7a7e938c54df8cdbac9910668c7dfb0 is solely for ZPODD, and we
now have a dedicated place for it, move these code there.

And the ata_acpi_add_pm_notifier code is changed a little bit in that it
is now invoked when scsi device is not bound with ACPI yet, so the way
to get the acpi handle is different with the previous version. And the
ata_acpi_add/remove_pm_notifier is also simplified a little bit in that
it doesn't check if the acpi_device for the handle exists or not as the
odd_can_poweroff function already checked that.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-acpi.c  | 71 ----------------------------------------------
 drivers/ata/libata-zpodd.c | 33 +++++++++++++++++++++
 2 files changed, 33 insertions(+), 71 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 5aa7322..b4788dd 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -974,57 +974,6 @@ void ata_acpi_on_disable(struct ata_device *dev)
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
@@ -1057,7 +1006,6 @@ static void ata_acpi_unregister_power_resource(struct ata_device *dev)
 
 void ata_acpi_bind(struct ata_device *dev)
 {
-	ata_acpi_add_pm_notifier(dev);
 	ata_acpi_register_power_resource(dev);
 }
 
@@ -1065,7 +1013,6 @@ void ata_acpi_unbind(struct ata_device *dev)
 {
 	if (zpodd_dev_enabled(dev))
 		zpodd_exit(dev);
-	ata_acpi_remove_pm_notifier(dev);
 	ata_acpi_unregister_power_resource(dev);
 }
 
@@ -1107,9 +1054,6 @@ static int ata_acpi_bind_device(struct ata_port *ap, struct scsi_device *sdev,
 				acpi_handle *handle)
 {
 	struct ata_device *ata_dev;
-	acpi_status status;
-	struct acpi_device *acpi_dev;
-	struct acpi_device_power_state *states;
 
 	if (ap->flags & ATA_FLAG_ACPI_SATA) {
 		if (!sata_pmp_attached(ap))
@@ -1126,21 +1070,6 @@ static int ata_acpi_bind_device(struct ata_port *ap, struct scsi_device *sdev,
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
 
diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index 58bf891..c8c7b74 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -1,5 +1,7 @@
 #include <linux/libata.h>
 #include <linux/cdrom.h>
+#include <linux/pm_runtime.h>
+#include <scsi/scsi_device.h>
 
 #include "libata.h"
 
@@ -7,6 +9,9 @@ struct zpodd {
 	bool slot:1;
 	bool drawer:1;
 
+	/* The following bits are synchronized by PM core */
+	bool from_notify:1; /* resumed as a result of acpi notification */
+
 	struct ata_device *dev;
 };
 
@@ -80,6 +85,32 @@ static bool odd_can_poweroff(struct ata_device *ata_dev)
 	return acpi_device_can_poweroff(acpi_dev);
 }
 
+static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
+{
+	struct ata_device *ata_dev = context;
+	struct zpodd *zpodd = ata_dev->zpodd;
+	struct device *dev = &ata_dev->sdev->sdev_gendev;
+
+	if (event == ACPI_NOTIFY_DEVICE_WAKE && ata_dev &&
+			pm_runtime_suspended(dev)) {
+		zpodd->from_notify = true;
+		pm_runtime_resume(dev);
+	}
+}
+
+static void ata_acpi_add_pm_notifier(struct ata_device *dev)
+{
+	acpi_handle handle = ata_dev_acpi_handle(dev);
+	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+				    zpodd_wake_dev, dev);
+}
+
+static void ata_acpi_remove_pm_notifier(struct ata_device *dev)
+{
+	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->sdev->sdev_gendev);
+	acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY, zpodd_wake_dev);
+}
+
 void zpodd_init(struct ata_device *dev)
 {
 	int ret;
@@ -103,12 +134,14 @@ void zpodd_init(struct ata_device *dev)
 	else
 		zpodd->slot = true;
 
+	ata_acpi_add_pm_notifier(dev);
 	zpodd->dev = dev;
 	dev->zpodd = zpodd;
 }
 
 void zpodd_exit(struct ata_device *dev)
 {
+	ata_acpi_remove_pm_notifier(dev);
 	kfree(dev->zpodd);
 	dev->zpodd = NULL;
 }
-- 
1.7.11.7

