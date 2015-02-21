From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 28/43] hpsa: don't return abort request until target is
 complete
Date: Sat, 21 Feb 2015 16:20:01 -0600
Message-ID: <20150221222001.21954.79148.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:55798 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbbBUWVU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:21:20 -0500
Received: from g6t1524.atlanta.hp.com (g6t1524.atlanta.hp.com [15.193.200.67])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 1CD3B85D
	for <linux-scsi@vger.kernel.org>; Sat, 21 Feb 2015 22:21:20 +0000 (UTC)
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Webb Scales <webbnh@hp.com>

Don't return from the abort request until the target command is complete.
Mark outstanding commands which have a pending abort, and do not send them
to the host if we can avoid it.

If the current command has been aborted, do not call the SCSI command
completion routine from the I/O path: when the abort returns successfully,
the SCSI mid-layer will handle the completion implicitly.

The following race was possible in theory.

1. LLD is requested to abort a scsi command
2. scsi command completes
3. The struct CommandList associated with 2 is made available.
4. new io request to LLD to another LUN re-uses struct CommandList
5. abort handler follows scsi_cmnd->host_scribble and
   finds struct CommandList and tries to aborts it.

Now we have aborted the wrong command.

Fix by resetting the scsi_cmd field of struct CommandList
upon completion and making the abort handler check that
the scsi_cmd pointer in the CommadList struct matches the
scsi_cmnd that it has been asked to abort.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Webb Scales <webbnh@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c     |  120 +++++++++++++++++++++++++++++++++++------------
 drivers/scsi/hpsa.h     |    1 
 drivers/scsi/hpsa_cmd.h |    2 +
 3 files changed, 93 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 29a86b3..6676517 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -194,6 +194,10 @@ static struct board_type products[] = {
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
 
+#define SCSI_CMD_BUSY ((struct scsi_cmnd *)&hpsa_cmd_busy)
+static const struct scsi_cmnd hpsa_cmd_busy;
+#define SCSI_CMD_IDLE ((struct scsi_cmnd *)&hpsa_cmd_idle)
+static const struct scsi_cmnd hpsa_cmd_idle;
 static int number_of_controllers;
 
 static irqreturn_t do_hpsa_intr_intx(int irq, void *dev_id);
@@ -269,6 +273,11 @@ static inline struct ctlr_info *shost_to_hba(struct Scsi_Host *sh)
 	return (struct ctlr_info *) *priv;
 }
 
+static inline bool hpsa_is_cmd_idle(struct CommandList *c)
+{
+	return c->scsi_cmd == SCSI_CMD_IDLE;
+}
+
 /* extract sense key, asc, and ascq from sense data.  -1 means invalid. */
 static void decode_sense_data(const u8 *sense_data, int sense_data_len,
 			int *sense_key, int *asc, int *ascq)
@@ -966,9 +975,11 @@ static void __enqueue_cmd_and_start_io(struct ctlr_info *h,
 	}
 }
 
-static void enqueue_cmd_and_start_io(struct ctlr_info *h,
-					struct CommandList *c)
+static void enqueue_cmd_and_start_io(struct ctlr_info *h, struct CommandList *c)
 {
+	if (unlikely(c->abort_pending))
+		return finish_cmd(c);
+
 	__enqueue_cmd_and_start_io(h, c, DEFAULT_REPLY_QUEUE);
 }
 
@@ -2026,9 +2037,36 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 	return retry;	/* retry on raid path? */
 }
 
+static void hpsa_cmd_resolve_events(struct ctlr_info *h,
+		struct CommandList *c)
+{
+	/*
+	 * Prevent the following race in the abort handler:
+	 *
+	 * 1. LLD is requested to abort a SCSI command
+	 * 2. The SCSI command completes
+	 * 3. The struct CommandList associated with step 2 is made available
+	 * 4. New I/O request to LLD to another LUN re-uses struct CommandList
+	 * 5. Abort handler follows scsi_cmnd->host_scribble and
+	 *    finds struct CommandList and tries to aborts it
+	 * Now we have aborted the wrong command.
+	 *
+	 * Clear c->scsi_cmd here so that the abort handler will know this
+	 * command has completed.  Then, check to see if the abort handler is
+	 * waiting for this command, and, if so, wake it.
+	 */
+	c->scsi_cmd = SCSI_CMD_IDLE;
+	mb(); /* Ensure c->scsi_cmd is set to SCSI_CMD_IDLE */
+	if (c->abort_pending) {
+		c->abort_pending = false;
+		wake_up_all(&h->abort_sync_wait_queue);
+	}
+}
+
 static void hpsa_cmd_free_and_done(struct ctlr_info *h,
 		struct CommandList *c, struct scsi_cmnd *cmd)
 {
+	hpsa_cmd_resolve_events(h, c);
 	cmd_free(h, c);
 	cmd->scsi_done(cmd);
 }
