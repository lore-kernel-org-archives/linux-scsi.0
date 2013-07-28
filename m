From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 6/9] ufs: don't disable_irq() if the IRQ can be shared among devices
Date: Sun, 28 Jul 2013 22:40:34 +0530
Message-ID: <1375031437-10206-7-git-send-email-santoshsy@gmail.com>
References: <1375031437-10206-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:35361 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3G1RMk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jul 2013 13:12:40 -0400
Received: by mail-pb0-f41.google.com with SMTP id rp16so3825545pbb.28
        for <linux-scsi@vger.kernel.org>; Sun, 28 Jul 2013 10:12:40 -0700 (PDT)
In-Reply-To: <1375031437-10206-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Akinobu Mita <mita@fixstars.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Santosh Y <santoshsy@gmail.com>

From: Akinobu Mita <mita@fixstars.com>

When removing the UFS driver, disable_irq() is called and the IRQ is
not enabled again.  Unfortunately, the IRQ is requested with IRQF_SHARED
and it can be shared among several devices.  So disabling the IRQ in
this way is just breaking other devices which are sharing the IRQ.

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 24d6ba7..a823cf4 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -131,8 +131,6 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
 
 	pm_runtime_forbid(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
-
-	disable_irq(pdev->irq);
 	ufshcd_remove(hba);
 	pci_set_drvdata(pdev, NULL);
 }
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index cc957fc..13b8c5a 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -186,8 +186,6 @@ static int ufshcd_pltfrm_remove(struct platform_device *pdev)
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
 
 	pm_runtime_get_sync(&(pdev)->dev);
-
-	disable_irq(hba->irq);
 	ufshcd_remove(hba);
 	return 0;
 }
-- 
1.8.3.1

