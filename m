From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 7/8] scsi: ufs-qcom: dump additional testbus registers
Date: Fri,  3 Feb 2017 16:58:12 -0800
Message-ID: <1486169892-22933-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Venkat Gopalakrishnan <venkatg@codeaurora.org>

Change testbus default config, dump additional testbus registers along
with other debug vendor specific registers. These additional info are
useful in debugging link related failures.

Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 48 +++++++++++++++++++++++++++++++++++++++------
 drivers/scsi/ufs/ufs-qcom.h |  1 +
 2 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 5ff8a6b..ce5d023 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1497,17 +1497,21 @@ static void ufs_qcom_print_hw_debug_reg_all(struct ufs_hba *hba,
 
 static void ufs_qcom_enable_test_bus(struct ufs_qcom_host *host)
 {
-	if (host->dbg_print_en & UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
+	if (host->dbg_print_en & UFS_QCOM_DBG_PRINT_TEST_BUS_EN) {
+		ufshcd_rmwl(host->hba, UFS_REG_TEST_BUS_EN,
+				UFS_REG_TEST_BUS_EN, REG_UFS_CFG1);
 		ufshcd_rmwl(host->hba, TEST_BUS_EN, TEST_BUS_EN, REG_UFS_CFG1);
-	else
+	} else {
+		ufshcd_rmwl(host->hba, UFS_REG_TEST_BUS_EN, 0, REG_UFS_CFG1);
 		ufshcd_rmwl(host->hba, TEST_BUS_EN, 0, REG_UFS_CFG1);
+	}
 }
 
 static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host)
 {
 	/* provide a legal default configuration */
-	host->testbus.select_major = TSTBUS_UAWM;
-	host->testbus.select_minor = 1;
+	host->testbus.select_major = TSTBUS_UNIPRO;
+	host->testbus.select_minor = 37;
 }
 
 static bool ufs_qcom_testbus_cfg_is_ok(struct ufs_qcom_host *host)
@@ -1524,7 +1528,7 @@ static bool ufs_qcom_testbus_cfg_is_ok(struct ufs_qcom_host *host)
 	 * mappings of select_minor, since there is no harm in
 	 * configuring a non-existent select_minor
 	 */
-	if (host->testbus.select_minor > 0x1F) {
+	if (host->testbus.select_minor > 0xFF) {
 		dev_err(host->hba->dev,
 			"%s: 0x%05X is not a legal testbus option\n",
 			__func__, host->testbus.select_minor);
@@ -1593,7 +1597,8 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host)
 		break;
 	case TSTBUS_UNIPRO:
 		reg = UFS_UNIPRO_CFG;
-		offset = 1;
+		offset = 20;
+		mask = 0xFFF;
 		break;
 	/*
 	 * No need for a default case, since
@@ -1612,6 +1617,11 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host)
 		    (u32)host->testbus.select_minor << offset,
 		    reg);
 	ufs_qcom_enable_test_bus(host);
+	/*
+	 * Make sure the test bus configuration is
+	 * committed before returning.
+	 */
+	mb();
 	ufshcd_release(host->hba);
 	pm_runtime_put_sync(host->hba->dev);
 
@@ -1623,13 +1633,39 @@ static void ufs_qcom_testbus_read(struct ufs_hba *hba)
 	ufs_qcom_dump_regs(hba, UFS_TEST_BUS, 1, "UFS_TEST_BUS ");
 }
 
+static void ufs_qcom_print_unipro_testbus(struct ufs_hba *hba)
+{
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+	u32 *testbus = NULL;
+	int i, nminor = 256, testbus_len = nminor * sizeof(u32);
+
+	testbus = kmalloc(testbus_len, GFP_KERNEL);
+	if (!testbus)
+		return;
+
+	host->testbus.select_major = TSTBUS_UNIPRO;
+	for (i = 0; i < nminor; i++) {
+		host->testbus.select_minor = i;
+		ufs_qcom_testbus_config(host);
+		testbus[i] = ufshcd_readl(hba, UFS_TEST_BUS);
+	}
+	print_hex_dump(KERN_ERR, "UNIPRO_TEST_BUS ", DUMP_PREFIX_OFFSET,
+			16, 4, testbus, testbus_len, false);
+	kfree(testbus);
+}
+
 static void ufs_qcom_dump_dbg_regs(struct ufs_hba *hba)
 {
 	ufs_qcom_dump_regs(hba, REG_UFS_SYS1CLK_1US, 16,
 			"HCI Vendor Specific Registers ");
 
+	/* sleep a bit intermittently as we are dumping too much data */
 	ufs_qcom_print_hw_debug_reg_all(hba, NULL, ufs_qcom_dump_regs_wrapper);
+	usleep_range(1000, 1100);
 	ufs_qcom_testbus_read(hba);
+	usleep_range(1000, 1100);
+	ufs_qcom_print_unipro_testbus(hba);
+	usleep_range(1000, 1100);
 }
 
 /**
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index fe517cd..076f528 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -95,6 +95,7 @@ enum {
 #define QUNIPRO_SEL	UFS_BIT(0)
 #define TEST_BUS_EN		BIT(18)
 #define TEST_BUS_SEL		GENMASK(22, 19)
+#define UFS_REG_TEST_BUS_EN	BIT(30)
 
 /* bit definitions for REG_UFS_CFG2 register */
 #define UAWM_HW_CGC_EN		(1 << 0)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
