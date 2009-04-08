From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 1/2] qla1280: driver clean up
Date: Wed, 08 Apr 2009 14:33:48 -0500
Message-ID: <49DCFC1C.5070805@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:44957 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752045AbZDHTdu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Apr 2009 15:33:50 -0400
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 313163040BB
	for <linux-scsi@vger.kernel.org>; Wed,  8 Apr 2009 12:33:49 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jeremy Higdon <jeremy@sgi.com>, Jes Sorensen <jes@sgi.com>

Remove some unneeded, inactive and unused code, make some trivial
corrections to comments and a printk, and return a proper status
in qla1280_queuecommand.  No fundamental logic changes are made.

Signed-off-by: Michael Reed <mdr@sgi.com>


--- a/drivers/scsi/qla1280.c	2009-04-07 14:40:53.000000000 -0500
+++ b/drivers/scsi/qla1280.c	2009-04-08 10:15:17.606490034 -0500
@@ -435,7 +435,6 @@ static int qla1280_mailbox_command(struc
 				   uint8_t, uint16_t *);
 static int qla1280_bus_reset(struct scsi_qla_host *, int);
 static int qla1280_device_reset(struct scsi_qla_host *, int, int);
-static int qla1280_abort_device(struct scsi_qla_host *, int, int, int);
 static int qla1280_abort_command(struct scsi_qla_host *, struct srb *, int);
 static int qla1280_abort_isp(struct scsi_qla_host *);
 #ifdef QLA_64BIT_PTR
@@ -698,7 +697,7 @@ qla1280_info(struct Scsi_Host *host)
 }
 
 /**************************************************************************
- *   qla1200_queuecommand
+ *   qla1280_queuecommand
  *     Queue a command to the controller.
  *
  * Note:
@@ -713,7 +712,7 @@ qla1280_queuecommand(struct scsi_cmnd *c
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct scsi_qla_host *ha = (struct scsi_qla_host *)host->hostdata;
-	struct srb *sp = (struct srb *)&cmd->SCp;
+	struct srb *sp = (struct srb *)CMD_SP(cmd);
 	int status;
 
 	cmd->scsi_done = fn;
@@ -738,11 +737,9 @@ qla1280_queuecommand(struct scsi_cmnd *c
 
 enum action {
 	ABORT_COMMAND,
-	ABORT_DEVICE,
 	DEVICE_RESET,
 	BUS_RESET,
 	ADAPTER_RESET,
-	FAIL
 };
 
 /* timer action for error action processor */
