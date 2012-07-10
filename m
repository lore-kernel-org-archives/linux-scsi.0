From: Jon Mason <jdmason@kudzu.us>
Subject: [PATCH RESUBMIT 2/3] qla2xxx: remove unnecessary reads of PCI_CAP_ID_EXP
Date: Tue, 10 Jul 2012 14:57:56 -0700
Message-ID: <1341957477-30946-3-git-send-email-jdmason@kudzu.us>
References: <1341957477-30946-1-git-send-email-jdmason@kudzu.us>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60311 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab2GJV5l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jul 2012 17:57:41 -0400
Received: by yenl2 with SMTP id l2so575232yen.19
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jul 2012 14:57:40 -0700 (PDT)
In-Reply-To: <1341957477-30946-1-git-send-email-jdmason@kudzu.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com

The PCIE capability offset is saved during PCI bus walking.  It will
remove an unnecessary search in the PCI configuration space if this
value is referenced instead of reacquiring it.  Also, pci_is_pcie is a
better way of determining if the device is PCIE or not (as it uses the
same saved PCIE capability offset).

Signed-off-by: Jon Mason <jdmason@kudzu.us>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-driver@qlogic.com
---
 drivers/scsi/qla2xxx/qla_init.c |    4 ++--
 drivers/scsi/qla2xxx/qla_nx.c   |    4 ++--
 drivers/scsi/qla2xxx/qla_os.c   |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ca50847..a44653b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -685,7 +685,7 @@ qla24xx_pci_config(scsi_qla_host_t *vha)
 		pcix_set_mmrbc(ha->pdev, 2048);
 
 	/* PCIe -- adjust Maximum Read Request Size (2048). */
-	if (pci_find_capability(ha->pdev, PCI_CAP_ID_EXP))
+	if (pci_is_pcie(ha->pdev))
 		pcie_set_readrq(ha->pdev, 2048);
 
 	pci_disable_rom(ha->pdev);
@@ -721,7 +721,7 @@ qla25xx_pci_config(scsi_qla_host_t *vha)
 	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
 
 	/* PCIe -- adjust Maximum Read Request Size (2048). */
-	if (pci_find_capability(ha->pdev, PCI_CAP_ID_EXP))
+	if (pci_is_pcie(ha->pdev))
 		pcie_set_readrq(ha->pdev, 2048);
 
 	pci_disable_rom(ha->pdev);
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index caf627b..9ce3a8f 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1620,7 +1620,7 @@ qla82xx_pci_info_str(struct scsi_qla_host *vha, char *str)
 	char lwstr[6];
 	uint16_t lnk;
 
-	pcie_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
+	pcie_reg = pci_pcie_cap(ha->pdev);
 	pci_read_config_word(ha->pdev, pcie_reg + PCI_EXP_LNKSTA, &lnk);
 	ha->link_width = (lnk >> 4) & 0x3f;
 
@@ -2528,7 +2528,7 @@ qla82xx_start_firmware(scsi_qla_host_t *vha)
 	}
 
 	/* Negotiated Link width */
-	pcie_cap = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
+	pcie_cap = pci_pcie_cap(ha->pdev);
 	pci_read_config_word(ha->pdev, pcie_cap + PCI_EXP_LNKSTA, &lnk);
 	ha->link_width = (lnk >> 4) & 0x3f;
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6d1d873..fb8cd38 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -482,12 +482,12 @@ qla24xx_pci_info_str(struct scsi_qla_host *vha, char *str)
 	uint32_t pci_bus;
 	int pcie_reg;
 
-	pcie_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
+	pcie_reg = pci_pcie_cap(ha->pdev);
 	if (pcie_reg) {
 		char lwstr[6];
 		uint16_t pcie_lstat, lspeed, lwidth;
 
-		pcie_reg += 0x12;
+		pcie_reg += PCI_EXP_LNKCAP;
 		pci_read_config_word(ha->pdev, pcie_reg, &pcie_lstat);
 		lspeed = pcie_lstat & (BIT_0 | BIT_1 | BIT_2 | BIT_3);
 		lwidth = (pcie_lstat &
-- 
1.7.9.5

