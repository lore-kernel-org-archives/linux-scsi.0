From: aris@cathedrallabs.org (Aristeu Sergio Rozanski Filho)
Subject: [patch][2/3] qlogicfas: split and create a new module with only specific chip functions
Date: Wed, 31 Mar 2004 10:05:56 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040331130556.GB28021@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ALfTUftag+2gvp1h"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:28177 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261951AbUCaNHw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 08:07:52 -0500
Received: from cathedrallabs.org (3-133.ctame701-3.telepar.net.br [200.181.174.133])
	by panda.sul.com.br (Postfix) with ESMTP id 18AC4326ED
	for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2004 10:08:06 -0300 (EST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



-- 
aris


--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="02-qlogicfas-split_in_driver_and_specific_chip_functions.patch"

diff -urNp -X dontdiff linux-2.6.4-applied/drivers/scsi/Makefile linux-2.6.4-work/drivers/scsi/Makefile
--- linux-2.6.4-applied/drivers/scsi/Makefile	2004-03-13 15:08:31.000000000 -0300
+++ linux-2.6.4-work/drivers/scsi/Makefile	2004-03-30 09:54:40.000000000 -0300
@@ -67,7 +67,8 @@ obj-$(CONFIG_SCSI_NCR53C406A)	+= NCR53c4
 obj-$(CONFIG_SCSI_NCR_D700)	+= NCR_D700.o 53c700.o
 obj-$(CONFIG_SCSI_NCR_Q720)	+= NCR_Q720_mod.o
 obj-$(CONFIG_SCSI_SYM53C416)	+= sym53c416.o
-obj-$(CONFIG_SCSI_QLOGIC_FAS)	+= qlogicfas.o
+obj-$(CONFIG_SCSI_QLOGIC_FAS)	+= qlogicfas408.o	qlogicfas.o
+obj-$(CONFIG_PCMCIA_QLOGIC)	+= qlogicfas408.o
 obj-$(CONFIG_SCSI_QLOGIC_ISP)	+= qlogicisp.o 
 obj-$(CONFIG_SCSI_QLOGIC_FC)	+= qlogicfc.o 
 obj-$(CONFIG_SCSI_QLOGIC_1280)	+= qla1280.o 
diff -urNp -X dontdiff linux-2.6.4-applied/drivers/scsi/qlogicfas.c linux-2.6.4-work/drivers/scsi/qlogicfas.c
--- linux-2.6.4-applied/drivers/scsi/qlogicfas.c	2004-03-18 08:45:57.000000000 -0300
+++ linux-2.6.4-work/drivers/scsi/qlogicfas.c	2004-03-30 13:51:19.000000000 -0300
@@ -1,43 +1,19 @@
-/*----------------------------------------------------------------*/
 /*
-   Qlogic linux driver - work in progress. No Warranty express or implied.
-   Use at your own risk.  Support Tort Reform so you won't have to read all
-   these silly disclaimers.
-
-   Copyright 1994, Tom Zerucha.   
-   tz@execpc.com
-   
-   Additional Code, and much appreciated help by
-   Michael A. Griffith
-   grif@cs.ucr.edu
-
-   Thanks to Eric Youngdale and Dave Hinds for loadable module and PCMCIA
-   help respectively, and for suffering through my foolishness during the
-   debugging process.
-
-   Reference Qlogic FAS408 Technical Manual, 53408-510-00A, May 10, 1994
-   (you can reference it, but it is incomplete and inaccurate in places)
-
-   Version 0.46 1/30/97 - kernel 1.2.0+
-
-   Functions as standalone, loadable, and PCMCIA driver, the latter from
-   Dave Hinds' PCMCIA package.
-   
-   Cleaned up 26/10/2002 by Alan Cox <alan@redhat.com> as part of the 2.5
-   SCSI driver cleanup and audit. This driver still needs work on the
-   following
-   	-	Non terminating hardware waits
-   	-	Some layering violations with its pcmcia stub
-
-   Redistributable under terms of the GNU General Public License
-
-   For the avoidance of doubt the "preferred form" of this code is one which
-   is in an open non patent encumbered format. Where cryptographic key signing
-   forms part of the process of creating an executable the information
-   including keys needed to generate an equivalently functional executable
-   are deemed to be part of the source code.
-
-*/
+ * Qlogic FAS408 ISA card driver
+ *
+ * Copyright 1994, Tom Zerucha.   
+ * tz@execpc.com
+ * 
+ * Redistributable under terms of the GNU General Public License
+ *
+ * For the avoidance of doubt the "preferred form" of this code is one which
+ * is in an open non patent encumbered format. Where cryptographic key signing
+ * forms part of the process of creating an executable the information
+ * including keys needed to generate an equivalently functional executable
+ * are deemed to be part of the source code.
+ *
+ * Check qlogicfas408.c for more credits and info.
+ */
 
 #include <linux/module.h>
 #include <linux/blkdev.h>		/* to get disk capacity */
@@ -57,428 +33,28 @@
 
 #include "scsi.h"
 #include "hosts.h"
-#include "qlogicfas.h"
-
-/*----------------------------------------------------------------*/
-int qlcfg5 = (XTALFREQ << 5);	/* 15625/512 */
-int qlcfg6 = SYNCXFRPD;
-int qlcfg7 = SYNCOFFST;
-int qlcfg8 = (SLOWCABLE << 7) | (QL_ENABLE_PARITY << 4);
-int qlcfg9 = ((XTALFREQ + 4) / 5);
-int qlcfgc = (FASTCLK << 3) | (FASTSCSI << 4);
-
-static char qlogicfas_name[] = "qlogicfas";
-
-int qlogicfas_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *));
-
-/*----------------------------------------------------------------*/
-
-/*----------------------------------------------------------------*/
-/* local functions */
-/*----------------------------------------------------------------*/
+#include "qlogicfas408.h"
 
-/* error recovery - reset everything */
-
-static void ql_zap(qlogicfas_priv_t priv)
-{
-	int x;
-	int qbase = priv->qbase;
-
-	x = inb(qbase + 0xd);
-	REG0;
-	outb(3, qbase + 3);	/* reset SCSI */
-	outb(2, qbase + 3);	/* reset chip */
-	if (x & 0x80)
-		REG1;
-}
-
-/*
- *	Do a pseudo-dma tranfer
+/* Set the following to 2 to use normal interrupt (active high/totempole-
+ * tristate), otherwise use 0 (REQUIRED FOR PCMCIA) for active low, open
+ * drain
  */
