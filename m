From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v1 03/12] be2iscsi: Remove redundant MCC processing code
Date: Thu,  4 Feb 2016 15:49:11 +0530
Message-ID: <1454581160-31869-4-git-send-email-jitendra.bhivare@broadcom.com>
References: <1454581160-31869-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:62101 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757796AbcBDKhY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 05:37:24 -0500
In-Reply-To: <1454581160-31869-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

be_mcc_compl_process_isr is removed.
MCC CQ processing is done only in beiscsi_process_mcc_cq and MCC CQE
processing is done only in beiscsi_process_mcc_compl.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/be2iscsi/be_cmds.c | 165 ++++++++++++++--------------------------
 drivers/scsi/be2iscsi/be_cmds.h |   7 +-
 drivers/scsi/be2iscsi/be_main.c |   8 +-
 drivers/scsi/be2iscsi/be_main.h |   1 +
 drivers/scsi/be2iscsi/be_mgmt.c |   3 +-
 5 files changed, 68 insertions(+), 116 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index c5e7739..f59dbdf 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -328,76 +328,6 @@ static int be_mcc_compl_process(struct be_ctrl_info *ctrl,
 	return 0;
 }
 
-int be_mcc_compl_process_isr(struct be_ctrl_info *ctrl,
-				    struct be_mcc_compl *compl)
-{
-	struct beiscsi_hba *phba = pci_get_drvdata(ctrl->pdev);
-	u16 compl_status, extd_status;
-	struct be_dma_mem *tag_mem;
-	unsigned int tag, wrb_idx;
-
-	be_dws_le_to_cpu(compl, 4);
-	tag = (compl->tag0 & MCC_Q_CMD_TAG_MASK);
-	wrb_idx = (compl->tag0 & CQE_STATUS_WRB_MASK) >> CQE_STATUS_WRB_SHIFT;
-
-	if (!test_bit(MCC_TAG_STATE_RUNNING,
-		      &ctrl->ptag_state[tag].tag_state)) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_MBOX |
-			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-			    "BC_%d : MBX cmd completed but not posted\n");
-		return 0;
-	}
-
-	if (test_bit(MCC_TAG_STATE_TIMEOUT,
-		     &ctrl->ptag_state[tag].tag_state)) {
-		beiscsi_log(phba, KERN_WARNING,
-			    BEISCSI_LOG_MBOX | BEISCSI_LOG_INIT |
-			    BEISCSI_LOG_CONFIG,
-			    "BC_%d : MBX Completion for timeout Command from FW\n");
-		/**
-		 * Check for the size before freeing resource.
-		 * Only for non-embedded cmd, PCI resource is allocated.
-		 **/
-		tag_mem = &ctrl->ptag_state[tag].tag_mem_state;
-		if (tag_mem->size)
-			pci_free_consistent(ctrl->pdev, tag_mem->size,
-					tag_mem->va, tag_mem->dma);
-		free_mcc_tag(ctrl, tag);
-		return 0;
-	}
-
-	compl_status = (compl->status >> CQE_STATUS_COMPL_SHIFT) &
-		       CQE_STATUS_COMPL_MASK;
-	extd_status = (compl->status >> CQE_STATUS_EXTD_SHIFT) &
-		      CQE_STATUS_EXTD_MASK;
-	/* The ctrl.mcc_tag_status[tag] is filled with
-	 * [31] = valid, [30:24] = Rsvd, [23:16] = wrb, [15:8] = extd_status,
-	 * [7:0] = compl_status
-	 */
-	ctrl->mcc_tag_status[tag] = CQE_VALID_MASK;
-	ctrl->mcc_tag_status[tag] |= (wrb_idx << CQE_STATUS_WRB_SHIFT);
-	ctrl->mcc_tag_status[tag] |= (extd_status << CQE_STATUS_ADDL_SHIFT) &
-				     CQE_STATUS_ADDL_MASK;
-	ctrl->mcc_tag_status[tag] |= (compl_status & CQE_STATUS_MASK);
-
-	/* write ordering implied in wake_up_interruptible */
-	clear_bit(MCC_TAG_STATE_RUNNING, &ctrl->ptag_state[tag].tag_state);
-	wake_up_interruptible(&ctrl->mcc_wait[tag]);
-	return 0;
-}
-
-static struct be_mcc_compl *be_mcc_compl_get(struct beiscsi_hba *phba)
-{
-	struct be_queue_info *mcc_cq = &phba->ctrl.mcc_obj.cq;
-	struct be_mcc_compl *compl = queue_tail_node(mcc_cq);
-
-	if (be_mcc_compl_is_new(compl)) {
-		queue_tail_inc(mcc_cq);
-		return compl;
-	}
-	return NULL;
-}
-
 /**
  * beiscsi_fail_session(): Closing session with appropriate error
  * @cls_session: ptr to session
@@ -528,27 +458,65 @@ void beiscsi_process_async_event(struct beiscsi_hba *phba,
 		    evt_code, compl->status, compl->flags);
 }
 
-int beiscsi_process_mcc(struct beiscsi_hba *phba)
+int beiscsi_process_mcc_compl(struct be_ctrl_info *ctrl,
+			      struct be_mcc_compl *compl)
 {
-	struct be_mcc_compl *compl;
-	int num = 0, status = 0;
-	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct beiscsi_hba *phba = pci_get_drvdata(ctrl->pdev);
+	u16 compl_status, extd_status;
+	struct be_dma_mem *tag_mem;
+	unsigned int tag, wrb_idx;
 
-	while ((compl = be_mcc_compl_get(phba))) {
-		if (compl->flags & CQE_FLAGS_ASYNC_MASK) {
-			beiscsi_process_async_event(phba, compl);
-		} else if (compl->flags & CQE_FLAGS_COMPLETED_MASK) {
-			status = be_mcc_compl_process(ctrl, compl);
-			atomic_dec(&phba->ctrl.mcc_obj.q.used);
-		}
-		be_mcc_compl_use(compl);
-		num++;
+	/**
+	 * Just swap the status to host endian; mcc tag is opaquely copied
+	 * from mcc_wrb
+	 */
+	be_dws_le_to_cpu(compl, 4);
+	tag = (compl->tag0 & MCC_Q_CMD_TAG_MASK);
+	wrb_idx = (compl->tag0 & CQE_STATUS_WRB_MASK) >> CQE_STATUS_WRB_SHIFT;
+
+	if (!test_bit(MCC_TAG_STATE_RUNNING,
+		      &ctrl->ptag_state[tag].tag_state)) {
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_MBOX |
+			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
+			    "BC_%d : MBX cmd completed but not posted\n");
+		return 0;
 	}
 
