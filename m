Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2DD4C3F2D7
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 17:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 922D620848
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 17:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgCERTO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 12:19:14 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:1437 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbgCERPL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2020 12:15:11 -0500
IronPort-SDR: XuA4+RAW8bgZWyzJMYTe3vh0ha9IHBzmH3ZJqao3xLZZ5MIw/tfGRoQaoTaupZAYNmjnRlN3YC
 0wqb9aSnMknGCJlhEG09JvYrbZfVIf580g7hvqmMF8Nx1O5SWATsunGAMNaInFjFhuD3fuyeTK
 oXPHb5heAFg5qwbXm+c5j13I25Jq0N+F3LHaMzgquDvqANroeTBi6jNLmx1YFwreRcNdk50sE6
 XXcBSz1+odzI0eCiAxj70LrYkg1crpsrM2aNQ1W2HBA/hK7PpvTIgoTJA/MSHm4Ku7eXgWOkrt
 wEk=
X-IronPort-AV: E=Sophos;i="5.70,517,1574150400"; 
   d="scan'208";a="28542843"
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by labrats.qualcomm.com with ESMTP; 05 Mar 2020 00:53:15 -0800
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg01-sd.qualcomm.com with ESMTP; 05 Mar 2020 00:53:14 -0800
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id 76BE139CE; Thu,  5 Mar 2020 00:53:14 -0800 (PST)
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
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 1/1] scsi: ufs: Fix possible unclocked access to auto hibern8 timer register
Date:   Thu,  5 Mar 2020 00:53:07 -0800
Message-Id: <1583398391-14273-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Before access auto hibner8 timer register, make sure power and clock are
properly configured to avoid unclocked register access.

Fixes: ba7af5ec5126 ("scsi: ufs: export ufshcd_auto_hibern8_update for vendor usage")
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e987fa3a..5698f11 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3914,18 +3914,25 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 {
 	unsigned long flags;
+	bool update = false;
 
-	if (!(hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT))
+	if (!ufshcd_is_auto_hibern8_supported(hba))
 		return;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->ahit == ahit)
-		goto out_unlock;
-	hba->ahit = ahit;
-	if (!pm_runtime_suspended(hba->dev))
-		ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
-out_unlock:
+	if (hba->ahit != ahit) {
+		hba->ahit = ahit;
+		update = true;
+	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	if (update && !pm_runtime_suspended(hba->dev)) {
+		pm_runtime_get_sync(hba->dev);
+		ufshcd_hold(hba, false);
+		ufshcd_auto_hibern8_enable(hba);
+		ufshcd_release(hba);
+		pm_runtime_put(hba->dev);
+	}
 }
 EXPORT_SYMBOL_GPL(ufshcd_auto_hibern8_update);
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