@@ -2039,6 +2077,21 @@ static void hpsa_retry_cmd(struct ctlr_info *h, struct CommandList *c)
 	queue_work_on(raw_smp_processor_id(), h->resubmit_wq, &c->work);
 }
 
+static void hpsa_set_scsi_cmd_aborted(struct scsi_cmnd *cmd)
+{
+	cmd->result = DID_ABORT << 16;
+}
+
+static void hpsa_cmd_abort_and_free(struct ctlr_info *h, struct CommandList *c,
+				    struct scsi_cmnd *cmd)
+{
+	hpsa_set_scsi_cmd_aborted(cmd);
+	dev_warn(&h->pdev->dev, "CDB %16phN was aborted with status 0x%x\n",
+			 c->Request.CDB, c->err_info->ScsiStatus);
+	hpsa_cmd_resolve_events(h, c);
+	cmd_free(h, c);		/* FIX-ME:  change to cmd_tagged_free(h, c) */
+}
+
 static void process_ioaccel2_completion(struct ctlr_info *h,
 		struct CommandList *c, struct scsi_cmnd *cmd,
 		struct hpsa_scsi_dev_t *dev)
@@ -2050,6 +2103,10 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 			c2->error_data.status == 0))
 		return hpsa_cmd_free_and_done(h, c, cmd);
 
+	/* don't requeue a command which is being aborted */
+	if (unlikely(c->abort_pending))
+		return hpsa_cmd_abort_and_free(h, c, cmd);
+
 	/*
 	 * Any RAID offload error results in retry which will use
 	 * the normal I/O path so the controller can handle whatever's
@@ -2171,10 +2228,14 @@ static void complete_scsi_command(struct CommandList *cp)
 		if (is_logical_dev_addr_mode(dev->scsi3addr)) {
 			if (ei->CommandStatus == CMD_IOACCEL_DISABLED)
 				dev->offload_enabled = 0;
-			return hpsa_retry_cmd(h, cp);
+			if (!cp->abort_pending)
+				return hpsa_retry_cmd(h, cp);
 		}
 	}
 
+	if (cp->abort_pending)
+		ei->CommandStatus = CMD_ABORTED;
+
 	/* an error has occurred */
 	switch (ei->CommandStatus) {
 
@@ -2262,10 +2323,8 @@ static void complete_scsi_command(struct CommandList *cp)
 			cp->Request.CDB);
 		break;
 	case CMD_ABORTED:
-		cmd->result = DID_ABORT << 16;
-		dev_warn(&h->pdev->dev, "CDB %16phN was aborted with status 0x%x\n",
-				cp->Request.CDB, ei->ScsiStatus);
-		break;
+		/* Return now to avoid calling scsi_done(). */
+		return hpsa_cmd_abort_and_free(h, cp, cmd);
 	case CMD_ABORT_FAILED:
 		cmd->result = DID_ERROR << 16;
 		dev_warn(&h->pdev->dev, "CDB %16phN : abort failed\n",
@@ -4501,6 +4560,7 @@ static void hpsa_cmd_init(struct ctlr_info *h, int index,
 	c->ErrDesc.Addr = cpu_to_le64((u64) err_dma_handle);
 	c->ErrDesc.Len = cpu_to_le32((u32) sizeof(*c->err_info));
 	c->h = h;
+	c->scsi_cmd = SCSI_CMD_IDLE;
 }
 
 static void hpsa_preinitialize_commands(struct ctlr_info *h)
@@ -4564,6 +4624,8 @@ static void hpsa_command_resubmit_worker(struct work_struct *work)
 		cmd->result = DID_NO_CONNECT << 16;
 		return hpsa_cmd_free_and_done(c->h, c, cmd);
 	}
