From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] convert eata to pass pointers around
Date: Tue, 2 Nov 2004 15:33:51 +0100
Message-ID: <20041102143351.GA32020@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:35526 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262693AbUKBOd7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2004 09:33:59 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

passt pointers to Scsi_Host and the private data around instead of using
indices into global arrays all over the place.

(ontop of the previous Lindenting patch)


--- drivers/scsi/eata.c~	2004-11-02 14:48:13.825040776 +0100
+++ drivers/scsi/eata.c	2004-11-02 15:35:57.910633584 +0100
@@ -836,7 +836,7 @@
 	struct mssp sp;		/* Local copy of sp buffer */
 };
 
-static struct Scsi_Host *sh[MAX_BOARDS + 1];
+struct Scsi_Host *sh[MAX_BOARDS];
 static const char *driver_name = "EATA";
 static char sha[MAX_BOARDS];
 static spinlock_t driver_lock = SPIN_LOCK_UNLOCKED;
@@ -868,9 +868,6 @@
 	0x0
 };
 
-#define HD(board) ((struct hostdata *) &sh[board]->hostdata)
-#define BN(board) (HD(board)->board_name)
-
 /* Device is Big Endian */
 #define H2DEV(x)   cpu_to_be32(x)
 #define DEV2H(x)   be32_to_cpu(x)
@@ -881,7 +878,7 @@
 #define REG2H(x)   le16_to_cpu(x)
 
 static irqreturn_t do_interrupt_handler(int, void *, struct pt_regs *);
-static void flush_dev(struct scsi_device *, unsigned long, unsigned int,
+static void flush_dev(struct scsi_device *, unsigned long, struct hostdata *,
 		      unsigned int);
 static int do_trace = 0;
 static int setup_done = 0;
@@ -944,11 +941,10 @@
 
 static int eata2x_slave_configure(struct scsi_device *dev)
 {
-	int j, tqd, utqd;
+	int tqd, utqd;
 	char *tag_suffix, *link_suffix;
-	struct Scsi_Host *host = dev->host;
-
-	j = ((struct hostdata *)host->hostdata)->board_number;
+	struct Scsi_Host *shost = dev->host;
+	struct hostdata *ha = (struct hostdata *)shost->hostdata;
 
 	utqd = MAX_CMD_PER_LUN;
 	tqd = max_queue_depth;
@@ -980,7 +976,7 @@
 		link_suffix = "";
 
 	printk("%s: scsi%d, channel %d, id %d, lun %d, cmds/lun %d%s%s.\n",
-	       BN(j), host->host_no, dev->channel, dev->id, dev->lun,
+	       ha->board_name, shost->host_no, dev->channel, dev->id, dev->lun,
 	       dev->queue_depth, link_suffix, tag_suffix);
 
 	return 0;
@@ -1091,6 +1087,8 @@
 	struct pci_dev *pdev;
 	/* Allowed DMA channels for ISA (0 indicates reserved) */
 	unsigned char dma_channel_table[4] = { 5, 6, 7, 0 };
+	struct Scsi_Host *shost;
+	struct hostdata *ha;
 	char name[16];
 
 	sprintf(name, "%s%d", driver_name, j);
@@ -1272,35 +1270,38 @@
 #endif
 
 	spin_unlock_irq(&driver_lock);
-	sh[j] = scsi_register(tpnt, sizeof(struct hostdata));
+	sh[j] = shost = scsi_register(tpnt, sizeof(struct hostdata));
 	spin_lock_irq(&driver_lock);
 
-	if (sh[j] == NULL) {
+	if (shost == NULL) {
 		printk("%s: unable to register host, detaching.\n", name);
 		goto freedma;
 	}
 
-	sh[j]->io_port = port_base;
-	sh[j]->unique_id = port_base;
-	sh[j]->n_io_port = REGION_SIZE;
-	sh[j]->dma_channel = dma_channel;
-	sh[j]->irq = irq;
-	sh[j]->sg_tablesize = (ushort) info.scatt_size;
-	sh[j]->this_id = (ushort) info.host_addr[3];
-	sh[j]->can_queue = (ushort) info.queue_size;
-	sh[j]->cmd_per_lun = MAX_CMD_PER_LUN;
-	memset(HD(j), 0, sizeof(struct hostdata));
-	HD(j)->subversion = subversion;
-	HD(j)->protocol_rev = protocol_rev;
-	HD(j)->is_pci = is_pci;
-	HD(j)->pdev = pdev;
-	HD(j)->board_number = j;
+	shost->io_port = port_base;
+	shost->unique_id = port_base;
+	shost->n_io_port = REGION_SIZE;
+	shost->dma_channel = dma_channel;
+	shost->irq = irq;
+	shost->sg_tablesize = (ushort) info.scatt_size;
+	shost->this_id = (ushort) info.host_addr[3];
+	shost->can_queue = (ushort) info.queue_size;
+	shost->cmd_per_lun = MAX_CMD_PER_LUN;
+
+	ha = (struct hostdata *)shost->hostdata;
+	
+	memset(ha, 0, sizeof(struct hostdata));
+	ha->subversion = subversion;
+	ha->protocol_rev = protocol_rev;
+	ha->is_pci = is_pci;
+	ha->pdev = pdev;
+	ha->board_number = j;
 
-	if (HD(j)->subversion == ESA)
-		sh[j]->unchecked_isa_dma = 0;
+	if (ha->subversion == ESA)
+		shost->unchecked_isa_dma = 0;
 	else {
 		unsigned long flags;
-		sh[j]->unchecked_isa_dma = 1;
+		shost->unchecked_isa_dma = 1;
 
 		flags = claim_dma_lock();
 		disable_dma(dma_channel);
@@ -1311,36 +1312,36 @@
 
 	}
 
-	strcpy(BN(j), name);
+	strcpy(ha->board_name, name);
 
 	/* DPT PM2012 does not allow to detect sg_tablesize correctly */
-	if (sh[j]->sg_tablesize > MAX_SGLIST || sh[j]->sg_tablesize < 2) {
+	if (shost->sg_tablesize > MAX_SGLIST || shost->sg_tablesize < 2) {
 		printk("%s: detect, wrong n. of SG lists %d, fixed.\n",
-		       BN(j), sh[j]->sg_tablesize);
-		sh[j]->sg_tablesize = MAX_SGLIST;
+		       ha->board_name, shost->sg_tablesize);
+		shost->sg_tablesize = MAX_SGLIST;
 	}
 
 	/* DPT PM2012 does not allow to detect can_queue correctly */
-	if (sh[j]->can_queue > MAX_MAILBOXES || sh[j]->can_queue < 2) {
+	if (shost->can_queue > MAX_MAILBOXES || shost->can_queue < 2) {
 		printk("%s: detect, wrong n. of mbox %d, fixed.\n",
-		       BN(j), sh[j]->can_queue);
-		sh[j]->can_queue = MAX_MAILBOXES;
+		       ha->board_name, shost->can_queue);
+		shost->can_queue = MAX_MAILBOXES;
 	}
 
 	if (protocol_rev != 'A') {
 		if (info.max_chan > 0 && info.max_chan < MAX_CHANNEL)
-			sh[j]->max_channel = info.max_chan;
+			shost->max_channel = info.max_chan;
 
 		if (info.max_id > 7 && info.max_id < MAX_TARGET)
-			sh[j]->max_id = info.max_id + 1;
+			shost->max_id = info.max_id + 1;
 
-		if (info.large_sg && sh[j]->sg_tablesize == MAX_SGLIST)
-			sh[j]->sg_tablesize = MAX_LARGE_SGLIST;
+		if (info.large_sg && shost->sg_tablesize == MAX_SGLIST)
+			shost->sg_tablesize = MAX_LARGE_SGLIST;
 	}
 
 	if (protocol_rev == 'C') {
 		if (info.max_lun > 7 && info.max_lun < MAX_LUN)
-			sh[j]->max_lun = info.max_lun + 1;
+			shost->max_lun = info.max_lun + 1;
 	}
 
 	if (dma_channel == NO_DMA)
@@ -1350,28 +1351,28 @@
 
 	spin_unlock_irq(&driver_lock);
 
-	for (i = 0; i < sh[j]->can_queue; i++)
-		HD(j)->cp[i].cp_dma_addr = pci_map_single(HD(j)->pdev,
-							  &HD(j)->cp[i],
+	for (i = 0; i < shost->can_queue; i++)
+		ha->cp[i].cp_dma_addr = pci_map_single(ha->pdev,
+							  &ha->cp[i],
 							  sizeof(struct mscp),
 							  PCI_DMA_BIDIRECTIONAL);
 
-	for (i = 0; i < sh[j]->can_queue; i++) {
-		size_t sz = sh[j]->sg_tablesize *sizeof(struct sg_list);
-		unsigned int gfp_mask = (sh[j]->unchecked_isa_dma ? GFP_DMA : 0) | GFP_ATOMIC;
-		(&HD(j)->cp[i])->sglist = kmalloc(sz, gfp_mask);
-		if (!(&HD(j)->cp[i])->sglist) {
+	for (i = 0; i < shost->can_queue; i++) {
+		size_t sz = shost->sg_tablesize *sizeof(struct sg_list);
+		unsigned int gfp_mask = (shost->unchecked_isa_dma ? GFP_DMA : 0) | GFP_ATOMIC;
+		ha->cp[i].sglist = kmalloc(sz, gfp_mask);
+		if (!ha->cp[i].sglist) {
 			printk
 			    ("%s: kmalloc SGlist failed, mbox %d, detaching.\n",
-			     BN(j), i);
+			     ha->board_name, i);
 			goto release;
 		}
 	}
 
-	if (!(HD(j)->sp_cpu_addr = pci_alloc_consistent(HD(j)->pdev,
+	if (!(ha->sp_cpu_addr = pci_alloc_consistent(ha->pdev,
 							sizeof(struct mssp),
-							&HD(j)->sp_dma_addr))) {
-		printk("%s: pci_alloc_consistent failed, detaching.\n", BN(j));
+							&ha->sp_dma_addr))) {
+		printk("%s: pci_alloc_consistent failed, detaching.\n", ha->board_name);
 		goto release;
 	}
 
@@ -1396,18 +1397,18 @@
 	}
 
 	printk("%s: 2.0%c, %s 0x%03lx, IRQ %u, %s, SG %d, MB %d.\n",
-	       BN(j), HD(j)->protocol_rev, bus_type,
-	       (unsigned long)sh[j]->io_port, sh[j]->irq, dma_name,
-	       sh[j]->sg_tablesize, sh[j]->can_queue);
+	       ha->board_name, ha->protocol_rev, bus_type,
+	       (unsigned long)shost->io_port, shost->irq, dma_name,
+	       shost->sg_tablesize, shost->can_queue);
 
-	if (sh[j]->max_id > 8 || sh[j]->max_lun > 8)
+	if (shost->max_id > 8 || shost->max_lun > 8)
 		printk
 		    ("%s: wide SCSI support enabled, max_id %u, max_lun %u.\n",
-		     BN(j), sh[j]->max_id, sh[j]->max_lun);
+		     ha->board_name, shost->max_id, shost->max_lun);
 
-	for (i = 0; i <= sh[j]->max_channel; i++)
+	for (i = 0; i <= shost->max_channel; i++)
 		printk("%s: SCSI channel %u enabled, host target ID %d.\n",
-		       BN(j), i, info.host_addr[3 - i]);
+		       ha->board_name, i, info.host_addr[3 - i]);
 
 #if defined(DEBUG_DETECT)
 	printk("%s: Vers. 0x%x, ocs %u, tar %u, trnxfr %u, more %u, SYNC 0x%x, "
@@ -1427,11 +1428,11 @@
 		       info.idquest, info.pci, info.eisa, info.raidnum);
 #endif
 
-	if (HD(j)->pdev) {
-		pci_set_master(HD(j)->pdev);
-		if (pci_set_dma_mask(HD(j)->pdev, 0xffffffff))
+	if (ha->pdev) {
+		pci_set_master(ha->pdev);
+		if (pci_set_dma_mask(ha->pdev, 0xffffffff))
 			printk("%s: warning, pci_set_dma_mask failed.\n",
-			       BN(j));
+			       ha->board_name);
 	}
 
 	return 1;
@@ -1448,7 +1449,7 @@
 	return 0;
 
       release:
-	eata2x_release(sh[j]);
+	eata2x_release(shost);
 	return 0;
 }
 
@@ -1578,9 +1579,6 @@
 	}
 #endif
 
