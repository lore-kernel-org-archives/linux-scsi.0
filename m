Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 703C0C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 05:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DAB161422
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 05:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhEMF5B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 01:57:01 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:35000 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbhEMF5A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 01:57:00 -0400
IronPort-SDR: 5sPPrIy/BC4+TLYPPFESN2mZiu4m77vCObLWUq2yfYNLnr9YlfBcZXf9h6fxQOI7Hf6xJsoep+
 tC8Aho9d/Lvywzv96T0SenodRdz+aOYfTLPXe/UkaA+1aYYRL53siRIr402whGqMvrKgVwfEa/
 p7LqUoau2+TJ/Ce0jWMU6Eck7uVw3vVNO2vWyyPJ/7s0DctOgYIN/OGbUYwa0xI1vJNFx8dXqp
 8dQNse9GhvT4UxluQ9EtS/ya/MHuniiQHt60bZW8rU08ekzMJUQpABJ/K34rA7VH/2gowiEQjj
 gpk=
X-IronPort-AV: E=Sophos;i="5.82,296,1613462400"; 
   d="scan'208";a="29767596"
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by labrats.qualcomm.com with ESMTP; 12 May 2021 22:55:50 -0700
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg05-sd.qualcomm.com with ESMTP; 12 May 2021 22:55:50 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 3432921A85; Wed, 12 May 2021 22:55:50 -0700 (PDT)
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
Subject: [PATCH v1 2/6] scsi: ufs: Update the return value of supplier pm ops
Date:   Wed, 12 May 2021 22:55:15 -0700
Message-Id: <1620885319-15151-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620885319-15151-1-git-send-email-cang@codeaurora.org>
References: <1620885319-15151-1-git-send-email-cang@codeaurora.org>
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
index c69602b..41205d1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8847,7 +8847,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		ufshcd_release(hba);
 	}
 	hba->wl_pm_op_in_progress = false;
-	return ret;
+	return ret <= 0 ? ret : -EINVAL;
 }
 
 static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
@@ -8934,7 +8934,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	hba->clk_gating.is_suspended = false;
 	ufshcd_release(hba);
 	hba->wl_pm_op_in_progress = false;
-	return ret;
+	return ret <= 0 ? ret : -EINVAL;
 }
 
 static int ufshcd_wl_runtime_suspend(struct device *dev)
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

