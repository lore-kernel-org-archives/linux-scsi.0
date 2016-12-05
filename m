From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 05/12] be2iscsi: Add checks to validate completions
Date: Mon,  5 Dec 2016 13:36:44 +0530
Message-ID: <1480925211-13223-6-git-send-email-jitendra.bhivare@broadcom.com>
References: <1480925211-13223-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:33645 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbcLEIHQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 03:07:16 -0500
Received: by mail-qt0-f182.google.com with SMTP id p16so305896694qta.0
        for <linux-scsi@vger.kernel.org>; Mon, 05 Dec 2016 00:07:16 -0800 (PST)
In-Reply-To: <1480925211-13223-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Added check in beiscsi_process_cq for pio_handle.
pio_handle is cleared in beiscsi_put_wrb_handle.
This catches any case where task gets cleaned up just before completion.

Use back_lock before accessing pio_handle.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 948384c..bd5e10e 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -960,6 +960,10 @@ static struct sgl_handle *alloc_io_sgl_handle(struct beiscsi_hba *phba)
 	unsigned long flags;
 
 	spin_lock_irqsave(&pwrb_context->wrb_lock, flags);
+	if (!pwrb_context->wrb_handles_available) {
+		spin_unlock_irqrestore(&pwrb_context->wrb_lock, flags);
+		return NULL;
+	}
 	pwrb_handle = pwrb_context->pwrb_handle_base[pwrb_context->alloc_index];
 	pwrb_context->wrb_handles_available--;
 	if (pwrb_context->alloc_index == (wrbs_per_cxn - 1))
@@ -1010,6 +1014,7 @@ struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid,
 		pwrb_context->free_index = 0;
 	else
 		pwrb_context->free_index++;
+	pwrb_handle->pio_handle = NULL;
 	spin_unlock_irqrestore(&pwrb_context->wrb_lock, flags);
 }
 
@@ -1220,6 +1225,7 @@ static struct sgl_handle *alloc_mgmt_sgl_handle(struct beiscsi_hba *phba)
 	uint16_t wrb_index, cid, cri_index;
 	struct hwi_controller *phwi_ctrlr;
 	struct wrb_handle *pwrb_handle;
+	struct iscsi_session *session;
 	struct iscsi_task *task;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
@@ -1238,8 +1244,12 @@ static struct sgl_handle *alloc_mgmt_sgl_handle(struct beiscsi_hba *phba)
 	cri_index = BE_GET_CRI_FROM_CID(cid);
 	pwrb_context = &phwi_ctrlr->wrb_context[cri_index];
 	pwrb_handle = pwrb_context->pwrb_handle_basestd[wrb_index];
+	session = beiscsi_conn->conn->session;
+	spin_lock_bh(&session->back_lock);
 	task = pwrb_handle->pio_handle;
-	iscsi_put_task(task);
+	if (task)
+		__iscsi_put_task(task);
+	spin_unlock_bh(&session->back_lock);
 }
 
 static void
@@ -1319,16 +1329,16 @@ static void adapter_get_sol_cqe(struct beiscsi_hba *phba,
 static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 			     struct beiscsi_hba *phba, struct sol_cqe *psol)
 {
+	struct iscsi_conn *conn = beiscsi_conn->conn;
+	struct iscsi_session *session = conn->session;
+	struct common_sol_cqe csol_cqe = {0};
 	struct hwi_wrb_context *pwrb_context;
+	struct hwi_controller *phwi_ctrlr;
 	struct wrb_handle *pwrb_handle;
 	struct iscsi_wrb *pwrb = NULL;
-	struct hwi_controller *phwi_ctrlr;
 	struct iscsi_task *task;
-	unsigned int type;
-	struct iscsi_conn *conn = beiscsi_conn->conn;
-	struct iscsi_session *session = conn->session;
-	struct common_sol_cqe csol_cqe = {0};
 	uint16_t cri_index = 0;
+	uint8_t type;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 
@@ -1341,11 +1351,15 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	pwrb_handle = pwrb_context->pwrb_handle_basestd[
 		      csol_cqe.wrb_index];
 
+	spin_lock_bh(&session->back_lock);
 	task = pwrb_handle->pio_handle;
+	if (!task) {
+		spin_unlock_bh(&session->back_lock);
+		return;
+	}
 	pwrb = pwrb_handle->pwrb;
 	type = ((struct beiscsi_io_task *)task->dd_data)->wrb_type;
 
-	spin_lock_bh(&session->back_lock);
 	switch (type) {
 	case HWH_TYPE_IO:
 	case HWH_TYPE_IO_RD:
-- 
1.8.3.1

