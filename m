From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] avoid obsolete scsi APIs in eata_pio
Date: Mon, 7 Jun 2004 12:26:26 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040607102626.GA13137@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:19678 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264385AbUFGK0a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2004 06:26:30 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.4/drivers/scsi/eata_generic.h	2003-01-03 19:58:49 +01:00
+++ edited/drivers/scsi/eata_generic.h	2004-06-07 12:19:05 +02:00
@@ -317,7 +317,7 @@
     __u8 rw_latency;
     __u8 retries;
     __u8 status;	      /* status of this queueslot		*/
-    Scsi_Cmnd *cmd;	      /* address of cmd				*/
+    struct scsi_cmnd *cmd;    /* address of cmd				*/
     struct eata_sg_list *sg_list;
 };
 
--- 1.24/drivers/scsi/eata_pio.c	2004-05-12 17:46:20 +02:00
+++ edited/drivers/scsi/eata_pio.c	2004-06-07 12:22:42 +02:00
@@ -46,6 +46,7 @@
  *  last change: 2002/11/02               OS: Linux 2.5.45  *
  ************************************************************/
 
+#include <linux/config.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -56,15 +57,14 @@
 #include <linux/pci.h>
 #include <linux/proc_fs.h>
 #include <linux/interrupt.h>
-#include <linux/stat.h>
-#include <linux/config.h>
 #include <linux/blkdev.h>
 #include <linux/spinlock.h>
 #include <asm/io.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsicam.h>
 
 #include "eata_generic.h"
 #include "eata_pio.h"
@@ -91,6 +91,8 @@
 static unsigned long int_counter;
 static unsigned long queue_counter;
 
+static struct scsi_host_template driver_template;
+
 /*
  * eata_proc_info
  * inout : decides on the direction of the dataflow and the meaning of the 
@@ -170,15 +172,15 @@
 		if (sh->io_port && sh->n_io_port)
 			release_region(sh->io_port, sh->n_io_port);
 	}
-	return (TRUE);
+	return 1;
 }
 
-static void IncStat(Scsi_Pointer * SCp, uint Increment)
+static void IncStat(struct scsi_pointer *SCp, uint Increment)
 {
 	SCp->ptr += Increment;
 	if ((SCp->this_residual -= Increment) == 0) {
 		if ((--SCp->buffers_residual) == 0)
-			SCp->Status = FALSE;
+			SCp->Status = 0;
 		else {
 			SCp->buffer++;
 			SCp->ptr = page_address(SCp->buffer->page) + SCp->buffer->offset;
@@ -204,7 +206,7 @@
 static void eata_pio_int_handler(int irq, void *dev_id, struct pt_regs *regs)
 {
 	uint eata_stat = 0xfffff;
-	Scsi_Cmnd *cmd;
+	struct scsi_cmnd *cmd;
 	hostdata *hd;
 	struct eata_ccb *cp;
 	uint base;
@@ -233,12 +235,12 @@
 			if (stat & HA_SDRQ) {
 				if (cp->DataIn) {
 					z = 256;
-					odd = FALSE;
+					odd = 0;
 					while ((cmd->SCp.Status) && ((z > 0) || (odd))) {
 						if (odd) {
 							*(cmd->SCp.ptr) = zwickel >> 8;
 							IncStat(&cmd->SCp, 1);
-							odd = FALSE;
+							odd = 0;
 						}
 						x = min_t(unsigned int, z, cmd->SCp.this_residual / 2);
 						insw(base + HA_RDATA, cmd->SCp.ptr, x);
@@ -249,7 +251,7 @@
 							*(cmd->SCp.ptr) = zwickel & 0xff;
 							IncStat(&cmd->SCp, 1);
 							z--;
-							odd = TRUE;
+							odd = 1;
 						}
 					}
 					while (z > 0) {
@@ -258,7 +260,7 @@
 					}
 				} else {	/* cp->DataOut */
 
-					odd = FALSE;
+					odd = 0;
 					z = 256;
 					while ((cmd->SCp.Status) && ((z > 0) || (odd))) {
 						if (odd) {
@@ -266,7 +268,7 @@
 							IncStat(&cmd->SCp, 1);
 							outw(zwickel, base + HA_RDATA);
 							z--;
-							odd = FALSE;
+							odd = 0;
 						}
 						x = min_t(unsigned int, z, cmd->SCp.this_residual / 2);
 						outsw(base + HA_RDATA, cmd->SCp.ptr, x);
@@ -276,13 +278,13 @@
 							zwickel = *(cmd->SCp.ptr);
 							zwickel &= 0xff;
 							IncStat(&cmd->SCp, 1);
-							odd = TRUE;
+							odd = 1;
 						}
 					}
 					while (z > 0 || odd) {
 						outw(zwickel, base + HA_RDATA);
 						z--;
-						odd = FALSE;
+						odd = 0;
 					}
 				}
 			}
