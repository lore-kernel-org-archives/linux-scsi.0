From: michaelc@cs.wisc.edu
Subject: [PATCH 4/7] Add reserve buffer for sg io
Date: Sun, 04 Mar 2007 12:31:21 -0600
Message-ID: <11730330872229-git-send-email-michaelc@cs.wisc.edu>
References: <1173033084706-git-send-email-michaelc@cs.wisc.edu> <11730330852430-git-send-email-michaelc@cs.wisc.edu> <11730330851234-git-send-email-michaelc@cs.wisc.edu> <11730330861995-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbXCDSbj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Mar 2007 13:31:39 -0500
In-Reply-To: <11730330861995-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

sg and st use a reserve buffer so that they can always
gaurantee that they can execute IO of a certain size
which is larger than the worst case guess.

This patch adds a bio_reserved_buf structure, which holds mutlple
segments that can be mapped into BIOs. This replaces sg's reserved
buffer code, and can be used for tape (I think we need some reserved buffer
growing code for that, but that should not be too difficult to add).
It can also be used for scsi_tgt, so we gaurantee a certain IO size will
always be executable.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/ll_rw_blk.c      |   15 ++-
 fs/bio.c               |  211 ++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/bio.h    |   20 ++++-
 include/linux/blkdev.h |    5 +
 4 files changed, 234 insertions(+), 17 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index c9d765b..4d6c2bd 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -2347,12 +2347,13 @@ EXPORT_SYMBOL(blk_rq_destroy_buffer);
  * @rq:		request structure to fill
  * @ubuf:	the user buffer (optional)
  * @len:	length of buffer
