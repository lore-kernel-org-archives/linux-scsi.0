From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/4] block: Fix race on request.end_io invocations
Date: Thu, 07 Jun 2012 18:41:14 +0000
Message-ID: <4FD0F5CA.40004@acm.org>
References: <4FD0F558.6090801@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:48070 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab2FGSlR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jun 2012 14:41:17 -0400
In-Reply-To: <4FD0F558.6090801@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>

Some request.end_io implementations can be called safely without
the queue lock held while several other implementations assume
that the queue lock is held. So let's play it safe and make sure
that the queue lock is held around all end_io invocations. Found
this through source code review.

Note: blk_finish_request() already invokes request.end_io with
the queue lock held.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-exec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index fb2cbd5..6724fab 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -54,10 +54,10 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	spin_lock_irq(q->queue_lock);
 
 	if (unlikely(blk_queue_dead(q))) {
-		spin_unlock_irq(q->queue_lock);
 		rq->errors = -ENXIO;
 		if (rq->end_io)
 			rq->end_io(rq, rq->errors);
+		spin_unlock_irq(q->queue_lock);
 		return;
 	}
 
-- 
1.7.7

