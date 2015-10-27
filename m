From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v5 02/15] scsi: ufs: clear fields UTRD, UPIU req and rsp before new transfers
Date: Tue, 27 Oct 2015 12:44:04 +0200
Message-ID: <1445942657-6293-3-git-send-email-ygardi@codeaurora.org>
References: <1445942657-6293-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445942657-6293-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Some of the data structures (like response UPIU) and/or its elements
(unused fields) should be cleared before sending out the respective
command to UFS device.

This change clears the UPIU response data structure for query commands
and NOP command before sending out the command. We also initialize the
PRDT table length to zero which should take care of commands which doesn't
have any data associated with it. We are also clearing the unused fields in
request UPIU for NOP command.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3428f72..2d3ebca 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1129,6 +1129,8 @@ static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
 		cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
 	/* dword_3 is reserved, hence it is set to 0 */
 	req_desc->header.dword_3 = 0;
+
+	req_desc->prd_table_length = 0;
 }
 
 /**
@@ -1198,6 +1200,7 @@ static void ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
 	if (query->request.upiu_req.opcode == UPIU_QUERY_OPCODE_WRITE_DESC)
 		memcpy(descp, query->descriptor, len);
 
+	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
 }
 
 static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
@@ -1210,6 +1213,11 @@ static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
 	ucd_req_ptr->header.dword_0 =
 		UPIU_HEADER_DWORD(
 			UPIU_TRANSACTION_NOP_OUT, 0, 0, lrbp->task_tag);
+	/* clear rest of the fields of basic header */
+	ucd_req_ptr->header.dword_1 = 0;
+	ucd_req_ptr->header.dword_2 = 0;
+
+	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
 }
 
 /**
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
