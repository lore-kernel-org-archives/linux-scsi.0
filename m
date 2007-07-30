From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 11/23] advansys: More PCI cleanups
Date: Mon, 30 Jul 2007 10:56:56 -0600
Message-ID: <11858146283924-git-send-email-matthew@wil.cx>
References: <20070730165508.GH21219@parisc-linux.org> <11858146283240-git-send-email-matthew@wil.cx> <1185814628978-git-send-email-matthew@wil.cx> <11858146282602-git-send-email-matthew@wil.cx> <11858146283106-git-send-email-matthew@wil.cx> <11858146282252-git-send-email-matthew@wil.cx> <11858146281790-git-send-email-matthew@wil.cx> <11858146281215-git-send-email-matthew@wil.cx> <11858146282469-git-send-email-matthew@wil.cx> <11858146281137-git-send-email-matthew@wil.cx> <11858146282332-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:43504 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937080AbXG3Q5M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 12:57:12 -0400
In-Reply-To: <11858146282332-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

 - Remove wrappers around the PCI configuration space accessors
 - Call pci_set_master() instead of poking at config space directly
 - Move the latency setting into one function called for both narrow and
   wide boards.
 - Tidy up AdvInitGetConfig() a little.
 - Delete a few unused prototypes and definitions.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  254 +++++++----------------------------------------
 1 files changed, 34 insertions(+), 220 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index d51ca86..424549d 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -854,15 +854,6 @@ typedef unsigned char uchar;
 #define ERR      (-1)
 #define UW_ERR   (uint)(0xFFFF)
 #define isodd_word(val)   ((((uint)val) & (uint)0x0001) != 0)
-#define AscPCIConfigVendorIDRegister      0x0000
-#define AscPCIConfigDeviceIDRegister      0x0002
-#define AscPCIConfigCommandRegister       0x0004
-#define AscPCIConfigStatusRegister        0x0006
-#define AscPCIConfigRevisionIDRegister    0x0008
-#define AscPCIConfigCacheSize             0x000C
-#define AscPCIConfigLatencyTimer          0x000D
-#define AscPCIIOBaseRegister              0x0010
-#define AscPCICmdRegBits_IOMemBusMaster   0x0007
 #define ASC_PCI_ID2FUNC(id)   (((id) >> 8) & 0x7)
 #define ASC_PCI_MKID(bus, dev, func) ((((dev) & 0x1F) << 11) | (((func) & 0x7) << 8) | ((bus) & 0xFF))
 
@@ -1936,17 +1927,11 @@ static uchar AscSetChipIRQ(PortAddr, uchar, ushort);
 static ushort AscGetChipBiosAddress(PortAddr, ushort);
 static inline ulong DvcEnterCritical(void);
 static inline void DvcLeaveCritical(ulong);
-#ifdef CONFIG_PCI
-static uchar DvcReadPCIConfigByte(ASC_DVC_VAR *, ushort);
-static void DvcWritePCIConfigByte(ASC_DVC_VAR *, ushort, uchar);
-#endif /* CONFIG_PCI */
 static ushort AscGetChipBiosAddress(PortAddr, ushort);
 static void DvcSleepMilliSecond(ASC_DCNT);
 static void DvcDelayNanoSecond(ASC_DVC_VAR *, ASC_DCNT);
 static void DvcPutScsiQ(PortAddr, ushort, uchar *, int);
 static void DvcGetQinfo(PortAddr, ushort, uchar *, int);
-static ushort AscInitGetConfig(ASC_DVC_VAR *);
-static ushort AscInitSetConfig(ASC_DVC_VAR *);
 static ushort AscInitAsc1000Driver(ASC_DVC_VAR *);
 static void AscAsyncFix(ASC_DVC_VAR *, uchar, ASC_SCSI_INQUIRY *);
 static int AscTagQueuingSafe(ASC_SCSI_INQUIRY *);