@@ -331,7 +333,7 @@
 
 	while (inb(base + HA_RSTATUS) & HA_SBUSY)
 		if (--loop == 0)
-			return (TRUE);
+			return 1;
 
 	/* Enable interrupts for HBA.  It is not the best way to do it at this
 	 * place, but I hope that it doesn't interfere with the IDE driver 
@@ -340,10 +342,11 @@
 	outb(HA_CTRL_8HEADS, base + HA_CTRLREG);
 
 	outb(command, base + HA_WCOMMAND);
-	return (FALSE);
+	return 0;
 }
 
-static int eata_pio_queue(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
+static int eata_pio_queue(struct scsi_cmnd *cmd,
+		void (*done)(struct scsi_cmnd *))
 {
 	uint x, y;
 	uint base;
@@ -383,21 +386,21 @@
 
 	cmd->scsi_done = (void *) done;
 
-	if(cmd->sc_data_direction == SCSI_DATA_WRITE)
-		cp->DataOut = TRUE;	/* Output mode */
+	if (cmd->sc_data_direction == DMA_TO_DEVICE)
+		cp->DataOut = 1;	/* Output mode */
 	else
-		cp->DataIn = TRUE;	/* Input mode  */
+		cp->DataIn = 0;	/* Input mode  */
 
 	cp->Interpret = (cmd->device->id == hd->hostid);
 	cp->cp_datalen = htonl((unsigned long) cmd->request_bufflen);
-	cp->Auto_Req_Sen = FALSE;
+	cp->Auto_Req_Sen = 0;
 	cp->cp_reqDMA = htonl(0);
 	cp->reqlen = 0;
 
 	cp->cp_id = cmd->device->id;
 	cp->cp_lun = cmd->device->lun;
-	cp->cp_dispri = FALSE;
-	cp->cp_identify = TRUE;
+	cp->cp_dispri = 0;
+	cp->cp_identify = 1;
 	memcpy(cp->cp_cdb, cmd->cmnd, COMMAND_SIZE(*cmd->cmnd));
 
 	cp->cp_statDMA = htonl(0);
@@ -440,7 +443,7 @@
 	return (0);
 }
 
-static int eata_pio_abort(Scsi_Cmnd * cmd)
+static int eata_pio_abort(struct scsi_cmnd *cmd)
 {
 	uint loop = HZ;
 
@@ -472,11 +475,11 @@
 	panic("eata_pio: abort: invalid slot status\n");
 }
 
-static int eata_pio_host_reset(Scsi_Cmnd * cmd)
+static int eata_pio_host_reset(struct scsi_cmnd *cmd)
 {
 	uint x, limit = 0;
-	unsigned char success = FALSE;
-	Scsi_Cmnd *sp;
+	unsigned char success = 0;
+	struct scsi_cmnd *sp;
 	struct Scsi_Host *host = cmd->device->host;
 
 	DBG(DBG_ABNORM, printk(KERN_WARNING "eata_pio_reset called pid:%ld target:" " %x lun: %x reason %x\n", cmd->pid, cmd->device->id, cmd->device->lun, cmd->abort_reason));
@@ -530,7 +533,7 @@
 		sp->scsi_done(sp);
 	}
 
