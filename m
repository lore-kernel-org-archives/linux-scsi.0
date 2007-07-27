From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 6/24] advansys: Convert to pci_register_driver interface
Date: Fri, 27 Jul 2007 07:42:15 -0600
Message-ID: <11855437531497-git-send-email-matthew@wil.cx>
References: <20070727134038.GC21219@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:56224 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760119AbXG0Nmf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 09:42:35 -0400
In-Reply-To: <20070727134038.GC21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

 - Add a pci_driver interface for the PCI advansys devices (for ISA/EISA/VLB
   devices, we still call advansys_detect and advansys_release).
 - Many functions are converted from __init to __devinit to allow hotplug
   PCI to work.
 - Remove some now-unused macros and struct definitions

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  347 +++++++++++++++++------------------------------
 1 files changed, 122 insertions(+), 225 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ec63139..80e24f5 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -865,12 +865,8 @@ typedef unsigned char uchar;
 #define AscPCIConfigLatencyTimer          0x000D
 #define AscPCIIOBaseRegister              0x0010
 #define AscPCICmdRegBits_IOMemBusMaster   0x0007
-#define ASC_PCI_ID2BUS(id)    ((id) & 0xFF)
-#define ASC_PCI_ID2DEV(id)    (((id) >> 11) & 0x1F)
 #define ASC_PCI_ID2FUNC(id)   (((id) >> 8) & 0x7)
 #define ASC_PCI_MKID(bus, dev, func) ((((dev) & 0x1F) << 11) | (((func) & 0x7) << 8) | ((bus) & 0xFF))
-#define ASC_PCI_REVISION_3150             0x02
-#define ASC_PCI_REVISION_3050             0x03
 
 #define  ASC_DVCLIB_CALL_DONE     (1)
 #define  ASC_DVCLIB_CALL_FAILED   (0)
