From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH] bsg: iovec support
Date: Thu, 1 Mar 2007 17:29:08 -0500
Message-ID: <20070301222908.GC20922@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:51263 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161033AbXCAW3J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Mar 2007 17:29:09 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

Support vectored IO as in SGv3.  The iovec structure uses explicit
sizes to avoid the need for compat conversion.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---

My application definitely can take advantage of scatter/gather IO,
which is supported in sgv3 but not in the bsg implementation of sgv4.
I understand Tomo's concerns about code bloat and the need for
32/64 compat translations, but this will make things much easier on
users of bsg who read or write out of multiple buffers in a single
SCSI operation.

Clearly we want to avoid doing the compat work that sg.c has to do
now, so I went with __u64 for the addresses in the structures that
userspace sees.  But to interface with existing bio structures, that
must be converted back to 32-bit pointers in sg_iovec (only on
32-bit architectures).  In the long run, maybe we should have a
bio_map_user_iov() that works on the constant-sized sg_io_v4_vec
proposed here?

		-- Pete


 block/bsg.c         |  132 ++++++++++++++++++++++++++++++++++++++++++---------
 include/linux/bsg.h |   16 ++++++
 2 files changed, 125 insertions(+), 23 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index c85d961..8e3d6c7 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -280,6 +280,95 @@ bsg_validate_sgv4_hdr(request_queue_t *q, struct sg_io_v4 *hdr, int *rw)
 }
 
 /*
+ * Sits around blk_rq_map_user_iov so we can use an iovec type that
+ * does not require compat manipulations.  For now we just clumsily
+ * remap the entire iovec if the types do not match.  Later consider
+ * changing the bio map function.
+ */
+static int bsg_map_user_iovec(request_queue_t *q, struct request *rq,
+			      struct sg_io_v4_vec *vec, int numvec,
+			      size_t tot_len, enum dma_data_direction dir)
+{
+	struct bio *bio;
+	struct sg_iovec *iov;
+	int write_to_vm = (dir == DMA_FROM_DEVICE ? 1 : 0);
+	int must_copy_iovec = (sizeof(*iov) != sizeof(*vec));
+
+	/*
+	 * For 64-bit everywhere, sg_io_v4_vec using __u64 is same as sg_iovec
+	 * using void *.  For 64-bit kernel with 32-bit userspace, also no
+	 * translation needed as userspace is forced to use __u64.  Only in the
+	 * all 32-bit case will sg_iovec use 32-bit pointers and hence we
+	 * must shrink our 64-bit pointers down into it.
+	 */
+	if (must_copy_iovec) {
+		int i;
+		iov = kmalloc(numvec * sizeof(*iov), GFP_KERNEL);
+		for (i=0; i<numvec; i++) {
+			iov[i].iov_base = (void __user *) vec[i].iov_base;
+			iov[i].iov_len = vec[i].iov_len;
+		}
+	} else {
+		iov = (struct sg_iovec *) vec;
+	}
+
+	bio = bio_map_user_iov(q, NULL, iov, numvec, write_to_vm);
+
+	if (must_copy_iovec)
+		kfree(iov);
+
+	if (IS_ERR(bio)) {
+		dprintk("bio_map_user_iov err\n");
+		return PTR_ERR(bio);
+	}
+
+	if (bio->bi_size != tot_len) {
+		dprintk("bio->bi_size %u != len %lu\n", bio->bi_size, tot_len);
+		bio_endio(bio, bio->bi_size, 0);
+		bio_unmap_user(bio);
+		return -EINVAL;
+	}
+
+	bio_get(bio);
+	blk_rq_bio_prep_bidi(q, rq, bio, dir);
+	rq->buffer = rq->data = NULL;
+	return 0;
+}
+
+/*
+ * Map either the in or out bufs.
+ */
+static int bsg_map_data(struct request_queue *q, struct request *rq,
+			__u64 uaddr, __u32 tot_len, __u32 numiov,
+			enum dma_data_direction dir)
+{
+	int ret;
+	void __user *ubuf = (void __user *) (unsigned long) uaddr;
+
+	if (numiov) {
+		struct sg_io_v4_vec *vec;
+		size_t len = numiov * sizeof(*vec);
+
+		vec = kmalloc(len, GFP_KERNEL);
+		if (vec == NULL) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		if (copy_from_user(vec, ubuf, len)) {
+			ret = -EFAULT;
+			kfree(vec);
+			goto out;
+		}
+		ret = bsg_map_user_iovec(q, rq, vec, numiov, tot_len, dir);
+		kfree(vec);
+	} else
+		ret = blk_rq_map_user(q, rq, ubuf, tot_len);
+
+out:
+	return ret;
+}
+
+/*
  * map sg_io_v4 to a request.
  */
 static struct request *
