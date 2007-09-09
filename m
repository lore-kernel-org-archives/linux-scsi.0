From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 05/22] advansys: Shrink advansys_board_found a little more
Date: Sun,  9 Sep 2007 08:56:30 -0600
Message-ID: <11893498071452-git-send-email-matthew@wil.cx>
References: <20070909145358.GG6809@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:43171 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269AbXIIO4r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 10:56:47 -0400
In-Reply-To: <20070909145358.GG6809@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Move the error reporting into AscInitGetConfig, AdvInitGetConfig and
AscInitSetConfig.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  230 +++++++++++++++++++++++------------------------
 1 files changed, 112 insertions(+), 118 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 5649bf4..fe289b1 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -9321,13 +9321,14 @@ static uchar __devinit AscGetIsaDmaSpeed(PortAddr iop_base)
 }
 #endif /* CONFIG_ISA */
 
-static ushort __devinit AscInitGetConfig(ASC_DVC_VAR *asc_dvc)
+static int __devinit AscInitGetConfig(asc_board_t *boardp)
 {
+	ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
 	unsigned short warn_code = 0;
 
 	asc_dvc->init_state = ASC_INIT_STATE_BEG_GET_CFG;
 	if (asc_dvc->err_code != 0)
-		return (UW_ERR);
+		return asc_dvc->err_code;
 
 	if (AscFindSignature(asc_dvc->iop_base)) {
 		warn_code |= AscInitAscDvcVar(asc_dvc);
@@ -9338,27 +9339,63 @@ static ushort __devinit AscInitGetConfig(ASC_DVC_VAR *asc_dvc)
 	} else {
 		asc_dvc->err_code = ASC_IERR_BAD_SIGNATURE;
 	}
-	return warn_code;
+
+	switch (warn_code) {
+	case 0:	/* No error */
+		break;
+	case ASC_WARN_IO_PORT_ROTATE:
+		ASC_PRINT1("AscInitGetConfig: board %d: I/O port address "
+			   "modified\n", boardp->id);
+		break;
+	case ASC_WARN_AUTO_CONFIG:
+		ASC_PRINT1("AscInitGetConfig: board %d: I/O port increment "
+			   "switch enabled\n", boardp->id);
+		break;
+	case ASC_WARN_EEPROM_CHKSUM:
+		ASC_PRINT1("AscInitGetConfig: board %d: EEPROM checksum "
+			   "error\n", boardp->id);
+		break;
+	case ASC_WARN_IRQ_MODIFIED:
+		ASC_PRINT1("AscInitGetConfig: board %d: IRQ modified\n",
+			   boardp->id);
+		break;
+	case ASC_WARN_CMD_QNG_CONFLICT:
+		ASC_PRINT1("AscInitGetConfig: board %d: tag queuing enabled "
+			   "w/o disconnects\n", boardp->id);
+		break;
+	default:
+		ASC_PRINT2("AscInitGetConfig: board %d: unknown warning: "
+			   "0x%x\n", boardp->id, warn_code);
+		break;
+	}
+
+	if (asc_dvc->err_code != 0) {
+		ASC_PRINT3("AscInitGetConfig: board %d error: init_state 0x%x, "
+			   "err_code 0x%x\n", boardp->id, asc_dvc->init_state,
+			   asc_dvc->err_code);
+	}
+
+	return asc_dvc->err_code;
 }
 
