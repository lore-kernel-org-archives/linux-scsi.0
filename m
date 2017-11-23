From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 1/3] scsi: arcmsr: Add driver module parameter msi_enable
Date: Thu, 23 Nov 2017 09:27:19 +0800
Message-ID: <1511400439.9832.19.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:38751 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751842AbdKWJ1X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Nov 2017 04:27:23 -0500
Received: by mail-io0-f175.google.com with SMTP id h205so25270584iof.5
        for <linux-scsi@vger.kernel.org>; Thu, 23 Nov 2017 01:27:23 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hare@suse.de, dan.carpenter@oracle.com, hch@infradead.org

From: Ching Huang <ching2048@areca.com.tw>

Add module parameter msi_enable to has a chance to disable msi interrupt if it does not work properly.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-23 14:29:26.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-23 16:02:28.000000000 +0800
@@ -75,6 +75,10 @@ MODULE_DESCRIPTION("Areca ARC11xx/12xx/1
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);
 
+static int msi_enable = 1;
+module_param(msi_enable, int, S_IRUGO);
+MODULE_PARM_DESC(msi_enable, " Enable MSI interrupt(0 ~ 1), msi_enable=1(enable), =0(disable)");
+
 static int host_can_queue = ARCMSR_DEFAULT_OUTSTANDING_CMD;
 module_param(host_can_queue, int, S_IRUGO);
 MODULE_PARM_DESC(host_can_queue, " adapter queue depth(32 ~ 1024), default is 128");
@@ -831,11 +835,15 @@ arcmsr_request_irq(struct pci_dev *pdev,
 		pr_info("arcmsr%d: msi-x enabled\n", acb->host->host_no);
 		flags = 0;
 	} else {
-		nvec = pci_alloc_irq_vectors(pdev, 1, 1,
-				PCI_IRQ_MSI | PCI_IRQ_LEGACY);
+		if (msi_enable == 1)
+			nvec = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_MSI);
+		else
+			nvec = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_LEGACY);
 		if (nvec < 1)
 			return FAILED;
 
+		if (msi_enable == 1)
+			pr_info("arcmsr%d: msi enabled\n", acb->host->host_no);
 		flags = IRQF_SHARED;
 	}
 
