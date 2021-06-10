Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17FE8C47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01AF160FEF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFJEqX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 00:46:23 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:10071 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhFJEqW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 00:46:22 -0400
IronPort-SDR: jotiyUclQrVrtpwZwn2WtillfYGqVfOIO78rVhdw/eCjOS4N6HbAky4c/KrgKGFSTs9bTSX+aW
 EdCfJxiFQQuyNuJxR4t0sNRw8k6RlW0cslRBb+6+rAT+m7YOk7tlicH2hGPQPZ/NdAZb7qlCy/
 fu1+7Y7V+fXXXu59R8erIui4jKxEYjcY9GduOfE/UFEKyKMoJzNzH8gXv1ElZocMPt3nOD7go1
 npt/7KIKcuNL7ObbRHu7YTFAKAWgjviTMxE0uBl2/Rb1gEAp0RwqOfGtTQGsCRSKtqJf9TBUTG
 aW8=
X-IronPort-AV: E=Sophos;i="5.83,262,1616482800"; 
   d="scan'208";a="29778431"
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by labrats.qualcomm.com with ESMTP; 09 Jun 2021 21:44:26 -0700
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg01-sd.qualcomm.com with ESMTP; 09 Jun 2021 21:44:25 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id AFCF921AF7; Wed,  9 Jun 2021 21:44:25 -0700 (PDT)
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
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 7/9] scsi: ufs: Let host_sem cover the entire system suspend/resume
Date:   Wed,  9 Jun 2021 21:43:35 -0700
Message-Id: <1623300218-9454-8-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
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
 drivers/scsi/ufs/ufshcd.h | 2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c418a19..861942b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9060,16 +9060,13 @@ static int ufshcd_wl_suspend(struct device *dev)
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
@@ -9102,7 +9099,6 @@ static int ufshcd_wl_resume(struct device *dev)
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
 	if (!ret)
 		hba->is_wl_sys_suspended = false;
-	up(&hba->host_sem);
 	return ret;
 }
 #endif
@@ -9665,6 +9661,7 @@ void ufshcd_resume_complete(struct device *dev)
 		ufshcd_rpmb_rpm_put(hba);
 		hba->rpmb_complete_put = false;
 	}
+	up(&hba->host_sem);
 }
 EXPORT_SYMBOL_GPL(ufshcd_resume_complete);
 
@@ -9691,6 +9688,7 @@ int ufshcd_suspend_prepare(struct device *dev)
 		ufshcd_rpmb_rpm_get_sync(hba);
 		hba->rpmb_complete_put = true;
 	}
+	down(&hba->host_sem);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ufshcd_suspend_prepare);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index eaebb4e..47da47c 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -693,7 +693,7 @@ struct ufs_hba_monitor {
  * @ee_ctrl_mask: Exception event control mask
  * @is_powered: flag to check if HBA is powered
  * @shutting_down: flag to check if shutdown has been invoked
- * @host_sem: semaphore used to serialize concurrent contexts
+ * @host_sem: semaphore used to avoid concurrency of contexts
  * @eh_wq: Workqueue that eh_work works on
  * @eh_work: Worker to handle UFS errors that require s/w attention
  * @eeh_work: Worker to handle exception events
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

