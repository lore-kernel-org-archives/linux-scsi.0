From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 11/14] block: Integrity checksum flag
Date: Thu, 28 Aug 2014 15:31:29 -0400
Message-ID: <1409254292-2540-12-git-send-email-martin.petersen@oracle.com>
References: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32796 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaH1Tap (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Aug 2014 15:30:45 -0400
In-Reply-To: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, axboe@fb.com
Cc: hch@lst.de, sagig@mellanox.com, "Martin K. Petersen" <martin.petersen@oracle.com>

Make the choice of checksum a per-I/O property by introducing a flag
that can be inspected by the SCSI layer. There are several reasons for
this:

 1. It allows us to switch choice of checksum without unloading and
    reloading the HBA driver.

 2. During error recovery we need to be able to tell the HBA that
    checksums read from disk should not be verified and converted to IP
    checksums.

 3. For error injection purposes we need to be able to write a bad guard
    tag to storage. Since the storage device only supports T10 CRC we
    need to be able to disable IP checksum conversion on the HBA.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
---
 block/bio-integrity.c  | 3 +++
 drivers/scsi/sd_dif.c  | 6 ++++--
 include/linux/bio.h    | 1 +
 include/linux/blkdev.h | 1 +
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 7cac9c34615c..b5327751fecc 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -297,6 +297,9 @@ int bio_integrity_prep(struct bio *bio)
 	bip->bip_iter.bi_size = len;
 	bip_set_seed(bip, bio->bi_iter.bi_sector);
 
+	if (bi->flags & BLK_INTEGRITY_IP_CHECKSUM)
+		bip->bip_flags |= BIP_IP_CHECKSUM;
+
 	/* Map it */
 	offset = offset_in_page(buf);
 	for (i = 0 ; i < nr_pages ; i++) {
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 4ce636fdc15f..2198abee619e 100644
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
index b508cf69206d..14bff3fe56d4 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -328,6 +328,7 @@ enum bip_flags {
 	BIP_MAPPED_INTEGRITY	= 1 << 1, /* ref tag has been remapped */
 	BIP_CTRL_NOCHECK	= 1 << 2, /* disable HBA integrity checking */
 	BIP_DISK_NOCHECK	= 1 << 3, /* disable disk integrity checking */
+	BIP_IP_CHECKSUM		= 1 << 4, /* IP checksum */
 };
 
 static inline sector_t bip_get_seed(struct bio_integrity_payload *bip)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index fc1ac3cab086..cbc3608d08c1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1468,6 +1468,7 @@ enum blk_integrity_flags {
 	BLK_INTEGRITY_VERIFY		= 1 << 0,
 	BLK_INTEGRITY_GENERATE		= 1 << 1,
 	BLK_INTEGRITY_DEVICE_CAPABLE	= 1 << 2,
+	BLK_INTEGRITY_IP_CHECKSUM	= 1 << 3,
 };
 
 struct blk_integrity_iter {
-- 
1.9.3

