From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [9/15]  qla2xxx: Tape command handling fixes
Date: Thu, 6 May 2004 22:55:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040507055530.GA4936@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:11506 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263199AbUEGFxr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 01:53:47 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1930 04/04/30 14:01:16 andrew.vasquez@apc.qlogic.com +4 -0
  Fix several problems when handling commands issued to tape devices:
  
  	1) insure commands are not prematurely returned to the mid-layer
  	   with a failed status during loop/fabric transitions.
  
  	2) tape commands tend to have rather 'long' timeout values,
  	   unfortunately, as the these values increase into the 17 to
  	   20 minute range (and larger), the cumulative skew of the
  	   RISC's own timer result in commands being held for seconds
  	   beyond their defined timeout values.  Compensate for this
  	   in the driver's command timeout function.

 drivers/scsi/qla2xxx/qla_def.h  |    3 +
 drivers/scsi/qla2xxx/qla_init.c |    4 ++
 drivers/scsi/qla2xxx/qla_isr.c  |   10 ++---
 drivers/scsi/qla2xxx/qla_os.c   |   74 ++++++++++++++++++++++++++++++++++++----
 4 files changed, 79 insertions(+), 12 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	Mon May  3 15:15:19 2004
+++ b/drivers/scsi/qla2xxx/qla_def.h	Mon May  3 15:15:19 2004
@@ -285,7 +285,8 @@
 
 #define SRB_BUSY		BIT_8	/* Command is in busy retry state */
 #define SRB_FO_CANCEL		BIT_9	/* Command don't need to do failover */
-#define	SRB_IOCTL		BIT_10	/* IOCTL command. */
+#define SRB_IOCTL		BIT_10	/* IOCTL command. */
+#define SRB_TAPE		BIT_11	/* FCP2 (Tape) command. */
 
 /*
  * SRB state definitions
diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	Mon May  3 15:15:19 2004
+++ b/drivers/scsi/qla2xxx/qla_init.c	Mon May  3 15:15:19 2004
@@ -3140,6 +3140,10 @@
 		spin_lock_irqsave(&ha->list_lock,flags);
 		list_for_each_safe(list, temp, &ha->pending_queue) {
 			sp = list_entry(list, srb_t, list);
+
+			if ((sp->flags & SRB_TAPE))
+				continue;
+			 
 			/* 
 			 * When time expire return request back to OS as BUSY 
 			 */
