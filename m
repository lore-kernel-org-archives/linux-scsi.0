From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v1 06/12] be2iscsi: Fix be_mcc_compl_poll to use tag_state
Date: Thu,  4 Feb 2016 15:49:14 +0530
Message-ID: <1454581160-31869-7-git-send-email-jitendra.bhivare@broadcom.com>
References: <1454581160-31869-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:62101 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757841AbcBDKhe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 05:37:34 -0500
In-Reply-To: <1454581160-31869-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

be_mcc_compl_poll waits till 'used' count of MCC WRBQ is zero. This is to
determine the completion of an MCC sent.

Change function to poll for the tag of MCC sent, instead, and wait till
its tag_state is cleared.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/be2iscsi/be_cmds.c | 92 +++++++++++++++++++++--------------------
 1 file changed, 47 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 12b60dd..60db2de 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -104,19 +104,6 @@ int be_chk_reset_complete(struct beiscsi_hba *phba)
 	return 0;
 }
 
-void be_mcc_notify(struct beiscsi_hba *phba, unsigned int tag)
-{
-	struct be_queue_info *mccq = &phba->ctrl.mcc_obj.q;
-	u32 val = 0;
-
-	set_bit(MCC_TAG_STATE_RUNNING, &phba->ctrl.ptag_state[tag].tag_state);
-	val |= mccq->id & DB_MCCQ_RING_ID_MASK;
-	val |= 1 << DB_MCCQ_NUM_POSTED_SHIFT;
-	/* ring doorbell after all of request and state is written */
-	wmb();
-	iowrite32(val, phba->db_va + DB_MCCQ_OFFSET);
-}
-
 unsigned int alloc_mcc_tag(struct beiscsi_hba *phba)
 {
 	unsigned int tag = 0;
@@ -139,6 +126,28 @@ unsigned int alloc_mcc_tag(struct beiscsi_hba *phba)
 	return tag;
 }
 
+void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag)
+{
+	spin_lock_bh(&ctrl->mcc_lock);
+	tag = tag & MCC_Q_CMD_TAG_MASK;
+	ctrl->mcc_tag[ctrl->mcc_free_index] = tag;
+	if (ctrl->mcc_free_index == (MAX_MCC_CMD - 1))
+		ctrl->mcc_free_index = 0;
+	else
+		ctrl->mcc_free_index++;
+	ctrl->mcc_tag_available++;
+	spin_unlock_bh(&ctrl->mcc_lock);
+}
+
+/**
+ * beiscsi_fail_session(): Closing session with appropriate error
+ * @cls_session: ptr to session
+ **/
+void beiscsi_fail_session(struct iscsi_cls_session *cls_session)
+{
+	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_CONN_FAILED);
+}
+
 /*
  * beiscsi_mccq_compl_wait()- Process completion in MCC CQ
  * @phba: Driver private structure
@@ -254,19 +263,6 @@ int beiscsi_mccq_compl_wait(struct beiscsi_hba *phba,
 	return rc;
 }
 
-void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag)
-{
-	spin_lock(&ctrl->mcc_lock);
-	tag = tag & MCC_Q_CMD_TAG_MASK;
-	ctrl->mcc_tag[ctrl->mcc_free_index] = tag;
-	if (ctrl->mcc_free_index == (MAX_MCC_CMD - 1))
-		ctrl->mcc_free_index = 0;
-	else
-		ctrl->mcc_free_index++;
-	ctrl->mcc_tag_available++;
-	spin_unlock(&ctrl->mcc_lock);
-}
-
 static inline bool be_mcc_compl_is_new(struct be_mcc_compl *compl)
 {
 	if (compl->flags != 0) {
@@ -328,15 +324,6 @@ static int beiscsi_process_mbox_compl(struct be_ctrl_info *ctrl,
 	return 0;
 }
 
-/**
- * beiscsi_fail_session(): Closing session with appropriate error
- * @cls_session: ptr to session
- **/
-void beiscsi_fail_session(struct iscsi_cls_session *cls_session)
-{
-	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_CONN_FAILED);
-}
-
 static void beiscsi_process_async_link(struct beiscsi_hba *phba,
 				       struct be_mcc_compl *compl)
 {
@@ -532,6 +519,7 @@ int beiscsi_process_mcc_compl(struct be_ctrl_info *ctrl,
  **/
 int be_mcc_compl_poll(struct beiscsi_hba *phba, unsigned int tag)
 {
+	struct be_ctrl_info *ctrl = &phba->ctrl;
 	int i;
 
 	for (i = 0; i < mcc_timeout; i++) {
@@ -540,19 +528,33 @@ int be_mcc_compl_poll(struct beiscsi_hba *phba, unsigned int tag)
 
 		beiscsi_process_mcc_cq(phba);
 
-		if (atomic_read(&phba->ctrl.mcc_obj.q.used) == 0)
+		if (!test_bit(MCC_TAG_STATE_RUNNING,
+			      &ctrl->ptag_state[tag].tag_state))
 			break;
 		udelay(100);
 	}
-	if (i == mcc_timeout) {
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BC_%d : FW Timed Out\n");
-		phba->fw_timeout = true;
-		beiscsi_ue_detect(phba);
-		return -EBUSY;
-	}
-	return 0;
+
+	if (i < mcc_timeout)
+		return 0;
+
+	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+		    "BC_%d : FW Timed Out\n");
+	phba->fw_timeout = true;
+	beiscsi_ue_detect(phba);
+	return -EBUSY;
+}
+
+void be_mcc_notify(struct beiscsi_hba *phba, unsigned int tag)
+{
+	struct be_queue_info *mccq = &phba->ctrl.mcc_obj.q;
+	u32 val = 0;
+
+	set_bit(MCC_TAG_STATE_RUNNING, &phba->ctrl.ptag_state[tag].tag_state);
+	val |= mccq->id & DB_MCCQ_RING_ID_MASK;
+	val |= 1 << DB_MCCQ_NUM_POSTED_SHIFT;
+	/* make request available for DMA */
+	wmb();
+	iowrite32(val, phba->db_va + DB_MCCQ_OFFSET);
 }
 
 /*
-- 
2.5.0

