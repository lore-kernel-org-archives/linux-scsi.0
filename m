Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5DD5C48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:37:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA213611AC
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhFWHj3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 03:39:29 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:1336 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbhFWHjO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 03:39:14 -0400
IronPort-SDR: yr2W6pfUiVo9FEI9d2LqouW+cLcrY70qPmPHgWIsWYCxe8stBc0y0UEH0UdHQ9eMYvjAx1jeEg
 hUifsXn6Gy99tgmRx4fe/etgVmLeo1v7cGtp5nWmvJ/WzWJ7YFtOcRCWEwddak0/d7ecz51koE
 c44gT3jo8joKPPubAlY1tT4HY4azvE71aYYDfLoTO5VIT/aQioZ28vbww213WQcp0b2+lgYDEa
 0k4iCBGetTg2A66hQhptH2yswW89leyNmPh9c0OLmaAKnOnWKEqPIiDNGWNtd2sIIaRQHBBch0
 MVk=
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="29780819"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 23 Jun 2021 00:36:56 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 23 Jun 2021 00:36:56 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 1B06421BE2; Wed, 23 Jun 2021 00:36:56 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
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
Subject: [PATCH v4 03/10] scsi: ufs: Update the return value of supplier pm ops
Date:   Wed, 23 Jun 2021 00:35:02 -0700
Message-Id: <1624433711-9339-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

rpm_get_suppliers() is returning an error only if the error is negative.
However, ufshcd_wl_resume() may return a positive error code, e.g., when
hibern8 or SSU cmd fails. Make the positive return value a negative error
code so that consumers are aware of any resume failure from their supplier.
Make the same change to ufshcd_wl_suspend() just to keep symmetry.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index abe5f2d..ee70522 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8922,7 +8922,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		ufshcd_release(hba);
 	}
 	hba->wlu_pm_op_in_progress = false;
-	return ret;
+	return ret <= 0 ? ret : -EINVAL;
 }
 
 static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
@@ -9009,7 +9009,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	hba->clk_gating.is_suspended = false;
 	ufshcd_release(hba);
 	hba->wlu_pm_op_in_progress = false;
-	return ret;
+	return ret <= 0 ? ret : -EINVAL;
 }
 
 static int ufshcd_wl_runtime_suspend(struct device *dev)
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

