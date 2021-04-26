Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8665FC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 690E561163
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbhDZDt4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:49:56 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:3644 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbhDZDty (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:49:54 -0400
IronPort-SDR: Mz0+g2QATWyjFtvhcy8T3ikHAIlypk/4nWXTqPRGKEUjAehJFv8TP0tBqGjQ5u+FhitYFXnPqb
 omq43wHwiZQ3SrFOUF9mXMHSB78jWteRMOC4p/9u+1gENnPugcB8p9F6mGdeWdqNNWoY7/xwDA
 L4tgEre/CXBy1eWPJnlSg4DAcsI6hWB40zj/WR41PrE9P2eSp4sVPUxId+vLDXEGrr5YMv26ez
 UaZOB6QOwgeicW8Zf7W+5RJuNRfN6PLZVWYItaxq0s4WawENLoS7i6PJ4/t21QgD6Lf/nwg9Ov
 YKc=
X-IronPort-AV: E=Sophos;i="5.82,251,1613462400"; 
   d="scan'208";a="29759517"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 25 Apr 2021 20:49:13 -0700
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 25 Apr 2021 20:49:13 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 3E4642121E; Sun, 25 Apr 2021 20:49:13 -0700 (PDT)
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
        Gilad Broner <gbroner@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 3/3] scsi: ufs: Narrow down fast pass in system suspend path
Date:   Sun, 25 Apr 2021 20:48:40 -0700
Message-Id: <1619408921-30426-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1619408921-30426-1-git-send-email-cang@codeaurora.org>
References: <1619408921-30426-1-git-send-email-cang@codeaurora.org>
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
 drivers/scsi/ufs/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a2f9c8e..c480f88 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9050,6 +9050,7 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	     hba->curr_dev_pwr_mode) &&
 	    (ufs_get_pm_lvl_to_link_pwr_state(hba->spm_lvl) ==
 	     hba->uic_link_state) &&
+	     pm_runtime_suspended(hba->dev) &&
 	     !hba->dev_info.b_rpm_dev_flush_capable)
 		goto out;
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

