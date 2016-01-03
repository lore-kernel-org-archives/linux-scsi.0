From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 60/78] ncr5380: Implement new eh_abort_handler
Date: Sun, 03 Jan 2016 16:06:01 +1100
Message-ID: <20160103050516.911765777@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-new-eh_abort_handler
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Introduce a new eh_abort_handler implementation. This one attempts to
follow all of the rules relating to EH handlers. There is still a known
bug: during selection, a command becomes invisible to the EH handlers
because it only appears in a pointer on the stack of a different thread.
This bug is addressed in a subsequent patch.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |  155 ++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/atari_NCR5380.c |  157 ++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 282 insertions(+), 30 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:04:25.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:04:28.000000000 +1100
@@ -2480,41 +2480,168 @@ static void NCR5380_reselect(struct Scsi
 }
 
 
-/*
- * Function : int NCR5380_abort (struct scsi_cmnd *cmd)
+/**
+ * list_find_cmd - test for presence of a command in a linked list
+ * @haystack: list of commands
+ * @needle: command to search for
+ */
+
+static bool list_find_cmd(struct list_head *haystack,
+                          struct scsi_cmnd *needle)
+{
+	struct NCR5380_cmd *ncmd;
+
+	list_for_each_entry(ncmd, haystack, list)
+		if (NCR5380_to_scmd(ncmd) == needle)
+			return true;
+	return false;
+}
+
+/**
+ * list_remove_cmd - remove a command from linked list
+ * @haystack: list of commands
+ * @needle: command to remove
+ */
+
+static bool list_del_cmd(struct list_head *haystack,
+                         struct scsi_cmnd *needle)
+{
+	if (list_find_cmd(haystack, needle)) {
+		struct NCR5380_cmd *ncmd = scsi_cmd_priv(needle);
+
+		list_del(&ncmd->list);
+		return true;
+	}
+	return false;
+}
+
+/**
+ * NCR5380_abort - scsi host eh_abort_handler() method
+ * @cmd: the command to be aborted
  *
- * Purpose : abort a command
+ * Try to abort a given command by removing it from queues and/or sending
+ * the target an abort message. This may not succeed in causing a target
+ * to abort the command. Nonetheless, the low-level driver must forget about
+ * the command because the mid-layer reclaims it and it may be re-issued.
  *
- * Inputs : cmd - the scsi_cmnd to abort, code - code to set the
- *	host byte of the result field to, if zero DID_ABORTED is
- *	used.
+ * The normal path taken by a command is as follows. For EH we trace this
+ * same path to locate and abort the command.
  *
- * Returns : SUCCESS - success, FAILED on failure.
+ * unissued -> selecting -> [unissued -> selecting ->]... connected ->
+ * [disconnected -> connected ->]...
+ * [autosense -> connected ->] done
  *
- * XXX - there is no way to abort the command that is currently
- *	 connected, you have to wait for it to complete.  If this is
- *	 a problem, we could implement longjmp() / setjmp(), setjmp()
- *	 called where the loop started in NCR5380_main().
+ * If cmd is unissued then just remove it.
+ * If cmd is disconnected, try to select the target.
+ * If cmd is connected, try to send an abort message.
+ * If cmd is waiting for autosense, give it a chance to complete but check
+ * that it isn't left connected.
+ * If cmd was not found at all then presumably it has already been completed,
+ * in which case return SUCCESS to try to avoid further EH measures.
+ * If the command has not completed yet, we must not fail to find it.
  */
 
