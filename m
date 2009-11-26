From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5/5] libata: Clarify ata_set_lba_range_entries function
Date: Thu, 26 Nov 2009 12:00:43 -0500
Message-ID: <1259254843-8326-6-git-send-email-martin.petersen__1316.04994317076$1259255024$gmane$org@oracle.com>
References: <1259254843-8326-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:20123 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760852AbZKZRCm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2009 12:02:42 -0500
In-Reply-To: <1259254843-8326-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, hch@infradead.org, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

ata_set_lba_range_entries used the variable max for two different things
which was confusing.  Make the function take a buffer size in bytes as
argument and return the used buffer size upon completion.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/ata/libata-scsi.c |    2 +-
 include/linux/ata.h       |   20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 08d4ab7..e06ee7b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2973,7 +2973,7 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 		goto invalid_fld;
 
 	buf = page_address(sg_page(scsi_sglist(scmd)));
-	size = ata_set_lba_range_entries(buf, 512 / 8, block, n_block);
+	size = ata_set_lba_range_entries(buf, 512, block, n_block);
 
 	tf->protocol = ATA_PROT_DMA;
 	tf->hob_feature = 0;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index b18b2bb..54a8ffb 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -981,17 +981,17 @@ static inline void ata_id_to_hd_driveid(u16 *id)
 }
 
 /*
- * Write up to 'max' LBA Range Entries to the buffer that will cover the
- * extent from sector to sector + count.  This is used for TRIM and for
- * ADD LBA(S) TO NV CACHE PINNED SET.
+ * Write LBA Range Entries to the buffer that will cover the extent from
+ * sector to sector + count.  This is used for TRIM and for ADD LBA(S)
+ * TO NV CACHE PINNED SET.
  */
-static inline unsigned ata_set_lba_range_entries(void *_buffer, unsigned max,
-						u64 sector, unsigned long count)
+static inline unsigned ata_set_lba_range_entries(void *_buffer,
+		unsigned buf_size, u64 sector, unsigned long count)
 {
 	__le64 *buffer = _buffer;
-	unsigned i = 0;
+	unsigned i = 0, used_bytes;
 
-	while (i < max) {
+	while (i < buf_size / 8 ) { /* 6-byte LBA + 2-byte range per entry */
 		u64 entry = sector |
 			((u64)(count > 0xffff ? 0xffff : count) << 48);
 		buffer[i++] = __cpu_to_le64(entry);
@@ -1001,9 +1001,9 @@ static inline unsigned ata_set_lba_range_entries(void *_buffer, unsigned max,
 		sector += 0xffff;
 	}
 
-	max = ALIGN(i * 8, 512);
-	memset(buffer + i, 0, max - i * 8);
-	return max;
+	used_bytes = ALIGN(i * 8, 512);
+	memset(buffer + i, 0, used_bytes - i * 8);
+	return used_bytes;
 }
 
 static inline int is_multi_taskfile(struct ata_taskfile *tf)
-- 
1.6.0.6