-	HD(cmd)->state = FALSE;
+	HD(cmd)->state = 0;
 
 	if (success) {		/* hmmm... */
 		DBG(DBG_ABNORM, printk(KERN_WARNING "eata_pio_reset: exit, success.\n"));
@@ -550,8 +553,8 @@
 	memset(&cp, 0, sizeof(struct eata_ccb));
 	memset(buff, 0, sizeof(buff));
 
-	cp.DataIn = TRUE;
-	cp.Interpret = TRUE;	/* Interpret command */
+	cp.DataIn = 1;
+	cp.Interpret = 1;	/* Interpret command */
 
 	cp.cp_datalen = htonl(254);
 	cp.cp_dataDMA = htonl(0);
@@ -630,7 +633,7 @@
 	while (inb(base + HA_RSTATUS) & HA_SDRQ)
 		inw(base + HA_RDATA);
 
-	if (ALLOW_DMA_BOARDS == FALSE) {
+	if (!ALLOW_DMA_BOARDS) {
 		for (z = 0; z < MAXISA; z++)
 			if (base == ISAbases[z]) {
 				buf->IRQ = ISAirqs[z];
@@ -680,7 +683,7 @@
 	return (!(inb(base + HA_RSTATUS) & HA_SERROR));
 }
 
-static int register_pio_HBA(long base, struct get_conf *gc, Scsi_Host_Template * tpnt)
+static int register_pio_HBA(long base, struct get_conf *gc)
 {
 	unsigned long size = 0;
 	char *buff;
@@ -691,10 +694,10 @@
 
 	DBG(DBG_REGISTER, print_pio_config(gc));
 
-	if (gc->DMA_support == TRUE) {
+	if (gc->DMA_support) {
 		printk("HBA at %#.4lx supports DMA. Please use EATA-DMA driver.\n", base);
-		if (ALLOW_DMA_BOARDS == FALSE)
-			return (FALSE);
+		if (!ALLOW_DMA_BOARDS)
+			return 0;
 	}
 
 	if ((buff = get_pio_board_data((uint) base, gc->IRQ, gc->scsi_id[3], cplen = (htonl(gc->cplen) + 1) / 2, cppadlen = (htons(gc->cppadlen) + 1) / 2)) == NULL) {
@@ -702,14 +705,14 @@
 		return 0;
 	}
 
-	if (print_selftest(base) == FALSE && ALLOW_DMA_BOARDS == FALSE) {
+	if (!print_selftest(base) && !ALLOW_DMA_BOARDS) {
 		printk("HBA at %#lx failed while performing self test & setup.\n", (unsigned long) base);
 		return 0;
 	}
 
 	size = sizeof(hostdata) + (sizeof(struct eata_ccb) * ntohs(gc->queuesiz));
 
-	sh = scsi_register(tpnt, size);
+	sh = scsi_register(&driver_template, size);
 	if (sh == NULL)
 		return 0;
 
@@ -717,13 +720,13 @@
 		if (!request_irq(gc->IRQ, do_eata_pio_int_handler, SA_INTERRUPT, "EATA-PIO", sh)) {
 			reg_IRQ[gc->IRQ]++;
 			if (!gc->IRQ_TR)
-				reg_IRQL[gc->IRQ] = TRUE;	/* IRQ is edge triggered */
+				reg_IRQL[gc->IRQ] = 1;	/* IRQ is edge triggered */
 		} else {
 			printk("Couldn't allocate IRQ %d, Sorry.\n", gc->IRQ);
 			return 0;
 		}
 	} else {		/* More than one HBA on this IRQ */
-		if (reg_IRQL[gc->IRQ] == TRUE) {
+		if (reg_IRQL[gc->IRQ]) {
 			printk("Can't support more than one HBA on this IRQ,\n" "  if the IRQ is edge triggered. Sorry.\n");
 			return 0;
 		} else
@@ -761,9 +764,9 @@
 	}
 
 	if (ntohl(gc->len) >= 0x22) {
-		if (gc->is_PCI == TRUE)
+		if (gc->is_PCI)
 			hd->bustype = IS_PCI;
-		else if (gc->is_EISA == TRUE)
+		else if (gc->is_EISA)
 			hd->bustype = IS_EISA;
 		else
 			hd->bustype = IS_ISA;
@@ -798,11 +801,11 @@
 	sh->max_lun = 8;
 
 	if (gc->SECOND)
-		hd->primary = FALSE;
+		hd->primary = 0;
 	else
-		hd->primary = TRUE;
+		hd->primary = 1;
 
-	sh->unchecked_isa_dma = FALSE;	/* We can only do PIO */
+	sh->unchecked_isa_dma = 0;	/* We can only do PIO */
 
 	hd->next = NULL;	/* build a linked list of all HBAs */
 	hd->prev = last_HBA;
@@ -815,7 +818,7 @@
 	return (1);
 }
 
-static void find_pio_ISA(struct get_conf *buf, Scsi_Host_Template * tpnt)
+static void find_pio_ISA(struct get_conf *buf)
 {
 	int i;
 
@@ -824,7 +827,7 @@
 			continue;
 		if (!get_pio_conf_PIO(ISAbases[i], buf))
 			continue;
-		if (!register_pio_HBA(ISAbases[i], buf, tpnt))
+		if (!register_pio_HBA(ISAbases[i], buf))
 			release_region(ISAbases[i], 9);
 		else
 			ISAbases[i] = 0;
@@ -832,7 +835,7 @@
 	return;
 }
 
-static void find_pio_EISA(struct get_conf *buf, Scsi_Host_Template * tpnt)
+static void find_pio_EISA(struct get_conf *buf)
 {
 	u32 base;
 	int i;
@@ -842,7 +845,7 @@
 #endif
 
 	for (i = 0; i < MAXEISA; i++) {
-		if (EISAbases[i] == TRUE) {	/* Still a possibility ?          */
+		if (EISAbases[i]) {	/* Still a possibility ?          */
 
 			base = 0x1c88 + (i * 0x1000);
 #if CHECKPAL
@@ -856,7 +859,7 @@
 				if (get_pio_conf_PIO(base, buf)) {
 					DBG(DBG_PROBE && DBG_EISA, print_pio_config(buf));
 					if (buf->IRQ) {
-						if (!register_pio_HBA(base, buf, tpnt))
+						if (!register_pio_HBA(base, buf))
 							release_region(base, 9);
 					} else {
 						printk(KERN_NOTICE "eata_dma: No valid IRQ. HBA " "removed from list\n");
@@ -873,7 +876,7 @@
 	return;
 }
 
-static void find_pio_PCI(struct get_conf *buf, Scsi_Host_Template * tpnt)
+static void find_pio_PCI(struct get_conf *buf)
 {
 #ifndef CONFIG_PCI
 	printk("eata_dma: kernel PCI support not enabled. Skipping scan for PCI HBAs.\n");
@@ -909,7 +912,7 @@
 				 * eventually remove it from the EISA and ISA list 
 				 */
 
-				if (!register_pio_HBA(base, buf, tpnt)) {
+				if (!register_pio_HBA(base, buf)) {
 					release_region(base, 9);
 					continue;
 				}
@@ -927,7 +930,7 @@
 				}
 			}
 #if CHECK_BLINK
-			else if (check_blink_state(base) == TRUE) {
+			else if (check_blink_state(base)) {
 				printk("eata_pio: HBA is in BLINK state.\n" "Consult your HBAs manual to correct this.\n");
 			}
 #endif
@@ -936,20 +939,15 @@
 #endif				/* #ifndef CONFIG_PCI */
 }
 
-
-static int eata_pio_detect(Scsi_Host_Template * tpnt)
+static int eata_pio_detect(struct scsi_host_template *tpnt)
 {
 	struct Scsi_Host *HBA_ptr;
 	struct get_conf gc;
 	int i;
 
-	tpnt->proc_name = "eata_pio";
-
-	find_pio_PCI(&gc, tpnt);
-
-	find_pio_EISA(&gc, tpnt);
-
-	find_pio_ISA(&gc, tpnt);
+	find_pio_PCI(&gc);
+	find_pio_EISA(&gc);
+	find_pio_ISA(&gc);
 
 	for (i = 0; i <= MAXIRQ; i++)
 		if (reg_IRQ[i])
@@ -969,16 +967,19 @@
 			       HBA_ptr->host_no, SD(HBA_ptr)->name, SD(HBA_ptr)->revision,
 			       SD(HBA_ptr)->EATA_revision, (SD(HBA_ptr)->bustype == 'P') ?
 			       "PCI " : (SD(HBA_ptr)->bustype == 'E') ? "EISA" : "ISA ",
-			       (uint) HBA_ptr->base, HBA_ptr->irq, SD(HBA_ptr)->channel, HBA_ptr->this_id, (SD(HBA_ptr)->primary == TRUE) ? 'Y' : 'N', HBA_ptr->can_queue, HBA_ptr->sg_tablesize, HBA_ptr->cmd_per_lun);
+			       (uint) HBA_ptr->base, HBA_ptr->irq, SD(HBA_ptr)->channel, HBA_ptr->this_id,
+			       SD(HBA_ptr)->primary ? 'Y' : 'N', HBA_ptr->can_queue,
+			       HBA_ptr->sg_tablesize, HBA_ptr->cmd_per_lun);
 			HBA_ptr = SD(HBA_ptr)->next;
 		}
 	}
 	return (registered_HBAs);
 }
 
-static Scsi_Host_Template driver_template = {
-	.proc_info         	= eata_pio_proc_info,
+static struct scsi_host_template driver_template = {
+	.proc_name		= "eata_pio",
 	.name              	= "EATA (Extended Attachment) PIO driver",
+	.proc_info         	= eata_pio_proc_info,
 	.detect            	= eata_pio_detect,
 	.release           	= eata_pio_release,
 	.queuecommand      	= eata_pio_queue,
