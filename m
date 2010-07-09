From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/3] block: set up rq->rq_disk properly for flush requests
Date: Fri,  9 Jul 2010 09:38:25 +0900
Message-ID: <1278635906-16400-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1278635906-16400-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:49700 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758921Ab0GIAjS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jul 2010 20:39:18 -0400
In-Reply-To: <1278635906-16400-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

q->bar_rq.rq_disk is NULL. Use the rq_disk of the original request
instead.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-barrier.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index e7fed5e..fa047b3 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -136,7 +136,7 @@ static void queue_flush(struct request_queue *q, unsigned which)
 	blk_rq_init(q, rq);
 	rq->cmd_type = REQ_TYPE_FS;
 	rq->cmd_flags = REQ_HARDBARRIER | REQ_FLUSH;
-	rq->rq_disk = q->bar_rq.rq_disk;
+	rq->rq_disk = q->orig_bar_rq->rq_disk;
 	rq->end_io = end_io;
 
 	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
-- 
1.6.5

