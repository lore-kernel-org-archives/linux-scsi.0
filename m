From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/8] fusion - adding MSI support
Date: Tue, 17 Jan 2006 13:44:29 +0000
Message-ID: <20060117134429.GF9152@infradead.org>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAC84@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:9160 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932488AbWAQNof (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2006 08:44:35 -0500
Content-Disposition: inline
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAC84@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Jan 16, 2006 at 06:53:24PM -0700, Moore, Eric wrote:
> Adding MSI support, and command line for enabling 
> it.  By default, the command line option has MSI disabled.

mpt_msi_enable is initialized to 0 implicitly, no need to do that.  Also
replace if (mpt_msi_enable == 1) tests with just if (mpt_msi_enable).

Updated patch below:

Index: linux-2.6/drivers/message/fusion/mptbase.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptbase.c	2006-01-17 14:12:03.000000000 +0100
+++ linux-2.6/drivers/message/fusion/mptbase.c	2006-01-17 14:13:53.000000000 +0100
@@ -81,6 +81,10 @@
 /*
  *  cmd line parameters
  */
+static int mpt_msi_enable;
+module_param(mpt_msi_enable, int, 0);
+MODULE_PARM_DESC(mpt_msi_enable, " MSI Support Enable (default=0)");
+
 #ifdef MFCNT
 static int mfcounter = 0;
 #define PRINT_MF_COUNT 20000
@@ -1444,6 +1448,9 @@
 
 	ioc->pci_irq = -1;
 	if (pdev->irq) {
+		if (mpt_msi_enable && !pci_enable_msi(pdev))
+			printk(MYIOC_s_INFO_FMT "PCI-MSI enabled\n", ioc->name);
+
 		r = request_irq(pdev->irq, mpt_interrupt, SA_SHIRQ, ioc->name, ioc);
 
 		if (r < 0) {
@@ -1483,6 +1490,8 @@
 
 		list_del(&ioc->list);
 		free_irq(ioc->pci_irq, ioc);
+		if (mpt_msi_enable)
+			pci_disable_msi(pdev);
 		iounmap(mem);
 		kfree(ioc);
 		pci_set_drvdata(pdev, NULL);
@@ -2136,6 +2145,8 @@
 
 	if (ioc->pci_irq != -1) {
 		free_irq(ioc->pci_irq, ioc);
+		if (mpt_msi_enable)
+			pci_disable_msi(ioc->pcidev);
 		ioc->pci_irq = -1;
 	}
 
