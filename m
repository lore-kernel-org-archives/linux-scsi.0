From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/5] block: introduce struct rq_map_data to use reserved pages
Date: Thu, 28 Aug 2008 16:17:06 +0900
Message-ID: <1219907829-27365-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <20080828070725.GP20055@kernel.dk>
 <1219907829-27365-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:39575 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbYH1HTI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2008 03:19:08 -0400
In-Reply-To: <1219907829-27365-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This patch introduces struct rq_map_data to enable bio_copy_use_iov()
use reserved pages.

Currently, bio_copy_user_iov allocates bounce pages but
drivers/scsi/sg.c wants to allocate pages by itself and use
them. struct rq_map_data can be used to pass allocated pages to
bio_copy_user_iov.

The current users of bio_copy_user_iov simply passes NULL (they don't
want to use pre-allocated pages).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/blk-map.c             |   26 ++++++++++++-------
 block/bsg.c                 |    7 +++--
 block/scsi_ioctl.c          |    4 +-
 drivers/cdrom/cdrom.c       |    2 +-
 drivers/scsi/scsi_tgt_lib.c |    2 +-
 fs/bio.c                    |   58 ++++++++++++++++++++++++++++++------------
 include/linux/bio.h         |    8 +++--
 include/linux/blkdev.h      |   12 +++++++-
 8 files changed, 80 insertions(+), 39 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index ac21b73..dad6a29 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -41,8 +41,8 @@ static int __blk_rq_unmap_user(struct bio *bio)
 }
 
 static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
-			     void __user *ubuf, unsigned int len,
-			     gfp_t gfp_mask)
+			     struct rq_map_data *map_data, void __user *ubuf,
+			     unsigned int len, gfp_t gfp_mask)
 {
 	unsigned long uaddr;
 	unsigned int alignment;
@@ -57,10 +57,10 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
 	 */
 	uaddr = (unsigned long) ubuf;
 	alignment = queue_dma_alignment(q) | q->dma_pad_mask;
-	if (!(uaddr & alignment) && !(len & alignment))
+	if (!(uaddr & alignment) && !(len & alignment) && !map_data)
 		bio = bio_map_user(q, NULL, uaddr, len, reading, gfp_mask);
 	else
-		bio = bio_copy_user(q, uaddr, len, reading, gfp_mask);
+		bio = bio_copy_user(q, map_data, uaddr, len, reading, gfp_mask);
 
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
@@ -89,6 +89,7 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
  * blk_rq_map_user - map user data to a request, for REQ_TYPE_BLOCK_PC usage
  * @q:		request queue where request should be inserted
  * @rq:		request structure to fill
+ * @map_data:   pointer to the rq_map_data holding pages (if necessary)
  * @ubuf:	the user buffer
  * @len:	length of user data
  * @gfp_mask:	memory allocation flags
@@ -107,7 +108,8 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
  *    unmapping.
  */
 int blk_rq_map_user(struct request_queue *q, struct request *rq,
-		    void __user *ubuf, unsigned long len, gfp_t gfp_mask)
+		    struct rq_map_data *map_data, void __user *ubuf,
+		    unsigned long len, gfp_t gfp_mask)
 {
 	unsigned long bytes_read = 0;
 	struct bio *bio = NULL;
@@ -134,7 +136,8 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 		if (end - start > BIO_MAX_PAGES)
 			map_len -= PAGE_SIZE;
 
-		ret = __blk_rq_map_user(q, rq, ubuf, map_len, gfp_mask);
+		ret = __blk_rq_map_user(q, rq, map_data, ubuf, map_len,
+					gfp_mask);
 		if (ret < 0)
 			goto unmap_rq;
 		if (!bio)
@@ -159,6 +162,7 @@ EXPORT_SYMBOL(blk_rq_map_user);
  * blk_rq_map_user_iov - map user data to a request, for REQ_TYPE_BLOCK_PC usage
  * @q:		request queue where request should be inserted
  * @rq:		request to map data to
+ * @map_data:   pointer to the rq_map_data holding pages (if necessary)
  * @iov:	pointer to the iovec
  * @iov_count:	number of elements in the iovec
  * @len:	I/O byte count
@@ -178,8 +182,8 @@ EXPORT_SYMBOL(blk_rq_map_user);
  *    unmapping.
  */
 int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
-			struct sg_iovec *iov, int iov_count, unsigned int len,
-			gfp_t gfp_mask)
+			struct rq_map_data *map_data, struct sg_iovec *iov,
+			int iov_count, unsigned int len, gfp_t gfp_mask)
 {
 	struct bio *bio;
 	int i, read = rq_data_dir(rq) == READ;
@@ -197,8 +201,9 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 		}
 	}
 