+	if (c->abort_pending)
+		return hpsa_cmd_abort_and_free(c->h, c, cmd);
 	if (c->cmd_type == CMD_IOACCEL2) {
 		struct ctlr_info *h = c->h;
 		struct io_accel2_cmd *c2 = &h->ioaccel2_cmd_pool[c->cmdindex];
@@ -4989,8 +5051,7 @@ static void setup_ioaccel2_abort_cmd(struct CommandList *c, struct ctlr_info *h,
 	struct hpsa_tmf_struct *ac = (struct hpsa_tmf_struct *) c2;
 	struct io_accel2_cmd *c2a =
 		&h->ioaccel2_cmd_pool[command_to_abort->cmdindex];
-	struct scsi_cmnd *scmd =
-		(struct scsi_cmnd *) command_to_abort->scsi_cmd;
+	struct scsi_cmnd *scmd = command_to_abort->scsi_cmd;
 	struct hpsa_scsi_dev_t *dev = scmd->device->hostdata;
 
 	/*
@@ -5005,6 +5066,8 @@ static void setup_ioaccel2_abort_cmd(struct CommandList *c, struct ctlr_info *h,
 				sizeof(ac->error_len));
 
 	c->cmd_type = IOACCEL2_TMF;
+	c->scsi_cmd = SCSI_CMD_BUSY;
+
 	/* Adjust the DMA address to point to the accelerated command buffer */
 	c->busaddr = (u32) h->ioaccel2_cmd_pool_dhandle +
 				(c->cmdindex * sizeof(struct io_accel2_cmd));
@@ -5197,7 +5260,7 @@ static inline int wait_for_available_abort_cmd(struct ctlr_info *h)
 static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 {
 
-	int i, rc;
+	int rc;
 	struct ctlr_info *h;
 	struct hpsa_scsi_dev_t *dev;
 	struct CommandList *abort; /* pointer to command to be aborted */
@@ -5270,6 +5333,16 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 		return FAILED;
 	}
 
+	/*
+	 * Check that we're aborting the right command.
+	 * It's possible the CommandList already completed and got re-used.
+	 */
+	if (abort->scsi_cmd != sc) {
+		cmd_free(h, abort);
+		return SUCCESS;
+	}
+
+	abort->abort_pending = true;
 	hpsa_get_tag(h, abort, &taglower, &tagupper);
 	reply_queue = hpsa_extract_reply_queue(h, abort);
 	ml += sprintf(msg+ml, "Tag:0x%08x:%08x ", tagupper, taglower);
@@ -5302,27 +5375,10 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 		return FAILED;
 	}
 	dev_info(&h->pdev->dev, "%s SENT, SUCCESS\n", msg);
-
-	/*
-	 * If the abort(s) above completed and actually aborted the
-	 * command, then the command to be aborted should already be
-	 * completed.  If not, wait around a bit more to see if they
-	 * manage to complete normally.
-	 */
-#define ABORT_COMPLETE_WAIT_SECS 30
-	for (i = 0; i < ABORT_COMPLETE_WAIT_SECS * 10; i++) {
-		refcount = atomic_read(&abort->refcount);
-		if (refcount < 2) {
-			cmd_free(h, abort);
-			return SUCCESS;
-		} else {
-			msleep(100);
-		}
-	}
-	dev_warn(&h->pdev->dev, "%s FAILED. Aborted command has not completed after %d seconds.\n",
-		msg, ABORT_COMPLETE_WAIT_SECS);
+	wait_event(h->abort_sync_wait_queue,
+		   abort->scsi_cmd != sc || lockup_detected(h));
 	cmd_free(h, abort);
-	return FAILED;
+	return !lockup_detected(h) ? SUCCESS : FAILED;
 }
 
 /*
@@ -5568,6 +5624,7 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 
 	/* Fill in the command type */
 	c->cmd_type = CMD_IOCTL_PEND;
+	c->scsi_cmd = SCSI_CMD_BUSY;
 	/* Fill in Command Header */
 	c->Header.ReplyQueue = 0; /* unused in simple mode */
 	if (iocommand.buf_size > 0) {	/* buffer to fill */
@@ -5701,6 +5758,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	c = cmd_alloc(h);
 
 	c->cmd_type = CMD_IOCTL_PEND;
+	c->scsi_cmd = SCSI_CMD_BUSY;
 	c->Header.ReplyQueue = 0;
 	c->Header.SGList = (u8) sg_used;
 	c->Header.SGTotal = cpu_to_le16(sg_used);
@@ -5843,6 +5901,7 @@ static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 	u64 tag; /* for commands to be aborted */
 
 	c->cmd_type = CMD_IOCTL_PEND;
+	c->scsi_cmd = SCSI_CMD_BUSY;
 	c->Header.ReplyQueue = 0;
 	if (buff != NULL && size > 0) {
 		c->Header.SGList = 1;
@@ -7638,6 +7697,7 @@ reinit_after_soft_reset:
 		goto clean5;	/* cmd, irq, pci, lockup, wq/aer/h */
 	init_waitqueue_head(&h->scan_wait_queue);
 	init_waitqueue_head(&h->abort_cmd_wait_queue);
+	init_waitqueue_head(&h->abort_sync_wait_queue);
 	h->scan_finished = 1; /* no scan currently in progress */
 
 	pci_set_drvdata(pdev, h);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 28b5d79..7cb8586 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -266,6 +266,7 @@ struct ctlr_info {
 	struct workqueue_struct *rescan_ctlr_wq;
 	atomic_t abort_cmds_available;
 	wait_queue_head_t abort_cmd_wait_queue;
+	wait_queue_head_t abort_sync_wait_queue;
 };
 
 struct offline_device_entry {
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 3719592..f986402 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -439,6 +439,8 @@ struct CommandList {
 	 * not used.
 	 */
 	struct hpsa_scsi_dev_t *phys_disk;
+
+	int abort_pending;
 	atomic_t refcount; /* Must be last to avoid memset in hpsa_cmd_init() */
 } __aligned(COMMANDLIST_ALIGNMENT);
 

