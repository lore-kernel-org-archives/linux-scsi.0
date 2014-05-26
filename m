From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [RESEND PATCH V7 2/6] scsi: ufs: make undeclared functions static
Date: Mon, 26 May 2014 10:59:11 +0530
Message-ID: <1401082155-23184-3-git-send-email-sthumma@codeaurora.org>
References: <1401082155-23184-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1401082155-23184-1-git-send-email-sthumma@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: vinholikatti@gmail.com, santoshsy@gmail.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Make undeclared functions static and declare exported symbols
to suppress warnings from sparse tool.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Acked-by: Vinayak Holikatti <vinholikatti@gmail.com>
---
 drivers/scsi/ufs/ufshcd.c | 4 ++--
 drivers/scsi/ufs/ufshcd.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 064c9d9..d476cc3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1148,7 +1148,7 @@ out_unlock:
  *
  * Returns 0 for success, non-zero in case of failure
 */
-int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
+static int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 			enum attr_idn idn, u8 index, u8 selector, u32 *attr_val)
 {
 	struct ufs_query_req *request;
@@ -1459,7 +1459,7 @@ EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
  *
  * Returns 0 on success, non-zero value on failure
  */
-int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
+static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
 {
 	struct uic_command uic_cmd = {0};
 	struct completion pwr_done;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 577679a..767ee9e 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -263,6 +263,8 @@ static inline void check_upiu_size(void)
 		GENERAL_UPIU_REQUEST_SIZE + QUERY_DESC_MAX_SIZE);
 }
 
+extern int ufshcd_suspend(struct ufs_hba *hba, pm_message_t state);
+extern int ufshcd_resume(struct ufs_hba *hba);
 extern int ufshcd_runtime_suspend(struct ufs_hba *hba);
 extern int ufshcd_runtime_resume(struct ufs_hba *hba);
 extern int ufshcd_runtime_idle(struct ufs_hba *hba);
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
