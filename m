From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Undo __scsi_kill_request()
Date: Thu, 06 Dec 2007 09:28:23 +0100
Message-ID: <4757B2A7.6050603@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060604090705020004090409"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:47030 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbXLFI2Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Dec 2007 03:28:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------060604090705020004090409
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi all,

the main goal of using FAILFAST is to have requests terminated
early if the link to the target is lost. This is indicated by
the device state SDEV_BLOCK.
So we only have to check for the FAILFAST flag when we check
the queue state in scsi_prep_fn().

This patch reverts parts of the original patch
'Do not requeue requests if REQ_FAILFAST is set'
as the return values of ->queuecommand() should not be affected
by the FAILFAST setting.

James, please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------060604090705020004090409
Content-Type: text/plain;
 name="scsi-undo-__kill-request"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-undo-__kill-request"

Remove __scsi_kill_request()

We only have to evaluate the FAILFAST flag if the device is in
status SDEV_BLOCK, as this indicates a link failure.
The return status of ->queuecommand() should not be affected by
this, so remove the check there.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1148c40..6f4862b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1424,17 +1424,6 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 	return 1;
 }
 
-static void __scsi_kill_request(struct request *req)
-{
-	struct scsi_cmnd *cmd = req->special;
-	struct scsi_device *sdev = cmd->device;
-
-	cmd->result = DID_NO_CONNECT << 16;
-	atomic_inc(&cmd->device->iorequest_cnt);
-	sdev->device_busy--;
-	__scsi_done(cmd);
-}
-
 /*
  * Kill a request for a dead device
  */
@@ -1639,12 +1628,9 @@ static void scsi_request_fn(struct request_queue *q)
 	 * later time.
 	 */
 	spin_lock_irq(q->queue_lock);
-	if (unlikely(req->cmd_flags & REQ_FAILFAST))
-		__scsi_kill_request(req);
-	else {
-		blk_requeue_request(q, req);
-		sdev->device_busy--;
-	}
+	blk_requeue_request(q, req);
+	sdev->device_busy--;
+
 	if(sdev->device_busy == 0)
 		blk_plug_device(q);
  out:

--------------060604090705020004090409--
