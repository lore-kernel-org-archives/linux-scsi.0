From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/3] bio: convert bio_copy_kern to use bio_copy_user
Date: Thu, 28 Aug 2008 15:05:57 +0900
Message-ID: <1219903559-32612-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1219903559-32612-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:49410 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbYH1GIC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2008 02:08:02 -0400
In-Reply-To: <1219903559-32612-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

bio_copy_kern and bio_copy_user are very similar. This converts
bio_copy_kern to use bio_copy_user.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 fs/bio.c |   54 ++++--------------------------------------------------
 1 files changed, 4 insertions(+), 50 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index a2f0726..9d68ddb 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -995,48 +995,13 @@ static void bio_copy_kern_endio(struct bio *bio, int err)
 struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 			  gfp_t gfp_mask, int reading)
 {
-	unsigned long kaddr = (unsigned long)data;
-	unsigned long end = (kaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	unsigned long start = kaddr >> PAGE_SHIFT;
-	const int nr_pages = end - start;
 	struct bio *bio;
 	struct bio_vec *bvec;
-	struct bio_map_data *bmd;
-	int i, ret;
-	struct sg_iovec iov;
-
-	iov.iov_base = data;
-	iov.iov_len = len;
-
-	bmd = bio_alloc_map_data(nr_pages, 1, gfp_mask);
-	if (!bmd)
-		return ERR_PTR(-ENOMEM);
-
-	ret = -ENOMEM;
-	bio = bio_alloc(gfp_mask, nr_pages);
-	if (!bio)
-		goto out_bmd;
-
-	while (len) {
-		struct page *page;
-		unsigned int bytes = PAGE_SIZE;
-
-		if (bytes > len)
-			bytes = len;
-
-		page = alloc_page(q->bounce_gfp | gfp_mask);
-		if (!page) {
-			ret = -ENOMEM;
-			goto cleanup;
-		}
-
-		if (bio_add_pc_page(q, bio, page, bytes, 0) < bytes) {
-			ret = -EINVAL;
-			goto cleanup;
-		}
+	int i;
 
-		len -= bytes;
-	}
+	bio = bio_copy_user(q, NULL, (unsigned long)data, len, 1, gfp_mask);
+	if (IS_ERR(bio))
+		return bio;
 
 	if (!reading) {
 		void *p = data;
@@ -1049,20 +1014,9 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 		}
 	}
 
-	bio->bi_private = bmd;
 	bio->bi_end_io = bio_copy_kern_endio;
 
-	bio_set_map_data(bmd, bio, &iov, 1, 1);
 	return bio;
-cleanup:
-	bio_for_each_segment(bvec, bio, i)
-		__free_page(bvec->bv_page);
-
-	bio_put(bio);
-out_bmd:
-	bio_free_map_data(bmd);
-
-	return ERR_PTR(ret);
 }
 
 /*
-- 
1.5.5.GIT

