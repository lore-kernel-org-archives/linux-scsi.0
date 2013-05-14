From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V2 3/9] scsi: ufs: Fix the response UPIU length setting
Date: Tue, 14 May 2013 10:08:42 +0300
Message-ID: <1368515328-31535-4-git-send-email-draviv@codeaurora.org>
References: <1368515328-31535-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368515328-31535-1-git-send-email-draviv@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, Maya Erez <merez@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The response UPIU length should be in DWORD and not in bytes.

Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Tested-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4ddc8be..7ce40a5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -807,7 +807,7 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 		utrdlp[i].prd_table_offset =
 				cpu_to_le16((prdt_offset >> 2));
 		utrdlp[i].response_upiu_length =
-				cpu_to_le16(ALIGNED_UPIU_SIZE);
+				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
 
 		hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
 		hba->lrb[i].ucd_req_ptr =
-- 
1.7.6

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
