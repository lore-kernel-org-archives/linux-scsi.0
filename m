From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 04/14] block: Remove bip_buf
Date: Wed, 28 May 2014 23:28:38 -0400
Message-ID: <1401334128-15499-5-git-send-email-martin.petersen@oracle.com>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26874 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbaE2D3G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 23:29:06 -0400
In-Reply-To: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

bip_buf is not really needed so we can remove it.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/bio-integrity.c | 10 ++++++----
 include/linux/bio.h   |  3 ---
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index f59cdc2e0e63..e06b3c807eef 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -99,7 +99,8 @@ void bio_integrity_free(struct bio *bio)
 	struct bio_set *bs = bio->bi_pool;
 
 	if (bip->bip_owns_buf)
-		kfree(bip->bip_buf);
+		kfree(page_address(bip->bip_vec->bv_page) +
+		      bip->bip_vec->bv_offset);
 
 	if (bs) {
 		if (bip->bip_slab != BIO_POOL_NONE)
@@ -225,14 +226,16 @@ static int bio_integrity_generate_verify(struct bio *bio, int operate)
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
 	struct blk_integrity_exchg bix;
 	struct bio_vec *bv;
+	struct bio_integrity_payload *bip = bio_integrity(bio);
 	sector_t sector;
 	unsigned int sectors, ret = 0, i;
-	void *prot_buf = bio_integrity(bio)->bip_buf;
+	void *prot_buf = page_address(bip->bip_vec->bv_page) +
+		bip->bip_vec->bv_offset;
 
 	if (operate)
 		sector = bio->bi_iter.bi_sector;
 	else
-		sector = bio_integrity(bio)->bip_iter.bi_sector;
+		sector = bip->bip_iter.bi_sector;
 
 	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	bix.sector_size = bi->sector_size;
@@ -327,7 +330,6 @@ int bio_integrity_prep(struct bio *bio)
 	}
 
 	bip->bip_owns_buf = 1;
-	bip->bip_buf = buf;
 	bip->bip_iter.bi_size = len;
 	bip->bip_iter.bi_sector = bio->bi_iter.bi_sector;
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index f7fa470c043e..5d9c7680280b 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -292,9 +292,6 @@ struct bio_integrity_payload {
 
 	struct bvec_iter	bip_iter;
 
-	/* kill - should just use bip_vec */
-	void			*bip_buf;	/* generated integrity data */
-
 	bio_end_io_t		*bip_end_io;	/* saved I/O completion fn */
 
 	unsigned short		bip_slab;	/* slab the bip came from */
-- 
1.9.0

