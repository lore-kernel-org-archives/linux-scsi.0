From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v5 01/15] scsi: ufs: clear UTRD, UPIU req and rsp before new transfers
Date: Tue, 27 Oct 2015 12:44:03 +0200
Message-ID: <1445942657-6293-2-git-send-email-ygardi@codeaurora.org>
References: <1445942657-6293-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445942657-6293-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Maya Erez <merez@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Clear the UFS data structures before sending new request.

The SCSI command is sent to the device within the UFS UPIU request.
As part of the transfer UPIU preparation, the SCSI command is copied
to the UPIU structure according to the SCSI command size.
As different SCSI commands differ in size from each other, we need
to clear the whole SCSI command field to prevent sending uninitialized
data to the device.

The UPIU response doesn't always include the sense data and can differ
in size.
Hence, the UPIU response should also be cleared before the transfer.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 131c720..3428f72 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3,7 +3,7 @@
  *
  * This code is based on drivers/scsi/ufs/ufshcd.c
  * Copyright (C) 2011-2013 Samsung India Software Operations
- * Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
  *
  * Authors:
  *	Santosh Yaraganavi <santosh.sy@samsung.com>
@@ -1035,6 +1035,7 @@ static int ufshcd_map_sg(struct ufshcd_lrb *lrbp)
 				cpu_to_le32(lower_32_bits(sg->dma_address));
 			prd_table[i].upper_addr =
 				cpu_to_le32(upper_32_bits(sg->dma_address));
+			prd_table[i].reserved = 0;
 		}
 	} else {
 		lrbp->utr_descriptor_ptr->prd_table_length = 0;
@@ -1117,7 +1118,8 @@ static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
 
 	/* Transfer request descriptor header fields */
 	req_desc->header.dword_0 = cpu_to_le32(dword_0);
-
+	/* dword_1 is reserved, hence it is set to 0 */
+	req_desc->header.dword_1 = 0;
 	/*
 	 * assigning invalid value for command status. Controller
 	 * updates OCS on command completion, with the command
@@ -1125,6 +1127,8 @@ static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
 	 */
 	req_desc->header.dword_2 =
 		cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
+	/* dword_3 is reserved, hence it is set to 0 */
+	req_desc->header.dword_3 = 0;
 }
 
 /**
@@ -1137,6 +1141,7 @@ static
 void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u32 upiu_flags)
 {
 	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
+	unsigned short cdb_len;
 
 	/* command descriptor fields */
 	ucd_req_ptr->header.dword_0 = UPIU_HEADER_DWORD(
@@ -1151,8 +1156,12 @@ void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u32 upiu_flags)
 	ucd_req_ptr->sc.exp_data_transfer_len =
 		cpu_to_be32(lrbp->cmd->sdb.length);
 
-	memcpy(ucd_req_ptr->sc.cdb, lrbp->cmd->cmnd,
-		(min_t(unsigned short, lrbp->cmd->cmd_len, MAX_CDB_SIZE)));
+	cdb_len = min_t(unsigned short, lrbp->cmd->cmd_len, MAX_CDB_SIZE);
+	memcpy(ucd_req_ptr->sc.cdb, lrbp->cmd->cmnd, cdb_len);
+	if (cdb_len < MAX_CDB_SIZE)
+		memset(ucd_req_ptr->sc.cdb + cdb_len, 0,
+		       (MAX_CDB_SIZE - cdb_len));
+	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
 }
 
 /**
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
