From: Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH] dc395x [4/5] - debugging cleanup
Date: Tue, 9 Mar 2004 15:25:25 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309042525.GD12274@twibble.org>
References: <20040309042300.GA12274@twibble.org> <20040309042400.GB12274@twibble.org> <20040309042442.GC12274@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:60356 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S261524AbUCIE0n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2004 23:26:43 -0500
Content-Disposition: inline
In-Reply-To: <20040309042442.GC12274@twibble.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

Clean up debugging statements. Work on making output consistent - use
the same format each time the same bit of information is output and
output the same bits of information in the same order each time it's
output. Update a lot of the actual messages to include useful
information and to explain better what some things are. Remove some
old comments and commented out code. Remove some of the debugging
states. Find few instance of spaces that should have been tabs and
trailing white space and remove them.

diff -du -r a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2004-03-08 12:44:56.455891840 +1100
+++ b/drivers/scsi/dc395x.c	2004-03-08 12:45:02.191007430 +1100
@@ -82,9 +82,7 @@
 #define DBG_KG		0x0001
 #define DBG_0		0x0002
 #define DBG_1		0x0004
-#define DBG_DCB		0x0008
-#define DBG_PARSE	0x0010		/* debug command line parsing */
-#define DBG_SGPARANOIA	0x0020
+#define DBG_SG		0x0020
 #define DBG_FIFO	0x0040
 #define DBG_PIO		0x0080
 
@@ -93,7 +91,7 @@
  * Set set of things to output debugging for.
  * Undefine to remove all debugging
  */
-/*#define DEBUG_MASK (DBG_0|DBG_1|DBG_DCB|DBG_PARSE|DBG_SGPARANOIA|DBG_FIFO|DBG_PIO)*/
+/*#define DEBUG_MASK (DBG_0|DBG_1|DBG_SG|DBG_FIFO|DBG_PIO)*/
 /*#define  DEBUG_MASK	DBG_0*/
 
 
@@ -370,7 +368,7 @@
 static void reselect(struct AdapterCtlBlk *acb);
 static u8 start_scsi(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb);
-static void build_srb(Scsi_Cmnd * cmd, struct DeviceCtlBlk *dcb,
+static void build_srb(Scsi_Cmnd *cmd, struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb);
 static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_code,
 		Scsi_Cmnd *cmd, u8 force);
@@ -393,7 +391,6 @@
                                  Static Data
  ---------------------------------------------------------------------------*/
 static u16 current_sync_offset = 0;
