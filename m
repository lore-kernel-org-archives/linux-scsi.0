From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] dc395x: dynamically map scatter-gather for PIO (take 2)
Date: Sun, 2 Apr 2006 21:57:43 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0604022004520.17410@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59316 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932410AbWDBT5p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Apr 2006 15:57:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Frei <Sebastian@schnapsleichen.de>, Fredrik Roubert <roubert@df.lth.se>, lenehan@twibble.org

Hello all,

This time I really mean it:-)

The current dc395x driver uses PIO to transfer up to 4 bytes which do not 
get transferred by DMA (under unclear circumstances). For this the driver 
uses page_address() which is broken on highmem. Apart from this the 
actual calculation of the virtual address is wrong (even without highmem). 
So, e.g., for reading it reads bytes from the driver to a wrong address 
and returns wrong data, I guess, for writing it would just output random 
data to the device.

The proper fix, as suggested by many, is to dynamically map data using 
kmap_atomic(page, KM_BIO_SRC_IRQ) / kunmap_atomic(virt). The reason why it 
has not been done until now, although I've done some preliminary patches 
more than a year ago was that nobody interested in fixing this problem was 
able to reliably reproduce it. Now it changed - with the help from 
Sebastian Frei (CC'ed) I was able to trigger the PIO path. Thus, I was 
also able to test and debug it.

There are 4 cases when PIO is used in dc395x - data-in / -out with and 
without scatter-gather. I was able to reproduce and test only data-in with 
and without SG. So, the data-out path is still untested, but it is also 
somewhat simpler than the data-in. Fredrik Roubert (also CC'ed) also had 
PIO triggering on his system, and in his case it was data-out without SG. 
It would be great if he could test the attached patch on his system, but 
even if he cannot, I would still request to apply the patch and just wait 
if anybody cries...

Implementation: I put 2 new functions in scsi_lib.c and their declarations 
in scsi_cmnd.h. I exported them without _GPL, although, I don't feel 
strongly about that - not many drivers are likely to use them. But there 
is at least one more - I want to use them in tmscsim.c. Whether these are 
the right files for the functions and their declarations - not sure 
either. Actually, they are not scsi-specific, so, might go somewhere 
around other scattergather magic? They are not platform specific either, 
and most SG functions are defined under arch/*/... As these issues were 
discussed previously there were some more routines suggested to manipulate 
scattergather buffers, I think, some of them were needed around 
crypto code... So, might be a common place reasonable, like 
lib/scattergather.c? I am open here.

Thanks
Guennadi
---
Guennadi Liakhovetski

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

diff -u a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	30 Mar 2006 19:19:15 -0000
+++ b/drivers/scsi/dc395x.c	2 Apr 2006 19:14:20 -0000
@@ -230,13 +230,12 @@
 	struct scsi_cmnd *cmd;
 
 	struct SGentry *segment_x;	/* Linear array of hw sg entries (up to 64 entries) */
-	u32 sg_bus_addr;	        /* Bus address of sg list (ie, of segment_x) */
+	dma_addr_t sg_bus_addr;	        /* Bus address of sg list (ie, of segment_x) */
 
 	u8 sg_count;			/* No of HW sg entries for this request */
 	u8 sg_index;			/* Index of HW sg entry for this request */
-	u32 total_xfer_length;		/* Total number of bytes remaining to be transfered */
-	unsigned char *virt_addr;	/* Virtual address of current transfer position */
-
+	size_t total_xfer_length;	/* Total number of bytes remaining to be transfered */
+	size_t request_length;		/* Total number of bytes in this request */
 	/*
 	 * The sense buffer handling function, request_sense, uses
 	 * the first hw sg entry (segment_x[0]) and the transfer
@@ -246,8 +245,7 @@
 	 * total_xfer_length in xferred. These values are restored in
 	 * pci_unmap_srb_sense. This is the only place xferred is used.
 	 */
-	unsigned char *virt_addr_req;	/* Saved virtual address of the request buffer */
-	u32 xferred;		        /* Saved copy of total_xfer_length */
+	size_t xferred;		        /* Saved copy of total_xfer_length */
 
 	u16 state;
 
@@ -977,17 +975,6 @@
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
@@ -1001,7 +988,6 @@
 	srb->sg_count = 0;
 	srb->total_xfer_length = 0;
 	srb->sg_bus_addr = 0;
-	srb->virt_addr = NULL;
 	srb->sg_index = 0;
 	srb->adapter_status = 0;
 	srb->target_status = 0;
@@ -1032,7 +1018,6 @@
 			reqlen, cmd->request_buffer, cmd->use_sg,
 			srb->sg_count);
 
-		srb->virt_addr = page_address(sl->page);
 		for (i = 0; i < srb->sg_count; i++) {
 			u32 busaddr = (u32)sg_dma_address(&sl[i]);
 			u32 seglen = (u32)sl[i].length;
@@ -1077,12 +1062,14 @@
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
 
 
@@ -1414,10 +1401,10 @@
 	}
 	srb = find_cmd(cmd, &dcb->srb_going_list);
 	if (srb) {
-		dprintkl(KERN_DEBUG, "eh_abort: Command in progress");
+		dprintkl(KERN_DEBUG, "eh_abort: Command in progress\n");
 		/* XXX: Should abort the command here */
 	} else {
-		dprintkl(KERN_DEBUG, "eh_abort: Command not found");
+		dprintkl(KERN_DEBUG, "eh_abort: Command not found\n");
 	}
 	return FAILED;
 }
