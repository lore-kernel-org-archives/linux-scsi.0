From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/9] scsi: remove a useless get/put_device pair in scsi_request_fn
Date: Thu, 20 Feb 2014 14:20:56 -0800
Message-ID: <20140220222357.243631632@bombadil.infradead.org>
References: <20140220222052.717958451@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58144 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbaBTWX7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 17:23:59 -0500
Content-Disposition: inline; filename=0004-scsi-remove-a-useless-get-put_device-pair-in-scsi_re.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>

From: Bart Van Assche <bvanassche@acm.org>

SCSI devices may only be removed by calling scsi_remove_device().
That function must invoke blk_cleanup_queue() before the final put
of sdev->sdev_gendev. Since blk_cleanup_queue() waits for the
block queue to drain and then tears it down, scsi_request_fn cannot
be active anymore after blk_cleanup_queue() has returned and hence
the get_device()/put_device() pair in scsi_request_fn is unnecessary.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_lib.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 500178c..7d35678 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1558,16 +1558,14 @@ static void scsi_softirq_done(struct request *rq)
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
@@ -1656,7 +1654,7 @@ static void scsi_request_fn(struct request_queue *q)
 			goto out_delay;
 	}
 
-	goto out;
+	return;
 
  not_ready:
 	spin_unlock_irq(shost->host_lock);
@@ -1675,12 +1673,6 @@ static void scsi_request_fn(struct request_queue *q)
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


