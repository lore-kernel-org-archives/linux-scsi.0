From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 6/9] qla2xxx: Use PCI-X/PCI-Express read control interfaces.
Date: Thu, 19 Jul 2007 15:06:01 -0700
Message-ID: <11848827642406-git-send-email-andrew.vasquez@qlogic.com>
References: <20070719220456.GK4015@plap.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:27113 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763669AbXGSWHG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 18:07:06 -0400
In-Reply-To: <20070719220456.GK4015@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Original from Peter Oruba <peter.oruba@amd.com>.  Additional
cleanups included.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   25 ++++---------------------
 1 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 401a879..622cf8f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -255,7 +255,6 @@ qla24xx_pci_config(scsi_qla_host_t *ha)
 	uint32_t d;
 	unsigned long flags = 0;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
-	int pcix_cmd_reg, pcie_dctl_reg;
 
 	pci_set_master(ha->pdev);
 	ret = pci_set_mwi(ha->pdev);
@@ -268,28 +267,12 @@ qla24xx_pci_config(scsi_qla_host_t *ha)
 	pci_write_config_byte(ha->pdev, PCI_LATENCY_TIMER, 0x80);
 
 	/* PCI-X -- adjust Maximum Memory Read Byte Count (2048). */
-	pcix_cmd_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_PCIX);
-	if (pcix_cmd_reg) {
-		uint16_t pcix_cmd;
-
-		pcix_cmd_reg += PCI_X_CMD;
-		pci_read_config_word(ha->pdev, pcix_cmd_reg, &pcix_cmd);
-		pcix_cmd &= ~PCI_X_CMD_MAX_READ;
-		pcix_cmd |= 0x0008;
-		pci_write_config_word(ha->pdev, pcix_cmd_reg, pcix_cmd);
-	}
+	if (pci_find_capability(ha->pdev, PCI_CAP_ID_PCIX))
+		pcix_set_mmrbc(ha->pdev, 2048);
 
 	/* PCIe -- adjust Maximum Read Request Size (2048). */
-	pcie_dctl_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
-	if (pcie_dctl_reg) {
-		uint16_t pcie_dctl;
-
-		pcie_dctl_reg += PCI_EXP_DEVCTL;
-		pci_read_config_word(ha->pdev, pcie_dctl_reg, &pcie_dctl);
-		pcie_dctl &= ~PCI_EXP_DEVCTL_READRQ;
-		pcie_dctl |= 0x4000;
-		pci_write_config_word(ha->pdev, pcie_dctl_reg, pcie_dctl);
-	}
+	if (pci_find_capability(ha->pdev, PCI_CAP_ID_EXP))
+		pcie_set_readrq(ha->pdev, 2048);
 
 	/* Reset expansion ROM address decode enable */
 	pci_read_config_dword(ha->pdev, PCI_ROM_ADDRESS, &d);
-- 
1.5.3.rc2.4.g726f9

