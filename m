From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 04/14] block: Remove bip_buf
Date: Thu, 28 Aug 2014 15:31:22 -0400
Message-ID: <1409254292-2540-5-git-send-email-martin.petersen@oracle.com>
References: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22778 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbaH1Tad (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Aug 2014 15:30:33 -0400
In-Reply-To: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, axboe@fb.com
Cc: hch@lst.de, sagig@mellanox.com, "Martin K. Petersen" <martin.petersen@oracle.com>

bip_buf is not really needed so we can remove it.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
---
 block/bio-integrity.c | 10 ++++++----
 include/linux/bio.h   |  3 ---
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 9be2431475e5..e4a015f661fc 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -101,7 +101,8 @@ void bio_integrity_free(struct bio *bio)
 	struct bio_set *bs = bio->bi_pool;
 
 	if (bip->bip_owns_buf)
-		kfree(bip->bip_buf);
+		kfree(page_address(bip->bip_vec->bv_page) +
+		      bip->bip_vec->bv_offset);
 
 	if (bs) {
 		if (bip->bip_slab != BIO_POOL_NONE)
@@ -219,14 +220,16 @@ static int bio_integrity_generate_verify(struct bio *bio, int operate)
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
@@ -321,7 +324,6 @@ int bio_integrity_prep(struct bio *bio)
 	}
 
 	bip->bip_owns_buf = 1;
-	bip->bip_buf = buf;
 	bip->bip_iter.bi_size = len;
 	bip->bip_iter.bi_sector = bio->bi_iter.bi_sector;
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 63a0e53e238c..448d8c052cb7 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -310,9 +310,6 @@ struct bio_integrity_payload {
 
 	struct bvec_iter	bip_iter;
 
-	/* kill - should just use bip_vec */
-	void			*bip_buf;	/* generated integrity data */
-
 	bio_end_io_t		*bip_end_io;	/* saved I/O completion fn */
 
 	unsigned short		bip_slab;	/* slab the bip came from */
-- 
1.9.3

