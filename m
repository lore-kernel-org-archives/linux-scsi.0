From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 7/7] Remove get_device() / put_device() pair from scsi_request_fn()
Date: Fri, 26 Oct 2012 14:05:47 +0200
Message-ID: <508A7C9B.5020800@acm.org>
References: <508A7B63.60608@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:37594 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab2JZMFs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Oct 2012 08:05:48 -0400
In-Reply-To: <508A7B63.60608@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

Since all scsi_request_fn() callers hold a reference on the
SCSI device that function is invoked for and since
blk_cleanup_queue() waits until scsi_request_fn() has finished
it is safe to remove the get_device() / put_device() pair from
scsi_request_fn().

Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c5d4ec2..71bddec 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1516,16 +1516,14 @@ static void scsi_softirq_done(struct request *rq)
  * Lock status: IO request lock assumed to be held when called.
  */
 static void scsi_request_fn(struct request_queue *q)
+	__releases(q->queue_lock)
+	__acquires(q->queue_lock)
 {
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost;
 	struct scsi_cmnd *cmd;
 	struct request *req;
 
-	if(!get_device(&sdev->sdev_gendev))
-		/* We must be tearing the block queue down already */
-		return;
-
 	/*
 	 * To start with, we keep looping until the queue is empty, or until
 	 * the host is no longer able to accept any more requests.
@@ -1634,11 +1632,7 @@ out_delay:
 	if (sdev->device_busy == 0)
 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
 out:
-	/* must be careful here...if we trigger the ->remove() function
-	 * we cannot be holding the q lock */
-	spin_unlock_irq(q->queue_lock);
-	put_device(&sdev->sdev_gendev);
-	spin_lock_irq(q->queue_lock);
+	;
 }
 
 u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
-- 
1.7.10.4

