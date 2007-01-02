From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] sym2: streamlinke queuecommand path
Date: Tue, 2 Jan 2007 17:37:48 +0100
Message-ID: <20070102163748.GA17602@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:49260 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366AbXABQhv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jan 2007 11:37:51 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org

Merge sym_queue_command, sym_setup_cdb and sym_setup_data_and_start into
sym53c8xx_queue_command.  Rename sym_queue_scsiio into sym_init_scsiio
now that it doesn't start I/O anymore but is simply a helper for
sym53c8xx_queue_command.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-11-02 15:44:10.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c	2007-01-02 17:24:56.000000000 +0100
@@ -401,15 +401,38 @@
 }
 
 /*
- *  Queue a SCSI command.
+ * queuecommand method.  Entered with the host adapter lock held and
+ * interrupts disabled.
  */
-static int sym_queue_command(struct sym_hcb *np, struct scsi_cmnd *cmd)
+static int sym53c8xx_queue_command(struct scsi_cmnd *cmd,
+					void (*done)(struct scsi_cmnd *))
 {
 	struct scsi_device *sdev = cmd->device;
+	struct sym_hcb *np = SYM_SOFTC_PTR(cmd);
+	struct sym_ucmd *ucp = SYM_UCMD_PTR(cmd);
 	struct sym_tcb *tp;
 	struct sym_lcb *lp;
 	struct sym_ccb *cp;
-	int	order;
+	u32 lastp, goalp;
+	int dir, order;
+
+	cmd->scsi_done     = done;
+	memset(ucp, 0, sizeof(*ucp));
+
+	/*
+	 *  Shorten our settle_time if needed for
+	 *  this command not to time out.
+	 */
+	if (np->s.settle_time_valid && cmd->timeout_per_command) {
+		unsigned long tlimit = jiffies + cmd->timeout_per_command;
+		tlimit -= SYM_CONF_TIMER_INTERVAL*2;
+		if (time_after(np->s.settle_time, tlimit)) {
+			np->s.settle_time = tlimit;
+		}
+	}
+
+	if (np->s.settle_time_valid)
+		return SCSI_MLQUEUE_HOST_BUSY;
 
 	/*
 	 *  Minimal checkings, so that we will not 
@@ -436,38 +459,13 @@
 	 */
 	cp = sym_get_ccb(np, cmd, order);
 	if (!cp)
-		return 1;	/* Means resource shortage */
-	sym_queue_scsiio(np, cmd, cp);
-	return 0;
-}
+		return SCSI_MLQUEUE_HOST_BUSY;
+	sym_init_scsiio(np, cmd, cp);
 
-/*
- *  Setup buffers and pointers that address the CDB.
- */
-static inline int sym_setup_cdb(struct sym_hcb *np, struct scsi_cmnd *cmd, struct sym_ccb *cp)
-{
 	memcpy(cp->cdb_buf, cmd->cmnd, cmd->cmd_len);
-
 	cp->phys.cmd.addr = CCB_BA(cp, cdb_buf[0]);
 	cp->phys.cmd.size = cpu_to_scr(cmd->cmd_len);
 
-	return 0;
-}
-
-/*
- *  Setup pointers that address the data and start the I/O.
- */
-int sym_setup_data_and_start(struct sym_hcb *np, struct scsi_cmnd *cmd, struct sym_ccb *cp)
-{
-	u32 lastp, goalp;
-	int dir;
-
-	/*
-	 *  Build the CDB.
-	 */
-	if (sym_setup_cdb(np, cmd, cp))
-		goto out_abort;
-
 	/*
 	 *  No direction means no data.
 	 */
@@ -615,41 +613,6 @@
 }
 
 /*
- * queuecommand method.  Entered with the host adapter lock held and
- * interrupts disabled.
- */
-static int sym53c8xx_queue_command(struct scsi_cmnd *cmd,
-					void (*done)(struct scsi_cmnd *))
-{
-	struct sym_hcb *np = SYM_SOFTC_PTR(cmd);
-	struct sym_ucmd *ucp = SYM_UCMD_PTR(cmd);
-	int sts = 0;
-
-	cmd->scsi_done     = done;
-	memset(ucp, 0, sizeof(*ucp));
-
-	/*
-	 *  Shorten our settle_time if needed for 
-	 *  this command not to time out.
-	 */
-	if (np->s.settle_time_valid && cmd->timeout_per_command) {
-		unsigned long tlimit = jiffies + cmd->timeout_per_command;
-		tlimit -= SYM_CONF_TIMER_INTERVAL*2;
-		if (time_after(np->s.settle_time, tlimit)) {
-			np->s.settle_time = tlimit;
-		}
-	}
-
-	if (np->s.settle_time_valid)
-		return SCSI_MLQUEUE_HOST_BUSY;
-
-	sts = sym_queue_command(np, cmd);
-	if (sts)
-		return SCSI_MLQUEUE_HOST_BUSY;
-	return 0;
-}
-
-/*
  *  Linux entry point of the interrupt handler.
  */
 static irqreturn_t sym53c8xx_intr(int irq, void *dev_id)