-	for (k = 0; k < MAX_BOARDS + 1; k++)
-		sh[k] = NULL;
-
 	for (k = MAX_INT_PARAM; io_port[k]; k++)
 		if (io_port[k] == SKIP)
 			continue;
@@ -1613,21 +1611,20 @@
 	return j;
 }
 
-static void map_dma(unsigned int i, unsigned int j)
+static void map_dma(unsigned int i, struct hostdata *ha)
 {
 	unsigned int k, count, pci_dir;
 	struct scatterlist *sgpnt;
 	struct mscp *cpp;
 	struct scsi_cmnd *SCpnt;
 
-	cpp = &HD(j)->cp[i];
+	cpp = &ha->cp[i];
 	SCpnt = cpp->SCpnt;
 	pci_dir = SCpnt->sc_data_direction;
 
 	if (SCpnt->sense_buffer)
 		cpp->sense_addr =
-		    H2DEV(pci_map_single
-			  (HD(j)->pdev, SCpnt->sense_buffer,
+		    H2DEV(pci_map_single(ha->pdev, SCpnt->sense_buffer,
 			   sizeof SCpnt->sense_buffer, PCI_DMA_FROMDEVICE));
 
 	cpp->sense_len = sizeof SCpnt->sense_buffer;
@@ -1639,7 +1636,7 @@
 			pci_dir = PCI_DMA_BIDIRECTIONAL;
 
 		if (SCpnt->request_buffer)
-			cpp->data_address = H2DEV(pci_map_single(HD(j)->pdev,
+			cpp->data_address = H2DEV(pci_map_single(ha->pdev,
 								 SCpnt->
 								 request_buffer,
 								 SCpnt->
@@ -1651,7 +1648,7 @@
 	}
 
 	sgpnt = (struct scatterlist *)SCpnt->request_buffer;
-	count = pci_map_sg(HD(j)->pdev, sgpnt, SCpnt->use_sg, pci_dir);
+	count = pci_map_sg(ha->pdev, sgpnt, SCpnt->use_sg, pci_dir);
 
 	for (k = 0; k < count; k++) {
 		cpp->sglist[k].address = H2DEV(sg_dma_address(&sgpnt[k]));
@@ -1659,68 +1656,68 @@
 	}
 
 	cpp->sg = 1;
-	cpp->data_address = H2DEV(pci_map_single(HD(j)->pdev, cpp->sglist,
+	cpp->data_address = H2DEV(pci_map_single(ha->pdev, cpp->sglist,
 						 SCpnt->use_sg *
 						 sizeof(struct sg_list),
 						 pci_dir));
 	cpp->data_len = H2DEV((SCpnt->use_sg * sizeof(struct sg_list)));
 }
 
-static void unmap_dma(unsigned int i, unsigned int j)
+static void unmap_dma(unsigned int i, struct hostdata *ha)
 {
 	unsigned int pci_dir;
 	struct mscp *cpp;
 	struct scsi_cmnd *SCpnt;
 
-	cpp = &HD(j)->cp[i];
+	cpp = &ha->cp[i];
 	SCpnt = cpp->SCpnt;
 	pci_dir = SCpnt->sc_data_direction;
 
 	if (DEV2H(cpp->sense_addr))
-		pci_unmap_single(HD(j)->pdev, DEV2H(cpp->sense_addr),
+		pci_unmap_single(ha->pdev, DEV2H(cpp->sense_addr),
 				 DEV2H(cpp->sense_len), PCI_DMA_FROMDEVICE);
 
 	if (SCpnt->use_sg)
-		pci_unmap_sg(HD(j)->pdev, SCpnt->request_buffer, SCpnt->use_sg,
+		pci_unmap_sg(ha->pdev, SCpnt->request_buffer, SCpnt->use_sg,
 			     pci_dir);
 
 	if (!DEV2H(cpp->data_len))
 		pci_dir = PCI_DMA_BIDIRECTIONAL;
 
 	if (DEV2H(cpp->data_address))
-		pci_unmap_single(HD(j)->pdev, DEV2H(cpp->data_address),
+		pci_unmap_single(ha->pdev, DEV2H(cpp->data_address),
 				 DEV2H(cpp->data_len), pci_dir);
 }
 
-static void sync_dma(unsigned int i, unsigned int j)
+static void sync_dma(unsigned int i, struct hostdata *ha)
 {
 	unsigned int pci_dir;
 	struct mscp *cpp;
 	struct scsi_cmnd *SCpnt;
 
-	cpp = &HD(j)->cp[i];
+	cpp = &ha->cp[i];
 	SCpnt = cpp->SCpnt;
 	pci_dir = SCpnt->sc_data_direction;
 
 	if (DEV2H(cpp->sense_addr))
-		pci_dma_sync_single_for_cpu(HD(j)->pdev, DEV2H(cpp->sense_addr),
+		pci_dma_sync_single_for_cpu(ha->pdev, DEV2H(cpp->sense_addr),
 					    DEV2H(cpp->sense_len),
 					    PCI_DMA_FROMDEVICE);
 
 	if (SCpnt->use_sg)
-		pci_dma_sync_sg_for_cpu(HD(j)->pdev, SCpnt->request_buffer,
+		pci_dma_sync_sg_for_cpu(ha->pdev, SCpnt->request_buffer,
 					SCpnt->use_sg, pci_dir);
 
 	if (!DEV2H(cpp->data_len))
 		pci_dir = PCI_DMA_BIDIRECTIONAL;
 
 	if (DEV2H(cpp->data_address))
-		pci_dma_sync_single_for_cpu(HD(j)->pdev,
+		pci_dma_sync_single_for_cpu(ha->pdev,
 					    DEV2H(cpp->data_address),
 					    DEV2H(cpp->data_len), pci_dir);
 }
 
-static void scsi_to_dev_dir(unsigned int i, unsigned int j)
+static void scsi_to_dev_dir(unsigned int i, struct hostdata *ha)
 {
 	unsigned int k;
 
@@ -1739,7 +1736,7 @@
 	struct mscp *cpp;
 	struct scsi_cmnd *SCpnt;
 
-	cpp = &HD(j)->cp[i];
+	cpp = &ha->cp[i];
 	SCpnt = cpp->SCpnt;
 
 	if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {
@@ -1757,7 +1754,8 @@
 	}
 
 	if (SCpnt->sc_data_direction != DMA_BIDIRECTIONAL)
-		panic("%s: qcomm, invalid SCpnt->sc_data_direction.\n", BN(j));
+		panic("%s: qcomm, invalid SCpnt->sc_data_direction.\n",
+				ha->board_name);
 
 	for (k = 0; k < ARRAY_SIZE(data_out_cmds); k++)
 		if (SCpnt->cmnd[0] == data_out_cmds[k]) {
@@ -1777,43 +1775,40 @@
 static int eata2x_queuecommand(struct scsi_cmnd *SCpnt,
 			       void (*done) (struct scsi_cmnd *))
 {
-	unsigned int i, j, k;
+	struct Scsi_Host *shost = SCpnt->device->host;
+	struct hostdata *ha = (struct hostdata *)shost->hostdata;
+	unsigned int i, k;
 	struct mscp *cpp;
 
-	/* j is the board number */
-	j = ((struct hostdata *)SCpnt->device->host->hostdata)->board_number;
-
 	if (SCpnt->host_scribble)
 		panic("%s: qcomm, pid %ld, SCpnt %p already active.\n",
-		      BN(j), SCpnt->pid, SCpnt);
+		      ha->board_name, SCpnt->pid, SCpnt);
 
 	/* i is the mailbox number, look for the first free mailbox
 	   starting from last_cp_used */
-	i = HD(j)->last_cp_used + 1;
-
-	for (k = 0; k < sh[j]->can_queue; k++, i++) {
+	i = ha->last_cp_used + 1;
 
-		if (i >= sh[j]->can_queue)
+	for (k = 0; k < shost->can_queue; k++, i++) {
+		if (i >= shost->can_queue)
 			i = 0;
-
-		if (HD(j)->cp_stat[i] == FREE) {
-			HD(j)->last_cp_used = i;
+		if (ha->cp_stat[i] == FREE) {
+			ha->last_cp_used = i;
 			break;
 		}
 	}
 
-	if (k == sh[j]->can_queue) {
-		printk("%s: qcomm, no free mailbox.\n", BN(j));
+	if (k == shost->can_queue) {
+		printk("%s: qcomm, no free mailbox.\n", ha->board_name);
 		return 1;
 	}
 
 	/* Set pointer to control packet structure */
-	cpp = &HD(j)->cp[i];
+	cpp = &ha->cp[i];
 
 	memset(cpp, 0, sizeof(struct mscp) - CP_TAIL_SIZE);
 
 	/* Set pointer to status packet structure, Big Endian format */
-	cpp->sp_dma_addr = H2DEV(HD(j)->sp_dma_addr);
+	cpp->sp_dma_addr = H2DEV(ha->sp_dma_addr);
 
 	SCpnt->scsi_done = done;
 	cpp->cpp_index = i;
@@ -1821,7 +1816,7 @@
 
 	if (do_trace)
 		printk("%s: qcomm, mbox %d, target %d.%d:%d, pid %ld.\n",
-		       BN(j), i, SCpnt->device->channel, SCpnt->device->id,
+		       ha->board_name, i, SCpnt->device->channel, SCpnt->device->id,
 		       SCpnt->device->lun, SCpnt->pid);
 
 	cpp->reqsen = 1;
@@ -1838,234 +1833,234 @@
 	memcpy(cpp->cdb, SCpnt->cmnd, SCpnt->cmd_len);
 
 	/* Use data transfer direction SCpnt->sc_data_direction */
-	scsi_to_dev_dir(i, j);
+	scsi_to_dev_dir(i, ha);
 
 	/* Map DMA buffers and SG list */
-	map_dma(i, j);
+	map_dma(i, ha);
 
 	if (linked_comm && SCpnt->device->queue_depth > 2
 	    && TLDEV(SCpnt->device->type)) {
-		HD(j)->cp_stat[i] = READY;
-		flush_dev(SCpnt->device, SCpnt->request->sector, j, 0);
+		ha->cp_stat[i] = READY;
+		flush_dev(SCpnt->device, SCpnt->request->sector, ha, 0);
 		return 0;
 	}
 
 	/* Send control packet to the board */
-	if (do_dma(sh[j]->io_port, cpp->cp_dma_addr, SEND_CP_DMA)) {
-		unmap_dma(i, j);
+	if (do_dma(shost->io_port, cpp->cp_dma_addr, SEND_CP_DMA)) {
+		unmap_dma(i, ha);
 		SCpnt->host_scribble = NULL;
 		printk("%s: qcomm, target %d.%d:%d, pid %ld, adapter busy.\n",
-		       BN(j), SCpnt->device->channel, SCpnt->device->id,
+		       ha->board_name, SCpnt->device->channel, SCpnt->device->id,
 		       SCpnt->device->lun, SCpnt->pid);
 		return 1;
 	}
 
-	HD(j)->cp_stat[i] = IN_USE;
+	ha->cp_stat[i] = IN_USE;
 	return 0;
 }
 
 static int eata2x_eh_abort(struct scsi_cmnd *SCarg)
 {
-	unsigned int i, j;
-
-	j = ((struct hostdata *)SCarg->device->host->hostdata)->board_number;
+	struct Scsi_Host *shost = SCarg->device->host;
+	struct hostdata *ha = (struct hostdata *)shost->hostdata;
+	unsigned int i;
 
 	if (SCarg->host_scribble == NULL) {
 		printk("%s: abort, target %d.%d:%d, pid %ld inactive.\n",
-		       BN(j), SCarg->device->channel, SCarg->device->id,
+		       ha->board_name, SCarg->device->channel, SCarg->device->id,
 		       SCarg->device->lun, SCarg->pid);
 		return SUCCESS;
 	}
 
 	i = *(unsigned int *)SCarg->host_scribble;
 	printk("%s: abort, mbox %d, target %d.%d:%d, pid %ld.\n",
-	       BN(j), i, SCarg->device->channel, SCarg->device->id,
+	       ha->board_name, i, SCarg->device->channel, SCarg->device->id,
 	       SCarg->device->lun, SCarg->pid);
 
-	if (i >= sh[j]->can_queue)
-		panic("%s: abort, invalid SCarg->host_scribble.\n", BN(j));
+	if (i >= shost->can_queue)
+		panic("%s: abort, invalid SCarg->host_scribble.\n", ha->board_name);
 
-	if (wait_on_busy(sh[j]->io_port, MAXLOOP)) {
-		printk("%s: abort, timeout error.\n", BN(j));
+	if (wait_on_busy(shost->io_port, MAXLOOP)) {
+		printk("%s: abort, timeout error.\n", ha->board_name);
 		return FAILED;
 	}
 
-	if (HD(j)->cp_stat[i] == FREE) {
-		printk("%s: abort, mbox %d is free.\n", BN(j), i);
+	if (ha->cp_stat[i] == FREE) {
+		printk("%s: abort, mbox %d is free.\n", ha->board_name, i);
 		return SUCCESS;
 	}
 
-	if (HD(j)->cp_stat[i] == IN_USE) {
-		printk("%s: abort, mbox %d is in use.\n", BN(j), i);
+	if (ha->cp_stat[i] == IN_USE) {
+		printk("%s: abort, mbox %d is in use.\n", ha->board_name, i);
 
-		if (SCarg != HD(j)->cp[i].SCpnt)
+		if (SCarg != ha->cp[i].SCpnt)
 			panic("%s: abort, mbox %d, SCarg %p, cp SCpnt %p.\n",
-			      BN(j), i, SCarg, HD(j)->cp[i].SCpnt);
+			      ha->board_name, i, SCarg, ha->cp[i].SCpnt);
 
-		if (inb(sh[j]->io_port + REG_AUX_STATUS) & IRQ_ASSERTED)
+		if (inb(shost->io_port + REG_AUX_STATUS) & IRQ_ASSERTED)
 			printk("%s: abort, mbox %d, interrupt pending.\n",
-			       BN(j), i);
+			       ha->board_name, i);
 
 		if (SCarg->eh_state == SCSI_STATE_TIMEOUT) {
-			unmap_dma(i, j);
+			unmap_dma(i, ha);
 			SCarg->host_scribble = NULL;
-			HD(j)->cp_stat[i] = FREE;
+			ha->cp_stat[i] = FREE;
 			printk
 			    ("%s, abort, mbox %d, eh_state timeout, pid %ld.\n",
-			     BN(j), i, SCarg->pid);
+			     ha->board_name, i, SCarg->pid);
 			return SUCCESS;
 		}
 
 		return FAILED;
 	}
 
-	if (HD(j)->cp_stat[i] == IN_RESET) {
-		printk("%s: abort, mbox %d is in reset.\n", BN(j), i);
+	if (ha->cp_stat[i] == IN_RESET) {
+		printk("%s: abort, mbox %d is in reset.\n", ha->board_name, i);
 		return FAILED;
 	}
 
-	if (HD(j)->cp_stat[i] == LOCKED) {
-		printk("%s: abort, mbox %d is locked.\n", BN(j), i);
+	if (ha->cp_stat[i] == LOCKED) {
+		printk("%s: abort, mbox %d is locked.\n", ha->board_name, i);
 		return SUCCESS;
 	}
 
-	if (HD(j)->cp_stat[i] == READY || HD(j)->cp_stat[i] == ABORTING) {
-		unmap_dma(i, j);
+	if (ha->cp_stat[i] == READY || ha->cp_stat[i] == ABORTING) {
+		unmap_dma(i, ha);
 		SCarg->result = DID_ABORT << 16;
 		SCarg->host_scribble = NULL;
-		HD(j)->cp_stat[i] = FREE;
+		ha->cp_stat[i] = FREE;
 		printk("%s, abort, mbox %d ready, DID_ABORT, pid %ld done.\n",
-		       BN(j), i, SCarg->pid);
+		       ha->board_name, i, SCarg->pid);
 		SCarg->scsi_done(SCarg);
 		return SUCCESS;
 	}
 
-	panic("%s: abort, mbox %d, invalid cp_stat.\n", BN(j), i);
+	panic("%s: abort, mbox %d, invalid cp_stat.\n", ha->board_name, i);
 }
 
 static int eata2x_eh_host_reset(struct scsi_cmnd *SCarg)
 {
-	unsigned int i, j, time, k, c, limit = 0;
+	unsigned int i, time, k, c, limit = 0;
 	int arg_done = 0;
 	struct scsi_cmnd *SCpnt;
+	struct Scsi_Host *shost = SCarg->device->host;
+	struct hostdata *ha = (struct hostdata *)shost->hostdata;
 
-	j = ((struct hostdata *)SCarg->device->host->hostdata)->board_number;
 	printk("%s: reset, enter, target %d.%d:%d, pid %ld.\n",
-	       BN(j), SCarg->device->channel, SCarg->device->id,
+	       ha->board_name, SCarg->device->channel, SCarg->device->id,
 	       SCarg->device->lun, SCarg->pid);
 
 	if (SCarg->host_scribble == NULL)
-		printk("%s: reset, pid %ld inactive.\n", BN(j), SCarg->pid);
+		printk("%s: reset, pid %ld inactive.\n", ha->board_name, SCarg->pid);
 
-	if (HD(j)->in_reset) {
-		printk("%s: reset, exit, already in reset.\n", BN(j));
+	if (ha->in_reset) {
+		printk("%s: reset, exit, already in reset.\n", ha->board_name);
 		return FAILED;
 	}
 
-	if (wait_on_busy(sh[j]->io_port, MAXLOOP)) {
-		printk("%s: reset, exit, timeout error.\n", BN(j));
+	if (wait_on_busy(shost->io_port, MAXLOOP)) {
+		printk("%s: reset, exit, timeout error.\n", ha->board_name);
 		return FAILED;
 	}
 
-	HD(j)->retries = 0;
+	ha->retries = 0;
 
-	for (c = 0; c <= sh[j]->max_channel; c++)
-		for (k = 0; k < sh[j]->max_id; k++) {
-			HD(j)->target_redo[k][c] = 1;
-			HD(j)->target_to[k][c] = 0;
+	for (c = 0; c <= shost->max_channel; c++)
+		for (k = 0; k < shost->max_id; k++) {
+			ha->target_redo[k][c] = 1;
+			ha->target_to[k][c] = 0;
 		}
 
-	for (i = 0; i < sh[j]->can_queue; i++) {
+	for (i = 0; i < shost->can_queue; i++) {
 
-		if (HD(j)->cp_stat[i] == FREE)
+		if (ha->cp_stat[i] == FREE)
 			continue;
 
-		if (HD(j)->cp_stat[i] == LOCKED) {
-			HD(j)->cp_stat[i] = FREE;
+		if (ha->cp_stat[i] == LOCKED) {
+			ha->cp_stat[i] = FREE;
 			printk("%s: reset, locked mbox %d forced free.\n",
-			       BN(j), i);
+			       ha->board_name, i);
 			continue;
 		}
 
-		if (!(SCpnt = HD(j)->cp[i].SCpnt))
-			panic("%s: reset, mbox %d, SCpnt == NULL.\n", BN(j), i);
+		if (!(SCpnt = ha->cp[i].SCpnt))
+			panic("%s: reset, mbox %d, SCpnt == NULL.\n", ha->board_name, i);
 
-		if (HD(j)->cp_stat[i] == READY || HD(j)->cp_stat[i] == ABORTING) {
-			HD(j)->cp_stat[i] = ABORTING;
+		if (ha->cp_stat[i] == READY || ha->cp_stat[i] == ABORTING) {
+			ha->cp_stat[i] = ABORTING;
 			printk("%s: reset, mbox %d aborting, pid %ld.\n",
-			       BN(j), i, SCpnt->pid);
+			       ha->board_name, i, SCpnt->pid);
 		}
 
 		else {
-			HD(j)->cp_stat[i] = IN_RESET;
+			ha->cp_stat[i] = IN_RESET;
 			printk("%s: reset, mbox %d in reset, pid %ld.\n",
-			       BN(j), i, SCpnt->pid);
+			       ha->board_name, i, SCpnt->pid);
 		}
 
 		if (SCpnt->host_scribble == NULL)
-			panic("%s: reset, mbox %d, garbled SCpnt.\n", BN(j), i);
+			panic("%s: reset, mbox %d, garbled SCpnt.\n", ha->board_name, i);
 
 		if (*(unsigned int *)SCpnt->host_scribble != i)
-			panic("%s: reset, mbox %d, index mismatch.\n", BN(j),
-			      i);
+			panic("%s: reset, mbox %d, index mismatch.\n", ha->board_name, i);
 
 		if (SCpnt->scsi_done == NULL)
 			panic("%s: reset, mbox %d, SCpnt->scsi_done == NULL.\n",
-			      BN(j), i);
+			      ha->board_name, i);
 
 		if (SCpnt == SCarg)
 			arg_done = 1;
 	}
 
-	if (do_dma(sh[j]->io_port, 0, RESET_PIO)) {
-		printk("%s: reset, cannot reset, timeout error.\n", BN(j));
+	if (do_dma(shost->io_port, 0, RESET_PIO)) {
+		printk("%s: reset, cannot reset, timeout error.\n", ha->board_name);
 		return FAILED;
 	}
 
-	printk("%s: reset, board reset done, enabling interrupts.\n", BN(j));
+	printk("%s: reset, board reset done, enabling interrupts.\n", ha->board_name);
 
 #if defined(DEBUG_RESET)
 	do_trace = 1;
 #endif
 
-	HD(j)->in_reset = 1;
+	ha->in_reset = 1;
 
-	spin_unlock_irq(sh[j]->host_lock);
+	spin_unlock_irq(shost->host_lock);
 	time = jiffies;
 	while ((jiffies - time) < (10 * HZ) && limit++ < 200000)
 		udelay(100L);
-	spin_lock_irq(sh[j]->host_lock);
+	spin_lock_irq(shost->host_lock);
 
-	printk("%s: reset, interrupts disabled, loops %d.\n", BN(j), limit);
+	printk("%s: reset, interrupts disabled, loops %d.\n", ha->board_name, limit);
 
-	for (i = 0; i < sh[j]->can_queue; i++) {
+	for (i = 0; i < shost->can_queue; i++) {
 
-		if (HD(j)->cp_stat[i] == IN_RESET) {
-			SCpnt = HD(j)->cp[i].SCpnt;
-			unmap_dma(i, j);
+		if (ha->cp_stat[i] == IN_RESET) {
+			SCpnt = ha->cp[i].SCpnt;
+			unmap_dma(i, ha);
 			SCpnt->result = DID_RESET << 16;
 			SCpnt->host_scribble = NULL;
 
 			/* This mailbox is still waiting for its interrupt */
-			HD(j)->cp_stat[i] = LOCKED;
+			ha->cp_stat[i] = LOCKED;
 
 			printk
 			    ("%s, reset, mbox %d locked, DID_RESET, pid %ld done.\n",
-			     BN(j), i, SCpnt->pid);
+			     ha->board_name, i, SCpnt->pid);
 		}
 
-		else if (HD(j)->cp_stat[i] == ABORTING) {
-			SCpnt = HD(j)->cp[i].SCpnt;
-			unmap_dma(i, j);
+		else if (ha->cp_stat[i] == ABORTING) {
+			SCpnt = ha->cp[i].SCpnt;
+			unmap_dma(i, ha);
 			SCpnt->result = DID_RESET << 16;
 			SCpnt->host_scribble = NULL;
 
 			/* This mailbox was never queued to the adapter */
-			HD(j)->cp_stat[i] = FREE;
+			ha->cp_stat[i] = FREE;
 
 			printk
 			    ("%s, reset, mbox %d aborting, DID_RESET, pid %ld done.\n",
-			     BN(j), i, SCpnt->pid);
+			     ha->board_name, i, SCpnt->pid);
 		}
 
 		else
@@ -2075,13 +2070,13 @@
 		SCpnt->scsi_done(SCpnt);
 	}
 
-	HD(j)->in_reset = 0;
+	ha->in_reset = 0;
 	do_trace = 0;
 
 	if (arg_done)
-		printk("%s: reset, exit, pid %ld done.\n", BN(j), SCarg->pid);
+		printk("%s: reset, exit, pid %ld done.\n", ha->board_name, SCarg->pid);
 	else
-		printk("%s: reset, exit.\n", BN(j));
+		printk("%s: reset, exit.\n", ha->board_name);
 
 	return SUCCESS;
 }
@@ -2135,7 +2130,7 @@
 	return;
 }
 
-static int reorder(unsigned int j, unsigned long cursec,
+static int reorder(struct hostdata *ha, unsigned long cursec,
 		   unsigned int ihdlr, unsigned int il[], unsigned int n_ready)
 {
 	struct scsi_cmnd *SCpnt;
@@ -2164,7 +2159,7 @@
 
 	for (n = 0; n < n_ready; n++) {
 		k = il[n];
-		cpp = &HD(j)->cp[k];
+		cpp = &ha->cp[k];
 		SCpnt = cpp->SCpnt;
 
 		if (!cpp->din)
@@ -2214,7 +2209,7 @@
 	if (!input_only)
 		for (n = 0; n < n_ready; n++) {
 			k = il[n];
-			cpp = &HD(j)->cp[k];
+			cpp = &ha->cp[k];
 			SCpnt = cpp->SCpnt;
 			ll[n] = SCpnt->request->nr_sectors;
 			pl[n] = SCpnt->pid;
@@ -2259,7 +2254,7 @@
 	if (link_statistics && (overlap || !(flushcount % link_statistics)))
 		for (n = 0; n < n_ready; n++) {
 			k = il[n];
-			cpp = &HD(j)->cp[k];
+			cpp = &ha->cp[k];
 			SCpnt = cpp->SCpnt;
 			printk
 			    ("%s %d.%d:%d pid %ld mb %d fc %d nr %d sec %ld ns %ld"
@@ -2277,100 +2272,100 @@
 }
 
 static void flush_dev(struct scsi_device *dev, unsigned long cursec,
-		      unsigned int j, unsigned int ihdlr)
+		      struct hostdata *ha, unsigned int ihdlr)
 {
 	struct scsi_cmnd *SCpnt;
 	struct mscp *cpp;
 	unsigned int k, n, n_ready = 0, il[MAX_MAILBOXES];
 
-	for (k = 0; k < sh[j]->can_queue; k++) {
+	for (k = 0; k < dev->host->can_queue; k++) {
 
-		if (HD(j)->cp_stat[k] != READY && HD(j)->cp_stat[k] != IN_USE)
+		if (ha->cp_stat[k] != READY && ha->cp_stat[k] != IN_USE)
 			continue;
 
-		cpp = &HD(j)->cp[k];
+		cpp = &ha->cp[k];
 		SCpnt = cpp->SCpnt;
 
 		if (SCpnt->device != dev)
 			continue;
 
-		if (HD(j)->cp_stat[k] == IN_USE)
+		if (ha->cp_stat[k] == IN_USE)
 			return;
 
 		il[n_ready++] = k;
 	}
 
-	if (reorder(j, cursec, ihdlr, il, n_ready))
+	if (reorder(ha, cursec, ihdlr, il, n_ready))
 		n_ready = 1;
 
 	for (n = 0; n < n_ready; n++) {
 		k = il[n];
-		cpp = &HD(j)->cp[k];
+		cpp = &ha->cp[k];
 		SCpnt = cpp->SCpnt;
 
-		if (do_dma(sh[j]->io_port, cpp->cp_dma_addr, SEND_CP_DMA)) {
+		if (do_dma(dev->host->io_port, cpp->cp_dma_addr, SEND_CP_DMA)) {
 			printk
 			    ("%s: %s, target %d.%d:%d, pid %ld, mbox %d, adapter"
-			     " busy, will abort.\n", BN(j),
+			     " busy, will abort.\n", ha->board_name,
 			     (ihdlr ? "ihdlr" : "qcomm"),
 			     SCpnt->device->channel, SCpnt->device->id,
 			     SCpnt->device->lun, SCpnt->pid, k);
-			HD(j)->cp_stat[k] = ABORTING;
+			ha->cp_stat[k] = ABORTING;
 			continue;
 		}
 
-		HD(j)->cp_stat[k] = IN_USE;
+		ha->cp_stat[k] = IN_USE;
 	}
-
 }
 
-static irqreturn_t ihdlr(int irq, unsigned int j)
+static irqreturn_t ihdlr(int irq, struct Scsi_Host *shost)
 {
 	struct scsi_cmnd *SCpnt;
 	unsigned int i, k, c, status, tstatus, reg;
 	struct mssp *spp;
 	struct mscp *cpp;
+	struct hostdata *ha = (struct hostdata *)shost->hostdata;
 
-	if (sh[j]->irq != irq)
-		panic("%s: ihdlr, irq %d, sh[j]->irq %d.\n", BN(j), irq,
-		      sh[j]->irq);
+	if (shost->irq != irq)
+		panic("%s: ihdlr, irq %d, shost->irq %d.\n", ha->board_name, irq,
+		      shost->irq);
 
 	/* Check if this board need to be serviced */
-	if (!(inb(sh[j]->io_port + REG_AUX_STATUS) & IRQ_ASSERTED))
+	if (!(inb(shost->io_port + REG_AUX_STATUS) & IRQ_ASSERTED))
 		goto none;
 
-	HD(j)->iocount++;
+	ha->iocount++;
 
 	if (do_trace)
-		printk("%s: ihdlr, enter, irq %d, count %d.\n", BN(j), irq,
-		       HD(j)->iocount);
+		printk("%s: ihdlr, enter, irq %d, count %d.\n", ha->board_name, irq,
+		       ha->iocount);
 
 	/* Check if this board is still busy */
-	if (wait_on_busy(sh[j]->io_port, 20 * MAXLOOP)) {
-		reg = inb(sh[j]->io_port + REG_STATUS);
+	if (wait_on_busy(shost->io_port, 20 * MAXLOOP)) {
+		reg = inb(shost->io_port + REG_STATUS);
 		printk
 		    ("%s: ihdlr, busy timeout error,  irq %d, reg 0x%x, count %d.\n",
-		     BN(j), irq, reg, HD(j)->iocount);
+		     ha->board_name, irq, reg, ha->iocount);
 		goto none;
 	}
 
-	spp = &HD(j)->sp;
+	spp = &ha->sp;
 
 	/* Make a local copy just before clearing the interrupt indication */
-	memcpy(spp, HD(j)->sp_cpu_addr, sizeof(struct mssp));
+	memcpy(spp, ha->sp_cpu_addr, sizeof(struct mssp));
 
 	/* Clear the completion flag and cp pointer on the dynamic copy of sp */
-	memset(HD(j)->sp_cpu_addr, 0, sizeof(struct mssp));
+	memset(ha->sp_cpu_addr, 0, sizeof(struct mssp));
 
 	/* Read the status register to clear the interrupt indication */
-	reg = inb(sh[j]->io_port + REG_STATUS);
+	reg = inb(shost->io_port + REG_STATUS);
 
 #if defined (DEBUG_INTERRUPT)
 	{
 		unsigned char *bytesp;
 		int cnt;
 		bytesp = (unsigned char *)spp;
-		if (HD(j)->iocount < 200) {
+		if (ha->iocount < 200) {
 			printk("sp[] =");
 			for (cnt = 0; cnt < 15; cnt++)
 				printk(" 0x%x", bytesp[cnt]);
@@ -2380,71 +2375,71 @@
 #endif
 
 	/* Reject any sp with supspect data */
-	if (spp->eoc == 0 && HD(j)->iocount > 1)
+	if (spp->eoc == 0 && ha->iocount > 1)
 		printk
 		    ("%s: ihdlr, spp->eoc == 0, irq %d, reg 0x%x, count %d.\n",
-		     BN(j), irq, reg, HD(j)->iocount);
-	if (spp->cpp_index < 0 || spp->cpp_index >= sh[j]->can_queue)
+		     ha->board_name, irq, reg, ha->iocount);
+	if (spp->cpp_index < 0 || spp->cpp_index >= shost->can_queue)
 		printk
 		    ("%s: ihdlr, bad spp->cpp_index %d, irq %d, reg 0x%x, count %d.\n",
-		     BN(j), spp->cpp_index, irq, reg, HD(j)->iocount);
+		     ha->board_name, spp->cpp_index, irq, reg, ha->iocount);
 	if (spp->eoc == 0 || spp->cpp_index < 0
-	    || spp->cpp_index >= sh[j]->can_queue)
+	    || spp->cpp_index >= shost->can_queue)
 		goto handled;
 
 	/* Find the mailbox to be serviced on this board */
 	i = spp->cpp_index;
 
-	cpp = &(HD(j)->cp[i]);
+	cpp = &(ha->cp[i]);
 
 #if defined(DEBUG_GENERATE_ABORTS)
-	if ((HD(j)->iocount > 500) && ((HD(j)->iocount % 500) < 3))
+	if ((ha->iocount > 500) && ((ha->iocount % 500) < 3))
 		goto handled;
 #endif
 
-	if (HD(j)->cp_stat[i] == IGNORE) {
-		HD(j)->cp_stat[i] = FREE;
+	if (ha->cp_stat[i] == IGNORE) {
+		ha->cp_stat[i] = FREE;
 		goto handled;
-	} else if (HD(j)->cp_stat[i] == LOCKED) {
-		HD(j)->cp_stat[i] = FREE;
-		printk("%s: ihdlr, mbox %d unlocked, count %d.\n", BN(j), i,
-		       HD(j)->iocount);
+	} else if (ha->cp_stat[i] == LOCKED) {
+		ha->cp_stat[i] = FREE;
+		printk("%s: ihdlr, mbox %d unlocked, count %d.\n", ha->board_name, i,
+		       ha->iocount);
 		goto handled;
-	} else if (HD(j)->cp_stat[i] == FREE) {
-		printk("%s: ihdlr, mbox %d is free, count %d.\n", BN(j), i,
-		       HD(j)->iocount);
+	} else if (ha->cp_stat[i] == FREE) {
+		printk("%s: ihdlr, mbox %d is free, count %d.\n", ha->board_name, i,
+		       ha->iocount);
 		goto handled;
-	} else if (HD(j)->cp_stat[i] == IN_RESET)
-		printk("%s: ihdlr, mbox %d is in reset.\n", BN(j), i);
-	else if (HD(j)->cp_stat[i] != IN_USE)
+	} else if (ha->cp_stat[i] == IN_RESET)
+		printk("%s: ihdlr, mbox %d is in reset.\n", ha->board_name, i);
+	else if (ha->cp_stat[i] != IN_USE)
 		panic("%s: ihdlr, mbox %d, invalid cp_stat: %d.\n",
-		      BN(j), i, HD(j)->cp_stat[i]);
+		      ha->board_name, i, ha->cp_stat[i]);
 
-	HD(j)->cp_stat[i] = FREE;
+	ha->cp_stat[i] = FREE;
 	SCpnt = cpp->SCpnt;
 
 	if (SCpnt == NULL)
-		panic("%s: ihdlr, mbox %d, SCpnt == NULL.\n", BN(j), i);
+		panic("%s: ihdlr, mbox %d, SCpnt == NULL.\n", ha->board_name, i);
 
 	if (SCpnt->host_scribble == NULL)
-		panic("%s: ihdlr, mbox %d, pid %ld, SCpnt %p garbled.\n", BN(j),
+		panic("%s: ihdlr, mbox %d, pid %ld, SCpnt %p garbled.\n", ha->board_name,
 		      i, SCpnt->pid, SCpnt);
 
 	if (*(unsigned int *)SCpnt->host_scribble != i)
 		panic("%s: ihdlr, mbox %d, pid %ld, index mismatch %d.\n",
-		      BN(j), i, SCpnt->pid,
+		      ha->board_name, i, SCpnt->pid,
 		      *(unsigned int *)SCpnt->host_scribble);
 
-	sync_dma(i, j);
+	sync_dma(i, ha);
 
 	if (linked_comm && SCpnt->device->queue_depth > 2
 	    && TLDEV(SCpnt->device->type))
-		flush_dev(SCpnt->device, SCpnt->request->sector, j, 1);
+		flush_dev(SCpnt->device, SCpnt->request->sector, ha, 1);
 
 	tstatus = status_byte(spp->target_status);
 
 #if defined(DEBUG_GENERATE_ERRORS)
-	if ((HD(j)->iocount > 500) && ((HD(j)->iocount % 200) < 2))
+	if ((ha->iocount > 500) && ((ha->iocount % 200) < 2))
 		spp->adapter_status = 0x01;
 #endif
 
@@ -2457,7 +2452,7 @@
 
 		/* If there was a bus reset, redo operation on each target */
 		else if (tstatus != GOOD && SCpnt->device->type == TYPE_DISK
-			 && HD(j)->target_redo[SCpnt->device->id][SCpnt->
+			 && ha->target_redo[SCpnt->device->id][SCpnt->
 								  device->
 								  channel])
 			status = DID_BUS_BUSY << 16;
@@ -2472,33 +2467,33 @@
 			status = DID_OK << 16;
 
 		if (tstatus == GOOD)
-			HD(j)->target_redo[SCpnt->device->id][SCpnt->device->
+			ha->target_redo[SCpnt->device->id][SCpnt->device->
 							      channel] = 0;
 
 		if (spp->target_status && SCpnt->device->type == TYPE_DISK &&
-		    (!(tstatus == CHECK_CONDITION && HD(j)->iocount <= 1000 &&
+		    (!(tstatus == CHECK_CONDITION && ha->iocount <= 1000 &&
 		       (SCpnt->sense_buffer[2] & 0xf) == NOT_READY)))
 			printk("%s: ihdlr, target %d.%d:%d, pid %ld, "
-			       "target_status 0x%x, sense key 0x%x.\n", BN(j),
+			       "target_status 0x%x, sense key 0x%x.\n",
+			       ha->board_name,
 			       SCpnt->device->channel, SCpnt->device->id,
 			       SCpnt->device->lun, SCpnt->pid,
 			       spp->target_status, SCpnt->sense_buffer[2]);
 
-		HD(j)->target_to[SCpnt->device->id][SCpnt->device->channel] = 0;
+		ha->target_to[SCpnt->device->id][SCpnt->device->channel] = 0;
 
-		if (HD(j)->last_retried_pid == SCpnt->pid)
-			HD(j)->retries = 0;
+		if (ha->last_retried_pid == SCpnt->pid)
+			ha->retries = 0;
 
 		break;
 	case ASST:		/* Selection Time Out */
 	case 0x02:		/* Command Time Out   */
 
-		if (HD(j)->
-		    target_to[SCpnt->device->id][SCpnt->device->channel] > 1)
+		if (ha->target_to[SCpnt->device->id][SCpnt->device->channel] > 1)
 			status = DID_ERROR << 16;
 		else {
 			status = DID_TIME_OUT << 16;
-			HD(j)->target_to[SCpnt->device->id][SCpnt->device->
+			ha->target_to[SCpnt->device->id][SCpnt->device->
 							    channel]++;
 		}
 
@@ -2508,12 +2503,12 @@
 	case 0x03:		/* SCSI Bus Reset Received */
 	case 0x04:		/* Initial Controller Power-up */
 
-		for (c = 0; c <= sh[j]->max_channel; c++)
-			for (k = 0; k < sh[j]->max_id; k++)
-				HD(j)->target_redo[k][c] = 1;
+		for (c = 0; c <= shost->max_channel; c++)
+			for (k = 0; k < shost->max_id; k++)
+				ha->target_redo[k][c] = 1;
 
 		if (SCpnt->device->type != TYPE_TAPE
-		    && HD(j)->retries < MAX_INTERNAL_RETRIES) {
+		    && ha->retries < MAX_INTERNAL_RETRIES) {
 
 #if defined(DID_SOFT_ERROR)
 			status = DID_SOFT_ERROR << 16;
@@ -2521,8 +2516,8 @@
 			status = DID_BUS_BUSY << 16;
 #endif
 
-			HD(j)->retries++;
-			HD(j)->last_retried_pid = SCpnt->pid;
+			ha->retries++;
+			ha->last_retried_pid = SCpnt->pid;
 		} else
 			status = DID_ERROR << 16;
 
@@ -2545,18 +2540,18 @@
 #if defined(DEBUG_INTERRUPT)
 	if (SCpnt->result || do_trace)
 #else
-	if ((spp->adapter_status != ASOK && HD(j)->iocount > 1000) ||
+	if ((spp->adapter_status != ASOK && ha->iocount > 1000) ||
 	    (spp->adapter_status != ASOK &&
-	     spp->adapter_status != ASST && HD(j)->iocount <= 1000) ||
+	     spp->adapter_status != ASST && ha->iocount <= 1000) ||
 	    do_trace || msg_byte(spp->target_status))
 #endif
 		printk("%s: ihdlr, mbox %2d, err 0x%x:%x,"
 		       " target %d.%d:%d, pid %ld, reg 0x%x, count %d.\n",
-		       BN(j), i, spp->adapter_status, spp->target_status,
+		       ha->board_name, i, spp->adapter_status, spp->target_status,
 		       SCpnt->device->channel, SCpnt->device->id,
-		       SCpnt->device->lun, SCpnt->pid, reg, HD(j)->iocount);
+		       SCpnt->device->lun, SCpnt->pid, reg, ha->iocount);
 
-	unmap_dma(i, j);
+	unmap_dma(i, ha);
 
 	/* Set the command state to inactive */
 	SCpnt->host_scribble = NULL;
@@ -2564,8 +2559,8 @@
 	SCpnt->scsi_done(SCpnt);
 
 	if (do_trace)
-		printk("%s: ihdlr, exit, irq %d, count %d.\n", BN(j), irq,
-		       HD(j)->iocount);
+		printk("%s: ihdlr, exit, irq %d, count %d.\n", ha->board_name,
+				irq, ha->iocount);
 
       handled:
 	return IRQ_HANDLED;
@@ -2576,6 +2571,7 @@
 static irqreturn_t do_interrupt_handler(int irq, void *shap,
 					struct pt_regs *regs)
 {
+	struct Scsi_Host *shost;
 	unsigned int j;
 	unsigned long spin_flags;
 	irqreturn_t ret;
@@ -2583,41 +2579,38 @@
 	/* Check if the interrupt must be processed by this handler */
 	if ((j = (unsigned int)((char *)shap - sha)) >= num_boards)
 		return IRQ_NONE;
+	shost = sh[j];
 
-	spin_lock_irqsave(sh[j]->host_lock, spin_flags);
-	ret = ihdlr(irq, j);
-	spin_unlock_irqrestore(sh[j]->host_lock, spin_flags);
+	spin_lock_irqsave(shost->host_lock, spin_flags);
+	ret = ihdlr(irq, shost);
+	spin_unlock_irqrestore(shost->host_lock, spin_flags);
 	return ret;
 }
 
-static int eata2x_release(struct Scsi_Host *shpnt)
+static int eata2x_release(struct Scsi_Host *shost)
 {
-	unsigned int i, j;
-
-	for (j = 0; sh[j] != NULL && sh[j] != shpnt; j++) ;
-
-	if (sh[j] == NULL)
-		panic("%s: release, invalid Scsi_Host pointer.\n", driver_name);
+	struct hostdata *ha = (struct hostdata *)shost->hostdata;
+	unsigned int i;
 
-	for (i = 0; i < sh[j]->can_queue; i++)
-		if ((&HD(j)->cp[i])->sglist)
-			kfree((&HD(j)->cp[i])->sglist);
+	for (i = 0; i < shost->can_queue; i++)
+		if ((&ha->cp[i])->sglist)
+			kfree((&ha->cp[i])->sglist);
 
-	for (i = 0; i < sh[j]->can_queue; i++)
-		pci_unmap_single(HD(j)->pdev, HD(j)->cp[i].cp_dma_addr,
+	for (i = 0; i < shost->can_queue; i++)
+		pci_unmap_single(ha->pdev, ha->cp[i].cp_dma_addr,
 				 sizeof(struct mscp), PCI_DMA_BIDIRECTIONAL);
 
-	if (HD(j)->sp_cpu_addr)
-		pci_free_consistent(HD(j)->pdev, sizeof(struct mssp),
-				    HD(j)->sp_cpu_addr, HD(j)->sp_dma_addr);
+	if (ha->sp_cpu_addr)
+		pci_free_consistent(ha->pdev, sizeof(struct mssp),
+				    ha->sp_cpu_addr, ha->sp_dma_addr);
 
-	free_irq(sh[j]->irq, &sha[j]);
+	free_irq(shost->irq, &sha[ha->board_number]);
 
-	if (sh[j]->dma_channel != NO_DMA)
-		free_dma(sh[j]->dma_channel);
+	if (shost->dma_channel != NO_DMA)
+		free_dma(shost->dma_channel);
 
-	release_region(sh[j]->io_port, sh[j]->n_io_port);
-	scsi_unregister(sh[j]);
+	release_region(shost->io_port, shost->n_io_port);
+	scsi_unregister(shost);
 	return 0;
 }
 
