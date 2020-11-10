Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725EFC388F7
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 09:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 304D320780
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 09:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbgKJJFg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 04:05:36 -0500
Received: from mail-m1272.qiye.163.com ([115.236.127.2]:3195 "EHLO
        mail-m1272.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729809AbgKJJEG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 04:04:06 -0500
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Nov 2020 04:04:04 EST
Received: from ubuntu.localdomain (unknown [157.0.31.124])
        by mail-m1272.qiye.163.com (Hmail) with ESMTPA id 0ECA1B02488;
        Tue, 10 Nov 2020 16:55:52 +0800 (CST)
From:   Yang Yang <yang.yang@vivo.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Sujit Reddy Thumma <sthumma@codeaurora.org>,
        Dolev Raviv <draviv@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     onlyfever@icloud.com, yang.yang@vivo.com
Subject: [PATCH] scsi: ufs: Fix a bug in ufshcd_system_resume()
Date:   Tue, 10 Nov 2020 00:55:35 -0800
Message-Id: <20201110085537.2889-1-yang.yang@vivo.com>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZHUpISRoYSklIT09MVkpNS09CQkNOTklPT0JVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6ODI6OBw6Hz8fERBDHDkKQxch
        EBJPCUtVSlVKTUtPQkJDTk5JQ0lOVTMWGhIXVQIaFRxVAhoVHDsNEg0UVRgUFkVZV1kSC1lBWUpO
        TFVLVUhKVUpJT1lXWQgBWUFITk9MNwY+
X-HM-Tid: 0a75b15e5b0398b7kuuu0eca1b02488
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During system resume, ufshcd_system_resume() won't resume UFS host if
runtime suspended. After that, scsi_bus_resume() try to set SCSI host's
RPM status to RPM_ACTIVE, this will fail because UFS host's RPM status
is still RPM_SUSPENDED. So fix it.

    scsi host0: scsi_runtime_suspend()
		ufshcd_runtime_suspend()
    scsi host0: scsi_bus_suspend()
		ufshcd_system_suspend()
    ----------------------------------
		ufshcd_pltfrm_resume()
    scsi host0: scsi_bus_resume()
    scsi host0: scsi_bus_resume_common()
    scsi host0: pm_runtime_set_active(dev)

    scsi host0: runtime PM trying to activate child device host0 but parent
    (8800000.ufshc) is not active

Fixes: 57d104c153d3 ("ufs: add UFS power management support")
Signed-off-by: Yang Yang <yang.yang@vivo.com>
---
 drivers/scsi/ufs/ufshcd.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b8f573a02713..9e666e1ad58c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8767,11 +8767,7 @@ int ufshcd_system_resume(struct ufs_hba *hba)
 	if (!hba)
 		return -EINVAL;
 
-	if (!hba->is_powered || pm_runtime_suspended(hba->dev))
-		/*
-		 * Let the runtime resume take care of resuming
-		 * if runtime suspended.
-		 */
+	if (!hba->is_powered)
 		goto out;
 	else
 		ret = ufshcd_resume(hba, UFS_SYSTEM_PM);
@@ -8779,8 +8775,15 @@ int ufshcd_system_resume(struct ufs_hba *hba)
 	trace_ufshcd_system_resume(dev_name(hba->dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
-	if (!ret)
+	if (!ret) {
 		hba->is_sys_suspended = false;
+
+		if (pm_runtime_suspended(hba->dev)) {
+			pm_runtime_disable(hba->dev);
+			pm_runtime_set_active(hba->dev);
+			pm_runtime_enable(hba->dev);
+		}
+	}
 	return ret;
 }
 EXPORT_SYMBOL(ufshcd_system_resume);
-- 
2.17.1

