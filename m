From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v11 7/9] libata: expose pm qos flags for ata device
Date: Sun,  6 Jan 2013 10:48:27 +0800
Message-ID: <1357440509-28108-8-git-send-email-aaron.lu@intel.com>
References: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

Expose pm qos flags to user space so that user has a chance to disable
pm features like power off, if he/she has a broken platform or devices
or simply does not like this pm feature.

This flag is exposed to user space only for ata device or atapi device
that is zero power capable. For normal atapi device, it will never be
powered off.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-acpi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index e832bf6..5b67be3 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -17,6 +17,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/pm_qos.h>
 #include <scsi/scsi_device.h>
 #include "libata.h"
 
@@ -1022,6 +1023,8 @@ static void ata_acpi_unregister_power_resource(struct ata_device *dev)
 void ata_acpi_bind(struct ata_device *dev)
 {
 	ata_acpi_register_power_resource(dev);
+	if (dev->class == ATA_DEV_ATA || zpodd_dev_enabled(dev))
+		dev_pm_qos_expose_flags(&dev->sdev->sdev_gendev, 0);
 }
 
 void ata_acpi_unbind(struct ata_device *dev)
-- 
1.7.11.7

