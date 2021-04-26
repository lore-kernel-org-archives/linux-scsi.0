Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C4DC43460
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8EF461152
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhDZDtv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:49:51 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:5837 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbhDZDtv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:49:51 -0400
IronPort-SDR: 8HxJbIwCH5tOuGTh8QNxHXSsu6ez7b5G4tX3+h5H3KJhaYYiIwFWgigf/vUWy8D04vXTZKmwOk
 zCzXP8zGSkDd/NgBOtRO364rckk2ngqvQ1SCPZeJVHO2k25F6nmtqzBRMNGOFXKWBh7IDyOd8J
 NaZIzfLP74otDpll3Z7OS4KxYeuop9ozX4SxsxUNhneMHZ+Eo0S2sJr0E55wVUQo6t4vCCiNKb
 9HO0Te9MYTpmzaZo72bGkFN/6CmQo9ZxZJsyUKKRNp4/kcs/s7zmynKkzZlJtPEb9WTrshYnSN
 Luw=
X-IronPort-AV: E=Sophos;i="5.82,251,1613462400"; 
   d="scan'208";a="47849242"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 25 Apr 2021 20:49:10 -0700
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 25 Apr 2021 20:49:09 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 933442121E; Sun, 25 Apr 2021 20:49:09 -0700 (PDT)
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
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/3] scsi: ufs: Cancel rpm_dev_flush_recheck_work during system suspend
Date:   Sun, 25 Apr 2021 20:48:39 -0700
Message-Id: <1619408921-30426-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1619408921-30426-1-git-send-email-cang@codeaurora.org>
References: <1619408921-30426-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During ufs system suspend, leaving rpm_dev_flush_recheck_work running or
pending is risky, because concurrency may happen btw system suspend/resume
and runtime resume routine. Fix it by cancelling rpm_dev_flush_recheck_work
synchronously during system suspend.

Fixes: 51dd905bd2f61 ("scsi: ufs: Fix WriteBooster flush during runtime suspend")
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 28501bb..a2f9c8e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9044,6 +9044,8 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	if (!hba->is_powered)
 		return 0;
 
+	cancel_delayed_work_sync(&hba->rpm_dev_flush_recheck_work);
+
 	if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
 	     hba->curr_dev_pwr_mode) &&
 	    (ufs_get_pm_lvl_to_link_pwr_state(hba->spm_lvl) ==
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

