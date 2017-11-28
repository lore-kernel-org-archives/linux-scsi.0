From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v2 2/3] scsi: arcmsr: Add driver module parameter
 msix_enable
Date: Tue, 28 Nov 2017 09:32:24 +0800
Message-ID: <1511832744.4399.24.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dan.carpenter@oracle.com, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

Add module parameter msix_enable to has a chance to disable msix interrupt if between controller and system has
msix INT compatible issue.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-24 15:16:20.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-24 15:17:46.000000000 +0800
@@ -75,6 +75,10 @@ MODULE_DESCRIPTION("Areca ARC11xx/12xx/1
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);
 
+static int msix_enable = 1;
+module_param(msix_enable, int, S_IRUGO);
+MODULE_PARM_DESC(msix_enable, "Enable MSI-X interrupt(0 ~ 1), msix_enable=1(enable), =0(disable)");
+
 static int msi_enable = 1;
 module_param(msi_enable, int, S_IRUGO);
 MODULE_PARM_DESC(msi_enable, "Enable MSI interrupt(0 ~ 1), msi_enable=1(enable), =0(disable)");
@@ -829,12 +833,15 @@ arcmsr_request_irq(struct pci_dev *pdev,
 	unsigned long flags;
 	int nvec, i;
 
+	if (msix_enable == 0)
+		goto msi_int0;
 	nvec = pci_alloc_irq_vectors(pdev, 1, ARCMST_NUM_MSIX_VECTORS,
 			PCI_IRQ_MSIX);
 	if (nvec > 0) {
 		pr_info("arcmsr%d: msi-x enabled\n", acb->host->host_no);
 		flags = 0;
 	} else {
+msi_int0:
 		if (msi_enable == 1) {
 			nvec = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_MSI);
 			if (nvec == 1) {
