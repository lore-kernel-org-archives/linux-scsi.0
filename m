From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] wd7000 updates
Date: Mon, 21 Jun 2004 16:25:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621142515.GA32007@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:35536 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264165AbUFUOZj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 10:25:39 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Avoid old APIs and fix a bad bug were the irq handler argument was
derefenced as struct Scsi_Host * instead of Adpater * which made the
driver instantly crash on SMP.


--- 1.31/drivers/scsi/wd7000.c	2004-06-15 17:49:13 +02:00
+++ edited/drivers/scsi/wd7000.c	2004-06-20 18:20:06 +02:00
@@ -183,7 +183,9 @@
 #include <asm/dma.h>
 #include <asm/io.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsicam.h>
 
@@ -218,7 +220,7 @@
  *  In this version, sg_tablesize now defaults to WD7000_SG, and will
  *  be set to SG_NONE for older boards.  This is the reverse of the
  *  previous default, and was changed so that the driver-level
- *  Scsi_Host_Template would reflect the driver's support for scatter/
+ *  scsi_host_template would reflect the driver's support for scatter/
  *  gather.
  *
  *  Also, it has been reported that boards at Revision 6 support scatter/
@@ -435,8 +437,8 @@
  *  carrying SCB addresses to/from the 7000-FASST2.
  *
  *  Note also since SCBs are not "permanently" associated with mailboxes,
- *  there is no need to keep a global list of Scsi_Cmnd pointers indexed
- *  by OGMB.   Again, SCBs reference their Scsi_Cmnds directly, so mailbox
+ *  there is no need to keep a global list of scsi_cmnd pointers indexed
+ *  by OGMB.   Again, SCBs reference their scsi_cmnds directly, so mailbox
  *  indices need not be involved.
  */
 
@@ -463,7 +465,7 @@
 	unchar direc;		/* Transfer Direction                        */
 	unchar reserved2[6];	/* SCSI Command Descriptor Block             */
 	/* end of hardware SCB                       */
-	Scsi_Cmnd *SCpnt;	/* Scsi_Cmnd using this SCB                  */
+	struct scsi_cmnd *SCpnt;/* scsi_cmnd using this SCB                  */
 	Sgb sgb[WD7000_SG];	/* Scatter/gather list for this SCB          */
 	Adapter *host;		/* host adapter                              */
 	struct scb *next;	/* for lists of scbs                         */
