From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Do not requeue requests if FAILFAST is set
Date: Tue, 06 Nov 2007 09:23:40 +0100
Message-ID: <4730248C.2030901@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010005030001040609000002"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbXKFIXm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Nov 2007 03:23:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>

This is a multi-part message in MIME format.
--------------010005030001040609000002
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi James,

the FAILFAST flag is currently not honored in scsi_request_fn().
So if scsi_dispatch_cmd() returns an error or the queue is not
ready, the request will always be requeued regardless of the
FAILFAST setting.
This can result in a delayed fallback for multipathing, as
these requests will only be catched once the timeout expires.

This patch avoids requeuing if the FAILFAST flag is set, and
terminates the request immediately.

Comments et al welcome.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------010005030001040609000002
Content-Type: text/plain;
 name="scsi-kill-failfast-requests"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-kill-failfast-requests"

Do not requeue requests if REQ_FAILFAST is set

Any requests with the REQ_FAILFAST flag set should not be requeued
to the requeust queue, but rather terminated directly.
Otherwise the multipath failover will stall until the command
timeout triggers.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 277f1b6..a12d2f1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1200,6 +1200,11 @@ static int scsi_prep_fn(struct request_queue *q, struct request *req)
 			 */
 			if (!(req->cmd_flags & REQ_PREEMPT))
 				ret = BLKPREP_DEFER;
+			/*
+			 * Return failfast requests immediately
+			 */
+			if (req->cmd_flags & REQ_FAILFAST)
+				ret = BLKPREP_KILL;
 			break;
 		default:
 			/*
@@ -1327,6 +1332,17 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 	return 1;
 }
 
+static void __scsi_kill_request(struct request *req)
+{
+	struct scsi_cmnd *cmd = req->special;
+	struct scsi_device *sdev = cmd->device;
+
+	cmd->result = DID_NO_CONNECT << 16;
+	atomic_inc(&cmd->device->iorequest_cnt);
+	sdev->device_busy--;
+	__scsi_done(cmd);
+}
+
 /*
  * Kill a request for a dead device
  */
@@ -1440,8 +1456,16 @@ static void scsi_request_fn(struct request_queue *q)
 		 * accept it.
 		 */
 		req = elv_next_request(q);
-		if (!req || !scsi_dev_queue_ready(q, sdev))
+		if (!req)
+			break;
+
+		if (!scsi_dev_queue_ready(q, sdev)) {
+			if (req->cmd_flags & REQ_FAILFAST) {
+				scsi_kill_request(req, q);
+				continue;
+			}
 			break;
+		}
 
 		if (unlikely(!scsi_device_online(sdev))) {
 			sdev_printk(KERN_ERR, sdev,
@@ -1522,8 +1546,12 @@ static void scsi_request_fn(struct request_queue *q)
 	 * later time.
 	 */
 	spin_lock_irq(q->queue_lock);
-	blk_requeue_request(q, req);
-	sdev->device_busy--;
+	if (unlikely(req->cmd_flags & REQ_FAILFAST))
+		__scsi_kill_request(req);
+	else {
+		blk_requeue_request(q, req);
+		sdev->device_busy--;
+	}
 	if(sdev->device_busy == 0)
 		blk_plug_device(q);
  out:

--------------010005030001040609000002--
