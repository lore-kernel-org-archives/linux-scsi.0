From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/3] block: set REQ_TYPE_FS on flush requests
Date: Fri,  9 Jul 2010 09:38:24 +0900
Message-ID: <1278635906-16400-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1278635906-16400-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:49697 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259Ab0GIAjQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jul 2010 20:39:16 -0400
In-Reply-To: <1278635906-16400-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

the block layer doesn't set rq->cmd_type on flush requests. By
definition, it should be REQ_TYPE_FS (the lower layers build a command
and interpret the result of it, that is, the block layer doesn't know
the details).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-barrier.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index eefbde8..e7fed5e 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -134,6 +134,7 @@ static void queue_flush(struct request_queue *q, unsigned which)
 	}
 
 	blk_rq_init(q, rq);
+	rq->cmd_type = REQ_TYPE_FS;
 	rq->cmd_flags = REQ_HARDBARRIER | REQ_FLUSH;
 	rq->rq_disk = q->bar_rq.rq_disk;
 	rq->end_io = end_io;
-- 
1.6.5

