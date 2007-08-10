From: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Subject: [PATCH][Take2] PCI legacy I/O port free driver - Making Emulex lpfc
 driver legacy I/O port free
Date: Fri, 10 Aug 2007 18:10:07 +0900
Message-ID: <46BC2B6F.9060508@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52509 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386AbXHJJJz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Aug 2007 05:09:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com, gregkh@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi

This patch makes Emulex lpfc driver legacy I/O port free.
It has already been acked quite long time ago.
So I resubmit the patch.
http://lkml.org/lkml/2006/11/22/28

Current lpfc driver is already using pci_select_bars()
and pci_enable_device_bars() when the PCI bus has been reset.
So I think this patch should also be acked.

Tomohiro Kusumi

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>

---
diff -Nurp linux-2.6.22.org/drivers/scsi/lpfc/lpfc_init.c linux-2.6.22/drivers/scsi/lpfc/lpfc_init.c
--- linux-2.6.22.org/drivers/scsi/lpfc/lpfc_init.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/drivers/scsi/lpfc/lpfc_init.c	2007-08-10 17:11:55.000000000 +0900
@@ -1356,6 +1356,7 @@ lpfc_scsi_free(struct lpfc_hba * phba)
 void lpfc_remove_device(struct lpfc_hba *phba)
 {
 	unsigned long iflag;
+	int bars = pci_select_bars(phba->pcidev, IORESOURCE_MEM);

 	lpfc_free_sysfs_attr(phba);

@@ -1400,7 +1401,7 @@ void lpfc_remove_device(struct lpfc_hba
 	iounmap(phba->ctrl_regs_memmap_p);
 	iounmap(phba->slim_memmap_p);

-	pci_release_regions(phba->pcidev);
+	pci_release_selected_regions(phba->pcidev, bars);
 	pci_disable_device(phba->pcidev);

 	idr_remove(&lpfc_hba_index, phba->brd_no);
@@ -1515,10 +1516,11 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	int error = -ENODEV, retval;
 	int i;
 	uint16_t iotag;
+	int bars = pci_select_bars(pdev, IORESOURCE_MEM);

-	if (pci_enable_device(pdev))
+	if (pci_enable_device_bars(pdev, bars))
 		goto out;
-	if (pci_request_regions(pdev, LPFC_DRIVER_NAME))
+	if (pci_request_selected_regions(pdev, bars, LPFC_DRIVER_NAME))
 		goto out_disable_device;

 	host = scsi_host_alloc(&lpfc_template, sizeof (struct lpfc_hba));
@@ -1748,7 +1750,7 @@ out_put_host:
 	phba->host = NULL;
 	scsi_host_put(host);
 out_release_regions:
-	pci_release_regions(pdev);
+	pci_release_selected_regions(pdev, bars);
 out_disable_device:
 	pci_disable_device(pdev);

