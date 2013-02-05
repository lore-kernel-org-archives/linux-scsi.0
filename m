From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v8 02/10] Remove get_device() / put_device() pair from scsi_request_fn()
Date: Tue, 05 Feb 2013 13:46:35 +0100
Message-ID: <5110FF2B.2090609@acm.org>
References: <5110FE98.8030209@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:41694 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab3BEMqg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2013 07:46:36 -0500
In-Reply-To: <5110FE98.8030209@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>

Now that all scsi_request_fn() callers hold a reference on the
SCSI device that function is invoked for and since
blk_cleanup_queue() waits until scsi_request_fn() has finished
it is safe to remove the get_device() / put_device() pair from
scsi_request_fn().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_lib.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5c67339..db4836bc 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1529,16 +1529,14 @@ static void scsi_softirq_done(struct request *rq)
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
@@ -1627,7 +1625,7 @@ static void scsi_request_fn(struct request_queue *q)
 			goto out_delay;
 	}
 
-	goto out;
+	return;
 
  not_ready:
 	spin_unlock_irq(shost->host_lock);
@@ -1646,12 +1644,6 @@ static void scsi_request_fn(struct request_queue *q)
 out_delay:
 	if (sdev->device_busy == 0)
 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
-out:
-	/* must be careful here...if we trigger the ->remove() function
-	 * we cannot be holding the q lock */
-	spin_unlock_irq(q->queue_lock);
-	put_device(&sdev->sdev_gendev);
-	spin_lock_irq(q->queue_lock);
 }
 
 u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
-- 
1.7.10.4


