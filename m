From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 23/37] smartpqi: remove qdepth calculations for logical
 volumes
Date: Tue, 25 Apr 2017 14:48:13 -0500
Message-ID: <149314969291.13903.16333142456414971848.stgit@brunhilda>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0058.outbound.protection.outlook.com ([104.47.42.58]:63808
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1176582AbdDYTsn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 15:48:43 -0400
In-Reply-To: <149314950730.13903.644081079070695025.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@hpe.com>

make the queue depth for LVs the same as the maximum
I/Os supported by the controller

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    6 -
 drivers/scsi/smartpqi/smartpqi_init.c |  140 ++-------------------------------
 2 files changed, 8 insertions(+), 138 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 400d1fb..857d1be 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -726,7 +726,6 @@ struct report_phys_lun_extended_entry {
 };
 
 /* for device_flags field of struct report_phys_lun_extended_entry */
-#define REPORT_PHYS_LUN_DEV_FLAG_NON_DISK	0x1
 #define REPORT_PHYS_LUN_DEV_FLAG_AIO_ENABLED	0x8
 
 struct report_phys_lun_extended {
@@ -786,8 +785,6 @@ struct pqi_scsi_dev {
 	u8	is_physical_device : 1;
 	u8	is_external_raid_device : 1;
 	u8	target_lun_valid : 1;
-	u8	expose_device : 1;
-	u8	no_uld_attach : 1;
 	u8	aio_enabled : 1;	/* only valid for physical disks */
 	u8	device_gone : 1;
 	u8	new_device : 1;
@@ -1034,9 +1031,6 @@ enum pqi_ctrl_mode {
  */
 #define PQI_PHYSICAL_DISK_DEFAULT_MAX_QUEUE_DEPTH	27
 
-/* 0 = no limit */
-#define PQI_LOGICAL_DRIVE_DEFAULT_MAX_QUEUE_DEPTH	0
-
 /* CISS commands */
 #define CISS_READ		0xc0
 #define CISS_REPORT_LOG		0xc2	/* Report Logical LUNs */
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 6235b6d..2b667b5 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1308,87 +1308,6 @@ static void pqi_show_volume_status(struct pqi_ctrl_info *ctrl_info,
 		device->bus, device->target, device->lun, status);
 }
 
-static struct pqi_scsi_dev *pqi_find_disk_by_aio_handle(
-	struct pqi_ctrl_info *ctrl_info, u32 aio_handle)
-{
-	struct pqi_scsi_dev *device;
-
-	list_for_each_entry(device, &ctrl_info->scsi_device_list,
-		scsi_device_list_entry) {
-		if (device->devtype != TYPE_DISK && device->devtype != TYPE_ZBC)
-			continue;
-		if (pqi_is_logical_device(device))
-			continue;
-		if (device->aio_handle == aio_handle)
-			return device;
-	}
-
-	return NULL;
-}
-
-static void pqi_update_logical_drive_queue_depth(
-	struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *logical_drive)
-{
-	unsigned int i;
-	struct raid_map *raid_map;
-	struct raid_map_disk_data *disk_data;
-	struct pqi_scsi_dev *phys_disk;
-	unsigned int num_phys_disks;
-	unsigned int num_raid_map_entries;
-	unsigned int queue_depth;
-
-	logical_drive->queue_depth = PQI_LOGICAL_DRIVE_DEFAULT_MAX_QUEUE_DEPTH;
-
-	raid_map = logical_drive->raid_map;
-	if (!raid_map)
-		return;
-
-	disk_data = raid_map->disk_data;
-	num_phys_disks = get_unaligned_le16(&raid_map->layout_map_count) *
-		(get_unaligned_le16(&raid_map->data_disks_per_row) +
-		get_unaligned_le16(&raid_map->metadata_disks_per_row));
-	num_raid_map_entries = num_phys_disks *
-		get_unaligned_le16(&raid_map->row_cnt);
-
-	queue_depth = 0;
-	for (i = 0; i < num_raid_map_entries; i++) {
-		phys_disk = pqi_find_disk_by_aio_handle(ctrl_info,
-			disk_data[i].aio_handle);
-
-		if (!phys_disk) {
-			dev_warn(&ctrl_info->pci_dev->dev,
-				"failed to find physical disk for logical drive %016llx\n",
-				get_unaligned_be64(logical_drive->scsi3addr));
-			logical_drive->offload_enabled = false;
-			logical_drive->offload_enabled_pending = false;
-			kfree(raid_map);
-			logical_drive->raid_map = NULL;
-			return;
-		}
-
-		queue_depth += phys_disk->queue_depth;
-	}
-
-	logical_drive->queue_depth = queue_depth;
-}
-
-static void pqi_update_all_logical_drive_queue_depths(
-	struct pqi_ctrl_info *ctrl_info)
-{
-	struct pqi_scsi_dev *device;
-
-	list_for_each_entry(device, &ctrl_info->scsi_device_list,
-		scsi_device_list_entry) {
-		if (device->devtype != TYPE_DISK && device->devtype != TYPE_ZBC)
-			continue;
-		if (!pqi_is_logical_device(device))
-			continue;
-		if (pqi_is_external_raid_device(device))
-			continue;
-		pqi_update_logical_drive_queue_depth(ctrl_info, device);
-	}
-}
-
 static void pqi_rescan_worker(struct work_struct *work)
 {
 	struct pqi_ctrl_info *ctrl_info;
@@ -1484,7 +1403,7 @@ static void pqi_dev_info(struct pqi_ctrl_info *ctrl_info,
 	char *action, struct pqi_scsi_dev *device)
 {
 	dev_info(&ctrl_info->pci_dev->dev,
-		"%s scsi %d:%d:%d:%d: %s %.8s %.16s %-12s SSDSmartPathCap%c En%c Exp%c qd=%d\n",
+		"%s scsi %d:%d:%d:%d: %s %.8s %.16s %-12s SSDSmartPathCap%c En%c qd=%d\n",
 		action,
 		ctrl_info->scsi_host->host_no,
 		device->bus,
@@ -1497,7 +1416,6 @@ static void pqi_dev_info(struct pqi_ctrl_info *ctrl_info,
 			pqi_raid_level_to_string(device->raid_level) : "",
 		device->offload_configured ? '+' : '-',
 		device->offload_enabled_pending ? '+' : '-',
-		device->expose_device ? '+' : '-',
 		device->queue_depth);
 }
 
@@ -1520,8 +1438,6 @@ static void pqi_scsi_update_device(struct pqi_scsi_dev *existing_device,
 	existing_device->is_physical_device = new_device->is_physical_device;
 	existing_device->is_external_raid_device =
 		new_device->is_external_raid_device;
-	existing_device->expose_device = new_device->expose_device;
-	existing_device->no_uld_attach = new_device->no_uld_attach;
 	existing_device->aio_enabled = new_device->aio_enabled;
 	memcpy(existing_device->vendor, new_device->vendor,
 		sizeof(existing_device->vendor));
@@ -1663,8 +1579,6 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 		device->keep_device = true;
 	}
 
-	pqi_update_all_logical_drive_queue_depths(ctrl_info);
-
 	list_for_each_entry(device, &ctrl_info->scsi_device_list,
 		scsi_device_list_entry)
 		device->offload_enabled =
@@ -1703,7 +1617,7 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 
 	/* Expose any new devices. */
 	list_for_each_entry_safe(device, next, &add_list, add_list_entry) {
-		if (device->expose_device && !device->sdev) {
+		if (!device->sdev) {
 			rc = pqi_add_device(ctrl_info, device);
 			if (rc) {
 				dev_warn(&ctrl_info->pci_dev->dev,
@@ -1746,38 +1660,15 @@ static bool pqi_is_supported_device(struct pqi_scsi_dev *device)
 	return is_supported;
 }
 
-static inline bool pqi_skip_device(u8 *scsi3addr,
-	struct report_phys_lun_extended_entry *phys_lun_ext_entry)
+static inline bool pqi_skip_device(u8 *scsi3addr)
 {
-	u8 device_flags;
-
-	if (!MASKED_DEVICE(scsi3addr))
-		return false;
-
-	/* The device is masked. */
-
-	device_flags = phys_lun_ext_entry->device_flags;
-
-	if (device_flags & REPORT_PHYS_LUN_DEV_FLAG_NON_DISK) {
-		/*
-		 * It's a non-disk device.  We ignore all devices of this type
-		 * when they're masked.
-		 */
+	/* Ignore all masked devices. */
+	if (MASKED_DEVICE(scsi3addr))
 		return true;
-	}
 
 	return false;
 }
 
-static inline bool pqi_ok_to_expose_device(struct pqi_scsi_dev *device)
-{
-	/* Expose all devices except for physical devices that are masked. */
-	if (device->is_physical_device && MASKED_DEVICE(device->scsi3addr))
-		return false;
-
-	return true;
-}
-
 static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 {
 	int i;
@@ -1876,8 +1767,7 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 			scsi3addr = log_lun_ext_entry->lunid;
 		}
 
-		if (is_physical_device &&
-			pqi_skip_device(scsi3addr, phys_lun_ext_entry))
+		if (is_physical_device && pqi_skip_device(scsi3addr))
 			continue;
 
 		if (device)
@@ -1912,8 +1802,6 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 
 		pqi_assign_bus_target_lun(device);
 
-		device->expose_device = pqi_ok_to_expose_device(device);
-
 		if (device->is_physical_device) {
 			device->wwid = phys_lun_ext_entry->wwid;
 			if ((phys_lun_ext_entry->device_flags &
@@ -4847,7 +4735,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost,
 				rc == SCSI_MLQUEUE_HOST_BUSY ||
 				rc == SAM_STAT_CHECK_CONDITION ||
 				rc == SAM_STAT_RESERVATION_CONFLICT)
-				raid_bypassed = true;
+					raid_bypassed = true;
 		}
 		if (!raid_bypassed)
 			rc = pqi_raid_submit_scsi_cmd(ctrl_info, device, scmd,
@@ -5173,7 +5061,7 @@ static int pqi_slave_alloc(struct scsi_device *sdev)
 			sdev_id(sdev), sdev->lun);
 	}
 
-	if (device && device->expose_device) {
+	if (device) {
 		sdev->hostdata = device;
 		device->sdev = sdev;
 		if (device->queue_depth) {
@@ -5188,17 +5076,6 @@ static int pqi_slave_alloc(struct scsi_device *sdev)
 	return 0;
 }
 
-static int pqi_slave_configure(struct scsi_device *sdev)
-{
-	struct pqi_scsi_dev *device;
-
-	device = sdev->hostdata;
-	if (!device->expose_device)
-		sdev->no_uld_attach = true;
-
-	return 0;
-}
-
 static int pqi_map_queues(struct Scsi_Host *shost)
 {
 	struct pqi_ctrl_info *ctrl_info = shost_to_hba(shost);
@@ -5592,7 +5469,6 @@ static struct scsi_host_template pqi_driver_template = {
 	.eh_device_reset_handler = pqi_eh_device_reset_handler,
 	.ioctl = pqi_ioctl,
 	.slave_alloc = pqi_slave_alloc,
-	.slave_configure = pqi_slave_configure,
 	.map_queues = pqi_map_queues,
 	.sdev_attrs = pqi_sdev_attrs,
 	.shost_attrs = pqi_shost_attrs,
