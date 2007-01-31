From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 1/2] Prevent infinite retries due to DID_RESET return status
Date: Wed, 31 Jan 2007 12:54:19 -0600
Message-ID: <45C0E5DB.6030407@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020903080408050204030102"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:45838 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933318AbXAaSy0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Jan 2007 13:54:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jeremy Higdon <jeremy@sgi.com>

This is a multi-part message in MIME format.
--------------020903080408050204030102
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Move scsi_release_buffers() call so that buffers are retained until
after a determination is made about whether the command will be
requeued via scsi_queue_insert().  Doing so allows a command which
receives DID_RESET to be immediately queued to the driver using
the original scsi_cmnd, thus retaining it's original jiffies_at_alloc.

Signed-off-by: Michael Reed <mdr@sgi.com>

--------------020903080408050204030102
Content-Type: text/x-patch;
 name="DID_RESET_new_1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="DID_RESET_new_1.patch"

Move scsi_release_buffers() call so that buffers are retained until
after a determination is made about whether the command will be
requeued via scsi_queue_insert().  Doing so allows a command which
receives DID_RESET to be immediately queued to the driver using
the original scsi_cmnd, thus retaining it's original jiffies_at_alloc.

Signed-off-by: Michael Reed <mdr@sgi.com>

--- rg61u/drivers/scsi/scsi_lib.c	2007-01-02 23:11:18.000000000 -0600
+++ rg61/drivers/scsi/scsi_lib.c	2007-01-29 15:03:36.602482680 -0600
@@ -65,6 +65,7 @@ static struct scsi_host_sg_pool scsi_sg_
 #undef SP
 
 static void scsi_run_queue(struct request_queue *q);
+static void scsi_release_buffers(struct scsi_cmnd *cmd);
 
 /*
  * Function:	scsi_unprep_request()
@@ -599,6 +600,7 @@ static void scsi_requeue_command(struct 
 	struct request *req = cmd->request;
 	unsigned long flags;
 
+	scsi_release_buffers(cmd);
 	scsi_unprep_request(req);
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, req);
@@ -644,6 +646,7 @@ void scsi_run_host_queues(struct Scsi_Ho
  * Lock status: Assumed that lock is not held upon entry.
  *
  * Returns:     cmd if requeue required, NULL otherwise.
+ * 		If cmd is returned then its buffers have not been released.
  *
  * Notes:       This is called for block device requests in order to
  *              mark some number of sectors as complete.
@@ -686,6 +689,7 @@ static struct scsi_cmnd *scsi_end_reques
 		}
 	}
 
+	scsi_release_buffers(cmd);
 	add_disk_randomness(req->rq_disk);
 
 	spin_lock_irqsave(q->queue_lock, flags);
@@ -826,8 +830,6 @@ void scsi_io_completion(struct scsi_cmnd
 	int sense_valid = 0;
 	int sense_deferred = 0;
 
-	scsi_release_buffers(cmd);
-
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
 		if (sense_valid)

--------------020903080408050204030102--
