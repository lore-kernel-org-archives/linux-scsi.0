From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 15/22] advansys: Use DRV_NAME
Date: Sun,  9 Sep 2007 08:56:40 -0600
Message-ID: <1189349807367-git-send-email-matthew@wil.cx>
References: <20070909145358.GG6809@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:50275 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382AbXIIO45 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 10:56:57 -0400
In-Reply-To: <20070909145358.GG6809@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Follow the example of some other drivers by defining DRV_NAME to be
"advansys".  Prevents spelling mistakes.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index e5b26a1..0303fc7 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -1,3 +1,4 @@
+#define DRV_NAME "advansys"
 #define ASC_VERSION "3.4"	/* AdvanSys Driver Version */
 
 /*
@@ -3213,11 +3214,11 @@ advansys_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 }
 
 static struct scsi_host_template advansys_template = {
-	.proc_name = "advansys",
+	.proc_name = DRV_NAME,
 #ifdef CONFIG_PROC_FS
 	.proc_info = advansys_proc_info,
 #endif
-	.name = "advansys",
+	.name = DRV_NAME,
 	.info = advansys_info,
 	.queuecommand = advansys_queuecommand,
 	.eh_bus_reset_handler = advansys_reset,
@@ -14634,7 +14635,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		/* Register DMA channel for ISA bus. */
 		if (asc_dvc_varp->bus_type & ASC_IS_ISA) {
 			shost->dma_channel = asc_dvc_varp->cfg->isa_dma_channel;
-			ret = request_dma(shost->dma_channel, "advansys");
+			ret = request_dma(shost->dma_channel, DRV_NAME);
 			if (ret) {
 				ASC_PRINT3
 				    ("advansys_board_found: board %d: request_dma() %d failed %d\n",
@@ -14650,7 +14651,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	ASC_DBG1(2, "advansys_board_found: request_irq() %d\n", shost->irq);
 
 	ret = request_irq(shost->irq, advansys_interrupt, share_irq,
-			  "advansys", shost);
+			  DRV_NAME, shost);
 
 	if (ret) {
 		if (ret == -EBUSY) {
@@ -14754,7 +14755,7 @@ static int __devinit advansys_isa_probe(struct device *dev, unsigned int id)
 	PortAddr iop_base = _asc_def_iop_base[id];
 	struct Scsi_Host *shost;
 
-	if (!request_region(iop_base, ASC_IOADR_GAP, "advansys")) {
+	if (!request_region(iop_base, ASC_IOADR_GAP, DRV_NAME)) {
 		ASC_DBG1(1, "advansys_isa_match: I/O port 0x%x busy\n",
 			 iop_base);
 		return -ENODEV;
@@ -14790,7 +14791,7 @@ static struct isa_driver advansys_isa_driver = {
 	.remove		= __devexit_p(advansys_isa_remove),
 	.driver = {
 		.owner	= THIS_MODULE,
-		.name	= "advansys",
+		.name	= DRV_NAME,
 	},
 };
 
@@ -14799,7 +14800,7 @@ static int __devinit advansys_vlb_probe(struct device *dev, unsigned int id)
 	PortAddr iop_base = _asc_def_iop_base[id];
 	struct Scsi_Host *shost;
 
-	if (!request_region(iop_base, ASC_IOADR_GAP, "advansys")) {
+	if (!request_region(iop_base, ASC_IOADR_GAP, DRV_NAME)) {
 		ASC_DBG1(1, "advansys_vlb_match: I/O port 0x%x busy\n",
 			 iop_base);
 		return -ENODEV;
@@ -14867,7 +14868,7 @@ static int __devinit advansys_eisa_probe(struct device *dev)
 
 	err = -ENODEV;
 	for (i = 0; i < 2; i++, ioport += 0x20) {
-		if (!request_region(ioport, ASC_IOADR_GAP, "advansys")) {
+		if (!request_region(ioport, ASC_IOADR_GAP, DRV_NAME)) {
 			printk(KERN_WARNING "Region %x-%x busy\n", ioport,
 			       ioport + ASC_IOADR_GAP - 1);
 			continue;
@@ -14925,7 +14926,7 @@ static __devexit int advansys_eisa_remove(struct device *dev)
 static struct eisa_driver advansys_eisa_driver = {
 	.id_table =		advansys_eisa_table,
 	.driver = {
-		.name =		"advansys",
+		.name =		DRV_NAME,
 		.probe =	advansys_eisa_probe,
 		.remove =	__devexit_p(advansys_eisa_remove),
 	}
@@ -14972,7 +14973,7 @@ advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = pci_enable_device(pdev);
 	if (err)
 		goto fail;
-	err = pci_request_regions(pdev, "advansys");
+	err = pci_request_regions(pdev, DRV_NAME);
 	if (err)
 		goto disable_device;
 	pci_set_master(pdev);
@@ -15007,7 +15008,7 @@ static void __devexit advansys_pci_remove(struct pci_dev *pdev)
 }
 
 static struct pci_driver advansys_pci_driver = {
-	.name =		"advansys",
+	.name =		DRV_NAME,
 	.id_table =	advansys_pci_tbl,
 	.probe =	advansys_pci_probe,
 	.remove =	__devexit_p(advansys_pci_remove),
-- 
1.5.2.4

