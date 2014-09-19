From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 3/8] scsi-mq: Pass hctx to low-level SCSI drivers
Date: Fri, 19 Sep 2014 14:57:35 +0200
Message-ID: <541C283F.8000800@acm.org>
References: <541C27BF.6070609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:36794 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaISM5h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Sep 2014 08:57:37 -0400
In-Reply-To: <541C27BF.6070609@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>

Low-level drivers (LLDs) need to know which hardware context has been
selected by the block layer. Hence pass this information to SCSI LLDs.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c      |  7 +++++--
 drivers/scsi/scsi_lib.c  |  4 ++--
 drivers/scsi/scsi_priv.h |  2 +-
 include/scsi/scsi_host.h | 14 ++++++++++++++
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d81f3cc..9bd4bd0 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -640,9 +640,10 @@ EXPORT_SYMBOL(scsi_cmd_get_serial);
  * Return: nonzero return request was rejected and device's queue needs to be
  * plugged.
  */
-int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
+int scsi_dispatch_cmd(struct blk_mq_hw_ctx *hctx, struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
+	struct scsi_host_template *hostt = host->hostt;
 	int rtn = 0;
 
 	atomic_inc(&cmd->device->iorequest_cnt);
@@ -701,7 +702,9 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	}
 
 	trace_scsi_dispatch_cmd_start(cmd);
-	rtn = host->hostt->queuecommand(host, cmd);
+	rtn = hctx && hostt->mq_queuecommand ?
+		hostt->mq_queuecommand(hctx, cmd) :
+		hostt->queuecommand(host, cmd);
 	if (rtn) {
 		trace_scsi_dispatch_cmd_error(cmd, rtn);
 		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b0b6117..6303648 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1747,7 +1747,7 @@ static void scsi_request_fn(struct request_queue *q)
 		 * Dispatch the command to the low-level driver.
 		 */
 		cmd->scsi_done = scsi_done;
-		rtn = scsi_dispatch_cmd(cmd);
+		rtn = scsi_dispatch_cmd(NULL, cmd);
 		if (rtn) {
 			scsi_queue_insert(cmd, rtn);
 			spin_lock_irq(q->queue_lock);
@@ -1889,7 +1889,7 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 	scsi_init_cmd_errh(cmd);
 	cmd->scsi_done = scsi_mq_done;
 
-	reason = scsi_dispatch_cmd(cmd);
+	reason = scsi_dispatch_cmd(hctx, cmd);
 	if (reason) {
 		scsi_set_blocked(cmd, reason);
 		ret = BLK_MQ_RQ_QUEUE_BUSY;
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 12b8e1b..f4115f6 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -29,7 +29,7 @@ extern int scsi_init_hosts(void);
 extern void scsi_exit_hosts(void);
 
 /* scsi.c */
-extern int scsi_dispatch_cmd(struct scsi_cmnd *cmd);
+extern int scsi_dispatch_cmd(struct blk_mq_hw_ctx *hctx, struct scsi_cmnd *cmd);
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
 extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
 #ifdef CONFIG_SCSI_LOGGING
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 0a867d9..c695f1c 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -133,6 +133,20 @@ struct scsi_host_template {
 	int (* queuecommand)(struct Scsi_Host *, struct scsi_cmnd *);
 
 	/*
+	 * scsi-mq version of queuecommand(). Must be provided by LLDDs that
+	 * provide multiple hardware queues and that need to know on which
+	 * hardware context a command has been queued by the block layer.
+	 *
+	 * Note: even if an LLDD provides an mq_queuecommand callback function
+	 * it still has to provide a queuecommand callback function. The SCSI
+	 * error handler namely can invoke the queuecommand callback function
+	 * even if scsi-mq is enabled.
+	 *
+	 * STATUS: OPTIONAL
+	 */
+	int (* mq_queuecommand)(struct blk_mq_hw_ctx *hctx, struct scsi_cmnd *);
+
+	/*
 	 * This is an error handling strategy routine.  You don't need to
 	 * define one of these if you don't want to - there is a default
 	 * routine that is present that should work in most cases.  For those
-- 
1.8.4.5