-static
-int NCR5380_abort(struct scsi_cmnd *cmd)
+static int NCR5380_abort(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *instance = cmd->device->host;
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned long flags;
+	int result = SUCCESS;
 
 	spin_lock_irqsave(&hostdata->lock, flags);
 
 #if (NDEBUG & NDEBUG_ANY)
-	scmd_printk(KERN_INFO, cmd, "aborting command\n");
+	scmd_printk(KERN_INFO, cmd, __func__);
 #endif
 	NCR5380_dprint(NDEBUG_ANY, instance);
 	NCR5380_dprint_phase(NDEBUG_ANY, instance);
 
+	if (list_del_cmd(&hostdata->unissued, cmd)) {
+		dsprintk(NDEBUG_ABORT, instance,
+		         "abort: removed %p from issue queue\n", cmd);
+		cmd->result = DID_ABORT << 16;
+		cmd->scsi_done(cmd); /* No tag or busy flag to worry about */
+	}
+
+	if (list_del_cmd(&hostdata->disconnected, cmd)) {
+		dsprintk(NDEBUG_ABORT, instance,
+		         "abort: removed %p from disconnected list\n", cmd);
+		cmd->result = DID_ERROR << 16;
+		if (!hostdata->connected)
+			NCR5380_select(instance, cmd);
+		if (hostdata->connected != cmd) {
+			complete_cmd(instance, cmd);
+			result = FAILED;
+			goto out;
+		}
+	}
+
+	if (hostdata->connected == cmd) {
+		dsprintk(NDEBUG_ABORT, instance, "abort: cmd %p is connected\n", cmd);
+		hostdata->connected = NULL;
+		if (do_abort(instance)) {
+			set_host_byte(cmd, DID_ERROR);
+			complete_cmd(instance, cmd);
+			result = FAILED;
+			goto out;
+		}
+		set_host_byte(cmd, DID_ABORT);
+#ifdef REAL_DMA
+		hostdata->dma_len = 0;
+#endif
+		if (cmd->cmnd[0] == REQUEST_SENSE)
+			complete_cmd(instance, cmd);
+		else {
+			struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
+
+			/* Perform autosense for this command */
+			list_add(&ncmd->list, &hostdata->autosense);
+		}
+	}
+
+	if (list_find_cmd(&hostdata->autosense, cmd)) {
+		dsprintk(NDEBUG_ABORT, instance,
+		         "abort: found %p on sense queue\n", cmd);
+		spin_unlock_irqrestore(&hostdata->lock, flags);
+		queue_work(hostdata->work_q, &hostdata->main_task);
+		msleep(1000);
+		spin_lock_irqsave(&hostdata->lock, flags);
+		if (list_del_cmd(&hostdata->autosense, cmd)) {
+			dsprintk(NDEBUG_ABORT, instance,
+			         "abort: removed %p from sense queue\n", cmd);
+			set_host_byte(cmd, DID_ABORT);
+			complete_cmd(instance, cmd);
+			goto out;
+		}
+	}
+
+	if (hostdata->connected == cmd) {
+		dsprintk(NDEBUG_ABORT, instance, "abort: cmd %p is connected\n", cmd);
+		hostdata->connected = NULL;
+		if (do_abort(instance)) {
+			set_host_byte(cmd, DID_ERROR);
+			complete_cmd(instance, cmd);
+			result = FAILED;
+			goto out;
+		}
+		set_host_byte(cmd, DID_ABORT);
+#ifdef REAL_DMA
+		hostdata->dma_len = 0;
+#endif
+		complete_cmd(instance, cmd);
+	}
+
+out:
+	if (result == FAILED)
+		dsprintk(NDEBUG_ABORT, instance, "abort: failed to abort %p\n", cmd);
+	else
+		dsprintk(NDEBUG_ABORT, instance, "abort: successfully aborted %p\n", cmd);
+
+	queue_work(hostdata->work_q, &hostdata->main_task);
+	maybe_release_dma_irq(instance);
 	spin_unlock_irqrestore(&hostdata->lock, flags);
 
-	return FAILED;
+	return result;
 }
 
 
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:04:25.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:04:28.000000000 +1100
@@ -2269,23 +2269,65 @@ static void NCR5380_dma_complete(NCR5380
 }
 #endif				/* def REAL_DMA */
 
-/*
- * Function : int NCR5380_abort (struct scsi_cmnd *cmd)
- *
- * Purpose : abort a command
+/**
+ * list_find_cmd - test for presence of a command in a linked list
+ * @haystack: list of commands
+ * @needle: command to search for
+ */
+
+static bool list_find_cmd(struct list_head *haystack,
+                          struct scsi_cmnd *needle)
+{
+	struct NCR5380_cmd *ncmd;
+
+	list_for_each_entry(ncmd, haystack, list)
+		if (NCR5380_to_scmd(ncmd) == needle)
+			return true;
+	return false;
+}
+
+/**
+ * list_remove_cmd - remove a command from linked list
+ * @haystack: list of commands
+ * @needle: command to remove
+ */
+
+static bool list_del_cmd(struct list_head *haystack,
+                         struct scsi_cmnd *needle)
+{
+	if (list_find_cmd(haystack, needle)) {
+		struct NCR5380_cmd *ncmd = scsi_cmd_priv(needle);
+
+		list_del(&ncmd->list);
+		return true;
+	}
+	return false;
+}
+
+/**
+ * NCR5380_abort - scsi host eh_abort_handler() method
+ * @cmd: the command to be aborted
  *
- * Inputs : cmd - the scsi_cmnd to abort, code - code to set the
- *      host byte of the result field to, if zero DID_ABORTED is
- *      used.
+ * Try to abort a given command by removing it from queues and/or sending
+ * the target an abort message. This may not succeed in causing a target
+ * to abort the command. Nonetheless, the low-level driver must forget about
+ * the command because the mid-layer reclaims it and it may be re-issued.
  *
- * Returns : SUCCESS - success, FAILED on failure.
+ * The normal path taken by a command is as follows. For EH we trace this
+ * same path to locate and abort the command.
  *
- *	XXX - there is no way to abort the command that is currently
- *	connected, you have to wait for it to complete.  If this is
- *	a problem, we could implement longjmp() / setjmp(), setjmp()
- *	called where the loop started in NCR5380_main().
+ * unissued -> selecting -> [unissued -> selecting ->]... connected ->
+ * [disconnected -> connected ->]...
+ * [autosense -> connected ->] done
  *
- * Locks: host lock taken by caller
+ * If cmd is unissued then just remove it.
+ * If cmd is disconnected, try to select the target.
+ * If cmd is connected, try to send an abort message.
+ * If cmd is waiting for autosense, give it a chance to complete but check
+ * that it isn't left connected.
+ * If cmd was not found at all then presumably it has already been completed,
+ * in which case return SUCCESS to try to avoid further EH measures.
+ * If the command has not completed yet, we must not fail to find it.
  */
 
 static int NCR5380_abort(struct scsi_cmnd *cmd)
