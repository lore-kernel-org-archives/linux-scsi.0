Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE6DC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 05:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A79F2076E
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 05:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHRFVA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Aug 2020 01:21:00 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:49492 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbgHRFU7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2020 01:20:59 -0400
IronPort-SDR: hVAo02F3cXNxOnSAKffXJ7khH6/2x9Sd18ogEVAtUT0crsO9JqM3SEOXN4HOZ7C1CEOUI0BsxI
 IuyDpZ8znxeF7/aBOfDyEppktrTtNe0DsUA2W+Lqto1ASLNnBqoGPpbe5MLBVb8gm+8qEytvlb
 n9tAma6Ov5Fmjc7tipOOsQYl1Jj+6MI9hXMUbBtHCxF+QqBBhP51FhpzxabmdDAgqmoAlDORQK
 BQWZp2gYZsrtEk4YvnQexzBamMUNCfcOe0TIESI6ZcIzmCmBVEhEirwvxFj4RQvJF6rk3woGzZ
 2FQ=
X-IronPort-AV: E=Sophos;i="5.76,326,1592895600"; 
   d="scan'208";a="29090719"
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by labrats.qualcomm.com with ESMTP; 17 Aug 2020 22:20:59 -0700
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg01-sd.qualcomm.com with ESMTP; 17 Aug 2020 22:20:56 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 92AFB215B6; Mon, 17 Aug 2020 22:20:49 -0700 (PDT)
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
Subject: [PATCH] scsi: ufs: Remove an unpaired ufshcd_scsi_unblock_requests() in err_handler()
Date:   Mon, 17 Aug 2020 22:20:43 -0700
Message-Id: <1597728047-39936-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 5586dd8ea250a ("scsi: ufs: Fix a race condition between error
handler and runtime PM ops") moves the ufshcd_scsi_block_requests() inside
err_handler(), but forgets to remove the ufshcd_scsi_unblock_requests() in
the early return path. Correct the coding mistake.

Signed-off-by: Can Guo <cang@codeaurora.org>

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

