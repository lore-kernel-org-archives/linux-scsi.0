Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C56C0C48BD1
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A49D4613B0
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFJEqC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 00:46:02 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:10993 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhFJEqC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 00:46:02 -0400
IronPort-SDR: 3sXAk0k9MJzrximd/juvH4shb43TTKhtGhw6v/732Q9Wvpt15eokixBnhu3t7i2BADKeir8uxf
 Apy7U51A5JVFyXFjT1Raois/9Ppk3V/SNi8foLXM27zPFSAAjcBOYSRJdGhSH2IvIsEdMUO0ef
 UwWtfanQmJSexEq6GXIBsrRcLNk75XbUvzzJ8zx0yq4bIv9luYxI3pZHxyeUmi3IgmC5zC+8DZ
 ucyOJcyzyyg6Q3QAa7jmNSGGSYyMC5hBp7/GoN1GfTDwn5nxQkZDR7E7JaBZxYLgOgDe3jBtLe
 fSg=
X-IronPort-AV: E=Sophos;i="5.83,262,1616482800"; 
   d="scan'208";a="29778427"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 09 Jun 2021 21:44:07 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 09 Jun 2021 21:44:05 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id BE4E221AF7; Wed,  9 Jun 2021 21:44:05 -0700 (PDT)
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
Subject: [PATCH v3 3/9] scsi: ufs: Enable IRQ after enabling clocks in error handling preparation
Date:   Wed,  9 Jun 2021 21:43:31 -0700
Message-Id: <1623300218-9454-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In error handling preparation, enable IRQ after enabling clocks in case
unclocked register access happens.

Fixes: c72e79c0ad2bd ("scsi: ufs: Recover HBA runtime PM error in error handler")
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fed893e..0c9d2ee 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5927,13 +5927,14 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 		 * can be OFF or in LPM.
 		 */
 		ufshcd_setup_hba_vreg(hba, true);
-		ufshcd_enable_irq(hba);
 		ufshcd_setup_vreg(hba, true);
 		ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq);
 		ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq2);
 		ufshcd_hold(hba, false);
-		if (!ufshcd_is_clkgating_allowed(hba))
+		if (!ufshcd_is_clkgating_allowed(hba)) {
 			ufshcd_setup_clocks(hba, true);
+			ufshcd_enable_irq(hba);
+		}
 		ufshcd_release(hba);
 		pm_op = hba->is_wl_sys_suspended ? UFS_SYSTEM_PM : UFS_RUNTIME_PM;
 		ufshcd_vops_resume(hba, pm_op);
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

