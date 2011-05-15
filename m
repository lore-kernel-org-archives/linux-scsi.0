From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 3/3] bsg: fix address space warning from sparse
Date: Sun, 15 May 2011 14:31:53 +0900
Message-ID: <1305437513-3914-3-git-send-email-namhyung@gmail.com>
References: <1305437513-3914-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34917 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab1EOFcD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 May 2011 01:32:03 -0400
In-Reply-To: <1305437513-3914-1-git-send-email-namhyung@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

copy_from/to_user() and blk_rq_map_user() want __user pointer.
This patch fixes following warnings from sparse:

   CHECK   block/bsg.c
 block/bsg.c:185:38: warning: incorrect type in argument 2 (different address spaces)
 block/bsg.c:185:38:    expected void const [noderef] <asn:1>*from
 block/bsg.c:185:38:    got void *<noident>
 block/bsg.c:295:58: warning: incorrect type in argument 4 (different address spaces)
 block/bsg.c:295:58:    expected void [noderef] <asn:1>*<noident>
 block/bsg.c:295:58:    got void *[assigned] dxferp
 block/bsg.c:311:52: warning: incorrect type in argument 4 (different address spaces)
 block/bsg.c:311:52:    expected void [noderef] <asn:1>*<noident>
 block/bsg.c:311:52:    got void *[assigned] dxferp
 block/bsg.c:448:37: warning: incorrect type in argument 1 (different address spaces)
 block/bsg.c:448:37:    expected void [noderef] <asn:1>*dst
 block/bsg.c:448:37:    got void *<noident>

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 block/bsg.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index b7e42ad55361..702f1316bb8f 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -182,7 +182,7 @@ static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
 			return -ENOMEM;
 	}
 
-	if (copy_from_user(rq->cmd, (void *)(unsigned long)hdr->request,
+	if (copy_from_user(rq->cmd, (void __user *)(unsigned long)hdr->request,
 			   hdr->request_len))
 		return -EFAULT;
 
@@ -249,7 +249,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
 	struct request *rq, *next_rq = NULL;
 	int ret, rw;
 	unsigned int dxfer_len;
-	void *dxferp = NULL;
+	void __user *dxferp = NULL;
 	struct bsg_class_device *bcd = &q->bsg_dev;
 
 	/* if the LLD has been removed then the bsg_unregister_queue will
@@ -291,7 +291,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
 		rq->next_rq = next_rq;
 		next_rq->cmd_type = rq->cmd_type;
 
-		dxferp = (void*)(unsigned long)hdr->din_xferp;
+		dxferp = (void __user *)(unsigned long)hdr->din_xferp;
 		ret =  blk_rq_map_user(q, next_rq, NULL, dxferp,
 				       hdr->din_xfer_len, GFP_KERNEL);
 		if (ret)
@@ -300,10 +300,10 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
 
 	if (hdr->dout_xfer_len) {
 		dxfer_len = hdr->dout_xfer_len;
-		dxferp = (void*)(unsigned long)hdr->dout_xferp;
+		dxferp = (void __user *)(unsigned long)hdr->dout_xferp;
 	} else if (hdr->din_xfer_len) {
 		dxfer_len = hdr->din_xfer_len;
-		dxferp = (void*)(unsigned long)hdr->din_xferp;
+		dxferp = (void __user *)(unsigned long)hdr->din_xferp;
 	} else
 		dxfer_len = 0;
 
@@ -445,7 +445,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 		int len = min_t(unsigned int, hdr->max_response_len,
 					rq->sense_len);
 
-		ret = copy_to_user((void*)(unsigned long)hdr->response,
+		ret = copy_to_user((void __user *)(unsigned long)hdr->response,
 				   rq->sense, len);
 		if (!ret)
 			hdr->response_len = len;
-- 
1.7.5

