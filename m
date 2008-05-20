From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 3/6] : Fixing default enabling of MSI for SPI and FC controllers
Date: Wed, 21 May 2008 00:57:42 +0530
Message-ID: <20080520192741.GD11542@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42562 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594AbYETTgU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2008 15:36:20 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id m4KJWYn6019813
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2008 12:32:34 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com


The patch submitted to enable the MSI by default for SAS controllers
sets the MSI even for SPI and FC controllers due to a coding error
This patch fixes that.

Signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 9538df2..ff9965d 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -2062,7 +2062,8 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 	if ((ret == 0) && (reason == MPT_HOSTEVENT_IOC_BRINGUP)) {
 		ioc->pci_irq = -1;
 		if (ioc->pcidev->irq) {
-			if (ioc->msi_enable && !pci_enable_msi(ioc->pcidev))
+			if (ioc->msi_enable == 1 &&
+					!pci_enable_msi(ioc->pcidev))
 				printk(MYIOC_s_INFO_FMT "PCI-MSI enabled\n",
 				    ioc->name);
 			else
@@ -2072,7 +2073,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 			if (rc < 0) {
 				printk(MYIOC_s_ERR_FMT "Unable to allocate "
 				    "interrupt %d!\n", ioc->name, ioc->pcidev->irq);
-				if (ioc->msi_enable)
+				if (ioc->msi_enable == 1)
 					pci_disable_msi(ioc->pcidev);
 				return -EBUSY;
 			}
@@ -2268,7 +2269,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
  out:
 	if ((ret != 0) && irq_allocated) {
 		free_irq(ioc->pci_irq, ioc);
-		if (ioc->msi_enable)
+		if (ioc->msi_enable == 1)
 			pci_disable_msi(ioc->pcidev);
 	}
 	return ret;
@@ -2450,7 +2451,7 @@ mpt_adapter_dispose(MPT_ADAPTER *ioc)
 
 	if (ioc->pci_irq != -1) {
 		free_irq(ioc->pci_irq, ioc);
-		if (ioc->msi_enable)
+		if (ioc->msi_enable == 1)
 			pci_disable_msi(ioc->pcidev);
 		ioc->pci_irq = -1;
 	}
