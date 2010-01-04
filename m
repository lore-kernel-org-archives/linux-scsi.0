From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/3] scsi_lib: request_queue is only needed inside scsi_requeue_command
Date: Mon, 04 Jan 2010 14:13:37 +0200
Message-ID: <4B41DB71.8080307@panasas.com>
References: <4B41DADD.4000102@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:12209 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751096Ab0ADMNj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 07:13:39 -0500
In-Reply-To: <4B41DADD.4000102@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.k>


This is a pure cleanup. Just starting the engines for things
to come.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c664242..05f988a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -475,9 +475,10 @@ static void scsi_run_queue(struct request_queue *q)
  *		sector.
  * Notes:	Upon return, cmd is a stale pointer.
  */
-static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
+static void scsi_requeue_command(struct scsi_cmnd *cmd)
 {
 	struct request *req = cmd->request;
+	struct request_queue *q = req->q;
 	unsigned long flags;
 
 	spin_lock_irqsave(q->queue_lock, flags);
@@ -538,7 +539,6 @@ static void __scsi_release_buffers(struct scsi_cmnd *, int);
 static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 					  int bytes, int requeue)
 {
-	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 
 	/*
@@ -557,7 +557,7 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 				 * queue, and goose the queue again.
 				 */
 				scsi_release_buffers(cmd);
-				scsi_requeue_command(q, cmd);
+				scsi_requeue_command(cmd);
 				cmd = NULL;
 			}
 			return cmd;
@@ -706,7 +706,6 @@ EXPORT_SYMBOL(scsi_release_buffers);
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int error = 0;
 	struct scsi_sense_hdr sshdr;
@@ -900,7 +899,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			scsi_print_command(cmd);
 		}
 		if (blk_end_request_err(req, error))
-			scsi_requeue_command(q, cmd);
+			scsi_requeue_command(cmd);
 		else
 			scsi_next_command(cmd);
 		break;
@@ -909,7 +908,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		 * A new command will be prepared and issued.
 		 */
 		scsi_release_buffers(cmd);
-		scsi_requeue_command(q, cmd);
+		scsi_requeue_command(cmd);
 		break;
 	case ACTION_RETRY:
 		/* Retry the same command immediately */
-- 
1.6.6


