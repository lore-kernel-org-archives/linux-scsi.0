From: Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH] dc395x [2/5] - sg list handling cleanups
Date: Tue, 9 Mar 2004 15:24:00 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309042400.GB12274@twibble.org>
References: <20040309042300.GA12274@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:49348 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S261528AbUCIEYZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2004 23:24:25 -0500
Content-Disposition: inline
In-Reply-To: <20040309042300.GA12274@twibble.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

Cleanup a lot of the sg list handling to make it easier to follow in
preparation for making this work on sparc64 (big-endian & 64bit).

diff -du -r a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2004-02-16 22:34:46.287013737 +1100
+++ b/drivers/scsi/dc395x.c	2004-02-16 22:34:36.420536329 +1100
@@ -210,11 +210,6 @@
 #define DC395x_write16(acb,address,value)	outw((value), acb->io_port_base + (address))
 #define DC395x_write32(acb,address,value)	outl((value), acb->io_port_base + (address))
 
-
-#define BUS_ADDR(sg)		sg_dma_address(&(sg))
-#define CPU_ADDR(sg)		(page_address((sg).page)+(sg).offset)
-#define PAGE_ADDRESS(sg)	page_address((sg)->page)
-
 /* cmd->result */
 #define RES_TARGET		0x000000FF	/* Target State */
 #define RES_TARGET_LNX  STATUS_MASK	/* Only official ... */
@@ -233,6 +228,13 @@
 
 #define TAG_NONE 255
 
