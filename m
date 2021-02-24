Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 273F9C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 05:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEB6664DFF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 05:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbhBXFhx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 00:37:53 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:1972 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbhBXFhs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 00:37:48 -0500
IronPort-SDR: zzIvBKeiGTZTxtUBNqoziZ2hlmFPpqUeIHAqQ7H29aYzlNXlkcK678EVVLtlOGN7hGU40rXhiK
 aX8DMkIgjgmS4Krn8acNRT529JOyVbr6cR4k/22VXWoxJaR6N/Z2XRwtGJgEI80ufKnET668iQ
 kEr6oeKVgEZkdCQhpLlhbqL2LJLSB8B6+08mNgQ7TVIQCfPzV1iQagUAxHd8GpaMDqn9cM4UmL
 W8rcL9f6xrkIIDzPI3quMf0msBfKJ7CtAzGbTLOcWsuwZ0Gos8nXw43bwDdOPZWT8eAlXddaXp
 WVk=
X-IronPort-AV: E=Sophos;i="5.81,201,1610438400"; 
   d="scan'208";a="47788278"
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by labrats.qualcomm.com with ESMTP; 23 Feb 2021 21:37:05 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg01-sd.qualcomm.com with ESMTP; 23 Feb 2021 21:37:03 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id E3BDD21A10; Tue, 23 Feb 2021 21:37:03 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 3/3] scsi: ufs: Remove redundant checks of !hba in suspend/resume callbacks
Date:   Tue, 23 Feb 2021 21:36:49 -0800
Message-Id: <1614145010-36079-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614145010-36079-1-git-send-email-cang@codeaurora.org>
References: <1614145010-36079-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Runtime and system suspend/resume can only come after hba probe invokes
platform_set_drvdata(pdev, hba), meaning hba cannot be NULL in these PM
callbacks, so remove the checks of !hba.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 013eb73..2517ef1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -95,8 +95,6 @@
 		       16, 4, buf, __len, false);                        \
 } while (0)
 
-static bool early_suspend;
-
 int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
 		     const char *prefix)
 {
@@ -8978,11 +8976,6 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	int ret = 0;
 	ktime_t start = ktime_get();
 
-	if (!hba) {
-		early_suspend = true;
-		return 0;
-	}
-
 	down(&hba->host_sem);
 
 	if (!hba->is_powered)
@@ -9034,14 +9027,6 @@ int ufshcd_system_resume(struct ufs_hba *hba)
 	int ret = 0;
 	ktime_t start = ktime_get();
 
-	if (!hba)
-		return -EINVAL;
-
-	if (unlikely(early_suspend)) {
-		early_suspend = false;
-		down(&hba->host_sem);
-	}
-
 	if (!hba->is_powered || pm_runtime_suspended(hba->dev))
 		/*
 		 * Let the runtime resume take care of resuming
@@ -9074,9 +9059,6 @@ int ufshcd_runtime_suspend(struct ufs_hba *hba)
 	int ret = 0;
 	ktime_t start = ktime_get();
 
-	if (!hba)
-		return -EINVAL;
-
 	if (!hba->is_powered)
 		goto out;
 	else
@@ -9115,9 +9097,6 @@ int ufshcd_runtime_resume(struct ufs_hba *hba)
 	int ret = 0;
 	ktime_t start = ktime_get();
 
-	if (!hba)
-		return -EINVAL;
-
 	if (!hba->is_powered)
 		goto out;
 	else
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

