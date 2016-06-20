From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v3] Add support for SCT Write Same
Date: Mon, 20 Jun 2016 10:03:48 -0500
Message-ID: <1466435028-13886-2-git-send-email-shaun@tancheff.com>
References: <1466435028-13886-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp78.mediacombb.net ([68.66.77.78]:54483 "EHLO
	dsmdc-mail-smtp.mcomdc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755467AbcFTPFB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2016 11:05:01 -0400
In-Reply-To: <1466435028-13886-1-git-send-email-shaun@tancheff.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>

SATA drives may support write same via SCT. This is useful
for setting the drive contents to a specific pattern (0's).

If UNMAP is not set or TRIM is not available then
fall back to SCT WRITE SAME, if it is available.

In this way it would be possible to mimic lbprz for devices that 
support TRIM but fail to zero blocks reliably. For example a
file-system or DM target could issue a write same w/o unmap followed
by an trim.

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
v3:
 - Demux UNMAP/TRIM from WRITE SAME
v2:
 - Remove fugly ata hacking from sd.c
---
 drivers/ata/libata-scsi.c  | 80 +++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/sd.c          |  2 +-
 include/linux/ata.h        | 43 +++++++++++++++++++++++++
 include/scsi/scsi_device.h |  1 +
 4 files changed, 106 insertions(+), 20 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bfec66f..3dcc29e 100644
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
 
@@ -3272,6 +3275,7 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 	struct ata_taskfile *tf = &qc->tf;
 	struct scsi_cmnd *scmd = qc->scsicmd;
 	struct ata_device *dev = qc->dev;
+	struct scatterlist *sg;
 	const u8 *cdb = scmd->cmnd;
 	u64 block;
 	u32 n_block;
@@ -3279,6 +3283,8 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 	void *buf;
 	u16 fp;
 	u8 bp = 0xff;
+	u8 unmap = cdb[1] & 0x8;
+	bool use_sct = (unmap && ata_id_has_trim(dev->id)) ? false : true;
 
 	/* we may not issue DMA commands if no DMA mode is set */
 	if (unlikely(!dev->dma_mode))
@@ -3290,8 +3296,14 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 	}
 	scsi_16_lba_len(cdb, &block, &n_block);
 
-	/* for now we only support WRITE SAME with the unmap bit set */
-	if (unlikely(!(cdb[1] & 0x8))) {
+	/* effectivly ignore had_trim if NOTRIM horkage is flagged */
+	if (dev->horkage & ATA_HORKAGE_NOTRIM)
+		use_sct = true;
+
+	/*
+	 * If use_sct and SCT write same is not available then fail.
+	 */
+	if (use_sct && !ata_id_sct_write_same(dev->id)) {
 		fp = 1;
 		bp = 3;
 		goto invalid_fld;
@@ -3304,26 +3316,56 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 	if (!scsi_sg_count(scmd))
 		goto invalid_param_len;
 
-	buf = page_address(sg_page(scsi_sglist(scmd)));
-	size = ata_set_lba_range_entries(buf, 512, block, n_block);
+	sg = scsi_sglist(scmd);
+	buf = page_address(sg_page(sg)) + sg->offset;
 
-	if (ata_ncq_enabled(dev) && ata_fpdma_dsm_supported(dev)) {
-		/* Newer devices support queued TRIM commands */
-		tf->protocol = ATA_PROT_NCQ;
-		tf->command = ATA_CMD_FPDMA_SEND;
-		tf->hob_nsect = ATA_SUBCMD_FPDMA_SEND_DSM & 0x1f;
-		tf->nsect = qc->tag << 3;
-		tf->hob_feature = (size / 512) >> 8;
-		tf->feature = size / 512;
+	/*
+	 * if we only have SCT then ignore the state of unmap request
+	 * a zero the blocks.
+	 */
+	if (use_sct) {
+		u16 *sctpg = buf;
+
+		put_unaligned_le16(0x0002,  &sctpg[0]); /* SCT_ACT_WRITE_SAME */
+		put_unaligned_le16(0x0101,  &sctpg[1]); /* WRITE PTRN FG */
+		put_unaligned_le64(block,   &sctpg[2]);
+		put_unaligned_le64(n_block, &sctpg[6]);
+		put_unaligned_le32(0u,      &sctpg[10]);
 
-		tf->auxiliary = 1;
-	} else {
-		tf->protocol = ATA_PROT_DMA;
 		tf->hob_feature = 0;
-		tf->feature = ATA_DSM_TRIM;
-		tf->hob_nsect = (size / 512) >> 8;
-		tf->nsect = size / 512;
-		tf->command = ATA_CMD_DSM;
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
+	} else {
+		size = ata_set_lba_range_entries(buf, 512, block, n_block);
+
+		if (ata_ncq_enabled(dev) && ata_fpdma_dsm_supported(dev)) {
+			/* Newer devices support queued TRIM commands */
+			tf->protocol = ATA_PROT_NCQ;
+			tf->command = ATA_CMD_FPDMA_SEND;
+			tf->hob_nsect = ATA_SUBCMD_FPDMA_SEND_DSM & 0x1f;
+			tf->nsect = qc->tag << 3;
+			tf->hob_feature = (size / 512) >> 8;
+			tf->feature = size / 512;
+
+			tf->auxiliary = 1;
+		} else {
+			tf->protocol = ATA_PROT_DMA;
+			tf->hob_feature = 0;
+			tf->feature = ATA_DSM_TRIM;
+			tf->hob_nsect = (size / 512) >> 8;
+			tf->nsect = size / 512;
+			tf->command = ATA_CMD_DSM;
+		}
 	}
 
 	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE | ATA_TFLAG_LBA48 |
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

