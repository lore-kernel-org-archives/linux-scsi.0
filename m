From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: needs to set the residual length of a bidi request.
Date: Tue, 9 Jun 2009 10:57:46 +0900
Message-ID: <20090609105709A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:48976 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756325AbZFIB6q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Jun 2009 21:58:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: tj@kernel.org, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This is against for-2.6.31.

This should fix the following problem:

http://marc.info/?l=linux-scsi&m=124449210813269&w=2

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: needs to set the residual length of a bidi request

Tejun's "block: set rq->resid_len to blk_rq_bytes() on issue" patch
seems to be incomplete; It doesn't set rq->resid_len to blk_rq_bytes()
for a bidi request (req->next_rq). As a result, all bidi users are
broken.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7ae83a1..03c5a64 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1846,6 +1846,9 @@ void blk_start_request(struct request *req)
 	 * resid_len to full count and add the timeout handler.
 	 */
 	req->resid_len = blk_rq_bytes(req);
+	if (unlikely(blk_bidi_rq(req)))
+		req->next_rq->resid_len = blk_rq_bytes(req->next_rq);
+
 	blk_add_timer(req);
 }
 EXPORT_SYMBOL(blk_start_request);
-- 
1.6.0.6

