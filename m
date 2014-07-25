From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 11/14] block: Integrity checksum flag
Date: Fri, 25 Jul 2014 16:34:26 -0400
Message-ID: <1406320469-29352-12-git-send-email-martin.petersen@oracle.com>
References: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22830 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935080AbaGYUds (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jul 2014 16:33:48 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6PKXkFf030944
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:47 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PKXkwG020431
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:46 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PKXk8d014728
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:46 GMT
In-Reply-To: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

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
---
 block/bio-integrity.c  | 3 +++
 drivers/scsi/sd_dif.c  | 6 ++++--
 include/linux/bio.h    | 1 +
 include/linux/blkdev.h | 1 +
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 63460cc34abe..31795b05339e 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -303,6 +303,9 @@ int bio_integrity_prep(struct bio *bio)
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
index 2657425629a8..a60195e07cff 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -327,6 +327,7 @@ enum bip_flags {
 	BIP_MAPPED_INTEGRITY	= 1 << 1, /* ref tag has been remapped */
 	BIP_CTRL_NOCHECK	= 1 << 2, /* disable HBA integrity checking */
 	BIP_DISK_NOCHECK	= 1 << 3, /* disable disk integrity checking */
+	BIP_IP_CHECKSUM		= 1 << 4, /* IP checksum */
 };
 
 static inline sector_t bip_get_seed(struct bio_integrity_payload *bip)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 57ac257c6872..68570d6cfec9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1466,6 +1466,7 @@ enum blk_integrity_flags {
 	BLK_INTEGRITY_VERIFY		= 1 << 0,
 	BLK_INTEGRITY_GENERATE		= 1 << 1,
 	BLK_INTEGRITY_DEVICE_CAPABLE	= 1 << 2,
+	BLK_INTEGRITY_IP_CHECKSUM	= 1 << 3,
 };
 
 struct blk_integrity_iter {
-- 
1.9.3

