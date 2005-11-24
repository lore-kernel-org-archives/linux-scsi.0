From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: [patch] kill duplicated scsi_cmnd->pid
Date: Wed, 23 Nov 2005 17:00:31 -0800
Message-ID: <200511240100.jAO10Vg31538@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr22.intel.com ([143.183.121.14]:5095 "EHLO
	scsfmr002.sc.intel.com") by vger.kernel.org with ESMTP
	id S1030568AbVKXBAi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Nov 2005 20:00:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>

Kill scsi_cmnd->pid, since it is exactly the same as ->serial_number.
No need to use two variables for the same thing.  (it's easier to
remove pid since usage in printk is a lot less compare to serial_number,
only dc395x and tmscsim).


Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>


 drivers/scsi/dc395x.c     |  110 +++++++++++++++++++++++-----------------------
 drivers/scsi/scsi.c       |    4 -
 drivers/scsi/scsi_error.c |    6 --
 drivers/scsi/tmscsim.c    |    4 -
 include/scsi/scsi_cmnd.h  |    5 --
 include/scsi/scsi_host.h  |    2 
 6 files changed, 59 insertions(+), 72 deletions(-)

--- ./include/scsi/scsi_cmnd.h.orig	2005-11-23 17:29:04.145255236 -0800
+++ ./include/scsi/scsi_cmnd.h	2005-11-23 17:29:22.232169077 -0800
@@ -47,9 +47,7 @@ struct scsi_cmnd {
 	 * has been completed.  It currently doesn't have much use other
 	 * than printk's.  Some lldd's use this number for other purposes.
 	 * It's almost certain that such usages are either incorrect or
-	 * meaningless.  Please kill all usages other than printk's.  Also,
-	 * as this number is always identical to ->pid, please convert
-	 * printk's to use ->pid, so that we can kill this field.
+	 * meaningless.  Please kill all usages other than printk's.
 	 */
 	unsigned long serial_number;
 	/*
@@ -130,7 +128,6 @@ struct scsi_cmnd {
 	int result;		/* Status code from lower level driver */
 
 	unsigned char tag;	/* SCSI-II queued command tag */
-	unsigned long pid;	/* Process ID, starts at 0. Unique per host. */
 };
 
 /*
--- ./include/scsi/scsi_host.h.orig	2005-11-23 17:54:47.151095709 -0800
+++ ./include/scsi/scsi_host.h	2005-11-23 17:54:51.912814401 -0800
@@ -526,7 +526,7 @@ struct Scsi_Host {
 	 * Used to assign serial numbers to the cmds.
 	 * Protected by the host lock.
 	 */
-	unsigned long cmd_serial_number, cmd_pid; 
+	unsigned long cmd_serial_number; 
 	
 	unsigned unchecked_isa_dma:1;
 	unsigned use_clustering:1;
--- ./drivers/scsi/scsi_error.c.orig	2005-11-23 17:28:43.964591421 -0800
+++ ./drivers/scsi/scsi_error.c	2005-11-23 17:29:39.471426678 -0800
@@ -1702,12 +1702,6 @@ scsi_reset_provider(struct scsi_device *
 
 	init_timer(&scmd->eh_timeout);
 
-	/*
-	 * Sometimes the command can get back into the timer chain,
-	 * so use the pid as an identifier.
-	 */
-	scmd->pid			= 0;
-
 	switch (flag) {
 	case SCSI_TRY_RESET_DEVICE:
 		rtn = scsi_try_bus_device_reset(scmd);
--- ./drivers/scsi/scsi.c.orig	2005-11-23 17:28:43.961661733 -0800
+++ ./drivers/scsi/scsi.c	2005-11-23 17:29:39.472403241 -0800
@@ -511,10 +511,6 @@ static inline void scsi_cmd_get_serial(s
 	cmd->serial_number = host->cmd_serial_number++;
 	if (cmd->serial_number == 0) 
 		cmd->serial_number = host->cmd_serial_number++;
-	
-	cmd->pid = host->cmd_pid++;
-	if (cmd->pid == 0)
-		cmd->pid = host->cmd_pid++;
 }
 
 /*
--- ./drivers/scsi/dc395x.c.orig	2005-11-23 17:33:59.809314114 -0800
+++ ./drivers/scsi/dc395x.c	2005-11-23 17:44:04.658916080 -0800
@@ -779,7 +779,7 @@ static void srb_waiting_insert(struct De
 		struct ScsiReqBlk *srb)
 {
 	dprintkdbg(DBG_0, "srb_waiting_insert: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
+		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
 	list_add(&srb->list, &dcb->srb_waiting_list);
 }
 
@@ -788,7 +788,7 @@ static void srb_waiting_append(struct De
 		struct ScsiReqBlk *srb)
 {
 	dprintkdbg(DBG_0, "srb_waiting_append: (pid#%li) <%02i-%i> srb=%p\n",
-		 srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
+		 srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
 	list_add_tail(&srb->list, &dcb->srb_waiting_list);
 }
 
@@ -796,7 +796,7 @@ static void srb_waiting_append(struct De
 static void srb_going_append(struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
 {
 	dprintkdbg(DBG_0, "srb_going_append: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
+		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
 	list_add_tail(&srb->list, &dcb->srb_going_list);
 }
 
@@ -806,7 +806,7 @@ static void srb_going_remove(struct Devi
 	struct ScsiReqBlk *i;
 	struct ScsiReqBlk *tmp;
 	dprintkdbg(DBG_0, "srb_going_remove: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
+		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
 
 	list_for_each_entry_safe(i, tmp, &dcb->srb_going_list, list)
 		if (i == srb) {
@@ -822,7 +822,7 @@ static void srb_waiting_remove(struct De
 	struct ScsiReqBlk *i;
 	struct ScsiReqBlk *tmp;
 	dprintkdbg(DBG_0, "srb_waiting_remove: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
+		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
 
 	list_for_each_entry_safe(i, tmp, &dcb->srb_waiting_list, list)
 		if (i == srb) {
@@ -837,7 +837,7 @@ static void srb_going_to_waiting_move(st
 {
 	dprintkdbg(DBG_0,
 		"srb_going_to_waiting_move: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
+		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
 	list_move(&srb->list, &dcb->srb_waiting_list);
 }
 
@@ -847,7 +847,7 @@ static void srb_waiting_to_going_move(st
 {
 	dprintkdbg(DBG_0,
 		"srb_waiting_to_going_move: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
+		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
 	list_move(&srb->list, &dcb->srb_going_list);
 }
 
@@ -993,7 +993,7 @@ static void build_srb(struct scsi_cmnd *
 {
 	enum dma_data_direction dir = cmd->sc_data_direction;
 	dprintkdbg(DBG_0, "build_srb: (pid#%li) <%02i-%i>\n",
-		cmd->pid, dcb->target_id, dcb->target_lun);
+		cmd->serial_number, dcb->target_id, dcb->target_lun);
 
 	srb->dcb = dcb;
 	srb->cmd = cmd;
@@ -1111,7 +1111,7 @@ static int dc395x_queue_command(struct s
 	struct AdapterCtlBlk *acb =
 	    (struct AdapterCtlBlk *)cmd->device->host->hostdata;
 	dprintkdbg(DBG_0, "queue_command: (pid#%li) <%02i-%i> cmnd=0x%02x\n",
-		cmd->pid, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+		cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 
 	/* Assume BAD_TARGET; will be cleared later */
 	cmd->result = DID_BAD_TARGET << 16;
@@ -1164,7 +1164,7 @@ static int dc395x_queue_command(struct s
 		/* process immediately */
 		send_srb(acb, srb);
 	}
-	dprintkdbg(DBG_1, "queue_command: (pid#%li) done\n", cmd->pid);
+	dprintkdbg(DBG_1, "queue_command: (pid#%li) done\n", cmd->serial_number);
 	return 0;
 
 complete:
@@ -1228,7 +1228,7 @@ static void dump_register_info(struct Ad
 		else
 			dprintkl(KERN_INFO, "dump: srb=%p cmd=%p (pid#%li) "
 				 "cmnd=0x%02x <%02i-%i>\n",
-			    	srb, srb->cmd, srb->cmd->pid,
+			    	srb, srb->cmd, srb->cmd->serial_number,
 				srb->cmd->cmnd[0], srb->cmd->device->id,
 			       	srb->cmd->device->lun);
 		printk("  sglist=%p cnt=%i idx=%i len=%i\n",
@@ -1325,7 +1325,7 @@ static int __dc395x_eh_bus_reset(struct 
 		(struct AdapterCtlBlk *)cmd->device->host->hostdata;
 	dprintkl(KERN_INFO,
 		"eh_bus_reset: (pid#%li) target=<%02i-%i> cmd=%p\n",
-		cmd->pid, cmd->device->id, cmd->device->lun, cmd);
+		cmd->serial_number, cmd->device->id, cmd->device->lun, cmd);
 
 	if (timer_pending(&acb->waiting_timer))
 		del_timer(&acb->waiting_timer);
@@ -1392,7 +1392,7 @@ static int dc395x_eh_abort(struct scsi_c
 	struct DeviceCtlBlk *dcb;
 	struct ScsiReqBlk *srb;
 	dprintkl(KERN_INFO, "eh_abort: (pid#%li) target=<%02i-%i> cmd=%p\n",
-		cmd->pid, cmd->device->id, cmd->device->lun, cmd);
+		cmd->serial_number, cmd->device->id, cmd->device->lun, cmd);
 
 	dcb = find_dcb(acb, cmd->device->id, cmd->device->lun);
 	if (!dcb) {
@@ -1519,7 +1519,7 @@ static u8 start_scsi(struct AdapterCtlBl
 	u8 s_stat, scsicommand, i, identify_message;
 	u8 *ptr;
 	dprintkdbg(DBG_0, "start_scsi: (pid#%li) <%02i-%i> srb=%p\n",
-		srb->cmd->pid, dcb->target_id, dcb->target_lun, srb);
+		srb->cmd->serial_number, dcb->target_id, dcb->target_lun, srb);
 
 	srb->tag_number = TAG_NONE;	/* acb->tag_max_num: had error read in eeprom */
 
@@ -1529,7 +1529,7 @@ static u8 start_scsi(struct AdapterCtlBl
 #if 1
 	if (s_stat & 0x20 /* s_stat2 & 0x02000 */ ) {
 		dprintkdbg(DBG_KG, "start_scsi: (pid#%li) BUSY %02x %04x\n",
-			srb->cmd->pid, s_stat, s_stat2);
+			srb->cmd->serial_number, s_stat, s_stat2);
 		/*
 		 * Try anyway?
 		 *
@@ -1547,14 +1547,14 @@ static u8 start_scsi(struct AdapterCtlBl
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
@@ -1628,7 +1628,7 @@ static u8 start_scsi(struct AdapterCtlBl
 		if (tag_number >= dcb->max_command) {
 			dprintkl(KERN_WARNING, "start_scsi: (pid#%li) "
 				"Out of tags target=<%02i-%i>)\n",
-				srb->cmd->pid, srb->cmd->device->id,
+				srb->cmd->serial_number, srb->cmd->device->id,
 				srb->cmd->device->lun);
 			srb->state = SRB_READY;
 			DC395x_write16(acb, TRM_S1040_SCSI_CONTROL,
@@ -1647,7 +1647,7 @@ static u8 start_scsi(struct AdapterCtlBl
 /*polling:*/
 	/* Send CDB ..command block ......... */
 	dprintkdbg(DBG_KG, "start_scsi: (pid#%li) <%02i-%i> cmnd=0x%02x tag=%i\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun,
+		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun,
 		srb->cmd->cmnd[0], srb->tag_number);
 	if (srb->flag & AUTO_REQSENSE) {
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, REQUEST_SENSE);
@@ -1672,7 +1672,7 @@ static u8 start_scsi(struct AdapterCtlBl
 		 * : Let's process it first!
 		 */
 		dprintkdbg(DBG_0, "start_scsi: (pid#%li) <%02i-%i> Failed - busy\n",
-			srb->cmd->pid, dcb->target_id, dcb->target_lun);
+			srb->cmd->serial_number, dcb->target_id, dcb->target_lun);
 		srb->state = SRB_READY;
 		free_tag(dcb, srb);
 		srb->msg_count = 0;
@@ -1868,7 +1868,7 @@ static irqreturn_t dc395x_interrupt(int 
 static void msgout_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "msgout_phase0: (pid#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "msgout_phase0: (pid#%li)\n", srb->cmd->serial_number);
 	if (srb->state & (SRB_UNEXPECT_RESEL + SRB_ABORT_SENT))
 		*pscsi_status = PH_BUS_FREE;	/*.. initial phase */
 
@@ -1882,18 +1882,18 @@ static void msgout_phase1(struct Adapter
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
@@ -1913,7 +1913,7 @@ static void msgout_phase1(struct Adapter
 static void command_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "command_phase0: (pid#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "command_phase0: (pid#%li)\n", srb->cmd->serial_number);
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);
 }
 
@@ -1924,7 +1924,7 @@ static void command_phase1(struct Adapte
 	struct DeviceCtlBlk *dcb;
 	u8 *ptr;
 	u16 i;
-	dprintkdbg(DBG_0, "command_phase1: (pid#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "command_phase1: (pid#%li)\n", srb->cmd->serial_number);
 
 	clear_fifo(acb, "command_phase1");
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_CLRATN);
@@ -2102,7 +2102,7 @@ static void data_out_phase0(struct Adapt
 	u16 scsi_status = *pscsi_status;
 	u32 d_left_counter = 0;
 	dprintkdbg(DBG_0, "data_out_phase0: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun);
 
 	/*
 	 * KG: We need to drain the buffers before we draw any conclusions!
@@ -2232,7 +2232,7 @@ static void data_out_phase1(struct Adapt
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "data_out_phase1: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun);
 	clear_fifo(acb, "data_out_phase1");
 	/* do prepare before transfer when data out phase */
 	data_io_transfer(acb, srb, XFERDATAOUT);
@@ -2245,7 +2245,7 @@ static void data_in_phase0(struct Adapte
 	u16 scsi_status = *pscsi_status;
 	u32 d_left_counter = 0;
 	dprintkdbg(DBG_0, "data_in_phase0: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun);
 
 	/*
 	 * KG: DataIn is much more tricky than DataOut. When the device is finished
@@ -2263,7 +2263,7 @@ static void data_in_phase0(struct Adapte
 	if (!(srb->state & SRB_XFERPAD)) {
 		if (scsi_status & PARITYERROR) {
 			dprintkl(KERN_INFO, "data_in_phase0: (pid#%li) "
-				"Parity Error\n", srb->cmd->pid);
+				"Parity Error\n", srb->cmd->serial_number);
 			srb->status |= PARITY_ERROR;
 		}
 		/*
@@ -2419,7 +2419,7 @@ static void data_in_phase1(struct Adapte
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "data_in_phase1: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun);
 	data_io_transfer(acb, srb, XFERDATAIN);
 }
 
@@ -2431,7 +2431,7 @@ static void data_io_transfer(struct Adap
 	u8 bval;
 	dprintkdbg(DBG_0,
 		"data_io_transfer: (pid#%li) <%02i-%i> %c len=%i, sg=(%i/%i)\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun,
+		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun,
 		((io_dir & DMACMD_DIR) ? 'r' : 'w'),
 		srb->total_xfer_length, srb->sg_index, srb->sg_count);
 	if (srb == acb->tmp_srb)
@@ -2589,7 +2589,7 @@ static void status_phase0(struct Adapter
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "status_phase0: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun);
 	srb->target_status = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 	srb->end_message = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);	/* get message */
 	srb->state = SRB_COMPLETED;
@@ -2603,7 +2603,7 @@ static void status_phase1(struct Adapter
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "status_phase1: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->cmd->device->id, srb->cmd->device->lun);
+		srb->cmd->serial_number, srb->cmd->device->id, srb->cmd->device->lun);
 	srb->state = SRB_STATUS;
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's important for atn stop */
 	DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_COMP);
@@ -2645,7 +2645,7 @@ static struct ScsiReqBlk *msgin_qtag(str
 	struct ScsiReqBlk *srb = NULL;
 	struct ScsiReqBlk *i;
 	dprintkdbg(DBG_0, "msgin_qtag: (pid#%li) tag=%i srb=%p\n",
-		   srb->cmd->pid, tag, srb);
+		   srb->cmd->serial_number, tag, srb);
 
 	if (!(dcb->tag_mask & (1 << tag)))
 		dprintkl(KERN_DEBUG,
@@ -2664,7 +2664,7 @@ static struct ScsiReqBlk *msgin_qtag(str
 		goto mingx0;
 
 	dprintkdbg(DBG_0, "msgin_qtag: (pid#%li) <%02i-%i>\n",
-		srb->cmd->pid, srb->dcb->target_id, srb->dcb->target_lun);
+		srb->cmd->serial_number, srb->dcb->target_id, srb->dcb->target_lun);
 	if (dcb->flag & ABORT_DEV_) {
 		/*srb->state = SRB_ABORT_SENT; */
 		enable_msgout_abort(acb, srb);
@@ -2874,7 +2874,7 @@ static void msgin_phase0(struct AdapterC
 		u16 *pscsi_status)
 {
 	struct DeviceCtlBlk *dcb = acb->active_dcb;
-	dprintkdbg(DBG_0, "msgin_phase0: (pid#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "msgin_phase0: (pid#%li)\n", srb->cmd->serial_number);
 
 	srb->msgin_buf[acb->msg_len++] = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 	if (msgin_completed(srb->msgin_buf, acb->msg_len)) {
@@ -2942,7 +2942,7 @@ static void msgin_phase0(struct AdapterC
 			 */
 			dprintkdbg(DBG_0, "msgin_phase0: (pid#%li) "
 				"SAVE POINTER rem=%i Ignore\n",
-				srb->cmd->pid, srb->total_xfer_length);
+				srb->cmd->serial_number, srb->total_xfer_length);
 			break;
 
 		case RESTORE_POINTERS:
@@ -2952,7 +2952,7 @@ static void msgin_phase0(struct AdapterC
 		case ABORT:
 			dprintkdbg(DBG_0, "msgin_phase0: (pid#%li) "
 				"<%02i-%i> ABORT msg\n",
-				srb->cmd->pid, dcb->target_id,
+				srb->cmd->serial_number, dcb->target_id,
 				dcb->target_lun);
 			dcb->flag |= ABORT_DEV_;
 			enable_msgout_abort(acb, srb);
@@ -2984,7 +2984,7 @@ static void msgin_phase0(struct AdapterC
 static void msgin_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	dprintkdbg(DBG_0, "msgin_phase1: (pid#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "msgin_phase1: (pid#%li)\n", srb->cmd->serial_number);
 	clear_fifo(acb, "msgin_phase1");
 	DC395x_write32(acb, TRM_S1040_SCSI_COUNTER, 1);
 	if (!(srb->state & SRB_MSGIN)) {
@@ -3050,7 +3050,7 @@ static void disconnect(struct AdapterCtl
 	}
 	srb = dcb->active_srb;
 	acb->active_dcb = NULL;
-	dprintkdbg(DBG_0, "disconnect: (pid#%li)\n", srb->cmd->pid);
+	dprintkdbg(DBG_0, "disconnect: (pid#%li)\n", srb->cmd->serial_number);
 
 	srb->scsi_phase = PH_BUS_FREE;	/* initial phase */
 	clear_fifo(acb, "disconnect");
@@ -3081,13 +3081,13 @@ static void disconnect(struct AdapterCtl
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
@@ -3099,7 +3099,7 @@ static void disconnect(struct AdapterCtl
 				srb_going_to_waiting_move(dcb, srb);
 				dprintkdbg(DBG_KG,
 					"disconnect: (pid#%li) Retry\n",
-					srb->cmd->pid);
+					srb->cmd->serial_number);
 				waiting_set_timer(acb, HZ / 20);
 			}
 		} else if (srb->state & SRB_DISCONNECT) {
@@ -3153,7 +3153,7 @@ static void reselect(struct AdapterCtlBl
 		if (!acb->scan_devices) {
 			dprintkdbg(DBG_KG, "reselect: (pid#%li) <%02i-%i> "
 				"Arb lost but Resel win rsel=%i stat=0x%04x\n",
-				srb->cmd->pid, dcb->target_id,
+				srb->cmd->serial_number, dcb->target_id,
 				dcb->target_lun, rsel_tar_lun_id,
 				DC395x_read16(acb, TRM_S1040_SCSI_STATUS));
 			arblostflag = 1;
@@ -3340,7 +3340,7 @@ static void srb_done(struct AdapterCtlBl
 		ptr = (struct ScsiInqData *)(cmd->request_buffer);
 	}
 
-	dprintkdbg(DBG_1, "srb_done: (pid#%li) <%02i-%i>\n", srb->cmd->pid,
+	dprintkdbg(DBG_1, "srb_done: (pid#%li) <%02i-%i>\n", srb->cmd->serial_number,
 		srb->cmd->device->id, srb->cmd->device->lun);
 	dprintkdbg(DBG_SG, "srb_done: srb=%p sg=%i(%i/%i) buf=%p addr=%p\n",
 		srb, cmd->use_sg, srb->sg_index, srb->sg_count,
@@ -3515,7 +3515,7 @@ static void srb_done(struct AdapterCtlBl
 		if (srb->total_xfer_length)
 			dprintkdbg(DBG_KG, "srb_done: (pid#%li) <%02i-%i> "
 				"cmnd=0x%02x Missed %i bytes\n",
-				cmd->pid, cmd->device->id, cmd->device->lun,
+				cmd->serial_number, cmd->device->id, cmd->device->lun,
 				cmd->cmnd[0], srb->total_xfer_length);
 	}
 
@@ -3525,7 +3525,7 @@ static void srb_done(struct AdapterCtlBl
 		dprintkl(KERN_ERR, "srb_done: ERROR! Completed cmd with tmp_srb\n");
 	else {
 		dprintkdbg(DBG_0, "srb_done: (pid#%li) done result=0x%08x\n",
-			cmd->pid, cmd->result);
+			cmd->serial_number, cmd->result);
 		srb_free_insert(acb, srb);
 	}
 	pci_unmap_srb(acb, srb);
@@ -3554,7 +3554,7 @@ static void doing_srb_done(struct Adapte
 			p = srb->cmd;
 			dir = p->sc_data_direction;
 			result = MK_RES(0, did_flag, 0, 0);
-			printk("G:%li(%02i-%i) ", p->pid,
+			printk("G:%li(%02i-%i) ", p->serial_number,
 			       p->device->id, p->device->lun);
 			srb_going_remove(dcb, srb);
 			free_tag(dcb, srb);
@@ -3584,7 +3584,7 @@ static void doing_srb_done(struct Adapte
 			p = srb->cmd;
 
 			result = MK_RES(0, did_flag, 0, 0);
-			printk("W:%li<%02i-%i>", p->pid, p->device->id,
+			printk("W:%li<%02i-%i>", p->serial_number, p->device->id,
 			       p->device->lun);
 			srb_waiting_remove(dcb, srb);
 			srb_free_insert(acb, srb);
@@ -3694,7 +3694,7 @@ static void request_sense(struct Adapter
 {
 	struct scsi_cmnd *cmd = srb->cmd;
 	dprintkdbg(DBG_1, "request_sense: (pid#%li) <%02i-%i>\n",
-		cmd->pid, cmd->device->id, cmd->device->lun);
+		cmd->serial_number, cmd->device->id, cmd->device->lun);
 
 	srb->flag |= AUTO_REQSENSE;
 	srb->adapter_status = 0;
@@ -3725,7 +3725,7 @@ static void request_sense(struct Adapter
 	if (start_scsi(acb, dcb, srb)) {	/* Should only happen, if sb. else grabs the bus */
 		dprintkl(KERN_DEBUG,
 			"request_sense: (pid#%li) failed <%02i-%i>\n",
-			srb->cmd->pid, dcb->target_id, dcb->target_lun);
+			srb->cmd->serial_number, dcb->target_id, dcb->target_lun);
 		srb_going_to_waiting_move(dcb, srb);
 		waiting_set_timer(acb, HZ / 100);
 	}
@@ -4733,13 +4733,13 @@ static int dc395x_proc_info(struct Scsi_
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
--- ./drivers/scsi/tmscsim.c.orig	2005-11-23 17:44:22.341533051 -0800
+++ ./drivers/scsi/tmscsim.c	2005-11-23 17:44:58.900126353 -0800
@@ -2086,7 +2086,7 @@ static int DC390_abort(struct scsi_cmnd 
 	struct dc390_dcb *pDCB = (struct dc390_dcb*) cmd->device->hostdata;
 
 	scmd_printk(KERN_WARNING, cmd,
-		"DC390: Abort command (pid %li)\n", cmd->pid);
+		"DC390: Abort command (pid %li)\n", cmd->serial_number);
 
 	/* abort() is too stupid for already sent commands at the moment. 
 	 * If it's called we are in trouble anyway, so let's dump some info 
@@ -2094,7 +2094,7 @@ static int DC390_abort(struct scsi_cmnd 
 	dc390_dumpinfo(pACB, pDCB, NULL);
 
 	pDCB->DCBFlag |= ABORT_DEV_;
-	printk(KERN_INFO "DC390: Aborted pid %li\n", cmd->pid);
+	printk(KERN_INFO "DC390: Aborted pid %li\n", cmd->serial_number);
 
 	return FAILED;
 }

