From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 3/5] scsi: Avoid dangling pointer in scsi_requeue_command()
Date: Fri, 29 Jun 2012 15:34:26 +0000
Message-ID: <4FEDCB02.6070600@acm.org>
References: <4FEDCA26.90804@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:45876 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab2F2Pe3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jun 2012 11:34:29 -0400
In-Reply-To: <4FEDCA26.90804@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Mike Christie <michaelc@cs.wisc.edu>, Muthukumar Ratty <muthur@gmail.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tejun Heo <tj@kernel.org>

Reported-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <JBottomley@parallels.com>
Cc: <stable@kernel.org>
---
 drivers/scsi/scsi_lib.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7ebe167..af6357a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -479,15 +479,24 @@ void scsi_requeue_run_queue(struct work_struct *work)
  */
 static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
 {
+	struct scsi_device *sdev = cmd->device;
 	struct request *req = cmd->request;
 	unsigned long flags;
 
+	/*
+	 * We need to hold a reference on the device to avoid that the queue
+	 * gets killed after the unlock and before scsi_run_queue is invoked.
+	 */
+	get_device(&sdev->sdev_gendev);
+
 	spin_lock_irqsave(q->queue_lock, flags);
 	scsi_unprep_request(req);
 	blk_requeue_request(q, req);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	scsi_run_queue(q);
+
+	put_device(&sdev->sdev_gendev);
 }
 
 void scsi_next_command(struct scsi_cmnd *cmd)
-- 
1.7.7

