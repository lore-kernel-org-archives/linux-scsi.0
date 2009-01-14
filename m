From: Boaz Harrosh <bharrosh@panasas.com>
Subject: support of sg_iovec in bsg's struct sg_io_v4
Date: Wed, 14 Jan 2009 20:01:07 +0200
Message-ID: <496E2863.40103@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:25806 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753084AbZANSBM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2009 13:01:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Is below just missing or is there something I do not understand?

It looks like the conversion from struct sg_io_hdr to struct sg_io_v4 the use
of sg_iovec was dropped. Even though all the members and code comments
say it is the same.

This adds the support in bsg and struct sg_io_v4 exactly in the same way
it was done in sg with struct sg_io_hdr.

BTW why is the ioctl SG_IO defined exactly the same for sg.c and bsg.c
even though they have none compatible API/ABI? Is that because we have the
protection of the first __s32 member that is 'Q' for bsg and 'S' or 0 for
sg? Is that usually done with ioctl's?

Not-signed-or-tested: Boaz Harrosh <bharrosh@panasas.com>
---
git diff --stat -p block/bsg.c
 block/bsg.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index d414bb5..1489458 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -285,8 +285,13 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm)
 		next_rq->cmd_type = rq->cmd_type;
 
 		dxferp = (void*)(unsigned long)hdr->din_xferp;
-		ret =  blk_rq_map_user(q, next_rq, NULL, dxferp,
-				       hdr->din_xfer_len, GFP_KERNEL);
+		if (hdr->din_iovec_count)
+			ret = blk_rq_map_user_iov(q, next_rq, NULL, dxferp,
+						  hdr->din_iovec_count,
+						  hdr->din_xfer_len, GFP_KERNEL);
+		else
+			ret =  blk_rq_map_user(q, next_rq, NULL, dxferp,
+					       hdr->din_xfer_len, GFP_KERNEL);
 		if (ret)
 			goto out;
 	}
@@ -301,8 +306,13 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm)
 		dxfer_len = 0;
 
 	if (dxfer_len) {
-		ret = blk_rq_map_user(q, rq, NULL, dxferp, dxfer_len,
-				      GFP_KERNEL);
+		if (hdr->dout_iovec_count)
+			ret = blk_rq_map_user_iov(q, rq, NULL, dxferp,
+						  hdr->dout_iovec_count,
+						  dxfer_len, GFP_KERNEL);
+		else
+			ret = blk_rq_map_user(q, rq, NULL, dxferp, dxfer_len,
+					      GFP_KERNEL);
 		if (ret)
 			goto out;
 	}
