From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Mon, 13 Feb 2006 00:47:31 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0602130043540.19775@poirot.grange>
References: <20060211011457.GA1839@igloo.df.lth.se>
 <Pine.LNX.4.60.0602112153320.3570@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.21]:51667 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751002AbWBLXrV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Feb 2006 18:47:21 -0500
In-Reply-To: <Pine.LNX.4.60.0602112153320.3570@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fredrik Roubert <roubert@df.lth.se>
Cc: linux-scsi@vger.kernel.org

On Sat, 11 Feb 2006, Guennadi Liakhovetski wrote:

> On Sat, 11 Feb 2006, Fredrik Roubert wrote:
> 
> > I just connected my old HP ScanJet 4c to my new DC315U SCSI adapter
> > (connected to an ASRock 939Dual-SATA2 motherboard with AMD Athlon 64 X2)
> > and tried using the dc395x kernel module with Linux 2.6.15 and scan an
> > image using xscanimage.
> > 
> > Sometimes it works, but sometimes xscanimage hangs for a long time and
> > then aborts with a message about I/O error. When that happends, the
> > following is printed in the dmesg output:
> > 
> > drivers/scsi/dc395x.c: Please, contact <linux-scsi@vger.kernel.org> to help improve support for your system.
> > dc395x: reselect: w/o disconnected cmds <02-0>
> > dc395x: disconnect: Unexpected reselection <02-0>

...

> Unless you want to dig out my patch from list-archives and start testing 
> it yourself, please wait until I send you an updated patch. Don't worry, 
> it will be "complicated" enough:-)

Ok, if you feel adventurous, you might try the patch below. Otherwise, you 
might want to wait until I also test-run it - so far only compile-tested. 
But even if I run-test it, I will not be able to test those PIO paths, 
so...

Thanks
Guennadi
---
Guennadi Liakhovetski

Index: drivers/scsi/dc395x.c
===================================================================
RCS file: /usr/src/cvs/linux-2_6/drivers/scsi/dc395x.c,v
retrieving revision 1.1.1.9
diff -u -r1.1.1.9 dc395x.c
--- a/drivers/scsi/dc395x.c	8 Feb 2006 23:08:47 -0000	1.1.1.9
+++ b/drivers/scsi/dc395x.c	12 Feb 2006 23:38:37 -0000
@@ -230,12 +230,8 @@
 	struct scsi_cmnd *cmd;
 
 	struct SGentry *segment_x;	/* Linear array of hw sg entries (up to 64 entries) */
-	u32 sg_bus_addr;	        /* Bus address of sg list (ie, of segment_x) */
-
-	u8 sg_count;			/* No of HW sg entries for this request */
-	u8 sg_index;			/* Index of HW sg entry for this request */
-	u32 total_xfer_length;		/* Total number of bytes remaining to be transfered */
-	unsigned char *virt_addr;	/* Virtual address of current transfer position */
+	size_t total_xfer_length;	/* Total number of bytes remaining to be transfered */
+	size_t request_length;		/* Total number of bytes in this request */
 
 	/*
 	 * The sense buffer handling function, request_sense, uses
@@ -246,7 +242,12 @@
 	 * total_xfer_length in xferred. These values are restored in
 	 * pci_unmap_srb_sense. This is the only place xferred is used.
 	 */
-	u32 xferred;		        /* Saved copy of total_xfer_length */
+	size_t xferred;		        /* Saved copy of total_xfer_length */
+
+	dma_addr_t sg_bus_addr;	        /* Bus address of sg list (ie, of segment_x) */
+
+	u8 sg_count;			/* No of HW sg entries for this request */
+	u8 sg_index;			/* Index of HW sg entry for this request */
 
 	u16 state;
 
@@ -976,17 +977,6 @@
 	}
 }
 
-static inline void pio_trigger(void)
-{
-	static int feedback_requested;
-
-	if (!feedback_requested) {
-		feedback_requested = 1;
-		printk(KERN_WARNING "%s: Please, contact <linux-scsi@vger.kernel.org> "
-		       "to help improve support for your system.\n", __FILE__);
-	}
-}
-
 /* Prepare SRB for being sent to Device DCB w/ command *cmd */
 static void build_srb(struct scsi_cmnd *cmd, struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb)
@@ -1000,7 +990,6 @@
 	srb->sg_count = 0;
 	srb->total_xfer_length = 0;
 	srb->sg_bus_addr = 0;
-	srb->virt_addr = NULL;
 	srb->sg_index = 0;
 	srb->adapter_status = 0;
 	srb->target_status = 0;
@@ -1031,7 +1020,6 @@
 			reqlen, cmd->request_buffer, cmd->use_sg,
 			srb->sg_count);
 