@@ -2293,18 +2335,101 @@ static int NCR5380_abort(struct scsi_cmn
 	struct Scsi_Host *instance = cmd->device->host;
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned long flags;
+	int result = SUCCESS;
 
 	spin_lock_irqsave(&hostdata->lock, flags);
 
 #if (NDEBUG & NDEBUG_ANY)
-	scmd_printk(KERN_INFO, cmd, "aborting command\n");
+	scmd_printk(KERN_INFO, cmd, __func__);
 #endif
 	NCR5380_dprint(NDEBUG_ANY, instance);
 	NCR5380_dprint_phase(NDEBUG_ANY, instance);
 
+	if (list_del_cmd(&hostdata->unissued, cmd)) {
+		dsprintk(NDEBUG_ABORT, instance,
+		         "abort: removed %p from issue queue\n", cmd);
+		cmd->result = DID_ABORT << 16;
+		cmd->scsi_done(cmd); /* No tag or busy flag to worry about */
+	}
+
+	if (list_del_cmd(&hostdata->disconnected, cmd)) {
+		dsprintk(NDEBUG_ABORT, instance,
+		         "abort: removed %p from disconnected list\n", cmd);
+		cmd->result = DID_ERROR << 16;
+		if (!hostdata->connected)
+			NCR5380_select(instance, cmd);
+		if (hostdata->connected != cmd) {
+			complete_cmd(instance, cmd);
+			result = FAILED;
+			goto out;
+		}
+	}
+
+	if (hostdata->connected == cmd) {
+		dsprintk(NDEBUG_ABORT, instance, "abort: cmd %p is connected\n", cmd);
+		hostdata->connected = NULL;
+		if (do_abort(instance)) {
+			set_host_byte(cmd, DID_ERROR);
+			complete_cmd(instance, cmd);
+			result = FAILED;
+			goto out;
+		}
+		set_host_byte(cmd, DID_ABORT);
+#ifdef REAL_DMA
+		hostdata->dma_len = 0;
+#endif
+		if (cmd->cmnd[0] == REQUEST_SENSE)
+			complete_cmd(instance, cmd);
+		else {
+			struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
+
+			/* Perform autosense for this command */
+			list_add(&ncmd->list, &hostdata->autosense);
+		}
+	}
+
+	if (list_find_cmd(&hostdata->autosense, cmd)) {
+		dsprintk(NDEBUG_ABORT, instance,
+		         "abort: found %p on sense queue\n", cmd);
+		spin_unlock_irqrestore(&hostdata->lock, flags);
+		queue_work(hostdata->work_q, &hostdata->main_task);
+		msleep(1000);
+		spin_lock_irqsave(&hostdata->lock, flags);
+		if (list_del_cmd(&hostdata->autosense, cmd)) {
+			dsprintk(NDEBUG_ABORT, instance,
+			         "abort: removed %p from sense queue\n", cmd);
+			set_host_byte(cmd, DID_ABORT);
+			complete_cmd(instance, cmd);
+			goto out;
+		}
+	}
+
+	if (hostdata->connected == cmd) {
+		dsprintk(NDEBUG_ABORT, instance, "abort: cmd %p is connected\n", cmd);
+		hostdata->connected = NULL;
+		if (do_abort(instance)) {
+			set_host_byte(cmd, DID_ERROR);
+			complete_cmd(instance, cmd);
+			result = FAILED;
+			goto out;
+		}
+		set_host_byte(cmd, DID_ABORT);
+#ifdef REAL_DMA
+		hostdata->dma_len = 0;
+#endif
+		complete_cmd(instance, cmd);
+	}
+
+out:
+	if (result == FAILED)
+		dsprintk(NDEBUG_ABORT, instance, "abort: failed to abort %p\n", cmd);
+	else
+		dsprintk(NDEBUG_ABORT, instance, "abort: successfully aborted %p\n", cmd);
+
+	queue_work(hostdata->work_q, &hostdata->main_task);
 	spin_unlock_irqrestore(&hostdata->lock, flags);
 
-	return FAILED;
+	return result;
 }
 
 
