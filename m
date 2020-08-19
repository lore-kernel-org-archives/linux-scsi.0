Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F49CC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 01:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 135252078B
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 01:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgHSBCq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Aug 2020 21:02:46 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:7052 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgHSBCp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2020 21:02:45 -0400
IronPort-SDR: 0qPuD+m6cR5LypoWJtvJWkR6V7SuTaXavDU8S7xNxCuahEMy+l/O3dt2o7J52ZxzgsoInEBvKt
 yMZKp5Ya0V279ZH/fd4pjZkzxqd5PBQyt4307awqvgX9SMgw829Aq4E6EiG9b+wMSHhRHqiOKE
 CLPWPi9EzB0etn8e6z9uPKpZgsyoFzJ0aWsJcVsSGxaxnVTm07AHqIF8tYfmqUMuBb/M0VplGq
 VUD9bK4OLB3vi1Vy8AIJorP5OLfDym03NB+ACQixY4ut8JV1ygbmQhKN3UsQtGoIM6l2As8BGM
 JU4=
X-IronPort-AV: E=Sophos;i="5.76,329,1592895600"; 
   d="scan'208";a="47259371"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 18 Aug 2020 18:02:45 -0700
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 18 Aug 2020 18:02:43 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id AFC3F215D9; Tue, 18 Aug 2020 18:02:43 -0700 (PDT)
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
Subject: [PATCH v2] scsi: ufs: Remove an unpaired ufshcd_scsi_unblock_requests() in err_handler()
Date:   Tue, 18 Aug 2020 18:02:29 -0700
Message-Id: <1597798958-24322-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 5586dd8ea250 ("scsi: ufs: Fix a race condition between error handler
and runtime PM ops") moves the ufshcd_scsi_block_requests() inside
err_handler(), but forgets to remove the ufshcd_scsi_unblock_requests() in
the early return path. Correct the coding mistake.

Fixes: 5586dd8ea250 ("scsi: ufs: Fix a race condition between error handler and runtime PM ops")
Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Hongwu Su<hongwus@codeaurora.org>
---

Change since v1:
- Added Fixes tag.

 drivers/scsi/ufs/ufshcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2b55c2e..b8441ad 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5670,7 +5670,6 @@ static void ufshcd_err_handler(struct work_struct *work)
 		if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
 			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
-		ufshcd_scsi_unblock_requests(hba);
 		return;
 	}
 	ufshcd_set_eh_in_progress(hba);
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