-	if (num)
-		hwi_ring_cq_db(phba, phba->ctrl.mcc_obj.cq.id, num, 1);
+	if (test_bit(MCC_TAG_STATE_TIMEOUT, &ctrl->ptag_state[tag].tag_state)) {
+		beiscsi_log(phba, KERN_WARNING,
+			    BEISCSI_LOG_MBOX | BEISCSI_LOG_INIT |
+			    BEISCSI_LOG_CONFIG,
+			    "BC_%d : MBX Completion for timeout Command from FW\n");
+		/**
+		 * Check for the size before freeing resource.
+		 * Only for non-embedded cmd, PCI resource is allocated.
+		 **/
+		tag_mem = &ctrl->ptag_state[tag].tag_mem_state;
+		if (tag_mem->size)
+			pci_free_consistent(ctrl->pdev, tag_mem->size,
+					tag_mem->va, tag_mem->dma);
+		free_mcc_tag(ctrl, tag);
+		return 0;
+	}
 
-	return status;
+	compl_status = (compl->status >> CQE_STATUS_COMPL_SHIFT) &
+		       CQE_STATUS_COMPL_MASK;
+	extd_status = (compl->status >> CQE_STATUS_EXTD_SHIFT) &
+		      CQE_STATUS_EXTD_MASK;
+	/* The ctrl.mcc_tag_status[tag] is filled with
+	 * [31] = valid, [30:24] = Rsvd, [23:16] = wrb, [15:8] = extd_status,
+	 * [7:0] = compl_status
+	 */
+	ctrl->mcc_tag_status[tag] = CQE_VALID_MASK;
+	ctrl->mcc_tag_status[tag] |= (wrb_idx << CQE_STATUS_WRB_SHIFT);
+	ctrl->mcc_tag_status[tag] |= (extd_status << CQE_STATUS_ADDL_SHIFT) &
+				     CQE_STATUS_ADDL_MASK;
+	ctrl->mcc_tag_status[tag] |= (compl_status & CQE_STATUS_MASK);
+
+	/* write ordering forced in wake_up_interruptible */
+	clear_bit(MCC_TAG_STATE_RUNNING, &ctrl->ptag_state[tag].tag_state);
+	wake_up_interruptible(&ctrl->mcc_wait[tag]);
+	return 0;
 }
 
 /*
@@ -562,16 +530,15 @@ int beiscsi_process_mcc(struct beiscsi_hba *phba)
  * Failure: Non-Zero
  *
  **/
