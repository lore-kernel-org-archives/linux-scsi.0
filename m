Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD3BC433EA
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 06:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ACEB20709
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 06:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgGTGgJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 02:36:09 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:5831 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbgGTGgH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 02:36:07 -0400
IronPort-SDR: bA0f+rOOMxZIZUWQsidAv72INfEBHAxg9rtWxwPTbHu6uAeBGSyPDrdV77lU57plbpVvbcyuhU
 Flp6EUPbi9kNXF9g89XqON2RILUAHdodnJ3Az3hI2aezCjPLtZ3deTYsxyfMzxQIA/2bZ7Xcqo
 akWtlqj0lHf6yrTO8l2mKPf86csu/V7IPNJK1zCqfq/juvxtAYxsxfirETe4EsVwxm88+5xVZJ
 L8P2KDZQmLWFKXR7FWMW2hRC913Rkt+Oy6982KTSGBnKOzPB/HV5Vw0ljL21ACf8Bou09rNJ1U
 0nE=
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="47226981"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 19 Jul 2020 23:36:07 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg03-sd.qualcomm.com with ESMTP; 19 Jul 2020 23:36:06 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id D891622DA5; Sun, 19 Jul 2020 23:36:06 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        sh425.lee@samsung.com, linux-scsi@vger.kernel.org,
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
Subject: [PATCH v4 2/8] scsi: ufs: Fix imbalanced scsi_block_reqs_cnt caused by ufshcd_hold()
Date:   Sun, 19 Jul 2020 23:35:49 -0700
Message-Id: <1595226956-7779-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595226956-7779-1-git-send-email-cang@codeaurora.org>
References: <1595226956-7779-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi_block_reqs_cnt increased in ufshcd_hold() is supposed to be
decreased back in ufshcd_ungate_work() in a paired way. However, if
specific ufshcd_hold/release sequences are met, it is possible that
scsi_block_reqs_cnt is increased twice but only one ungate work is
queued. To make sure scsi_block_reqs_cnt is handled by ufshcd_hold() and
ufshcd_ungate_work() in a paired way, increase it only if queue_work()
returns true.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 99bd3e4..2907828 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1611,12 +1611,12 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		 */
 		/* fallthrough */
 	case CLKS_OFF:
-		ufshcd_scsi_block_requests(hba);
 		hba->clk_gating.state = REQ_CLKS_ON;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
 					hba->clk_gating.state);
-		queue_work(hba->clk_gating.clk_gating_workq,
-			   &hba->clk_gating.ungate_work);
+		if (queue_work(hba->clk_gating.clk_gating_workq,
+			       &hba->clk_gating.ungate_work))
+			ufshcd_scsi_block_requests(hba);
 		/*
 		 * fall through to check if we should wait for this
 		 * work to be done or not.
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

