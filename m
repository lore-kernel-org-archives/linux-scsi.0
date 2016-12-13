From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 05/13] be2iscsi: Add checks to validate completions
Date: Tue, 13 Dec 2016 15:55:58 +0530
Message-ID: <1481624766-13846-6-git-send-email-jitendra.bhivare@broadcom.com>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:34164 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932220AbcLMK0x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2016 05:26:53 -0500
Received: by mail-qk0-f172.google.com with SMTP id q130so111369092qke.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2016 02:26:52 -0800 (PST)
In-Reply-To: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
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
index b509acd..832d4f0 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -960,6 +960,10 @@ beiscsi_get_wrb_handle(struct hwi_wrb_context *pwrb_context,
 	unsigned long flags;
 
 	spin_lock_irqsave(&pwrb_context->wrb_lock, flags);
+	if (!pwrb_context->wrb_handles_available) {
+		spin_unlock_irqrestore(&pwrb_context->wrb_lock, flags);
+		return NULL;
+	}
 	pwrb_handle = pwrb_context->pwrb_handle_base[pwrb_context->alloc_index];
 	pwrb_context->wrb_handles_available--;
 	if (pwrb_context->alloc_index == (wrbs_per_cxn - 1))
@@ -1010,6 +1014,7 @@ beiscsi_put_wrb_handle(struct hwi_wrb_context *pwrb_context,
 		pwrb_context->free_index = 0;
 	else
 		pwrb_context->free_index++;
+	pwrb_handle->pio_handle = NULL;
 	spin_unlock_irqrestore(&pwrb_context->wrb_lock, flags);
 }
 
@@ -1220,6 +1225,7 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 	uint16_t wrb_index, cid, cri_index;
 	struct hwi_controller *phwi_ctrlr;
 	struct wrb_handle *pwrb_handle;
+	struct iscsi_session *session;
 	struct iscsi_task *task;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
@@ -1238,8 +1244,12 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
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
2.7.4

