Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 489E2C2D0E7
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 17:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26A922077D
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 17:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgCYRuW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 13:50:22 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:10957 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728247AbgCYRuV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Mar 2020 13:50:21 -0400
IronPort-SDR: 8VjKLx+JsMa/Of+DSfvflWJoMagIr+MOQ7Wz6+QQYPXON4uQURvzqRis0G4xyWrM0wlYducT5e
 5xOcGX+qYSD6TV/F5zdhi3854l91Y46crqgv88ymGUi0Ac+SYB/0hVWV3YRJtE5QjCOIWAe3Sd
 Ey4Q17OzoNB/HdOPLjH39gZ6pEEeoHG1W+RR9EKV2+7pD0UKIdpwmQLQpD9LnEVaBI1MPv8S+2
 Dyj1PVF3xh/GWRNdvn/eZtKe2RSJGUpMposOOyepkbilmBcKG7T/MmBeec6knWbUeE2nFbAWJh
 97I=
X-IronPort-AV: E=Sophos;i="5.72,303,1580803200"; 
   d="scan'208";a="28615551"
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by labrats.qualcomm.com with ESMTP; 25 Mar 2020 02:24:53 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg05-sd.qualcomm.com with ESMTP; 25 Mar 2020 02:24:51 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id C62C73A9C; Wed, 25 Mar 2020 02:24:51 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Subhash Jadavani <subhashj@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 1/2] scsi: ufs: Clean up ufshcd_scale_clks() and clock scaling error out path
Date:   Wed, 25 Mar 2020 02:23:38 -0700
Message-Id: <1585128220-26128-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1585128220-26128-1-git-send-email-cang@codeaurora.org>
References: <1585128220-26128-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

This change introduces a func ufshcd_set_clk_freq() to explicitly
set clock frequency so that it can be used in reset_and_resotre path and
in ufshcd_scale_clks(). Meanwhile, this change cleans up the clock scaling
error out path.

Fixes: a3cd5ec55f6c ("scsi: ufs: add load based scaling of UFS gear")
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 68 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2a2a63b..9c26f82 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -855,28 +855,29 @@ static bool ufshcd_is_unipro_pa_params_tuning_req(struct ufs_hba *hba)
 		return false;
 }
 
-static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
+/**
+ * ufshcd_set_clk_freq - set UFS controller clock frequencies
+ * @hba: per adapter instance
+ * @scale_up: If True, set max possible frequency othewise set low frequency
+ *
+ * Returns 0 if successful
+ * Returns < 0 for any other errors
+ */
+static int ufshcd_set_clk_freq(struct ufs_hba *hba, bool scale_up)
 {
 	int ret = 0;
 	struct ufs_clk_info *clki;
 	struct list_head *head = &hba->clk_list_head;
-	ktime_t start = ktime_get();
-	bool clk_state_changed = false;
 
 	if (list_empty(head))
 		goto out;
 
-	ret = ufshcd_vops_clk_scale_notify(hba, scale_up, PRE_CHANGE);
-	if (ret)
-		return ret;
-
 	list_for_each_entry(clki, head, list) {
 		if (!IS_ERR_OR_NULL(clki->clk)) {
 			if (scale_up && clki->max_freq) {
 				if (clki->curr_freq == clki->max_freq)
 					continue;
 
-				clk_state_changed = true;
 				ret = clk_set_rate(clki->clk, clki->max_freq);
 				if (ret) {
 					dev_err(hba->dev, "%s: %s clk set rate(%dHz) failed, %d\n",
@@ -895,7 +896,6 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
 				if (clki->curr_freq == clki->min_freq)
 					continue;
 
-				clk_state_changed = true;
 				ret = clk_set_rate(clki->clk, clki->min_freq);
 				if (ret) {
 					dev_err(hba->dev, "%s: %s clk set rate(%dHz) failed, %d\n",
@@ -914,13 +914,40 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
 				clki->name, clk_get_rate(clki->clk));
 	}
 
+out:
+	return ret;
+}
+
+/**
+ * ufshcd_scale_clks - scale up or scale down UFS controller clocks
+ * @hba: per adapter instance
+ * @scale_up: True if scaling up and false if scaling down
+ *
+ * Returns 0 if successful
+ * Returns < 0 for any other errors
+ */
+static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
+{
+	int ret = 0;
+
+	ret = ufshcd_vops_clk_scale_notify(hba, scale_up, PRE_CHANGE);
+	if (ret)
+		return ret;
+
+	ret = ufshcd_set_clk_freq(hba, scale_up);
+	if (ret)
+		return ret;
+
 	ret = ufshcd_vops_clk_scale_notify(hba, scale_up, POST_CHANGE);
+	if (ret) {
+		ufshcd_set_clk_freq(hba, !scale_up);
+		return ret;
+	}
 
-out:
-	if (clk_state_changed)
-		trace_ufshcd_profile_clk_scaling(dev_name(hba->dev),
+	trace_ufshcd_profile_clk_scaling(dev_name(hba->dev),
 			(scale_up ? "up" : "down"),
 			ktime_to_us(ktime_sub(ktime_get(), start)), ret);
+
 	return ret;
 }
 
@@ -1106,35 +1133,32 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 
 	ret = ufshcd_clock_scaling_prepare(hba);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* scale down the gear before scaling down clocks */
 	if (!scale_up) {
 		ret = ufshcd_scale_gear(hba, false);
 		if (ret)
-			goto out;
+			goto out_unprepare;
 	}
 
 	ret = ufshcd_scale_clks(hba, scale_up);
 	if (ret) {
 		if (!scale_up)
 			ufshcd_scale_gear(hba, true);
-		goto out;
+		goto out_unprepare;
 	}
 
 	/* scale up the gear after scaling up clocks */
 	if (scale_up) {
 		ret = ufshcd_scale_gear(hba, true);
-		if (ret) {
+		if (ret)
 			ufshcd_scale_clks(hba, false);
-			goto out;
-		}
 	}
 
-	ret = ufshcd_vops_clk_scale_notify(hba, scale_up, POST_CHANGE);
-
-out:
+out_unprepare:
 	ufshcd_clock_scaling_unprepare(hba);
+out:
 	ufshcd_release(hba);
 	return ret;
 }
@@ -6251,7 +6275,7 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/* scale up clocks to max frequency before full reinitialization */
-	ufshcd_scale_clks(hba, true);
+	ufshcd_set_clk_freq(hba, true);
 
 	err = ufshcd_hba_enable(hba);
 	if (err)
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

