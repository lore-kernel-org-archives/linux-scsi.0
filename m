From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 2/7] be2iscsi: Cleanup of resets for device and target V2
Date: Sat, 20 Feb 2010 08:02:39 +0530
Message-ID: <20100220023229.GA13603@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:53432 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755518Ab0BTCci (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2010 21:32:38 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

     This patch cleans up device and target reset handling
for the driver

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |  134 +++++++++++++++++++++++++++++++++++++--
 drivers/scsi/be2iscsi/be_main.h |    7 ++
 drivers/scsi/be2iscsi/be_mgmt.c |   14 +++--
 drivers/scsi/be2iscsi/be_mgmt.h |    8 +--
 4 files changed, 145 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 4d269b4..eab31a5 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -58,6 +58,123 @@ static int beiscsi_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
+static int beiscsi_eh_abort(struct scsi_cmnd *sc)
+{
+	struct iscsi_cls_session *cls_session;
+	struct iscsi_task *aborted_task = (struct iscsi_task *)sc->SCp.ptr;
+	struct beiscsi_io_task *aborted_io_task;
+	struct iscsi_conn *conn;
+	struct beiscsi_conn *beiscsi_conn;
+	struct beiscsi_hba *phba;
+	struct iscsi_session *session;
+	struct invalidate_command_table *inv_tbl;
+	unsigned int cid, tag, num_invalidate;
+
+	cls_session = starget_to_session(scsi_target(sc->device));
+	session = cls_session->dd_data;
+
+	spin_lock_bh(&session->lock);
+	if (!aborted_task || !aborted_task->sc) {
+		/* we raced */
+		spin_unlock_bh(&session->lock);
+		return SUCCESS;
+	}
+
+	aborted_io_task = aborted_task->dd_data;
+	if (!aborted_io_task->scsi_cmnd) {
+		/* raced or invalid command */
+		spin_unlock_bh(&session->lock);
+		return SUCCESS;
+	}
+	spin_unlock_bh(&session->lock);
+	conn = aborted_task->conn;
+	beiscsi_conn = conn->dd_data;
+	phba = beiscsi_conn->phba;
+
+	/* invalidate iocb */
+	cid = beiscsi_conn->beiscsi_conn_cid;
+	inv_tbl = phba->inv_tbl;
+	memset(inv_tbl, 0x0, sizeof(*inv_tbl));
+	inv_tbl->cid = cid;
+	inv_tbl->icd = aborted_io_task->psgl_handle->sgl_index;
+	num_invalidate = 1;
+	tag = mgmt_invalidate_icds(phba, inv_tbl, num_invalidate, cid);
+	if (!tag) {
+		shost_printk(KERN_WARNING, phba->shost,
+			     "mgmt_invalidate_icds could not be"
+			     " submitted\n");
+		return FAILED;
+	} else {
+		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
+					 phba->ctrl.mcc_numtag[tag]);
+		free_mcc_tag(&phba->ctrl, tag);
+	}
+
+	return iscsi_eh_abort(sc);
+}
+
+static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
+{
+	struct iscsi_task *abrt_task;
+	struct beiscsi_io_task *abrt_io_task;
+	struct iscsi_conn *conn;
+	struct beiscsi_conn *beiscsi_conn;
+	struct beiscsi_hba *phba;
+	struct iscsi_session *session;
+	struct iscsi_cls_session *cls_session;
+	struct invalidate_command_table *inv_tbl;
+	unsigned int cid, tag, i, num_invalidate;
+	int rc = FAILED;
+
+	/* invalidate iocbs */
+	cls_session = starget_to_session(scsi_target(sc->device));
+	session = cls_session->dd_data;
+	spin_lock_bh(&session->lock);
+	if (!session->leadconn || session->state != ISCSI_STATE_LOGGED_IN)
+		goto unlock;
+
+	conn = session->leadconn;
+	beiscsi_conn = conn->dd_data;
+	phba = beiscsi_conn->phba;
+	cid = beiscsi_conn->beiscsi_conn_cid;
+	inv_tbl = phba->inv_tbl;
+	memset(inv_tbl, 0x0, sizeof(*inv_tbl) * BE2_CMDS_PER_CXN);
+	num_invalidate = 0;
+	for (i = 0; i < conn->session->cmds_max; i++) {
+		abrt_task = conn->session->cmds[i];
+		abrt_io_task = abrt_task->dd_data;
+		if (!abrt_task->sc || abrt_task->state == ISCSI_TASK_FREE)
+			continue;
+
+		if (abrt_task->sc->device->lun != abrt_task->sc->device->lun)
+			continue;
+
+		inv_tbl->cid = cid;
+		inv_tbl->icd = abrt_io_task->psgl_handle->sgl_index;
+		num_invalidate++;
+		inv_tbl++;
+	}
+	spin_unlock_bh(&session->lock);
+	inv_tbl = phba->inv_tbl;
+
+	tag = mgmt_invalidate_icds(phba, inv_tbl, num_invalidate, cid);
+	if (!tag) {
+		shost_printk(KERN_WARNING, phba->shost,
+			     "mgmt_invalidate_icds could not be"
+			     " submitted\n");
+		return FAILED;
+	} else {
+		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
+					 phba->ctrl.mcc_numtag[tag]);
+		free_mcc_tag(&phba->ctrl, tag);
+	}
+
+	return iscsi_eh_device_reset(sc);
+unlock:
+	spin_unlock_bh(&session->lock);
+	return rc;
+}
+
 /*------------------- PCI Driver operations and data ----------------- */
 static DEFINE_PCI_DEVICE_TABLE(beiscsi_pci_id_table) = {
 	{ PCI_DEVICE(BE_VENDOR_ID, BE_DEVICE_ID1) },
@@ -74,11 +191,11 @@ static struct scsi_host_template beiscsi_sht = {
 	.name = "ServerEngines 10Gbe open-iscsi Initiator Driver",
 	.proc_name = DRV_NAME,
 	.queuecommand = iscsi_queuecommand,
-	.eh_abort_handler = iscsi_eh_abort,
 	.change_queue_depth = iscsi_change_queue_depth,
 	.slave_configure = beiscsi_slave_configure,
 	.target_alloc = iscsi_target_alloc,
-	.eh_device_reset_handler = iscsi_eh_device_reset,
+	.eh_abort_handler = beiscsi_eh_abort,
+	.eh_device_reset_handler = beiscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_session_reset,
 	.sg_tablesize = BEISCSI_SGLIST_ELEMENTS,
 	.can_queue = BE2_IO_DEPTH,
@@ -3486,9 +3603,9 @@ static int beiscsi_mtask(struct iscsi_task *task)
 	struct hwi_wrb_context *pwrb_context;
 	struct wrb_handle *pwrb_handle;
 	unsigned int doorbell = 0;
-	unsigned int i, cid;
+	struct invalidate_command_table *inv_tbl;
 	struct iscsi_task *aborted_task;
-	unsigned int tag;
+	unsigned int i, cid, tag, num_invalidate;
 
 	cid = beiscsi_conn->beiscsi_conn_cid;
 	pwrb = io_task->pwrb_handle->pwrb;
@@ -3538,9 +3655,12 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		if (!aborted_io_task->scsi_cmnd)
 			return 0;
 
-		tag = mgmt_invalidate_icds(phba,
-				     aborted_io_task->psgl_handle->sgl_index,
-				     cid);
+		inv_tbl = phba->inv_tbl;
+		memset(inv_tbl, 0x0, sizeof(*inv_tbl));
+		inv_tbl->cid = cid;
+		inv_tbl->icd = aborted_io_task->psgl_handle->sgl_index;
+		num_invalidate = 1;
+		tag = mgmt_invalidate_icds(phba, inv_tbl, num_invalidate, cid);
 		if (!tag) {
 			shost_printk(KERN_WARNING, phba->shost,
 				     "mgmt_invalidate_icds could not be"
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index c53a80a..d4d31dc 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -257,6 +257,11 @@ struct hba_parameters {
 	unsigned int num_sge;
 };
 
+struct invalidate_command_table {
+	unsigned short icd;
+	unsigned short cid;
+} __packed;
+
 struct beiscsi_hba {
 	struct hba_parameters params;
 	struct hwi_controller *phwi_ctrlr;
@@ -329,6 +334,8 @@ struct beiscsi_hba {
 	struct work_struct work_cqs;	/* The work being queued */
 	struct be_ctrl_info ctrl;
 	unsigned int generation;
+	struct invalidate_command_table inv_tbl[128];
+
 };
 
 struct beiscsi_session {
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 317bcd0..72617b6 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -145,14 +145,15 @@ unsigned char mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)
 }
 
 unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
-				   unsigned int icd, unsigned int cid)
+				struct invalidate_command_table *inv_tbl,
+				unsigned int num_invalidate, unsigned int cid)
 {
 	struct be_dma_mem nonemb_cmd;
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 	struct be_mcc_wrb *wrb;
 	struct be_sge *sge;
 	struct invalidate_commands_params_in *req;
-	unsigned int tag = 0;
+	unsigned int i, tag = 0;
 
 	spin_lock(&ctrl->mbox_lock);
 	tag = alloc_mcc_tag(phba);
@@ -183,9 +184,12 @@ unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
 			sizeof(*req));
 	req->ref_handle = 0;
 	req->cleanup_type = CMD_ISCSI_COMMAND_INVALIDATE;
-	req->icd_count = 0;
-	req->table[req->icd_count].icd = icd;
-	req->table[req->icd_count].cid = cid;
+	for (i = 0; i < num_invalidate; i++) {
+		req->table[i].icd = inv_tbl->icd;
+		req->table[i].cid = inv_tbl->cid;
+		req->icd_count++;
+		inv_tbl++;
+	}
 	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd.dma));
 	sge->pa_lo = cpu_to_le32(nonemb_cmd.dma & 0xFFFFFFFF);
 	sge->len = cpu_to_le32(nonemb_cmd.size);
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index ecead6a..3d316b8 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -94,7 +94,8 @@ unsigned char mgmt_upload_connection(struct beiscsi_hba *phba,
 				     unsigned short cid,
 				     unsigned int upload_flag);
 unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
-				   unsigned int icd, unsigned int cid);
+				struct invalidate_command_table *inv_tbl,
+				unsigned int num_invalidate, unsigned int cid);
 
 struct iscsi_invalidate_connection_params_in {
 	struct be_cmd_req_hdr hdr;
@@ -116,11 +117,6 @@ union iscsi_invalidate_connection_params {
 	struct iscsi_invalidate_connection_params_out response;
 } __packed;
 
-struct invalidate_command_table {
-	unsigned short icd;
-	unsigned short cid;
-} __packed;
-
 struct invalidate_commands_params_in {
 	struct be_cmd_req_hdr hdr;
 	unsigned int ref_handle;
-- 
1.6.4

