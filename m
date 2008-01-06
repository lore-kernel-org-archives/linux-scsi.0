From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH 18/33][SCSI] ibmmca: Convert 'Scsi_Cmnd' to 'struct scsi_cmnd'
Date: Sun, 6 Jan 2008 04:04:22 +0100 (MET)
Message-ID: <20080106030422.30002.76264.sendpatchset@thinktank.campus.ltu.se>
References: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:53949 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbYAFDEb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 22:04:31 -0500
In-Reply-To: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: kernel-janitors@vger.kernel.org, trivial@kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Convert the typedef'ed 'Scsi_Cmnd' to 'struct scsi_cmnd'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Last item before 'drivers/scsi/scsi_typedefs.h' can be removed.
Cleaned up checkpatch.pl-errors (so no '> 80 lines'-warning).


diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index db004a4..5863d70 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -39,9 +39,9 @@
 #include <scsi/scsi_host.h>
 
 /* Common forward declarations for all Linux-versions: */
-static int ibmmca_queuecommand (Scsi_Cmnd *, void (*done) (Scsi_Cmnd *));
-static int ibmmca_abort (Scsi_Cmnd *);
-static int ibmmca_host_reset (Scsi_Cmnd *);
+static int ibmmca_queuecommand(struct scsi_cmnd *, void (*done) (struct scsi_cmnd *));
+static int ibmmca_abort(struct scsi_cmnd *);
+static int ibmmca_host_reset(struct scsi_cmnd *);
 static int ibmmca_biosparam (struct scsi_device *, struct block_device *, sector_t, int *);
 static int ibmmca_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start, off_t offset, int length, int inout);
 
@@ -315,7 +315,7 @@ struct logical_device {
 	struct im_tsb tsb;	/* SCSI command complete status block structure */
 	struct im_sge sge[16];	/* scatter gather list structure */
 	unsigned char buf[256];	/* SCSI command return data buffer */
-	Scsi_Cmnd *cmd;		/* SCSI-command that is currently in progress */
+	struct scsi_cmnd *cmd;	/* SCSI-command that is currently in progress */
 	int device_type;	/* type of the SCSI-device. See include/scsi/scsi.h
 				   for interpretation of the possible values */
 	int block_length;	/* blocksize of a particular logical SCSI-device */
@@ -476,7 +476,7 @@ static char ibm_ansi_order = 0;
 #endif
 
 static void issue_cmd(struct Scsi_Host *, unsigned long, unsigned char);
-static void internal_done(Scsi_Cmnd * cmd);
+static void internal_done(struct scsi_cmnd *cmd);
 static void check_devices(struct Scsi_Host *, int);
 static int immediate_assign(struct Scsi_Host *, unsigned int, unsigned int, unsigned int, unsigned int);
 static int immediate_feature(struct Scsi_Host *, unsigned int, unsigned int);
@@ -503,7 +503,7 @@ static irqreturn_t interrupt_handler(int irq, void *dev_id)
 	unsigned int cmd_result;
 	unsigned int ldn;
 	unsigned long flags;
-	Scsi_Cmnd *cmd;
+	struct scsi_cmnd *cmd;
 	int lastSCSI;
 	struct device *dev = dev_id;
 	struct Scsi_Host *shpnt = dev_get_drvdata(dev);
@@ -726,7 +726,7 @@ static void issue_cmd(struct Scsi_Host *shpnt, unsigned long cmd_reg,
 	spin_unlock_irqrestore(shpnt->host_lock, flags);
 }
 
-static void internal_done(Scsi_Cmnd * cmd)
+static void internal_done(struct scsi_cmnd *cmd)
 {
 	cmd->SCp.Status++;
 	return;
@@ -1692,7 +1692,7 @@ static int __devexit ibmmca_remove(struct device *dev)
 }
 
 /* The following routine is the SCSI command queue for the midlevel driver */
-static int ibmmca_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
+static int ibmmca_queuecommand(struct scsi_cmnd *cmd, void (*done) (struct scsi_cmnd *))
 {
 	unsigned int ldn;
 	unsigned int scsi_cmd;
@@ -1997,7 +1997,7 @@ static int ibmmca_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 	return 0;
 }
 
-static int __ibmmca_abort(Scsi_Cmnd * cmd)
+static int __ibmmca_abort(struct scsi_cmnd *cmd)
 {
 	/* Abort does not work, as the adapter never generates an interrupt on
 	 * whatever situation is simulated, even when really pending commands
@@ -2005,7 +2005,7 @@ static int __ibmmca_abort(Scsi_Cmnd * cmd)
 
 	struct Scsi_Host *shpnt;
 	unsigned int ldn;
-	void (*saved_done) (Scsi_Cmnd *);
+	void (*saved_done) (struct scsi_cmnd *);
 	int target;
 	int max_pun;
 	unsigned long imm_command;
@@ -2091,7 +2091,7 @@ static int __ibmmca_abort(Scsi_Cmnd * cmd)
 	}
 }
 
-static int ibmmca_abort(Scsi_Cmnd * cmd)
+static int ibmmca_abort(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *shpnt = cmd->device->host;
 	int rc;
@@ -2103,10 +2103,10 @@ static int ibmmca_abort(Scsi_Cmnd * cmd)
 	return rc;
 }
 
-static int __ibmmca_host_reset(Scsi_Cmnd * cmd)
+static int __ibmmca_host_reset(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *shpnt;
-	Scsi_Cmnd *cmd_aid;
+	struct scsi_cmnd *cmd_aid;
 	int ticks, i;
 	unsigned long imm_command;
 
@@ -2183,7 +2183,7 @@ static int __ibmmca_host_reset(Scsi_Cmnd * cmd)
 	return SUCCESS;
 }
 
-static int ibmmca_host_reset(Scsi_Cmnd * cmd)
+static int ibmmca_host_reset(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *shpnt = cmd->device->host;
 	int rc;