-static char monitor_next_irq = 0;
 
 static void *dc395x_scsi_phase0[] = {
 	data_out_phase0,/* phase:0 */
@@ -591,13 +588,15 @@
 {
 	int i;
 
-	dprintkdbg(DBG_PARSE, "setup %08x %08x %08x %08x %08x %08x\n",
-		    cfg_data[CFG_ADAPTER_ID].value,
-		    cfg_data[CFG_MAX_SPEED].value,
-		    cfg_data[CFG_DEV_MODE].value,
-		    cfg_data[CFG_ADAPTER_MODE].value,
-		    cfg_data[CFG_TAGS].value,
-		    cfg_data[CFG_RESET_DELAY].value);
+	dprintkdbg(DBG_1,
+		"setup: AdapterId=%08x MaxSpeed=%08x DevMode=%08x "
+		"AdapterMode=%08x Tags=%08x ResetDelay=%08x\n",
+		cfg_data[CFG_ADAPTER_ID].value,
+		cfg_data[CFG_MAX_SPEED].value,
+		cfg_data[CFG_DEV_MODE].value,
+		cfg_data[CFG_ADAPTER_MODE].value,
+		cfg_data[CFG_TAGS].value,
+		cfg_data[CFG_RESET_DELAY].value);
 	for (i = 0; i < CFG_NUM; i++)
 	{
 		if (cfg_data[i].value < cfg_data[i].min
@@ -693,14 +692,14 @@
 	list_for_each(pos, head)
 		count++;
 	return count;
-}                                                                                        
+}
 
 
 static struct DeviceCtlBlk *dcb_get_next(struct list_head *head,
 		struct DeviceCtlBlk *pos)
 {
 	int use_next = 0;
-	struct DeviceCtlBlk* next = NULL;	
+	struct DeviceCtlBlk* next = NULL;
 	struct DeviceCtlBlk* i;
 
 	if (list_empty(head))
@@ -749,15 +748,12 @@
 static struct ScsiReqBlk *srb_get_free(struct AdapterCtlBlk *acb)
 {
 	struct list_head *head = &acb->srb_free_list;
-	struct ScsiReqBlk *srb;
+	struct ScsiReqBlk *srb = NULL;
 
 	if (!list_empty(head)) {
 		srb = list_entry(head->next, struct ScsiReqBlk, list);
 		list_del(head->next);
-		dprintkdbg(DBG_0, "srb_get_free: got srb %p\n", srb);
-	} else {
-		srb = NULL;
-		dprintkl(KERN_ERR, "Out of Free SRBs :-(\n");
+		dprintkdbg(DBG_0, "srb_get_free: srb=%p\n", srb);
 	}
 	return srb;
 }
@@ -765,32 +761,34 @@
 
 static void srb_free_insert(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
 {
-	dprintkdbg(DBG_0, "srb_free_insert: put srb %p\n", srb);
-        list_add_tail(&srb->list, &acb->srb_free_list);
+	dprintkdbg(DBG_0, "srb_free_insert: srb=%p\n", srb);
+	list_add_tail(&srb->list, &acb->srb_free_list);
 }
 
 
 static void srb_waiting_insert(struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb)
 {
-	dprintkdbg(DBG_0, "srb_waiting_insert: srb %p cmd %li\n", srb, srb->cmd->pid);
-        list_add(&srb->list, &dcb->srb_waiting_list);
+	dprintkdbg(DBG_0, "srb_waiting_insert: (pid#%li) <%02i-%i> srb=%p\n",
+		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
+	list_add(&srb->list, &dcb->srb_waiting_list);
 }
 
 
 static void srb_waiting_append(struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb)
 {
-	dprintkdbg(DBG_0, "srb_waiting_append: srb %p cmd %li\n",
-		   srb, srb->cmd->pid);
-        list_add_tail(&srb->list, &dcb->srb_waiting_list);
+	dprintkdbg(DBG_0, "srb_waiting_append: (pid#%li) <%02i-%i> srb=%p\n",
+		 srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
+	list_add_tail(&srb->list, &dcb->srb_waiting_list);
 }
 
 
 static void srb_going_append(struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
 {
-	dprintkdbg(DBG_0, "srb_going_append: srb %p\n", srb);
-        list_add_tail(&srb->list, &dcb->srb_going_list);
+	dprintkdbg(DBG_0, "srb_going_append: (pid#%li) <%02i-%i> srb=%p\n",
+		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
+	list_add_tail(&srb->list, &dcb->srb_going_list);
 }
 
 
@@ -798,7 +796,8 @@
 {
 	struct ScsiReqBlk *i;
 	struct ScsiReqBlk *tmp;
-	dprintkdbg(DBG_0, "srb_going_remove: srb %p\n", srb);
+	dprintkdbg(DBG_0, "srb_going_remove: (pid#%li) <%02i-%i> srb=%p\n",
+		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
 
 	list_for_each_entry_safe(i, tmp, &dcb->srb_going_list, list)
 		if (i == srb) {
@@ -813,7 +812,8 @@
 {
 	struct ScsiReqBlk *i;
 	struct ScsiReqBlk *tmp;
-	dprintkdbg(DBG_0, "srb_waiting_remove: srb %p\n", srb);
+	dprintkdbg(DBG_0, "srb_waiting_remove: (pid#%li) <%02i-%i> srb=%p\n",
+		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
 
 	list_for_each_entry_safe(i, tmp, &dcb->srb_waiting_list, list)
 		if (i == srb) {
@@ -826,8 +826,9 @@
 static void srb_going_to_waiting_move(struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb)
 {
-	dprintkdbg(DBG_0, "srb_going_to_waiting_move: srb %p, pid = %li\n",
-		   srb, srb->cmd->pid);
+	dprintkdbg(DBG_0,
+		"srb_going_to_waiting_move: (pid#%li) <%02i-%i> srb=%p\n",
+		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
 	list_move(&srb->list, &dcb->srb_waiting_list);
 }
 
@@ -835,7 +836,9 @@
 static void srb_waiting_to_going_move(struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb)
 {
-	dprintkdbg(DBG_0, "srb_waiting_to_going_move: srb %p\n", srb);
+	dprintkdbg(DBG_0,
+		"srb_waiting_to_going_move: (pid#%li) <%02i-%i> srb=%p\n",
+		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
 	list_move(&srb->list, &dcb->srb_going_list);
 }
 
@@ -928,7 +931,8 @@
 {
 	unsigned long flags;
 	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)ptr;
-	dprintkdbg(DBG_KG, "Debug: Waiting queue woken up by timer.\n");
+	dprintkdbg(DBG_1,
+		"waiting_timeout: Queue woken up by timer. acb=%p\n", acb);
 	DC395x_LOCK_IO(acb->scsi_host, flags);
 	waiting_process_next(acb);
 	DC395x_UNLOCK_IO(acb->scsi_host, flags);
@@ -969,7 +973,8 @@
 		struct ScsiReqBlk *srb)
 {
 	int dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
-	dprintkdbg(DBG_0, "build_srb...\n");
+	dprintkdbg(DBG_0, "build_srb: (pid#%li) <%02i-%i>\n",
+		cmd->pid, dcb->target_id, dcb->target_lun);
 
 	srb->dcb = dcb;
 	srb->cmd = cmd;
@@ -990,9 +995,10 @@
 	srb->end_message = 0;
 
 	if (dir == PCI_DMA_NONE || !cmd->request_buffer) {
-		dprintkdbg(DBG_0, "srb[A] len=%d buf=%p use_sg=%d !MAP=%08x\n",
-			    cmd->bufflen, cmd->request_buffer,
-			    cmd->use_sg, srb->segment_x[0].address);
+		dprintkdbg(DBG_0,
+			"build_srb: [0] len=%d buf=%p use_sg=%d !MAP=%08x\n",
+			cmd->bufflen, cmd->request_buffer,
+			cmd->use_sg, srb->segment_x[0].address);
 	} else if (cmd->use_sg) {
 		int i;
 		u32 reqlen = cmd->request_bufflen;
@@ -1001,9 +1007,10 @@
 		struct SGentry *sgp = srb->segment_x;
 		srb->sg_count = pci_map_sg(dcb->acb->dev, sl, cmd->use_sg,
 					   dir);
-		dprintkdbg(DBG_0, "srb[B] len=%d buf=%p use_sg=%d segs=%d\n",
-			   reqlen, cmd->request_buffer, cmd->use_sg,
-			   srb->sg_count);
+		dprintkdbg(DBG_0,
+			"build_srb: [n] len=%d buf=%p use_sg=%d segs=%d\n",
+			reqlen, cmd->request_buffer, cmd->use_sg,
+			srb->sg_count);
 
 		srb->virt_addr = page_address(sl->page);
 		for (i = 0; i < srb->sg_count; i++) {
@@ -1036,8 +1043,8 @@
 				            	SEGMENTX_LEN,
 				            	PCI_DMA_TODEVICE);
 
-		dprintkdbg(DBG_SGPARANOIA, "srb[B] map sg %p->%08x(%05x)\n",
-			   srb->segment_x, srb->sg_bus_addr, SEGMENTX_LEN);
+		dprintkdbg(DBG_SG, "build_srb: [n] map sg %p->%08x(%05x)\n",
+			srb->segment_x, srb->sg_bus_addr, SEGMENTX_LEN);
 	} else {
 		srb->total_xfer_length = cmd->request_bufflen;
 		srb->sg_count = 1;
@@ -1051,14 +1058,14 @@
 
 		srb->segment_x[0].length = srb->total_xfer_length;
 		srb->virt_addr = cmd->request_buffer;
-		dprintkdbg(DBG_0, "srb[C] len=%d buf=%p use_sg=%d map=%08x\n",
-				srb->total_xfer_length, cmd->request_buffer,
-			        cmd->use_sg, srb->segment_x[0].address);
+		dprintkdbg(DBG_0,
+			"build_srb: [1] len=%d buf=%p use_sg=%d map=%08x\n",
+			srb->total_xfer_length, cmd->request_buffer,
+			cmd->use_sg, srb->segment_x[0].address);
 	}
 }
 
 
-
 /**
  * dc395x_queue_command - queue scsi command passed from the mid
  * layer, invoke 'done' on completion
@@ -1084,12 +1091,8 @@
 	struct ScsiReqBlk *srb;
 	struct AdapterCtlBlk *acb =
 	    (struct AdapterCtlBlk *)cmd->device->host->hostdata;
-
-	dprintkdbg(DBG_0, "Queue Cmd=%02x,Tgt=%d,LUN=%d (pid=%li)\n",
-		   cmd->cmnd[0],
-		   cmd->device->id,
-		   cmd->device->lun,
-		   cmd->pid);
+	dprintkdbg(DBG_0, "queue_command: (pid#%li) <%02i-%i> cmnd=0x%02x\n",
+		cmd->pid, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 
 	/* Assume BAD_TARGET; will be cleared later */
 	cmd->result = DID_BAD_TARGET << 16;
@@ -1103,8 +1106,8 @@
 
 	/* does the specified lun on the specified device exist */
 	if (!(acb->dcb_map[cmd->device->id] & (1 << cmd->device->lun))) {
-		dprintkl(KERN_INFO, "Ignore target %02x lun %02x\n", cmd->device->id,
-		       cmd->device->lun);
+		dprintkl(KERN_INFO, "queue_command: Ignore target <%02i-%i>\n",
+			cmd->device->id, cmd->device->lun);
 		goto complete;
 	}
 
@@ -1112,9 +1115,8 @@
 	dcb = find_dcb(acb, cmd->device->id, cmd->device->lun);
 	if (!dcb) {
 		/* should never happen */
-		dprintkl(KERN_ERR, "no DCB failed, target %02x lun %02x\n",
-				   cmd->device->id, cmd->device->lun);
-		dprintkl(KERN_ERR, "No DCB in queuecommand (2)!\n");
+		dprintkl(KERN_ERR, "queue_command: No such device <%02i-%i>",
+			cmd->device->id, cmd->device->lun);
 		goto complete;
 	}
 
@@ -1129,7 +1131,7 @@
 		 * Return 1 since we are unable to queue this command at this
 		 * point in time.
 		 */
-		dprintkdbg(DBG_0, "No free SRB's in queuecommand\n");
+		dprintkdbg(DBG_0, "queue_command: No free srb's\n");
 		return 1;
 	}
 
@@ -1143,7 +1145,7 @@
 		/* process immediately */
 		send_srb(acb, srb);
 	}
-	dprintkdbg(DBG_1, "... command (pid %li) queued successfully.\n", cmd->pid);
+	dprintkdbg(DBG_1, "queue_command: (pid#%li) done\n", cmd->pid);
 	return 0;
 
 complete:
@@ -1202,60 +1204,57 @@
 		srb = dcb->active_srb;
 	if (srb) {
 		if (!srb->cmd)
-			dprintkl(KERN_INFO, "dump: SRB %p: cmd %p OOOPS!\n", srb,
-			       srb->cmd);
+			dprintkl(KERN_INFO, "dump: srb=%p cmd=%p OOOPS!\n",
+				srb, srb->cmd);
 		else
-			dprintkl(KERN_INFO, "dump: SRB %p: cmd %p pid %li: %02x (%02i-%i)\n",
-			       srb, srb->cmd, srb->cmd->pid,
-			       srb->cmd->cmnd[0], srb->cmd->device->id,
-			       srb->cmd->device->lun);
-		printk("              SGList %p Cnt %i Idx %i Len %i\n",
+			dprintkl(KERN_INFO, "dump: srb=%p cmd=%p (pid#%li) "
+				 "cmnd=0x%02x <%02i-%i>\n",
+			    	srb, srb->cmd, srb->cmd->pid,
+				srb->cmd->cmnd[0], srb->cmd->device->id,
+			       	srb->cmd->device->lun);
+		printk("  sglist=%p cnt=%i idx=%i len=%i\n",
 		       srb->segment_x, srb->sg_count, srb->sg_index,
 		       srb->total_xfer_length);
-		printk
-		    ("              State %04x Status %02x Phase %02x (%sconn.)\n",
-		     srb->state, srb->status, srb->scsi_phase,
-		     (acb->active_dcb) ? "" : "not");
+		printk("  state=0x%04x status=0x%02x phase=0x%02x (%sconn.)\n",
+		       srb->state, srb->status, srb->scsi_phase,
+		       (acb->active_dcb) ? "" : "not");
 	}
-	dprintkl(KERN_INFO, "dump: SCSI block\n");
-	printk
-	    ("              Status %04x FIFOCnt %02x Signals %02x IRQStat %02x\n",
-	     DC395x_read16(acb, TRM_S1040_SCSI_STATUS),
-	     DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT),
-	     DC395x_read8(acb, TRM_S1040_SCSI_SIGNAL),
-	     DC395x_read8(acb, TRM_S1040_SCSI_INTSTATUS));
-	printk
-	    ("              Sync %02x Target %02x RSelID %02x SCSICtr %08x\n",
-	     DC395x_read8(acb, TRM_S1040_SCSI_SYNC),
-	     DC395x_read8(acb, TRM_S1040_SCSI_TARGETID),
-	     DC395x_read8(acb, TRM_S1040_SCSI_IDMSG),
-	     DC395x_read32(acb, TRM_S1040_SCSI_COUNTER));
-	printk
-	    ("              IRQEn %02x Config %04x Cfg2 %02x Cmd %02x SelTO %02x\n",
-	     DC395x_read8(acb, TRM_S1040_SCSI_INTEN),
-	     DC395x_read16(acb, TRM_S1040_SCSI_CONFIG0),
-	     DC395x_read8(acb, TRM_S1040_SCSI_CONFIG2),
-	     DC395x_read8(acb, TRM_S1040_SCSI_COMMAND),
-	     DC395x_read8(acb, TRM_S1040_SCSI_TIMEOUT));
-	dprintkl(KERN_INFO, "dump: DMA block\n");
-	printk
-	    ("              Cmd %04x FIFOCnt %02x FStat %02x IRQStat %02x IRQEn %02x Cfg %04x\n",
-	     DC395x_read16(acb, TRM_S1040_DMA_COMMAND),
-	     DC395x_read8(acb, TRM_S1040_DMA_FIFOCNT),
-	     DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT),
-	     DC395x_read8(acb, TRM_S1040_DMA_STATUS),
-	     DC395x_read8(acb, TRM_S1040_DMA_INTEN),
-	     DC395x_read16(acb, TRM_S1040_DMA_CONFIG));
-	printk("              TCtr %08x CTCtr %08x Addr %08x%08x\n",
-	       DC395x_read32(acb, TRM_S1040_DMA_XCNT),
-	       DC395x_read32(acb, TRM_S1040_DMA_CXCNT),
-	       DC395x_read32(acb, TRM_S1040_DMA_XHIGHADDR),
-	       DC395x_read32(acb, TRM_S1040_DMA_XLOWADDR));
-	dprintkl(KERN_INFO, "dump: Misc: GCtrl %02x GStat %02x GTmr %02x\n",
-	       DC395x_read8(acb, TRM_S1040_GEN_CONTROL),
-	       DC395x_read8(acb, TRM_S1040_GEN_STATUS),
-	       DC395x_read8(acb, TRM_S1040_GEN_TIMER));
-	dprintkl(KERN_INFO, "dump: PCI Status %04x\n", pstat);
+	dprintkl(KERN_INFO, "dump: SCSI{status=0x%04x fifocnt=0x%02x "
+		"signals=0x%02x irqstat=0x%02x sync=0x%02x target=0x%02x "
+		"rselid=0x%02x ctr=0x%08x irqen=0x%02x config=0x%04x "
+		"config2=0x%02x cmd=0x%02x selto=0x%02x}\n",
+		DC395x_read16(acb, TRM_S1040_SCSI_STATUS),
+		DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT),
+		DC395x_read8(acb, TRM_S1040_SCSI_SIGNAL),
+		DC395x_read8(acb, TRM_S1040_SCSI_INTSTATUS),
+		DC395x_read8(acb, TRM_S1040_SCSI_SYNC),
+		DC395x_read8(acb, TRM_S1040_SCSI_TARGETID),
+		DC395x_read8(acb, TRM_S1040_SCSI_IDMSG),
+		DC395x_read32(acb, TRM_S1040_SCSI_COUNTER),
+		DC395x_read8(acb, TRM_S1040_SCSI_INTEN),
+		DC395x_read16(acb, TRM_S1040_SCSI_CONFIG0),
+		DC395x_read8(acb, TRM_S1040_SCSI_CONFIG2),
+		DC395x_read8(acb, TRM_S1040_SCSI_COMMAND),
+		DC395x_read8(acb, TRM_S1040_SCSI_TIMEOUT));
+	dprintkl(KERN_INFO, "dump: DMA{cmd=0x%04x fifocnt=0x%02x fstat=0x%02x "
+		"irqstat=0x%02x irqen=0x%02x cfg=0x%04x tctr=0x%08x "
+		"ctctr=0x%08x addr=0x%08x:0x%08x}\n",
+		DC395x_read16(acb, TRM_S1040_DMA_COMMAND),
+		DC395x_read8(acb, TRM_S1040_DMA_FIFOCNT),
+		DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT),
+		DC395x_read8(acb, TRM_S1040_DMA_STATUS),
+		DC395x_read8(acb, TRM_S1040_DMA_INTEN),
+		DC395x_read16(acb, TRM_S1040_DMA_CONFIG),
+		DC395x_read32(acb, TRM_S1040_DMA_XCNT),
+		DC395x_read32(acb, TRM_S1040_DMA_CXCNT),
+		DC395x_read32(acb, TRM_S1040_DMA_XHIGHADDR),
+		DC395x_read32(acb, TRM_S1040_DMA_XLOWADDR));
+	dprintkl(KERN_INFO, "dump: gen{gctrl=0x%02x gstat=0x%02x gtmr=0x%02x} "
+		"pci{status=0x%04x}\n",
+		DC395x_read8(acb, TRM_S1040_GEN_CONTROL),
+		DC395x_read8(acb, TRM_S1040_GEN_STATUS),
+		DC395x_read8(acb, TRM_S1040_GEN_TIMER),
+		pstat);
 }
 
 
@@ -1266,7 +1265,7 @@
 	u8 fifocnt = DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT);
 	if (!(fifocnt & 0x40))
 		dprintkdbg(DBG_FIFO,
-		       "Clr FIFO (%i bytes) on phase %02x in %s\n",
+			"clear_fifo: (%i bytes) on phase %02x in %s\n",
 			fifocnt & 0x3f, lines, txt);
 #endif
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_CLRFIFO);
@@ -1277,8 +1276,8 @@
 {
 	struct DeviceCtlBlk *dcb;
 	struct NvRamType *eeprom = &acb->eeprom;
+	dprintkdbg(DBG_0, "reset_dev_param: acb=%p\n", acb);
 
-	dprintkdbg(DBG_0, "reset_dev_param..............\n");
 	list_for_each_entry(dcb, &acb->dcb_list, list) {
 		u8 period_index;
 
@@ -1301,12 +1300,13 @@
  * @cmd - some command for this host (for fetching hooks)
  * Returns: SUCCESS (0x2002) on success, else FAILED (0x2003).
  */
-static int dc395x_eh_bus_reset(Scsi_Cmnd * cmd)
+static int dc395x_eh_bus_reset(Scsi_Cmnd *cmd)
 {
-	struct AdapterCtlBlk *acb;
-
-	dprintkl(KERN_INFO, "reset requested!\n");
-	acb = (struct AdapterCtlBlk *)cmd->device->host->hostdata;
+	struct AdapterCtlBlk *acb =
+		(struct AdapterCtlBlk *)cmd->device->host->hostdata;
+	dprintkl(KERN_INFO,
+		"eh_bus_reset: (pid#%li) target=<%02i-%i> cmd=%p\n",
+		cmd->pid, cmd->device->id, cmd->device->lun, cmd);
 
 	if (timer_pending(&acb->waiting_timer))
 		del_timer(&acb->waiting_timer);
@@ -1332,7 +1332,7 @@
 	 */
 	/* Clear SCSI FIFO          */
 	DC395x_write8(acb, TRM_S1040_DMA_CONTROL, CLRXFIFO);
-	clear_fifo(acb, "reset");
+	clear_fifo(acb, "eh_bus_reset");
 	/* Delete pending IRQ */
 	DC395x_read8(acb, TRM_S1040_SCSI_INTSTATUS);
 	set_basic_config(acb);
@@ -1362,16 +1362,12 @@
 	    (struct AdapterCtlBlk *)cmd->device->host->hostdata;
 	struct DeviceCtlBlk *dcb;
 	struct ScsiReqBlk *srb;
-
-	dprintkl(KERN_INFO, "eh abort: cmd %p (pid %li, %02i-%i) ",
-			     cmd,
-			     cmd->pid,
-			     cmd->device->id,
-			     cmd->device->lun);
+	dprintkl(KERN_INFO, "eh_abort: (pid#%li) target=<%02i-%i> cmd=%p\n",
+		cmd->pid, cmd->device->id, cmd->device->lun, cmd);
 
 	dcb = find_dcb(acb, cmd->device->id, cmd->device->lun);
 	if (!dcb) {
-		dprintkl(KERN_DEBUG, "abort - no DCB found");
+		dprintkl(KERN_DEBUG, "eh_abort: No such device\n");
 		return FAILED;
 	}
 
@@ -1382,16 +1378,16 @@
 		pci_unmap_srb(acb, srb);
 		free_tag(dcb, srb);
 		srb_free_insert(acb, srb);
-		dprintkl(KERN_DEBUG, "abort - command found in waiting commands queue");
+		dprintkl(KERN_DEBUG, "eh_abort: Command was waiting\n");
 		cmd->result = DID_ABORT << 16;
 		return SUCCESS;
 	}
 	srb = find_cmd(cmd, &dcb->srb_going_list);
 	if (srb) {
-		dprintkl(KERN_DEBUG, "abort - command currently in progress");
+		dprintkl(KERN_DEBUG, "eh_abort: Command in progress");
 		/* XXX: Should abort the command here */
 	} else {
-		dprintkl(KERN_DEBUG, "abort - command not found");
+		dprintkl(KERN_DEBUG, "eh_abort: Command not found");
 	}
 	return FAILED;
 }
@@ -1404,9 +1400,9 @@
 	u8 *ptr = srb->msgout_buf + srb->msg_count;
 	if (srb->msg_count > 1) {
 		dprintkl(KERN_INFO,
-		       "Build_SDTR: msgout_buf BUSY (%i: %02x %02x)\n",
-		       srb->msg_count, srb->msgout_buf[0],
-		       srb->msgout_buf[1]);
+			"build_sdtr: msgout_buf BUSY (%i: %02x %02x)\n",
+			srb->msg_count, srb->msgout_buf[0],
+			srb->msgout_buf[1]);
 		return;
 	}
 	if (!(dcb->dev_mode & NTC_DO_SYNC_NEGO)) {
@@ -1434,9 +1430,9 @@
 	u8 *ptr = srb->msgout_buf + srb->msg_count;
 	if (srb->msg_count > 1) {
 		dprintkl(KERN_INFO,
-		       "Build_WDTR: msgout_buf BUSY (%i: %02x %02x)\n",
-		       srb->msg_count, srb->msgout_buf[0],
-		       srb->msgout_buf[1]);
+			"build_wdtr: msgout_buf BUSY (%i: %02x %02x)\n",
+			srb->msg_count, srb->msgout_buf[0],
+			srb->msgout_buf[1]);
 		return;
 	}
 	*ptr++ = MSG_EXTENDED;	/* (01h) */
@@ -1487,14 +1483,15 @@
 #endif
 
 
-static u8 start_scsi(struct AdapterCtlBlk * acb, struct DeviceCtlBlk * dcb,
-		struct ScsiReqBlk * srb)
+static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
+		struct ScsiReqBlk* srb)
 {
 	u16 s_stat2, return_code;
 	u8 s_stat, scsicommand, i, identify_message;
 	u8 *ptr;
+	dprintkdbg(DBG_0, "start_scsi: (pid#%li) <%02i-%i> srb=%p\n",
+		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
 
-	dprintkdbg(DBG_0, "start_scsi (#%li)\n", srb->cmd->pid);
 	srb->tag_number = TAG_NONE;	/* acb->tag_max_num: had error read in eeprom */
 
 	s_stat = DC395x_read8(acb, TRM_S1040_SCSI_SIGNAL);
@@ -1502,10 +1499,8 @@
 	s_stat2 = DC395x_read16(acb, TRM_S1040_SCSI_STATUS);
 #if 1
 	if (s_stat & 0x20 /* s_stat2 & 0x02000 */ ) {
-		dprintkdbg(DBG_KG,
-		       "StartSCSI: pid %li(%02i-%i): BUSY %02x %04x\n",
-		       srb->cmd->pid, dcb->target_id, dcb->target_lun,
-		       s_stat, s_stat2);
+		dprintkdbg(DBG_KG, "start_scsi: (pid#%li) BUSY %02x %04x\n",
+			srb->cmd->pid, s_stat, s_stat2);
 		/*
 		 * Try anyway?
 		 *
@@ -1517,34 +1512,31 @@
 		 * tried again after a short time
 		 */
 		/*selto_timer (acb); */
-		/*monitor_next_irq = 1; */
 		return 1;
 	}
 #endif
 	if (acb->active_dcb) {
-		dprintkl(KERN_DEBUG, "We try to start a SCSI command (%li)!\n",
-		       srb->cmd->pid);
-		dprintkl(KERN_DEBUG, "While another one (%li) is active!!\n",
-		       (acb->active_dcb->active_srb ? acb->active_dcb->
-			active_srb->cmd->pid : 0));
+		dprintkl(KERN_DEBUG, "start_scsi: (pid#%li) Attempt to start a"
+			"command while another command (pid#%li) is active.",
+			srb->cmd->pid,
+			acb->active_dcb->active_srb ?
+			    acb->active_dcb->active_srb->cmd->pid : 0);
 		return 1;
 	}
 	if (DC395x_read16(acb, TRM_S1040_SCSI_STATUS) & SCSIINTERRUPT) {
-		dprintkdbg(DBG_KG,
-		       "StartSCSI failed (busy) for pid %li(%02i-%i)\n",
-		       srb->cmd->pid, dcb->target_id, dcb->target_lun);
+		dprintkdbg(DBG_KG, "start_scsi: (pid#%li) Failed (busy)\n",
+			srb->cmd->pid);
 		return 1;
 	}
 	/* Allow starting of SCSI commands half a second before we allow the mid-level
 	 * to queue them again after a reset */
 	if (time_before(jiffies, acb->scsi_host->last_reset - HZ / 2)) {
-		dprintkdbg(DBG_KG, 
-		       "We were just reset and don't accept commands yet!\n");
+		dprintkdbg(DBG_KG, "start_scsi: Refuse cmds (reset wait)\n");
 		return 1;
 	}
 
 	/* Flush FIFO */
-	clear_fifo(acb, "Start");
+	clear_fifo(acb, "start_scsi");
 	DC395x_write8(acb, TRM_S1040_SCSI_HOSTID, acb->scsi_host->this_id);
 	DC395x_write8(acb, TRM_S1040_SCSI_TARGETID, dcb->target_id);
 	DC395x_write8(acb, TRM_S1040_SCSI_SYNC, dcb->sync_period);
@@ -1605,10 +1597,10 @@
 			tag_number++;
 		}
 		if (tag_number >= dcb->max_command) {
-			dprintkl(KERN_WARNING,
-			       "Start_SCSI: Out of tags for pid %li (%i-%i)\n",
-			       srb->cmd->pid, srb->cmd->device->id,
-			       srb->cmd->device->lun);
+			dprintkl(KERN_WARNING, "start_scsi: (pid#%li) "
+				"Out of tags target=<%02i-%i>)\n",
+				srb->cmd->pid, srb->cmd->device->id,
+				srb->cmd->device->lun);
 			srb->state = SRB_READY;
 			DC395x_write16(acb, TRM_S1040_SCSI_CONTROL,
 				       DO_HWRESELECT);
@@ -1625,11 +1617,9 @@
 #endif
 /*polling:*/
 	/* Send CDB ..command block ......... */
-	dprintkdbg(DBG_KG, 
-	       "StartSCSI (pid %li) %02x (%i-%i): Tag %i\n",
-	       srb->cmd->pid, srb->cmd->cmnd[0],
-	       srb->cmd->device->id, srb->cmd->device->lun,
-	       srb->tag_number);
+	dprintkdbg(DBG_KG, "start_scsi: (pid#%li) <%02i-%i> cmnd=0x%02x tag=%i\n",
+		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun,
+		srb->cmd->cmnd[0], srb->tag_number);
 	if (srb->flag & AUTO_REQSENSE) {
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, REQUEST_SENSE);
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, (dcb->target_lun << 5));
@@ -1652,10 +1642,8 @@
 		 * we caught an interrupt (must be reset or reselection ... )
 		 * : Let's process it first!
 		 */
-		dprintkdbg(DBG_0, "Debug: StartSCSI failed (busy) for pid %li(%02i-%i)!\n",
+		dprintkdbg(DBG_0, "start_scsi: (pid#%li) <%02i-%i> Failed - busy\n",
 			srb->cmd->pid, dcb->target_id, dcb->target_lun);
-		/*clear_fifo(acb, "Start2"); */
-		/*DC395x_write16(TRM_S1040_SCSI_CONTROL, DO_HWRESELECT | DO_DATALATCH); */
 		srb->state = SRB_READY;
 		free_tag(dcb, srb);
 		srb->msg_count = 0;
@@ -1703,21 +1691,13 @@
 	/* This acknowledges the IRQ */
 	scsi_intstatus = DC395x_read8(acb, TRM_S1040_SCSI_INTSTATUS);
 	if ((scsi_status & 0x2007) == 0x2002)
-		dprintkl(KERN_DEBUG, "COP after COP completed? %04x\n",
-		       scsi_status);
-#if 1				/*def DBG_0 */
-	if (monitor_next_irq) {
-		dprintkl(KERN_INFO,
-		       "status=%04x intstatus=%02x\n", scsi_status,
-		       scsi_intstatus);
-		monitor_next_irq--;
-	}
-#endif
+		dprintkl(KERN_DEBUG,
+			"COP after COP completed? %04x\n", scsi_status);
 	if (debug_enabled(DBG_KG)) {
 		if (scsi_intstatus & INT_SELTIMEOUT)
-		dprintkdbg(DBG_KG, "Sel Timeout IRQ\n");
+			dprintkdbg(DBG_KG, "handle_interrupt: Selection timeout\n");
 	}
-	/*dprintkl(KERN_DEBUG, "DC395x_IRQ: intstatus = %02x ", scsi_intstatus); */
+	/*dprintkl(KERN_DEBUG, "handle_interrupt: intstatus = 0x%02x ", scsi_intstatus); */
 
 	if (timer_pending(&acb->selto_timer))
 		del_timer(&acb->selto_timer);
@@ -1742,8 +1722,8 @@
 		dcb = acb->active_dcb;
 		if (!dcb) {
 			dprintkl(KERN_DEBUG,
-			       "Oops: BusService (%04x %02x) w/o ActiveDCB!\n",
-			       scsi_status, scsi_intstatus);
+				"Oops: BusService (%04x %02x) w/o ActiveDCB!\n",
+				scsi_status, scsi_intstatus);
 			goto out_unlock;
 		}
 		srb = dcb->active_srb;
@@ -1807,8 +1787,6 @@
 	u8 dma_status;
 	irqreturn_t handled = IRQ_NONE;
 
-	dprintkdbg(DBG_0, "dc395x_interrupt...\n");
-
 	/*
 	 * Check for pending interupt
 	 */
@@ -1821,7 +1799,7 @@
 	}
 	else if (dma_status & 0x20) {
 		/* Error from the DMA engine */
-		dprintkl(KERN_INFO, "Interrupt from DMA engine: %02x!\n", dma_status);
+		dprintkl(KERN_INFO, "Interrupt from DMA engine: 0x%02x!\n", dma_status);
 #if 0
 		dprintkl(KERN_INFO, "This means DMA error! Try to handle ...\n");
 		if (acb->active_dcb) {
@@ -1844,7 +1822,7 @@
 static void msgout_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "msgout_phase0 (#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "msgout_phase0: (pid#%li)\n", srb->cmd->pid);
 	if (srb->state & (SRB_UNEXPECT_RESEL + SRB_ABORT_SENT))
 		*pscsi_status = PH_BUS_FREE;	/*.. initial phase */
 
@@ -1858,15 +1836,17 @@
 {
 	u16 i;
 	u8 *ptr;
+	dprintkdbg(DBG_0, "msgout_phase1: (pid#%li)\n", srb->cmd->pid);
 
-	dprintkdbg(DBG_0, "msgout_phase1 (#%li)\n", srb->cmd->pid);
-	clear_fifo(acb, "MOP1");
+	clear_fifo(acb, "msgout_phase1");
 	if (!(srb->state & SRB_MSGOUT)) {
 		srb->state |= SRB_MSGOUT;
-		dprintkl(KERN_DEBUG, "Debug: pid %li: MsgOut Phase unexpected.\n", srb->cmd->pid);	/* So what ? */
+		dprintkl(KERN_DEBUG,
+			"msgout_phase1: (pid#%li) Phase unexpected\n",
+			srb->cmd->pid);	/* So what ? */
 	}
 	if (!srb->msg_count) {
-		dprintkdbg(DBG_0, "Debug: pid %li: NOP Msg (no output message there).\n",
+		dprintkdbg(DBG_0, "msgout_phase1: (pid#%li) NOP msg\n",
 			srb->cmd->pid);
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, MSG_NOP);
 		DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
@@ -1877,13 +1857,9 @@
 	for (i = 0; i < srb->msg_count; i++)
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, *ptr++);
 	srb->msg_count = 0;
-	if (/*(dcb->flag & ABORT_DEV_) && */
-	    (srb->msgout_buf[0] == MSG_ABORT))
+	if (srb->msgout_buf[0] == MSG_ABORT)
 		srb->state = SRB_ABORT_SENT;
 
-	/*1.25 */
-	/*DC395x_write16 (TRM_S1040_SCSI_CONTROL, DO_DATALATCH); *//* it's important for atn stop */
-	/* SCSI command */
 	DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_FIFO_OUT);
 }
 
@@ -1891,9 +1867,7 @@
 static void command_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "command_phase0 (#%li)\n", srb->cmd->pid);
-	/*1.25 */
-	/*clear_fifo(acb, COP0); */
+	dprintkdbg(DBG_0, "command_phase0: (pid#%li)\n", srb->cmd->pid);
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);
 }
 
@@ -1904,9 +1878,9 @@
 	struct DeviceCtlBlk *dcb;
 	u8 *ptr;
 	u16 i;
+	dprintkdbg(DBG_0, "command_phase1: (pid#%li)\n", srb->cmd->pid);
 
-	dprintkdbg(DBG_0, "command_phase1 (#%li)\n", srb->cmd->pid);
-	clear_fifo(acb, "COP1");
+	clear_fifo(acb, "command_phase1");
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_CLRATN);
 	if (!(srb->flag & AUTO_REQSENSE)) {
 		ptr = (u8 *)srb->cmd->cmnd;
@@ -1939,14 +1913,14 @@
  */
 static void sg_verify_length(struct ScsiReqBlk *srb)
 {
-	if (debug_enabled(DBG_SGPARANOIA)) {
+	if (debug_enabled(DBG_SG)) {
 		unsigned len = 0;
 		unsigned idx = srb->sg_index;
 		struct SGentry *psge = srb->segment_x + idx;
 		for (; idx < srb->sg_count; psge++, idx++)
 			len += psge->length;
 		if (len != srb->total_xfer_length)
-			dprintkdbg(DBG_SGPARANOIA,
+			dprintkdbg(DBG_SG,
 			       "Inconsistent SRB S/G lengths (Tot=%i, Count=%i) !!\n",
 			       srb->total_xfer_length, len);
 	}			       
@@ -1966,9 +1940,9 @@
 	u32 xferred = srb->total_xfer_length - left; /* bytes transfered */
 	struct SGentry *psge = srb->segment_x + srb->sg_index;
 
-	dprintkdbg(DBG_0, "sg_update_list: Transfered %i of %i bytes, "
-		   "%i remain\n",
-		   xferred, srb->total_xfer_length, left);
+	dprintkdbg(DBG_0,
+		"sg_update_list: Transfered %i of %i bytes, %i remain\n",
+		xferred, srb->total_xfer_length, left);
 	if (xferred == 0) {
 		/* nothing to update since we did not transfer any data */
 		return;
@@ -2016,7 +1990,7 @@
 		++sg;
 	}
 
-	dprintkl(KERN_ERR, "sg_to_virt failed!\n");
+	dprintkl(KERN_ERR, "sg_update_list: sg_to_virt failed\n");
 	srb->virt_addr = 0;
 }
 
@@ -2055,14 +2029,14 @@
 	/*DC395x_write8 (TRM_S1040_DMA_STATUS, FORCEDMACOMP); */
 	if (DC395x_read16(acb, TRM_S1040_DMA_COMMAND) & 0x0001) {	/* read */
 		if (!(DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) & 0x40))
-			clear_fifo(acb, "ClnIn");
+			clear_fifo(acb, "cleanup/in");
 		if (!(DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT) & 0x80))
 			DC395x_write8(acb, TRM_S1040_DMA_CONTROL, CLRXFIFO);
 	} else {		/* write */
 		if (!(DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT) & 0x80))
 			DC395x_write8(acb, TRM_S1040_DMA_CONTROL, CLRXFIFO);
 		if (!(DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) & 0x40))
-			clear_fifo(acb, "ClnOut");
+			clear_fifo(acb, "cleanup/out");
 	}
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);
 }
@@ -2081,8 +2055,8 @@
 	struct DeviceCtlBlk *dcb = srb->dcb;
 	u16 scsi_status = *pscsi_status;
 	u32 d_left_counter = 0;
-
-	dprintkdbg(DBG_0, "data_out_phase0 (#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "data_out_phase0: (pid#%li) <%02i-%i>\n",
+		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
 
 	/*
 	 * KG: We need to drain the buffers before we draw any conclusions!
@@ -2096,12 +2070,14 @@
 	 * KG: Stop DMA engine pushing more data into the SCSI FIFO
 	 * If we need more data, the DMA SG list will be freshly set up, anyway
 	 */
-	dprintkdbg(DBG_PIO, "DOP0: DMA_FCNT: %02x, DMA_FSTAT: %02x, SCSI_FCNT: %02x, CTR %06x, stat %04x, Tot: %06x\n",
-	       DC395x_read8(acb, TRM_S1040_DMA_FIFOCNT),
-	       DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT),
-	       DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT),
-	       DC395x_read32(acb, TRM_S1040_SCSI_COUNTER), scsi_status,
-	       srb->total_xfer_length);
+	dprintkdbg(DBG_PIO, "data_out_phase0: "
+		"DMA{fifcnt=0x%02x fifostat=0x%02x} "
+		"SCSI{fifocnt=0x%02x cnt=0x%06x status=0x%04x} total=0x%06x\n",
+		DC395x_read8(acb, TRM_S1040_DMA_FIFOCNT),
+		DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT),
+		DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT),
+		DC395x_read32(acb, TRM_S1040_SCSI_COUNTER), scsi_status,
+		srb->total_xfer_length);
 	DC395x_write8(acb, TRM_S1040_DMA_CONTROL, STOPDMAXFER | CLRXFIFO);
 
 	if (!(srb->state & SRB_XFERPAD)) {
@@ -2125,26 +2101,16 @@
 			if (dcb->sync_period & WIDE_SYNC)
 				d_left_counter <<= 1;
 
-			dprintkdbg(DBG_KG,
-			       "Debug: SCSI FIFO contains %i %s in DOP0\n",
-			       DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT),
-			       (dcb->
-				sync_period & WIDE_SYNC) ? "words" :
-			       "bytes");
-			dprintkdbg(DBG_KG,
-			       "SCSI FIFOCNT %02x, SCSI CTR %08x\n",
-			       DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT),
-			       DC395x_read32(acb, TRM_S1040_SCSI_COUNTER));
-			dprintkdbg(DBG_KG,
-			       "DMA FIFOCNT %04x, FIFOSTAT %02x, DMA CTR %08x\n",
-			       DC395x_read8(acb, TRM_S1040_DMA_FIFOCNT),
-			       DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT),
-			       DC395x_read32(acb, TRM_S1040_DMA_CXCNT));
-
-			/*
-			 * if WIDE scsi SCSI FIFOCNT unit is word !!!
-			 * so need to *= 2
-			 */
+			dprintkdbg(DBG_KG, "data_out_phase0: FIFO contains %i %s\n"
+				"SCSI{fifocnt=0x%02x cnt=0x%08x} "
+				"DMA{fifocnt=0x%04x cnt=0x%02x ctr=0x%08x}\n",
+				DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT),
+				(dcb->sync_period & WIDE_SYNC) ? "words" : "bytes",
+				DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT),
+				DC395x_read32(acb, TRM_S1040_SCSI_COUNTER),
+				DC395x_read8(acb, TRM_S1040_DMA_FIFOCNT),
+				DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT),
+				DC395x_read32(acb, TRM_S1040_DMA_CXCNT));
 		}
 		/*
 		 * calculate all the residue data that not yet tranfered
@@ -2165,8 +2131,9 @@
 		if (d_left_counter == 1 && dcb->sync_period & WIDE_SYNC
 		    && srb->cmd->request_bufflen % 2) {
 			d_left_counter = 0;
-			dprintkl(KERN_INFO, "DOP0: Discard 1 byte. (%02x)\n",
-			       scsi_status);
+			dprintkl(KERN_INFO,
+				"data_out_phase0: Discard 1 byte (0x%02x)\n",
+				scsi_status);
 		}
 		/*
 		 * KG: Oops again. Same thinko as above: The SCSI might have been
@@ -2178,19 +2145,9 @@
 		 * KG: This is nonsense: We have been WRITING data to the bus
 		 * If the SCSI engine has no bytes left, how should the DMA engine?
 		 */
