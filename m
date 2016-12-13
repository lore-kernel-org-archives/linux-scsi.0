From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 02/13] be2iscsi: Fix for crash in beiscsi_eh_device_reset
Date: Tue, 13 Dec 2016 15:55:55 +0530
Message-ID: <1481624766-13846-3-git-send-email-jitendra.bhivare@broadcom.com>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:34138 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932220AbcLMK0l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2016 05:26:41 -0500
Received: by mail-qt0-f169.google.com with SMTP id n6so102362923qtd.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2016 02:26:41 -0800 (PST)
In-Reply-To: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

System crashes when sg_reset is executed in a loop.
CPU: 13 PID: 7073 Comm: sg_reset Tainted: G            E   4.8.0-rc1+ #4
RIP: 0010:[<ffffffffa0825370>]  [<ffffffffa0825370>]
beiscsi_eh_device_reset+0x160/0x520 [be2iscsi]
Call Trace:
[<ffffffff814c7c77>] ? scsi_host_alloc_command+0x47/0xc0
[<ffffffff814caafa>] scsi_try_bus_device_reset+0x2a/0x50
[<ffffffff814cb46e>] scsi_ioctl_reset+0x13e/0x260
[<ffffffff814ca477>] scsi_ioctl+0x137/0x3d0
[<ffffffffa05e4ba2>] sg_ioctl+0x572/0xc20 [sg]
[<ffffffff8123f627>] do_vfs_ioctl+0xa7/0x5d0

The accesses to beiscsi_io_task is being protected in device reset handler
with frwd_lock but the freeing of task can happen under back_lock.

Hold the reference of iscsi_task till invalidation completes.
This prevents use of ICD when invalidation of that ICD is being processed.
Use frwd_lock for iscsi_tasks looping and back_lock to access
beiscsi_io_task structures.

Rewrite mgmt_invalidation_icds to handle allocation and freeing of IOCTL
buffer in one place.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 121 +++++++++++++++++-----------------------
 drivers/scsi/be2iscsi/be_mgmt.c | 107 ++++++++++++++++++++---------------
 drivers/scsi/be2iscsi/be_mgmt.h |   8 +--
 3 files changed, 114 insertions(+), 122 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 3811a0d..7feecc0 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -226,8 +226,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 	struct beiscsi_hba *phba;
 	struct iscsi_session *session;
 	struct invldt_cmd_tbl inv_tbl;
-	struct be_dma_mem nonemb_cmd;
-	unsigned int cid, tag;
+	unsigned int cid;
 	int rc;
 
 	cls_session = starget_to_session(scsi_target(sc->device));
@@ -259,64 +258,47 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 	cid = beiscsi_conn->beiscsi_conn_cid;
 	inv_tbl.cid = cid;
 	inv_tbl.icd = aborted_io_task->psgl_handle->sgl_index;
-	nonemb_cmd.size = sizeof(union be_invldt_cmds_params);
-	nonemb_cmd.va = pci_zalloc_consistent(phba->ctrl.pdev,
-					      nonemb_cmd.size,
-					      &nonemb_cmd.dma);
-	if (nonemb_cmd.va == NULL) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
-			    "BM_%d : Failed to allocate memory for"
-			    "mgmt_invalidate_icds\n");
-		return FAILED;
-	}
-
-	tag = mgmt_invalidate_icds(phba, &inv_tbl, 1, cid, &nonemb_cmd);
-	if (!tag) {
+	rc = beiscsi_mgmt_invalidate_icds(phba, &inv_tbl, 1);
+	if (rc) {
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_EH,
-			    "BM_%d : mgmt_invalidate_icds could not be"
-			    "submitted\n");
-		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
-				    nonemb_cmd.va, nonemb_cmd.dma);
-
+			    "BM_%d : sc %p invalidation failed %d\n",
+			    sc, rc);
 		return FAILED;
 	}
 
