From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 03/12] be2iscsi: Link Wrb with next Wrb
Date: Tue, 5 Jan 2010 05:06:21 +0530
Message-ID: <20100104233610.GA16747@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:14385 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753910Ab0ADXf7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 18:35:59 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

	This patch will link the current allocated wrb with the next
 wrb that will be allocated. This is a requirement from the chip.


Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |   19 ++++++++++---------
 drivers/scsi/be2iscsi/be_main.h |    3 +--
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 1390023..ac76b14 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -629,29 +629,30 @@ free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
  * alloc_wrb_handle - To allocate a wrb handle
  * @phba: The hba pointer
  * @cid: The cid to use for allocation
- * @index: index allocation and wrb index
  *
  * This happens under session_lock until submission to chip
  */
-struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid,
-				    int index)
+struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid)
 {
 	struct hwi_wrb_context *pwrb_context;
 	struct hwi_controller *phwi_ctrlr;
-	struct wrb_handle *pwrb_handle;
+	struct wrb_handle *pwrb_handle, *pwrb_handle_tmp;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	pwrb_context = &phwi_ctrlr->wrb_context[cid];
-	if (pwrb_context->wrb_handles_available) {
+	if (pwrb_context->wrb_handles_available >= 2) {
 		pwrb_handle = pwrb_context->pwrb_handle_base[
 					    pwrb_context->alloc_index];
 		pwrb_context->wrb_handles_available--;
-		pwrb_handle->nxt_wrb_index = pwrb_handle->wrb_index;
 		if (pwrb_context->alloc_index ==
 						(phba->params.wrbs_per_cxn - 1))
 			pwrb_context->alloc_index = 0;
 		else
 			pwrb_context->alloc_index++;
+
+		pwrb_handle_tmp = pwrb_context->pwrb_handle_base[
+						pwrb_context->alloc_index];
+		pwrb_handle->nxt_wrb_index = pwrb_handle_tmp->wrb_index;
 	} else
 		pwrb_handle = NULL;
 	return pwrb_handle;
@@ -3206,7 +3207,7 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 	 * login/startup related tasks.
 	 */
 	pwrb_handle = alloc_wrb_handle(phba, (beiscsi_conn->beiscsi_conn_cid -
-				       phba->fw_config.iscsi_cid_start), 0);
+				       phba->fw_config.iscsi_cid_start));
 	pwrb = (struct iscsi_target_context_update_wrb *)pwrb_handle->pwrb;
 	memset(pwrb, 0, sizeof(*pwrb));
 	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb,
@@ -3316,8 +3317,8 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	io_task->libiscsi_itt = (itt_t)task->itt;
 	io_task->pwrb_handle = alloc_wrb_handle(phba,
 						beiscsi_conn->beiscsi_conn_cid -
-						phba->fw_config.iscsi_cid_start,
-						task->itt);
+						phba->fw_config.iscsi_cid_start
+						);
 	io_task->conn = beiscsi_conn;
 
 	task->hdr = (struct iscsi_hdr *)&io_task->cmd_bhs->iscsi_hdr;
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 0e2eac6..0553f49 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -651,8 +651,7 @@ struct amap_iscsi_wrb {
 
 } __packed;
 
-struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid,
-				    int index);
+struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid);
 void
 free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle);
 
-- 
1.6.4

