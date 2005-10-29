From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] qlogic and lpfc messaging update
Date: Sat, 29 Oct 2005 17:17:00 -0400
Message-ID: <4363E6CC.1070606@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070901020607030005060509"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:14726 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751241AbVJ2VRG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Oct 2005 17:17:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <James.Smart@emulex.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070901020607030005060509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Gentlemen,

I would like to get these changes upstream, now that scsi-misc-2.6 has 
the appropriate infrastructure.  These changes eliminate unneeded 
references to sdev->{id,channel,lun}, since the drivers' respective 
messaging infrastructure should already expose this.

Review requested...  patch against latest scsi-misc-2.6 
(a3632fa3ecefe50d88fc70af90610f79b99e0715).

	Jeff



--------------070901020607030005060509
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index c34d3cf..f4e41fc 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -402,10 +402,10 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 			lpfc_cmd->status = IOSTAT_DEFAULT;
 
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP,
-				"%d:0729 FCP cmd x%x failed <%d/%d> status: "
+				"0729 FCP cmd x%x failed status: "
 				"x%x result: x%x Data: x%x x%x\n",
-				phba->brd_no, cmd->cmnd[0], cmd->device->id,
-				cmd->device->lun, lpfc_cmd->status,
+				cmd->cmnd[0],
+				lpfc_cmd->status,
 				lpfc_cmd->result, pIocbOut->iocb.ulpContext,
 				lpfc_cmd->cur_iocbq.iocb.ulpIoTag);
 
@@ -434,10 +434,9 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 		uint32_t *lp = (uint32_t *)cmd->sense_buffer;
 
 		lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
-				"%d:0710 Iodone <%d/%d> cmd %p, error x%x "
+				"0710 Iodone cmd %p, error x%x "
 				"SNS x%x x%x Data: x%x x%x\n",
-				phba->brd_no, cmd->device->id,
-				cmd->device->lun, cmd, cmd->result,
+				cmd, cmd->result,
 				*lp, *(lp + 3), cmd->retries, cmd->resid);
 	}
 
@@ -593,10 +592,8 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 		lpfc_printf_log(phba,
 				KERN_INFO,
 				LOG_FCP,
-				"%d:0703 Issue LUN Reset to TGT %d LUN %d "
+				"0703 Issue LUN Reset "
 				"Data: x%x x%x\n",
-				phba->brd_no,
-				scsi_dev->id, scsi_dev->lun,
 				ndlp->nlp_rpi, ndlp->nlp_flag);
 
 		break;
@@ -605,10 +602,8 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 		lpfc_printf_log(phba,
 				KERN_INFO,
 				LOG_FCP,
-				"%d:0701 Issue Abort Task Set to TGT %d LUN %d "
+				"0701 Issue Abort Task Set "
 				"Data: x%x x%x\n",
-				phba->brd_no,
-				scsi_dev->id, scsi_dev->lun,
 				ndlp->nlp_rpi, ndlp->nlp_flag);
 
 		break;
@@ -617,10 +612,9 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 		lpfc_printf_log(phba,
 				KERN_INFO,
 				LOG_FCP,
-				"%d:0702 Issue Target Reset to TGT %d "
+				"0702 Issue Target Reset "
 				"Data: x%x x%x\n",
-				phba->brd_no,
-				scsi_dev->id, ndlp->nlp_rpi,
+				ndlp->nlp_rpi,
 				ndlp->nlp_flag);
 		break;
 	}
@@ -837,18 +831,16 @@ __lpfc_abort_handler(struct scsi_cmnd *c
 		ret = FAILED;
 		lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
 				"%d:0748 abort handler timed out waiting for "
-				"abort to complete: ret %#x, ID %d, LUN %d, "
+				"abort to complete: ret %#x, "
 				"snum %#lx\n",
-				phba->brd_no,  ret, cmnd->device->id,
-				cmnd->device->lun, cmnd->serial_number);
+				phba->brd_no,  ret, cmnd->serial_number);
 	}
 
  out:
 	lpfc_printf_log(phba, KERN_WARNING, LOG_FCP,
 			"%d:0749 SCSI layer issued abort device: ret %#x, "
-			"ID %d, LUN %d, snum %#lx\n",
-			phba->brd_no, ret, cmnd->device->id,
-			cmnd->device->lun, cmnd->serial_number);
+			"snum %#lx\n",
+			phba->brd_no, ret, cmnd->serial_number);
 
 	return ret;
 }
@@ -959,10 +951,9 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 
 out_free_scsi_buf:
 	lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
-			"%d:0713 SCSI layer issued LUN reset (%d, %d) "
+			"0713 SCSI layer issued LUN reset "
 			"Data: x%x x%x x%x\n",
