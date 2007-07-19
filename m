From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 7/9] qla2xxx: Use pci_try_set_mwi().
Date: Thu, 19 Jul 2007 15:06:02 -0700
Message-ID: <1184882764384-git-send-email-andrew.vasquez@qlogic.com>
References: <20070719220456.GK4015@plap.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:27113 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763768AbXGSWHG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 18:07:06 -0400
In-Reply-To: <20070719220456.GK4015@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

As the "must-check" return-value of pci_set_msi() is never
really checked.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 622cf8f..3c5fcf8 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -129,14 +129,13 @@ qla2x00_initialize_adapter(scsi_qla_host_t *ha)
 int
 qla2100_pci_config(scsi_qla_host_t *ha)
 {
-	int ret;
 	uint16_t w;
 	uint32_t d;
 	unsigned long flags;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	pci_set_master(ha->pdev);
-	ret = pci_set_mwi(ha->pdev);
+	pci_try_set_mwi(ha->pdev);
 
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
 	w |= (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
@@ -164,7 +163,6 @@ qla2100_pci_config(scsi_qla_host_t *ha)
 int
 qla2300_pci_config(scsi_qla_host_t *ha)
 {
-	int		ret;
 	uint16_t	w;
 	uint32_t	d;
 	unsigned long   flags = 0;
@@ -172,7 +170,7 @@ qla2300_pci_config(scsi_qla_host_t *ha)
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	pci_set_master(ha->pdev);
-	ret = pci_set_mwi(ha->pdev);
+	pci_try_set_mwi(ha->pdev);
 
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
 	w |= (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
@@ -250,14 +248,13 @@ qla2300_pci_config(scsi_qla_host_t *ha)
 int
 qla24xx_pci_config(scsi_qla_host_t *ha)
 {
-	int ret;
 	uint16_t w;
 	uint32_t d;
 	unsigned long flags = 0;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
 	pci_set_master(ha->pdev);
-	ret = pci_set_mwi(ha->pdev);
+	pci_try_set_mwi(ha->pdev);
 
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
 	w |= (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
-- 
1.5.3.rc2.4.g726f9

