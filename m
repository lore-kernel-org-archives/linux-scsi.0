From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/4] block: Fix race on request_queue.end_io invocations
Date: Tue, 05 Jun 2012 17:10:15 +0000
Message-ID: <4FCE3D77.8040909@acm.org>
References: <4FCE3D20.4000205@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:55861 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab2FERKS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jun 2012 13:10:18 -0400
In-Reply-To: <4FCE3D20.4000205@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>

Some request_queue.end_io implementations can be called safely
without the queue lock held while several other implementations
assume that the queue lock is held. So let's play it safe and
make sure that the queue lock is held around end_io invocations.
Found this through source code review.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@kernel.org>
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
 
