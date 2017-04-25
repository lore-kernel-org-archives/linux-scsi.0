From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 20/37] smartpqi: add ptraid support
Date: Tue, 25 Apr 2017 14:47:54 -0500
Message-ID: <149314967409.13903.2226976663275826120.stgit@brunhilda>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0071.outbound.protection.outlook.com ([104.47.41.71]:61804
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1176499AbdDYTsU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 15:48:20 -0400
In-Reply-To: <149314950730.13903.644081079070695025.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@hpe.com>

add support for PTRAID devices

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    8 +++---
 drivers/scsi/smartpqi/smartpqi_init.c |   48 ++++++++++++++++++++++++++++-----
 2 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index d044a58c..be04bcb 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -694,7 +694,8 @@ struct pqi_config_table_heartbeat {
 #define PQI_PHYSICAL_DEVICE_BUS		0
 #define PQI_RAID_VOLUME_BUS		1
 #define PQI_HBA_BUS			2
-#define PQI_MAX_BUS			PQI_HBA_BUS
+#define PQI_EXTERNAL_RAID_VOLUME_BUS	3
+#define PQI_MAX_BUS			PQI_EXTERNAL_RAID_VOLUME_BUS
 
 struct report_lun_header {
 	__be32	list_length;
@@ -781,6 +782,7 @@ struct pqi_scsi_dev {
 	__be64	wwid;
 	u8	volume_id[16];
 	u8	is_physical_device : 1;
+	u8	is_external_raid_device : 1;
 	u8	target_lun_valid : 1;
 	u8	expose_device : 1;
 	u8	no_uld_attach : 1;
@@ -1056,10 +1058,10 @@ enum pqi_ctrl_mode {
 #define SA_CACHE_FLUSH				0x1
 
 #define MASKED_DEVICE(lunid)			((lunid)[3] & 0xc0)
-#define CISS_GET_BUS(lunid)			((lunid)[7] & 0x3f)
+#define CISS_GET_LEVEL_2_BUS(lunid)		((lunid)[7] & 0x3f)
 #define CISS_GET_LEVEL_2_TARGET(lunid)		((lunid)[6])
 #define CISS_GET_DRIVE_NUMBER(lunid)		\
-	(((CISS_GET_BUS((lunid)) - 1) << 8) +	\
+	(((CISS_GET_LEVEL_2_BUS((lunid)) - 1) << 8) + \
 	CISS_GET_LEVEL_2_TARGET((lunid)))
 
 #define NO_TIMEOUT		((unsigned long) -1)
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index c5b37bc..f943e58 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -147,6 +147,16 @@ static inline bool pqi_is_logical_device(struct pqi_scsi_dev *device)
 	return !device->is_physical_device;
 }
 
+static inline bool pqi_is_external_raid_device(struct pqi_scsi_dev *device)
+{
+	return device->is_external_raid_device;
+}
+
+static inline bool pqi_is_external_raid_addr(u8 *scsi3addr)
+{
+	return scsi3addr[2] != 0;
+}
+
 static inline bool pqi_ctrl_offline(struct pqi_ctrl_info *ctrl_info)
 {
 	return !ctrl_info->controller_online;
@@ -885,6 +895,9 @@ static void pqi_assign_bus_target_lun(struct pqi_scsi_dev *device)
 {
 	u8 *scsi3addr;
 	u32 lunid;
+	int bus;
+	int target;
+	int lun;
 
 	scsi3addr = device->scsi3addr;
 	lunid = get_unaligned_le32(scsi3addr);
@@ -897,8 +910,16 @@ static void pqi_assign_bus_target_lun(struct pqi_scsi_dev *device)
 	}
 
 	if (pqi_is_logical_device(device)) {
-		pqi_set_bus_target_lun(device, PQI_RAID_VOLUME_BUS, 0,
-			lunid & 0x3fff);
+		if (pqi_is_external_raid_device(device)) {
+			bus = PQI_EXTERNAL_RAID_VOLUME_BUS;
+			target = (lunid >> 16) & 0x3fff;
+			lun = lunid & 0xff;
+		} else {
+			bus = PQI_RAID_VOLUME_BUS;
+			target = 0;
+			lun = lunid & 0x3fff;
+		}
+		pqi_set_bus_target_lun(device, bus, target, lun);
 		device->target_lun_valid = true;
 		return;
 	}
@@ -1137,9 +1158,15 @@ static int pqi_get_device_info(struct pqi_ctrl_info *ctrl_info,
 	memcpy(device->model, &buffer[16], sizeof(device->model));
 
 	if (pqi_is_logical_device(device) && device->devtype == TYPE_DISK) {
-		pqi_get_raid_level(ctrl_info, device);
-		pqi_get_offload_status(ctrl_info, device);
-		pqi_get_volume_status(ctrl_info, device);
+		if (pqi_is_external_raid_device(device)) {
+			device->raid_level = SA_RAID_UNKNOWN;
+			device->volume_status = CISS_LV_OK;
+			device->volume_offline = false;
+		} else {
+			pqi_get_raid_level(ctrl_info, device);
+			pqi_get_offload_status(ctrl_info, device);
+			pqi_get_volume_status(ctrl_info, device);
+		}
 	}
 
 out:
@@ -1356,6 +1383,8 @@ static void pqi_update_all_logical_drive_queue_depths(
 			continue;
 		if (!pqi_is_logical_device(device))
 			continue;
+		if (pqi_is_external_raid_device(device))
+			continue;
 		pqi_update_logical_drive_queue_depth(ctrl_info, device);
 	}
 }
@@ -1464,7 +1493,8 @@ static void pqi_dev_info(struct pqi_ctrl_info *ctrl_info,
 		scsi_device_type(device->devtype),
 		device->vendor,
 		device->model,
-		pqi_raid_level_to_string(device->raid_level),
+		pqi_is_logical_device(device) ?
+			pqi_raid_level_to_string(device->raid_level) : "",
 		device->offload_configured ? '+' : '-',
 		device->offload_enabled_pending ? '+' : '-',
 		device->expose_device ? '+' : '-',
@@ -1488,6 +1518,8 @@ static void pqi_scsi_update_device(struct pqi_scsi_dev *existing_device,
 	/* By definition, the scsi3addr and wwid fields are already the same. */
 
 	existing_device->is_physical_device = new_device->is_physical_device;
+	existing_device->is_external_raid_device =
+		new_device->is_external_raid_device;
 	existing_device->expose_device = new_device->expose_device;
 	existing_device->no_uld_attach = new_device->no_uld_attach;
 	existing_device->aio_enabled = new_device->aio_enabled;
@@ -1856,7 +1888,9 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 
 		memcpy(device->scsi3addr, scsi3addr, sizeof(device->scsi3addr));
 		device->is_physical_device = is_physical_device;
-		device->raid_level = SA_RAID_UNKNOWN;
+		if (!is_physical_device)
+			device->is_external_raid_device =
+				pqi_is_external_raid_addr(scsi3addr);
 
 		/* Gather information about the device. */
 		rc = pqi_get_device_info(ctrl_info, device);
