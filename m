From: michaelc@cs.wisc.edu
Subject: [PATCH 04/17] be2iscsi:Freeing of WRB and SGL Handle in cleanup task
Date: Tue,  3 Apr 2012 23:41:39 -0500
Message-ID: <1333514512-21799-5-git-send-email-michaelc@cs.wisc.edu>
References: <1333514512-21799-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab2DDEmE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Apr 2012 00:42:04 -0400
In-Reply-To: <1333514512-21799-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 The WRB and SGL Handle allocated for Login task were not freed
 back to the pool after the login process was done. This code
 releases the WRB and SGL Handle after the login process.

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_iscsi.h |    1 +
 drivers/scsi/be2iscsi/be_main.c  |   68 +++++++++++++++++++++++---------------
 2 files changed, 42 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
index 5c45be1..2f6ada8 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.h
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -31,6 +31,7 @@ umode_t be2iscsi_attr_is_visible(int param_type, int param);
 void beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 				struct beiscsi_offload_params *params);
 
+void beiscsi_cleanup_task(struct iscsi_task *task);
 void beiscsi_offload_iscsi(struct beiscsi_hba *phba, struct iscsi_conn *conn,
 			   struct beiscsi_conn *beiscsi_conn,
 			   unsigned int fw_handle);
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 23344c8..4e20213 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1252,9 +1252,9 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 	task = pwrb_handle->pio_handle;
 
 	io_task = task->dd_data;
-	spin_lock(&phba->mgmt_sgl_lock);
+	spin_lock_bh(&phba->mgmt_sgl_lock);
 	free_mgmt_sgl_handle(phba, io_task->psgl_handle);
-	spin_unlock(&phba->mgmt_sgl_lock);
+	spin_unlock_bh(&phba->mgmt_sgl_lock);
 	spin_lock_bh(&session->lock);
 	free_wrb_handle(phba, pwrb_context, pwrb_handle);
 	spin_unlock_bh(&session->lock);
@@ -3701,12 +3701,16 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 	struct iscsi_target_context_update_wrb *pwrb = NULL;
 	struct be_mem_descriptor *mem_descr;
 	struct beiscsi_hba *phba = beiscsi_conn->phba;
+	struct iscsi_task *task = beiscsi_conn->task;
 	u32 doorbell = 0;
 
 	/*
 	 * We can always use 0 here because it is reserved by libiscsi for
 	 * login/startup related tasks.
 	 */
+	beiscsi_conn->login_in_progress = 0;
+	beiscsi_cleanup_task(task);
+
 	pwrb_handle = alloc_wrb_handle(phba, (beiscsi_conn->beiscsi_conn_cid -
 				       phba->fw_config.iscsi_cid_start));
 	pwrb = (struct iscsi_target_context_update_wrb *)pwrb_handle->pwrb;
