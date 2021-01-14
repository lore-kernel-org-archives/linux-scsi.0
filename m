Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 414E0C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 03:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02F0F2343F
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 03:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbhANDOa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 22:14:30 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:34373 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbhANDO3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 22:14:29 -0500
IronPort-SDR: L+ZCJcCj9SCwDytXmebOvFTTkQcMJY6ZuXqN/QcKJW+ZXH3P97aNY4wcGlY9T3o06x/ipiRwSI
 FcNzBadLc15j1JY/J8O2EAEG85ZJNfp2hwWpC0v6BEJEsLGyi4drekeq6e/i6zEI21Qjvx2Znh
 TU5RMMSVk+uDor1V9Os50LbokCeItMhUeRsQJeiZkgvAznCU/o8LZBqb1AJIyf6RnDFusftmqg
 RDT1w+N5AccQg1mz5eraFPNZWVxJn6lmWBoqi+35Aql2EzDw1bWKVrf5R2QhuwEXbmdqmXWaih
 Tmc=
X-IronPort-AV: E=Sophos;i="5.79,346,1602572400"; 
   d="scan'208";a="29539977"
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by labrats.qualcomm.com with ESMTP; 13 Jan 2021 19:13:38 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 13 Jan 2021 19:13:36 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 916BE216AD; Wed, 13 Jan 2021 19:13:36 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH v5 1/2] scsi: ufs: Fix a possible NULL pointer issue
Date:   Wed, 13 Jan 2021 19:13:27 -0800
Message-Id: <1610594010-7254-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1610594010-7254-1-git-send-email-cang@codeaurora.org>
References: <1610594010-7254-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During system resume/suspend, hba could be NULL. In this case, do not touch
eh_sem.

Fixes: 88a92d6ae4fe ("scsi: ufs: Serialize eh_work with system PM events and async scan")

Acked-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 53fd59c..969aed9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -94,6 +94,8 @@
 		       16, 4, buf, __len, false);                        \
 } while (0)
 
+static bool early_suspend;
+
 int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
 		     const char *prefix)
 {
@@ -8953,8 +8955,14 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	int ret = 0;
 	ktime_t start = ktime_get();
 
+	if (!hba) {
+		early_suspend = true;
+		return 0;
+	}
+
 	down(&hba->eh_sem);
-	if (!hba || !hba->is_powered)
+
+	if (!hba->is_powered)
 		return 0;
 
 	if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
@@ -9002,9 +9010,12 @@ int ufshcd_system_resume(struct ufs_hba *hba)
 	int ret = 0;
 	ktime_t start = ktime_get();
 
-	if (!hba) {
-		up(&hba->eh_sem);
+	if (!hba)
 		return -EINVAL;
+
+	if (unlikely(early_suspend)) {
+		early_suspend = false;
+		down(&hba->eh_sem);
 	}
 
 	if (!hba->is_powered || pm_runtime_suspended(hba->dev))
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

