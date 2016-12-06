From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 4/4] scsi: ufs-qcom: fix bug with read/modify write of UFS_CFG1
Date: Mon,  5 Dec 2016 19:25:42 -0800
Message-ID: <1480994742-19737-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

ufs_qcom_print_hw_debug_reg_all() function is having a bug
where it might incorrectly modify undesired bits in UFS_CFG1 register,
this change fixes it.

Reviewed-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 2943a68..abe6173 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1470,7 +1470,8 @@ static void ufs_qcom_print_hw_debug_reg_all(struct ufs_hba *hba,
 	reg = ufs_qcom_get_debug_reg_offset(host, UFS_UFS_DBG_RD_PRDT_RAM);
 	print_fn(hba, reg, 64, "UFS_UFS_DBG_RD_PRDT_RAM ", priv);
 
-	ufshcd_writel(hba, (reg & ~UFS_BIT(17)), REG_UFS_CFG1);
+	/* clear bit 17 - UTP_DBG_RAMS_EN */
+	ufshcd_rmwl(hba, UFS_BIT(17), 0, REG_UFS_CFG1);
 
 	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_UAWM);
 	print_fn(hba, reg, 4, "UFS_DBG_RD_REG_UAWM ", priv);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
