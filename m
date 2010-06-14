From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [BSG]: Add support for struct sg_io_v4->d[out,in]_iovec_count
Date: Sun, 13 Jun 2010 23:11:29 -0700
Message-ID: <1276495889-1714-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:42208 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751537Ab0FNGKl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jun 2010 02:10:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>, James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings Jens and co,

This patch adds the missing support to block/bsg.c:bsg_map_hdr() to accept
struct sg_io_v4->d[out,in]_iovec_count and process struct sg_io_v4->d[out,in]_xferp memory
containing userspace iovecs for kernel level BSG.  It adds a new wrapper bsg_rq_map_user_iov()
that will call copy_from_user() and blk_rq_map_user_iov() following the original SG_IO logic in
drivers/scsi/sg.c:sg_start_req().

So far this has been tested on a x86_64 v2.6.34 KVM Host with TCM_Loop Virtual SAS Port/LUNs
into a x86_64 v2.6.26 KVM Guest with Megasas 8707EM2 HBA Emulation + my new scsi-bsg backstore code.

Please consider this for v2.6.36 as it will be required in order for QEMU-KVM MegaSAS and VirtIO HBA
emulation using QEMU scatterlist memory and BSG backstores.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 block/bsg.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 82d5882..3f789cf 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -239,6 +239,33 @@ bsg_validate_sgv4_hdr(struct request_queue *q, struct sg_io_v4 *hdr, int *rw)
 	return ret;
 }
 
+static int
+bsg_rq_map_user_iov(struct request_queue *q, struct request *rq, void *dxferp,
+	unsigned int dxfer_len, int iovec_count, int gfp)
+{
+	struct iovec *iov;
+	int len, ret, size = sizeof(struct sg_iovec) * iovec_count;
+
+	iov = kzalloc(size, GFP_ATOMIC);
+	if (!iov)
+		return -ENOMEM;
+	
+	if (copy_from_user(iov, dxferp, size)) {
+		kfree(iov);
+		return -EFAULT;
+	}
+
+	len = iov_length(iov, iovec_count);
+	if (dxfer_len < len) {
+		iovec_count = iov_shorten(iov, iovec_count, dxfer_len);
+		len = dxfer_len;
+	}
+	ret = blk_rq_map_user_iov(q, rq, NULL, dxferp, iovec_count,
+			len, gfp);
+	kfree(iov);	
+	return ret;
+}
+
 /*
  * map sg_io_v4 to a request.
  */
@@ -248,7 +275,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
 {
 	struct request_queue *q = bd->queue;
 	struct request *rq, *next_rq = NULL;
-	int ret, rw;
+	int ret, rw, iovec_count;
 	unsigned int dxfer_len;
 	void *dxferp = NULL;
 
@@ -284,28 +311,40 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
 		rq->next_rq = next_rq;
 		next_rq->cmd_type = rq->cmd_type;
 
+		iovec_count = hdr->din_iovec_count;
 		dxferp = (void*)(unsigned long)hdr->din_xferp;
-		ret =  blk_rq_map_user(q, next_rq, NULL, dxferp,
-				       hdr->din_xfer_len, GFP_KERNEL);
+
+		if (iovec_count)
+			ret = bsg_rq_map_user_iov(q, next_rq, dxferp,
+					hdr->din_xfer_len, iovec_count,
+					GFP_KERNEL);
+		else
+			ret = blk_rq_map_user(q, next_rq, NULL, dxferp,
+					hdr->din_xfer_len, GFP_KERNEL);
 		if (ret)
 			goto out;
 	}
 
 	if (hdr->dout_xfer_len) {
 		dxfer_len = hdr->dout_xfer_len;
+		iovec_count = hdr->dout_iovec_count;
 		dxferp = (void*)(unsigned long)hdr->dout_xferp;
 	} else if (hdr->din_xfer_len) {
 		dxfer_len = hdr->din_xfer_len;
+		iovec_count = hdr->din_iovec_count;
 		dxferp = (void*)(unsigned long)hdr->din_xferp;
 	} else
 		dxfer_len = 0;
 
-	if (dxfer_len) {
+	if (iovec_count && dxfer_len) 
+		ret = bsg_rq_map_user_iov(q, rq, dxferp, dxfer_len,
+				iovec_count, GFP_KERNEL);
+	else if (dxfer_len)
 		ret = blk_rq_map_user(q, rq, NULL, dxferp, dxfer_len,
-				      GFP_KERNEL);
-		if (ret)
-			goto out;
-	}
+				GFP_KERNEL);
+	
+	if (ret)
+		goto out;
 
 	rq->sense = sense;
 	rq->sense_len = 0;
-- 
1.5.6.5