- 
-static int ql_pdma(qlogicfas_priv_t priv, int phase, char *request, int reqlen)
-{
-	int j;
-	int qbase = priv->qbase;
-	j = 0;
-	if (phase & 1) {	/* in */
-#if QL_TURBO_PDMA
-		rtrc(4)
-		/* empty fifo in large chunks */
-		if (reqlen >= 128 && (inb(qbase + 8) & 2)) {	/* full */
-			insl(qbase + 4, request, 32);
-			reqlen -= 128;
-			request += 128;
-		}
-		while (reqlen >= 84 && !(j & 0xc0))	/* 2/3 */
-			if ((j = inb(qbase + 8)) & 4) 
-			{
-				insl(qbase + 4, request, 21);
-				reqlen -= 84;
-				request += 84;
-			}
-		if (reqlen >= 44 && (inb(qbase + 8) & 8)) {	/* 1/3 */
-			insl(qbase + 4, request, 11);
-			reqlen -= 44;
-			request += 44;
-		}
-#endif
-		/* until both empty and int (or until reclen is 0) */
-		rtrc(7)
-		j = 0;
-		while (reqlen && !((j & 0x10) && (j & 0xc0))) 
-		{
-			/* while bytes to receive and not empty */
-			j &= 0xc0;
-			while (reqlen && !((j = inb(qbase + 8)) & 0x10)) 
-			{
-				*request++ = inb(qbase + 4);
-				reqlen--;
-			}
-			if (j & 0x10)
-				j = inb(qbase + 8);
+#define INT_TYPE	2
 
-		}
-	} else {		/* out */
-#if QL_TURBO_PDMA
-		rtrc(4)
-		    if (reqlen >= 128 && inb(qbase + 8) & 0x10) {	/* empty */
-			outsl(qbase + 4, request, 32);
-			reqlen -= 128;
-			request += 128;
-		}
-		while (reqlen >= 84 && !(j & 0xc0))	/* 1/3 */
-			if (!((j = inb(qbase + 8)) & 8)) {
-				outsl(qbase + 4, request, 21);
-				reqlen -= 84;
-				request += 84;
-			}
-		if (reqlen >= 40 && !(inb(qbase + 8) & 4)) {	/* 2/3 */
-			outsl(qbase + 4, request, 10);
-			reqlen -= 40;
-			request += 40;
-		}
-#endif
-		/* until full and int (or until reclen is 0) */
-		rtrc(7)
-		    j = 0;
-		while (reqlen && !((j & 2) && (j & 0xc0))) {
-			/* while bytes to send and not full */
-			while (reqlen && !((j = inb(qbase + 8)) & 2)) 
-			{
-				outb(*request++, qbase + 4);
-				reqlen--;
-			}
-			if (j & 2)
-				j = inb(qbase + 8);
-		}
-	}
-	/* maybe return reqlen */
-	return inb(qbase + 8) & 0xc0;
-}
-
-/*
- *	Wait for interrupt flag (polled - not real hardware interrupt) 
- */
-
-static int ql_wai(qlogicfas_priv_t priv)
-{
-	int k;
-	int qbase = priv->qbase;
-	unsigned long i;
-
-	k = 0;
-	i = jiffies + WATCHDOG;
-	while (time_before(jiffies, i) && !priv->qabort &&
-					!((k = inb(qbase + 4)) & 0xe0)) {
-		barrier();
-		cpu_relax();
-	}
-	if (time_after_eq(jiffies, i))
-		return (DID_TIME_OUT);
-	if (priv->qabort)
-		return (priv->qabort == 1 ? DID_ABORT : DID_RESET);
-	if (k & 0x60)
-		ql_zap(priv);
-	if (k & 0x20)
-		return (DID_PARITY);
-	if (k & 0x40)
-		return (DID_ERROR);
-	return 0;
-}
-
-/*
- *	Initiate scsi command - queueing handler 
- *	caller must hold host lock
- */
-
-static void ql_icmd(Scsi_Cmnd * cmd)
-{
-	qlogicfas_priv_t priv = (qlogicfas_priv_t)&(cmd->device->host->hostdata[0]);
-	int 	qbase = priv->qbase;
-	unsigned int i;
-
-	priv->qabort = 0;
-
-	REG0;
-	/* clearing of interrupts and the fifo is needed */
-
-	inb(qbase + 5);		/* clear interrupts */
-	if (inb(qbase + 5))	/* if still interrupting */
-		outb(2, qbase + 3);	/* reset chip */
-	else if (inb(qbase + 7) & 0x1f)
-		outb(1, qbase + 3);	/* clear fifo */
-	while (inb(qbase + 5));	/* clear ints */
-	REG1;
-	outb(1, qbase + 8);	/* set for PIO pseudo DMA */
-	outb(0, qbase + 0xb);	/* disable ints */
-	inb(qbase + 8);		/* clear int bits */
-	REG0;
-	outb(0x40, qbase + 0xb);	/* enable features */
-
-	/* configurables */
-	outb(qlcfgc, qbase + 0xc);
-	/* config: no reset interrupt, (initiator) bus id */
-	outb(0x40 | qlcfg8 | priv->qinitid, qbase + 8);
-	outb(qlcfg7, qbase + 7);
-	outb(qlcfg6, qbase + 6);
-	 /**/ outb(qlcfg5, qbase + 5);	/* select timer */
-	outb(qlcfg9 & 7, qbase + 9);	/* prescaler */
-/*	outb(0x99, qbase + 5);	*/
-	outb(cmd->device->id, qbase + 4);
-
-	for (i = 0; i < cmd->cmd_len; i++)
-		outb(cmd->cmnd[i], qbase + 2);
-
-	priv->qlcmd = cmd;
-	outb(0x41, qbase + 3);	/* select and send command */
-}
-
-/*
- *	Process scsi command - usually after interrupt 
- */
-
-static unsigned int ql_pcmd(Scsi_Cmnd * cmd)
-{
-	unsigned int i, j;
-	unsigned long k;
-	unsigned int result;	/* ultimate return result */
-	unsigned int status;	/* scsi returned status */
-	unsigned int message;	/* scsi returned message */
-	unsigned int phase;	/* recorded scsi phase */
-	unsigned int reqlen;	/* total length of transfer */
-	struct scatterlist *sglist;	/* scatter-gather list pointer */
-	unsigned int sgcount;	/* sg counter */
-	char *buf;
-	qlogicfas_priv_t priv = (qlogicfas_priv_t)&(cmd->device->host->hostdata[0]);
-	int qbase = priv->qbase;
-
-	rtrc(1)
-	j = inb(qbase + 6);
-	i = inb(qbase + 5);
-	if (i == 0x20) {
-		return (DID_NO_CONNECT << 16);
-	}
-	i |= inb(qbase + 5);	/* the 0x10 bit can be set after the 0x08 */
-	if (i != 0x18) {
-		printk(KERN_ERR "Ql:Bad Interrupt status:%02x\n", i);
-		ql_zap(priv);
-		return (DID_BAD_INTR << 16);
-	}
-	j &= 7;			/* j = inb( qbase + 7 ) >> 5; */
-
-	/* correct status is supposed to be step 4 */
-	/* it sometimes returns step 3 but with 0 bytes left to send */
-	/* We can try stuffing the FIFO with the max each time, but we will get a
-	   sequence of 3 if any bytes are left (but we do flush the FIFO anyway */
-
-	if (j != 3 && j != 4) {
-		printk(KERN_ERR "Ql:Bad sequence for command %d, int %02X, cmdleft = %d\n",
-		     j, i, inb(qbase + 7) & 0x1f);
-		ql_zap(priv);
-		return (DID_ERROR << 16);
-	}
-	result = DID_OK;
-	if (inb(qbase + 7) & 0x1f)	/* if some bytes in fifo */
-		outb(1, qbase + 3);	/* clear fifo */
-	/* note that request_bufflen is the total xfer size when sg is used */
-	reqlen = cmd->request_bufflen;
-	/* note that it won't work if transfers > 16M are requested */
-	if (reqlen && !((phase = inb(qbase + 4)) & 6)) {	/* data phase */
-		rtrc(2)
-		outb(reqlen, qbase);	/* low-mid xfer cnt */
-		outb(reqlen >> 8, qbase + 1);	/* low-mid xfer cnt */
-		outb(reqlen >> 16, qbase + 0xe);	/* high xfer cnt */
-		outb(0x90, qbase + 3);	/* command do xfer */
-		/* PIO pseudo DMA to buffer or sglist */
-		REG1;
-		if (!cmd->use_sg)
-			ql_pdma(priv, phase, cmd->request_buffer,
-				cmd->request_bufflen);
-		else {
-			sgcount = cmd->use_sg;
-			sglist = cmd->request_buffer;
-			while (sgcount--) {
-				if (priv->qabort) {
-					REG0;
-					return ((priv->qabort == 1 ?
-						DID_ABORT : DID_RESET) << 16);
-				}
-				buf = page_address(sglist->page) + sglist->offset;
-				if (ql_pdma(priv, phase, buf, sglist->length))
-					break;
-				sglist++;
-			}
-		}
-		REG0;
-		rtrc(2)
-		/*
-		 *	Wait for irq (split into second state of irq handler
-		 *	if this can take time) 
-		 */
-		if ((k = ql_wai(priv)))
-			return (k << 16);
-		k = inb(qbase + 5);	/* should be 0x10, bus service */
-	}
-
-	/*
-	 *	Enter Status (and Message In) Phase 
-	 */
-	 
-	k = jiffies + WATCHDOG;
-
-	while (time_before(jiffies, k) && !priv->qabort &&
-						!(inb(qbase + 4) & 6))
-		cpu_relax();	/* wait for status phase */
-
-	if (time_after_eq(jiffies, k)) {
-		ql_zap(priv);
-		return (DID_TIME_OUT << 16);
-	}
-
-	/* FIXME: timeout ?? */
-	while (inb(qbase + 5))
-		cpu_relax();	/* clear pending ints */
-
-	if (priv->qabort)
-		return ((priv->qabort == 1 ? DID_ABORT : DID_RESET) << 16);
-
-	outb(0x11, qbase + 3);	/* get status and message */
-	if ((k = ql_wai(priv)))
-		return (k << 16);
-	i = inb(qbase + 5);	/* get chip irq stat */
-	j = inb(qbase + 7) & 0x1f;	/* and bytes rec'd */
-	status = inb(qbase + 2);
-	message = inb(qbase + 2);
-
-	/*
-	 *	Should get function complete int if Status and message, else 
-	 *	bus serv if only status 
-	 */
-	if (!((i == 8 && j == 2) || (i == 0x10 && j == 1))) {
-		printk(KERN_ERR "Ql:Error during status phase, int=%02X, %d bytes recd\n", i, j);
-		result = DID_ERROR;
-	}
-	outb(0x12, qbase + 3);	/* done, disconnect */
-	rtrc(1)
-	if ((k = ql_wai(priv)))
-		return (k << 16);
-
-	/*
-	 *	Should get bus service interrupt and disconnect interrupt 
-	 */
-	 
-	i = inb(qbase + 5);	/* should be bus service */
-	while (!priv->qabort && ((i & 0x20) != 0x20)) {
-		barrier();
-		cpu_relax();
-		i |= inb(qbase + 5);
-	}
-	rtrc(0)
-
-	if (priv->qabort)
-		return ((priv->qabort == 1 ? DID_ABORT : DID_RESET) << 16);
-		
-	return (result << 16) | (message << 8) | (status & STATUS_MASK);
-}
-
-/*
- *	Interrupt handler 
- */
-
-static void ql_ihandl(int irq, void *dev_id, struct pt_regs *regs)
-{
-	Scsi_Cmnd *icmd;
-	struct Scsi_Host *host = (struct Scsi_Host *)dev_id;
-	qlogicfas_priv_t priv = (qlogicfas_priv_t)&(host->hostdata[0]);
-	int qbase = priv->qbase;
-	REG0;
-
-	if (!(inb(qbase + 4) & 0x80))	/* false alarm? */
-		return;
-
-	if (priv->qlcmd == NULL) {	/* no command to process? */
-		int i;
-		i = 16;
-		while (i-- && inb(qbase + 5));	/* maybe also ql_zap() */
-		return;
-	}
-	icmd = priv->qlcmd;
-	icmd->result = ql_pcmd(icmd);
-	priv->qlcmd = NULL;
-	/*
-	 *	If result is CHECK CONDITION done calls qcommand to request 
-	 *	sense 
-	 */
-	(icmd->scsi_done) (icmd);
-}
-
-irqreturn_t do_ql_ihandl(int irq, void *dev_id, struct pt_regs *regs)
-{
-	unsigned long flags;
-	struct Scsi_Host *host = dev_id;
-
-	spin_lock_irqsave(host->host_lock, flags);
-	ql_ihandl(irq, dev_id, regs);
-	spin_unlock_irqrestore(host->host_lock, flags);
-	return IRQ_HANDLED;
-}
-
-/*
- *	Queued command
- */
-
-int qlogicfas_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
-{
-	qlogicfas_priv_t priv = (qlogicfas_priv_t)&(cmd->device->host->hostdata[0]);
-	if (cmd->device->id == priv->qinitid) {
-		cmd->result = DID_BAD_TARGET << 16;
-		done(cmd);
-		return 0;
-	}
-
-	cmd->scsi_done = done;
-	/* wait for the last command's interrupt to finish */
-	while (priv->qlcmd != NULL) {
-		barrier();
-		cpu_relax();
-	}
-	ql_icmd(cmd);
-	return 0;
-}
+static char qlogicfas_name[] = "qlogicfas";
 
