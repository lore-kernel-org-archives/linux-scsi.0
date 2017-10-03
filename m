From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v2 v2 2/4] scsi: ufs-qcom: Remove uses of UFS_BIT() macro
Date: Tue, 03 Oct 2017 20:51:23 +0530
Message-ID: <1507044085-16905-2-git-send-email-alim.akhtar@samsung.com>
References: <1507044085-16905-1-git-send-email-alim.akhtar@samsung.com>
        <CGME20171003152910epcas2p3a89515a352b8291d7cdeb5a97536d2a8@epcas2p3.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1507044085-16905-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vinholikatti@gmail.com, martin.petersen@oracle.com, subhashj@codeaurora.org, Bart.VanAssche@wdc.com
List-Id: linux-scsi@vger.kernel.org

Use actual bit position instead of UFS_BIT() macro. This
patch also changes bit-17 to meaningful #define.

This change is as per discussion here [1]
[1] -> https://lkml.org/lkml/2017/8/28/786

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 4 ++--
 drivers/scsi/ufs/ufs-qcom.h | 7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index c87d770..6a548e7 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1458,7 +1458,7 @@ static void ufs_qcom_print_hw_debug_reg_all(struct ufs_hba *hba,
 	print_fn(hba, reg, 44, "UFS_UFS_DBG_RD_REG_OCSC ", priv);
 
 	reg = ufshcd_readl(hba, REG_UFS_CFG1);
-	reg |= UFS_BIT(17);
+	reg |= UTP_DBG_RAMS_EN;
 	ufshcd_writel(hba, reg, REG_UFS_CFG1);
 
 	reg = ufs_qcom_get_debug_reg_offset(host, UFS_UFS_DBG_RD_EDTL_RAM);
@@ -1471,7 +1471,7 @@ static void ufs_qcom_print_hw_debug_reg_all(struct ufs_hba *hba,
 	print_fn(hba, reg, 64, "UFS_UFS_DBG_RD_PRDT_RAM ", priv);
 
 	/* clear bit 17 - UTP_DBG_RAMS_EN */
-	ufshcd_rmwl(hba, UFS_BIT(17), 0, REG_UFS_CFG1);
+	ufshcd_rmwl(hba, UTP_DBG_RAMS_EN, 0, REG_UFS_CFG1);
 
 	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_UAWM);
 	print_fn(hba, reg, 4, "UFS_DBG_RD_REG_UAWM ", priv);
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index 076f528..295f4be 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -92,7 +92,8 @@ enum {
 #define UFS_CNTLR_3_x_x_VEN_REGS_OFFSET(x)	(0x400 + x)
 
 /* bit definitions for REG_UFS_CFG1 register */
-#define QUNIPRO_SEL	UFS_BIT(0)
+#define QUNIPRO_SEL		0x1
+#define UTP_DBG_RAMS_EN		0x20000
 #define TEST_BUS_EN		BIT(18)
 #define TEST_BUS_SEL		GENMASK(22, 19)
 #define UFS_REG_TEST_BUS_EN	BIT(30)
@@ -213,13 +214,13 @@ struct ufs_qcom_host {
 	 * Note: By default this capability will be kept enabled if host
 	 * controller supports the QUniPro mode.
 	 */
-	#define UFS_QCOM_CAP_QUNIPRO	UFS_BIT(0)
+	#define UFS_QCOM_CAP_QUNIPRO	0x1
 
 	/*
 	 * Set this capability if host controller can retain the secure
 	 * configuration even after UFS controller core power collapse.
 	 */
-	#define UFS_QCOM_CAP_RETAIN_SEC_CFG_AFTER_PWR_COLLAPSE	UFS_BIT(1)
+	#define UFS_QCOM_CAP_RETAIN_SEC_CFG_AFTER_PWR_COLLAPSE	0x2
 	u32 caps;
 
 	struct phy *generic_phy;
-- 
2.7.4
