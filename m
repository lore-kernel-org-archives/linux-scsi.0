Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A4CC4345F
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD84722D70
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgHFFHM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 01:07:12 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:4057 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728276AbgHFFHF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 01:07:05 -0400
IronPort-SDR: QLVrMAOEpUUgTjsvYyz0a51seXYBaPgpETDw5Qyl6hTyOv4IIZ0wZ/qjPIR84Fc21aFvbVtmyy
 bY7wkePJzez75bac8OW0bapsr7te5gNNUn/bGjLTXw6D6PmAZdokjkkc7OfI1zIE/B0w69d87H
 vCnncy80cu+7lr6wWFN7WE42ysz6wOPpgDSpWX29+4BIZOWojIOjmyEvxUTrKg98Y30hTy5n8B
 z0HhIL06ehxA3n3QqHRNhicrvwgJ7odwX55ya8llmBmvXVWVY+lK/TlLfNKLIlxcTpb8pggV7e
 I4E=
X-IronPort-AV: E=Sophos;i="5.75,440,1589266800"; 
   d="scan'208";a="29068261"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 05 Aug 2020 22:07:04 -0700
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 05 Aug 2020 22:07:03 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 06A2621562; Wed,  5 Aug 2020 22:07:04 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH 9/9] scsi: ufs: Properly release resources if a task is aborted successfully
Date:   Wed,  5 Aug 2020 22:06:20 -0700
Message-Id: <1596690383-16438-10-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596690383-16438-1-git-send-email-cang@codeaurora.org>
References: <1596690383-16438-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In current UFS task abort hook, namely ufshcd_abort(), if a task is
aborted successfully, clock scaling busy time statistics is not updated
and, most important, clk_gating.active_reqs is not decreased, which makes
clk_gating.active_reqs stay above zero forever, thus clock gating would
never happen. To fix it, instead of releasing resources "mannually", use
the existing func __ufshcd_transfer_req_compl(). This can also eliminate
racing of scsi_dma_unmap() from the real completion in IRQ handler path.

Signed-off-by: Can Guo <cang@codeaurora.org>
CC: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b2947ab..9541fc7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6636,11 +6636,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto out;
 	}
 
-	scsi_dma_unmap(cmd);
-
 	spin_lock_irqsave(host->host_lock, flags);
-	ufshcd_outstanding_req_clear(hba, tag);
-	hba->lrb[tag].cmd = NULL;
+	__ufshcd_transfer_req_compl(hba, (1UL << tag));
 	spin_unlock_irqrestore(host->host_lock, flags);
 
 out:
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

