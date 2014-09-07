From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/8] scsi: move scsi_dispatch_cmd to scsi_lib.c
Date: Sun,  7 Sep 2014 09:31:06 -0700
Message-ID: <1410107469-896-6-git-send-email-hch@lst.de>
References: <1410107469-896-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35030 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbaIGQ3G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2014 12:29:06 -0400
Received: from [50.247.105.171] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XQfKq-0006T0-Kk
	for linux-scsi@vger.kernel.org; Sun, 07 Sep 2014 16:29:05 +0000
In-Reply-To: <1410107469-896-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

scsi_lib.c is where the rest of the I/O submission path lives, so move
scsi_dispatch_cmd there and mark it static.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c      | 81 ------------------------------------------------
 drivers/scsi/scsi_lib.c  | 81 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_priv.h |  1 -
 3 files changed, 81 insertions(+), 82 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 534bf26..a86ccb7 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -626,87 +626,6 @@ void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 EXPORT_SYMBOL(scsi_cmd_get_serial);
 
 /**
- * scsi_dispatch_command - Dispatch a command to the low-level driver.
- * @cmd: command block we are dispatching.
- *
- * Return: nonzero return request was rejected and device's queue needs to be
- * plugged.
- */
-int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
-{
-	struct Scsi_Host *host = cmd->device->host;
-	int rtn = 0;
-
-	atomic_inc(&cmd->device->iorequest_cnt);
-
-	/* check if the device is still usable */
-	if (unlikely(cmd->device->sdev_state == SDEV_DEL)) {
-		/* in SDEV_DEL we error all commands. DID_NO_CONNECT
-		 * returns an immediate error upwards, and signals
-		 * that the device is no longer present */
-		cmd->result = DID_NO_CONNECT << 16;
-		goto done;
-	}
-
-	/* Check to see if the scsi lld made this device blocked. */
-	if (unlikely(scsi_device_blocked(cmd->device))) {
-		/*
-		 * in blocked state, the command is just put back on
-		 * the device queue.  The suspend state has already
-		 * blocked the queue so future requests should not
-		 * occur until the device transitions out of the
-		 * suspend state.
-		 */
-		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
-			"queuecommand : device blocked\n"));
-		return SCSI_MLQUEUE_DEVICE_BUSY;
-	}
-
-	/* Store the LUN value in cmnd, if needed. */
-	if (cmd->device->lun_in_cdb)
-		cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
-			       (cmd->device->lun << 5 & 0xe0);
-
-	scsi_log_send(cmd);
-
-	/*
-	 * Before we queue this command, check if the command
-	 * length exceeds what the host adapter can handle.
-	 */
-	if (cmd->cmd_len > cmd->device->host->max_cmd_len) {
-		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
-			       "queuecommand : command too long. "
-			       "cdb_size=%d host->max_cmd_len=%d\n",
-			       cmd->cmd_len, cmd->device->host->max_cmd_len));
-		cmd->result = (DID_ABORT << 16);
-		goto done;
-	}
-
-	if (unlikely(host->shost_state == SHOST_DEL)) {
-		cmd->result = (DID_NO_CONNECT << 16);
-		goto done;
-
-	}
-
-	trace_scsi_dispatch_cmd_start(cmd);
-	rtn = host->hostt->queuecommand(host, cmd);
-	if (rtn) {
-		trace_scsi_dispatch_cmd_error(cmd, rtn);
-		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
-		    rtn != SCSI_MLQUEUE_TARGET_BUSY)
-			rtn = SCSI_MLQUEUE_HOST_BUSY;
-
-		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
-			"queuecommand : request rejected\n"));
-	}
-
-	return rtn;
- done:
-	cmd->scsi_done(cmd);
-	return 0;
-}
-
-/**
  * scsi_finish_command - cleanup and pass command back to upper layer
  * @cmd: the command
  *
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 877ea3d..c398343 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1581,6 +1581,87 @@ static void scsi_softirq_done(struct request *rq)
 }
 
 /**
+ * scsi_dispatch_command - Dispatch a command to the low-level driver.
+ * @cmd: command block we are dispatching.
+ *
+ * Return: nonzero return request was rejected and device's queue needs to be
+ * plugged.
+ */
+static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
+{
+	struct Scsi_Host *host = cmd->device->host;
+	int rtn = 0;
+
+	atomic_inc(&cmd->device->iorequest_cnt);
+
+	/* check if the device is still usable */
+	if (unlikely(cmd->device->sdev_state == SDEV_DEL)) {
+		/* in SDEV_DEL we error all commands. DID_NO_CONNECT
+		 * returns an immediate error upwards, and signals
+		 * that the device is no longer present */
+		cmd->result = DID_NO_CONNECT << 16;
+		goto done;
+	}
+
+	/* Check to see if the scsi lld made this device blocked. */
+	if (unlikely(scsi_device_blocked(cmd->device))) {
+		/*
+		 * in blocked state, the command is just put back on
+		 * the device queue.  The suspend state has already
+		 * blocked the queue so future requests should not
+		 * occur until the device transitions out of the
+		 * suspend state.
+		 */
+		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
+			"queuecommand : device blocked\n"));
+		return SCSI_MLQUEUE_DEVICE_BUSY;
+	}
+
+	/* Store the LUN value in cmnd, if needed. */
+	if (cmd->device->lun_in_cdb)
+		cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
+			       (cmd->device->lun << 5 & 0xe0);
+
+	scsi_log_send(cmd);
+
+	/*
+	 * Before we queue this command, check if the command
+	 * length exceeds what the host adapter can handle.
+	 */
+	if (cmd->cmd_len > cmd->device->host->max_cmd_len) {
+		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
+			       "queuecommand : command too long. "
+			       "cdb_size=%d host->max_cmd_len=%d\n",
+			       cmd->cmd_len, cmd->device->host->max_cmd_len));
+		cmd->result = (DID_ABORT << 16);
+		goto done;
+	}
+
+	if (unlikely(host->shost_state == SHOST_DEL)) {
+		cmd->result = (DID_NO_CONNECT << 16);
+		goto done;
+
+	}
+
+	trace_scsi_dispatch_cmd_start(cmd);
+	rtn = host->hostt->queuecommand(host, cmd);
+	if (rtn) {
+		trace_scsi_dispatch_cmd_error(cmd, rtn);
+		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
+		    rtn != SCSI_MLQUEUE_TARGET_BUSY)
+			rtn = SCSI_MLQUEUE_HOST_BUSY;
+
+		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
+			"queuecommand : request rejected\n"));
+	}
+
+	return rtn;
+ done:
+	cmd->scsi_done(cmd);
+	return 0;
+}
+
+/**
  * scsi_done - Invoke completion on finished SCSI command.
  * @cmd: The SCSI Command for which a low-level device driver (LLDD) gives
  * ownership back to SCSI Core -- i.e. the LLDD has finished with it.
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 2a382c1..2dc4a83 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -29,7 +29,6 @@ extern int scsi_init_hosts(void);
 extern void scsi_exit_hosts(void);
 
 /* scsi.c */
-extern int scsi_dispatch_cmd(struct scsi_cmnd *cmd);
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
 extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
 #ifdef CONFIG_SCSI_LOGGING
-- 
1.9.1

