From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v2 4/5] scsi/ufs: qcom: Set phy mode based on the controllers HS MODE
Date: Thu, 12 Oct 2017 11:49:35 +0530
Message-ID: <1507789176-2760-5-git-send-email-vivek.gautam@codeaurora.org>
References: <1507789176-2760-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507789176-2760-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kishon@ti.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: subhashj@codeaurora.org, robh+dt@kernel.org, bjorn.andersson@linaro.org, devicetree@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Set the phy mode based on the UFS HS PA mode. This lets the
controller let phy know the mode in which the PHY Adapter is
running and set the phy rates accordingly.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
---

Changes since v1:
 - none.

 drivers/scsi/ufs/ufs-qcom.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 6a548e74d704..942e40c9eaf7 100644
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
