From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 11/21] hpsa: add function is_logical_device
Date: Sat, 24 Oct 2015 14:53:33 -0500
Message-ID: <20151024195333.17127.91753.stgit@brunhilda>
References: <20151024193306.17127.7819.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:51385 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752336AbbJXT5P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Oct 2015 15:57:15 -0400
In-Reply-To: <20151024193306.17127.7819.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@pmcs.com>

simplify checking for logical/physical devices

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 1598573..40770b8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -617,6 +617,11 @@ static const char * const raid_label[] = { "0", "4", "1(+0)", "5", "5+1", "6",
 #define HPSA_RAID_ADM	6	/* also used for RAID 1+0 ADM */
 #define RAID_UNKNOWN (ARRAY_SIZE(raid_label) - 1)
 
+static inline bool is_logical_device(struct hpsa_scsi_dev_t *device)
+{
+	return !device->physical_device;
+}
+
 static ssize_t raid_level_show(struct device *dev,
 	     struct device_attribute *attr, char *buf)
 {
@@ -637,7 +642,7 @@ static ssize_t raid_level_show(struct device *dev,
 	}
 
 	/* Is this even a logical drive? */
-	if (!is_logical_dev_addr_mode(hdev->scsi3addr)) {
+	if (!is_logical_device(hdev)) {
 		spin_unlock_irqrestore(&h->lock, flags);
 		l = snprintf(buf, PAGE_SIZE, "N/A\n");
 		return l;
@@ -771,8 +776,8 @@ static ssize_t path_info_show(struct device *dev,
 				scsi_device_type(hdev->devtype));
 
 		if (is_ext_target(h, hdev) ||
-			(hdev->devtype == TYPE_RAID) ||
-			is_logical_dev_addr_mode(hdev->scsi3addr)) {
+			hdev->devtype == TYPE_RAID ||
+			is_logical_device(hdev)) {
 			output_len += snprintf(path[i] + output_len,
 						PATH_STRING_LEN, "%s\n",
 						active);
@@ -1582,7 +1587,7 @@ static void hpsa_figure_phys_disk_ptrs(struct ctlr_info *h,
 		for (j = 0; j < ndevices; j++) {
 			if (dev[j]->devtype != TYPE_DISK)
 				continue;
-			if (is_logical_dev_addr_mode(dev[j]->scsi3addr))
+			if (is_logical_device(dev[j]))
 				continue;
 			if (dev[j]->ioaccel_handle != dd[i].ioaccel_handle)
 				continue;
@@ -1625,7 +1630,7 @@ static void hpsa_update_log_drive_phys_drive_ptrs(struct ctlr_info *h,
 	for (i = 0; i < ndevices; i++) {
 		if (dev[i]->devtype != TYPE_DISK)
 			continue;
-		if (!is_logical_dev_addr_mode(dev[i]->scsi3addr))
+		if (!is_logical_device(dev[i]))
 			continue;
 
 		/*
@@ -2228,7 +2233,7 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 	 * the normal I/O path so the controller can handle whatever's
 	 * wrong.
 	 */
-	if (is_logical_dev_addr_mode(dev->scsi3addr) &&
+	if (is_logical_device(dev) &&
 		c2->error_data.serv_response ==
 			IOACCEL2_SERV_RESPONSE_FAILURE) {
 		if (c2->error_data.status ==
@@ -2348,7 +2353,7 @@ static void complete_scsi_command(struct CommandList *cp)
 		 * the normal I/O path so the controller can handle whatever's
 		 * wrong.
 		 */
-		if (is_logical_dev_addr_mode(dev->scsi3addr)) {
+		if (is_logical_device(dev)) {
 			if (ei->CommandStatus == CMD_IOACCEL_DISABLED)
 				dev->offload_enabled = 0;
 			return hpsa_retry_cmd(h, cp);

