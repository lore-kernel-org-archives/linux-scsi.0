From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 15/17] scsi: arcmsr: Add driver module parameter msi_enable
Date: Tue, 05 Dec 2017 10:24:01 +0800
Message-ID: <1512440641.4577.80.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:37727 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753266AbdLEKYK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2017 05:24:10 -0500
Received: by mail-pg0-f53.google.com with SMTP id y6so10382298pgp.4
        for <linux-scsi@vger.kernel.org>; Tue, 05 Dec 2017 02:24:10 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, sfr@canb.auug.org.au

From: Ching Huang <ching2048@areca.com.tw>

Add module parameter msi_enable to has a chance to disable msi interrupt if between controller and system has
msi INT compatible issue.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-12-05 11:44:36.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-12-05 16:59:58.000000000 +0800
@@ -75,6 +75,10 @@ MODULE_DESCRIPTION("Areca ARC11xx/12xx/1
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);
 
+static int msi_enable = 1;
+module_param(msi_enable, int, S_IRUGO);
+MODULE_PARM_DESC(msi_enable, "Enable MSI interrupt(0 ~ 1), msi_enable=1(enable), =0(disable)");
+
 static int host_can_queue = ARCMSR_DEFAULT_OUTSTANDING_CMD;
 module_param(host_can_queue, int, S_IRUGO);
 MODULE_PARM_DESC(host_can_queue, " adapter queue depth(32 ~ 1024), default is 128");
@@ -831,11 +835,17 @@ arcmsr_request_irq(struct pci_dev *pdev,
 		pr_info("arcmsr%d: msi-x enabled\n", acb->host->host_no);
 		flags = 0;
 	} else {
-		nvec = pci_alloc_irq_vectors(pdev, 1, 1,
-				PCI_IRQ_MSI | PCI_IRQ_LEGACY);
+		if (msi_enable == 1) {
+			nvec = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_MSI);
+			if (nvec == 1) {
+				dev_info(&pdev->dev, "msi enabled\n");
+				goto msi_int1;
+			}
+		}
+		nvec = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_LEGACY);
 		if (nvec < 1)
 			return FAILED;
-
+msi_int1:
 		flags = IRQF_SHARED;
 	}
 
