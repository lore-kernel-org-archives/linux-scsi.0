Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D817FC1B0E3
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 02:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D06C2389F
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 02:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437874AbgLNCGf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Dec 2020 21:06:35 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:9322 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437850AbgLNCGf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Dec 2020 21:06:35 -0500
IronPort-SDR: dkjfAgX34W//Ji8Qi6V0kqvrXq9h1vxhzHKKPyZbAp1HNTyHzjUig6B61UHs+M39t9w4Xu+TYj
 JrXgQ6NyywfdZcrB+nzmdSXBIG9iKMAgMbCqbAkwBLkq8Ol6Ni1an+0YbhopjwYK4Wd8oYGvJQ
 E08uU1u+5ou7UpYhe7r5rxwItXvrRKQf8A8BqQGnh3xzRNmht3+OQ8dErY8rI4yDSL0/yOcWm8
 XcRv5kxrq2AwfkmKlw3iCRkmqxLUb9jyb5G0ioNQwulG07TZ6i5N+UUtTa3vp9IUoHUAxMUKSM
 RJg=
X-IronPort-AV: E=Sophos;i="5.78,417,1599548400"; 
   d="scan'208";a="29359144"
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by labrats.qualcomm.com with ESMTP; 13 Dec 2020 18:05:54 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg05-sd.qualcomm.com with ESMTP; 13 Dec 2020 18:05:53 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 628B92123A; Sun, 13 Dec 2020 18:05:53 -0800 (PST)
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
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/1] scsi: ufs: Fix a possible NULL pointer issue
Date:   Sun, 13 Dec 2020 18:05:47 -0800
Message-Id: <1607911551-18101-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During system resume/suspend, hba could be NULL. In this case, do not touch
eh_sem.

Fixes: 88a92d6ae4fe ("scsi: ufs: Serialize eh_work with system PM events and async scan")

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c1c401b..140394a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8883,9 +8883,13 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	int ret = 0;
 	ktime_t start = ktime_get();
 
-	down(&hba->eh_sem);
-	if (!hba || !hba->is_powered)
+	if (!hba)
+		return 0;
+
+	if (!hba->is_powered) {
+		down(&hba->eh_sem);
 		return 0;
+	}
 
 	if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
 	     hba->curr_dev_pwr_mode) &&
@@ -8932,10 +8936,8 @@ int ufshcd_system_resume(struct ufs_hba *hba)
 	int ret = 0;
 	ktime_t start = ktime_get();
 
-	if (!hba) {
-		up(&hba->eh_sem);
+	if (!hba)
 		return -EINVAL;
-	}
 
 	if (!hba->is_powered || pm_runtime_suspended(hba->dev))
 		/*
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

