Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C9A0C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 08:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37BB761153
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 08:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhEXItH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 04:49:07 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:4217 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhEXItG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 04:49:06 -0400
IronPort-SDR: /cf1ow8DPZULsbs7lTFz0h2kJm4F0mCcRlfCZ0iy9QIj+9AXNDOcMbbmkSdn02IKlB80VTS5d9
 1zy6AIjS6dBZ1qkLsUWdGOKTxPC7mMudbwlfwosL5zfdhvqbzGYWUUwyprhKeud1xeMlomI/e5
 EGb6OpuAw+84EYzzvGxFqDNU0Zn9gcXv+libIMPrZImieX/oksiSbj61oDUjCOG2abFZXo3SwU
 XTBlAuKTOm5d+Fuc8/SSroUbuBMwWUJ+8yPxDTA/SNYsUGB36+UhWI3dAHf1ho9bvMJFv3ue/v
 sDY=
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="29772335"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 24 May 2021 01:47:39 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 24 May 2021 01:47:39 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 0937E21AD7; Mon, 24 May 2021 01:47:39 -0700 (PDT)
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
Subject: [PATCH v2 2/6] scsi: ufs: Update the return value of supplier pm ops
Date:   Mon, 24 May 2021 01:47:21 -0700
Message-Id: <1621846046-22204-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621846046-22204-1-git-send-email-cang@codeaurora.org>
References: <1621846046-22204-1-git-send-email-cang@codeaurora.org>
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
index 3836a0a..809d0cb 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8912,7 +8912,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		ufshcd_release(hba);
 	}
 	hba->wl_pm_op_in_progress = false;
-	return ret;
+	return ret <= 0 ? ret : -EINVAL;
 }
 
 static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
@@ -8999,7 +8999,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	hba->clk_gating.is_suspended = false;
 	ufshcd_release(hba);
 	hba->wl_pm_op_in_progress = false;
-	return ret;
+	return ret <= 0 ? ret : -EINVAL;
 }
 
 static int ufshcd_wl_runtime_suspend(struct device *dev)
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