@@ -768,7 +765,7 @@ static void qla1280_mailbox_timeout(unsi
 }
 
 /**************************************************************************
- * qla1200_error_action
+ * qla1280_error_action
  *    The function will attempt to perform a specified error action and
  *    wait for the results (or time out).
  *
@@ -798,6 +795,8 @@ qla1280_error_action(struct scsi_cmnd *c
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct timer_list timer;
 
+	ENTER("qla1280_error_action");
+
 	ha = (struct scsi_qla_host *)(CMD_HOST(cmd)->hostdata);
 
 	dprintk(4, "error_action %i, istatus 0x%04x\n", action,
@@ -807,20 +806,11 @@ qla1280_error_action(struct scsi_cmnd *c
 		RD_REG_WORD(&ha->iobase->host_cmd),
 		RD_REG_WORD(&ha->iobase->ictrl), jiffies);
 
-	ENTER("qla1280_error_action");
 	if (qla1280_verbose)
 		printk(KERN_INFO "scsi(%li): Resetting Cmnd=0x%p, "
 		       "Handle=0x%p, action=0x%x\n",
 		       ha->host_no, cmd, CMD_HANDLE(cmd), action);
 
-	if (cmd == NULL) {
-		printk(KERN_WARNING "(scsi?:?:?:?) Reset called with NULL "
-		       "si_Cmnd pointer, failing.\n");
-		LEAVE("qla1280_error_action");
-		return FAILED;
-	}
-
-	ha = (struct scsi_qla_host *)cmd->device->host->hostdata;
 	sp = (struct srb *)CMD_SP(cmd);
 	handle = CMD_HANDLE(cmd);
 
@@ -857,9 +847,6 @@ qla1280_error_action(struct scsi_cmnd *c
 	 * mean the actual success or fail of the action */
 	result = FAILED;
 	switch (action) {
-	case FAIL:
-		break;
-
 	case ABORT_COMMAND:
 		if ((sp->flags & SRB_ABORT_PENDING)) {
 			printk(KERN_WARNING
@@ -893,15 +880,6 @@ qla1280_error_action(struct scsi_cmnd *c
 		}
 		break;
 
-	case ABORT_DEVICE:
-		if (qla1280_verbose)
-			printk(KERN_INFO
-			       "scsi(%ld:%d:%d:%d): Queueing abort device "
-			       "command.\n", ha->host_no, bus, target, lun);
-		if (qla1280_abort_device(ha, bus, target, lun) == 0)
-			result = SUCCESS;
-		break;
-
 	case DEVICE_RESET:
 		if (qla1280_verbose)
 			printk(KERN_INFO
@@ -1285,8 +1263,6 @@ qla1280_done(struct scsi_qla_host *ha)
 		case DID_ABORT:
 			sp->flags &= ~SRB_ABORT_PENDING;
 			sp->flags |= SRB_ABORTED;
-			if (sp->flags & SRB_TIMEOUT)
-				CMD_RESULT(sp->cmd) = DID_TIME_OUT << 16;
 			break;
 		default:
 			break;
@@ -2417,9 +2393,6 @@ static int
 qla1280_mailbox_command(struct scsi_qla_host *ha, uint8_t mr, uint16_t *mb)
 {
 	struct device_reg __iomem *reg = ha->iobase;
-#if 0
-	LIST_HEAD(done_q);
-#endif
 	int status = 0;
 	int cnt;
 	uint16_t *optr, *iptr;
@@ -2493,19 +2466,9 @@ qla1280_mailbox_command(struct scsi_qla_
 	mr = MAILBOX_REGISTER_COUNT;
 	memcpy(optr, iptr, MAILBOX_REGISTER_COUNT * sizeof(uint16_t));
 
-#if 0
-	/* Go check for any response interrupts pending. */
-	qla1280_isr(ha, &done_q);
-#endif
-
 	if (ha->flags.reset_marker)
 		qla1280_rst_aen(ha);
 
-#if 0
-	if (!list_empty(&done_q))
-		qla1280_done(ha, &done_q);
-#endif
-
 	if (status)
 		dprintk(2, "qla1280_mailbox_command: **** FAILED, mailbox0 = "
 			"0x%x ****\n", mb[0]);
@@ -2641,41 +2604,6 @@ qla1280_device_reset(struct scsi_qla_hos
 }
 
 /*
- * qla1280_abort_device
- *      Issue an abort message to the device
- *
- * Input:
- *      ha     = adapter block pointer.
- *      bus    = SCSI BUS.
- *      target = SCSI ID.
- *      lun    = SCSI LUN.
- *
- * Returns:
- *      0 = success
- */
-static int
-qla1280_abort_device(struct scsi_qla_host *ha, int bus, int target, int lun)
-{
-	uint16_t mb[MAILBOX_REGISTER_COUNT];
-	int status;
-
-	ENTER("qla1280_abort_device");
-
-	mb[0] = MBC_ABORT_DEVICE;
-	mb[1] = (bus ? target | BIT_7 : target) << 8 | lun;
-	status = qla1280_mailbox_command(ha, BIT_1 | BIT_0, &mb[0]);
-
-	/* Issue marker command. */
-	qla1280_marker(ha, bus, target, lun, MK_SYNC_ID_LUN);
-
-	if (status)
-		dprintk(2, "qla1280_abort_device: **** FAILED ****\n");
-
-	LEAVE("qla1280_abort_device");
-	return status;
-}
-
-/*
  * qla1280_abort_command
  *      Abort command aborts a specified IOCB.
  *
@@ -2833,7 +2761,7 @@ qla1280_64bit_start_scsi(struct scsi_qla
 
 	/* If room for request in request ring. */
 	if ((req_cnt + 2) >= ha->req_q_cnt) {
-		status = 1;
+		status = SCSI_MLQUEUE_HOST_BUSY;
 		dprintk(2, "qla1280_start_scsi: in-ptr=0x%x  req_q_cnt="
 			"0x%xreq_cnt=0x%x", ha->req_ring_index, ha->req_q_cnt,
 			req_cnt);
@@ -2845,7 +2773,7 @@ qla1280_64bit_start_scsi(struct scsi_qla
 		     ha->outstanding_cmds[cnt] != NULL; cnt++);
 
 	if (cnt >= MAX_OUTSTANDING_COMMANDS) {
-		status = 1;
+		status = SCSI_MLQUEUE_HOST_BUSY;
 		dprintk(2, "qla1280_start_scsi: NO ROOM IN "
 			"OUTSTANDING ARRAY, req_q_cnt=0x%x", ha->req_q_cnt);
 		goto out;
@@ -3108,7 +3036,7 @@ qla1280_32bit_start_scsi(struct scsi_qla
 		ha->req_q_cnt, seg_cnt);
 	/* If room for request in request ring. */
 	if ((req_cnt + 2) >= ha->req_q_cnt) {
-		status = 1;
+		status = SCSI_MLQUEUE_HOST_BUSY;
 		dprintk(2, "qla1280_32bit_start_scsi: in-ptr=0x%x, "
 			"req_q_cnt=0x%x, req_cnt=0x%x", ha->req_ring_index,
 			ha->req_q_cnt, req_cnt);
@@ -3120,7 +3048,7 @@ qla1280_32bit_start_scsi(struct scsi_qla
 		     (ha->outstanding_cmds[cnt] != 0); cnt++) ;
 
 	if (cnt >= MAX_OUTSTANDING_COMMANDS) {
-		status = 1;
+		status = SCSI_MLQUEUE_HOST_BUSY;
 		dprintk(2, "qla1280_32bit_start_scsi: NO ROOM IN OUTSTANDING "
 			"ARRAY, req_q_cnt=0x%x\n", ha->req_q_cnt);
 		goto out;
@@ -3495,7 +3423,7 @@ qla1280_isr(struct scsi_qla_host *ha, st
 					 * If we get here we have a real problem!
 					 */
 					printk(KERN_WARNING
-					       "qla1280: ISP invalid handle");
+					       "qla1280: ISP invalid handle\n");
 				}
 			}
 			break;
@@ -3955,13 +3883,6 @@ qla1280_check_for_dead_scsi_bus(struct s
 
 		if (scsi_control == SCSI_PHASE_INVALID) {
 			ha->bus_settings[bus].scsi_bus_dead = 1;
-#if 0
-			CMD_RESULT(cp) = DID_NO_CONNECT << 16;
-			CMD_HANDLE(cp) = INVALID_HANDLE;
-			/* ha->actthreads--; */
-
-			(*(cp)->scsi_done)(cp);
-#endif
 			return 1;	/* bus is dead */
 		} else {
 			ha->bus_settings[bus].scsi_bus_dead = 0;