@@ -1976,14 +1963,11 @@
 
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
 
@@ -2016,29 +2000,6 @@
 		psge++;
 	}
 	sg_verify_length(srb);
-
-	/* we need the corresponding virtual address */
-	if (!segment || (srb->flag & AUTO_REQSENSE)) {
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
 
 
@@ -2050,15 +2011,7 @@
  */
 static void sg_subtract_one(struct ScsiReqBlk *srb)
 {
-	srb->total_xfer_length--;
-	srb->segment_x[srb->sg_index].length--;
-	if (srb->total_xfer_length &&
-	    !srb->segment_x[srb->sg_index].length) {
-		if (debug_enabled(DBG_PIO))
-			printk(" (next segment)");
-		srb->sg_index++;
-		sg_update_list(srb, srb->total_xfer_length);
-	}
+	sg_update_list(srb, srb->total_xfer_length - 1);
 }
 
 
@@ -2118,7 +2071,7 @@
 	 * If we need more data, the DMA SG list will be freshly set up, anyway
 	 */
 	dprintkdbg(DBG_PIO, "data_out_phase0: "
-		"DMA{fifcnt=0x%02x fifostat=0x%02x} "
+		"DMA{fifocnt=0x%02x fifostat=0x%02x} "
 		"SCSI{fifocnt=0x%02x cnt=0x%06x status=0x%04x} total=0x%06x\n",
 		DC395x_read8(acb, TRM_S1040_DMA_FIFOCNT),
 		DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT),
@@ -2239,12 +2192,11 @@
 	data_io_transfer(acb, srb, XFERDATAOUT);
 }
 
-
 static void data_in_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
 	u16 scsi_status = *pscsi_status;
-	u32 d_left_counter = 0;
+
 	dprintkdbg(DBG_0, "data_in_phase0: (pid#%li) <%02i-%i>\n",
 		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
 
@@ -2262,6 +2214,9 @@
 	 * seem to be a bad idea, actually.
 	 */
 	if (!(srb->state & SRB_XFERPAD)) {
+		u32 d_left_counter;
+		unsigned int sc, fc;
+
 		if (scsi_status & PARITYERROR) {
 			dprintkl(KERN_INFO, "data_in_phase0: (pid#%li) "
 				"Parity Error\n", srb->cmd->pid);
@@ -2298,18 +2253,19 @@
 				DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT));
 		}
 		/* Now: Check remainig data: The SCSI counters should tell us ... */
