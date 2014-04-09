From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/2] block: Fix integrity verification
Date: Tue,  8 Apr 2014 22:43:44 -0400
Message-ID: <1397011424-10970-2-git-send-email-martin.petersen@oracle.com>
References: <1397011424-10970-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51090 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbaDICoN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Apr 2014 22:44:13 -0400
In-Reply-To: <1397011424-10970-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Gu Zheng <guz.fnst@cn.fujitsu.com>

From: "Martin K. Petersen" <martin.petersen@oracle.com>

Commit bf36f9cfa6d3d caused a regression by effectively reverting Nic's
fix from 5837c80e870b that ensures we traverse the full bio_vec list
upon completion.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/bio-integrity.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 29696b78d1f4..b355b98dbf1b 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -309,10 +309,9 @@ static int bio_integrity_generate_verify(struct bio *bio, int operate)
 {
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
 	struct blk_integrity_exchg bix;
-	struct bio_vec bv;
-	struct bvec_iter iter;
+	struct bio_vec *bv;
 	sector_t sector;
-	unsigned int sectors, ret = 0;
+	unsigned int sectors, ret = 0, i;
 	void *prot_buf = bio->bi_integrity->bip_buf;
 
 	if (operate)
@@ -323,16 +322,16 @@ static int bio_integrity_generate_verify(struct bio *bio, int operate)
 	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	bix.sector_size = bi->sector_size;
 
-	bio_for_each_segment(bv, bio, iter) {
-		void *kaddr = kmap_atomic(bv.bv_page);
-		bix.data_buf = kaddr + bv.bv_offset;
-		bix.data_size = bv.bv_len;
+	bio_for_each_segment_all(bv, bio, i) {
+		void *kaddr = kmap_atomic(bv->bv_page);
+		bix.data_buf = kaddr + bv->bv_offset;
+		bix.data_size = bv->bv_len;
 		bix.prot_buf = prot_buf;
 		bix.sector = sector;
 
-		if (operate) {
+		if (operate)
 			bi->generate_fn(&bix);
-		} else {
+		else {
 			ret = bi->verify_fn(&bix);
 			if (ret) {
 				kunmap_atomic(kaddr);
@@ -340,7 +339,7 @@ static int bio_integrity_generate_verify(struct bio *bio, int operate)
 			}
 		}
 
-		sectors = bv.bv_len / bi->sector_size;
+		sectors = bv->bv_len / bi->sector_size;
 		sector += sectors;
 		prot_buf += sectors * bi->tuple_size;
 
-- 
1.8.3.1

