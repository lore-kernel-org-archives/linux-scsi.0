From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 01/20] [SCSI] lpfc 8.3.42: remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 09:55:51 +0900
Message-ID: <000501ceb7f7$a6446b70$f2cd4250$%han@samsung.com>
References: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:61874 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab3IWAzx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Sep 2013 20:55:53 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MTJ00COWZWQUW90@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 23 Sep 2013 09:55:51 +0900 (KST)
In-reply-to: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'James Smart' <james.smart@emulex.com>, 'Jingoo Han' <jg1.han@samsung.com>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/lpfc/lpfc_init.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 647f5bf..3dfd38c 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4581,8 +4581,6 @@ lpfc_disable_pci_dev(struct lpfc_hba *phba)
 	/* Release PCI resource and disable PCI device */
 	pci_release_selected_regions(pdev, bars);
 	pci_disable_device(pdev);
-	/* Null out PCI private reference to driver */
-	pci_set_drvdata(pdev, NULL);
 
 	return;
 }
@@ -9429,7 +9427,6 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
 	/* Disable interrupt */
 	lpfc_sli_disable_intr(phba);
 
-	pci_set_drvdata(pdev, NULL);
 	scsi_host_put(shost);
 
 	/*
-- 
1.7.10.4