-		srb->virt_addr = page_address(sl->page);
 		for (i = 0; i < srb->sg_count; i++) {
 			u32 busaddr = (u32)sg_dma_address(&sl[i]);
 			u32 seglen = (u32)sl[i].length;
@@ -1063,7 +1051,7 @@
 				            	PCI_DMA_TODEVICE);
 
 		dprintkdbg(DBG_SG, "build_srb: [n] map sg %p->%08x(%05x)\n",
-			srb->segment_x, srb->sg_bus_addr, SEGMENTX_LEN);
+			srb->segment_x, (u32)srb->sg_bus_addr, SEGMENTX_LEN);
 	} else {
 		srb->total_xfer_length = cmd->request_bufflen;
 		srb->sg_count = 1;
@@ -1076,12 +1064,14 @@
 			srb->total_xfer_length++;
 
 		srb->segment_x[0].length = srb->total_xfer_length;
-		srb->virt_addr = cmd->request_buffer;
+
 		dprintkdbg(DBG_0,
 			"build_srb: [1] len=%d buf=%p use_sg=%d map=%08x\n",
 			srb->total_xfer_length, cmd->request_buffer,
 			cmd->use_sg, srb->segment_x[0].address);
 	}
+
+	srb->request_length = srb->total_xfer_length;
 }
 
 
@@ -1975,14 +1965,11 @@
 
 /*
  * Compute the next Scatter Gather list index and adjust its length
- * and address if necessary; also compute virt_addr
+ * and address if necessary
  */
 static void sg_update_list(struct ScsiReqBlk *srb, u32 left)
 {
 	u8 idx;
-	struct scatterlist *sg;
-	struct scsi_cmnd *cmd = srb->cmd;
-	int segment = cmd->use_sg;
 	u32 xferred = srb->total_xfer_length - left; /* bytes transfered */
 	struct SGentry *psge = srb->segment_x + srb->sg_index;
 
@@ -2015,29 +2002,6 @@
 		psge++;
 	}
 	sg_verify_length(srb);
-
-	/* we need the corresponding virtual address */
-	if (!segment) {
-		srb->virt_addr += xferred;
-		return;
-	}
-
-	/* We have to walk the scatterlist to find it */
-	sg = (struct scatterlist *)cmd->request_buffer;
-	while (segment--) {
-		unsigned long mask =
-		    ~((unsigned long)sg->length - 1) & PAGE_MASK;
-		if ((sg_dma_address(sg) & mask) == (psge->address & mask)) {
-			srb->virt_addr = (page_address(sg->page)
-					   + psge->address -
-					   (psge->address & PAGE_MASK));
-			return;
-		}
-		++sg;
-	}
-
-	dprintkl(KERN_ERR, "sg_update_list: sg_to_virt failed\n");
-	srb->virt_addr = NULL;
 }
 
 
@@ -2049,15 +2013,17 @@
  */
 static void sg_subtract_one(struct ScsiReqBlk *srb)
 {
+	struct SGentry *psge = srb->segment_x + srb->sg_index;
+
 	srb->total_xfer_length--;
-	srb->segment_x[srb->sg_index].length--;
+	psge->length--;
 	if (srb->total_xfer_length &&
-	    !srb->segment_x[srb->sg_index].length) {
+	    !psge->length) {
 		if (debug_enabled(DBG_PIO))
 			printk(" (next segment)");
 		srb->sg_index++;
-		sg_update_list(srb, srb->total_xfer_length);
-	}
+	} else
+		psge->address++;
 }
 
 
@@ -2216,7 +2182,6 @@
 				    srb->total_xfer_length - diff;
 				sg_update_list(srb, d_left_counter);
 				/*srb->total_xfer_length -= diff; */
-				/*srb->virt_addr += diff; */
 				/*if (srb->cmd->use_sg) */
 				/*      srb->sg_index++; */
 			}
@@ -2238,12 +2203,52 @@
 	data_io_transfer(acb, srb, XFERDATAOUT);
 }
 
