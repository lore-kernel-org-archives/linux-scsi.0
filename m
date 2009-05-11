From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/3] block: let blk_end_request_all handle bidi requests
Date: Mon, 11 May 2009 17:56:07 +0900
Message-ID: <1242032169-22422-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1242032169-22422-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:37524 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262AbZEKI46 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2009 04:56:58 -0400
In-Reply-To: <1242032169-22422-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: tj@kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

blk_end_request_all() and __blk_end_request_all() should finish all
bytes including bidi, by definition. That's what all bidi users need ,
bidi requests must be complete as a whole (partial completion is
impossible).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/blkdev.h |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8919683..3b5c564 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -911,8 +911,12 @@ static inline bool blk_end_request(struct request *rq, int error,
 static inline void blk_end_request_all(struct request *rq, int error)
 {
 	bool pending;
+	unsigned int bidi_bytes = 0;
 
-	pending = blk_end_request(rq, error, blk_rq_bytes(rq));
+	if (unlikely(blk_bidi_rq(rq)))
+		bidi_bytes = blk_rq_bytes(rq->next_rq);
+
+	pending = blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes);
 	BUG_ON(pending);
 }
 
@@ -963,8 +967,12 @@ static inline bool __blk_end_request(struct request *rq, int error,
 static inline void __blk_end_request_all(struct request *rq, int error)
 {
 	bool pending;
+	unsigned int bidi_bytes = 0;
+
+	if (unlikely(blk_bidi_rq(rq)))
+		bidi_bytes = blk_rq_bytes(rq->next_rq);
 
-	pending = __blk_end_request(rq, error, blk_rq_bytes(rq));
+	pending = __blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes);
 	BUG_ON(pending);
 }
 
-- 
1.6.0.6

