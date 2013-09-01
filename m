From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 8/7] scsi: cleanup scsi_requeue_command
Date: Sun, 1 Sep 2013 10:08:58 -0700
Message-ID: <20130901170858.GA25338@infradead.org>
References: <52135B99.2000102@acm.org>
 <52135CC1.3000901@acm.org>
 <20130901170613.GF4344@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59181 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab3IARJD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Sep 2013 13:09:03 -0400
Content-Disposition: inline
In-Reply-To: <20130901170613.GF4344@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

Avoid a spurious device get/put cycle by using scsi_put_command and folding
scsi_unprep_request into scsi_requeue_command.

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0fc7970..2c30df0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -97,28 +97,6 @@ EXPORT_SYMBOL_GPL(scsi_unregister_acpi_bus_type);
  */
 #define SCSI_QUEUE_DELAY	3
 
-/*
- * Function:	scsi_unprep_request()
- *
- * Purpose:	Remove all preparation done for a request, including its
- *		associated scsi_cmnd, so that it can be requeued.
- *
- * Arguments:	req	- request to unprepare
- *
- * Lock status:	Assumed that no locks are held upon entry.
- *
- * Returns:	Nothing.
- */
-static void scsi_unprep_request(struct request *req)
-{
-	struct scsi_cmnd *cmd = req->special;
-
-	blk_unprep_request(req);
-	req->special = NULL;
-
-	scsi_put_command_and_dev(cmd);
-}
-
 /**
  * __scsi_queue_insert - private queue insertion
  * @cmd: The SCSI command being requeued
@@ -519,16 +497,11 @@ static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
 	struct request *req = cmd->request;
 	unsigned long flags;
 
-	/*
-	 * We need to hold a reference on the device to avoid the queue being
-	 * killed after the unlock and before scsi_run_queue is invoked which
-	 * may happen because scsi_unprep_request() puts the command which
-	 * releases its reference on the device.
-	 */
-	get_device(&sdev->sdev_gendev);
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	scsi_unprep_request(req);
+	blk_unprep_request(req);
+	req->special = NULL;
+	scsi_put_command(cmd);
 	blk_requeue_request(q, req);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
