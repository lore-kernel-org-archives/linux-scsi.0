From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v8 03/11] ata: zpodd: identify and init ZPODD devices
Date: Mon, 29 Oct 2012 17:01:30 +0800
Message-ID: <1351501298-3716-4-git-send-email-aaron.lu@intel.com>
References: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45943 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758366Ab2J2JBv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2012 05:01:51 -0400
In-Reply-To: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Oliver Neukum <oliver@neukum.org>
Cc: Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

If the ODD supports device attention and the platform can runtime
power off it through ACPI, it means this ODD together with this platform
is ZPODD capable. For this case, zpodd_init is called and a new
structure is allocated for the device to store ZPODD related stuffs.

And the zpodd_dev_enabled function is used to test if ZPODD is currently
enabled for this ODD.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-acpi.c | 32 ++++++++++++++++++++++++++++++++
 drivers/ata/sata_zpodd.c  | 23 +++++++++++++++++++++++
 drivers/ata/sata_zpodd.h  | 24 ++++++++++++++++++++++++
 3 files changed, 79 insertions(+)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index fd9ecf7..53b2f10 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -19,6 +19,7 @@
 #include <linux/pm_runtime.h>
 #include <scsi/scsi_device.h>
 #include "libata.h"
+#include "sata_zpodd.h"
 
 #include <acpi/acpi_bus.h>
 
@@ -1051,14 +1052,45 @@ static void ata_acpi_unregister_power_resource(struct ata_device *dev)
 	acpi_power_resource_unregister_device(device, handle);
 }
 
+static bool ata_acpi_device_poweroff(struct ata_device *ata_dev)
+{
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_device_power_state *states;
+	struct acpi_device *acpi_dev;
+
+	handle = DEVICE_ACPI_HANDLE(&ata_dev->sdev->sdev_gendev);
+	if (!handle)
+		return false;
+
+	status = acpi_bus_get_device(handle, &acpi_dev);
+	if (ACPI_FAILURE(status))
+		return false;
+
+	/*
+	 * If firmware has _PS3 or _PR3 for this device,
+	 * it means this device can be runtime powered off
+	 */
+	states = acpi_dev->power.states;
+	if (states[ACPI_STATE_D3_HOT].flags.valid ||
+	    states[ACPI_STATE_D3_COLD].flags.explicit_set)
+		return true;
+	else
+		return false;
+}
+
 void ata_acpi_bind(struct ata_device *dev)
 {
 	ata_acpi_add_pm_notifier(dev);
 	ata_acpi_register_power_resource(dev);
+	if (dev->flags & ATA_DFLAG_DA && ata_acpi_device_poweroff(dev))
+		zpodd_init(dev);
 }
 
 void ata_acpi_unbind(struct ata_device *dev)
 {
+	if (zpodd_dev_enabled(dev))
+		zpodd_deinit(dev);
 	ata_acpi_remove_pm_notifier(dev);
 	ata_acpi_unregister_power_resource(dev);
 }
diff --git a/drivers/ata/sata_zpodd.c b/drivers/ata/sata_zpodd.c
index e69de29..b37db2f 100644
--- a/drivers/ata/sata_zpodd.c
+++ b/drivers/ata/sata_zpodd.c
@@ -0,0 +1,23 @@
+#include <linux/libata.h>
+
+struct zpodd {
+	struct ata_device *dev;
+};
+
+
+void zpodd_init(struct ata_device *dev)
+{
+	struct zpodd *zpodd;
+	zpodd = kzalloc(sizeof(struct zpodd), GFP_KERNEL);
+	if (!zpodd)
+		return;
+
+	zpodd->dev = dev;
+	dev->private_data = zpodd;
+}
+
+void zpodd_deinit(struct ata_device *dev)
+{
+	kfree(dev->private_data);
+	dev->private_data = NULL;
+}
diff --git a/drivers/ata/sata_zpodd.h b/drivers/ata/sata_zpodd.h
index e69de29..e320c6f 100644
--- a/drivers/ata/sata_zpodd.h
+++ b/drivers/ata/sata_zpodd.h
@@ -0,0 +1,24 @@
+#ifndef __SATA_ZPODD_H__
+#define __SATA_ZPODD_H__
+
+#include <linux/libata.h>
+
+#ifdef CONFIG_SATA_ZPODD
+void zpodd_init(struct ata_device *);
+void zpodd_deinit(struct ata_device *);
+
+static bool zpodd_dev_enabled(struct ata_device *dev)
+{
+	if (dev->flags & ATA_DFLAG_DA && dev->private_data)
+		return true;
+	else
+		return false;
+}
+
+#else
+static inline void zpodd_init(struct ata_device *dev) {}
+static inline void zpodd_deinit(struct ata_device *dev) {}
+static inline bool zpodd_dev_enabled(struct ata_device *dev) { return false; }
+#endif
+
+#endif
-- 
1.7.12.4

