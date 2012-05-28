From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v4 07/13] libata-acpi: register/unregister device to/from power resource
Date: Mon, 28 May 2012 13:08:34 +0800
Message-ID: <1338181720-4149-8-git-send-email-ming.m.lin@intel.com>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, David Woodhouse <David.Woodhouse@intel.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/power.c      |    2 ++
 drivers/ata/libata-acpi.c |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 0500f71..d21d1a1 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -390,6 +390,7 @@ void acpi_power_resource_unregister_device(struct device *dev, acpi_handle handl
 		__acpi_power_resource_unregister_device(dev,
 			list->handles[i]);
 }
+EXPORT_SYMBOL_GPL(acpi_power_resource_unregister_device);
 
 static int __acpi_power_resource_register_device(
 	struct acpi_power_managed_device *powered_device, acpi_handle handle)
@@ -460,6 +461,7 @@ int acpi_power_resource_register_device(struct device *dev, acpi_handle handle)
 	printk(KERN_WARNING PREFIX "Invalid Power Resource to register!");
 	return -ENODEV;
 }
+EXPORT_SYMBOL_GPL(acpi_power_resource_register_device);
 
 /**
  * acpi_device_sleep_wake - execute _DSW (Device Sleep Wake) or (deprecated in
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 23c0d3b..5431f1d 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -1014,14 +1014,46 @@ static void ata_acpi_remove_pm_notifier(struct ata_device *dev)
 	}
 }
 
+static void ata_acpi_register_power_resource(struct ata_device *dev)
+{
+	struct scsi_device *sdev = dev->sdev;
+	acpi_handle handle;
+	struct device *device;
+
+	handle = ata_dev_acpi_handle(dev);
+	if (!handle)
+		return;
+
+	device = &sdev->sdev_gendev;
+
+	acpi_power_resource_register_device(device, handle);
+}
+
+static void ata_acpi_unregister_power_resource(struct ata_device *dev)
+{
+	struct scsi_device *sdev = dev->sdev;
+	acpi_handle handle;
+	struct device *device;
+
+	handle = ata_dev_acpi_handle(dev);
+	if (!handle)
+		return;
+
+	device = &sdev->sdev_gendev;
+
+	acpi_power_resource_unregister_device(device, handle);
+}
+
 void ata_acpi_bind(struct ata_device *dev)
 {
 	ata_acpi_add_pm_notifier(dev);
+	ata_acpi_register_power_resource(dev);
 }
 
 void ata_acpi_unbind(struct ata_device *dev)
 {
 	ata_acpi_remove_pm_notifier(dev);
+	ata_acpi_unregister_power_resource(dev);
 }
 
 static int is_pci_ata(struct device *dev)
-- 
1.7.2.5
