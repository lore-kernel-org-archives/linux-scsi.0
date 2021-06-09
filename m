Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B00D7C47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 06:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95B5A6120F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 06:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236828AbhFIGmh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 02:42:37 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:15277 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbhFIGmh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 02:42:37 -0400
IronPort-SDR: xD2eZaohPZeG4KU0pQSvgHxwAEOLtyzjPOMOF3vdv/PoVtXqLgCs7AH8RukZUs42DQX72FXlMt
 A7/nIBkIQvZa2Byr9zBggnawlJU1Pm587Vp3npX2+8wjuWIwXfdQGhXcZ6wqy9Cc+vrMT1xj24
 Gm3MNqEJIiJzxc9c7rWFd46ATTM4xEg7fBEuR4x3LAxAn9fjAT/NLoTs4xEoB81WeRoCR8gsl5
 tB0/xXzuRQ4cjk0xD2A5G4h/o77XsJkEJcZVoy0Mh0teg2p7euUFj83GxqOizdX0+p/YD58mXC
 eV0=
X-IronPort-AV: E=Sophos;i="5.83,260,1616482800"; 
   d="scan'208";a="29778252"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 08 Jun 2021 23:40:43 -0700
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 08 Jun 2021 23:40:42 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 687E321B1D; Tue,  8 Jun 2021 23:40:42 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH v2 1/1] scsi: ufs: Fix a possible use before initialization case
Date:   Tue,  8 Jun 2021 23:39:34 -0700
Message-Id: <1623220779-22030-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In ufshcd_exec_dev_cmd(), if error happens before lrpb is initialized,
then we should bail out instead of letting trace record the error.

Fixes: a45f937110fa6 ("scsi: ufs: Optimize host lock on transfer requests send/compl paths")
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
Change since V1:
- Use codeaurora mail in Signed-off-by tag.

 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fe1b5f4..0d54ab7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2972,7 +2972,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 
 	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
 		err = -EBUSY;
-		goto out;
+		goto out_put_tag;
 	}
 
 	init_completion(&wait);
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