-		if (d_left_counter == 0
-		    /*|| (scsi_status & SCSIXFERCNT_2_ZERO)*/) {
-			/*
-			 * int ctr = 6000000; u8 TempDMAstatus;
-			 * do
-			 * {
-			 *  TempDMAstatus = DC395x_read8(acb, TRM_S1040_DMA_STATUS);
-			 * } while( !(TempDMAstatus & DMAXFERCOMP) && --ctr);
-			 * if (ctr < 6000000-1) dprintkl(KERN_DEBUG, "DMA should be complete ... in DOP1\n");
-			 * if (!ctr) dprintkl(KERN_ERR, "Deadlock in DataOutPhase0 !!\n");
-			 */
+		if (d_left_counter == 0) {
 			srb->total_xfer_length = 0;
-		} else {	/* Update SG list         */
+		} else {
 			/*
 			 * if transfer not yet complete
 			 * there were some data residue in SCSI FIFO or
@@ -2207,8 +2164,8 @@
 			    || ((oldxferred & ~PAGE_MASK) ==
 				(PAGE_SIZE - diff))
 			    ) {
-				dprintkl(KERN_INFO,
-				       "Work around chip bug (%i)?\n", diff);
+				dprintkl(KERN_INFO, "data_out_phase0: "
+					"Work around chip bug (%i)?\n", diff);
 				d_left_counter =
 				    srb->total_xfer_length - diff;
 				sg_update_list(srb, d_left_counter);
@@ -2219,43 +2176,30 @@
 			}
 		}
 	}
-#if 0
-	if (!(DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) & 0x40))
-		dprintkl(KERN_DEBUG,
-			"DOP0(%li): %i bytes in SCSI FIFO! (Clear!)\n",
-			srb->cmd->pid,
-			DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) & 0x1f);
-#endif
-	/*clear_fifo(acb, "DOP0"); */
-	/*DC395x_write8(TRM_S1040_DMA_CONTROL, CLRXFIFO | ABORTXFER); */
-#if 1
 	if ((*pscsi_status & PHASEMASK) != PH_DATA_OUT) {
-		/*dprintkl(KERN_DEBUG, "Debug: Clean up after Data Out ...\n"); */
 		cleanup_after_transfer(acb, srb);
 	}
-#endif
 }
 
 
 static void data_out_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "data_out_phase1 (#%li)\n", srb->cmd->pid);
