From: Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH] 3w-9xxx: use PCI resource length correctly
Date: Fri, 28 Sep 2007 11:45:56 -0300
Message-ID: <20070928144556.GG4668@blackpad.ctb.virtua.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939AbXI1OqI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Sep 2007 10:46:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxraid@amcc.com
Cc: linux-scsi@vger.kernel.org

Trying to ioremap() a larger area than pci_resource_len()
may fail (e.g. under Xen). Fixes 3w-9xxx to use pci_resource_len()
as length parameter to ioremap() instead of PAGE_SIZE.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 drivers/scsi/3w-9xxx.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index efd9d8d..885b340 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1999,7 +1999,8 @@ static int __devinit twa_probe(struct pci_dev *pdev, const struct pci_device_id
 {
 	struct Scsi_Host *host = NULL;
 	TW_Device_Extension *tw_dev;
-	u32 mem_addr;
+	int bar;
+	unsigned long mem_addr, mem_len;
 	int retval = -ENODEV;
 
 	retval = pci_enable_device(pdev);
@@ -2046,12 +2047,15 @@ static int __devinit twa_probe(struct pci_dev *pdev, const struct pci_device_id
 	}
 
 	if (pdev->device == PCI_DEVICE_ID_3WARE_9000)
-		mem_addr = pci_resource_start(pdev, 1);
+		bar = 1;
 	else
-		mem_addr = pci_resource_start(pdev, 2);
+		bar = 2;
+
+	mem_addr = pci_resource_start(pdev, bar);
+	mem_len = pci_resource_len(pdev, bar);
 
 	/* Save base address */
-	tw_dev->base_addr = ioremap(mem_addr, PAGE_SIZE);
+	tw_dev->base_addr = ioremap(mem_addr, mem_len);
 	if (!tw_dev->base_addr) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x35, "Failed to ioremap");
 		goto out_release_mem_region;
@@ -2086,7 +2090,7 @@ static int __devinit twa_probe(struct pci_dev *pdev, const struct pci_device_id
 
 	pci_set_drvdata(pdev, host);
 
-	printk(KERN_WARNING "3w-9xxx: scsi%d: Found a 3ware 9000 Storage Controller at 0x%x, IRQ: %d.\n",
+	printk(KERN_WARNING "3w-9xxx: scsi%d: Found a 3ware 9000 Storage Controller at 0x%lx, IRQ: %d.\n",
 	       host->host_no, mem_addr, pdev->irq);
 	printk(KERN_WARNING "3w-9xxx: scsi%d: Firmware %s, BIOS %s, Ports: %d.\n",
 	       host->host_no,
-- 
1.5.3.rc1.gaf83
