From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v4 09/13] libata: tell scsi layer device supports runtime power off
Date: Mon, 28 May 2012 13:08:36 +0800
Message-ID: <1338181720-4149-10-git-send-email-ming.m.lin@intel.com>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, David Woodhouse <David.Woodhouse@intel.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Aaron Lu <aaron.lu@amd.com>

If ATA device supports "Device Attention", then tell scsi layer that
the device supports runtime power off.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-acpi.c  |   32 ++++++++++++++++++++++++++++----
 include/scsi/scsi_device.h |    1 +
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 5431f1d..f0fa115 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -989,7 +989,10 @@ static void ata_acpi_add_pm_notifier(struct ata_device *dev)
 		return;
 
 	status = acpi_bus_get_device(handle, &acpi_dev);
-	if (ACPI_SUCCESS(status)) {
+	if (ACPI_FAILURE(status))
+		return;
+
+	if (dev->sdev->can_power_off) {
 		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 			ata_acpi_wake_dev, dev);
 		device_set_run_wake(&dev->sdev->sdev_gendev, true);
@@ -1007,7 +1010,10 @@ static void ata_acpi_remove_pm_notifier(struct ata_device *dev)
 		return;
 
 	status = acpi_bus_get_device(handle, &acpi_dev);
-	if (ACPI_SUCCESS(status)) {
+	if (ACPI_FAILURE(status))
+		return;
+
+	if (dev->sdev->can_power_off) {
 		device_set_run_wake(&dev->sdev->sdev_gendev, false);
 		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 			ata_acpi_wake_dev);
@@ -1091,10 +1097,13 @@ static int ata_acpi_bind_host(struct device *dev, int host, acpi_handle *handle)
 static int ata_acpi_bind_device(struct device *dev, int channel, int id,
 				acpi_handle *handle)
 {
-	struct device *host = dev->parent->parent;
-	struct Scsi_Host *shost = dev_to_shost(host);
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct Scsi_Host *shost = sdev->host;
 	struct ata_port *ap = ata_shost_to_port(shost);
 	struct ata_device *ata_dev;
+	acpi_status status;
+	struct acpi_device *acpi_dev;
+	struct acpi_device_power_state *states;
 
 	if (ap->flags & ATA_FLAG_ACPI_SATA)
 		ata_dev = &ap->link.device[channel];
@@ -1106,6 +1115,21 @@ static int ata_acpi_bind_device(struct device *dev, int channel, int id,
 	if (!*handle)
 		return -ENODEV;
 
+	status = acpi_bus_get_device(*handle, &acpi_dev);
+	if (ACPI_FAILURE(status))
+		return 0;
+
+	/*
+	 * If firmware has _PS3 or _PR3 for this device,
+	 * and this ata ODD device support device attention,
+	 * it means this device can be powered off
+	 */
+	states = acpi_dev->power.states;
+	if ((states[ACPI_STATE_D3_HOT].flags.valid ||
+			states[ACPI_STATE_D3_COLD].flags.explicit_set) &&
+			ata_dev->flags & ATA_DFLAG_DA)
+		sdev->can_power_off = 1;
+
 	return 0;
 }
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6efb2e1..1237fac 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -152,6 +152,7 @@ struct scsi_device {
 	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
 	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
+	unsigned can_power_off:1; /* Device supports runtime power off */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
-- 
1.7.2.5
