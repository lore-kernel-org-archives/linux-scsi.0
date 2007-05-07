From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/6] qla2xxx: Correct pci_set_msi() usage semantics.
Date: Mon,  7 May 2007 07:43:01 -0700
Message-ID: <11785489833242-git-send-email-andrew.vasquez@qlogic.com>
References: <20070507144216.GC7207@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47147 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934202AbXEGOnb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 10:43:31 -0400
In-Reply-To: <20070507144216.GC7207@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   31 ++++++++++++++-----------------
 1 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6ad1588..db998d8 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -130,18 +130,17 @@ qla2x00_initialize_adapter(scsi_qla_host_t *ha)
 int
 qla2100_pci_config(scsi_qla_host_t *ha)
 {
-	uint16_t w, mwi;
+	int ret;
+	uint16_t w;
 	uint32_t d;
 	unsigned long flags;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	pci_set_master(ha->pdev);
-	mwi = 0;
-	if (pci_set_mwi(ha->pdev))
-		mwi = PCI_COMMAND_INVALIDATE;
+	ret = pci_set_mwi(ha->pdev);
 
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
-	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
+	w |= (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
 	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
 
 	/* Reset expansion ROM address decode enable */
@@ -166,22 +165,22 @@ qla2100_pci_config(scsi_qla_host_t *ha)
 int
 qla2300_pci_config(scsi_qla_host_t *ha)
 {
-	uint16_t	w, mwi;
+	int		ret;
+	uint16_t	w;
 	uint32_t	d;
 	unsigned long   flags = 0;
 	uint32_t	cnt;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	pci_set_master(ha->pdev);
-	mwi = 0;
-	if (pci_set_mwi(ha->pdev))
-		mwi = PCI_COMMAND_INVALIDATE;
+	ret = pci_set_mwi(ha->pdev);
 
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
-	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
+	w |= (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
 
 	if (IS_QLA2322(ha) || IS_QLA6322(ha))
 		w &= ~PCI_COMMAND_INTX_DISABLE;
+	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
 
 	/*
 	 * If this is a 2300 card and not 2312, reset the
@@ -210,7 +209,7 @@ qla2300_pci_config(scsi_qla_host_t *ha)
 		ha->fb_rev = RD_FB_CMD_REG(ha, reg);
 
 		if (ha->fb_rev == FPM_2300)
-			w &= ~PCI_COMMAND_INVALIDATE;
+			pci_clear_mwi(ha->pdev);
 
 		/* Deselect FPM registers. */
 		WRT_REG_WORD(&reg->ctrl_status, 0x0);
@@ -227,7 +226,6 @@ qla2300_pci_config(scsi_qla_host_t *ha)
 
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	}
-	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
 
 	pci_write_config_byte(ha->pdev, PCI_LATENCY_TIMER, 0x80);
 
@@ -253,19 +251,18 @@ qla2300_pci_config(scsi_qla_host_t *ha)
 int
 qla24xx_pci_config(scsi_qla_host_t *ha)
 {
-	uint16_t w, mwi;
+	int ret;
+	uint16_t w;
 	uint32_t d;
 	unsigned long flags = 0;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	int pcix_cmd_reg, pcie_dctl_reg;
 
 	pci_set_master(ha->pdev);
-	mwi = 0;
-	if (pci_set_mwi(ha->pdev))
-		mwi = PCI_COMMAND_INVALIDATE;
+	ret = pci_set_mwi(ha->pdev);
 
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
-	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
+	w |= (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
 	w &= ~PCI_COMMAND_INTX_DISABLE;
 	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
 
-- 
1.5.2.rc1.9.g6644

