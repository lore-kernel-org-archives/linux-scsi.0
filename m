From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Sun, 10 Apr 2005 00:48:55 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0504100035110.4283@poirot.grange>
References: <20050321075531.GC23911@suse.de> <7044.1111398919@www16.gmx.net>
  <Pine.LNX.4.56.0503211111290.20956@pcgl.dsa-ac.de>  <20050321104419.GH23911@suse.de>
  <Pine.LNX.4.56.0503211147420.20956@pcgl.dsa-ac.de>
 <Pine.LNX.4.60.0503302318250.9431@poirot.grange> <1112220802.9435.1.camel@mulgrave>
 <Pine.LNX.4.56.0503311051290.20956@pcgl.dsa-ac.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:33926 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261397AbVDIWtj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Apr 2005 18:49:39 -0400
In-Reply-To: <Pine.LNX.4.56.0503311051290.20956@pcgl.dsa-ac.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 31 Mar 2005 gl@dsa-ac.de wrote:

> On Wed, 30 Mar 2005, James Bottomley wrote:
> 
> > On Wed, 2005-03-30 at 23:22 +0200, Guennadi Liakhovetski wrote:
> > > What is going to happen to this stuff? The current Linus' tree contains a
> > > broken (by me:-() dc395x, other drivers (including tmscsim) would benefit
> > > from a generic API. I understand, the drivers are not top importance, but
> > > still.
> >
> > I'd propose fixing the driver first and then using that fix as the basis
> > for a generic API.  Is the patch you sent on the 17th of March what
> > you'd consider to be your final fix for this?
> 
> Well, it could be. But I'd use Jens' suggestion and actually test it for
> highmem. And, since we are at it, I'd try to organise this code in
> separate API, so, that we just have to replace dc395x_* with scsi_* in
> function names. Makes sense?

Ok, here's what I've come up with so far. Too bad - I cannot actually test 
it. Not only for high-, but also for lowmem. In my tests those PIO paths 
are not entered. More precisely - they are entered, e.g., when reading the 
disk's partition table, or doing sginfo -a, but only without 
scatter-gather... I also cannot test the wide part. I've only got a narrow 
(dc315, I think) card and (easy) I can only connect an external 100MB ZIP 
and an internal tape drives. Anybody has an idea when those paths are 
actually entered? Or anybody could test the patch? Another bad thing -
diffstat:

dc395x.c |  200 +++++++++++++++++++++++++++++++++++++++++----------------------
 1 files changed, 132 insertions(+), 68 deletions(-)

One of the reasons the number of "+"s is so large, is that on the one 
hand, not knowing the hardware and having no datasheet at hand, I tried 
not to modify the flow essentially, and on the other hand, I tried to make 
it rather generic, e.g., I am pretty sure, that those PIO bytes always 
belong to only one sg-segment, but I did it more generic, perhaps, an 
overkill. Anyway, please, comment. Not asking for inclusion - yet.

Thanks
Guennadi
---
Guennadi Liakhovetski

diff -u a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	4 Mar 2005 22:42:35
+++ b/drivers/scsi/dc395x.c	9 Apr 2005 22:10:23
@@ -229,12 +229,8 @@
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
@@ -245,7 +241,12 @@
 	 * total_xfer_length in xferred. These values are restored in
 	 * pci_unmap_srb_sense. This is the only place xferred is used.
 	 */
-	u32 xferred;		        /* Saved copy of total_xfer_length */
+	size_t xferred;		        /* Saved copy of total_xfer_length */
+
+	u32 sg_bus_addr;	        /* Bus address of sg list (ie, of segment_x) */
+
+	u8 sg_count;			/* No of HW sg entries for this request */
+	u8 sg_index;			/* Index of HW sg entry for this request */
 
 	u16 state;
 
@@ -989,7 +990,6 @@
 	srb->sg_count = 0;
 	srb->total_xfer_length = 0;
 	srb->sg_bus_addr = 0;
-	srb->virt_addr = NULL;
 	srb->sg_index = 0;
 	srb->adapter_status = 0;
 	srb->target_status = 0;
@@ -1020,7 +1020,6 @@
 			reqlen, cmd->request_buffer, cmd->use_sg,
 			srb->sg_count);
 
