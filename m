Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F08C63777
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 01:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72113221FB
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 01:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392174AbgK0B66 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 20:58:58 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:9517 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727441AbgK0B66 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 20:58:58 -0500
IronPort-SDR: YqWQHFxxWyhCXue7wDKjcy2Jsgl//SfzvwokYNn6DzM7zzb077SqOqUiBWTk0W3aF/SRrn3CNj
 qcJQFRciJBKFJbCnJ0ZV5MyhekNzU+zlaxvu0WMvXIA+pudSHaTUsaqbOFmewutRKQHQI0HkPK
 iOolkEKPYDIBeTC4oRSP+Iju7m8Kj/kGJmcMHujK8hTcV9j7EbszCPGb6qTmyNwCniXzucma15
 vFFOkFK9gN0QFUkpqMxylvjAsW2LG3yUnrP1JybKtDwQ3YX7wBqw2jmTrLa5gJ935n38Ynv9ls
 Q7g=
X-IronPort-AV: E=Sophos;i="5.78,373,1599548400"; 
   d="scan'208";a="29304738"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 26 Nov 2020 17:58:57 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 26 Nov 2020 17:58:56 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 284A521864; Thu, 26 Nov 2020 17:58:56 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/1] scsi: ufs: Remove scale down gear hard code
Date:   Thu, 26 Nov 2020 17:58:48 -0800
Message-Id: <1606442334-22641-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of making the scale down gear a hard code, make it a member of
ufs_clk_scaling struct.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
 drivers/scsi/ufs/ufshcd.h |  2 ++
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 44254c9..1789df3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1100,7 +1100,6 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
  */
 static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
 {
-	#define UFS_MIN_GEAR_TO_SCALE_DOWN	UFS_HS_G1
 	int ret = 0;
 	struct ufs_pa_layer_attr new_pwr_info;
 
@@ -1111,16 +1110,16 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
 		memcpy(&new_pwr_info, &hba->pwr_info,
 		       sizeof(struct ufs_pa_layer_attr));
 
-		if (hba->pwr_info.gear_tx > UFS_MIN_GEAR_TO_SCALE_DOWN
-		    || hba->pwr_info.gear_rx > UFS_MIN_GEAR_TO_SCALE_DOWN) {
+		if (hba->pwr_info.gear_tx > hba->clk_scaling.min_gear ||
+		    hba->pwr_info.gear_rx > hba->clk_scaling.min_gear) {
 			/* save the current power mode */
 			memcpy(&hba->clk_scaling.saved_pwr_info.info,
 				&hba->pwr_info,
 				sizeof(struct ufs_pa_layer_attr));
 
 			/* scale down gear */
-			new_pwr_info.gear_tx = UFS_MIN_GEAR_TO_SCALE_DOWN;
-			new_pwr_info.gear_rx = UFS_MIN_GEAR_TO_SCALE_DOWN;
+			new_pwr_info.gear_tx = hba->clk_scaling.min_gear;
+			new_pwr_info.gear_rx = hba->clk_scaling.min_gear;
 		}
 	}
 
@@ -1824,6 +1823,9 @@ static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
 
+	if (!hba->clk_scaling.min_gear)
+		hba->clk_scaling.min_gear = UFS_HS_G1;
+
 	INIT_WORK(&hba->clk_scaling.suspend_work,
 		  ufshcd_clk_scaling_suspend_work);
 	INIT_WORK(&hba->clk_scaling.resume_work,
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 6f0f2d4..bdab23e 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -385,6 +385,7 @@ struct ufs_saved_pwr_info {
  * @workq: workqueue to schedule devfreq suspend/resume work
  * @suspend_work: worker to suspend devfreq
  * @resume_work: worker to resume devfreq
+ * @min_gear: lowest HS gear to scale down to
  * @is_allowed: tracks if scaling is currently allowed or not
  * @is_busy_started: tracks if busy period has started or not
  * @is_suspended: tracks if devfreq is suspended or not
@@ -399,6 +400,7 @@ struct ufs_clk_scaling {
 	struct workqueue_struct *workq;
 	struct work_struct suspend_work;
 	struct work_struct resume_work;
+	u32 min_gear;
 	bool is_allowed;
 	bool is_busy_started;
 	bool is_suspended;
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