-		d_left_counter = DC395x_read32(acb, TRM_S1040_SCSI_COUNTER)
-		    + ((DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) & 0x1f)
+		sc = DC395x_read32(acb, TRM_S1040_SCSI_COUNTER);
+		fc = DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT);
+		d_left_counter = sc + ((fc & 0x1f)
 		       << ((srb->dcb->sync_period & WIDE_SYNC) ? 1 :
 			   0));
 		dprintkdbg(DBG_KG, "data_in_phase0: "
 			"SCSI{fifocnt=0x%02x%s ctr=0x%08x} "
 			"DMA{fifocnt=0x%02x fifostat=0x%02x ctr=0x%08x} "
 			"Remain{totxfer=%i scsi_fifo+ctr=%i}\n",
-			DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT),
+			fc,
 			(srb->dcb->sync_period & WIDE_SYNC) ? "words" : "bytes",
-			DC395x_read32(acb, TRM_S1040_SCSI_COUNTER),
-			DC395x_read8(acb, TRM_S1040_DMA_FIFOCNT),
+			sc,
+			fc,
 			DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT),
 			DC395x_read32(acb, TRM_S1040_DMA_CXCNT),
 			srb->total_xfer_length, d_left_counter);
@@ -2317,40 +2273,79 @@
 		/* KG: Less than or equal to 4 bytes can not be transfered via DMA, it seems. */
 		if (d_left_counter
 		    && srb->total_xfer_length <= DC395x_LASTPIO) {
+			size_t left_io = srb->total_xfer_length;
+
 			/*u32 addr = (srb->segment_x[srb->sg_index].address); */
 			/*sg_update_list (srb, d_left_counter); */
-			dprintkdbg(DBG_PIO, "data_in_phase0: PIO (%i %s) to "
-				"%p for remaining %i bytes:",
-				DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) & 0x1f,
+			dprintkdbg(DBG_PIO, "data_in_phase0: PIO (%i %s) "
+				   "for remaining %i bytes:",
+				fc & 0x1f,
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
+			while (left_io) {
+				unsigned char *virt, *base = NULL;
+				unsigned long flags = 0;
+				size_t len = left_io;
+
+				if (srb->cmd->use_sg) {
+					size_t offset = srb->request_length - left_io;
+					local_irq_save(flags);
+					/* Assumption: it's inside one page as it's at most 4 bytes and
+					   I just assume it's on a 4-byte boundary */
+					base = scsi_kmap_atomic_sg((struct scatterlist *)srb->cmd->request_buffer,
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
+
+					fc = DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT);
+
+					if (fc == 0x40) {
+						left_io = 0;
+						break;
+					}
+				}
+
+				WARN_ON((fc != 0x40) == !d_left_counter);
+
+				if (fc == 0x40 && (srb->dcb->sync_period & WIDE_SYNC)) {
+					/* Read the last byte ... */
+					if (srb->total_xfer_length > 0) {
+						u8 byte = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
+
+						*virt++ = byte;
+						srb->total_xfer_length--;
+						if (debug_enabled(DBG_PIO))
+							printk(" %02x", byte);
+					}
+
+					DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2, 0);
+				}
+
+				if (srb->cmd->use_sg) {
+					scsi_kunmap_atomic_sg(base);
+					local_irq_restore(flags);
 				}
-#endif
-				DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2, 0);
 			}
 			/*printk(" %08x", *(u32*)(bus_to_virt (addr))); */
 			/*srb->total_xfer_length = 0; */
