From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v9 10/10] ata: expose pm qos flags to user space for ata device
Date: Fri,  9 Nov 2012 14:52:02 +0800
Message-ID: <1352443922-13734-11-git-send-email-aaron.lu@intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

Expose pm qos flags to user space so that user has a chance to disable
pm features like power off, if he/she has a broken platform or devices
or simply does not like this pm feature.

This flag is exposed to user space only for ata device or atapi device
that is zero power capable. For normal atapi device, it will never be
powered off.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-acpi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 91f3405..3984290 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -1031,6 +1031,8 @@ void ata_acpi_bind(struct ata_device *dev)
 	ata_acpi_register_power_resource(dev);
 	dev_pm_qos_add_request(&dev->sdev->sdev_gendev, &dev->poweroff_req,
 				DEV_PM_QOS_FLAGS, value);
+	if (dev->class == ATA_DEV_ATA || zpodd_dev_enabled(dev))
+		dev_pm_qos_expose_flags(&dev->sdev->sdev_gendev, 0);
 }
 
 void ata_acpi_unbind(struct ata_device *dev)
-- 
1.7.12.4

