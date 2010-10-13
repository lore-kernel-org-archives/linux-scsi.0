From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Check return value of fc_block_scsi_eh()
Date: Wed, 13 Oct 2010 13:42:28 +0200
Message-ID: <20101013114228.96669354D8@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39210 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab0JMLma (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2010 07:42:30 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id C38688E8CC
	for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2010 13:42:28 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org


fc_block_scsi_eh() might return with status FAST_IO_FAIL
indicating I/O has been terminated due to fast_io_fail timeout.
In this case the rport is still blocked, so any error recovery
will be failing on this port.
Hence each driver needs to check if the return value from
fc_block_scsi_eh() is something other than SUCCESS, in which
case it should just return with that status.
And we need to update the error handler to deal with a
status of FAST_IO_FAIL, too.
And fc_block_scsi_eh() should return SUCCESS on success,
not 0. Otherwise the calling routine will become confused
when reusing that value.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: James Smart <james.smart@emulex.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: Abhijeet Joglekar <abjoglek@cisco.com>

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index ae10883..d5f8b90 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -199,7 +199,7 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 
 		zfcp_erp_wait(adapter);
 		ret = fc_block_scsi_eh(scpnt);
-		if (ret)
+		if (ret != SUCCESS)
 			return ret;
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING)) {
@@ -241,7 +241,7 @@ static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
 
 		zfcp_erp_wait(adapter);
 		ret = fc_block_scsi_eh(scpnt);
-		if (ret)
+		if (ret != SUCCESS)
 			return ret;
 
 		if (!(atomic_read(&adapter->status) &
@@ -283,11 +283,7 @@ static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
 
 	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1", scpnt);
 	zfcp_erp_wait(adapter);
-	ret = fc_block_scsi_eh(scpnt);
-	if (ret)
-		return ret;
-
-	return SUCCESS;
+	return fc_block_scsi_eh(scpnt);
 }
 
 int zfcp_adapter_scsi_register(struct zfcp_adapter *adapter)
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 198cbab..8d797a6 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1240,7 +1240,9 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 
 	/* Wait for rport to unblock */
-	fc_block_scsi_eh(sc);
+	ret = fc_block_scsi_eh(sc);
+	if (ret != SUCCESS)
+		return ret;
 
 	/* Get local-port, check ready and link up */
 	lp = shost_priv(sc->device->host);
@@ -1512,13 +1514,15 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	struct fnic_io_req *io_req;
 	struct fc_rport *rport;
 	int status;
-	int ret = FAILED;
+	int ret;
 	spinlock_t *io_lock;
 	unsigned long flags;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 
 	/* Wait for rport to unblock */
-	fc_block_scsi_eh(sc);
+	ret = fc_block_scsi_eh(sc);
+	if (ret != SUCCESS)
+		return ret;
 
 	/* Get local-port, check ready and link up */
 	lp = shost_priv(sc->device->host);
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 00d08b2..a270a00 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2360,17 +2360,21 @@ static int ibmvfc_eh_abort_handler(struct scsi_cmnd *cmd)
 	struct scsi_device *sdev = cmd->device;
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
 	int cancel_rc, abort_rc;
-	int rc = FAILED;
+	int rc;
 
 	ENTER;
-	fc_block_scsi_eh(cmd);
+	rc = fc_block_scsi_eh(cmd);
+	if (rc != SUCCESS)
+		goto leave;
 	ibmvfc_wait_while_resetting(vhost);
 	cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
 	abort_rc = ibmvfc_abort_task_set(sdev);
 
 	if (!cancel_rc && !abort_rc)
 		rc = ibmvfc_wait_for_ops(vhost, sdev, ibmvfc_match_lun);
-
+	else
+		rc = FAILED;
+leave:
 	LEAVE;
 	return rc;
 }
@@ -2387,17 +2391,21 @@ static int ibmvfc_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	struct scsi_device *sdev = cmd->device;
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
 	int cancel_rc, reset_rc;
-	int rc = FAILED;
+	int rc;
 
 	ENTER;
-	fc_block_scsi_eh(cmd);
+	rc = fc_block_scsi_eh(cmd);
+	if (rc != SUCCESS)
+		goto leave;
 	ibmvfc_wait_while_resetting(vhost);
 	cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_LUN_RESET);
 	reset_rc = ibmvfc_reset_device(sdev, IBMVFC_LUN_RESET, "LUN");
 
 	if (!cancel_rc && !reset_rc)
 		rc = ibmvfc_wait_for_ops(vhost, sdev, ibmvfc_match_lun);