-	if (unaligned || (q->dma_pad_mask & len))
-		bio = bio_copy_user_iov(q, iov, iov_count, read, gfp_mask);
+	if (unaligned || (q->dma_pad_mask & len) || map_data)
+		bio = bio_copy_user_iov(q, map_data, iov, iov_count, read,
+					gfp_mask);
 	else
 		bio = bio_map_user_iov(q, NULL, iov, iov_count, read, gfp_mask);
 
@@ -220,6 +225,7 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	rq->buffer = rq->data = NULL;
 	return 0;
 }
+EXPORT_SYMBOL(blk_rq_map_user_iov);
 
 /**
  * blk_rq_unmap_user - unmap a request with user data
diff --git a/block/bsg.c b/block/bsg.c
index e7a142e..56cb343 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -283,8 +283,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, int has_write_perm)
 		next_rq->cmd_type = rq->cmd_type;
 
 		dxferp = (void*)(unsigned long)hdr->din_xferp;
-		ret =  blk_rq_map_user(q, next_rq, dxferp, hdr->din_xfer_len,
-				       GFP_KERNEL);
+		ret =  blk_rq_map_user(q, next_rq, NULL, dxferp,
+				       hdr->din_xfer_len, GFP_KERNEL);
 		if (ret)
 			goto out;
 	}
@@ -299,7 +299,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, int has_write_perm)
 		dxfer_len = 0;
 
 	if (dxfer_len) {
-		ret = blk_rq_map_user(q, rq, dxferp, dxfer_len, GFP_KERNEL);
+		ret = blk_rq_map_user(q, rq, NULL, dxferp, dxfer_len,
+				      GFP_KERNEL);
 		if (ret)
 			goto out;
 	}
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index f49d6a1..c34272a 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -314,11 +314,11 @@ static int sg_io(struct file *file, struct request_queue *q,
 			goto out;
 		}
 
-		ret = blk_rq_map_user_iov(q, rq, iov, hdr->iovec_count,
+		ret = blk_rq_map_user_iov(q, rq, NULL, iov, hdr->iovec_count,
 					  hdr->dxfer_len, GFP_KERNEL);
 		kfree(iov);
 	} else if (hdr->dxfer_len)
-		ret = blk_rq_map_user(q, rq, hdr->dxferp, hdr->dxfer_len,
+		ret = blk_rq_map_user(q, rq, NULL, hdr->dxferp, hdr->dxfer_len,
 				      GFP_KERNEL);
 
 	if (ret)
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index e861d24..d47f2f8 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2097,7 +2097,7 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 
 		len = nr * CD_FRAMESIZE_RAW;
 
-		ret = blk_rq_map_user(q, rq, ubuf, len, GFP_KERNEL);
+		ret = blk_rq_map_user(q, rq, NULL, ubuf, len, GFP_KERNEL);
 		if (ret)
 			break;
 
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 2a4fd82..3117bb1 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -362,7 +362,7 @@ static int scsi_map_user_pages(struct scsi_tgt_cmd *tcmd, struct scsi_cmnd *cmd,
 	int err;
 
 	dprintk("%lx %u\n", uaddr, len);
-	err = blk_rq_map_user(q, rq, (void *)uaddr, len, GFP_KERNEL);
+	err = blk_rq_map_user(q, rq, NULL, (void *)uaddr, len, GFP_KERNEL);
 	if (err) {
 		/*
 		 * TODO: need to fixup sg_tablesize, max_segment_size,
diff --git a/fs/bio.c b/fs/bio.c
index 3d2e9ad..a2f0726 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -439,16 +439,19 @@ int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 
 struct bio_map_data {
 	struct bio_vec *iovecs;
-	int nr_sgvecs;
 	struct sg_iovec *sgvecs;
+	int nr_sgvecs;
+	int is_our_pages;
 };
 
 static void bio_set_map_data(struct bio_map_data *bmd, struct bio *bio,
-			     struct sg_iovec *iov, int iov_count)
+			     struct sg_iovec *iov, int iov_count,
+			     int is_our_pages)
 {
 	memcpy(bmd->iovecs, bio->bi_io_vec, sizeof(struct bio_vec) * bio->bi_vcnt);
 	memcpy(bmd->sgvecs, iov, sizeof(struct sg_iovec) * iov_count);
 	bmd->nr_sgvecs = iov_count;
+	bmd->is_our_pages = is_our_pages;
 	bio->bi_private = bmd;
 }
 
@@ -483,7 +486,8 @@ static struct bio_map_data *bio_alloc_map_data(int nr_segs, int iov_count,
 }
 
 static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
-			  struct sg_iovec *iov, int iov_count, int uncopy)
+			  struct sg_iovec *iov, int iov_count, int uncopy,
+			  int do_free_page)
 {
 	int ret = 0, i;
 	struct bio_vec *bvec;
@@ -526,7 +530,7 @@ static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
 			}
 		}
 
-		if (uncopy)
+		if (do_free_page)
 			__free_page(bvec->bv_page);
 	}
 
@@ -545,7 +549,8 @@ int bio_uncopy_user(struct bio *bio)
 	struct bio_map_data *bmd = bio->bi_private;
 	int ret;
 
-	ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs, bmd->nr_sgvecs, 1);
+	ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs, bmd->nr_sgvecs, 1,
+			     bmd->is_our_pages);
 
 	bio_free_map_data(bmd);
 	bio_put(bio);
@@ -555,6 +560,7 @@ int bio_uncopy_user(struct bio *bio)
 /**
  *	bio_copy_user_iov	-	copy user data to bio
  *	@q: destination block queue
+ *	@map_data: pointer to the rq_map_data holding pages (if necessary)
  *	@iov:	the iovec.
  *	@iov_count: number of elements in the iovec
  *	@write_to_vm: bool indicating writing to pages or not
@@ -564,8 +570,10 @@ int bio_uncopy_user(struct bio *bio)
  *	to/from kernel pages as necessary. Must be paired with
  *	call bio_uncopy_user() on io completion.
  */