@@ -799,8 +801,8 @@
 
 static inline short WAIT(unsigned port, unsigned mask, unsigned allof, unsigned noneof)
 {
-	register unsigned WAITbits;
-	register unsigned long WAITtimeout = jiffies + WAITnexttimeout;
+	unsigned WAITbits;
+	unsigned long WAITtimeout = jiffies + WAITnexttimeout;
 
 	while (time_before_eq(jiffies, WAITtimeout)) {
 		WAITbits = inb(port) & mask;
@@ -846,10 +848,10 @@
  */
 static inline Scb *alloc_scbs(struct Scsi_Host *host, int needed)
 {
-	register Scb *scb, *p = NULL;
+	Scb *scb, *p = NULL;
 	unsigned long flags;
-	register unsigned long timeout = jiffies + WAITnexttimeout;
-	register unsigned long now;
+	unsigned long timeout = jiffies + WAITnexttimeout;
+	unsigned long now;
 	int i;
 
 	if (needed <= 0)
@@ -936,7 +938,7 @@
  *  Note: this can also be used for ICBs; just cast to the parm type.
  */
 {
-	register int i, ogmb;
+	int i, ogmb;
 	unsigned long flags;
 	unchar start_ogmb;
 	Mailbox *ogmbs = host->mb.ogmb;
@@ -1034,23 +1036,26 @@
 
 #define wd7000_intr_ack(host)   outb (0, host->iobase + ASC_INTR_ACK)
 
-static void wd7000_intr_handle(int irq, void *dev_id, struct pt_regs *regs)
+
+static irqreturn_t wd7000_intr(int irq, void *dev_id, struct pt_regs *regs)
 {
-	register int flag, icmb, errstatus, icmb_status;
-	register int host_error, scsi_error;
-	register Scb *scb;	/* for SCSI commands */
-	register IcbAny *icb;	/* for host commands */
-	register Scsi_Cmnd *SCpnt;
 	Adapter *host = (Adapter *) dev_id;
+	int flag, icmb, errstatus, icmb_status;
+	int host_error, scsi_error;
+	Scb *scb;	/* for SCSI commands */
+	IcbAny *icb;	/* for host commands */
+	struct scsi_cmnd *SCpnt;
 	Mailbox *icmbs = host->mb.icmb;
+	unsigned long flags;
 
+	spin_lock_irqsave(host->sh->host_lock, flags);
 	host->int_counter++;
 
-	dprintk("wd7000_intr_handle: irq = %d, host = 0x%06lx\n", irq, (long) host);
+	dprintk("wd7000_intr: irq = %d, host = 0x%06lx\n", irq, (long) host);
 
 	flag = inb(host->iobase + ASC_INTR_STAT);
 
-	dprintk("wd7000_intr_handle: intr stat = 0x%02x\n", flag);
+	dprintk("wd7000_intr: intr stat = 0x%02x\n", flag);
 
 	if (!(inb(host->iobase + ASC_STAT) & INT_IM)) {
 		/* NB: these are _very_ possible if IRQ 15 is being used, since
@@ -1061,79 +1066,70 @@
 		 * can sort these out.  Otherwise, electrical noise and other such
 		 * problems would be indistinguishable from valid interrupts...
 		 */
-		dprintk("wd7000_intr_handle: phantom interrupt...\n");
-		wd7000_intr_ack(host);
-		return;
+		dprintk("wd7000_intr: phantom interrupt...\n");
+		goto ack;
 	}
 
-	if (flag & MB_INTR) {
-		/* The interrupt is for a mailbox */
-		if (!(flag & IMB_INTR)) {
-			dprintk("wd7000_intr_handle: free outgoing mailbox\n");
-			/*
-			 * If sleep_on() and the "interrupt on free OGMB" command are
-			 * used in mail_out(), wake_up() should correspondingly be called
-			 * here.  For now, we don't need to do anything special.
-			 */
-			wd7000_intr_ack(host);
-			return;
-		} else {
-			/* The interrupt is for an incoming mailbox */
-			icmb = flag & MB_MASK;
-			icmb_status = icmbs[icmb].status;
-			if (icmb_status & 0x80) {	/* unsolicited - result in ICMB */
-				dprintk("wd7000_intr_handle: unsolicited interrupt 0x%02x\n", icmb_status);
-				wd7000_intr_ack(host);
-				return;
-			}
-			/* Aaaargh! (Zaga) */
-			scb = isa_bus_to_virt(scsi2int((unchar *) icmbs[icmb].scbptr));
-			icmbs[icmb].status = 0;
-			if (!(scb->op & ICB_OP_MASK)) {	/* an SCB is done */
-				SCpnt = scb->SCpnt;
-				if (--(SCpnt->SCp.phase) <= 0) {	/* all scbs are done */
-					host_error = scb->vue | (icmb_status << 8);
-					scsi_error = scb->status;
-					errstatus = make_code(host_error, scsi_error);
-					SCpnt->result = errstatus;
+	if (!(flag & MB_INTR))
+		goto ack;
 
-					free_scb(scb);
+	/* The interrupt is for a mailbox */
+	if (!(flag & IMB_INTR)) {
+		dprintk("wd7000_intr: free outgoing mailbox\n");
+		/*
+		 * If sleep_on() and the "interrupt on free OGMB" command are
+		 * used in mail_out(), wake_up() should correspondingly be called
+		 * here.  For now, we don't need to do anything special.
+		 */
+		goto ack;
+	}
 
-					SCpnt->scsi_done(SCpnt);
-				}
-			} else {	/* an ICB is done */
-				icb = (IcbAny *) scb;
-				icb->status = icmb_status;
-				icb->phase = 0;
-			}
-		}		/* incoming mailbox */
+	/* The interrupt is for an incoming mailbox */
+	icmb = flag & MB_MASK;
+	icmb_status = icmbs[icmb].status;
+	if (icmb_status & 0x80) {	/* unsolicited - result in ICMB */
+		dprintk("wd7000_intr: unsolicited interrupt 0x%02x\n", icmb_status);
+		goto ack;
 	}
 
-	wd7000_intr_ack(host);
+	/* Aaaargh! (Zaga) */
+	scb = isa_bus_to_virt(scsi2int((unchar *) icmbs[icmb].scbptr));
+	icmbs[icmb].status = 0;
+	if (scb->op & ICB_OP_MASK) {	/* an SCB is done */
+		icb = (IcbAny *) scb;
+		icb->status = icmb_status;
+		icb->phase = 0;
+		goto ack;
+	}
 
-	dprintk("wd7000_intr_handle: return from interrupt handler\n");
-}
+	SCpnt = scb->SCpnt;
+	if (--(SCpnt->SCp.phase) <= 0) {	/* all scbs are done */
+		host_error = scb->vue | (icmb_status << 8);
+		scsi_error = scb->status;
+		errstatus = make_code(host_error, scsi_error);
+		SCpnt->result = errstatus;
 
-static irqreturn_t do_wd7000_intr_handle(int irq, void *dev_id,
-					struct pt_regs *regs)
-{
-	unsigned long flags;
-	struct Scsi_Host *host = dev_id;
+		free_scb(scb);
 
-	spin_lock_irqsave(host->host_lock, flags);
-	wd7000_intr_handle(irq, dev_id, regs);
-	spin_unlock_irqrestore(host->host_lock, flags);
+		SCpnt->scsi_done(SCpnt);
+	}
+
+ ack:
+	dprintk("wd7000_intr: return from interrupt handler\n");
+	wd7000_intr_ack(host);
+
+	spin_unlock_irqrestore(host->sh->host_lock, flags);
 	return IRQ_HANDLED;
 }
 
-
-static int wd7000_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
+static int wd7000_queuecommand(struct scsi_cmnd *SCpnt,
+		void (*done)(struct scsi_cmnd *))
 {
-	register Scb *scb;
-	register Sgb *sgb;
-	register unchar *cdb = (unchar *) SCpnt->cmnd;
-	register unchar idlun;
-	register short cdblen;
+	Scb *scb;
+	Sgb *sgb;
+	unchar *cdb = (unchar *) SCpnt->cmnd;
+	unchar idlun;
+	short cdblen;
 	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
 
 	cdblen = SCpnt->cmd_len;
@@ -1293,7 +1289,7 @@
 		return 0;
 
 
-	if (request_irq(host->irq, do_wd7000_intr_handle, SA_INTERRUPT, "wd7000", host)) {
+	if (request_irq(host->irq, wd7000_intr, SA_INTERRUPT, "wd7000", host)) {
 		printk("wd7000_init: can't get IRQ %d.\n", host->irq);
 		return (0);
 	}
@@ -1434,7 +1430,7 @@
  *
  */
 
-static int wd7000_detect(Scsi_Host_Template * tpnt)
+static int wd7000_detect(struct scsi_host_template *tpnt)
 {
 	short present = 0, biosaddr_ptr, sig_ptr, i, pass;
 	short biosptr[NUM_CONFIGS];
@@ -1623,24 +1619,10 @@
 #endif
 
 /*
- *  I also have no idea how to do a reset...
- */
-
-static int wd7000_bus_reset(Scsi_Cmnd * SCpnt)
-{
-	return FAILED;
-}
-
-static int wd7000_device_reset(Scsi_Cmnd * SCpnt)
-{
-	return FAILED;
-}
-
-/*
  *  Last resort. Reinitialize the board.
  */
 
-static int wd7000_host_reset(Scsi_Cmnd * SCpnt)
+static int wd7000_host_reset(struct scsi_cmnd *SCpnt)
 {
 	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
 
@@ -1650,7 +1632,6 @@
 	return SUCCESS;
 }
 
-
 /*
  *  This was borrowed directly from aha1542.c. (Zaga)
  */
@@ -1706,15 +1687,13 @@
 MODULE_DESCRIPTION("Driver for the WD7000 series ISA controllers");
 MODULE_LICENSE("GPL");
 
-static Scsi_Host_Template driver_template = {
+static struct scsi_host_template driver_template = {
 	.proc_name		= "wd7000",
 	.proc_info		= wd7000_proc_info,
 	.name			= "Western Digital WD-7000",
 	.detect			= wd7000_detect,
 	.release		= wd7000_release,
 	.queuecommand		= wd7000_queuecommand,
-	.eh_bus_reset_handler	= wd7000_bus_reset,
-	.eh_device_reset_handler = wd7000_device_reset,
 	.eh_host_reset_handler	= wd7000_host_reset,
 	.bios_param		= wd7000_biosparam,
 	.can_queue		= WD7000_Q,
