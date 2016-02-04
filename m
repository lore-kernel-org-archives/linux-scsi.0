From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v1 02/12] be2iscsi: Use macros for MCC WRB and CQE fields
Date: Thu,  4 Feb 2016 15:49:10 +0530
Message-ID: <1454581160-31869-3-git-send-email-jitendra.bhivare@broadcom.com>
References: <1454581160-31869-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:62101 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757742AbcBDKhV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 05:37:21 -0500
In-Reply-To: <1454581160-31869-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Rename mcc_numtag to mcc_tag_status.
MCC CQE status is processed using macros already defined in be_cmds.h.

Add MCC_Q_WRB_ and MCC_Q_CMD_TAG_MASK macros to map to already defined
CQE_STATUS_ macros to be consistent when posting MCC.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/be2iscsi/be.h      |  8 +++++++-
 drivers/scsi/be2iscsi/be_cmds.c | 40 +++++++++++++++++++++-------------------
 drivers/scsi/be2iscsi/be_cmds.h | 13 +++++++------
 drivers/scsi/be2iscsi/be_main.c | 11 ++++++-----
 4 files changed, 41 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index 1524fe4..da1d87a 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -135,7 +135,7 @@ struct be_ctrl_info {
 
 	wait_queue_head_t mcc_wait[MAX_MCC_CMD + 1];
 	unsigned int mcc_tag[MAX_MCC_CMD];
-	unsigned int mcc_numtag[MAX_MCC_CMD + 1];
+	unsigned int mcc_tag_status[MAX_MCC_CMD + 1];
 	unsigned short mcc_alloc_index;
 	unsigned short mcc_free_index;
 	unsigned int mcc_tag_available;
@@ -145,6 +145,12 @@ struct be_ctrl_info {
 
 #include "be_cmds.h"
 
+/* WRB index mask for MCC_Q_LEN queue entries */
+#define MCC_Q_WRB_IDX_MASK	CQE_STATUS_WRB_MASK
+#define MCC_Q_WRB_IDX_SHIFT	CQE_STATUS_WRB_SHIFT
+/* TAG is from 1...MAX_MCC_CMD, MASK includes MAX_MCC_CMD */
+#define MCC_Q_CMD_TAG_MASK	((MAX_MCC_CMD << 1) - 1)
+
 #define PAGE_SHIFT_4K 12
 #define PAGE_SIZE_4K (1 << PAGE_SHIFT_4K)
 #define mcc_timeout		120000 /* 12s timeout */
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index e8e9d22..c5e7739 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -125,7 +125,7 @@ unsigned int alloc_mcc_tag(struct beiscsi_hba *phba)
 	if (phba->ctrl.mcc_tag_available) {
 		tag = phba->ctrl.mcc_tag[phba->ctrl.mcc_alloc_index];
 		phba->ctrl.mcc_tag[phba->ctrl.mcc_alloc_index] = 0;
-		phba->ctrl.mcc_numtag[tag] = 0;
+		phba->ctrl.mcc_tag_status[tag] = 0;
 		phba->ctrl.ptag_state[tag].tag_state = 0;
 	}
 	if (tag) {
@@ -157,7 +157,7 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
 		struct be_dma_mem *mbx_cmd_mem)
 {
 	int rc = 0;
-	uint32_t mcc_tag_response;
+	uint32_t mcc_tag_status;
 	uint16_t status = 0, addl_status = 0, wrb_num = 0;
 	struct be_mcc_wrb *temp_wrb;
 	struct be_cmd_req_hdr *mbx_hdr;
@@ -172,7 +172,7 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
 	/* wait for the mccq completion */
 	rc = wait_event_interruptible_timeout(
 				phba->ctrl.mcc_wait[tag],
-				phba->ctrl.mcc_numtag[tag],
+				phba->ctrl.mcc_tag_status[tag],
 				msecs_to_jiffies(
 				BEISCSI_HOST_MBX_TIMEOUT));
 	/**
@@ -209,15 +209,15 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
 	}
 
 	rc = 0;
-	mcc_tag_response = phba->ctrl.mcc_numtag[tag];
-	status = (mcc_tag_response & CQE_STATUS_MASK);
-	addl_status = ((mcc_tag_response & CQE_STATUS_ADDL_MASK) >>
+	mcc_tag_status = phba->ctrl.mcc_tag_status[tag];
+	status = (mcc_tag_status & CQE_STATUS_MASK);
+	addl_status = ((mcc_tag_status & CQE_STATUS_ADDL_MASK) >>
 			CQE_STATUS_ADDL_SHIFT);
 
 	if (mbx_cmd_mem) {
 		mbx_hdr = (struct be_cmd_req_hdr *)mbx_cmd_mem->va;
 	} else {
-		wrb_num = (mcc_tag_response & CQE_STATUS_WRB_MASK) >>
+		wrb_num = (mcc_tag_status & CQE_STATUS_WRB_MASK) >>
 			   CQE_STATUS_WRB_SHIFT;
 		temp_wrb = (struct be_mcc_wrb *)queue_get_wrb(mccq, wrb_num);
 		mbx_hdr = embedded_payload(temp_wrb);
@@ -257,7 +257,7 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
 void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag)
 {
 	spin_lock(&ctrl->mcc_lock);
-	tag = tag & 0x000000FF;
+	tag = tag & MCC_Q_CMD_TAG_MASK;
 	ctrl->mcc_tag[ctrl->mcc_free_index] = tag;
 	if (ctrl->mcc_free_index == (MAX_MCC_CMD - 1))
 		ctrl->mcc_free_index = 0;
@@ -334,10 +334,11 @@ int be_mcc_compl_process_isr(struct be_ctrl_info *ctrl,
 	struct beiscsi_hba *phba = pci_get_drvdata(ctrl->pdev);
 	u16 compl_status, extd_status;
 	struct be_dma_mem *tag_mem;
-	unsigned short tag;
+	unsigned int tag, wrb_idx;
 
 	be_dws_le_to_cpu(compl, 4);
-	tag = (compl->tag0 & 0x000000FF);
+	tag = (compl->tag0 & MCC_Q_CMD_TAG_MASK);
+	wrb_idx = (compl->tag0 & CQE_STATUS_WRB_MASK) >> CQE_STATUS_WRB_SHIFT;
 
 	if (!test_bit(MCC_TAG_STATE_RUNNING,
 		      &ctrl->ptag_state[tag].tag_state)) {
@@ -366,17 +367,18 @@ int be_mcc_compl_process_isr(struct be_ctrl_info *ctrl,
 	}
 
 	compl_status = (compl->status >> CQE_STATUS_COMPL_SHIFT) &
-					CQE_STATUS_COMPL_MASK;
-	/* The ctrl.mcc_numtag[tag] is filled with
+		       CQE_STATUS_COMPL_MASK;
+	extd_status = (compl->status >> CQE_STATUS_EXTD_SHIFT) &
+		      CQE_STATUS_EXTD_MASK;
+	/* The ctrl.mcc_tag_status[tag] is filled with
 	 * [31] = valid, [30:24] = Rsvd, [23:16] = wrb, [15:8] = extd_status,
 	 * [7:0] = compl_status
 	 */
-	extd_status = (compl->status >> CQE_STATUS_EXTD_SHIFT) &
-					CQE_STATUS_EXTD_MASK;
-	ctrl->mcc_numtag[tag]  = 0x80000000;
-	ctrl->mcc_numtag[tag] |= (compl->tag0 & 0x00FF0000);
-	ctrl->mcc_numtag[tag] |= (extd_status & 0x000000FF) << 8;
-	ctrl->mcc_numtag[tag] |= (compl_status & 0x000000FF);
+	ctrl->mcc_tag_status[tag] = CQE_VALID_MASK;
+	ctrl->mcc_tag_status[tag] |= (wrb_idx << CQE_STATUS_WRB_SHIFT);
+	ctrl->mcc_tag_status[tag] |= (extd_status << CQE_STATUS_ADDL_SHIFT) &
+				     CQE_STATUS_ADDL_MASK;
+	ctrl->mcc_tag_status[tag] |= (compl_status & CQE_STATUS_MASK);
 
 	/* write ordering implied in wake_up_interruptible */
 	clear_bit(MCC_TAG_STATE_RUNNING, &ctrl->ptag_state[tag].tag_state);
@@ -844,7 +846,7 @@ struct be_mcc_wrb *wrb_from_mccq(struct beiscsi_hba *phba)
 	WARN_ON(atomic_read(&mccq->used) >= mccq->len);
 	wrb = queue_head_node(mccq);
 	memset(wrb, 0, sizeof(*wrb));
-	wrb->tag0 = (mccq->head & 0x000000FF) << 16;
+	wrb->tag0 = (mccq->head << MCC_Q_WRB_IDX_SHIFT) & MCC_Q_WRB_IDX_MASK;
 	queue_head_inc(mccq);
 	atomic_inc(&mccq->used);
 	return wrb;
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 7caf585..adafd9c 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -58,15 +58,16 @@ struct be_mcc_wrb {
 #define MCC_STATUS_ILLEGAL_FIELD 0x3
 #define MCC_STATUS_INSUFFICIENT_BUFFER 0x4
 
-#define CQE_STATUS_COMPL_MASK 0xFFFF
-#define CQE_STATUS_COMPL_SHIFT 0	/* bits 0 - 15 */
-#define CQE_STATUS_EXTD_MASK 0xFFFF
-#define CQE_STATUS_EXTD_SHIFT 16		/* bits 0 - 15 */
+#define CQE_STATUS_COMPL_MASK	0xFFFF
+#define CQE_STATUS_COMPL_SHIFT	0		/* bits 0 - 15 */
+#define CQE_STATUS_EXTD_MASK	0xFFFF
+#define CQE_STATUS_EXTD_SHIFT	16		/* bits 31 - 16 */
 #define CQE_STATUS_ADDL_MASK	0xFF00
-#define CQE_STATUS_MASK	0xFF
-#define CQE_STATUS_ADDL_SHIFT	0x08
+#define CQE_STATUS_ADDL_SHIFT	8
+#define CQE_STATUS_MASK		0xFF
 #define CQE_STATUS_WRB_MASK	0xFF0000
 #define CQE_STATUS_WRB_SHIFT	16
+
 #define BEISCSI_HOST_MBX_TIMEOUT (110 * 1000)
 #define BEISCSI_FW_MBX_TIMEOUT	100
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 314fd2c..aaf39d4 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5241,11 +5241,12 @@ static int beiscsi_bsg_request(struct bsg_job *job)
 
 		rc = wait_event_interruptible_timeout(
 					phba->ctrl.mcc_wait[tag],
-					phba->ctrl.mcc_numtag[tag],
+					phba->ctrl.mcc_tag_status[tag],
 					msecs_to_jiffies(
 					BEISCSI_HOST_MBX_TIMEOUT));
-		extd_status = (phba->ctrl.mcc_numtag[tag] & 0x0000FF00) >> 8;
-		status = phba->ctrl.mcc_numtag[tag] & 0x000000FF;
+		extd_status = (phba->ctrl.mcc_tag_status[tag] &
+			       CQE_STATUS_ADDL_MASK) >> CQE_STATUS_ADDL_SHIFT;
+		status = phba->ctrl.mcc_tag_status[tag] & CQE_STATUS_MASK;
 		free_mcc_tag(&phba->ctrl, tag);
 		resp = (struct be_cmd_resp_hdr *)nonemb_cmd.va;
 		sg_copy_from_buffer(job->reply_payload.sg_list,
@@ -5580,7 +5581,7 @@ static void beiscsi_eeh_resume(struct pci_dev *pdev)
 	for (i = 0; i < MAX_MCC_CMD; i++) {
 		init_waitqueue_head(&phba->ctrl.mcc_wait[i + 1]);
 		phba->ctrl.mcc_tag[i] = i + 1;
-		phba->ctrl.mcc_numtag[i + 1] = 0;
+		phba->ctrl.mcc_tag_status[i + 1] = 0;
 		phba->ctrl.mcc_tag_available++;
 	}
 
@@ -5739,7 +5740,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	for (i = 0; i < MAX_MCC_CMD; i++) {
 		init_waitqueue_head(&phba->ctrl.mcc_wait[i + 1]);
 		phba->ctrl.mcc_tag[i] = i + 1;
-		phba->ctrl.mcc_numtag[i + 1] = 0;
+		phba->ctrl.mcc_tag_status[i + 1] = 0;
 		phba->ctrl.mcc_tag_available++;
 		memset(&phba->ctrl.ptag_state[i].tag_mem_state, 0,
 		       sizeof(struct be_dma_mem));
-- 
2.5.0

