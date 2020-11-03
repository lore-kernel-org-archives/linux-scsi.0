Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E74C388F7
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 06:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E816A22277
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 06:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgKCGYu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 01:24:50 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:20045 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgKCGYu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 01:24:50 -0500
IronPort-SDR: tm9WZLWZnji4s6uVJx5CRrXJDcOHRFhIr4cdBUbQsFcvY6G0ChSme/CtCOR0/C2lPOtMM7KIeD
 n0LZsv61nVREaxyChqVJEC5LzPpBdjbX3bEbNy6QuAIPbtDQ+29qLYC+senLqhrUUNj/llK1pF
 zLNb30L0+vT2GhT0mQuiFjUDpUBHg13iwo4kP9LTxbalHROZRfVZFm1A+fEXJVnqIZmdnLE9V2
 TZPOXyUks/Qwo5fhUY9lfMR/CJDnbl8IrEiUWxPFuco4VyicR0xOFdjmdYA92FLFz+RvQna6Sf
 CXQ=
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="47412255"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 02 Nov 2020 22:24:49 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 02 Nov 2020 22:24:48 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 8229F217C9; Mon,  2 Nov 2020 22:24:48 -0800 (PST)
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
Subject: [PATCH v1 1/2] scsi: ufs: Fix unbalanced scsi_block_reqs_cnt caused by ufshcd_hold()
Date:   Mon,  2 Nov 2020 22:24:39 -0800
Message-Id: <1604384682-15837-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604384682-15837-1-git-send-email-cang@codeaurora.org>
References: <1604384682-15837-1-git-send-email-cang@codeaurora.org>
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
Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 847f355..efa7d86 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1634,12 +1634,12 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
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