+ * @rbuf:	reserve buf to use
  *
  * Description:
  *    The caller must call blk_rq_destroy_buffer when the IO is completed.
  */
 int blk_rq_setup_buffer(struct request *rq, void __user *ubuf,
-			unsigned long len)
+			unsigned long len, struct bio_reserve_buf *rbuf)
 {
 	struct request_queue *q = rq->q;
 	unsigned long bytes_read = 0;
@@ -2383,7 +2384,7 @@ int blk_rq_setup_buffer(struct request *
 
 			bio = bio_map_user(q, uaddr, map_len, reading);
 		} else
-			bio = bio_setup_user_buffer(q, map_len, reading);
+			bio = bio_setup_user_buffer(q, map_len, reading, rbuf);
 		if (IS_ERR(bio)) {
 			ret = PTR_ERR(bio);
 			goto unmap_rq;
@@ -2450,7 +2451,7 @@ EXPORT_SYMBOL(blk_rq_setup_buffer);
 int blk_rq_map_user(request_queue_t *q, struct request *rq,
 		     void __user *ubuf, unsigned long len)
 {
-	return blk_rq_setup_buffer(rq, ubuf, len);
+	return blk_rq_setup_buffer(rq, ubuf, len, NULL);
 }
 EXPORT_SYMBOL(blk_rq_map_user);
 
@@ -2522,6 +2523,7 @@ continue_from_bvec:
  * @iov:	sg iovec
  * @iov_count:	number of elements in the iovec
  * @len:	max length of data (length of buffer)
+ * @rbuf:	reserve buffer
  *
  * Description:
  *    This function is for REQ_BLOCK_PC usage.
@@ -2534,11 +2536,12 @@ continue_from_bvec:
  *    proper unmapping.
  */
 int blk_rq_copy_user_iov(struct request *rq, struct sg_iovec *iov,
-			 int iov_count, unsigned long len)
+			 int iov_count, unsigned long len,
+			 struct bio_reserve_buf *rbuf)
 {
 	int ret;
 
-	ret = blk_rq_setup_buffer(rq, NULL, len);
+	ret = blk_rq_setup_buffer(rq, NULL, len, rbuf);
 	if (ret)
 		return ret;
 
@@ -2607,7 +2610,7 @@ int blk_rq_init_transfer(request_queue_t
 		iov.iov_base = ubuf;
 		iov.iov_len = len;
 
-		ret = blk_rq_copy_user_iov(rq, &iov, 1, len);
+		ret = blk_rq_copy_user_iov(rq, &iov, 1, len, NULL);
 	}
 	return ret;
 }
diff --git a/fs/bio.c b/fs/bio.c
index 2fff42a..75a3495 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -458,6 +458,7 @@ struct bio_map_vec {
 };
 
 struct bio_map_data {
+	struct bio_reserve_buf *rbuf;
 	struct bio_map_vec *iovecs;
 	int nr_vecs;
 };
@@ -485,8 +486,7 @@ static struct bio_map_data *bio_alloc_ma
 
 /*
  * This is only a esitmation. Drivers, like MD/DM RAID could have strange
- * boundaries not expressed in a q limit, so we do not know the real
- * limit until we add the page to the bio.
+ * boundaries not expresses in a q limit.
  *
  * This should only be used by bio helpers, because we cut off the max
  * segment size at BIO_MAX_SIZE. There is hw that can do larger segments,
@@ -505,6 +505,7 @@ static unsigned int bio_estimate_max_seg
 	return bytes;
 }
 
+/* This should only be used by block layer helpers */
 static struct page *bio_alloc_pages(struct request_queue *q, unsigned int len,
 				    int *ret_order)
 {
@@ -530,10 +531,175 @@ static struct page *bio_alloc_pages(stru
 	return pages;
 }
 
+static void free_reserve_buf(struct bio_reserve_buf *rbuf)
+{
+	struct scatterlist *sg;
+	int i;
+
+	for (i = 0; i < rbuf->sg_count; i++) {
+		sg = &rbuf->sg[i];
+		if (sg->page)
+			__free_pages(sg->page, get_order(sg->length));
+	}
+
+	kfree(rbuf->sg);
+	kfree(rbuf);
+}
+
+/**
+ * bio_free_reserve_buf - free reserve buffer
+ * @q: the request queue for the device
+ *
+ * It is the responsibility of the caller to make sure it is
+ * no longer processing requests that may be using the reserved
+ * buffer.
+ **/
+int bio_free_reserve_buf(struct bio_reserve_buf *rbuf)
+{
+	if (!rbuf)
+		return 0;
+
+	if (test_and_set_bit(BIO_RESERVE_BUF_IN_USE, &rbuf->flags))
+		return -EBUSY;
+
+	free_reserve_buf(rbuf);
+	return 0;
+}
+
+/**
+ * bio_alloc_reserve_buf - allocate a buffer for pass through
+ * @q: the request queue for the device
+ * @buf_size: size of reserve buffer to allocate
+ *
+ * This is very simple for now. It is copied from sg.c because it is only
+ * meant to support what sg had supported.
+ *
+ * It will allocate as many bytes as posssible up to buf_size. It is
+ * the callers responsibility to check the buf_size returned.
+ **/
+struct bio_reserve_buf *bio_alloc_reserve_buf(struct request_queue *q,
+					      unsigned long buf_size)
+{
+	struct bio_reserve_buf *rbuf;
+	struct page *pg;
+	struct scatterlist *sg;
+	int order, i, remainder, allocated;
+	unsigned int segment_size;
+
+	rbuf = kzalloc(sizeof(*rbuf), GFP_KERNEL);
+	if (!rbuf)
+		return NULL;
+	rbuf->buf_size = buf_size;
+	rbuf->sg_count = min(q->max_phys_segments, q->max_hw_segments);
+
+	rbuf->sg = kzalloc(rbuf->sg_count * sizeof(struct scatterlist),
+			  GFP_KERNEL);
+	if (!rbuf->sg)
+		goto free_buf;
+
+	segment_size = bio_estimate_max_segment_size(q);
+	for (i = 0, remainder = buf_size;
+	     (remainder > 0) && (i < rbuf->sg_count);
+	      ++i, remainder -= allocated) {
+		unsigned int requested_size;
+
+		sg = &rbuf->sg[i];
+
+		requested_size = remainder;
+		if (requested_size > segment_size)
+			requested_size = segment_size;
+
+		pg = bio_alloc_pages(q, requested_size, &order);
+		if (!pg)
+			goto free_buf;
+		sg->page = pg;
+		sg->length = (1 << order) << PAGE_SHIFT;
+		allocated = sg->length;
+	}
+	/* set to how mnay elements we are using */
+	rbuf->sg_count = i;
+	/* support partial allocations */
+	rbuf->buf_size -= remainder;
+
+	return rbuf;
+
+free_buf:
+	free_reserve_buf(rbuf);
+	return NULL;
+}
+
+/**
+ * get_reserve_seg - get pages from the reserve buffer
+ * @rbuf:	reserve buffer
+ * @len:	len of segment returned
+ *
+ * This assumes that caller is serializing access to the buffer.
+ **/
+static struct page *get_reserve_seg(struct bio_reserve_buf *rbuf,
+				    unsigned int *len)
+{
+	struct scatterlist *sg;
+
+	*len = 0;
+	if (!rbuf || rbuf->sg_index >= rbuf->sg_count) {
+		BUG();
+		return NULL;
+	}
+
+	sg = &rbuf->sg[rbuf->sg_index++];
+	*len = sg->length;
+	return sg->page;
+}
+
+/*
+ * sg only allowed one command to use the reserve buf at a time.
+ * We assume the block layer and sg, will always do a put() for a get(),
+ * and will continue to only allow one command to the use the buffer
+ * at a time, so we just decrement the sg_index here.
+ */
+static void put_reserve_seg(struct bio_reserve_buf *rbuf)
+{
+	if (!rbuf || rbuf->sg_index == 0) {
+		BUG();
+		return;
+	}
+	rbuf->sg_index--;
+}
+
+int bio_claim_reserve_buf(struct bio_reserve_buf *rbuf, unsigned long len)
+{
+	if (!rbuf)
+		return -ENOMEM;
+
+	if (test_and_set_bit(BIO_RESERVE_BUF_IN_USE, &rbuf->flags))
+		return -EBUSY;
+
+	if (len > rbuf->buf_size) {
+		clear_bit(BIO_RESERVE_BUF_IN_USE, &rbuf->flags);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+void bio_release_reserve_buf(struct bio_reserve_buf *rbuf)
+{
+	if (!rbuf)
+		return;
+
+	if (rbuf->sg_index != 0)
+		BUG();
+
+	rbuf->sg_index = 0;
+	clear_bit(BIO_RESERVE_BUF_IN_USE, &rbuf->flags);
+}
+
 static void bio_destroy_map_vec(struct bio *bio, struct bio_map_data *bmd,
 				struct bio_map_vec *vec)
 {
-	__free_pages(vec->page, vec->order);
+	if (bio_flagged(bio, BIO_USED_RESERVE))
+		put_reserve_seg(bmd->rbuf);
+	else
+		__free_pages(vec->page, vec->order);
 }
 
 /**
@@ -559,6 +725,7 @@ void bio_destroy_user_buffer(struct bio 
  *	@uaddr: start of user address
  *	@len: max length in bytes (length of buffer)
  *	@write_to_vm: bool indicating writing to pages or not
+ *	@rbuf: reserve buf to use
  *
  *	Prepares and returns a bio for indirect user io or mmap usage.
  *      It will allocate buffers with the queue's bounce_pfn, so
@@ -567,7 +734,7 @@ void bio_destroy_user_buffer(struct bio 
  *      len is larger than the bio can hold, len bytes will be setup.
  */
 struct bio *bio_setup_user_buffer(request_queue_t *q, unsigned int len,
-				  int write_to_vm)
+				  int write_to_vm, struct bio_reserve_buf *rbuf)
 {
 	struct bio_map_data *bmd;
 	struct bio *bio;
@@ -577,12 +744,15 @@ struct bio *bio_setup_user_buffer(reques
 	bmd = bio_alloc_map_data(nr_pages);
 	if (!bmd)
 		return ERR_PTR(-ENOMEM);
+	bmd->rbuf = rbuf;
 
 	bio = bio_alloc(GFP_KERNEL, nr_pages);
 	if (!bio) {
 		ret = -ENOMEM;
 		goto out_bmd;
 	}
+	if (rbuf)
+		bio->bi_flags |= (1 << BIO_USED_RESERVE);
 	bio->bi_rw |= (!write_to_vm << BIO_RW);
 
 	ret = 0;
@@ -590,10 +760,31 @@ struct bio *bio_setup_user_buffer(reques
 		unsigned add_len;
 		int order = 0;
 
-		page = bio_alloc_pages(q, len, &order);
-		if (!page) {
-			ret = -ENOMEM;
-			goto cleanup;
+		if (rbuf) {
+			int seg_len = 0;
+
+			page = get_reserve_seg(rbuf, &seg_len);
+			if (!page) {
+				ret = -ENOMEM;
+				goto cleanup;
+			}
+
+			/*
+			 * segments may not fit nicely in bios - caller
+			 * will handle this
+			 */
+			if (bio->bi_size + seg_len > BIO_MAX_SIZE) {
+				put_reserve_seg(rbuf);
+				break;
+			}
+			order = get_order(seg_len);
+
+		} else {
+			page = bio_alloc_pages(q, len, &order);
+			if (!page) {
+				ret = -ENOMEM;
+				goto cleanup;
+			}
 		}
 
 		bmd->nr_vecs++;
@@ -1285,6 +1476,10 @@ EXPORT_SYMBOL(bio_split);
 EXPORT_SYMBOL(bio_split_pool);
 EXPORT_SYMBOL(bio_setup_user_buffer);
 EXPORT_SYMBOL(bio_destroy_user_buffer);
+EXPORT_SYMBOL(bio_free_reserve_buf);
+EXPORT_SYMBOL(bio_alloc_reserve_buf);
+EXPORT_SYMBOL(bio_claim_reserve_buf);
+EXPORT_SYMBOL(bio_release_reserve_buf);
 EXPORT_SYMBOL(bioset_create);
 EXPORT_SYMBOL(bioset_free);
 EXPORT_SYMBOL(bio_alloc_bioset);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index e568373..a14f72b 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -51,6 +51,18 @@ #define BIO_MAX_PAGES		256
 #define BIO_MAX_SIZE		(BIO_MAX_PAGES << PAGE_CACHE_SHIFT)
 #define BIO_MAX_SECTORS		(BIO_MAX_SIZE >> 9)
 
+struct scatterlist;
+
+#define BIO_RESERVE_BUF_IN_USE 0
+
+struct bio_reserve_buf {
+	unsigned long flags;		/* state bits */
+	struct scatterlist *sg;		/* sg to hold pages */
+	unsigned buf_size;		/* size of reserve buffer */
+	int sg_count;			/* number of sg entries in use */
+	int sg_index;			/* index of sg in list */
+};
+
 /*
  * was unsigned short, but we might as well be ready for > 64kB I/O pages
  */
@@ -125,6 +137,7 @@ #define BIO_CLONED	4	/* doesn't own data
 #define BIO_BOUNCED	5	/* bio is a bounce bio */
 #define BIO_USER_MAPPED 6	/* contains user pages */
 #define BIO_EOPNOTSUPP	7	/* not supported */
+#define BIO_USED_RESERVE 8	/* using reserve buffer */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
@@ -298,6 +311,11 @@ extern int bio_add_page(struct bio *, st
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
+extern int bio_free_reserve_buf(struct bio_reserve_buf *);
+extern struct bio_reserve_buf *bio_alloc_reserve_buf(struct request_queue *,
+						    unsigned long);
+extern int bio_claim_reserve_buf(struct bio_reserve_buf *, unsigned long);
+extern void bio_release_reserve_buf(struct bio_reserve_buf *);
 extern struct bio *bio_map_user(struct request_queue *, unsigned long,
 				unsigned int, int);
 struct sg_iovec;
@@ -310,7 +328,7 @@ extern void bio_set_pages_dirty(struct b
 extern void bio_check_pages_dirty(struct bio *bio);
 extern void bio_release_pages(struct bio *bio);
 extern struct bio *bio_setup_user_buffer(struct request_queue *, unsigned int,
-					 int);
+					 int, struct bio_reserve_buf *);
 extern void bio_destroy_user_buffer(struct bio *bio);
 void zero_fill_bio(struct bio *bio);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7382988..755f0b4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -673,10 +673,11 @@ extern void blk_start_queueing(request_q
 extern int blk_rq_init_transfer(request_queue_t *, struct request *, void __user *, unsigned long);
 extern int blk_rq_map_user(request_queue_t *, struct request *,
 			   void __user *, unsigned long);
-extern int blk_rq_setup_buffer(struct request *, void __user *, unsigned long);
+extern int blk_rq_setup_buffer(struct request *, void __user *, unsigned long,
+			       struct bio_reserve_buf *);
 extern void blk_rq_destroy_buffer(struct bio *);
 extern int blk_rq_copy_user_iov(struct request *, struct sg_iovec *,
-				int, unsigned long);
+				int, unsigned long, struct bio_reserve_buf *);
 extern int blk_rq_uncopy_user_iov(struct bio *, struct sg_iovec *, int);
 extern int blk_rq_complete_transfer(struct bio *, void __user *, unsigned long);
 extern int blk_rq_map_kern(request_queue_t *, struct request *, void *, unsigned int, gfp_t);
-- 
1.4.1.1

