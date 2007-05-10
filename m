From: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Subject: [PATCH] PCI legacy I/O port free driver - Making Emulex lpfc driver
 legacy I/O port free
Date: Thu, 10 May 2007 19:18:05 +0900
Message-ID: <4642F15D.5010203@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail9.fujitsu.co.jp ([192.51.44.39]:52453 "EHLO
	fgwmail9.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760928AbXEJKTi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 May 2007 06:19:38 -0400
Received: from fgwmail7.fujitsu.co.jp (fgwmail7.fujitsu.co.jp [192.51.44.37])
	by fgwmail9.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id l4AAJaPU012253
	for <linux-scsi@vger.kernel.org> (envelope-from kusumi.tomohiro@jp.fujitsu.com);
	Thu, 10 May 2007 19:19:36 +0900
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com, gregkh@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi

As you can see in the "10. pci_enable_device_bars() and Legacy I/O
Port space" of the Documentation/pci.txt, the latest kernel has
interfaces for PCI device drivers to tell the kernel which resource
the driver want to use, ex. I/O port or MMIO.

I've made a patch which makes Emulex lpfc driver legacy I/O port
free by using the PCI core changes I mentioned above. The Emulex
lpfc driver can handle some of its devices without using I/O port.
So this patch changes the driver not to enable/request I/O port
region.

As a result, the driver can handle its device even when there are
huge number of PCI devices being used on the system and no I/O
port region assigned to the device.

Tomohiro Kusumi

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>

---
 lpfc_init.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff -uprN linux-2.6.21.orig/drivers/scsi/lpfc/lpfc_init.c linux-2.6.21/drivers/scsi/lpfc/lpfc_init.c
--- linux-2.6.21.orig/drivers/scsi/lpfc/lpfc_init.c	2007-04-26 12:08:32.000000000 +0900
+++ linux-2.6.21/drivers/scsi/lpfc/lpfc_init.c	2007-05-09 18:22:10.000000000 +0900
@@ -1419,10 +1419,11 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
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
@@ -1734,7 +1735,7 @@ out_put_host:
 	phba->host = NULL;
 	scsi_host_put(host);
 out_release_regions:
-	pci_release_regions(pdev);
+	pci_release_selected_regions(pdev, bars);
 out_disable_device:
 	pci_disable_device(pdev);
 out:
@@ -1748,6 +1749,7 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	struct Scsi_Host   *host = pci_get_drvdata(pdev);
 	struct lpfc_hba    *phba = (struct lpfc_hba *)host->hostdata;
 	unsigned long iflag;
+	int bars = pci_select_bars(pdev, IORESOURCE_MEM);

 	lpfc_free_sysfs_attr(phba);

@@ -1792,7 +1794,7 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	iounmap(phba->ctrl_regs_memmap_p);
 	iounmap(phba->slim_memmap_p);

-	pci_release_regions(phba->pcidev);
+	pci_release_selected_regions(phba->pcidev, bars);
 	pci_disable_device(phba->pcidev);

 	idr_remove(&lpfc_hba_index, phba->brd_no);