Index: scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sym53c8xx_2/sym_glue.h	2006-07-07 14:39:00.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h	2007-01-02 17:26:54.000000000 +0100
@@ -264,7 +264,6 @@
 #define sym_print_addr(cmd, arg...) dev_info(&cmd->device->sdev_gendev , ## arg)
 void sym_xpt_async_bus_reset(struct sym_hcb *np);
 void sym_xpt_async_sent_bdr(struct sym_hcb *np, int target);
-int  sym_setup_data_and_start (struct sym_hcb *np, struct scsi_cmnd *csio, struct sym_ccb *cp);
 void sym_log_bus_error(struct sym_hcb *np);
 
 #endif /* SYM_GLUE_H */
Index: scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sym53c8xx_2/sym_hipd.c	2006-06-24 19:48:44.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c	2007-01-02 17:27:21.000000000 +0100
@@ -5030,7 +5030,7 @@
 /*
  *  Queue a SCSI IO to the controller.
  */
-int sym_queue_scsiio(struct sym_hcb *np, struct scsi_cmnd *cmd, struct sym_ccb *cp)
+void sym_init_scsiio(struct sym_hcb *np, struct scsi_cmnd *cmd, struct sym_ccb *cp)
 {
 	struct scsi_device *sdev = cmd->device;
 	struct sym_tcb *tp;
@@ -5155,12 +5155,6 @@
 	 */
 	cp->ext_sg  = -1;
 	cp->ext_ofs = 0;
-
-	/*
-	 *  Build the CDB and DATA descriptor block 
-	 *  and start the IO.
-	 */
-	return sym_setup_data_and_start(np, cmd, cp);
 }
 
 /*
Index: scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sym53c8xx_2/sym_hipd.h	2006-06-02 18:20:23.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h	2007-01-02 17:27:24.000000000 +0100
@@ -1058,7 +1058,7 @@
 struct sym_ccb *sym_get_ccb(struct sym_hcb *np, struct scsi_cmnd *cmd, u_char tag_order);
 void sym_free_ccb(struct sym_hcb *np, struct sym_ccb *cp);
 struct sym_lcb *sym_alloc_lcb(struct sym_hcb *np, u_char tn, u_char ln);
-int sym_queue_scsiio(struct sym_hcb *np, struct scsi_cmnd *csio, struct sym_ccb *cp);
+void sym_init_scsiio(struct sym_hcb *np, struct scsi_cmnd *csio, struct sym_ccb *cp);
 int sym_abort_scsiio(struct sym_hcb *np, struct scsi_cmnd *ccb, int timed_out);
 int sym_reset_scsi_target(struct sym_hcb *np, int target);
 void sym_hcb_free(struct sym_hcb *np);
