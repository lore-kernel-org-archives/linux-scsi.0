From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 3/3] hpsa: add box and bay information for enclosure devices
Date: Wed, 09 Dec 2015 15:18:57 -0600
Message-ID: <20151209211857.519.17381.stgit@brunhilda>
References: <20151209211816.519.50876.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:53610 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231AbbLIVXX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2015 16:23:23 -0500
In-Reply-To: <20151209211816.519.50876.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, james.bottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c     |  108 ++++++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/hpsa_cmd.h |   13 ++++++
 2 files changed, 114 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f8370b8..6f84ec7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -750,7 +750,6 @@ static ssize_t host_show_hp_ssd_smart_path_enabled(struct device *dev,
 }
 
 #define MAX_PATHS 8
-
 static ssize_t path_info_show(struct device *dev,
 	     struct device_attribute *attr, char *buf)
 {
@@ -792,9 +791,7 @@ static ssize_t path_info_show(struct device *dev,
 				hdev->bus, hdev->target, hdev->lun,
 				scsi_device_type(hdev->devtype));
 
-		if (hdev->external ||
-			hdev->devtype == TYPE_RAID ||
-			is_logical_device(hdev)) {
+		if (hdev->devtype == TYPE_RAID || is_logical_device(hdev)) {
 			output_len += scnprintf(buf + output_len,
 						PAGE_SIZE - output_len,
 						"%s\n", active);
@@ -808,8 +805,7 @@ static ssize_t path_info_show(struct device *dev,
 			phys_connector[0] = '0';
 		if (phys_connector[1] < '0')
 			phys_connector[1] = '0';
-		if (hdev->phys_connector[i] > 0)
-			output_len += scnprintf(buf + output_len,
+		output_len += scnprintf(buf + output_len,
 				PAGE_SIZE - output_len,
 				"PORT: %.2s ",
 				phys_connector);
@@ -3191,6 +3187,90 @@ out:
 	return rc;
 }
 
+/*
+ * get enclosure information
+ * struct ReportExtendedLUNdata *rlep - Used for BMIC drive number
+ * struct hpsa_scsi_dev_t *encl_dev - device entry for enclosure
+ * Uses id_physical_device to determine the box_index.
+ */
+static int hpsa_get_enclosure_info(struct ctlr_info *h,
+			unsigned char *scsi3addr,
+			struct ReportExtendedLUNdata *rlep, int rle_index,
+			struct hpsa_scsi_dev_t *encl_dev)
+{
+	int rc = -1;
+	struct CommandList *c = NULL;
+	struct ErrorInfo *ei = NULL;
+	struct bmic_sense_storage_box_params *bssbp = NULL;
+	struct bmic_identify_physical_device *id_phys = NULL;
+	struct ext_report_lun_entry *rle = &rlep->LUN[rle_index];
+	u16 bmic_device_index = 0;
+
+
+	bssbp = kzalloc(sizeof(*bssbp), GFP_KERNEL);
+	if (!bssbp)
+		goto out;
+
+	id_phys = kzalloc(sizeof(*id_phys), GFP_KERNEL);
+	if (!id_phys)
+		goto out;
+
+	bmic_device_index = GET_BMIC_DRIVE_NUMBER(&rle->lunid[0]);
+
+	if (bmic_device_index == 0xFF00)
+		goto out;
+
+	memset(id_phys, 0, sizeof(*id_phys));
+	rc = hpsa_bmic_id_physical_device(h, scsi3addr, bmic_device_index,
+						id_phys, sizeof(*id_phys));
+	if (rc) {
+		dev_warn(&h->pdev->dev, "%s: id_phys failed %d bdi[0x%x]\n",
+			__func__, encl_dev->external, bmic_device_index);
+		goto out;
+	}
+
+	c = cmd_alloc(h);
+
+	rc = fill_cmd(c, BMIC_SENSE_STORAGE_BOX_PARAMS, h, bssbp,
+			sizeof(*bssbp), 0, RAID_CTLR_LUNID, TYPE_CMD);
+
+	if (rc)
+		goto out;
+
+	if (id_phys->phys_connector[1] == 'E')
+		c->Request.CDB[5] = id_phys->box_index;
+	else
+		c->Request.CDB[5] = 0;
+
+	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE,
+						NO_TIMEOUT);
+	if (rc)
+		goto out;
+
+	ei = c->err_info;
+	if (ei->CommandStatus != 0 && ei->CommandStatus != CMD_DATA_UNDERRUN) {
+		rc = -1;
+		goto out;
+	}
+
+	encl_dev->box[id_phys->active_path_number] = bssbp->phys_box_on_port;
+	memcpy(&encl_dev->phys_connector[id_phys->active_path_number],
+		bssbp->phys_connector, sizeof(bssbp->phys_connector));
+
+	rc = IO_OK;
+out:
+	kfree(bssbp);
+	kfree(id_phys);
+
+	if (c)
+		cmd_free(h, c);
+
+	if (rc != IO_OK)
+		hpsa_show_dev_msg(KERN_INFO, h, encl_dev,
+			"Error, could not get enclosure information\n");
+	return rc;
+}
+
 static u64 hpsa_get_sas_address_from_report_physical(struct ctlr_info *h,
 						unsigned char *scsi3addr)
 {
@@ -4032,7 +4112,8 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 
 		/* skip masked non-disk devices */
 		if (MASKED_DEVICE(lunaddrbytes) && physical_device &&
-			(physdev_list->LUN[phys_dev_index].device_flags & 0x01))
+		   (physdev_list->LUN[phys_dev_index].device_type != 0x06) &&
+		   (physdev_list->LUN[phys_dev_index].device_flags & 0x01))
 			continue;
 
 		/* Get device type, vendor, model, device id */
@@ -4117,6 +4198,9 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 		case TYPE_TAPE:
 		case TYPE_MEDIUM_CHANGER:
 		case TYPE_ENCLOSURE:
+			hpsa_get_enclosure_info(h, lunaddrbytes,
+						physdev_list, phys_dev_index,
+						this_device);
 			ncurrent++;
 			break;
 		case TYPE_RAID:
@@ -6629,6 +6713,16 @@ static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 			c->Request.CDB[7] = (size >> 16) & 0xFF;
 			c->Request.CDB[8] = (size >> 8) & 0XFF;
 			break;
+		case BMIC_SENSE_STORAGE_BOX_PARAMS:
+			c->Request.CDBLen = 10;
+			c->Request.type_attr_dir =
+				TYPE_ATTR_DIR(cmd_type, ATTR_SIMPLE, XFER_READ);
+			c->Request.Timeout = 0;
+			c->Request.CDB[0] = BMIC_READ;
+			c->Request.CDB[6] = BMIC_SENSE_STORAGE_BOX_PARAMS;
+			c->Request.CDB[7] = (size >> 16) & 0xFF;
+			c->Request.CDB[8] = (size >> 8) & 0XFF;
+			break;
 		case BMIC_IDENTIFY_CONTROLLER:
 			c->Request.CDBLen = 10;
 			c->Request.type_attr_dir =
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index d92ef0d..6a919ad 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -291,6 +291,7 @@ struct SenseSubsystem_info {
 #define BMIC_SENSE_DIAG_OPTIONS 0xF5
 #define HPSA_DIAG_OPTS_DISABLE_RLD_CACHING 0x40000000
 #define BMIC_SENSE_SUBSYSTEM_INFORMATION 0x66
+#define BMIC_SENSE_STORAGE_BOX_PARAMS 0x65
 
 /* Command List Structure */
 union SCSI3Addr {
@@ -842,5 +843,17 @@ struct bmic_sense_subsystem_info {
 	u8	pad[332];
 };
 
+struct bmic_sense_storage_box_params {
+	u8	reserved[36];
+	u8	inquiry_valid;
+	u8	reserved_1[68];
+	u8	phys_box_on_port;
+	u8	reserved_2[22];
+	u16	connection_info;
+	u8	reserver_3[84];
+	u8	phys_connector[2];
+	u8	reserved_4[296];
+};
+
 #pragma pack()
 #endif /* HPSA_CMD_H */

