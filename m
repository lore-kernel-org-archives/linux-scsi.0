From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH v2] bsg: iovec support with explicit u64
Date: Mon, 19 Mar 2007 14:13:49 -0400
Message-ID: <20070319181349.GC32043@osc.edu>
References: <45FE8887.8040901@torque.net> <20070319184305U.fujita.tomonori@lab.ntt.co.jp> <45FE987D.5070908@torque.net> <20070319232113N.fujita.tomonori@lab.ntt.co.jp> <20070319180727.GB32043@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:34170 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481AbXCSSNu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Mar 2007 14:13:50 -0400
Content-Disposition: inline
In-Reply-To: <20070319232113N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dougg@torque.net, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

pw@osc.edu wrote on Mon, 19 Mar 2007 14:07 -0400:
> Here is the patch to use sg_iovec, with its userspace void * and
> size_t, and the CONFIG_COMPAT code to fixup 32-bit userspace.  I'm
> not fond of having __u64 for non-iovec buffer representations, and
> void * for iovec buffer representations, but it saves having to
> build an sg_iovec just to call into the existing blk_rq_map_user_iov.

Just for comparison, a cleaned up version of the earlier patch that
does not require compat conversion.  Instead, use a new struct
sg_v4_iovec with explicit u64/u32 representation for user pointer
and length.

Perhaps later we might change blk_rq_map_user_iov to take
sg_v4_iovec and let sgv3 convert its sg_iovec into that.

		-- Pete


Support vectored IO as in SGv3.  The iovec structure uses explicit
sizes to avoid the need for compat conversion.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 block/bsg.c         |   95 ++++++++++++++++++++++++++++++++++++++------------
 include/linux/bsg.h |   14 +++++++
 2 files changed, 86 insertions(+), 23 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index f1ea258..e334f75 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -280,6 +280,56 @@ bsg_validate_sgv4_hdr(request_queue_t *q, struct sg_io_v4 *hdr, int *rw)
 }
 
 /*
+ * Map either the in or out bufs.  Convert sg_v4_iovec to sg_iovec
+ * to use existing blk_rq_map infrastructure.  We could do a copy-in-place
+ * conversion on 64-bit kernels, just by zeroing the top half of sg_iovec's
+ * iov_len, but do not, for simplicity.
+ */
+static int bsg_map_data(struct request_queue *q, struct request *rq,
+			__u64 uaddr, __u32 tot_len, __u32 numiov,
+			enum dma_data_direction dir)
+{
+	int i, ret;
+	void __user *ubuf = (void __user *) (unsigned long) uaddr;
+	struct sg_iovec fastiov[8], *iov = fastiov;
+	struct sg_v4_iovec v4_fastiov[8], *v4_iov = v4_fastiov;
+
+	if (numiov == 0) {
+		ret = blk_rq_map_user(q, rq, ubuf, tot_len);
+		goto out;
+	}
+
+	if (numiov >= ARRAY_SIZE(fastiov)) {
+		iov = kmalloc(numiov * (sizeof(*iov) + sizeof(*v4_iov)),
+			      GFP_KERNEL);
+		if (iov == NULL) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		v4_iov = (void *) &iov[numiov];
+	}
+
+	if (copy_from_user(v4_iov, ubuf, numiov * sizeof(*v4_iov))) {
+		ret = -EFAULT;
+		goto outfree;
+	}
+
+	for (i=0; i<numiov; i++) {
+		iov[i].iov_base = (void *)(unsigned long) v4_iov[i].iov_base;
+		iov[i].iov_len = v4_iov[i].iov_len;
+	}
+
+	ret = blk_rq_map_user_iov(q, rq, iov, numiov, tot_len);
+
+outfree:
+	if (iov != fastiov)
+		kfree(iov);
+
+out:
+	return ret;
+}
+
+/*
  * map sg_io_v4 to a request.
  */
 static struct request *
@@ -288,12 +338,12 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 	request_queue_t *q = bd->queue;
 	struct request *rq;
 	int ret, rw = 0; /* shut up gcc */
-	unsigned int dxfer_len;
-	void *dxferp = NULL;
 
-	dprintk("map hdr %llx/%u %llx/%u\n", (unsigned long long) hdr->dout_xferp,
-		hdr->dout_xfer_len, (unsigned long long) hdr->din_xferp,
-		hdr->din_xfer_len);
+	dprintk("map hdr %llx/%u/%u %llx/%u/%u\n",
+	        (unsigned long long) hdr->dout_xferp, hdr->dout_xfer_len,
+		hdr->dout_iovec_count,
+		(unsigned long long) hdr->din_xferp, hdr->din_xfer_len,
+		hdr->din_iovec_count);
 
 	ret = bsg_validate_sgv4_hdr(q, hdr, &rw);
 	if (ret)
@@ -305,29 +355,28 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
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
index 51152cb..7c11e67 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -16,6 +16,8 @@ struct sg_io_v4 {
 	__u64 response;		/* [i], [*o] {SCSI: (auto)sense data} */
 
 	/* "din_" for data in (from device); "dout_" for data out (to device) */
+	__u32 dout_iovec_count; /* [i] =0 -> "flat" data transfer */
+	__u32 din_iovec_count;  /* [i] >0 -> dxfer is struct sg_v4_iovec * */
 	__u32 dout_xfer_len;	/* [i] bytes to be transferred to device */
 	__u32 din_xfer_len;	/* [i] bytes to be transferred from device */
 	__u64 dout_xferp;	/* [i], [*i] */
@@ -40,6 +42,18 @@ struct sg_io_v4 {
 	__u32 padding;
 };
 
+/*
+ * Vector of address/length pairs, used when dout_iovec_count (or din_)
+ * is non-zero.  In that case, dout_xferp is a list of struct sg_v4_iovec
+ * and dout_iovec_count is the number of entries in that list.  dout_xfer_len
+ * is the total length of the list.
+ */
+struct sg_v4_iovec {
+	__u64 iov_base;
+	__u32 iov_len;
+	__u32 __pad1;
+};
+
 #ifdef __KERNEL__
 
 #if defined(CONFIG_BLK_DEV_BSG)
-- 
1.5.0.3

