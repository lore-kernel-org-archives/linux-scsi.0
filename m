Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75BDC04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 08:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BF076113B
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 08:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbhEXIij (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 04:38:39 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:12145 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbhEXIij (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 04:38:39 -0400
IronPort-SDR: ZzQS+FN4lAjrIbd6BaXDIqC1HEoUUMkGnMC+K9FtIVF7bYWdzd6SsuwyUta2DB8quQT5+Ic0Cf
 x5ezx8lxrd9L8unW06lFkyhQE9riRtE/XZcTM+7f/vwp4Pv53w+Mam76iKCTNglEs+pMSW3O5q
 5Rn7X8XVJ5evrJ20UrIirlFnD0gVMDmQVc7Lq5wdG+F/oeoa/15ex0MHO33ILUdGhonvVUBZqs
 J/jkYO2ZG8hQfYgUNf7ncci1GcUiy/qwraxdd3mHSTJuKaURkX4iLOpmj695n1xgd9HTsCMU/c
 kqM=
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="29772328"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 24 May 2021 01:37:11 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 24 May 2021 01:37:10 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id A7B8421AD7; Mon, 24 May 2021 01:37:10 -0700 (PDT)
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
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 1/3] scsi: ufs: Remove a redundant command completion logic in error handler
Date:   Mon, 24 May 2021 01:36:56 -0700
Message-Id: <1621845419-14194-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufshcd_host_reset_and_restore() anyways completes all pending requests
before starts re-probing, so there is no need to complete the command on
the highest bit in tr_doorbell in advance.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d543864..c4b37d2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6123,19 +6123,6 @@ static void ufshcd_err_handler(struct work_struct *work)
 do_reset:
 	/* Fatal errors need reset */
 	if (needs_reset) {
-		unsigned long max_doorbells = (1UL << hba->nutrs) - 1;
-
-		/*
-		 * ufshcd_reset_and_restore() does the link reinitialization
-		 * which will need atleast one empty doorbell slot to send the
-		 * device management commands (NOP and query commands).
-		 * If there is no slot empty at this moment then free up last
-		 * slot forcefully.
-		 */
-		if (hba->outstanding_reqs == max_doorbells)
-			__ufshcd_transfer_req_compl(hba,
-						    (1UL << (hba->nutrs - 1)));
-
 		hba->force_reset = false;
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		err = ufshcd_reset_and_restore(hba);
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

