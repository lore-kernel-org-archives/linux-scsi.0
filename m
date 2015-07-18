From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 05/11] hpsa: add sysfs entry path_info to show box and bay
 information
Date: Sat, 18 Jul 2015 11:12:43 -0500
Message-ID: <20150718161243.31955.59402.stgit@brunhilda>
References: <20150718160245.31955.16794.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:40751 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbbGRQPB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2015 12:15:01 -0400
In-Reply-To: <20150718160245.31955.16794.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hp.com
Cc: linux-scsi@vger.kernel.org

From: Joe Handzik <joseph.t.handzik@hp.com>

host no, bus, target, lun, scsi_device_type
for hba mode add: box and bay information

report if the path is active/inactive

Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |  122 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/hpsa.h |    5 ++
 2 files changed, 127 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index eaa35bd..f64a2c7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -264,6 +264,7 @@ static int hpsa_scsi_ioaccel_queue_command(struct ctlr_info *h,
 static void hpsa_command_resubmit_worker(struct work_struct *work);
 static u32 lockup_detected(struct ctlr_info *h);
 static int detect_controller_lockup(struct ctlr_info *h);
+static int is_ext_target(struct ctlr_info *h, struct hpsa_scsi_dev_t *device);
 
 static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
 {
@@ -714,12 +715,106 @@ static ssize_t host_show_hp_ssd_smart_path_enabled(struct device *dev,
 	return snprintf(buf, 20, "%d\n", offload_enabled);
 }
 
+#define MAX_PATHS 8
+#define PATH_STRING_LEN 50
+
+static ssize_t path_info_show(struct device *dev,
+	     struct device_attribute *attr, char *buf)
+{
+	struct ctlr_info *h;
+	struct scsi_device *sdev;
+	struct hpsa_scsi_dev_t *hdev;
+	unsigned long flags;
+	int i;
+	int output_len = 0;
+	u8 box;
+	u8 bay;
+	u8 path_map_index = 0;
+	char *active;
+	unsigned char phys_connector[2];
+	unsigned char path[MAX_PATHS][PATH_STRING_LEN];
+
+	memset(path, 0, MAX_PATHS * PATH_STRING_LEN);
+	sdev = to_scsi_device(dev);
+	h = sdev_to_hba(sdev);
+	spin_lock_irqsave(&h->devlock, flags);
+	hdev = sdev->hostdata;
+	if (!hdev) {
+		spin_unlock_irqrestore(&h->devlock, flags);
+		return -ENODEV;
+	}
+
+	bay = hdev->bay;
+	for (i = 0; i < MAX_PATHS; i++) {
+		path_map_index = 1<<i;
+		if (i == hdev->active_path_index)
+			active = "Active";
+		else if (hdev->path_map & path_map_index)
+			active = "Inactive";
+		else
+			continue;
+
+		output_len = snprintf(path[i],
+				PATH_STRING_LEN, "[%d:%d:%d:%d] %20.20s ",
+				h->scsi_host->host_no,
+				hdev->bus, hdev->target, hdev->lun,
+				scsi_device_type(hdev->devtype));
+
+		if (is_ext_target(h, hdev) ||
+			(hdev->devtype == TYPE_RAID) ||
+			is_logical_dev_addr_mode(hdev->scsi3addr)) {
+			output_len += snprintf(path[i] + output_len,
+						PATH_STRING_LEN, "%s\n",
+						active);
+			continue;
+		}
+
+		box = hdev->box[i];
+		memcpy(&phys_connector, &hdev->phys_connector[i],
+			sizeof(phys_connector));
+		if (phys_connector[0] < '0')
+			phys_connector[0] = '0';
+		if (phys_connector[1] < '0')
+			phys_connector[1] = '0';
+		if (hdev->phys_connector[i] > 0)
+			output_len += snprintf(path[i] + output_len,
+				PATH_STRING_LEN,
+				"PORT: %.2s ",
+				phys_connector);
+		if (hdev->devtype == TYPE_DISK && h->hba_mode_enabled) {
+			if (box == 0 || box == 0xFF) {
+				output_len += snprintf(path[i] + output_len,
+					PATH_STRING_LEN,
+					"BAY: %hhu %s\n",
+					bay, active);
+			} else {
+				output_len += snprintf(path[i] + output_len,
+					PATH_STRING_LEN,
+					"BOX: %hhu BAY: %hhu %s\n",
+					box, bay, active);
+			}
+		} else if (box != 0 && box != 0xFF) {
+			output_len += snprintf(path[i] + output_len,
+				PATH_STRING_LEN, "BOX: %hhu %s\n",
+				box, active);
+		} else
+			output_len += snprintf(path[i] + output_len,
+				PATH_STRING_LEN, "%s\n", active);
+	}
+
+	spin_unlock_irqrestore(&h->devlock, flags);
+	return snprintf(buf, output_len+1, "%s%s%s%s%s%s%s%s",
+		path[0], path[1], path[2], path[3],
+		path[4], path[5], path[6], path[7]);
+}
+
 static DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
 static DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
 static DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
 static DEVICE_ATTR(hp_ssd_smart_path_enabled, S_IRUGO,
 			host_show_hp_ssd_smart_path_enabled, NULL);
+static DEVICE_ATTR(path_info, S_IRUGO, path_info_show, NULL);
 static DEVICE_ATTR(hp_ssd_smart_path_status, S_IWUSR|S_IRUGO|S_IROTH,
 		host_show_hp_ssd_smart_path_status,
 		host_store_hp_ssd_smart_path_status);
@@ -741,6 +836,7 @@ static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_lunid,
 	&dev_attr_unique_id,
 	&dev_attr_hp_ssd_smart_path_enabled,
+	&dev_attr_path_info,
 	&dev_attr_lockup_detected,
 	NULL,
 };
@@ -3611,6 +3707,31 @@ static void hpsa_get_ioaccel_drive_info(struct ctlr_info *h,
 	atomic_set(&dev->reset_cmds_out, 0);
 }
 
+static void hpsa_get_path_info(struct hpsa_scsi_dev_t *this_device,
+	u8 *lunaddrbytes,
+	struct bmic_identify_physical_device *id_phys)
+{
+	if (PHYS_IOACCEL(lunaddrbytes)
+		&& this_device->ioaccel_handle)
+		this_device->hba_ioaccel_enabled = 1;
+
+	memcpy(&this_device->active_path_index,
+		&id_phys->active_path_number,
+		sizeof(this_device->active_path_index));
+	memcpy(&this_device->path_map,
+		&id_phys->redundant_path_present_map,
+		sizeof(this_device->path_map));
+	memcpy(&this_device->box,
+		&id_phys->alternate_paths_phys_box_on_port,
+		sizeof(this_device->box));
+	memcpy(&this_device->phys_connector,
+		&id_phys->alternate_paths_phys_connector,
+		sizeof(this_device->phys_connector));
+	memcpy(&this_device->bay,
+		&id_phys->phys_bay_in_box,
+		sizeof(this_device->bay));
+}
+
 static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 {
 	/* the idea here is we could get notified
@@ -3771,6 +3892,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 
 			hpsa_get_ioaccel_drive_info(h, this_device,
 						lunaddrbytes, id_phys);
+			hpsa_get_path_info(this_device, lunaddrbytes, id_phys);
 			atomic_set(&this_device->ioaccel_cmds_out, 0);
 			ncurrent++;
 			break;
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 6f6084b..ab014d3 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -50,6 +50,11 @@ struct hpsa_scsi_dev_t {
 					 * device via "ioaccel" path.
 					 */
 	u32 ioaccel_handle;
+	u8 active_path_index;
+	u8 path_map;
+	u8 bay;
+	u8 box[8];
+	u16 phys_connector[8];
 	int offload_config;		/* I/O accel RAID offload configured */
 	int offload_enabled;		/* I/O accel RAID offload enabled */
 	int offload_to_be_enabled;

