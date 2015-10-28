From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 1 14/25] hpsa: add function is_logical_device
Date: Wed, 28 Oct 2015 17:05:55 -0500
Message-ID: <20151028220555.5323.38019.stgit@brunhilda>
References: <20151028215206.5323.84194.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:49072 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755473AbbJ1WJl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Oct 2015 18:09:41 -0400
In-Reply-To: <20151028215206.5323.84194.stgit@brunhilda>
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
index 7c1a552..c1b053f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -619,6 +619,11 @@ static const char * const raid_label[] = { "0", "4", "1(+0)", "5", "5+1", "6",
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
@@ -639,7 +644,7 @@ static ssize_t raid_level_show(struct device *dev,
 	}
 
 	/* Is this even a logical drive? */
-	if (!is_logical_dev_addr_mode(hdev->scsi3addr)) {
+	if (!is_logical_device(hdev)) {
 		spin_unlock_irqrestore(&h->lock, flags);
 		l = snprintf(buf, PAGE_SIZE, "N/A\n");
 		return l;
@@ -773,8 +778,8 @@ static ssize_t path_info_show(struct device *dev,
 				scsi_device_type(hdev->devtype));
 
 		if (is_ext_target(h, hdev) ||
-			(hdev->devtype == TYPE_RAID) ||
-			is_logical_dev_addr_mode(hdev->scsi3addr)) {
+			hdev->devtype == TYPE_RAID ||
+			is_logical_device(hdev)) {
 			output_len += snprintf(path[i] + output_len,
 						PATH_STRING_LEN, "%s\n",
 						active);
@@ -1594,7 +1599,7 @@ static void hpsa_figure_phys_disk_ptrs(struct ctlr_info *h,
 				continue;
 			if (dev[j]->devtype != TYPE_DISK)
 				continue;
-			if (is_logical_dev_addr_mode(dev[j]->scsi3addr))
+			if (is_logical_device(dev[j]))
 				continue;
 			if (dev[j]->ioaccel_handle != dd[i].ioaccel_handle)
 				continue;
@@ -1639,7 +1644,7 @@ static void hpsa_update_log_drive_phys_drive_ptrs(struct ctlr_info *h,
 			continue;
 		if (dev[i]->devtype != TYPE_DISK)
 			continue;
-		if (!is_logical_dev_addr_mode(dev[i]->scsi3addr))
+		if (!is_logical_device(dev[i]))
 			continue;
 
 		/*
@@ -2246,7 +2251,7 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 	 * the normal I/O path so the controller can handle whatever's
 	 * wrong.
 	 */
-	if (is_logical_dev_addr_mode(dev->scsi3addr) &&
+	if (is_logical_device(dev) &&
 		c2->error_data.serv_response ==
 			IOACCEL2_SERV_RESPONSE_FAILURE) {
 		if (c2->error_data.status ==
@@ -2366,7 +2371,7 @@ static void complete_scsi_command(struct CommandList *cp)
 		 * the normal I/O path so the controller can handle whatever's
 		 * wrong.
 		 */
-		if (is_logical_dev_addr_mode(dev->scsi3addr)) {
+		if (is_logical_device(dev)) {
 			if (ei->CommandStatus == CMD_IOACCEL_DISABLED)
 				dev->offload_enabled = 0;
 			return hpsa_retry_cmd(h, cp);

