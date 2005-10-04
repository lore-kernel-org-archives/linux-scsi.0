From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] megaraid_sas: cleanup up queuecommand path
Date: Tue, 4 Oct 2005 20:41:01 +0200
Message-ID: <20051004184101.GB17168@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:53407 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964912AbVJDSlG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2005 14:41:06 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreenivas.Bagalkote@lsil.com
Cc: linux-scsi@vger.kernel.org

There's a lot of duplicate code megasas_build_cmd.  Move that out of
the different codepathes and merge the reminder of megasas_build_cmd
into megasas_queue_command


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/megaraid/megaraid_sas.c
===================================================================
--- linux-2.6.orig/drivers/scsi/megaraid/megaraid_sas.c	2005-10-04 20:07:32.000000000 +0200
+++ linux-2.6/drivers/scsi/megaraid/megaraid_sas.c	2005-10-04 20:22:11.000000000 +0200
@@ -556,113 +556,22 @@
 	return cmd->frame_count;
 }
 
-/**
- * megasas_build_cmd -	Prepares a command packet
- * @instance:		Adapter soft state
- * @scp:		SCSI command
- * @frame_count:	[OUT] Number of frames used to prepare this command
- */
-static inline struct megasas_cmd *megasas_build_cmd(struct megasas_instance
-						    *instance,
-						    struct scsi_cmnd *scp,
-						    int *frame_count)
+static inline int megasas_is_ldio(struct scsi_cmnd *cmd)
 {
-	u32 logical_cmd;
-	struct megasas_cmd *cmd;
-
-	/*
-	 * Find out if this is logical or physical drive command.
-	 */
-	logical_cmd = MEGASAS_IS_LOGICAL(scp);
-
-	/*
-	 * Logical drive command
-	 */
-	if (logical_cmd) {
-
-		if (scp->device->id >= MEGASAS_MAX_LD) {
-			scp->result = DID_BAD_TARGET << 16;
-			return NULL;
-		}
-
-		switch (scp->cmnd[0]) {
-
-		case READ_10:
-		case WRITE_10:
-		case READ_12:
-		case WRITE_12:
-		case READ_6:
-		case WRITE_6:
-		case READ_16:
-		case WRITE_16:
-			/*
-			 * Fail for LUN > 0
-			 */
-			if (scp->device->lun) {
-				scp->result = DID_BAD_TARGET << 16;
-				return NULL;
-			}
-
-			cmd = megasas_get_cmd(instance);
-
-			if (!cmd) {
-				scp->result = DID_IMM_RETRY << 16;
-				return NULL;
-			}
-
-			*frame_count = megasas_build_ldio(instance, scp, cmd);
-
-			if (!(*frame_count)) {
-				megasas_return_cmd(instance, cmd);
-				return NULL;
-			}
-
-			return cmd;
-
-		default:
-			/*
-			 * Fail for LUN > 0
-			 */
-			if (scp->device->lun) {
-				scp->result = DID_BAD_TARGET << 16;
-				return NULL;
-			}
-
-			cmd = megasas_get_cmd(instance);
-
-			if (!cmd) {
-				scp->result = DID_IMM_RETRY << 16;
-				return NULL;
-			}
-
-			*frame_count = megasas_build_dcdb(instance, scp, cmd);
-
-			if (!(*frame_count)) {
-				megasas_return_cmd(instance, cmd);
-				return NULL;
-			}
-
-			return cmd;
-		}
-	} else {
-		cmd = megasas_get_cmd(instance);
-
-		if (!cmd) {
-			scp->result = DID_IMM_RETRY << 16;
-			return NULL;
-		}
-
-		*frame_count = megasas_build_dcdb(instance, scp, cmd);
-
-		if (!(*frame_count)) {
-			megasas_return_cmd(instance, cmd);
-			return NULL;
-		}
-
-		return cmd;
+	if (!MEGASAS_IS_LOGICAL(cmd))
+		return 0;
+	switch (cmd->cmnd[0]) {
+	case READ_10:
+	case WRITE_10:
+	case READ_12:
+	case WRITE_12:
+	case READ_6:
+	case WRITE_6:
+	case READ_16:
+		return 1;
+	default:
+		return 0;
 	}
-
-	return NULL;
 }
 
 /**
@@ -683,13 +592,27 @@
 	scmd->scsi_done = done;
 	scmd->result = 0;
 
-	cmd = megasas_build_cmd(instance, scmd, &frame_count);
-
-	if (!cmd) {
-		done(scmd);
-		return 0;
+	if (MEGASAS_IS_LOGICAL(scmd) &&
+	    (scmd->device->id >= MEGASAS_MAX_LD || scmd->device->lun)) {
+		scmd->result = DID_BAD_TARGET << 16;
+		goto out_done;
 	}
 
+	cmd = megasas_get_cmd(instance);
+	if (!cmd)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
+	/*
+	 * Logical drive command
+	 */
+	if (megasas_is_ldio(scmd))
+		frame_count = megasas_build_ldio(instance, scmd, cmd);
+	else
+		frame_count = megasas_build_dcdb(instance, scmd, cmd);
+
+	if (!frame_count)
+		goto out_return_cmd;
+
 	cmd->scmd = scmd;
 	scmd->SCp.ptr = (char *)cmd;
 	scmd->SCp.sent_command = jiffies;
@@ -705,6 +628,12 @@
 	       &instance->reg_set->inbound_queue_port);
 
 	return 0;
+
+ out_return_cmd:
+	megasas_return_cmd(instance, cmd);
+ out_done:
+	done(scmd);
+	return 0;
 }
 
 /**