-	/*1.25 */
-	clear_fifo(acb, "DOP1");
-	/* do prepare befor transfer when data out phase */
+	dprintkdbg(DBG_0, "data_out_phase1: (pid#%li) <%02i-%i>\n",
+		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+	clear_fifo(acb, "data_out_phase1");
+	/* do prepare before transfer when data out phase */
 	data_io_transfer(acb, srb, XFERDATAOUT);
 }
 
 
-
 static void data_in_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
 	u16 scsi_status = *pscsi_status;
 	u32 d_left_counter = 0;
-
-	dprintkdbg(DBG_0, "data_in_phase0 (#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "data_in_phase0: (pid#%li) <%02i-%i>\n",
+		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
 
 	/*
 	 * KG: DataIn is much more tricky than DataOut. When the device is finished
@@ -2272,10 +2216,8 @@
 	 */
 	if (!(srb->state & SRB_XFERPAD)) {
 		if (scsi_status & PARITYERROR) {
-			dprintkl(KERN_INFO,
-			       "Parity Error (pid %li, target %02i-%i)\n",
-			       srb->cmd->pid, srb->cmd->device->id,
-			       srb->cmd->device->lun);
+			dprintkl(KERN_INFO, "data_in_phase0: (pid#%li) "
+				"Parity Error\n", srb->cmd->pid);
 			srb->status |= PARITY_ERROR;
 		}
 		/*
@@ -2288,7 +2230,7 @@
 #if 0
 			int ctr = 6000000;
 			dprintkl(KERN_DEBUG,
-			       "DIP0: Wait for DMA FIFO to flush ...\n");
+				"DIP0: Wait for DMA FIFO to flush ...\n");
 			/*DC395x_write8  (TRM_S1040_DMA_CONTROL, STOPDMAXFER); */
 			/*DC395x_write32 (TRM_S1040_SCSI_COUNTER, 7); */
 			/*DC395x_write8  (TRM_S1040_SCSI_COMMAND, SCMD_DMA_IN); */
@@ -2303,47 +2245,43 @@
 				       "Deadlock in DIP0 waiting for DMA FIFO empty!!\n");
 			/*DC395x_write32 (TRM_S1040_SCSI_COUNTER, 0); */
 #endif
-			dprintkdbg(DBG_KG, "DIP0: DMA_FIFO: %02x %02x\n",
-			       DC395x_read8(acb, TRM_S1040_DMA_FIFOCNT),
-			       DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT));
+			dprintkdbg(DBG_KG, "data_in_phase0: "
+				"DMA{fifocnt=0x%02x fifostat=0x%02x}\n",
+				DC395x_read8(acb, TRM_S1040_DMA_FIFOCNT),
+				DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT));
 		}
 		/* Now: Check remainig data: The SCSI counters should tell us ... */
 		d_left_counter = DC395x_read32(acb, TRM_S1040_SCSI_COUNTER)
 		    + ((DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) & 0x1f)
 		       << ((srb->dcb->sync_period & WIDE_SYNC) ? 1 :
 			   0));
-
-		dprintkdbg(DBG_KG, "SCSI FIFO contains %i %s in DIP0\n",
-			  DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) & 0x1f,
-			  (srb->dcb->
-			  sync_period & WIDE_SYNC) ? "words" : "bytes");
-		dprintkdbg(DBG_KG, "SCSI FIFOCNT %02x, SCSI CTR %08x\n",
-			  DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT),
-			  DC395x_read32(acb, TRM_S1040_SCSI_COUNTER));
-		dprintkdbg(DBG_KG, "DMA FIFOCNT %02x,%02x DMA CTR %08x\n",
-			  DC395x_read8(acb, TRM_S1040_DMA_FIFOCNT),
-			  DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT),
-			  DC395x_read32(acb, TRM_S1040_DMA_CXCNT));
-		dprintkdbg(DBG_KG, "Remaining: TotXfer: %i, SCSI FIFO+Ctr: %i\n",
-			  srb->total_xfer_length, d_left_counter);
+		dprintkdbg(DBG_KG, "data_in_phase0: "
+			"SCSI{fifocnt=0x%02x%s ctr=0x%08x} "
+			"DMA{fifocnt=0x%02x fifostat=0x%02x ctr=0x%08x} "
+			"Remain{totxfer=%i scsi_fifo+ctr=%i}\n",
+			DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT),
+			(srb->dcb->sync_period & WIDE_SYNC) ? "words" : "bytes",
+			DC395x_read32(acb, TRM_S1040_SCSI_COUNTER),
+			DC395x_read8(acb, TRM_S1040_DMA_FIFOCNT),
+			DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT),
+			DC395x_read32(acb, TRM_S1040_DMA_CXCNT),
+			srb->total_xfer_length, d_left_counter);
 #if DC395x_LASTPIO
 		/* KG: Less than or equal to 4 bytes can not be transfered via DMA, it seems. */
 		if (d_left_counter
 		    && srb->total_xfer_length <= DC395x_LASTPIO) {
 			/*u32 addr = (srb->segment_x[srb->sg_index].address); */
 			/*sg_update_list (srb, d_left_counter); */
-			dprintkdbg(DBG_PIO, "DIP0: PIO (%i %s) to %p for remaining %i bytes:",
-				  DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) &
-				  0x1f,
-				  (srb->dcb->
-				   sync_period & WIDE_SYNC) ? "words" :
-				  "bytes", srb->virt_addr,
-				  srb->total_xfer_length);
-
+			dprintkdbg(DBG_PIO, "data_in_phase0: PIO (%i %s) to "
+				"%p for remaining %i bytes:",
+				DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) & 0x1f,
+				(srb->dcb->sync_period & WIDE_SYNC) ?
+				    "words" : "bytes",
+				srb->virt_addr,
+				srb->total_xfer_length);
 			if (srb->dcb->sync_period & WIDE_SYNC)
 				DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2,
 					      CFG2_WIDEFIFO);
-
 			while (DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) != 0x40) {
 				u8 byte = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 				*(srb->virt_addr)++ = byte;
@@ -2394,17 +2332,6 @@
 			 */
 		}
 #endif
