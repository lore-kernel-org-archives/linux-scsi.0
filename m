From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Wed, 16 Mar 2005 21:24:04 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0503162028590.11165@poirot.grange>
References: <200503160209.j2G29cAf010870@hera.kernel.org> <20050316075839.GC7842@suse.de>
 <1110986016.5771.3.camel@mulgrave> <20050316160447.GU7842@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from pop.gmx.net ([213.165.64.20]:10707 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262782AbVCPUZN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 15:25:13 -0500
In-Reply-To: <20050316160447.GU7842@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi

Thanks for reviewing this patch!

On Wed, 16 Mar 2005, Jens Axboe wrote:

> On Wed, Mar 16 2005, James Bottomley wrote:
...
> > I agree the kmap is inefficient.  The efficient alternative is to do
> > dma_map_sg() and use kmap_atomic() in the interrupt routine where we do
> > the PIO cleanup---I'm afraid I just passed on explaining how to do
> > this ... unless you care to do the honours ?

In fact, the first version of my patch (attached below) did exactly this - 
only when the driver recognises, that it needs to do PIO in the interrupt, 
I would call kmap_atomic(), do PIO, then kunmap_atomic(). The main reason, 
why I didn't submit that patch, was that I got confused about various KM_ 
macros, and I thought, since it is a valuable limited resource, only very 
"special" drivers are allowed to use them / are allocated one of them. 
But, I guess now, you can just do

	local_irq_save(flags);
	kmap_atomic();
	...
	kunmap_atomic();
	local_irq_restore(flags);

Please, have a look. Or should we indeed go the "generic helper functions" 
way?

> The kmap() isn't just inefficient, it's a problem to iterate over the sg
> list and kmap all the pages. That is illegal.

Hm, what do you mean "illegal"? Could you explain why?

> But it's not so tricky to get right, if the punting just happens in the
> isr. Basically just iterate over every sg entry left ala:
> 
>         for (i = start; i < sg_entries; i++) {
>                 unsigned long flags;
>                 char *ptr;
> 
>                 local_irq_save(flags);
>                 ptr = kmap_atomic(sg->page, KM_BIO_SRC_IRQ);
> 
>                 /* transfer to/from ptr + sg->offset, sg->length bytes */
> 
>                 kunmap_atomic(ptr, KM_BIO_SRC_IRQ);
>                 local_irq_restore(flags);
>         }
> 
> I _think_ the sg->length field is universally called so, you should not
> use sg->dma_length/sg_dma_len() or sg_dma_address(), as we are outside
> the work of the iommu at this point.

One more fragment in the driver I wasn't sure about is this:

 		unsigned long mask =
 		    ~((unsigned long)sg->length - 1) & PAGE_MASK;
 		if ((sg_dma_address(sg) & mask) == (psge->address & mask)) {

Is sg->length guaranteed to be something like a power of 2 or smaller 
than page? I thought about replacing the above with

+		if (sg_dma_address(sg) <= psge->address && sg_dma_address(sg) + psge->length > psge->address) {

but wasn't sure.

Thanks
Guennadi
---
Guennadi Liakhovetski

Index: drivers/scsi/dc395x.c
===================================================================
RCS file: /usr/src/cvs/linux-2_6/drivers/scsi/dc395x.c,v
retrieving revision 1.1.1.4
diff -u -r1.1.1.4 dc395x.c
--- drivers/scsi/dc395x.c	17 Nov 2004 21:04:51 -0000	1.1.1.4
+++ drivers/scsi/dc395x.c	16 Mar 2005 20:12:07 -0000
@@ -185,7 +185,7 @@
 
 
 struct SGentry {
-	u32 address;		/* bus! address */
+	dma_addr_t address;		/* bus! address */
 	u32 length;
 };
 
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
@@ -1020,11 +1022,11 @@
 			reqlen, cmd->request_buffer, cmd->use_sg,
 			srb->sg_count);
 
-		srb->virt_addr = page_address(sl->page);
+		srb->page = sl->page;
+		srb->offset = sl->offset;
 		for (i = 0; i < srb->sg_count; i++) {
-			u32 busaddr = (u32)sg_dma_address(&sl[i]);
-			u32 seglen = (u32)sl[i].length;
-			sgp[i].address = busaddr;
+			u32 seglen = (u32)sg_dma_len(sl + i);
+			sgp[i].address = cpu_to_le32(0xffffffff & sg_dma_address(sl +i));
 			sgp[i].length = seglen;
 			srb->total_xfer_length += seglen;
 		}
@@ -1065,7 +1067,8 @@
 			srb->total_xfer_length++;
 
 		srb->segment_x[0].length = srb->total_xfer_length;
-		srb->virt_addr = cmd->request_buffer;
+		srb->page = virt_to_page(cmd->request_buffer);
+		srb->offset = (unsigned long)cmd->request_buffer & ~PAGE_MASK;
 		dprintkdbg(DBG_0,
 			"build_srb: [1] len=%d buf=%p use_sg=%d map=%08x\n",
 			srb->total_xfer_length, cmd->request_buffer,
@@ -1984,8 +1987,7 @@
 			psge->length -= xferred;
 			psge->address += xferred;
 			srb->sg_index = idx;
-			pci_dma_sync_single_for_device(srb->dcb->
-					    acb->dev,
+			pci_dma_sync_single_for_device(srb->dcb->acb->dev,
 					    srb->sg_bus_addr,
 					    SEGMENTX_LEN,
 					    PCI_DMA_TODEVICE);
@@ -1995,28 +1997,21 @@
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
+//		if (sg_dma_address(sg) <= psge->address && sg_dma_address(sg) + psge->length > psge->address) {
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
+			page_addr = kmap_atomic(srb->page, KM_USER0);
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
+			kunmap_atomic(page_addr, KM_IRQ0);
+			local_irq_restore(flags);
 			/*printk(" %08x", *(u32*)(bus_to_virt (addr))); */
 			/*srb->total_xfer_length = 0; */
 			if (debug_enabled(DBG_PIO))
@@ -2452,7 +2443,7 @@
 			DC395x_write32(acb, TRM_S1040_DMA_XLOWADDR,
 				       srb->segment_x[0].address);
 			DC395x_write32(acb, TRM_S1040_DMA_XCNT,
-				       srb->segment_x[0].length);
+				       cpu_to_le32(srb->segment_x[0].length));
 		}
 		/* load total transfer length (24bits) max value 16Mbyte */
 		DC395x_write32(acb, TRM_S1040_SCSI_COUNTER,
@@ -2485,22 +2476,25 @@
 				      SCMD_FIFO_IN);
 		} else {	/* write */
 			int ln = srb->total_xfer_length;
+			char *page_addr, *virt_addr;
+			unsigned long flags;
+
+			local_irq_save(flags);
+			page_addr = kmap_atomic(srb->page, KM_USER0);
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
+			kunmap_atomic(page_addr, KM_USER0);
+			local_irq_restore(flags);
 			if (srb->dcb->sync_period & WIDE_SYNC) {
 				if (ln % 2) {
 					DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 0);