+/**
+ * dc395_kmap_atomic_sg - find and atomically map an sg-elemnt
+ * @sg:		scatter-gather list
+ * @sg_count:	number of segments in sg
+ * @offset:	offset in bytes into sg, on return offset into the mapped area
+ * @len:	on return number of bytes mapped
+ *
+ * Returns virtual address of the start of the mapped page
+ */
+static void *dc395x_kmap_atomic_sg(struct scatterlist *sg, int sg_count, size_t *offset, size_t *len)
+{
+	int i;
+	size_t sg_len = 0, l2 = 0;
+	struct page *page;
+
+	for (i = 0; i < sg_count; i++) {
+		l2 = sg_len; /* Complete sg-entries */
+		sg_len += sg[i].length;
+		if (sg_len > *offset)
+			break;
+	}
+
+	BUG_ON(i == sg_count);
+
+	/* Offset starting from the beginning of first page in this sg-entry */
+	*offset = *offset - l2 + sg[i].offset;
+
+	/* Assumption: contiguous pages can be accessed as "page + i" */
+	page = sg[i].page + (*offset >> PAGE_SHIFT);
+	*offset &= ~PAGE_MASK;
+
+	/* Bytes in this sg-entry from *offset to the end of the page */
+	*len = PAGE_SIZE - *offset;
+
+	return kmap_atomic(page, KM_BIO_SRC_IRQ);
+}
+
+static void dc395x_kunmap_atomic_sg(void *virt)
+{
+	kunmap_atomic(virt, KM_BIO_SRC_IRQ);
+}
 
 static void data_in_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
 	u16 scsi_status = *pscsi_status;
-	u32 d_left_counter = 0;
 	dprintkdbg(DBG_0, "data_in_phase0: (pid#%li) <%02i-%i>\n",
 		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
 
@@ -2261,6 +2266,7 @@
 	 * seem to be a bad idea, actually.
 	 */
 	if (!(srb->state & SRB_XFERPAD)) {
+		unsigned int d_left_counter, max_left;
 		if (scsi_status & PARITYERROR) {
 			dprintkl(KERN_INFO, "data_in_phase0: (pid#%li) "
 				"Parity Error\n", srb->cmd->pid);
@@ -2313,44 +2319,85 @@
 			DC395x_read32(acb, TRM_S1040_DMA_CXCNT),
 			srb->total_xfer_length, d_left_counter);
 #if DC395x_LASTPIO
+		max_left = max(d_left_counter, srb->total_xfer_length);
 		/* KG: Less than or equal to 4 bytes can not be transfered via DMA, it seems. */
 		if (d_left_counter
 		    && srb->total_xfer_length <= DC395x_LASTPIO) {
+			size_t left_io = srb->total_xfer_length;
+
 			/*u32 addr = (srb->segment_x[srb->sg_index].address); */
 			/*sg_update_list (srb, d_left_counter); */
-			dprintkdbg(DBG_PIO, "data_in_phase0: PIO (%i %s) to "
-				"%p for remaining %i bytes:",
+			dprintkdbg(DBG_PIO, "data_in_phase0: PIO (%i %s) "
+				"for remaining %i bytes:",
 				DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) & 0x1f,
 				(srb->dcb->sync_period & WIDE_SYNC) ?
 				    "words" : "bytes",
-				srb->virt_addr,
 				srb->total_xfer_length);
 			if (srb->dcb->sync_period & WIDE_SYNC)
 				DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2,
 					      CFG2_WIDEFIFO);
-			while (DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) != 0x40) {
-				u8 byte = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
-				pio_trigger();
-				*(srb->virt_addr)++ = byte;
-				if (debug_enabled(DBG_PIO))
-					printk(" %02x", byte);
-				d_left_counter--;
-				sg_subtract_one(srb);
-			}
-			if (srb->dcb->sync_period & WIDE_SYNC) {
-#if 1
-                /* Read the last byte ... */
-				if (srb->total_xfer_length > 0) {
-					u8 byte = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
-					pio_trigger();
-					*(srb->virt_addr)++ = byte;
-					srb->total_xfer_length--;
+
+			while (left_io) {
+				unsigned char *virt, *base = NULL;
+				unsigned long flags = 0;
+				size_t len;
+				u8 fifocnt = 0;
+
+				if (srb->cmd->use_sg) {
+					size_t offset = srb->request_length - left_io;
+					local_irq_save(flags);
+					/* Assumption: it's inside one page as it's at most 4 bytes and
+					   I just assume it's on a 4-byte boundary */
+					base = dc395x_kmap_atomic_sg((struct scatterlist *)srb->cmd->request_buffer,
+								     srb->sg_count, &offset, &len);
+					virt = base + offset;
+				} else {
+					virt = srb->cmd->request_buffer + srb->cmd->request_bufflen - left_io;
+					len = left_io;
+				}
+				left_io -= len;
+
+				while (len) {
+					u8 byte;
+					fifocnt = DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT);
+
+					if (fifocnt == 0x40) {
+						left_io = 0;
+						break;
+					}
+
+					byte = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
+					*virt++ = byte;
+
 					if (debug_enabled(DBG_PIO))
 						printk(" %02x", byte);
+
+					d_left_counter--;
+					sg_subtract_one(srb);
+
+					len--;
 				}
+
+				if (fifocnt == 0x40 && (srb->dcb->sync_period & WIDE_SYNC)) {
+#if 1
+					/* Read the last byte ... */
+					if (srb->total_xfer_length > 0) {
+						u8 byte = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
+						*virt++ = byte;
+						srb->total_xfer_length--;
+						if (debug_enabled(DBG_PIO))
+							printk(" %02x", byte);
+					}
 #endif
-				DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2, 0);
+					DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2, 0);
+				}
+
+				if (srb->cmd->use_sg) {
+					dc395x_kunmap_atomic_sg(base);
+					local_irq_restore(flags);
+				}
 			}