@@ -3823,9 +3827,9 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	io_task->pwrb_handle = NULL;
 
 	if (task->sc) {
-		spin_lock(&phba->io_sgl_lock);
+		spin_lock_bh(&phba->io_sgl_lock);
 		io_task->psgl_handle = alloc_io_sgl_handle(phba);
-		spin_unlock(&phba->io_sgl_lock);
+		spin_unlock_bh(&phba->io_sgl_lock);
 		if (!io_task->psgl_handle)
 			goto free_hndls;
 		io_task->pwrb_handle = alloc_wrb_handle(phba,
@@ -3837,10 +3841,10 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 		io_task->scsi_cmnd = NULL;
 		if ((opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN) {
 			if (!beiscsi_conn->login_in_progress) {
-				spin_lock(&phba->mgmt_sgl_lock);
+				spin_lock_bh(&phba->mgmt_sgl_lock);
 				io_task->psgl_handle = (struct sgl_handle *)
 						alloc_mgmt_sgl_handle(phba);
-				spin_unlock(&phba->mgmt_sgl_lock);
+				spin_unlock_bh(&phba->mgmt_sgl_lock);
 				if (!io_task->psgl_handle)
 					goto free_hndls;
 
@@ -3862,10 +3866,11 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 				io_task->pwrb_handle =
 						beiscsi_conn->plogin_wrb_handle;
 			}
+			beiscsi_conn->task = task;
 		} else {
-			spin_lock(&phba->mgmt_sgl_lock);
+			spin_lock_bh(&phba->mgmt_sgl_lock);
 			io_task->psgl_handle = alloc_mgmt_sgl_handle(phba);
-			spin_unlock(&phba->mgmt_sgl_lock);
+			spin_unlock_bh(&phba->mgmt_sgl_lock);
 			if (!io_task->psgl_handle)
 				goto free_hndls;
 			io_task->pwrb_handle =
@@ -3886,14 +3891,14 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	return 0;
 
 free_io_hndls:
-	spin_lock(&phba->io_sgl_lock);
+	spin_lock_bh(&phba->io_sgl_lock);
 	free_io_sgl_handle(phba, io_task->psgl_handle);
-	spin_unlock(&phba->io_sgl_lock);
+	spin_unlock_bh(&phba->io_sgl_lock);
 	goto free_hndls;
 free_mgmt_hndls:
-	spin_lock(&phba->mgmt_sgl_lock);
+	spin_lock_bh(&phba->mgmt_sgl_lock);
 	free_mgmt_sgl_handle(phba, io_task->psgl_handle);
-	spin_unlock(&phba->mgmt_sgl_lock);
+	spin_unlock_bh(&phba->mgmt_sgl_lock);
 free_hndls:
 	phwi_ctrlr = phba->phwi_ctrlr;
 	pwrb_context = &phwi_ctrlr->wrb_context[
@@ -3904,11 +3909,12 @@ free_hndls:
 	io_task->pwrb_handle = NULL;
 	pci_pool_free(beiscsi_sess->bhs_pool, io_task->cmd_bhs,
 		      io_task->bhs_pa.u.a64.address);
+	io_task->cmd_bhs = NULL;
 	SE_DEBUG(DBG_LVL_1, "Alloc of SGL_ICD Failed\n");
 	return -ENOMEM;
 }
 
-static void beiscsi_cleanup_task(struct iscsi_task *task)
+void beiscsi_cleanup_task(struct iscsi_task *task)
 {
 	struct beiscsi_io_task *io_task = task->dd_data;
 	struct iscsi_conn *conn = task->conn;
@@ -3921,32 +3927,40 @@ static void beiscsi_cleanup_task(struct iscsi_task *task)
 	phwi_ctrlr = phba->phwi_ctrlr;
 	pwrb_context = &phwi_ctrlr->wrb_context[beiscsi_conn->beiscsi_conn_cid
 			- phba->fw_config.iscsi_cid_start];
-	if (io_task->pwrb_handle) {
-		free_wrb_handle(phba, pwrb_context, io_task->pwrb_handle);
-		io_task->pwrb_handle = NULL;
-	}
 
 	if (io_task->cmd_bhs) {
 		pci_pool_free(beiscsi_sess->bhs_pool, io_task->cmd_bhs,
 			      io_task->bhs_pa.u.a64.address);
+		io_task->cmd_bhs = NULL;
 	}
 
 	if (task->sc) {
+		if (io_task->pwrb_handle) {
+			free_wrb_handle(phba, pwrb_context,
+					io_task->pwrb_handle);
+			io_task->pwrb_handle = NULL;
+		}
+
 		if (io_task->psgl_handle) {
-			spin_lock(&phba->io_sgl_lock);
+			spin_lock_bh(&phba->io_sgl_lock);
 			free_io_sgl_handle(phba, io_task->psgl_handle);
-			spin_unlock(&phba->io_sgl_lock);
+			spin_unlock_bh(&phba->io_sgl_lock);
 			io_task->psgl_handle = NULL;
 		}
 	} else {
-		if (task->hdr &&
-		   ((task->hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN))
-			return;
-		if (io_task->psgl_handle) {
-			spin_lock(&phba->mgmt_sgl_lock);
-			free_mgmt_sgl_handle(phba, io_task->psgl_handle);
-			spin_unlock(&phba->mgmt_sgl_lock);
-			io_task->psgl_handle = NULL;
+		if (!beiscsi_conn->login_in_progress) {
+			if (io_task->pwrb_handle) {
+				free_wrb_handle(phba, pwrb_context,
+						io_task->pwrb_handle);
+				io_task->pwrb_handle = NULL;
+			}
+			if (io_task->psgl_handle) {
+				spin_lock_bh(&phba->mgmt_sgl_lock);
+				free_mgmt_sgl_handle(phba,
+						     io_task->psgl_handle);
+				spin_unlock_bh(&phba->mgmt_sgl_lock);
+				io_task->psgl_handle = NULL;
+			}
 		}
 	}
 }
-- 
1.7.7.6

