From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH] hpsa: add in sas transport
Date: Tue, 29 Sep 2015 17:21:54 -0500
Message-ID: <20150929222154.6433.60590.stgit@brunhilda>
References: <20150929221748.6433.53593.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:38320 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735AbbI2WZM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 18:25:12 -0400
Received: from bby1mta02.pmc-sierra.bc.ca (localhost.pmc-sierra.bc.ca [127.0.0.1])
	by localhost (Postfix) with SMTP id 1A66C8E0464
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 15:25:12 -0700 (PDT)
Received: from bby1uinfra02-temp.pmc-sierra.bc.ca (bby1uinfra02-temp.pmc-sierra.bc.ca [216.241.226.204])
	by bby1mta02.pmc-sierra.bc.ca (Postfix) with ESMTP id EE80D8E03B7
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 15:25:11 -0700 (PDT)
Received: from [127.0.1.1] (kirk.hou.lab.pmc-sierra.bc.ca [10.238.32.34])
	by bby1uinfra02-temp.pmc-sierra.bc.ca (Postfix) with ESMTP id B27B6E06DF
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 15:25:11 -0700 (PDT)
In-Reply-To: <20150929221748.6433.53593.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@pmcs.com>

customers want lsscsi -t to show sas addresses when
enumerating sas devices. The sas addresses are used
mainly to light drive LEDs for location.

Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c     |  704 ++++++++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/hpsa.h     |   37 ++
 drivers/scsi/hpsa_cmd.h |   14 +
 3 files changed, 677 insertions(+), 78 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3b35de0..ae811a7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -41,6 +41,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_transport_sas.h>
 #include <scsi/scsi_dbg.h>
 #include <linux/cciss_ioctl.h>
 #include <linux/string.h>