diff -Nru a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c	Mon May  3 15:15:19 2004
+++ b/drivers/scsi/qla2xxx/qla_isr.c	Mon May  3 15:15:19 2004
@@ -907,7 +907,7 @@
 	 * If loop is in transient state Report DID_BUS_BUSY
 	 */
 	if ((comp_status != CS_COMPLETE || scsi_status != 0)) {
-		if (!(sp->flags & SRB_IOCTL) &&
+		if (!(sp->flags & (SRB_IOCTL | SRB_TAPE)) &&
 		    (atomic_read(&ha->loop_down_timer) ||
 			atomic_read(&ha->loop_state) != LOOP_READY)) {
 
@@ -986,7 +986,7 @@
 		if (sp->request_sense_length != 0)
 			ha->status_srb = sp;
 
-		if (!(sp->flags & SRB_IOCTL) &&
+		if (!(sp->flags & (SRB_IOCTL | SRB_TAPE)) &&
 		    qla2x00_check_sense(cp, lq) == QLA_SUCCESS) {
 			/* Throw away status_cont if any */
 			ha->status_srb = NULL;
@@ -1053,7 +1053,7 @@
 			if (sp->request_sense_length != 0)
 				ha->status_srb = sp;
 
-			if (!(sp->flags & SRB_IOCTL) &&
+			if (!(sp->flags & (SRB_IOCTL | SRB_TAPE)) &&
 			    (qla2x00_check_sense(cp, lq) == QLA_SUCCESS)) {
 				ha->status_srb = NULL;
 				add_to_scsi_retry_queue(ha, sp);
@@ -1137,7 +1137,7 @@
 		    ha->host_no, t, l, cp->serial_number, comp_status,
 		    atomic_read(&fcport->state)));
 
-		if ((sp->flags & SRB_IOCTL) ||
+		if ((sp->flags & (SRB_IOCTL | SRB_TAPE)) ||
 		    atomic_read(&fcport->state) == FCS_DEVICE_DEAD) {
 			cp->result = DID_NO_CONNECT << 16;
 			if (atomic_read(&ha->loop_state) == LOOP_DOWN) 
@@ -1162,7 +1162,7 @@
 		    "scsi(%ld): RESET status detected 0x%x-0x%x.\n",
 		    ha->host_no, comp_status, scsi_status));
 
-		if (sp->flags & SRB_IOCTL) {
+		if (sp->flags & (SRB_IOCTL | SRB_TAPE)) {
 			cp->result = DID_RESET << 16;
 		} else {
 			qla2x00_extend_timeout(cp, EXTEND_CMD_TIMEOUT);
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Mon May  3 15:15:19 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Mon May  3 15:15:19 2004
@@ -775,10 +775,13 @@
 
 	/* Only modify the allowed count if the target is a *non* tape device */
 	if ((fcport->flags & FCF_TAPE_PRESENT) == 0) {
+		sp->flags &= ~SRB_TAPE;
 		if (cmd->allowed < ql2xretrycount) {
 			cmd->allowed = ql2xretrycount;
 		}
-	}
+	} else
+		sp->flags |= SRB_TAPE;
+
 
 	DEBUG5(printk("scsi(%ld:%2d:%2d): (queuecmd) queue sp = %p, "
 	    "flags=0x%x fo retry=%d, pid=%ld\n",
@@ -821,7 +824,8 @@
 		spin_lock_irq(ha->host->host_lock);
 		return (0);
 	}
-	if (tq && test_bit(TQF_SUSPENDED, &tq->flags)) {
+	if (tq && test_bit(TQF_SUSPENDED, &tq->flags) &&
+	    (sp->flags & SRB_TAPE) == 0) {
 		/* If target suspended put incoming I/O in retry_q. */
 		qla2x00_extend_timeout(sp->cmd, 10);
 		add_to_scsi_retry_queue(ha, sp);
@@ -3943,8 +3947,8 @@
 	int processed;
 	scsi_qla_host_t *vis_ha, *dest_ha;
 	struct scsi_cmnd *cmd;
-	ulong      flags;
-	fc_port_t	*fcport;
+	unsigned long flags, cpu_flags;
+	fc_port_t *fcport;
 
 	cmd = sp->cmd;
 	vis_ha = (scsi_qla_host_t *)cmd->device->host->hostdata;
@@ -4039,6 +4043,64 @@
 		 return;
 	}
 
+	spin_lock_irqsave(&dest_ha->list_lock, cpu_flags);
+	if (sp->state == SRB_DONE_STATE) {
+		/* IO in done_q  -- leave it */
+		DEBUG(printk("scsi(%ld): Found in Done queue pid %ld sp=%p.\n",
+		    dest_ha->host_no, cmd->serial_number, sp));
+	} else if (sp->state == SRB_SUSPENDED_STATE) {
+		DEBUG(printk("scsi(%ld): Found SP %p in suspended state  "
+		    "- pid %ld:\n",
+		    dest_ha->host_no, sp, cmd->serial_number));
+		DEBUG(qla2x00_dump_buffer((uint8_t *)sp, sizeof(srb_t));)
+	} else if (sp->state == SRB_ACTIVE_STATE) {
+		/*
+		 * IO is with ISP find the command in our active list.
+		 */
+		spin_unlock_irqrestore(&dest_ha->list_lock, cpu_flags);
+		spin_lock_irqsave(&dest_ha->hardware_lock, flags);
+		if (sp == dest_ha->outstanding_cmds[
+		    (unsigned long)sp->cmd->host_scribble]) {
+
+			DEBUG(printk("cmd_timeout: Found in ISP \n"));
+
+			if (sp->flags & SRB_TAPE) {
+				/*
+				 * We cannot allow the midlayer error handler
+				 * to wakeup and begin the abort process.
+				 * Extend the timer so that the firmware can
+				 * properly return the IOCB.
+				 */
+				DEBUG(printk("cmd_timeout: Extending timeout "
+				    "of FCP2 tape command!\n"));
+				qla2x00_extend_timeout(sp->cmd,
+				    EXTEND_CMD_TIMEOUT);
+			}
+			sp->state = SRB_ACTIVE_TIMEOUT_STATE;
+			spin_unlock_irqrestore(&dest_ha->hardware_lock, flags);
+		} else {
+			spin_unlock_irqrestore(&dest_ha->hardware_lock, flags);
+			printk(KERN_INFO 
+				"qla_cmd_timeout: State indicates it is with "
+				"ISP, But not in active array\n");
+		}
+		spin_lock_irqsave(&dest_ha->list_lock, cpu_flags);
+	} else if (sp->state == SRB_ACTIVE_TIMEOUT_STATE) {
+		DEBUG(printk("qla2100%ld: Found in Active timeout state"
+				"pid %ld, State = %x., \n",
+				dest_ha->host_no,
+				sp->cmd->serial_number, sp->state);)
+	} else {
+		/* EMPTY */
+		DEBUG2(printk("cmd_timeout%ld: LOST command state = "
+				"0x%x, sp=%p\n",
+				vis_ha->host_no, sp->state,sp);)
+
+		qla_printk(KERN_INFO, vis_ha,
+			"cmd_timeout: LOST command state = 0x%x\n", sp->state);
+	}
+	spin_unlock_irqrestore(&dest_ha->list_lock, cpu_flags);
+
 	DEBUG3(printk("cmd_timeout: Leaving\n");)
 }
 
@@ -4268,7 +4330,7 @@
 		 * continues until the LOOP DOWN time expires or the condition
 		 * goes away.
 		 */
-	 	if (!(sp->flags & SRB_IOCTL) &&
+		if (!(sp->flags & (SRB_IOCTL | SRB_TAPE)) &&
 		    (atomic_read(&fcport->state) != FCS_ONLINE ||
 			test_bit(ABORT_ISP_ACTIVE, &dest_ha->dpc_flags) ||
 			atomic_read(&dest_ha->loop_state) != LOOP_READY)) {
@@ -4293,7 +4355,7 @@
 		 * If this request's lun is suspended then put the request on
 		 * the  scsi_retry queue. 
 		 */
-	 	if (!(sp->flags & SRB_IOCTL) &&
+	 	if (!(sp->flags & (SRB_IOCTL | SRB_TAPE)) &&
 		    sp->lun_queue->q_state == LUN_STATE_WAIT) {
 			DEBUG3(printk("scsi(%ld): lun wait state - pid=%ld, "
 			    "opcode=%d, allowed=%d, retries=%d\n",
