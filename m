From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v5 11/12] scsi/ufs: qcom: Add phy_exit call in hcd exit path
Date: Tue,  8 Nov 2016 15:37:50 +0530
Message-ID: <1478599671-13071-12-git-send-email-vivek.gautam@codeaurora.org>
References: <1478599671-13071-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1478599671-13071-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com
Cc: sboyd@codeaurora.org, subhashj@codeaurora.org, ygardi@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Do a phy_exit() over the ufs phy in the ufs qcom exit path
to de-initialize the phy.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 5f70a35..31df783 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1280,6 +1280,7 @@ static void ufs_qcom_exit(struct ufs_hba *hba)
 
 	ufs_qcom_disable_lane_clks(host);
 	phy_power_off(host->generic_phy);
+	phy_exit(host->generic_phy);
 }
 
 static int ufs_qcom_set_dme_vs_core_clk_ctrl_clear_div(struct ufs_hba *hba,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
