From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 25/29] be2iscsi: Fix bad WRB index error
Date: Fri, 19 Aug 2016 15:20:22 +0530
Message-ID: <1471600226-22055-26-git-send-email-jitendra.bhivare@broadcom.com>
References: <1471600226-22055-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35961 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754479AbcHSJwJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Aug 2016 05:52:09 -0400
Received: by mail-wm0-f51.google.com with SMTP id q128so27544404wma.1
        for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2016 02:52:04 -0700 (PDT)
In-Reply-To: <1471600226-22055-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

In very rare scenario, connection gets killed after throwing this error:
scsi host0: BM_2312 : Event CXN_KILLED_BAD_WRB_INDEX_ERROR[15]... CID : 4
connection1:0: detected conn error (1011)

memset ISCSI_WRB descriptor to zero for all allocations of WRB handle.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 5024651..50d865e 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -967,6 +967,7 @@ beiscsi_get_wrb_handle(struct hwi_wrb_context *pwrb_context,
 	else
 		pwrb_context->alloc_index++;
 	spin_unlock_bh(&pwrb_context->wrb_lock);
+	memset(pwrb_handle->pwrb, 0, sizeof(*pwrb_handle->pwrb));
 
 	return pwrb_handle;
 }
@@ -1209,11 +1210,10 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 		       struct beiscsi_hba *phba, struct sol_cqe *psol)
 {
 	struct hwi_wrb_context *pwrb_context;
-	struct wrb_handle *pwrb_handle = NULL;
+	uint16_t wrb_index, cid, cri_index;
 	struct hwi_controller *phwi_ctrlr;
+	struct wrb_handle *pwrb_handle;
 	struct iscsi_task *task;
-	struct beiscsi_io_task *io_task;
-	uint16_t wrb_index, cid, cri_index;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	if (is_chip_be2_be3r(phba)) {
@@ -1232,9 +1232,6 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 	pwrb_context = &phwi_ctrlr->wrb_context[cri_index];
 	pwrb_handle = pwrb_context->pwrb_handle_basestd[wrb_index];
 	task = pwrb_handle->pio_handle;
-
-	io_task = task->dd_data;
-	memset(io_task->pwrb_handle->pwrb, 0, sizeof(struct iscsi_wrb));
 	iscsi_put_task(task);
 }
 
@@ -4295,16 +4292,12 @@ beiscsi_free_mgmt_task_handles(struct beiscsi_conn *beiscsi_conn,
 	io_task = task->dd_data;
 
 	if (io_task->pwrb_handle) {
-		memset(io_task->pwrb_handle->pwrb, 0,
-		       sizeof(struct iscsi_wrb));
-		free_wrb_handle(phba, pwrb_context,
-				io_task->pwrb_handle);
+		free_wrb_handle(phba, pwrb_context, io_task->pwrb_handle);
 		io_task->pwrb_handle = NULL;
 	}
 
 	if (io_task->psgl_handle) {
-		free_mgmt_sgl_handle(phba,
-				     io_task->psgl_handle);
+		free_mgmt_sgl_handle(phba, io_task->psgl_handle);
 		io_task->psgl_handle = NULL;
 	}
 
@@ -4341,6 +4334,7 @@ static void beiscsi_cleanup_task(struct iscsi_task *task)
 		pci_pool_free(beiscsi_sess->bhs_pool, io_task->cmd_bhs,
 			      io_task->bhs_pa.u.a64.address);
 		io_task->cmd_bhs = NULL;
+		task->hdr = NULL;
 	}
 
 	if (task->sc) {
-- 
1.9.1

