From: Can Guo <quic_cang@quicinc.com>
Subject: [PATCH v9 5/7] scsi: ufs: Power on phy after it is initialized
Date: Thu, 20 Sep 2018 21:27:58 -0700
Message-ID: <1537504081-29976-6-git-send-email-quic_cang@quicinc.com>
References: <1537504081-29976-1-git-send-email-quic_cang@quicinc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537504081-29976-1-git-send-email-quic_cang@quicinc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, asutoshd@codeaurora.org, vivek.gautam@codeaurora.org, evgreen@chromium.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Can Guo <cang@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

Before UFS PHY is initialized, powering on it has no effect but increases
the PHY's power on count. Then when power on PHY to enable it after phy
initialization where it is really needed, as PHY's power on count is not
zero, again it would do nothing but directly return and leaves the PHY
disabled. This change adds condition checks to phy power on calls which
happen before phy initialization.

Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Evan Green <evgreen@chromium.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 4 +++-
 drivers/scsi/ufs/ufs-qcom.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 698b92d..fa20de4 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -288,6 +288,7 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
 			__func__, ret);
 		goto out;
 	}
+	host->is_phy_init = true;
 
 	/* De-assert PHY reset and start serdes */
 	ufs_qcom_deassert_reset(hba);
@@ -1176,7 +1177,8 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
 		return 0;
 
 	if (on && (status == POST_CHANGE)) {
-		phy_power_on(host->generic_phy);
+		if (host->is_phy_init)
+			phy_power_on(host->generic_phy);
 
 		/* enable the device ref clock for HS mode*/
 		if (ufshcd_is_hs_mode(&hba->pwr_info))
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index 295f4be..5747aa3 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -242,6 +242,7 @@ struct ufs_qcom_host {
 	/* Bitmask for enabling debug prints */
 	u32 dbg_print_en;
 	struct ufs_qcom_testbus testbus;
+	bool is_phy_init;
 };
 
 static inline u32
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
