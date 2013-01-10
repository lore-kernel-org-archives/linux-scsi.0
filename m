From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v12 6/9] libata: expose pm qos flags for ata device
Date: Thu, 10 Jan 2013 17:24:27 +0800
Message-ID: <1357809870-18816-7-git-send-email-aaron.lu@intel.com>
References: <1357809870-18816-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24143 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab3AJJY1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jan 2013 04:24:27 -0500
In-Reply-To: <1357809870-18816-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>

Expose pm qos flags to user space so that user has a chance to disable
ZPODD feature, if he/she has a broken platform or devices or simply does
not like this feature.

This flag is exposed to user space only for ZPODD devices.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-acpi.c | 3 +++
 1 file changed, 3 insertions(+)

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
-- 
1.7.11.7

