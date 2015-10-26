From: Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH v2 02/17] scsi: ufs: add option to change default UFS power management level
Date: Mon, 26 Oct 2015 17:40:57 +0200
Message-ID: <1445874072-25909-3-git-send-email-ygardi@codeaurora.org>
References: <1445874072-25909-1-git-send-email-ygardi@codeaurora.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445874072-25909-1-git-send-email-ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, santoshsy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-scsi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <JBottomley-wo1vFcy6AUs@public.gmane.org>, "open list:OPEN FIRMWARE AND FLATTENED
	DEVICE TREE BINDINGS" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

UFS device and link can be put in multiple different low power modes
hence UFS driver supports multiple different low power modes.
By default UFS driver selects the default (optimal) low power mode
(which gives moderate power savings and have relatively less enter
and exit latencies) but we might have to tune this default power
mode for different chipset platforms to meet the low power
requirements/goals. Hence this patch adds option to change default
UFS low power mode (level).

Signed-off-by: Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Signed-off-by: Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

---
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  8 +++++
 drivers/scsi/ufs/ufshcd-pltfrm.c                   | 17 +++++++++-
 drivers/scsi/ufs/ufshcd.c                          | 39 ++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h                          |  4 +--
 4 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index 9fea0de..b7db1c9 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -38,6 +38,14 @@ Optional properties:
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
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 5be0c91..1130dd9 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -226,7 +226,20 @@ out:
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
@@ -345,6 +358,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 		goto dealloc_host;
 	}
 
+	ufshcd_parse_pm_levels(hba);
+
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8d16aca..20c5b5d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -187,6 +187,30 @@ ufs_get_pm_lvl_to_link_pwr_state(enum ufs_pm_level lvl)
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
@@ -5885,6 +5909,21 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
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
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
