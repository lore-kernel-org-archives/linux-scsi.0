From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/4] scsi: remove cmd->serial_number litter
Date: Mon, 4 Apr 2011 09:42:14 -0400
Message-ID: <20110404134214.GA32522@infradead.org>
References: <20110404134203.GA29525@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32911 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab1DDNmP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2011 09:42:15 -0400
Content-Disposition: inline
In-Reply-To: <20110404134203.GA29525@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com

Stop using cmd->serial_number in printks.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/message/i2o/i2o_scsi.c
===================================================================
--- linux-2.6.orig/drivers/message/i2o/i2o_scsi.c	2011-04-02 07:11:59.896236655 -0700
+++ linux-2.6/drivers/message/i2o/i2o_scsi.c	2011-04-02 07:12:02.148236588 -0700
@@ -361,7 +361,7 @@ static int i2o_scsi_reply(struct i2o_con
 	 */
 	error = le32_to_cpu(msg->body[0]);
 
-	osm_debug("Completed %ld\n", cmd->serial_number);
+	osm_debug("Completed %0x%p\n", cmd);
 
 	cmd->result = error & 0xff;
 	/*
@@ -678,7 +678,7 @@ static int i2o_scsi_queuecommand_lck(str
 	/* Queue the message */
 	i2o_msg_post(c, msg);
 
-	osm_debug("Issued %ld\n", SCpnt->serial_number);
+	osm_debug("Issued %0x%p\n", SCpnt);
 
 	return 0;
 
Index: linux-2.6/drivers/scsi/dc395x.c
===================================================================
--- linux-2.6.orig/drivers/scsi/dc395x.c	2011-04-02 07:11:59.914741301 -0700
+++ linux-2.6/drivers/scsi/dc395x.c	2011-04-02 07:28:05.751735653 -0700
@@ -778,8 +778,8 @@ static void srb_free_insert(struct Adapt
 static void srb_waiting_insert(struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb)
 {
-	dprintkdbg(DBG_0, "srb_waiting_insert: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
+	dprintkdbg(DBG_0, "srb_waiting_insert: (0x%p) <%02i-%i> srb=%p\n",
+		srb->cmd, dcb->target_id, dcb->target_lun, srb);
 	list_add(&srb->list, &dcb->srb_waiting_list);
 }
 
@@ -787,16 +787,16 @@ static void srb_waiting_insert(struct De
 static void srb_waiting_append(struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb)
 {
-	dprintkdbg(DBG_0, "srb_waiting_append: (pid#%li) <%02i-%i> srb=%p\n",
-		 srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
+	dprintkdbg(DBG_0, "srb_waiting_append: (0x%p) <%02i-%i> srb=%p\n",
+		 srb->cmd, dcb->target_id, dcb->target_lun, srb);
 	list_add_tail(&srb->list, &dcb->srb_waiting_list);
 }
 
 
 static void srb_going_append(struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
 {
-	dprintkdbg(DBG_0, "srb_going_append: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
+	dprintkdbg(DBG_0, "srb_going_append: (0x%p) <%02i-%i> srb=%p\n",
+		srb->cmd, dcb->target_id, dcb->target_lun, srb);
 	list_add_tail(&srb->list, &dcb->srb_going_list);
 }
 
@@ -805,8 +805,8 @@ static void srb_going_remove(struct Devi
 {
 	struct ScsiReqBlk *i;
 	struct ScsiReqBlk *tmp;
-	dprintkdbg(DBG_0, "srb_going_remove: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
+	dprintkdbg(DBG_0, "srb_going_remove: (0x%p) <%02i-%i> srb=%p\n",
+		srb->cmd, dcb->target_id, dcb->target_lun, srb);
 
 	list_for_each_entry_safe(i, tmp, &dcb->srb_going_list, list)
 		if (i == srb) {
@@ -821,8 +821,8 @@ static void srb_waiting_remove(struct De
 {
 	struct ScsiReqBlk *i;
 	struct ScsiReqBlk *tmp;
-	dprintkdbg(DBG_0, "srb_waiting_remove: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
+	dprintkdbg(DBG_0, "srb_waiting_remove: (0x%p) <%02i-%i> srb=%p\n",
+		srb->cmd, dcb->target_id, dcb->target_lun, srb);
 
 	list_for_each_entry_safe(i, tmp, &dcb->srb_waiting_list, list)
 		if (i == srb) {
@@ -836,8 +836,8 @@ static void srb_going_to_waiting_move(st
 		struct ScsiReqBlk *srb)
 {
 	dprintkdbg(DBG_0,
-		"srb_going_to_waiting_move: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
+		"srb_going_to_waiting_move: (0x%p) <%02i-%i> srb=%p\n",
+		srb->cmd, dcb->target_id, dcb->target_lun, srb);
 	list_move(&srb->list, &dcb->srb_waiting_list);
 }
 
@@ -846,8 +846,8 @@ static void srb_waiting_to_going_move(st
 		struct ScsiReqBlk *srb)
 {
 	dprintkdbg(DBG_0,
-		"srb_waiting_to_going_move: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
+		"srb_waiting_to_going_move: (0x%p) <%02i-%i> srb=%p\n",
+		srb->cmd, dcb->target_id, dcb->target_lun, srb);
 	list_move(&srb->list, &dcb->srb_going_list);
 }
 
@@ -982,8 +982,8 @@ static void build_srb(struct scsi_cmnd *
 {
 	int nseg;
 	enum dma_data_direction dir = cmd->sc_data_direction;
-	dprintkdbg(DBG_0, "build_srb: (pid#%li) <%02i-%i>\n",
-		cmd->serial_number, dcb->target_id, dcb->target_lun);
+	dprintkdbg(DBG_0, "build_srb: (0x%p) <%02i-%i>\n",
+		cmd, dcb->target_id, dcb->target_lun);
 
 	srb->dcb = dcb;
 	srb->cmd = cmd;
@@ -1086,8 +1086,8 @@ static int dc395x_queue_command_lck(stru
 	struct ScsiReqBlk *srb;
 	struct AdapterCtlBlk *acb =
 	    (struct AdapterCtlBlk *)cmd->device->host->hostdata;
-	dprintkdbg(DBG_0, "queue_command: (pid#%li) <%02i-%i> cmnd=0x%02x\n",
-		cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+	dprintkdbg(DBG_0, "queue_command: (0x%p) <%02i-%i> cmnd=0x%02x\n",
+		cmd, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 
 	/* Assume BAD_TARGET; will be cleared later */
 	cmd->result = DID_BAD_TARGET << 16;
@@ -1140,7 +1140,7 @@ static int dc395x_queue_command_lck(stru
 		/* process immediately */
 		send_srb(acb, srb);
 	}
-	dprintkdbg(DBG_1, "queue_command: (pid#%li) done\n", cmd->serial_number);
+	dprintkdbg(DBG_1, "queue_command: (0x%p) done\n", cmd);
 	return 0;
 
 complete:
@@ -1203,9 +1203,9 @@ static void dump_register_info(struct Ad
 			dprintkl(KERN_INFO, "dump: srb=%p cmd=%p OOOPS!\n",
 				srb, srb->cmd);
 		else
-			dprintkl(KERN_INFO, "dump: srb=%p cmd=%p (pid#%li) "
+			dprintkl(KERN_INFO, "dump: srb=%p cmd=%p "
 				 "cmnd=0x%02x <%02i-%i>\n",
-				srb, srb->cmd, srb->cmd->serial_number,
+				srb, srb->cmd,
 				srb->cmd->cmnd[0], srb->cmd->device->id,
 			       	srb->cmd->device->lun);
 		printk("  sglist=%p cnt=%i idx=%i len=%zu\n",
@@ -1301,8 +1301,8 @@ static int __dc395x_eh_bus_reset(struct
 	struct AdapterCtlBlk *acb =
 		(struct AdapterCtlBlk *)cmd->device->host->hostdata;
 	dprintkl(KERN_INFO,
-		"eh_bus_reset: (pid#%li) target=<%02i-%i> cmd=%p\n",
-		cmd->serial_number, cmd->device->id, cmd->device->lun, cmd);
+		"eh_bus_reset: (0%p) target=<%02i-%i> cmd=%p\n",
+		cmd, cmd->device->id, cmd->device->lun, cmd);
 
 	if (timer_pending(&acb->waiting_timer))
 		del_timer(&acb->waiting_timer);
@@ -1368,8 +1368,8 @@ static int dc395x_eh_abort(struct scsi_c
 	    (struct AdapterCtlBlk *)cmd->device->host->hostdata;
 	struct DeviceCtlBlk *dcb;
 	struct ScsiReqBlk *srb;
-	dprintkl(KERN_INFO, "eh_abort: (pid#%li) target=<%02i-%i> cmd=%p\n",
-		cmd->serial_number, cmd->device->id, cmd->device->lun, cmd);
+	dprintkl(KERN_INFO, "eh_abort: (0x%p) target=<%02i-%i> cmd=%p\n",
+		cmd, cmd->device->id, cmd->device->lun, cmd);
 
 	dcb = find_dcb(acb, cmd->device->id, cmd->device->lun);
 	if (!dcb) {
@@ -1495,8 +1495,8 @@ static u8 start_scsi(struct AdapterCtlBl
 	u16 s_stat2, return_code;
 	u8 s_stat, scsicommand, i, identify_message;
 	u8 *ptr;
-	dprintkdbg(DBG_0, "start_scsi: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
+	dprintkdbg(DBG_0, "start_scsi: (0x%p) <%02i-%i> srb=%p\n",
+		dcb->target_id, dcb->target_lun, srb);
 
 	srb->tag_number = TAG_NONE;	/* acb->tag_max_num: had error read in eeprom */
 
@@ -1505,8 +1505,8 @@ static u8 start_scsi(struct AdapterCtlBl
 	s_stat2 = DC395x_read16(acb, TRM_S1040_SCSI_STATUS);
 #if 1
 	if (s_stat & 0x20 /* s_stat2 & 0x02000 */ ) {
-		dprintkdbg(DBG_KG, "start_scsi: (pid#%li) BUSY %02x %04x\n",
-			srb->cmd->serial_number, s_stat, s_stat2);
+		dprintkdbg(DBG_KG, "start_scsi: (0x%p) BUSY %02x %04x\n",
+			s_stat, s_stat2);
 		/*
 		 * Try anyway?
 		 *
@@ -1522,16 +1522,15 @@ static u8 start_scsi(struct AdapterCtlBl
 	}
 #endif
 	if (acb->active_dcb) {
-		dprintkl(KERN_DEBUG, "start_scsi: (pid#%li) Attempt to start a"
-			"command while another command (pid#%li) is active.",
-			srb->cmd->serial_number,
+		dprintkl(KERN_DEBUG, "start_scsi: (0x%p) Attempt to start a"
+			"command while another command (0x%p) is active.",
+			srb->cmd,
 			acb->active_dcb->active_srb ?
-			    acb->active_dcb->active_srb->cmd->serial_number : 0);
+			    acb->active_dcb->active_srb->cmd : 0);
 		return 1;
 	}
 	if (DC395x_read16(acb, TRM_S1040_SCSI_STATUS) & SCSIINTERRUPT) {
-		dprintkdbg(DBG_KG, "start_scsi: (pid#%li) Failed (busy)\n",
-			srb->cmd->serial_number);
+		dprintkdbg(DBG_KG, "start_scsi: (0x%p) Failed (busy)\n", srb->cmd);
 		return 1;
 	}
 	/* Allow starting of SCSI commands half a second before we allow the mid-level
@@ -1603,9 +1602,9 @@ static u8 start_scsi(struct AdapterCtlBl
 			tag_number++;
 		}
 		if (tag_number >= dcb->max_command) {
-			dprintkl(KERN_WARNING, "start_scsi: (pid#%li) "
+			dprintkl(KERN_WARNING, "start_scsi: (0x%p) "
 				"Out of tags target=<%02i-%i>)\n",
-				srb->cmd->serial_number, srb->cmd->device->id,
+				srb->cmd, srb->cmd->device->id,
 				srb->cmd->device->lun);
 			srb->state = SRB_READY;
 			DC395x_write16(acb, TRM_S1040_SCSI_CONTROL,
@@ -1623,8 +1622,8 @@ static u8 start_scsi(struct AdapterCtlBl
 #endif
 /*polling:*/
 	/* Send CDB ..command block ......... */
-	dprintkdbg(DBG_KG, "start_scsi: (pid#%li) <%02i-%i> cmnd=0x%02x tag=%i\n",
-		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun,
+	dprintkdbg(DBG_KG, "start_scsi: (0x%p) <%02i-%i> cmnd=0x%02x tag=%i\n",
+		srb->cmd, srb->cmd->device->id, srb->cmd->device->lun,
 		srb->cmd->cmnd[0], srb->tag_number);
 	if (srb->flag & AUTO_REQSENSE) {
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, REQUEST_SENSE);
@@ -1647,8 +1646,8 @@ static u8 start_scsi(struct AdapterCtlBl
 		 * we caught an interrupt (must be reset or reselection ... )
 		 * : Let's process it first!
 		 */
-		dprintkdbg(DBG_0, "start_scsi: (pid#%li) <%02i-%i> Failed - busy\n",
-			srb->cmd->serial_number, dcb->target_id, dcb->target_lun);
+		dprintkdbg(DBG_0, "start_scsi: (0x%p) <%02i-%i> Failed - busy\n",
+			srb->cmd, dcb->target_id, dcb->target_lun);
 		srb->state = SRB_READY;
 		free_tag(dcb, srb);
 		srb->msg_count = 0;
@@ -1843,7 +1842,7 @@ static irqreturn_t dc395x_interrupt(int
 static void msgout_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "msgout_phase0: (pid#%li)\n", srb->cmd->serial_number);
+	dprintkdbg(DBG_0, "msgout_phase0: (0x%p)\n", srb->cmd);
 	if (srb->state & (SRB_UNEXPECT_RESEL + SRB_ABORT_SENT))
 		*pscsi_status = PH_BUS_FREE;	/*.. initial phase */
 
@@ -1857,18 +1856,18 @@ static void msgout_phase1(struct Adapter
 {
 	u16 i;
 	u8 *ptr;
-	dprintkdbg(DBG_0, "msgout_phase1: (pid#%li)\n", srb->cmd->serial_number);
+	dprintkdbg(DBG_0, "msgout_phase1: (0x%p)\n", srb->cmd);
 
 	clear_fifo(acb, "msgout_phase1");
 	if (!(srb->state & SRB_MSGOUT)) {
 		srb->state |= SRB_MSGOUT;
 		dprintkl(KERN_DEBUG,
-			"msgout_phase1: (pid#%li) Phase unexpected\n",
-			srb->cmd->serial_number);	/* So what ? */
+			"msgout_phase1: (0x%p) Phase unexpected\n",
+			srb->cmd);	/* So what ? */
 	}
 	if (!srb->msg_count) {
-		dprintkdbg(DBG_0, "msgout_phase1: (pid#%li) NOP msg\n",
-			srb->cmd->serial_number);
+		dprintkdbg(DBG_0, "msgout_phase1: (0x%p) NOP msg\n",
+			srb->cmd);
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, MSG_NOP);
 		DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
 		DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_FIFO_OUT);
@@ -1888,7 +1887,7 @@ static void msgout_phase1(struct Adapter
 static void command_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "command_phase0: (pid#%li)\n", srb->cmd->serial_number);
+	dprintkdbg(DBG_0, "command_phase0: (0x%p)\n", srb->cmd);
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);
 }
 
@@ -1899,7 +1898,7 @@ static void command_phase1(struct Adapte
 	struct DeviceCtlBlk *dcb;
 	u8 *ptr;
 	u16 i;
-	dprintkdbg(DBG_0, "command_phase1: (pid#%li)\n", srb->cmd->serial_number);
+	dprintkdbg(DBG_0, "command_phase1: (0x%p)\n", srb->cmd);
 
 	clear_fifo(acb, "command_phase1");
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_CLRATN);
@@ -2041,8 +2040,8 @@ static void data_out_phase0(struct Adapt
 	struct DeviceCtlBlk *dcb = srb->dcb;
 	u16 scsi_status = *pscsi_status;
 	u32 d_left_counter = 0;
-	dprintkdbg(DBG_0, "data_out_phase0: (pid#%li) <%02i-%i>\n",
-		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun);
+	dprintkdbg(DBG_0, "data_out_phase0: (0x%p) <%02i-%i>\n",
+		srb->cmd, srb->cmd->device->id, srb->cmd->device->lun);
 
 	/*
 	 * KG: We need to drain the buffers before we draw any conclusions!
@@ -2171,8 +2170,8 @@ static void data_out_phase0(struct Adapt
 static void data_out_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "data_out_phase1: (pid#%li) <%02i-%i>\n",
-		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun);
+	dprintkdbg(DBG_0, "data_out_phase1: (0x%p) <%02i-%i>\n",
+		srb->cmd, srb->cmd->device->id, srb->cmd->device->lun);
 	clear_fifo(acb, "data_out_phase1");
 	/* do prepare before transfer when data out phase */
 	data_io_transfer(acb, srb, XFERDATAOUT);
@@ -2183,8 +2182,8 @@ static void data_in_phase0(struct Adapte
 {
 	u16 scsi_status = *pscsi_status;
 
-	dprintkdbg(DBG_0, "data_in_phase0: (pid#%li) <%02i-%i>\n",
-		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun);
+	dprintkdbg(DBG_0, "data_in_phase0: (0x%p) <%02i-%i>\n",
+		srb->cmd, srb->cmd->device->id, srb->cmd->device->lun);
 
 	/*
 	 * KG: DataIn is much more tricky than DataOut. When the device is finished
@@ -2204,8 +2203,8 @@ static void data_in_phase0(struct Adapte
 		unsigned int sc, fc;
 
 		if (scsi_status & PARITYERROR) {
-			dprintkl(KERN_INFO, "data_in_phase0: (pid#%li) "
-				"Parity Error\n", srb->cmd->serial_number);
+			dprintkl(KERN_INFO, "data_in_phase0: (0x%p) "
+				"Parity Error\n", srb->cmd);
 			srb->status |= PARITY_ERROR;
 		}
 		/*
@@ -2394,8 +2393,8 @@ static void data_in_phase0(struct Adapte
 static void data_in_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "data_in_phase1: (pid#%li) <%02i-%i>\n",
-		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun);
+	dprintkdbg(DBG_0, "data_in_phase1: (0x%p) <%02i-%i>\n",
+		srb->cmd, srb->cmd->device->id, srb->cmd->device->lun);
 	data_io_transfer(acb, srb, XFERDATAIN);
 }
 
@@ -2406,8 +2405,8 @@ static void data_io_transfer(struct Adap
 	struct DeviceCtlBlk *dcb = srb->dcb;
 	u8 bval;
 	dprintkdbg(DBG_0,
-		"data_io_transfer: (pid#%li) <%02i-%i> %c len=%i, sg=(%i/%i)\n",
-		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun,
+		"data_io_transfer: (0x%p) <%02i-%i> %c len=%i, sg=(%i/%i)\n",
+		srb->cmd, srb->cmd->device->id, srb->cmd->device->lun,
 		((io_dir & DMACMD_DIR) ? 'r' : 'w'),
 		srb->total_xfer_length, srb->sg_index, srb->sg_count);
 	if (srb == acb->tmp_srb)
@@ -2579,8 +2578,8 @@ static void data_io_transfer(struct Adap
 static void status_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "status_phase0: (pid#%li) <%02i-%i>\n",
-		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun);
+	dprintkdbg(DBG_0, "status_phase0: (0x%p) <%02i-%i>\n",
+		srb->cmd, srb->cmd->device->id, srb->cmd->device->lun);
 	srb->target_status = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 	srb->end_message = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);	/* get message */
 	srb->state = SRB_COMPLETED;
@@ -2593,8 +2592,8 @@ static void status_phase0(struct Adapter
 static void status_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "status_phase1: (pid#%li) <%02i-%i>\n",
-		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun);
+	dprintkdbg(DBG_0, "status_phase1: (0x%p) <%02i-%i>\n",
+		srb->cmd, srb->cmd->device->id, srb->cmd->device->lun);
 	srb->state = SRB_STATUS;
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
 	DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_COMP);
@@ -2635,8 +2634,8 @@ static struct ScsiReqBlk *msgin_qtag(str
 {
 	struct ScsiReqBlk *srb = NULL;
 	struct ScsiReqBlk *i;
-	dprintkdbg(DBG_0, "msgin_qtag: (pid#%li) tag=%i srb=%p\n",
-		   srb->cmd->serial_number, tag, srb);
+	dprintkdbg(DBG_0, "msgin_qtag: (0x%p) tag=%i srb=%p\n",
+		   srb->cmd, tag, srb);
 
 	if (!(dcb->tag_mask & (1 << tag)))
 		dprintkl(KERN_DEBUG,
@@ -2654,8 +2653,8 @@ static struct ScsiReqBlk *msgin_qtag(str
 	if (!srb)
 		goto mingx0;
 
-	dprintkdbg(DBG_0, "msgin_qtag: (pid#%li) <%02i-%i>\n",
-		srb->cmd->serial_number, srb->dcb->target_id, srb->dcb->target_lun);
+	dprintkdbg(DBG_0, "msgin_qtag: (0x%p) <%02i-%i>\n",
+		srb->cmd, srb->dcb->target_id, srb->dcb->target_lun);
 	if (dcb->flag & ABORT_DEV_) {
 		/*srb->state = SRB_ABORT_SENT; */
 		enable_msgout_abort(acb, srb);
@@ -2865,7 +2864,7 @@ static void msgin_phase0(struct AdapterC
 		u16 *pscsi_status)
 {
 	struct DeviceCtlBlk *dcb = acb->active_dcb;
-	dprintkdbg(DBG_0, "msgin_phase0: (pid#%li)\n", srb->cmd->serial_number);
+	dprintkdbg(DBG_0, "msgin_phase0: (0x%p)\n", srb->cmd);
 
 	srb->msgin_buf[acb->msg_len++] = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 	if (msgin_completed(srb->msgin_buf, acb->msg_len)) {
@@ -2931,9 +2930,9 @@ static void msgin_phase0(struct AdapterC
 			 * SAVE POINTER may be ignored as we have the struct
 			 * ScsiReqBlk* associated with the scsi command.
 			 */
-			dprintkdbg(DBG_0, "msgin_phase0: (pid#%li) "
+			dprintkdbg(DBG_0, "msgin_phase0: (0x%p) "
 				"SAVE POINTER rem=%i Ignore\n",
-				srb->cmd->serial_number, srb->total_xfer_length);
+				srb->cmd, srb->total_xfer_length);
 			break;
 
 		case RESTORE_POINTERS:
@@ -2941,9 +2940,9 @@ static void msgin_phase0(struct AdapterC
 			break;
 
 		case ABORT:
-			dprintkdbg(DBG_0, "msgin_phase0: (pid#%li) "
+			dprintkdbg(DBG_0, "msgin_phase0: (0x%p) "
 				"<%02i-%i> ABORT msg\n",
-				srb->cmd->serial_number, dcb->target_id,
+				srb->cmd, dcb->target_id,
 				dcb->target_lun);
 			dcb->flag |= ABORT_DEV_;
 			enable_msgout_abort(acb, srb);
@@ -2975,7 +2974,7 @@ static void msgin_phase0(struct AdapterC
 static void msgin_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "msgin_phase1: (pid#%li)\n", srb->cmd->serial_number);
+	dprintkdbg(DBG_0, "msgin_phase1: (0x%p)\n", srb->cmd);
 	clear_fifo(acb, "msgin_phase1");
 	DC395x_write32(acb, TRM_S1040_SCSI_COUNTER, 1);
 	if (!(srb->state & SRB_MSGIN)) {
@@ -3041,7 +3040,7 @@ static void disconnect(struct AdapterCtl
 	}
 	srb = dcb->active_srb;
 	acb->active_dcb = NULL;
-	dprintkdbg(DBG_0, "disconnect: (pid#%li)\n", srb->cmd->serial_number);
+	dprintkdbg(DBG_0, "disconnect: (0x%p)\n", srb->cmd);
 
 	srb->scsi_phase = PH_BUS_FREE;	/* initial phase */
 	clear_fifo(acb, "disconnect");
@@ -3071,14 +3070,14 @@ static void disconnect(struct AdapterCtl
 			    && srb->state != SRB_MSGOUT) {
 				srb->state = SRB_READY;
 				dprintkl(KERN_DEBUG,
-					"disconnect: (pid#%li) Unexpected\n",
-					srb->cmd->serial_number);
+					"disconnect: (0x%p) Unexpected\n",
+					srb->cmd);
 				srb->target_status = SCSI_STAT_SEL_TIMEOUT;
 				goto disc1;
 			} else {
 				/* Normal selection timeout */
-				dprintkdbg(DBG_KG, "disconnect: (pid#%li) "
-					"<%02i-%i> SelTO\n", srb->cmd->serial_number,
+				dprintkdbg(DBG_KG, "disconnect: (0x%p) "
+					"<%02i-%i> SelTO\n", srb->cmd,
 					dcb->target_id, dcb->target_lun);
 				if (srb->retry_count++ > DC395x_MAX_RETRIES
 				    || acb->scan_devices) {
@@ -3089,8 +3088,8 @@ static void disconnect(struct AdapterCtl
 				free_tag(dcb, srb);
 				srb_going_to_waiting_move(dcb, srb);
 				dprintkdbg(DBG_KG,
-					"disconnect: (pid#%li) Retry\n",
-					srb->cmd->serial_number);
+					"disconnect: (0x%p) Retry\n",
+					srb->cmd);
 				waiting_set_timer(acb, HZ / 20);
 			}
 		} else if (srb->state & SRB_DISCONNECT) {
@@ -3142,9 +3141,9 @@ static void reselect(struct AdapterCtlBl
 		}
 		/* Why the if ? */
 		if (!acb->scan_devices) {
-			dprintkdbg(DBG_KG, "reselect: (pid#%li) <%02i-%i> "
+			dprintkdbg(DBG_KG, "reselect: (0x%p) <%02i-%i> "
 				"Arb lost but Resel win rsel=%i stat=0x%04x\n",
-				srb->cmd->serial_number, dcb->target_id,
+				srb->cmd, dcb->target_id,
 				dcb->target_lun, rsel_tar_lun_id,
 				DC395x_read16(acb, TRM_S1040_SCSI_STATUS));
 			arblostflag = 1;
@@ -3318,7 +3317,7 @@ static void srb_done(struct AdapterCtlBl
 	enum dma_data_direction dir = cmd->sc_data_direction;
 	int ckc_only = 1;
 
-	dprintkdbg(DBG_1, "srb_done: (pid#%li) <%02i-%i>\n", srb->cmd->serial_number,
+	dprintkdbg(DBG_1, "srb_done: (0x%p) <%02i-%i>\n", srb->cmd,
 		srb->cmd->device->id, srb->cmd->device->lun);
 	dprintkdbg(DBG_SG, "srb_done: srb=%p sg=%i(%i/%i) buf=%p\n",
 		   srb, scsi_sg_count(cmd), srb->sg_index, srb->sg_count,
@@ -3497,9 +3496,9 @@ static void srb_done(struct AdapterCtlBl
 	cmd->SCp.buffers_residual = 0;
 	if (debug_enabled(DBG_KG)) {
 		if (srb->total_xfer_length)
-			dprintkdbg(DBG_KG, "srb_done: (pid#%li) <%02i-%i> "
+			dprintkdbg(DBG_KG, "srb_done: (0x%p) <%02i-%i> "
 				"cmnd=0x%02x Missed %i bytes\n",
-				cmd->serial_number, cmd->device->id, cmd->device->lun,
+				cmd, cmd->device->id, cmd->device->lun,
 				cmd->cmnd[0], srb->total_xfer_length);
 	}
 
@@ -3508,8 +3507,8 @@ static void srb_done(struct AdapterCtlBl
 	if (srb == acb->tmp_srb)
 		dprintkl(KERN_ERR, "srb_done: ERROR! Completed cmd with tmp_srb\n");
 	else {
-		dprintkdbg(DBG_0, "srb_done: (pid#%li) done result=0x%08x\n",
-			cmd->serial_number, cmd->result);
+		dprintkdbg(DBG_0, "srb_done: (0x%p) done result=0x%08x\n",
+			cmd, cmd->result);
 		srb_free_insert(acb, srb);
 	}
 	pci_unmap_srb(acb, srb);
@@ -3538,7 +3537,7 @@ static void doing_srb_done(struct Adapte
 			p = srb->cmd;
 			dir = p->sc_data_direction;
 			result = MK_RES(0, did_flag, 0, 0);
-			printk("G:%li(%02i-%i) ", p->serial_number,
+			printk("G:%p(%02i-%i) ", p,
 			       p->device->id, p->device->lun);
 			srb_going_remove(dcb, srb);
 			free_tag(dcb, srb);
@@ -3568,7 +3567,7 @@ static void doing_srb_done(struct Adapte
 			p = srb->cmd;
 
 			result = MK_RES(0, did_flag, 0, 0);
-			printk("W:%li<%02i-%i>", p->serial_number, p->device->id,
+			printk("W:%p<%02i-%i>", p, p->device->id,
 			       p->device->lun);
 			srb_waiting_remove(dcb, srb);
 			srb_free_insert(acb, srb);
@@ -3677,8 +3676,8 @@ static void request_sense(struct Adapter
 		struct ScsiReqBlk *srb)
 {
 	struct scsi_cmnd *cmd = srb->cmd;
-	dprintkdbg(DBG_1, "request_sense: (pid#%li) <%02i-%i>\n",
-		cmd->serial_number, cmd->device->id, cmd->device->lun);
+	dprintkdbg(DBG_1, "request_sense: (0x%p) <%02i-%i>\n",
+		cmd, cmd->device->id, cmd->device->lun);
 
 	srb->flag |= AUTO_REQSENSE;
 	srb->adapter_status = 0;
@@ -3708,8 +3707,8 @@ static void request_sense(struct Adapter
 
 	if (start_scsi(acb, dcb, srb)) {	/* Should only happen, if sb. else grabs the bus */
 		dprintkl(KERN_DEBUG,
-			"request_sense: (pid#%li) failed <%02i-%i>\n",
-			srb->cmd->serial_number, dcb->target_id, dcb->target_lun);
+			"request_sense: (0x%p) failed <%02i-%i>\n",
+			srb->cmd, dcb->target_id, dcb->target_lun);
 		srb_going_to_waiting_move(dcb, srb);
 		waiting_set_timer(acb, HZ / 100);
 	}
@@ -4717,13 +4716,13 @@ static int dc395x_proc_info(struct Scsi_
 				dcb->target_id, dcb->target_lun,
 				list_size(&dcb->srb_waiting_list));
                 list_for_each_entry(srb, &dcb->srb_waiting_list, list)
-			SPRINTF(" %li", srb->cmd->serial_number);
+			SPRINTF(" %p", srb->cmd);
 		if (!list_empty(&dcb->srb_going_list))
 			SPRINTF("\nDCB (%02i-%i): Going  : %i:",
 				dcb->target_id, dcb->target_lun,
 				list_size(&dcb->srb_going_list));
 		list_for_each_entry(srb, &dcb->srb_going_list, list)
-			SPRINTF(" %li", srb->cmd->serial_number);
+			SPRINTF(" %p", srb->cmd);
 		if (!list_empty(&dcb->srb_waiting_list) || !list_empty(&dcb->srb_going_list))
 			SPRINTF("\n");
 	}
Index: linux-2.6/drivers/scsi/eata_pio.c
===================================================================
--- linux-2.6.orig/drivers/scsi/eata_pio.c	2011-04-02 07:11:59.918736723 -0700
+++ linux-2.6/drivers/scsi/eata_pio.c	2011-04-02 07:12:02.156235982 -0700
@@ -372,8 +372,7 @@ static int eata_pio_queue_lck(struct scs
 	cp->status = USED;	/* claim free slot */
 
 	DBG(DBG_QUEUE, scmd_printk(KERN_DEBUG, cmd,
-		"eata_pio_queue pid %ld, y %d\n",
-		cmd->serial_number, y));
+		"eata_pio_queue 0x%p, y %d\n", cmd, y));
 
 	cmd->scsi_done = (void *) done;
 
@@ -417,8 +416,8 @@ static int eata_pio_queue_lck(struct scs
 	if (eata_pio_send_command(base, EATA_CMD_PIO_SEND_CP)) {
 		cmd->result = DID_BUS_BUSY << 16;
 		scmd_printk(KERN_NOTICE, cmd,
-			"eata_pio_queue pid %ld, HBA busy, "
-			"returning DID_BUS_BUSY, done.\n", cmd->serial_number);
+			"eata_pio_queue pid 0x%p, HBA busy, "
+			"returning DID_BUS_BUSY, done.\n", cmd);
 		done(cmd);
 		cp->status = FREE;
 		return 0;
@@ -432,8 +431,8 @@ static int eata_pio_queue_lck(struct scs
 		outw(0, base + HA_RDATA);
 
 	DBG(DBG_QUEUE, scmd_printk(KERN_DEBUG, cmd,
-		"Queued base %#.4lx pid: %ld "
-		"slot %d irq %d\n", sh->base, cmd->serial_number, y, sh->irq));
+		"Queued base %#.4lx cmd: 0x%p "
+		"slot %d irq %d\n", sh->base, cmd, y, sh->irq));
 
 	return 0;
 }
@@ -445,8 +444,7 @@ static int eata_pio_abort(struct scsi_cm
 	unsigned int loop = 100;
 
 	DBG(DBG_ABNORM, scmd_printk(KERN_WARNING, cmd,
-		"eata_pio_abort called pid: %ld\n",
-		cmd->serial_number));
+		"eata_pio_abort called pid: 0x%p\n", cmd));
 
 	while (inb(cmd->device->host->base + HA_RAUXSTAT) & HA_ABUSY)
 		if (--loop == 0) {
@@ -481,8 +479,7 @@ static int eata_pio_host_reset(struct sc
 	struct Scsi_Host *host = cmd->device->host;
 
 	DBG(DBG_ABNORM, scmd_printk(KERN_WARNING, cmd,
-		"eata_pio_reset called pid:%ld\n",
-		cmd->serial_number));
+		"eata_pio_reset called\n"));
 
 	spin_lock_irq(host->host_lock);
 
@@ -501,7 +498,7 @@ static int eata_pio_host_reset(struct sc
 
 		sp = HD(cmd)->ccb[x].cmd;
 		HD(cmd)->ccb[x].status = RESET;
-		printk(KERN_WARNING "eata_pio_reset: slot %d in reset, pid %ld.\n", x, sp->serial_number);
+		printk(KERN_WARNING "eata_pio_reset: slot %d in reset.\n", x);
 
 		if (sp == NULL)
 			panic("eata_pio_reset: slot %d, sp==NULL.\n", x);
Index: linux-2.6/drivers/scsi/u14-34f.c
===================================================================
--- linux-2.6.orig/drivers/scsi/u14-34f.c	2011-04-02 07:11:59.926737150 -0700
+++ linux-2.6/drivers/scsi/u14-34f.c	2011-04-02 07:12:02.160236365 -0700
@@ -1256,8 +1256,8 @@ static int u14_34f_queuecommand_lck(stru
    j = ((struct hostdata *) SCpnt->device->host->hostdata)->board_number;
 
    if (SCpnt->host_scribble)
-      panic("%s: qcomm, pid %ld, SCpnt %p already active.\n",
-            BN(j), SCpnt->serial_number, SCpnt);
+      panic("%s: qcomm, SCpnt %p already active.\n",
+            BN(j), SCpnt);
 
    /* i is the mailbox number, look for the first free mailbox
       starting from last_cp_used */
@@ -1286,9 +1286,9 @@ static int u14_34f_queuecommand_lck(stru
    cpp->cpp_index = i;
    SCpnt->host_scribble = (unsigned char *) &cpp->cpp_index;
 
-   if (do_trace) printk("%s: qcomm, mbox %d, target %d.%d:%d, pid %ld.\n",
+   if (do_trace) printk("%s: qcomm, mbox %d, target %d.%d:%d.\n",
                         BN(j), i, SCpnt->device->channel, SCpnt->device->id,
-                        SCpnt->device->lun, SCpnt->serial_number);
+                        SCpnt->device->lun);
 
    cpp->opcode = OP_SCSI;
    cpp->channel = SCpnt->device->channel;
@@ -1315,7 +1315,7 @@ static int u14_34f_queuecommand_lck(stru
       unmap_dma(i, j);
       SCpnt->host_scribble = NULL;
       scmd_printk(KERN_INFO, SCpnt,
-      		"qcomm, pid %ld, adapter busy.\n", SCpnt->serial_number);
+      		"qcomm, adapter busy.\n");
       return 1;
       }
 
@@ -1337,14 +1337,12 @@ static int u14_34f_eh_abort(struct scsi_
    j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;
 
    if (SCarg->host_scribble == NULL) {
-      scmd_printk(KERN_INFO, SCarg, "abort, pid %ld inactive.\n",
-             SCarg->serial_number);
+      scmd_printk(KERN_INFO, SCarg, "abort, command inactive.\n");
       return SUCCESS;
       }
 
    i = *(unsigned int *)SCarg->host_scribble;
-   scmd_printk(KERN_INFO, SCarg, "abort, mbox %d, pid %ld.\n",
-	       i, SCarg->serial_number);
+   scmd_printk(KERN_INFO, SCarg, "abort, mbox %d.\n", i);
 
    if (i >= sh[j]->can_queue)
       panic("%s: abort, invalid SCarg->host_scribble.\n", BN(j));
@@ -1387,8 +1385,7 @@ static int u14_34f_eh_abort(struct scsi_
       SCarg->result = DID_ABORT << 16;
       SCarg->host_scribble = NULL;
       HD(j)->cp_stat[i] = FREE;
-      printk("%s, abort, mbox %d ready, DID_ABORT, pid %ld done.\n",
-             BN(j), i, SCarg->serial_number);
+      printk("%s, abort, mbox %d ready, DID_ABORT, done.\n", BN(j), i);
       SCarg->scsi_done(SCarg);
       return SUCCESS;
       }
@@ -1403,12 +1400,12 @@ static int u14_34f_eh_host_reset(struct
    struct scsi_cmnd *SCpnt;
 
    j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;
-   scmd_printk(KERN_INFO, SCarg, "reset, enter, pid %ld.\n", SCarg->serial_number);
+   scmd_printk(KERN_INFO, SCarg, "reset, enter.\n");
 
    spin_lock_irq(sh[j]->host_lock);
 
    if (SCarg->host_scribble == NULL)
-      printk("%s: reset, pid %ld inactive.\n", BN(j), SCarg->serial_number);
+      printk("%s: reset, inactive.\n", BN(j));
 
    if (HD(j)->in_reset) {
       printk("%s: reset, exit, already in reset.\n", BN(j));
@@ -1445,14 +1442,12 @@ static int u14_34f_eh_host_reset(struct
 
       if (HD(j)->cp_stat[i] == READY || HD(j)->cp_stat[i] == ABORTING) {
          HD(j)->cp_stat[i] = ABORTING;
-         printk("%s: reset, mbox %d aborting, pid %ld.\n",
-                BN(j), i, SCpnt->serial_number);
+         printk("%s: reset, mbox %d aborting.\n", BN(j), i);
          }
 
       else {
          HD(j)->cp_stat[i] = IN_RESET;
-         printk("%s: reset, mbox %d in reset, pid %ld.\n",
-                BN(j), i, SCpnt->serial_number);
+         printk("%s: reset, mbox %d in reset.\n", BN(j), i);
          }
 
       if (SCpnt->host_scribble == NULL)
@@ -1500,8 +1495,7 @@ static int u14_34f_eh_host_reset(struct
          /* This mailbox is still waiting for its interrupt */
          HD(j)->cp_stat[i] = LOCKED;
 
-         printk("%s, reset, mbox %d locked, DID_RESET, pid %ld done.\n",
-                BN(j), i, SCpnt->serial_number);
+         printk("%s, reset, mbox %d locked, DID_RESET, done.\n", BN(j), i);
          }
 
       else if (HD(j)->cp_stat[i] == ABORTING) {
@@ -1513,8 +1507,7 @@ static int u14_34f_eh_host_reset(struct
          /* This mailbox was never queued to the adapter */
          HD(j)->cp_stat[i] = FREE;
 
-         printk("%s, reset, mbox %d aborting, DID_RESET, pid %ld done.\n",
-                BN(j), i, SCpnt->serial_number);
+         printk("%s, reset, mbox %d aborting, DID_RESET, done.\n", BN(j), i);
          }
 
       else
@@ -1528,7 +1521,7 @@ static int u14_34f_eh_host_reset(struct
    HD(j)->in_reset = FALSE;
    do_trace = FALSE;
 
-   if (arg_done) printk("%s: reset, exit, pid %ld done.\n", BN(j), SCarg->serial_number);
+   if (arg_done) printk("%s: reset, exit, done.\n", BN(j));
    else          printk("%s: reset, exit.\n", BN(j));
 
    spin_unlock_irq(sh[j]->host_lock);
@@ -1671,10 +1664,10 @@ static int reorder(unsigned int j, unsig
    if (link_statistics && (overlap || !(flushcount % link_statistics)))
       for (n = 0; n < n_ready; n++) {
          k = il[n]; cpp = &HD(j)->cp[k]; SCpnt = cpp->SCpnt;
-         printk("%s %d.%d:%d pid %ld mb %d fc %d nr %d sec %ld ns %u"\
+         printk("%s %d.%d:%d mb %d fc %d nr %d sec %ld ns %u"\
                 " cur %ld s:%c r:%c rev:%c in:%c ov:%c xd %d.\n",
                 (ihdlr ? "ihdlr" : "qcomm"), SCpnt->channel, SCpnt->target,
-                SCpnt->lun, SCpnt->serial_number, k, flushcount, n_ready,
+                SCpnt->lun, k, flushcount, n_ready,
                 blk_rq_pos(SCpnt->request), blk_rq_sectors(SCpnt->request),
 		cursec, YESNO(s), YESNO(r), YESNO(rev), YESNO(input_only),
                 YESNO(overlap), cpp->xdir);
@@ -1709,9 +1702,9 @@ static void flush_dev(struct scsi_device
 
       if (wait_on_busy(sh[j]->io_port, MAXLOOP)) {
          scmd_printk(KERN_INFO, SCpnt,
-	 	"%s, pid %ld, mbox %d, adapter"
+	 	"%s, mbox %d, adapter"
                 " busy, will abort.\n", (ihdlr ? "ihdlr" : "qcomm"),
-                SCpnt->serial_number, k);
+                k);
          HD(j)->cp_stat[k] = ABORTING;
          continue;
          }
@@ -1793,12 +1786,12 @@ static irqreturn_t ihdlr(unsigned int j)
    if (SCpnt == NULL) panic("%s: ihdlr, mbox %d, SCpnt == NULL.\n", BN(j), i);
 
    if (SCpnt->host_scribble == NULL)
-      panic("%s: ihdlr, mbox %d, pid %ld, SCpnt %p garbled.\n", BN(j), i,
-            SCpnt->serial_number, SCpnt);
+      panic("%s: ihdlr, mbox %d, SCpnt %p garbled.\n", BN(j), i,
+            SCpnt);
 
    if (*(unsigned int *)SCpnt->host_scribble != i)
-      panic("%s: ihdlr, mbox %d, pid %ld, index mismatch %d.\n",
-            BN(j), i, SCpnt->serial_number, *(unsigned int *)SCpnt->host_scribble);
+      panic("%s: ihdlr, mbox %d, index mismatch %d.\n",
+            BN(j), i, *(unsigned int *)SCpnt->host_scribble);
 
    sync_dma(i, j);
 
@@ -1841,8 +1834,8 @@ static irqreturn_t ihdlr(unsigned int j)
              (!(tstatus == CHECK_CONDITION && HD(j)->iocount <= 1000 &&
                (SCpnt->sense_buffer[2] & 0xf) == NOT_READY)))
             scmd_printk(KERN_INFO, SCpnt,
-	    	"ihdlr, pid %ld, target_status 0x%x, sense key 0x%x.\n",
-                   SCpnt->serial_number, spp->target_status,
+	    	"ihdlr, target_status 0x%x, sense key 0x%x.\n",
+                   spp->target_status,
                    SCpnt->sense_buffer[2]);
 
          HD(j)->target_to[scmd_id(SCpnt)][scmd_channel(SCpnt)] = 0;
@@ -1913,8 +1906,8 @@ static irqreturn_t ihdlr(unsigned int j)
         do_trace || msg_byte(spp->target_status))
 #endif
       scmd_printk(KERN_INFO, SCpnt, "ihdlr, mbox %2d, err 0x%x:%x,"\
-             " pid %ld, reg 0x%x, count %d.\n",
-             i, spp->adapter_status, spp->target_status, SCpnt->serial_number,
+             " reg 0x%x, count %d.\n",
+             i, spp->adapter_status, spp->target_status,
              reg, HD(j)->iocount);
 
    unmap_dma(i, j);
Index: linux-2.6/drivers/scsi/wd33c93.c
===================================================================
--- linux-2.6.orig/drivers/scsi/wd33c93.c	2011-04-02 07:11:59.930737713 -0700
+++ linux-2.6/drivers/scsi/wd33c93.c	2011-04-02 07:12:02.168237302 -0700
@@ -381,7 +381,7 @@ wd33c93_queuecommand_lck(struct scsi_cmn
 	hostdata = (struct WD33C93_hostdata *) cmd->device->host->hostdata;
 
 	DB(DB_QUEUE_COMMAND,
-	   printk("Q-%d-%02x-%ld( ", cmd->device->id, cmd->cmnd[0], cmd->serial_number))
+	   printk("Q-%d-%02x( ", cmd->device->id, cmd->cmnd[0]))
 
 /* Set up a few fields in the scsi_cmnd structure for our own use:
  *  - host_scribble is the pointer to the next cmd in the input queue
@@ -462,7 +462,7 @@ wd33c93_queuecommand_lck(struct scsi_cmn
 
 	wd33c93_execute(cmd->device->host);
 
-	DB(DB_QUEUE_COMMAND, printk(")Q-%ld ", cmd->serial_number))
+	DB(DB_QUEUE_COMMAND, printk(")Q "))
 
 	spin_unlock_irq(&hostdata->lock);
 	return 0;
@@ -687,7 +687,7 @@ wd33c93_execute(struct Scsi_Host *instan
 	 */
 
 	DB(DB_EXECUTE,
-	   printk("%s%ld)EX-2 ", (cmd->SCp.phase) ? "d:" : "", cmd->serial_number))
+	   printk("%s)EX-2 ", (cmd->SCp.phase) ? "d:" : ""))
 }
 
 static void
@@ -963,7 +963,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 	case CSR_XFER_DONE | PHS_COMMAND:
 	case CSR_UNEXP | PHS_COMMAND:
 	case CSR_SRV_REQ | PHS_COMMAND:
-		DB(DB_INTR, printk("CMND-%02x,%ld", cmd->cmnd[0], cmd->serial_number))
+		DB(DB_INTR, printk("CMND-%02x", cmd->cmnd[0]))
 		    transfer_pio(regs, cmd->cmnd, cmd->cmd_len, DATA_OUT_DIR,
 				 hostdata);
 		hostdata->state = S_CONNECTED;
@@ -1007,7 +1007,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 		switch (msg) {
 
 		case COMMAND_COMPLETE:
-			DB(DB_INTR, printk("CCMP-%ld", cmd->serial_number))
+			DB(DB_INTR, printk("CCMP"))
 			    write_wd33c93_cmd(regs, WD_CMD_NEGATE_ACK);
 			hostdata->state = S_PRE_CMP_DISC;
 			break;
@@ -1174,7 +1174,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 
 		write_wd33c93(regs, WD_SOURCE_ID, SRCID_ER);
 		if (phs == 0x60) {
-			DB(DB_INTR, printk("SX-DONE-%ld", cmd->serial_number))
+			DB(DB_INTR, printk("SX-DONE"))
 			    cmd->SCp.Message = COMMAND_COMPLETE;
 			lun = read_wd33c93(regs, WD_TARGET_LUN);
 			DB(DB_INTR, printk(":%d.%d", cmd->SCp.Status, lun))
@@ -1200,8 +1200,8 @@ wd33c93_intr(struct Scsi_Host *instance)
 			wd33c93_execute(instance);
 		} else {
 			printk
-			    ("%02x:%02x:%02x-%ld: Unknown SEL_XFER_DONE phase!!---",
-			     asr, sr, phs, cmd->serial_number);
+			    ("%02x:%02x:%02x: Unknown SEL_XFER_DONE phase!!---",
+			     asr, sr, phs);
 			spin_unlock_irqrestore(&hostdata->lock, flags);
 		}
 		break;
@@ -1266,7 +1266,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 			spin_unlock_irqrestore(&hostdata->lock, flags);
 			return;
 		}
-		DB(DB_INTR, printk("UNEXP_DISC-%ld", cmd->serial_number))
+		DB(DB_INTR, printk("UNEXP_DISC"))
 		    hostdata->connected = NULL;
 		hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
 		hostdata->state = S_UNCONNECTED;
@@ -1292,7 +1292,7 @@ wd33c93_intr(struct Scsi_Host *instance)
  */
 
 		write_wd33c93(regs, WD_SOURCE_ID, SRCID_ER);
-		DB(DB_INTR, printk("DISC-%ld", cmd->serial_number))
+		DB(DB_INTR, printk("DISC"))
 		    if (cmd == NULL) {
 			printk(" - Already disconnected! ");
 			hostdata->state = S_UNCONNECTED;
@@ -1491,7 +1491,6 @@ wd33c93_intr(struct Scsi_Host *instance)
 		} else
 			hostdata->state = S_CONNECTED;
 
-		DB(DB_INTR, printk("-%ld", cmd->serial_number))
 		    spin_unlock_irqrestore(&hostdata->lock, flags);
 		break;
 
@@ -1637,8 +1636,8 @@ wd33c93_abort(struct scsi_cmnd * cmd)
 			cmd->host_scribble = NULL;
 			cmd->result = DID_ABORT << 16;
 			printk
-			    ("scsi%d: Abort - removing command %ld from input_Q. ",
-			     instance->host_no, cmd->serial_number);
+			    ("scsi%d: Abort - removing command from input_Q. ",
+			     instance->host_no);
 			enable_irq(cmd->device->host->irq);
 			cmd->scsi_done(cmd);
 			return SUCCESS;
@@ -1662,8 +1661,8 @@ wd33c93_abort(struct scsi_cmnd * cmd)
 		uchar sr, asr;
 		unsigned long timeout;
 
-		printk("scsi%d: Aborting connected command %ld - ",
-		       instance->host_no, cmd->serial_number);
+		printk("scsi%d: Aborting connected command - ",
+		       instance->host_no);
 
 		printk("stopping DMA - ");
 		if (hostdata->dma == D_DMA_RUNNING) {
@@ -1729,8 +1728,8 @@ wd33c93_abort(struct scsi_cmnd * cmd)
 	while (tmp) {
 		if (tmp == cmd) {
 			printk
-			    ("scsi%d: Abort - command %ld found on disconnected_Q - ",
-			     instance->host_no, cmd->serial_number);
+			    ("scsi%d: Abort - command found on disconnected_Q - ",
+			     instance->host_no);
 			printk("Abort SNOOZE. ");
 			enable_irq(cmd->device->host->irq);
 			return FAILED;
@@ -2180,8 +2179,8 @@ wd33c93_proc_info(struct Scsi_Host *inst
 		strcat(bp, "\nconnected:     ");
 		if (hd->connected) {
 			cmd = (struct scsi_cmnd *) hd->connected;
-			sprintf(tbuf, " %ld-%d:%d(%02x)",
-				cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+			sprintf(tbuf, " %d:%d(%02x)",
+				cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			strcat(bp, tbuf);
 		}
 	}
@@ -2189,8 +2188,8 @@ wd33c93_proc_info(struct Scsi_Host *inst
 		strcat(bp, "\ninput_Q:       ");
 		cmd = (struct scsi_cmnd *) hd->input_Q;
 		while (cmd) {
-			sprintf(tbuf, " %ld-%d:%d(%02x)",
-				cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+			sprintf(tbuf, " %d:%d(%02x)",
+				cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			strcat(bp, tbuf);
 			cmd = (struct scsi_cmnd *) cmd->host_scribble;
 		}
@@ -2199,8 +2198,8 @@ wd33c93_proc_info(struct Scsi_Host *inst
 		strcat(bp, "\ndisconnected_Q:");
 		cmd = (struct scsi_cmnd *) hd->disconnected_Q;
 		while (cmd) {
-			sprintf(tbuf, " %ld-%d:%d(%02x)",
-				cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+			sprintf(tbuf, " %d:%d(%02x)",
+				cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			strcat(bp, tbuf);
 			cmd = (struct scsi_cmnd *) cmd->host_scribble;
 		}
Index: linux-2.6/drivers/scsi/dpt_i2o.c
===================================================================
--- linux-2.6.orig/drivers/scsi/dpt_i2o.c	2011-04-02 07:11:59.942741061 -0700
+++ linux-2.6/drivers/scsi/dpt_i2o.c	2011-04-02 07:12:02.176237042 -0700
@@ -780,7 +780,7 @@ static int adpt_abort(struct scsi_cmnd *
 		return FAILED;
 	}
 	pHba = (adpt_hba*) cmd->device->host->hostdata[0];
-	printk(KERN_INFO"%s: Trying to Abort cmd=%ld\n",pHba->name, cmd->serial_number);
+	printk(KERN_INFO"%s: Trying to Abort\n",pHba->name);
 	if ((dptdevice = (void*) (cmd->device->hostdata)) == NULL) {
 		printk(KERN_ERR "%s: Unable to abort: No device in cmnd\n",pHba->name);
 		return FAILED;
@@ -802,10 +802,10 @@ static int adpt_abort(struct scsi_cmnd *
 			printk(KERN_INFO"%s: Abort cmd not supported\n",pHba->name);
 			return FAILED;
 		}
-		printk(KERN_INFO"%s: Abort cmd=%ld failed.\n",pHba->name, cmd->serial_number);
+		printk(KERN_INFO"%s: Abort failed.\n",pHba->name);
 		return FAILED;
 	} 
-	printk(KERN_INFO"%s: Abort cmd=%ld complete.\n",pHba->name, cmd->serial_number);
+	printk(KERN_INFO"%s: Abort complete.\n",pHba->name);
 	return SUCCESS;
 }
 
Index: linux-2.6/drivers/scsi/eata.c
===================================================================
--- linux-2.6.orig/drivers/scsi/eata.c	2011-04-02 07:11:59.950739343 -0700
+++ linux-2.6/drivers/scsi/eata.c	2011-04-02 07:12:02.184178625 -0700
@@ -1766,8 +1766,8 @@ static int eata2x_queuecommand_lck(struc
 	struct mscp *cpp;
 
 	if (SCpnt->host_scribble)
-		panic("%s: qcomm, pid %ld, SCpnt %p already active.\n",
-		      ha->board_name, SCpnt->serial_number, SCpnt);
+		panic("%s: qcomm, SCpnt %p already active.\n",
+		      ha->board_name, SCpnt);
 
 	/* i is the mailbox number, look for the first free mailbox
 	   starting from last_cp_used */
@@ -1801,7 +1801,7 @@ static int eata2x_queuecommand_lck(struc
 
 	if (do_trace)
 		scmd_printk(KERN_INFO, SCpnt,
-			"qcomm, mbox %d, pid %ld.\n", i, SCpnt->serial_number);
+			"qcomm, mbox %d.\n", i);
 
 	cpp->reqsen = 1;
 	cpp->dispri = 1;
@@ -1833,8 +1833,7 @@ static int eata2x_queuecommand_lck(struc
 	if (do_dma(shost->io_port, cpp->cp_dma_addr, SEND_CP_DMA)) {
 		unmap_dma(i, ha);
 		SCpnt->host_scribble = NULL;
-		scmd_printk(KERN_INFO, SCpnt,
-			"qcomm, pid %ld, adapter busy.\n", SCpnt->serial_number);
+		scmd_printk(KERN_INFO, SCpnt, "qcomm, adapter busy.\n");
 		return 1;
 	}
 
@@ -1851,14 +1850,12 @@ static int eata2x_eh_abort(struct scsi_c
 	unsigned int i;
 
 	if (SCarg->host_scribble == NULL) {
-		scmd_printk(KERN_INFO, SCarg,
-			"abort, pid %ld inactive.\n", SCarg->serial_number);
+		scmd_printk(KERN_INFO, SCarg, "abort, cmd inactive.\n");
 		return SUCCESS;
 	}
 
 	i = *(unsigned int *)SCarg->host_scribble;
-	scmd_printk(KERN_WARNING, SCarg,
-		"abort, mbox %d, pid %ld.\n", i, SCarg->serial_number);
+	scmd_printk(KERN_WARNING, SCarg, "abort, mbox %d.\n", i);
 
 	if (i >= shost->can_queue)
 		panic("%s: abort, invalid SCarg->host_scribble.\n", ha->board_name);
@@ -1902,8 +1899,8 @@ static int eata2x_eh_abort(struct scsi_c
 		SCarg->result = DID_ABORT << 16;
 		SCarg->host_scribble = NULL;
 		ha->cp_stat[i] = FREE;
-		printk("%s, abort, mbox %d ready, DID_ABORT, pid %ld done.\n",
-		       ha->board_name, i, SCarg->serial_number);
+		printk("%s, abort, mbox %d ready, DID_ABORT, done.\n",
+		       ha->board_name, i);
 		SCarg->scsi_done(SCarg);
 		return SUCCESS;
 	}
@@ -1919,13 +1916,12 @@ static int eata2x_eh_host_reset(struct s
 	struct Scsi_Host *shost = SCarg->device->host;
 	struct hostdata *ha = (struct hostdata *)shost->hostdata;
 
-	scmd_printk(KERN_INFO, SCarg,
-		"reset, enter, pid %ld.\n", SCarg->serial_number);
+	scmd_printk(KERN_INFO, SCarg, "reset, enter.\n");
 
 	spin_lock_irq(shost->host_lock);
 
 	if (SCarg->host_scribble == NULL)
-		printk("%s: reset, pid %ld inactive.\n", ha->board_name, SCarg->serial_number);
+		printk("%s: reset, inactive.\n", ha->board_name);
 
 	if (ha->in_reset) {
 		printk("%s: reset, exit, already in reset.\n", ha->board_name);
@@ -1964,14 +1960,14 @@ static int eata2x_eh_host_reset(struct s
 
 		if (ha->cp_stat[i] == READY || ha->cp_stat[i] == ABORTING) {
 			ha->cp_stat[i] = ABORTING;
-			printk("%s: reset, mbox %d aborting, pid %ld.\n",
-			       ha->board_name, i, SCpnt->serial_number);
+			printk("%s: reset, mbox %d aborting.\n",
+			       ha->board_name, i);
 		}
 
 		else {
 			ha->cp_stat[i] = IN_RESET;
-			printk("%s: reset, mbox %d in reset, pid %ld.\n",
-			       ha->board_name, i, SCpnt->serial_number);
+			printk("%s: reset, mbox %d in reset.\n",
+			       ha->board_name, i);
 		}
 
 		if (SCpnt->host_scribble == NULL)
@@ -2025,8 +2021,8 @@ static int eata2x_eh_host_reset(struct s
 			ha->cp_stat[i] = LOCKED;
 
 			printk
-			    ("%s, reset, mbox %d locked, DID_RESET, pid %ld done.\n",
-			     ha->board_name, i, SCpnt->serial_number);
+			    ("%s, reset, mbox %d locked, DID_RESET, done.\n",
+			     ha->board_name, i);
 		}
 
 		else if (ha->cp_stat[i] == ABORTING) {
@@ -2039,8 +2035,8 @@ static int eata2x_eh_host_reset(struct s
 			ha->cp_stat[i] = FREE;
 
 			printk
-			    ("%s, reset, mbox %d aborting, DID_RESET, pid %ld done.\n",
-			     ha->board_name, i, SCpnt->serial_number);
+			    ("%s, reset, mbox %d aborting, DID_RESET, done.\n",
+			     ha->board_name, i);
 		}
 
 		else
@@ -2054,7 +2050,7 @@ static int eata2x_eh_host_reset(struct s
 	do_trace = 0;
 
 	if (arg_done)
-		printk("%s: reset, exit, pid %ld done.\n", ha->board_name, SCarg->serial_number);
+		printk("%s: reset, exit, done.\n", ha->board_name);
 	else
 		printk("%s: reset, exit.\n", ha->board_name);
 
@@ -2238,10 +2234,10 @@ static int reorder(struct hostdata *ha,
 			cpp = &ha->cp[k];
 			SCpnt = cpp->SCpnt;
 			scmd_printk(KERN_INFO, SCpnt,
-			    "%s pid %ld mb %d fc %d nr %d sec %ld ns %u"
+			    "%s mb %d fc %d nr %d sec %ld ns %u"
 			     " cur %ld s:%c r:%c rev:%c in:%c ov:%c xd %d.\n",
 			     (ihdlr ? "ihdlr" : "qcomm"),
-			     SCpnt->serial_number, k, flushcount,
+			     k, flushcount,
 			     n_ready, blk_rq_pos(SCpnt->request),
 			     blk_rq_sectors(SCpnt->request), cursec, YESNO(s),
 			     YESNO(r), YESNO(rev), YESNO(input_only),
@@ -2285,10 +2281,10 @@ static void flush_dev(struct scsi_device
 
 		if (do_dma(dev->host->io_port, cpp->cp_dma_addr, SEND_CP_DMA)) {
 			scmd_printk(KERN_INFO, SCpnt,
-			    "%s, pid %ld, mbox %d, adapter"
+			    "%s, mbox %d, adapter"
 			     " busy, will abort.\n",
 			     (ihdlr ? "ihdlr" : "qcomm"),
-			     SCpnt->serial_number, k);
+			     k);
 			ha->cp_stat[k] = ABORTING;
 			continue;
 		}
@@ -2398,12 +2394,12 @@ static irqreturn_t ihdlr(struct Scsi_Hos
 		panic("%s: ihdlr, mbox %d, SCpnt == NULL.\n", ha->board_name, i);
 
 	if (SCpnt->host_scribble == NULL)
-		panic("%s: ihdlr, mbox %d, pid %ld, SCpnt %p garbled.\n", ha->board_name,
-		      i, SCpnt->serial_number, SCpnt);
+		panic("%s: ihdlr, mbox %d, SCpnt %p garbled.\n", ha->board_name,
+		      i, SCpnt);
 
 	if (*(unsigned int *)SCpnt->host_scribble != i)
-		panic("%s: ihdlr, mbox %d, pid %ld, index mismatch %d.\n",
-		      ha->board_name, i, SCpnt->serial_number,
+		panic("%s: ihdlr, mbox %d, index mismatch %d.\n",
+		      ha->board_name, i,
 		      *(unsigned int *)SCpnt->host_scribble);
 
 	sync_dma(i, ha);
@@ -2449,11 +2445,11 @@ static irqreturn_t ihdlr(struct Scsi_Hos
 		if (spp->target_status && SCpnt->device->type == TYPE_DISK &&
 		    (!(tstatus == CHECK_CONDITION && ha->iocount <= 1000 &&
 		       (SCpnt->sense_buffer[2] & 0xf) == NOT_READY)))
-			printk("%s: ihdlr, target %d.%d:%d, pid %ld, "
+			printk("%s: ihdlr, target %d.%d:%d, "
 			       "target_status 0x%x, sense key 0x%x.\n",
 			       ha->board_name,
 			       SCpnt->device->channel, SCpnt->device->id,
-			       SCpnt->device->lun, SCpnt->serial_number,
+			       SCpnt->device->lun,
 			       spp->target_status, SCpnt->sense_buffer[2]);
 
 		ha->target_to[SCpnt->device->id][SCpnt->device->channel] = 0;
@@ -2522,9 +2518,9 @@ static irqreturn_t ihdlr(struct Scsi_Hos
 	    do_trace || msg_byte(spp->target_status))
 #endif
 		scmd_printk(KERN_INFO, SCpnt, "ihdlr, mbox %2d, err 0x%x:%x,"
-		       " pid %ld, reg 0x%x, count %d.\n",
+		       " reg 0x%x, count %d.\n",
 		       i, spp->adapter_status, spp->target_status,
-		       SCpnt->serial_number, reg, ha->iocount);
+		       reg, ha->iocount);
 
 	unmap_dma(i, ha);
 
Index: linux-2.6/drivers/scsi/in2000.c
===================================================================
--- linux-2.6.orig/drivers/scsi/in2000.c	2011-04-02 07:11:59.962740460 -0700
+++ linux-2.6/drivers/scsi/in2000.c	2011-04-02 07:12:02.191768919 -0700
@@ -343,7 +343,7 @@ static int in2000_queuecommand_lck(Scsi_
 	instance = cmd->device->host;
 	hostdata = (struct IN2000_hostdata *) instance->hostdata;
 
-	DB(DB_QUEUE_COMMAND, scmd_printk(KERN_DEBUG, cmd, "Q-%02x-%ld(", cmd->cmnd[0], cmd->serial_number))
+	DB(DB_QUEUE_COMMAND, scmd_printk(KERN_DEBUG, cmd, "Q-%02x(", cmd->cmnd[0]))
 
 /* Set up a few fields in the Scsi_Cmnd structure for our own use:
  *  - host_scribble is the pointer to the next cmd in the input queue
@@ -427,7 +427,7 @@ static int in2000_queuecommand_lck(Scsi_
 
 	in2000_execute(cmd->device->host);
 
-	DB(DB_QUEUE_COMMAND, printk(")Q-%ld ", cmd->serial_number))
+	DB(DB_QUEUE_COMMAND, printk(")Q "))
 	    return 0;
 }
 
@@ -705,7 +705,7 @@ static void in2000_execute(struct Scsi_H
 	 * to search the input_Q again...
 	 */
 
-	DB(DB_EXECUTE, printk("%s%ld)EX-2 ", (cmd->SCp.phase) ? "d:" : "", cmd->serial_number))
+	DB(DB_EXECUTE, printk("%s)EX-2 ", (cmd->SCp.phase) ? "d:" : ""))
 
 }
 
@@ -1149,7 +1149,7 @@ static irqreturn_t in2000_intr(int irqnu
 	case CSR_XFER_DONE | PHS_COMMAND:
 	case CSR_UNEXP | PHS_COMMAND:
 	case CSR_SRV_REQ | PHS_COMMAND:
-		DB(DB_INTR, printk("CMND-%02x,%ld", cmd->cmnd[0], cmd->serial_number))
+		DB(DB_INTR, printk("CMND-%02x", cmd->cmnd[0]))
 		    transfer_pio(cmd->cmnd, cmd->cmd_len, DATA_OUT_DIR, hostdata);
 		hostdata->state = S_CONNECTED;
 		break;
@@ -1191,7 +1191,7 @@ static irqreturn_t in2000_intr(int irqnu
 		switch (msg) {
 
 		case COMMAND_COMPLETE:
-			DB(DB_INTR, printk("CCMP-%ld", cmd->serial_number))
+			DB(DB_INTR, printk("CCMP"))
 			    write_3393_cmd(hostdata, WD_CMD_NEGATE_ACK);
 			hostdata->state = S_PRE_CMP_DISC;
 			break;
@@ -1329,7 +1329,7 @@ static irqreturn_t in2000_intr(int irqnu
 
 		write_3393(hostdata, WD_SOURCE_ID, SRCID_ER);
 		if (phs == 0x60) {
-			DB(DB_INTR, printk("SX-DONE-%ld", cmd->serial_number))
+			DB(DB_INTR, printk("SX-DONE"))
 			    cmd->SCp.Message = COMMAND_COMPLETE;
 			lun = read_3393(hostdata, WD_TARGET_LUN);
 			DB(DB_INTR, printk(":%d.%d", cmd->SCp.Status, lun))
@@ -1350,7 +1350,7 @@ static irqreturn_t in2000_intr(int irqnu
 
 			in2000_execute(instance);
 		} else {
-			printk("%02x:%02x:%02x-%ld: Unknown SEL_XFER_DONE phase!!---", asr, sr, phs, cmd->serial_number);
+			printk("%02x:%02x:%02x: Unknown SEL_XFER_DONE phase!!---", asr, sr, phs);
 		}
 		break;
 
@@ -1417,7 +1417,7 @@ static irqreturn_t in2000_intr(int irqnu
 			spin_unlock_irqrestore(instance->host_lock, flags);
 			return IRQ_HANDLED;
 		}
-		DB(DB_INTR, printk("UNEXP_DISC-%ld", cmd->serial_number))
+		DB(DB_INTR, printk("UNEXP_DISC"))
 		    hostdata->connected = NULL;
 		hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
 		hostdata->state = S_UNCONNECTED;
@@ -1442,7 +1442,7 @@ static irqreturn_t in2000_intr(int irqnu
  */
 
 		write_3393(hostdata, WD_SOURCE_ID, SRCID_ER);
-		DB(DB_INTR, printk("DISC-%ld", cmd->serial_number))
+		DB(DB_INTR, printk("DISC"))
 		    if (cmd == NULL) {
 			printk(" - Already disconnected! ");
 			hostdata->state = S_UNCONNECTED;
@@ -1575,7 +1575,6 @@ static irqreturn_t in2000_intr(int irqnu
 		} else
 			hostdata->state = S_CONNECTED;
 
-		DB(DB_INTR, printk("-%ld", cmd->serial_number))
 		    break;
 
 	default:
@@ -1704,7 +1703,7 @@ static int __in2000_abort(Scsi_Cmnd * cm
 				prev->host_scribble = cmd->host_scribble;
 			cmd->host_scribble = NULL;
 			cmd->result = DID_ABORT << 16;
-			printk(KERN_WARNING "scsi%d: Abort - removing command %ld from input_Q. ", instance->host_no, cmd->serial_number);
+			printk(KERN_WARNING "scsi%d: Abort - removing command from input_Q. ", instance->host_no);
 			cmd->scsi_done(cmd);
 			return SUCCESS;
 		}
@@ -1725,7 +1724,7 @@ static int __in2000_abort(Scsi_Cmnd * cm
 
 	if (hostdata->connected == cmd) {
 
-		printk(KERN_WARNING "scsi%d: Aborting connected command %ld - ", instance->host_no, cmd->serial_number);
+		printk(KERN_WARNING "scsi%d: Aborting connected command - ", instance->host_no);
 
 		printk("sending wd33c93 ABORT command - ");
 		write_3393(hostdata, WD_CONTROL, CTRL_IDI | CTRL_EDI | CTRL_POLLED);
@@ -2270,7 +2269,7 @@ static int in2000_proc_info(struct Scsi_
 		strcat(bp, "\nconnected:     ");
 		if (hd->connected) {
 			cmd = (Scsi_Cmnd *) hd->connected;
-			sprintf(tbuf, " %ld-%d:%d(%02x)", cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+			sprintf(tbuf, " %d:%d(%02x)", cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			strcat(bp, tbuf);
 		}
 	}
@@ -2278,7 +2277,7 @@ static int in2000_proc_info(struct Scsi_
 		strcat(bp, "\ninput_Q:       ");
 		cmd = (Scsi_Cmnd *) hd->input_Q;
 		while (cmd) {
-			sprintf(tbuf, " %ld-%d:%d(%02x)", cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+			sprintf(tbuf, " %d:%d(%02x)", cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			strcat(bp, tbuf);
 			cmd = (Scsi_Cmnd *) cmd->host_scribble;
 		}
@@ -2287,7 +2286,7 @@ static int in2000_proc_info(struct Scsi_
 		strcat(bp, "\ndisconnected_Q:");
 		cmd = (Scsi_Cmnd *) hd->disconnected_Q;
 		while (cmd) {
-			sprintf(tbuf, " %ld-%d:%d(%02x)", cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+			sprintf(tbuf, " %d:%d(%02x)", cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			strcat(bp, tbuf);
 			cmd = (Scsi_Cmnd *) cmd->host_scribble;
 		}
Index: linux-2.6/drivers/scsi/lpfc/lpfc_scsi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/lpfc/lpfc_scsi.c	2011-04-02 07:11:59.978739551 -0700
+++ linux-2.6/drivers/scsi/lpfc/lpfc_scsi.c	2011-04-02 07:12:02.199289504 -0700
@@ -3238,9 +3238,8 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	if (!lpfc_cmd) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			 "2873 SCSI Layer I/O Abort Request IO CMPL Status "
-			 "x%x ID %d "
-			 "LUN %d snum %#lx\n", ret, cmnd->device->id,
-			 cmnd->device->lun, cmnd->serial_number);
+			 "x%x ID %d LUN %d\n",
+			 ret, cmnd->device->id, cmnd->device->lun);
 		return SUCCESS;
 	}
 
@@ -3318,16 +3317,15 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 				 "0748 abort handler timed out waiting "
 				 "for abort to complete: ret %#x, ID %d, "
-				 "LUN %d, snum %#lx\n",
-				 ret, cmnd->device->id, cmnd->device->lun,
-				 cmnd->serial_number);
+				 "LUN %d\n",
+				 ret, cmnd->device->id, cmnd->device->lun);
 	}
 
  out:
 	lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			 "0749 SCSI Layer I/O Abort Request Status x%x ID %d "
-			 "LUN %d snum %#lx\n", ret, cmnd->device->id,
-			 cmnd->device->lun, cmnd->serial_number);
+			 "LUN %d\n", ret, cmnd->device->id,
+			 cmnd->device->lun);
 	return ret;
 }
 
Index: linux-2.6/drivers/scsi/megaraid.c
===================================================================
--- linux-2.6.orig/drivers/scsi/megaraid.c	2011-04-02 07:11:59.986738243 -0700
+++ linux-2.6/drivers/scsi/megaraid.c	2011-04-02 07:12:02.210757502 -0700
@@ -1469,8 +1469,8 @@ mega_cmd_done(adapter_t *adapter, u8 com
 			if( scb->state & SCB_ABORT ) {
 
 				printk(KERN_WARNING
-				"megaraid: aborted cmd %lx[%x] complete.\n",
-					scb->cmd->serial_number, scb->idx);
+				"megaraid: aborted cmd [%x] complete.\n",
+					scb->idx);
 
 				scb->cmd->result = (DID_ABORT << 16);
 
@@ -1488,8 +1488,8 @@ mega_cmd_done(adapter_t *adapter, u8 com
 			if( scb->state & SCB_RESET ) {
 
 				printk(KERN_WARNING
-				"megaraid: reset cmd %lx[%x] complete.\n",
-					scb->cmd->serial_number, scb->idx);
+				"megaraid: reset cmd [%x] complete.\n",
+					scb->idx);
 
 				scb->cmd->result = (DID_RESET << 16);
 
@@ -1958,8 +1958,8 @@ megaraid_abort_and_reset(adapter_t *adap
 	struct list_head	*pos, *next;
 	scb_t			*scb;
 
-	printk(KERN_WARNING "megaraid: %s-%lx cmd=%x <c=%d t=%d l=%d>\n",
-	     (aor == SCB_ABORT)? "ABORTING":"RESET", cmd->serial_number,
+	printk(KERN_WARNING "megaraid: %s cmd=%x <c=%d t=%d l=%d>\n",
+	     (aor == SCB_ABORT)? "ABORTING":"RESET",
 	     cmd->cmnd[0], cmd->device->channel, 
 	     cmd->device->id, cmd->device->lun);
 
@@ -1983,9 +1983,9 @@ megaraid_abort_and_reset(adapter_t *adap
 			if( scb->state & SCB_ISSUED ) {
 
 				printk(KERN_WARNING
-					"megaraid: %s-%lx[%x], fw owner.\n",
+					"megaraid: %s[%x], fw owner.\n",
 					(aor==SCB_ABORT) ? "ABORTING":"RESET",
-					cmd->serial_number, scb->idx);
+					scb->idx);
 
 				return FALSE;
 			}
@@ -1996,9 +1996,9 @@ megaraid_abort_and_reset(adapter_t *adap
 				 * list
 				 */
 				printk(KERN_WARNING
-					"megaraid: %s-%lx[%x], driver owner.\n",
+					"megaraid: %s-[%x], driver owner.\n",
 					(aor==SCB_ABORT) ? "ABORTING":"RESET",
-					cmd->serial_number, scb->idx);
+					scb->idx);
 
 				mega_free_scb(adapter, scb);
 
Index: linux-2.6/drivers/scsi/megaraid/megaraid_mbox.c
===================================================================
--- linux-2.6.orig/drivers/scsi/megaraid/megaraid_mbox.c	2011-04-02 07:12:00.002740102 -0700
+++ linux-2.6/drivers/scsi/megaraid/megaraid_mbox.c	2011-04-02 07:12:02.210757502 -0700
@@ -2315,8 +2315,8 @@ megaraid_mbox_dpc(unsigned long devp)
 		// Was an abort issued for this command earlier
 		if (scb->state & SCB_ABORT) {
 			con_log(CL_ANN, (KERN_NOTICE
-			"megaraid: aborted cmd %lx[%x] completed\n",
-				scp->serial_number, scb->sno));
+			"megaraid: aborted cmd [%x] completed\n",
+				scb->sno));
 		}
 
 		/*
@@ -2472,8 +2472,8 @@ megaraid_abort_handler(struct scsi_cmnd
 	raid_dev	= ADAP2RAIDDEV(adapter);
 
 	con_log(CL_ANN, (KERN_WARNING
-		"megaraid: aborting-%ld cmd=%x <c=%d t=%d l=%d>\n",
-		scp->serial_number, scp->cmnd[0], SCP2CHANNEL(scp),
+		"megaraid: aborting cmd=%x <c=%d t=%d l=%d>\n",
+		scp->cmnd[0], SCP2CHANNEL(scp),
 		SCP2TARGET(scp), SCP2LUN(scp)));
 
 	// If FW has stopped responding, simply return failure
@@ -2496,9 +2496,8 @@ megaraid_abort_handler(struct scsi_cmnd
 			list_del_init(&scb->list);	// from completed list
 
 			con_log(CL_ANN, (KERN_WARNING
-			"megaraid: %ld:%d[%d:%d], abort from completed list\n",
-				scp->serial_number, scb->sno,
-				scb->dev_channel, scb->dev_target));
+			"megaraid: %d[%d:%d], abort from completed list\n",
+				scb->sno, scb->dev_channel, scb->dev_target));
 
 			scp->result = (DID_ABORT << 16);
 			scp->scsi_done(scp);
@@ -2527,9 +2526,8 @@ megaraid_abort_handler(struct scsi_cmnd
 			ASSERT(!(scb->state & SCB_ISSUED));
 
 			con_log(CL_ANN, (KERN_WARNING
-				"megaraid abort: %ld[%d:%d], driver owner\n",
-				scp->serial_number, scb->dev_channel,
-				scb->dev_target));
+				"megaraid abort: [%d:%d], driver owner\n",
+				scb->dev_channel, scb->dev_target));
 
 			scp->result = (DID_ABORT << 16);
 			scp->scsi_done(scp);
@@ -2560,25 +2558,21 @@ megaraid_abort_handler(struct scsi_cmnd
 
 			if (!(scb->state & SCB_ISSUED)) {
 				con_log(CL_ANN, (KERN_WARNING
-				"megaraid abort: %ld%d[%d:%d], invalid state\n",
-				scp->serial_number, scb->sno, scb->dev_channel,
-				scb->dev_target));
+				"megaraid abort: %d[%d:%d], invalid state\n",
+				scb->sno, scb->dev_channel, scb->dev_target));
 				BUG();
 			}
 			else {
 				con_log(CL_ANN, (KERN_WARNING
-				"megaraid abort: %ld:%d[%d:%d], fw owner\n",
-				scp->serial_number, scb->sno, scb->dev_channel,
-				scb->dev_target));
+				"megaraid abort: %d[%d:%d], fw owner\n",
+				scb->sno, scb->dev_channel, scb->dev_target));
 			}
 		}
 	}
 	spin_unlock_irq(&adapter->lock);
 
 	if (!found) {
-		con_log(CL_ANN, (KERN_WARNING
-			"megaraid abort: scsi cmd:%ld, do now own\n",
-			scp->serial_number));
+		con_log(CL_ANN, (KERN_WARNING "megaraid abort: do now own\n"));
 
 		// FIXME: Should there be a callback for this command?
 		return SUCCESS;
@@ -2649,9 +2643,8 @@ megaraid_reset_handler(struct scsi_cmnd
 		} else {
 			if (scb->scp == scp) {	// Found command
 				con_log(CL_ANN, (KERN_WARNING
-					"megaraid: %ld:%d[%d:%d], reset from pending list\n",
-					scp->serial_number, scb->sno,
-					scb->dev_channel, scb->dev_target));
+					"megaraid: %d[%d:%d], reset from pending list\n",
+					scb->sno, scb->dev_channel, scb->dev_target));
 			} else {
 				con_log(CL_ANN, (KERN_WARNING
 				"megaraid: IO packet with %d[%d:%d] being reset\n",
Index: linux-2.6/drivers/scsi/mesh.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mesh.c	2011-04-02 07:12:00.010739503 -0700
+++ linux-2.6/drivers/scsi/mesh.c	2011-04-02 07:12:02.215236150 -0700
@@ -415,8 +415,7 @@ static void mesh_start_cmd(struct mesh_s
 #if 1
 	if (DEBUG_TARGET(cmd)) {
 		int i;
-		printk(KERN_DEBUG "mesh_start: %p ser=%lu tgt=%d cmd=",
-		       cmd, cmd->serial_number, id);
+		printk(KERN_DEBUG "mesh_start: %p tgt=%d cmd=", cmd, id);
 		for (i = 0; i < cmd->cmd_len; ++i)
 			printk(" %x", cmd->cmnd[i]);
 		printk(" use_sg=%d buffer=%p bufflen=%u\n",
Index: linux-2.6/drivers/scsi/ncr53c8xx.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ncr53c8xx.c	2011-04-02 07:12:00.022738726 -0700
+++ linux-2.6/drivers/scsi/ncr53c8xx.c	2011-04-02 07:12:02.222737436 -0700
@@ -8147,7 +8147,7 @@ static int ncr53c8xx_abort(struct scsi_c
 	unsigned long flags;
 	struct scsi_cmnd *done_list;
 
-	printk("ncr53c8xx_abort: command pid %lu\n", cmd->serial_number);
+	printk("ncr53c8xx_abort\n");
 
 	NCR_LOCK_NCB(np, flags);
 
Index: linux-2.6/drivers/scsi/qla1280.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.c	2011-04-02 07:12:00.034740571 -0700
+++ linux-2.6/drivers/scsi/qla1280.c	2011-04-02 07:12:02.231236842 -0700
@@ -4066,7 +4066,7 @@ __qla1280_print_scsi_cmd(struct scsi_cmn
 	   } */
 	printk("  tag=%d, transfersize=0x%x \n",
 	       cmd->tag, cmd->transfersize);
-	printk("  Pid=%li, SP=0x%p\n", cmd->serial_number, CMD_SP(cmd));
+	printk("  SP=0x%p\n", CMD_SP(cmd));
 	printk(" underflow size = 0x%x, direction=0x%x\n",
 	       cmd->underflow, cmd->sc_data_direction);
 }
Index: linux-2.6/drivers/scsi/qla4xxx/ql4_os.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla4xxx/ql4_os.c	2011-04-02 07:12:00.046739067 -0700
+++ linux-2.6/drivers/scsi/qla4xxx/ql4_os.c	2011-04-02 07:12:02.235001461 -0700
@@ -2068,15 +2068,14 @@ static int qla4xxx_eh_abort(struct scsi_
 	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
 	unsigned int id = cmd->device->id;
 	unsigned int lun = cmd->device->lun;
-	unsigned long serial = cmd->serial_number;
 	unsigned long flags;
 	struct srb *srb = NULL;
 	int ret = SUCCESS;
 	int wait = 0;
 
 	ql4_printk(KERN_INFO, ha,
-	    "scsi%ld:%d:%d: Abort command issued cmd=%p, pid=%ld\n",
-	    ha->host_no, id, lun, cmd, serial);
+	    "scsi%ld:%d:%d: Abort command issued cmd=%p\n",
+	    ha->host_no, id, lun, cmd);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	srb = (struct srb *) CMD_SP(cmd);
Index: linux-2.6/drivers/scsi/tmscsim.c
===================================================================
--- linux-2.6.orig/drivers/scsi/tmscsim.c	2011-04-02 07:12:00.062740320 -0700
+++ linux-2.6/drivers/scsi/tmscsim.c	2011-04-02 07:12:02.239236210 -0700
@@ -565,12 +565,12 @@ dc390_StartSCSI( struct dc390_acb* pACB,
 	pDCB->TagMask |= 1 << tag[1];
 	pSRB->TagNumber = tag[1];
 	DC390_write8(ScsiFifo, tag[1]);
-	DEBUG1(printk(KERN_INFO "DC390: Select w/DisCn for Cmd %li (SRB %p), block tag %02x\n", scmd->serial_number, pSRB, tag[1]));
+	DEBUG1(printk(KERN_INFO "DC390: Select w/DisCn for SRB %p, block tag %02x\n", pSRB, tag[1]));
 	cmd = SEL_W_ATN3;
     } else {
 	/* No TagQ */
 //no_tag:
-	DEBUG1(printk(KERN_INFO "DC390: Select w%s/DisCn for Cmd %li (SRB %p), No TagQ\n", disc_allowed ? "" : "o", scmd->serial_number, pSRB));
+	DEBUG1(printk(KERN_INFO "DC390: Select w%s/DisCn for SRB %p, No TagQ\n", disc_allowed ? "" : "o", pSRB));
     }
 
     pSRB->SRBState = SRB_START_;
@@ -620,8 +620,8 @@ dc390_StartSCSI( struct dc390_acb* pACB,
     if (DC390_read8 (Scsi_Status) & INTERRUPT)
     {
 	dc390_freetag (pDCB, pSRB);
-	DEBUG0(printk ("DC390: Interrupt during Start SCSI (pid %li, target %02i-%02i)\n",
-		scmd->serial_number, scmd->device->id, scmd->device->lun));
+	DEBUG0(printk ("DC390: Interrupt during Start SCSI (target %02i-%02i)\n",
+		scmd->device->id, scmd->device->lun));
 	pSRB->SRBState = SRB_READY;
 	//DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
 	pACB->SelLost++;
@@ -1705,8 +1705,7 @@ dc390_SRBdone( struct dc390_acb* pACB, s
 
     status = pSRB->TargetStatus;
 
-    DEBUG0(printk (" SRBdone (%02x,%08x), SRB %p, pid %li\n", status, pcmd->result,\
-		pSRB, pcmd->serial_number));
+    DEBUG0(printk (" SRBdone (%02x,%08x), SRB %p\n", status, pcmd->result, pSRB));
     if(pSRB->SRBFlag & AUTO_REQSENSE)
     {	/* Last command was a Request Sense */
 	pSRB->SRBFlag &= ~AUTO_REQSENSE;
@@ -1727,7 +1726,7 @@ dc390_SRBdone( struct dc390_acb* pACB, s
 	    } else {
 		SET_RES_DRV(pcmd->result, DRIVER_SENSE);
 		//pSRB->ScsiCmdLen	 = (u8) (pSRB->Segment1[0] >> 8);
-		DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->serial_number, pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
+		DEBUG0 (printk ("DC390: RETRY (%02x), target %02i-%02i\n", pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
 		pSRB->TotalXferredLen = 0;
 		SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
 	    }
@@ -1747,7 +1746,7 @@ dc390_SRBdone( struct dc390_acb* pACB, s
 	else if (status == SAM_STAT_TASK_SET_FULL)
 	{
 	    scsi_track_queue_full(pcmd->device, pDCB->GoingSRBCnt - 1);
-	    DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->serial_number, pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
+	    DEBUG0 (printk ("DC390: RETRY (%02x), target %02i-%02i\n", pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
 	    pSRB->TotalXferredLen = 0;
 	    SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
 	}
@@ -1801,7 +1800,7 @@ cmd_done:
     /* Add to free list */
     dc390_Free_insert (pACB, pSRB);
 
-    DEBUG0(printk (KERN_DEBUG "DC390: SRBdone: done pid %li\n", pcmd->serial_number));
+    DEBUG0(printk (KERN_DEBUG "DC390: SRBdone: done\n"));
     pcmd->scsi_done (pcmd);
 
     return;
@@ -1997,8 +1996,7 @@ static int DC390_abort(struct scsi_cmnd
 	struct dc390_acb *pACB = (struct dc390_acb*) cmd->device->host->hostdata;
 	struct dc390_dcb *pDCB = (struct dc390_dcb*) cmd->device->hostdata;
 
-	scmd_printk(KERN_WARNING, cmd,
-		"DC390: Abort command (pid %li)\n", cmd->serial_number);
+	scmd_printk(KERN_WARNING, cmd, "DC390: Abort command\n");
 
 	/* abort() is too stupid for already sent commands at the moment. 
 	 * If it's called we are in trouble anyway, so let's dump some info 
@@ -2006,7 +2004,7 @@ static int DC390_abort(struct scsi_cmnd
 	dc390_dumpinfo(pACB, pDCB, NULL);
 
 	pDCB->DCBFlag |= ABORT_DEV_;
-	printk(KERN_INFO "DC390: Aborted pid %li\n", cmd->serial_number);
+	printk(KERN_INFO "DC390: Aborted.\n");
 
 	return FAILED;
 }
Index: linux-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
===================================================================
--- linux-2.6.orig/drivers/scsi/megaraid/megaraid_sas_base.c	2011-04-02 07:12:54.836236487 -0700
+++ linux-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-04-02 07:13:31.939236930 -0700
@@ -1751,10 +1751,9 @@ static int megasas_wait_for_outstanding(
 			list_del_init(&reset_cmd->list);
 			if (reset_cmd->scmd) {
 				reset_cmd->scmd->result = DID_RESET << 16;
-				printk(KERN_NOTICE "%d:%p reset [%02x], %#lx\n",
+				printk(KERN_NOTICE "%d:%p reset [%02x]\n",
 					reset_index, reset_cmd,
-					reset_cmd->scmd->cmnd[0],
-					reset_cmd->scmd->serial_number);
+					reset_cmd->scmd->cmnd[0]);
 
 				reset_cmd->scmd->scsi_done(reset_cmd->scmd);
 				megasas_return_cmd(instance, reset_cmd);
@@ -1879,8 +1878,8 @@ static int megasas_generic_reset(struct
 
 	instance = (struct megasas_instance *)scmd->device->host->hostdata;
 
-	scmd_printk(KERN_NOTICE, scmd, "megasas: RESET -%ld cmd=%x retries=%x\n",
-		 scmd->serial_number, scmd->cmnd[0], scmd->retries);
+	scmd_printk(KERN_NOTICE, scmd, "megasas: RESET cmd=%x retries=%x\n",
+		 scmd->cmnd[0], scmd->retries);
 
 	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
 		printk(KERN_ERR "megasas: cannot recover from previous reset "
@@ -2349,9 +2348,9 @@ megasas_issue_pending_cmds_again(struct
 							cmd->frame_phys_addr ,
 							0, instance->reg_set);
 		} else if (cmd->scmd) {
-			printk(KERN_NOTICE "megasas: %p scsi cmd [%02x],%#lx"
+			printk(KERN_NOTICE "megasas: %p scsi cmd [%02x]"
 			"detected on the internal queue, issue again.\n",
-			cmd, cmd->scmd->cmnd[0], cmd->scmd->serial_number);
+			cmd, cmd->scmd->cmnd[0]);
 
 			atomic_inc(&instance->fw_outstanding);
 			instance->instancet->fire_cmd(instance,
