From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] [SCSI] ufs: fix potential NULL pointer dereferencing error in ufshcd_prove.
Date: Sun, 20 May 2012 03:08:01 -0400
Message-ID: <1337497681-5147-1-git-send-email-linkinjeon@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49775 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab2ETHIL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 May 2012 03:08:11 -0400
Received: by dady13 with SMTP id y13so5500324dad.19
        for <linux-scsi@vger.kernel.org>; Sun, 20 May 2012 00:08:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: santoshsy@gmail.com, vinholikatti@gmail.com, santosh.sy@samsung.com, James.Bottomley@HansenPartnership.com, jBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>

Avoid dereferencing a NULL pointer if scsi_host_alloc is failed.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 drivers/scsi/ufs/ufshcd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e47a0da..58f4ba6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1838,7 +1838,7 @@ ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	err = pci_request_regions(pdev, UFSHCD);
 	if (err < 0) {
 		dev_err(&pdev->dev, "request regions failed\n");
-		goto out_disable;
+		goto out_host_put;
 	}
 
 	hba->mmio_base = pci_ioremap_bar(pdev, 0);
@@ -1927,8 +1927,9 @@ out_iounmap:
 	iounmap(hba->mmio_base);
 out_release_regions:
 	pci_release_regions(pdev);
-out_disable:
+out_host_put:
 	scsi_host_put(host);
+out_disable:
 	pci_clear_master(pdev);
 	pci_disable_device(pdev);
 out_error:
-- 
1.7.9.5

