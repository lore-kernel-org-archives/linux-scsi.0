Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9B03C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Mar 2021 21:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3E2961947
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Mar 2021 21:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbhCUV6s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Mar 2021 17:58:48 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:40323 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbhCUV6X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Mar 2021 17:58:23 -0400
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 21 Mar 2021 14:58:23 -0700
X-QCInternal: smtphost
Received: from ironmsg01-blr.qualcomm.com ([10.86.208.130])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/AES256-SHA; 21 Mar 2021 14:58:22 -0700
X-QCInternal: smtphost
Received: from maggarwa.ap.qualcomm.com (HELO nitirawa-linux.qualcomm.com) ([10.206.25.176])
  by ironmsg01-blr.qualcomm.com with ESMTP; 22 Mar 2021 03:27:47 +0530
Received: by nitirawa-linux.qualcomm.com (Postfix, from userid 2342877)
        id BB5752E1C; Mon, 22 Mar 2021 03:27:46 +0530 (IST)
From:   Nitin Rawat <nitirawa@codeaurora.org>
To:     asutoshd@codeaurora.org, cang@codeaurora.org,
        stummala@codeaurora.org, vbadigan@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bjorn.andersson@linaro.org,
        adrian.hunter@intel.com, bvanassche@acm.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Rawat <nitirawa@codeaurora.org>
Subject: [PATCH V2 2/3] scsi: ufs: add a vops to configure VCC voltage level
Date:   Mon, 22 Mar 2021 03:27:36 +0530
Message-Id: <1616363857-26760-3-git-send-email-nitirawa@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616363857-26760-1-git-send-email-nitirawa@codeaurora.org>
References: <1616363857-26760-1-git-send-email-nitirawa@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a vops to configure VCC voltage VCC voltage level
for platform supporting both ufs2.x and ufs 3.x devices.

Suggested-by: Stanley Chu <stanley.chu@mediatek.com>
Suggested-by: Asutosh Das <asutoshd@codeaurora.org>
Suggested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Nitin Rawat <nitirawa@codeaurora.org>
Signed-off-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c |  4 ++++
 drivers/scsi/ufs/ufshcd.h | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 633ca8e..5bfe987 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7763,6 +7763,10 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 		goto out;

 	ufshcd_clear_ua_wluns(hba);
+	if (ufshcd_vops_setup_vcc_regulators(hba))
+		dev_err(hba->dev,
+			"%s: Failed to set the VCC regulator values, continue with 2.7v\n",
+			__func__);

 	/* Initialize devfreq after UFS device is detected */
 	if (ufshcd_is_clkscaling_supported(hba)) {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 0db796a..8f0945d 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -324,6 +324,7 @@ struct ufs_pwr_mode_info {
  * @device_reset: called to issue a reset pulse on the UFS device
  * @program_key: program or evict an inline encryption key
  * @event_notify: called to notify important events
+ * @setup_vcc_regulators : update vcc regulator level
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -360,6 +361,7 @@ struct ufs_hba_variant_ops {
 			       const union ufs_crypto_cfg_entry *cfg, int slot);
 	void	(*event_notify)(struct ufs_hba *hba,
 				enum ufs_event_type evt, void *data);
+	int    (*setup_vcc_regulators)(struct ufs_hba *hba);
 };

 /* clock gating state  */
@@ -1269,6 +1271,14 @@ static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
 		hba->vops->config_scaling_param(hba, profile, data);
 }

+static inline int ufshcd_vops_setup_vcc_regulators(struct ufs_hba *hba)
+{
+	if (hba->vops && hba->vops->setup_vcc_regulators)
+		return hba->vops->setup_vcc_regulators(hba);
+
+	return 0;
+}
+
 extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];

 /*
--
2.7.4

