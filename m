From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix up request buffer reference in various scsi drivers
Date: Sat, 3 Jun 2006 13:21:13 +0200
Message-ID: <20060603112113.GA17018@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:42711 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932611AbWFCLVX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Jun 2006 07:21:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Various scsi drivers use scsi_cmnd.buffer and scsi_cmnd.bufflen in their
queuecommand functions.  Those fields are internal storage for the
midlayer only and are used to restore the original payload after
request_buffer and request_bufflen have been overwritten for EH.  Using
the buffer and bufflen fields means they do very broken things in error
handling.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/block/cciss_scsi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/block/cciss_scsi.c	2006-06-03 12:07:51.000000000 +0200
+++ scsi-misc-2.6/drivers/block/cciss_scsi.c	2006-06-03 12:25:32.000000000 +0200
@@ -578,7 +578,7 @@
 
 	if (cmd->use_sg) {
 		pci_unmap_sg(ctlr->pdev,
-			cmd->buffer, cmd->use_sg,
+			cmd->request_buffer, cmd->use_sg,
 				cmd->sc_data_direction); 
 	}
 	else if (cmd->request_bufflen) {
@@ -1210,7 +1210,7 @@
 		struct scsi_cmnd *cmd)
 {
 	unsigned int use_sg, nsegs=0, len;
-	struct scatterlist *scatter = (struct scatterlist *) cmd->buffer;
+	struct scatterlist *scatter = (struct scatterlist *) cmd->request_buffer;
 	__u64 addr64;
 
 	/* is it just one virtual address? */	
@@ -1232,7 +1232,7 @@
 	} /* else, must be a list of virtual addresses.... */
 	else if (cmd->use_sg <= MAXSGENTRIES) {	/* not too many addrs? */
 
-		use_sg = pci_map_sg(pdev, cmd->buffer, cmd->use_sg, 
+		use_sg = pci_map_sg(pdev, cmd->request_buffer, cmd->use_sg,
 			cmd->sc_data_direction);
 
 		for (nsegs=0; nsegs < use_sg; nsegs++) {
Index: scsi-misc-2.6/drivers/scsi/3w-9xxx.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/3w-9xxx.c	2006-06-03 12:07:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/3w-9xxx.c	2006-06-03 12:25:32.000000000 +0200
@@ -1388,7 +1388,7 @@
 	if (cmd->use_sg == 0)
 		goto out;
 
-	use_sg = pci_map_sg(pdev, cmd->buffer, cmd->use_sg, DMA_BIDIRECTIONAL);
+	use_sg = pci_map_sg(pdev, cmd->request_buffer, cmd->use_sg, DMA_BIDIRECTIONAL);
 
 	if (use_sg == 0) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1c, "Failed to map scatter gather list");
Index: scsi-misc-2.6/drivers/scsi/3w-xxxx.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/3w-xxxx.c	2006-06-03 12:07:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/3w-xxxx.c	2006-06-03 12:25:32.000000000 +0200
@@ -1286,7 +1286,7 @@
 	if (cmd->use_sg == 0)
 		return 0;
 
-	use_sg = pci_map_sg(pdev, cmd->buffer, cmd->use_sg, DMA_BIDIRECTIONAL);
+	use_sg = pci_map_sg(pdev, cmd->request_buffer, cmd->use_sg, DMA_BIDIRECTIONAL);
 	
 	if (use_sg == 0) {
 		printk(KERN_WARNING "3w-xxxx: tw_map_scsi_sg_data(): pci_map_sg() failed.\n");
Index: scsi-misc-2.6/drivers/scsi/NCR5380.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/NCR5380.c	2006-06-03 12:07:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/NCR5380.c	2006-06-03 12:25:32.000000000 +0200
@@ -296,7 +296,7 @@
 	 */
 
 	if (cmd->use_sg) {
-		cmd->SCp.buffer = (struct scatterlist *) cmd->buffer;
+		cmd->SCp.buffer = (struct scatterlist *) cmd->request_buffer;
 		cmd->SCp.buffers_residual = cmd->use_sg - 1;
 		cmd->SCp.ptr = page_address(cmd->SCp.buffer->page)+
 			       cmd->SCp.buffer->offset;
Index: scsi-misc-2.6/drivers/scsi/aacraid/aachba.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aacraid/aachba.c	2006-06-03 12:07:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aacraid/aachba.c	2006-06-03 12:25:32.000000000 +0200
@@ -961,7 +961,7 @@
 		
 	if(scsicmd->use_sg)
 		pci_unmap_sg(dev->pdev, 
-			(struct scatterlist *)scsicmd->buffer,
+			(struct scatterlist *)scsicmd->request_buffer,
 			scsicmd->use_sg,
 			scsicmd->sc_data_direction);
 	else if(scsicmd->request_bufflen)
@@ -1919,7 +1919,7 @@
 
 	if(scsicmd->use_sg)
 		pci_unmap_sg(dev->pdev, 
-			(struct scatterlist *)scsicmd->buffer,
+			(struct scatterlist *)scsicmd->request_buffer,
 			scsicmd->use_sg,
 			scsicmd->sc_data_direction);
 	else if(scsicmd->request_bufflen)
Index: scsi-misc-2.6/drivers/scsi/atp870u.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/atp870u.c	2006-06-03 12:07:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/atp870u.c	2006-06-03 12:25:32.000000000 +0200
@@ -473,7 +473,7 @@
 			 */
 			if (workreq->use_sg) {
 				pci_unmap_sg(dev->pdev,
-					(struct scatterlist *)workreq->buffer,
+					(struct scatterlist *)workreq->request_buffer,
 					workreq->use_sg,
 					workreq->sc_data_direction);
 			} else if (workreq->request_bufflen &&
Index: scsi-misc-2.6/drivers/scsi/gdth.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/gdth.c	2006-06-03 12:07:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/gdth.c	2006-06-03 12:25:32.000000000 +0200
@@ -2542,7 +2542,7 @@
     gdth_ha_str *ha;
     char *address;
 
-    cpcount = count<=(ushort)scp->bufflen ? count:(ushort)scp->bufflen;
+    cpcount = count<=(ushort)scp->request_bufflen ? count:(ushort)scp->request_bufflen;
     ha = HADATA(gdth_ctr_tab[hanum]);
 
     if (scp->use_sg) {
Index: scsi-misc-2.6/drivers/scsi/in2000.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/in2000.c	2006-06-03 12:07:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/in2000.c	2006-06-03 12:25:32.000000000 +0200
@@ -370,7 +370,7 @@
  */
 
 	if (cmd->use_sg) {
-		cmd->SCp.buffer = (struct scatterlist *) cmd->buffer;
+		cmd->SCp.buffer = (struct scatterlist *) cmd->request_buffer;
 		cmd->SCp.buffers_residual = cmd->use_sg - 1;
 		cmd->SCp.ptr = (char *) page_address(cmd->SCp.buffer->page) + cmd->SCp.buffer->offset;
 		cmd->SCp.this_residual = cmd->SCp.buffer->length;
Index: scsi-misc-2.6/drivers/scsi/ips.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/ips.c	2006-06-03 12:07:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/ips.c	2006-06-03 12:25:32.000000000 +0200
@@ -4364,7 +4364,7 @@
 
 	METHOD_TRACE("ips_rdcap", 1);
 
-	if (scb->scsi_cmd->bufflen < 8)
+	if (scb->scsi_cmd->request_bufflen < 8)
 		return (0);
 
 	cap.lba =
Index: scsi-misc-2.6/drivers/scsi/libata-scsi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/libata-scsi.c	2006-06-03 12:07:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/libata-scsi.c	2006-06-03 12:25:32.000000000 +0200
@@ -2310,7 +2310,7 @@
 #endif
 	}
 
-	qc->nbytes = cmd->bufflen;
+	qc->nbytes = cmd->request_bufflen;
 
 	return 0;
 }
@@ -2500,7 +2500,7 @@
 	 * TODO: find out if we need to do more here to
 	 *       cover scatter/gather case.
 	 */
-	qc->nsect = cmd->bufflen / ATA_SECT_SIZE;
+	qc->nsect = cmd->request_bufflen / ATA_SECT_SIZE;
 
 	return 0;
 
Index: scsi-misc-2.6/drivers/scsi/megaraid.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/megaraid.c	2006-06-03 12:07:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/megaraid.c	2006-06-03 12:25:32.000000000 +0200
@@ -524,7 +524,7 @@
 	 * filter the internal and ioctl commands
 	 */
 	if((cmd->cmnd[0] == MEGA_INTERNAL_CMD)) {
-		return cmd->buffer;
+		return cmd->request_buffer;
 	}
 
 
@@ -4493,7 +4493,7 @@
 	scmd->device = sdev;
 
 	scmd->device->host = adapter->host;
-	scmd->buffer = (void *)scb;
+	scmd->request_buffer = (void *)scb;
 	scmd->cmnd[0] = MEGA_INTERNAL_CMD;
 
 	scb->state |= SCB_ACTIVE;
Index: scsi-misc-2.6/drivers/scsi/ncr53c8xx.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/ncr53c8xx.c	2006-06-03 12:07:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/ncr53c8xx.c	2006-06-03 12:25:32.000000000 +0200
@@ -529,7 +529,7 @@
 {
 	switch(cmd->__data_mapped) {
 	case 2:
-		dma_unmap_sg(dev, cmd->buffer, cmd->use_sg,
+		dma_unmap_sg(dev, cmd->request_buffer, cmd->use_sg,
 				cmd->sc_data_direction);
 		break;
 	case 1:
@@ -564,7 +564,7 @@
 	if (cmd->use_sg == 0)
 		return 0;
 
-	use_sg = dma_map_sg(dev, cmd->buffer, cmd->use_sg,
+	use_sg = dma_map_sg(dev, cmd->request_buffer, cmd->use_sg,
 			cmd->sc_data_direction);
 	cmd->__data_mapped = 2;
 	cmd->__data_mapping = use_sg;
@@ -7697,7 +7697,7 @@
 	if (!use_sg)
 		segment = ncr_scatter_no_sglist(np, cp, cmd);
 	else if ((use_sg = map_scsi_sg_data(np, cmd)) > 0) {
-		struct scatterlist *scatter = (struct scatterlist *)cmd->buffer;
+		struct scatterlist *scatter = (struct scatterlist *)cmd->request_buffer;
 		struct scr_tblmove *data;
 
 		if (use_sg > MAX_SCATTER) {
Index: scsi-misc-2.6/drivers/scsi/nsp32.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/nsp32.c	2006-06-03 12:07:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/nsp32.c	2006-06-03 12:25:32.000000000 +0200
@@ -1636,7 +1636,7 @@
 
 	if (SCpnt->use_sg) {
 		pci_unmap_sg(data->Pci,
-			     (struct scatterlist *)SCpnt->buffer,
+			     (struct scatterlist *)SCpnt->request_buffer,
 			     SCpnt->use_sg, SCpnt->sc_data_direction);
 	} else {
 		pci_unmap_single(data->Pci,
Index: scsi-misc-2.6/drivers/scsi/sd.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sd.c	2006-06-03 12:07:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sd.c	2006-06-03 12:25:32.000000000 +0200
@@ -891,7 +891,7 @@
 static void sd_rw_intr(struct scsi_cmnd * SCpnt)
 {
 	int result = SCpnt->result;
-	int this_count = SCpnt->bufflen;
+	int this_count = SCpnt->request_bufflen;
 	int good_bytes = (result == 0 ? this_count : 0);
 	sector_t block_sectors = 1;
 	u64 first_err_block;
Index: scsi-misc-2.6/drivers/scsi/sr.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sr.c	2006-06-03 12:07:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sr.c	2006-06-03 12:25:32.000000000 +0200
@@ -217,7 +217,7 @@
 static void rw_intr(struct scsi_cmnd * SCpnt)
 {
 	int result = SCpnt->result;
-	int this_count = SCpnt->bufflen;
+	int this_count = SCpnt->request_bufflen;
 	int good_bytes = (result == 0 ? this_count : 0);
 	int block_sectors = 0;
 	long error_sector;
Index: scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-06-03 12:07:51.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-06-03 12:25:32.000000000 +0200
@@ -156,7 +156,7 @@
 
 	switch(SYM_UCMD_PTR(cmd)->data_mapped) {
 	case 2:
-		pci_unmap_sg(pdev, cmd->buffer, cmd->use_sg, dma_dir);
+		pci_unmap_sg(pdev, cmd->request_buffer, cmd->use_sg, dma_dir);
 		break;
 	case 1:
 		pci_unmap_single(pdev, SYM_UCMD_PTR(cmd)->data_mapping,
@@ -186,7 +186,7 @@
 	int use_sg;
 	int dma_dir = cmd->sc_data_direction;
 
-	use_sg = pci_map_sg(pdev, cmd->buffer, cmd->use_sg, dma_dir);
+	use_sg = pci_map_sg(pdev, cmd->request_buffer, cmd->use_sg, dma_dir);
 	if (use_sg > 0) {
 		SYM_UCMD_PTR(cmd)->data_mapped  = 2;
 		SYM_UCMD_PTR(cmd)->data_mapping = use_sg;
@@ -376,7 +376,7 @@
 	if (!use_sg)
 		segment = sym_scatter_no_sglist(np, cp, cmd);
 	else if ((use_sg = map_scsi_sg_data(np, cmd)) > 0) {
-		struct scatterlist *scatter = (struct scatterlist *)cmd->buffer;
+		struct scatterlist *scatter = (struct scatterlist *)cmd->request_buffer;
 		struct sym_tcb *tp = &np->target[cp->target];
 		struct sym_tblmove *data;
 
Index: scsi-misc-2.6/drivers/usb/image/microtek.c
===================================================================
--- scsi-misc-2.6.orig/drivers/usb/image/microtek.c	2006-06-03 12:07:51.000000000 +0200
+++ scsi-misc-2.6/drivers/usb/image/microtek.c	2006-06-03 12:25:32.000000000 +0200
@@ -513,7 +513,7 @@
 		mts_transfer_cleanup(transfer);
         }
 
-	sg = context->srb->buffer;
+	sg = context->srb->request_buffer;
 	context->fragment++;
 	mts_int_submit_urb(transfer,
 			   context->data_pipe,
@@ -549,19 +549,19 @@
 	desc->context.fragment = 0;
 
 	if (!srb->use_sg) {
-		if ( !srb->bufflen ){
+		if ( !srb->request_bufflen ){
 			desc->context.data = NULL;
 			desc->context.data_length = 0;
 			return;
 		} else {
-			desc->context.data = srb->buffer;
-			desc->context.data_length = srb->bufflen;
+			desc->context.data = srb->request_buffer;
+			desc->context.data_length = srb->request_bufflen;
 			MTS_DEBUG("length = %d or %d\n",
 				  srb->request_bufflen, srb->bufflen);
 		}
 	} else {
 		MTS_DEBUG("Using scatter/gather\n");
-		sg = srb->buffer;
+		sg = srb->request_buffer;
 		desc->context.data = page_address(sg[0].page) + sg[0].offset;
 		desc->context.data_length = sg[0].length;
 	}
