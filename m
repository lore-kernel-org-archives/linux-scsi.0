From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] bsg: add large command support
Date: Wed, 30 Apr 2008 13:16:21 +0900
Message-ID: <20080430131616O.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:50597 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbYD3EQ6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Apr 2008 00:16:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, pw@osc.edu, jens.axboe@oracle.com

This is against Linus' tree since this depends on the large command
support of the block layer, which was merged few hours ago.

This can be applied now since it doesn't depend on Boaz's variable
length CDB support though this is useful only for the variable length
CDB.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] bsg: add large command support

This enables bsg to handle the request length larger than BLK_MAX_CDB
(mainly for the variable length CDB format).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: Pete Wyckoff <pw@osc.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/bsg.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 23ea4fd..d8b889d 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -174,7 +174,11 @@ unlock:
 static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
 				struct sg_io_v4 *hdr, int has_write_perm)
 {
-	memset(rq->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
+	if (hdr->request_len > BLK_MAX_CDB) {
+		rq->cmd = kzalloc(hdr->request_len, GFP_KERNEL);
+		if (!rq->cmd)
+			return -ENOMEM;
+	}
 
 	if (copy_from_user(rq->cmd, (void *)(unsigned long)hdr->request,
 			   hdr->request_len))
@@ -211,8 +215,6 @@ bsg_validate_sgv4_hdr(struct request_queue *q, struct sg_io_v4 *hdr, int *rw)
 
 	if (hdr->guard != 'Q')
 		return -EINVAL;
-	if (hdr->request_len > BLK_MAX_CDB)
-		return -EINVAL;
 	if (hdr->dout_xfer_len > (q->max_sectors << 9) ||
 	    hdr->din_xfer_len > (q->max_sectors << 9))
 		return -EIO;
@@ -302,6 +304,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 	}
 	return rq;
 out:
+	if (rq->cmd != rq->__cmd)
+		kfree(rq->cmd);
 	blk_put_request(rq);
 	if (next_rq) {
 		blk_rq_unmap_user(next_rq->bio);
@@ -455,6 +459,8 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 		ret = rq->errors;
 
 	blk_rq_unmap_user(bio);
+	if (rq->cmd != rq->__cmd)
+		kfree(rq->cmd);
 	blk_put_request(rq);
 
 	return ret;
-- 
1.5.4.2

