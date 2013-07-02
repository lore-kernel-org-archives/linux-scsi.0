From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/4] Fix race between starved list and device removal
Date: Tue, 02 Jul 2013 15:05:26 +0200
Message-ID: <51D2D016.5030505@acm.org>
References: <51D2CFE2.90302@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:39890 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3GBNF1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jul 2013 09:05:27 -0400
In-Reply-To: <51D2CFE2.90302@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Tejun Heo <tj@kernel.org>

From: James Bottomley <JBottomley@Parallels.com>

scsi_run_queue() examines all SCSI devices that are present on
the starved list. Since scsi_run_queue() unlocks the SCSI host
lock a SCSI device can get removed after it has been removed
from the starved list and before its queue is run. Protect
against that race condition by holding a reference on the
queue while running it.

Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reported-by: Chanho Min <chanho.min@lge.com>
Reference: http://lkml.org/lkml/2012/8/2/96
Cc: Tejun Heo <tj@kernel.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/scsi_lib.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 86d5220..df8bd5a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -434,6 +434,8 @@ static void scsi_run_queue(struct request_queue *q)
 	list_splice_init(&shost->starved_list, &starved_list);
 
 	while (!list_empty(&starved_list)) {
+		struct request_queue *slq;
+
 		/*
 		 * As long as shost is accepting commands and we have
 		 * starved queues, call blk_run_queue. scsi_request_fn
@@ -456,11 +458,25 @@ static void scsi_run_queue(struct request_queue *q)
 			continue;
 		}
 
-		spin_unlock(shost->host_lock);
-		spin_lock(sdev->request_queue->queue_lock);
-		__blk_run_queue(sdev->request_queue);
-		spin_unlock(sdev->request_queue->queue_lock);
-		spin_lock(shost->host_lock);
+		/*
+		 * Once we drop the host lock, a racing scsi_remove_device()
+		 * call may remove the sdev from the starved list and destroy
+		 * it and the queue.  Mitigate by taking a reference to the
+		 * queue and never touching the sdev again after we drop the
+		 * host lock.  Note: if __scsi_remove_device() invokes
+		 * blk_cleanup_queue() before the queue is run from this
+		 * function then blk_run_queue() will return immediately since
+		 * blk_cleanup_queue() marks the queue with QUEUE_FLAG_DYING.
+		 */
+		slq = sdev->request_queue;
+		if (!blk_get_queue(slq))
+			continue;
+		spin_unlock_irqrestore(shost->host_lock, flags);
+
+		blk_run_queue(slq);
+		blk_put_queue(slq);
+
+		spin_lock_irqsave(shost->host_lock, flags);
 	}
 	/* put any unprocessed entries back */
 	list_splice(&starved_list, &shost->starved_list);
-- 
1.7.10.4

