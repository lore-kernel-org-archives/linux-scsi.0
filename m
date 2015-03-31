From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 1/2] scsi: ufs-qcom: save controller revision info in internal structure
Date: Tue, 31 Mar 2015 17:37:13 +0300
Message-ID: <1427812635-16617-2-git-send-email-ygardi@codeaurora.org>
References: <1427812635-16617-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427812635-16617-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

Sometimes, specific information about the UFS controller revision is
required in order to determine certain operations or execute
controller dependent quirks.
In order to avoid reading the controller revision multiple times,
we simply read it once and save this information in internal structure.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufs-qcom.c | 14 +++++++-------
 drivers/scsi/ufs/ufs-qcom.h |  8 ++++++++
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 9217af9..d7cb843 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -214,8 +214,6 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
 	struct ufs_qcom_host *host = hba->priv;
 	struct phy *phy = host->generic_phy;
 	int ret = 0;
-	u8 major;
-	u16 minor, step;
 	bool is_rate_B = (UFS_QCOM_LIMIT_HS_RATE == PA_HS_MODE_B)
 							? true : false;
 
@@ -224,8 +222,6 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
 	/* provide 1ms delay to let the reset pulse propagate */
 	usleep_range(1000, 1100);
 
-	ufs_qcom_get_controller_revision(hba, &major, &minor, &step);
-	ufs_qcom_phy_save_controller_version(phy, major, minor, step);
 	ret = ufs_qcom_phy_calibrate_phy(phy, is_rate_B);
 	if (ret) {
 		dev_err(hba->dev, "%s: ufs_qcom_phy_calibrate_phy() failed, ret = %d\n",
@@ -698,10 +694,7 @@ out:
  */
 static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 {
-	u8 major;
-	u16 minor, step;
 
-	ufs_qcom_get_controller_revision(hba, &major, &minor, &step);
 
 	/*
 	 * TBD
@@ -929,6 +922,13 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 	if (err)
 		goto out_host_free;
 
+	ufs_qcom_get_controller_revision(hba, &host->hw_ver.major,
+		&host->hw_ver.minor, &host->hw_ver.step);
+
+	/* update phy revision information before calling phy_init() */
+	ufs_qcom_phy_save_controller_version(host->generic_phy,
+		host->hw_ver.major, host->hw_ver.minor, host->hw_ver.step);
+
 	phy_init(host->generic_phy);
 	err = phy_power_on(host->generic_phy);
 	if (err)
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index 9a6febd..9037396 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -151,6 +151,12 @@ struct ufs_qcom_bus_vote {
 	struct device_attribute max_bus_bw;
 };
 
+/* Host controller hardware version: major.minor.step */
+struct ufs_hw_version {
+	u16 step;
+	u16 minor;
+	u8 major;
+};
 struct ufs_qcom_host {
 	struct phy *generic_phy;
 	struct ufs_hba *hba;
@@ -161,6 +167,8 @@ struct ufs_qcom_host {
 	struct clk *rx_l1_sync_clk;
 	struct clk *tx_l1_sync_clk;
 	bool is_lane_clks_enabled;
+
+	struct ufs_hw_version hw_ver;
 };
 
 #define ufs_qcom_is_link_off(hba) ufshcd_is_link_off(hba)
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
