From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 2/6] scsi: ufs: fix unbalanced power.usage_count after reloading driver
Date: Sun,  2 Aug 2015 02:19:16 +0900
Message-ID: <1438449560-4106-3-git-send-email-akinobu.mita@gmail.com>
References: <1438449560-4106-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34193 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbbHARTr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Aug 2015 13:19:47 -0400
Received: by pacan13 with SMTP id an13so60204284pac.1
        for <linux-scsi@vger.kernel.org>; Sat, 01 Aug 2015 10:19:46 -0700 (PDT)
In-Reply-To: <1438449560-4106-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Maya Erez <merez@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

On driver removal, pm_runtime_get_sync() is called, but
pm_runtime_put_*() is missed.  So once the driver is reloaded, the
device's power.usage_count is unbalanced and the idle callback for the
device will never be called.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>
Cc: Sahitya Tummala <stummala@codeaurora.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 7db9564..9beac71 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -368,6 +368,7 @@ static int ufshcd_pltfrm_remove(struct platform_device *pdev)
 
 	pm_runtime_get_sync(&(pdev)->dev);
 	ufshcd_remove(hba);
+	pm_runtime_put_noidle(&pdev->dev);
 	return 0;
 }
 
-- 
1.9.1

