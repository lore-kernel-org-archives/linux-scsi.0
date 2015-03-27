From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/3] scsi: ufs: fix unbalanced power.usage_count after reloading driver
Date: Sat, 28 Mar 2015 08:51:46 +0900
Message-ID: <1427500307-5649-3-git-send-email-akinobu.mita@gmail.com>
References: <1427500307-5649-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:33229 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbbC0XwM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2015 19:52:12 -0400
Received: by pdnc3 with SMTP id c3so110969958pdn.0
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 16:52:11 -0700 (PDT)
In-Reply-To: <1427500307-5649-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Maya Erez <merez@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

On driver removal, pm_runtime_get_sync() is called, but
pm_runtime_put_sync() is missed.  So once the driver is reloaded, the
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
index 7db9564..4164108 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -368,6 +368,7 @@ static int ufshcd_pltfrm_remove(struct platform_device *pdev)
 
 	pm_runtime_get_sync(&(pdev)->dev);
 	ufshcd_remove(hba);
+	pm_runtime_put_sync(&pdev->dev);
 	return 0;
 }
 
-- 
1.9.1

