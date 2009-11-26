From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4/5] libata: Report zeroed read after Trim and max discard size
Date: Thu, 26 Nov 2009 12:00:42 -0500
Message-ID: <1259254843-8326-5-git-send-email-martin.petersen__28549.570326186$1259255033$gmane$org@oracle.com>
References: <1259254843-8326-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:47621 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760878AbZKZRCr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2009 12:02:47 -0500
In-Reply-To: <1259254843-8326-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, hch@infradead.org, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Our current Trim payload is a single sector that can accommodate 64 *
65535 blocks being unmapped.  Report this value in the Block Limits
Maximum Unmap LBA count field.

If a storage device supports Trim and the DRAT and RZAT bits are set,
report TPRZ=1 in Read Capacity(16).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/ata/libata-scsi.c |   12 +++++++++---
 include/linux/ata.h       |   10 ++++++++++
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e0995c4..08d4ab7 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2116,8 +2116,10 @@ static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
 	 * that we support some form of unmap - in thise case via WRITE SAME
 	 * with the unmap bit set.
 	 */
-	if (ata_id_has_trim(args->id))
+	if (ata_id_has_trim(args->id)) {
+		put_unaligned_be32(65535 * 512 / 8, &rbuf[20]);
 		put_unaligned_be32(1, &rbuf[28]);
+	}
 
 	return 0;
 }
@@ -2412,8 +2414,12 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 		rbuf[14] = (lowest_aligned >> 8) & 0x3f;
 		rbuf[15] = lowest_aligned;
 
-		if (ata_id_has_trim(args->id))
-			rbuf[14] |= 0x80;
+		if (ata_id_has_trim(args->id)) {
+			rbuf[14] |= 0x80; /* TPE */
+
+			if (ata_id_has_zero_after_trim(args->id))
+				rbuf[14] |= 0x40; /* TPRZ */
+		}
 	}
 
 	return 0;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index e2595e8..b18b2bb 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -75,6 +75,7 @@ enum {
 	ATA_ID_EIDE_DMA_TIME	= 66,
 	ATA_ID_EIDE_PIO		= 67,
 	ATA_ID_EIDE_PIO_IORDY	= 68,
+	ATA_ID_ADDITIONAL_SUPP	= 69,
 	ATA_ID_QUEUE_DEPTH	= 75,
 	ATA_ID_MAJOR_VER	= 80,
 	ATA_ID_COMMAND_SET_1	= 82,
@@ -816,6 +817,15 @@ static inline int ata_id_has_trim(const u16 *id)
 	return 0;
 }
 
+static inline int ata_id_has_zero_after_trim(const u16 *id)
+{
+	/* DSM supported, deterministic read, and read zero after trim set */
+	if (ata_id_has_trim(id) && id[ATA_ID_ADDITIONAL_SUPP] & 0x4020)
+		return 1;
+
+	return 0;
+}
+
 static inline int ata_id_current_chs_valid(const u16 *id)
 {
 	/* For ATA-1 devices, if the INITIALIZE DEVICE PARAMETERS command
-- 
1.6.0.6