+
 			/*printk(" %08x", *(u32*)(bus_to_virt (addr))); */
 			/*srb->total_xfer_length = 0; */
 			if (debug_enabled(DBG_PIO))
@@ -2463,7 +2510,7 @@
 		if (srb->cmd->use_sg) {	/* with S/G */
 			io_dir |= DMACMD_SG;
 			DC395x_write32(acb, TRM_S1040_DMA_XLOWADDR,
-				       srb->sg_bus_addr +
+				       (u32)srb->sg_bus_addr +
 				       sizeof(struct SGentry) *
 				       srb->sg_index);
 			/* load how many bytes in the sg list table */
@@ -2508,23 +2555,45 @@
 				      SCMD_FIFO_IN);
 		} else {	/* write */
 			int ln = srb->total_xfer_length;
+			size_t left_io = srb->total_xfer_length;
+
 			if (srb->dcb->sync_period & WIDE_SYNC)
 				DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2,
 				     CFG2_WIDEFIFO);
-			dprintkdbg(DBG_PIO,
-				"data_io_transfer: PIO %i bytes from %p:",
-				srb->total_xfer_length, srb->virt_addr);
-
-			while (srb->total_xfer_length) {
-				if (debug_enabled(DBG_PIO))
-					printk(" %02x", (unsigned char) *(srb->virt_addr));
-
-				pio_trigger();
-				DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 
-				     *(srb->virt_addr)++);
 
-				sg_subtract_one(srb);
+			while (left_io) {
+				unsigned char *virt, *base = NULL;
+				unsigned long flags = 0;
+				size_t len;
+
+				if (srb->cmd->use_sg) {
+					size_t offset = srb->request_length - left_io;
+					local_irq_save(flags);
+					/* Again, max 4 bytes */
+					base = dc395x_kmap_atomic_sg((struct scatterlist *)srb->cmd->request_buffer,
+								     srb->sg_count, &offset, &len);
+					virt = base + offset;
+				} else {
+					virt = srb->cmd->request_buffer + srb->cmd->request_bufflen - left_io;
+					len = left_io;
+				}
+				left_io -= len;
+
+				while (len--) {
+					if (debug_enabled(DBG_PIO))
+						printk(" %02x", *virt);
+
+					DC395x_write8(acb, TRM_S1040_SCSI_FIFO, *virt++);
+
+					sg_subtract_one(srb);
+				}
+
+				if (srb->cmd->use_sg) {
+					dc395x_kunmap_atomic_sg(base);
+					local_irq_restore(flags);
+				}
 			}
+
 			if (srb->dcb->sync_period & WIDE_SYNC) {
 				if (ln % 2) {
 					DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 0);
@@ -3282,7 +3351,7 @@
 	if (cmd->use_sg && dir != PCI_DMA_NONE) {
 		/* unmap DC395x SG list */
 		dprintkdbg(DBG_SG, "pci_unmap_srb: list=%08x(%05x)\n",
-			srb->sg_bus_addr, SEGMENTX_LEN);
+			(u32)srb->sg_bus_addr, SEGMENTX_LEN);
 		pci_unmap_single(acb->dev, srb->sg_bus_addr,
 				 SEGMENTX_LEN,
 				 PCI_DMA_TODEVICE);
@@ -4820,6 +4889,7 @@
 	unsigned long io_port_base;
 	unsigned int io_port_len;
 	unsigned int irq;
+	int ret = -ENODEV;
 	
 	dprintkdbg(DBG_0, "Init one instance (%s)\n", pci_name(dev));
 	banner_display();
@@ -4834,6 +4904,9 @@
 	irq = dev->irq;
 	dprintkdbg(DBG_0, "IO_PORT=0x%04lx, IRQ=0x%x\n", io_port_base, dev->irq);
 
+	if ((ret = pci_set_dma_mask(dev, DMA_32BIT_MASK)))
+		goto fail;
+
 	/* allocate scsi host information (includes out adapter) */
 	scsi_host = scsi_host_alloc(&dc395x_driver_template,
 				    sizeof(struct AdapterCtlBlk));
@@ -4869,7 +4942,7 @@
 	if (scsi_host != NULL)
 		scsi_host_put(scsi_host);
 	pci_disable_device(dev);
-	return -ENODEV;
+	return ret;
 }
 
 
