From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v2] Add support for SCT Write Same
Date: Thu,  9 Jun 2016 01:32:47 -0500
Message-ID: <1465453967-11085-2-git-send-email-shaun@tancheff.com>
References: <1465453967-11085-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp81.mediacombb.net ([68.66.77.81]:54161 "EHLO
	dsmdc-mail-smtp.mcomdc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1423278AbcFIGdV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2016 02:33:21 -0400
In-Reply-To: <1465453967-11085-1-git-send-email-shaun@tancheff.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, Shaun Tancheff <shaun.tancheff@seagate.com>

SATA drives may support write same via SCT. This is useful
for setting the drive contents to a specific pattern (0's).

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
v2:
 - Remove fugly ata hacking from sd.c
---
 drivers/ata/libata-scsi.c  | 34 ++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c          |  2 +-
 include/linux/ata.h        | 43 +++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  1 +
 4 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bfec66f..b73eace 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1204,6 +1204,9 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 	if (!ata_id_has_unload(dev->id))
 		dev->flags |= ATA_DFLAG_NO_UNLOAD;
 
+	if (ata_id_sct_write_same(dev->id))
+		sdev->sct_write_same = 1;
+
 	/* configure max sectors */
 	blk_queue_max_hw_sectors(q, dev->max_sectors);
 
@@ -3305,6 +3308,37 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 		goto invalid_param_len;
 
 	buf = page_address(sg_page(scsi_sglist(scmd)));
+
+	if (ata_id_sct_write_same(dev->id)) {
+		u16 *sctpg = buf;
+
+		put_unaligned_le16(0x0002,  &sctpg[0]); /* SCT_ACT_WRITE_SAME */
+		put_unaligned_le16(0x0101,  &sctpg[1]); /* WRITE PTRN FG */
+		put_unaligned_le64(block,   &sctpg[2]);
+		put_unaligned_le64(n_block, &sctpg[6]);
+		put_unaligned_le32(0u,      &sctpg[10]);
+
+		tf->hob_feature = 0;
+		tf->feature = 0;
+		tf->hob_nsect = 0;
+		tf->nsect = 1;
+		tf->lbah = 0;
+		tf->lbam = 0;
+		tf->lbal = ATA_CMD_STANDBYNOW1;
+		tf->hob_lbah = 0;
+		tf->hob_lbam = 0;
+		tf->hob_lbal = 0;
+		tf->device = ATA_CMD_STANDBYNOW1;
+		tf->protocol = ATA_PROT_DMA;
+		tf->command = ATA_CMD_WRITE_LOG_DMA_EXT;
+		tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE |
+			     ATA_TFLAG_LBA48 | ATA_TFLAG_WRITE;
+
+		ata_qc_set_pc_nbytes(qc);
+
+		return 0;
+	}
+
 	size = ata_set_lba_range_entries(buf, 512, block, n_block);
 
 	if (ata_ncq_enabled(dev) && ata_fpdma_dsm_supported(dev)) {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f459dff..b5ffcd3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -794,7 +794,7 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
 	struct request_queue *q = sdkp->disk->queue;
 	unsigned int logical_block_size = sdkp->device->sector_size;
 
-	if (sdkp->device->no_write_same) {
+	if (sdkp->device->no_write_same && !sdkp->device->sct_write_same) {
 		sdkp->max_ws_blocks = 0;
 		goto out;
 	}
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 99346be..4132de3 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -104,6 +104,7 @@ enum {
 	ATA_ID_CFA_KEY_MGMT	= 162,
 	ATA_ID_CFA_MODES	= 163,
 	ATA_ID_DATA_SET_MGMT	= 169,
+	ATA_ID_SCT_CMD_XPORT	= 206,
 	ATA_ID_ROT_SPEED	= 217,
 	ATA_ID_PIO4		= (1 << 1),
 
@@ -778,6 +779,48 @@ static inline bool ata_id_sense_reporting_enabled(const u16 *id)
 }
 
 /**
+ *
+ * Word: 206 - SCT Command Transport
+ *    15:12 - Vendor Specific
+ *     11:6 - Reserved
+ *        5 - SCT Command Transport Data Tables supported
+ *        4 - SCT Command Transport Features Control supported
+ *        3 - SCT Command Transport Error Recovery Control supported
+ *        2 - SCT Command Transport Write Same supported
+ *        1 - SCT Command Transport Long Sector Access supported
+ *        0 - SCT Command Transport supported
+ */
+static inline bool ata_id_sct_data_tables(const u16 *id)
+{
+	return id[ATA_ID_SCT_CMD_XPORT] & (1 << 5) ? true : false;
+}
+
+static inline bool ata_id_sct_features_ctrl(const u16 *id)
+{
+	return id[ATA_ID_SCT_CMD_XPORT] & (1 << 4) ? true : false;
+}
+
+static inline bool ata_id_sct_error_recovery_ctrl(const u16 *id)
+{
+	return id[ATA_ID_SCT_CMD_XPORT] & (1 << 3) ? true : false;
+}
+
+static inline bool ata_id_sct_write_same(const u16 *id)
+{
+	return id[ATA_ID_SCT_CMD_XPORT] & (1 << 2) ? true : false;
+}
+
+static inline bool ata_id_sct_long_sector_access(const u16 *id)
+{
+	return id[ATA_ID_SCT_CMD_XPORT] & (1 << 1) ? true : false;
+}
+
+static inline bool ata_id_sct_supported(const u16 *id)
+{
+	return id[ATA_ID_SCT_CMD_XPORT] & (1 << 0) ? true : false;
+}
+
+/**
  *	ata_id_major_version	-	get ATA level of drive
  *	@id: Identify data
  *
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index a6c346d..66f5af7 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -157,6 +157,7 @@ struct scsi_device {
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
 	unsigned no_report_opcodes:1;	/* no REPORT SUPPORTED OPERATION CODES */
 	unsigned no_write_same:1;	/* no WRITE SAME command */
+	unsigned sct_write_same:1;	/* Has WRITE SAME via SCT Command */
 	unsigned use_16_for_rw:1; /* Use read/write(16) over read/write(10) */
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
-- 
2.8.1