@@ -3422,7 +3418,7 @@ typedef struct {
 
 #define ASC_NUM_BOARD_SUPPORTED 16
 #define ASC_NUM_IOPORT_PROBE    4
-#define ASC_NUM_BUS             4
+#define ASC_NUM_BUS             3
 
 /* Reference Scsi_Host hostdata */
 #define ASC_BOARDP(host) ((asc_board_t *) &((host)->hostdata))
@@ -3526,11 +3522,6 @@ typedef struct scsi_cmnd REQ, *REQP;
 /* Return non-zero, if the queue is empty. */
 #define ASC_QUEUE_EMPTY(ascq)    ((ascq)->q_tidmask == 0)
 
-#define PCI_MAX_SLOT            0x1F
-#define PCI_MAX_BUS             0xFF
-#define PCI_IOADDRESS_MASK      0xFFFE
-#define ASC_PCI_DEVICE_ID_CNT   6	/* PCI Device ID count. */
-
 #ifndef ADVANSYS_STATS
 #define ASC_STATS(shost, counter)
 #define ASC_STATS_ADD(shost, counter, count)
@@ -3856,52 +3847,6 @@ typedef struct asc_board {
 } asc_board_t;
 
 /*
- * PCI configuration structures
- */
-typedef struct _PCI_DATA_ {
-	uchar type;
-	uchar bus;
-	uchar slot;
-	uchar func;
-	uchar offset;
-} PCI_DATA;
-
-typedef struct _PCI_DEVICE_ {
-	ushort vendorID;
-	ushort deviceID;
-	ushort slotNumber;
-	ushort slotFound;
-	uchar busNumber;
-	uchar maxBusNumber;
-	uchar devFunc;
-	ushort startSlot;
-	ushort endSlot;
-	uchar bridge;
-	uchar type;
-} PCI_DEVICE;
-
-typedef struct _PCI_CONFIG_SPACE_ {
-	ushort vendorID;
-	ushort deviceID;
-	ushort command;
-	ushort status;
-	uchar revision;
-	uchar classCode[3];
-	uchar cacheSize;
-	uchar latencyTimer;
-	uchar headerType;
-	uchar bist;
-	ADV_PADDR baseAddress[6];
-	ushort reserved[4];
-	ADV_PADDR optionRomAddr;
-	ushort reserved2[4];
-	uchar irqLine;
-	uchar irqPin;
-	uchar minGnt;
-	uchar maxLatency;
-} PCI_CONFIG_SPACE;
-
-/*
  * --- Driver Data
  */
 
@@ -3920,12 +3865,11 @@ static uchar overrun_buf[ASC_OVERRUN_BSIZE] = { 0 };
 static ASC_SCSI_Q asc_scsi_q = { {0} };
 static ASC_SG_HEAD asc_sg_head = { 0 };
 
-/* List of supported bus types. */
+/* List of bus types probed in advansys_detect. */
 static ushort asc_bus[ASC_NUM_BUS] __initdata = {
 	ASC_IS_ISA,
 	ASC_IS_VL,
 	ASC_IS_EISA,
-	ASC_IS_PCI,
 };
 
 static int asc_iopflag = ASC_FALSE;
@@ -3936,7 +3880,6 @@ static char *asc_bus_name[ASC_NUM_BUS] = {
 	"ASC_IS_ISA",
 	"ASC_IS_VL",
 	"ASC_IS_EISA",
-	"ASC_IS_PCI",
 };
 
 static int asc_dbglvl = 3;
@@ -4692,6 +4635,8 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 	 */
 	for (i = 0; i < asc_board_count; i++) {
 		shost = asc_host[i];
+		if (!shost)
+			continue;
 		boardp = ASC_BOARDP(shost);
 		ASC_DBG2(2, "advansys_interrupt: i %d, boardp 0x%lx\n",
 			 i, (ulong)boardp);
@@ -7495,7 +7440,7 @@ DvcGetQinfo(PortAddr iop_base, ushort s_addr, uchar *inbuf, int words)
 /*
  * Read a PCI configuration byte.
  */
-static uchar __init DvcReadPCIConfigByte(ASC_DVC_VAR *asc_dvc, ushort offset)
+static uchar __devinit DvcReadPCIConfigByte(ASC_DVC_VAR *asc_dvc, ushort offset)
 {
 #ifdef CONFIG_PCI
 	uchar byte_data;
@@ -7509,7 +7454,7 @@ static uchar __init DvcReadPCIConfigByte(ASC_DVC_VAR *asc_dvc, ushort offset)
 /*
  * Write a PCI configuration byte.
  */
-static void __init
+static void __devinit
 DvcWritePCIConfigByte(ASC_DVC_VAR *asc_dvc, ushort offset, uchar byte_data)
 {
 #ifdef CONFIG_PCI
@@ -7521,7 +7466,7 @@ DvcWritePCIConfigByte(ASC_DVC_VAR *asc_dvc, ushort offset, uchar byte_data)
  * Return the BIOS address of the adapter at the specified
  * I/O port and with the specified bus type.
  */
-static ushort __init AscGetChipBiosAddress(PortAddr iop_base, ushort bus_type)
+static ushort __devinit AscGetChipBiosAddress(PortAddr iop_base, ushort bus_type)
 {
 	ushort cfg_lsw;
 	ushort bios_addr;
@@ -7592,7 +7537,7 @@ DvcGetPhyAddr(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq,
 /*
  * Read a PCI configuration byte.
  */
-static uchar __init DvcAdvReadPCIConfigByte(ADV_DVC_VAR *asc_dvc, ushort offset)
+static uchar __devinit DvcAdvReadPCIConfigByte(ADV_DVC_VAR *asc_dvc, ushort offset)
 {
 #ifdef CONFIG_PCI
 	uchar byte_data;
@@ -7606,7 +7551,7 @@ static uchar __init DvcAdvReadPCIConfigByte(ADV_DVC_VAR *asc_dvc, ushort offset)
 /*
  * Write a PCI configuration byte.
  */
-static void __init
+static void __devinit
 DvcAdvWritePCIConfigByte(ADV_DVC_VAR *asc_dvc, ushort offset, uchar byte_data)
 {
 #ifdef CONFIG_PCI
@@ -8202,7 +8147,7 @@ static void asc_prt_hex(char *f, uchar *s, int l)
  * --- Asc Library Functions
  */
 
-static ushort __init AscGetEisaChipCfg(PortAddr iop_base)
+static ushort __devinit AscGetEisaChipCfg(PortAddr iop_base)
 {
 	PortAddr eisa_cfg_iop;
 
@@ -8211,7 +8156,7 @@ static ushort __init AscGetEisaChipCfg(PortAddr iop_base)
 	return (inpw(eisa_cfg_iop));
 }
 
-static uchar __init AscSetChipScsiID(PortAddr iop_base, uchar new_host_id)
+static uchar __devinit AscSetChipScsiID(PortAddr iop_base, uchar new_host_id)
 {
 	ushort cfg_lsw;
 
@@ -8225,7 +8170,7 @@ static uchar __init AscSetChipScsiID(PortAddr iop_base, uchar new_host_id)
 	return (AscGetChipScsiID(iop_base));
 }
 
-static uchar __init AscGetChipScsiCtrl(PortAddr iop_base)
+static uchar __devinit AscGetChipScsiCtrl(PortAddr iop_base)
 {
 	uchar sc;
 
@@ -8235,7 +8180,7 @@ static uchar __init AscGetChipScsiCtrl(PortAddr iop_base)
 	return (sc);
 }
 
-static uchar __init AscGetChipVersion(PortAddr iop_base, ushort bus_type)
+static uchar __devinit AscGetChipVersion(PortAddr iop_base, ushort bus_type)
 {
 	if ((bus_type & ASC_IS_EISA) != 0) {
 		PortAddr eisa_iop;
@@ -8248,7 +8193,7 @@ static uchar __init AscGetChipVersion(PortAddr iop_base, ushort bus_type)
 	return (AscGetChipVerNo(iop_base));
 }
 
-static ushort __init AscGetChipBusType(PortAddr iop_base)
+static ushort __devinit AscGetChipBusType(PortAddr iop_base)
 {
 	ushort chip_ver;
 
@@ -8400,14 +8345,14 @@ static void __init AscSetISAPNPWaitForKey(void)
 }
 #endif /* CONFIG_ISA */
 
-static void __init AscToggleIRQAct(PortAddr iop_base)
+static void __devinit AscToggleIRQAct(PortAddr iop_base)
 {
 	AscSetChipStatus(iop_base, CIW_IRQ_ACT);
 	AscSetChipStatus(iop_base, 0);
 	return;
 }
 
-static uchar __init AscGetChipIRQ(PortAddr iop_base, ushort bus_type)
+static uchar __devinit AscGetChipIRQ(PortAddr iop_base, ushort bus_type)
 {
 	ushort cfg_lsw;
 	uchar chip_irq;
@@ -8435,7 +8380,7 @@ static uchar __init AscGetChipIRQ(PortAddr iop_base, ushort bus_type)
 	return ((uchar)(chip_irq + ASC_MIN_IRQ_NO));
 }
 
-static uchar __init
+static uchar __devinit
 AscSetChipIRQ(PortAddr iop_base, uchar irq_no, ushort bus_type)
 {
 	ushort cfg_lsw;
@@ -8472,7 +8417,7 @@ AscSetChipIRQ(PortAddr iop_base, uchar irq_no, ushort bus_type)
 }
 
 #ifdef CONFIG_ISA
-static void __init AscEnableIsaDma(uchar dma_channel)
+static void __devinit AscEnableIsaDma(uchar dma_channel)
 {
 	if (dma_channel < 4) {
 		outp(0x000B, (ushort)(0xC0 | dma_channel));
@@ -10554,7 +10499,7 @@ static int AscResetChipAndScsiBus(ASC_DVC_VAR *asc_dvc)
 	return (AscIsChipHalted(iop_base));
 }
 
-static ASC_DCNT __init AscGetMaxDmaCount(ushort bus_type)
+static ASC_DCNT __devinit AscGetMaxDmaCount(ushort bus_type)
 {
 	if (bus_type & ASC_IS_ISA)
 		return (ASC_MAX_ISA_DMA_COUNT);
@@ -10564,7 +10509,7 @@ static ASC_DCNT __init AscGetMaxDmaCount(ushort bus_type)
 }
 
 #ifdef CONFIG_ISA
-static ushort __init AscGetIsaDmaChannel(PortAddr iop_base)
+static ushort __devinit AscGetIsaDmaChannel(PortAddr iop_base)
 {
 	ushort channel;
 
@@ -10576,7 +10521,7 @@ static ushort __init AscGetIsaDmaChannel(PortAddr iop_base)
 	return (channel + 4);
 }
 
-static ushort __init AscSetIsaDmaChannel(PortAddr iop_base, ushort dma_channel)
+static ushort __devinit AscSetIsaDmaChannel(PortAddr iop_base, ushort dma_channel)
 {
 	ushort cfg_lsw;
 	uchar value;
@@ -10594,7 +10539,7 @@ static ushort __init AscSetIsaDmaChannel(PortAddr iop_base, ushort dma_channel)
 	return (0);
 }
 
-static uchar __init AscSetIsaDmaSpeed(PortAddr iop_base, uchar speed_value)
+static uchar __devinit AscSetIsaDmaSpeed(PortAddr iop_base, uchar speed_value)
 {
 	speed_value &= 0x07;
 	AscSetBank(iop_base, 1);
@@ -10603,7 +10548,7 @@ static uchar __init AscSetIsaDmaSpeed(PortAddr iop_base, uchar speed_value)
 	return (AscGetIsaDmaSpeed(iop_base));
 }
 
-static uchar __init AscGetIsaDmaSpeed(PortAddr iop_base)
+static uchar __devinit AscGetIsaDmaSpeed(PortAddr iop_base)
 {
 	uchar speed_value;
 
@@ -10615,7 +10560,7 @@ static uchar __init AscGetIsaDmaSpeed(PortAddr iop_base)
 }
 #endif /* CONFIG_ISA */
 
-static ushort __init
+static ushort __devinit
 AscReadPCIConfigWord(ASC_DVC_VAR *asc_dvc, ushort pci_config_offset)
 {
 	uchar lsb, msb;
@@ -10625,7 +10570,7 @@ AscReadPCIConfigWord(ASC_DVC_VAR *asc_dvc, ushort pci_config_offset)
 	return ((ushort)((msb << 8) | lsb));
 }
 
-static ushort __init AscInitGetConfig(ASC_DVC_VAR *asc_dvc)
+static ushort __devinit AscInitGetConfig(ASC_DVC_VAR *asc_dvc)
 {
 	ushort warn_code;
 	PortAddr iop_base;
@@ -10710,7 +10655,7 @@ static ushort __init AscInitGetConfig(ASC_DVC_VAR *asc_dvc)
 	return (warn_code);
 }
 
-static ushort __init AscInitSetConfig(ASC_DVC_VAR *asc_dvc)
+static ushort __devinit AscInitSetConfig(ASC_DVC_VAR *asc_dvc)
 {
 	ushort warn_code = 0;
 
@@ -10726,7 +10671,7 @@ static ushort __init AscInitSetConfig(ASC_DVC_VAR *asc_dvc)
 	return (warn_code);
 }
 
-static ushort __init AscInitFromAscDvcVar(ASC_DVC_VAR *asc_dvc)
+static ushort __devinit AscInitFromAscDvcVar(ASC_DVC_VAR *asc_dvc)
 {
 	PortAddr iop_base;
 	ushort cfg_msw;
@@ -10827,7 +10772,7 @@ static ushort AscInitAsc1000Driver(ASC_DVC_VAR *asc_dvc)
 	return (warn_code);
 }
 
-static ushort __init AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
+static ushort __devinit AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 {
 	int i;
 	PortAddr iop_base;
@@ -10939,7 +10884,7 @@ static ushort __init AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 	return (warn_code);
 }
 
-static ushort __init AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
+static ushort __devinit AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
 {
 	ASCEEP_CONFIG eep_config_buf;
 	ASCEEP_CONFIG *eep_config;
@@ -11160,7 +11105,7 @@ static ushort AscInitMicroCodeVar(ASC_DVC_VAR *asc_dvc)
 	return (warn_code);
 }
 
-static int __init AscTestExternalLram(ASC_DVC_VAR *asc_dvc)
+static int __devinit AscTestExternalLram(ASC_DVC_VAR *asc_dvc)
 {
 	PortAddr iop_base;
 	ushort q_addr;
@@ -11182,7 +11127,7 @@ static int __init AscTestExternalLram(ASC_DVC_VAR *asc_dvc)
 	return (sta);
 }
 
-static int __init AscWriteEEPCmdReg(PortAddr iop_base, uchar cmd_reg)
+static int __devinit AscWriteEEPCmdReg(PortAddr iop_base, uchar cmd_reg)
 {
 	uchar read_back;
 	int retry;
@@ -11201,7 +11146,7 @@ static int __init AscWriteEEPCmdReg(PortAddr iop_base, uchar cmd_reg)
 	}
 }
 
-static int __init AscWriteEEPDataReg(PortAddr iop_base, ushort data_reg)
+static int __devinit AscWriteEEPDataReg(PortAddr iop_base, ushort data_reg)
 {
 	ushort read_back;
 	int retry;
@@ -11220,19 +11165,19 @@ static int __init AscWriteEEPDataReg(PortAddr iop_base, ushort data_reg)
 	}
 }
 
-static void __init AscWaitEEPRead(void)
+static void __devinit AscWaitEEPRead(void)
 {
 	DvcSleepMilliSecond(1);
 	return;
 }
 
-static void __init AscWaitEEPWrite(void)
+static void __devinit AscWaitEEPWrite(void)
 {
 	DvcSleepMilliSecond(20);
 	return;
 }
 
-static ushort __init AscReadEEPWord(PortAddr iop_base, uchar addr)
+static ushort __devinit AscReadEEPWord(PortAddr iop_base, uchar addr)
 {
 	ushort read_wval;
 	uchar cmd_reg;
@@ -11247,7 +11192,7 @@ static ushort __init AscReadEEPWord(PortAddr iop_base, uchar addr)
 	return (read_wval);
 }
 
-static ushort __init
+static ushort __devinit
 AscWriteEEPWord(PortAddr iop_base, uchar addr, ushort word_val)
 {
 	ushort read_wval;
@@ -11268,7 +11213,7 @@ AscWriteEEPWord(PortAddr iop_base, uchar addr, ushort word_val)
 	return (read_wval);
 }
 
-static ushort __init
+static ushort __devinit
 AscGetEEPConfig(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort bus_type)
 {
 	ushort wval;
@@ -11315,7 +11260,7 @@ AscGetEEPConfig(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort bus_type)
 	return (sum);
 }
 
-static int __init
+static int __devinit
 AscSetEEPConfigOnce(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort bus_type)
 {
 	int n_error;
@@ -11411,7 +11356,7 @@ AscSetEEPConfigOnce(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort bus_type)
 	return (n_error);
 }
 
-static int __init
+static int __devinit
 AscSetEEPConfig(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort bus_type)
 {
 	int retry;
@@ -13823,7 +13768,7 @@ static ADV_DCNT _adv_asc38C1600_chksum = 0x0604EF77UL;	/* Expanded little-endian
  * on big-endian platforms so char fields read as words are actually being
  * unswapped on big-endian platforms.
  */
-static ADVEEP_3550_CONFIG Default_3550_EEPROM_Config __initdata = {
+static ADVEEP_3550_CONFIG Default_3550_EEPROM_Config __devinitdata = {
 	ADV_EEPROM_BIOS_ENABLE,	/* cfg_lsw */
 	0x0000,			/* cfg_msw */
 	0xFFFF,			/* disc_enable */
@@ -13861,7 +13806,7 @@ static ADVEEP_3550_CONFIG Default_3550_EEPROM_Config __initdata = {
 	0			/* num_of_err */
 };
 
-static ADVEEP_3550_CONFIG ADVEEP_3550_Config_Field_IsChar __initdata = {
+static ADVEEP_3550_CONFIG ADVEEP_3550_Config_Field_IsChar __devinitdata = {
 	0,			/* cfg_lsw */
 	0,			/* cfg_msw */
 	0,			/* -disc_enable */
@@ -13899,7 +13844,7 @@ static ADVEEP_3550_CONFIG ADVEEP_3550_Config_Field_IsChar __initdata = {
 	0			/* num_of_err */
 };
 
-static ADVEEP_38C0800_CONFIG Default_38C0800_EEPROM_Config __initdata = {
+static ADVEEP_38C0800_CONFIG Default_38C0800_EEPROM_Config __devinitdata = {
 	ADV_EEPROM_BIOS_ENABLE,	/* 00 cfg_lsw */
 	0x0000,			/* 01 cfg_msw */
 	0xFFFF,			/* 02 disc_enable */
@@ -13964,7 +13909,7 @@ static ADVEEP_38C0800_CONFIG Default_38C0800_EEPROM_Config __initdata = {
 	0			/* 63 reserved */
 };
 
-static ADVEEP_38C0800_CONFIG ADVEEP_38C0800_Config_Field_IsChar __initdata = {
+static ADVEEP_38C0800_CONFIG ADVEEP_38C0800_Config_Field_IsChar __devinitdata = {
 	0,			/* 00 cfg_lsw */
 	0,			/* 01 cfg_msw */
 	0,			/* 02 disc_enable */
@@ -14029,7 +13974,7 @@ static ADVEEP_38C0800_CONFIG ADVEEP_38C0800_Config_Field_IsChar __initdata = {
 	0			/* 63 reserved */
 };
 
-static ADVEEP_38C1600_CONFIG Default_38C1600_EEPROM_Config __initdata = {
+static ADVEEP_38C1600_CONFIG Default_38C1600_EEPROM_Config __devinitdata = {
 	ADV_EEPROM_BIOS_ENABLE,	/* 00 cfg_lsw */
 	0x0000,			/* 01 cfg_msw */
 	0xFFFF,			/* 02 disc_enable */
@@ -14094,7 +14039,7 @@ static ADVEEP_38C1600_CONFIG Default_38C1600_EEPROM_Config __initdata = {
 	0			/* 63 reserved */
 };
 
-static ADVEEP_38C1600_CONFIG ADVEEP_38C1600_Config_Field_IsChar __initdata = {
+static ADVEEP_38C1600_CONFIG ADVEEP_38C1600_Config_Field_IsChar __devinitdata = {
 	0,			/* 00 cfg_lsw */
 	0,			/* 01 cfg_msw */
 	0,			/* 02 disc_enable */
@@ -14167,7 +14112,7 @@ static ADVEEP_38C1600_CONFIG ADVEEP_38C1600_Config_Field_IsChar __initdata = {
  * For a non-fatal error return a warning code. If there are no warnings
  * then 0 is returned.
  */
-static int __init AdvInitGetConfig(ADV_DVC_VAR *asc_dvc)
+static int __devinit AdvInitGetConfig(ADV_DVC_VAR *asc_dvc)
 {
 	ushort warn_code;
 	AdvPortAddr iop_base;
@@ -16111,7 +16056,7 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
  *
  * Note: Chip is stopped on entry.
  */
-static int __init AdvInitFrom3550EEP(ADV_DVC_VAR *asc_dvc)
+static int __devinit AdvInitFrom3550EEP(ADV_DVC_VAR *asc_dvc)
 {
 	AdvPortAddr iop_base;
 	ushort warn_code;
@@ -16265,7 +16210,7 @@ static int __init AdvInitFrom3550EEP(ADV_DVC_VAR *asc_dvc)
  *
  * Note: Chip is stopped on entry.
  */
-static int __init AdvInitFrom38C0800EEP(ADV_DVC_VAR *asc_dvc)
+static int __devinit AdvInitFrom38C0800EEP(ADV_DVC_VAR *asc_dvc)
 {
 	AdvPortAddr iop_base;
 	ushort warn_code;
@@ -16468,7 +16413,7 @@ static int __init AdvInitFrom38C0800EEP(ADV_DVC_VAR *asc_dvc)
  *
  * Note: Chip is stopped on entry.
  */
-static int __init AdvInitFrom38C1600EEP(ADV_DVC_VAR *asc_dvc)
+static int __devinit AdvInitFrom38C1600EEP(ADV_DVC_VAR *asc_dvc)
 {
 	AdvPortAddr iop_base;
 	ushort warn_code;
@@ -16709,7 +16654,7 @@ static int __init AdvInitFrom38C1600EEP(ADV_DVC_VAR *asc_dvc)
  *
  * Return a checksum based on the EEPROM configuration read.
  */
-static ushort __init
+static ushort __devinit
 AdvGet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
 {
 	ushort wval, chksum;
@@ -16752,7 +16697,7 @@ AdvGet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
  *
  * Return a checksum based on the EEPROM configuration read.
  */
-static ushort __init
+static ushort __devinit
 AdvGet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cfg_buf)
 {
 	ushort wval, chksum;
@@ -16795,7 +16740,7 @@ AdvGet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cfg_buf)
  *
  * Return a checksum based on the EEPROM configuration read.
  */
-static ushort __init
+static ushort __devinit
 AdvGet38C1600EEPConfig(AdvPortAddr iop_base, ADVEEP_38C1600_CONFIG *cfg_buf)
 {
 	ushort wval, chksum;
@@ -16836,7 +16781,7 @@ AdvGet38C1600EEPConfig(AdvPortAddr iop_base, ADVEEP_38C1600_CONFIG *cfg_buf)
 /*
  * Read the EEPROM from specified location
  */
-static ushort __init AdvReadEEPWord(AdvPortAddr iop_base, int eep_word_addr)
+static ushort __devinit AdvReadEEPWord(AdvPortAddr iop_base, int eep_word_addr)
 {
 	AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
 			     ASC_EEP_CMD_READ | eep_word_addr);
@@ -16847,7 +16792,7 @@ static ushort __init AdvReadEEPWord(AdvPortAddr iop_base, int eep_word_addr)
 /*
  * Wait for EEPROM command to complete
  */
-static void __init AdvWaitEEPCmd(AdvPortAddr iop_base)
+static void __devinit AdvWaitEEPCmd(AdvPortAddr iop_base)
 {
 	int eep_delay_ms;
 
@@ -16868,7 +16813,7 @@ static void __init AdvWaitEEPCmd(AdvPortAddr iop_base)
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void __init
+void __devinit
 AdvSet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
 {
 	ushort *wbuf;
@@ -16936,7 +16881,7 @@ AdvSet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void __init
+void __devinit
 AdvSet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cfg_buf)
 {
 	ushort *wbuf;
@@ -17004,7 +16949,7 @@ AdvSet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cfg_buf)
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void __init
+void __devinit
 AdvSet38C1600EEPConfig(AdvPortAddr iop_base, ADVEEP_38C1600_CONFIG *cfg_buf)
 {
 	ushort *wbuf;
@@ -18598,23 +18543,6 @@ static int __init advansys_detect(void)
 	int iop;
 	int bus;
 	int ioport = 0;
-	struct device *dev = NULL;
-#ifdef CONFIG_PCI
-	int pci_init_search = 0;
-	struct pci_dev *pci_devicep[ASC_NUM_BOARD_SUPPORTED];
-	int pci_card_cnt_max = 0;
-	int pci_card_cnt = 0;
-	struct pci_dev *pdev = NULL;
-	int pci_device_id_cnt = 0;
-	unsigned int pci_device_id[ASC_PCI_DEVICE_ID_CNT] = {
-		PCI_DEVICE_ID_ASP_1200A,
-		PCI_DEVICE_ID_ASP_ABP940,
-		PCI_DEVICE_ID_ASP_ABP940U,
-		PCI_DEVICE_ID_ASP_ABP940UW,
-		PCI_DEVICE_ID_38C0800_REV1,
-		PCI_DEVICE_ID_38C1600_REV1
-	};
-#endif /* CONFIG_PCI */
 
 	ASC_DBG(1, "advansys_detect: begin\n");
 
@@ -18751,97 +18679,6 @@ static int __init advansys_detect(void)
 #endif /* CONFIG_ISA */
 				break;
 
-			case ASC_IS_PCI:
-#ifdef CONFIG_PCI
-				if (pci_init_search == 0) {
-					int i, j;
-
-					pci_init_search = 1;
-
-					/* Find all PCI cards. */
-					while (pci_device_id_cnt <
-					       ASC_PCI_DEVICE_ID_CNT) {
-						if ((pdev =
-						     pci_find_device
-						     (PCI_VENDOR_ID_ASP,
-						      pci_device_id
-						      [pci_device_id_cnt],
-						      pdev)) == NULL) {
-							pci_device_id_cnt++;
-						} else {
-							if (pci_enable_device
-							    (pdev) == 0) {
-								pci_devicep
-								    [pci_card_cnt_max++]
-								    = pdev;
-							}
-						}
-					}
-
-					/*
-					 * Sort PCI cards in ascending order by PCI Bus, Slot,
-					 * and Device Number.
-					 */
-					for (i = 0; i < pci_card_cnt_max - 1;
-					     i++) {
-						for (j = i + 1;
-						     j < pci_card_cnt_max;
-						     j++) {
-							if ((pci_devicep[j]->
-							     bus->number <
-							     pci_devicep[i]->
-							     bus->number)
-							    ||
-							    ((pci_devicep[j]->
-							      bus->number ==
-							      pci_devicep[i]->
-							      bus->number)
-							     &&
-							     (pci_devicep[j]->
-							      devfn <
-							      pci_devicep[i]->
-							      devfn))) {
-								pdev =
-								    pci_devicep
-								    [i];
-								pci_devicep[i] =
-								    pci_devicep
-								    [j];
-								pci_devicep[j] =
-								    pdev;
-							}
-						}
-					}
-
-					pci_card_cnt = 0;
-				} else {
-					pci_card_cnt++;
-				}
-
-				if (pci_card_cnt == pci_card_cnt_max) {
-					iop = 0;
-				} else {
-					pdev = pci_devicep[pci_card_cnt];
-
-					ASC_DBG2(2,
-						 "advansys_detect: devfn %d, bus number %d\n",
-						 pdev->devfn,
-						 pdev->bus->number);
-					iop = pci_resource_start(pdev, 0);
-					ASC_DBG2(1,
-						 "advansys_detect: vendorID %X, deviceID %X\n",
-						 pdev->vendor,
-						 pdev->device);
-					ASC_DBG2(2,
-						 "advansys_detect: iop %X, irqLine %d\n",
-						 iop, pdev->irq);
-				}
-				if (pdev)
-					dev = &pdev->dev;
-
-#endif /* CONFIG_PCI */
-				break;
-
 			default:
 				ASC_PRINT1
 				    ("advansys_detect: unknown bus type: %d\n",
@@ -18857,7 +18694,7 @@ static int __init advansys_detect(void)
 				break;
 			}
 
-			advansys_board_found(iop, dev, asc_bus[bus]);
+			advansys_board_found(iop, NULL, asc_bus[bus]);
 		}
 	}
 
@@ -18907,7 +18744,20 @@ static int advansys_release(struct Scsi_Host *shost)
 	return 0;
 }
 
-#ifdef CONFIG_PCI
+static void __devexit advansys_remove(struct Scsi_Host *shost)
+{
+	int i;
+	scsi_remove_host(shost);
+	advansys_release(shost);
+
+	for (i = 0; i < asc_board_count; i++) {
+		if (asc_host[i] == shost) {
+			asc_host[i] = NULL;
+			break;
+		}
+	}
+}
+
 /* PCI Devices supported by this driver */
 static struct pci_device_id advansys_pci_tbl[] __devinitdata = {
 	{PCI_VENDOR_ID_ASP, PCI_DEVICE_ID_ASP_1200A,
@@ -18926,19 +18776,66 @@ static struct pci_device_id advansys_pci_tbl[] __devinitdata = {
 };
 
 MODULE_DEVICE_TABLE(pci, advansys_pci_tbl);
-#endif /* CONFIG_PCI */
+
+static int __devinit
+advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	int err, ioport;
+	struct Scsi_Host *shost;
+
+	err = pci_enable_device(pdev);
+	if (err)
+		goto fail;
+
+	ioport = pci_resource_start(pdev, 0);
+	shost = advansys_board_found(ioport, &pdev->dev, ASC_IS_PCI);
+
+	if (shost) {
+		pci_set_drvdata(pdev, shost);
+		return 0;
+	}
+
+	err = -ENODEV;
+	pci_disable_device(pdev);
+ fail:
+	return err;
+}
+
+static void __devexit advansys_pci_remove(struct pci_dev *pdev)
+{
+	advansys_remove(pci_get_drvdata(pdev));
+	pci_disable_device(pdev);
+}
+
+static struct pci_driver advansys_pci_driver = {
+	.name =		"advansys",
+	.id_table =	advansys_pci_tbl,
+	.probe =	advansys_pci_probe,
+	.remove =	__devexit_p(advansys_pci_remove),
+};
 
 static int __init advansys_init(void)
 {
-	int count;
+	int count, error;
 	count = advansys_detect();
-	return 0;
+	error = pci_register_driver(&advansys_pci_driver);
+
+	/*
+	 * If we found some ISA, EISA or VLB devices, we must not fail.
+	 * We may not drive any PCI devices, but it's better to drive
+	 * the cards that we successfully discovered than none at all.
+	 */
+	if (count > 0)
+		error = 0;
+	return error;
 }
 
 static void __exit advansys_exit(void)
 {
 	int i;
 
+	pci_unregister_driver(&advansys_pci_driver);
+
 	for (i = 0; i < asc_board_count; i++) {
 		struct Scsi_Host *host = asc_host[i];
 		if (!host)
-- 
1.4.4.4

