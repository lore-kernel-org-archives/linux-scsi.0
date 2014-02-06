From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/6] scsi: remove a useless get/put_device pair in scsi_requeue_command
Date: Thu, 06 Feb 2014 10:43:12 -0800
Message-ID: <20140206184418.178186483@bombadil.infradead.org>
References: <20140206184306.997538898@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58569 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615AbaBFSoS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 13:44:18 -0500
Content-Disposition: inline; filename=0006-scsi-remove-a-useless-get-put_device-pair-in-scsi_re.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

Avoid a spurious device get/put cycle by using scsi_put_command and folding
scsi_unprep_request into scsi_requeue_command.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |   35 +++--------------------------------
 1 file changed, 3 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 91ca414..9350691 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -75,29 +75,6 @@ struct kmem_cache *scsi_sdb_cache;
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
-	scsi_put_command(cmd);
-	put_device(&cmd->device->sdev_gendev);
-}
-
 /**
  * __scsi_queue_insert - private queue insertion
  * @cmd: The SCSI command being requeued
@@ -503,16 +480,10 @@ static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
 	struct request *req = cmd->request;
 	unsigned long flags;
 
-	/*
-	 * We need to hold a reference on the device to avoid the queue being
-	 * killed after the unlock and before scsi_run_queue is invoked which
-	 * may happen because scsi_unprep_request() puts the command which
-	 * releases its reference on the device.
-	 */
-	get_device(&sdev->sdev_gendev);
-
 	spin_lock_irqsave(q->queue_lock, flags);
-	scsi_unprep_request(req);
+	blk_unprep_request(req);
+	req->special = NULL;
+	scsi_put_command(cmd);
 	blk_requeue_request(q, req);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-- 
1.7.10.4


