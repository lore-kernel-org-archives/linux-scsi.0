Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D41AC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 16:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 269E864E0C
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 16:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbhA1Q4g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 11:56:36 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:62233 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbhA1Q4e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 11:56:34 -0500
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 28 Jan 2021 08:55:31 -0800
X-QCInternal: smtphost
Received: from ironmsg02-blr.qualcomm.com ([10.86.208.131])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/AES256-SHA; 28 Jan 2021 08:55:30 -0800
X-QCInternal: smtphost
Received: from nitirawa-linux.qualcomm.com ([10.206.25.176])
  by ironmsg02-blr.qualcomm.com with ESMTP; 28 Jan 2021 22:25:08 +0530
Received: by nitirawa-linux.qualcomm.com (Postfix, from userid 2342877)
        id 05A052A73; Thu, 28 Jan 2021 22:25:07 +0530 (IST)
From:   Nitin Rawat <nitirawa@codeaurora.org>
To:     asutoshd@codeaurora.org, cang@codeaurora.org,
        stummala@codeaurora.org, vbadigan@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com
Cc:     bvanassche@acm.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nitin Rawat <nitirawa@codeaurora.org>,
        "Bao D . Nguyen" <nguyenb@codeaurora.org>
Subject: [PATCH V1 3/3] scsi: ufs-qcom: configure VCC voltage level in vendor file
Date:   Thu, 28 Jan 2021 22:24:59 +0530
Message-Id: <1611852899-2171-4-git-send-email-nitirawa@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1611852899-2171-1-git-send-email-nitirawa@codeaurora.org>
References: <1611852899-2171-1-git-send-email-nitirawa@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As a part of vops handler, VCC voltage is updated
as per the ufs device probed after reading the device
descriptor. We follow below steps to configure voltage
level.

1. Set the device to SLEEP state.
2. Disable the Vcc Regulator.
3. Set the vcc voltage according to the device type and reenable
   the regulator.
4. Set the device mode back to ACTIVE.

Signed-off-by: Nitin Rawat <nitirawa@codeaurora.org>
Signed-off-by: Bao D. Nguyen <nguyenb@codeaurora.org>
Signed-off-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 51 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index f97d7b0..ca35f5c 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -21,6 +21,17 @@
 #define UFS_QCOM_DEFAULT_DBG_PRINT_EN	\
 	(UFS_QCOM_DBG_PRINT_REGS_EN | UFS_QCOM_DBG_PRINT_TEST_BUS_EN)

+#define	ANDROID_BOOT_DEV_MAX	30
+static char android_boot_dev[ANDROID_BOOT_DEV_MAX];
+
+/* Min and Max VCC voltage values for ufs 2.x and
+ * ufs 3.x devices
+ */
+#define UFS_3X_VREG_VCC_MIN_UV	2540000 /* uV */
+#define UFS_3X_VREG_VCC_MAX_UV	2700000 /* uV */
+#define UFS_2X_VREG_VCC_MIN_UV	2950000 /* uV */
+#define UFS_2X_VREG_VCC_MAX_UV	2960000 /* uV */
+
 enum {
 	TSTBUS_UAWM,
 	TSTBUS_UARM,
@@ -1293,6 +1304,45 @@ static void ufs_qcom_print_hw_debug_reg_all(struct ufs_hba *hba,
 	print_fn(hba, reg, 9, "UFS_DBG_RD_REG_TMRLUT ", priv);
 }

+  /**
+   * ufs_qcom_setup_vcc_regulators - Update VCC voltage
+   * @hba: host controller instance
+   * Update VCC voltage based on UFS device(ufs 2.x or
+   * ufs 3.x probed)
+   */
+static int ufs_qcom_setup_vcc_regulators(struct ufs_hba *hba)
+{
+	struct ufs_dev_info *dev_info = &hba->dev_info;
+	struct ufs_vreg *vreg = hba->vreg_info.vcc;
+	int ret;
+
+	/* Put the device in sleep before lowering VCC level */
+	ret = ufshcd_set_dev_pwr_mode(hba, UFS_SLEEP_PWR_MODE);
+
+	/* Switch off VCC before switching it ON at 2.5v or 2.96v */
+	ret = ufshcd_disable_vreg(hba->dev, vreg);
+
+	/* add ~2ms delay before renabling VCC at lower voltage */
+	usleep_range(2000, 2100);
+
+	/* set VCC min and max voltage according to ufs device type */
+	if (dev_info->wspecversion >= 0x300) {
+		vreg->min_uV = UFS_3X_VREG_VCC_MIN_UV;
+		vreg->max_uV = UFS_3X_VREG_VCC_MAX_UV;
+	}
+
+	else {
+		vreg->min_uV = UFS_2X_VREG_VCC_MIN_UV;
+		vreg->max_uV = UFS_2X_VREG_VCC_MAX_UV;
+	}
+
+	ret = ufshcd_enable_vreg(hba->dev, vreg);
+
+	/* Bring the device in active now */
+	ret = ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE);
+	return ret;
+}
+
 static void ufs_qcom_enable_test_bus(struct ufs_qcom_host *host)
 {
 	if (host->dbg_print_en & UFS_QCOM_DBG_PRINT_TEST_BUS_EN) {
@@ -1490,6 +1540,7 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.device_reset		= ufs_qcom_device_reset,
 	.config_scaling_param = ufs_qcom_config_scaling_param,
 	.program_key		= ufs_qcom_ice_program_key,
+	.setup_vcc_regulators	= ufs_qcom_setup_vcc_regulators,
 };

 /**
--
2.7.4

