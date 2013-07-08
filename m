From: Akinobu Mita <mita@fixstars.com>
Subject: [PATCH 2/2] ufs: don't stop controller before scsi_remove_host()
Date: Mon,  8 Jul 2013 21:50:24 +0900
Message-ID: <1373287824-4038-2-git-send-email-mita@fixstars.com>
References: <1373287824-4038-1-git-send-email-mita@fixstars.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo.fixstars.hdemail.jp ([176.34.54.138]:57077 "EHLO
	mo.fixstars.hdemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3GHMzF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jul 2013 08:55:05 -0400
In-Reply-To: <1373287824-4038-1-git-send-email-mita@fixstars.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <mita@fixstars.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

scsi_remove_host() sends SYNCHRONIZE CACHE commands for write cache
enabled scsi disk devices.  So stopping controller working shouldn't
be done before scsi_remove_host().

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd-pci.c    | 1 -
 drivers/scsi/ufs/ufshcd-pltfrm.c | 1 -
 drivers/scsi/ufs/ufshcd.c        | 3 ++-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index c34efb9..91a2e79 100644
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
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index cfa9633..f2832b8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1657,11 +1657,12 @@ EXPORT_SYMBOL_GPL(ufshcd_resume);
  */
 void ufshcd_remove(struct ufs_hba *hba)
 {
+	scsi_remove_host(hba->host);
 	/* disable interrupts */
+	disable_irq(hba->irq);
 	ufshcd_disable_intr(hba, hba->intr_mask);
 	ufshcd_hba_stop(hba);
 
-	scsi_remove_host(hba->host);
 	scsi_host_put(hba->host);
 }
 EXPORT_SYMBOL_GPL(ufshcd_remove);
-- 
1.8.1.4

