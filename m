From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4/4] libata: Fix garbled Trim payload
Date: Fri, 20 Nov 2009 21:45:24 -0500
Message-ID: <1258771524-26673-5-git-send-email-martin.petersen__8902.78525553203$1258771621$gmane$org@oracle.com>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:42609 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbZKUCqc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2009 21:46:32 -0500
In-Reply-To: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, hch@infradead.org, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

ata_set_lba_range_entries confused indexes into a u64 buffer with byte
offsets.  Fix this up and document the return value.

Update the libata write same translation to reflect this.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/ata/libata-scsi.c |    8 ++++----
 include/linux/ata.h       |    9 +++++----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 08d4ab7..0c496f8 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2950,7 +2950,7 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 	const u8 *cdb = scmd->cmnd;
 	u64 block;
 	u32 n_block;
-	u32 size;
+	u32 trim_sectors;
 	void *buf;
 
 	/* we may not issue DMA commands if no DMA mode is set */
@@ -2973,13 +2973,13 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 		goto invalid_fld;
 
 	buf = page_address(sg_page(scsi_sglist(scmd)));
-	size = ata_set_lba_range_entries(buf, 512 / 8, block, n_block);
+	trim_sectors = ata_set_lba_range_entries(buf, 512 / 8, block, n_block);
 
 	tf->protocol = ATA_PROT_DMA;
 	tf->hob_feature = 0;
 	tf->feature = ATA_DSM_TRIM;
-	tf->hob_nsect = (size / 512) >> 8;
-	tf->nsect = size / 512;
+	tf->hob_nsect = trim_sectors >> 8;
+	tf->nsect = trim_sectors;
 	tf->command = ATA_CMD_DSM;
 	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE | ATA_TFLAG_LBA48 |
 		     ATA_TFLAG_WRITE;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index b18b2bb..150c9dc 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -983,7 +983,8 @@ static inline void ata_id_to_hd_driveid(u16 *id)
 /*
  * Write up to 'max' LBA Range Entries to the buffer that will cover the
  * extent from sector to sector + count.  This is used for TRIM and for
- * ADD LBA(S) TO NV CACHE PINNED SET.
+ * ADD LBA(S) TO NV CACHE PINNED SET.  Returns number of 512-byte
+ * sectors required to encode the range.
  */
 static inline unsigned ata_set_lba_range_entries(void *_buffer, unsigned max,
 						u64 sector, unsigned long count)
@@ -1001,9 +1002,9 @@ static inline unsigned ata_set_lba_range_entries(void *_buffer, unsigned max,
 		sector += 0xffff;
 	}
 
-	max = ALIGN(i * 8, 512);
-	memset(buffer + i, 0, max - i * 8);
-	return max;
+	memset(&buffer[i], 0, (max - i) * 8);
+
+	return ALIGN(i * 8, 512);
 }
 
 static inline int is_multi_taskfile(struct ata_taskfile *tf)
-- 
1.6.0.6

