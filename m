From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V1 2/4] scsi: ufs: device query status and size check
Date: Tue, 27 May 2014 10:21:50 +0300
Message-ID: <1401175312-17753-3-git-send-email-draviv@codeaurora.org>
References: <1401175312-17753-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:38847 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaE0HXC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 03:23:02 -0400
In-Reply-To: <1401175312-17753-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, sthumma@codeaurora.org, linux-arm-msm@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>

Check query response status before copying the response.
Add descriptor query response size check, before copying it to buffer.

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Raviv Shvili <rshvili@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 49 +++++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ed533f4..f3768ec 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -446,30 +446,34 @@ static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
  * @lrb - pointer to local reference block
  */
 static
-void ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+int ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
 	struct ufs_query_res *query_res = &hba->dev_cmd.query.response;
 
-	/* Get the UPIU response */
-	query_res->response = ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr) >>
-			UPIU_RSP_CODE_OFFSET;
-
 	memcpy(&query_res->upiu_res, &lrbp->ucd_rsp_ptr->qr, QUERY_OSF_SIZE);
 
-
 	/* Get the descriptor */
 	if (lrbp->ucd_rsp_ptr->qr.opcode == UPIU_QUERY_OPCODE_READ_DESC) {
 		u8 *descp = (u8 *)lrbp->ucd_rsp_ptr +
 				GENERAL_UPIU_REQUEST_SIZE;
-		u16 len;
+		u16 resp_len;
+		u16 buf_len;
 
 		/* data segment length */
-		len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2) &
+		resp_len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2) &
 						MASK_QUERY_DATA_SEG_LEN;
-
-		memcpy(hba->dev_cmd.query.descriptor, descp,
-				min_t(u16, len, QUERY_DESC_MAX_SIZE));
+		buf_len = hba->dev_cmd.query.request.upiu_req.length;
+		if (likely(buf_len >= resp_len)) {
+			memcpy(hba->dev_cmd.query.descriptor, descp, resp_len);
+		} else {
+			dev_warn(hba->dev,
+				"%s: Response size is bigger than buffer",
+				__func__);
+			return -EINVAL;
+		}
 	}
+
+	return 0;
 }
 
 /**
@@ -797,11 +801,9 @@ static void ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
 			QUERY_OSF_SIZE);
 
 	/* Copy the Descriptor */
-	if ((len > 0) && (query->request.upiu_req.opcode ==
-					UPIU_QUERY_OPCODE_WRITE_DESC)) {
-		memcpy(descp, query->descriptor,
-				min_t(u16, len, QUERY_DESC_MAX_SIZE));
-	}
+	if (query->request.upiu_req.opcode == UPIU_QUERY_OPCODE_WRITE_DESC)
+		memcpy(descp, query->descriptor, len);
+
 }
 
 static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
@@ -980,6 +982,17 @@ ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
 	return err;
 }
 
+static int
+ufshcd_check_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	struct ufs_query_res *query_res = &hba->dev_cmd.query.response;
+
+	/* Get the UPIU response */
+	query_res->response = ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr) >>
+				UPIU_RSP_CODE_OFFSET;
+	return query_res->response;
+}
+
 /**
  * ufshcd_dev_cmd_completion() - handles device management command responses
  * @hba: per adapter instance
@@ -1002,7 +1015,9 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		}
 		break;
 	case UPIU_TRANSACTION_QUERY_RSP:
-		ufshcd_copy_query_response(hba, lrbp);
+		err = ufshcd_check_query_response(hba, lrbp);
+		if (!err)
+			err = ufshcd_copy_query_response(hba, lrbp);
 		break;
 	case UPIU_TRANSACTION_REJECT_UPIU:
 		/* TODO: handle Reject UPIU Response */
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