-static unsigned short __devinit
-AscInitSetConfig(struct pci_dev *pdev, ASC_DVC_VAR *asc_dvc)
+static int __devinit AscInitSetConfig(struct pci_dev *pdev, asc_board_t *boardp)
 {
+	ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
 	PortAddr iop_base = asc_dvc->iop_base;
 	unsigned short cfg_msw;
 	unsigned short warn_code = 0;
 
 	asc_dvc->init_state |= ASC_INIT_STATE_BEG_SET_CFG;
 	if (asc_dvc->err_code != 0)
-		return UW_ERR;
+		return asc_dvc->err_code;
 	if (!AscFindSignature(asc_dvc->iop_base)) {
 		asc_dvc->err_code = ASC_IERR_BAD_SIGNATURE;
-		return 0;
+		return asc_dvc->err_code;
 	}
 
 	cfg_msw = AscGetChipCfgMsw(iop_base);
 	if ((cfg_msw & ASC_CFG_MSW_CLR_MASK) != 0) {
-		cfg_msw &= (~(ASC_CFG_MSW_CLR_MASK));
+		cfg_msw &= ~ASC_CFG_MSW_CLR_MASK;
 		warn_code |= ASC_WARN_CFG_MSW_RECOVER;
 		AscSetChipCfgMsw(iop_base, cfg_msw);
 	}
@@ -9409,7 +9446,44 @@ AscInitSetConfig(struct pci_dev *pdev, ASC_DVC_VAR *asc_dvc)
 #endif /* CONFIG_ISA */
 
 	asc_dvc->init_state |= ASC_INIT_STATE_END_SET_CFG;
-	return warn_code;
+
+	switch (warn_code) {
+	case 0:	/* No error. */
+		break;
+	case ASC_WARN_IO_PORT_ROTATE:
+		ASC_PRINT1("AscInitSetConfig: board %d: I/O port address "
+			   "modified\n", boardp->id);
+		break;
+	case ASC_WARN_AUTO_CONFIG:
+		ASC_PRINT1("AscInitSetConfig: board %d: I/O port increment "
+			   "switch enabled\n", boardp->id);
+		break;
+	case ASC_WARN_EEPROM_CHKSUM:
+		ASC_PRINT1("AscInitSetConfig: board %d: EEPROM checksum "
+			   "error\n", boardp->id);
+		break;
+	case ASC_WARN_IRQ_MODIFIED:
+		ASC_PRINT1("AscInitSetConfig: board %d: IRQ modified\n",
+			   boardp->id);
+		break;
+	case ASC_WARN_CMD_QNG_CONFLICT:
+		ASC_PRINT1("AscInitSetConfig: board %d: tag queuing w/o "
+			   "disconnects\n",
+		     boardp->id);
+		break;
+	default:
+		ASC_PRINT2("AscInitSetConfig: board %d: unknown warning: "
+			   "0x%x\n", boardp->id, warn_code);
+		break;
+	}
+
+	if (asc_dvc->err_code != 0) {
+		ASC_PRINT3("AscInitSetConfig: board %d error: init_state 0x%x, "
+			   "err_code 0x%x\n", boardp->id, asc_dvc->init_state,
+			   asc_dvc->err_code);
+	}
+
+	return asc_dvc->err_code;
 }
 
 static ushort AscInitAsc1000Driver(ASC_DVC_VAR *asc_dvc)
@@ -9596,7 +9670,7 @@ static ushort __devinit AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
 	cfg_msw = AscGetChipCfgMsw(iop_base);
 	cfg_lsw = AscGetChipCfgLsw(iop_base);
 	if ((cfg_msw & ASC_CFG_MSW_CLR_MASK) != 0) {
-		cfg_msw &= (~(ASC_CFG_MSW_CLR_MASK));
+		cfg_msw &= ~ASC_CFG_MSW_CLR_MASK;
 		warn_code |= ASC_WARN_CFG_MSW_RECOVER;
 		AscSetChipCfgMsw(iop_base, cfg_msw);
 	}
@@ -12009,6 +12083,7 @@ static ADVEEP_38C1600_CONFIG ADVEEP_38C1600_Config_Field_IsChar __devinitdata =
 	0			/* 63 reserved */
 };
 
+#ifdef CONFIG_PCI
 /*
  * Initialize the ADV_DVC_VAR structure.
  *
@@ -12018,8 +12093,9 @@ static ADVEEP_38C1600_CONFIG ADVEEP_38C1600_Config_Field_IsChar __devinitdata =
  * then 0 is returned.
  */
 static int __devinit
-AdvInitGetConfig(struct pci_dev *pdev, ADV_DVC_VAR *asc_dvc)
+AdvInitGetConfig(struct pci_dev *pdev, asc_board_t *boardp)
 {
+	ADV_DVC_VAR *asc_dvc = &boardp->dvc_var.adv_dvc_var;
 	unsigned short warn_code = 0;
 	AdvPortAddr iop_base = asc_dvc->iop_base;
 	u16 cmd;
@@ -12087,8 +12163,19 @@ AdvInitGetConfig(struct pci_dev *pdev, ADV_DVC_VAR *asc_dvc)
 		warn_code |= status;
 	}
 
-	return warn_code;
+	if (warn_code != 0) {
+		ASC_PRINT2("AdvInitGetConfig: board %d: warning: 0x%x\n",
+			   boardp->id, warn_code);
+	}
+
+	if (asc_dvc->err_code) {
+		ASC_PRINT2("AdvInitGetConfig: board %d error: err_code 0x%x\n",
+		     boardp->id, asc_dvc->err_code);
+	}
+
+	return asc_dvc->err_code;
 }
+#endif
 
 static void AdvBuildCarrierFreelist(struct adv_dvc_var *asc_dvc)
 {
@@ -15316,22 +15403,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 			share_irq = 0;
 			break;
 		}
-	} else {
-		/*
-		 * For Wide boards set PCI information before calling
-		 * AdvInitGetConfig().
-		 */
-#ifdef CONFIG_PCI
-		shost->irq = adv_dvc_varp->irq_no = pdev->irq;
-		shost->unchecked_isa_dma = FALSE;
-		share_irq = IRQF_SHARED;
-#endif /* CONFIG_PCI */
-	}
 
