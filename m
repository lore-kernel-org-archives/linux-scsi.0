Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E8CC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 02:27:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24CB760FE9
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 02:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbhDZC1j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 22:27:39 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:5466 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbhDZC1g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 22:27:36 -0400
IronPort-SDR: LkIscuHhj8zitTHPBdEdjfpIpHOhhVaGsC5dBRfdyu7+BaVPgIdN77d3fn/zCI50I8xR239Y2D
 gpIhY0V6+0f0lex8WA0uBTQYfvwW+pL6zGWzxsg9pYRxVTK/ccWhTV1oruQSttm74seTqBKH0r
 gl/usqBH8kCR5mCm2x8BiJuLGRGiZ9v+j/ZgkCeVO//JzinbOzMzGeh3Lh7l8IF8AvUnnQ06Bx
 0ARpk0ujJiR/Z1BVusMrijQ2W1lcJpb0o3RTe2B+cPXor0Kqs4Bjc+E0OGW8bl+muGZQ2ol9JL
 pX4=
X-IronPort-AV: E=Sophos;i="5.82,251,1613462400"; 
   d="scan'208";a="29759457"
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by labrats.qualcomm.com with ESMTP; 25 Apr 2021 19:26:56 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 25 Apr 2021 19:26:55 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 5B2392113E; Sun, 25 Apr 2021 19:26:55 -0700 (PDT)
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
        Subhash Jadavani <subhashj@codeaurora.org>,
        Gilad Broner <gbroner@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 3/3] scsi: ufs: Narrow down fast pass in system suspend path
Date:   Sun, 25 Apr 2021 19:24:37 -0700
Message-Id: <1619403878-28330-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1619403878-28330-1-git-send-email-cang@codeaurora.org>
References: <1619403878-28330-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If spm_lvl is set to 0 or 1, when system suspend kicks start and hba is
runtime active, system suspend may just bail without doing anything (the
fast pass), leaving other contexts still running, e.g., clock gating and
clock scaling. When system resume kicks start, concurrency can happen btw
ufshcd_resume() and these contexts, leading to various stability issues.
Fix it by adding a check against hba's runtime status and allowing fast
pass only if hba is runtime suspended, otherwise let system suspend go
ahead call ufshcd_suspend(). This can guarantee that these contexts are
stopped by either runtime suspend or system suspend.

Fixes: 0b257734344aa ("scsi: ufs: optimize system suspend handling")
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 090b654..1fd965f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9060,7 +9060,8 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 
 	cancel_delayed_work_sync(&hba->rpm_dev_flush_recheck_work);
 
-	if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
+	if (pm_runtime_suspended(hba->dev) &&
+	    (ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
 	     hba->curr_dev_pwr_mode) &&
 	    (ufs_get_pm_lvl_to_link_pwr_state(hba->spm_lvl) ==
 	     hba->uic_link_state))
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

