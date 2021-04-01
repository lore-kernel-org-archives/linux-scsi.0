Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B35C433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 07:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 452A7610CA
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 07:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233283AbhDAHjU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 03:39:20 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:49605 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbhDAHjP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 03:39:15 -0400
IronPort-SDR: wGTYIz9+kjcTO99VPBy0frlZ80GQmPAoz1yXnuoY+v+gEDx4MQ8G4o+55oxuWjG6IwEPR71VCg
 g8l+JhG++wNj0IzTdyW4CoW5S0aheLTDSMPH3o/B1kIi3C1xSASBe5SNuBA4bGbfknmWS26OKZ
 YuOmhx7UNj4YHQbYkQ0ztuMDgDbtOWOfoie43oxZuyZD+U38V/FIG3DA0evxkSLRmUpGJcKO/J
 bjP7NsqDV0YC80lRFH/Rx0RxMsqooM5MtYOMTfcssCK0Z1nZHf3/GcQcy89+RjH3tHB5QsBaCE
 Fp4=
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="29736676"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 01 Apr 2021 00:39:15 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 01 Apr 2021 00:39:14 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id A457B210A9; Thu,  1 Apr 2021 00:39:14 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 1/2] scsi: ufs: Fix task management request completion timeout
Date:   Thu,  1 Apr 2021 00:39:08 -0700
Message-Id: <1617262750-4864-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617262750-4864-1-git-send-email-cang@codeaurora.org>
References: <1617262750-4864-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufshcd_tmc_handler() calls blk_mq_tagset_busy_iter(fn = ufshcd_compl_tm()),
but since blk_mq_tagset_busy_iter() only iterates over all reserved tags
and requests which are not in IDLE state, ufshcd_compl_tm() never gets a
chance to run. Thus, TMR always ends up with completion timeout. Fix it by
calling blk_mq_start_request() in  __ufshcd_issue_tm_cmd().

Fixes: 69a6c269c097 ("scsi: ufs: Use blk_{get,put}_request() to allocate and free TMFs")

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b49555fa..d4f8cb2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6464,6 +6464,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 
 	spin_lock_irqsave(host->host_lock, flags);
 	task_tag = hba->nutrs + free_slot;
+	blk_mq_start_request(req);
 
 	treq->req_header.dword_0 |= cpu_to_be32(task_tag);
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

