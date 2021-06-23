Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F351FC48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC5B46128A
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhFWHjk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 03:39:40 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:9757 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbhFWHjV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 03:39:21 -0400
IronPort-SDR: lt5cE9eBpnslfYbr9VZrYOHwKXrlwitl/+pnUlcMX4dqbvrn9AwzaPptbQX17blGahA1tXlgpb
 zS102jxZ0DmJ/7C2NjO3idjeoxbwWotrMRltdgAaQmxq6vFrwtqmJspYpZefEaBf9C1VWLugHL
 xAmCBOdq2+WtbVsj6L+pNz+iikdBLq50D7mvKy1rXK66FuQrsOiNxS8akmlhxkAiwOlr1UF9Bd
 39SW/tD8RZpjZstHEj1Pze9KhGUmMC+BtaF1FusNEJntmFZzL6hEVgLrxDBS8kQVdz9So6m561
 jo0=
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="47902945"
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by labrats.qualcomm.com with ESMTP; 23 Jun 2021 00:37:04 -0700
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 23 Jun 2021 00:37:03 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id B4AF621BC1; Wed, 23 Jun 2021 00:37:03 -0700 (PDT)
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
Subject: [PATCH 05/10] scsi: ufs: Complete the cmd before returning in queuecommand
Date:   Wed, 23 Jun 2021 00:35:04 -0700
Message-Id: <1624433711-9339-6-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 7a7e66c65d4148fc3f23b058405bc9f102414fcb ("scsi: ufs: Fix a race
condition between ufshcd_abort() and eh_work()") forgot to complete the
cmd, which takes an occupied lrb, before returning in queuecommand. This
change adds the missing codes.

Fixes: 7a7e66c65d414 ("scsi: ufs: Fix a race condition between ufshcd_abort() and eh_work()")
Signed-off-by: Can Guo <cang@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5f837c4..7fbc63e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2758,6 +2758,16 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		goto out;
 	}
 
+	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
+		if (hba->wlu_pm_op_in_progress) {
+			set_host_byte(cmd, DID_BAD_TARGET);
+			cmd->scsi_done(cmd);
+		} else {
+			err = SCSI_MLQUEUE_HOST_BUSY;
+		}
+		goto out;
+	}
+
 	hba->req_abort_count = 0;
 
 	err = ufshcd_hold(hba, true);
@@ -2768,15 +2778,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
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