+/*
+ * srb->segement_x is the hw sg list. It is always allocated as a
+ * DC395x_MAX_SG_LISTENTRY entries in a linear block which does not
+ * cross a page boundy.
+ */
+#define SEGMENTX_LEN	(sizeof(struct SGentry)*DC395x_MAX_SG_LISTENTRY)
+
 
 struct SGentry {
 	u32 address;		/* bus! address */
@@ -276,21 +278,28 @@
 struct ScsiReqBlk {
 	struct list_head list;		/* next/prev ptrs for srb lists */
 	struct DeviceCtlBlk *dcb;
-
-	/* HW scatter list (up to 64 entries) */
-	struct SGentry *segment_x;
 	Scsi_Cmnd *cmd;
 
-	unsigned char *virt_addr;	/* set by update_sg_list */
+	struct SGentry *segment_x;	/* Linear array of hw sg entries (up to 64 entries) */
+	u32 sg_bus_addr;	        /* Bus address of sg list (ie, of segment_x) */
 
-	u32 total_xfer_length;
-	u32 xferred;		/* Backup for the already xferred len */
+	u8 sg_count;			/* No of HW sg entries for this request */
+	u8 sg_index;			/* Index of HW sg entry for this request */
+	u32 total_xfer_length;		/* Total number of bytes remaining to be transfered */
+	unsigned char *virt_addr;	/* Virtual address of current transfer position */
 
-	u32 sg_bus_addr;	/* bus address of DC395x scatterlist */
+	/*
+	 * The sense buffer handling function, request_sense, uses
+	 * the first hw sg entry (segment_x[0]) and the transfer
+	 * length (total_xfer_length). While doing this it stores the
+	 * original values into the last sg hw list
+	 * (srb->segment_x[DC395x_MAX_SG_LISTENTRY - 1] and the
+	 * total_xfer_length in xferred. These values are restored in
+	 * pci_unmap_srb_sense. This is the only place xferred is used.
+	 */
+	u32 xferred;		        /* Saved copy of total_xfer_length */
 
 	u16 state;
-	u8 sg_count;
-	u8 sg_index;
 
 	u8 msgin_buf[6];
 	u8 msgout_buf[6];
@@ -835,7 +844,8 @@
 static void srb_waiting_append(struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb)
 {
-	dprintkdbg(DBG_0, "srb_waiting_append: srb %p cmd %li\n", srb, srb->cmd->pid);
+	dprintkdbg(DBG_0, "srb_waiting_append: srb %p cmd %li\n",
+		   srb, srb->cmd->pid);
         list_add_tail(&srb->list, &dcb->srb_waiting_list);
 }
 
@@ -879,7 +889,8 @@
 static void srb_going_to_waiting_move(struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb)
 {
-	dprintkdbg(DBG_0, "srb_going_to_waiting_move: srb %p, pid = %li\n", srb, srb->cmd->pid);
+	dprintkdbg(DBG_0, "srb_going_to_waiting_move: srb %p, pid = %li\n",
+		   srb, srb->cmd->pid);
 	list_move(&srb->list, &dcb->srb_waiting_list);
 }
 
@@ -1021,134 +1032,97 @@
 static void build_srb(Scsi_Cmnd *cmd, struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb)
 {
-	int i, max;
-	struct SGentry *sgp;
-	struct scatterlist *sl;
-	u32 request_size;
-	int dir;
-
+	int dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
 	dprintkdbg(DBG_0, "build_srb...\n");
+
 	srb->dcb = dcb;
 	srb->cmd = cmd;
-	dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
+	srb->sg_count = 0;
+	srb->total_xfer_length = 0;
+	srb->sg_bus_addr = 0;
+	srb->virt_addr = 0;
+	srb->sg_index = 0;
+	srb->adapter_status = 0;
+	srb->target_status = 0;
+	srb->msg_count = 0;
+	srb->status = 0;
+	srb->flag = 0;
+	srb->state = 0;
+	srb->retry_count = 0;
+	srb->tag_number = TAG_NONE;
+	srb->scsi_phase = PH_BUS_FREE;	/* initial phase */
+	srb->end_message = 0;
 
-	if (cmd->use_sg && dir != PCI_DMA_NONE) {
-		unsigned int len = 0;
-		/* TODO: In case usg_sg and the no of segments differ, things
-		 * will probably go wrong. */
-		max = srb->sg_count =
-		    pci_map_sg(dcb->acb->dev,
-			       (struct scatterlist *)cmd->request_buffer,
-			       cmd->use_sg, dir);
-		sgp = srb->segment_x;
-		request_size = cmd->request_bufflen;
-		dprintkdbg(DBG_SGPARANOIA, 
-		       "BuildSRB: Bufflen = %d, buffer = %p, use_sg = %d\n",
-		       cmd->request_bufflen, cmd->request_buffer,
-		       cmd->use_sg);
-		dprintkdbg(DBG_SGPARANOIA, 
-		       "Mapped %i Segments to %i\n", cmd->use_sg,
-		       srb->sg_count);
-		sl = (struct scatterlist *)cmd->request_buffer;
+	if (dir == PCI_DMA_NONE || !cmd->request_buffer) {
+		dprintkdbg(DBG_0, "srb[A] len=%d buf=%p use_sg=%d !MAP=%08x\n",
+			    cmd->bufflen, cmd->request_buffer,
+			    cmd->use_sg, srb->segment_x[0].address);
+	} else if (cmd->use_sg) {
+		int i;
+		u32 reqlen = cmd->request_bufflen;
+		struct scatterlist *sl = (struct scatterlist *)
+					 cmd->request_buffer;
+		struct SGentry *sgp = srb->segment_x;
+		srb->sg_count = pci_map_sg(dcb->acb->dev, sl, cmd->use_sg,
+					   dir);
+		dprintkdbg(DBG_0, "srb[B] len=%d buf=%p use_sg=%d segs=%d\n",
+			   reqlen, cmd->request_buffer, cmd->use_sg,
+			   srb->sg_count);
 
 		srb->virt_addr = page_address(sl->page);
-		for (i = 0; i < max; i++) {
-			u32 busaddr = (u32) sg_dma_address(&sl[i]);
-			u32 seglen = (u32) sl[i].length;
+		for (i = 0; i < srb->sg_count; i++) {
+			u32 busaddr = (u32)sg_dma_address(&sl[i]);
+			u32 seglen = (u32)sl[i].length;
 			sgp[i].address = busaddr;
 			sgp[i].length = seglen;
-			len += seglen;
-			dprintkdbg(DBG_SGPARANOIA,
-			       "Setting up sgp %d, address = 0x%08x, length = %d, tot len = %d\n",
-			       i, busaddr, seglen, len);
+			srb->total_xfer_length += seglen;
 		}
-		sgp += max - 1;
-		/* Fixup for last buffer too big as it is allocated on even page boundaries */
-		if (len > request_size) {
-#if debug_enabled(DBG_KG) || debug_enabled(DBG_SGPARANOIA)
-			dprintkdbg(DBG_KG|DBG_SGPARANOIA,
-			       "Fixup SG total length: %d->%d, last seg %d->%d\n",
-			       len, request_size, sgp->length,
-			       sgp->length - (len - request_size));
-#endif
-			sgp->length -= (len - request_size);
-			len = request_size;
+		sgp += srb->sg_count - 1;
+
+		/*
+		 * adjust last page if too big as it is allocated
+		 * on even page boundaries
+		 */
+		if (srb->total_xfer_length > reqlen) {
+			sgp->length -= (srb->total_xfer_length - reqlen);
+			srb->total_xfer_length = reqlen;
 		}
-		/* WIDE padding */
-		if (dcb->sync_period & WIDE_SYNC && len % 2) {
-			len++;
+
+		/* Fixup for WIDE padding - make sure length is even */
+		if (dcb->sync_period & WIDE_SYNC &&
+		    srb->total_xfer_length % 2) {
+			srb->total_xfer_length++;
 			sgp->length++;
 		}
-		srb->total_xfer_length = len;	/*? */
-		/* Hopefully this does not cross a page boundary ... */
-		srb->sg_bus_addr =
-		    pci_map_single(dcb->acb->dev, srb->segment_x,
-				   sizeof(struct SGentry) *
-				   DC395x_MAX_SG_LISTENTRY,
-				   PCI_DMA_TODEVICE);
-		dprintkdbg(DBG_SGPARANOIA,
-		       "Map SG descriptor list %p (%05x) to %08x\n",
-		       srb->segment_x,
-		       sizeof(struct SGentry) * DC395x_MAX_SG_LISTENTRY,
-		       srb->sg_bus_addr);
+
+		srb->sg_bus_addr = pci_map_single(dcb->acb->dev,
+						srb->segment_x,
+				            	SEGMENTX_LEN,
+				            	PCI_DMA_TODEVICE);
+
+		dprintkdbg(DBG_SGPARANOIA, "srb[B] map sg %p->%08x(%05x)\n",
+			   srb->segment_x, srb->sg_bus_addr, SEGMENTX_LEN);
 	} else {
-		if (cmd->request_buffer && dir != PCI_DMA_NONE) {
-			u32 len = cmd->request_bufflen;	/* Actual request size */
-			srb->sg_count = 1;
-			srb->segment_x[0].address =
-			    pci_map_single(dcb->acb->dev,
-					   cmd->request_buffer, len, dir);
-			/* WIDE padding */
-			if (dcb->sync_period & WIDE_SYNC && len % 2)
-				len++;
-			srb->segment_x[0].length = len;
-			srb->total_xfer_length = len;
-			srb->virt_addr = cmd->request_buffer;
-			srb->sg_bus_addr = 0;
-			dprintkdbg(DBG_SGPARANOIA,
-			       "BuildSRB: len = %d, buffer = %p, use_sg = %d, map %08x\n",
-			       len, cmd->request_buffer, cmd->use_sg,
-			       srb->segment_x[0].address);
-		} else {
-			srb->sg_count = 0;
-			srb->total_xfer_length = 0;
-			srb->sg_bus_addr = 0;
-			srb->virt_addr = 0;
-			dprintkdbg(DBG_SGPARANOIA,
-			       "BuildSRB: buflen = %d, buffer = %p, use_sg = %d, NOMAP %08x\n",
-			       cmd->bufflen, cmd->request_buffer,
-			       cmd->use_sg, srb->segment_x[0].address);
-		}
-	}
+		srb->total_xfer_length = cmd->request_bufflen;
+		srb->sg_count = 1;
+		srb->segment_x[0].address =
+			pci_map_single(dcb->acb->dev, cmd->request_buffer,
+				       srb->total_xfer_length, dir);
 
-	srb->sg_index = 0;
-	srb->adapter_status = 0;
-	srb->target_status = 0;
-	srb->msg_count = 0;
-	srb->status = 0;
-	srb->flag = 0;
-	srb->state = 0;
-	srb->retry_count = 0;
+		/* Fixup for WIDE padding - make sure length is even */
+		if (dcb->sync_period & WIDE_SYNC && srb->total_xfer_length % 2)
+			srb->total_xfer_length++;
 
-#if debug_enabled(DBG_TRACE|DBG_TRACEALL) && debug_enabled(DBG_SGPARANOIA)
-	if ((unsigned long)srb->debugtrace & (DEBUGTRACEBUFSZ - 1)) {
-		dprintkdbg(DBG_SGPARANOIA,
-			"SRB %i (%p): debugtrace %p corrupt!\n",
-		       (srb - dcb->acb->srb_array) /
-		       sizeof(struct ScsiReqBlk), srb, srb->debugtrace);
+		srb->segment_x[0].length = srb->total_xfer_length;
+		srb->virt_addr = cmd->request_buffer;
+		dprintkdbg(DBG_0, "srb[C] len=%d buf=%p use_sg=%d map=%08x\n",
+				srb->total_xfer_length, cmd->request_buffer,
+			        cmd->use_sg, srb->segment_x[0].address);
 	}
-#endif
 #if debug_enabled(DBG_TRACE|DBG_TRACEALL)
 	srb->debugpos = 0;
 	srb->debugtrace = 0;
 #endif
-	TRACEPRINTF("pid %li(%li):%02x %02x..(%i-%i) *", cmd->pid,
-		    jiffies, cmd->cmnd[0], cmd->cmnd[1],
-		    cmd->device->id, cmd->device->lun);
-	srb->tag_number = TAG_NONE;
-
-	srb->scsi_phase = PH_BUS_FREE;	/* initial phase */
-	srb->end_message = 0;
 }
 
 
@@ -1598,7 +1572,7 @@
 	u8 s_stat, scsicommand, i, identify_message;
 	u8 *ptr;
 
-	dprintkdbg(DBG_0, "start_scsi..............\n");
+	dprintkdbg(DBG_0, "start_scsi (#%li)\n", srb->cmd->pid);
 	srb->tag_number = TAG_NONE;	/* acb->tag_max_num: had error read in eeprom */
 
 	s_stat = DC395x_read8(acb, TRM_S1040_SCSI_SIGNAL);
@@ -1958,7 +1932,7 @@
 static void msgout_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "msgout_phase0...\n");
+	dprintkdbg(DBG_0, "msgout_phase0 (#%li)\n", srb->cmd->pid);
 	if (srb->state & (SRB_UNEXPECT_RESEL + SRB_ABORT_SENT))
 		*pscsi_status = PH_BUS_FREE;	/*.. initial phase */
 
@@ -1974,7 +1948,7 @@
 	u16 i;
 	u8 *ptr;
 
-	dprintkdbg(DBG_0, "msgout_phase1...\n");
+	dprintkdbg(DBG_0, "msgout_phase1 (#%li)\n", srb->cmd->pid);
 	TRACEPRINTF("MOP1*");
 	clear_fifo(acb, "MOP1");
 	if (!(srb->state & SRB_MSGOUT)) {
@@ -2014,6 +1988,7 @@
 static void command_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
+	dprintkdbg(DBG_0, "command_phase0 (#%li)\n", srb->cmd->pid);
 	TRACEPRINTF("COP0 *");
 	/*1.25 */
 	/*clear_fifo(acb, COP0); */
@@ -2028,7 +2003,7 @@
 	u8 *ptr;
 	u16 i;
 
-	dprintkdbg(DBG_0, "command_phase1...\n");
+	dprintkdbg(DBG_0, "command_phase1 (#%li)\n", srb->cmd->pid);
 	TRACEPRINTF("COP1*");
 	clear_fifo(acb, "COP1");
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_CLRATN);
@@ -2058,8 +2033,11 @@
 }
 
 
-/* Do sanity checks for S/G list */
-static inline void check_sg_list(struct ScsiReqBlk *srb)
+/*
+ * Verify that the remaining space in the hw sg lists is the same as
+ * the count of remaining bytes in srb->total_xfer_length
+ */
+static void sg_verify_length(struct ScsiReqBlk *srb)
 {
 	if (debug_enabled(DBG_SGPARANOIA)) {
 		unsigned len = 0;
@@ -2079,75 +2057,90 @@
  * Compute the next Scatter Gather list index and adjust its length
  * and address if necessary; also compute virt_addr
  */
-static void update_sg_list(struct ScsiReqBlk *srb, u32 left)
+static void sg_update_list(struct ScsiReqBlk *srb, u32 left)
 {
-	struct SGentry *psge;
-	u32 xferred = 0;
 	u8 idx;
-	Scsi_Cmnd *cmd = srb->cmd;
 	struct scatterlist *sg;
+	Scsi_Cmnd *cmd = srb->cmd;
 	int segment = cmd->use_sg;
+	u32 xferred = srb->total_xfer_length - left; /* bytes transfered */
+	struct SGentry *psge = srb->segment_x + srb->sg_index;
 
-	dprintkdbg(DBG_KG, "Update SG: Total %i, Left %i\n", 
-	       srb->total_xfer_length, left);
-	check_sg_list(srb);
-	psge = srb->segment_x + srb->sg_index;
-	/* data that has already been transferred */
-	xferred = srb->total_xfer_length - left;
-	if (srb->total_xfer_length != left) {
-		/*check_sg_list_TX (srb, xferred); */
-		/* Remaining */
-		srb->total_xfer_length = left;
-		/* parsing from last time disconnect SGIndex */
-		for (idx = srb->sg_index; idx < srb->sg_count; idx++) {
+	dprintkdbg(DBG_0, "sg_update_list: Transfered %i of %i bytes, "
+		   "%i remain\n",
+		   xferred, srb->total_xfer_length, left);
+	if (xferred == 0) {
+		/* nothing to update since we did not transfer any data */
+		return;
+	}
+
+	sg_verify_length(srb);
+	srb->total_xfer_length = left;	/* update remaining count */
+	for (idx = srb->sg_index; idx < srb->sg_count; idx++) {
+		if (xferred >= psge->length) {
 			/* Complete SG entries done */
-			if (xferred >= psge->length)
-				xferred -= psge->length;
-			/* Partial SG entries done */
-			else {
-				psge->length -= xferred;	/* residue data length  */
-				psge->address += xferred;	/* residue data pointer */
-				srb->sg_index = idx;
-				pci_dma_sync_single(srb->dcb->
-						    acb->dev,
-						    srb->sg_bus_addr,
-						    sizeof(struct SGentry)
-						    *
-						    DC395x_MAX_SG_LISTENTRY,
-						    PCI_DMA_TODEVICE);
-				break;
-			}
-			psge++;
+			xferred -= psge->length;
+		} else {
+			/* Partial SG entry done */
+			psge->length -= xferred;
+			psge->address += xferred;
+			srb->sg_index = idx;
+			pci_dma_sync_single(srb->dcb->
+					    acb->dev,
+					    srb->sg_bus_addr,
+					    SEGMENTX_LEN,
+					    PCI_DMA_TODEVICE);
+			break;
 		}
-		check_sg_list(srb);
+		psge++;
 	}
-	/* We need the corresponding virtual address sg_to_virt */
-	/*dprintkl(KERN_DEBUG, "sg_to_virt: bus %08x -> virt ", psge->address); */
+	sg_verify_length(srb);
+
+	/* we need the corresponding virtual address */
 	if (!segment) {
 		srb->virt_addr += xferred;
-		/*printk("%p\n", srb->virt_addr); */
 		return;
 	}
+
 	/* We have to walk the scatterlist to find it */
 	sg = (struct scatterlist *)cmd->request_buffer;
 	while (segment--) {
-		/*printk("(%08x)%p ", BUS_ADDR(*sg), PAGE_ADDRESS(sg)); */
 		unsigned long mask =
 		    ~((unsigned long)sg->length - 1) & PAGE_MASK;
-		if ((BUS_ADDR(*sg) & mask) == (psge->address & mask)) {
-			srb->virt_addr = (PAGE_ADDRESS(sg)
+		if ((sg_dma_address(sg) & mask) == (psge->address & mask)) {
+			srb->virt_addr = (page_address(sg->page)
 					   + psge->address -
 					   (psge->address & PAGE_MASK));
-			/*printk("%p\n", srb->virt_addr); */
 			return;
 		}
 		++sg;
 	}
+
 	dprintkl(KERN_ERR, "sg_to_virt failed!\n");
 	srb->virt_addr = 0;
 }
 
 
+/*
+ * We have transfered a single byte (PIO mode?) and need to update
+ * the count of bytes remaining (total_xfer_length) and update the sg
+ * entry to either point to next byte in the current sg entry, or of
+ * already at the end to point to the start of the next sg entry
+ */
+static void sg_subtract_one(struct ScsiReqBlk *srb)
+{
+	srb->total_xfer_length--;
+	srb->segment_x[srb->sg_index].length--;
+	if (srb->total_xfer_length &&
+	    !srb->segment_x[srb->sg_index].length) {
+		if (debug_enabled(DBG_PIO))
+			printk(" (next segment)");
+		srb->sg_index++;
+		sg_update_list(srb, srb->total_xfer_length);
+	}
+}
+
+
 /* 
  * cleanup_after_transfer
  * 
@@ -2190,7 +2183,7 @@
 	u16 scsi_status = *pscsi_status;
 	u32 d_left_counter = 0;
 
-	dprintkdbg(DBG_0, "data_out_phase0...\n");
+	dprintkdbg(DBG_0, "data_out_phase0 (#%li)\n", srb->cmd->pid);
 	TRACEPRINTF("DOP0*");
 
 	/*
@@ -2310,7 +2303,7 @@
 			    srb->total_xfer_length - d_left_counter;
 			const int diff =
 			    (dcb->sync_period & WIDE_SYNC) ? 2 : 1;
-			update_sg_list(srb, d_left_counter);
+			sg_update_list(srb, d_left_counter);
 			/* KG: Most ugly hack! Apparently, this works around a chip bug */
 			if ((srb->segment_x[srb->sg_index].length ==
 			     diff && srb->cmd->use_sg)
@@ -2321,7 +2314,7 @@
 				       "Work around chip bug (%i)?\n", diff);
 				d_left_counter =
 				    srb->total_xfer_length - diff;
-				update_sg_list(srb, d_left_counter);
+				sg_update_list(srb, d_left_counter);
 				/*srb->total_xfer_length -= diff; */
 				/*srb->virt_addr += diff; */
 				/*if (srb->cmd->use_sg) */
@@ -2351,7 +2344,7 @@
 static void data_out_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "data_out_phase1...\n");
+	dprintkdbg(DBG_0, "data_out_phase1 (#%li)\n", srb->cmd->pid);
 	/*1.25 */
 	TRACEPRINTF("DOP1*");
 	clear_fifo(acb, "DOP1");
@@ -2368,7 +2361,7 @@
 	u16 scsi_status = *pscsi_status;
 	u32 d_left_counter = 0;
 
-	dprintkdbg(DBG_0, "data_in_phase0...\n");
+	dprintkdbg(DBG_0, "data_in_phase0 (#%li)\n", srb->cmd->pid);
 	TRACEPRINTF("DIP0*");
 
 	/*
@@ -2445,7 +2438,7 @@
 		if (d_left_counter
 		    && srb->total_xfer_length <= DC395x_LASTPIO) {
 			/*u32 addr = (srb->segment_x[srb->sg_index].address); */
-			/*update_sg_list (srb, d_left_counter); */
+			/*sg_update_list (srb, d_left_counter); */
 			dprintkdbg(DBG_PIO, "DIP0: PIO (%i %s) to %p for remaining %i bytes:",
 				  DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) &
 				  0x1f,
@@ -2458,32 +2451,19 @@
 				DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2,
 					      CFG2_WIDEFIFO);
 
-			while (DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) !=
-			       0x40) {
-				u8 byte =
-				    DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
+			while (DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) != 0x40) {
+				u8 byte = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 				*(srb->virt_addr)++ = byte;
 				if (debug_enabled(DBG_PIO))
 					printk(" %02x", byte);
-				srb->total_xfer_length--;
 				d_left_counter--;
-				srb->segment_x[srb->sg_index].length--;
-				if (srb->total_xfer_length
-				    && !srb->segment_x[srb->sg_index].
-				    length) {
-				    	if (debug_enabled(DBG_PIO))
-						printk(" (next segment)");
-					srb->sg_index++;
-					update_sg_list(srb,
-							     d_left_counter);
-				}
+				sg_subtract_one(srb);
 			}
 			if (srb->dcb->sync_period & WIDE_SYNC) {
-#if 1				/* Read the last byte ... */
+#if 1
+                /* Read the last byte ... */
 				if (srb->total_xfer_length > 0) {
-					u8 byte =
-					    DC395x_read8
-					    (acb, TRM_S1040_SCSI_FIFO);
+					u8 byte = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 					*(srb->virt_addr)++ = byte;
 					srb->total_xfer_length--;
 					if (debug_enabled(DBG_PIO))
@@ -2563,7 +2543,7 @@
 			 * there were some data residue in SCSI FIFO or
 			 * SCSI transfer counter not empty
 			 */
-			update_sg_list(srb, d_left_counter);
+			sg_update_list(srb, d_left_counter);
 		}
 	}
 	/* KG: The target may decide to disconnect: Empty FIFO before! */
@@ -2597,7 +2577,7 @@
 static void data_in_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "data_in_phase1...\n");
+	dprintkdbg(DBG_0, "data_in_phase1 (#%li)\n", srb->cmd->pid);
 	/* FIFO should be cleared, if previous phase was not DataPhase */
 	/*clear_fifo(acb, "DIP1"); */
 	/* Allow data in! */
@@ -2615,7 +2595,7 @@
 	struct DeviceCtlBlk *dcb = srb->dcb;
 	u8 bval;
 
-	dprintkdbg(DBG_0, "DataIO_transfer %c (pid %li): len = %i, SG: %i/%i\n",
+	dprintkdbg(DBG_0, "data_io_transfer %c (#%li): len=%i, sg=(%i/%i)\n",
 	       ((io_dir & DMACMD_DIR) ? 'r' : 'w'), srb->cmd->pid,
 	       srb->total_xfer_length, srb->sg_index,
 	       srb->sg_count);
@@ -2623,176 +2603,151 @@
 		    srb->sg_index, srb->sg_count);
 	if (srb == acb->tmp_srb)
 		dprintkl(KERN_ERR, "Using tmp_srb in DataPhase!\n");
-	if (srb->sg_index < srb->sg_count) {
-		if (srb->total_xfer_length > DC395x_LASTPIO) {
-			u8 dma_status = DC395x_read8(acb, TRM_S1040_DMA_STATUS);
-			/*
-			 * KG: What should we do: Use SCSI Cmd 0x90/0x92?
-			 * Maybe, even ABORTXFER would be appropriate
-			 */
-			if (dma_status & XFERPENDING) {
-				dprintkl(KERN_DEBUG, "Xfer pending! Expect trouble!!\n");
-				dump_register_info(acb, dcb, srb);
-				DC395x_write8(acb, TRM_S1040_DMA_CONTROL,
-					      CLRXFIFO);
-			}
-			/* clear_fifo(acb, "IO"); */
-			/* 
-			 * load what physical address of Scatter/Gather list table want to be
-			 * transfer 
-			 */
-			srb->state |= SRB_DATA_XFER;
-			DC395x_write32(acb, TRM_S1040_DMA_XHIGHADDR, 0);
-			if (srb->cmd->use_sg) {	/* with S/G */
-				io_dir |= DMACMD_SG;
-				DC395x_write32(acb, TRM_S1040_DMA_XLOWADDR,
-					       srb->sg_bus_addr +
-					       sizeof(struct SGentry) *
-					       srb->sg_index);
-				/* load how many bytes in the Scatter/Gather list table */
-				DC395x_write32(acb, TRM_S1040_DMA_XCNT,
-					       ((u32)
-						(srb->sg_count -
-						 srb->sg_index) << 3));
-			} else {	/* without S/G */
-				io_dir &= ~DMACMD_SG;
-				DC395x_write32(acb, TRM_S1040_DMA_XLOWADDR,
-					       srb->segment_x[0].address);
-				DC395x_write32(acb, TRM_S1040_DMA_XCNT,
-					       srb->segment_x[0].length);
-			}
-			/* load total transfer length (24bits) max value 16Mbyte */
-			DC395x_write32(acb, TRM_S1040_SCSI_COUNTER,
-				       srb->total_xfer_length);
-			DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
-			if (io_dir & DMACMD_DIR) {	/* read */
-				DC395x_write8(acb, TRM_S1040_SCSI_COMMAND,
-					      SCMD_DMA_IN);
-				DC395x_write16(acb, TRM_S1040_DMA_COMMAND,
-					       io_dir);
-			} else {
-				DC395x_write16(acb, TRM_S1040_DMA_COMMAND,
-					       io_dir);
-				DC395x_write8(acb, TRM_S1040_SCSI_COMMAND,
-					      SCMD_DMA_OUT);
-			}
 
+	if (srb->sg_index >= srb->sg_count) {
+		/* can't happen? out of bounds error */
+		return;
+	}
+
+	if (srb->total_xfer_length > DC395x_LASTPIO) {
+		u8 dma_status = DC395x_read8(acb, TRM_S1040_DMA_STATUS);
+		/*
+		 * KG: What should we do: Use SCSI Cmd 0x90/0x92?
+		 * Maybe, even ABORTXFER would be appropriate
+		 */
+		if (dma_status & XFERPENDING) {
+			dprintkl(KERN_DEBUG, "Xfer pending! Expect trouble!!\n");
+			dump_register_info(acb, dcb, srb);
+			DC395x_write8(acb, TRM_S1040_DMA_CONTROL, CLRXFIFO);
+		}
+		/* clear_fifo(acb, "IO"); */
+		/* 
+		 * load what physical address of Scatter/Gather list table
+		 * want to be transfer
+		 */
+		srb->state |= SRB_DATA_XFER;
+		DC395x_write32(acb, TRM_S1040_DMA_XHIGHADDR, 0);
+		if (srb->cmd->use_sg) {	/* with S/G */
+			io_dir |= DMACMD_SG;
+			DC395x_write32(acb, TRM_S1040_DMA_XLOWADDR,
+				       srb->sg_bus_addr +
+				       sizeof(struct SGentry) *
+				       srb->sg_index);
+			/* load how many bytes in the sg list table */
+			DC395x_write32(acb, TRM_S1040_DMA_XCNT,
+				       ((u32)(srb->sg_count -
+					      srb->sg_index) << 3));
+		} else {	/* without S/G */
+			io_dir &= ~DMACMD_SG;
+			DC395x_write32(acb, TRM_S1040_DMA_XLOWADDR,
+				       srb->segment_x[0].address);
+			DC395x_write32(acb, TRM_S1040_DMA_XCNT,
+				       srb->segment_x[0].length);
+		}
+		/* load total transfer length (24bits) max value 16Mbyte */
+		DC395x_write32(acb, TRM_S1040_SCSI_COUNTER,
+			       srb->total_xfer_length);
+		DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
+		if (io_dir & DMACMD_DIR) {	/* read */
+			DC395x_write8(acb, TRM_S1040_SCSI_COMMAND,
+				      SCMD_DMA_IN);
+			DC395x_write16(acb, TRM_S1040_DMA_COMMAND, io_dir);
+		} else {
+			DC395x_write16(acb, TRM_S1040_DMA_COMMAND, io_dir);
+			DC395x_write8(acb, TRM_S1040_SCSI_COMMAND,
+				      SCMD_DMA_OUT);
 		}
+
+	}
 #if DC395x_LASTPIO
-		else if (srb->total_xfer_length > 0) {	/* The last four bytes: Do PIO */
-			/* clear_fifo(acb, "IO"); */
-			/* 
-			 * load what physical address of Scatter/Gather list table want to be
-			 * transfer 
-			 */
-			srb->state |= SRB_DATA_XFER;
-			/* load total transfer length (24bits) max value 16Mbyte */
-			DC395x_write32(acb, TRM_S1040_SCSI_COUNTER,
-				       srb->total_xfer_length);
-			DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
-			if (io_dir & DMACMD_DIR) {	/* read */
-				DC395x_write8(acb, TRM_S1040_SCSI_COMMAND,
-					      SCMD_FIFO_IN);
-			} else {	/* write */
-				int ln = srb->total_xfer_length;
-				if (srb->dcb->sync_period & WIDE_SYNC)
-					DC395x_write8
-					    (acb, TRM_S1040_SCSI_CONFIG2,
-					     CFG2_WIDEFIFO);
-				dprintkdbg(DBG_PIO, "DOP1: PIO %i bytes from %p:",
-					  srb->total_xfer_length,
-					  srb->virt_addr);
-				while (srb->total_xfer_length) {
+	else if (srb->total_xfer_length > 0) {	/* The last four bytes: Do PIO */
+		/* 
+		 * load what physical address of Scatter/Gather list table
+		 * want to be transfer
+		 */
+		srb->state |= SRB_DATA_XFER;
+		/* load total transfer length (24bits) max value 16Mbyte */
+		DC395x_write32(acb, TRM_S1040_SCSI_COUNTER,
+			       srb->total_xfer_length);
+		DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
+		if (io_dir & DMACMD_DIR) {	/* read */
+			DC395x_write8(acb, TRM_S1040_SCSI_COMMAND,
+				      SCMD_FIFO_IN);
+		} else {	/* write */
+			int ln = srb->total_xfer_length;
+			if (srb->dcb->sync_period & WIDE_SYNC)
+				DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2,
+				     CFG2_WIDEFIFO);
+
+			dprintkdbg(DBG_PIO, "DOP1: PIO %i bytes from %p:",
+				  srb->total_xfer_length,
+				  srb->virt_addr);
+
+			while (srb->total_xfer_length) {
+				if (debug_enabled(DBG_PIO))
+					printk(" %02x", (unsigned char) *(srb->virt_addr));
+
+				DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 
+				     *(srb->virt_addr)++);
+
+				sg_subtract_one(srb);
+			}
+			if (srb->dcb->sync_period & WIDE_SYNC) {
+				if (ln % 2) {
+					DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 0);
 					if (debug_enabled(DBG_PIO))
-						printk(" %02x", (unsigned char) *(srb->virt_addr));
-					DC395x_write8
-					    (acb, TRM_S1040_SCSI_FIFO,
-					     *(srb->virt_addr)++);
-					srb->total_xfer_length--;
-					srb->segment_x[srb->sg_index].
-					    length--;
-					if (srb->total_xfer_length
-					    && !srb->segment_x[srb->
-							       sg_index].
-					    length) {
-						if (debug_enabled(DBG_PIO))
-							printk(" (next segment)");
-						srb->sg_index++;
-						update_sg_list(srb,
-							       srb->total_xfer_length);
-					}
-				}
-				if (srb->dcb->sync_period & WIDE_SYNC) {
-					if (ln % 2) {
-						DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 0);
-						if (debug_enabled(DBG_PIO))
-							printk(" |00");
-					}
-					DC395x_write8
-					    (acb, TRM_S1040_SCSI_CONFIG2, 0);
+						printk(" |00");
 				}
-				/*DC395x_write32(acb, TRM_S1040_SCSI_COUNTER, ln); */
-				if (debug_enabled(DBG_PIO))
-					printk("\n");
-				DC395x_write8(acb, TRM_S1040_SCSI_COMMAND,
-						  SCMD_FIFO_OUT);
+				DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2, 0);
 			}
+			/*DC395x_write32(acb, TRM_S1040_SCSI_COUNTER, ln); */
+			if (debug_enabled(DBG_PIO))
+				printk("\n");
+			DC395x_write8(acb, TRM_S1040_SCSI_COMMAND,
+					  SCMD_FIFO_OUT);
 		}
+	}
 #endif				/* DC395x_LASTPIO */
-		else {		/* xfer pad */
-			u8 data = 0, data2 = 0;
-			if (srb->sg_count) {
-				srb->adapter_status = H_OVER_UNDER_RUN;
-				srb->status |= OVER_RUN;
-			}
-			/*
-			 * KG: despite the fact that we are using 16 bits I/O ops
-			 * the SCSI FIFO is only 8 bits according to the docs
-			 * (we can set bit 1 in 0x8f to serialize FIFO access ...)
-			 */
-			if (dcb->sync_period & WIDE_SYNC) {
-				DC395x_write32(acb, TRM_S1040_SCSI_COUNTER, 2);
-				DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2,
-					      CFG2_WIDEFIFO);
-				if (io_dir & DMACMD_DIR) {	/* read */
-					data =
-					    DC395x_read8
-					    (acb, TRM_S1040_SCSI_FIFO);
-					data2 =
-					    DC395x_read8
-					    (acb, TRM_S1040_SCSI_FIFO);
-					/*dprintkl(KERN_DEBUG, "DataIO: Xfer pad: %02x %02x\n", data, data2); */
-				} else {
-					/* Danger, Robinson: If you find KGs scattered over the wide
-					 * disk, the driver or chip is to blame :-( */
-					DC395x_write8(acb, TRM_S1040_SCSI_FIFO,
-						      'K');
-					DC395x_write8(acb, TRM_S1040_SCSI_FIFO,
-						      'G');
-				}
-				DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2, 0);
+	else {		/* xfer pad */
+		u8 data = 0, data2 = 0;
+		if (srb->sg_count) {
+			srb->adapter_status = H_OVER_UNDER_RUN;
+			srb->status |= OVER_RUN;
+		}
+		/*
+		 * KG: despite the fact that we are using 16 bits I/O ops
+		 * the SCSI FIFO is only 8 bits according to the docs
+		 * (we can set bit 1 in 0x8f to serialize FIFO access ...)
+		 */
+		if (dcb->sync_period & WIDE_SYNC) {
+			DC395x_write32(acb, TRM_S1040_SCSI_COUNTER, 2);
+			DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2,
+				      CFG2_WIDEFIFO);
+			if (io_dir & DMACMD_DIR) {
+				data = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
+				data2 = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 			} else {
-				DC395x_write32(acb, TRM_S1040_SCSI_COUNTER, 1);
-				/* Danger, Robinson: If you find a collection of Ks on your disk
-				 * something broke :-( */
-				if (io_dir & DMACMD_DIR) {	/* read */
-					data =
-					    DC395x_read8
-					    (acb, TRM_S1040_SCSI_FIFO);
-					/*dprintkl(KERN_DEBUG, "DataIO: Xfer pad: %02x\n", data); */
-				} else {
-					DC395x_write8(acb, TRM_S1040_SCSI_FIFO,
-						      'K');
-				}
+				/* Danger, Robinson: If you find KGs
+				 * scattered over the wide disk, the driver
+				 * or chip is to blame :-( */
+				DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 'K');
+				DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 'G');
 			}
-			srb->state |= SRB_XFERPAD;
-			DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
-			/* SCSI command */
-			bval =
-			    (io_dir & DMACMD_DIR) ? SCMD_FIFO_IN :
-			    SCMD_FIFO_OUT;
-			DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, bval);
+			DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2, 0);
+		} else {
+			DC395x_write32(acb, TRM_S1040_SCSI_COUNTER, 1);
+			/* Danger, Robinson: If you find a collection of Ks on your disk
+			 * something broke :-( */
+			if (io_dir & DMACMD_DIR)
+				data = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
+			else
+				DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 'K');
 		}
+		srb->state |= SRB_XFERPAD;
+		DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
+		/* SCSI command */
+		bval = (io_dir & DMACMD_DIR) ? SCMD_FIFO_IN : SCMD_FIFO_OUT;
+		DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, bval);
 	}
 }
 
