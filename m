From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Thu, 17 Mar 2005 21:51:35 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0503172141330.6952@poirot.grange>
References: <20050317074013.GJ7842@suse.de> <22734.1111050528@www13.gmx.net>
 <Pine.LNX.4.56.0503171011410.20956@pcgl.dsa-ac.de> <20050317100854.GA1860@suse.de>
 <Pine.LNX.4.56.0503171113160.20956@pcgl.dsa-ac.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from pop.gmx.net ([213.165.64.20]:52966 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261155AbVCQVAc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2005 16:00:32 -0500
In-Reply-To: <Pine.LNX.4.56.0503171113160.20956@pcgl.dsa-ac.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gl@dsa-ac.de
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jamie Lenehan <lenehan@twibble.org>

Hi

Here's a fixed patch - thanks to everybody for reviewing and commenting!

However, if it is decided to implement helper functions, as suggested by 
Christoph and others, feel free to drop it. There, probably, was only 1 
user of this card with highmem and he retired his card too:-)

Thanks
Guennadi
---
Guennadi Liakhovetski

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

diff -u a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	17 Nov 2004 21:04:51
+++ b/drivers/scsi/dc395x.c	17 Mar 2005 20:18:14
@@ -234,7 +234,8 @@
 	u8 sg_count;			/* No of HW sg entries for this request */
 	u8 sg_index;			/* Index of HW sg entry for this request */
 	u32 total_xfer_length;		/* Total number of bytes remaining to be transfered */
-	unsigned char *virt_addr;	/* Virtual address of current transfer position */
+	struct page *page;
+	unsigned int offset;
 
 	/*
 	 * The sense buffer handling function, request_sense, uses
@@ -989,7 +990,8 @@
 	srb->sg_count = 0;
 	srb->total_xfer_length = 0;
 	srb->sg_bus_addr = 0;
-	srb->virt_addr = NULL;
+	srb->page = NULL;
+	srb->offset = 0;
 	srb->sg_index = 0;
 	srb->adapter_status = 0;
 	srb->target_status = 0;
@@ -1020,7 +1022,8 @@
 			reqlen, cmd->request_buffer, cmd->use_sg,
 			srb->sg_count);
 
-		srb->virt_addr = page_address(sl->page);
+		srb->page = sl->page;
+		srb->offset = sl->offset;
 		for (i = 0; i < srb->sg_count; i++) {
 			u32 busaddr = (u32)sg_dma_address(&sl[i]);
 			u32 seglen = (u32)sl[i].length;
@@ -1065,7 +1068,8 @@
 			srb->total_xfer_length++;
 
 		srb->segment_x[0].length = srb->total_xfer_length;
-		srb->virt_addr = cmd->request_buffer;
+		srb->page = virt_to_page(cmd->request_buffer);
+		srb->offset = (unsigned long)cmd->request_buffer & ~PAGE_MASK;
 		dprintkdbg(DBG_0,
 			"build_srb: [1] len=%d buf=%p use_sg=%d map=%08x\n",
 			srb->total_xfer_length, cmd->request_buffer,
@@ -1984,8 +1988,7 @@
 			psge->length -= xferred;
 			psge->address += xferred;
 			srb->sg_index = idx;
-			pci_dma_sync_single_for_device(srb->dcb->
-					    acb->dev,
+			pci_dma_sync_single_for_device(srb->dcb->acb->dev,
 					    srb->sg_bus_addr,
 					    SEGMENTX_LEN,
 					    PCI_DMA_TODEVICE);
@@ -1995,28 +1998,20 @@
 	}
 	sg_verify_length(srb);
 
-	/* we need the corresponding virtual address */
-	if (!segment) {
-		srb->virt_addr += xferred;
-		return;
-	}
-
 	/* We have to walk the scatterlist to find it */
 	sg = (struct scatterlist *)cmd->request_buffer;
 	while (segment--) {
 		unsigned long mask =
 		    ~((unsigned long)sg->length - 1) & PAGE_MASK;
 		if ((sg_dma_address(sg) & mask) == (psge->address & mask)) {
-			srb->virt_addr = (page_address(sg->page)
-					   + psge->address -
-					   (psge->address & PAGE_MASK));
+			srb->page = sg->page;
+			srb->offset = psge->address & ~PAGE_MASK;
 			return;
 		}
 		++sg;
 	}
 
 	dprintkl(KERN_ERR, "sg_update_list: sg_to_virt failed\n");
-	srb->virt_addr = NULL;
 }
 
 
