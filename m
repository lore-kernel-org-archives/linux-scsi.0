From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/2] block: make blk_rq_map_user take a NULL user-space buffer
Date: Tue,  2 Sep 2008 16:20:19 +0900
Message-ID: <1220340020-4855-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220340020-4855-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:57311 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbYIBHVs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 03:21:48 -0400
In-Reply-To: <1220340020-4855-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jpyFUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This patch changes blk_rq_map_user to accept a NULL user-space buffer
with a READ command if rq_map_data is not NULL. Thus a caller can pass
page frames to lk_rq_map_user to just set up a request and bios with
page frames propely. bio_uncopy_user (called via blk_rq_unmap_user)
doesn't copy data to user space with such request.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-map.c     |   16 ++++++++++++----
 fs/bio.c            |    8 ++++----
 include/linux/bio.h |    1 +
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 572140c..4849fa3 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -42,7 +42,7 @@ static int __blk_rq_unmap_user(struct bio *bio)
 
 static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
 			     struct rq_map_data *map_data, void __user *ubuf,
-			     unsigned int len, gfp_t gfp_mask)
+			     unsigned int len, int null_mapped, gfp_t gfp_mask)
 {
 	unsigned long uaddr;
 	struct bio *bio, *orig_bio;
@@ -63,6 +63,9 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
+	if (null_mapped)
+		bio->bi_flags |= (1 << BIO_NULL_MAPPED);
+
 	orig_bio = bio;
 	blk_queue_bounce(q, &bio);
 
@@ -111,12 +114,17 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 {
 	unsigned long bytes_read = 0;
 	struct bio *bio = NULL;
-	int ret;
+	int ret, null_mapped = 0;
 
 	if (len > (q->max_hw_sectors << 9))
 		return -EINVAL;
-	if (!len || !ubuf)
+	if (!len)
 		return -EINVAL;
+	if (!ubuf) {
+		if (!map_data || rq_data_dir(rq) != READ)
+			return -EINVAL;
+		null_mapped = 1;
+	}
 
 	while (bytes_read != len) {
 		unsigned long map_len, end, start;
@@ -135,7 +143,7 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 			map_len -= PAGE_SIZE;
 
 		ret = __blk_rq_map_user(q, rq, map_data, ubuf, map_len,
-					gfp_mask);
+					null_mapped, gfp_mask);
 		if (ret < 0)
 			goto unmap_rq;
 		if (!bio)
diff --git a/fs/bio.c b/fs/bio.c
index 9d68ddb..3553029 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -547,11 +547,11 @@ static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
 int bio_uncopy_user(struct bio *bio)
 {
 	struct bio_map_data *bmd = bio->bi_private;
-	int ret;
-
-	ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs, bmd->nr_sgvecs, 1,
-			     bmd->is_our_pages);
+	int ret = 0;
 
+	if (!bio_flagged(bio, BIO_NULL_MAPPED))
+		ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
+				     bmd->nr_sgvecs, 1, bmd->is_our_pages);
 	bio_free_map_data(bmd);
 	bio_put(bio);
 	return ret;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index bc386cd..7af373f 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -108,6 +108,7 @@ struct bio {
 #define BIO_USER_MAPPED 6	/* contains user pages */
 #define BIO_EOPNOTSUPP	7	/* not supported */
 #define BIO_CPU_AFFINE	8	/* complete bio on same CPU as submitted */
+#define BIO_NULL_MAPPED 9	/* contains invalid user pages */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
-- 
1.5.4.2

