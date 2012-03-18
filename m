From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] block: Make blk_drain_queue() work for stopped queues
Date: Sun, 18 Mar 2012 13:18:21 +0000
Message-ID: <4F65E09D.6010600@acm.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090200070107000109010504"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:35633 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab2CRNS2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Mar 2012 09:18:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------090200070107000109010504
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

All queued requests must be processed eventually. Hence make sure
that blk_drain_queue() drains the queue even if the queue is in the
stopped state. This patch makes it safe to invoke blk_cleanup_queue()
on a stopped queue.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: stable@vger.kernel.org
---
 block/blk-core.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3a78b00..bdcec86 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -300,10 +300,8 @@ EXPORT_SYMBOL(blk_sync_queue);
  */
 void __blk_run_queue(struct request_queue *q)
 {
-	if (unlikely(blk_queue_stopped(q)))
-		return;
-
-	q->request_fn(q);
+	if (!blk_queue_stopped(q) || blk_queue_dead(q))
+		q->request_fn(q);
 }
 EXPORT_SYMBOL(__blk_run_queue);
 -- 1.7.7



--------------090200070107000109010504
Content-Type: text/plain;
 name="Attached Message Part"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Attached Message Part"


--------------090200070107000109010504--