-	rc = beiscsi_mccq_compl_wait(phba, tag, NULL, &nonemb_cmd);
-	if (rc != -EBUSY)
-		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
-				    nonemb_cmd.va, nonemb_cmd.dma);
-
 	return iscsi_eh_abort(sc);
 }
 
 static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 {
-	struct iscsi_task *abrt_task;
-	struct beiscsi_io_task *abrt_io_task;
-	struct iscsi_conn *conn;
+	struct beiscsi_invldt_cmd_tbl {
+		struct invldt_cmd_tbl tbl[BE_INVLDT_CMD_TBL_SZ];
+		struct iscsi_task *task[BE_INVLDT_CMD_TBL_SZ];
+	} *inv_tbl;
+	struct iscsi_cls_session *cls_session;
 	struct beiscsi_conn *beiscsi_conn;
-	struct beiscsi_hba *phba;
+	struct beiscsi_io_task *io_task;
 	struct iscsi_session *session;
-	struct iscsi_cls_session *cls_session;
-	struct invldt_cmd_tbl *inv_tbl;
-	struct be_dma_mem nonemb_cmd;
-	unsigned int cid, tag, i, nents;
+	struct beiscsi_hba *phba;
+	struct iscsi_conn *conn;
+	struct iscsi_task *task;
+	unsigned int i, nents;
 	int rc, more = 0;
 
-	/* invalidate iocbs */
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
+
 	spin_lock_bh(&session->frwd_lock);
 	if (!session->leadconn || session->state != ISCSI_STATE_LOGGED_IN) {
 		spin_unlock_bh(&session->frwd_lock);
 		return FAILED;
 	}
+
 	conn = session->leadconn;
 	beiscsi_conn = conn->dd_data;
 	phba = beiscsi_conn->phba;
-	cid = beiscsi_conn->beiscsi_conn_cid;
 
-	inv_tbl = kcalloc(BE_INVLDT_CMD_TBL_SZ, sizeof(*inv_tbl), GFP_KERNEL);
+	inv_tbl = kzalloc(sizeof(*inv_tbl), GFP_KERNEL);
 	if (!inv_tbl) {
 		spin_unlock_bh(&session->frwd_lock);
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
@@ -324,13 +306,14 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 		return FAILED;
 	}
 	nents = 0;
+	/* take back_lock to prevent task from getting cleaned up under us */
+	spin_lock(&session->back_lock);
 	for (i = 0; i < conn->session->cmds_max; i++) {
-		abrt_task = conn->session->cmds[i];
-		abrt_io_task = abrt_task->dd_data;
-		if (!abrt_task->sc || abrt_task->state == ISCSI_TASK_FREE)
+		task = conn->session->cmds[i];
+		if (!task->sc)
 			continue;
 
-		if (sc->device->lun != abrt_task->sc->device->lun)
+		if (sc->device->lun != task->sc->device->lun)
 			continue;
 		/**
 		 * Can't fit in more cmds? Normally this won't happen b'coz
@@ -341,52 +324,48 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 			break;
 		}
 
-		/* Invalidate WRB Posted for this Task */
+		/* get a task ref till FW processes the req for the ICD used */
+		__iscsi_get_task(task);
+		io_task = task->dd_data;
+		/* mark WRB invalid which have been not processed by FW yet */
 		AMAP_SET_BITS(struct amap_iscsi_wrb, invld,
-			      abrt_io_task->pwrb_handle->pwrb,
+			      io_task->pwrb_handle->pwrb,
 			      1);
 
-		inv_tbl[nents].cid = cid;
-		inv_tbl[nents].icd = abrt_io_task->psgl_handle->sgl_index;
+		inv_tbl->tbl[nents].cid = beiscsi_conn->beiscsi_conn_cid;
+		inv_tbl->tbl[nents].icd = io_task->psgl_handle->sgl_index;
+		inv_tbl->task[nents] = task;
 		nents++;
 	}
+	spin_unlock_bh(&session->back_lock);
 	spin_unlock_bh(&session->frwd_lock);
 
+	rc = SUCCESS;
+	if (!nents)
+		goto end_reset;
+
 	if (more) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
 			    "BM_%d : number of cmds exceeds size of invalidation table\n");