@@ -2509,22 +2504,43 @@
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
+				size_t len = left_io;
+
+				if (srb->cmd->use_sg) {
+					size_t offset = srb->request_length - left_io;
+					local_irq_save(flags);
+					/* Again, max 4 bytes */
+					base = scsi_kmap_atomic_sg((struct scatterlist *)srb->cmd->request_buffer,
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
+					scsi_kunmap_atomic_sg(base);
+					local_irq_restore(flags);
+				}
 			}
 			if (srb->dcb->sync_period & WIDE_SYNC) {
 				if (ln % 2) {
@@ -3319,7 +3335,6 @@
 	    srb->segment_x[DC395x_MAX_SG_LISTENTRY - 1].address;
 	srb->segment_x[0].length =
 	    srb->segment_x[DC395x_MAX_SG_LISTENTRY - 1].length;
-	srb->virt_addr = srb->virt_addr_req;
 }
 
 
@@ -3713,8 +3728,6 @@
 	srb->xferred = srb->total_xfer_length;
 	/* srb->segment_x : a one entry of S/G list table */
 	srb->total_xfer_length = sizeof(cmd->sense_buffer);
-	srb->virt_addr_req = srb->virt_addr;
-	srb->virt_addr = cmd->sense_buffer;
 	srb->segment_x[0].length = sizeof(cmd->sense_buffer);
 	/* Map sense buffer */
 	srb->segment_x[0].address =
diff -u a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	30 Mar 2006 19:19:08 -0000
+++ b/drivers/scsi/scsi_lib.c	2 Apr 2006 19:13:12 -0000
@@ -2307,3 +2307,60 @@
 	return 1;
 }
 EXPORT_SYMBOL_GPL(scsi_execute_in_process_context);
+
+/**
+ * scsi_kmap_atomic_sg - find and atomically map an sg-elemnt
+ * @sg:		scatter-gather list
+ * @sg_count:	number of segments in sg
+ * @offset:	offset in bytes into sg, on return offset into the mapped area
+ * @len:	bytes to map, on return number of bytes mapped
+ *
+ * Returns virtual address of the start of the mapped page
+ */
+void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
+			  size_t *offset, size_t *len)
+{
+	int i;
+	size_t sg_len = 0, len_complete = 0;
+	struct page *page;
+
+	for (i = 0; i < sg_count; i++) {
+		len_complete = sg_len; /* Complete sg-entries */
+		sg_len += sg[i].length;
+		if (sg_len > *offset)
+			break;
+	}
+
+	if (i == sg_count) {
+		printk(KERN_ERR "%s: Bytes in sg: %u, requested offset %u, elements %d\n",
+		       __FUNCTION__, sg_len, *offset, sg_count);
+		WARN_ON(1);
+		return NULL;
+	}
+
+	/* Offset starting from the beginning of first page in this sg-entry */
+	*offset = *offset - len_complete + sg[i].offset;
+
+	/* Assumption: contiguous pages can be accessed as "page + i" */
+	page = nth_page(sg[i].page, (*offset >> PAGE_SHIFT));
+	*offset &= ~PAGE_MASK;
+
+	/* Bytes in this sg-entry from *offset to the end of the page */
+	sg_len = PAGE_SIZE - *offset;
+	if (*len > sg_len)
+		*len = sg_len;
+
+	return kmap_atomic(page, KM_BIO_SRC_IRQ);
+}
+EXPORT_SYMBOL(scsi_kmap_atomic_sg);
+
+/**
+ * scsi_kunmap_atomic_sg - atomically unmap a virtual address, previously
+ *			   mapped with scsi_kmap_atomic_sg
+ * @virt:	virtual address to be unmapped
+ */
+void scsi_kunmap_atomic_sg(void *virt)
+{
+	kunmap_atomic(virt, KM_BIO_SRC_IRQ);
+}
+EXPORT_SYMBOL(scsi_kunmap_atomic_sg);
diff -u a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
--- a/include/scsi/scsi_cmnd.h	30 Mar 2006 19:21:31 -0000
+++ b/include/scsi/scsi_cmnd.h	2 Apr 2006 19:10:10 -0000
@@ -152,4 +152,8 @@
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int, unsigned int);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
+extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
+				 size_t *offset, size_t *len);
+extern void scsi_kunmap_atomic_sg(void *virt);
+
 #endif /* _SCSI_SCSI_CMND_H */
