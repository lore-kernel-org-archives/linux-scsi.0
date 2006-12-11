From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] remove unnecessary blk_queue_bounce in SG_IO
Date: Tue, 12 Dec 2006 07:52:12 +0900
Message-ID: <20061212075212A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:32773 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750700AbWLKWv6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Dec 2006 17:51:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org

When I converted the origianl patch, I left unnecessary
blk_queue_bounce in SG_IO.

---
[PATCH] remove unnecessary blk_queue_bounce in SG_IO

This patch removes blk_queue_bounce in SG_IO since the blk functions
handle it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 045cabd..f322b6a 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -271,13 +271,6 @@ static int sg_io(struct file *file, requ
 
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 
-	/*
-	 * bounce this after holding a reference to the original bio, it's
-	 * needed for proper unmapping
-	 */
-	if (rq->bio)
-		blk_queue_bounce(q, &rq->bio);
-
 	rq->timeout = jiffies_to_msecs(hdr->timeout);
 	if (!rq->timeout)
 		rq->timeout = q->sg_timeout;