-		kfree(inv_tbl);
-		return FAILED;
+		rc = FAILED;
+		goto end_reset;
 	}
 
-	nonemb_cmd.size = sizeof(union be_invldt_cmds_params);
-	nonemb_cmd.va = pci_zalloc_consistent(phba->ctrl.pdev,
-					      nonemb_cmd.size,
-					      &nonemb_cmd.dma);
-	if (nonemb_cmd.va == NULL) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
-			    "BM_%d : Failed to allocate memory for"
-			    "mgmt_invalidate_icds\n");
-		kfree(inv_tbl);
-		return FAILED;
-	}
-	tag = mgmt_invalidate_icds(phba, inv_tbl, nents,
-				   cid, &nonemb_cmd);
-	kfree(inv_tbl);
-	if (!tag) {
+	if (beiscsi_mgmt_invalidate_icds(phba, &inv_tbl->tbl[0], nents)) {
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_EH,
-			    "BM_%d : mgmt_invalidate_icds could not be"
-			    " submitted\n");
-		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
-				    nonemb_cmd.va, nonemb_cmd.dma);
-		return FAILED;
+			    "BM_%d : cid %u scmds invalidation failed\n",
+			    beiscsi_conn->beiscsi_conn_cid);
+		rc = FAILED;
 	}
 
-	rc = beiscsi_mccq_compl_wait(phba, tag, NULL, &nonemb_cmd);
-	if (rc != -EBUSY)
-		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
-				    nonemb_cmd.va, nonemb_cmd.dma);
-	return iscsi_eh_device_reset(sc);
+end_reset:
+	for (i = 0; i < nents; i++)
+		iscsi_put_task(inv_tbl->task[i]);
+	kfree(inv_tbl);
+
+	if (rc == SUCCESS)
+		rc = iscsi_eh_device_reset(sc);
+	return rc;
 }
 
 /*------------------- PCI Driver operations and data ----------------- */
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 5f02e8d..110c0d0 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -128,52 +128,6 @@ unsigned int mgmt_vendor_specific_fw_cmd(struct be_ctrl_info *ctrl,
 	return tag;
 }
 
-unsigned int  mgmt_invalidate_icds(struct beiscsi_hba *phba,
-				struct invldt_cmd_tbl *inv_tbl,
-				unsigned int num_invalidate, unsigned int cid,
-				struct be_dma_mem *nonemb_cmd)
-
-{
-	struct be_ctrl_info *ctrl = &phba->ctrl;
-	struct be_mcc_wrb *wrb;
-	struct be_sge *sge;
-	struct invldt_cmds_params_in *req;
-	unsigned int i, tag;
-
-	if (num_invalidate > BE_INVLDT_CMD_TBL_SZ)
-		return 0;
-
-	mutex_lock(&ctrl->mbox_lock);
-	wrb = alloc_mcc_wrb(phba, &tag);
-	if (!wrb) {
-		mutex_unlock(&ctrl->mbox_lock);
-		return 0;
-	}
-
-	req = nonemb_cmd->va;
-	memset(req, 0, sizeof(*req));
-	sge = nonembedded_sgl(wrb);
-
-	be_wrb_hdr_prepare(wrb, sizeof(*req), false, 1);
-	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
-			OPCODE_COMMON_ISCSI_ERROR_RECOVERY_INVALIDATE_COMMANDS,
-			sizeof(*req));
-	req->ref_handle = 0;
-	req->cleanup_type = CMD_ISCSI_COMMAND_INVALIDATE;
-	for (i = 0; i < num_invalidate; i++) {
-		req->table[i].icd = inv_tbl[i].icd;
-		req->table[i].cid = inv_tbl[i].cid;
-		req->icd_count++;
-	}
-	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd->dma));
-	sge->pa_lo = cpu_to_le32(nonemb_cmd->dma & 0xFFFFFFFF);
-	sge->len = cpu_to_le32(nonemb_cmd->size);
-
-	be_mcc_notify(phba, tag);
-	mutex_unlock(&ctrl->mbox_lock);
-	return tag;
-}
-
 unsigned int mgmt_invalidate_connection(struct beiscsi_hba *phba,
 					 struct beiscsi_endpoint *beiscsi_ep,
 					 unsigned short cid,
@@ -1496,3 +1450,64 @@ void beiscsi_offload_cxn_v2(struct beiscsi_offload_params *params,
 		     (params->dw[offsetof(struct amap_beiscsi_offload_params,
 		      exp_statsn) / 32] + 1));
 }
