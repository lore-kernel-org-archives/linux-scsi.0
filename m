From: Paul Mackerras <paulus@samba.org>
Subject: [PATCH] update mac53c94 scsi driver
Date: Sun, 23 Mar 2003 15:19:32 +1100 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <15997.13780.518276.558779@nanango.paulus.ozlabs.org>
Reply-To: paulus@samba.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, torvalds@transmeta.com

This patch updates the mac53c94 scsi HBA driver, used on older
powermacs, to correspond with the recent scsi subsystem changes, to
use the PCI DMA API, to not panic, and to use a spinlock instead of
save_flags/restore_flags/cli/sti. 

Paul.

diff -urN linux-2.5/drivers/scsi/mac53c94.c linuxppc-2.5/drivers/scsi/mac53c94.c
--- linux-2.5/drivers/scsi/mac53c94.c	2002-02-06 02:28:32.000000000 +1100
+++ linuxppc-2.5/drivers/scsi/mac53c94.c	2003-02-09 16:38:15.000000000 +1100
@@ -16,11 +16,13 @@
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
 #include <linux/spinlock.h>
+#include <linux/interrupt.h>
 #include <asm/dbdma.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/prom.h>
 #include <asm/system.h>
+#include <asm/pci-bridge.h>
 
 #include "scsi.h"
 #include "hosts.h"
@@ -48,6 +50,8 @@
 	enum fsc_phase phase;		/* what we're currently trying to do */
 	struct dbdma_cmd *dma_cmds;	/* space for dbdma commands, aligned */
 	void	*dma_cmd_space;
+	struct	pci_dev *pdev;
+	dma_addr_t dma_addr;
 };
 
 static struct fsc_state *all_53c94s;
@@ -70,36 +74,66 @@
 	void *dma_cmd_space;
 	unsigned char *clkprop;
 	int proplen;
