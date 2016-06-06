From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH] Add support for SCT Write Same
Date: Mon,  6 Jun 2016 12:58:10 -0500
Message-ID: <1465235890-15703-2-git-send-email-shaun@tancheff.com>
References: <1465235890-15703-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1465235890-15703-1-git-send-email-shaun@tancheff.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

SATA drives may support write same via SCT. This is useful
for setting the drive contents to a specific pattern (0's).

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
 drivers/ata/libata-scsi.c  | 31 +++++++++++++++++++++++++
 drivers/scsi/sd.c          | 25 +++++++++++---------
 include/linux/ata.h        | 58 ++++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  1 +
 4 files changed, 104 insertions(+), 11 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bfec66f..4f1a97b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3305,6 +3305,37 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
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
index 428c03e..c5c8424 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -52,6 +52,7 @@
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
 #include <linux/pr.h>
+#include <linux/ata.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 
@@ -794,7 +795,7 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
 	struct request_queue *q = sdkp->disk->queue;
 	unsigned int logical_block_size = sdkp->device->sector_size;
 
-	if (sdkp->device->no_write_same) {
+	if (sdkp->device->no_write_same && !sdkp->device->sct_write_same) {
 		sdkp->max_ws_blocks = 0;
 		goto out;
 	}
@@ -2761,24 +2762,26 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 {
 	struct scsi_device *sdev = sdkp->device;
 
-	if (sdev->host->no_write_same) {
-		sdev->no_write_same = 1;
-
-		return;
-	}
-
 	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY) < 0) {
-		/* too large values might cause issues with arcmsr */
-		int vpd_buf_len = 64;
-
 		sdev->no_report_opcodes = 1;
 
 		/* Disable WRITE SAME if REPORT SUPPORTED OPERATION
 		 * CODES is unsupported and the device has an ATA
 		 * Information VPD page (SAT).
 		 */
-		if (!scsi_get_vpd_page(sdev, 0x89, buffer, vpd_buf_len))
+		if (!scsi_get_vpd_page(sdev, 0x89, buffer, SD_BUF_SIZE)) {
 			sdev->no_write_same = 1;
+			if (ata_id_sct_write_same((u16 *)&buffer[60])) {
+				sdev->sct_write_same = 1;
+				sdkp->max_ws_blocks = SD_MAX_WS16_BLOCKS;
+			}
+		}
+	}
+
+	if (sdev->host->no_write_same) {
+		sdev->no_write_same = 1;
+
+		return;
 	}
 
 	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16) == 1)
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 99346be..cdffe1f 100644
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
@@ -1060,6 +1103,21 @@ static inline void ata_id_to_hd_driveid(u16 *id)
 #endif
 }
 
+/**
+ * _lba_to_cmd_ata() - Copy lba48 to ATA command
+ * @cmd: ATA command as an array of bytes
+ * @_lba: lba48 in the low 48 bits
+ */
+static inline void _lba_to_cmd_ata(u8 *cmd, u64 _lba)
+{
+	cmd[1] =  _lba	      & 0xff;
+	cmd[3] = (_lba >>  8) & 0xff;
+	cmd[5] = (_lba >> 16) & 0xff;
+	cmd[0] = (_lba >> 24) & 0xff;
+	cmd[2] = (_lba >> 32) & 0xff;
+	cmd[4] = (_lba >> 40) & 0xff;
+}
+
 /*
  * Write LBA Range Entries to the buffer that will cover the extent from
  * sector to sector + count.  This is used for TRIM and for ADD LBA(S)
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