@@ -2138,7 +2133,7 @@
 				DC395x_read32(acb, TRM_S1040_DMA_CXCNT));
 		}
 		/*
-		 * calculate all the residue data that not yet tranfered
+		 * calculate all the residue data that not yet transfered
 		 * SCSI transfer counter + left in SCSI FIFO data
 		 *
 		 * .....TRM_S1040_SCSI_COUNTER (24bits)
@@ -2184,15 +2179,10 @@
 			    (dcb->sync_period & WIDE_SYNC) ? 2 : 1;
 			sg_update_list(srb, d_left_counter);
 			/* KG: Most ugly hack! Apparently, this works around a chip bug */
-			if ((srb->segment_x[srb->sg_index].length ==
-			     diff && srb->cmd->use_sg)
-			    || ((oldxferred & ~PAGE_MASK) ==
-				(PAGE_SIZE - diff))
-			    ) {
-				dprintkl(KERN_INFO, "data_out_phase0: "
-					"Work around chip bug (%i)?\n", diff);
-				d_left_counter =
-				    srb->total_xfer_length - diff;
+			if ((srb->segment_x[srb->sg_index].length == diff && srb->cmd->use_sg) ||
+			    (oldxferred & ~PAGE_MASK) == PAGE_SIZE - diff) {
+				dprintkl(KERN_INFO, "data_out_phase0: Work around chip bug (%i)?\n", diff);
+				d_left_counter = srb->total_xfer_length - diff;
 				sg_update_list(srb, d_left_counter);
 				/*srb->total_xfer_length -= diff; */
 				/*srb->virt_addr += diff; */
@@ -2297,19 +2287,18 @@
 		    && srb->total_xfer_length <= DC395x_LASTPIO) {
 			/*u32 addr = (srb->segment_x[srb->sg_index].address); */
 			/*sg_update_list (srb, d_left_counter); */
-			dprintkdbg(DBG_PIO, "data_in_phase0: PIO (%i %s) to "
-				"%p for remaining %i bytes:",
-				DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) & 0x1f,
-				(srb->dcb->sync_period & WIDE_SYNC) ?
-				    "words" : "bytes",
-				srb->virt_addr,
-				srb->total_xfer_length);
+			char *page_addr, *virt_addr;
+			unsigned long flags;
 			if (srb->dcb->sync_period & WIDE_SYNC)
 				DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2,
 					      CFG2_WIDEFIFO);
+			local_irq_save(flags);
+			page_addr = kmap_atomic(srb->page, KM_BIO_SRC_IRQ);
+			virt_addr = page_addr + srb->offset;
+
 			while (DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) != 0x40) {
 				u8 byte = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
-				*(srb->virt_addr)++ = byte;
+				*(virt_addr)++ = byte;
 				if (debug_enabled(DBG_PIO))
 					printk(" %02x", byte);
 				d_left_counter--;
@@ -2320,7 +2309,7 @@
                 /* Read the last byte ... */
 				if (srb->total_xfer_length > 0) {
 					u8 byte = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
-					*(srb->virt_addr)++ = byte;
+					*(virt_addr)++ = byte;
 					srb->total_xfer_length--;
 					if (debug_enabled(DBG_PIO))
 						printk(" %02x", byte);
@@ -2328,6 +2317,8 @@
 #endif
 				DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2, 0);
 			}
+			kunmap_atomic(page_addr, KM_BIO_SRC_IRQ);
+			local_irq_restore(flags);
 			/*printk(" %08x", *(u32*)(bus_to_virt (addr))); */
 			/*srb->total_xfer_length = 0; */
 			if (debug_enabled(DBG_PIO))
@@ -2485,22 +2476,25 @@
 				      SCMD_FIFO_IN);
 		} else {	/* write */
 			int ln = srb->total_xfer_length;
+			char *page_addr, *virt_addr;
+			unsigned long flags;
+
+			local_irq_save(flags);
+			page_addr = kmap_atomic(srb->page, KM_BIO_SRC_IRQ);
+			virt_addr = page_addr + srb->offset;
 			if (srb->dcb->sync_period & WIDE_SYNC)
 				DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2,
 				     CFG2_WIDEFIFO);
-			dprintkdbg(DBG_PIO,
-				"data_io_transfer: PIO %i bytes from %p:",
-				srb->total_xfer_length, srb->virt_addr);
-
 			while (srb->total_xfer_length) {
 				if (debug_enabled(DBG_PIO))
-					printk(" %02x", (unsigned char) *(srb->virt_addr));
+					printk(" %02x", (unsigned char) *virt_addr);
 
 				DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 
-				     *(srb->virt_addr)++);
-
+				     *virt_addr++);
 				sg_subtract_one(srb);
 			}
+			kunmap_atomic(page_addr, KM_BIO_SRC_IRQ);
+			local_irq_restore(flags);
 			if (srb->dcb->sync_period & WIDE_SYNC) {
 				if (ln % 2) {
 					DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 0);
