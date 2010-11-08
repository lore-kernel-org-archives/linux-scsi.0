From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/3] scsi_lib: request_queue is only needed inside scsi_requeue_command
Date: Mon, 08 Nov 2010 17:10:11 +0200
Message-ID: <4CD812D3.7090906@panasas.com>
References: <4CD810FA.902@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:48529 "HELO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754837Ab0KHPKO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 10:10:14 -0500
In-Reply-To: <4CD810FA.902@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>


This is a pure cleanup. Just starting the engines for things
to come.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index eafeeda..c886754 100644
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
@@ -907,7 +906,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			scsi_print_command(cmd);
 		}
 		if (blk_end_request_err(req, error))
-			scsi_requeue_command(q, cmd);
+			scsi_requeue_command(cmd);
 		else
 			scsi_next_command(cmd);
 		break;
@@ -916,7 +915,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		 * A new command will be prepared and issued.
 		 */
 		scsi_release_buffers(cmd);
-		scsi_requeue_command(q, cmd);
+		scsi_requeue_command(cmd);
 		break;
 	case ACTION_RETRY:
 		/* Retry the same command immediately */
-- 
1.7.2.3


