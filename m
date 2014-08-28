From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 10/14] block: Relocate bio integrity flags
Date: Thu, 28 Aug 2014 15:31:28 -0400
Message-ID: <1409254292-2540-11-git-send-email-martin.petersen@oracle.com>
References: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32761 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaH1Tan (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Aug 2014 15:30:43 -0400
In-Reply-To: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, axboe@fb.com
Cc: hch@lst.de, sagig@mellanox.com, "Martin K. Petersen" <martin.petersen@oracle.com>

Move flags affecting the integrity code out of the bio bi_flags and into
the block integrity payload.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
---
 block/bio-integrity.c     | 4 ++--
 drivers/scsi/sd_dif.c     | 4 ++--
 include/linux/bio.h       | 9 ++++++++-
 include/linux/blk_types.h | 6 ++----
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index c6bc2faf2af7..7cac9c34615c 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -100,7 +100,7 @@ void bio_integrity_free(struct bio *bio)
 	struct bio_integrity_payload *bip = bio_integrity(bio);
 	struct bio_set *bs = bio->bi_pool;
 
-	if (bip->bip_owns_buf)
+	if (bip->bip_flags & BIP_BLOCK_INTEGRITY)
 		kfree(page_address(bip->bip_vec->bv_page) +
 		      bip->bip_vec->bv_offset);
 
@@ -293,7 +293,7 @@ int bio_integrity_prep(struct bio *bio)
 		return -EIO;
 	}
 
-	bip->bip_owns_buf = 1;
+	bip->bip_flags |= BIP_BLOCK_INTEGRITY;
 	bip->bip_iter.bi_size = len;
 	bip_set_seed(bip, bio->bi_iter.bi_sector);
 
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 1e971c6f8c2b..4ce636fdc15f 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -326,7 +326,7 @@ void sd_dif_prepare(struct request *rq, sector_t hw_sector,
 		unsigned int j;
 
 		/* Already remapped? */
-		if (bio_flagged(bio, BIO_MAPPED_INTEGRITY))
+		if (bip->bip_flags & BIP_MAPPED_INTEGRITY)
 			break;
 
 		virt = bip_get_seed(bip) & 0xffffffff;
@@ -347,7 +347,7 @@ void sd_dif_prepare(struct request *rq, sector_t hw_sector,
 			kunmap_atomic(sdt);
 		}
 
-		bio->bi_flags |= (1 << BIO_MAPPED_INTEGRITY);
+		bip->bip_flags |= BIP_MAPPED_INTEGRITY;
 	}
 }
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 3fd36660fd10..b508cf69206d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -315,7 +315,7 @@ struct bio_integrity_payload {
 	unsigned short		bip_slab;	/* slab the bip came from */
 	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
 	unsigned short		bip_max_vcnt;	/* integrity bio_vec slots */
-	unsigned		bip_owns_buf:1;	/* should free bip_buf */
+	unsigned short		bip_flags;	/* control flags */
 
 	struct work_struct	bip_work;	/* I/O completion */
 
@@ -323,6 +323,13 @@ struct bio_integrity_payload {
 	struct bio_vec		bip_inline_vecs[0];/* embedded bvec array */
 };
 
+enum bip_flags {
+	BIP_BLOCK_INTEGRITY	= 1 << 0, /* block layer owns integrity data */
+	BIP_MAPPED_INTEGRITY	= 1 << 1, /* ref tag has been remapped */
+	BIP_CTRL_NOCHECK	= 1 << 2, /* disable HBA integrity checking */
+	BIP_DISK_NOCHECK	= 1 << 3, /* disable disk integrity checking */
+};
+
 static inline sector_t bip_get_seed(struct bio_integrity_payload *bip)
 {
 	return bip->bip_iter.bi_sector;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 0b7084f7c136..c96939d488ed 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -120,10 +120,8 @@ struct bio {
 #define BIO_USER_MAPPED 6	/* contains user pages */
 #define BIO_EOPNOTSUPP	7	/* not supported */
 #define BIO_NULL_MAPPED 8	/* contains invalid user pages */
-#define BIO_FS_INTEGRITY 9	/* fs owns integrity data, not block layer */
-#define BIO_QUIET	10	/* Make BIO Quiet */
-#define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
-#define BIO_SNAP_STABLE	12	/* bio data must be snapshotted during write */
+#define BIO_QUIET	9	/* Make BIO Quiet */
+#define BIO_SNAP_STABLE	10	/* bio data must be snapshotted during write */
 
 /*
  * Flags starting here get preserved by bio_reset() - this includes
-- 
1.9.3