@@ -205,6 +206,16 @@ static struct board_type products[] = {
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
 
+static struct scsi_transport_template *hpsa_sas_transport_template;
+static int hpsa_add_sas_host(struct ctlr_info *h);
+static void hpsa_delete_sas_host(struct ctlr_info *h);
+static int hpsa_add_sas_device(struct hpsa_sas_node *hpsa_sas_node,
+			struct hpsa_scsi_dev_t *device);
+static void hpsa_remove_sas_device(struct hpsa_scsi_dev_t *device);
+static struct hpsa_scsi_dev_t
+	*hpsa_find_device_by_sas_rphy(struct ctlr_info *h,
+		struct sas_rphy *rphy);
+
 #define SCSI_CMD_BUSY ((struct scsi_cmnd *)&hpsa_cmd_busy)
 static const struct scsi_cmnd hpsa_cmd_busy;
 #define SCSI_CMD_IDLE ((struct scsi_cmnd *)&hpsa_cmd_idle)
@@ -275,6 +286,8 @@ static void hpsa_command_resubmit_worker(struct work_struct *work);
 static u32 lockup_detected(struct ctlr_info *h);
 static int detect_controller_lockup(struct ctlr_info *h);
 static int is_ext_target(struct ctlr_info *h, struct hpsa_scsi_dev_t *device);
+static inline int hpsa_scsi_do_report_phys_luns(struct ctlr_info *h,
+	struct ReportExtendedLUNdata *buf, int bufsize);
 
 static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
 {
@@ -617,6 +630,11 @@ static const char * const raid_label[] = { "0", "4", "1(+0)", "5", "5+1", "6",
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
@@ -637,7 +655,7 @@ static ssize_t raid_level_show(struct device *dev,
 	}
 
 	/* Is this even a logical drive? */
-	if (!is_logical_dev_addr_mode(hdev->scsi3addr)) {
+	if (!is_logical_device(hdev)) {
 		spin_unlock_irqrestore(&h->lock, flags);
 		l = snprintf(buf, PAGE_SIZE, "N/A\n");
 		return l;
@@ -771,8 +789,8 @@ static ssize_t path_info_show(struct device *dev,
 				scsi_device_type(hdev->devtype));
 
 		if (is_ext_target(h, hdev) ||
-			(hdev->devtype == TYPE_RAID) ||
-			is_logical_dev_addr_mode(hdev->scsi3addr)) {
+			hdev->devtype == TYPE_RAID ||
+			is_logical_device(hdev)) {
 			output_len += snprintf(path[i] + output_len,
 						PATH_STRING_LEN, "%s\n",
 						active);
@@ -791,8 +809,7 @@ static ssize_t path_info_show(struct device *dev,
 				PATH_STRING_LEN,
 				"PORT: %.2s ",
 				phys_connector);
-		if (hdev->devtype == TYPE_DISK &&
-			hdev->expose_state != HPSA_DO_NOT_EXPOSE) {
+		if (hdev->devtype == TYPE_DISK && hdev->expose_device) {
 			if (box == 0 || box == 0xFF) {
 				output_len += snprintf(path[i] + output_len,
 					PATH_STRING_LEN,
@@ -1148,7 +1165,7 @@ static inline void hpsa_show_dev_msg(const char *level, struct ctlr_info *h,
 				"RAID-?" : raid_label[dev->raid_level],
 			dev->offload_config ? '+' : '-',
 			dev->offload_enabled ? '+' : '-',
-			dev->expose_state);
+			dev->expose_device);
 }
 
 /* Add an entry into h->dev[] array. */
@@ -1221,7 +1238,7 @@ lun_assigned:
 	added[*nadded] = device;
 	(*nadded)++;
 	hpsa_show_dev_msg(KERN_INFO, h, device,
-		device->expose_state & HPSA_SCSI_ADD ? "added" : "masked");
+		device->expose_device ? "added" : "masked");
 	device->offload_to_be_enabled = device->offload_enabled;
 	device->offload_enabled = 0;
 	return 0;
@@ -1579,7 +1596,7 @@ static void hpsa_figure_phys_disk_ptrs(struct ctlr_info *h,
 		for (j = 0; j < ndevices; j++) {
 			if (dev[j]->devtype != TYPE_DISK)
 				continue;
-			if (is_logical_dev_addr_mode(dev[j]->scsi3addr))
+			if (is_logical_device(dev[j]))
 				continue;
 			if (dev[j]->ioaccel_handle != dd[i].ioaccel_handle)
 				continue;
@@ -1622,7 +1639,7 @@ static void hpsa_update_log_drive_phys_drive_ptrs(struct ctlr_info *h,
 	for (i = 0; i < ndevices; i++) {
 		if (dev[i]->devtype != TYPE_DISK)
 			continue;
-		if (!is_logical_dev_addr_mode(dev[i]->scsi3addr))
+		if (!is_logical_device(dev[i]))
 			continue;
 
 		/*
@@ -1638,6 +1655,45 @@ static void hpsa_update_log_drive_phys_drive_ptrs(struct ctlr_info *h,
 	}
 }
 
+static int hpsa_add_device(struct ctlr_info *h, struct hpsa_scsi_dev_t *device)
+{
+	int rc;
+
+	if (is_logical_device(device))
+		rc = scsi_add_device(h->scsi_host, device->bus,
+			device->target, device->lun);
+	else
+		rc = hpsa_add_sas_device(h->sas_host, device);
+
+	return rc;
+}
+
+static void hpsa_remove_device(struct ctlr_info *h,
+			struct hpsa_scsi_dev_t *device)
+{
+	if (is_logical_device(device)) {
+		struct scsi_device *sdev =
+			scsi_device_lookup(h->scsi_host, device->bus,
+				device->target, device->lun);
+		if (sdev) {
+			scsi_remove_device(sdev);
+			scsi_device_put(sdev);
+		} else {
+			/*
+			 * We don't expect to get here.  Future commands
+			 * to this device will get a selection timeout as
+			 * if the device were gone.
+			 */
+			dev_warn(&h->pdev->dev,
+				"didn't find scsi %d:%d:%d:%d for removal.",
+				h->scsi_host->host_no, device->bus,
+				device->target, device->lun);
+		}
+	} else {
+		hpsa_remove_sas_device(device);
+	}
+}
+
 static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 	struct hpsa_scsi_dev_t *sd[], int nsds)
 {
@@ -1650,14 +1706,13 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 	unsigned long flags;
 	struct hpsa_scsi_dev_t **added, **removed;
 	int nadded, nremoved;
-	struct Scsi_Host *sh = NULL;
 
 	added = kzalloc(sizeof(*added) * HPSA_MAX_DEVICES, GFP_KERNEL);
 	removed = kzalloc(sizeof(*removed) * HPSA_MAX_DEVICES, GFP_KERNEL);
 
 	if (!added || !removed) {
-		dev_warn(&h->pdev->dev, "out of memory in "
-			"adjust_hpsa_scsi_table\n");
+		dev_warn(&h->pdev->dev, "out of memory in %s\n",
+			__func__);
 		goto free_and_out;
 	}
 
@@ -1758,36 +1813,19 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 	if (hostno == -1 || !changes)
 		goto free_and_out;
 
-	sh = h->scsi_host;
 	/* Notify scsi mid layer of any removed devices */
 	for (i = 0; i < nremoved; i++) {
-		if (removed[i]->expose_state & HPSA_SCSI_ADD) {
-			struct scsi_device *sdev =
-				scsi_device_lookup(sh, removed[i]->bus,
-					removed[i]->target, removed[i]->lun);
-			if (sdev != NULL) {
-				scsi_remove_device(sdev);
-				scsi_device_put(sdev);
-			} else {
-				/*
-				 * We don't expect to get here.
-				 * future cmds to this device will get selection
-				 * timeout as if the device was gone.
-				 */
-				hpsa_show_dev_msg(KERN_WARNING, h, removed[i],
-					"didn't find device for removal.");
-			}
-		}
+		if (removed[i]->expose_device)
+			hpsa_remove_device(h, removed[i]);
 		kfree(removed[i]);
 		removed[i] = NULL;
 	}
 
 	/* Notify scsi mid layer of any added devices */
 	for (i = 0; i < nadded; i++) {
-		if (!(added[i]->expose_state & HPSA_SCSI_ADD))
+		if (!(added[i]->expose_device))
 			continue;
-		if (scsi_add_device(sh, added[i]->bus,
-			added[i]->target, added[i]->lun) == 0)
+		if (hpsa_add_device(h, added[i]) == 0)
 			continue;
 		hpsa_show_dev_msg(KERN_WARNING, h, added[i],
 					"addition failed, device not added.");
@@ -1826,15 +1864,28 @@ static int hpsa_slave_alloc(struct scsi_device *sdev)
 	struct hpsa_scsi_dev_t *sd;
 	unsigned long flags;
 	struct ctlr_info *h;
+	struct scsi_target *starget;
+	struct sas_rphy *rphy;
 
 	h = sdev_to_hba(sdev);
 	spin_lock_irqsave(&h->devlock, flags);
-	sd = lookup_hpsa_scsi_dev(h, sdev_channel(sdev),
-		sdev_id(sdev), sdev->lun);
-	if (likely(sd)) {
-		atomic_set(&sd->ioaccel_cmds_out, 0);
-		sdev->hostdata = (sd->expose_state & HPSA_SCSI_ADD) ? sd : NULL;
+
+	if (sdev_channel(sdev) == HPSA_PHYSICAL_DEVICE_BUS) {
+		starget = scsi_target(sdev);
+		rphy = target_to_rphy(starget);
+		sd = hpsa_find_device_by_sas_rphy(h, rphy);
+		if (sd) {
+			sd->target = sdev_id(sdev);
+			sd->lun = sdev->lun;
+		}
 	} else
+		sd = lookup_hpsa_scsi_dev(h, sdev_channel(sdev),
+			sdev_id(sdev), sdev->lun);
+
+	if (sd && sd->expose_device) {
+		atomic_set(&sd->ioaccel_cmds_out, 0);
+		sdev->hostdata = sd;
+	} else if (sd)
 		sdev->hostdata = NULL;
 	spin_unlock_irqrestore(&h->devlock, flags);
 	return 0;
@@ -1847,7 +1898,7 @@ static int hpsa_slave_configure(struct scsi_device *sdev)
 	int queue_depth;
 
 	sd = sdev->hostdata;
-	sdev->no_uld_attach = !sd || !(sd->expose_state & HPSA_ULD_ATTACH);
+	sdev->no_uld_attach = !sd || !sd->expose_device;
 
 	if (sd)
 		queue_depth = sd->queue_depth != 0 ?
@@ -2210,7 +2261,7 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 	 * the normal I/O path so the controller can handle whatever's
 	 * wrong.
 	 */
-	if (is_logical_dev_addr_mode(dev->scsi3addr) &&
+	if (is_logical_device(dev) &&
 		c2->error_data.serv_response ==
 			IOACCEL2_SERV_RESPONSE_FAILURE) {
 		if (c2->error_data.status ==
@@ -2330,7 +2381,7 @@ static void complete_scsi_command(struct CommandList *cp)
 		 * the normal I/O path so the controller can handle whatever's
 		 * wrong.
 		 */
-		if (is_logical_dev_addr_mode(dev->scsi3addr)) {
+		if (is_logical_device(dev)) {
 			if (ei->CommandStatus == CMD_IOACCEL_DISABLED)
 				dev->offload_enabled = 0;
 			return hpsa_retry_cmd(h, cp);
@@ -2984,6 +3035,38 @@ out:
 	return rc;
 }
 
+static int hpsa_bmic_sense_subsystem_information(struct ctlr_info *h,
+		unsigned char scsi3addr[], u16 bmic_device_index,
+		struct bmic_sense_subsystem_info *buf, size_t bufsize)
+{
+	int rc = IO_OK;
+	struct CommandList *c;
+	struct ErrorInfo *ei;
+
+	c = cmd_alloc(h);
+
+	rc = fill_cmd(c, BMIC_SENSE_SUBSYSTEM_INFORMATION, h, buf, bufsize,
+		0, RAID_CTLR_LUNID, TYPE_CMD);
+	if (rc)
+		goto out;
+
+	c->Request.CDB[2] = bmic_device_index & 0xff;
+	c->Request.CDB[9] = (bmic_device_index >> 8) & 0xff;
+
+	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
+				PCI_DMA_FROMDEVICE, NO_TIMEOUT);
+	if (rc)
+		goto out;
+	ei = c->err_info;
+	if (ei->CommandStatus != 0 && ei->CommandStatus != CMD_DATA_UNDERRUN) {
+		hpsa_scsi_interpret_error(h, c);
+		rc = -1;
+	}
+out:
+	cmd_free(h, c);
+	return rc;
+}
+
 static int hpsa_bmic_id_physical_device(struct ctlr_info *h,
 		unsigned char scsi3addr[], u16 bmic_device_index,
 		struct bmic_identify_physical_device *buf, size_t bufsize)
@@ -3010,6 +3093,7 @@ static int hpsa_bmic_id_physical_device(struct ctlr_info *h,
 	}
 out:
 	cmd_free(h, c);
+
 	return rc;
 }
 
@@ -3095,9 +3179,60 @@ out:
 	return;
 }
 
-/* Get the device id from inquiry page 0x83 */
+static u64 hpsa_get_sas_address_from_report_physical(struct ctlr_info *h,
+	unsigned char *scsi3addr)
+{
+	struct ReportExtendedLUNdata *physdev;
+	u32 nphysicals;
+	u64 sa = 0;
+	int i;
+
+	physdev = kzalloc(sizeof(*physdev), GFP_KERNEL);
+	if (!physdev)
+		return 0;
+
+	if (hpsa_scsi_do_report_phys_luns(h, physdev, sizeof(*physdev))) {
+		dev_err(&h->pdev->dev, "report physical LUNs failed.\n");
+		kfree(physdev);
+		return 0;
+	}
+	nphysicals = get_unaligned_be32(physdev->LUNListLength) / 24;
+
+	for (i = 0; i < nphysicals; i++) {
+		if (!memcmp(&physdev->LUN[i].lunid[0], scsi3addr, 8))
+			sa = get_unaligned_be64(&physdev->LUN[i].wwid[0]);
+	}
+
+	kfree(physdev);
+
+	return sa;
+}
+
+static void hpsa_get_sas_address(struct ctlr_info *h, unsigned char *scsi3addr,
+				struct hpsa_scsi_dev_t *dev)
+{
+	int rc;
+	u64 sa = 0;
+
+	if (is_hba_lunid(scsi3addr)) {
+		struct bmic_sense_subsystem_info ssi;
+
+		rc = hpsa_bmic_sense_subsystem_information(h,
+					scsi3addr, 0, &ssi, sizeof(ssi));
+		if (rc == 0) {
+			sa = get_unaligned_be64(&ssi.primary_world_wide_id[0]);
+			h->sas_address = sa;
+		}
+	} else {
+		sa = hpsa_get_sas_address_from_report_physical(h, scsi3addr);
+	}
+
+	dev->sas_address = sa;
+}
+
+/* Get a device id from inquiry page 0x83 */
 static int hpsa_get_device_id(struct ctlr_info *h, unsigned char *scsi3addr,
-	unsigned char *device_id, int buflen)
+	unsigned char *device_id, int index, int buflen)
 {
 	int rc;
 	unsigned char *buf;
@@ -3109,8 +3244,10 @@ static int hpsa_get_device_id(struct ctlr_info *h, unsigned char *scsi3addr,
 		return -ENOMEM;
 	rc = hpsa_scsi_do_inquiry(h, scsi3addr, VPD_PAGE | 0x83, buf, 64);
 	if (rc == 0)
-		memcpy(device_id, &buf[8], buflen);
+		memcpy(device_id, &buf[index], buflen);
+
 	kfree(buf);
+
 	return rc != 0;
 }
 
@@ -3339,6 +3476,18 @@ static int hpsa_device_supports_aborts(struct ctlr_info *h,
 	return rc;
 }
 
+static void sanitize_inquiry_string(unsigned char *s, int len)
+{
+	bool terminated = false;
+
+	for (; len > 0; (--len, ++s)) {
+		if (*s == 0)
+			terminated = true;
+		if (terminated || *s < 0x20 || *s > 0x7e)
+			*s = ' ';
+	}
+}
+
 static int hpsa_update_device_info(struct ctlr_info *h,
 	unsigned char scsi3addr[], struct hpsa_scsi_dev_t *this_device,
 	unsigned char *is_OBDR_device)
@@ -3365,6 +3514,9 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		goto bail_out;
 	}
 
+	sanitize_inquiry_string(&inq_buff[8], 8);
+	sanitize_inquiry_string(&inq_buff[16], 16);
+
 	this_device->devtype = (inq_buff[0] & 0x1f);
 	memcpy(this_device->scsi3addr, scsi3addr, 8);
 	memcpy(this_device->vendor, &inq_buff[8],
@@ -3373,7 +3525,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		sizeof(this_device->model));
 	memset(this_device->device_id, 0,
 		sizeof(this_device->device_id));
-	hpsa_get_device_id(h, scsi3addr, this_device->device_id,
+	hpsa_get_device_id(h, scsi3addr, this_device->device_id, 8,
 		sizeof(this_device->device_id));
 
 	if (this_device->devtype == TYPE_DISK &&
@@ -3460,38 +3612,37 @@ static int is_ext_target(struct ctlr_info *h, struct hpsa_scsi_dev_t *device)
 	return 0;
 }
 
-/* Helper function to assign bus, target, lun mapping of devices.
- * Puts non-external target logical volumes on bus 0, external target logical
- * volumes on bus 1, physical devices on bus 2. and the hba on bus 3.
+/*
+ * Helper function to assign bus, target, lun mapping of devices.
  * Logical drive target and lun are assigned at this time, but
  * physical device lun and target assignment are deferred (assigned
  * in hpsa_find_target_lun, called by hpsa_scsi_add_entry.)
- */
+*/
 static void figure_bus_target_lun(struct ctlr_info *h,
 	u8 *lunaddrbytes, struct hpsa_scsi_dev_t *device)
 {
-	u32 lunid = le32_to_cpu(*((__le32 *) lunaddrbytes));
+	u32 lunid = le32_to_cpu(*((__le32 *)lunaddrbytes));
 
 	if (!is_logical_dev_addr_mode(lunaddrbytes)) {
 		/* physical device, target and lun filled in later */
 		if (is_hba_lunid(lunaddrbytes))
-			hpsa_set_bus_target_lun(device, 3, 0, lunid & 0x3fff);
+			hpsa_set_bus_target_lun(device,
+					HPSA_HBA_BUS, 0, lunid & 0x3fff);
 		else
 			/* defer target, lun assignment for physical devices */
-			hpsa_set_bus_target_lun(device, 2, -1, -1);
+			hpsa_set_bus_target_lun(device,
+					HPSA_PHYSICAL_DEVICE_BUS, -1, -1);
 		return;
 	}
 	/* It's a logical device */
 	if (is_ext_target(h, device)) {
-		/* external target way, put logicals on bus 1
-		 * and match target/lun numbers box
-		 * reports, other smart array, bus 0, target 0, match lunid
-		 */
 		hpsa_set_bus_target_lun(device,
-			1, (lunid >> 16) & 0x3fff, lunid & 0x00ff);
+			HPSA_EXTERNAL_RAID_VOLUME_BUS, (lunid >> 16) & 0x3fff,
+			lunid & 0x00ff);
 		return;
 	}
-	hpsa_set_bus_target_lun(device, 0, 0, lunid & 0x3fff);
+	hpsa_set_bus_target_lun(device, HPSA_RAID_VOLUME_BUS,
+				0, lunid & 0x3fff);
 }
 
 /*
@@ -3620,6 +3771,11 @@ static int hpsa_gather_lun_info(struct ctlr_info *h,
 	return 0;
 }
 
+/*
+ * Helper function that figures out where the LUN ID info is coming from
+ * given index i, lists of physical and logical devices, where in
+ * the list the raid controller is supposed to appear (first or last).
+ */
 static u8 *figure_lunaddrbytes(struct ctlr_info *h, int raid_ctlr_position,
 	int i, int nphysicals, int nlogicals,
 	struct ReportExtendedLUNdata *physdev_list,
@@ -3724,6 +3880,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 	int ncurrent = 0;
 	int i, n_ext_target_devs, ndevs_to_allocate;
 	int raid_ctlr_position;
+	bool physical_device;
 	DECLARE_BITMAP(lunzerobits, MAX_EXT_TARGETS);
 
 	currentsd = kzalloc(sizeof(*currentsd) * HPSA_MAX_DEVICES, GFP_KERNEL);
@@ -3778,14 +3935,15 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		u8 *lunaddrbytes, is_OBDR = 0;
 		int phys_dev_index = i - (raid_ctlr_position == 0);
 
+		physical_device = i < nphysicals + (raid_ctlr_position == 0);
+
 		/* Figure out where the LUN ID info is coming from */
 		lunaddrbytes = figure_lunaddrbytes(h, raid_ctlr_position,
 			i, nphysicals, nlogicals, physdev_list, logdev_list);
 
 		/* skip masked non-disk devices */
-		if (MASKED_DEVICE(lunaddrbytes))
-			if (i < nphysicals + (raid_ctlr_position == 0) &&
-				(physdev_list->LUN[phys_dev_index].device_flags & 0x01))
+		if (MASKED_DEVICE(lunaddrbytes) && physical_device &&
+			(physdev_list->LUN[phys_dev_index].device_flags & 0x01))
 				continue;
 
 		/* Get device type, vendor, model, device id */
@@ -3800,26 +3958,34 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		 * For external target devices, we have to insert a LUN 0 which
 		 * doesn't show up in CCISS_REPORT_PHYSICAL data, but there
 		 * is nonetheless an enclosure device there.  We have to
-		 * present that otherwise linux won't find anything if
-		 * there is no lun 0.
+		 * present that otherwise Linux won't find anything if
+		 * there is no LUN 0.
 		 */
 		if (add_ext_target_dev(h, tmpdevice, this_device,
-				lunaddrbytes, lunzerobits,
-				&n_ext_target_devs)) {
+			lunaddrbytes, lunzerobits,
+			&n_ext_target_devs)) {
 			ncurrent++;
 			this_device = currentsd[ncurrent];
 		}
 
 		*this_device = *tmpdevice;
+		this_device->physical_device = physical_device;
 
-		/* do not expose masked devices */
-		if (MASKED_DEVICE(lunaddrbytes) &&
-			i < nphysicals + (raid_ctlr_position == 0)) {
-			this_device->expose_state = HPSA_DO_NOT_EXPOSE;
-		} else {
-			this_device->expose_state =
-					HPSA_SG_ATTACH | HPSA_ULD_ATTACH;
-		}
+		/*
+		 * Expose all devices except for physical devices that
+		 * are masked.
+		 */
+		if (this_device->physical_device &&
+			MASKED_DEVICE(lunaddrbytes))
+				this_device->expose_device = 0;
+		else
+			this_device->expose_device = 1;
+
+		/*
+		 * Get the SAS address for physical devices that are exposed.
+		 */
+		if (this_device->physical_device && this_device->expose_device)
+			hpsa_get_sas_address(h, lunaddrbytes, this_device);
 
 		switch (this_device->devtype) {
 		case TYPE_ROM:
@@ -3834,7 +4000,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 				ncurrent++;
 			break;
 		case TYPE_DISK:
-			if (i < nphysicals + (raid_ctlr_position == 0)) {
+			if (this_device->physical_device) {
 				/* The disk is in HBA mode. */
 				/* Never use RAID mapper in HBA mode. */
 				this_device->offload_enabled = 0;
@@ -3849,8 +4015,6 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		case TYPE_MEDIUM_CHANGER:
 		case TYPE_ENCLOSURE:
 			ncurrent++;
-			this_device->expose_state =
-					HPSA_SG_ATTACH | HPSA_ULD_ATTACH;
 			break;
 		case TYPE_RAID:
 			/* Only present the Smartarray HBA as a RAID controller.
@@ -3868,6 +4032,10 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		if (ncurrent >= HPSA_MAX_DEVICES)
 			break;
 	}
+
+	if (h->sas_host == NULL)
+		hpsa_add_sas_host(h);
+
 	adjust_hpsa_scsi_table(h, hostno, currentsd, ncurrent);
 out:
 	kfree(tmpdevice);
@@ -4998,6 +5166,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 	sh->can_queue = h->nr_cmds - HPSA_NRESERVED_CMDS;
 	sh->cmd_per_lun = sh->can_queue;
 	sh->sg_tablesize = h->maxsgentries;
+	sh->transportt = hpsa_sas_transport_template;
 	sh->hostdata[0] = (unsigned long) h;
 	sh->irq = h->intr[h->intr_mode];
 	sh->unique_id = sh->irq;
@@ -6325,6 +6494,16 @@ static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 			c->Request.CDB[7] = (size >> 16) & 0xFF;
 			c->Request.CDB[8] = (size >> 8) & 0XFF;
 			break;
+		case BMIC_SENSE_SUBSYSTEM_INFORMATION:
+			c->Request.CDBLen = 10;
+			c->Request.type_attr_dir =
+				TYPE_ATTR_DIR(cmd_type, ATTR_SIMPLE, XFER_READ);
+			c->Request.Timeout = 0;
+			c->Request.CDB[0] = BMIC_READ;
+			c->Request.CDB[6] = BMIC_SENSE_SUBSYSTEM_INFORMATION;
+			c->Request.CDB[7] = (size >> 16) & 0xFF;
+			c->Request.CDB[8] = (size >> 8) & 0XFF;
+			break;
 		default:
 			dev_warn(&h->pdev->dev, "unknown command 0x%c\n", cmd);
 			BUG();
@@ -8324,6 +8503,11 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	free_percpu(h->lockup_detected);		/* init_one 2 */
 	h->lockup_detected = NULL;			/* init_one 2 */
 	/* (void) pci_disable_pcie_error_reporting(pdev); */	/* init_one 1 */
+
+	printk("%s: Calling hpsa_delete_sas_host\n", __func__);
+	hpsa_delete_sas_host(h);
+	printk("%s: Called hpsa_delete_sas_host\n", __func__);
+
 	kfree(h);					/* init_one 1 */
 }
 
@@ -8786,18 +8970,384 @@ static void hpsa_drain_accel_commands(struct ctlr_info *h)
 	} while (1);
 }
 
+static struct hpsa_sas_phy *hpsa_alloc_sas_phy(
+				struct hpsa_sas_port *hpsa_sas_port)
+{
+	struct hpsa_sas_phy *hpsa_sas_phy;
+	struct sas_phy *phy;
+
+	hpsa_sas_phy = kzalloc(sizeof(*hpsa_sas_phy), GFP_KERNEL);
+	if (!hpsa_sas_phy)
+		return NULL;
+
+	phy = sas_phy_alloc(hpsa_sas_port->parent_node->parent_dev,
+		hpsa_sas_port->next_phy_index);
+	if (!phy) {
+		kfree(hpsa_sas_phy);
+		return NULL;
+	}
+
+	hpsa_sas_port->next_phy_index++;
+	hpsa_sas_phy->phy = phy;
+	hpsa_sas_phy->parent_port = hpsa_sas_port;
+
+	return hpsa_sas_phy;
+}
+
+static void hpsa_free_sas_phy(struct hpsa_sas_phy *hpsa_sas_phy)
+{
+	struct sas_phy *phy = hpsa_sas_phy->phy;
+
+	printk("%s: Calling sas_port_delete_phy\n", __func__);
+	sas_port_delete_phy(hpsa_sas_phy->parent_port->port, phy);
+	printk("%s: Called sas_port_delete_phy\n", __func__);
+	sas_phy_free(phy);
+	printk("%s: Called sas_phy_free\n", __func__);
+	if (hpsa_sas_phy->added_to_port)
+		list_del(&hpsa_sas_phy->phy_list_entry);
+	kfree(hpsa_sas_phy);
+}
+
+static int hpsa_sas_port_add_phy(struct hpsa_sas_phy *hpsa_sas_phy)
+{
+	int rc;
+	struct hpsa_sas_port *hpsa_sas_port;
+	struct sas_phy *phy;
+	struct sas_identify *identify;
+
+	hpsa_sas_port = hpsa_sas_phy->parent_port;
+	phy = hpsa_sas_phy->phy;
+
+	identify = &phy->identify;
+	memset(identify, 0, sizeof(*identify));
+	identify->sas_address = hpsa_sas_port->sas_address;
+	identify->device_type = SAS_END_DEVICE;
+	identify->initiator_port_protocols = SAS_PROTOCOL_STP;
+	identify->target_port_protocols = SAS_PROTOCOL_STP;
+	phy->minimum_linkrate_hw = SAS_LINK_RATE_UNKNOWN;
+	phy->maximum_linkrate_hw = SAS_LINK_RATE_UNKNOWN;
+	phy->minimum_linkrate = SAS_LINK_RATE_UNKNOWN;
+	phy->maximum_linkrate = SAS_LINK_RATE_UNKNOWN;
+	phy->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
+
+	rc = sas_phy_add(hpsa_sas_phy->phy);
+	if (rc)
+		return rc;
+
+	sas_port_add_phy(hpsa_sas_port->port, hpsa_sas_phy->phy);
+	list_add_tail(&hpsa_sas_phy->phy_list_entry,
+			&hpsa_sas_port->phy_list_head);
+	hpsa_sas_phy->added_to_port = true;
+
+	return 0;
+}
+
+static int
+	hpsa_sas_port_add_rphy(struct hpsa_sas_port *hpsa_sas_port,
+				struct sas_rphy *rphy)
+{
+	struct sas_identify *identify;
+
+	identify = &rphy->identify;
+	identify->sas_address = hpsa_sas_port->sas_address;
+	identify->initiator_port_protocols = SAS_PROTOCOL_STP;
+	identify->target_port_protocols = SAS_PROTOCOL_STP;
+
+	return sas_rphy_add(rphy);
+}
+
+static struct hpsa_sas_port
+	*hpsa_alloc_sas_port(struct hpsa_sas_node *hpsa_sas_node,
+				u64 sas_address)
+{
+	int rc;
+	struct hpsa_sas_port *hpsa_sas_port;
+	struct sas_port *port;
+
+	hpsa_sas_port = kzalloc(sizeof(*hpsa_sas_port), GFP_KERNEL);
+	if (!hpsa_sas_port)
+		return NULL;
+
+	INIT_LIST_HEAD(&hpsa_sas_port->phy_list_head);
+	hpsa_sas_port->parent_node = hpsa_sas_node;
+
+	port = sas_port_alloc_num(hpsa_sas_node->parent_dev);
+	if (!port)
+		goto free_hpsa_port;
+
+	rc = sas_port_add(port);
+	if (rc)
+		goto free_sas_port;
+
+	hpsa_sas_port->port = port;
+	hpsa_sas_port->sas_address = sas_address;
+	list_add_tail(&hpsa_sas_port->port_list_entry,
+			&hpsa_sas_node->port_list_head);
+
+	return hpsa_sas_port;
+
+free_sas_port:
+	sas_port_free(port);
+free_hpsa_port:
+	kfree(hpsa_sas_port);
+
+	return NULL;
+}
+
+static void hpsa_free_sas_port(struct hpsa_sas_port *hpsa_sas_port)
+{
+	struct hpsa_sas_phy *hpsa_sas_phy;
+	struct hpsa_sas_phy *next;
+
+	list_for_each_entry_safe(hpsa_sas_phy, next,
+			&hpsa_sas_port->phy_list_head, phy_list_entry) {
+		printk("%s: Calling hpsa_free_sas_phy\n", __func__);
+		hpsa_free_sas_phy(hpsa_sas_phy);
+		printk("%s: Called hpsa_free_sas_phy\n", __func__);
+	}
+
+	printk("%s: Calling sas_port_delete\n", __func__);
+	sas_port_delete(hpsa_sas_port->port);
+	printk("%s: Called sas_port_delete\n", __func__);
+	list_del(&hpsa_sas_port->port_list_entry);
+	kfree(hpsa_sas_port);
+}
+
+static struct hpsa_sas_node *hpsa_alloc_sas_node(struct device *parent_dev)
+{
+	struct hpsa_sas_node *hpsa_sas_node;
+
+	hpsa_sas_node = kzalloc(sizeof(*hpsa_sas_node), GFP_KERNEL);
+	if (hpsa_sas_node) {
+		hpsa_sas_node->parent_dev = parent_dev;
+		INIT_LIST_HEAD(&hpsa_sas_node->port_list_head);
+	}
+
+	return hpsa_sas_node;
+}
+
+static void hpsa_free_sas_node(struct hpsa_sas_node *hpsa_sas_node)
+{
+	struct hpsa_sas_port *hpsa_sas_port;
+	struct hpsa_sas_port *next;
+
+	if (!hpsa_sas_node)
+		return;
+
+	list_for_each_entry_safe(hpsa_sas_port, next,
+			&hpsa_sas_node->port_list_head, port_list_entry) {
+		printk("%s: Calling hpsa_free_sas_port\n", __func__);
+		hpsa_free_sas_port(hpsa_sas_port);
+		printk("%s: Called hpsa_free_sas_port\n", __func__);
+	}
+
+	printk("%s: Calling kfree hpsa_sas_node\n", __func__);
+	kfree(hpsa_sas_node);
+	printk("%s: Called kfree hpsa_sas_node\n", __func__);
+}
+
+static struct hpsa_scsi_dev_t
+	*hpsa_find_device_by_sas_rphy(struct ctlr_info *h,
+					struct sas_rphy *rphy)
+{
+	int i;
+	struct hpsa_scsi_dev_t *device;
+
+	for (i = 0; i < h->ndevices; i++) {
+		device = h->dev[i];
+		if (!device->sas_port)
+			continue;
+		if (device->sas_port->rphy == rphy)
+			return device;
+	}
+
+	return NULL;
+}
+
+static int hpsa_add_sas_host(struct ctlr_info *h)
+{
+	int rc;
+	struct device *parent_dev;
+	struct hpsa_sas_node *hpsa_sas_node;
+	struct hpsa_sas_port *hpsa_sas_port;
+	struct hpsa_sas_phy *hpsa_sas_phy;
+
+	parent_dev = &h->scsi_host->shost_gendev;
+
+	hpsa_sas_node = hpsa_alloc_sas_node(parent_dev);
+	if (!hpsa_sas_node)
+		return -ENOMEM;
+
+	hpsa_sas_port = hpsa_alloc_sas_port(hpsa_sas_node, h->sas_address);
+	if (!hpsa_sas_port) {
+		rc = -ENODEV;
+		goto free_sas_node;
+	}
+
+	hpsa_sas_phy = hpsa_alloc_sas_phy(hpsa_sas_port);
+	if (!hpsa_sas_phy) {
+		rc = -ENODEV;
+		goto free_sas_port;
+	}
+
+	rc = hpsa_sas_port_add_phy(hpsa_sas_phy);
+	if (rc)
+		goto free_sas_phy;
+
+	h->sas_host = hpsa_sas_node;
+
+	return 0;
+
+free_sas_phy:
+	hpsa_free_sas_phy(hpsa_sas_phy);
+free_sas_port:
+	hpsa_free_sas_port(hpsa_sas_port);
+free_sas_node:
+	hpsa_free_sas_node(hpsa_sas_node);
+
+	return rc;
+}
+
+static void hpsa_delete_sas_host(struct ctlr_info *h)
+{
+	printk("%s: Calling hpsa_free_sas_node\n", __func__);
+	hpsa_free_sas_node(h->sas_host);
+	printk("%s: Called hpsa_free_sas_node\n", __func__);
+}
+
+static int hpsa_add_sas_device(struct hpsa_sas_node *hpsa_sas_node,
+				struct hpsa_scsi_dev_t *device)
+{
+	int rc;
+	struct hpsa_sas_port *hpsa_sas_port;
+	struct sas_rphy *rphy;
+
+	hpsa_sas_port = hpsa_alloc_sas_port(hpsa_sas_node, device->sas_address);
+	if (!hpsa_sas_port)
+		return -ENOMEM;
+
+	rphy = sas_end_device_alloc(hpsa_sas_port->port);
+	if (!rphy) {
+		rc = -ENODEV;
+		goto free_sas_port;
+	}
+
+	hpsa_sas_port->rphy = rphy;
+	device->sas_port = hpsa_sas_port;
+
+	rc = hpsa_sas_port_add_rphy(hpsa_sas_port, rphy);
+	if (rc)
+		goto free_sas_port;
+
+	return 0;
+
+free_sas_port:
+	hpsa_free_sas_port(hpsa_sas_port);
+	device->sas_port = NULL;
+
+	return rc;
+}
+
+static void hpsa_remove_sas_device(struct hpsa_scsi_dev_t *device)
+{
+	if (device->sas_port) {
+		hpsa_free_sas_port(device->sas_port);
+		device->sas_port = NULL;
+	}
+}
+
+static int
+hpsa_sas_get_linkerrors(struct sas_phy *phy)
+{
+	return 0;
+}
+
+static int
+hpsa_sas_get_enclosure_identifier(struct sas_rphy *rphy, u64 *identifier)
+{
+	return 0;
+}
+
+static int
+hpsa_sas_get_bay_identifier(struct sas_rphy *rphy)
+{
+	return -ENXIO;
+}
+
+static int
+hpsa_sas_phy_reset(struct sas_phy *phy, int hard_reset)
+{
+	return 0;
+}
+
+static int
+hpsa_sas_phy_enable(struct sas_phy *phy, int enable)
+{
+	return 0;
+}
+
+static int
+hpsa_sas_phy_setup(struct sas_phy *phy)
+{
+	return 0;
+}
+
+static void
+hpsa_sas_phy_release(struct sas_phy *phy)
+{
+}
+
+static int
+hpsa_sas_phy_speed(struct sas_phy *phy, struct sas_phy_linkrates *rates)
+{
+	return -EINVAL;
+}
+
+/* SMP = Serial Management Protocol */
+static int
+hpsa_sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
+struct request *req)
+{
+	return -EINVAL;
+}
+
+static struct sas_function_template hpsa_sas_transport_functions = {
+	.get_linkerrors = hpsa_sas_get_linkerrors,
+	.get_enclosure_identifier = hpsa_sas_get_enclosure_identifier,
+	.get_bay_identifier = hpsa_sas_get_bay_identifier,
+	.phy_reset = hpsa_sas_phy_reset,
+	.phy_enable = hpsa_sas_phy_enable,
+	.phy_setup = hpsa_sas_phy_setup,
+	.phy_release = hpsa_sas_phy_release,
+	.set_phy_speed = hpsa_sas_phy_speed,
+	.smp_handler = hpsa_sas_smp_handler,
+};
+
 /*
  *  This is it.  Register the PCI driver information for the cards we control
  *  the OS will call our registered routines when it finds one of our cards.
  */
 static int __init hpsa_init(void)
 {
-	return pci_register_driver(&hpsa_pci_driver);
+	int rc;
+
+	hpsa_sas_transport_template =
+		sas_attach_transport(&hpsa_sas_transport_functions);
+	if (!hpsa_sas_transport_template)
+		return -ENODEV;
+
+	rc = pci_register_driver(&hpsa_pci_driver);
+
+	if (rc)
+		sas_release_transport(hpsa_sas_transport_template);
+
+	return rc;
 }
 
 static void __exit hpsa_cleanup(void)
 {
 	pci_unregister_driver(&hpsa_pci_driver);
+	sas_release_transport(hpsa_sas_transport_template);
 }
 
 static void __attribute__((unused)) verify_offsets(void)
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 27fcd4c..c110e6c 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -33,12 +33,38 @@ struct access_method {
 	unsigned long (*command_completed)(struct ctlr_info *h, u8 q);
 };
 
+/* for SAS hosts and SAS expanders */
+struct hpsa_sas_node {
+	struct device *parent_dev;
+	struct list_head port_list_head;
+};
+
+struct hpsa_sas_port {
+	struct list_head port_list_entry;
+	u64 sas_address;
+	struct sas_port *port;
+	int	next_phy_index;
+	struct list_head phy_list_head;
+	struct hpsa_sas_node *parent_node;
+	struct sas_rphy *rphy;
+};
+
+struct hpsa_sas_phy {
+	struct list_head phy_list_entry;
+	struct sas_phy *phy;
+	struct hpsa_sas_port *parent_port;
+	bool	added_to_port;
+};
+
 struct hpsa_scsi_dev_t {
-	int devtype;
+	int devtype;			/* as reported by INQUIRY commmand */
 	int bus, target, lun;		/* as presented to the OS */
 	unsigned char scsi3addr[8];	/* as presented to the HW */
+	u8 physical_device : 1;
+	u8 expose_device : 1;
 #define RAID_CTLR_LUNID "\0\0\0\0\0\0\0\0"
 	unsigned char device_id[16];    /* from inquiry pg. 0x83 */
+	u64 sas_address;                /* from inquiry pg. 0x83 */
 	unsigned char vendor[8];        /* bytes 8-15 of inquiry data */
 	unsigned char model[16];        /* bytes 16-31 of inquiry data */
 	unsigned char raid_level;	/* from inquiry page 0xC1 */
@@ -80,6 +106,7 @@ struct hpsa_scsi_dev_t {
 #define HPSA_ULD_ATTACH		0x2
 #define HPSA_SCSI_ADD		(HPSA_SG_ATTACH | HPSA_ULD_ATTACH)
 	u8 expose_state;
+	struct hpsa_sas_port *sas_port;
 };
 
 struct reply_queue_buffer {
@@ -136,6 +163,7 @@ struct ctlr_info {
 	char    *product_name;
 	struct pci_dev *pdev;
 	u32	board_id;
+	u64	sas_address;
 	void __iomem *vaddr;
 	unsigned long paddr;
 	int 	nr_cmds; /* Number of commands allowed on this controller */
@@ -270,6 +298,7 @@ struct ctlr_info {
 	wait_queue_head_t abort_cmd_wait_queue;
 	wait_queue_head_t event_sync_wait_queue;
 	struct mutex reset_mutex;
+	struct hpsa_sas_node *sas_host;
 };
 
 struct offline_device_entry {
@@ -368,6 +397,12 @@ struct offline_device_entry {
 #define IOACCEL2_INBOUND_POSTQ_64_LOW	0xd0
 #define IOACCEL2_INBOUND_POSTQ_64_HI	0xd4
 
+#define HPSA_PHYSICAL_DEVICE_BUS       0
+#define HPSA_RAID_VOLUME_BUS           1
+#define HPSA_EXTERNAL_RAID_VOLUME_BUS  2
+#define HPSA_HBA_BUS                   3
+
+
 /*
 	Send the command to the hardware
 */
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index c2c0737..1721aec 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -286,6 +286,7 @@ struct SenseSubsystem_info {
 #define BMIC_FLASH_FIRMWARE 0xF7
 #define BMIC_SENSE_CONTROLLER_PARAMETERS 0x64
 #define BMIC_IDENTIFY_PHYSICAL_DEVICE 0x15
+#define BMIC_SENSE_SUBSYSTEM_INFORMATION 0x66
 
 /* Command List Structure */
 union SCSI3Addr {
@@ -814,5 +815,18 @@ struct bmic_identify_physical_device {
 	u8     padding[112];
 };
 
+struct bmic_sense_subsystem_info {
+	u8	primary_slot_number;
+	u8	reserved[3];
+	u8	chasis_serial_number[32];
+	u8	primary_world_wide_id[8];
+	u8	primary_array_serial_number[32]; /* NULL terminated */
+	u8	primary_cache_serial_number[32]; /* NULL terminated */
+	u8	reserved_2[8];
+	u8	secondary_array_serial_number[32];
+	u8	secondary_cache_serial_number[32];
+	u8	pad[332];
+};
+
 #pragma pack()
 #endif /* HPSA_CMD_H */

