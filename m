Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11946C47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA806611BF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbhFIDjY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:39:24 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:2936 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236456AbhFIDjX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 23:39:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1623209850; x=1654745850;
  h=from:to:cc:subject:date:message-id;
  bh=DIyylziV6vHQtVy7YM6RC+KUySRLTtWpcgXj9Ly0rLo=;
  b=tqzXPgLtkZTH0zYuXcOfmcqtjDImPWL4vscLQdDq6TcpOLqORcE1cjlD
   1w632OzLOktmhYb8Blhu0ELtlsf3lB9UoaJQp2U/HBPSoGQcx4cZiKAr3
   Ufcl0M8cHlrVZ+rmPKKnLXi7u8m2FFOkW7JDa5uXEcRAPcYC2YN9p4Jah
   4=;
IronPort-SDR: 75sHfRhcuwAQBPt4JvoptEoyrzWgbsfq74fZqFVnDhQTqpy/sEXPu3mrBCAMBWdGf95eHfw/S6
 pImEWYpEeabQhPMFsTuOKncBTB+naOcs40r5HmjrF+NY8yqTzebsj+3EPvrtuu0Z3yybbKFrRT
 83KbVs2Wv+qjqfC4OeKeSYO0vZp+ICgHSSUQoGsxbUOPLIwCSyuAV/EReruiTfGaVASELXow0K
 v+NvVcQaX9p/kmi0mO8a88f3ClrgJWxmWIO4quP5OukVSg40d2ziObzSk0CMsbFeaj/y0KMaT0
 99M=
X-IronPort-AV: E=Sophos;i="5.83,260,1616482800"; 
   d="scan'208";a="47892545"
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by labrats.qualcomm.com with ESMTP; 08 Jun 2021 20:37:28 -0700
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 08 Jun 2021 20:37:27 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id CA82921078; Tue,  8 Jun 2021 20:37:27 -0700 (PDT)
From:   Can Guo <cang@qti.qualcomm.com>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        cang@codeaurora.org
Cc:     Can Guo <cang@qti.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: ufs: Fix a possible use before initialization case
Date:   Tue,  8 Jun 2021 20:36:50 -0700
Message-Id: <1623209820-37840-1-git-send-email-cang@qti.qualcomm.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In ufshcd_exec_dev_cmd(), if error happens before lrpb is initialized,
then we should bail out instead of letting trace record the error.

Fixes: a45f937110fa6 ("scsi: ufs: Optimize host lock on transfer requests send/compl paths")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Can Guo <cang@qti.qualcomm.com>

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