+
+int beiscsi_mgmt_invalidate_icds(struct beiscsi_hba *phba,
+				 struct invldt_cmd_tbl *inv_tbl,
+				 unsigned int nents)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct invldt_cmds_params_in *req;
+	struct be_dma_mem nonemb_cmd;
+	struct be_mcc_wrb *wrb;
+	unsigned int i, tag;
+	struct be_sge *sge;
+	int rc;
+
+	if (!nents || nents > BE_INVLDT_CMD_TBL_SZ)
+		return -EINVAL;
+
+	nonemb_cmd.size = sizeof(union be_invldt_cmds_params);
+	nonemb_cmd.va = pci_zalloc_consistent(phba->ctrl.pdev,
+					      nonemb_cmd.size,
+					      &nonemb_cmd.dma);
+	if (!nonemb_cmd.va) {
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
+			    "BM_%d : invldt_cmds_params alloc failed\n");
+		return -ENOMEM;
+	}
+
+	mutex_lock(&ctrl->mbox_lock);
+	wrb = alloc_mcc_wrb(phba, &tag);
+	if (!wrb) {
+		mutex_unlock(&ctrl->mbox_lock);
+		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
+				    nonemb_cmd.va, nonemb_cmd.dma);
+		return -ENOMEM;
+	}
+
+	req = nonemb_cmd.va;
+	be_wrb_hdr_prepare(wrb, nonemb_cmd.size, false, 1);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
+			OPCODE_COMMON_ISCSI_ERROR_RECOVERY_INVALIDATE_COMMANDS,
+			sizeof(*req));
+	req->ref_handle = 0;
+	req->cleanup_type = CMD_ISCSI_COMMAND_INVALIDATE;
+	for (i = 0; i < nents; i++) {
+		req->table[i].icd = inv_tbl[i].icd;
+		req->table[i].cid = inv_tbl[i].cid;
+		req->icd_count++;
+	}
+	sge = nonembedded_sgl(wrb);
+	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd.dma));
+	sge->pa_lo = cpu_to_le32(lower_32_bits(nonemb_cmd.dma));
+	sge->len = cpu_to_le32(nonemb_cmd.size);
+
+	be_mcc_notify(phba, tag);
+	mutex_unlock(&ctrl->mbox_lock);
+
+	rc = beiscsi_mccq_compl_wait(phba, tag, NULL, &nonemb_cmd);
+	if (rc != -EBUSY)
+		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
+				    nonemb_cmd.va, nonemb_cmd.dma);
+	return rc;
+}
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 6e19281..f301d57 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -258,16 +258,14 @@ struct beiscsi_endpoint {
 	u16 cid_vld;
 };
 
-unsigned int mgmt_invalidate_icds(struct beiscsi_hba *phba,
-				struct invldt_cmd_tbl *inv_tbl,
-				unsigned int num_invalidate, unsigned int cid,
-				struct be_dma_mem *nonemb_cmd);
-
 unsigned int mgmt_invalidate_connection(struct beiscsi_hba *phba,
 					 struct beiscsi_endpoint *beiscsi_ep,
 					 unsigned short cid,
 					 unsigned short issue_reset,
 					 unsigned short savecfg_flag);
+int beiscsi_mgmt_invalidate_icds(struct beiscsi_hba *phba,
+				 struct invldt_cmd_tbl *inv_tbl,
+				 unsigned int nents);
 
 int beiscsi_if_en_dhcp(struct beiscsi_hba *phba, u32 ip_type);
 
-- 
2.7.4

