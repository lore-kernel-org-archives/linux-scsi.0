Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E77BC433DB
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Jan 2021 14:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 530D922482
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Jan 2021 14:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbhABOAh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jan 2021 09:00:37 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:20241 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbhABOAh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jan 2021 09:00:37 -0500
IronPort-SDR: RKLfSV7ITHhdpTzWS3qwDiMgrp8Wrwz6QVWwflSxipDQJCAgb8hsmEkvkMAy2gYoBow4RAU7KB
 IIO7AhpWX3dh5ftwh7Re2mfNvDbkA3EptFSP4/o/lwbSJJKjKDIpsDrZ/MahdrBBlnDQzH388q
 GK28O2fZpe7J037fDEVUlZxXgcnyqZPMhMteIHtm0dhc+8xyUSN/shyEVy8vEbxHFdOo1WxfRa
 A+9RmcxxPRz0HtXRw/iWmD2vT8LRGfVeoIJ2Z7tzU+yqH2Q6Pn/+iHa2bSUZKdK1OxKlGT3uIX
 3lk=
X-IronPort-AV: E=Sophos;i="5.78,469,1599548400"; 
   d="scan'208";a="29476449"
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by labrats.qualcomm.com with ESMTP; 02 Jan 2021 05:59:44 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg01-sd.qualcomm.com with ESMTP; 02 Jan 2021 05:59:43 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 075EE2187E; Sat,  2 Jan 2021 05:59:44 -0800 (PST)
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
Subject: [PATCH 1/2] scsi: ufs: Fix a possible NULL pointer issue
Date:   Sat,  2 Jan 2021 05:59:33 -0800
Message-Id: <1609595975-12219-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During system resume/suspend, hba could be NULL. In this case, do not touch
eh_sem.

Fixes: 88a92d6ae4fe ("scsi: ufs: Serialize eh_work with system PM events and async scan")

Signed-off-by: Can Guo <cang@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e221add..9829c8d 100644
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
@@ -8896,8 +8898,14 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
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
@@ -8945,9 +8953,12 @@ int ufshcd_system_resume(struct ufs_hba *hba)
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

