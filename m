From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 2/7] hpsa: add SMR drive support
Date: Tue, 23 Feb 2016 15:16:15 -0600
Message-ID: <20160223211615.5968.99389.stgit@brunhilda>
References: <20160223210957.5968.6998.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:37153 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755328AbcBWVQR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Feb 2016 16:16:17 -0500
In-Reply-To: <20160223210957.5968.6998.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Reviewed-by: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Reviewed-by: Justin Lindley <justin.lindley@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 098e8de..671ad57 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -809,7 +809,8 @@ static ssize_t path_info_show(struct device *dev,
 				PAGE_SIZE - output_len,
 				"PORT: %.2s ",
 				phys_connector);
-		if (hdev->devtype == TYPE_DISK && hdev->expose_device) {
+		if ((hdev->devtype == TYPE_DISK || hdev->devtype == TYPE_ZBC) &&
+			hdev->expose_device) {
 			if (box == 0 || box == 0xFF) {
 				output_len += scnprintf(buf + output_len,
 					PAGE_SIZE - output_len,
@@ -1166,6 +1167,7 @@ static void hpsa_show_dev_msg(const char *level, struct ctlr_info *h,
 		snprintf(label, LABEL_SIZE, "enclosure");
 		break;
 	case TYPE_DISK:
+	case TYPE_ZBC:
 		if (dev->external)
 			snprintf(label, LABEL_SIZE, "external");
 		else if (!is_logical_dev_addr_mode(dev->scsi3addr))
@@ -1636,6 +1638,8 @@ static void hpsa_figure_phys_disk_ptrs(struct ctlr_info *h,
 				continue;
 			if (dev[j]->devtype != TYPE_DISK)
 				continue;
+			if (dev[j]->devtype != TYPE_ZBC)
+				continue;
 			if (is_logical_device(dev[j]))
 				continue;
 			if (dev[j]->ioaccel_handle != dd[i].ioaccel_handle)
@@ -1681,6 +1685,8 @@ static void hpsa_update_log_drive_phys_drive_ptrs(struct ctlr_info *h,
 			continue;
 		if (dev[i]->devtype != TYPE_DISK)
 			continue;
+		if (dev[i]->devtype != TYPE_ZBC)
+			continue;
 		if (!is_logical_device(dev[i]))
 			continue;
 
@@ -3715,7 +3721,8 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 	hpsa_get_device_id(h, scsi3addr, this_device->device_id, 8,
 		sizeof(this_device->device_id));
 
-	if (this_device->devtype == TYPE_DISK &&
+	if ((this_device->devtype == TYPE_DISK ||
+		this_device->devtype == TYPE_ZBC) &&
 		is_logical_dev_addr_mode(scsi3addr)) {
 		int volume_offline;
 
@@ -4183,6 +4190,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 				ncurrent++;
 			break;
 		case TYPE_DISK:
+		case TYPE_ZBC:
 			if (this_device->physical_device) {
 				/* The disk is in HBA mode. */
 				/* Never use RAID mapper in HBA mode. */

