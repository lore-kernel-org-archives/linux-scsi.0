From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v12 3/9] libata: move acpi notification code to zpodd
Date: Thu, 10 Jan 2013 17:24:24 +0800
Message-ID: <1357809870-18816-4-git-send-email-aaron.lu@intel.com>
References: <1357809870-18816-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:4760 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab3AJJYT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jan 2013 04:24:19 -0500
In-Reply-To: <1357809870-18816-1-git-send-email-aaron.lu@intel.com>
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
 drivers/ata/libata-zpodd.c | 34 ++++++++++++++++++++++
 2 files changed, 34 insertions(+), 71 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index ef01ac0..446b4e7 100644
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
@@ -1057,13 +1006,11 @@ static void ata_acpi_unregister_power_resource(struct ata_device *dev)
 
 void ata_acpi_bind(struct ata_device *dev)
 {
-	ata_acpi_add_pm_notifier(dev);
 	ata_acpi_register_power_resource(dev);
 }
 
 void ata_acpi_unbind(struct ata_device *dev)
 {
-	ata_acpi_remove_pm_notifier(dev);
 	ata_acpi_unregister_power_resource(dev);
 }
 
@@ -1105,9 +1052,6 @@ static int ata_acpi_bind_device(struct ata_port *ap, struct scsi_device *sdev,
 				acpi_handle *handle)
 {
 	struct ata_device *ata_dev;
-	acpi_status status;
-	struct acpi_device *acpi_dev;
-	struct acpi_device_power_state *states;
 
 	if (ap->flags & ATA_FLAG_ACPI_SATA) {
 		if (!sata_pmp_attached(ap))
@@ -1124,21 +1068,6 @@ static int ata_acpi_bind_device(struct ata_port *ap, struct scsi_device *sdev,
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
index 27eed2f..9a0d90d 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -1,5 +1,7 @@
 #include <linux/libata.h>
 #include <linux/cdrom.h>
+#include <linux/pm_runtime.h>
+#include <scsi/scsi_device.h>
 
 #include "libata.h"
 
@@ -12,6 +14,10 @@ enum odd_mech_type {
 struct zpodd {
 	enum odd_mech_type	mech_type; /* init during probe, RO afterwards */
 	struct ata_device	*dev;
+
+	/* The following fields are synchronized by PM core. */
+	bool			from_notify; /* resumed as a result of
+					      * acpi wake notification */
 };
 
 /* Per the spec, only slot type and drawer type ODD can be supported */
@@ -68,6 +74,32 @@ static bool odd_can_poweroff(struct ata_device *ata_dev)
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
 	enum odd_mech_type mech_type;
@@ -89,12 +121,14 @@ void zpodd_init(struct ata_device *dev)
 
 	zpodd->mech_type = mech_type;
 
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

