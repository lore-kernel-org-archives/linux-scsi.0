From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v1 05/12] be2iscsi: Remove be_mbox_notify_wait function
Date: Thu,  4 Feb 2016 15:49:13 +0530
Message-ID: <1454581160-31869-6-git-send-email-jitendra.bhivare@broadcom.com>
References: <1454581160-31869-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:62101 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757836AbcBDKhd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 05:37:33 -0500
In-Reply-To: <1454581160-31869-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

be_mbox_notify_wait does exactly same thing as be_mbox_notify.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/be2iscsi/be_cmds.c | 79 +++--------------------------------------
 1 file changed, 4 insertions(+), 75 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 1fe8eb8..12b60dd 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -625,8 +625,6 @@ int be_mbox_notify(struct be_ctrl_info *ctrl)
 	void __iomem *db = ctrl->db + MPU_MAILBOX_DB_OFFSET;
 	struct be_dma_mem *mbox_mem = &ctrl->mbox_mem;
 	struct be_mcc_mailbox *mbox = mbox_mem->va;
-	struct be_mcc_compl *compl = &mbox->compl;
-	struct beiscsi_hba *phba = pci_get_drvdata(ctrl->pdev);
 
 	status = be_mbox_db_ready_poll(ctrl);
 	if (status)
@@ -654,77 +652,8 @@ int be_mbox_notify(struct be_ctrl_info *ctrl)
 	/* RDY is set; small delay before CQE read. */
 	udelay(1);
 
-	if (be_mcc_compl_is_new(compl)) {
-		status = beiscsi_process_mbox_compl(ctrl, compl);
-		be_mcc_compl_use(compl);
-		if (status) {
-			beiscsi_log(phba, KERN_ERR,
-				    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-				    "BC_%d : After beiscsi_process_mbox_compl\n");
-
-			return status;
-		}
-	} else {
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BC_%d : Invalid Mailbox Completion\n");
-
-		return -EBUSY;
-	}
-	return 0;
-}
-
-/*
- * Insert the mailbox address into the doorbell in two steps
- * Polls on the mbox doorbell till a command completion (or a timeout) occurs
- */
-static int be_mbox_notify_wait(struct beiscsi_hba *phba)
-{
-	int status;
-	u32 val = 0;
-	void __iomem *db = phba->ctrl.db + MPU_MAILBOX_DB_OFFSET;
-	struct be_dma_mem *mbox_mem = &phba->ctrl.mbox_mem;
-	struct be_mcc_mailbox *mbox = mbox_mem->va;
-	struct be_mcc_compl *compl = &mbox->compl;
-	struct be_ctrl_info *ctrl = &phba->ctrl;
-
-	status = be_mbox_db_ready_poll(ctrl);
-	if (status)
-		return status;
-
-	val |= MPU_MAILBOX_DB_HI_MASK;
-	/* at bits 2 - 31 place mbox dma addr msb bits 34 - 63 */
-	val |= (upper_32_bits(mbox_mem->dma) >> 2) << 2;
-	iowrite32(val, db);
-
-	/* wait for ready to be set */
-	status = be_mbox_db_ready_poll(ctrl);
-	if (status != 0)
-		return status;
-
-	val = 0;
-	/* at bits 2 - 31 place mbox dma addr lsb bits 4 - 33 */
-	val |= (u32)(mbox_mem->dma >> 4) << 2;
-	iowrite32(val, db);
-
-	status = be_mbox_db_ready_poll(ctrl);
-	if (status != 0)
-		return status;
-
-	/* A cq entry has been made now */
-	if (be_mcc_compl_is_new(compl)) {
-		status = beiscsi_process_mbox_compl(ctrl, &mbox->compl);
-		be_mcc_compl_use(compl);
-		if (status)
-			return status;
-	} else {
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BC_%d : invalid mailbox completion\n");
-
-		return -EBUSY;
-	}
-	return 0;
+	status = beiscsi_process_mbox_compl(ctrl, &mbox->compl);
+	return status;
 }
 
 void be_wrb_hdr_prepare(struct be_mcc_wrb *wrb, int payload_len,
@@ -1039,7 +968,7 @@ int beiscsi_cmd_mccq_create(struct beiscsi_hba *phba,
 
 	be_cmd_page_addrs_prepare(req->pages, ARRAY_SIZE(req->pages), q_mem);
 
-	status = be_mbox_notify_wait(phba);
+	status = be_mbox_notify(ctrl);
 	if (!status) {
 		struct be_cmd_resp_mcc_create *resp = embedded_payload(wrb);
 		mccq->id = le16_to_cpu(resp->id);
@@ -1381,7 +1310,7 @@ int beiscsi_cmd_reset_function(struct beiscsi_hba  *phba)
 	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
 	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
 			   OPCODE_COMMON_FUNCTION_RESET, sizeof(*req));
-	status = be_mbox_notify_wait(phba);
+	status = be_mbox_notify(ctrl);
 
 	mutex_unlock(&ctrl->mbox_lock);
 	return status;
-- 
2.5.0

