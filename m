From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V3 16/16] scsi: ufs: definitions for phy interface
Date: Wed, 10 Sep 2014 14:54:23 +0300
Message-ID: <1410350063-23267-17-git-send-email-draviv@codeaurora.org>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:44041 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaIJLzP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 07:55:15 -0400
In-Reply-To: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>

- Adding some of the definitions missing in unipro.h, including power
  enumeration.
- Read Modify Write Line helper function
- Indication for the type of suspend

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 33984cc..8b7c332 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4947,6 +4947,8 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 
 	ret = ufshcd_suspend(hba, UFS_SYSTEM_PM);
 out:
+	if (!ret)
+		hba->is_sys_suspended = true;
 	return ret;
 }
 EXPORT_SYMBOL(ufshcd_system_suspend);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index b94b835..d502d70 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -471,6 +471,7 @@ struct ufs_hba {
 
 	struct devfreq *devfreq;
 	struct ufs_clk_scaling clk_scaling;
+	bool is_sys_suspended;
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
@@ -496,6 +497,23 @@ static inline bool ufshcd_can_autobkops_during_suspend(struct ufs_hba *hba)
 #define ufshcd_readl(hba, reg)	\
 	readl((hba)->mmio_base + (reg))
 
+/**
+ * ufshcd_rmwl - read modify write into a register
+ * @hba - per adapter instance
+ * @mask - mask to apply on read value
+ * @val - actual value to write
+ * @reg - register address
+ */
+static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32 reg)
+{
+	u32 tmp;
+
+	tmp = ufshcd_readl(hba, reg);
+	tmp &= ~mask;
+	tmp |= (val & mask);
+	ufshcd_writel(hba, tmp, reg);
+}
+
 int ufshcd_alloc_host(struct device *, struct ufs_hba **);
 int ufshcd_init(struct ufs_hba * , void __iomem * , unsigned int);
 void ufshcd_remove(struct ufs_hba *);
diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index 0bb8041..3fc3e21 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -13,6 +13,44 @@
 #define _UNIPRO_H_
 
 /*
+ * M-TX Configuration Attributes
+ */
+#define TX_MODE					0x0021
+#define TX_HSRATE_SERIES			0x0022
+#define TX_HSGEAR				0x0023
+#define TX_PWMGEAR				0x0024
+#define TX_AMPLITUDE				0x0025
+#define TX_HS_SLEWRATE				0x0026
+#define TX_SYNC_SOURCE				0x0027
+#define TX_HS_SYNC_LENGTH			0x0028
+#define TX_HS_PREPARE_LENGTH			0x0029
+#define TX_LS_PREPARE_LENGTH			0x002A
+#define TX_HIBERN8_CONTROL			0x002B
+#define TX_LCC_ENABLE				0x002C
+#define TX_PWM_BURST_CLOSURE_EXTENSION		0x002D
+#define TX_BYPASS_8B10B_ENABLE			0x002E
+#define TX_DRIVER_POLARITY			0x002F
+#define TX_HS_UNTERMINATED_LINE_DRIVE_ENABLE	0x0030
+#define TX_LS_TERMINATED_LINE_DRIVE_ENABLE	0x0031
+#define TX_LCC_SEQUENCER			0x0032
+#define TX_MIN_ACTIVATETIME			0x0033
+#define TX_PWM_G6_G7_SYNC_LENGTH		0x0034
+
+/*
+ * M-RX Configuration Attributes
+ */
+#define RX_MODE					0x00A1
+#define RX_HSRATE_SERIES			0x00A2
+#define RX_HSGEAR				0x00A3
+#define RX_PWMGEAR				0x00A4
+#define RX_LS_TERMINATED_ENABLE			0x00A5
+#define RX_HS_UNTERMINATED_ENABLE		0x00A6
+#define RX_ENTER_HIBERN8			0x00A7
+#define RX_BYPASS_8B10B_ENABLE			0x00A8
+#define RX_TERMINATION_FORCE_ENABLE		0x0089
+
+#define is_mphy_tx_attr(attr)			(attr < RX_MODE)
+/*
  * PHY Adpater attributes
  */
 #define PA_ACTIVETXDATALANES	0x1560
@@ -87,6 +125,24 @@ enum {
 	PA_HS_MODE_B	= 2,
 };
 
+enum ufs_pwm_gear_tag {
+	UFS_PWM_DONT_CHANGE,	/* Don't change Gear */
+	UFS_PWM_G1,		/* PWM Gear 1 (default for reset) */
+	UFS_PWM_G2,		/* PWM Gear 2 */
+	UFS_PWM_G3,		/* PWM Gear 3 */
+	UFS_PWM_G4,		/* PWM Gear 4 */
+	UFS_PWM_G5,		/* PWM Gear 5 */
+	UFS_PWM_G6,		/* PWM Gear 6 */
+	UFS_PWM_G7,		/* PWM Gear 7 */
+};
+
+enum ufs_hs_gear_tag {
+	UFS_HS_DONT_CHANGE,	/* Don't change Gear */
+	UFS_HS_G1,		/* HS Gear 1 (default for reset) */
+	UFS_HS_G2,		/* HS Gear 2 */
+	UFS_HS_G3,		/* HS Gear 3 */
+};
+
 /*
  * Data Link Layer Attributes
  */
-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

