From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] scsi-misc-2.5 remove some unused scsi_cmnd fields
Date: Wed, 12 Feb 2003 15:03:38 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030212150338.A6767@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Hi -

This patch against scsi-misc-2.5 removes some unused scsi_cmnd fields,
shrinking scsi_cmnd (on an x86) from 340 to 316 bytes.

The flags field and associated defines (WAS_RESET etc.) were primarily
used in the old scsi_obsolete.c code.

eh_state was not completey removed (well, removed and replaced by any
scsi_eh_eflags_*) to avoid conflicts with Mike A's scsi_error.c changes.

There might be an issue with DID_RESET handling in scsi_error.c
(independent of this patch).

--- 1.26/drivers/scsi/eata.c	Tue Feb  4 11:07:50 2003
+++ edited/drivers/scsi/eata.c	Wed Feb 12 14:05:05 2003
@@ -1757,16 +1757,12 @@
       if (inb(sh[j]->io_port + REG_AUX_STATUS) & IRQ_ASSERTED)
          printk("%s: abort, mbox %d, interrupt pending.\n", BN(j), i);
 
-      if (SCarg->eh_state == SCSI_STATE_TIMEOUT) {
-         unmap_dma(i, j);
-         SCarg->host_scribble = NULL;
-         HD(j)->cp_stat[i] = FREE;
-         printk("%s, abort, mbox %d, eh_state timeout, pid %ld.\n",
-                BN(j), i, SCarg->pid);
-         return SUCCESS;
-         }
-
-      return FAILED;
+      unmap_dma(i, j);
+      SCarg->host_scribble = NULL;
+      HD(j)->cp_stat[i] = FREE;
+      printk("%s, abort, mbox %d, eh_eflags timeout, pid %ld.\n",
+             BN(j), i, SCarg->pid);
+      return SUCCESS;
       }
 
    if (HD(j)->cp_stat[i] == IN_RESET) {
===== drivers/scsi/qla1280.c 1.30 vs edited =====
--- 1.30/drivers/scsi/qla1280.c	Fri Feb  7 00:20:35 2003
+++ edited/drivers/scsi/qla1280.c	Wed Feb 12 14:05:05 2003
@@ -1177,9 +1177,7 @@
 	sp = (srb_t *)CMD_SP(cmd);
 	sp->cmd = cmd;
 	cmd->scsi_done = fn;
-	if (cmd->flags == 0) {	/* new command */
-		sp->flags = 0;
-	}
+	sp->flags = 0;
 
 	qla1280_print_scsi_cmd(5, cmd);
 
===== drivers/scsi/scsi.c 1.91 vs edited =====
--- 1.91/drivers/scsi/scsi.c	Tue Feb 11 01:53:40 2003
+++ edited/drivers/scsi/scsi.c	Wed Feb 12 14:05:05 2003
@@ -602,7 +602,6 @@
 	SCpnt->serial_number_at_timeout = 0;
 	SCpnt->bufflen = SRpnt->sr_bufflen;
 	SCpnt->buffer = SRpnt->sr_buffer;
-	SCpnt->flags = 0;
 	SCpnt->retries = 0;
 	SCpnt->allowed = SRpnt->sr_allowed;
 	SCpnt->done = SRpnt->sr_done;
@@ -632,7 +631,6 @@
 
 	/* Start the timer ticking.  */
 
-	SCpnt->internal_timeout = NORMAL_TIMEOUT;
 	SCpnt->abort_reason = 0;
 	SCpnt->result = 0;
 
===== drivers/scsi/scsi.h 1.61 vs edited =====
--- 1.61/drivers/scsi/scsi.h	Tue Feb 11 01:57:35 2003
+++ edited/drivers/scsi/scsi.h	Wed Feb 12 14:05:05 2003
@@ -360,20 +360,6 @@
  */
 
 /*
- *  As the scsi do command functions are intelligent, and may need to
- *  redo a command, we need to keep track of the last command
- *  executed on each one.
- */
-
-#define WAS_RESET       0x01
-#define WAS_TIMEDOUT    0x02
-#define WAS_SENSE       0x04
-#define IS_RESETTING    0x08
-#define IS_ABORTING     0x10
-#define ASKED_FOR_SENSE 0x20
-#define SYNC_RESET      0x40
-
-/*
  * This specifies "machine infinity" for host templates which don't
  * limit the transfer size.  Note this limit represents an absolute
  * maximum, and may be over the transfer limits allowed for individual
@@ -726,7 +712,7 @@
 
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
 
-	int eh_state;		/* Used for state tracking in error handlr */
+	int eh_state;		/* to be removed */
 	int eh_eflags;		/* Used by error handlr */
 	void (*done) (struct scsi_cmnd *);	/* Mid-level done function */
 	/*
@@ -749,14 +735,6 @@
 	int retries;
 	int allowed;
 	int timeout_per_command;
-	int timeout_total;
-	int timeout;
-
-	/*
-	 * We handle the timeout differently if it happens when a reset, 
-	 * abort, etc are in process. 
-	 */
-	unsigned volatile char internal_timeout;
 	struct scsi_cmnd *bh_next;	/* To enumerate the commands waiting 
 					   to be processed. */
 	unsigned char cmd_len;
@@ -804,16 +782,6 @@
 						 * when CHECK CONDITION is
 						 * received on original command 
 						 * (auto-sense) */
-
-	unsigned flags;
-
-	/*
-	 * Used to indicate that a command which has timed out also
-	 * completed normally.  Typically the completion function will
-	 * do nothing but set this flag in this instance because the
-	 * timeout handler is already running.
-	 */
-	unsigned done_late:1;
 
 	/* Low-level done function - can be used by low-level driver to point
 	 *        to completion function.  Not used by mid/upper level code. */
===== drivers/scsi/scsi_error.c 1.33 vs edited =====
--- 1.33/drivers/scsi/scsi_error.c	Sun Feb  9 07:35:26 2003
+++ edited/drivers/scsi/scsi_error.c	Wed Feb 12 14:05:06 2003
@@ -360,22 +360,9 @@
 	 * that would indicate what we need to do.
 	 */
 	if (host_byte(scmd->result) == DID_RESET) {
-		if (scmd->flags & IS_RESETTING) {
-			/*
-			 * ok, this is normal.  we don't know whether in fact
-			 * the command in question really needs to be rerun
-			 * or not - if this was the original data command then
-			 * the answer is yes, otherwise we just flag it as
-			 * SUCCESS.
-			 */
-			scmd->flags &= ~IS_RESETTING;
-			return NEEDS_RETRY;
-		}
 		/*
-		 * rats.  we are already in the error handler, so we now
-		 * get to try and figure out what to do next.  if the sense
-		 * is valid, we have a pretty good idea of what to do.
-		 * if not, we mark it as FAILED.
+		 * XXX should this: set or check sdev->was_reset? check
+		 * sdev->expecting_cc_ua? call scsi_check_sense?
 		 */
 		return scsi_check_sense(scmd);
 	}
@@ -1287,10 +1274,11 @@
 		 * in the normal case where we haven't initiated a reset,
 		 * this is a failure.
 		 */
-		if (scmd->flags & IS_RESETTING) {
-			scmd->flags &= ~IS_RESETTING;
-			goto maybe_retry;
-		}
+		/*
+		 * XXX should this: set or check sdev->was_reset? check
+		 * sdev->expecting_cc_ua? call scsi_check_sense, and
+		 * conditionally goto retry?
+		 */
 		return SUCCESS;
 	default:
 		return FAILED;
@@ -1764,7 +1752,6 @@
 	SCpnt->request_buffer		= NULL;
 	SCpnt->request_bufflen		= 0;
 
-	SCpnt->internal_timeout		= NORMAL_TIMEOUT;
 	SCpnt->abort_reason		= DID_ABORT;
 
 	SCpnt->cmd_len			= 0;
===== drivers/scsi/scsi_lib.c 1.69 vs edited =====
--- 1.69/drivers/scsi/scsi_lib.c	Tue Feb 11 03:25:56 2003
+++ edited/drivers/scsi/scsi_lib.c	Wed Feb 12 14:05:06 2003
@@ -263,7 +263,6 @@
 	cmd->reset_chain = NULL;
 	cmd->serial_number = 0;
 	cmd->serial_number_at_timeout = 0;
-	cmd->flags = 0;
 	cmd->retries = 0;
 	cmd->abort_reason = 0;
 
@@ -287,7 +286,6 @@
 	cmd->buffer = cmd->request_buffer;
 	cmd->bufflen = cmd->request_bufflen;
 	cmd->reset_chain = NULL;
-	cmd->internal_timeout = NORMAL_TIMEOUT;
 	cmd->abort_reason = 0;
 
 	return 1;
===== drivers/scsi/scsi_proc.c 1.16 vs edited =====
--- 1.16/drivers/scsi/scsi_proc.c	Sun Feb  9 07:35:26 2003
+++ edited/drivers/scsi/scsi_proc.c	Wed Feb 12 14:05:06 2003
@@ -364,7 +364,7 @@
 			spin_lock_irqsave(&SDpnt->list_lock, flags);
 			list_for_each_entry(SCpnt, &SDpnt->cmd_list, list) {
 				/*  (0) h:c:t:l (dev sect nsect cnumsec sg) (ret all flg) (to/cmd to ito) cmd snse result %d %x      */
-				printk(KERN_INFO "(%3d) %2d:%1d:%2d:%2d (%6s %4llu %4ld %4ld %4x %1d) (%1d %1d 0x%2x) (%4d %4d %4d) 0x%2.2x 0x%2.2x 0x%8.8x\n",
+				printk(KERN_INFO "(%3d) %2d:%1d:%2d:%2d (%6s %4llu %4ld %4ld %4x %1d) (%1d %1d) (%4d) 0x%2.2x 0x%2.2x 0x%8.8x\n",
 				       i++,
 
 				       SCpnt->device->host->host_no,
@@ -382,11 +382,8 @@
 
 				       SCpnt->retries,
 				       SCpnt->allowed,
-				       SCpnt->flags,
 
 				       SCpnt->timeout_per_command,
-				       SCpnt->timeout,
-				       SCpnt->internal_timeout,
 
 				       SCpnt->cmnd[0],
 				       SCpnt->sense_buffer[2],
===== drivers/scsi/u14-34f.c 1.22 vs edited =====
--- 1.22/drivers/scsi/u14-34f.c	Tue Feb  4 11:07:38 2003
+++ edited/drivers/scsi/u14-34f.c	Wed Feb 12 14:05:06 2003
@@ -1327,16 +1327,12 @@
       if (inb(sh[j]->io_port + REG_SYS_INTR) & IRQ_ASSERTED)
          printk("%s: abort, mbox %d, interrupt pending.\n", BN(j), i);
 
-      if (SCarg->eh_state == SCSI_STATE_TIMEOUT) {
-         unmap_dma(i, j);
-         SCarg->host_scribble = NULL;
-         HD(j)->cp_stat[i] = FREE;
-         printk("%s, abort, mbox %d, eh_state timeout, pid %ld.\n",
-                BN(j), i, SCarg->pid);
-         return SUCCESS;
-         }
-
-      return FAILED;
+      unmap_dma(i, j);
+      SCarg->host_scribble = NULL;
+      HD(j)->cp_stat[i] = FREE;
+      printk("%s, abort, mbox %d, eh_eflags timeout, pid %ld.\n",
+             BN(j), i, SCarg->pid);
+      return SUCCESS;
       }
 
    if (HD(j)->cp_stat[i] == IN_RESET) {

-- Patrick Mansfield