-			phba->brd_no, lpfc_cmd->pCmd->device->id,
-			lpfc_cmd->pCmd->device->lun, ret, lpfc_cmd->status,
+			ret, lpfc_cmd->status,
 			lpfc_cmd->result);
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
 out:
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 89793c1..c28901d 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1973,10 +1973,11 @@ qla2x00_print_scsi_cmd(struct scsi_cmnd 
 	ha = (struct scsi_qla_host *)cmd->device->host->hostdata;
 
 	sp = (srb_t *) cmd->SCp.ptr;
-	printk("SCSI Command @=0x%p, Handle=0x%p\n", cmd, cmd->host_scribble);
-	printk("  chan=0x%02x, target=0x%02x, lun=0x%02x, cmd_len=0x%02x\n",
-	    cmd->device->channel, cmd->device->id, cmd->device->lun,
-	    cmd->cmd_len);
+	scmd_printk(KERN_INFO, cmd,
+		"SCSI Command @=0x%p, Handle=0x%p\n", cmd, cmd->host_scribble);
+	scmd_printk(KERN_INFO, cmd,
+		"  cmd_len=0x%02x\n", cmd->cmd_len);
+
 	printk(" CDB: ");
 	for (i = 0; i < cmd->cmd_len; i++) {
 		printk("0x%02x ", cmd->cmnd[i]);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 09afc0f..9fddf10 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1023,11 +1023,10 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 			if ((unsigned)(cp->request_bufflen - resid) <
 			    cp->underflow) {
 				qla_printk(KERN_INFO, ha,
-				    "scsi(%ld:%d:%d:%d): Mid-layer underflow "
+				    "Mid-layer underflow "
 				    "detected (%x of %x bytes)...returning "
-				    "error status.\n", ha->host_no,
-				    cp->device->channel, cp->device->id,
-				    cp->device->lun, resid,
+				    "error status.\n",
+				    resid,
 				    cp->request_bufflen);
 
 				cp->result = DID_ERROR << 16;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c58c9d9..0e64ec2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -586,7 +586,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
 	srb_t *sp;
 	int ret, i;
-	unsigned int id, lun;
+	unsigned int id;
 	unsigned long serial;
 	unsigned long flags;
 
@@ -595,8 +595,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 
 	ret = FAILED;
 
-	id = cmd->device->id;
-	lun = cmd->device->lun;
+	id = scmd_id(cmd);
 	serial = cmd->serial_number;
 
 	/* Check active list for command command. */
@@ -634,14 +633,13 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	if (ret == SUCCESS) {
 		if (qla2x00_eh_wait_on_command(ha, cmd) != QLA_SUCCESS) {
 			qla_printk(KERN_ERR, ha,
-			    "scsi(%ld:%d:%d): Abort handler timed out -- %lx "
-			    "%x.\n", ha->host_no, id, lun, serial, ret);
+			    "Abort handler timed out -- %lx "
+			    "%x.\n", serial, ret);
 		}
 	}
 
-	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d): Abort command issued -- %lx %x.\n", ha->host_no,
-	    id, lun, serial, ret);
+	qla_printk(KERN_INFO, ha, "Abort command issued -- %lx %x.\n",
+	    serial, ret);
 
 	return ret;
 }
@@ -681,7 +679,7 @@ qla2x00_eh_wait_for_pending_target_comma
 		if (sp) {
 			cmd = sp->cmd;
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-			if (cmd->device->id == t) {
+			if (scmd_id(cmd) == t) {
 				if (!qla2x00_eh_wait_on_command(ha, cmd)) {
 					status = 1;
 					break;
@@ -721,21 +719,19 @@ qla2xxx_eh_device_reset(struct scsi_cmnd
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	srb_t *sp;
 	int ret;
-	unsigned int id, lun;
+	unsigned int id;
 	unsigned long serial;
 
 	ret = FAILED;
 
-	id = cmd->device->id;
-	lun = cmd->device->lun;
+	id = scmd_id(cmd);
 	serial = cmd->serial_number;
 
 	sp = (srb_t *) CMD_SP(cmd);
 	if (!sp || !fcport)
 		return ret;
 
-	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d): DEVICE RESET ISSUED.\n", ha->host_no, id, lun);
+	qla_printk(KERN_INFO, ha, "DEVICE RESET ISSUED.\n");
 
 	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS)
 		goto eh_dev_reset_done;
@@ -775,9 +771,7 @@ qla2xxx_eh_device_reset(struct scsi_cmnd
 		qla_printk(KERN_INFO, ha,
 		    "%s: failed while waiting for commands\n", __func__);
 	} else
-		qla_printk(KERN_INFO, ha,
-		    "scsi(%ld:%d:%d): DEVICE RESET SUCCEEDED.\n", ha->host_no,
-		    id, lun);
+		qla_printk(KERN_INFO, ha, "DEVICE RESET SUCCEEDED.\n");
  eh_dev_reset_done:
 	return ret;
 }
@@ -852,21 +846,19 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *c
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	srb_t *sp;
 	int ret;
-	unsigned int id, lun;
+	unsigned int id;
 	unsigned long serial;
 
 	ret = FAILED;
 
-	id = cmd->device->id;
-	lun = cmd->device->lun;
+	id = scmd_id(cmd);
 	serial = cmd->serial_number;
 
 	sp = (srb_t *) CMD_SP(cmd);
 	if (!sp || !fcport)
 		return ret;
 
-	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d): LOOP RESET ISSUED.\n", ha->host_no, id, lun);
+	qla_printk(KERN_INFO, ha, "LOOP RESET ISSUED.\n");
 
 	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS) {
 		DEBUG2(printk("%s failed:board disabled\n",__func__));
@@ -913,21 +905,19 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	srb_t *sp;
 	int ret;
-	unsigned int id, lun;
+	unsigned int id;
 	unsigned long serial;
 
 	ret = FAILED;
 
-	id = cmd->device->id;
-	lun = cmd->device->lun;
+	id = scmd_id(cmd);
 	serial = cmd->serial_number;
 
 	sp = (srb_t *) CMD_SP(cmd);
 	if (!sp || !fcport)
 		return ret;
 
-	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d): ADAPTER RESET ISSUED.\n", ha->host_no, id, lun);
+	qla_printk(KERN_INFO, ha, "ADAPTER RESET ISSUED.\n");
 
 	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS)
 		goto eh_host_reset_lock;

--------------070901020607030005060509--
