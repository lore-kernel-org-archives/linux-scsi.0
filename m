From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Remove ->pid field from scsi_cmnd
Date: Tue, 18 Sep 2007 19:54:43 -0600
Message-ID: <20070919015442.GC7624@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:55885 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbXISByp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Sep 2007 21:54:45 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The pid field is a duplicate of the serial_number field and has been
scheduled for removal for a long time.  A few drivers were still using
it, so just change them to use serial_number instead.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

 drivers/scsi/dc395x.c     |  110 +++++++++++++++++++++++-----------------------
 drivers/scsi/eata.c       |   44 +++++++++---------
 drivers/scsi/eata_pio.c   |   12 ++---
 drivers/scsi/in2000.c     |   30 ++++++------
 drivers/scsi/ncr53c8xx.c  |    7 --
 drivers/scsi/qla1280.c    |    2 
 drivers/scsi/scsi.c       |    6 --
 drivers/scsi/scsi_error.c |    6 --
 drivers/scsi/tmscsim.c    |   18 +++----
 drivers/scsi/u14-34f.c    |   44 +++++++++---------
 drivers/scsi/wd33c93.c    |   32 ++++++-------
 include/scsi/scsi_cmnd.h  |   11 +---
 include/scsi/scsi_host.h  |    2 
 13 files changed, 153 insertions(+), 171 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 7b8a345..c81f745 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -778,7 +778,7 @@ static void srb_waiting_insert(struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb)
 {
 	dprintkdbg(DBG_0, "srb_waiting_insert: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
+		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
 	list_add(&srb->list, &dcb->srb_waiting_list);
 }
 
@@ -787,7 +787,7 @@ static void srb_waiting_append(struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb)
 {
 	dprintkdbg(DBG_0, "srb_waiting_append: (pid#%li) <%02i-%i> srb=%p\n",
-		 srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
+		 srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
 	list_add_tail(&srb->list, &dcb->srb_waiting_list);
 }
 
@@ -795,7 +795,7 @@ static void srb_waiting_append(struct DeviceCtlBlk *dcb,
 static void srb_going_append(struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
 {
 	dprintkdbg(DBG_0, "srb_going_append: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
+		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
 	list_add_tail(&srb->list, &dcb->srb_going_list);
 }
 
@@ -805,7 +805,7 @@ static void srb_going_remove(struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
 	struct ScsiReqBlk *i;
 	struct ScsiReqBlk *tmp;
 	dprintkdbg(DBG_0, "srb_going_remove: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
+		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
 
 	list_for_each_entry_safe(i, tmp, &dcb->srb_going_list, list)
 		if (i == srb) {
@@ -821,7 +821,7 @@ static void srb_waiting_remove(struct DeviceCtlBlk *dcb,
 	struct ScsiReqBlk *i;
 	struct ScsiReqBlk *tmp;
 	dprintkdbg(DBG_0, "srb_waiting_remove: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
+		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
 
 	list_for_each_entry_safe(i, tmp, &dcb->srb_waiting_list, list)
 		if (i == srb) {
@@ -836,7 +836,7 @@ static void srb_going_to_waiting_move(struct DeviceCtlBlk *dcb,
 {
 	dprintkdbg(DBG_0,
 		"srb_going_to_waiting_move: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
+		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
 	list_move(&srb->list, &dcb->srb_waiting_list);
 }
 
@@ -846,7 +846,7 @@ static void srb_waiting_to_going_move(struct DeviceCtlBlk *dcb,
 {
 	dprintkdbg(DBG_0,
 		"srb_waiting_to_going_move: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
+		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
 	list_move(&srb->list, &dcb->srb_going_list);
 }
 
@@ -982,7 +982,7 @@ static void build_srb(struct scsi_cmnd *cmd, struct DeviceCtlBlk *dcb,
 	int nseg;
 	enum dma_data_direction dir = cmd->sc_data_direction;
 	dprintkdbg(DBG_0, "build_srb: (pid#%li) <%02i-%i>\n",
-		cmd->pid, dcb->target_id, dcb->target_lun);
+		cmd->serial_number, dcb->target_id, dcb->target_lun);
 
 	srb->dcb = dcb;
 	srb->cmd = cmd;
@@ -1086,7 +1086,7 @@ static int dc395x_queue_command(struct scsi_cmnd *cmd, void (*done)(struct scsi_
 	struct AdapterCtlBlk *acb =
 	    (struct AdapterCtlBlk *)cmd->device->host->hostdata;
 	dprintkdbg(DBG_0, "queue_command: (pid#%li) <%02i-%i> cmnd=0x%02x\n",
-		cmd->pid, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+		cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 
 	/* Assume BAD_TARGET; will be cleared later */
 	cmd->result = DID_BAD_TARGET << 16;
@@ -1139,7 +1139,7 @@ static int dc395x_queue_command(struct scsi_cmnd *cmd, void (*done)(struct scsi_
 		/* process immediately */
 		send_srb(acb, srb);
 	}
-	dprintkdbg(DBG_1, "queue_command: (pid#%li) done\n", cmd->pid);
+	dprintkdbg(DBG_1, "queue_command: (pid#%li) done\n", cmd->serial_number);
 	return 0;
 
 complete:
@@ -1203,7 +1203,7 @@ static void dump_register_info(struct AdapterCtlBlk *acb,
 		else
 			dprintkl(KERN_INFO, "dump: srb=%p cmd=%p (pid#%li) "
 				 "cmnd=0x%02x <%02i-%i>\n",
-			    	srb, srb->cmd, srb->cmd->pid,
+			    	srb, srb->cmd, srb->cmd->serial_number,
 				srb->cmd->cmnd[0], srb->cmd->device->id,
 			       	srb->cmd->device->lun);
 		printk("  sglist=%p cnt=%i idx=%i len=%zu\n",
@@ -1300,7 +1300,7 @@ static int __dc395x_eh_bus_reset(struct scsi_cmnd *cmd)
 		(struct AdapterCtlBlk *)cmd->device->host->hostdata;
 	dprintkl(KERN_INFO,
 		"eh_bus_reset: (pid#%li) target=<%02i-%i> cmd=%p\n",
-		cmd->pid, cmd->device->id, cmd->device->lun, cmd);
+		cmd->serial_number, cmd->device->id, cmd->device->lun, cmd);
 
 	if (timer_pending(&acb->waiting_timer))
 		del_timer(&acb->waiting_timer);
@@ -1367,7 +1367,7 @@ static int dc395x_eh_abort(struct scsi_cmnd *cmd)
 	struct DeviceCtlBlk *dcb;
 	struct ScsiReqBlk *srb;
 	dprintkl(KERN_INFO, "eh_abort: (pid#%li) target=<%02i-%i> cmd=%p\n",
-		cmd->pid, cmd->device->id, cmd->device->lun, cmd);
+		cmd->serial_number, cmd->device->id, cmd->device->lun, cmd);
 
 	dcb = find_dcb(acb, cmd->device->id, cmd->device->lun);
 	if (!dcb) {
@@ -1494,7 +1494,7 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 	u8 s_stat, scsicommand, i, identify_message;
 	u8 *ptr;
 	dprintkdbg(DBG_0, "start_scsi: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
+		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
 
 	srb->tag_number = TAG_NONE;	/* acb->tag_max_num: had error read in eeprom */
 
@@ -1504,7 +1504,7 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 #if 1
 	if (s_stat & 0x20 /* s_stat2 & 0x02000 */ ) {
 		dprintkdbg(DBG_KG, "start_scsi: (pid#%li) BUSY %02x %04x\n",
-			srb->cmd->pid, s_stat, s_stat2);
+			srb->cmd->serial_number, s_stat, s_stat2);
 		/*
 		 * Try anyway?
 		 *
@@ -1522,14 +1522,14 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 	if (acb->active_dcb) {
 		dprintkl(KERN_DEBUG, "start_scsi: (pid#%li) Attempt to start a"
 			"command while another command (pid#%li) is active.",
-			srb->cmd->pid,
+			srb->cmd->serial_number,
 			acb->active_dcb->active_srb ?
-			    acb->active_dcb->active_srb->cmd->pid : 0);
+			    acb->active_dcb->active_srb->cmd->serial_number : 0);
 		return 1;
 	}
 	if (DC395x_read16(acb, TRM_S1040_SCSI_STATUS) & SCSIINTERRUPT) {
 		dprintkdbg(DBG_KG, "start_scsi: (pid#%li) Failed (busy)\n",
-			srb->cmd->pid);
+			srb->cmd->serial_number);
 		return 1;
 	}
 	/* Allow starting of SCSI commands half a second before we allow the mid-level
@@ -1603,7 +1603,7 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 		if (tag_number >= dcb->max_command) {
 			dprintkl(KERN_WARNING, "start_scsi: (pid#%li) "
 				"Out of tags target=<%02i-%i>)\n",
-				srb->cmd->pid, srb->cmd->device->id,
+				srb->cmd->serial_number, srb->cmd->device->id,
 				srb->cmd->device->lun);
 			srb->state = SRB_READY;
 			DC395x_write16(acb, TRM_S1040_SCSI_CONTROL,
@@ -1622,7 +1622,7 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 /*polling:*/
 	/* Send CDB ..command block ......... */
 	dprintkdbg(DBG_KG, "start_scsi: (pid#%li) <%02i-%i> cmnd=0x%02x tag=%i\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun,
+		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun,
 		srb->cmd->cmnd[0], srb->tag_number);
 	if (srb->flag & AUTO_REQSENSE) {
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, REQUEST_SENSE);
@@ -1647,7 +1647,7 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 		 * : Let's process it first!
 		 */
 		dprintkdbg(DBG_0, "start_scsi: (pid#%li) <%02i-%i> Failed - busy\n",
-			srb->cmd->pid, dcb->target_id, dcb->target_lun);
+			srb->cmd->serial_number, dcb->target_id, dcb->target_lun);
 		srb->state = SRB_READY;
 		free_tag(dcb, srb);
 		srb->msg_count = 0;
@@ -1842,7 +1842,7 @@ static irqreturn_t dc395x_interrupt(int irq, void *dev_id)
 static void msgout_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "msgout_phase0: (pid#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "msgout_phase0: (pid#%li)\n", srb->cmd->serial_number);
 	if (srb->state & (SRB_UNEXPECT_RESEL + SRB_ABORT_SENT))
 		*pscsi_status = PH_BUS_FREE;	/*.. initial phase */
 
@@ -1856,18 +1856,18 @@ static void msgout_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 {
 	u16 i;
 	u8 *ptr;
-	dprintkdbg(DBG_0, "msgout_phase1: (pid#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "msgout_phase1: (pid#%li)\n", srb->cmd->serial_number);
 
 	clear_fifo(acb, "msgout_phase1");
 	if (!(srb->state & SRB_MSGOUT)) {
 		srb->state |= SRB_MSGOUT;
 		dprintkl(KERN_DEBUG,
 			"msgout_phase1: (pid#%li) Phase unexpected\n",
-			srb->cmd->pid);	/* So what ? */
+			srb->cmd->serial_number);	/* So what ? */
 	}
 	if (!srb->msg_count) {
 		dprintkdbg(DBG_0, "msgout_phase1: (pid#%li) NOP msg\n",
-			srb->cmd->pid);
+			srb->cmd->serial_number);
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, MSG_NOP);
 		DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
 		DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_FIFO_OUT);
@@ -1887,7 +1887,7 @@ static void msgout_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 static void command_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "command_phase0: (pid#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "command_phase0: (pid#%li)\n", srb->cmd->serial_number);
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);
 }
 
@@ -1898,7 +1898,7 @@ static void command_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 	struct DeviceCtlBlk *dcb;
 	u8 *ptr;
 	u16 i;
-	dprintkdbg(DBG_0, "command_phase1: (pid#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "command_phase1: (pid#%li)\n", srb->cmd->serial_number);
 
 	clear_fifo(acb, "command_phase1");
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_CLRATN);
@@ -2042,7 +2042,7 @@ static void data_out_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 	u16 scsi_status = *pscsi_status;
 	u32 d_left_counter = 0;
 	dprintkdbg(DBG_0, "data_out_phase0: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun);
 
 	/*
 	 * KG: We need to drain the buffers before we draw any conclusions!
@@ -2172,7 +2172,7 @@ static void data_out_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "data_out_phase1: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun);
 	clear_fifo(acb, "data_out_phase1");
 	/* do prepare before transfer when data out phase */
 	data_io_transfer(acb, srb, XFERDATAOUT);
@@ -2184,7 +2184,7 @@ static void data_in_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 	u16 scsi_status = *pscsi_status;
 
 	dprintkdbg(DBG_0, "data_in_phase0: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun);
 
 	/*
 	 * KG: DataIn is much more tricky than DataOut. When the device is finished
@@ -2205,7 +2205,7 @@ static void data_in_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 
 		if (scsi_status & PARITYERROR) {
 			dprintkl(KERN_INFO, "data_in_phase0: (pid#%li) "
-				"Parity Error\n", srb->cmd->pid);
+				"Parity Error\n", srb->cmd->serial_number);
 			srb->status |= PARITY_ERROR;
 		}
 		/*
@@ -2395,7 +2395,7 @@ static void data_in_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "data_in_phase1: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun);
 	data_io_transfer(acb, srb, XFERDATAIN);
 }
 
@@ -2407,7 +2407,7 @@ static void data_io_transfer(struct AdapterCtlBlk *acb,
 	u8 bval;
 	dprintkdbg(DBG_0,
 		"data_io_transfer: (pid#%li) <%02i-%i> %c len=%i, sg=(%i/%i)\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun,
+		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun,
 		((io_dir & DMACMD_DIR) ? 'r' : 'w'),
 		srb->total_xfer_length, srb->sg_index, srb->sg_count);
 	if (srb == acb->tmp_srb)
@@ -2580,7 +2580,7 @@ static void status_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "status_phase0: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun);
 	srb->target_status = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 	srb->end_message = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);	/* get message */
 	srb->state = SRB_COMPLETED;
@@ -2594,7 +2594,7 @@ static void status_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "status_phase1: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun);
 	srb->state = SRB_STATUS;
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
 	DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_COMP);
@@ -2636,7 +2636,7 @@ static struct ScsiReqBlk *msgin_qtag(struct AdapterCtlBlk *acb,
 	struct ScsiReqBlk *srb = NULL;
 	struct ScsiReqBlk *i;
 	dprintkdbg(DBG_0, "msgin_qtag: (pid#%li) tag=%i srb=%p\n",
-		   srb->cmd->pid, tag, srb);
+		   srb->cmd->serial_number, tag, srb);
 
 	if (!(dcb->tag_mask & (1 << tag)))
 		dprintkl(KERN_DEBUG,
@@ -2655,7 +2655,7 @@ static struct ScsiReqBlk *msgin_qtag(struct AdapterCtlBlk *acb,
 		goto mingx0;
 
 	dprintkdbg(DBG_0, "msgin_qtag: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->dcb->target_id, srb->dcb->target_lun);
+		srb->cmd->serial_number, srb->dcb->target_id, srb->dcb->target_lun);
 	if (dcb->flag & ABORT_DEV_) {
 		/*srb->state = SRB_ABORT_SENT; */
 		enable_msgout_abort(acb, srb);
@@ -2865,7 +2865,7 @@ static void msgin_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
 	struct DeviceCtlBlk *dcb = acb->active_dcb;
-	dprintkdbg(DBG_0, "msgin_phase0: (pid#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "msgin_phase0: (pid#%li)\n", srb->cmd->serial_number);
 
 	srb->msgin_buf[acb->msg_len++] = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 	if (msgin_completed(srb->msgin_buf, acb->msg_len)) {
@@ -2933,7 +2933,7 @@ static void msgin_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 			 */
 			dprintkdbg(DBG_0, "msgin_phase0: (pid#%li) "
 				"SAVE POINTER rem=%i Ignore\n",
-				srb->cmd->pid, srb->total_xfer_length);
+				srb->cmd->serial_number, srb->total_xfer_length);
 			break;
 
 		case RESTORE_POINTERS:
@@ -2943,7 +2943,7 @@ static void msgin_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		case ABORT:
 			dprintkdbg(DBG_0, "msgin_phase0: (pid#%li) "
 				"<%02i-%i> ABORT msg\n",
-				srb->cmd->pid, dcb->target_id,
+				srb->cmd->serial_number, dcb->target_id,
 				dcb->target_lun);
 			dcb->flag |= ABORT_DEV_;
 			enable_msgout_abort(acb, srb);
@@ -2975,7 +2975,7 @@ static void msgin_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 static void msgin_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "msgin_phase1: (pid#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "msgin_phase1: (pid#%li)\n", srb->cmd->serial_number);
 	clear_fifo(acb, "msgin_phase1");
 	DC395x_write32(acb, TRM_S1040_SCSI_COUNTER, 1);
 	if (!(srb->state & SRB_MSGIN)) {
@@ -3041,7 +3041,7 @@ static void disconnect(struct AdapterCtlBlk *acb)
 	}
 	srb = dcb->active_srb;
 	acb->active_dcb = NULL;
-	dprintkdbg(DBG_0, "disconnect: (pid#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "disconnect: (pid#%li)\n", srb->cmd->serial_number);
 
 	srb->scsi_phase = PH_BUS_FREE;	/* initial phase */
 	clear_fifo(acb, "disconnect");
@@ -3072,13 +3072,13 @@ static void disconnect(struct AdapterCtlBlk *acb)
 				srb->state = SRB_READY;
 				dprintkl(KERN_DEBUG,
 					"disconnect: (pid#%li) Unexpected\n",
-					srb->cmd->pid);
+					srb->cmd->serial_number);
 				srb->target_status = SCSI_STAT_SEL_TIMEOUT;
 				goto disc1;
 			} else {
 				/* Normal selection timeout */
 				dprintkdbg(DBG_KG, "disconnect: (pid#%li) "
-					"<%02i-%i> SelTO\n", srb->cmd->pid,
+					"<%02i-%i> SelTO\n", srb->cmd->serial_number,
 					dcb->target_id, dcb->target_lun);
 				if (srb->retry_count++ > DC395x_MAX_RETRIES
 				    || acb->scan_devices) {
@@ -3090,7 +3090,7 @@ static void disconnect(struct AdapterCtlBlk *acb)
 				srb_going_to_waiting_move(dcb, srb);
 				dprintkdbg(DBG_KG,
 					"disconnect: (pid#%li) Retry\n",
-					srb->cmd->pid);
+					srb->cmd->serial_number);
 				waiting_set_timer(acb, HZ / 20);
 			}
 		} else if (srb->state & SRB_DISCONNECT) {
@@ -3144,7 +3144,7 @@ static void reselect(struct AdapterCtlBlk *acb)
 		if (!acb->scan_devices) {
 			dprintkdbg(DBG_KG, "reselect: (pid#%li) <%02i-%i> "
 				"Arb lost but Resel win rsel=%i stat=0x%04x\n",
-				srb->cmd->pid, dcb->target_id,
+				srb->cmd->serial_number, dcb->target_id,
 				dcb->target_lun, rsel_tar_lun_id,
 				DC395x_read16(acb, TRM_S1040_SCSI_STATUS));
 			arblostflag = 1;
@@ -3318,7 +3318,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 	enum dma_data_direction dir = cmd->sc_data_direction;
 	int ckc_only = 1;
 
-	dprintkdbg(DBG_1, "srb_done: (pid#%li) <%02i-%i>\n", srb->cmd->pid,
+	dprintkdbg(DBG_1, "srb_done: (pid#%li) <%02i-%i>\n", srb->cmd->serial_number,
 		srb->cmd->device->id, srb->cmd->device->lun);
 	dprintkdbg(DBG_SG, "srb_done: srb=%p sg=%i(%i/%i) buf=%p\n",
 		   srb, scsi_sg_count(cmd), srb->sg_index, srb->sg_count,
@@ -3499,7 +3499,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		if (srb->total_xfer_length)
 			dprintkdbg(DBG_KG, "srb_done: (pid#%li) <%02i-%i> "
 				"cmnd=0x%02x Missed %i bytes\n",
-				cmd->pid, cmd->device->id, cmd->device->lun,
+				cmd->serial_number, cmd->device->id, cmd->device->lun,
 				cmd->cmnd[0], srb->total_xfer_length);
 	}
 
@@ -3509,7 +3509,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		dprintkl(KERN_ERR, "srb_done: ERROR! Completed cmd with tmp_srb\n");
 	else {
 		dprintkdbg(DBG_0, "srb_done: (pid#%li) done result=0x%08x\n",
-			cmd->pid, cmd->result);
+			cmd->serial_number, cmd->result);
 		srb_free_insert(acb, srb);
 	}
 	pci_unmap_srb(acb, srb);
@@ -3538,7 +3538,7 @@ static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
 			p = srb->cmd;
 			dir = p->sc_data_direction;
 			result = MK_RES(0, did_flag, 0, 0);
-			printk("G:%li(%02i-%i) ", p->pid,
+			printk("G:%li(%02i-%i) ", p->serial_number,
 			       p->device->id, p->device->lun);
 			srb_going_remove(dcb, srb);
 			free_tag(dcb, srb);
@@ -3568,7 +3568,7 @@ static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
 			p = srb->cmd;
 
 			result = MK_RES(0, did_flag, 0, 0);
-			printk("W:%li<%02i-%i>", p->pid, p->device->id,
+			printk("W:%li<%02i-%i>", p->serial_number, p->device->id,
 			       p->device->lun);
 			srb_waiting_remove(dcb, srb);
 			srb_free_insert(acb, srb);
@@ -3678,7 +3678,7 @@ static void request_sense(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 {
 	struct scsi_cmnd *cmd = srb->cmd;
 	dprintkdbg(DBG_1, "request_sense: (pid#%li) <%02i-%i>\n",
-		cmd->pid, cmd->device->id, cmd->device->lun);
+		cmd->serial_number, cmd->device->id, cmd->device->lun);
 
 	srb->flag |= AUTO_REQSENSE;
 	srb->adapter_status = 0;
@@ -3709,7 +3709,7 @@ static void request_sense(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 	if (start_scsi(acb, dcb, srb)) {	/* Should only happen, if sb. else grabs the bus */
 		dprintkl(KERN_DEBUG,
 			"request_sense: (pid#%li) failed <%02i-%i>\n",
-			srb->cmd->pid, dcb->target_id, dcb->target_lun);
+			srb->cmd->serial_number, dcb->target_id, dcb->target_lun);
 		srb_going_to_waiting_move(dcb, srb);
 		waiting_set_timer(acb, HZ / 100);
 	}
@@ -4717,13 +4717,13 @@ static int dc395x_proc_info(struct Scsi_Host *host, char *buffer,
 				dcb->target_id, dcb->target_lun,
 				list_size(&dcb->srb_waiting_list));
                 list_for_each_entry(srb, &dcb->srb_waiting_list, list)
-			SPRINTF(" %li", srb->cmd->pid);
+			SPRINTF(" %li", srb->cmd->serial_number);
 		if (!list_empty(&dcb->srb_going_list))
 			SPRINTF("\nDCB (%02i-%i): Going  : %i:",
 				dcb->target_id, dcb->target_lun,
 				list_size(&dcb->srb_going_list));
 		list_for_each_entry(srb, &dcb->srb_going_list, list)
-			SPRINTF(" %li", srb->cmd->pid);
+			SPRINTF(" %li", srb->cmd->serial_number);
 		if (!list_empty(&dcb->srb_waiting_list) || !list_empty(&dcb->srb_going_list))
 			SPRINTF("\n");
 	}
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index a83e9f1..ec22331 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1758,7 +1758,7 @@ static int eata2x_queuecommand(struct scsi_cmnd *SCpnt,
 
 	if (SCpnt->host_scribble)
 		panic("%s: qcomm, pid %ld, SCpnt %p already active.\n",
-		      ha->board_name, SCpnt->pid, SCpnt);
+		      ha->board_name, SCpnt->serial_number, SCpnt);
 
 	/* i is the mailbox number, look for the first free mailbox
 	   starting from last_cp_used */
@@ -1792,7 +1792,7 @@ static int eata2x_queuecommand(struct scsi_cmnd *SCpnt,
 
 	if (do_trace)
 		scmd_printk(KERN_INFO, SCpnt,
-			"qcomm, mbox %d, pid %ld.\n", i, SCpnt->pid);
+			"qcomm, mbox %d, pid %ld.\n", i, SCpnt->serial_number);
 
 	cpp->reqsen = 1;
 	cpp->dispri = 1;
@@ -1825,7 +1825,7 @@ static int eata2x_queuecommand(struct scsi_cmnd *SCpnt,
 		unmap_dma(i, ha);
 		SCpnt->host_scribble = NULL;
 		scmd_printk(KERN_INFO, SCpnt,
-			"qcomm, pid %ld, adapter busy.\n", SCpnt->pid);
+			"qcomm, pid %ld, adapter busy.\n", SCpnt->serial_number);
 		return 1;
 	}
 
@@ -1841,13 +1841,13 @@ static int eata2x_eh_abort(struct scsi_cmnd *SCarg)
 
 	if (SCarg->host_scribble == NULL) {
 		scmd_printk(KERN_INFO, SCarg,
-			"abort, pid %ld inactive.\n", SCarg->pid);
+			"abort, pid %ld inactive.\n", SCarg->serial_number);
 		return SUCCESS;
 	}
 
 	i = *(unsigned int *)SCarg->host_scribble;
 	scmd_printk(KERN_WARNING, SCarg,
-		"abort, mbox %d, pid %ld.\n", i, SCarg->pid);
+		"abort, mbox %d, pid %ld.\n", i, SCarg->serial_number);
 
 	if (i >= shost->can_queue)
 		panic("%s: abort, invalid SCarg->host_scribble.\n", ha->board_name);
@@ -1892,7 +1892,7 @@ static int eata2x_eh_abort(struct scsi_cmnd *SCarg)
 		SCarg->host_scribble = NULL;
 		ha->cp_stat[i] = FREE;
 		printk("%s, abort, mbox %d ready, DID_ABORT, pid %ld done.\n",
-		       ha->board_name, i, SCarg->pid);
+		       ha->board_name, i, SCarg->serial_number);
 		SCarg->scsi_done(SCarg);
 		return SUCCESS;
 	}
@@ -1909,12 +1909,12 @@ static int eata2x_eh_host_reset(struct scsi_cmnd *SCarg)
 	struct hostdata *ha = (struct hostdata *)shost->hostdata;
 
 	scmd_printk(KERN_INFO, SCarg,
-		"reset, enter, pid %ld.\n", SCarg->pid);
+		"reset, enter, pid %ld.\n", SCarg->serial_number);
 
 	spin_lock_irq(shost->host_lock);
 
 	if (SCarg->host_scribble == NULL)
-		printk("%s: reset, pid %ld inactive.\n", ha->board_name, SCarg->pid);
+		printk("%s: reset, pid %ld inactive.\n", ha->board_name, SCarg->serial_number);
 
 	if (ha->in_reset) {
 		printk("%s: reset, exit, already in reset.\n", ha->board_name);
@@ -1954,13 +1954,13 @@ static int eata2x_eh_host_reset(struct scsi_cmnd *SCarg)
 		if (ha->cp_stat[i] == READY || ha->cp_stat[i] == ABORTING) {
 			ha->cp_stat[i] = ABORTING;
 			printk("%s: reset, mbox %d aborting, pid %ld.\n",
-			       ha->board_name, i, SCpnt->pid);
+			       ha->board_name, i, SCpnt->serial_number);
 		}
 
 		else {
 			ha->cp_stat[i] = IN_RESET;
 			printk("%s: reset, mbox %d in reset, pid %ld.\n",
-			       ha->board_name, i, SCpnt->pid);
+			       ha->board_name, i, SCpnt->serial_number);
 		}
 
 		if (SCpnt->host_scribble == NULL)
@@ -2015,7 +2015,7 @@ static int eata2x_eh_host_reset(struct scsi_cmnd *SCarg)
 
 			printk
 			    ("%s, reset, mbox %d locked, DID_RESET, pid %ld done.\n",
-			     ha->board_name, i, SCpnt->pid);
+			     ha->board_name, i, SCpnt->serial_number);
 		}
 
 		else if (ha->cp_stat[i] == ABORTING) {
@@ -2029,7 +2029,7 @@ static int eata2x_eh_host_reset(struct scsi_cmnd *SCarg)
 
 			printk
 			    ("%s, reset, mbox %d aborting, DID_RESET, pid %ld done.\n",
-			     ha->board_name, i, SCpnt->pid);
+			     ha->board_name, i, SCpnt->serial_number);
 		}
 
 		else
@@ -2043,7 +2043,7 @@ static int eata2x_eh_host_reset(struct scsi_cmnd *SCarg)
 	do_trace = 0;
 
 	if (arg_done)
-		printk("%s: reset, exit, pid %ld done.\n", ha->board_name, SCarg->pid);
+		printk("%s: reset, exit, pid %ld done.\n", ha->board_name, SCarg->serial_number);
 	else
 		printk("%s: reset, exit.\n", ha->board_name);
 
@@ -2182,7 +2182,7 @@ static int reorder(struct hostdata *ha, unsigned long cursec,
 			cpp = &ha->cp[k];
 			SCpnt = cpp->SCpnt;
 			ll[n] = SCpnt->request->nr_sectors;
-			pl[n] = SCpnt->pid;
+			pl[n] = SCpnt->serial_number;
 
 			if (!n)
 				continue;
@@ -2230,7 +2230,7 @@ static int reorder(struct hostdata *ha, unsigned long cursec,
 			    "%s pid %ld mb %d fc %d nr %d sec %ld ns %ld"
 			     " cur %ld s:%c r:%c rev:%c in:%c ov:%c xd %d.\n",
 			     (ihdlr ? "ihdlr" : "qcomm"),
-			     SCpnt->pid, k, flushcount,
+			     SCpnt->serial_number, k, flushcount,
 			     n_ready, SCpnt->request->sector,
 			     SCpnt->request->nr_sectors, cursec, YESNO(s),
 			     YESNO(r), YESNO(rev), YESNO(input_only),
@@ -2277,7 +2277,7 @@ static void flush_dev(struct scsi_device *dev, unsigned long cursec,
 			    "%s, pid %ld, mbox %d, adapter"
 			     " busy, will abort.\n",
 			     (ihdlr ? "ihdlr" : "qcomm"),
-			     SCpnt->pid, k);
+			     SCpnt->serial_number, k);
 			ha->cp_stat[k] = ABORTING;
 			continue;
 		}
@@ -2391,11 +2391,11 @@ static irqreturn_t ihdlr(int irq, struct Scsi_Host *shost)
 
 	if (SCpnt->host_scribble == NULL)
 		panic("%s: ihdlr, mbox %d, pid %ld, SCpnt %p garbled.\n", ha->board_name,
-		      i, SCpnt->pid, SCpnt);
+		      i, SCpnt->serial_number, SCpnt);
 
 	if (*(unsigned int *)SCpnt->host_scribble != i)
 		panic("%s: ihdlr, mbox %d, pid %ld, index mismatch %d.\n",
-		      ha->board_name, i, SCpnt->pid,
+		      ha->board_name, i, SCpnt->serial_number,
 		      *(unsigned int *)SCpnt->host_scribble);
 
 	sync_dma(i, ha);
@@ -2445,12 +2445,12 @@ static irqreturn_t ihdlr(int irq, struct Scsi_Host *shost)
 			       "target_status 0x%x, sense key 0x%x.\n",
 			       ha->board_name,
 			       SCpnt->device->channel, SCpnt->device->id,
-			       SCpnt->device->lun, SCpnt->pid,
+			       SCpnt->device->lun, SCpnt->serial_number,
 			       spp->target_status, SCpnt->sense_buffer[2]);
 
 		ha->target_to[SCpnt->device->id][SCpnt->device->channel] = 0;
 
-		if (ha->last_retried_pid == SCpnt->pid)
+		if (ha->last_retried_pid == SCpnt->serial_number)
 			ha->retries = 0;
 
 		break;
@@ -2485,7 +2485,7 @@ static irqreturn_t ihdlr(int irq, struct Scsi_Host *shost)
 #endif
 
 			ha->retries++;
-			ha->last_retried_pid = SCpnt->pid;
+			ha->last_retried_pid = SCpnt->serial_number;
 		} else
 			status = DID_ERROR << 16;
 
@@ -2516,7 +2516,7 @@ static irqreturn_t ihdlr(int irq, struct Scsi_Host *shost)
 		scmd_printk(KERN_INFO, SCpnt, "ihdlr, mbox %2d, err 0x%x:%x,"
 		       " pid %ld, reg 0x%x, count %d.\n",
 		       i, spp->adapter_status, spp->target_status,
-		       SCpnt->pid, reg, ha->iocount);
+		       SCpnt->serial_number, reg, ha->iocount);
 
 	unmap_dma(i, ha);
 
diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index f33ad01..678ea6d 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -390,7 +390,7 @@ static int eata_pio_queue(struct scsi_cmnd *cmd,
 
 	DBG(DBG_QUEUE, scmd_printk(KERN_DEBUG, cmd,
 		"eata_pio_queue pid %ld, y %d\n",
-		cmd->pid, y));
+		cmd->serial_number, y));
 
 	cmd->scsi_done = (void *) done;
 
@@ -435,7 +435,7 @@ static int eata_pio_queue(struct scsi_cmnd *cmd,
 		cmd->result = DID_BUS_BUSY << 16;
 		scmd_printk(KERN_NOTICE, cmd,
 			"eata_pio_queue pid %ld, HBA busy, "
-			"returning DID_BUS_BUSY, done.\n", cmd->pid);
+			"returning DID_BUS_BUSY, done.\n", cmd->serial_number);
 		done(cmd);
 		cp->status = FREE;
 		return (0);
@@ -450,7 +450,7 @@ static int eata_pio_queue(struct scsi_cmnd *cmd,
 
 	DBG(DBG_QUEUE, scmd_printk(KERN_DEBUG, cmd,
 		"Queued base %#.4lx pid: %ld "
-		"slot %d irq %d\n", sh->base, cmd->pid, y, sh->irq));
+		"slot %d irq %d\n", sh->base, cmd->serial_number, y, sh->irq));
 
 	return (0);
 }
@@ -461,7 +461,7 @@ static int eata_pio_abort(struct scsi_cmnd *cmd)
 
 	DBG(DBG_ABNORM, scmd_printk(KERN_WARNING, cmd,
 		"eata_pio_abort called pid: %ld\n",
-		cmd->pid));
+		cmd->serial_number));
 
 	while (inb(cmd->device->host->base + HA_RAUXSTAT) & HA_ABUSY)
 		if (--loop == 0) {
@@ -497,7 +497,7 @@ static int eata_pio_host_reset(struct scsi_cmnd *cmd)
 
 	DBG(DBG_ABNORM, scmd_printk(KERN_WARNING, cmd,
 		"eata_pio_reset called pid:%ld\n",
-		cmd->pid));
+		cmd->serial_number));
 
 	spin_lock_irq(host->host_lock);
 
@@ -516,7 +516,7 @@ static int eata_pio_host_reset(struct scsi_cmnd *cmd)
 
 		sp = HD(cmd)->ccb[x].cmd;
 		HD(cmd)->ccb[x].status = RESET;
-		printk(KERN_WARNING "eata_pio_reset: slot %d in reset, pid %ld.\n", x, sp->pid);
+		printk(KERN_WARNING "eata_pio_reset: slot %d in reset, pid %ld.\n", x, sp->serial_number);
 
 		if (sp == NULL)
 			panic("eata_pio_reset: slot %d, sp==NULL.\n", x);
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index 312190a..ab7cbf3 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -343,7 +343,7 @@ static int in2000_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 	instance = cmd->device->host;
 	hostdata = (struct IN2000_hostdata *) instance->hostdata;
 
-	DB(DB_QUEUE_COMMAND, scmd_printk(KERN_DEBUG, cmd, "Q-%02x-%ld(", cmd->cmnd[0], cmd->pid))
+	DB(DB_QUEUE_COMMAND, scmd_printk(KERN_DEBUG, cmd, "Q-%02x-%ld(", cmd->cmnd[0], cmd->serial_number))
 
 /* Set up a few fields in the Scsi_Cmnd structure for our own use:
  *  - host_scribble is the pointer to the next cmd in the input queue
@@ -427,7 +427,7 @@ static int in2000_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 
 	in2000_execute(cmd->device->host);
 
-	DB(DB_QUEUE_COMMAND, printk(")Q-%ld ", cmd->pid))
+	DB(DB_QUEUE_COMMAND, printk(")Q-%ld ", cmd->serial_number))
 	    return 0;
 }
 
@@ -703,7 +703,7 @@ static void in2000_execute(struct Scsi_Host *instance)
 	 * to search the input_Q again...
 	 */
 
-	DB(DB_EXECUTE, printk("%s%ld)EX-2 ", (cmd->SCp.phase) ? "d:" : "", cmd->pid))
+	DB(DB_EXECUTE, printk("%s%ld)EX-2 ", (cmd->SCp.phase) ? "d:" : "", cmd->serial_number))
 
 }
 
@@ -1147,7 +1147,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 	case CSR_XFER_DONE | PHS_COMMAND:
 	case CSR_UNEXP | PHS_COMMAND:
 	case CSR_SRV_REQ | PHS_COMMAND:
-		DB(DB_INTR, printk("CMND-%02x,%ld", cmd->cmnd[0], cmd->pid))
+		DB(DB_INTR, printk("CMND-%02x,%ld", cmd->cmnd[0], cmd->serial_number))
 		    transfer_pio(cmd->cmnd, cmd->cmd_len, DATA_OUT_DIR, hostdata);
 		hostdata->state = S_CONNECTED;
 		break;
@@ -1189,7 +1189,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 		switch (msg) {
 
 		case COMMAND_COMPLETE:
-			DB(DB_INTR, printk("CCMP-%ld", cmd->pid))
+			DB(DB_INTR, printk("CCMP-%ld", cmd->serial_number))
 			    write_3393_cmd(hostdata, WD_CMD_NEGATE_ACK);
 			hostdata->state = S_PRE_CMP_DISC;
 			break;
@@ -1327,7 +1327,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 
 		write_3393(hostdata, WD_SOURCE_ID, SRCID_ER);
 		if (phs == 0x60) {
-			DB(DB_INTR, printk("SX-DONE-%ld", cmd->pid))
+			DB(DB_INTR, printk("SX-DONE-%ld", cmd->serial_number))
 			    cmd->SCp.Message = COMMAND_COMPLETE;
 			lun = read_3393(hostdata, WD_TARGET_LUN);
 			DB(DB_INTR, printk(":%d.%d", cmd->SCp.Status, lun))
@@ -1348,7 +1348,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 
 			in2000_execute(instance);
 		} else {
-			printk("%02x:%02x:%02x-%ld: Unknown SEL_XFER_DONE phase!!---", asr, sr, phs, cmd->pid);
+			printk("%02x:%02x:%02x-%ld: Unknown SEL_XFER_DONE phase!!---", asr, sr, phs, cmd->serial_number);
 		}
 		break;
 
@@ -1415,7 +1415,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 			spin_unlock_irqrestore(instance->host_lock, flags);
 			return IRQ_HANDLED;
 		}
-		DB(DB_INTR, printk("UNEXP_DISC-%ld", cmd->pid))
+		DB(DB_INTR, printk("UNEXP_DISC-%ld", cmd->serial_number))
 		    hostdata->connected = NULL;
 		hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
 		hostdata->state = S_UNCONNECTED;
@@ -1440,7 +1440,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
  */
 
 		write_3393(hostdata, WD_SOURCE_ID, SRCID_ER);
-		DB(DB_INTR, printk("DISC-%ld", cmd->pid))
+		DB(DB_INTR, printk("DISC-%ld", cmd->serial_number))
 		    if (cmd == NULL) {
 			printk(" - Already disconnected! ");
 			hostdata->state = S_UNCONNECTED;
@@ -1573,7 +1573,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 		} else
 			hostdata->state = S_CONNECTED;
 
-		DB(DB_INTR, printk("-%ld", cmd->pid))
+		DB(DB_INTR, printk("-%ld", cmd->serial_number))
 		    break;
 
 	default:
@@ -1702,7 +1702,7 @@ static int __in2000_abort(Scsi_Cmnd * cmd)
 				prev->host_scribble = cmd->host_scribble;
 			cmd->host_scribble = NULL;
 			cmd->result = DID_ABORT << 16;
-			printk(KERN_WARNING "scsi%d: Abort - removing command %ld from input_Q. ", instance->host_no, cmd->pid);
+			printk(KERN_WARNING "scsi%d: Abort - removing command %ld from input_Q. ", instance->host_no, cmd->serial_number);
 			cmd->scsi_done(cmd);
 			return SUCCESS;
 		}
@@ -1723,7 +1723,7 @@ static int __in2000_abort(Scsi_Cmnd * cmd)
 
 	if (hostdata->connected == cmd) {
 
-		printk(KERN_WARNING "scsi%d: Aborting connected command %ld - ", instance->host_no, cmd->pid);
+		printk(KERN_WARNING "scsi%d: Aborting connected command %ld - ", instance->host_no, cmd->serial_number);
 
 		printk("sending wd33c93 ABORT command - ");
 		write_3393(hostdata, WD_CONTROL, CTRL_IDI | CTRL_EDI | CTRL_POLLED);
@@ -2268,7 +2268,7 @@ static int in2000_proc_info(struct Scsi_Host *instance, char *buf, char **start,
 		strcat(bp, "\nconnected:     ");
 		if (hd->connected) {
 			cmd = (Scsi_Cmnd *) hd->connected;
-			sprintf(tbuf, " %ld-%d:%d(%02x)", cmd->pid, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+			sprintf(tbuf, " %ld-%d:%d(%02x)", cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			strcat(bp, tbuf);
 		}
 	}
@@ -2276,7 +2276,7 @@ static int in2000_proc_info(struct Scsi_Host *instance, char *buf, char **start,
 		strcat(bp, "\ninput_Q:       ");
 		cmd = (Scsi_Cmnd *) hd->input_Q;
 		while (cmd) {
-			sprintf(tbuf, " %ld-%d:%d(%02x)", cmd->pid, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+			sprintf(tbuf, " %ld-%d:%d(%02x)", cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			strcat(bp, tbuf);
 			cmd = (Scsi_Cmnd *) cmd->host_scribble;
 		}
@@ -2285,7 +2285,7 @@ static int in2000_proc_info(struct Scsi_Host *instance, char *buf, char **start,
 		strcat(bp, "\ndisconnected_Q:");
 		cmd = (Scsi_Cmnd *) hd->disconnected_Q;
 		while (cmd) {
-			sprintf(tbuf, " %ld-%d:%d(%02x)", cmd->pid, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+			sprintf(tbuf, " %ld-%d:%d(%02x)", cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			strcat(bp, tbuf);
 			cmd = (Scsi_Cmnd *) cmd->host_scribble;
 		}
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 030ba49..1dc88b8 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -8143,12 +8143,7 @@ static int ncr53c8xx_abort(struct scsi_cmnd *cmd)
 	unsigned long flags;
 	struct scsi_cmnd *done_list;
 
-#if defined SCSI_RESET_SYNCHRONOUS && defined SCSI_RESET_ASYNCHRONOUS
-	printk("ncr53c8xx_abort: pid=%lu serial_number=%ld\n",
-		cmd->pid, cmd->serial_number);
-#else
-	printk("ncr53c8xx_abort: command pid %lu\n", cmd->pid);
-#endif
+	printk("ncr53c8xx_abort: command pid %lu\n", cmd->serial_number);
 
 	NCR_LOCK_NCB(np, flags);
 
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 54d8bdf..fba8aa8 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4086,7 +4086,7 @@ __qla1280_print_scsi_cmd(struct scsi_cmnd *cmd)
 	   } */
 	printk("  tag=%d, transfersize=0x%x \n",
 	       cmd->tag, cmd->transfersize);
-	printk("  Pid=%li, SP=0x%p\n", cmd->pid, CMD_SP(cmd));
+	printk("  Pid=%li, SP=0x%p\n", cmd->serial_number, CMD_SP(cmd));
 	printk(" underflow size = 0x%x, direction=0x%x\n",
 	       cmd->underflow, cmd->sc_data_direction);
 }
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index a5de1a8..07a7c2a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -442,7 +442,7 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 #endif
 
 /* 
- * Assign a serial number and pid to the request for error recovery
+ * Assign a serial number to the request for error recovery
  * and debugging purposes.  Protected by the Host_Lock of host.
  */
 static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
@@ -450,10 +450,6 @@ static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd
 	cmd->serial_number = host->cmd_serial_number++;
 	if (cmd->serial_number == 0) 
 		cmd->serial_number = host->cmd_serial_number++;
-	
-	cmd->pid = host->cmd_pid++;
-	if (cmd->pid == 0)
-		cmd->pid = host->cmd_pid++;
 }
 
 /*
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c8e351f..99b217f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1682,12 +1682,6 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 
 	init_timer(&scmd->eh_timeout);
 
-	/*
-	 * Sometimes the command can get back into the timer chain,
-	 * so use the pid as an identifier.
-	 */
-	scmd->pid			= 0;
-
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->tmf_in_progress = 1;
 	spin_unlock_irqrestore(shost->host_lock, flags);
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 5db1520..5c72ca3 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -567,12 +567,12 @@ dc390_StartSCSI( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_sr
 	pDCB->TagMask |= 1 << tag[1];
 	pSRB->TagNumber = tag[1];
 	DC390_write8(ScsiFifo, tag[1]);
-	DEBUG1(printk(KERN_INFO "DC390: Select w/DisCn for Cmd %li (SRB %p), block tag %02x\n", scmd->pid, pSRB, tag[1]));
+	DEBUG1(printk(KERN_INFO "DC390: Select w/DisCn for Cmd %li (SRB %p), block tag %02x\n", scmd->serial_number, pSRB, tag[1]));
 	cmd = SEL_W_ATN3;
     } else {
 	/* No TagQ */
 //no_tag:
-	DEBUG1(printk(KERN_INFO "DC390: Select w%s/DisCn for Cmd %li (SRB %p), No TagQ\n", disc_allowed ? "" : "o", scmd->pid, pSRB));
+	DEBUG1(printk(KERN_INFO "DC390: Select w%s/DisCn for Cmd %li (SRB %p), No TagQ\n", disc_allowed ? "" : "o", scmd->serial_number, pSRB));
     }
 
     pSRB->SRBState = SRB_START_;
@@ -623,7 +623,7 @@ dc390_StartSCSI( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_sr
     {
 	dc390_freetag (pDCB, pSRB);
 	DEBUG0(printk ("DC390: Interrupt during Start SCSI (pid %li, target %02i-%02i)\n",
-		scmd->pid, scmd->device->id, scmd->device->lun));
+		scmd->serial_number, scmd->device->id, scmd->device->lun));
 	pSRB->SRBState = SRB_READY;
 	//DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
 	pACB->SelLost++;
@@ -1708,7 +1708,7 @@ dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb*
     status = pSRB->TargetStatus;
 
     DEBUG0(printk (" SRBdone (%02x,%08x), SRB %p, pid %li\n", status, pcmd->result,\
-		pSRB, pcmd->pid));
+		pSRB, pcmd->serial_number));
     if(pSRB->SRBFlag & AUTO_REQSENSE)
     {	/* Last command was a Request Sense */
 	pSRB->SRBFlag &= ~AUTO_REQSENSE;
@@ -1729,7 +1729,7 @@ dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb*
 	    } else {
 		SET_RES_DRV(pcmd->result, DRIVER_SENSE);
 		//pSRB->ScsiCmdLen	 = (u8) (pSRB->Segment1[0] >> 8);
-		DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->pid, pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
+		DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->serial_number, pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
 		pSRB->TotalXferredLen = 0;
 		SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
 	    }
@@ -1749,7 +1749,7 @@ dc390_SRBdone( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb*
 	else if (status == SAM_STAT_TASK_SET_FULL)
 	{
 	    scsi_track_queue_full(pcmd->device, pDCB->GoingSRBCnt - 1);
-	    DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->pid, pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
+	    DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->serial_number, pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
 	    pSRB->TotalXferredLen = 0;
 	    SET_RES_DID(pcmd->result, DID_SOFT_ERROR);
 	}
@@ -1803,7 +1803,7 @@ cmd_done:
     /* Add to free list */
     dc390_Free_insert (pACB, pSRB);
 
-    DEBUG0(printk (KERN_DEBUG "DC390: SRBdone: done pid %li\n", pcmd->pid));
+    DEBUG0(printk (KERN_DEBUG "DC390: SRBdone: done pid %li\n", pcmd->serial_number));
     pcmd->scsi_done (pcmd);
 
     return;
@@ -1998,7 +1998,7 @@ static int DC390_abort(struct scsi_cmnd *cmd)
 	struct dc390_dcb *pDCB = (struct dc390_dcb*) cmd->device->hostdata;
 
 	scmd_printk(KERN_WARNING, cmd,
-		"DC390: Abort command (pid %li)\n", cmd->pid);
+		"DC390: Abort command (pid %li)\n", cmd->serial_number);
 
 	/* abort() is too stupid for already sent commands at the moment. 
 	 * If it's called we are in trouble anyway, so let's dump some info 
@@ -2006,7 +2006,7 @@ static int DC390_abort(struct scsi_cmnd *cmd)
 	dc390_dumpinfo(pACB, pDCB, NULL);
 
 	pDCB->DCBFlag |= ABORT_DEV_;
-	printk(KERN_INFO "DC390: Aborted pid %li\n", cmd->pid);
+	printk(KERN_INFO "DC390: Aborted pid %li\n", cmd->serial_number);
 
 	return FAILED;
 }
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 9e8232a..fc9f518 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1254,7 +1254,7 @@ static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scs
 
    if (SCpnt->host_scribble)
       panic("%s: qcomm, pid %ld, SCpnt %p already active.\n",
-            BN(j), SCpnt->pid, SCpnt);
+            BN(j), SCpnt->serial_number, SCpnt);
 
    /* i is the mailbox number, look for the first free mailbox
       starting from last_cp_used */
@@ -1285,7 +1285,7 @@ static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scs
 
    if (do_trace) printk("%s: qcomm, mbox %d, target %d.%d:%d, pid %ld.\n",
                         BN(j), i, SCpnt->device->channel, SCpnt->device->id,
-                        SCpnt->device->lun, SCpnt->pid);
+                        SCpnt->device->lun, SCpnt->serial_number);
 
    cpp->opcode = OP_SCSI;
    cpp->channel = SCpnt->device->channel;
@@ -1312,7 +1312,7 @@ static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scs
       unmap_dma(i, j);
       SCpnt->host_scribble = NULL;
       scmd_printk(KERN_INFO, SCpnt,
-      		"qcomm, pid %ld, adapter busy.\n", SCpnt->pid);
+      		"qcomm, pid %ld, adapter busy.\n", SCpnt->serial_number);
       return 1;
       }
 
@@ -1333,13 +1333,13 @@ static int u14_34f_eh_abort(struct scsi_cmnd *SCarg) {
 
    if (SCarg->host_scribble == NULL) {
       scmd_printk(KERN_INFO, SCarg, "abort, pid %ld inactive.\n",
-             SCarg->pid);
+             SCarg->serial_number);
       return SUCCESS;
       }
 
    i = *(unsigned int *)SCarg->host_scribble;
    scmd_printk(KERN_INFO, SCarg, "abort, mbox %d, pid %ld.\n",
-	       i, SCarg->pid);
+	       i, SCarg->serial_number);
 
    if (i >= sh[j]->can_queue)
       panic("%s: abort, invalid SCarg->host_scribble.\n", BN(j));
@@ -1383,7 +1383,7 @@ static int u14_34f_eh_abort(struct scsi_cmnd *SCarg) {
       SCarg->host_scribble = NULL;
       HD(j)->cp_stat[i] = FREE;
       printk("%s, abort, mbox %d ready, DID_ABORT, pid %ld done.\n",
-             BN(j), i, SCarg->pid);
+             BN(j), i, SCarg->serial_number);
       SCarg->scsi_done(SCarg);
       return SUCCESS;
       }
@@ -1397,12 +1397,12 @@ static int u14_34f_eh_host_reset(struct scsi_cmnd *SCarg) {
    struct scsi_cmnd *SCpnt;
 
    j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;
-   scmd_printk(KERN_INFO, SCarg, "reset, enter, pid %ld.\n", SCarg->pid);
+   scmd_printk(KERN_INFO, SCarg, "reset, enter, pid %ld.\n", SCarg->serial_number);
 
    spin_lock_irq(sh[j]->host_lock);
 
    if (SCarg->host_scribble == NULL)
-      printk("%s: reset, pid %ld inactive.\n", BN(j), SCarg->pid);
+      printk("%s: reset, pid %ld inactive.\n", BN(j), SCarg->serial_number);
 
    if (HD(j)->in_reset) {
       printk("%s: reset, exit, already in reset.\n", BN(j));
@@ -1440,13 +1440,13 @@ static int u14_34f_eh_host_reset(struct scsi_cmnd *SCarg) {
       if (HD(j)->cp_stat[i] == READY || HD(j)->cp_stat[i] == ABORTING) {
          HD(j)->cp_stat[i] = ABORTING;
          printk("%s: reset, mbox %d aborting, pid %ld.\n",
-                BN(j), i, SCpnt->pid);
+                BN(j), i, SCpnt->serial_number);
          }
 
       else {
          HD(j)->cp_stat[i] = IN_RESET;
          printk("%s: reset, mbox %d in reset, pid %ld.\n",
-                BN(j), i, SCpnt->pid);
+                BN(j), i, SCpnt->serial_number);
          }
 
       if (SCpnt->host_scribble == NULL)
@@ -1495,7 +1495,7 @@ static int u14_34f_eh_host_reset(struct scsi_cmnd *SCarg) {
          HD(j)->cp_stat[i] = LOCKED;
 
          printk("%s, reset, mbox %d locked, DID_RESET, pid %ld done.\n",
-                BN(j), i, SCpnt->pid);
+                BN(j), i, SCpnt->serial_number);
          }
 
       else if (HD(j)->cp_stat[i] == ABORTING) {
@@ -1508,7 +1508,7 @@ static int u14_34f_eh_host_reset(struct scsi_cmnd *SCarg) {
          HD(j)->cp_stat[i] = FREE;
 
          printk("%s, reset, mbox %d aborting, DID_RESET, pid %ld done.\n",
-                BN(j), i, SCpnt->pid);
+                BN(j), i, SCpnt->serial_number);
          }
 
       else
@@ -1522,7 +1522,7 @@ static int u14_34f_eh_host_reset(struct scsi_cmnd *SCarg) {
    HD(j)->in_reset = FALSE;
    do_trace = FALSE;
 
-   if (arg_done) printk("%s: reset, exit, pid %ld done.\n", BN(j), SCarg->pid);
+   if (arg_done) printk("%s: reset, exit, pid %ld done.\n", BN(j), SCarg->serial_number);
    else          printk("%s: reset, exit.\n", BN(j));
 
    spin_unlock_irq(sh[j]->host_lock);
@@ -1639,7 +1639,7 @@ static int reorder(unsigned int j, unsigned long cursec,
 
    if (!input_only) for (n = 0; n < n_ready; n++) {
       k = il[n]; cpp = &HD(j)->cp[k]; SCpnt = cpp->SCpnt;
-      ll[n] = SCpnt->request->nr_sectors; pl[n] = SCpnt->pid;
+      ll[n] = SCpnt->request->nr_sectors; pl[n] = SCpnt->serial_number;
 
       if (!n) continue;
 
@@ -1666,7 +1666,7 @@ static int reorder(unsigned int j, unsigned long cursec,
          printk("%s %d.%d:%d pid %ld mb %d fc %d nr %d sec %ld ns %ld"\
                 " cur %ld s:%c r:%c rev:%c in:%c ov:%c xd %d.\n",
                 (ihdlr ? "ihdlr" : "qcomm"), SCpnt->channel, SCpnt->target,
-                SCpnt->lun, SCpnt->pid, k, flushcount, n_ready,
+                SCpnt->lun, SCpnt->serial_number, k, flushcount, n_ready,
                 SCpnt->request->sector, SCpnt->request->nr_sectors, cursec,
                 YESNO(s), YESNO(r), YESNO(rev), YESNO(input_only),
                 YESNO(overlap), cpp->xdir);
@@ -1703,7 +1703,7 @@ static void flush_dev(struct scsi_device *dev, unsigned long cursec, unsigned in
          scmd_printk(KERN_INFO, SCpnt,
 	 	"%s, pid %ld, mbox %d, adapter"
                 " busy, will abort.\n", (ihdlr ? "ihdlr" : "qcomm"),
-                SCpnt->pid, k);
+                SCpnt->serial_number, k);
          HD(j)->cp_stat[k] = ABORTING;
          continue;
          }
@@ -1787,11 +1787,11 @@ static irqreturn_t ihdlr(int irq, unsigned int j) {
 
    if (SCpnt->host_scribble == NULL)
       panic("%s: ihdlr, mbox %d, pid %ld, SCpnt %p garbled.\n", BN(j), i,
-            SCpnt->pid, SCpnt);
+            SCpnt->serial_number, SCpnt);
 
    if (*(unsigned int *)SCpnt->host_scribble != i)
       panic("%s: ihdlr, mbox %d, pid %ld, index mismatch %d.\n",
-            BN(j), i, SCpnt->pid, *(unsigned int *)SCpnt->host_scribble);
+            BN(j), i, SCpnt->serial_number, *(unsigned int *)SCpnt->host_scribble);
 
    sync_dma(i, j);
 
@@ -1835,12 +1835,12 @@ static irqreturn_t ihdlr(int irq, unsigned int j) {
                (SCpnt->sense_buffer[2] & 0xf) == NOT_READY)))
             scmd_printk(KERN_INFO, SCpnt,
 	    	"ihdlr, pid %ld, target_status 0x%x, sense key 0x%x.\n",
-                   SCpnt->pid, spp->target_status,
+                   SCpnt->serial_number, spp->target_status,
                    SCpnt->sense_buffer[2]);
 
          HD(j)->target_to[scmd_id(SCpnt)][scmd_channel(SCpnt)] = 0;
 
-         if (HD(j)->last_retried_pid == SCpnt->pid) HD(j)->retries = 0;
+         if (HD(j)->last_retried_pid == SCpnt->serial_number) HD(j)->retries = 0;
 
          break;
       case ASST:     /* Selection Time Out */
@@ -1877,7 +1877,7 @@ static irqreturn_t ihdlr(int irq, unsigned int j) {
 #endif
 
             HD(j)->retries++;
-            HD(j)->last_retried_pid = SCpnt->pid;
+            HD(j)->last_retried_pid = SCpnt->serial_number;
             }
          else
             status = DID_ERROR << 16;
@@ -1907,7 +1907,7 @@ static irqreturn_t ihdlr(int irq, unsigned int j) {
 #endif
       scmd_printk(KERN_INFO, SCpnt, "ihdlr, mbox %2d, err 0x%x:%x,"\
              " pid %ld, reg 0x%x, count %d.\n",
-             i, spp->adapter_status, spp->target_status, SCpnt->pid,
+             i, spp->adapter_status, spp->target_status, SCpnt->serial_number,
              reg, HD(j)->iocount);
 
    unmap_dma(i, j);
diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index b92ff04..0e8e642 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -381,7 +381,7 @@ wd33c93_queuecommand(struct scsi_cmnd *cmd,
 	hostdata = (struct WD33C93_hostdata *) cmd->device->host->hostdata;
 
 	DB(DB_QUEUE_COMMAND,
-	   printk("Q-%d-%02x-%ld( ", cmd->device->id, cmd->cmnd[0], cmd->pid))
+	   printk("Q-%d-%02x-%ld( ", cmd->device->id, cmd->cmnd[0], cmd->serial_number))
 
 /* Set up a few fields in the scsi_cmnd structure for our own use:
  *  - host_scribble is the pointer to the next cmd in the input queue
@@ -463,7 +463,7 @@ wd33c93_queuecommand(struct scsi_cmnd *cmd,
 
 	wd33c93_execute(cmd->device->host);
 
-	DB(DB_QUEUE_COMMAND, printk(")Q-%ld ", cmd->pid))
+	DB(DB_QUEUE_COMMAND, printk(")Q-%ld ", cmd->serial_number))
 
 	spin_unlock_irq(&hostdata->lock);
 	return 0;
@@ -686,7 +686,7 @@ wd33c93_execute(struct Scsi_Host *instance)
 	 */
 
 	DB(DB_EXECUTE,
-	   printk("%s%ld)EX-2 ", (cmd->SCp.phase) ? "d:" : "", cmd->pid))
+	   printk("%s%ld)EX-2 ", (cmd->SCp.phase) ? "d:" : "", cmd->serial_number))
 }
 
 static void
@@ -963,7 +963,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 	case CSR_XFER_DONE | PHS_COMMAND:
 	case CSR_UNEXP | PHS_COMMAND:
 	case CSR_SRV_REQ | PHS_COMMAND:
-		DB(DB_INTR, printk("CMND-%02x,%ld", cmd->cmnd[0], cmd->pid))
+		DB(DB_INTR, printk("CMND-%02x,%ld", cmd->cmnd[0], cmd->serial_number))
 		    transfer_pio(regs, cmd->cmnd, cmd->cmd_len, DATA_OUT_DIR,
 				 hostdata);
 		hostdata->state = S_CONNECTED;
@@ -1007,7 +1007,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 		switch (msg) {
 
 		case COMMAND_COMPLETE:
-			DB(DB_INTR, printk("CCMP-%ld", cmd->pid))
+			DB(DB_INTR, printk("CCMP-%ld", cmd->serial_number))
 			    write_wd33c93_cmd(regs, WD_CMD_NEGATE_ACK);
 			hostdata->state = S_PRE_CMP_DISC;
 			break;
@@ -1174,7 +1174,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 
 		write_wd33c93(regs, WD_SOURCE_ID, SRCID_ER);
 		if (phs == 0x60) {
-			DB(DB_INTR, printk("SX-DONE-%ld", cmd->pid))
+			DB(DB_INTR, printk("SX-DONE-%ld", cmd->serial_number))
 			    cmd->SCp.Message = COMMAND_COMPLETE;
 			lun = read_wd33c93(regs, WD_TARGET_LUN);
 			DB(DB_INTR, printk(":%d.%d", cmd->SCp.Status, lun))
@@ -1201,7 +1201,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 		} else {
 			printk
 			    ("%02x:%02x:%02x-%ld: Unknown SEL_XFER_DONE phase!!---",
-			     asr, sr, phs, cmd->pid);
+			     asr, sr, phs, cmd->serial_number);
 			spin_unlock_irqrestore(&hostdata->lock, flags);
 		}
 		break;
@@ -1266,7 +1266,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 			spin_unlock_irqrestore(&hostdata->lock, flags);
 			return;
 		}
-		DB(DB_INTR, printk("UNEXP_DISC-%ld", cmd->pid))
+		DB(DB_INTR, printk("UNEXP_DISC-%ld", cmd->serial_number))
 		    hostdata->connected = NULL;
 		hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
 		hostdata->state = S_UNCONNECTED;
@@ -1292,7 +1292,7 @@ wd33c93_intr(struct Scsi_Host *instance)
  */
 
 		write_wd33c93(regs, WD_SOURCE_ID, SRCID_ER);
-		DB(DB_INTR, printk("DISC-%ld", cmd->pid))
+		DB(DB_INTR, printk("DISC-%ld", cmd->serial_number))
 		    if (cmd == NULL) {
 			printk(" - Already disconnected! ");
 			hostdata->state = S_UNCONNECTED;
@@ -1491,7 +1491,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 		} else
 			hostdata->state = S_CONNECTED;
 
-		DB(DB_INTR, printk("-%ld", cmd->pid))
+		DB(DB_INTR, printk("-%ld", cmd->serial_number))
 		    spin_unlock_irqrestore(&hostdata->lock, flags);
 		break;
 
@@ -1638,7 +1638,7 @@ wd33c93_abort(struct scsi_cmnd * cmd)
 			cmd->result = DID_ABORT << 16;
 			printk
 			    ("scsi%d: Abort - removing command %ld from input_Q. ",
-			     instance->host_no, cmd->pid);
+			     instance->host_no, cmd->serial_number);
 			enable_irq(cmd->device->host->irq);
 			cmd->scsi_done(cmd);
 			return SUCCESS;
@@ -1663,7 +1663,7 @@ wd33c93_abort(struct scsi_cmnd * cmd)
 		unsigned long timeout;
 
 		printk("scsi%d: Aborting connected command %ld - ",
-		       instance->host_no, cmd->pid);
+		       instance->host_no, cmd->serial_number);
 
 		printk("stopping DMA - ");
 		if (hostdata->dma == D_DMA_RUNNING) {
@@ -1730,7 +1730,7 @@ wd33c93_abort(struct scsi_cmnd * cmd)
 		if (tmp == cmd) {
 			printk
 			    ("scsi%d: Abort - command %ld found on disconnected_Q - ",
-			     instance->host_no, cmd->pid);
+			     instance->host_no, cmd->serial_number);
 			printk("Abort SNOOZE. ");
 			enable_irq(cmd->device->host->irq);
 			return FAILED;
@@ -2184,7 +2184,7 @@ wd33c93_proc_info(struct Scsi_Host *instance, char *buf, char **start, off_t off
 		if (hd->connected) {
 			cmd = (struct scsi_cmnd *) hd->connected;
 			sprintf(tbuf, " %ld-%d:%d(%02x)",
-				cmd->pid, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+				cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			strcat(bp, tbuf);
 		}
 	}
@@ -2193,7 +2193,7 @@ wd33c93_proc_info(struct Scsi_Host *instance, char *buf, char **start, off_t off
 		cmd = (struct scsi_cmnd *) hd->input_Q;
 		while (cmd) {
 			sprintf(tbuf, " %ld-%d:%d(%02x)",
-				cmd->pid, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+				cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			strcat(bp, tbuf);
 			cmd = (struct scsi_cmnd *) cmd->host_scribble;
 		}
@@ -2203,7 +2203,7 @@ wd33c93_proc_info(struct Scsi_Host *instance, char *buf, char **start, off_t off
 		cmd = (struct scsi_cmnd *) hd->disconnected_Q;
 		while (cmd) {
 			sprintf(tbuf, " %ld-%d:%d(%02x)",
-				cmd->pid, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+				cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			strcat(bp, tbuf);
 			cmd = (struct scsi_cmnd *) cmd->host_scribble;
 		}
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 53e1705..5d80971 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -39,14 +39,12 @@ struct scsi_cmnd {
 	 * A SCSI Command is assigned a nonzero serial_number before passed
 	 * to the driver's queue command function.  The serial_number is
 	 * cleared when scsi_done is entered indicating that the command
-	 * has been completed.  It currently doesn't have much use other
-	 * than printk's.  Some lldd's use this number for other purposes.
-	 * It's almost certain that such usages are either incorrect or
-	 * meaningless.  Please kill all usages other than printk's.  Also,
-	 * as this number is always identical to ->pid, please convert
-	 * printk's to use ->pid, so that we can kill this field.
+	 * has been completed.  It is a bug for LLDDs to use this number
+	 * for purposes other than printk (and even that is only useful
+	 * for debugging).
 	 */
 	unsigned long serial_number;
+
 	/*
 	 * This is set to jiffies as it was when the command was first
 	 * allocated.  It is used to time how long the command has
@@ -116,7 +114,6 @@ struct scsi_cmnd {
 	int result;		/* Status code from lower level driver */
 
 	unsigned char tag;	/* SCSI-II queued command tag */
-	unsigned long pid;	/* Process ID, starts at 0. Unique per host. */
 };
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 5b79697..1e67cc5 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -580,7 +580,7 @@ struct Scsi_Host {
 	 * Used to assign serial numbers to the cmds.
 	 * Protected by the host lock.
 	 */
-	unsigned long cmd_serial_number, cmd_pid; 
+	unsigned long cmd_serial_number; 
 	
 	unsigned active_mode:2;
 	unsigned unchecked_isa_dma:1;
-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
