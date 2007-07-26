From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 20/21] advansys: Remove pci_slot_info
Date: Thu, 26 Jul 2007 13:22:56 -0400
Message-ID: <11854705772984-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:40422 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765458AbXGZSKN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 14:10:13 -0400
In-Reply-To: 20070726171141.GE19275@parisc-linux.org
References: 20070726171141.GE19275@parisc-linux.org
In-Reply-To: <20070726171141.GE19275@parisc-linux.org>
References: <20070726171141.GE19275@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

The driver kept a copy of the PCI config address; refer to the pci_dev
associated with the card instead.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   29 +++++++++--------------------
 1 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 3fe4b04..1704427 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -853,8 +853,6 @@ typedef unsigned char uchar;
 #define ERR      (-1)
 #define UW_ERR   (uint)(0xFFFF)
 #define isodd_word(val)   ((((uint)val) & (uint)0x0001) != 0)
-#define ASC_PCI_ID2FUNC(id)   (((id) >> 8) & 0x7)
-#define ASC_PCI_MKID(bus, dev, func) ((((dev) & 0x1F) << 11) | (((func) & 0x7) << 8) | ((bus) & 0xFF))
 
 #define  ASC_DVCLIB_CALL_DONE     (1)
 #define  ASC_DVCLIB_CALL_FAILED   (0)
@@ -1389,7 +1387,6 @@ typedef struct asc_dvc_cfg {
 	uchar max_tag_qng[ASC_MAX_TID + 1];
 	uchar *overrun_buf;
 	uchar sdtr_period_offset[ASC_MAX_TID + 1];
-	ushort pci_slot_info;
 	uchar adapter_info[6];
 } ASC_DVC_CFG;
 
@@ -2827,9 +2824,6 @@ typedef struct adv_dvc_cfg {
 	ushort control_flag;	/* Microcode Control Flag */
 	ushort mcode_date;	/* Microcode date */
 	ushort mcode_version;	/* Microcode version */
-	ushort pci_slot_info;	/* high byte device/function number */
-	/* bits 7-3 device num., bits 2-0 function num. */
-	/* low byte bus num. */
 	ushort serial1;		/* EEPROM serial number word 1 */
 	ushort serial2;		/* EEPROM serial number word 2 */
 	ushort serial3;		/* EEPROM serial number word 3 */
@@ -3651,6 +3645,10 @@ typedef struct asc_board {
 	ushort bios_codelen;	/* BIOS Code Segment Length. */
 } asc_board_t;
 
+#define adv_dvc_to_board(adv_dvc) container_of(adv_dvc, struct asc_board, \
+							dvc_var.adv_dvc_var)
+#define adv_dvc_to_pdev(adv_dvc) to_pci_dev(adv_dvc_to_board(adv_dvc)->dev)
+
 /*
  * --- Driver Data
  */
@@ -7859,8 +7857,7 @@ static void asc_prt_adv_dvc_cfg(ADV_DVC_CFG *h)
 	printk("  mcode_version 0x%x, pci_device_id 0x%x, lib_version %u\n",
 	       h->mcode_version, to_pci_dev(h->dev)->device, h->lib_version);
 
-	printk("  control_flag 0x%x, pci_slot_info 0x%x\n",
-	       h->control_flag, h->pci_slot_info);
+	printk("  control_flag 0x%x\n", h->control_flag);
 }
 
 /*
@@ -15359,6 +15356,7 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
 	 * ready to be 'ored' into SCSI_CFG1.
 	 */
 	if ((asc_dvc->cfg->termination & TERM_SE) == 0) {
+		struct pci_dev *pdev = adv_dvc_to_pdev(asc_dvc);
 		/* SE automatic termination control is enabled. */
 		switch (scsi_cfg1 & C_DET_SE) {
 			/* TERM_SE_HI: on, TERM_SE_LO: on */
@@ -15369,7 +15367,7 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
 			break;
 
 		case 0x0:
-			if (ASC_PCI_ID2FUNC(asc_dvc->cfg->pci_slot_info) == 0) {
+			if (PCI_FUNC(pdev->devfn) == 0) {
 				/* Function 0 - TERM_SE_HI: off, TERM_SE_LO: off */
 			} else {
 				/* Function 1 - TERM_SE_HI: on, TERM_SE_LO: off */
@@ -15975,15 +15973,14 @@ static int __devinit AdvInitFrom38C1600EEP(ADV_DVC_VAR *asc_dvc)
 	 */
 	if (AdvGet38C1600EEPConfig(iop_base, &eep_config) !=
 	    eep_config.check_sum) {
+		struct pci_dev *pdev = adv_dvc_to_pdev(asc_dvc);
 		warn_code |= ASC_WARN_EEPROM_CHKSUM;
 
 		/*
 		 * Set EEPROM default values.
 		 */
 		for (i = 0; i < sizeof(ADVEEP_38C1600_CONFIG); i++) {
-			if (i == 1
-			    && ASC_PCI_ID2FUNC(asc_dvc->cfg->pci_slot_info) !=
-			    0) {
+			if (i == 1 && PCI_FUNC(pdev->devfn) != 0) {
 				/*
 				 * Set Function 1 EEPROM Word 0 MSB
 				 *
@@ -17296,10 +17293,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 #ifdef CONFIG_PCI
 		case ASC_IS_PCI:
 			shost->irq = asc_dvc_varp->irq_no = pdev->irq;
-			asc_dvc_varp->cfg->pci_slot_info =
-			    ASC_PCI_MKID(pdev->bus->number,
-					 PCI_SLOT(pdev->devfn),
-					 PCI_FUNC(pdev->devfn));
 			shost->unchecked_isa_dma = FALSE;
 			share_irq = TRUE;
 			break;
@@ -17319,10 +17312,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		 */
 #ifdef CONFIG_PCI
 		shost->irq = adv_dvc_varp->irq_no = pdev->irq;
-		adv_dvc_varp->cfg->pci_slot_info =
-		    ASC_PCI_MKID(pdev->bus->number,
-				 PCI_SLOT(pdev->devfn),
-				 PCI_FUNC(pdev->devfn));
 		shost->unchecked_isa_dma = FALSE;
 		share_irq = TRUE;
 #endif /* CONFIG_PCI */
-- 
1.4.4.4

