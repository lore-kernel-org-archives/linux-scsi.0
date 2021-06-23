Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6240BC4743C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E3FA611AC
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhFWHjt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 03:39:49 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:4033 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbhFWHj1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 03:39:27 -0400
IronPort-SDR: rSf3kEGxfPls28NJoptcnE8i3v2WSFhubXF7ba1eWunPn/QJmggQg8c7H7OeioItmiLo6rLqqg
 G6kIkew7XOhZTOl4BZHzaRX/Yl0kAV6Y3ZsicB8orULc7IZm0+GFJh+aRhsgipJTuO59NMxP5F
 ik0+drNDjN9qNUyA0x0XSh9hIHyNo8BNZvzoYhbea2KE9eF40nAA2yFGGO26FKGzQ32jivDr/N
 ETES5eOJD7K8gcDetVpxOZyf7Y39OGol7Tb01PAYLRSUQqgomrnmZg51m4SArTmbL0JKh5jLSp
 kzQ=
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="47902946"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 23 Jun 2021 00:37:07 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 23 Jun 2021 00:37:07 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 4790E21BC1; Wed, 23 Jun 2021 00:37:07 -0700 (PDT)
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
Subject: [PATCH v4 05/10] scsi: ufs: Remove a redundant tag check in ufshcd_queuecommand()
Date:   Wed, 23 Jun 2021 00:35:05 -0700
Message-Id: <1624433711-9339-7-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since commit a45f937110fa6b0c2c06a5d3ef026963a5759050 ("scsi: ufs: Optimize
host lock on transfer requests send/compl paths") has moved ufshcd state
check to front, we can remove the following tag check added for preventing
the scenario where a cmd is trying to take a lrbp, which is still in use.
This scenario can only happen if a cmd goes through the fast abort path
(whose tag is released but lrbp is not) in ufshcd_abort(), and since ufshcd
state is also changed by the fast abort path, checking the ufshcd state in
ufshcd_queuecommand() is equivalent, hence remove the tag check.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5f837c4..3695dd2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2768,15 +2768,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	WARN_ON(ufshcd_is_clkgating_allowed(hba) &&
 		(hba->clk_gating.state != CLKS_ON));
 
-	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
-		if (hba->wlu_pm_op_in_progress)
-			set_host_byte(cmd, DID_BAD_TARGET);
-		else
-			err = SCSI_MLQUEUE_HOST_BUSY;
-		ufshcd_release(hba);
-		goto out;
-	}
-
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = cmd;
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