@@ -3077,8 +3062,6 @@ typedef struct adv_scsi_req_q {
 static inline ulong DvcEnterCritical(void);
 static inline void DvcLeaveCritical(ulong);
 static void DvcSleepMilliSecond(ADV_DCNT);
-static uchar DvcAdvReadPCIConfigByte(ADV_DVC_VAR *, ushort);
-static void DvcAdvWritePCIConfigByte(ADV_DVC_VAR *, ushort, uchar);
 static ADV_PADDR DvcGetPhyAddr(ADV_DVC_VAR *, ADV_SCSI_REQ_Q *,
 			       uchar *, ASC_SDCNT *, int);
 static void DvcDelayMicroSecond(ADV_DVC_VAR *, ushort);
@@ -3112,12 +3095,6 @@ static void AdvSet38C1600EEPConfig(AdvPortAddr, ADVEEP_38C1600_CONFIG *);
 static void AdvWaitEEPCmd(AdvPortAddr);
 static ushort AdvReadEEPWord(AdvPortAddr, int);
 
-/*
- * PCI Bus Definitions
- */
-#define AscPCICmdRegBits_BusMastering     0x0007
-#define AscPCICmdRegBits_ParErrRespCtrl   0x0040
-
 /* Read byte from a register. */
 #define AdvReadByteRegister(iop_base, reg_off) \
      (ADV_MEM_READB((iop_base) + (reg_off)))
@@ -7327,31 +7304,6 @@ DvcGetQinfo(PortAddr iop_base, ushort s_addr, uchar *inbuf, int words)
 }
 
 /*
- * Read a PCI configuration byte.
- */
-static uchar __devinit DvcReadPCIConfigByte(ASC_DVC_VAR *asc_dvc, ushort offset)
-{
-#ifdef CONFIG_PCI
-	uchar byte_data;
-	pci_read_config_byte(to_pci_dev(asc_dvc->cfg->dev), offset, &byte_data);
-	return byte_data;
-#else /* !defined(CONFIG_PCI) */
-	return 0;
-#endif /* !defined(CONFIG_PCI) */
-}
-
-/*
- * Write a PCI configuration byte.
- */
-static void __devinit
-DvcWritePCIConfigByte(ASC_DVC_VAR *asc_dvc, ushort offset, uchar byte_data)
-{
-#ifdef CONFIG_PCI
-	pci_write_config_byte(to_pci_dev(asc_dvc->cfg->dev), offset, byte_data);
-#endif /* CONFIG_PCI */
-}
-
-/*
  * Return the BIOS address of the adapter at the specified
  * I/O port and with the specified bus type.
  */
@@ -7424,33 +7376,6 @@ DvcGetPhyAddr(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq,
 }
 
 /*
- * Read a PCI configuration byte.
- */
-static uchar __devinit DvcAdvReadPCIConfigByte(ADV_DVC_VAR *asc_dvc, ushort offset)
-{
-#ifdef CONFIG_PCI
-	uchar byte_data;
-	pci_read_config_byte(to_pci_dev(asc_dvc->cfg->dev), offset, &byte_data);
-	return byte_data;
-#else /* CONFIG_PCI */
-	return 0;
-#endif /* CONFIG_PCI */
-}
-
-/*
- * Write a PCI configuration byte.
- */
-static void __devinit
-DvcAdvWritePCIConfigByte(ADV_DVC_VAR *asc_dvc, ushort offset, uchar byte_data)
-{
-#ifdef CONFIG_PCI
-	pci_write_config_byte(to_pci_dev(asc_dvc->cfg->dev), offset, byte_data);
-#else /* CONFIG_PCI */
-	return;
-#endif /* CONFIG_PCI */
-}
-
-/*
  * --- Tracing and Debugging Functions
  */
 
@@ -10321,89 +10246,15 @@ static uchar __devinit AscGetIsaDmaSpeed(PortAddr iop_base)
 }
 #endif /* CONFIG_ISA */
 
