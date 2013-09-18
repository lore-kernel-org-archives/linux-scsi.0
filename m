From: michaelc@cs.wisc.edu
Subject: [PATCH] block: free bios when failing blk_execute_rq_nowait calls
Date: Wed, 18 Sep 2013 02:37:49 -0500
Message-ID: <1379489869-4492-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47547 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab3IRHiH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Sep 2013 03:38:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, JBottomley@parallels.com, axboe@kernel.dk
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If the queue is dying then we only call the rq->end_io callout.
This leaves bios setup on the request, because the caller assumes when
the blk_execute_rq_nowait/blk_execute_rq call has completed that
the rq->bios have been cleaned up.

This patch has blk_execute_rq_nowait use __blk_end_request_all
to free bios and also call rq->end_io.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/blk-exec.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index e706213..ae4f27d 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -68,9 +68,9 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	spin_lock_irq(q->queue_lock);
 
 	if (unlikely(blk_queue_dying(q))) {
+		rq->cmd_flags |= REQ_QUIET; 
 		rq->errors = -ENXIO;
-		if (rq->end_io)
-			rq->end_io(rq, rq->errors);
+		__blk_end_request_all(rq, rq->errors);
 		spin_unlock_irq(q->queue_lock);
 		return;
 	}
-- 
1.7.1

