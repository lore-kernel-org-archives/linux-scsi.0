From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 3/6] scsi: ufs: fix unbalanced power.disable_depth after reloading driver
Date: Sun,  2 Aug 2015 02:19:17 +0900
Message-ID: <1438449560-4106-4-git-send-email-akinobu.mita@gmail.com>
References: <1438449560-4106-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34216 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbbHARTv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Aug 2015 13:19:51 -0400
Received: by pacan13 with SMTP id an13so60204941pac.1
        for <linux-scsi@vger.kernel.org>; Sat, 01 Aug 2015 10:19:51 -0700 (PDT)
In-Reply-To: <1438449560-4106-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Maya Erez <merez@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

Every time the driver is reloaded, the warning message
"Unbalanced pm_runtime_enable!" is triggered due to unbalanced
power.disable_depth.  This is because pm_runtime_enable() is called
during driver probe but pm_runtime_disable() is missed on driver remove.

This also restores the device's runtime PM status to 'suspended' on
driver remove as it was set to 'active' during driver probe.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>
Cc: Raviv Shvili <rshvili@codeaurora.org>
Cc: Sahitya Tummala <stummala@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 9beac71..12f1246 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -369,6 +369,10 @@ static int ufshcd_pltfrm_remove(struct platform_device *pdev)
 	pm_runtime_get_sync(&(pdev)->dev);
 	ufshcd_remove(hba);
 	pm_runtime_put_noidle(&pdev->dev);
+
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
+
 	return 0;
 }
 
-- 
1.9.1

