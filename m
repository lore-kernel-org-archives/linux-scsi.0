Return-Path: <SRS0=1wnw=BT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5086C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 12:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE96A206D8
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 12:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgHIMUS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Aug 2020 08:20:18 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:41632 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgHIMQp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Aug 2020 08:16:45 -0400
IronPort-SDR: yssPynAa+KB3fJ5xFlAz6+8VyxgQIDBqTyEBCW7y56j0EeM9Sv8MbR4pzyH9mINWtYQGZP2+V2
 ohzFu1iPS29+MrL8ytpycWwTmMOtr7G2tkHJO8WNEVVWoFCY9z5f/9UQxx5/BGz1dk8ChP1Afd
 oa6NZjOtNtfw8wyYx+1JJd0AD93szwXkbJZ7VpRajwo+lgBGiSvDVs+OYiZXb4AWLA0K752HZr
 Z18quy9XXI6vlfuF7HJU4zJoIpRFTigY3pFkOQGUFSUjfsvPXROZnQlK8XABtBxzwrws1IOekI
 dXc=
X-IronPort-AV: E=Sophos;i="5.75,453,1589266800"; 
   d="scan'208";a="47246501"
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by labrats.qualcomm.com with ESMTP; 09 Aug 2020 05:16:40 -0700
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg01-sd.qualcomm.com with ESMTP; 09 Aug 2020 05:16:38 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id CBE512156E; Sun,  9 Aug 2020 05:16:38 -0700 (PDT)
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
        James Bottomley <JBottomley@Parallels.com>,
        Santosh Y <santoshsy@gmail.com>,
        Sujit Reddy Thumma <sthumma@codeaurora.org>,
        Dolev Raviv <draviv@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH 9/9] scsi: ufs: Properly release resources if a task is aborted successfully
Date:   Sun,  9 Aug 2020 05:15:55 -0700
Message-Id: <1596975355-39813-10-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596975355-39813-1-git-send-email-cang@codeaurora.org>
References: <1596975355-39813-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In current UFS task abort hook, namely ufshcd_abort(), if one task is
aborted successfully, clk_gating.active_reqs held by this task is not
decreased, which makes clk_gating.active_reqs stay above zero forever,
thus clock gating would never happen. Instead of releasing resources of
one task "manually", use the existing func __ufshcd_transfer_req_compl().
This change can also eliminate possible racing of scsi_dma_unmap() from
the real completion in IRQ handler path.

Fixes: 5a0b0cb9bee76 ("ufs: Add support for clock gating")
Signed-off-by: Can Guo <cang@codeaurora.org>
CC: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9ebb5cd..efb40b1 100644
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

