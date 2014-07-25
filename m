From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 04/14] block: Remove bip_buf
Date: Fri, 25 Jul 2014 16:34:19 -0400
Message-ID: <1406320469-29352-5-git-send-email-martin.petersen@oracle.com>
References: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38302 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbaGYUdh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jul 2014 16:33:37 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6PKXaBP028161
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:37 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PKXZuK014318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:36 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PKXZdG003899
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:35 GMT
In-Reply-To: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

bip_buf is not really needed so we can remove it.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
---
 block/bio-integrity.c | 10 ++++++----
 include/linux/bio.h   |  3 ---
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 2c4bbc0aaa93..cea93a9553d6 100644
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
index f8b09d7020ef..38bcec55c4c6 100644
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