-		/*d_left_counter += DC395x_read32(acb, TRM_S1040_SCSI_COUNTER); */
-#if 0
-		dprintkl(KERN_DEBUG,
-		       "DIP0: ctr=%08x, DMA_FIFO=%02x,%02x SCSI_FIFO=%02x\n",
-		       d_left_counter, DC395x_read8(acb, TRM_S1040_DMA_FIFOCNT),
-		       DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT),
-		       DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT));
-		dprintkl(KERN_DEBUG, "DIP0: DMAStat %02x\n",
-		       DC395x_read8(acb, TRM_S1040_DMA_STATUS));
-#endif
-
 		/* KG: This should not be needed any more! */
 		if (d_left_counter == 0
 		    || (scsi_status & SCSIXFERCNT_2_ZERO)) {
@@ -2420,12 +2347,6 @@
 				       "Deadlock in DataInPhase0 waiting for DMA!!\n");
 			srb->total_xfer_length = 0;
 #endif
-#if 0				/*def DBG_KG             */
-			dprintkl(KERN_DEBUG,
-			       "DIP0: DMA not yet ready: %02x: %i -> %i bytes\n",
-			       DC395x_read8(acb, TRM_S1040_DMA_STATUS),
-			       srb->total_xfer_length, d_left_counter);
-#endif
 			srb->total_xfer_length = d_left_counter;
 		} else {	/* phase changed */
 			/*
@@ -2441,57 +2362,32 @@
 	}
 	/* KG: The target may decide to disconnect: Empty FIFO before! */
 	if ((*pscsi_status & PHASEMASK) != PH_DATA_IN) {
-		/*dprintkl(KERN_DEBUG, "Debug: Clean up after Data In  ...\n"); */
 		cleanup_after_transfer(acb, srb);
 	}
-#if 0
-	/* KG: Make sure, no previous transfers are pending! */
-	bval = DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT);
-	if (!(bval & 0x40)) {
-		bval &= 0x1f;
-		dprintkl(KERN_DEBUG,
-		       "DIP0(%li): %i bytes in SCSI FIFO (stat %04x) (left %08x)!!\n",
-		       srb->cmd->pid, bval & 0x1f, scsi_status,
-		       d_left_counter);
-		if (d_left_counter == 0
-		    || (scsi_status & SCSIXFERCNT_2_ZERO)) {
-			dprintkl(KERN_DEBUG, "Clear FIFO!\n");
-			clear_fifo(acb, "DIP0");
-		}
-	}
-#endif
-	/*DC395x_write8 (TRM_S1040_DMA_CONTROL, CLRXFIFO | ABORTXFER); */
-	/*clear_fifo(acb, "DIP0"); */
-	/*DC395x_write16(TRM_S1040_SCSI_CONTROL, DO_DATALATCH); */
 }
 
 
 static void data_in_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "data_in_phase1 (#%li)\n", srb->cmd->pid);
-	/* FIFO should be cleared, if previous phase was not DataPhase */
-	/*clear_fifo(acb, "DIP1"); */
-	/* Allow data in! */
-	/*DC395x_write16(TRM_S1040_SCSI_CONTROL, DO_DATALATCH); */
-	/* do prepare before transfer when data in phase */
+	dprintkdbg(DBG_0, "data_in_phase1: (pid#%li) <%02i-%i>\n",
+		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
 	data_io_transfer(acb, srb, XFERDATAIN);
 }
 
 
-static void data_io_transfer(struct AdapterCtlBlk *acb,
+static void data_io_transfer(struct AdapterCtlBlk *acb, 
 		struct ScsiReqBlk *srb, u16 io_dir)
 {
 	struct DeviceCtlBlk *dcb = srb->dcb;
 	u8 bval;
-
-	dprintkdbg(DBG_0, "data_io_transfer %c (#%li): len=%i, sg=(%i/%i)\n",
-	       ((io_dir & DMACMD_DIR) ? 'r' : 'w'), srb->cmd->pid,
-	       srb->total_xfer_length, srb->sg_index,
-	       srb->sg_count);
+	dprintkdbg(DBG_0,
+		"data_io_transfer: (pid#%li) <%02i-%i> %c len=%i, sg=(%i/%i)\n",
+		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun,
+		((io_dir & DMACMD_DIR) ? 'r' : 'w'),
+		srb->total_xfer_length, srb->sg_index, srb->sg_count);
 	if (srb == acb->tmp_srb)
-		dprintkl(KERN_ERR, "Using tmp_srb in DataPhase!\n");
-
+		dprintkl(KERN_ERR, "data_io_transfer: Using tmp_srb!\n");
 	if (srb->sg_index >= srb->sg_count) {
 		/* can't happen? out of bounds error */
 		return;
@@ -2504,7 +2400,8 @@
 		 * Maybe, even ABORTXFER would be appropriate
 		 */
 		if (dma_status & XFERPENDING) {
-			dprintkl(KERN_DEBUG, "Xfer pending! Expect trouble!!\n");
+			dprintkl(KERN_DEBUG, "data_io_transfer: Xfer pending! "
+				"Expect trouble!\n");
 			dump_register_info(acb, dcb, srb);
 			DC395x_write8(acb, TRM_S1040_DMA_CONTROL, CLRXFIFO);
 		}
@@ -2566,10 +2463,9 @@
 			if (srb->dcb->sync_period & WIDE_SYNC)
 				DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2,
 				     CFG2_WIDEFIFO);
-
-			dprintkdbg(DBG_PIO, "DOP1: PIO %i bytes from %p:",
-				  srb->total_xfer_length,
-				  srb->virt_addr);
+			dprintkdbg(DBG_PIO,
+				"data_io_transfer: PIO %i bytes from %p:",
+				srb->total_xfer_length, srb->virt_addr);
 
 			while (srb->total_xfer_length) {
 				if (debug_enabled(DBG_PIO))
@@ -2643,15 +2539,13 @@
 static void status_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "status_phase0 (#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "status_phase0: (pid#%li) <%02i-%i>\n",
+		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
 	srb->target_status = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 	srb->end_message = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);	/* get message */
 	srb->state = SRB_COMPLETED;
 	*pscsi_status = PH_BUS_FREE;	/*.. initial phase */
-	/*1.25 */
-	/*clear_fifo(acb, "STP0"); */
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
-	/* SCSI command */
 	DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_MSGACCEPT);
 }
 
@@ -2659,27 +2553,14 @@
 static void status_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "status_phase1 (#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "status_phase1: (pid#%li) <%02i-%i>\n",
+		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
 	srb->state = SRB_STATUS;
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
-	/* SCSI command */
 	DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_COMP);
 }
 
 
-#if 0
-/* Print received message */
-static void print_msg(u8 * msg_buf, u32 len)
-{
-	int i;
-	printk(" %02x", msg_buf[0]);
-	for (i = 1; i < len; i++)
-		printk(" %02x", msg_buf[i]);
-	printk("\n");
-}
-#endif
-
-
 /* Check if the message is complete */
 static inline u8 msgin_completed(u8 * msgbuf, u32 len)
 {
@@ -2708,9 +2589,9 @@
 	DC395x_ENABLE_MSGOUT;
 	srb->state &= ~SRB_MSGIN;
 	srb->state |= SRB_MSGOUT;
-	dprintkl(KERN_INFO,
-	       "Reject message %02x from %02i-%i\n", srb->msgin_buf[0],
-	       srb->dcb->target_id, srb->dcb->target_lun);
+	dprintkl(KERN_INFO, "msgin_reject: 0x%02x <%02i-%i>\n",
+		srb->msgin_buf[0],
+		srb->dcb->target_id, srb->dcb->target_lun);
 }
 
 
@@ -2723,10 +2604,6 @@
 	DC395x_ENABLE_MSGOUT;
 	srb->state &= ~SRB_MSGIN;
 	srb->state |= SRB_MSGOUT;
-	/*
-	   if (srb->dcb)
-	   srb->dcb->flag &= ~ABORT_DEV_;
-	 */
 }
 
 
@@ -2735,13 +2612,13 @@
 {
 	struct ScsiReqBlk *srb = NULL;
 	struct ScsiReqBlk *i;
-
-	dprintkdbg(DBG_0, "msgin_qtag (#%li) tag=%i (srb=%p)\n",
+	dprintkdbg(DBG_0, "msgin_qtag: (pid#%li) tag=%i srb=%p\n",
 		   srb->cmd->pid, tag, srb);
+
 	if (!(dcb->tag_mask & (1 << tag)))
 		dprintkl(KERN_DEBUG,
-		       "MsgIn_QTag: tag_mask (%08x) does not reserve tag %i!\n",
-		       dcb->tag_mask, tag);
+			"msgin_qtag: tag_mask=0x%08x does not reserve tag %i!\n",
+			dcb->tag_mask, tag);
 
 	if (list_empty(&dcb->srb_going_list))
 		goto mingx0;
@@ -2754,8 +2631,8 @@
 	if (!srb)
 		goto mingx0;
 
-	dprintkdbg(DBG_0, "pid %li (%i-%i)\n", srb->cmd->pid,
-	       srb->dcb->target_id, srb->dcb->target_lun);
+	dprintkdbg(DBG_0, "msgin_qtag: (pid#%li) <%02i-%i>\n",
+		srb->cmd->pid, srb->dcb->target_id, srb->dcb->target_lun);
 	if (dcb->flag & ABORT_DEV_) {
 		/*srb->state = SRB_ABORT_SENT; */
 		enable_msgout_abort(acb, srb);
@@ -2778,7 +2655,7 @@
 	srb->msgout_buf[0] = MSG_ABORT_TAG;
 	srb->msg_count = 1;
 	DC395x_ENABLE_MSGOUT;
-	dprintkl(KERN_DEBUG, "Unknown tag received: %i: abort !!\n", tag);
+	dprintkl(KERN_DEBUG, "msgin_qtag: Unknown tag %i - abort\n", tag);
 	return srb;
 }
 
@@ -2797,8 +2674,9 @@
 static void msgin_set_async(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
 {
 	struct DeviceCtlBlk *dcb = srb->dcb;
+	dprintkl(KERN_DEBUG, "msgin_set_async: No sync transfers <%02i-%i>\n",
+		dcb->target_id, dcb->target_lun);
 
-	dprintkl(KERN_DEBUG, "Target %02i: No sync transfers\n", dcb->target_id);
 	dcb->sync_mode &= ~(SYNC_NEGO_ENABLE);
 	dcb->sync_mode |= SYNC_NEGO_DONE;
 	/*dcb->sync_period &= 0; */
@@ -2810,7 +2688,7 @@
 	    && !(dcb->sync_mode & WIDE_NEGO_DONE)) {
 		build_wdtr(acb, dcb, srb);
 		DC395x_ENABLE_MSGOUT;
-		dprintkdbg(DBG_0, "SDTR(rej): Try WDTR anyway ...\n");
+		dprintkdbg(DBG_0, "msgin_set_async(rej): Try WDTR anyway\n");
 	}
 }
 
@@ -2821,12 +2699,12 @@
 	struct DeviceCtlBlk *dcb = srb->dcb;
 	u8 bval;
 	int fact;
-
-	dprintkdbg(DBG_1, "Target %02i: Sync: %ins (%02i.%01i MHz) Offset %i\n",
-	       dcb->target_id, srb->msgin_buf[3] << 2,
-	       (250 / srb->msgin_buf[3]),
-	       ((250 % srb->msgin_buf[3]) * 10) / srb->msgin_buf[3],
-	       srb->msgin_buf[4]);
+	dprintkdbg(DBG_1, "msgin_set_sync: <%02i> Sync: %ins "
+		"(%02i.%01i MHz) Offset %i\n",
+		dcb->target_id, srb->msgin_buf[3] << 2,
+		(250 / srb->msgin_buf[3]),
+		((250 % srb->msgin_buf[3]) * 10) / srb->msgin_buf[3],
+		srb->msgin_buf[4]);
 
 	if (srb->msgin_buf[4] > 15)
 		srb->msgin_buf[4] = 15;
@@ -2845,8 +2723,8 @@
 		bval++;
 	if (srb->msgin_buf[3] < clock_period[bval])
 		dprintkl(KERN_INFO,
-		       "Increase sync nego period to %ins\n",
-		       clock_period[bval] << 2);
+			"msgin_set_sync: Increase sync nego period to %ins\n",
+			clock_period[bval] << 2);
 	srb->msgin_buf[3] = clock_period[bval];
 	dcb->sync_period &= 0xf0;
 	dcb->sync_period |= ALT_SYNC | bval;
@@ -2858,17 +2736,17 @@
 		fact = 250;
 
 	dprintkl(KERN_INFO,
-	       "Target %02i: %s Sync: %ins Offset %i (%02i.%01i MB/s)\n",
-	       dcb->target_id, (fact == 500) ? "Wide16" : "",
-	       dcb->min_nego_period << 2, dcb->sync_offset,
-	       (fact / dcb->min_nego_period),
-	       ((fact % dcb->min_nego_period) * 10 +
+		"Target %02i: %s Sync: %ins Offset %i (%02i.%01i MB/s)\n",
+		dcb->target_id, (fact == 500) ? "Wide16" : "",
+		dcb->min_nego_period << 2, dcb->sync_offset,
+		(fact / dcb->min_nego_period),
+		((fact % dcb->min_nego_period) * 10 +
 		dcb->min_nego_period / 2) / dcb->min_nego_period);
 
 	if (!(srb->state & SRB_DO_SYNC_NEGO)) {
 		/* Reply with corrected SDTR Message */
-		dprintkl(KERN_DEBUG, " .. answer w/  %ins %i\n",
-		       srb->msgin_buf[3] << 2, srb->msgin_buf[4]);
+		dprintkl(KERN_DEBUG, "msgin_set_sync: answer w/%ins %i\n",
+			srb->msgin_buf[3] << 2, srb->msgin_buf[4]);
 
 		memcpy(srb->msgout_buf, srb->msgin_buf, 5);
 		srb->msg_count = 5;
@@ -2879,7 +2757,7 @@
 		    && !(dcb->sync_mode & WIDE_NEGO_DONE)) {
 			build_wdtr(acb, dcb, srb);
 			DC395x_ENABLE_MSGOUT;
-			dprintkdbg(DBG_0, "SDTR: Also try WDTR ...\n");
+			dprintkdbg(DBG_0, "msgin_set_sync: Also try WDTR\n");
 		}
 	}
 	srb->state &= ~SRB_DO_SYNC_NEGO;
