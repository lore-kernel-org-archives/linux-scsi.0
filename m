Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CDA4C8301D
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 08:28:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37C9A2223F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 08:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgLBI2L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 03:28:11 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:22598 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729039AbgLBI2K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 03:28:10 -0500
IronPort-SDR: QaNLU5nCxCuAwcOOnijYGFPXP7xP0o3eowhCEhFJPhcAorTTOCTyFI2izM8Vp0/cSIzYAdfZmy
 bj/0p+X8aRaNQso9/w6LmwYDYMoYf+hY4ruGMuTEdW/i4dTFJtoZ8MquzxVY4lfX2vvzvHPF6M
 cllL42jEllHIOMCO6Ryacbs4dFBdshJeXP6IBFrJqylBtRuYe12K2cIbilUWY0tKjmmYjiBsQw
 lqtouY+0i0U8wOa9nZeQT/BXD581PenlpOHD4X8KmReQ2UP0CotNKrcFVJQUv5qNvzDi74ID5g
 wz4=
X-IronPort-AV: E=Sophos;i="5.78,386,1599548400"; 
   d="scan'208";a="47539711"
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by labrats.qualcomm.com with ESMTP; 02 Dec 2020 00:27:07 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg05-sd.qualcomm.com with ESMTP; 02 Dec 2020 00:27:05 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 248E22107E; Wed,  2 Dec 2020 00:27:06 -0800 (PST)
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
Subject: [PATCH V5 3/3] scsi: ufs: Print host regs in IRQ handler when AH8 error happens
Date:   Wed,  2 Dec 2020 00:24:34 -0800
Message-Id: <1606897475-16907-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606897475-16907-1-git-send-email-cang@codeaurora.org>
References: <1606897475-16907-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When AH8 error happens, all the regs and states are dumped in err handler.
Sometime we need to look into host regs right after AH8 error happens,
which is before leaving the IRQ handler.

Reviewed-by: Bao D. Nguyen <nguyenb@codeaurora.org>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Hongwu Su<hongwus@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fa90e15..94405e4 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6057,7 +6057,8 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
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

