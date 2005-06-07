From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] megasas: clean up queuecommand path a little
Date: Tue, 7 Jun 2005 12:35:03 +0100
Message-ID: <20050607113503.GB5439@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:14464 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261842AbVFGLfH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jun 2005 07:35:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sreenib@lsil.com
Cc: linux-scsi@vger.kernel.org

Only one small change in behaviour: we're returning SCSI_MLQUEUE_HOST_BUSY now
when no command is available to make the midlayers life easier.  Else it's just
streamlining the code and removing duplications.


--- megaraid/megaraid_sas.c	2005-06-07 12:41:10.000000000 +0200
+++ megaraid-hch/megaraid_sas.c	2005-06-07 13:12:32.000000000 +0200
@@ -556,113 +556,21 @@ megasas_build_ldio(struct megasas_instan
 	return cmd->frame_count;
 }
 
-/**
- * megasas_build_cmd -	Prepares a command packet
- * @instance:		Adapter soft state
- * @scp:		SCSI command
- * @frame_count:	[OUT] Number of frames used to prepare this command
- */
-static inline struct megasas_cmd*
-megasas_build_cmd(struct megasas_instance *instance, struct scsi_cmnd *scp,
-							int *frame_count )
+static int megasas_cmd_is_rw(struct scsi_cmnd *scmd)
 {
-	u32			logical_cmd;
-	struct megasas_cmd	*cmd;
-
-	/*
-	 * Find out if this is logical or physical drive command.
-	 */
-	logical_cmd	= MEGASAS_IS_LOGICAL(scp);
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
-		switch(scp->cmnd[0]) {
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
-			if (! (*frame_count) ) {
-				megasas_return_cmd( instance, cmd );
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
-			if (! (*frame_count) ) {
-				megasas_return_cmd(instance, cmd);
-				return NULL;
-			}
-
-			return cmd;
-		}
-	}
-	else {
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
+	switch (scmd->cmnd[0]) {
+	case READ_10:
+	case WRITE_10:
+	case READ_12:
+	case WRITE_12:
+	case READ_6:
+	case WRITE_6:
+	case READ_16:
+	case WRITE_16:
+		return 1;
+	default:
+		return 0;
 	}
-
-	return NULL;
 }
 
 /**
@@ -671,8 +579,9 @@ megasas_build_cmd(struct megasas_instanc
  * @done:			Callback entry point
  */
 static int
-megasas_queue_command(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd*))
+megasas_queue_command(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 {
+	u32				logical_cmd;
 	u32				frame_count;
 	unsigned long			flags;
 	struct megasas_cmd		*cmd;
@@ -680,14 +589,29 @@ megasas_queue_command(struct scsi_cmnd *
 
 	instance	= (struct megasas_instance*)
 				scmd->device->host->hostdata;
+	logical_cmd	= MEGASAS_IS_LOGICAL(scmd);
+
 	scmd->scsi_done	= done;
 	scmd->result	= 0;
 
-	cmd = megasas_build_cmd( instance, scmd, &frame_count );
+	if (logical_cmd &&
+	    (scmd->device->id >= MEGASAS_MAX_LD || scmd->device->lun)) {
+		scmd->result = DID_BAD_TARGET << 16;
+		goto out_fail_hard;
+	}
 
-	if (!cmd) {
-		done(scmd);
-		return 0;
+	cmd = megasas_get_cmd(instance);
+	if (!cmd)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
+	if (logical_cmd && megasas_cmd_is_rw(scmd))
+		frame_count = megasas_build_ldio(instance, scmd, cmd);
+	else
+		frame_count = megasas_build_dcdb(instance, scmd, cmd);
+
+	if (!frame_count) {
+		megasas_return_cmd(instance, cmd);
+		goto out_fail_hard;
 	}
 
 	cmd->scmd = scmd;
@@ -703,6 +627,10 @@ megasas_queue_command(struct scsi_cmnd *
 				&instance->reg_set->inbound_queue_port );
 
 	return 0;
+
+ out_fail_hard:
+	done(scmd);
+	return 0;
 }
 
 /**
