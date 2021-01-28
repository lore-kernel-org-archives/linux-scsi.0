Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A989C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 16:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4908A64E07
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 16:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbhA1Q4z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 11:56:55 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:62233 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbhA1Q4w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 11:56:52 -0500
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 28 Jan 2021 08:55:33 -0800
X-QCInternal: smtphost
Received: from ironmsg02-blr.qualcomm.com ([10.86.208.131])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/AES256-SHA; 28 Jan 2021 08:55:31 -0800
X-QCInternal: smtphost
Received: from nitirawa-linux.qualcomm.com ([10.206.25.176])
  by ironmsg02-blr.qualcomm.com with ESMTP; 28 Jan 2021 22:25:03 +0530
Received: by nitirawa-linux.qualcomm.com (Postfix, from userid 2342877)
        id A9BA12A73; Thu, 28 Jan 2021 22:25:03 +0530 (IST)
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
Subject: [PATCH V1 1/3] scsi: ufs: export api for use in vendor file
Date:   Thu, 28 Jan 2021 22:24:57 +0530
Message-Id: <1611852899-2171-2-git-send-email-nitirawa@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1611852899-2171-1-git-send-email-nitirawa@codeaurora.org>
References: <1611852899-2171-1-git-send-email-nitirawa@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Exporting functions ufshcd_set_dev_pwr_mode, ufshcd_disable_vreg
and ufshcd_enable_vreg so that vendor drivers can make use of
them in setting vendor specific regulator setting
in vendor specific file.

Signed-off-by: Nitin Rawat <nitirawa@codeaurora.org>
Signed-off-by: Bao D. Nguyen <nguyenb@codeaurora.org>
Signed-off-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 9 ++++++---
 drivers/scsi/ufs/ufshcd.h | 4 ++++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9c691e4..000a03a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8091,7 +8091,7 @@ static int ufshcd_config_vreg(struct device *dev,
 	return ret;
 }

-static int ufshcd_enable_vreg(struct device *dev, struct ufs_vreg *vreg)
+int ufshcd_enable_vreg(struct device *dev, struct ufs_vreg *vreg)
 {
 	int ret = 0;

@@ -8110,8 +8110,9 @@ static int ufshcd_enable_vreg(struct device *dev, struct ufs_vreg *vreg)
 out:
 	return ret;
 }
+EXPORT_SYMBOL(ufshcd_enable_vreg);

-static int ufshcd_disable_vreg(struct device *dev, struct ufs_vreg *vreg)
+int ufshcd_disable_vreg(struct device *dev, struct ufs_vreg *vreg)
 {
 	int ret = 0;

@@ -8131,6 +8132,7 @@ static int ufshcd_disable_vreg(struct device *dev, struct ufs_vreg *vreg)
 out:
 	return ret;
 }
+EXPORT_SYMBOL(ufshcd_disable_vreg);

 static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on)
 {
@@ -8455,7 +8457,7 @@ ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp)
  * Returns 0 if requested power mode is set successfully
  * Returns non-zero if failed to set the requested power mode
  */
-static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
+int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 				     enum ufs_dev_pwr_mode pwr_mode)
 {
 	unsigned char cmd[6] = { START_STOP };
@@ -8513,6 +8515,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	hba->host->eh_noresume = 0;
 	return ret;
 }
+EXPORT_SYMBOL(ufshcd_set_dev_pwr_mode);

 static int ufshcd_link_state_transition(struct ufs_hba *hba,
 					enum uic_link_state req_link_state,
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index ee61f82..1410c95 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -997,6 +997,10 @@ extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u32 *mib_val, u8 peer);
 extern int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 			struct ufs_pa_layer_attr *desired_pwr_mode);
+extern int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
+						enum ufs_dev_pwr_mode pwr_mode);
+extern int ufshcd_enable_vreg(struct device *dev, struct ufs_vreg *vreg);
+extern int ufshcd_disable_vreg(struct device *dev, struct ufs_vreg *vreg);

 /* UIC command interfaces for DME primitives */
 #define DME_LOCAL	0
--
2.7.4

