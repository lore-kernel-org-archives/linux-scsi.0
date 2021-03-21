Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E7EFC433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Mar 2021 21:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 226EA61944
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Mar 2021 21:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhCUV6s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Mar 2021 17:58:48 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:40323 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbhCUV6W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Mar 2021 17:58:22 -0400
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 21 Mar 2021 14:58:22 -0700
X-QCInternal: smtphost
Received: from ironmsg01-blr.qualcomm.com ([10.86.208.130])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/AES256-SHA; 21 Mar 2021 14:58:20 -0700
X-QCInternal: smtphost
Received: from maggarwa.ap.qualcomm.com (HELO nitirawa-linux.qualcomm.com) ([10.206.25.176])
  by ironmsg01-blr.qualcomm.com with ESMTP; 22 Mar 2021 03:27:46 +0530
Received: by nitirawa-linux.qualcomm.com (Postfix, from userid 2342877)
        id BF2C22E19; Mon, 22 Mar 2021 03:27:45 +0530 (IST)
From:   Nitin Rawat <nitirawa@codeaurora.org>
To:     asutoshd@codeaurora.org, cang@codeaurora.org,
        stummala@codeaurora.org, vbadigan@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bjorn.andersson@linaro.org,
        adrian.hunter@intel.com, bvanassche@acm.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Rawat <nitirawa@codeaurora.org>
Subject: [PATCH V2 1/3] scsi: ufs: export api for use in vendor file
Date:   Mon, 22 Mar 2021 03:27:35 +0530
Message-Id: <1616363857-26760-2-git-send-email-nitirawa@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616363857-26760-1-git-send-email-nitirawa@codeaurora.org>
References: <1616363857-26760-1-git-send-email-nitirawa@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Exporting functions ufshcd_set_dev_pwr_mode, ufshcd_disable_vreg
and ufshcd_enable_vreg so that vendor drivers can make use of
them in setting vendor specific regulator setting
in vendor specific file.

Signed-off-by: Nitin Rawat <nitirawa@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 9 ++++++---
 drivers/scsi/ufs/ufshcd.h | 4 ++++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 80620c8..633ca8e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8081,7 +8081,7 @@ static int ufshcd_config_vreg(struct device *dev,
 	return ret;
 }

-static int ufshcd_enable_vreg(struct device *dev, struct ufs_vreg *vreg)
+int ufshcd_enable_vreg(struct device *dev, struct ufs_vreg *vreg)
 {
 	int ret = 0;

@@ -8100,8 +8100,9 @@ static int ufshcd_enable_vreg(struct device *dev, struct ufs_vreg *vreg)
 out:
 	return ret;
 }
+EXPORT_SYMBOL(ufshcd_enable_vreg);

-static int ufshcd_disable_vreg(struct device *dev, struct ufs_vreg *vreg)
+int ufshcd_disable_vreg(struct device *dev, struct ufs_vreg *vreg)
 {
 	int ret = 0;

@@ -8121,6 +8122,7 @@ static int ufshcd_disable_vreg(struct device *dev, struct ufs_vreg *vreg)
 out:
 	return ret;
 }
+EXPORT_SYMBOL(ufshcd_disable_vreg);

 static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on)
 {
@@ -8445,7 +8447,7 @@ ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp)
  * Returns 0 if requested power mode is set successfully
  * Returns non-zero if failed to set the requested power mode
  */
-static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
+int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 				     enum ufs_dev_pwr_mode pwr_mode)
 {
 	unsigned char cmd[6] = { START_STOP };
@@ -8503,6 +8505,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	hba->host->eh_noresume = 0;
 	return ret;
 }
+EXPORT_SYMBOL(ufshcd_set_dev_pwr_mode);

 static int ufshcd_link_state_transition(struct ufs_hba *hba,
 					enum uic_link_state req_link_state,
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 18e56c1..0db796a 100644
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

