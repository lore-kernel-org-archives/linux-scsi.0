From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] wd33c93 update
Date: Mon, 21 Jun 2004 16:26:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621142611.GA32068@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:38096 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266248AbUFUO0e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 10:26:34 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

avoid obsolete APIs


--- 1.18/drivers/scsi/wd33c93.c	2004-05-12 17:46:23 +02:00
+++ edited/drivers/scsi/wd33c93.c	2004-06-20 18:02:36 +02:00
@@ -82,7 +82,9 @@
 #include <linux/blkdev.h>
 #include <asm/irq.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 
 #include "wd33c93.h"
@@ -299,17 +301,6 @@
 	return x;
 }
 
-/* The 33c93 needs to be told which direction a command transfers its
- * data; we use this function to figure it out. Returns true if there
- * will be a DATA_OUT phase with this command, false otherwise.
- * (Thanks to Joerg Dorchain for the research and suggestion.)
- */
-static inline int
-is_dir_out(Scsi_Cmnd * cmd)
-{
-	return cmd->sc_data_direction == SCSI_DATA_WRITE;
-}
-
 static struct sx_period sx_table[] = {
 	{1, 0x20},
 	{252, 0x20},
@@ -348,17 +339,18 @@
 }
 
 int
-wd33c93_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
+wd33c93_queuecommand(struct scsi_cmnd *cmd,
+		void (*done)(struct scsi_cmnd *))
 {
 	struct WD33C93_hostdata *hostdata;
-	Scsi_Cmnd *tmp;
+	struct scsi_cmnd *tmp;
 
 	hostdata = (struct WD33C93_hostdata *) cmd->device->host->hostdata;
 
 	DB(DB_QUEUE_COMMAND,
 	   printk("Q-%d-%02x-%ld( ", cmd->device->id, cmd->cmnd[0], cmd->pid))
 
-/* Set up a few fields in the Scsi_Cmnd structure for our own use:
+/* Set up a few fields in the scsi_cmnd structure for our own use:
  *  - host_scribble is the pointer to the next cmd in the input queue
  *  - scsi_done points to the routine we call when a cmd is finished
  *  - result is what you'd expect
@@ -426,8 +418,9 @@
 		cmd->host_scribble = (uchar *) hostdata->input_Q;
 		hostdata->input_Q = cmd;
 	} else {		/* find the end of the queue */
-		for (tmp = (Scsi_Cmnd *) hostdata->input_Q; tmp->host_scribble;
-		     tmp = (Scsi_Cmnd *) tmp->host_scribble) ;
+		for (tmp = (struct scsi_cmnd *) hostdata->input_Q;
+		     tmp->host_scribble;
+		     tmp = (struct scsi_cmnd *) tmp->host_scribble) ;
 		tmp->host_scribble = (uchar *) cmd;
 	}
 
@@ -459,7 +452,7 @@
 	struct WD33C93_hostdata *hostdata =
 	    (struct WD33C93_hostdata *) instance->hostdata;
 	const wd33c93_regs regs = hostdata->regs;
