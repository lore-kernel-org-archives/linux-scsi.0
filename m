From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH 4/5] scsi/ufs: qcom: Set phy mode based on the controllers HS MODE
Date: Fri,  4 Aug 2017 12:18:51 +0530
Message-ID: <1501829332-5183-5-git-send-email-vivek.gautam@codeaurora.org>
References: <1501829332-5183-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501829332-5183-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kishon@ti.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, robh+dt@kernel.org
Cc: linux-arm-msm@vger.kernel.org, subhashj@codeaurora.org, bjorn.andersson@linaro.org, devicetree@vger.kernel.org, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Set the phy mode based on the UFS HS PA mode. This lets the
controller let phy know the mode in which the PHY Adapter is
running and set the phy rates accordingly.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index c87d770b519a..44c21d5818ee 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -273,6 +273,9 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
 	bool is_rate_B = (UFS_QCOM_LIMIT_HS_RATE == PA_HS_MODE_B)
 							? true : false;
 
+	if (is_rate_B)
+		phy_set_mode(phy, PHY_MODE_UFS_HS_B);
+
 	/* Assert PHY reset and apply PHY calibration values */
 	ufs_qcom_assert_reset(hba);
 	/* provide 1ms delay to let the reset pulse propagate */
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
