From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/3] block: set up rq->rq_disk properly for flush requests
Date: Thu, 24 Jun 2010 00:07:30 +0900
Message-ID: <1277305652-2306-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1277305652-2306-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:39443 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab0FWPLJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jun 2010 11:11:09 -0400
In-Reply-To: <1277305652-2306-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

q->bar_rq.rq_disk is NULL. Use the rq_disk of the original request
instead.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-barrier.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 7c6f4a7..4646f6d 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -144,7 +144,7 @@ static void queue_flush(struct request_queue *q, unsigned which)
 
 	blk_rq_init(q, rq);
 	rq->cmd_flags = REQ_HARDBARRIER;
-	rq->rq_disk = q->bar_rq.rq_disk;
+	rq->rq_disk = q->orig_bar_rq->rq_disk;
 	rq->end_io = end_io;
 	q->prepare_flush_fn(q, rq);
 
-- 
1.6.5

