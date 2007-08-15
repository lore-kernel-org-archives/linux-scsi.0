From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH 3/3] varlen bsg submit
Date: Wed, 15 Aug 2007 14:17:04 -0500
Message-ID: <20070815191704.GD14977@osc.edu>
References: <20070815191523.GA14977@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:58091 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761057AbXHOT2Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2007 15:28:25 -0400
Content-Disposition: inline
In-Reply-To: <20070815191523.GA14977@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

Accept variable length SCSI commands through BSG.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 block/bsg.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index eb0aaf4..c72b4f9 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -175,11 +175,22 @@ unlock:
 static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
 				struct sg_io_v4 *hdr, int has_write_perm)
 {
+	int len = hdr->request_len;
+
 	memset(rq->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
 
 	if (copy_from_user(rq->cmd, (void *)(unsigned long)hdr->request,
-			   hdr->request_len))
+			   min(len, BLK_MAX_CDB)))
 		return -EFAULT;
+	if (len > BLK_MAX_CDB) {
+		rq->varlen_cdb_len = len;
+		rq->varlen_cdb = kmalloc(len, GFP_KERNEL);
+		if (rq->varlen_cdb == NULL)
+			return -ENOMEM;
+		if (copy_from_user(rq->varlen_cdb,
+		                   (void *)(unsigned long)hdr->request, len))
+			return -EFAULT;
+	}
 
 	if (hdr->subprotocol == BSG_SUB_PROTOCOL_SCSI_CMD) {
 		if (blk_verify_command(rq->cmd, has_write_perm))
@@ -190,7 +201,7 @@ static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
 	/*
 	 * fill in request structure
 	 */
-	rq->cmd_len = hdr->request_len;
+	rq->cmd_len = min(len, BLK_MAX_CDB);
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 
 	rq->timeout = (hdr->timeout * HZ) / 1000;
@@ -212,8 +223,6 @@ bsg_validate_sgv4_hdr(struct request_queue *q, struct sg_io_v4 *hdr, int *rw)
 
 	if (hdr->guard != 'Q')
 		return -EINVAL;
-	if (hdr->request_len > BLK_MAX_CDB)
-		return -EINVAL;
 	if (hdr->dout_xfer_len > (q->max_sectors << 9) ||
 	    hdr->din_xfer_len > (q->max_sectors << 9))
 		return -EIO;
@@ -303,6 +312,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 	}
 	return rq;
 out:
+	kfree(rq->varlen_cdb);
 	blk_put_request(rq);
 	if (next_rq) {
 		blk_rq_unmap_user(next_rq->bio);
@@ -443,6 +453,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	}
 
 	blk_rq_unmap_user(bio);
+	kfree(rq->varlen_cdb);
 	blk_put_request(rq);
 
 	return ret;
-- 
1.5.2.4

