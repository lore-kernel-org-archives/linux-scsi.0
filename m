From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 31/36] smartpqi: make ioaccel references consistent
Date: Wed, 3 May 2017 18:55:25 -0500
Message-ID: <149385572550.11043.11808706883213169945.stgit@brunhilda>
References: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0077.outbound.protection.outlook.com ([104.47.37.77]:64544
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751792AbdECXzp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 May 2017 19:55:45 -0400
In-Reply-To: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@hpe.com>

 - make all references to RAID bypass consistent throughout driver.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |   13 ++++----
 drivers/scsi/smartpqi/smartpqi_init.c |   56 ++++++++++++++-------------------
 2 files changed, 30 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 2ed15cf..e9f113a 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -805,12 +805,11 @@ struct pqi_scsi_dev {
 	u8	bay;
 	u8	box[8];
 	u16	phys_connector[8];
-	int	offload_configured;	/* I/O accel RAID offload configured */
-	int	offload_enabled;	/* I/O accel RAID offload enabled */
-	int	offload_enabled_pending;
-	int	offload_to_mirror;	/* Send next I/O accelerator RAID */
-					/* offload request to mirror drive. */
-	struct raid_map *raid_map;	/* I/O accelerator RAID map */
+	bool	raid_bypass_configured;	/* RAID bypass configured */
+	bool	raid_bypass_enabled;	/* RAID bypass enabled */
+	int	offload_to_mirror;	/* Send next RAID bypass request */
+					/* to mirror drive. */
+	struct raid_map *raid_map;	/* RAID bypass map */
 
 	struct pqi_sas_port *sas_port;
 	struct scsi_device *sdev;
@@ -827,7 +826,7 @@ struct pqi_scsi_dev {
 #define SCSI_VPD_SUPPORTED_PAGES	0x0	/* standard page */
 #define SCSI_VPD_DEVICE_ID		0x83	/* standard page */
 #define CISS_VPD_LV_DEVICE_GEOMETRY	0xc1	/* vendor-specific page */
-#define CISS_VPD_LV_OFFLOAD_STATUS	0xc2	/* vendor-specific page */
+#define CISS_VPD_LV_BYPASS_STATUS	0xc2	/* vendor-specific page */
 #define CISS_VPD_LV_STATUS		0xc3	/* vendor-specific page */
 
 #define VPD_PAGE	(1 << 8)
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 4e016df..5f1c607 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1112,35 +1112,33 @@ static int pqi_get_raid_map(struct pqi_ctrl_info *ctrl_info,
 	return rc;
 }
 
-static void pqi_get_offload_status(struct pqi_ctrl_info *ctrl_info,
+static void pqi_get_raid_bypass_status(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device)
 {
 	int rc;
 	u8 *buffer;
-	u8 offload_status;
+	u8 bypass_status;
 
 	buffer = kmalloc(64, GFP_KERNEL);
 	if (!buffer)
 		return;
 
 	rc = pqi_scsi_inquiry(ctrl_info, device->scsi3addr,
-		VPD_PAGE | CISS_VPD_LV_OFFLOAD_STATUS, buffer, 64);
+		VPD_PAGE | CISS_VPD_LV_BYPASS_STATUS, buffer, 64);
 	if (rc)
 		goto out;
 
-#define OFFLOAD_STATUS_BYTE	4
-#define OFFLOAD_CONFIGURED_BIT	0x1
-#define OFFLOAD_ENABLED_BIT	0x2
+#define RAID_BYPASS_STATUS	4
+#define RAID_BYPASS_CONFIGURED	0x1
+#define RAID_BYPASS_ENABLED	0x2
 
-	offload_status = buffer[OFFLOAD_STATUS_BYTE];
-	device->offload_configured =
-		!!(offload_status & OFFLOAD_CONFIGURED_BIT);
-	if (device->offload_configured) {
-		device->offload_enabled_pending =
-			!!(offload_status & OFFLOAD_ENABLED_BIT);
-		if (pqi_get_raid_map(ctrl_info, device))
-			device->offload_enabled_pending = false;
-	}
+	bypass_status = buffer[RAID_BYPASS_STATUS];
+	device->raid_bypass_configured =
+		(bypass_status & RAID_BYPASS_CONFIGURED) != 0;
+	if (device->raid_bypass_configured &&
+		(bypass_status & RAID_BYPASS_ENABLED) &&
+		pqi_get_raid_map(ctrl_info, device) == 0)
+		device->raid_bypass_enabled = true;
 
 out:
 	kfree(buffer);
@@ -1214,7 +1212,7 @@ static int pqi_get_device_info(struct pqi_ctrl_info *ctrl_info,
 			device->volume_offline = false;
 		} else {
 			pqi_get_raid_level(ctrl_info, device);
-			pqi_get_offload_status(ctrl_info, device);
+			pqi_get_raid_bypass_status(ctrl_info, device);
 			pqi_get_volume_status(ctrl_info, device);
 		}
 	}
@@ -1492,9 +1490,8 @@ static void pqi_dev_info(struct pqi_ctrl_info *ctrl_info,
 			count += snprintf(buffer + count,
 				PQI_DEV_INFO_BUFFER_LENGTH - count,
 				"SSDSmartPathCap%c En%c %-12s",
-				device->offload_configured ? '+' : '-',
-				(device->offload_enabled ||
-				device->offload_enabled_pending) ? '+' : '-',
+				device->raid_bypass_configured ? '+' : '-',
+				device->raid_bypass_enabled ? '+' : '-',
 				pqi_raid_level_to_string(device->raid_level));
 	} else {
 		count += snprintf(buffer + count,
@@ -1546,13 +1543,13 @@ static void pqi_scsi_update_device(struct pqi_scsi_dev *existing_device,
 		sizeof(existing_device->box));
 	memcpy(existing_device->phys_connector, new_device->phys_connector,
 		sizeof(existing_device->phys_connector));
-	existing_device->offload_configured = new_device->offload_configured;
-	existing_device->offload_enabled = false;
-	existing_device->offload_enabled_pending =
-		new_device->offload_enabled_pending;
 	existing_device->offload_to_mirror = 0;
 	kfree(existing_device->raid_map);
 	existing_device->raid_map = new_device->raid_map;
+	existing_device->raid_bypass_configured =
+		new_device->raid_bypass_configured;
+	existing_device->raid_bypass_enabled =
+		new_device->raid_bypass_enabled;
 
 	/* To prevent this from being freed later. */
 	new_device->raid_map = NULL;
@@ -1670,11 +1667,6 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 		device->keep_device = true;
 	}
 
-	list_for_each_entry(device, &ctrl_info->scsi_device_list,
-		scsi_device_list_entry)
-		device->offload_enabled =
-			device->offload_enabled_pending;
-
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
 	/* Remove all devices that have gone away. */
@@ -2044,7 +2036,7 @@ static inline void pqi_set_encryption_info(
 }
 
 /*
- * Attempt to perform offload RAID mapping for a logical volume I/O.
+ * Attempt to perform RAID bypass mapping for a logical volume I/O.
  */
 
 #define PQI_RAID_BYPASS_INELIGIBLE	1
@@ -2448,7 +2440,7 @@ static inline void pqi_aio_path_disabled(struct pqi_io_request *io_request)
 	struct pqi_scsi_dev *device;
 
 	device = io_request->scmd->device->hostdata;
-	device->offload_enabled = false;
+	device->raid_bypass_enabled = false;
 	device->aio_enabled = false;
 }
 
@@ -5002,7 +4994,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost,
 
 	if (pqi_is_logical_device(device)) {
 		raid_bypassed = false;
-		if (device->offload_enabled &&
+		if (device->raid_bypass_enabled &&
 				!blk_rq_is_passthrough(scmd->request)) {
 			rc = pqi_raid_bypass_submit_scsi_cmd(ctrl_info, device,
 				scmd, queue_group);
@@ -5753,7 +5745,7 @@ static ssize_t pqi_ssd_smart_path_enabled_show(struct device *dev,
 	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
 
 	device = sdev->hostdata;
-	buffer[0] = device->offload_enabled ? '1' : '0';
+	buffer[0] = device->raid_bypass_enabled ? '1' : '0';
 	buffer[1] = '\n';
 	buffer[2] = '\0';
 