-
+	else
+		rc = FAILED;
+leave:
 	LEAVE;
 	return rc;
 }
@@ -2427,18 +2435,22 @@ static int ibmvfc_eh_target_reset_handler(struct scsi_cmnd *cmd)
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
 	struct scsi_target *starget = scsi_target(sdev);
 	int reset_rc;
-	int rc = FAILED;
+	int rc;
 	unsigned long cancel_rc = 0;
 
 	ENTER;
-	fc_block_scsi_eh(cmd);
+	rc = fc_block_scsi_eh(cmd);
+	if (rc != SUCCESS)
+		goto leave;
 	ibmvfc_wait_while_resetting(vhost);
 	starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all_reset);
 	reset_rc = ibmvfc_reset_device(sdev, IBMVFC_TARGET_RESET, "target");
 
 	if (!cancel_rc && !reset_rc)
 		rc = ibmvfc_wait_for_ops(vhost, starget, ibmvfc_match_target);
-
+	else
+		rc = FAILED;
+leave:
 	LEAVE;
 	return rc;
 }
@@ -2453,7 +2465,10 @@ static int ibmvfc_eh_host_reset_handler(struct scsi_cmnd *cmd)
 	int rc;
 	struct ibmvfc_host *vhost = shost_priv(cmd->device->host);
 
-	fc_block_scsi_eh(cmd);
+	rc = fc_block_scsi_eh(cmd);
+	if (rc != SUCCESS)
+		return rc;
+
 	dev_err(vhost->dev, "Resetting connection due to error recovery\n");
 	rc = ibmvfc_issue_fc_host_lip(vhost->host);
 	return rc ? FAILED : SUCCESS;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 3a65895..c516ba8 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3080,7 +3080,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
 	ret = fc_block_scsi_eh(cmnd);
-	if (ret)
+	if (ret != SUCCESS)
 		return ret;
 	lpfc_cmd = (struct lpfc_scsi_buf *)cmnd->host_scribble;
 	if (!lpfc_cmd) {
@@ -3407,7 +3407,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	}
 	pnode = rdata->pnode;
 	status = fc_block_scsi_eh(cmnd);
-	if (status)
+	if (status != SUCCESS)
 		return status;
 
 	status = lpfc_chk_tgt_mapped(vport, cmnd);
@@ -3474,7 +3474,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	}
 	pnode = rdata->pnode;
 	status = fc_block_scsi_eh(cmnd);
-	if (status)
+	if (status != SUCCESS)
 		return status;
 
 	status = lpfc_chk_tgt_mapped(vport, cmnd);
@@ -3542,7 +3542,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
 
 	ret = fc_block_scsi_eh(cmnd);
