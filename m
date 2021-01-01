Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B67EC433E6
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jan 2021 05:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36DB322202
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jan 2021 05:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbhAAFpl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jan 2021 00:45:41 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:5658 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbhAAFpl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jan 2021 00:45:41 -0500
IronPort-SDR: dINKIomj4e9VoVXNGBG8BSLJoTdIXNGFcp5ddOUs4i35yaNxWNPxX8N8fSOopfq+YddqeIqQcv
 rzDYph/kIy8cjqfM3Qg8cUutzp5lpZusxB1U4NFCI0J8NriNAINouY9BmZLUq8xcpzyEUSKGIr
 +vjLT8zmTiq/4P5S667Z2z0BCCNiY6P8HulwezDrrzzYrFC99mHen0kIpIkRXd3DbQZiiQxasf
 wrzaZz64+K2Ytxms5iQF/WEtlFns1hbsPMy/FjR9I52OGS4DTHf4IbTuZdKYO3P41MQps34vJa
 fPA=
X-IronPort-AV: E=Sophos;i="5.78,466,1599548400"; 
   d="scan'208";a="47632970"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 31 Dec 2020 21:45:01 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 31 Dec 2020 21:44:59 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 4AC88212C1; Thu, 31 Dec 2020 21:44:59 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/2] scsi: ufs: Fix a possible NULL pointer issue
Date:   Thu, 31 Dec 2020 21:44:52 -0800
Message-Id: <1609479893-8889-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1609479893-8889-1-git-send-email-cang@codeaurora.org>
References: <1609479893-8889-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During system resume/suspend, hba could be NULL. In this case, do not touch
eh_sem.

Fixes: 88a92d6ae4fe ("scsi: ufs: Serialize eh_work with system PM events and async scan")

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e221add..34e2541 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8896,8 +8896,11 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	int ret = 0;
 	ktime_t start = ktime_get();
 
+	if (!hba)
+		return 0;
+
 	down(&hba->eh_sem);
-	if (!hba || !hba->is_powered)
+	if (!hba->is_powered)
 		return 0;
 
 	if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
@@ -8945,10 +8948,8 @@ int ufshcd_system_resume(struct ufs_hba *hba)
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