+	struct pci_dev *pdev;
+	u8 pbus, devfn;
 
 	nfscs = 0;
 	prev_statep = &all_53c94s;
 	for (node = find_devices("53c94"); node != 0; node = node->next) {
-		if (node->n_addrs != 2 || node->n_intrs != 2)
-			panic("53c94: expected 2 addrs and intrs (got %d/%d)",
-			      node->n_addrs, node->n_intrs);
+		if (node->n_addrs != 2 || node->n_intrs != 2) {
+			printk(KERN_ERR "mac53c94: expected 2 addrs and intrs"
+			       " (got %d/%d) for node %s\n",
+			       node->n_addrs, node->n_intrs, node->full_name);
+			continue;
+		}
+
+		pdev = NULL;
+		if (node->parent != NULL
+		    && !pci_device_from_OF_node(node->parent, &pbus, &devfn))
+			pdev = pci_find_slot(pbus, devfn);
+		if (pdev == NULL) {
+			printk(KERN_ERR "mac53c94: can't find PCI device "
+			       "for %s\n", node->full_name);
+			continue;
+		}
+
 		host = scsi_register(tp, sizeof(struct fsc_state));
 		if (host == NULL)
 			break;
 		host->unique_id = nfscs;
-#ifndef MODULE
-		note_scsi_host(node, host);
-#endif
 
 		state = (struct fsc_state *) host->hostdata;
-		if (state == 0)
-			panic("no 53c94 state");
+		if (state == 0) {
+			/* "can't happen" */
+			printk(KERN_ERR "mac53c94: no state for %s?!\n",
+			       node->full_name);
+			scsi_unregister(host);
+			break;
+		}
 		state->host = host;
+		state->pdev = pdev;
+
 		state->regs = (volatile struct mac53c94_regs *)
 			ioremap(node->addrs[0].address, 0x1000);
 		state->intr = node->intrs[0].line;
 		state->dma = (volatile struct dbdma_regs *)
 			ioremap(node->addrs[1].address, 0x1000);
 		state->dmaintr = node->intrs[1].line;
+		if (state->regs == NULL || state->dma == NULL) {
+			printk(KERN_ERR "mac53c94: ioremap failed for %s\n",
+			       node->full_name);
+			if (state->dma != NULL)
+				iounmap(state->dma);
+			if (state->regs != NULL)
+				iounmap(state->regs);
+			scsi_unregister(host);
+			break;
+		}
 
 		clkprop = get_property(node, "clock-frequency", &proplen);
 		if (clkprop == NULL || proplen != sizeof(int)) {
-			printk(KERN_ERR "%s: can't get clock frequency\n",
-			       node->full_name);
+			printk(KERN_ERR "%s: can't get clock frequency, "
+			       "assuming 25MHz\n", node->full_name);
 			state->clk_freq = 25000000;
 		} else
 			state->clk_freq = *(int *)clkprop;
@@ -108,8 +142,11 @@
 		   +1 to allow for aligning. */
 		dma_cmd_space = kmalloc((host->sg_tablesize + 2) *
 					sizeof(struct dbdma_cmd), GFP_KERNEL);
-		if (dma_cmd_space == 0)
-			panic("53c94: couldn't allocate dma command space");
+		if (dma_cmd_space == 0) {
+			printk(KERN_ERR "mac53c94: couldn't allocate dma "
+			       "command space for %s\n", node->full_name);
+			goto err_cleanup;
+		}
 		state->dma_cmds = (struct dbdma_cmd *)
 			DBDMA_ALIGN(dma_cmd_space);
 		memset(state->dma_cmds, 0, (host->sg_tablesize + 1)
@@ -121,7 +158,13 @@
 
 		if (request_irq(state->intr, do_mac53c94_interrupt, 0,
 				"53C94", state)) {
-			printk(KERN_ERR "mac53C94: can't get irq %d\n", state->intr);
+			printk(KERN_ERR "mac53C94: can't get irq %d for %s\n",
+			       state->intr, node->full_name);
+		err_cleanup:
+			iounmap(state->dma);
+			iounmap(state->regs);
+			scsi_unregister(host);
+			break;
 		}
 
 		mac53c94_init(state);
@@ -150,7 +193,6 @@
 int
 mac53c94_queue(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
 {
-	unsigned long flags;
 	struct fsc_state *state;
 
 #if 0
@@ -167,10 +209,8 @@
 	cmd->scsi_done = done;
 	cmd->host_scribble = NULL;
 
-	state = (struct fsc_state *) cmd->host->hostdata;
+	state = (struct fsc_state *) cmd->device->host->hostdata;
 
-	save_flags(flags);
-	cli();
 	if (state->request_q == NULL)
 		state->request_q = cmd;
 	else
@@ -180,7 +220,6 @@
 	if (state->phase == idle)
 		mac53c94_start(state);
 
-	restore_flags(flags);
 	return 0;
 }
 
@@ -191,15 +230,12 @@
 }
 
 int
-mac53c94_reset(Scsi_Cmnd *cmd, unsigned how)
+mac53c94_host_reset(Scsi_Cmnd *cmd)
 {
-	struct fsc_state *state = (struct fsc_state *) cmd->host->hostdata;
+	struct fsc_state *state = (struct fsc_state *) cmd->device->host->hostdata;
 	volatile struct mac53c94_regs *regs = state->regs;
 	volatile struct dbdma_regs *dma = state->dma;
-	unsigned long flags;
 
-	save_flags(flags);
-	cli();
 	st_le32(&dma->control, (RUN|PAUSE|FLUSH|WAKE) << 16);
 	regs->command = CMD_SCSI_RESET;	/* assert RST */
 	eieio();
@@ -210,15 +246,7 @@
 	mac53c94_init(state);
 	regs->command = CMD_NOP;
 	eieio();
-	restore_flags(flags);
-	return SCSI_RESET_PENDING;
-}
-
-int
-mac53c94_command(Scsi_Cmnd *cmd)
-{
-	printk(KERN_DEBUG "whoops... mac53c94_command called\n");
-	return -1;
+	return SUCCESS;
 }
 
 static void
@@ -269,7 +297,7 @@
 	regs->command = CMD_FLUSH;
 	udelay(1);
 	eieio();
-	regs->dest_id = cmd->target;
+	regs->dest_id = cmd->device->id;
 	regs->sync_period = 0;
 	regs->sync_offset = 0;
 	eieio();
@@ -292,7 +320,7 @@
 do_mac53c94_interrupt(int irq, void *dev_id, struct pt_regs *ptregs)
 {
 	unsigned long flags;
-	struct Scsi_Host *dev = ((struct fsc_state *) dev_id)->current_req->host;
+	struct Scsi_Host *dev = ((struct fsc_state *) dev_id)->current_req->device->host;
 	
 	spin_lock_irqsave(dev->host_lock, flags);
 	mac53c94_interrupt(irq, dev_id, ptregs);
@@ -308,6 +336,7 @@
 	Scsi_Cmnd *cmd = state->current_req;
 	int nb, stat, seq, intr;
 	static int mac53c94_errors;
+	int dma_dir;
 
 	/*
 	 * Apparently, reading the interrupt register unlatches
@@ -427,7 +456,16 @@
 		if ((stat & STAT_PHASE) != STAT_CD + STAT_IO) {
 			printk(KERN_DEBUG "intr %x before data xfer complete\n", intr);
 		}
-		st_le32(&dma->control, RUN << 16);	/* stop dma */
+		out_le32(&dma->control, RUN << 16);	/* stop dma */
+		dma_dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
+		if (cmd->use_sg != 0) {
+			pci_unmap_sg(state->pdev,
+				(struct scatterlist *)cmd->request_buffer,
+				cmd->use_sg, dma_dir);
+		} else {
+			pci_unmap_single(state->pdev, state->dma_addr,
+				cmd->request_bufflen, dma_dir);
+		}
 		/* should check dma status */
 		regs->command = CMD_I_COMPLETE;
 		state->phase = completing;
@@ -480,19 +518,27 @@
 	int i, dma_cmd, total;
 	struct scatterlist *scl;
 	struct dbdma_cmd *dcmds;
+	dma_addr_t dma_addr;
+	u32 dma_len;
+	int dma_dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
 
 	dma_cmd = data_goes_out(cmd)? OUTPUT_MORE: INPUT_MORE;
 	dcmds = state->dma_cmds;
 	if (cmd->use_sg > 0) {
+		int nseg;
+
 		total = 0;
 		scl = (struct scatterlist *) cmd->buffer;
-		for (i = 0; i < cmd->use_sg; ++i) {
-			if (scl->length > 0xffff)
+		nseg = pci_map_sg(state->pdev, scl, cmd->use_sg, dma_dir);
+		for (i = 0; i < nseg; ++i) {
+			dma_addr = sg_dma_address(scl);
+			dma_len = sg_dma_len(scl);
+			if (dma_len > 0xffff)
 				panic("mac53c94: scatterlist element >= 64k");
-			total += scl->length;
-			st_le16(&dcmds->req_count, scl->length);
+			total += dma_len;
+			st_le16(&dcmds->req_count, dma_len);
 			st_le16(&dcmds->command, dma_cmd);
-			st_le32(&dcmds->phy_addr, virt_to_phys(scl->address));
+			st_le32(&dcmds->phy_addr, dma_addr);
 			dcmds->xfer_status = 0;
 			++scl;
 			++dcmds;
@@ -501,8 +547,11 @@
 		total = cmd->request_bufflen;
 		if (total > 0xffff)
 			panic("mac53c94: transfer size >= 64k");
+		dma_addr = pci_map_single(state->pdev, cmd->request_buffer,
+					  total, dma_dir);
+		state->dma_addr = dma_addr;
 		st_le16(&dcmds->req_count, total);
-		st_le32(&dcmds->phy_addr, virt_to_phys(cmd->request_buffer));
+		st_le32(&dcmds->phy_addr, dma_addr);
 		dcmds->xfer_status = 0;
 		++dcmds;
 	}
@@ -514,12 +563,19 @@
 
 /*
  * Work out whether data will be going out from the host adaptor or into it.
- * (If this information is available from somewhere else in the scsi
- * code, somebody please let me know :-)
  */
 static int
 data_goes_out(Scsi_Cmnd *cmd)
 {
+	switch (cmd->sc_data_direction) {
+	case SCSI_DATA_WRITE:
+		return 1;
+	case SCSI_DATA_READ:
+		return 0;
+	}
+
+	/* for SCSI_DATA_UNKNOWN or SCSI_DATA_NONE, fall back on the
+	   old method for now... */
 	switch (cmd->cmnd[0]) {
 	case CHANGE_DEFINITION: 
 	case COMPARE:	  
@@ -557,6 +613,19 @@
 	}
 }
 
-static Scsi_Host_Template driver_template = SCSI_MAC53C94;
+static Scsi_Host_Template driver_template = {
+	.proc_name	= "53c94",
+	.name		= "53C94",
+	.detect		= mac53c94_detect,
+	.release	= mac53c94_release,
+	.queuecommand	= mac53c94_queue,
+	.eh_abort_handler = mac53c94_abort,
+	.eh_host_reset_handler = mac53c94_host_reset,
+	.can_queue	= 1,
+	.this_id	= 7,
+	.sg_tablesize	= SG_ALL,
+	.cmd_per_lun	= 1,
+	.use_clustering	= DISABLE_CLUSTERING,
+};
 
 #include "scsi_module.c"
diff -urN linux-2.5/drivers/scsi/mac53c94.h linuxppc-2.5/drivers/scsi/mac53c94.h
--- linux-2.5/drivers/scsi/mac53c94.h	2002-12-11 07:28:33.000000000 +1100
+++ linuxppc-2.5/drivers/scsi/mac53c94.h	2003-01-09 09:48:37.000000000 +1100
@@ -7,29 +7,6 @@
 #ifndef _MAC53C94_H
 #define _MAC53C94_H
 
-int mac53c94_detect(Scsi_Host_Template *);
-int mac53c94_release(struct Scsi_Host *);
-int mac53c94_command(Scsi_Cmnd *);
-int mac53c94_queue(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-int mac53c94_abort(Scsi_Cmnd *);
-int mac53c94_reset(Scsi_Cmnd *, unsigned int);
-
-#define SCSI_MAC53C94 {					\
-	.proc_name	= "53c94",			\
-	.name		= "53C94",			\
-	.detect		= mac53c94_detect,		\
-	.release	= mac53c94_release,		\
-	.command	= mac53c94_command,		\
-	.queuecommand	= mac53c94_queue,			\
-	.abort		= mac53c94_abort,			\
-	.reset		= mac53c94_reset,			\
-	.can_queue	= 1,				\
-	.this_id	= 7,				\
-	.sg_tablesize	= SG_ALL,				\
-	.cmd_per_lun	= 1,				\
-	.use_clustering	= DISABLE_CLUSTERING,		\
-}
-
 /*
  * Registers in the 53C94 controller.
  */