@@ -2800,7 +2755,7 @@
 static void status_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "StatusPhase0 (pid %li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "status_phase0 (#%li)\n", srb->cmd->pid);
 	TRACEPRINTF("STP0 *");
 	srb->target_status = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 	srb->end_message = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);	/* get message */
@@ -2817,10 +2772,8 @@
 static void status_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "StatusPhase1 (pid=%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "status_phase1 (#%li)\n", srb->cmd->pid);
 	TRACEPRINTF("STP1 *");
-	/* Cleanup is now done at the end of DataXXPhase0 */
-	/*cleanup_after_transfer (acb, srb); */
 
 	srb->state = SRB_STATUS;
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
@@ -2900,7 +2853,8 @@
 	struct ScsiReqBlk *srb = NULL;
 	struct ScsiReqBlk *i;
 
-	dprintkdbg(DBG_0, "QTag Msg (SRB %p): %i\n", srb, tag);
+	dprintkdbg(DBG_0, "msgin_qtag (#%li) tag=%i (srb=%p)\n",
+		   srb->cmd->pid, tag, srb);
 	if (!(dcb->tag_mask & (1 << tag)))
 		dprintkl(KERN_DEBUG,
 		       "MsgIn_QTag: tag_mask (%08x) does not reserve tag %i!\n",
@@ -3147,7 +3101,7 @@
 {
 	struct DeviceCtlBlk *dcb = acb->active_dcb;
 
-	dprintkdbg(DBG_0, "msgin_phase0...\n");
+	dprintkdbg(DBG_0, "msgin_phase0 (#%li)\n", srb->cmd->pid);
 	TRACEPRINTF("MIP0*");
 
 	srb->msgin_buf[acb->msg_len++] = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
@@ -3275,7 +3229,7 @@
 static void msgin_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "msgin_phase1...\n");
+	dprintkdbg(DBG_0, "msgin_phase1 (#%li)\n", srb->cmd->pid);
 	TRACEPRINTF("MIP1 *");
 	clear_fifo(acb, "MIP1");
 	DC395x_write32(acb, TRM_S1040_SCSI_COUNTER, 1);
@@ -3344,7 +3298,7 @@
 	}
 	srb = dcb->active_srb;
 	acb->active_dcb = NULL;
-	dprintkdbg(DBG_0, "Disconnect (pid=%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "disconnect (#%li)\n", srb->cmd->pid);
 	TRACEPRINTF("DISC *");
 
 	srb->scsi_phase = PH_BUS_FREE;	/* initial phase */
@@ -3383,7 +3337,7 @@
 				/* Normal selection timeout */
 				TRACEPRINTF("SlTO *");
 				dprintkdbg(DBG_KG,
-				       "Disc: SelTO (pid=%li) for dev %02i-%i\n",
+				       "Disc: SelTO (#%li) for dev %02i-%i\n",
 				       srb->cmd->pid, dcb->target_id,
 				       dcb->target_lun);
 				if (srb->retry_count++ > DC395x_MAX_RETRIES
@@ -3403,7 +3357,7 @@
 			/*
 			 * SRB_DISCONNECT (This is what we expect!)
 			 */
-			/* dprintkl(KERN_DEBUG, "DoWaitingSRB (pid=%li)\n", srb->cmd->pid); */
+			/* dprintkl(KERN_DEBUG, "DoWaitingSRB (#%li)\n", srb->cmd->pid); */
 			TRACEPRINTF("+*");
 			if (bval & 0x40) {
 				dprintkdbg(DBG_0, "Debug: DISC: SCSI bus stat %02x: ACK set! Other controllers?\n",
@@ -3425,7 +3379,7 @@
 			free_tag(dcb, srb);
 			dcb->active_srb = NULL;
 			srb->state = SRB_FREE;
-			/*dprintkl(KERN_DEBUG, "done (pid=%li)\n", srb->cmd->pid); */
+			/*dprintkl(KERN_DEBUG, "done (#%li)\n", srb->cmd->pid); */
 			srb_done(acb, dcb, srb);
 		}
 	}
@@ -3598,12 +3552,11 @@
 	if (cmd->use_sg && dir != PCI_DMA_NONE) {
 		/* unmap DC395x SG list */
 		dprintkdbg(DBG_SGPARANOIA,
-		       "Unmap SG descriptor list %08x (%05x)\n",
+		       "unmap SG list %08x(%05x)\n",
 		       srb->sg_bus_addr,
-		       sizeof(struct SGentry) * DC395x_MAX_SG_LISTENTRY);
+		       SEGMENTX_LEN);
 		pci_unmap_single(acb->dev, srb->sg_bus_addr,
-				 sizeof(struct SGentry) *
-				 DC395x_MAX_SG_LISTENTRY,
+				 SEGMENTX_LEN,
 				 PCI_DMA_TODEVICE);
 		dprintkdbg(DBG_SGPARANOIA, "Unmap %i SG segments from %p\n",
 		       cmd->use_sg, cmd->request_buffer);
@@ -3612,7 +3565,7 @@
 			     (struct scatterlist *)cmd->request_buffer,
 			     cmd->use_sg, dir);
 	} else if (cmd->request_buffer && dir != PCI_DMA_NONE) {
-		dprintkdbg(DBG_SGPARANOIA, "Unmap buffer at %08x (%05x)\n",
+		dprintkdbg(DBG_SGPARANOIA, "Unmap buffer %08x(%05x)\n",
 		       srb->segment_x[0].address, cmd->request_bufflen);
 		pci_unmap_single(acb->dev, srb->segment_x[0].address,
 				 cmd->request_bufflen, dir);
@@ -3656,17 +3609,19 @@
 	TRACEPRINTF("DONE *");
 
 	dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
-	ptr = (struct ScsiInqData *)(cmd->request_buffer);
-	if (cmd->use_sg)
-		ptr =
-		    (struct ScsiInqData *)CPU_ADDR(*(struct scatterlist *)
-						    ptr);
+	if (cmd->use_sg) {
+		struct scatterlist* sg = (struct scatterlist *)cmd->request_buffer;
+		ptr = (struct ScsiInqData *)(page_address(sg->page) + sg->offset);
+	} else {
+		ptr = (struct ScsiInqData *)(cmd->request_buffer);
+	}
+
 	dprintkdbg(DBG_SGPARANOIA, 
-	       "SRBdone SG=%i (%i/%i), req_buf = %p, adr = %p\n",
+	       "srb_done sg=%i(%i/%i), buf=%p, addr=%p\n",
 	       cmd->use_sg, srb->sg_index, srb->sg_count,
 	       cmd->request_buffer, ptr);
 	dprintkdbg(DBG_KG,
-	       "SRBdone (pid %li, target %02i-%i): ", srb->cmd->pid,
+	       "srb_done (#%li) (target %02i-%i): ", srb->cmd->pid,
 	       srb->cmd->device->id, srb->cmd->device->lun);
 	status = srb->target_status;
 	if (srb->flag & AUTO_REQSENSE) {
@@ -3850,7 +3805,7 @@
 	else
 		srb_free_insert(acb, srb);
 
-	dprintkdbg(DBG_0, "SRBdone: done pid %li\n", cmd->pid);
+	dprintkdbg(DBG_0, "srb_done: done (#%li)\n", cmd->pid);
 	if (debug_enabled(DBG_KG)) {
 		printk(" 0x%08x\n", cmd->result);
 	}
@@ -4065,9 +4020,9 @@
 	srb->segment_x[0].address =
 	    pci_map_single(acb->dev, cmd->sense_buffer,
 			   sizeof(cmd->sense_buffer), PCI_DMA_FROMDEVICE);
-	dprintkdbg(DBG_SGPARANOIA, "Map sense buffer at %p (%05x) to %08x\n",
-	       cmd->sense_buffer, sizeof(cmd->sense_buffer),
-	       srb->segment_x[0].address);
+	dprintkdbg(DBG_SGPARANOIA, "Map sense buffer %p->%08x(%05x)\n",
+	       cmd->sense_buffer, srb->segment_x[0].address,
+	       sizeof(cmd->sense_buffer));
 	srb->sg_count = 1;
 	srb->sg_index = 0;
 
@@ -4673,8 +4628,7 @@
 static void adapter_sg_tables_free(struct AdapterCtlBlk *acb)
 {
 	int i;
-	const unsigned srbs_per_page = PAGE_SIZE/(DC395x_MAX_SG_LISTENTRY
-						  *sizeof(struct SGentry));
+	const unsigned srbs_per_page = PAGE_SIZE/SEGMENTX_LEN;
 
 	for (i = 0; i < DC395x_MAX_SRB_CNT; i += srbs_per_page)
 		if (acb->srb_array[i].segment_x)
@@ -4688,11 +4642,9 @@
 static int __init adapter_sg_tables_alloc(struct AdapterCtlBlk *acb)
 {
 	const unsigned mem_needed = (DC395x_MAX_SRB_CNT+1)
-	                            *DC395x_MAX_SG_LISTENTRY
-	                            *sizeof(struct SGentry);
+	                            *SEGMENTX_LEN;
 	int pages = (mem_needed+(PAGE_SIZE-1))/PAGE_SIZE;
-	const unsigned srbs_per_page = PAGE_SIZE/(DC395x_MAX_SG_LISTENTRY
-	                                          *sizeof(struct SGentry));
+	const unsigned srbs_per_page = PAGE_SIZE/SEGMENTX_LEN;
 	int srb_idx = 0;
 	unsigned i = 0;
 	struct SGentry *ptr;

-- 
 Jamie Lenehan <lenehan@twibble.org>