-	/*
-	 * Read the board configuration.
-	 */
-	if (ASC_NARROW_BOARD(boardp)) {
 		/*
 		 * NOTE: AscInitGetConfig() may change the board's
 		 * bus_type value. The bus_type value should no
@@ -15339,60 +15411,20 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		 * referenced only use the bit-wise AND operator "&".
 		 */
 		ASC_DBG(2, "advansys_board_found: AscInitGetConfig()\n");
-		switch (ret = AscInitGetConfig(asc_dvc_varp)) {
-		case 0:	/* No error */
-			break;
-		case ASC_WARN_IO_PORT_ROTATE:
-			ASC_PRINT1
-			    ("AscInitGetConfig: board %d: I/O port address modified\n",
-			     boardp->id);
-			break;
-		case ASC_WARN_AUTO_CONFIG:
-			ASC_PRINT1
-			    ("AscInitGetConfig: board %d: I/O port increment switch enabled\n",
-			     boardp->id);
-			break;
-		case ASC_WARN_EEPROM_CHKSUM:
-			ASC_PRINT1
-			    ("AscInitGetConfig: board %d: EEPROM checksum error\n",
-			     boardp->id);
-			break;
-		case ASC_WARN_IRQ_MODIFIED:
-			ASC_PRINT1
-			    ("AscInitGetConfig: board %d: IRQ modified\n",
-			     boardp->id);
-			break;
-		case ASC_WARN_CMD_QNG_CONFLICT:
-			ASC_PRINT1
-			    ("AscInitGetConfig: board %d: tag queuing enabled w/o disconnects\n",
-			     boardp->id);
-			break;
-		default:
-			ASC_PRINT2
-			    ("AscInitGetConfig: board %d: unknown warning: 0x%x\n",
-			     boardp->id, ret);
-			break;
-		}
-		if ((err_code = asc_dvc_varp->err_code) != 0) {
-			ASC_PRINT3
-			    ("AscInitGetConfig: board %d error: init_state 0x%x, err_code 0x%x\n",
-			     boardp->id,
-			     asc_dvc_varp->init_state, asc_dvc_varp->err_code);
-		}
+		err_code = AscInitGetConfig(boardp);
 	} else {
+#ifdef CONFIG_PCI
+		/*
+		 * For Wide boards set PCI information before calling
+		 * AdvInitGetConfig().
+		 */
+		shost->irq = adv_dvc_varp->irq_no = pdev->irq;
+		shost->unchecked_isa_dma = FALSE;
+		share_irq = IRQF_SHARED;
 		ASC_DBG(2, "advansys_board_found: AdvInitGetConfig()\n");
 
-		ret = AdvInitGetConfig(pdev, adv_dvc_varp);
-		if (ret != 0) {
-			ASC_PRINT2
-			    ("AdvInitGetConfig: board %d: warning: 0x%x\n",
-			     boardp->id, ret);
-		}
-		if ((err_code = adv_dvc_varp->err_code) != 0) {
-			ASC_PRINT2
-			    ("AdvInitGetConfig: board %d error: err_code 0x%x\n",
-			     boardp->id, adv_dvc_varp->err_code);
-		}
+		err_code = AdvInitGetConfig(pdev, boardp);
+#endif /* CONFIG_PCI */
 	}
 
 	if (err_code != 0)
@@ -15439,47 +15471,9 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		 * Modify board configuration.
 		 */
 		ASC_DBG(2, "advansys_board_found: AscInitSetConfig()\n");
-		switch (ret = AscInitSetConfig(pdev, asc_dvc_varp)) {
-		case 0:	/* No error. */
-			break;
-		case ASC_WARN_IO_PORT_ROTATE:
-			ASC_PRINT1
-			    ("AscInitSetConfig: board %d: I/O port address modified\n",
-			     boardp->id);
-			break;
-		case ASC_WARN_AUTO_CONFIG:
-			ASC_PRINT1
-			    ("AscInitSetConfig: board %d: I/O port increment switch enabled\n",
-			     boardp->id);
-			break;
-		case ASC_WARN_EEPROM_CHKSUM:
-			ASC_PRINT1
-			    ("AscInitSetConfig: board %d: EEPROM checksum error\n",
-			     boardp->id);
-			break;
-		case ASC_WARN_IRQ_MODIFIED:
-			ASC_PRINT1
-			    ("AscInitSetConfig: board %d: IRQ modified\n",
-			     boardp->id);
-			break;
-		case ASC_WARN_CMD_QNG_CONFLICT:
-			ASC_PRINT1
-			    ("AscInitSetConfig: board %d: tag queuing w/o disconnects\n",
-			     boardp->id);
-			break;
-		default:
-			ASC_PRINT2
-			    ("AscInitSetConfig: board %d: unknown warning: 0x%x\n",
-			     boardp->id, ret);
-			break;
-		}
-		if (asc_dvc_varp->err_code != 0) {
-			ASC_PRINT3
-			    ("AscInitSetConfig: board %d error: init_state 0x%x, err_code 0x%x\n",
-			     boardp->id,
-			     asc_dvc_varp->init_state, asc_dvc_varp->err_code);
+		err_code = AscInitSetConfig(pdev, boardp);
+		if (err_code)
 			goto err_free_proc;
-		}
 
 		/*
 		 * Finish initializing the 'Scsi_Host' structure.
-- 
1.5.2.4

