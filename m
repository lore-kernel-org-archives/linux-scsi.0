Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C5F2C433E6
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Mar 2021 21:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D96EC61944
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Mar 2021 21:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbhCUV6t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Mar 2021 17:58:49 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:40323 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbhCUV6Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Mar 2021 17:58:24 -0400
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 21 Mar 2021 14:58:24 -0700
X-QCInternal: smtphost
Received: from ironmsg01-blr.qualcomm.com ([10.86.208.130])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/AES256-SHA; 21 Mar 2021 14:58:22 -0700
X-QCInternal: smtphost
Received: from maggarwa.ap.qualcomm.com (HELO nitirawa-linux.qualcomm.com) ([10.206.25.176])
  by ironmsg01-blr.qualcomm.com with ESMTP; 22 Mar 2021 03:27:48 +0530
Received: by nitirawa-linux.qualcomm.com (Postfix, from userid 2342877)
        id 8ECCB2E19; Mon, 22 Mar 2021 03:27:47 +0530 (IST)
From:   Nitin Rawat <nitirawa@codeaurora.org>
To:     asutoshd@codeaurora.org, cang@codeaurora.org,
        stummala@codeaurora.org, vbadigan@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bjorn.andersson@linaro.org,
        adrian.hunter@intel.com, bvanassche@acm.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Rawat <nitirawa@codeaurora.org>
Subject: [PATCH V2 3/3] scsi: ufs-qcom: configure VCC voltage level in vendor file
Date:   Mon, 22 Mar 2021 03:27:37 +0530
Message-Id: <1616363857-26760-4-git-send-email-nitirawa@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616363857-26760-1-git-send-email-nitirawa@codeaurora.org>
References: <1616363857-26760-1-git-send-email-nitirawa@codeaurora.org>
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

