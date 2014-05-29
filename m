From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 10/14] block: Integrity checksum flag
Date: Wed, 28 May 2014 23:28:44 -0400
Message-ID: <1401334128-15499-11-git-send-email-martin.petersen@oracle.com>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33073 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbaE2D3Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 23:29:24 -0400
In-Reply-To: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Make the choice of checksum a per-I/O property by introducing a flag
that can be inspected by the SCSI layer.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/bio-integrity.c  | 3 +++
 drivers/scsi/sd_dif.c  | 6 ++++--
 include/linux/bio.h    | 1 +
 include/linux/blkdev.h | 1 +
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 877bce028766..4eb7893a7559 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -303,6 +303,9 @@ int bio_integrity_prep(struct bio *bio)
 	bip->bip_iter.bi_size = len;
 	bip_set_seed(bip, bio->bi_iter.bi_sector);
 
+	if (bi->flags & BLK_INTEGRITY_IP_CHECKSUM)
+		bip_set_flag(bip, BIP_IP_CHECKSUM);
+
 	/* Map it */
 	offset = offset_in_page(buf);
 	for (i = 0 ; i < nr_pages ; i++) {
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 95d5cb806f58..033d30d37952 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -255,12 +255,14 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 		return;
 
 	/* Enable DMA of protection information */
-	if (scsi_host_get_guard(sdkp->device->host) & SHOST_DIX_GUARD_IP)
+	if (scsi_host_get_guard(sdkp->device->host) & SHOST_DIX_GUARD_IP) {
 		if (type == SD_DIF_TYPE3_PROTECTION)
 			blk_integrity_register(disk, &dif_type3_integrity_ip);
 		else
 			blk_integrity_register(disk, &dif_type1_integrity_ip);
-	else
+
+		disk->integrity->flags |= BLK_INTEGRITY_IP_CHECKSUM;
+	} else
 		if (type == SD_DIF_TYPE3_PROTECTION)
 			blk_integrity_register(disk, &dif_type3_integrity_crc);
 		else
diff --git a/include/linux/bio.h b/include/linux/bio.h
index adc806325c36..83e4725f6aca 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -309,6 +309,7 @@ enum bip_flags {
 	BIP_MAPPED_INTEGRITY,	/* integrity metadata has been remapped */
 	BIP_CTRL_NOCHECK,	/* disable controller integrity checking */
 	BIP_DISK_NOCHECK,	/* disable disk integrity checking */
+	BIP_IP_CHECKSUM,	/* IP checksum */
 };
 
 static inline bool bip_get_flag(struct bio_integrity_payload *bip,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4be0446a8817..9bf6f761f1ac 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1432,6 +1432,7 @@ enum blk_integrity_flags {
 	BLK_INTEGRITY_VERIFY		= 1 << 0,
 	BLK_INTEGRITY_GENERATE		= 1 << 1,
 	BLK_INTEGRITY_DISK		= 1 << 2,
+	BLK_INTEGRITY_IP_CHECKSUM	= 1 << 3,
 };
 
 struct blk_integrity_iter {
-- 
1.9.0

