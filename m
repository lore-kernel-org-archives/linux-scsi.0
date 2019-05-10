From: Ondrej Zary <linux@zary.sk>
Subject: [PATCH 1/2] fdomain: Remove BIOS-related code from core
Date: Fri, 10 May 2019 23:23:34 +0200
Message-ID: <20190510212335.14728-1-linux@zary.sk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Move all BIOS signature and base handling to (currently not merged) ISA bus
driver.

Signed-off-by: Ondrej Zary <linux@zary.sk>
---
 drivers/scsi/fdomain.c     | 18 ++----------------
 drivers/scsi/fdomain.h     | 10 ----------
 drivers/scsi/fdomain_pci.c |  2 +-
 3 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index e43fdd1ab3a8..f0fda2ad1c7d 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -494,7 +494,6 @@ static struct scsi_host_template fdomain_template = {
 };
 
 struct Scsi_Host *fdomain_create(int base, int irq, int this_id,
-				 unsigned long bios_base, struct signature *sig,
 				 struct device *dev)
 {
 	struct Scsi_Host *sh;
@@ -524,9 +523,6 @@ struct Scsi_Host *fdomain_create(int base, int irq, int this_id,
 
 	if (this_id)
 		sh->this_id = this_id & 0x07;
-	else if (sig && sig->bios_major > 0 &&
-		(sig->bios_major < 3 || sig->bios_minor < 2))
-		sh->this_id = 6;
 
 	sh->irq = irq;
 	sh->io_port = base;
@@ -541,19 +537,9 @@ struct Scsi_Host *fdomain_create(int base, int irq, int this_id,
 			  "fdomain", fd))
 		goto fail_put;
 
-	if (!sig || (sig->bios_major < 0 && sig->bios_minor < 0))
-		shost_printk(KERN_INFO, sh, "No BIOS; using SCSI ID %d\n",
-			     sh->this_id);
-	else {
-		char v1 = (sig->bios_major >= 0) ? '0' + sig->bios_major : '?';
-		char v2 = (sig->bios_minor >= 0) ? '0' + sig->bios_minor : '?';
-
-		shost_printk(KERN_INFO, sh, "BIOS version %c.%c at 0x%lx using SCSI ID %d\n",
-			     v1, v2, bios_base, sh->this_id);
-	}
-	shost_printk(KERN_INFO, sh, "%s chip at 0x%x irq %d\n",
+	shost_printk(KERN_INFO, sh, "%s chip at 0x%x irq %d SCSI ID %d\n",
 		     dev_is_pci(dev) ? "TMC-36C70 (PCI bus)" : chip_names[chip],
-		     base, irq);
+		     base, irq, sh->this_id);
 
 	if (scsi_add_host(sh, dev))
 		goto fail_free_irq;
diff --git a/drivers/scsi/fdomain.h b/drivers/scsi/fdomain.h
index a124a95764d6..fabb2e49461f 100644
--- a/drivers/scsi/fdomain.h
+++ b/drivers/scsi/fdomain.h
@@ -41,15 +41,6 @@ enum out_port_type {
 	Write_FIFO	= 12
 };
 
-struct signature {
-	const char *signature;
-	int offset;
-	int length;
-	int bios_major;
-	int bios_minor;
-	int flag; /* 1 = PCI_bus, 2 = ISA_200S, 3 = ISA_250MG, 4 = ISA_200S */
-};
-
 #ifdef CONFIG_PM_SLEEP
 static const struct dev_pm_ops fdomain_pm_ops;
 #define FDOMAIN_PM_OPS	(&fdomain_pm_ops)
@@ -58,6 +49,5 @@ static const struct dev_pm_ops fdomain_pm_ops;
 #endif /* CONFIG_PM_SLEEP */
 
 struct Scsi_Host *fdomain_create(int base, int irq, int this_id,
-				 unsigned long bios_base, struct signature *sig,
 				 struct device *dev);
 int fdomain_destroy(struct Scsi_Host *sh);
diff --git a/drivers/scsi/fdomain_pci.c b/drivers/scsi/fdomain_pci.c
index 381a7157c078..3e05ce7b89e5 100644
--- a/drivers/scsi/fdomain_pci.c
+++ b/drivers/scsi/fdomain_pci.c
@@ -22,7 +22,7 @@ static int fdomain_pci_probe(struct pci_dev *pdev,
 	if (pci_resource_len(pdev, 0) == 0)
 		goto release_region;
 
-	sh = fdomain_create(pci_resource_start(pdev, 0), pdev->irq, 7, 0, NULL,
+	sh = fdomain_create(pci_resource_start(pdev, 0), pdev->irq, 7,
 			    &pdev->dev);
 	if (!sh)
 		goto release_region;
-- 
Ondrej Zary
