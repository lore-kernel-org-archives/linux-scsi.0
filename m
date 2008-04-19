From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: add dma alignment and padding support to
 blk_rq_map_kern
Date: Sat, 19 Apr 2008 20:28:28 +0900
Message-ID: <20080419202757Z.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:52558 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbYDSL2p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Apr 2008 07:28:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: htejun@gmail.com, jens.axboe@oracle.com

blk_rq_map_kern ignores dma alignment and padding. Is it problematic
to libata?

This is against Jens' for-2.6.26 branch.

==
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: add dma alignment and padding support to blk_rq_map_kern

This patch adds bio_copy_kern similar to
bio_copy_user. blk_rq_map_kern uses bio_copy_kern instead of
bio_map_kern if necessary.

bio_copy_kern uses temporary pages and the bi_end_io callback frees
these pages. bio_copy_kern saves the original kernel buffer at
bio->bi_private it doesn't use something like struct bio_map_data to
store the information about the caller.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-map.c     |   21 +++++++++++-
 fs/bio.c            |   90 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h |    2 +
 3 files changed, 112 insertions(+), 1 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 3c942bd..0b1af5a 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -255,10 +255,18 @@ EXPORT_SYMBOL(blk_rq_unmap_user);
  * @kbuf:	the kernel buffer
  * @len:	length of user data
  * @gfp_mask:	memory allocation flags
+ *
+ * Description:
+ *    Data will be mapped directly if possible. Otherwise a bounce
+ *    buffer is used.
  */
 int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 		    unsigned int len, gfp_t gfp_mask)
 {
+	unsigned long kaddr;
+	unsigned int alignment;
+	int reading = rq_data_dir(rq) == READ;
+	int do_copy = 0;
 	struct bio *bio;
 
 	if (len > (q->max_hw_sectors << 9))
@@ -266,13 +274,24 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	if (!len || !kbuf)
 		return -EINVAL;
 
-	bio = bio_map_kern(q, kbuf, len, gfp_mask);
+	kaddr = (unsigned long)kbuf;
+	alignment = queue_dma_alignment(q) | q->dma_pad_mask;
+	do_copy = ((kaddr & alignment) || (len & alignment));
+
+	if (do_copy)
+		bio = bio_copy_kern(q, kbuf, len, gfp_mask, reading);
+	else
+		bio = bio_map_kern(q, kbuf, len, gfp_mask);
+
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
 	if (rq_data_dir(rq) == WRITE)
 		bio->bi_rw |= (1 << BIO_RW);
 
+	if (do_copy)
+		rq->cmd_flags |= REQ_COPY_USER;
+
 	blk_rq_bio_prep(q, rq, bio);
 	blk_queue_bounce(q, &rq->bio);
 	rq->buffer = rq->data = NULL;
diff --git a/fs/bio.c b/fs/bio.c
index 6e0b6f6..799f86d 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -937,6 +937,95 @@ struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
 	return ERR_PTR(-EINVAL);
 }
 
+static void bio_copy_kern_endio(struct bio *bio, int err)
+{
+	struct bio_vec *bvec;
+	const int read = bio_data_dir(bio) == READ;
+	char *p = bio->bi_private;
+	int i;
+
+	__bio_for_each_segment(bvec, bio, i, 0) {
+		char *addr = page_address(bvec->bv_page);
+
+		if (read && !err)
+			memcpy(p, addr, bvec->bv_len);
+
+		__free_page(bvec->bv_page);
+		p += bvec->bv_len;
+	}
+
+	bio_put(bio);
+}
+
+/**
+ *	bio_copy_kern	-	copy kernel address into bio
+ *	@q: the struct request_queue for the bio
+ *	@data: pointer to buffer to copy
+ *	@len: length in bytes
+ *	@gfp_mask: allocation flags for bio and page allocation
+ *
+ *	copy the kernel address into a bio suitable for io to a block
+ *	device. Returns an error pointer in case of error.
+ */
+struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
+			  gfp_t gfp_mask, int reading)
+{
+	unsigned long kaddr = (unsigned long)data;
+	unsigned long end = (kaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	unsigned long start = kaddr >> PAGE_SHIFT;
+	const int nr_pages = end - start;
+	struct bio *bio;
+	struct bio_vec *bvec;
+	int i, ret;
+
+	bio = bio_alloc(gfp_mask, nr_pages);
+	if (!bio)
+		return ERR_PTR(-ENOMEM);
+
+	while (len) {
+		struct page *page;
+		unsigned int bytes = PAGE_SIZE;
+
+		if (bytes > len)
+			bytes = len;
+
+		page = alloc_page(q->bounce_gfp | gfp_mask);
+		if (!page) {
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+
+		if (bio_add_pc_page(q, bio, page, bytes, 0) < bytes) {
+			ret = -EINVAL;
+			goto cleanup;
+		}
+
+		len -= bytes;
+	}
+
+	if (!reading) {
+		void *p = data;
+
+		bio_for_each_segment(bvec, bio, i) {
+			char *addr = page_address(bvec->bv_page);
+
+			memcpy(addr, p, bvec->bv_len);
+			p += bvec->bv_len;
+		}
+	}
+
+	bio->bi_private = data;
+	bio->bi_end_io = bio_copy_kern_endio;
+	return bio;
+cleanup:
+	bio_for_each_segment(bvec, bio, i)
+		__free_page(bvec->bv_page);
+
+	bio_put(bio);
+
+	return ERR_PTR(ret);
+}
+
 /*
  * bio_set_pages_dirty() and bio_check_pages_dirty() are support functions
  * for performing direct-IO in BIOs.
@@ -1273,6 +1362,7 @@ EXPORT_SYMBOL(bio_get_nr_vecs);
 EXPORT_SYMBOL(bio_map_user);
 EXPORT_SYMBOL(bio_unmap_user);
 EXPORT_SYMBOL(bio_map_kern);
+EXPORT_SYMBOL(bio_copy_kern);
 EXPORT_SYMBOL(bio_pair_release);
 EXPORT_SYMBOL(bio_split);
 EXPORT_SYMBOL(bio_split_pool);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index d259690..61c15ea 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -324,6 +324,8 @@ extern struct bio *bio_map_user_iov(struct request_queue *,
 extern void bio_unmap_user(struct bio *);
 extern struct bio *bio_map_kern(struct request_queue *, void *, unsigned int,
 				gfp_t);
+extern struct bio *bio_copy_kern(struct request_queue *, void *, unsigned int,
+				 gfp_t, int);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
 extern struct bio *bio_copy_user(struct request_queue *, unsigned long, unsigned int, int);
-- 
1.5.3.4

