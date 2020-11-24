Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA8BC2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 07:29:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F3EC206E5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 07:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbgKXH2l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 02:28:41 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:1905 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729915AbgKXH2k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2020 02:28:40 -0500
IronPort-SDR: 6OY8T7vt2+VeFjyrZfPs5CtGPxel/V9/om+gizMrETkT9taxkGk6NMmV+gGSIFQToKDxwAOL8t
 Li2e4HXX5o6QMwh31fi1auHNBLL+ZooUHBjlARCE9nCcBsFGCLmL1/bxR15Y15B7oiqZ6IIfdk
 +959n42WNMnvYG7JGncw0k6W0PNuVCytEG6DZ5gtw0ktUvarlFZINsDwcwvn53NKUwsPoM/0cy
 x8XjGC5Vp3XoviLH8UO1HdJH0Hrk6yGlmBOIG8/jKoAF7gqS8PCUO96oRf11W4tZHJF7Jv3yqL
 N8I=
X-IronPort-AV: E=Sophos;i="5.78,365,1599548400"; 
   d="scan'208";a="47507389"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 23 Nov 2020 23:28:40 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 23 Nov 2020 23:28:37 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 6F6AE2185E; Mon, 23 Nov 2020 23:28:37 -0800 (PST)
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
        Tomas Winkler <tomas.winkler@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/2] scsi: ufs: Refector ufshcd_setup_clocks() to remove skip_ref_clk
Date:   Mon, 23 Nov 2020 23:28:25 -0800
Message-Id: <1606202906-14485-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606202906-14485-1-git-send-email-cang@codeaurora.org>
References: <1606202906-14485-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the param skip_ref_clk from __ufshcd_setup_clocks(), but keep a flag
in struct ufs_clk_info to tell whether a clock can be disabled or not while
the link is active.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c |  2 ++
 drivers/scsi/ufs/ufshcd.c        | 25 +++++--------------------
 drivers/scsi/ufs/ufshcd.h        |  3 +++
 3 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 3db0af6..39b1f9b 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -92,6 +92,8 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 		clki->min_freq = clkfreq[i];
 		clki->max_freq = clkfreq[i+1];
 		clki->name = kstrdup(name, GFP_KERNEL);
+		if (!strcmp(name, "ref_clk"))
+			clki->always_on_while_link_active = true;
 		dev_dbg(dev, "%s: min %u max %u name %s\n", "freq-table-hz",
 				clki->min_freq, clki->max_freq, clki->name);
 		list_add_tail(&clki->list, &hba->clk_list_head);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a7857f6..0802c10 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -221,8 +221,6 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
 static int ufshcd_probe_hba(struct ufs_hba *hba, bool async);
-static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
-				 bool skip_ref_clk);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
 static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
@@ -1707,11 +1705,7 @@ static void ufshcd_gate_work(struct work_struct *work)
 
 	ufshcd_disable_irq(hba);
 
-	if (!ufshcd_is_link_active(hba))
-		ufshcd_setup_clocks(hba, false);
-	else
-		/* If link is active, device ref_clk can't be switched off */
-		__ufshcd_setup_clocks(hba, false, true);
+	ufshcd_setup_clocks(hba, false);
 
 	/*
 	 * In case you are here to cancel this work the gating state
@@ -7990,8 +7984,7 @@ static int ufshcd_init_hba_vreg(struct ufs_hba *hba)
 	return 0;
 }
 
-static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
-					bool skip_ref_clk)
+static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
 {
 	int ret = 0;
 	struct ufs_clk_info *clki;
@@ -8009,7 +8002,8 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 
 	list_for_each_entry(clki, head, list) {
 		if (!IS_ERR_OR_NULL(clki->clk)) {
-			if (skip_ref_clk && !strcmp(clki->name, "ref_clk"))
+			if (ufshcd_is_link_active(hba) &&
+			    clki->always_on_while_link_active)
 				continue;
 
 			clk_state_changed = on ^ clki->enabled;
@@ -8054,11 +8048,6 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 	return ret;
 }
 
-static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
-{
-	return  __ufshcd_setup_clocks(hba, on, false);
-}
-
 static int ufshcd_init_clocks(struct ufs_hba *hba)
 {
 	int ret = 0;
@@ -8577,11 +8566,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	 */
 	ufshcd_disable_irq(hba);
 
-	if (!ufshcd_is_link_active(hba))
-		ufshcd_setup_clocks(hba, false);
-	else
-		/* If link is active, device ref_clk can't be switched off */
-		__ufshcd_setup_clocks(hba, false, true);
+	ufshcd_setup_clocks(hba, false);
 
 	if (ufshcd_is_clkgating_allowed(hba)) {
 		hba->clk_gating.state = CLKS_OFF;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 66e5338..a06bdfb 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -229,6 +229,8 @@ struct ufs_dev_cmd {
  * @max_freq: maximum frequency supported by the clock
  * @min_freq: min frequency that can be used for clock scaling
  * @curr_freq: indicates the current frequency that it is set to
+ * @always_on_while_link_active: indicate that the clk should not be disabled if
+				 link is still active
  * @enabled: variable to check against multiple enable/disable
  */
 struct ufs_clk_info {
@@ -238,6 +240,7 @@ struct ufs_clk_info {
 	u32 max_freq;
 	u32 min_freq;
 	u32 curr_freq;
+	bool always_on_while_link_active;
 	bool enabled;
 };
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