-struct bio *bio_copy_user_iov(struct request_queue *q, struct sg_iovec *iov,
-			      int iov_count, int write_to_vm, gfp_t gfp_mask)
+struct bio *bio_copy_user_iov(struct request_queue *q,
+			      struct rq_map_data *map_data,
+			      struct sg_iovec *iov, int iov_count,
+			      int write_to_vm, gfp_t gfp_mask)
 {
 	struct bio_map_data *bmd;
 	struct bio_vec *bvec;
@@ -600,13 +608,26 @@ struct bio *bio_copy_user_iov(struct request_queue *q, struct sg_iovec *iov,
 	bio->bi_rw |= (!write_to_vm << BIO_RW);
 
 	ret = 0;
+	i = 0;
 	while (len) {
-		unsigned int bytes = PAGE_SIZE;
+		unsigned int bytes;
+
+		if (map_data)
+			bytes = 1U << (PAGE_SHIFT + map_data->page_order);
+		else
+			bytes = PAGE_SIZE;
 
 		if (bytes > len)
 			bytes = len;
 
-		page = alloc_page(q->bounce_gfp | gfp_mask);
+		if (map_data) {
+			if (i == map_data->nr_entries) {
+				ret = -ENOMEM;
+				break;
+			}
+			page = map_data->pages[i++];
+		} else
+			page = alloc_page(q->bounce_gfp | gfp_mask);
 		if (!page) {
 			ret = -ENOMEM;
 			break;
@@ -625,16 +646,17 @@ struct bio *bio_copy_user_iov(struct request_queue *q, struct sg_iovec *iov,
 	 * success
 	 */
 	if (!write_to_vm) {
-		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, iov_count, 0);
+		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, iov_count, 0, 0);
 		if (ret)
 			goto cleanup;
 	}
 
-	bio_set_map_data(bmd, bio, iov, iov_count);
+	bio_set_map_data(bmd, bio, iov, iov_count, map_data ? 0 : 1);
 	return bio;
 cleanup:
-	bio_for_each_segment(bvec, bio, i)
-		__free_page(bvec->bv_page);
+	if (!map_data)
+		bio_for_each_segment(bvec, bio, i)
+			__free_page(bvec->bv_page);
 
 	bio_put(bio);
 out_bmd:
@@ -645,6 +667,7 @@ out_bmd:
 /**
  *	bio_copy_user	-	copy user data to bio
  *	@q: destination block queue
+ *	@map_data: pointer to the rq_map_data holding pages (if necessary)
  *	@uaddr: start of user address
  *	@len: length in bytes
  *	@write_to_vm: bool indicating writing to pages or not
@@ -654,15 +677,16 @@ out_bmd:
  *	to/from kernel pages as necessary. Must be paired with
  *	call bio_uncopy_user() on io completion.
  */
-struct bio *bio_copy_user(struct request_queue *q, unsigned long uaddr,
-			  unsigned int len, int write_to_vm, gfp_t gfp_mask)
+struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *map_data,
+			  unsigned long uaddr, unsigned int len,
+			  int write_to_vm, gfp_t gfp_mask)
 {
 	struct sg_iovec iov;
 
 	iov.iov_base = (void __user *)uaddr;
 	iov.iov_len = len;
 
-	return bio_copy_user_iov(q, &iov, 1, write_to_vm, gfp_mask);
+	return bio_copy_user_iov(q, map_data, &iov, 1, write_to_vm, gfp_mask);
 }
 
 static struct bio *__bio_map_user_iov(struct request_queue *q,
@@ -1028,7 +1052,7 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 	bio->bi_private = bmd;
 	bio->bi_end_io = bio_copy_kern_endio;
 
-	bio_set_map_data(bmd, bio, &iov, 1);
+	bio_set_map_data(bmd, bio, &iov, 1, 1);
 	return bio;
 cleanup:
 	bio_for_each_segment(bvec, bio, i)
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 200b185..bc386cd 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -327,6 +327,7 @@ extern int bio_get_nr_vecs(struct block_device *);
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
 				unsigned long, unsigned int, int, gfp_t);
 struct sg_iovec;
+struct rq_map_data;
 extern struct bio *bio_map_user_iov(struct request_queue *,
 				    struct block_device *,
 				    struct sg_iovec *, int, int, gfp_t);
@@ -337,9 +338,10 @@ extern struct bio *bio_copy_kern(struct request_queue *, void *, unsigned int,
 				 gfp_t, int);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
-extern struct bio *bio_copy_user(struct request_queue *, unsigned long,
-				 unsigned int, int, gfp_t);
-extern struct bio *bio_copy_user_iov(struct request_queue *, struct sg_iovec *,
+extern struct bio *bio_copy_user(struct request_queue *, struct rq_map_data *,
+				 unsigned long, unsigned int, int, gfp_t);
+extern struct bio *bio_copy_user_iov(struct request_queue *,
+				     struct rq_map_data *, struct sg_iovec *,
 				     int, int, gfp_t);
 extern int bio_uncopy_user(struct bio *);
 void zero_fill_bio(struct bio *bio);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9512c5b..d2faa72 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -642,6 +642,12 @@ static inline void blk_queue_bounce(struct request_queue *q, struct bio **bio)
 }
 #endif /* CONFIG_MMU */
 
+struct rq_map_data {
+	struct page **pages;
+	int page_order;
+	int nr_entries;
+};
+
 struct req_iterator {
 	int i;
 	struct bio *bio;
@@ -711,11 +717,13 @@ extern void __blk_run_queue(struct request_queue *);
 extern void blk_run_queue(struct request_queue *);
 extern void blk_start_queueing(struct request_queue *);
 extern int blk_rq_map_user(struct request_queue *, struct request *,
-			   void __user *, unsigned long, gfp_t);
+			   struct rq_map_data *, void __user *, unsigned long,
+			   gfp_t);
 extern int blk_rq_unmap_user(struct bio *);
 extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, unsigned int, gfp_t);
 extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
-			       struct sg_iovec *, int, unsigned int, gfp_t);
+			       struct rq_map_data *, struct sg_iovec *, int,
+			       unsigned int, gfp_t);
 extern int blk_execute_rq(struct request_queue *, struct gendisk *,
 			  struct request *, int);
 extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
-- 
1.5.5.GIT