-static ushort __devinit
-AscReadPCIConfigWord(ASC_DVC_VAR *asc_dvc, ushort pci_config_offset)
-{
-	uchar lsb, msb;
-
-	lsb = DvcReadPCIConfigByte(asc_dvc, pci_config_offset);
-	msb = DvcReadPCIConfigByte(asc_dvc, pci_config_offset + 1);
-	return ((ushort)((msb << 8) | lsb));
-}
-
 static ushort __devinit AscInitGetConfig(ASC_DVC_VAR *asc_dvc)
 {
-	ushort warn_code;
-	PortAddr iop_base;
-	ushort PCIDeviceID;
-	ushort PCIVendorID;
-	uchar PCIRevisionID;
-	uchar prevCmdRegBits;
+	unsigned short warn_code = 0;
 
-	warn_code = 0;
-	iop_base = asc_dvc->iop_base;
 	asc_dvc->init_state = ASC_INIT_STATE_BEG_GET_CFG;
-	if (asc_dvc->err_code != 0) {
+	if (asc_dvc->err_code != 0)
 		return (UW_ERR);
-	}
-	if (asc_dvc->bus_type == ASC_IS_PCI) {
-		PCIVendorID = AscReadPCIConfigWord(asc_dvc,
-						   AscPCIConfigVendorIDRegister);
-
-		PCIDeviceID = AscReadPCIConfigWord(asc_dvc,
-						   AscPCIConfigDeviceIDRegister);
-
-		PCIRevisionID = DvcReadPCIConfigByte(asc_dvc,
-						     AscPCIConfigRevisionIDRegister);
 
-		if (PCIVendorID != PCI_VENDOR_ID_ASP) {
-			warn_code |= ASC_WARN_SET_PCI_CONFIG_SPACE;
-		}
-		prevCmdRegBits = DvcReadPCIConfigByte(asc_dvc,
-						      AscPCIConfigCommandRegister);
-
-		if ((prevCmdRegBits & AscPCICmdRegBits_IOMemBusMaster) !=
-		    AscPCICmdRegBits_IOMemBusMaster) {
-			DvcWritePCIConfigByte(asc_dvc,
-					      AscPCIConfigCommandRegister,
-					      (prevCmdRegBits |
-					       AscPCICmdRegBits_IOMemBusMaster));
-
-			if ((DvcReadPCIConfigByte(asc_dvc,
-						  AscPCIConfigCommandRegister)
-			     & AscPCICmdRegBits_IOMemBusMaster)
-			    != AscPCICmdRegBits_IOMemBusMaster) {
-				warn_code |= ASC_WARN_SET_PCI_CONFIG_SPACE;
-			}
-		}
-		if ((PCIDeviceID == PCI_DEVICE_ID_ASP_1200A) ||
-		    (PCIDeviceID == PCI_DEVICE_ID_ASP_ABP940)) {
-			DvcWritePCIConfigByte(asc_dvc,
-					      AscPCIConfigLatencyTimer, 0x00);
-			if (DvcReadPCIConfigByte
-			    (asc_dvc, AscPCIConfigLatencyTimer)
-			    != 0x00) {
-				warn_code |= ASC_WARN_SET_PCI_CONFIG_SPACE;
-			}
-		} else if (PCIDeviceID == PCI_DEVICE_ID_ASP_ABP940U) {
-			if (DvcReadPCIConfigByte(asc_dvc,
-						 AscPCIConfigLatencyTimer) <
-			    0x20) {
-				DvcWritePCIConfigByte(asc_dvc,
-						      AscPCIConfigLatencyTimer,
-						      0x20);
-
-				if (DvcReadPCIConfigByte(asc_dvc,
-							 AscPCIConfigLatencyTimer)
-				    < 0x20) {
-					warn_code |=
-					    ASC_WARN_SET_PCI_CONFIG_SPACE;
-				}
-			}
-		}
-	}
-
-	if (AscFindSignature(iop_base)) {
+	if (AscFindSignature(asc_dvc->iop_base)) {
 		warn_code |= AscInitAscDvcVar(asc_dvc);
 		warn_code |= AscInitFromEEP(asc_dvc);
 		asc_dvc->init_state |= ASC_INIT_STATE_END_GET_CFG;
@@ -10437,13 +10288,8 @@ static ushort __devinit AscInitFromAscDvcVar(ASC_DVC_VAR *asc_dvc)
 	PortAddr iop_base;
 	ushort cfg_msw;
 	ushort warn_code;
-	ushort pci_device_id = 0;
 
 	iop_base = asc_dvc->iop_base;
-#ifdef CONFIG_PCI
-	if (asc_dvc->cfg->dev)
-		pci_device_id = to_pci_dev(asc_dvc->cfg->dev)->device;
-#endif
 	warn_code = 0;
 	cfg_msw = AscGetChipCfgMsw(iop_base);
 	if ((cfg_msw & ASC_CFG_MSW_CLR_MASK) != 0) {
@@ -10465,19 +10311,23 @@ static ushort __devinit AscInitFromAscDvcVar(ASC_DVC_VAR *asc_dvc)
 			asc_dvc->err_code |= ASC_IERR_SET_IRQ_NO;
 		}
 	}
+#ifdef CONFIG_PCI
 	if (asc_dvc->bus_type & ASC_IS_PCI) {
+		struct pci_dev *pdev = to_pci_dev(asc_dvc->cfg->dev);
 		cfg_msw &= 0xFFC0;
 		AscSetChipCfgMsw(iop_base, cfg_msw);
 		if ((asc_dvc->bus_type & ASC_IS_PCI_ULTRA) == ASC_IS_PCI_ULTRA) {
 		} else {
-			if ((pci_device_id == PCI_DEVICE_ID_ASP_1200A) ||
-			    (pci_device_id == PCI_DEVICE_ID_ASP_ABP940)) {
+			if ((pdev->device == PCI_DEVICE_ID_ASP_1200A) ||
+			    (pdev->device == PCI_DEVICE_ID_ASP_ABP940)) {
 				asc_dvc->bug_fix_cntl |= ASC_BUG_FIX_IF_NOT_DWB;
 				asc_dvc->bug_fix_cntl |=
 				    ASC_BUG_FIX_ASYN_USE_SYN;
 			}
 		}
-	} else if (asc_dvc->bus_type == ASC_IS_ISAPNP) {
+	} else
+#endif /* CONFIG_PCI */
+	if (asc_dvc->bus_type == ASC_IS_ISAPNP) {
 		if (AscGetChipVersion(iop_base, asc_dvc->bus_type)
 		    == ASC_CHIP_VER_ASYN_BUG) {
 			asc_dvc->bug_fix_cntl |= ASC_BUG_FIX_ASYN_USE_SYN;
@@ -13875,55 +13725,13 @@ static ADVEEP_38C1600_CONFIG ADVEEP_38C1600_Config_Field_IsChar __devinitdata =
  */
 static int __devinit AdvInitGetConfig(ADV_DVC_VAR *asc_dvc)
 {
-	ushort warn_code;
-	AdvPortAddr iop_base;
-	uchar pci_cmd_reg;
+	unsigned short warn_code = 0;
+	AdvPortAddr iop_base = asc_dvc->iop_base;
+	struct pci_dev *pdev = to_pci_dev(asc_dvc->cfg->dev);
+	u16 cmd;
 	int status;
 
-	warn_code = 0;
 	asc_dvc->err_code = 0;
-	iop_base = asc_dvc->iop_base;
-
-	/*
-	 * PCI Command Register
-	 *
-	 * Note: AscPCICmdRegBits_BusMastering definition (0x0007) includes
-	 * I/O Space Control, Memory Space Control and Bus Master Control bits.
-	 */
-
-	if (((pci_cmd_reg = DvcAdvReadPCIConfigByte(asc_dvc,
-						    AscPCIConfigCommandRegister))
-	     & AscPCICmdRegBits_BusMastering)
-	    != AscPCICmdRegBits_BusMastering) {
-		pci_cmd_reg |= AscPCICmdRegBits_BusMastering;
-
-		DvcAdvWritePCIConfigByte(asc_dvc,
-					 AscPCIConfigCommandRegister,
-					 pci_cmd_reg);
-
-		if (((DvcAdvReadPCIConfigByte
-		      (asc_dvc, AscPCIConfigCommandRegister))
-		     & AscPCICmdRegBits_BusMastering)
-		    != AscPCICmdRegBits_BusMastering) {
-			warn_code |= ASC_WARN_SET_PCI_CONFIG_SPACE;
-		}
-	}
-
-	/*
-	 * PCI Latency Timer
-	 *
-	 * If the "latency timer" register is 0x20 or above, then we don't need
-	 * to change it.  Otherwise, set it to 0x20 (i.e. set it to 0x20 if it
-	 * comes up less than 0x20).
-	 */
-	if (DvcAdvReadPCIConfigByte(asc_dvc, AscPCIConfigLatencyTimer) < 0x20) {
-		DvcAdvWritePCIConfigByte(asc_dvc, AscPCIConfigLatencyTimer,
-					 0x20);
-		if (DvcAdvReadPCIConfigByte(asc_dvc, AscPCIConfigLatencyTimer) <
-		    0x20) {
-			warn_code |= ASC_WARN_SET_PCI_CONFIG_SPACE;
-		}
-	}
 
 	/*
 	 * Save the state of the PCI Configuration Command Register
@@ -13932,10 +13740,9 @@ static int __devinit AdvInitGetConfig(ADV_DVC_VAR *asc_dvc)
 	 * DMA parity errors.
 	 */
 	asc_dvc->cfg->control_flag = 0;
-	if (((DvcAdvReadPCIConfigByte(asc_dvc, AscPCIConfigCommandRegister)
-	      & AscPCICmdRegBits_ParErrRespCtrl)) == 0) {
+	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+	if ((cmd & PCI_COMMAND_PARITY) == 0)
 		asc_dvc->cfg->control_flag |= CONTROL_FLAG_IGNORE_PERR;
-	}
 
 	asc_dvc->cfg->lib_version = (ADV_LIB_VERSION_MAJOR << 8) |
 	    ADV_LIB_VERSION_MINOR;
@@ -13977,19 +13784,11 @@ static int __devinit AdvInitGetConfig(ADV_DVC_VAR *asc_dvc)
 				     ADV_CTRL_REG_CMD_WR_IO_REG);
 
 		if (asc_dvc->chip_type == ADV_CHIP_ASC38C1600) {
-			if ((status =
-			     AdvInitFrom38C1600EEP(asc_dvc)) == ADV_ERROR) {
-				return ADV_ERROR;
-			}
+			status = AdvInitFrom38C1600EEP(asc_dvc);
 		} else if (asc_dvc->chip_type == ADV_CHIP_ASC38C0800) {
-			if ((status =
-			     AdvInitFrom38C0800EEP(asc_dvc)) == ADV_ERROR) {
-				return ADV_ERROR;
-			}
+			status = AdvInitFrom38C0800EEP(asc_dvc);
 		} else {
-			if ((status = AdvInitFrom3550EEP(asc_dvc)) == ADV_ERROR) {
-				return ADV_ERROR;
-			}
+			status = AdvInitFrom3550EEP(asc_dvc);
 		}
 		warn_code |= status;
 	}
@@ -18488,6 +18287,19 @@ static struct pci_device_id advansys_pci_tbl[] __devinitdata = {
 
 MODULE_DEVICE_TABLE(pci, advansys_pci_tbl);
 
+static void __devinit advansys_set_latency(struct pci_dev *pdev)
+{
+	if ((pdev->device == PCI_DEVICE_ID_ASP_1200A) ||
+	    (pdev->device == PCI_DEVICE_ID_ASP_ABP940)) {
+		pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0);
+	} else {
+		u8 latency;
+		pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &latency);
+		if (latency < 0x20)
+			pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x20);
+	}
+}
+
 static int __devinit
 advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
@@ -18500,6 +18312,8 @@ advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = pci_request_regions(pdev, "advansys");
 	if (err)
 		goto disable_device;
+	pci_set_master(pdev);
+	advansys_set_latency(pdev);
 
 	if (pci_resource_len(pdev, 0) == 0)
 		goto nodev;
-- 
1.4.4.4

