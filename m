From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] Revert "block: WARN in __blk_put_request() for potential
 bio leak"
Date: Tue, 9 Jun 2009 19:44:11 +0900
Message-ID: <20090609194338S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:47716 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932314AbZFIKoW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Jun 2009 06:44:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com

This reverts commit 1cd96c242a829d52f7a5ae98f554ca9775429685.

commit 1cd96c242a829d52f7a5ae98f554ca9775429685
Author: Boaz Harrosh <bharrosh@panasas.com>
Date:   Tue Mar 24 12:35:07 2009 +0100

    block: WARN in __blk_put_request() for potential bio leak

    Put a WARN_ON in __blk_put_request if it is about to
    leak bio(s). This is a serious bug that can happen in error
    handling code paths.

    For this to work I have fixed a couple of places in block/ where
    request->bio != NULL ownership was not honored. And a small cleanup
    at sg_io() while at it.


With 2.6.30-rc, BSG SMP requests get the following warnings:

WARNING: at block/blk-core.c:1068 __blk_put_request+0x52/0xc0()

However, this is false. There is no bio leak wrt BSG SMP
requests. Probably the better fix is calling blk_end_request_all() in
the BSG SMP path.

blk_end_request_all() is not very useful for the BSG SMP path (we call
it to just unlink rq->bio) however calling blk_end_request_all() in
all bio users is consistent.

blk_end_request_all() is not available in 2.6.30-rc so seems that the
simplest fix is removing WARN_ON for now.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-core.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c89883b..4aacb3c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1064,9 +1064,6 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 
 	elv_completed_request(q, req);
 
-	/* this is a bio leak */
-	WARN_ON(req->bio != NULL);
-
 	/*
 	 * Request may not have originated from ll_rw_blk. if not,
 	 * it didn't come out of our reserved rq pools
-- 
1.6.0.6


