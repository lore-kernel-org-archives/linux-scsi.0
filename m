From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 3/3] mpt fusion: Avoid racing when mptsas and mptcl module are loaded in parallel
Date: Fri, 8 Feb 2008 16:35:40 +0530
Message-ID: <20080208110540.GD20415@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56988 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401AbYBHLKP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Feb 2008 06:10:15 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id m18B7IaM009013
	for <linux-scsi@vger.kernel.org>; Fri, 8 Feb 2008 03:07:18 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com

This patch sets the IOC pointer in drvrdata of pcidev before adding the IOC into the list of IOCs. Without this patch the driver oops when the mptsas and mptctl modules are loaded in parallel.

signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---


diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 355c172..d473146 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1704,6 +1704,9 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc->active = 0;
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
 
+	/* Set IOC ptr in the pcidev's driver data. */
+	pci_set_drvdata(ioc->pcidev, ioc);
+
 	/* Set lookup ptr. */
 	list_add_tail(&ioc->list, &ioc_list);
 
@@ -2074,7 +2077,6 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 			irq_allocated = 1;
 			ioc->pci_irq = ioc->pcidev->irq;
 			pci_set_master(ioc->pcidev);		/* ?? */
-			pci_set_drvdata(ioc->pcidev, ioc);
 			dprintk(ioc, printk(MYIOC_s_INFO_FMT "installed at interrupt "
 			    "%d\n", ioc->name, ioc->pcidev->irq));
 		}
