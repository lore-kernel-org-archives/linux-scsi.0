From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v9 4/8] scsi: ufs: add ufshcd_get_variant ufshcd_set_variant
Date: Wed, 28 Oct 2015 13:15:47 +0200
Message-ID: <1446030951-2431-5-git-send-email-ygardi@codeaurora.org>
References: <1446030951-2431-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446030951-2431-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

This patch adds ufshcd_get_variant() and ufshcd_set_variant()
routines in order to get/set the variant specific data.

Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufs-qcom.c | 34 +++++++++++++++++-----------------
 drivers/scsi/ufs/ufshcd.h   | 21 +++++++++++++++++++++
 2 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 6c23bbf..64c54b7 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -155,7 +155,7 @@ out:
 
 static int ufs_qcom_link_startup_post_change(struct ufs_hba *hba)
 {
-	struct ufs_qcom_host *host = hba->priv;
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	struct phy *phy = host->generic_phy;
 	u32 tx_lanes;
 	int err = 0;
@@ -211,7 +211,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 
 static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
 {
-	struct ufs_qcom_host *host = hba->priv;
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	struct phy *phy = host->generic_phy;
 	int ret = 0;
 	bool is_rate_B = (UFS_QCOM_LIMIT_HS_RATE == PA_HS_MODE_B)
@@ -273,7 +273,7 @@ static void ufs_qcom_enable_hw_clk_gating(struct ufs_hba *hba)
 
 static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba, bool status)
 {
-	struct ufs_qcom_host *host = hba->priv;
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	int err = 0;
 
 	switch (status) {
@@ -307,7 +307,7 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba, bool status)
 static unsigned long
 ufs_qcom_cfg_timers(struct ufs_hba *hba, u32 gear, u32 hs, u32 rate)
 {
-	struct ufs_qcom_host *host = hba->priv;
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	struct ufs_clk_info *clki;
 	u32 core_clk_period_in_ns;
 	u32 tx_clk_cycles_per_us = 0;
@@ -448,7 +448,7 @@ static int ufs_qcom_link_startup_notify(struct ufs_hba *hba, bool status)
 
 static int ufs_qcom_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
-	struct ufs_qcom_host *host = hba->priv;
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	struct phy *phy = host->generic_phy;
 	int ret = 0;
 
@@ -479,7 +479,7 @@ out:
 
 static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
-	struct ufs_qcom_host *host = hba->priv;
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	struct phy *phy = host->generic_phy;
 	int err;
 
@@ -621,7 +621,7 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 				struct ufs_pa_layer_attr *dev_req_params)
 {
 	u32 val;
-	struct ufs_qcom_host *host = hba->priv;
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	struct phy *phy = host->generic_phy;
 	struct ufs_qcom_dev_params ufs_qcom_cap;
 	int ret = 0;
@@ -696,7 +696,7 @@ out:
 
 static u32 ufs_qcom_get_ufs_hci_version(struct ufs_hba *hba)
 {
-	struct ufs_qcom_host *host = hba->priv;
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 
 	if (host->hw_ver.major == 0x1)
 		return UFSHCI_VERSION_11;
@@ -715,7 +715,7 @@ static u32 ufs_qcom_get_ufs_hci_version(struct ufs_hba *hba)
  */
 static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 {
-	struct ufs_qcom_host *host = hba->priv;
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 
 	if (host->hw_ver.major == 0x01) {
 		hba->quirks |= UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS
@@ -740,7 +740,7 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 
 static void ufs_qcom_set_caps(struct ufs_hba *hba)
 {
-	struct ufs_qcom_host *host = hba->priv;
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 
 	if (host->hw_ver.major >= 0x2)
 		host->caps = UFS_QCOM_CAP_QUNIPRO;
@@ -811,7 +811,7 @@ static void ufs_qcom_get_speed_mode(struct ufs_pa_layer_attr *p, char *result)
 
 static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on)
 {
-	struct ufs_qcom_host *host = hba->priv;
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	int err = 0;
 	int vote = 0;
 
@@ -866,7 +866,7 @@ show_ufs_to_mem_max_bus_bw(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
-	struct ufs_qcom_host *host = hba->priv;
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 
 	return snprintf(buf, PAGE_SIZE, "%u\n",
 			host->bus_vote.is_max_bw_needed);
@@ -877,7 +877,7 @@ store_ufs_to_mem_max_bus_bw(struct device *dev, struct device_attribute *attr,
 		const char *buf, size_t count)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
-	struct ufs_qcom_host *host = hba->priv;
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	uint32_t value;
 
 	if (!kstrtou32(buf, 0, &value)) {
@@ -954,7 +954,7 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 	}
 
 	host->hba = hba;
-	hba->priv = (void *)host;
+	ufshcd_set_variant(hba, host);
 
 	host->generic_phy = devm_phy_get(dev, "ufsphy");
 
@@ -1003,14 +1003,14 @@ out_unregister_bus:
 	phy_exit(host->generic_phy);
 out_host_free:
 	devm_kfree(dev, host);
-	hba->priv = NULL;
+	ufshcd_set_variant(hba, NULL);
 out:
 	return err;
 }
 
 static void ufs_qcom_exit(struct ufs_hba *hba)
 {
-	struct ufs_qcom_host *host = hba->priv;
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 
 	ufs_qcom_disable_lane_clks(host);
 	phy_power_off(host->generic_phy);
@@ -1019,7 +1019,7 @@ static void ufs_qcom_exit(struct ufs_hba *hba)
 static
 void ufs_qcom_clk_scale_notify(struct ufs_hba *hba)
 {
-	struct ufs_qcom_host *host = hba->priv;
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	struct ufs_pa_layer_attr *dev_req_params = &host->dev_req_params;
 
 	if (!dev_req_params)
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c40a0e7..54e7afb 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -594,6 +594,27 @@ static inline void check_upiu_size(void)
 		GENERAL_UPIU_REQUEST_SIZE + QUERY_DESC_MAX_SIZE);
 }
 
+/**
+ * ufshcd_set_variant - set variant specific data to the hba
+ * @hba - per adapter instance
+ * @variant - pointer to variant specific data
+ */
+static inline void ufshcd_set_variant(struct ufs_hba *hba, void *variant)
+{
+	BUG_ON(!hba);
+	hba->priv = variant;
+}
+
+/**
+ * ufshcd_get_variant - get variant specific data from the hba
+ * @hba - per adapter instance
+ */
+static inline void *ufshcd_get_variant(struct ufs_hba *hba)
+{
+	BUG_ON(!hba);
+	return hba->priv;
+}
+
 extern int ufshcd_runtime_suspend(struct ufs_hba *hba);
 extern int ufshcd_runtime_resume(struct ufs_hba *hba);
 extern int ufshcd_runtime_idle(struct ufs_hba *hba);
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
