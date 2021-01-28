Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B69C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 733C164DD6
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhA1ESJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 23:18:09 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:40784 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbhA1ESF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 23:18:05 -0500
IronPort-SDR: uis1MRu9wOS/NldmsOhX/HutjYmbB/JNYuv7iW4+GFNHgfwxrlgqtngdvcI3YTiwnSKBYMMnX3
 H+aHPlk67ZGR3x5e/w8t6p7o6SWAbgqZj8ezrRNIjGqswB0qS3ae+ywx9AkbaisKL7ITpHRRvR
 npbnw8GZGQTOJHBS+KCQ/aIS3/uSce0zdAwVEoXaDubkLqx1PhS/w7pwnk0lH33jVQoXpdYf35
 iVzs2ISTKp8id5pXpj01jDYHUAm8ZAm0eIy8zEvRUZ7UP5CApvO9s3pv4nAujA4kepIRQMcOY+
 UZw=
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="47715649"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 27 Jan 2021 20:17:45 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 27 Jan 2021 20:17:43 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 4A40A219A2; Wed, 27 Jan 2021 20:17:43 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     jaegeuk@kernel.org, bvanassche@acm.org, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 1/3] scsi: ufs: Fix task management request completion timeout
Date:   Wed, 27 Jan 2021 20:16:02 -0800
Message-Id: <1611807365-35513-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1611807365-35513-1-git-send-email-cang@codeaurora.org>
References: <1611807365-35513-1-git-send-email-cang@codeaurora.org>
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
index 8da75e6..c0c5925 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6395,6 +6395,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 
 	spin_lock_irqsave(host->host_lock, flags);
 	task_tag = hba->nutrs + free_slot;
+	blk_mq_start_request(req);
 
 	treq->req_header.dword_0 |= cpu_to_be32(task_tag);
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

