From: Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH v1 07/12] scsi: ufs: add option to change default UFS power management level
Date: Mon, 12 Dec 2016 16:54:20 -0800
Message-ID: <1481590462-9981-1-git-send-email-subhashj@codeaurora.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>, Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, "open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

UFS device and link can be put in multiple different low power modes hence
UFS driver supports multiple different low power modes. By default UFS
driver selects the default (optimal) low power mode (which gives moderate
power savings and have relatively less enter and exit latencies) but
we might have to tune this default power mode for different chipset
platforms to meet the low power requirements/goals. Hence this patch
adds option to change default UFS low power mode (level).

Reviewed-by: Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Signed-off-by: Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      | 10 ++++++
 drivers/scsi/ufs/ufshcd-pltfrm.c                   | 14 ++++++++
 drivers/scsi/ufs/ufshcd.c                          | 39 ++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h                          |  4 +--
 4 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index a99ed55..c3836c5 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -41,6 +41,14 @@ Optional properties:
 -lanes-per-direction	: number of lanes available per direction - either 1 or 2.
 			  Note that it is assume same number of lanes is used both
 			  directions at once. If not specified, default is 2 lanes per direction.
+- rpm-level		: UFS Runtime power management level. Following PM levels are supported:
+			  0 - Both UFS device and Link in active state (Highest power consumption)
+			  1 - UFS device in active state but Link in Hibern8 state
+			  2 - UFS device in Sleep state but Link in active state
+			  3 - UFS device in Sleep state and Link in hibern8 state (default PM level)
+			  4 - UFS device in Power-down state and Link in Hibern8 state
+			  5 - UFS device in Power-down state and Link in OFF state (Lowest power consumption)
+- spm-level		: UFS System power management level. Allowed PM levels are same as rpm-level.
 
 Note: If above properties are not defined it can be assumed that the supply
 regulators or clocks are always on.
@@ -66,4 +74,6 @@ Example:
 		freq-table-hz = <100000000 200000000>, <0 0>, <0 0>;
 		phys = <&ufsphy1>;
 		phy-names = "ufsphy";
+		rpm-level = <3>;
+		spm-level = <5>;
 	};
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index a72a4ba..896943d 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -223,6 +223,19 @@ static int ufshcd_parse_regulator_info(struct ufs_hba *hba)
 	return err;
 }
 
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
 #ifdef CONFIG_PM
 /**
  * ufshcd_pltfrm_suspend - suspend power management function
@@ -342,6 +355,7 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 		goto dealloc_host;
 	}
 
+	ufshcd_parse_pm_levels(hba);
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 470ea99..43f9b44 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -191,6 +191,22 @@ enum {
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
 static struct ufs_dev_fix ufs_fixups[] = {
 	/* UFS cards deviations table */
 	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
@@ -215,6 +231,14 @@ enum {
 	END_FIX
 };
 
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
@@ -7290,6 +7314,21 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		ufshcd_clkscaling_init_sysfs(hba);
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
index 787323b..97fbe4a 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -432,9 +432,9 @@ struct ufs_hba {
 	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
 	enum uic_link_state uic_link_state;
 	/* Desired UFS power management level during runtime PM */
-	enum ufs_pm_level rpm_lvl;
+	int rpm_lvl;
 	/* Desired UFS power management level during system PM */
-	enum ufs_pm_level spm_lvl;
+	int spm_lvl;
 	struct device_attribute rpm_lvl_attr;
 	struct device_attribute spm_lvl_attr;
 	int pm_op_in_progress;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
