From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH 07/12] be2iscsi: Cleanup processing of BMBX completion
Date: Mon,  1 Feb 2016 15:42:46 +0530
Message-ID: <1454321571-16167-8-git-send-email-jitendra.bhivare@avagotech.com>
References: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:54821 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753394AbcBAKN2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2016 05:13:28 -0500
In-Reply-To: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@avagotech.com>

Remove confusingly named be_mcc_compl_is_new and be_mcc_compl_use functions
in processing of BMBX. Rearrange beiscsi_process_mbox_compl function.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
---
 drivers/scsi/be2iscsi/be_cmds.c | 75 ++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 60db2de..728aa133 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -263,21 +263,6 @@ int beiscsi_mccq_compl_wait(struct beiscsi_hba *phba,
 	return rc;
 }
 
-static inline bool be_mcc_compl_is_new(struct be_mcc_compl *compl)
-{
-	if (compl->flags != 0) {
-		compl->flags = le32_to_cpu(compl->flags);
-		WARN_ON((compl->flags & CQE_FLAGS_VALID_MASK) == 0);
-		return true;
-	} else
-		return false;
-}
-
-static inline void be_mcc_compl_use(struct be_mcc_compl *compl)
-{
-	compl->flags = 0;
-}
-
 /*
  * beiscsi_process_mbox_compl()- Check the MBX completion status
  * @ctrl: Function specific MBX data structure
@@ -298,30 +283,46 @@ static int beiscsi_process_mbox_compl(struct be_ctrl_info *ctrl,
 	struct be_cmd_req_hdr *hdr = embedded_payload(wrb);
 	struct be_cmd_resp_hdr *resp_hdr;
 
-	be_dws_le_to_cpu(compl, 4);
+	/**
+	 * To check if valid bit is set, check the entire word as we don't know
+	 * the endianness of the data (old entry is host endian while a new
+	 * entry is little endian)
+	 */
+	if (!compl->flags) {
+		beiscsi_log(phba, KERN_ERR,
+				BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+				"BC_%d : BMBX busy, no completion\n");
+		return -EBUSY;
+	}
+	compl->flags = le32_to_cpu(compl->flags);
+	WARN_ON((compl->flags & CQE_FLAGS_VALID_MASK) == 0);
 
+	/**
+	 * Just swap the status to host endian;
+	 * mcc tag is opaquely copied from mcc_wrb.
+	 */
+	be_dws_le_to_cpu(compl, 4);
 	compl_status = (compl->status >> CQE_STATUS_COMPL_SHIFT) &
-					CQE_STATUS_COMPL_MASK;
-	if (compl_status != MCC_STATUS_SUCCESS) {
-		extd_status = (compl->status >> CQE_STATUS_EXTD_SHIFT) &
-						CQE_STATUS_EXTD_MASK;
+		CQE_STATUS_COMPL_MASK;
+	extd_status = (compl->status >> CQE_STATUS_EXTD_SHIFT) &
+		CQE_STATUS_EXTD_MASK;
+	/* Need to reset the entire word that houses the valid bit */
+	compl->flags = 0;
 
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BC_%d : error in cmd completion: "
-			    "Subsystem : %d Opcode : %d "
-			    "status(compl/extd)=%d/%d\n",
-			    hdr->subsystem, hdr->opcode,
-			    compl_status, extd_status);
-
-		if (compl_status == MCC_STATUS_INSUFFICIENT_BUFFER) {
-			resp_hdr = (struct be_cmd_resp_hdr *) hdr;
-			if (resp_hdr->response_length)
-				return 0;
-		}
-		return -EINVAL;
+	if (compl_status == MCC_STATUS_SUCCESS)
+		return 0;
+
+	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+		    "BC_%d : error in cmd completion: Subsystem : %d Opcode : %d status(compl/extd)=%d/%d\n",
+		    hdr->subsystem, hdr->opcode, compl_status, extd_status);
+
+	if (compl_status == MCC_STATUS_INSUFFICIENT_BUFFER) {
+		/* if status is insufficient buffer, check the length */
+		resp_hdr = (struct be_cmd_resp_hdr *) hdr;
+		if (resp_hdr->response_length)
+			return 0;
 	}
-	return 0;
+	return -EINVAL;
 }
 
 static void beiscsi_process_async_link(struct beiscsi_hba *phba,
@@ -453,10 +454,6 @@ int beiscsi_process_mcc_compl(struct be_ctrl_info *ctrl,
 	struct be_dma_mem *tag_mem;
 	unsigned int tag, wrb_idx;
 
-	/**
-	 * Just swap the status to host endian; mcc tag is opaquely copied
-	 * from mcc_wrb
-	 */
 	be_dws_le_to_cpu(compl, 4);
 	tag = (compl->tag0 & MCC_Q_CMD_TAG_MASK);
 	wrb_idx = (compl->tag0 & CQE_STATUS_WRB_MASK) >> CQE_STATUS_WRB_SHIFT;
-- 
2.5.0

