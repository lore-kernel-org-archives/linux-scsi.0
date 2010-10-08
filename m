From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] block: Make the integrity mapped property a bio flag
Date: Fri, 08 Oct 2010 01:19:22 -0400
Message-ID: <yq18w29s1lx.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:23002 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0JHFTg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2010 01:19:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-scsi@vger.kernel.org


Previously we tracked whether the integrity metadata had been remapped
using a request flag. This was fine for low-level retries. However, if
an I/O was redriven by upper layers we would end up remapping again,
causing the retry to fail.

Deprecate the REQ_INTEGRITY flag and introduce BIO_MAPPED_INTEGRITY
which enables filesystems to notify lower layers that the bio in
question has already been remapped.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 84be621..0cb39ff 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -375,21 +375,20 @@ int sd_dif_prepare(struct request *rq, sector_t hw_sector, unsigned int sector_s
 	unsigned int i, j;
 	u32 phys, virt;
 
-	/* Already remapped? */
-	if (rq->cmd_flags & REQ_INTEGRITY)
-		return 0;
-
 	sdkp = rq->bio->bi_bdev->bd_disk->private_data;
 
 	if (sdkp->protection_type == SD_DIF_TYPE3_PROTECTION)
 		return 0;
 
-	rq->cmd_flags |= REQ_INTEGRITY;
 	phys = hw_sector & 0xffffffff;
 
 	__rq_for_each_bio(bio, rq) {
 		struct bio_vec *iv;
 
+		/* Already remapped? */
+		if (bio_flagged(bio, BIO_MAPPED_INTEGRITY))
+			break;
+
 		virt = bio->bi_integrity->bip_sector & 0xffffffff;
 
 		bip_for_each_vec(iv, bio->bi_integrity, i) {
@@ -408,6 +407,8 @@ int sd_dif_prepare(struct request *rq, sector_t hw_sector, unsigned int sector_s
 
 			kunmap_atomic(sdt, KM_USER0);
 		}
+
+		bio->bi_flags |= BIO_MAPPED_INTEGRITY;
 	}
 
 	return 0;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index ca83a97..925b80d 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -97,6 +97,7 @@ struct bio {
 #define BIO_NULL_MAPPED 9	/* contains invalid user pages */
 #define BIO_FS_INTEGRITY 10	/* fs owns integrity data, not block layer */
 #define BIO_QUIET	11	/* Make BIO Quiet */
+#define BIO_MAPPED_INTEGRITY 12/* integrity metadata has been remapped */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
@@ -146,7 +147,6 @@ enum rq_flag_bits {
 	__REQ_ORDERED_COLOR,	/* is before or after barrier */
 	__REQ_ALLOCED,		/* request came from our alloc pool */
 	__REQ_COPY_USER,	/* contains copies of user pages */
-	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
 	__REQ_FLUSH,		/* request for cache flush */
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
@@ -187,7 +187,6 @@ enum rq_flag_bits {
 #define REQ_ORDERED_COLOR	(1 << __REQ_ORDERED_COLOR)
 #define REQ_ALLOCED		(1 << __REQ_ALLOCED)
 #define REQ_COPY_USER		(1 << __REQ_COPY_USER)
-#define REQ_INTEGRITY		(1 << __REQ_INTEGRITY)
 #define REQ_FLUSH		(1 << __REQ_FLUSH)
 #define REQ_IO_STAT		(1 << __REQ_IO_STAT)
 #define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
