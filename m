Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD59C83013
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 12:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0B9A221FE
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 12:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbgLBMFA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 07:05:00 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:1561 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgLBME7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 07:04:59 -0500
IronPort-SDR: g9jAffxBAYy8vjgsNRxjoVmXcn5jzUqBIOPo+H+d7pjKM2N0MQAF2P1J+MMaQ/geTBFjFRX5N9
 rK3I9UUZsXvLNovXuvQHgp/Izv6AO8JuuKNSyyYANy1cb44xHKhqe9W6DBfOwQOTkLRGCh4J51
 qdiZvDUvYqfghv6zpkCMouOtSMX/g3+jsUm77ag86NmDJ2G2+cfOHcl3nqngSzCG/yWWL7bzJT
 Qy8fgXj3ciDGjyrW4/ehRsFpDhCam+ijFEVM8YE/2TD8ybE9S4Emsm3of/3rKgdYoKNX9Zy4m+
 E/w=
X-IronPort-AV: E=Sophos;i="5.78,386,1599548400"; 
   d="scan'208";a="47540559"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 02 Dec 2020 04:04:18 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 02 Dec 2020 04:04:18 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id F3E5F2106D; Wed,  2 Dec 2020 04:04:17 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH V7 3/3] scsi: ufs: Print host regs in IRQ handler when AH8 error happens
Date:   Wed,  2 Dec 2020 04:04:03 -0800
Message-Id: <1606910644-21185-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606910644-21185-1-git-send-email-cang@codeaurora.org>
References: <1606910644-21185-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When AH8 error happens, all the regs and states are dumped in err handler.
Sometime we need to look into host regs right after AH8 error happens,
which is before leaving the IRQ handler.

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bao D. Nguyen <nguyenb@codeaurora.org>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Hongwu Su<hongwus@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 26c1fa0..4561601 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6060,7 +6060,8 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
 		hba->saved_uic_err |= hba->uic_error;
 
 		/* dump controller state before resetting */
-		if ((hba->saved_err & (INT_FATAL_ERRORS)) ||
+		if ((hba->saved_err &
+		     (INT_FATAL_ERRORS | UFSHCD_UIC_HIBERN8_MASK)) ||
 		    (hba->saved_uic_err &&
 		     (hba->saved_uic_err != UFSHCD_UIC_PA_GENERIC_ERROR))) {
 			dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x\n",
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

