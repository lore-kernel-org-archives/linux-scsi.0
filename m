From: Akinobu Mita <mita@fixstars.com>
Subject: [PATCH v2 2/3] ufs: don't disable_irq() if the IRQ can be shared among devices
Date: Sat, 20 Jul 2013 09:41:24 +0900
Message-ID: <1374280885-11526-3-git-send-email-mita@fixstars.com>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo.fixstars.hdemail.jp ([176.34.54.138]:45367 "EHLO
	mo.fixstars.hdemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab3GTAqG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jul 2013 20:46:06 -0400
In-Reply-To: <1374280885-11526-1-git-send-email-mita@fixstars.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <mita@fixstars.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

When removing the UFS driver, disable_irq() is called and the IRQ is
not enabled again.  Unfortunately, the IRQ is requested with IRQF_SHARED
and it can be shared among several devices.  So disabling the IRQ in
this way is just breaking other devices which are sharing the IRQ.

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd-pci.c    | 1 -
 drivers/scsi/ufs/ufshcd-pltfrm.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index de4c52b..2349c0e 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -91,7 +91,6 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
 {
 	struct ufs_hba *hba = pci_get_drvdata(pdev);
 
-	disable_irq(pdev->irq);
 	ufshcd_remove(hba);
 	pci_set_drvdata(pdev, NULL);
 }
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index c42db40..94ba40c 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -144,7 +144,6 @@ static int ufshcd_pltfrm_remove(struct platform_device *pdev)
 {
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
 
-	disable_irq(hba->irq);
 	ufshcd_remove(hba);
 	return 0;
 }
-- 
1.8.3.1

