From: Aaron Lu <aaron.lwe@gmail.com>
Subject: [PATCH v6 4/7] libata: acpi: set can_power_off for both ODD and HD
Date: Tue,  4 Sep 2012 22:24:37 +0800
Message-ID: <1346768680-7287-5-git-send-email-aaron.lwe@gmail.com>
References: <1346768680-7287-1-git-send-email-aaron.lwe@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44458 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab2IDOZn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Sep 2012 10:25:43 -0400
In-Reply-To: <1346768680-7287-1-git-send-email-aaron.lwe@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>, Aaron Lu <aaron.lwe@gmail.com>

From: Aaron Lu <aaron.lu@intel.com>

Hard disk may also be runtime powered off, so set can_power_off flag
for it too if condition satisfies.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-acpi.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 64ba43d..6c8f89c 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -1005,7 +1005,7 @@ static void ata_acpi_add_pm_notifier(struct ata_device *dev)
 	if (ACPI_FAILURE(status))
 		return;
 
-	if (dev->sdev->can_power_off) {
+	if (dev->class == ATA_DEV_ATAPI && dev->sdev->can_power_off) {
 		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 			ata_acpi_wake_dev, dev);
 		device_set_run_wake(&dev->sdev->sdev_gendev, true);
@@ -1026,7 +1026,7 @@ static void ata_acpi_remove_pm_notifier(struct ata_device *dev)
 	if (ACPI_FAILURE(status))
 		return;
 
-	if (dev->sdev->can_power_off) {
+	if (dev->class == ATA_DEV_ATAPI && dev->sdev->can_power_off) {
 		device_set_run_wake(&dev->sdev->sdev_gendev, false);
 		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 			ata_acpi_wake_dev);
@@ -1130,14 +1130,23 @@ static int ata_acpi_bind_device(struct ata_port *ap, struct scsi_device *sdev,
 
 	/*
 	 * If firmware has _PS3 or _PR3 for this device,
-	 * and this ata ODD device support device attention,
-	 * it means this device can be powered off
+	 * it means this device can be powered off runtime
 	 */
 	states = acpi_dev->power.states;
-	if ((states[ACPI_STATE_D3_HOT].flags.valid ||
-			states[ACPI_STATE_D3_COLD].flags.explicit_set) &&
-			ata_dev->flags & ATA_DFLAG_DA)
-		sdev->can_power_off = 1;
+	if (states[ACPI_STATE_D3_HOT].flags.valid ||
+			states[ACPI_STATE_D3_COLD].flags.explicit_set) {
+		/*
+		 * For ODD, it needs to support device attention or
+		 * it can't be powered up back by user
+		 */
+		if (ata_dev->class == ATA_DEV_ATAPI &&
+				ata_dev->flags & ATA_DFLAG_DA)
+			sdev->can_power_off = 1;
+
+		/* No requirement for hard disk */
+		if (ata_dev->class == ATA_DEV_ATA)
+			sdev->can_power_off = 1;
+	}
 
 	return 0;
 }
-- 
1.7.11.3