@@ -2893,9 +2771,8 @@
 		struct ScsiReqBlk *srb)
 {
 	struct DeviceCtlBlk *dcb = srb->dcb;
+	dprintkdbg(DBG_1, "msgin_set_nowide: <%02i>\n", dcb->target_id);
 
-	dprintkdbg(DBG_KG, "WDTR got rejected from target %02i\n",
-	       dcb->target_id);
 	dcb->sync_period &= ~WIDE_SYNC;
 	dcb->sync_mode &= ~(WIDE_NEGO_ENABLE);
 	dcb->sync_mode |= WIDE_NEGO_DONE;
@@ -2905,7 +2782,7 @@
 	    && !(dcb->sync_mode & SYNC_NEGO_DONE)) {
 		build_sdtr(acb, dcb, srb);
 		DC395x_ENABLE_MSGOUT;
-		dprintkdbg(DBG_0, "WDTR(rej): Try SDTR anyway ...\n");
+		dprintkdbg(DBG_0, "msgin_set_nowide: Rejected. Try SDTR anyway\n");
 	}
 }
 
@@ -2914,14 +2791,15 @@
 	struct DeviceCtlBlk *dcb = srb->dcb;
 	u8 wide = (dcb->dev_mode & NTC_DO_WIDE_NEGO
 		   && acb->config & HCC_WIDE_CARD) ? 1 : 0;
+	dprintkdbg(DBG_1, "msgin_set_wide: <%02i>\n", dcb->target_id);
 
 	if (srb->msgin_buf[3] > wide)
 		srb->msgin_buf[3] = wide;
 	/* Completed */
 	if (!(srb->state & SRB_DO_WIDE_NEGO)) {
 		dprintkl(KERN_DEBUG,
-		       "Target %02i initiates Wide Nego ...\n",
-		       dcb->target_id);
+			"msgin_set_wide: Wide nego initiated <%02i>\n",
+			dcb->target_id);
 		memcpy(srb->msgout_buf, srb->msgin_buf, 4);
 		srb->msg_count = 4;
 		srb->state |= SRB_DO_WIDE_NEGO;
@@ -2935,15 +2813,15 @@
 		dcb->sync_period &= ~WIDE_SYNC;
 	srb->state &= ~SRB_DO_WIDE_NEGO;
 	/*dcb->sync_mode &= ~(WIDE_NEGO_ENABLE+WIDE_NEGO_DONE); */
-	dprintkdbg(DBG_KG,
-	       "Wide transfers (%i bit) negotiated with target %02i\n",
-	       (8 << srb->msgin_buf[3]), dcb->target_id);
+	dprintkdbg(DBG_1,
+		"msgin_set_wide: Wide (%i bit) negotiated <%02i>\n",
+		(8 << srb->msgin_buf[3]), dcb->target_id);
 	reprogram_regs(acb, dcb);
 	if ((dcb->sync_mode & SYNC_NEGO_ENABLE)
 	    && !(dcb->sync_mode & SYNC_NEGO_DONE)) {
 		build_sdtr(acb, dcb, srb);
 		DC395x_ENABLE_MSGOUT;
-		dprintkdbg(DBG_0, "WDTR: Also try SDTR ...\n");
+		dprintkdbg(DBG_0, "msgin_set_wide: Also try SDTR.\n");
 	}
 }
 
