Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E98AC19425
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 06:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EDBD23B86
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 06:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgLIG7Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 01:59:24 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:5506 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728329AbgLIG7V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 01:59:21 -0500
IronPort-SDR: 1xi+2kSz3668aA4wquqQLQsSMXQPGteHr0enzHMcvsBEGq7GiH0d33qYQ7PEn2ipcjqZ9ZaeFo
 cfX3CV1l457iYc8hjTgNIWVkWGm0y2yhc6Nu0NHr8R/RZmdNb3YcMIkGjhKFRvxrN3VzzdrQHJ
 YGpKVnF0mXycvWPskXDjTCxKS6u51xzsY7sROfn3qB/4ZK7d0lRhn2DjwK0vFEVsiJny4A9qV6
 V5F5yoobTx7X/HitMxdItWZVcR/PoZjH4bNWoHnAkfGkeJyWTVymxmGdke7Dv1R80qZrS8f0BE
 FUs=
X-IronPort-AV: E=Sophos;i="5.78,404,1599548400"; 
   d="scan'208";a="47568894"
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by labrats.qualcomm.com with ESMTP; 08 Dec 2020 22:58:32 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 08 Dec 2020 22:58:31 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id CB682212AC; Tue,  8 Dec 2020 22:58:31 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 2/2] scsi: ufs: Clean up some lines from ufshcd_hba_exit()
Date:   Tue,  8 Dec 2020 22:58:20 -0800
Message-Id: <1607497100-27570-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607497100-27570-1-git-send-email-cang@codeaurora.org>
References: <1607497100-27570-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufshcd_hba_exit() is always called after ufshcd_exit_clk_scaling() and
ufshcd_exit_clk_gating(), so no need to suspend clock scaling again in
ufshcd_hba_exit().

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 12266bd..0a5b197 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7765,6 +7765,7 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	if (ret) {
 		pm_runtime_put_sync(hba->dev);
 		ufshcd_exit_clk_scaling(hba);
+		ufshcd_exit_clk_gating(hba);
 		ufshcd_hba_exit(hba);
 	}
 }
@@ -8203,10 +8204,6 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 	if (hba->is_powered) {
 		ufshcd_variant_hba_exit(hba);
 		ufshcd_setup_vreg(hba, false);
-		ufshcd_suspend_clkscaling(hba);
-		if (ufshcd_is_clkscaling_supported(hba))
-			if (hba->devfreq)
-				ufshcd_suspend_clkscaling(hba);
 		ufshcd_setup_clocks(hba, false);
 		ufshcd_setup_hba_vreg(hba, false);
 		hba->is_powered = false;
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

