From: Ivan Mironov <mironov.ivan@gmail.com>
Subject: [PATCH 1/6] scsi: hpsa: Add function to check if device is a disk or a zoned device
Date: Fri, 14 Dec 2018 18:21:10 +0500
Message-ID: <20181214132115.21440-2-mironov.ivan@gmail.com>
References: <20181214132115.21440-1-mironov.ivan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181214132115.21440-1-mironov.ivan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, mironov.ivan@gmail.com
Cc: linux-kernel@vger.kernel.org, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com
List-Id: linux-scsi@vger.kernel.org

This check is used multiple times within the driver. New function makes
conditional statements a bit shorter and more readable.

Signed-off-by: Ivan Mironov <mironov.ivan@gmail.com>
---
 drivers/scsi/hpsa.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c9cccf35e9d7..fc06b790f16b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -768,6 +768,11 @@ static ssize_t sas_address_show(struct device *dev,
 	return snprintf(buf, PAGE_SIZE, "0x%016llx\n", sas_address);
 }
 
+static inline bool is_disk_or_zbc(const struct hpsa_scsi_dev_t *hdev)
+{
+	return hdev->devtype == TYPE_DISK || hdev->devtype == TYPE_ZBC;
+}
+
 static ssize_t host_show_hp_ssd_smart_path_enabled(struct device *dev,
 	     struct device_attribute *attr, char *buf)
 {
@@ -788,7 +793,7 @@ static ssize_t host_show_hp_ssd_smart_path_enabled(struct device *dev,
 	offload_enabled = hdev->offload_enabled;
 	spin_unlock_irqrestore(&h->lock, flags);
 
-	if (hdev->devtype == TYPE_DISK || hdev->devtype == TYPE_ZBC)
+	if (is_disk_or_zbc(hdev))
 		return snprintf(buf, 20, "%d\n", offload_enabled);
 	else
 		return snprintf(buf, 40, "%s\n",
@@ -855,8 +860,7 @@ static ssize_t path_info_show(struct device *dev,
 				PAGE_SIZE - output_len,
 				"PORT: %.2s ",
 				phys_connector);
-		if ((hdev->devtype == TYPE_DISK || hdev->devtype == TYPE_ZBC) &&
-			hdev->expose_device) {
+		if (is_disk_or_zbc(hdev) && hdev->expose_device) {
 			if (box == 0 || box == 0xFF) {
 				output_len += scnprintf(buf + output_len,
 					PAGE_SIZE - output_len,
@@ -1715,8 +1719,7 @@ static void hpsa_figure_phys_disk_ptrs(struct ctlr_info *h,
 		for (j = 0; j < ndevices; j++) {
 			if (dev[j] == NULL)
 				continue;
-			if (dev[j]->devtype != TYPE_DISK &&
-			    dev[j]->devtype != TYPE_ZBC)
+			if (!is_disk_or_zbc(dev[j]))
 				continue;
 			if (is_logical_device(dev[j]))
 				continue;
@@ -1770,8 +1773,7 @@ static void hpsa_update_log_drive_phys_drive_ptrs(struct ctlr_info *h,
 	for (i = 0; i < ndevices; i++) {
 		if (dev[i] == NULL)
 			continue;
-		if (dev[i]->devtype != TYPE_DISK &&
-		    dev[i]->devtype != TYPE_ZBC)
+		if (!is_disk_or_zbc(dev[i]))
 			continue;
 		if (!is_logical_device(dev[i]))
 			continue;
@@ -3965,9 +3967,8 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 			scsi_device_type(this_device->devtype),
 			this_device->model);
 
-	if ((this_device->devtype == TYPE_DISK ||
-		this_device->devtype == TYPE_ZBC) &&
-		is_logical_dev_addr_mode(scsi3addr)) {
+	if (is_disk_or_zbc(this_device) &&
+			is_logical_dev_addr_mode(scsi3addr)) {
 		unsigned char volume_offline;
 
 		hpsa_get_raid_level(h, scsi3addr, &this_device->raid_level);
-- 
2.19.2
