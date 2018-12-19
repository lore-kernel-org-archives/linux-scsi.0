From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 2/12] scsi: arcmsr: Rename arcmsr_free_mu to
 arcmsr_free_io_queue
Date: Wed, 19 Dec 2018 16:27:20 +0800
Message-ID: <1545208040.4457.18.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

>From Ching Huang <ching2048@areca.com.tw>

Rename arcmsr_free_mu to arcmsr_free_io_queue

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index f3a7855..f831c13 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -223,7 +223,7 @@ static struct pci_driver arcmsr_pci_driver = {
 ****************************************************************************
 */
 
-static void arcmsr_free_mu(struct AdapterControlBlock *acb)
+static void arcmsr_free_io_queue(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_B:
@@ -990,7 +990,7 @@ scsi_host_remove:
 free_ccb_pool:
 	arcmsr_free_ccb_pool(acb);
 free_hbb_mu:
-	arcmsr_free_mu(acb);
+	arcmsr_free_io_queue(acb);
 unmap_pci_region:
 	arcmsr_unmap_pciregion(acb);
 pci_release_regs:
@@ -1500,7 +1500,7 @@ static void arcmsr_free_pcidev(struct AdapterControlBlock *acb)
 	pdev = acb->pdev;
 	arcmsr_free_irq(pdev, acb);
 	arcmsr_free_ccb_pool(acb);
-	arcmsr_free_mu(acb);
+	arcmsr_free_io_queue(acb);
 	arcmsr_unmap_pciregion(acb);
 	pci_release_regions(pdev);
 	scsi_host_put(host);
@@ -1558,7 +1558,7 @@ static void arcmsr_remove(struct pci_dev *pdev)
 	}
 	arcmsr_free_irq(pdev, acb);
 	arcmsr_free_ccb_pool(acb);
-	arcmsr_free_mu(acb);
+	arcmsr_free_io_queue(acb);
 	arcmsr_unmap_pciregion(acb);
 	pci_release_regions(pdev);
 	scsi_host_put(host);
