From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/3] block: convert bio_copy_user to bio_copy_user_iov
Date: Thu, 10 Apr 2008 23:17:11 +0900
Message-ID: <1207837033-23835-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1207837033-23835-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:35832 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495AbYDJOUI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Apr 2008 10:20:08 -0400
In-Reply-To: <1207837033-23835-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Tejun Heo <htejun@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>

This patch enables bio_copy_user to take struct sg_iovec (renamed
bio_copy_user_iov). bio_copy_user uses bio_copy_user_iov internally as
bio_map_user uses bio_map_user_iov.

The major changes are:

- adds sg_iovec array to struct bio_map_data

- adds __bio_copy_iov that copy data between bio and
sg_iovec. bio_copy_user_iov and bio_uncopy_user use it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 fs/bio.c            |  158 +++++++++++++++++++++++++++++++++++++-------------
 include/linux/bio.h |    2 +
 2 files changed, 119 insertions(+), 41 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 553b5b7..6e0b6f6 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -444,22 +444,27 @@ int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 
 struct bio_map_data {
 	struct bio_vec *iovecs;
-	void __user *userptr;
+	int nr_sgvecs;
+	struct sg_iovec *sgvecs;
 };
 
-static void bio_set_map_data(struct bio_map_data *bmd, struct bio *bio)
+static void bio_set_map_data(struct bio_map_data *bmd, struct bio *bio,
+			     struct sg_iovec *iov, int iov_count)
 {
 	memcpy(bmd->iovecs, bio->bi_io_vec, sizeof(struct bio_vec) * bio->bi_vcnt);
+	memcpy(bmd->sgvecs, iov, sizeof(struct sg_iovec) * iov_count);
+	bmd->nr_sgvecs = iov_count;
 	bio->bi_private = bmd;
 }
 
 static void bio_free_map_data(struct bio_map_data *bmd)
 {
 	kfree(bmd->iovecs);
+	kfree(bmd->sgvecs);
 	kfree(bmd);
 }
 
-static struct bio_map_data *bio_alloc_map_data(int nr_segs)
+static struct bio_map_data *bio_alloc_map_data(int nr_segs, int iov_count)
 {
 	struct bio_map_data *bmd = kmalloc(sizeof(*bmd), GFP_KERNEL);
 
@@ -467,13 +472,71 @@ static struct bio_map_data *bio_alloc_map_data(int nr_segs)
 		return NULL;
 
 	bmd->iovecs = kmalloc(sizeof(struct bio_vec) * nr_segs, GFP_KERNEL);
-	if (bmd->iovecs)
+	if (!bmd->iovecs) {
+		kfree(bmd);
+		return NULL;
+	}
+
+	bmd->sgvecs = kmalloc(sizeof(struct sg_iovec) * iov_count, GFP_KERNEL);
+	if (bmd->sgvecs)
 		return bmd;
 
+	kfree(bmd->iovecs);
 	kfree(bmd);
 	return NULL;
 }
 
+static int __bio_copy_iov(struct bio *bio, struct sg_iovec *iov, int iov_count,
+			  int uncopy)
+{
+	int ret = 0, i;
+	struct bio_vec *bvec;
+	int iov_idx = 0;
+	unsigned int iov_off = 0;
+	int read = bio_data_dir(bio) == READ;
+
+	__bio_for_each_segment(bvec, bio, i, 0) {
+		char *bv_addr = page_address(bvec->bv_page);
+		unsigned int bv_len = bvec->bv_len;
+
+		while (bv_len && iov_idx < iov_count) {
+			unsigned int bytes;
+			char *iov_addr;
+
+			bytes = min_t(unsigned int,
+				      iov[iov_idx].iov_len - iov_off, bv_len);
+			iov_addr = iov[iov_idx].iov_base + iov_off;
+
+			if (!ret) {
+				if (!read && !uncopy)
+					ret = copy_from_user(bv_addr, iov_addr,
+							     bytes);
+				if (read && uncopy)
+					ret = copy_to_user(iov_addr, bv_addr,
+							   bytes);
+
+				if (ret)
+					ret = -EFAULT;
+			}
+
+			bv_len -= bytes;
+			bv_addr += bytes;
+			iov_addr += bytes;
+			iov_off += bytes;
+
+			if (iov[iov_idx].iov_len == iov_off) {
+				iov_idx++;
+				iov_off = 0;
+			}
+		}
+
+		if (uncopy)
+			__free_page(bvec->bv_page);
+	}
+
+	return ret;
+}
+
 /**
  *	bio_uncopy_user	-	finish previously mapped bio
  *	@bio: bio being terminated
@@ -484,55 +547,56 @@ static struct bio_map_data *bio_alloc_map_data(int nr_segs)
 int bio_uncopy_user(struct bio *bio)
 {
 	struct bio_map_data *bmd = bio->bi_private;
-	const int read = bio_data_dir(bio) == READ;
-	struct bio_vec *bvec;
-	int i, ret = 0;
+	int ret;
 
-	__bio_for_each_segment(bvec, bio, i, 0) {
-		char *addr = page_address(bvec->bv_page);
-		unsigned int len = bmd->iovecs[i].bv_len;
+	ret = __bio_copy_iov(bio, bmd->sgvecs, bmd->nr_sgvecs, 1);
 
-		if (read && !ret && copy_to_user(bmd->userptr, addr, len))
-			ret = -EFAULT;
-
-		__free_page(bvec->bv_page);
-		bmd->userptr += len;
-	}
 	bio_free_map_data(bmd);
 	bio_put(bio);
 	return ret;
 }
 
 /**
- *	bio_copy_user	-	copy user data to bio
+ *	bio_copy_user_iov	-	copy user data to bio
  *	@q: destination block queue
- *	@uaddr: start of user address
- *	@len: length in bytes
+ *	@iov:	the iovec.
+ *	@iov_count: number of elements in the iovec
  *	@write_to_vm: bool indicating writing to pages or not
  *
  *	Prepares and returns a bio for indirect user io, bouncing data
  *	to/from kernel pages as necessary. Must be paired with
  *	call bio_uncopy_user() on io completion.
  */
