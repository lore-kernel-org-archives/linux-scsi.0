Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3836C6379F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 05:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1476206FB
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 05:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgKXFFP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 00:05:15 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:6985 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgKXFFO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2020 00:05:14 -0500
IronPort-SDR: YuD+uhDPbcBkWH4V/B/ZsrKuO5v+4EaFPWEWcBQN1CDUyttVWDIdPs+eplxSayUaOg1LwAaM5J
 0JGnuUW7iVvlphQeSSKzm6blxtobQLiqs/ReOkt7A3VJwbuywiNpQds8Cwvr6iG1ueP0PfiYUo
 rwxxe3KKl9d5SgIoX9jh+MFhIamwvoNaW+0DA07HnO/diFaNoUGvSkAqqOet/wcej92RI0nJS4
 qreqUGaH4K+CTsKCKwzkr5PUvB6hzPXMV2TsW1uERT+gUubidAQ1ROT59wfpkDpzkriL7BQuID
 89c=
X-IronPort-AV: E=Sophos;i="5.78,365,1599548400"; 
   d="scan'208";a="29298269"
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by labrats.qualcomm.com with ESMTP; 23 Nov 2020 21:05:14 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg01-sd.qualcomm.com with ESMTP; 23 Nov 2020 21:05:13 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 8082C21855; Mon, 23 Nov 2020 21:05:13 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: ufs: Don't disable core_clk_unipro if the link is active
Date:   Mon, 23 Nov 2020 21:05:08 -0800
Message-Id: <1606194312-25378-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we want to disable clocks but still keep the link active, both ref_clk
and core_clk_unipro should be skipped.

Signed-off-by: Can Guo <cang@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a7857f6..69c2e91 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -222,7 +222,7 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
 static int ufshcd_probe_hba(struct ufs_hba *hba, bool async);
 static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
-				 bool skip_ref_clk);
+				 bool keep_link_active);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
 static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
@@ -1710,7 +1710,6 @@ static void ufshcd_gate_work(struct work_struct *work)
 	if (!ufshcd_is_link_active(hba))
 		ufshcd_setup_clocks(hba, false);
 	else
-		/* If link is active, device ref_clk can't be switched off */
 		__ufshcd_setup_clocks(hba, false, true);
 
 	/*
@@ -7991,7 +7990,7 @@ static int ufshcd_init_hba_vreg(struct ufs_hba *hba)
 }
 
 static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
-					bool skip_ref_clk)
+					bool keep_link_active)
 {
 	int ret = 0;
 	struct ufs_clk_info *clki;
@@ -8009,7 +8008,13 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 
 	list_for_each_entry(clki, head, list) {
 		if (!IS_ERR_OR_NULL(clki->clk)) {
-			if (skip_ref_clk && !strcmp(clki->name, "ref_clk"))
+			/*
+			 * To keep link active, ref_clk and core_clk_unipro
+			 * should be kept ON.
+			 */
+			if (keep_link_active &&
+			    (!strcmp(clki->name, "ref_clk") ||
+			     !strcmp(clki->name, "core_clk_unipro")))
 				continue;
 
 			clk_state_changed = on ^ clki->enabled;
@@ -8580,7 +8585,6 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (!ufshcd_is_link_active(hba))
 		ufshcd_setup_clocks(hba, false);
 	else
-		/* If link is active, device ref_clk can't be switched off */
 		__ufshcd_setup_clocks(hba, false, true);
 
 	if (ufshcd_is_clkgating_allowed(hba)) {
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

