From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH v2] bsg: iovec support with compat
Date: Mon, 19 Mar 2007 14:07:27 -0400
Message-ID: <20070319180727.GB32043@osc.edu>
References: <45FE8887.8040901@torque.net> <20070319184305U.fujita.tomonori@lab.ntt.co.jp> <45FE987D.5070908@torque.net> <20070319232113N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:39666 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030417AbXCSSHa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Mar 2007 14:07:30 -0400
Content-Disposition: inline
In-Reply-To: <20070319232113N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dougg@torque.net, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

fujita.tomonori@lab.ntt.co.jp wrote on Mon, 19 Mar 2007 23:21 +0900:
> From: Douglas Gilbert <dougg@torque.net>
> Subject: Re: [PATCH] bsg: iovec support
> Date: Mon, 19 Mar 2007 10:04:45 -0400
> 
> > >> Pete is also suggesting (shown above) a revised sg_io_vec
> > >> structure that uses a uint64_t for the pointer to simplify
> > >> 32, 64 bit thunking.
> > > 
> > > All I said is that it would be better to use the existing compat
> > > infrastructure (sg_build_iovec, sg_ioctl_trans, etc in
> > > fs/compat_ioctl.c) instead of adding another compat code.
> > 
> > Won't sg v4 make this even a bigger mess, at least
> > initially anyway?
> 
> Inventing a new iovec structure like sg_io_v4_vec and something like
> blk_rq_map_user_iov_sgv4 sounds a mess.

It is sort of a mess to have new blk mapping routine for a new iovec
type.  But I very much did not want to introduce the need for
another compat conversion.  But, I took a look at how it would be to
pass the existing sg_iovec into bsg.

Adding a new bsg_write_compat would be bad.  There is lots of
parsing and setup before we even get to the possibility of iovec
data mapping.  Reusing just sg_build_ioctl from compat_ioctl.c is
also suboptimal as this function is built around the idea of a
contiguous sg_io_hdr + iovec in userspace.  The function is small
enough that splitting it into a generic + ioctl-specific part would
add too much abstraction to be worth it.

Here is the patch to use sg_iovec, with its userspace void * and
size_t, and the CONFIG_COMPAT code to fixup 32-bit userspace.  I'm
not fond of having __u64 for non-iovec buffer representations, and
void * for iovec buffer representations, but it saves having to
build an sg_iovec just to call into the existing blk_rq_map_user_iov.

Comments?

		-- Pete


Support vectored IO as in SGv3.  This uses the standard struct sg_iovec
(same as struct iovec) and converts if necessary for CONFIG_COMPAT.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 block/bsg.c         |  105 +++++++++++++++++++++++++++++++++++++++-----------
 include/linux/bsg.h |    2 +
 2 files changed, 84 insertions(+), 23 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index f1ea258..5a31062 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -25,6 +25,7 @@
 #include <linux/percpu.h>
 #include <linux/uio.h>
 #include <linux/bsg.h>
+#include <linux/compat.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
@@ -280,6 +281,65 @@ bsg_validate_sgv4_hdr(request_queue_t *q, struct sg_io_v4 *hdr, int *rw)
 }
 
 /*
+ * Map either the in or out bufs.  Handle compat conversion for
+ * iovec too.
+ */
+static int bsg_map_data(struct request_queue *q, struct request *rq,
+			__u64 uaddr, __u32 tot_len, __u32 numiov,
+			enum dma_data_direction dir)
+{
+	int ret;
+	void __user *ubuf = (void __user *) (unsigned long) uaddr;
+	struct sg_iovec fastiov[8], *iov = fastiov;
+
+	if (numiov == 0) {
+		ret = blk_rq_map_user(q, rq, ubuf, tot_len);
+		goto out;
+	}
+
+	if (numiov >= ARRAY_SIZE(fastiov)) {
+		iov = kmalloc(numiov * sizeof(*iov), GFP_KERNEL);
+		if (iov == NULL) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+
+#ifdef CONFIG_COMPAT
+	if (sizeof(struct compat_iovec) != sizeof(*iov)) {
+		struct compat_iovec __user *compat_iov = ubuf;
+		int i;
+		for (i=0; i<numiov; i++) {
+			compat_uptr_t cbase;
+			compat_size_t clen;
+			if (get_user(cbase, &compat_iov[i].iov_base)
+			 || get_user(clen, &compat_iov[i].iov_len)) {
+				ret = -EFAULT;
+				goto outfree;
+			}
+			iov[i].iov_base = compat_ptr(cbase);
+			iov[i].iov_len = clen;
+		}
+		goto map;
+	}
+#endif
+
+	if (copy_from_user(iov, ubuf, numiov * sizeof(*iov))) {
+		ret = -EFAULT;
+		goto outfree;
+	}
+map:
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
@@ -288,12 +348,12 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
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
@@ -305,29 +365,28 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
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
index 51152cb..6bd7311 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -16,6 +16,8 @@ struct sg_io_v4 {
 	__u64 response;		/* [i], [*o] {SCSI: (auto)sense data} */
 
 	/* "din_" for data in (from device); "dout_" for data out (to device) */
+	__u32 dout_iovec_count; /* [i] =0 -> "flat" data transfer */
+	__u32 din_iovec_count;  /* [i] >0 -> dxfer is struct sg_iovec * */
 	__u32 dout_xfer_len;	/* [i] bytes to be transferred to device */
 	__u32 din_xfer_len;	/* [i] bytes to be transferred from device */
 	__u64 dout_xferp;	/* [i], [*i] */
-- 
1.5.0.3

