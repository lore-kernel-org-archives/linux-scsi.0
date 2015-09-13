From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 02/17] scsi: ufs: add option to change default UFS power management level
Date: Sun, 13 Sep 2015 17:52:42 +0300
Message-ID: <1442155977-7686-3-git-send-email-ygardi@codeaurora.org>
References: <1442155977-7686-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442155977-7686-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, "open list:OPEN FIRMWARE AND FLATTENED
	DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

UFS device and link can be put in multiple different low power modes
hence UFS driver supports multiple different low power modes.
By default UFS driver selects the default (optimal) low power mode
(which gives moderate power savings and have relatively less enter
and exit latencies) but we might have to tune this default power
mode for different chipset platforms to meet the low power
requirements/goals. Hence this patch adds option to change default
UFS low power mode (level).

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  8 +++++
 drivers/scsi/ufs/ufs-qcom.c                        |  9 ++---
 drivers/scsi/ufs/ufshcd-pltfrm.c                   | 17 +++++++++-
 drivers/scsi/ufs/ufshcd.c                          | 39 ++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h                          |  4 +--
 5 files changed, 70 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index 56b105f..de9ff25 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -31,6 +31,14 @@ Optional properties:
 			  defined or a value in the array is "0" then it is assumed
 			  that the frequency is set by the parent clock or a
 			  fixed rate clock source.
+- rpm-level		: UFS Runtime power management level. Following PM levels are supported:
+			  0 - Both UFS device and Link in active state (Highest power consumption)
+			  1 - UFS device in active state but Link in Hibern8 state
+			  2 - UFS device in Sleep state but Link in active state
+			  3 - UFS device in Sleep state and Link in hibern8 state (default PM level)
+			  4 - UFS device in Power-down state and Link in Hibern8 state
+			  5 - UFS device in Power-down state and Link in OFF state (Lowest power consumption)
+- spm-level		: UFS System power management level. Allowed PM levels are same as rpm-level.
 - lanes-per-direction:	number of lanes available per direction - either 1 or 2.
 			Note that it is assume same number of lanes is used both directions at once.
 			If not specified, default is 2 lanes per direction.
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 3196197..1d26e49 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1195,11 +1195,12 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 		if (res) {
 			host->dev_ref_clk_ctrl_mmio =
 					devm_ioremap_resource(dev, res);
-			if (IS_ERR(host->dev_ref_clk_ctrl_mmio)) {
-				dev_warn(dev,
-					"%s: could not map dev_ref_clk_ctrl_mmio, err %ld\n",
+			if (IS_ERR((__force void const *)
+				   host->dev_ref_clk_ctrl_mmio)) {
+				dev_warn(dev, "%s: could not map dev_ref_clk_ctrl_mmio, err %ld\n",
 					__func__,
-					PTR_ERR(host->dev_ref_clk_ctrl_mmio));
+					PTR_ERR((__force void const *)
+						 host->dev_ref_clk_ctrl_mmio));
 				host->dev_ref_clk_ctrl_mmio = NULL;
 			}
 			host->dev_ref_clk_en_mask = BIT(5);
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 8eafcfa..9188ea4 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -224,7 +224,20 @@ out:
 	return err;
 }
 
-#ifdef CONFIG_PM
+static void ufshcd_parse_pm_levels(struct ufs_hba *hba)
+{
+	struct device *dev = hba->dev;
+	struct device_node *np = dev->of_node;
+
+	if (np) {
+		if (of_property_read_u32(np, "rpm-level", &hba->rpm_lvl))
+			hba->rpm_lvl = -1;
+		if (of_property_read_u32(np, "spm-level", &hba->spm_lvl))
+			hba->spm_lvl = -1;
+	}
+}
+
+#ifdef CONFIG_SMP
 /**
  * ufshcd_pltfrm_suspend - suspend power management function
  * @dev: pointer to device handle
@@ -328,6 +341,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 		goto out;
 	}
 
+	ufshcd_parse_pm_levels(hba);
+
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9638553..388536e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -188,6 +188,30 @@ ufs_get_pm_lvl_to_link_pwr_state(enum ufs_pm_level lvl)
 	return ufs_pm_lvl_states[lvl].link_state;
 }
 
+static inline enum ufs_pm_level
+ufs_get_desired_pm_lvl_for_dev_link_state(enum ufs_dev_pwr_mode dev_state,
+					enum uic_link_state link_state)
+{
+	enum ufs_pm_level lvl;
+
+	for (lvl = UFS_PM_LVL_0; lvl < UFS_PM_LVL_MAX; lvl++) {
+		if ((ufs_pm_lvl_states[lvl].dev_state == dev_state) &&
+			(ufs_pm_lvl_states[lvl].link_state == link_state))
+			return lvl;
+	}
+
+	/* if no match found, return the level 0 */
+	return UFS_PM_LVL_0;
+}
+
+static inline bool ufshcd_is_valid_pm_lvl(int lvl)
+{
+	if (lvl >= 0 && lvl < ARRAY_SIZE(ufs_pm_lvl_states))
+		return true;
+	else
+		return false;
+}
+
 static void ufshcd_tmc_handler(struct ufs_hba *hba);
 static void ufshcd_async_scan(void *data, async_cookie_t cookie);
 static int ufshcd_reset_and_restore(struct ufs_hba *hba);
@@ -5907,6 +5931,21 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		hba->clk_scaling.window_start_t = 0;
 	}
 
+	/*
+	 * If rpm_lvl and and spm_lvl are not already set to valid levels,
+	 * set the default power management level for UFS runtime and system
+	 * suspend. Default power saving mode selected is keeping UFS link in
+	 * Hibern8 state and UFS device in sleep.
+	 */
+	if (!ufshcd_is_valid_pm_lvl(hba->rpm_lvl))
+		hba->rpm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
+							UFS_SLEEP_PWR_MODE,
+							UIC_LINK_HIBERN8_STATE);
+	if (!ufshcd_is_valid_pm_lvl(hba->spm_lvl))
+		hba->spm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
+							UFS_SLEEP_PWR_MODE,
+							UIC_LINK_HIBERN8_STATE);
+
 	/* Hold auto suspend until async scan completes */
 	pm_runtime_get_sync(dev);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e7bcf65..889335a 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -408,9 +408,9 @@ struct ufs_hba {
 	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
 	enum uic_link_state uic_link_state;
 	/* Desired UFS power management level during runtime PM */
-	enum ufs_pm_level rpm_lvl;
+	int rpm_lvl;
 	/* Desired UFS power management level during system PM */
-	enum ufs_pm_level spm_lvl;
+	int spm_lvl;
 	int pm_op_in_progress;
 
 	struct ufshcd_lrb *lrb;
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
