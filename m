From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v2 1/3] scsi: arcmsr: Add driver module parameter msi_enable
Date: Tue, 28 Nov 2017 09:28:44 +0800
Message-ID: <1511832524.4399.20.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dan.carpenter@oracle.com, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

Add module parameter msi_enable to has a chance to disable msi interrupt if between controller and system has
msi INT compatible issue.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-23 14:29:26.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-24 15:16:20.000000000 +0800
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
 
