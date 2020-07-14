Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0456DC433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 02:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8DD420773
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 02:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGNC2Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 22:28:25 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:2199 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgGNC2Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 22:28:25 -0400
IronPort-SDR: 47AfwHXM8xPRg2gsPUUI5742wUL2Wry+9RnanidNCEQf4ozJ+4aeHW8Dgg75c3VjZr2o2VfAyq
 vM5IifwniIpnmeaNxPBfTxvGtxW3nn11EK3/zt+cBisR8dNo73QfLR71q6+I3bwqMU8430+GI9
 BI4z6RLZhx3H+OmXTWCbFjfTVGsKYJNdtHSzayH4GuubsE7xQoH5U7/oT2nlxJ0HKGzzdpUJ3S
 uNKDLYijZAT5QIiPp/Y6vnv3TamfdPMEjZDgYA9XWEEoMRWkRl49jwtfDp4ajjZBg6kOK46qG3
 k6Q=
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="29035045"
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by labrats.qualcomm.com with ESMTP; 13 Jul 2020 19:28:24 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 13 Jul 2020 19:28:23 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id 018EA22DC2; Mon, 13 Jul 2020 19:28:23 -0700 (PDT)
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
Subject: [PATCH v2 2/4] scsi: ufs: Fix imbalanced scsi_block_reqs_cnt caused by ufshcd_hold()
Date:   Mon, 13 Jul 2020 19:28:10 -0700
Message-Id: <1594693693-22466-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594693693-22466-1-git-send-email-cang@codeaurora.org>
References: <1594693693-22466-1-git-send-email-cang@codeaurora.org>
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
index ebf7a95..33214bb 100644
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

