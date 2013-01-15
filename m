From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v13 6/9] libata: expose pm qos flags for ata device
Date: Tue, 15 Jan 2013 17:21:02 +0800
Message-ID: <1358241665-2156-7-git-send-email-aaron.lu@intel.com>
References: <1358241665-2156-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1358241665-2156-1-git-send-email-aaron.lu@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Expose pm qos flags to user space so that user has a chance to disable
ZPODD feature, if he/she has a broken platform or devices or simply does
not like this feature.

This flag is exposed to user space only for ZPODD devices.

Due to this flag, it is possible the ODD is ZP ready but we didn't power
it off. So the zp_ready flag will need to be cleared whenever we found
the ODD is not in ZP ready state. Previously, once zp_ready is set, the
ODD will always be powered off and the flag will be cleared in
post_poweron. But this is no longer the case now.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-acpi.c  | 3 +++
 drivers/ata/libata-zpodd.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 6f72c64..9709449 100644
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
+	if (zpodd_dev_enabled(dev))
+		dev_pm_qos_expose_flags(&dev->sdev->sdev_gendev, 0);
 }
 
 void ata_acpi_unbind(struct ata_device *dev)
diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index 1f5d52a..540b0b7 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -150,6 +150,7 @@ void zpodd_on_suspend(struct ata_device *dev)
 
 	if (!zpready(dev)) {
 		zpodd->zp_sampled = false;
+		zpodd->zp_ready = false;
 		return;
 	}
 
-- 
1.7.11.7

