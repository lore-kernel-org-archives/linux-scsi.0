From: tom.ty89@gmail.com
Subject: [PATCH v2 1/2] libata-scsi: improve TRIM translation
Date: Tue,  5 Jul 2016 14:45:55 +0800
Message-ID: <577b57b0.5b4c620a.37648.6c8d@mx.google.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:33857 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421AbcGEGqJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2016 02:46:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com, sergei.shtylyov@cogentembedded.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

Define TRIM_RANGE_SIZE and TRIM_RANGE_NUM so that the corresponding
functions can be more generalized. Also, conform to SBC by rejecting
WRITE SAME (16) commands with number of blocks that exceeds the limit
that is defined in the SATL.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bfec66f..029e738 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -75,6 +75,9 @@ static struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
 #define ALL_MPAGES 0x3f
 #define ALL_SUB_MPAGES 0xff
 
+#define TRIM_RANGE_SIZE 0xffff
+#define TRIM_RANGE_NUM 64 /* 512-byte payload / (6-byte LBA + 2-byte range per entry) */
+
 
 static const u8 def_rw_recovery_mpage[RW_RECOVERY_MPAGE_LEN] = {
 	RW_RECOVERY_MPAGE,
@@ -2314,7 +2317,7 @@ static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
 	 * with the unmap bit set.
 	 */
 	if (ata_id_has_trim(args->id)) {
-		put_unaligned_be64(65535 * 512 / 8, &rbuf[36]);
+		put_unaligned_be64(TRIM_RANGE_SIZE * TRIM_RANGE_NUM, &rbuf[36]);
 		put_unaligned_be32(1, &rbuf[28]);
 	}
 
@@ -3305,7 +3308,10 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 		goto invalid_param_len;
 
 	buf = page_address(sg_page(scsi_sglist(scmd)));
-	size = ata_set_lba_range_entries(buf, 512, block, n_block);
+	if (n_block <= TRIM_RANGE_SIZE * TRIM_RANGE_NUM)
+		size = ata_set_lba_range_entries(buf, TRIM_RANGE_NUM, block, n_block);
+	else
+		goto invalid_fld;
 
 	if (ata_ncq_enabled(dev) && ata_fpdma_dsm_supported(dev)) {
 		/* Newer devices support queued TRIM commands */
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 99346be..0971c3f 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -1071,7 +1071,7 @@ static inline unsigned ata_set_lba_range_entries(void *_buffer,
 	__le64 *buffer = _buffer;
 	unsigned i = 0, used_bytes;
 
-	while (i < buf_size / 8 ) { /* 6-byte LBA + 2-byte range per entry */
+	while (i < buf_size) {
 		u64 entry = sector |
 			((u64)(count > 0xffff ? 0xffff : count) << 48);
 		buffer[i++] = __cpu_to_le64(entry);
-- 
2.9.0

