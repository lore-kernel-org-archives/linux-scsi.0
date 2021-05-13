Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F8CC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 05:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECD4F61422
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 05:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhEMF50 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 01:57:26 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:1857 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbhEMF5P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 01:57:15 -0400
IronPort-SDR: qGa9atKjyh3b9cwt1JCzVEqal8nauOC4iq9VUNBptPpTf61wXm+kHSN9wfyJg2YETEgl8quRCl
 p6tLT1pNaddJonuBHL1Ad3SWCSQ71Z7VzqCg30CSQV32Rdbsd7fbXuIYvuAn0vgTtO+HXZNxoO
 j/uKPM3RgmxmZLCgV8j8C5E/bRdwle20Jcbcr64lXWqJ/HkLK9K8N4qzbBLstQMm54TbPXaN93
 eFS1jKGclkzVhi/jB2QMx0qSBb8rrxEMdtVoVmUsu64JJ7xVNTLra6+eFwNK49cNWtVZgYpJzh
 PjI=
X-IronPort-AV: E=Sophos;i="5.82,296,1613462400"; 
   d="scan'208";a="47866514"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 12 May 2021 22:56:05 -0700
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 12 May 2021 22:56:04 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 1B6CE21A85; Wed, 12 May 2021 22:56:04 -0700 (PDT)
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
Subject: [PATCH v1 5/6] scsi: ufs: Let host_sem cover the entire system suspend/resume
Date:   Wed, 12 May 2021 22:55:18 -0700
Message-Id: <1620885319-15151-7-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620885319-15151-1-git-send-email-cang@codeaurora.org>
References: <1620885319-15151-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS error handling now is doing more than just re-probing, but also sending
scsi cmds, e.g., for clearing UACs, and recovering runtime PM error, which
may change runtime status of scsi devices. To protect system suspend/resume
from being disturbed by error handling, move the host_sem from wl pm ops
to ufshcd_suspend_prepare() and ufshcd_resume_complete().

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 631c5f8..a6313cf40 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8991,16 +8991,13 @@ static int ufshcd_wl_suspend(struct device *dev)
 	ktime_t start = ktime_get();
 
 	hba = shost_priv(sdev->host);
-	down(&hba->host_sem);
 
 	if (pm_runtime_suspended(dev))
 		goto out;
 
 	ret = __ufshcd_wl_suspend(hba, UFS_SYSTEM_PM);
-	if (ret) {
+	if (ret)
 		dev_err(&sdev->sdev_gendev, "%s failed: %d\n", __func__,  ret);
-		up(&hba->host_sem);
-	}
 
 out:
 	if (!ret)
@@ -9033,7 +9030,6 @@ static int ufshcd_wl_resume(struct device *dev)
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
 	if (!ret)
 		hba->is_wl_sys_suspended = false;
-	up(&hba->host_sem);
 	return ret;
 }
 #endif
@@ -9600,6 +9596,7 @@ void ufshcd_resume_complete(struct device *dev)
 		ufshcd_rpmb_rpm_put(hba);
 		hba->rpmb_complete_put = false;
 	}
+	up(&hba->host_sem);
 }
 EXPORT_SYMBOL_GPL(ufshcd_resume_complete);
 
@@ -9626,6 +9623,7 @@ int ufshcd_suspend_prepare(struct device *dev)
 		ufshcd_rpmb_rpm_get_sync(hba);
 		hba->rpmb_complete_put = true;
 	}
+	down(&hba->host_sem);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ufshcd_suspend_prepare);
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

