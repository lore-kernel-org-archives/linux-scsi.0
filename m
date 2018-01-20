From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: 3ware: use pci_iounmap instead of iounmap
Date: Sat, 20 Jan 2018 07:12:22 +0100
Message-ID: <20180120061222.29166-1-christophe.jaillet@wanadoo.fr>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:27537 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbeATGMt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Jan 2018 01:12:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aradford@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>

'base_addr' has been mapped using 'pci_iomap()'. It should be freed with
the corresponding 'pci_iounmap()' instead of 'iomap()'.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/3w-sas.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index cf9f2a09b47d..231b04dd9076 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1692,7 +1692,7 @@ static int twl_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 		pci_disable_msi(pdev);
 	scsi_remove_host(host);
 out_iounmap:
-	iounmap(tw_dev->base_addr);
+	pci_iounmap(pdev, tw_dev->base_addr);
 out_release_mem_region:
 	pci_release_regions(pdev);
 out_free_device_extension:
@@ -1738,7 +1738,7 @@ static void twl_remove(struct pci_dev *pdev)
 		pci_disable_msi(pdev);
 
 	/* Free IO remapping */
-	iounmap(tw_dev->base_addr);
+	pci_iounmap(pdev, tw_dev->base_addr);
 
 	/* Free up the mem region */
 	pci_release_regions(pdev);
-- 
2.14.1