-struct bio *bio_copy_user(struct request_queue *q, unsigned long uaddr,
-			  unsigned int len, int write_to_vm)
+struct bio *bio_copy_user_iov(struct request_queue *q, struct sg_iovec *iov,
+			      int iov_count, int write_to_vm)
 {
-	unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	unsigned long start = uaddr >> PAGE_SHIFT;
 	struct bio_map_data *bmd;
 	struct bio_vec *bvec;
 	struct page *page;
 	struct bio *bio;
 	int i, ret;
+	int nr_pages = 0;
+	unsigned int len = 0;
 
-	bmd = bio_alloc_map_data(end - start);
+	for (i = 0; i < iov_count; i++) {
+		unsigned long uaddr;
+		unsigned long end;
+		unsigned long start;
+
+		uaddr = (unsigned long)iov[i].iov_base;
+		end = (uaddr + iov[i].iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		start = uaddr >> PAGE_SHIFT;
+
+		nr_pages += end - start;
+		len += iov[i].iov_len;
+	}
+
+	bmd = bio_alloc_map_data(nr_pages, iov_count);
 	if (!bmd)
 		return ERR_PTR(-ENOMEM);
 
-	bmd->userptr = (void __user *) uaddr;
-
 	ret = -ENOMEM;
-	bio = bio_alloc(GFP_KERNEL, end - start);
+	bio = bio_alloc(GFP_KERNEL, nr_pages);
 	if (!bio)
 		goto out_bmd;
 
@@ -564,22 +628,12 @@ struct bio *bio_copy_user(struct request_queue *q, unsigned long uaddr,
 	 * success
 	 */
 	if (!write_to_vm) {
-		char __user *p = (char __user *) uaddr;
-
-		/*
-		 * for a write, copy in data to kernel pages
-		 */
-		ret = -EFAULT;
-		bio_for_each_segment(bvec, bio, i) {
-			char *addr = page_address(bvec->bv_page);
-
-			if (copy_from_user(addr, p, bvec->bv_len))
-				goto cleanup;
-			p += bvec->bv_len;
-		}
+		ret = __bio_copy_iov(bio, iov, iov_count, 0);
+		if (ret)
+			goto cleanup;
 	}
 
-	bio_set_map_data(bmd, bio);
+	bio_set_map_data(bmd, bio, iov, iov_count);
 	return bio;
 cleanup:
 	bio_for_each_segment(bvec, bio, i)
@@ -591,6 +645,28 @@ out_bmd:
 	return ERR_PTR(ret);
 }
 
+/**
+ *	bio_copy_user	-	copy user data to bio
+ *	@q: destination block queue
+ *	@uaddr: start of user address
+ *	@len: length in bytes
+ *	@write_to_vm: bool indicating writing to pages or not
+ *
+ *	Prepares and returns a bio for indirect user io, bouncing data
+ *	to/from kernel pages as necessary. Must be paired with
+ *	call bio_uncopy_user() on io completion.
+ */
+struct bio *bio_copy_user(struct request_queue *q, unsigned long uaddr,
+			  unsigned int len, int write_to_vm)
+{
+	struct sg_iovec iov;
+
+	iov.iov_base = (void __user *)uaddr;
+	iov.iov_len = len;
+
+	return bio_copy_user_iov(q, &iov, 1, write_to_vm);
+}
+
 static struct bio *__bio_map_user_iov(struct request_queue *q,
 				      struct block_device *bdev,
 				      struct sg_iovec *iov, int iov_count,
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 4c59bdc..d259690 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -327,6 +327,8 @@ extern struct bio *bio_map_kern(struct request_queue *, void *, unsigned int,
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
 extern struct bio *bio_copy_user(struct request_queue *, unsigned long, unsigned int, int);
+extern struct bio *bio_copy_user_iov(struct request_queue *, struct sg_iovec *,
+				     int, int);
 extern int bio_uncopy_user(struct bio *);
 void zero_fill_bio(struct bio *bio);
 
-- 
1.5.4.2

