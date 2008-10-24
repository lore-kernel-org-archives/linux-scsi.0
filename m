From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/5] qla2xxx: Use pci_disable_rom() to manipulate PCI config space.
Date: Fri, 24 Oct 2008 15:13:45 -0700
Message-ID: <1224886428-31799-3-git-send-email-andrew.vasquez@qlogic.com>
References: <1224886428-31799-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:14169 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbYJXWNx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Oct 2008 18:13:53 -0400
In-Reply-To: <1224886428-31799-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

http://bugzilla.kernel.org/show_bug.cgi?id=9422

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   24 ++++--------------------
 1 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a470f2d..ecf91ad 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -140,7 +140,6 @@ int
 qla2100_pci_config(scsi_qla_host_t *ha)
 {
 	uint16_t w;
-	uint32_t d;
 	unsigned long flags;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
@@ -151,10 +150,7 @@ qla2100_pci_config(scsi_qla_host_t *ha)
 	w |= (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
 	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
 
-	/* Reset expansion ROM address decode enable */
-	pci_read_config_dword(ha->pdev, PCI_ROM_ADDRESS, &d);
-	d &= ~PCI_ROM_ADDRESS_ENABLE;
-	pci_write_config_dword(ha->pdev, PCI_ROM_ADDRESS, d);
+	pci_disable_rom(ha->pdev);
 
 	/* Get PCI bus information. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -174,7 +170,6 @@ int
 qla2300_pci_config(scsi_qla_host_t *ha)
 {
 	uint16_t	w;
-	uint32_t	d;
 	unsigned long   flags = 0;
 	uint32_t	cnt;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -236,10 +231,7 @@ qla2300_pci_config(scsi_qla_host_t *ha)
 
 	pci_write_config_byte(ha->pdev, PCI_LATENCY_TIMER, 0x80);
 
-	/* Reset expansion ROM address decode enable */
-	pci_read_config_dword(ha->pdev, PCI_ROM_ADDRESS, &d);
-	d &= ~PCI_ROM_ADDRESS_ENABLE;
-	pci_write_config_dword(ha->pdev, PCI_ROM_ADDRESS, d);
+	pci_disable_rom(ha->pdev);
 
 	/* Get PCI bus information. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -259,7 +251,6 @@ int
 qla24xx_pci_config(scsi_qla_host_t *ha)
 {
 	uint16_t w;
-	uint32_t d;
 	unsigned long flags = 0;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
@@ -281,10 +272,7 @@ qla24xx_pci_config(scsi_qla_host_t *ha)
 	if (pci_find_capability(ha->pdev, PCI_CAP_ID_EXP))
 		pcie_set_readrq(ha->pdev, 2048);
 
-	/* Reset expansion ROM address decode enable */
-	pci_read_config_dword(ha->pdev, PCI_ROM_ADDRESS, &d);
-	d &= ~PCI_ROM_ADDRESS_ENABLE;
-	pci_write_config_dword(ha->pdev, PCI_ROM_ADDRESS, d);
+	pci_disable_rom(ha->pdev);
 
 	ha->chip_revision = ha->pdev->revision;
 
@@ -306,7 +294,6 @@ int
 qla25xx_pci_config(scsi_qla_host_t *ha)
 {
 	uint16_t w;
-	uint32_t d;
 
 	pci_set_master(ha->pdev);
 	pci_try_set_mwi(ha->pdev);
@@ -320,10 +307,7 @@ qla25xx_pci_config(scsi_qla_host_t *ha)
 	if (pci_find_capability(ha->pdev, PCI_CAP_ID_EXP))
 		pcie_set_readrq(ha->pdev, 2048);
 
-	/* Reset expansion ROM address decode enable */
-	pci_read_config_dword(ha->pdev, PCI_ROM_ADDRESS, &d);
-	d &= ~PCI_ROM_ADDRESS_ENABLE;
-	pci_write_config_dword(ha->pdev, PCI_ROM_ADDRESS, d);
+	pci_disable_rom(ha->pdev);
 
 	ha->chip_revision = ha->pdev->revision;
 
-- 
1.6.0.2.526.g5c283