-#ifndef PCMCIA
 /*
  *	Look for qlogic card and init if found 
  */
  
-struct Scsi_Host *__qlogicfas_detect(Scsi_Host_Template *host, int qbase,
+static struct Scsi_Host *__qlogicfas_detect(Scsi_Host_Template *host,
+								int qbase,
 								int qlirq)
 {
 	int qltyp;		/* type of chip */
 	int qinitid;
 	struct Scsi_Host *hreg;	/* registered host structure */
-	qlogicfas_priv_t priv;
+	struct qlogicfas408_priv *priv;
 
 	/*	Qlogic Cards only exist at 0x230 or 0x330 (the chip itself
 	 *	decodes the address - I check 230 first since MIDI cards are
@@ -498,9 +74,7 @@ struct Scsi_Host *__qlogicfas_detect(Scs
 		goto err;
 	}
 
-	REG1;
-	if (((inb(qbase + 0xe) ^ inb(qbase + 0xe)) != 7)
-	    || ((inb(qbase + 0xe) ^ inb(qbase + 0xe)) != 7)) {
+	if (!qlogicfas408_detect(qbase, INT_TYPE)) {
 		printk(KERN_WARNING "%s: probe failed for %#x\n",
 								qlogicfas_name,
 								qbase);
@@ -510,29 +84,17 @@ struct Scsi_Host *__qlogicfas_detect(Scs
 	printk(KERN_INFO "%s: Using preset base address of %03x,"
 			 " IRQ %d\n", qlogicfas_name, qbase, qlirq);
 
-	qltyp = inb(qbase + 0xe) & 0xf8;
+	qltyp = qlogicfas408_get_chip_type(qbase, INT_TYPE);
 	qinitid = host->this_id;
 	if (qinitid < 0)
 		qinitid = 7;	/* if no ID, use 7 */
-	outb(1, qbase + 8);	/* set for PIO pseudo DMA */
-	REG0;
-	outb(0x40 | qlcfg8 | qinitid, qbase + 8);	/* (ini) bus id, disable scsi rst */
-	outb(qlcfg5, qbase + 5);	/* select timer */
-	outb(qlcfg9, qbase + 9);	/* prescaler */
-
-#if QL_RESET_AT_START
-	outb(3, qbase + 3);
-	REG1;
-	/* FIXME: timeout */
-	while (inb(qbase + 0xf) & 4)
-		cpu_relax();
-	REG0;
-#endif
 
-	hreg = scsi_host_alloc(host, sizeof(struct qlogicfas_priv));
+	qlogicfas408_setup(qbase, qinitid, INT_TYPE);
+
+	hreg = scsi_host_alloc(host, sizeof(struct qlogicfas408_priv));
 	if (!hreg)
 		goto err_release_mem;
-	priv = (qlogicfas_priv_t)&(hreg->hostdata[0]);
+	priv = get_priv_by_host(hreg);
 	hreg->io_port = qbase;
 	hreg->n_io_port = 16;
 	hreg->dma_channel = -1;
@@ -542,13 +104,14 @@ struct Scsi_Host *__qlogicfas_detect(Scs
 	priv->qlirq = qlirq;
 	priv->qinitid = qinitid;
 	priv->shost = hreg;
+	priv->int_type = INT_TYPE;
 
 	sprintf(priv->qinfo,
 		"Qlogicfas Driver version 0.46, chip %02X at %03X, IRQ %d, TPdma:%d",
 		qltyp, qbase, qlirq, QL_TURBO_PDMA);
 	host->name = qlogicfas_name;
 
-	if (request_irq(qlirq, do_ql_ihandl, 0, qlogicfas_name, hreg))
+	if (request_irq(qlirq, qlogicfas408_ihandl, 0, qlogicfas_name, hreg))
 		goto free_scsi_host;
 
 	if (scsi_add_host(hreg, NULL))
@@ -571,7 +134,7 @@ err:
 }
 
 #define MAX_QLOGICFAS	8
-static qlogicfas_priv_t cards;
+static struct qlogicfas408_priv *cards;
 static int iobase[MAX_QLOGICFAS];
 static int irq[MAX_QLOGICFAS] = { [0 ... MAX_QLOGICFAS-1] = -1 };
 MODULE_PARM(iobase, "1-" __MODULE_STRING(MAX_QLOGICFAS) "i");
@@ -579,11 +142,11 @@ MODULE_PARM(irq, "1-" __MODULE_STRING(MA
 MODULE_PARM_DESC(iobase, "I/O address");
 MODULE_PARM_DESC(irq, "IRQ");
 
-int __devinit qlogicfas_detect(Scsi_Host_Template *sht)
+static int __devinit qlogicfas_detect(Scsi_Host_Template *sht)
 {
-	struct Scsi_Host	*shost;
-	qlogicfas_priv_t	priv;
-	int	num;
+	struct Scsi_Host *shost;
+	struct qlogicfas408_priv *priv;
+	int num;
 
 	for (num = 0; num < MAX_QLOGICFAS; num++) {
 		shost = __qlogicfas_detect(sht, iobase[num], irq[num]);
@@ -591,7 +154,7 @@ int __devinit qlogicfas_detect(Scsi_Host
 			/* no more devices */
 			break;
 		}
-		priv = (qlogicfas_priv_t)&(shost->hostdata[0]);
+		priv = get_priv_by_host(shost);
 		priv->next = cards;
 		cards = priv;
 	}
@@ -601,13 +164,10 @@ int __devinit qlogicfas_detect(Scsi_Host
 
 static int qlogicfas_release(struct Scsi_Host *shost)
 {
-	qlogicfas_priv_t priv = (qlogicfas_priv_t)&(shost->hostdata[0]);
-	int qbase = priv->qbase;
+	struct qlogicfas408_priv *priv = get_priv_by_host(shost);
 
 	if (shost->irq) {
-		REG1;
-		outb(0, qbase + 0xb);	/* disable ints */
-	
+		qlogicfas408_disable_ints(priv);	
 		free_irq(shost->irq, shost);
 	}
 	if (shost->dma_channel != 0xff)
@@ -619,100 +179,21 @@ static int qlogicfas_release(struct Scsi
 
 	return 0;
 }
-#endif	/* ifndef PCMCIA */
-
-/* 
- *	Return bios parameters 
- */
-
-int qlogicfas_biosparam(struct scsi_device * disk,
-		        struct block_device *dev,
-			sector_t capacity, int ip[])
-{
-/* This should mimic the DOS Qlogic driver's behavior exactly */
-	ip[0] = 0x40;
-	ip[1] = 0x20;
-	ip[2] = (unsigned long) capacity / (ip[0] * ip[1]);
-	if (ip[2] > 1024) {
-		ip[0] = 0xff;
-		ip[1] = 0x3f;
-		ip[2] = (unsigned long) capacity / (ip[0] * ip[1]);
-#if 0
-		if (ip[2] > 1023)
-			ip[2] = 1023;
-#endif
-	}
-	return 0;
-}
-
-/*
- *	Abort a command in progress
- */
- 
-static int qlogicfas_abort(Scsi_Cmnd * cmd)
-{
-	qlogicfas_priv_t priv = (qlogicfas_priv_t)&(cmd->device->host->hostdata[0]);
-	priv->qabort = 1;
-	ql_zap(priv);
-	return SUCCESS;
-}
-
-/* 
- *	Reset SCSI bus
- *	FIXME: This function is invoked with cmd = NULL directly by
- *	the PCMCIA qlogic_stub code. This wants fixing
- */
-
-int qlogicfas_bus_reset(Scsi_Cmnd * cmd)
-{
-	qlogicfas_priv_t priv = (qlogicfas_priv_t)&(cmd->device->host->hostdata[0]);
-	priv->qabort = 2;
-	ql_zap(priv);
-	return SUCCESS;
-}
-
-/* 
- *	Reset SCSI host controller
- */
-
-static int qlogicfas_host_reset(Scsi_Cmnd * cmd)
-{
-	return FAILED;
-}
-
-/* 
- *	Reset SCSI device
- */
-
-static int qlogicfas_device_reset(Scsi_Cmnd * cmd)
-{
-	return FAILED;
-}
-
-/*
- *	Return info string
- */
-
-static const char *qlogicfas_info(struct Scsi_Host *host)
-{
-	qlogicfas_priv_t priv = (qlogicfas_priv_t)&(host->hostdata[0]);
-	return priv->qinfo;
-}
 
 /*
  *	The driver template is also needed for PCMCIA
  */
-Scsi_Host_Template qlogicfas_driver_template = {
+static Scsi_Host_Template qlogicfas_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= qlogicfas_name,
 	.proc_name		= qlogicfas_name,
-	.info			= qlogicfas_info,
-	.queuecommand		= qlogicfas_queuecommand,
-	.eh_abort_handler	= qlogicfas_abort,
-	.eh_bus_reset_handler	= qlogicfas_bus_reset,
-	.eh_device_reset_handler= qlogicfas_device_reset,
-	.eh_host_reset_handler	= qlogicfas_host_reset,
-	.bios_param		= qlogicfas_biosparam,
+	.info			= qlogicfas408_info,
+	.queuecommand		= qlogicfas408_queuecommand,
+	.eh_abort_handler	= qlogicfas408_abort,
+	.eh_bus_reset_handler	= qlogicfas408_bus_reset,
+	.eh_device_reset_handler= qlogicfas408_device_reset,
+	.eh_host_reset_handler	= qlogicfas408_host_reset,
+	.bios_param		= qlogicfas408_biosparam,
 	.can_queue		= 1,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
@@ -720,7 +201,6 @@ Scsi_Host_Template qlogicfas_driver_temp
 	.use_clustering		= DISABLE_CLUSTERING,
 };
 
-#ifndef PCMCIA
 static __init int qlogicfas_init(void)
 {
 	if (!qlogicfas_detect(&qlogicfas_driver_template)) {
@@ -736,16 +216,15 @@ static __init int qlogicfas_init(void)
 
 static __exit void qlogicfas_exit(void)
 {
-	qlogicfas_priv_t	priv;
+	struct qlogicfas408_priv *priv;
 
 	for (priv = cards; priv != NULL; priv = priv->next)
 		qlogicfas_release(priv->shost);
 }
 
 MODULE_AUTHOR("Tom Zerucha, Michael Griffith");
-MODULE_DESCRIPTION("Driver for the Qlogic FAS SCSI controllers");
+MODULE_DESCRIPTION("Driver for the Qlogic FAS408 based ISA card");
 MODULE_LICENSE("GPL");
 module_init(qlogicfas_init);
 module_exit(qlogicfas_exit);
-#endif	/* ifndef PCMCIA */
 
diff -urNp -X dontdiff linux-2.6.4-applied/drivers/scsi/qlogicfas.h linux-2.6.4-work/drivers/scsi/qlogicfas.h
--- linux-2.6.4-applied/drivers/scsi/qlogicfas.h	2004-03-13 15:10:48.000000000 -0300
+++ linux-2.6.4-work/drivers/scsi/qlogicfas.h	1969-12-31 21:00:00.000000000 -0300
@@ -1,124 +0,0 @@
-/* to be used by qlogicfas and qlogic_cs */
-#ifndef __QLOGICFAS_H
-#define __QLOGICFAS_H
-
-/*----------------------------------------------------------------*/
-/* Configuration */
-
-/* Set the following to 2 to use normal interrupt (active high/totempole-
-   tristate), otherwise use 0 (REQUIRED FOR PCMCIA) for active low, open
-   drain */
-
-#define QL_INT_ACTIVE_HIGH 2
-
-/* Set the following to max out the speed of the PIO PseudoDMA transfers,
-   again, 0 tends to be slower, but more stable.  */
-
-#define QL_TURBO_PDMA 1
-
-/* This should be 1 to enable parity detection */
-
-#define QL_ENABLE_PARITY 1
-
-/* This will reset all devices when the driver is initialized (during bootup).
-   The other linux drivers don't do this, but the DOS drivers do, and after
-   using DOS or some kind of crash or lockup this will bring things back
-   without requiring a cold boot.  It does take some time to recover from a
-   reset, so it is slower, and I have seen timeouts so that devices weren't
-   recognized when this was set. */
-
-#define QL_RESET_AT_START 0
-
-/* crystal frequency in megahertz (for offset 5 and 9)
-   Please set this for your card.  Most Qlogic cards are 40 Mhz.  The
-   Control Concepts ISA (not VLB) is 24 Mhz */
-
-#define XTALFREQ	40
-
-/**********/
-/* DANGER! modify these at your own risk */
-/* SLOWCABLE can usually be reset to zero if you have a clean setup and
-   proper termination.  The rest are for synchronous transfers and other
-   advanced features if your device can transfer faster than 5Mb/sec.
-   If you are really curious, email me for a quick howto until I have
-   something official */
-/**********/
-
-/*****/
-/* config register 1 (offset 8) options */
-/* This needs to be set to 1 if your cabling is long or noisy */
-#define SLOWCABLE 1
-
-/*****/
-/* offset 0xc */
-/* This will set fast (10Mhz) synchronous timing when set to 1
-   For this to have an effect, FASTCLK must also be 1 */
-#define FASTSCSI 0
-
-/* This when set to 1 will set a faster sync transfer rate */
-#define FASTCLK 0	/*(XTALFREQ>25?1:0)*/
-
-/*****/
-/* offset 6 */
-/* This is the sync transfer divisor, XTALFREQ/X will be the maximum
-   achievable data rate (assuming the rest of the system is capable
-   and set properly) */
-#define SYNCXFRPD 5	/*(XTALFREQ/5)*/
-
-/*****/
-/* offset 7 */
-/* This is the count of how many synchronous transfers can take place
-	i.e. how many reqs can occur before an ack is given.
-	The maximum value for this is 15, the upper bits can modify
-	REQ/ACK assertion and deassertion during synchronous transfers
-	If this is 0, the bus will only transfer asynchronously */
-#define SYNCOFFST 0
-/* for the curious, bits 7&6 control the deassertion delay in 1/2 cycles
-	of the 40Mhz clock. If FASTCLK is 1, specifying 01 (1/2) will
-	cause the deassertion to be early by 1/2 clock.  Bits 5&4 control
-	the assertion delay, also in 1/2 clocks (FASTCLK is ignored here). */
-
-/*----------------------------------------------------------------*/
-#ifdef PCMCIA
-#undef QL_INT_ACTIVE_HIGH
-#define QL_INT_ACTIVE_HIGH 0
-#endif
-
-struct qlogicfas_priv;
-typedef struct qlogicfas_priv *qlogicfas_priv_t;
-struct qlogicfas_priv {
-	 int		qbase;		/* Port */
-	 int		qinitid;	/* initiator ID */
-	 int		qabort;		/* Flag to cause an abort */
-	 int		qlirq;		/* IRQ being used */
-	 char		qinfo[80];	/* description */
-	 Scsi_Cmnd 	*qlcmd;		/* current command being processed */
-	 struct Scsi_Host	*shost;	/* pointer back to host */
-	 qlogicfas_priv_t	next;	/* next private struct */
-};
-
-extern int qlcfg5;
-extern int qlcfg6;
-extern int qlcfg7;
-extern int qlcfg8;
-extern int qlcfg9;
-extern int qlcfgc;
-
-/* The qlogic card uses two register maps - These macros select which one */
-#define REG0 ( outb( inb( qbase + 0xd ) & 0x7f , qbase + 0xd ), outb( 4 , qbase + 0xd ))
-#define REG1 ( outb( inb( qbase + 0xd ) | 0x80 , qbase + 0xd ), outb( 0xb4 | QL_INT_ACTIVE_HIGH , qbase + 0xd ))
-
-/* following is watchdog timeout in microseconds */
-#define WATCHDOG 5000000
-
-/*----------------------------------------------------------------*/
-/* the following will set the monitor border color (useful to find
-   where something crashed or gets stuck at and as a simple profiler) */
-
-#if 0
-#define rtrc(i) {inb(0x3da);outb(0x31,0x3c0);outb((i),0x3c0);}
-#else
-#define rtrc(i) {}
-#endif
-#endif	/* __QLOGICFAS_H */
-
diff -urNp -X dontdiff linux-2.6.4-applied/drivers/scsi/qlogicfas408.c linux-2.6.4-work/drivers/scsi/qlogicfas408.c
--- linux-2.6.4-applied/drivers/scsi/qlogicfas408.c	1969-12-31 21:00:00.000000000 -0300
+++ linux-2.6.4-work/drivers/scsi/qlogicfas408.c	2004-03-30 13:49:22.000000000 -0300
@@ -0,0 +1,637 @@
+/*----------------------------------------------------------------*/
+/*
+   Qlogic linux driver - work in progress. No Warranty express or implied.
+   Use at your own risk.  Support Tort Reform so you won't have to read all
+   these silly disclaimers.
+
+   Copyright 1994, Tom Zerucha.   
+   tz@execpc.com
+   
+   Additional Code, and much appreciated help by
+   Michael A. Griffith
+   grif@cs.ucr.edu
+
+   Thanks to Eric Youngdale and Dave Hinds for loadable module and PCMCIA
+   help respectively, and for suffering through my foolishness during the
+   debugging process.
+
+   Reference Qlogic FAS408 Technical Manual, 53408-510-00A, May 10, 1994
+   (you can reference it, but it is incomplete and inaccurate in places)
+
+   Version 0.46 1/30/97 - kernel 1.2.0+
+
+   Functions as standalone, loadable, and PCMCIA driver, the latter from
+   Dave Hinds' PCMCIA package.
+   
+   Cleaned up 26/10/2002 by Alan Cox <alan@redhat.com> as part of the 2.5
+   SCSI driver cleanup and audit. This driver still needs work on the
+   following
+   	-	Non terminating hardware waits
+   	-	Some layering violations with its pcmcia stub
+
+   Redistributable under terms of the GNU General Public License
+
+   For the avoidance of doubt the "preferred form" of this code is one which
+   is in an open non patent encumbered format. Where cryptographic key signing
+   forms part of the process of creating an executable the information
+   including keys needed to generate an equivalently functional executable
+   are deemed to be part of the source code.
+
+*/
+
+#include <linux/module.h>
+#include <linux/blkdev.h>		/* to get disk capacity */
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
+#include <linux/proc_fs.h>
+#include <linux/unistd.h>
+#include <linux/spinlock.h>
+#include <linux/stat.h>
+
+#include <asm/io.h>
+#include <asm/irq.h>
+#include <asm/dma.h>
+
+#include "scsi.h"
+#include "hosts.h"
+#include "qlogicfas408.h"
+
+/*----------------------------------------------------------------*/
+static int qlcfg5 = (XTALFREQ << 5);	/* 15625/512 */
+static int qlcfg6 = SYNCXFRPD;
+static int qlcfg7 = SYNCOFFST;
+static int qlcfg8 = (SLOWCABLE << 7) | (QL_ENABLE_PARITY << 4);
+static int qlcfg9 = ((XTALFREQ + 4) / 5);
+static int qlcfgc = (FASTCLK << 3) | (FASTSCSI << 4);
+
+/*----------------------------------------------------------------*/
+
+/*----------------------------------------------------------------*/
+/* local functions */
+/*----------------------------------------------------------------*/
+
+/* error recovery - reset everything */
+
+static void ql_zap(struct qlogicfas408_priv *priv)
+{
+	int x;
+	int qbase = priv->qbase;
+	int int_type = priv->int_type;
+
+	x = inb(qbase + 0xd);
+	REG0;
+	outb(3, qbase + 3);	/* reset SCSI */
+	outb(2, qbase + 3);	/* reset chip */
+	if (x & 0x80)
+		REG1;
+}
+
+/*
+ *	Do a pseudo-dma tranfer
+ */
+ 
+static int ql_pdma(struct qlogicfas408_priv *priv, int phase, char *request, int reqlen)
+{
+	int j;
+	int qbase = priv->qbase;
+	j = 0;
+	if (phase & 1) {	/* in */
+#if QL_TURBO_PDMA
+		rtrc(4)
+		/* empty fifo in large chunks */
+		if (reqlen >= 128 && (inb(qbase + 8) & 2)) {	/* full */
+			insl(qbase + 4, request, 32);
+			reqlen -= 128;
+			request += 128;
+		}
+		while (reqlen >= 84 && !(j & 0xc0))	/* 2/3 */
+			if ((j = inb(qbase + 8)) & 4) 
+			{
+				insl(qbase + 4, request, 21);
+				reqlen -= 84;
+				request += 84;
+			}
+		if (reqlen >= 44 && (inb(qbase + 8) & 8)) {	/* 1/3 */
+			insl(qbase + 4, request, 11);
+			reqlen -= 44;
+			request += 44;
+		}
+#endif
+		/* until both empty and int (or until reclen is 0) */
+		rtrc(7)
+		j = 0;
+		while (reqlen && !((j & 0x10) && (j & 0xc0))) 
+		{
+			/* while bytes to receive and not empty */
+			j &= 0xc0;
+			while (reqlen && !((j = inb(qbase + 8)) & 0x10)) 
+			{
+				*request++ = inb(qbase + 4);
+				reqlen--;
+			}
+			if (j & 0x10)
+				j = inb(qbase + 8);
+
+		}
+	} else {		/* out */
+#if QL_TURBO_PDMA
+		rtrc(4)
+		    if (reqlen >= 128 && inb(qbase + 8) & 0x10) {	/* empty */
+			outsl(qbase + 4, request, 32);
+			reqlen -= 128;
+			request += 128;
+		}
+		while (reqlen >= 84 && !(j & 0xc0))	/* 1/3 */
+			if (!((j = inb(qbase + 8)) & 8)) {
+				outsl(qbase + 4, request, 21);
+				reqlen -= 84;
+				request += 84;
+			}
+		if (reqlen >= 40 && !(inb(qbase + 8) & 4)) {	/* 2/3 */
+			outsl(qbase + 4, request, 10);
+			reqlen -= 40;
+			request += 40;
+		}
+#endif
+		/* until full and int (or until reclen is 0) */
+		rtrc(7)
+		    j = 0;
+		while (reqlen && !((j & 2) && (j & 0xc0))) {
+			/* while bytes to send and not full */
+			while (reqlen && !((j = inb(qbase + 8)) & 2)) 
+			{
+				outb(*request++, qbase + 4);
+				reqlen--;
+			}
+			if (j & 2)
+				j = inb(qbase + 8);
+		}
+	}
+	/* maybe return reqlen */
+	return inb(qbase + 8) & 0xc0;
+}
+
+/*
+ *	Wait for interrupt flag (polled - not real hardware interrupt) 
+ */
+
+static int ql_wai(struct qlogicfas408_priv *priv)
+{
+	int k;
+	int qbase = priv->qbase;
+	unsigned long i;
+
+	k = 0;
+	i = jiffies + WATCHDOG;
+	while (time_before(jiffies, i) && !priv->qabort &&
+					!((k = inb(qbase + 4)) & 0xe0)) {
+		barrier();
+		cpu_relax();
+	}
+	if (time_after_eq(jiffies, i))
+		return (DID_TIME_OUT);
+	if (priv->qabort)
+		return (priv->qabort == 1 ? DID_ABORT : DID_RESET);
+	if (k & 0x60)
+		ql_zap(priv);
+	if (k & 0x20)
+		return (DID_PARITY);
+	if (k & 0x40)
+		return (DID_ERROR);
+	return 0;
+}
+
+/*
+ *	Initiate scsi command - queueing handler 
+ *	caller must hold host lock
+ */
+
+static void ql_icmd(Scsi_Cmnd * cmd)
+{
+	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
+	int 	qbase = priv->qbase;
+	int	int_type = priv->int_type;
+	unsigned int i;
+
+	priv->qabort = 0;
+
+	REG0;
+	/* clearing of interrupts and the fifo is needed */
+
+	inb(qbase + 5);		/* clear interrupts */
+	if (inb(qbase + 5))	/* if still interrupting */
+		outb(2, qbase + 3);	/* reset chip */
+	else if (inb(qbase + 7) & 0x1f)
+		outb(1, qbase + 3);	/* clear fifo */
+	while (inb(qbase + 5));	/* clear ints */
+	REG1;
+	outb(1, qbase + 8);	/* set for PIO pseudo DMA */
+	outb(0, qbase + 0xb);	/* disable ints */
+	inb(qbase + 8);		/* clear int bits */
+	REG0;
+	outb(0x40, qbase + 0xb);	/* enable features */
+
+	/* configurables */
+	outb(qlcfgc, qbase + 0xc);
+	/* config: no reset interrupt, (initiator) bus id */
+	outb(0x40 | qlcfg8 | priv->qinitid, qbase + 8);
+	outb(qlcfg7, qbase + 7);
+	outb(qlcfg6, qbase + 6);
+	 /**/ outb(qlcfg5, qbase + 5);	/* select timer */
+	outb(qlcfg9 & 7, qbase + 9);	/* prescaler */
+/*	outb(0x99, qbase + 5);	*/
+	outb(cmd->device->id, qbase + 4);
+
+	for (i = 0; i < cmd->cmd_len; i++)
+		outb(cmd->cmnd[i], qbase + 2);
+
+	priv->qlcmd = cmd;
+	outb(0x41, qbase + 3);	/* select and send command */
+}
+
+/*
+ *	Process scsi command - usually after interrupt 
+ */
+
+static unsigned int ql_pcmd(Scsi_Cmnd * cmd)
+{
+	unsigned int i, j;
+	unsigned long k;
+	unsigned int result;	/* ultimate return result */
+	unsigned int status;	/* scsi returned status */
+	unsigned int message;	/* scsi returned message */
+	unsigned int phase;	/* recorded scsi phase */
+	unsigned int reqlen;	/* total length of transfer */
+	struct scatterlist *sglist;	/* scatter-gather list pointer */
+	unsigned int sgcount;	/* sg counter */
+	char *buf;
+	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
+	int qbase = priv->qbase;
+	int int_type = priv->int_type;
+
+	rtrc(1)
+	j = inb(qbase + 6);
+	i = inb(qbase + 5);
+	if (i == 0x20) {
+		return (DID_NO_CONNECT << 16);
+	}
+	i |= inb(qbase + 5);	/* the 0x10 bit can be set after the 0x08 */
+	if (i != 0x18) {
+		printk(KERN_ERR "Ql:Bad Interrupt status:%02x\n", i);
+		ql_zap(priv);
+		return (DID_BAD_INTR << 16);
+	}
+	j &= 7;			/* j = inb( qbase + 7 ) >> 5; */
+
+	/* correct status is supposed to be step 4 */
+	/* it sometimes returns step 3 but with 0 bytes left to send */
+	/* We can try stuffing the FIFO with the max each time, but we will get a
+	   sequence of 3 if any bytes are left (but we do flush the FIFO anyway */
+
+	if (j != 3 && j != 4) {
+		printk(KERN_ERR "Ql:Bad sequence for command %d, int %02X, cmdleft = %d\n",
+		     j, i, inb(qbase + 7) & 0x1f);
+		ql_zap(priv);
+		return (DID_ERROR << 16);
+	}
+	result = DID_OK;
+	if (inb(qbase + 7) & 0x1f)	/* if some bytes in fifo */
+		outb(1, qbase + 3);	/* clear fifo */
+	/* note that request_bufflen is the total xfer size when sg is used */
+	reqlen = cmd->request_bufflen;
+	/* note that it won't work if transfers > 16M are requested */
+	if (reqlen && !((phase = inb(qbase + 4)) & 6)) {	/* data phase */
+		rtrc(2)
+		outb(reqlen, qbase);	/* low-mid xfer cnt */
+		outb(reqlen >> 8, qbase + 1);	/* low-mid xfer cnt */
+		outb(reqlen >> 16, qbase + 0xe);	/* high xfer cnt */
+		outb(0x90, qbase + 3);	/* command do xfer */
+		/* PIO pseudo DMA to buffer or sglist */
+		REG1;
+		if (!cmd->use_sg)
+			ql_pdma(priv, phase, cmd->request_buffer,
+				cmd->request_bufflen);
+		else {
+			sgcount = cmd->use_sg;
+			sglist = cmd->request_buffer;
+			while (sgcount--) {
+				if (priv->qabort) {
+					REG0;
+					return ((priv->qabort == 1 ?
+						DID_ABORT : DID_RESET) << 16);
+				}
+				buf = page_address(sglist->page) + sglist->offset;
+				if (ql_pdma(priv, phase, buf, sglist->length))
+					break;
+				sglist++;
+			}
+		}
+		REG0;
+		rtrc(2)
+		/*
+		 *	Wait for irq (split into second state of irq handler
+		 *	if this can take time) 
+		 */
+		if ((k = ql_wai(priv)))
+			return (k << 16);
+		k = inb(qbase + 5);	/* should be 0x10, bus service */
+	}
+
+	/*
+	 *	Enter Status (and Message In) Phase 
+	 */
+	 
+	k = jiffies + WATCHDOG;
+
+	while (time_before(jiffies, k) && !priv->qabort &&
+						!(inb(qbase + 4) & 6))
+		cpu_relax();	/* wait for status phase */
+
+	if (time_after_eq(jiffies, k)) {
+		ql_zap(priv);
+		return (DID_TIME_OUT << 16);
+	}
+
+	/* FIXME: timeout ?? */
+	while (inb(qbase + 5))
+		cpu_relax();	/* clear pending ints */
+
+	if (priv->qabort)
+		return ((priv->qabort == 1 ? DID_ABORT : DID_RESET) << 16);
+
+	outb(0x11, qbase + 3);	/* get status and message */
+	if ((k = ql_wai(priv)))
+		return (k << 16);
+	i = inb(qbase + 5);	/* get chip irq stat */
+	j = inb(qbase + 7) & 0x1f;	/* and bytes rec'd */
+	status = inb(qbase + 2);
+	message = inb(qbase + 2);
+
+	/*
+	 *	Should get function complete int if Status and message, else 
+	 *	bus serv if only status 
+	 */
+	if (!((i == 8 && j == 2) || (i == 0x10 && j == 1))) {
+		printk(KERN_ERR "Ql:Error during status phase, int=%02X, %d bytes recd\n", i, j);
+		result = DID_ERROR;
+	}
+	outb(0x12, qbase + 3);	/* done, disconnect */
+	rtrc(1)
+	if ((k = ql_wai(priv)))
+		return (k << 16);
+
+	/*
+	 *	Should get bus service interrupt and disconnect interrupt 
+	 */
+	 
+	i = inb(qbase + 5);	/* should be bus service */
+	while (!priv->qabort && ((i & 0x20) != 0x20)) {
+		barrier();
+		cpu_relax();
+		i |= inb(qbase + 5);
+	}
+	rtrc(0)
+
+	if (priv->qabort)
+		return ((priv->qabort == 1 ? DID_ABORT : DID_RESET) << 16);
+		
+	return (result << 16) | (message << 8) | (status & STATUS_MASK);
+}
+
+/*
+ *	Interrupt handler 
+ */
+
+static void ql_ihandl(int irq, void *dev_id, struct pt_regs *regs)
+{
+	Scsi_Cmnd *icmd;
+	struct Scsi_Host *host = (struct Scsi_Host *)dev_id;
+	struct qlogicfas408_priv *priv = get_priv_by_host(host);
+	int qbase = priv->qbase;
+	REG0;
+
+	if (!(inb(qbase + 4) & 0x80))	/* false alarm? */
+		return;
+
+	if (priv->qlcmd == NULL) {	/* no command to process? */
+		int i;
+		i = 16;
+		while (i-- && inb(qbase + 5));	/* maybe also ql_zap() */
+		return;
+	}
+	icmd = priv->qlcmd;
+	icmd->result = ql_pcmd(icmd);
+	priv->qlcmd = NULL;
+	/*
+	 *	If result is CHECK CONDITION done calls qcommand to request 
+	 *	sense 
+	 */
+	(icmd->scsi_done) (icmd);
+}
+
+irqreturn_t qlogicfas408_ihandl(int irq, void *dev_id, struct pt_regs *regs)
+{
+	unsigned long flags;
+	struct Scsi_Host *host = dev_id;
+
+	spin_lock_irqsave(host->host_lock, flags);
+	ql_ihandl(irq, dev_id, regs);
+	spin_unlock_irqrestore(host->host_lock, flags);
+	return IRQ_HANDLED;
+}
+
+/*
+ *	Queued command
+ */
+
+int qlogicfas408_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
+{
+	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
+	if (cmd->device->id == priv->qinitid) {
+		cmd->result = DID_BAD_TARGET << 16;
+		done(cmd);
+		return 0;
+	}
+
+	cmd->scsi_done = done;
+	/* wait for the last command's interrupt to finish */
+	while (priv->qlcmd != NULL) {
+		barrier();
+		cpu_relax();
+	}
+	ql_icmd(cmd);
+	return 0;
+}
+
+/* 
+ *	Return bios parameters 
+ */
+
+int qlogicfas408_biosparam(struct scsi_device * disk,
+		        struct block_device *dev,
+			sector_t capacity, int ip[])
+{
+/* This should mimic the DOS Qlogic driver's behavior exactly */
+	ip[0] = 0x40;
+	ip[1] = 0x20;
+	ip[2] = (unsigned long) capacity / (ip[0] * ip[1]);
+	if (ip[2] > 1024) {
+		ip[0] = 0xff;
+		ip[1] = 0x3f;
+		ip[2] = (unsigned long) capacity / (ip[0] * ip[1]);
+#if 0
+		if (ip[2] > 1023)
+			ip[2] = 1023;
+#endif
+	}
+	return 0;
+}
+
+/*
+ *	Abort a command in progress
+ */
+ 
+int qlogicfas408_abort(Scsi_Cmnd * cmd)
+{
+	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
+	priv->qabort = 1;
+	ql_zap(priv);
+	return SUCCESS;
+}
+
+/* 
+ *	Reset SCSI bus
+ *	FIXME: This function is invoked with cmd = NULL directly by
+ *	the PCMCIA qlogic_stub code. This wants fixing
+ */
+
+int qlogicfas408_bus_reset(Scsi_Cmnd * cmd)
+{
+	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
+	priv->qabort = 2;
+	ql_zap(priv);
+	return SUCCESS;
+}
+
+/* 
+ *	Reset SCSI host controller
+ */
+
+int qlogicfas408_host_reset(Scsi_Cmnd * cmd)
+{
+	return FAILED;
+}
+
+/* 
+ *	Reset SCSI device
+ */
+
+int qlogicfas408_device_reset(Scsi_Cmnd * cmd)
+{
+	return FAILED;
+}
+
+/*
+ *	Return info string
+ */
+
+char *qlogicfas408_info(struct Scsi_Host *host)
+{
+	struct qlogicfas408_priv *priv = get_priv_by_host(host);
+	return priv->qinfo;
+}
+
+/*
+ *	Get type of chip
+ */
+
+int qlogicfas408_get_chip_type(int qbase, int int_type)
+{
+	REG1;
+	return inb(qbase + 0xe) & 0xf8;
+}
+
+/*
+ *	Perform initialization tasks
+ */
+
+void qlogicfas408_setup(int qbase, int id, int int_type)
+{
+	outb(1, qbase + 8);	/* set for PIO pseudo DMA */
+	REG0;
+	outb(0x40 | qlcfg8 | id, qbase + 8);	/* (ini) bus id, disable scsi rst */
+	outb(qlcfg5, qbase + 5);	/* select timer */
+	outb(qlcfg9, qbase + 9);	/* prescaler */
+
+#if QL_RESET_AT_START
+	outb(3, qbase + 3);
+
+	REG1;
+	/* FIXME: timeout */
+	while (inb(qbase + 0xf) & 4)
+		cpu_relax();
+
+	REG0;
+#endif
+}
+
+/*
+ *	Checks if this is a QLogic FAS 408
+ */
+
+int qlogicfas408_detect(int qbase, int int_type)
+{
+        REG1;
+	return (((inb(qbase + 0xe) ^ inb(qbase + 0xe)) == 7) &&
+	       ((inb(qbase + 0xe) ^ inb(qbase + 0xe)) == 7));		
+}
+
+/*
+ *	Disable interrupts
+ */
+
+void qlogicfas408_disable_ints(struct qlogicfas408_priv *priv)
+{
+	int qbase = priv->qbase;
+	int int_type = priv->int_type;
+
+	REG1;
+	outb(0, qbase + 0xb);	/* disable ints */
+}
+
+/*
+ *	Init and exit functions
+ */
+
+static int __init qlogicfas408_init(void)
+{
+	return 0;
+}
+
+static void __exit qlogicfas408_exit(void)
+{
+
+}
+
+MODULE_AUTHOR("Tom Zerucha, Michael Griffith");
+MODULE_DESCRIPTION("Driver for the Qlogic FAS SCSI controllers");
+MODULE_LICENSE("GPL");
+module_init(qlogicfas408_init);
+module_exit(qlogicfas408_exit);
+
+EXPORT_SYMBOL(qlogicfas408_info);
+EXPORT_SYMBOL(qlogicfas408_queuecommand);
+EXPORT_SYMBOL(qlogicfas408_abort);
+EXPORT_SYMBOL(qlogicfas408_bus_reset);
+EXPORT_SYMBOL(qlogicfas408_device_reset);
+EXPORT_SYMBOL(qlogicfas408_host_reset);
+EXPORT_SYMBOL(qlogicfas408_biosparam);
+EXPORT_SYMBOL(qlogicfas408_ihandl);
+EXPORT_SYMBOL(qlogicfas408_get_chip_type);
+EXPORT_SYMBOL(qlogicfas408_setup);
+EXPORT_SYMBOL(qlogicfas408_detect);
+EXPORT_SYMBOL(qlogicfas408_disable_ints);
+
diff -urNp -X dontdiff linux-2.6.4-applied/drivers/scsi/qlogicfas408.h linux-2.6.4-work/drivers/scsi/qlogicfas408.h
--- linux-2.6.4-applied/drivers/scsi/qlogicfas408.h	1969-12-31 21:00:00.000000000 -0300
+++ linux-2.6.4-work/drivers/scsi/qlogicfas408.h	2004-03-30 13:49:32.000000000 -0300
@@ -0,0 +1,120 @@
+/* to be used by qlogicfas and qlogic_cs */
+#ifndef __QLOGICFAS408_H
+#define __QLOGICFAS408_H
+
+/*----------------------------------------------------------------*/
+/* Configuration */
+
+/* Set the following to max out the speed of the PIO PseudoDMA transfers,
+   again, 0 tends to be slower, but more stable.  */
+
+#define QL_TURBO_PDMA 1
+
+/* This should be 1 to enable parity detection */
+
+#define QL_ENABLE_PARITY 1
+
+/* This will reset all devices when the driver is initialized (during bootup).
+   The other linux drivers don't do this, but the DOS drivers do, and after
+   using DOS or some kind of crash or lockup this will bring things back
+   without requiring a cold boot.  It does take some time to recover from a
+   reset, so it is slower, and I have seen timeouts so that devices weren't
+   recognized when this was set. */
+
+#define QL_RESET_AT_START 0
+
+/* crystal frequency in megahertz (for offset 5 and 9)
+   Please set this for your card.  Most Qlogic cards are 40 Mhz.  The
+   Control Concepts ISA (not VLB) is 24 Mhz */
+
+#define XTALFREQ	40
+
+/**********/
+/* DANGER! modify these at your own risk */
+/* SLOWCABLE can usually be reset to zero if you have a clean setup and
+   proper termination.  The rest are for synchronous transfers and other
+   advanced features if your device can transfer faster than 5Mb/sec.
+   If you are really curious, email me for a quick howto until I have
+   something official */
+/**********/
+
+/*****/
+/* config register 1 (offset 8) options */
+/* This needs to be set to 1 if your cabling is long or noisy */
+#define SLOWCABLE 1
+
+/*****/
+/* offset 0xc */
+/* This will set fast (10Mhz) synchronous timing when set to 1
+   For this to have an effect, FASTCLK must also be 1 */
+#define FASTSCSI 0
+
+/* This when set to 1 will set a faster sync transfer rate */
+#define FASTCLK 0	/*(XTALFREQ>25?1:0)*/
+
+/*****/
+/* offset 6 */
+/* This is the sync transfer divisor, XTALFREQ/X will be the maximum
+   achievable data rate (assuming the rest of the system is capable
+   and set properly) */
+#define SYNCXFRPD 5	/*(XTALFREQ/5)*/
+
+/*****/
+/* offset 7 */
+/* This is the count of how many synchronous transfers can take place
+	i.e. how many reqs can occur before an ack is given.
+	The maximum value for this is 15, the upper bits can modify
+	REQ/ACK assertion and deassertion during synchronous transfers
+	If this is 0, the bus will only transfer asynchronously */
+#define SYNCOFFST 0
+/* for the curious, bits 7&6 control the deassertion delay in 1/2 cycles
+	of the 40Mhz clock. If FASTCLK is 1, specifying 01 (1/2) will
+	cause the deassertion to be early by 1/2 clock.  Bits 5&4 control
+	the assertion delay, also in 1/2 clocks (FASTCLK is ignored here). */
+
+/*----------------------------------------------------------------*/
+
+struct qlogicfas408_priv {
+	 int		qbase;		/* Port */
+	 int		qinitid;	/* initiator ID */
+	 int		qabort;		/* Flag to cause an abort */
+	 int		qlirq;		/* IRQ being used */
+	 int		int_type;	/* type of irq, 2 for ISA board, 0 for PCMCIA */
+	 char		qinfo[80];	/* description */
+	 Scsi_Cmnd 	*qlcmd;		/* current command being processed */
+	 struct Scsi_Host *shost;	/* pointer back to host */
+	 struct qlogicfas408_priv *next; /* next private struct */
+};
+
+/* The qlogic card uses two register maps - These macros select which one */
+#define REG0 ( outb( inb( qbase + 0xd ) & 0x7f , qbase + 0xd ), outb( 4 , qbase + 0xd ))
+#define REG1 ( outb( inb( qbase + 0xd ) | 0x80 , qbase + 0xd ), outb( 0xb4 | int_type, qbase + 0xd ))
+
+/* following is watchdog timeout in microseconds */
+#define WATCHDOG 5000000
+
+/*----------------------------------------------------------------*/
+/* the following will set the monitor border color (useful to find
+   where something crashed or gets stuck at and as a simple profiler) */
+
+#define rtrc(i) {}
+
+#define get_priv_by_cmd(x) (struct qlogicfas408_priv *)&((x)->device->host->hostdata[0])
+#define get_priv_by_host(x) (struct qlogicfas408_priv *)&((x)->hostdata[0])
+
+irqreturn_t qlogicfas408_ihandl(int irq, void *dev_id, struct pt_regs *regs);
+int qlogicfas408_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *));
+int qlogicfas408_biosparam(struct scsi_device * disk,
+		        struct block_device *dev,
+			sector_t capacity, int ip[]);
+int qlogicfas408_abort(Scsi_Cmnd * cmd);
+int qlogicfas408_bus_reset(Scsi_Cmnd * cmd);
+int qlogicfas408_host_reset(Scsi_Cmnd * cmd);
+int qlogicfas408_device_reset(Scsi_Cmnd * cmd);
+char *qlogicfas408_info(struct Scsi_Host *host);
+int qlogicfas408_get_chip_type(int qbase, int int_type);
+void qlogicfas408_setup(int qbase, int id, int int_type);
+int qlogicfas408_detect(int qbase, int int_type);
+void qlogicfas408_disable_ints(struct qlogicfas408_priv *priv);
+#endif	/* __QLOGICFAS408_H */
+

--ALfTUftag+2gvp1h--
