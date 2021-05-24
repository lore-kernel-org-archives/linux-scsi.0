Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0751FC04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 08:48:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDB2061153
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 08:48:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhEXItb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 04:49:31 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:2199 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbhEXItW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 04:49:22 -0400
IronPort-SDR: 8JAQqg7qGTINxB9+J5SrY4UaW1sizO8+7wfumfx3jWTl9Y0IM+pt+Z1SNex1hixEuqueCzdzDV
 I1V+dGw8ts1JwyiYg3t+Jtr4quBZEEwPXuQKj+kTdqUulKBdoIbeqhoDW2MQ59Lqiw30ibaCvg
 wGcAVLfEdH4x+0XFYNV+9nj5mE8UWImdnKw5hhOll7cQU7iKpuakQA0hcwDQUbUzvJ0oq5gGC4
 jGFk3EHr1kXFMgK/vgfRgV9rcZu0sSHO0W+z24LmgKCGUDASBlpCnNyI+qYlym9Uf9FtZeXfZe
 VVo=
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="47877521"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 24 May 2021 01:47:52 -0700
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 24 May 2021 01:47:51 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 364CF21AD7; Mon, 24 May 2021 01:47:51 -0700 (PDT)
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
Subject: [PATCH v2 5/6] scsi: ufs: Let host_sem cover the entire system suspend/resume
Date:   Mon, 24 May 2021 01:47:24 -0700
Message-Id: <1621846046-22204-6-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621846046-22204-1-git-send-email-cang@codeaurora.org>
References: <1621846046-22204-1-git-send-email-cang@codeaurora.org>
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
index 5e6e3ac..9a3bc04 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9057,16 +9057,13 @@ static int ufshcd_wl_suspend(struct device *dev)
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
@@ -9099,7 +9096,6 @@ static int ufshcd_wl_resume(struct device *dev)
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
 	if (!ret)
 		hba->is_wl_sys_suspended = false;
-	up(&hba->host_sem);
 	return ret;
 }
 #endif
@@ -9666,6 +9662,7 @@ void ufshcd_resume_complete(struct device *dev)
 		ufshcd_rpmb_rpm_put(hba);
 		hba->rpmb_complete_put = false;
 	}
+	up(&hba->host_sem);
 }
 EXPORT_SYMBOL_GPL(ufshcd_resume_complete);
 
@@ -9692,6 +9689,7 @@ int ufshcd_suspend_prepare(struct device *dev)
 		ufshcd_rpmb_rpm_get_sync(hba);
 		hba->rpmb_complete_put = true;
 	}
+	down(&hba->host_sem);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ufshcd_suspend_prepare);
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

