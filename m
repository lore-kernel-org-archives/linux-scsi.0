From: Richard A Lary <rlary@linux.vnet.ibm.com>
Subject: [PATCH] mpt2sas: use correct pci_resource_flag for comparison with
 device pci ,resource
Date: Fri, 12 Mar 2010 15:27:06 -0800
Message-ID: <4B9ACDCA.6080803@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41653 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934705Ab0CLX1Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 18:27:16 -0500
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e4.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o2CNGCEG004392
	for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2010 18:16:12 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2CNRFfh1454124
	for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2010 18:27:15 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2CNRFRg031783
	for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2010 20:27:15 -0300
Received: from [127.0.0.1] (sig-9-48-87-249.mts.ibm.com [9.48.87.249])
	by d01av03.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVin) with ESMTP id o2CNRCb7031768
	for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2010 20:27:14 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Richard A Lary <rlary@linux.vnet.ibm.com>

This patch replaces incorrect  base address space flag with correct IO 
resource
flag.  Also, performs check of memory resource to validate resource before
using.

Signed-off-by: Richard A Lary <rlary@linux.vnet.ibm.com>

---

Index: b/drivers/scsi/mpt2sas/mpt2sas_base.c
===================================================================
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1253,7 +1253,7 @@ mpt2sas_base_map_resources(struct MPT2SA
  	}

  	for (i = 0, memap_sz = 0, pio_sz = 0 ; i < DEVICE_COUNT_RESOURCE; i++) {
-		if (pci_resource_flags(pdev, i) & PCI_BASE_ADDRESS_SPACE_IO) {
+		if (pci_resource_flags(pdev, i) & IORESOURCE_IO) {
  			if (pio_sz)
  				continue;
  			pio_chip = (u64)pci_resource_start(pdev, i);
@@ -1261,15 +1261,18 @@ mpt2sas_base_map_resources(struct MPT2SA
  		} else {
  			if (memap_sz)
  				continue;
-			ioc->chip_phys = pci_resource_start(pdev, i);
-			chip_phys = (u64)ioc->chip_phys;
-			memap_sz = pci_resource_len(pdev, i);
-			ioc->chip = ioremap(ioc->chip_phys, memap_sz);
-			if (ioc->chip == NULL) {
-				printk(MPT2SAS_ERR_FMT "unable to map adapter "
-				    "memory!\n", ioc->name);
-				r = -EINVAL;
-				goto out_fail;
+			/* verify memory resource is valid before using */
+			if (pci_resource_flags(pdev, i) & IORESOURCE_MEM) {
+				ioc->chip_phys = pci_resource_start(pdev, i);
+				chip_phys = (u64)ioc->chip_phys;
+				memap_sz = pci_resource_len(pdev, i);
+				ioc->chip = ioremap(ioc->chip_phys, memap_sz);
+				if (ioc->chip == NULL) {
+					printk(MPT2SAS_ERR_FMT "unable to map "
+					    "adapter memory!\n", ioc->name);
+					r = -EINVAL;
+					goto out_fail;
+				}
  			}
  		}
  	}