-	if (ret)
+	if (ret != SUCCESS)
 		return ret;
 
 	/*
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bdd53f0..75e7719 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -834,12 +834,12 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	srb_t *spt;
 	int got_ref = 0;
 
-	fc_block_scsi_eh(cmd);
-
 	if (!CMD_SP(cmd))
 		return SUCCESS;
 
-	ret = SUCCESS;
+	ret = fc_block_scsi_eh(cmd);
+	if (ret != SUCCESS)
+		return ret;
 
 	id = cmd->device->id;
 	lun = cmd->device->lun;
@@ -966,11 +966,13 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	int err;
 
-	fc_block_scsi_eh(cmd);
-
 	if (!fcport)
 		return FAILED;
 
+	err = fc_block_scsi_eh(cmd);
+	if (err != SUCCESS)
+		return err;
+
 	qla_printk(KERN_INFO, vha->hw, "scsi(%ld:%d:%d): %s RESET ISSUED.\n",
 	    vha->host_no, cmd->device->id, cmd->device->lun, name);
 
@@ -1045,8 +1047,6 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 	unsigned int id, lun;
 	unsigned long serial;
 
-	fc_block_scsi_eh(cmd);
-
 	id = cmd->device->id;
 	lun = cmd->device->lun;
 	serial = cmd->serial_number;
@@ -1054,6 +1054,11 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 	if (!fcport)
 		return ret;
 
+	ret = fc_block_scsi_eh(cmd);
+	if (ret != SUCCESS)
+		return ret;
+	ret = FAILED;
+
 	qla_printk(KERN_INFO, vha->hw,
 	    "scsi(%ld:%d:%d): BUS RESET ISSUED.\n", vha->host_no, id, lun);
 
@@ -1107,8 +1112,6 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	unsigned long serial;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
-	fc_block_scsi_eh(cmd);
-
 	id = cmd->device->id;
 	lun = cmd->device->lun;
 	serial = cmd->serial_number;
@@ -1116,6 +1119,11 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	if (!fcport)
 		return ret;
 
+	ret = fc_block_scsi_eh(cmd);
+	if (ret != SUCCESS)
+		return ret;
+	ret = FAILED;
+
 	qla_printk(KERN_INFO, ha,
 	    "scsi(%ld:%d:%d): ADAPTER RESET ISSUED.\n", vha->host_no, id, lun);
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1de30eb..4279e7c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -655,11 +655,21 @@ static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 
 static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
 {
-	if (__scsi_try_to_abort_cmd(scmd) != SUCCESS)
-		if (scsi_try_bus_device_reset(scmd) != SUCCESS)
-			if (scsi_try_target_reset(scmd) != SUCCESS)
-				if (scsi_try_bus_reset(scmd) != SUCCESS)
-					scsi_try_host_reset(scmd);
+	int ret;
+
+	ret = __scsi_try_to_abort_cmd(scmd);
+	if ((ret == SUCCESS) || (ret == FAST_IO_FAIL))
+		return;
+	ret = scsi_try_bus_device_reset(scmd);
+	if ((ret == SUCCESS) || (ret == FAST_IO_FAIL))
+		return;
+	ret = scsi_try_target_reset(scmd);
+	if ((ret == SUCCESS) || (ret == FAST_IO_FAIL))
+		return;
+	ret = scsi_try_bus_reset(scmd);
+	if ((ret == SUCCESS) || (ret == FAST_IO_FAIL))
+		return;
+	scsi_try_host_reset(scmd);
 }
 
 /**
@@ -958,6 +968,7 @@ retry_tur:
 		if (retry_cnt--)
 			goto retry_tur;
 		/*FALLTHRU*/
+	case FAST_IO_FAIL:
 	case SUCCESS:
 		return 0;
 	default:
@@ -1026,7 +1037,7 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
 		for (i = 0; rtn == NEEDS_RETRY && i < 2; i++)
 			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6, scmd->device->request_queue->rq_timeout, 0);
 
-		if (rtn == SUCCESS)
+		if (rtn == SUCCESS || rtn == FAST_IO_FAIL)
 			return 0;
 	}
 
@@ -1928,17 +1939,17 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	switch (flag) {
 	case SCSI_TRY_RESET_DEVICE:
 		rtn = scsi_try_bus_device_reset(scmd);
-		if (rtn == SUCCESS)
+		if (rtn == SUCCESS || rtn == FAST_IO_FAIL)
 			break;
 		/* FALLTHROUGH */
 	case SCSI_TRY_RESET_TARGET:
 		rtn = scsi_try_target_reset(scmd);
-		if (rtn == SUCCESS)
+		if (rtn == SUCCESS || rtn == FAST_IO_FAIL)
 			break;
 		/* FALLTHROUGH */
 	case SCSI_TRY_RESET_BUS:
 		rtn = scsi_try_bus_reset(scmd);
-		if (rtn == SUCCESS)
+		if (rtn == SUCCESS || rtn == FAST_IO_FAIL)
 			break;
 		/* FALLTHROUGH */
 	case SCSI_TRY_RESET_HOST:
@@ -1966,7 +1977,7 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 
 	scsi_next_command(scmd);
 	scsi_autopm_put_host(shost);
-	return rtn;
+	return (rtn == FAST_IO_FAIL) ? SUCCESS : rtn;
 }
 EXPORT_SYMBOL(scsi_reset_provider);
 
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 998c01b..fae5bcd 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3257,7 +3257,7 @@ fc_scsi_scan_rport(struct work_struct *work)
  * necessary to avoid the scsi_eh failing recovery actions for blocked
  * rports which would lead to offlined SCSI devices.
  *
- * Returns: 0 if the fc_rport left the state FC_PORTSTATE_BLOCKED.
+ * Returns: SUCCESS if the fc_rport left the state FC_PORTSTATE_BLOCKED.
  *	    FAST_IO_FAIL if the fast_io_fail_tmo fired, this should be
  *	    passed back to scsi_eh.
  */
@@ -3279,7 +3279,7 @@ int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
 	if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
 		return FAST_IO_FAIL;
 
-	return 0;
+	return SUCCESS;
 }
 EXPORT_SYMBOL(fc_block_scsi_eh);
 
