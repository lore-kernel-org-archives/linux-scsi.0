From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/7] libata: remove SCT WRITE SAME support
Date: Mon, 20 Mar 2017 16:43:15 -0400
Message-ID: <20170320204319.12628-4-hch@lst.de>
References: <20170320204319.12628-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170320204319.12628-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com, axboe@kernel.dk
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This was already disabled a while ago because it caused I/O errors,
and it's severly getting into the way of the discard / write zeroes
rework.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ata/libata-scsi.c | 128 +++++++++++-----------------------------------
 1 file changed, 29 insertions(+), 99 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1ac70744ae7b..b93d7e33789a 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3393,46 +3393,6 @@ static size_t ata_format_dsm_trim_descr(struct scsi_cmnd *cmd, u32 trmax,
 }
 
 /**
- * ata_format_dsm_trim_descr() - SATL Write Same to ATA SCT Write Same
- * @cmd: SCSI command being translated
- * @lba: Starting sector
- * @num: Number of sectors to be zero'd.
- *
- * Rewrite the WRITE SAME payload to be an SCT Write Same formatted
- * descriptor.
- * NOTE: Writes a pattern (0's) in the foreground.
- *
- * Return: Number of bytes copied into sglist.
- */
-static size_t ata_format_sct_write_same(struct scsi_cmnd *cmd, u64 lba, u64 num)
-{
-	struct scsi_device *sdp = cmd->device;
-	size_t len = sdp->sector_size;
-	size_t r;
-	u16 *buf;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ata_scsi_rbuf_lock, flags);
-	buf = ((void *)ata_scsi_rbuf);
-
-	put_unaligned_le16(0x0002,  &buf[0]); /* SCT_ACT_WRITE_SAME */
-	put_unaligned_le16(0x0101,  &buf[1]); /* WRITE PTRN FG */
-	put_unaligned_le64(lba,     &buf[2]);
-	put_unaligned_le64(num,     &buf[6]);
-	put_unaligned_le32(0u,      &buf[10]); /* pattern */
-
-	WARN_ON(len > ATA_SCSI_RBUF_SIZE);
-
-	if (len > ATA_SCSI_RBUF_SIZE)
-		len = ATA_SCSI_RBUF_SIZE;
-
-	r = sg_copy_from_buffer(scsi_sglist(cmd), scsi_sg_count(cmd), buf, len);
-	spin_unlock_irqrestore(&ata_scsi_rbuf_lock, flags);
-
-	return r;
-}
-
-/**
  * ata_scsi_write_same_xlat() - SATL Write Same to ATA SCT Write Same
  * @qc: Command to be translated
  *
@@ -3468,26 +3428,17 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 	}
 	scsi_16_lba_len(cdb, &block, &n_block);
 
-	if (unmap) {
-		/* If trim is not enabled the cmd is invalid. */
-		if ((dev->horkage & ATA_HORKAGE_NOTRIM) ||
-		    !ata_id_has_trim(dev->id)) {
-			fp = 1;
-			bp = 3;
-			goto invalid_fld;
-		}
-		/* If the request is too large the cmd is invalid */
-		if (n_block > 0xffff * trmax) {
-			fp = 2;
-			goto invalid_fld;
-		}
-	} else {
-		/* If write same is not available the cmd is invalid */
-		if (!ata_id_sct_write_same(dev->id)) {
-			fp = 1;
-			bp = 3;
-			goto invalid_fld;
-		}
+	if (!unmap ||
+	    (dev->horkage & ATA_HORKAGE_NOTRIM) ||
+	    !ata_id_has_trim(dev->id)) {
+		fp = 1;
+		bp = 3;
+		goto invalid_fld;
+	}
+	/* If the request is too large the cmd is invalid */
+	if (n_block > 0xffff * trmax) {
+		fp = 2;
+		goto invalid_fld;
 	}
 
 	/*
@@ -3502,49 +3453,28 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 	 * For DATA SET MANAGEMENT TRIM in ACS-2 nsect (aka count)
 	 * is defined as number of 512 byte blocks to be transferred.
 	 */
-	if (unmap) {
-		size = ata_format_dsm_trim_descr(scmd, trmax, block, n_block);
-		if (size != len)
-			goto invalid_param_len;
 
-		if (ata_ncq_enabled(dev) && ata_fpdma_dsm_supported(dev)) {
-			/* Newer devices support queued TRIM commands */
-			tf->protocol = ATA_PROT_NCQ;
-			tf->command = ATA_CMD_FPDMA_SEND;
-			tf->hob_nsect = ATA_SUBCMD_FPDMA_SEND_DSM & 0x1f;
-			tf->nsect = qc->tag << 3;
-			tf->hob_feature = (size / 512) >> 8;
-			tf->feature = size / 512;
+	size = ata_format_dsm_trim_descr(scmd, trmax, block, n_block);
+	if (size != len)
+		goto invalid_param_len;
 
-			tf->auxiliary = 1;
-		} else {
-			tf->protocol = ATA_PROT_DMA;
-			tf->hob_feature = 0;
-			tf->feature = ATA_DSM_TRIM;
-			tf->hob_nsect = (size / 512) >> 8;
-			tf->nsect = size / 512;
-			tf->command = ATA_CMD_DSM;
-		}
-	} else {
-		size = ata_format_sct_write_same(scmd, block, n_block);
-		if (size != len)
-			goto invalid_param_len;
+	if (ata_ncq_enabled(dev) && ata_fpdma_dsm_supported(dev)) {
+		/* Newer devices support queued TRIM commands */
+		tf->protocol = ATA_PROT_NCQ;
+		tf->command = ATA_CMD_FPDMA_SEND;
+		tf->hob_nsect = ATA_SUBCMD_FPDMA_SEND_DSM & 0x1f;
+		tf->nsect = qc->tag << 3;
+		tf->hob_feature = (size / 512) >> 8;
+		tf->feature = size / 512;
 
-		tf->hob_feature = 0;
-		tf->feature = 0;
-		tf->hob_nsect = 0;
-		tf->nsect = 1;
-		tf->lbah = 0;
-		tf->lbam = 0;
-		tf->lbal = ATA_CMD_STANDBYNOW1;
-		tf->hob_lbah = 0;
-		tf->hob_lbam = 0;
-		tf->hob_lbal = 0;
-		tf->device = ATA_CMD_STANDBYNOW1;
+		tf->auxiliary = 1;
+	} else {
 		tf->protocol = ATA_PROT_DMA;
-		tf->command = ATA_CMD_WRITE_LOG_DMA_EXT;
-		if (unlikely(dev->flags & ATA_DFLAG_PIO))
-			tf->command = ATA_CMD_WRITE_LOG_EXT;
+		tf->hob_feature = 0;
+		tf->feature = ATA_DSM_TRIM;
+		tf->hob_nsect = (size / 512) >> 8;
+		tf->nsect = size / 512;
+		tf->command = ATA_CMD_DSM;
 	}
 
 	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE | ATA_TFLAG_LBA48 |
-- 
2.11.0