-	Scsi_Cmnd *cmd, *prev;
+	struct scsi_cmnd *cmd, *prev;
 
 	DB(DB_EXECUTE, printk("EX("))
 	if (hostdata->selecting || hostdata->connected) {
@@ -472,13 +465,13 @@
 	 * for an idle target/lun.
 	 */
 
-	cmd = (Scsi_Cmnd *) hostdata->input_Q;
+	cmd = (struct scsi_cmnd *) hostdata->input_Q;
 	prev = 0;
 	while (cmd) {
 		if (!(hostdata->busy[cmd->device->id] & (1 << cmd->device->lun)))
 			break;
 		prev = cmd;
-		cmd = (Scsi_Cmnd *) cmd->host_scribble;
+		cmd = (struct scsi_cmnd *) cmd->host_scribble;
 	}
 
 	/* quit if queue empty or all possible targets are busy */
@@ -493,7 +486,7 @@
 	if (prev)
 		prev->host_scribble = cmd->host_scribble;
 	else
-		hostdata->input_Q = (Scsi_Cmnd *) cmd->host_scribble;
+		hostdata->input_Q = (struct scsi_cmnd *) cmd->host_scribble;
 
 #ifdef PROC_STATISTICS
 	hostdata->cmd_cnt[cmd->device->id]++;
@@ -503,7 +496,7 @@
 	 * Start the selection process
 	 */
 
-	if (is_dir_out(cmd))
+	if (cmd->sc_data_direction == DMA_TO_DEVICE)
 		write_wd33c93(regs, WD_DESTINATION_ID, cmd->device->id);
 	else
 		write_wd33c93(regs, WD_DESTINATION_ID, cmd->device->id | DSTID_DPD);
@@ -542,12 +535,12 @@
 		goto yes;
 	if (!(hostdata->input_Q))	/* input_Q empty? */
 		goto no;
-	for (prev = (Scsi_Cmnd *) hostdata->input_Q; prev;
-	     prev = (Scsi_Cmnd *) prev->host_scribble) {
+	for (prev = (struct scsi_cmnd *) hostdata->input_Q; prev;
+	     prev = (struct scsi_cmnd *) prev->host_scribble) {
 		if ((prev->device->id != cmd->device->id) ||
 		    (prev->device->lun != cmd->device->lun)) {
-			for (prev = (Scsi_Cmnd *) hostdata->input_Q; prev;
-			     prev = (Scsi_Cmnd *) prev->host_scribble)
+			for (prev = (struct scsi_cmnd *) hostdata->input_Q; prev;
+			     prev = (struct scsi_cmnd *) prev->host_scribble)
 				prev->SCp.phase = 1;
 			goto yes;
 		}
@@ -635,8 +628,8 @@
 
 		if ((cmd->SCp.phase == 0) && (hostdata->no_dma == 0)) {
 			if (hostdata->dma_setup(cmd,
-						(is_dir_out(cmd)) ? DATA_OUT_DIR
-						: DATA_IN_DIR))
+			    (cmd->sc_data_direction == DMA_TO_DEVICE) ?
+			     DATA_OUT_DIR : DATA_IN_DIR))
 				write_wd33c93_count(regs, 0);	/* guarantee a DATA_PHASE interrupt */
 			else {
 				write_wd33c93_count(regs,
@@ -699,7 +692,8 @@
 }
 
 static void
-transfer_bytes(const wd33c93_regs regs, Scsi_Cmnd * cmd, int data_in_dir)
+transfer_bytes(const wd33c93_regs regs, struct scsi_cmnd *cmd,
+		int data_in_dir)
 {
 	struct WD33C93_hostdata *hostdata;
 	unsigned long length;
@@ -774,7 +768,7 @@
 	struct WD33C93_hostdata *hostdata =
 	    (struct WD33C93_hostdata *) instance->hostdata;
 	const wd33c93_regs regs = hostdata->regs;
-	Scsi_Cmnd *patch, *cmd;
+	struct scsi_cmnd *patch, *cmd;
 	uchar asr, sr, phs, id, lun, *ucp, msg;
 	unsigned long length, flags;
 
@@ -788,7 +782,7 @@
 	hostdata->int_cnt++;
 #endif
 
-	cmd = (Scsi_Cmnd *) hostdata->connected;	/* assume we're connected */
+	cmd = (struct scsi_cmnd *) hostdata->connected;	/* assume we're connected */
 	sr = read_wd33c93(regs, WD_SCSI_STATUS);	/* clear the interrupt */
 	phs = read_wd33c93(regs, WD_COMMAND_PHASE);
 
@@ -828,7 +822,7 @@
 		    if (hostdata->state == S_RUNNING_LEVEL2)
 			hostdata->connected = NULL;
 		else {
-			cmd = (Scsi_Cmnd *) hostdata->selecting;	/* get a valid cmd */
+			cmd = (struct scsi_cmnd *) hostdata->selecting;	/* get a valid cmd */
 			hostdata->selecting = NULL;
 		}
 
@@ -861,7 +855,7 @@
 	case CSR_SELECT:
 		DB(DB_INTR, printk("SELECT"))
 		    hostdata->connected = cmd =
-		    (Scsi_Cmnd *) hostdata->selecting;
+		    (struct scsi_cmnd *) hostdata->selecting;
 		hostdata->selecting = NULL;
 
 		/* construct an IDENTIFY message with correct disconnect bit */
@@ -1307,7 +1301,7 @@
 		    if (hostdata->level2 <= L2_NONE) {
 
 			if (hostdata->selecting) {
-				cmd = (Scsi_Cmnd *) hostdata->selecting;
+				cmd = (struct scsi_cmnd *) hostdata->selecting;
 				hostdata->selecting = NULL;
 				hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
 				cmd->host_scribble =
@@ -1399,13 +1393,13 @@
 
 		/* Now we look for the command that's reconnecting. */
 
-		cmd = (Scsi_Cmnd *) hostdata->disconnected_Q;
+		cmd = (struct scsi_cmnd *) hostdata->disconnected_Q;
 		patch = NULL;
 		while (cmd) {
 			if (id == cmd->device->id && lun == cmd->device->lun)
 				break;
 			patch = cmd;
-			cmd = (Scsi_Cmnd *) cmd->host_scribble;
+			cmd = (struct scsi_cmnd *) cmd->host_scribble;
 		}
 
 		/* Hmm. Couldn't find a valid command.... What to do? */
@@ -1424,7 +1418,7 @@
 			patch->host_scribble = cmd->host_scribble;
 		else
 			hostdata->disconnected_Q =
-			    (Scsi_Cmnd *) cmd->host_scribble;
+			    (struct scsi_cmnd *) cmd->host_scribble;
 		hostdata->connected = cmd;
 
 		/* We don't need to worry about 'initialize_SCp()' or 'hostdata->busy[]'
@@ -1432,7 +1426,7 @@
 		 * But we DO need to fix the DPD bit so it's correct for this command.
 		 */
 
-		if (is_dir_out(cmd))
+		if (cmd->sc_data_direction == DMA_TO_DEVICE)
 			write_wd33c93(regs, WD_DESTINATION_ID, cmd->device->id);
 		else
 			write_wd33c93(regs, WD_DESTINATION_ID,
@@ -1522,7 +1516,7 @@
 }
 
 int
-wd33c93_host_reset(Scsi_Cmnd * SCpnt)
+wd33c93_host_reset(struct scsi_cmnd * SCpnt)
 {
 	struct Scsi_Host *instance;
 	struct WD33C93_hostdata *hostdata;
@@ -1557,12 +1551,12 @@
 }
 
 int
-wd33c93_abort(Scsi_Cmnd * cmd)
+wd33c93_abort(struct scsi_cmnd * cmd)
 {
 	struct Scsi_Host *instance;
 	struct WD33C93_hostdata *hostdata;
 	wd33c93_regs regs;
-	Scsi_Cmnd *tmp, *prev;
+	struct scsi_cmnd *tmp, *prev;
 
 	disable_irq(cmd->device->host->irq);
 
@@ -1575,7 +1569,7 @@
  *     from the input_Q.
  */
 
-	tmp = (Scsi_Cmnd *) hostdata->input_Q;
+	tmp = (struct scsi_cmnd *) hostdata->input_Q;
 	prev = 0;
 	while (tmp) {
 		if (tmp == cmd) {
@@ -1583,7 +1577,7 @@
 				prev->host_scribble = cmd->host_scribble;
 			else
 				hostdata->input_Q =
-				    (Scsi_Cmnd *) cmd->host_scribble;
+				    (struct scsi_cmnd *) cmd->host_scribble;
 			cmd->host_scribble = NULL;
 			cmd->result = DID_ABORT << 16;
 			printk
@@ -1594,7 +1588,7 @@
 			return SUCCESS;
 		}
 		prev = tmp;
-		tmp = (Scsi_Cmnd *) tmp->host_scribble;
+		tmp = (struct scsi_cmnd *) tmp->host_scribble;
 	}
 
 /*
@@ -1675,7 +1669,7 @@
  * an ABORT_SNOOZE and hope for the best...
  */
 
-	tmp = (Scsi_Cmnd *) hostdata->disconnected_Q;
+	tmp = (struct scsi_cmnd *) hostdata->disconnected_Q;
 	while (tmp) {
 		if (tmp == cmd) {
 			printk
@@ -1685,7 +1679,7 @@
 			enable_irq(cmd->device->host->irq);
 			return FAILED;
 		}
-		tmp = (Scsi_Cmnd *) tmp->host_scribble;
+		tmp = (struct scsi_cmnd *) tmp->host_scribble;
 	}
 
 /*
@@ -1921,7 +1915,7 @@
 	char *bp;
 	char tbuf[128];
 	struct WD33C93_hostdata *hd;
-	Scsi_Cmnd *cmd;
+	struct scsi_cmnd *cmd;
 	int x, i;
 	static int stop = 0;
 
@@ -2022,7 +2016,7 @@
 	if (hd->proc & PR_CONNECTED) {
 		strcat(bp, "\nconnected:     ");
 		if (hd->connected) {
-			cmd = (Scsi_Cmnd *) hd->connected;
+			cmd = (struct scsi_cmnd *) hd->connected;
 			sprintf(tbuf, " %ld-%d:%d(%02x)",
 				cmd->pid, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			strcat(bp, tbuf);
@@ -2030,22 +2024,22 @@
 	}
 	if (hd->proc & PR_INPUTQ) {
 		strcat(bp, "\ninput_Q:       ");
-		cmd = (Scsi_Cmnd *) hd->input_Q;
+		cmd = (struct scsi_cmnd *) hd->input_Q;
 		while (cmd) {
 			sprintf(tbuf, " %ld-%d:%d(%02x)",
 				cmd->pid, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			strcat(bp, tbuf);
-			cmd = (Scsi_Cmnd *) cmd->host_scribble;
+			cmd = (struct scsi_cmnd *) cmd->host_scribble;
 		}
 	}
 	if (hd->proc & PR_DISCQ) {
 		strcat(bp, "\ndisconnected_Q:");
-		cmd = (Scsi_Cmnd *) hd->disconnected_Q;
+		cmd = (struct scsi_cmnd *) hd->disconnected_Q;
 		while (cmd) {
 			sprintf(tbuf, " %ld-%d:%d(%02x)",
 				cmd->pid, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			strcat(bp, tbuf);
-			cmd = (Scsi_Cmnd *) cmd->host_scribble;
+			cmd = (struct scsi_cmnd *) cmd->host_scribble;
 		}
 	}
 	strcat(bp, "\n");
===== drivers/scsi/wd33c93.h 1.6 vs edited =====
--- 1.6/drivers/scsi/wd33c93.h	2003-05-12 16:26:16 +02:00
+++ edited/drivers/scsi/wd33c93.h	2004-06-20 18:01:32 +02:00
@@ -196,9 +196,9 @@
 } wd33c93_regs;
 
 
-typedef int (*dma_setup_t) (Scsi_Cmnd *SCpnt, int dir_in);
-typedef void (*dma_stop_t) (struct Scsi_Host *instance, Scsi_Cmnd *SCpnt,
-             int status);
+typedef int (*dma_setup_t) (struct scsi_cmnd *SCpnt, int dir_in);
+typedef void (*dma_stop_t) (struct Scsi_Host *instance,
+		struct scsi_cmnd *SCpnt, int status);
 
 
 #define ILLEGAL_STATUS_BYTE   0xff
@@ -234,10 +234,10 @@
     uchar            *dma_bounce_buffer;
     unsigned int     dma_bounce_len;
     volatile uchar   busy[8];          /* index = target, bit = lun */
-    volatile Scsi_Cmnd *input_Q;       /* commands waiting to be started */
-    volatile Scsi_Cmnd *selecting;     /* trying to select this command */
-    volatile Scsi_Cmnd *connected;     /* currently connected command */
-    volatile Scsi_Cmnd *disconnected_Q;/* commands waiting for reconnect */
+    volatile struct scsi_cmnd *input_Q;       /* commands waiting to be started */
+    volatile struct scsi_cmnd *selecting;     /* trying to select this command */
+    volatile struct scsi_cmnd *connected;     /* currently connected command */
+    volatile struct scsi_cmnd *disconnected_Q;/* commands waiting for reconnect */
     uchar            state;            /* what we are currently doing */
     uchar            dma;              /* current state of DMA (on/off) */
     uchar            level2;           /* extent to which Level-2 commands are used */
@@ -335,11 +335,12 @@
 
 void wd33c93_init (struct Scsi_Host *instance, const wd33c93_regs regs,
          dma_setup_t setup, dma_stop_t stop, int clock_freq);
-int wd33c93_abort (Scsi_Cmnd *cmd);
-int wd33c93_queuecommand (Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *));
+int wd33c93_abort (struct scsi_cmnd *cmd);
+int wd33c93_queuecommand (struct scsi_cmnd *cmd,
+		void (*done)(struct scsi_cmnd *));
 void wd33c93_intr (struct Scsi_Host *instance);
 int wd33c93_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
-int wd33c93_host_reset (Scsi_Cmnd *);
+int wd33c93_host_reset (struct scsi_cmnd *);
 void wd33c93_release(void);
 
 #endif /* WD33C93_H */