-		srb->virt_addr = page_address(sl->page);
 		for (i = 0; i < srb->sg_count; i++) {
 			u32 busaddr = (u32)sg_dma_address(&sl[i]);
 			u32 seglen = (u32)sl[i].length;
@@ -1065,12 +1064,14 @@
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
 
 
@@ -1954,14 +1955,12 @@
 
 /*
  * Compute the next Scatter Gather list index and adjust its length
- * and address if necessary; also compute virt_addr
+ * and address if necessary
  */
 static void sg_update_list(struct ScsiReqBlk *srb, u32 left)
 {
 	u8 idx;
-	struct scatterlist *sg;
 	struct scsi_cmnd *cmd = srb->cmd;
-	int segment = cmd->use_sg;
 	u32 xferred = srb->total_xfer_length - left; /* bytes transfered */
 	struct SGentry *psge = srb->segment_x + srb->sg_index;
 
@@ -1994,29 +1993,6 @@
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
 
 
@@ -2035,7 +2011,6 @@
 		if (debug_enabled(DBG_PIO))
 			printk(" (next segment)");
 		srb->sg_index++;
-		sg_update_list(srb, srb->total_xfer_length);
 	}
 }
 
@@ -2195,7 +2170,6 @@
 				    srb->total_xfer_length - diff;
 				sg_update_list(srb, d_left_counter);
 				/*srb->total_xfer_length -= diff; */
-				/*srb->virt_addr += diff; */
 				/*if (srb->cmd->use_sg) */
 				/*      srb->sg_index++; */
 			}
@@ -2217,12 +2191,42 @@
 	data_io_transfer(acb, srb, XFERDATAOUT);
 }
 
+/**
+ * dc395x_kmap_atomic_sg - find and atomically map an sg-elemnt
+ * @sg:		scatter-gather list
+ * @sg_count:	number of segments in sg
+ * @offset:	offset in bytes into sg
+ * @len:	on return number of bytes mapped
+ *
+ * Return virtual address
+ */
+static void *dc395x_kmap_atomic_sg(struct scatterlist *sg, int sg_count, size_t offset, size_t *len)
+{
+	int i;
+	size_t sg_len = 0;
+
+	for (i = 0; i < sg_count; i++) {
+		sg_len += sg[i].length;
+		if (sg_len > offset)
+			break;
+	}
+
+	BUG_ON(i == sg_count);
+
+	*len = sg_len - offset;
+
+	return kmap_atomic(sg[i].page, KM_BIO_SRC_IRQ) + sg[i].offset + sg[i].length - *len;
+}
+
+static void dc395x_kunmap_atomic_sg(void *virt)
+{
+	kunmap_atomic(virt_to_page(virt), KM_BIO_SRC_IRQ);
+}
 
 static void data_in_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
 	u16 scsi_status = *pscsi_status;
-	u32 d_left_counter = 0;
 	dprintkdbg(DBG_0, "data_in_phase0: (pid#%li) <%02i-%i>\n",
 		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
 
@@ -2240,6 +2244,7 @@
 	 * seem to be a bad idea, actually.
 	 */
 	if (!(srb->state & SRB_XFERPAD)) {
+		unsigned int d_left_counter, max_left;
 		if (scsi_status & PARITYERROR) {
 			dprintkl(KERN_INFO, "data_in_phase0: (pid#%li) "
 				"Parity Error\n", srb->cmd->pid);
@@ -2292,42 +2297,81 @@
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
-					*(srb->virt_addr)++ = byte;
-					srb->total_xfer_length--;
+
+			while (left_io) {
+				unsigned char *virt, *tmp = NULL;
+				unsigned long flags = 0;
+				size_t len;
+				u8 fifocnt = 0;
+
+				if (srb->cmd->use_sg) {
+					local_irq_save(flags);
+					virt = tmp = dc395x_kmap_atomic_sg((struct scatterlist *)srb->cmd->request_buffer,
+									   srb->sg_count, srb->request_length - left_io, &len);
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
+					dc395x_kunmap_atomic_sg(tmp);
+					local_irq_restore(flags);
+				}
 			}
+
 			/*printk(" %08x", *(u32*)(bus_to_virt (addr))); */
 			/*srb->total_xfer_length = 0; */
 			if (debug_enabled(DBG_PIO))
@@ -2485,22 +2529,42 @@
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
 
-				DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 
-				     *(srb->virt_addr)++);
+			while (left_io) {
+				unsigned char *virt, *tmp = NULL;
+				unsigned long flags = 0;
+				size_t len;
+
+				if (srb->cmd->use_sg) {
+					local_irq_save(flags);
+					virt = tmp = dc395x_kmap_atomic_sg((struct scatterlist *)srb->cmd->request_buffer,
+									   srb->sg_count, srb->request_length - left_io, &len);
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
 
-				sg_subtract_one(srb);
+					sg_subtract_one(srb);
+				}
+
+				if (srb->cmd->use_sg) {
+					dc395x_kunmap_atomic_sg(tmp);
+					local_irq_restore(flags);
+				}
 			}
+
 			if (srb->dcb->sync_period & WIDE_SYNC) {
 				if (ln % 2) {
 					DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 0);