-static int be_mcc_wait_compl(struct beiscsi_hba *phba)
+int be_mcc_compl_poll(struct beiscsi_hba *phba, unsigned int tag)
 {
-	int i, status;
+	int i;
+
 	for (i = 0; i < mcc_timeout; i++) {
 		if (beiscsi_error(phba))
 			return -EIO;
 
-		status = beiscsi_process_mcc(phba);
-		if (status)
-			return status;
+		beiscsi_process_mcc_cq(phba);
 
 		if (atomic_read(&phba->ctrl.mcc_obj.q.used) == 0)
 			break;
@@ -589,22 +556,6 @@ static int be_mcc_wait_compl(struct beiscsi_hba *phba)
 }
 
 /*
- * be_mcc_notify_wait()- Notify and wait for Compl
- * @phba: driver private structure
- *
- * Notify MCC requests and wait for completion
- *
- * return
- * Success: 0
- * Failure: Non-Zero
- **/
-int be_mcc_notify_wait(struct beiscsi_hba *phba, unsigned int tag)
-{
-	be_mcc_notify(phba, tag);
-	return be_mcc_wait_compl(phba);
-}
-
-/*
  * be_mbox_db_ready_wait()- Check ready status
  * @ctrl: Function specific MBX data structure
  *
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index adafd9c..f50b32ac 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -741,13 +741,14 @@ int be_cmd_fw_uninit(struct be_ctrl_info *ctrl);
 
 struct be_mcc_wrb *wrb_from_mbox(struct be_dma_mem *mbox_mem);
 struct be_mcc_wrb *wrb_from_mccq(struct beiscsi_hba *phba);
-int be_mcc_notify_wait(struct beiscsi_hba *phba, unsigned int tag);
+int be_mcc_compl_poll(struct beiscsi_hba *phba, unsigned int tag);
 void be_mcc_notify(struct beiscsi_hba *phba, unsigned int tag);
 unsigned int alloc_mcc_tag(struct beiscsi_hba *phba);
 void beiscsi_process_async_event(struct beiscsi_hba *phba,
 				struct be_mcc_compl *compl);
-int be_mcc_compl_process_isr(struct be_ctrl_info *ctrl,
-				    struct be_mcc_compl *compl);
+int beiscsi_process_mcc_compl(struct be_ctrl_info *ctrl,
+			      struct be_mcc_compl *compl);
+
 
 int be_mbox_notify(struct be_ctrl_info *ctrl);
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index aaf39d4..8b9d01a 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2028,7 +2028,7 @@ static void hwi_process_default_pdu_ring(struct beiscsi_conn *beiscsi_conn,
 			       phwi_ctrlr, cri_index));
 }
 
-static void  beiscsi_process_mcc_isr(struct beiscsi_hba *phba)
+void beiscsi_process_mcc_cq(struct beiscsi_hba *phba)
 {
 	struct be_queue_info *mcc_cq;
 	struct  be_mcc_compl *mcc_compl;
@@ -2038,7 +2038,6 @@ static void  beiscsi_process_mcc_isr(struct beiscsi_hba *phba)
 	mcc_compl = queue_tail_node(mcc_cq);
 	mcc_compl->flags = le32_to_cpu(mcc_compl->flags);
 	while (mcc_compl->flags & CQE_FLAGS_VALID_MASK) {
-
 		if (num_processed >= 32) {
 			hwi_ring_cq_db(phba, mcc_cq->id,
 					num_processed, 0);
@@ -2047,7 +2046,7 @@ static void  beiscsi_process_mcc_isr(struct beiscsi_hba *phba)
 		if (mcc_compl->flags & CQE_FLAGS_ASYNC_MASK) {
 			beiscsi_process_async_event(phba, mcc_compl);
 		} else if (mcc_compl->flags & CQE_FLAGS_COMPLETED_MASK) {
-			be_mcc_compl_process_isr(&phba->ctrl, mcc_compl);
+			beiscsi_process_mcc_compl(&phba->ctrl, mcc_compl);
 			atomic_dec(&phba->ctrl.mcc_obj.q.used);
 		}
 
@@ -2060,7 +2059,6 @@ static void  beiscsi_process_mcc_isr(struct beiscsi_hba *phba)
 
 	if (num_processed > 0)
 		hwi_ring_cq_db(phba, mcc_cq->id, num_processed, 1);
-
 }
 
 /**
@@ -2269,7 +2267,7 @@ void beiscsi_process_all_cqs(struct work_struct *work)
 		spin_lock_irqsave(&phba->isr_lock, flags);
 		pbe_eq->todo_mcc_cq = false;
 		spin_unlock_irqrestore(&phba->isr_lock, flags);
-		beiscsi_process_mcc_isr(phba);
+		beiscsi_process_mcc_cq(phba);
 	}
 
 	if (pbe_eq->todo_cq) {
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 16a6fd0..5ded3fa 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -853,6 +853,7 @@ void hwi_ring_cq_db(struct beiscsi_hba *phba,
 		     unsigned char rearm);
 
 unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget);
+void beiscsi_process_mcc_cq(struct beiscsi_hba *phba);
 
 static inline bool beiscsi_error(struct beiscsi_hba *phba)
 {
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index da040e7..a88e636 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -678,7 +678,8 @@ int mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short ulp_num)
 	req->hdr_ring_id = cpu_to_le16(HWI_GET_DEF_HDRQ_ID(phba, ulp_num));
 	req->data_ring_id = cpu_to_le16(HWI_GET_DEF_BUFQ_ID(phba, ulp_num));
 
-	status = be_mcc_notify_wait(phba, tag);
+	be_mcc_notify(phba, tag);
+	status = be_mcc_compl_poll(phba, tag);
 	if (status)
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
 			    "BG_%d : mgmt_epfw_cleanup , FAILED\n");
-- 
2.5.0

