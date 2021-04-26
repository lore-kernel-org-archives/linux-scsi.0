Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DE7FC43460
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 02:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE1B860FE9
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 02:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhDZC1e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 22:27:34 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:5466 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbhDZC1c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 22:27:32 -0400
IronPort-SDR: yZaRuUNy7jrssaWn9DzpOjEla7R3Q1WaxFMlQuT27KcrIfE7XR7SGjrZEjghMIagbLO623A2Ek
 n3UDYrlQfkarkvoAcv65KrPgLRy1kb16WGiNtfeOF5SnueIV71M4J4BB4ZE2aLjssRuxLXo2mH
 ZFKngTqD0oBYWuxoaxotswU9eEiE2Ydx2rdoqFOdVGNGePcFUibdmCReZtcWcxxxUz6ExopBOj
 0vct5yJFasQpdsQxLkzP9+Ty9acx+UkDkTTfASfoTdqO90ViI+MH32wFZnYCWUpIrWx3Cjeuma
 4KU=
X-IronPort-AV: E=Sophos;i="5.82,251,1613462400"; 
   d="scan'208";a="29759456"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 25 Apr 2021 19:26:52 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 25 Apr 2021 19:26:51 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id A4B292113E; Sun, 25 Apr 2021 19:26:51 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, ziqichen@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 2/3] scsi: ufs: Cancel rpm_dev_flush_recheck_work during system suspend
Date:   Sun, 25 Apr 2021 19:24:36 -0700
Message-Id: <1619403878-28330-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1619403878-28330-1-git-send-email-cang@codeaurora.org>
References: <1619403878-28330-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During ufs system suspend, leaving rpm_dev_flush_recheck_work running or
pending is risky, because concurrency may happen btw system suspend/resume
and runtime resume routine. Fix it by cancelling rpm_dev_flush_recheck_work
synchronously during system suspend.

Fixes: 1d53864c3617f5235f891ca0fbe9347c4cd35d46 ("scsi: ufs: Fix possible power drain during system suspend")
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7ab6b12..090b654 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9058,11 +9058,12 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	if (!hba->is_powered)
 		return 0;
 
+	cancel_delayed_work_sync(&hba->rpm_dev_flush_recheck_work);
+
 	if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
 	     hba->curr_dev_pwr_mode) &&
 	    (ufs_get_pm_lvl_to_link_pwr_state(hba->spm_lvl) ==
-	     hba->uic_link_state) &&
-	     !hba->dev_info.b_rpm_dev_flush_capable)
+	     hba->uic_link_state))
 		goto out;
 
 	if (pm_runtime_suspended(hba->dev)) {
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