@@ -2964,8 +2842,7 @@
 		u16 *pscsi_status)
 {
 	struct DeviceCtlBlk *dcb = acb->active_dcb;
-
-	dprintkdbg(DBG_0, "msgin_phase0 (#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "msgin_phase0: (pid#%li)\n", srb->cmd->pid);
 
 	srb->msgin_buf[acb->msg_len++] = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 	if (msgin_completed(srb->msgin_buf, acb->msg_len)) {
@@ -3017,43 +2894,42 @@
 			msgin_reject(acb, srb);
 			break;
 
-			/* Discard  wide residual */
 		case MSG_IGNOREWIDE:
-			dprintkdbg(DBG_0, "Ignore Wide Residual!\n");
-			/*DC395x_write32 (TRM_S1040_SCSI_COUNTER, 1); */
-			/*DC395x_read8 (TRM_S1040_SCSI_FIFO); */
+			/* Discard  wide residual */
+			dprintkdbg(DBG_0, "msgin_phase0: Ignore Wide Residual!\n");
 			break;
 
-			/* nothing has to be done */
 		case COMMAND_COMPLETE:
+			/* nothing has to be done */
 			break;
+
+		case SAVE_POINTERS:
 			/*
 			 * SAVE POINTER may be ignored as we have the struct
 			 * ScsiReqBlk* associated with the scsi command.
 			 */
-		case SAVE_POINTERS:
-			dprintkdbg(DBG_0, "SAVE POINTER message received (pid %li: rem.%i) ... ignore :-(\n",
-			       srb->cmd->pid, srb->total_xfer_length);
-			/*srb->Saved_Ptr = srb->TotalxferredLen; */
+			dprintkdbg(DBG_0, "msgin_phase0: (pid#%li) "
+				"SAVE POINTER rem=%i Ignore\n",
+				srb->cmd->pid, srb->total_xfer_length);
 			break;
-			/* The device might want to restart transfer with a RESTORE */
+
 		case RESTORE_POINTERS:
-			dprintkl(KERN_DEBUG,
-			       "RESTORE POINTER message received ... ignore :-(\n");
-			/*dc395x_restore_ptr (acb, srb); */
+			dprintkdbg(DBG_0, "msgin_phase0: RESTORE POINTER. Ignore\n");
 			break;
+
 		case ABORT:
-			dprintkl(KERN_DEBUG,
-			       "ABORT msg received (pid %li %02i-%i)\n",
-			       srb->cmd->pid, dcb->target_id,
-			       dcb->target_lun);
+			dprintkdbg(DBG_0, "msgin_phase0: (pid#%li) "
+				"<%02i-%i> ABORT msg\n",
+				srb->cmd->pid, dcb->target_id,
+				dcb->target_lun);
 			dcb->flag |= ABORT_DEV_;
 			enable_msgout_abort(acb, srb);
 			break;
-			/* reject unknown messages */
+
 		default:
+			/* reject unknown messages */
 			if (srb->msgin_buf[0] & IDENTIFY_BASE) {
-				dprintkl(KERN_DEBUG, "Identify Message received?\n");
+				dprintkdbg(DBG_0, "msgin_phase0: Identify msg\n");
 				srb->msg_count = 1;
 				srb->msgout_buf[0] = dcb->identify_msg;
 				DC395x_ENABLE_MSGOUT;
@@ -3076,8 +2952,8 @@
 static void msgin_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "msgin_phase1 (#%li)\n", srb->cmd->pid);
-	clear_fifo(acb, "MIP1");
+	dprintkdbg(DBG_0, "msgin_phase1: (pid#%li)\n", srb->cmd->pid);
+	clear_fifo(acb, "msgin_phase1");
 	DC395x_write32(acb, TRM_S1040_SCSI_COUNTER, 1);
 	if (!(srb->state & SRB_MSGIN)) {
 		srb->state &= ~SRB_DISCONNECT;
@@ -3130,32 +3006,33 @@
 	struct ScsiReqBlk *srb;
 
 	if (!dcb) {
-		dprintkl(KERN_ERR, "Disc: Exception Disconnect dcb=NULL !!\n ");
+		dprintkl(KERN_ERR, "disconnect: No such device\n");
 		udelay(500);
 		/* Suspend queue for a while */
 		acb->scsi_host->last_reset =
 		    jiffies + HZ / 2 +
 		    HZ * acb->eeprom.delay_time;
-		clear_fifo(acb, "DiscEx");
+		clear_fifo(acb, "disconnectEx");
 		DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_HWRESELECT);
 		return;
 	}
 	srb = dcb->active_srb;
 	acb->active_dcb = NULL;
-	dprintkdbg(DBG_0, "disconnect (#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "disconnect: (pid#%li)\n", srb->cmd->pid);
 
 	srb->scsi_phase = PH_BUS_FREE;	/* initial phase */
-	clear_fifo(acb, "Disc");
+	clear_fifo(acb, "disconnect");
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_HWRESELECT);
 	if (srb->state & SRB_UNEXPECT_RESEL) {
-		dprintkl(KERN_ERR, "Disc: Unexpected Reselection (%i-%i)\n",
-		       dcb->target_id, dcb->target_lun);
+		dprintkl(KERN_ERR,
+			"disconnect: Unexpected reselection <%02i-%i>\n",
+			dcb->target_id, dcb->target_lun);
 		srb->state = 0;
 		waiting_process_next(acb);
 	} else if (srb->state & SRB_ABORT_SENT) {
 		dcb->flag &= ~ABORT_DEV_;
 		acb->scsi_host->last_reset = jiffies + HZ / 2 + 1;
-		dprintkl(KERN_ERR, "Disc: SRB_ABORT_SENT!\n");
+		dprintkl(KERN_ERR, "disconnect: SRB_ABORT_SENT\n");
 		doing_srb_done(acb, DID_ABORT, srb->cmd, 1);
 		waiting_process_next(acb);
 	} else {
@@ -3170,16 +3047,16 @@
 			if (srb->state != SRB_START_
 			    && srb->state != SRB_MSGOUT) {
 				srb->state = SRB_READY;
-				dprintkl(KERN_DEBUG, "Unexpected Disconnection (pid %li)!\n",
-				       srb->cmd->pid);
+				dprintkl(KERN_DEBUG,
+					"disconnect: (pid#%li) Unexpected\n",
+					srb->cmd->pid);
 				srb->target_status = SCSI_STAT_SEL_TIMEOUT;
 				goto disc1;
 			} else {
 				/* Normal selection timeout */
-				dprintkdbg(DBG_KG,
-				       "Disc: SelTO (#%li) for dev %02i-%i\n",
-				       srb->cmd->pid, dcb->target_id,
-				       dcb->target_lun);
+				dprintkdbg(DBG_KG, "disconnect: (pid#%li) "
+					"<%02i-%i> SelTO\n", srb->cmd->pid,
+					dcb->target_id, dcb->target_lun);
 				if (srb->retry_count++ > DC395x_MAX_RETRIES
 				    || acb->scan_devices) {
 					srb->target_status =
@@ -3188,8 +3065,9 @@
 				}
 				free_tag(dcb, srb);
 				srb_going_to_waiting_move(dcb, srb);
-				dprintkdbg(DBG_KG, "Retry pid %li ...\n",
-				       srb->cmd->pid);
+				dprintkdbg(DBG_KG,
+					"disconnect: (pid#%li) Retry\n",
+					srb->cmd->pid);
 				waiting_set_timer(acb, HZ / 20);
 			}
 		} else if (srb->state & SRB_DISCONNECT) {
@@ -3197,9 +3075,9 @@
 			/*
 			 * SRB_DISCONNECT (This is what we expect!)
 			 */
-			/* dprintkl(KERN_DEBUG, "DoWaitingSRB (#%li)\n", srb->cmd->pid); */
 			if (bval & 0x40) {
-				dprintkdbg(DBG_0, "Debug: DISC: SCSI bus stat %02x: ACK set! Other controllers?\n",
+				dprintkdbg(DBG_0, "disconnect: SCSI bus stat "
+					" 0x%02x: ACK set! Other controllers?\n",
 					bval);
 				/* It could come from another initiator, therefore don't do much ! */
 			} else
@@ -3212,7 +3090,6 @@
 			free_tag(dcb, srb);
 			dcb->active_srb = NULL;
 			srb->state = SRB_FREE;
-			/*dprintkl(KERN_DEBUG, "done (#%li)\n", srb->cmd->pid); */
 			srb_done(acb, dcb, srb);
 		}
 	}
@@ -3226,27 +3103,27 @@
 	u16 rsel_tar_lun_id;
 	u8 id, lun;
 	u8 arblostflag = 0;
+	dprintkdbg(DBG_0, "reselect: acb=%p\n", acb);
 
-	dprintkdbg(DBG_0, "reselect...\n");
-
-	clear_fifo(acb, "Resel");
+	clear_fifo(acb, "reselect");
 	/*DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_HWRESELECT | DO_DATALATCH); */
 	/* Read Reselected Target ID and LUN */
 	rsel_tar_lun_id = DC395x_read16(acb, TRM_S1040_SCSI_TARGETID);
 	if (dcb) {		/* Arbitration lost but Reselection win */
 		srb = dcb->active_srb;
 		if (!srb) {
-			dprintkl(KERN_DEBUG, "Arb lost Resel won, but active_srb == NULL!\n");
+			dprintkl(KERN_DEBUG, "reselect: Arb lost Resel won, "
+				"but active_srb == NULL\n");
 			DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
 			return;
 		}
 		/* Why the if ? */
 		if (!acb->scan_devices) {
-			dprintkdbg(DBG_KG,
-			       "Arb lost but Resel win pid %li (%02i-%i) Rsel %04x Stat %04x\n",
-			       srb->cmd->pid, dcb->target_id,
-			       dcb->target_lun, rsel_tar_lun_id,
-			       DC395x_read16(acb, TRM_S1040_SCSI_STATUS));
+			dprintkdbg(DBG_KG, "reselect: (pid#%li) <%02i-%i> "
+				"Arb lost but Resel win rsel=%i stat=0x%04x\n",
+				srb->cmd->pid, dcb->target_id,
+				dcb->target_lun, rsel_tar_lun_id,
+				DC395x_read16(acb, TRM_S1040_SCSI_STATUS));
 			arblostflag = 1;
 			/*srb->state |= SRB_DISCONNECT; */
 
@@ -3260,23 +3137,23 @@
 	}
 	/* Read Reselected Target Id and LUN */
 	if (!(rsel_tar_lun_id & (IDENTIFY_BASE << 8)))
-		dprintkl(KERN_DEBUG, "Resel expects identify msg! Got %04x!\n",
-		       rsel_tar_lun_id);
+		dprintkl(KERN_DEBUG, "reselect: Expects identify msg. "
+			"Got %i!\n", rsel_tar_lun_id);
 	id = rsel_tar_lun_id & 0xff;
 	lun = (rsel_tar_lun_id >> 8) & 7;
 	dcb = find_dcb(acb, id, lun);
 	if (!dcb) {
-		dprintkl(KERN_ERR, "Reselect from non existing device (%02i-%i)\n",
-		       id, lun);
+		dprintkl(KERN_ERR, "reselect: From non existent device "
+			"<%02i-%i>\n", id, lun);
 		DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
 		return;
 	}
-
 	acb->active_dcb = dcb;
 
 	if (!(dcb->dev_mode & NTC_DO_DISCONNECT))
-		dprintkl(KERN_DEBUG, "Reselection in spite of forbidden disconnection? (%02i-%i)\n",
-		       dcb->target_id, dcb->target_lun);
+		dprintkl(KERN_DEBUG, "reselect: in spite of forbidden "
+			"disconnection? <%02i-%i>\n",
+			dcb->target_id, dcb->target_lun);
 
 	if (dcb->sync_mode & EN_TAG_QUEUEING /*&& !arblostflag */) {
 		srb = acb->tmp_srb;
@@ -3289,8 +3166,8 @@
 			 * abort command
 			 */
 			dprintkl(KERN_DEBUG,
-			       "Reselected w/o disconnected cmds from %02i-%i?\n",
-			       dcb->target_id, dcb->target_lun);
+				"reselect: w/o disconnected cmds <%02i-%i>\n",
+				dcb->target_id, dcb->target_lun);
 			srb = acb->tmp_srb;
 			srb->state = SRB_UNEXPECT_RESEL;
 			dcb->active_srb = srb;
@@ -3307,6 +3184,7 @@
 	srb->scsi_phase = PH_BUS_FREE;	/* initial phase */
 
 	/* Program HA ID, target ID, period and offset */
+	dprintkdbg(DBG_0, "reselect: select <%i>\n", dcb->target_id);
 	DC395x_write8(acb, TRM_S1040_SCSI_HOSTID, acb->scsi_host->this_id);	/* host   ID */
 	DC395x_write8(acb, TRM_S1040_SCSI_TARGETID, dcb->target_id);		/* target ID */
 	DC395x_write8(acb, TRM_S1040_SCSI_OFFSET, dcb->sync_offset);		/* offset    */
@@ -3371,22 +3249,20 @@
 	int dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
 	if (cmd->use_sg && dir != PCI_DMA_NONE) {
 		/* unmap DC395x SG list */
-		dprintkdbg(DBG_SGPARANOIA,
-		       "unmap SG list %08x(%05x)\n",
-		       srb->sg_bus_addr,
-		       SEGMENTX_LEN);
+		dprintkdbg(DBG_SG, "pci_unmap_srb: list=%08x(%05x)\n",
+			srb->sg_bus_addr, SEGMENTX_LEN);
 		pci_unmap_single(acb->dev, srb->sg_bus_addr,
 				 SEGMENTX_LEN,
 				 PCI_DMA_TODEVICE);
-		dprintkdbg(DBG_SGPARANOIA, "Unmap %i SG segments from %p\n",
-		       cmd->use_sg, cmd->request_buffer);
+		dprintkdbg(DBG_SG, "pci_unmap_srb: segs=%i buffer=%p\n",
+			cmd->use_sg, cmd->request_buffer);
 		/* unmap the sg segments */
 		pci_unmap_sg(acb->dev,
 			     (struct scatterlist *)cmd->request_buffer,
 			     cmd->use_sg, dir);
 	} else if (cmd->request_buffer && dir != PCI_DMA_NONE) {
-		dprintkdbg(DBG_SGPARANOIA, "Unmap buffer %08x(%05x)\n",
-		       srb->segment_x[0].address, cmd->request_bufflen);
+		dprintkdbg(DBG_SG, "pci_unmap_srb: buffer=%08x(%05x)\n",
+			srb->segment_x[0].address, cmd->request_bufflen);
 		pci_unmap_single(acb->dev, srb->segment_x[0].address,
 				 cmd->request_bufflen, dir);
 	}
@@ -3400,12 +3276,11 @@
 	if (!(srb->flag & AUTO_REQSENSE))
 		return;
 	/* Unmap sense buffer */
-	dprintkdbg(DBG_SGPARANOIA, "Unmap sense buffer from %08x\n",
+	dprintkdbg(DBG_SG, "pci_unmap_srb_sense: buffer=%08x\n",
 	       srb->segment_x[0].address);
 	pci_unmap_single(acb->dev, srb->segment_x[0].address,
 			 srb->segment_x[0].length, PCI_DMA_FROMDEVICE);
 	/* Restore SG stuff */
-	/*printk ("Auto_ReqSense finished: Restore Counters ...\n"); */
 	srb->total_xfer_length = srb->xferred;
 	srb->segment_x[0].address =
 	    srb->segment_x[DC395x_MAX_SG_LISTENTRY - 1].address;
@@ -3434,16 +3309,14 @@
 		ptr = (struct ScsiInqData *)(cmd->request_buffer);
 	}
 
-	dprintkdbg(DBG_SGPARANOIA, 
-	       "srb_done sg=%i(%i/%i), buf=%p, addr=%p\n",
-	       cmd->use_sg, srb->sg_index, srb->sg_count,
-	       cmd->request_buffer, ptr);
-	dprintkdbg(DBG_KG,
-	       "srb_done (#%li) (target %02i-%i): ", srb->cmd->pid,
-	       srb->cmd->device->id, srb->cmd->device->lun);
+	dprintkdbg(DBG_1, "srb_done: (pid#%li) <%02i-%i>\n", srb->cmd->pid,
+		srb->cmd->device->id, srb->cmd->device->lun);
+	dprintkdbg(DBG_SG, "srb_done: srb=%p sg=%i(%i/%i) buf=%p addr=%p\n",
+		srb, cmd->use_sg, srb->sg_index, srb->sg_count,
+		cmd->request_buffer, ptr);
 	status = srb->target_status;
 	if (srb->flag & AUTO_REQSENSE) {
-		dprintkdbg(DBG_0, "AUTO_REQSENSE1..............\n");
+		dprintkdbg(DBG_0, "srb_done: AUTO_REQSENSE1\n");
 		pci_unmap_srb_sense(acb, srb);
 		/*
 		 ** target status..........................
@@ -3451,58 +3324,57 @@
 		srb->flag &= ~AUTO_REQSENSE;
 		srb->adapter_status = 0;
 		srb->target_status = CHECK_CONDITION << 1;
-		if (debug_enabled(DBG_KG)) {
+		if (debug_enabled(DBG_1)) {
 			switch (cmd->sense_buffer[2] & 0x0f) {
 			case NOT_READY:
 				dprintkl(KERN_DEBUG,
-				     "ReqSense: NOT_READY (Cmnd = 0x%02x, Dev = %i-%i, Stat = %i, Scan = %i) ",
+				     "ReqSense: NOT_READY cmnd=0x%02x <%02i-%i> stat=%i scan=%i ",
 				     cmd->cmnd[0], dcb->target_id,
 				     dcb->target_lun, status, acb->scan_devices);
 				break;
 			case UNIT_ATTENTION:
 				dprintkl(KERN_DEBUG,
-				     "ReqSense: UNIT_ATTENTION (Cmnd = 0x%02x, Dev = %i-%i, Stat = %i, Scan = %i) ",
+				     "ReqSense: UNIT_ATTENTION cmnd=0x%02x <%02i-%i> stat=%i scan=%i ",
 				     cmd->cmnd[0], dcb->target_id,
 				     dcb->target_lun, status, acb->scan_devices);
 				break;
 			case ILLEGAL_REQUEST:
 				dprintkl(KERN_DEBUG,
-				     "ReqSense: ILLEGAL_REQUEST (Cmnd = 0x%02x, Dev = %i-%i, Stat = %i, Scan = %i) ",
+				     "ReqSense: ILLEGAL_REQUEST cmnd=0x%02x <%02i-%i> stat=%i scan=%i ",
 				     cmd->cmnd[0], dcb->target_id,
 				     dcb->target_lun, status, acb->scan_devices);
 				break;
 			case MEDIUM_ERROR:
 				dprintkl(KERN_DEBUG,
-				     "ReqSense: MEDIUM_ERROR (Cmnd = 0x%02x, Dev = %i-%i, Stat = %i, Scan = %i) ",
+				     "ReqSense: MEDIUM_ERROR cmnd=0x%02x <%02i-%i> stat=%i scan=%i ",
 				     cmd->cmnd[0], dcb->target_id,
 				     dcb->target_lun, status, acb->scan_devices);
 				break;
 			case HARDWARE_ERROR:
 				dprintkl(KERN_DEBUG,
-				     "ReqSense: HARDWARE_ERROR (Cmnd = 0x%02x, Dev = %i-%i, Stat = %i, Scan = %i) ",
+				     "ReqSense: HARDWARE_ERROR cmnd=0x%02x <%02i-%i> stat=%i scan=%i ",
 				     cmd->cmnd[0], dcb->target_id,
 				     dcb->target_lun, status, acb->scan_devices);
 				break;
 			}
 			if (cmd->sense_buffer[7] >= 6)
-				dprintkl(KERN_DEBUG, 
-				     "Sense=%02x, ASC=%02x, ASCQ=%02x (%08x %08x) ",
-				     cmd->sense_buffer[2], cmd->sense_buffer[12],
-				     cmd->sense_buffer[13],
-				     *((unsigned int *)(cmd->sense_buffer + 3)),
-				     *((unsigned int *)(cmd->sense_buffer + 8)));
+				printk("sense=0x%02x ASC=0x%02x ASCQ=0x%02x "
+					"(0x%08x 0x%08x)\n",
+					cmd->sense_buffer[2], cmd->sense_buffer[12],
+					cmd->sense_buffer[13],
+					*((unsigned int *)(cmd->sense_buffer + 3)),
+					*((unsigned int *)(cmd->sense_buffer + 8)));
 			else
-				dprintkl(KERN_DEBUG,
-				     "Sense=%02x, No ASC/ASCQ (%08x) ",
-				     cmd->sense_buffer[2],
-				     *((unsigned int *)(cmd->sense_buffer + 3)));
+				printk("sense=0x%02x No ASC/ASCQ (0x%08x)\n",
+					cmd->sense_buffer[2],
+					*((unsigned int *)(cmd->sense_buffer + 3)));
 		}
 
 		if (status == (CHECK_CONDITION << 1)) {
 			cmd->result = DID_BAD_TARGET << 16;
 			goto ckc_e;
 		}
-		dprintkdbg(DBG_0, "AUTO_REQSENSE2..............\n");
+		dprintkdbg(DBG_0, "srb_done: AUTO_REQSENSE2\n");
 
 		if (srb->total_xfer_length
 		    && srb->total_xfer_length >= cmd->underflow)
@@ -3528,8 +3400,7 @@
 			return;
 		} else if (status_byte(status) == QUEUE_FULL) {
 			tempcnt = (u8)list_size(&dcb->srb_going_list);
-			printk
-			    ("\nDC395x:  QUEUE_FULL for dev %02i-%i with %i cmnds\n",
+			dprintkl(KERN_INFO, "QUEUE_FULL for dev <%02i-%i> with %i cmnds\n",
 			     dcb->target_id, dcb->target_lun, tempcnt);
 			if (tempcnt > 1)
 				tempcnt--;
@@ -3611,27 +3482,24 @@
 	cmd->SCp.buffers_residual = 0;
 	if (debug_enabled(DBG_KG)) {
 		if (srb->total_xfer_length)
-			dprintkdbg(DBG_KG, "pid %li: %02x (%02i-%i): Missed %i bytes\n",
-			     cmd->pid, cmd->cmnd[0], cmd->device->id,
-			     cmd->device->lun, srb->total_xfer_length);
+			dprintkdbg(DBG_KG, "srb_done: (pid#%li) <%02i-%i> "
+				"cmnd=0x%02x Missed %i bytes\n",
+				cmd->pid, cmd->device->id, cmd->device->lun,
+				cmd->cmnd[0], srb->total_xfer_length);
 	}
 
 	srb_going_remove(dcb, srb);
 	/* Add to free list */
 	if (srb == acb->tmp_srb)
-		dprintkl(KERN_ERR, "ERROR! Completed Cmnd with tmp_srb!\n");
-	else
+		dprintkl(KERN_ERR, "srb_done: ERROR! Completed cmd with tmp_srb\n");
+	else {
+		dprintkdbg(DBG_0, "srb_done: (pid#%li) done result=0x%08x\n",
+			cmd->pid, cmd->result);
 		srb_free_insert(acb, srb);
-
-	dprintkdbg(DBG_0, "srb_done: done (#%li)\n", cmd->pid);
-	if (debug_enabled(DBG_KG)) {
-		printk(" 0x%08x\n", cmd->result);
 	}
 	pci_unmap_srb(acb, srb);
-	/*DC395x_UNLOCK_ACB_NI; */
-	cmd->scsi_done(cmd);
-	/*DC395x_LOCK_ACB_NI; */
 
+	cmd->scsi_done(cmd);
 	waiting_process_next(acb);
 }
 
@@ -3641,8 +3509,8 @@
 		Scsi_Cmnd *cmd, u8 force)
 {
 	struct DeviceCtlBlk *dcb;
-
 	dprintkl(KERN_INFO, "doing_srb_done: pids ");
+
 	list_for_each_entry(dcb, &acb->dcb_list, list) {
 		struct ScsiReqBlk *srb;
 		struct ScsiReqBlk *tmp;
@@ -3671,11 +3539,11 @@
 		}
 		if (!list_empty(&dcb->srb_going_list))
 			dprintkl(KERN_DEBUG, 
-			       "How could the ML send cmnds to the Going queue? (%02i-%i)!!\n",
+			       "How could the ML send cmnds to the Going queue? <%02i-%i>\n",
 			       dcb->target_id, dcb->target_lun);
 		if (dcb->tag_mask)
 			dprintkl(KERN_DEBUG,
-			       "tag_mask for %02i-%i should be empty, is %08x!\n",
+			       "tag_mask for <%02i-%i> should be empty, is %08x!\n",
 			       dcb->target_id, dcb->target_lun,
 			       dcb->tag_mask);
 
@@ -3685,7 +3553,7 @@
 			p = srb->cmd;
 
 			result = MK_RES(0, did_flag, 0, 0);
-			printk("W:%li(%i-%i)", p->pid, p->device->id,
+			printk("W:%li<%02i-%i>", p->pid, p->device->id,
 			       p->device->lun);
 			srb_waiting_remove(dcb, srb);
 			srb_free_insert(acb, srb);
@@ -3699,11 +3567,9 @@
 			}
 		}
 		if (!list_empty(&dcb->srb_waiting_list))
-			printk
-			    ("\nDC395x: Debug: ML queued %i cmnds again to %02i-%i\n",
+			dprintkl(KERN_DEBUG, "ML queued %i cmnds again to <%02i-%i>\n",
 			     list_size(&dcb->srb_waiting_list), dcb->target_id,
 			     dcb->target_lun);
-
 		dcb->flag &= ~ABORT_DEV_;
 	}
 	printk("\n");
@@ -3712,7 +3578,7 @@
 
 static void reset_scsi_bus(struct AdapterCtlBlk *acb)
 {
-	dprintkdbg(DBG_0, "reset_scsi_bus...\n");
+	dprintkdbg(DBG_0, "reset_scsi_bus: acb=%p\n", acb);
 	acb->acb_flag |= RESET_DEV;	/* RESET_DETECT, RESET_DONE, RESET_DEV */
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_RSTSCSI);
 
@@ -3746,7 +3612,6 @@
 	wval = DC395x_read16(acb, TRM_S1040_DMA_CONFIG) & ~DMA_FIFO_CTRL;
 	wval |=
 	    DMA_FIFO_HALF_HALF | DMA_ENHANCE /*| DMA_MEM_MULTI_READ */ ;
-	/*dprintkl(KERN_INFO, "DMA_Config: %04x\n", wval); */
 	DC395x_write16(acb, TRM_S1040_DMA_CONFIG, wval);
 	/* Clear pending interrupt status */
 	DC395x_read8(acb, TRM_S1040_SCSI_INTSTATUS);
@@ -3760,7 +3625,7 @@
 
 static void scsi_reset_detect(struct AdapterCtlBlk *acb)
 {
-	dprintkl(KERN_INFO, "scsi_reset_detect\n");
+	dprintkl(KERN_INFO, "scsi_reset_detect: acb=%p\n", acb);
 	/* delay half a second */
 	if (timer_pending(&acb->waiting_timer))
 		del_timer(&acb->waiting_timer);
@@ -3774,7 +3639,7 @@
 	    jiffies + 5 * HZ / 2 +
 	    HZ * acb->eeprom.delay_time;
 
-	clear_fifo(acb, "RstDet");
+	clear_fifo(acb, "scsi_reset_detect");
 	set_basic_config(acb);
 	/*1.25 */
 	/*DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_HWRESELECT); */
@@ -3797,10 +3662,9 @@
 		struct ScsiReqBlk *srb)
 {
 	Scsi_Cmnd *cmd = srb->cmd;
+	dprintkdbg(DBG_1, "request_sense: (pid#%li) <%02i-%i>\n",
+		cmd->pid, cmd->device->id, cmd->device->lun);
 
-	dprintkdbg(DBG_KG,
-	       "request_sense for pid %li, target %02i-%i\n",
-	       cmd->pid, cmd->device->id, cmd->device->lun);
 	srb->flag |= AUTO_REQSENSE;
 	srb->adapter_status = 0;
 	srb->target_status = 0;
@@ -3821,7 +3685,7 @@
 	srb->segment_x[0].address =
 	    pci_map_single(acb->dev, cmd->sense_buffer,
 			   sizeof(cmd->sense_buffer), PCI_DMA_FROMDEVICE);
-	dprintkdbg(DBG_SGPARANOIA, "Map sense buffer %p->%08x(%05x)\n",
+	dprintkdbg(DBG_SG, "request_sense: map buffer %p->%08x(%05x)\n",
 	       cmd->sense_buffer, srb->segment_x[0].address,
 	       sizeof(cmd->sense_buffer));
 	srb->sg_count = 1;
@@ -3829,8 +3693,8 @@
 
 	if (start_scsi(acb, dcb, srb)) {	/* Should only happen, if sb. else grabs the bus */
 		dprintkl(KERN_DEBUG,
-		       "Request Sense failed for pid %li (%02i-%i)!\n",
-		       srb->cmd->pid, dcb->target_id, dcb->target_lun);
+			"request_sense: (pid#%li) failed <%02i-%i>\n",
+			srb->cmd->pid, dcb->target_id, dcb->target_lun);
 		srb_going_to_waiting_move(dcb, srb);
 		waiting_set_timer(acb, HZ / 100);
 	}
@@ -3858,7 +3722,7 @@
 	struct DeviceCtlBlk *dcb;
 
 	dcb = kmalloc(sizeof(struct DeviceCtlBlk), GFP_ATOMIC);
-	dprintkdbg(DBG_0, "device_alloc: device %p\n", dcb);
+	dprintkdbg(DBG_0, "device_alloc: <%02i-%i>\n", target, lun);
 	if (!dcb)
 		return NULL;
 	dcb->acb = NULL;
@@ -3899,10 +3763,10 @@
 		list_for_each_entry(p, &acb->dcb_list, list)
 			if (p->target_id == dcb->target_id)
 				break;
-		dprintkdbg(DBG_KG, 
-		       "Copy settings from %02i-%02i to %02i-%02i\n",
-		       p->target_id, p->target_lun,
-		       dcb->target_id, dcb->target_lun);
+		dprintkdbg(DBG_1, 
+		       "device_alloc: <%02i-%i> copy from <%02i-%i>\n",
+		       dcb->target_id, dcb->target_lun,
+		       p->target_id, p->target_lun);
 		dcb->sync_mode = p->sync_mode;
 		dcb->sync_period = p->sync_period;
 		dcb->min_nego_period = p->min_nego_period;
@@ -3952,8 +3816,8 @@
 {
 	struct DeviceCtlBlk *i;
 	struct DeviceCtlBlk *tmp;
-	dprintkdbg(DBG_0, "adapter_remove_device: Remove device (ID %i, LUN %i): %p\n",
-		   dcb->target_id, dcb->target_lun, dcb);
+	dprintkdbg(DBG_0, "adapter_remove_device: <%02i-%i>\n",
+		dcb->target_id, dcb->target_lun);
 
 	/* fix up any pointers to this device that we have in the adapter */
 	if (acb->active_dcb == dcb)
@@ -3986,8 +3850,9 @@
 		struct DeviceCtlBlk *dcb)
 {
 	if (list_size(&dcb->srb_going_list) > 1) {
-		dprintkdbg(DBG_DCB, "adapter_remove_and_free_device: "
-		           "Won't remove because of %i active requests\n",
+		dprintkdbg(DBG_1, "adapter_remove_and_free_device: <%02i-%i> "
+		           "Won't remove because of %i active requests.\n",
+			   dcb->target_id, dcb->target_lun,
 			   list_size(&dcb->srb_going_list));
 		return;
 	}
@@ -4006,7 +3871,7 @@
 {
 	struct DeviceCtlBlk *dcb;
 	struct DeviceCtlBlk *tmp;
-	dprintkdbg(DBG_DCB, "adapter_remove_and_free_all_devices: Free all devices (%i devices)\n",
+	dprintkdbg(DBG_1, "adapter_remove_and_free_all_devices: num=%i\n",
 		   list_size(&acb->dcb_list));
 
 	list_for_each_entry_safe(dcb, tmp, &acb->dcb_list, list)
@@ -4303,7 +4168,7 @@
 		 * Load a set of defaults into the eeprom buffer
 		 */
 		dprintkl(KERN_WARNING,
-		       "EEProm checksum error: using default values and options.\n");
+			"EEProm checksum error: using default values and options.\n");
 		eeprom->sub_vendor_id[0] = (u8)PCI_VENDOR_ID_TEKRAM;
 		eeprom->sub_vendor_id[1] = (u8)(PCI_VENDOR_ID_TEKRAM >> 8);
 		eeprom->sub_sys_id[0] = (u8)PCI_DEVICE_ID_TEKRAM_TRMS1040;
@@ -4356,16 +4221,14 @@
 static void __init print_eeprom_settings(struct NvRamType *eeprom)
 {
 	dprintkl(KERN_INFO, "Used settings: AdapterID=%02i, Speed=%i(%02i.%01iMHz), dev_mode=0x%02x\n",
-	       eeprom->scsi_id,
-	       eeprom->target[0].period,
-	       clock_speed[eeprom->target[0].period] / 10,
-	       clock_speed[eeprom->target[0].period] % 10,
-	       eeprom->target[0].cfg0);
+		eeprom->scsi_id,
+		eeprom->target[0].period,
+		clock_speed[eeprom->target[0].period] / 10,
+		clock_speed[eeprom->target[0].period] % 10,
+		eeprom->target[0].cfg0);
 	dprintkl(KERN_INFO, "               AdaptMode=0x%02x, Tags=%i(%02i), DelayReset=%is\n",
-	       eeprom->channel_cfg,
-	       eeprom->max_tag,
-	       1 << eeprom->max_tag,
-	       eeprom->delay_time);
+		eeprom->channel_cfg, eeprom->max_tag,
+		1 << eeprom->max_tag, eeprom->delay_time);
 }
 
 
@@ -4405,7 +4268,7 @@
 			return 1;
 		}
 		dprintkdbg(DBG_1, "Allocate %li bytes at %p for SG segments %i\n",
-				  PAGE_SIZE, ptr, srb_idx);
+			PAGE_SIZE, ptr, srb_idx);
 		i = 0;
 		while (i < srbs_per_page && srb_idx < DC395x_MAX_SRB_CNT)
 			acb->srb_array[srb_idx++].segment_x =
@@ -4435,8 +4298,8 @@
 	u8 bval;
 
 	bval = DC395x_read8(acb, TRM_S1040_GEN_STATUS);
-	dprintkl(KERN_INFO, "%s Connectors: ",
-	       ((bval & WIDESCSI) ? "(Wide)" : ""));
+	dprintkl(KERN_INFO, "%sConnectors: ",
+		((bval & WIDESCSI) ? "(Wide) " : ""));
 	if (!(bval & CON5068))
 		printk("ext%s ", !(bval & EXT68HIGH) ? "68" : "50");
 	if (!(bval & CON68))
@@ -4667,11 +4530,11 @@
 	adapter_init_chip(acb);
 	set_basic_config(acb);
 
-	dprintkdbg(DBG_0, "adapter_init: acb=%p, pdcb_map=%p "
-	                  "psrb_array=%p ACB size=%04x, DCB size=%04x "
-	                  "SRB size=%04x\n",
-		   acb, acb->dcb_map, acb->srb_array, sizeof(struct AdapterCtlBlk),
-		   sizeof(struct DeviceCtlBlk), sizeof(struct ScsiReqBlk));
+	dprintkdbg(DBG_0,
+		"adapter_init: acb=%p, pdcb_map=%p psrb_array=%p "
+		"size{acb=0x%04x dcb=0x%04x srb=0x%04x}\n",
+		acb, acb->dcb_map, acb->srb_array, sizeof(struct AdapterCtlBlk),
+		sizeof(struct DeviceCtlBlk), sizeof(struct ScsiReqBlk));
 	return 0;
 
 failed:
@@ -4851,7 +4714,7 @@
 			SPRINTF("\n");
 	}
 
-	if (debug_enabled(DBG_DCB)) {
+	if (debug_enabled(DBG_1)) {
 		SPRINTF("DCB list for ACB %p:\n", acb);
 		list_for_each_entry(dcb, &acb->dcb_list, list) {
 			SPRINTF("%p -> ", dcb);
@@ -4953,7 +4816,7 @@
 
 	/* initialise the adapter and everything we need */
  	if (adapter_init(acb, io_port_base, io_port_len, irq)) {
-		dprintkl(KERN_INFO, "DC395x_initAdapter initial ERROR\n");
+		dprintkl(KERN_INFO, "adapter init failed\n");
 		scsi_host_put(scsi_host);
 		return -ENODEV;
 	}
@@ -4964,7 +4827,7 @@
 	if (scsi_add_host(scsi_host, &dev->dev)) {
 		dprintkl(KERN_ERR, "scsi_add_host failed\n");
 		adapter_uninit(acb);
-                scsi_host_put(scsi_host);
+		scsi_host_put(scsi_host);
 		return -ENODEV;
 	}
 	pci_set_drvdata(dev, scsi_host);
@@ -4985,7 +4848,7 @@
 	struct Scsi_Host *scsi_host = pci_get_drvdata(dev);
 	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)(scsi_host->hostdata);
 
-	dprintkdbg(DBG_0, "Removing instance\n");
+	dprintkdbg(DBG_0, "dc395x_remove_one: acb=%p\n", acb);
 
 	scsi_remove_host(scsi_host);
 	adapter_uninit(acb);

-- 
 Jamie Lenehan <lenehan@twibble.org>