@@ -288,12 +377,10 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 	request_queue_t *q = bd->queue;
 	struct request *rq;
 	int ret, rw = 0; /* shut up gcc */
-	unsigned int dxfer_len;
-	void *dxferp = NULL;
 
-	dprintk("map hdr %llx/%u %llx/%u\n", (unsigned long long) hdr->dout_xferp,
-		hdr->dout_xfer_len, (unsigned long long) hdr->din_xferp,
-		hdr->din_xfer_len);
+	dprintk("map hdr %llx/%u %llx/%u\n",
+	        (unsigned long long) hdr->dout_xferp, hdr->dout_xfer_len,
+		(unsigned long long) hdr->din_xferp, hdr->din_xfer_len);
 
 	ret = bsg_validate_sgv4_hdr(q, hdr, &rw);
 	if (ret)
@@ -305,29 +392,28 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 	rq = blk_get_request(q, rw, GFP_KERNEL);
 	ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, test_bit(BSG_F_WRITE_PERM,
 						       &bd->flags));
-	if (ret) {
-		blk_put_request(rq);
-		return ERR_PTR(ret);
-	}
+	if (ret)
+		goto errout;
 
 	if (hdr->dout_xfer_len) {
-		dxfer_len = hdr->dout_xfer_len;
-		dxferp = (void*)(unsigned long)hdr->dout_xferp;
+		ret = bsg_map_data(q, rq, hdr->dout_xferp, hdr->dout_xfer_len,
+		                   hdr->dout_iovec_count, DMA_TO_DEVICE);
+		if (ret)
+			goto errout;
 	} else if (hdr->din_xfer_len) {
-		dxfer_len = hdr->din_xfer_len;
-		dxferp = (void*)(unsigned long)hdr->din_xferp;
-	} else
-		dxfer_len = 0;
-
-	if (dxfer_len) {
-		ret = blk_rq_map_user(q, rq, dxferp, dxfer_len);
-		if (ret) {
-			dprintk("failed map at %d\n", ret);
-			blk_put_request(rq);
-			rq = ERR_PTR(ret);
-		}
+		ret = bsg_map_data(q, rq, hdr->din_xferp, hdr->din_xfer_len,
+		                   hdr->din_iovec_count, DMA_FROM_DEVICE);
+		if (ret)
+			goto errout;
 	}
 
+	goto out;
+
+errout:
+	blk_put_request(rq);
+	rq = ERR_PTR(ret);
+
+out:
 	return rq;
 }
 
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index 2154a6d..3580921 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -16,6 +16,8 @@ struct sg_io_v4 {
 	__u64 response;		/* [i], [*o] {SCSI: (auto)sense data} */
 
 	/* "din_" for data in (from device); "dout_" for data out (to device) */
+	__u32 dout_iovec_count; /* [i] =0 -> "flat" data transfer */
+	__u32 din_iovec_count;  /* [i] */
 	__u32 dout_xfer_len;	/* [i] bytes to be transferred to device */
 	__u32 din_xfer_len;	/* [i] bytes to be transferred from device */
 	__u64 dout_xferp;	/* [i], [*i] */
@@ -40,6 +42,20 @@ struct sg_io_v4 {
 	__u32 padding;
 };
 
+/*
+ * Vector of address/length pairs, used when dout_iovec_count (or din_)
+ * is non-zero.  In that case, dout_xferp is a list of struct sg_io_v4_vec
+ * and dout_iovec_count is the number of entries in that list.  dout_xfer_len
+ * is the total length of the list.  Note the use of u64 instead of a
+ * native pointer to avoid compat issues, and padding to avoid structure
+ * alignment problems.
+ */
+struct sg_io_v4_vec {
+	__u64 iov_base;
+	__u32 iov_len;
+	__u32 __pad1;
+};
+
 #ifdef __KERNEL__
 
 #if defined(CONFIG_BLK_DEV_BSG)
-- 
1.5.0.2

