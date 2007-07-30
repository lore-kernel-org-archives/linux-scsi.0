From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 7/23] advansys: Convert to PCI driver model
Date: Mon, 30 Jul 2007 10:56:52 -0600
Message-ID: <11858146281215-git-send-email-matthew@wil.cx>
References: <20070730165508.GH21219@parisc-linux.org> <11858146283240-git-send-email-matthew@wil.cx> <1185814628978-git-send-email-matthew@wil.cx> <11858146282602-git-send-email-matthew@wil.cx> <11858146283106-git-send-email-matthew@wil.cx> <11858146282252-git-send-email-matthew@wil.cx> <11858146281790-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:58922 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964936AbXG3Q5N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 12:57:13 -0400
In-Reply-To: <11858146281790-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

 - Add a pci_driver interface for the PCI advansys devices (for
   ISA/EISA/VLB devices, we still call advansys_detect).
 - Many functions are converted from __init to __devinit to allow hotplug
   PCI to work.
 - Only keep devices found by advansys_detect in the asc_host list.
 - Rename asc_board_count to asc_legacy_count.  New asc_board_count is only
   used to generate a unique name for each device.
 - Remove some now-unused macros and struct definitions

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  378 ++++++++++++++++-------------------------------
 1 files changed, 129 insertions(+), 249 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 8353680..3ba7032 100644
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
@@ -3853,60 +3844,11 @@ typedef struct asc_board {
 	ushort bios_codelen;	/* BIOS Code Segment Length. */
 } asc_board_t;
 
-/*
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
- * --- Driver Data
- */
-
-/* Note: All driver global data should be initialized. */
-
 /* Number of boards detected in system. */
-static int asc_board_count = 0;
+static int asc_board_count;
+
+/* Number of boards detected by advansys_detect */
+static int asc_legacy_count;
 static struct Scsi_Host *asc_host[ASC_NUM_BOARD_SUPPORTED] = { NULL };
 
 /* Overrun buffer used by all narrow boards. */
@@ -3918,12 +3860,11 @@ static uchar overrun_buf[ASC_OVERRUN_BSIZE] = { 0 };
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
@@ -3934,7 +3875,6 @@ static char *asc_bus_name[ASC_NUM_BUS] = {
 	"ASC_IS_ISA",
 	"ASC_IS_VL",
 	"ASC_IS_EISA",
-	"ASC_IS_PCI",
 };
 
 static int asc_dbglvl = 3;
@@ -7441,7 +7381,7 @@ DvcGetQinfo(PortAddr iop_base, ushort s_addr, uchar *inbuf, int words)
 /*
  * Read a PCI configuration byte.
  */
-static uchar __init DvcReadPCIConfigByte(ASC_DVC_VAR *asc_dvc, ushort offset)
+static uchar __devinit DvcReadPCIConfigByte(ASC_DVC_VAR *asc_dvc, ushort offset)
 {
 #ifdef CONFIG_PCI
 	uchar byte_data;
@@ -7455,7 +7395,7 @@ static uchar __init DvcReadPCIConfigByte(ASC_DVC_VAR *asc_dvc, ushort offset)
 /*
  * Write a PCI configuration byte.
  */
-static void __init
+static void __devinit
 DvcWritePCIConfigByte(ASC_DVC_VAR *asc_dvc, ushort offset, uchar byte_data)
 {
 #ifdef CONFIG_PCI
@@ -7467,7 +7407,7 @@ DvcWritePCIConfigByte(ASC_DVC_VAR *asc_dvc, ushort offset, uchar byte_data)
  * Return the BIOS address of the adapter at the specified
  * I/O port and with the specified bus type.
  */
-static ushort __init AscGetChipBiosAddress(PortAddr iop_base, ushort bus_type)
+static ushort __devinit AscGetChipBiosAddress(PortAddr iop_base, ushort bus_type)
 {
 	ushort cfg_lsw;
 	ushort bios_addr;
@@ -7538,7 +7478,7 @@ DvcGetPhyAddr(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq,
 /*
  * Read a PCI configuration byte.
  */
-static uchar __init DvcAdvReadPCIConfigByte(ADV_DVC_VAR *asc_dvc, ushort offset)
+static uchar __devinit DvcAdvReadPCIConfigByte(ADV_DVC_VAR *asc_dvc, ushort offset)
 {
 #ifdef CONFIG_PCI
 	uchar byte_data;
@@ -7552,7 +7492,7 @@ static uchar __init DvcAdvReadPCIConfigByte(ADV_DVC_VAR *asc_dvc, ushort offset)
 /*
  * Write a PCI configuration byte.
  */
-static void __init
+static void __devinit
 DvcAdvWritePCIConfigByte(ADV_DVC_VAR *asc_dvc, ushort offset, uchar byte_data)
 {
 #ifdef CONFIG_PCI
@@ -8148,7 +8088,7 @@ static void asc_prt_hex(char *f, uchar *s, int l)
  * --- Asc Library Functions
  */
 
-static ushort __init AscGetEisaChipCfg(PortAddr iop_base)
+static ushort __devinit AscGetEisaChipCfg(PortAddr iop_base)
 {
 	PortAddr eisa_cfg_iop;
 
@@ -8157,7 +8097,7 @@ static ushort __init AscGetEisaChipCfg(PortAddr iop_base)
 	return (inpw(eisa_cfg_iop));
 }
 
-static uchar __init AscSetChipScsiID(PortAddr iop_base, uchar new_host_id)
+static uchar __devinit AscSetChipScsiID(PortAddr iop_base, uchar new_host_id)
 {
 	ushort cfg_lsw;
 
@@ -8171,7 +8111,7 @@ static uchar __init AscSetChipScsiID(PortAddr iop_base, uchar new_host_id)
 	return (AscGetChipScsiID(iop_base));
 }
 
-static uchar __init AscGetChipScsiCtrl(PortAddr iop_base)
+static uchar __devinit AscGetChipScsiCtrl(PortAddr iop_base)
 {
 	uchar sc;
 
@@ -8181,7 +8121,7 @@ static uchar __init AscGetChipScsiCtrl(PortAddr iop_base)
 	return (sc);
 }
 
-static uchar __init AscGetChipVersion(PortAddr iop_base, ushort bus_type)
+static uchar __devinit AscGetChipVersion(PortAddr iop_base, ushort bus_type)
 {
 	if ((bus_type & ASC_IS_EISA) != 0) {
 		PortAddr eisa_iop;
@@ -8194,7 +8134,7 @@ static uchar __init AscGetChipVersion(PortAddr iop_base, ushort bus_type)
 	return (AscGetChipVerNo(iop_base));
 }
 
-static ushort __init AscGetChipBusType(PortAddr iop_base)
+static ushort __devinit AscGetChipBusType(PortAddr iop_base)
 {
 	ushort chip_ver;
 
@@ -8346,14 +8286,14 @@ static void __init AscSetISAPNPWaitForKey(void)
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
@@ -8381,7 +8321,7 @@ static uchar __init AscGetChipIRQ(PortAddr iop_base, ushort bus_type)
 	return ((uchar)(chip_irq + ASC_MIN_IRQ_NO));
 }
 
-static uchar __init
+static uchar __devinit
 AscSetChipIRQ(PortAddr iop_base, uchar irq_no, ushort bus_type)
 {
 	ushort cfg_lsw;
@@ -8418,7 +8358,7 @@ AscSetChipIRQ(PortAddr iop_base, uchar irq_no, ushort bus_type)
 }
 
 #ifdef CONFIG_ISA
-static void __init AscEnableIsaDma(uchar dma_channel)
+static void __devinit AscEnableIsaDma(uchar dma_channel)
 {
 	if (dma_channel < 4) {
 		outp(0x000B, (ushort)(0xC0 | dma_channel));
@@ -10500,7 +10440,7 @@ static int AscResetChipAndScsiBus(ASC_DVC_VAR *asc_dvc)
 	return (AscIsChipHalted(iop_base));
 }
 
-static ASC_DCNT __init AscGetMaxDmaCount(ushort bus_type)
+static ASC_DCNT __devinit AscGetMaxDmaCount(ushort bus_type)
 {
 	if (bus_type & ASC_IS_ISA)
 		return (ASC_MAX_ISA_DMA_COUNT);
@@ -10510,7 +10450,7 @@ static ASC_DCNT __init AscGetMaxDmaCount(ushort bus_type)
 }
 
 #ifdef CONFIG_ISA
-static ushort __init AscGetIsaDmaChannel(PortAddr iop_base)
+static ushort __devinit AscGetIsaDmaChannel(PortAddr iop_base)
 {
 	ushort channel;
 
@@ -10522,7 +10462,7 @@ static ushort __init AscGetIsaDmaChannel(PortAddr iop_base)
 	return (channel + 4);
 }
 
-static ushort __init AscSetIsaDmaChannel(PortAddr iop_base, ushort dma_channel)
+static ushort __devinit AscSetIsaDmaChannel(PortAddr iop_base, ushort dma_channel)
 {
 	ushort cfg_lsw;
 	uchar value;
@@ -10540,7 +10480,7 @@ static ushort __init AscSetIsaDmaChannel(PortAddr iop_base, ushort dma_channel)
 	return (0);
 }
 
-static uchar __init AscSetIsaDmaSpeed(PortAddr iop_base, uchar speed_value)
+static uchar __devinit AscSetIsaDmaSpeed(PortAddr iop_base, uchar speed_value)
 {
 	speed_value &= 0x07;
 	AscSetBank(iop_base, 1);
@@ -10549,7 +10489,7 @@ static uchar __init AscSetIsaDmaSpeed(PortAddr iop_base, uchar speed_value)
 	return (AscGetIsaDmaSpeed(iop_base));
 }
 
-static uchar __init AscGetIsaDmaSpeed(PortAddr iop_base)
+static uchar __devinit AscGetIsaDmaSpeed(PortAddr iop_base)
 {
 	uchar speed_value;
 
@@ -10561,7 +10501,7 @@ static uchar __init AscGetIsaDmaSpeed(PortAddr iop_base)
 }
 #endif /* CONFIG_ISA */
 
-static ushort __init
+static ushort __devinit
 AscReadPCIConfigWord(ASC_DVC_VAR *asc_dvc, ushort pci_config_offset)
 {
 	uchar lsb, msb;
@@ -10571,7 +10511,7 @@ AscReadPCIConfigWord(ASC_DVC_VAR *asc_dvc, ushort pci_config_offset)
 	return ((ushort)((msb << 8) | lsb));
 }
 
-static ushort __init AscInitGetConfig(ASC_DVC_VAR *asc_dvc)
+static ushort __devinit AscInitGetConfig(ASC_DVC_VAR *asc_dvc)
 {
 	ushort warn_code;
 	PortAddr iop_base;
@@ -10656,7 +10596,7 @@ static ushort __init AscInitGetConfig(ASC_DVC_VAR *asc_dvc)
 	return (warn_code);
 }
 
-static ushort __init AscInitSetConfig(ASC_DVC_VAR *asc_dvc)
+static ushort __devinit AscInitSetConfig(ASC_DVC_VAR *asc_dvc)
 {
 	ushort warn_code = 0;
 
@@ -10672,7 +10612,7 @@ static ushort __init AscInitSetConfig(ASC_DVC_VAR *asc_dvc)
 	return (warn_code);
 }
 
-static ushort __init AscInitFromAscDvcVar(ASC_DVC_VAR *asc_dvc)
+static ushort __devinit AscInitFromAscDvcVar(ASC_DVC_VAR *asc_dvc)
 {
 	PortAddr iop_base;
 	ushort cfg_msw;
@@ -10773,7 +10713,7 @@ static ushort AscInitAsc1000Driver(ASC_DVC_VAR *asc_dvc)
 	return (warn_code);
 }
 
-static ushort __init AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
+static ushort __devinit AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 {
 	int i;
 	PortAddr iop_base;
@@ -10885,7 +10825,7 @@ static ushort __init AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 	return (warn_code);
 }
 
-static ushort __init AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
+static ushort __devinit AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
 {
 	ASCEEP_CONFIG eep_config_buf;
 	ASCEEP_CONFIG *eep_config;
@@ -11106,7 +11046,7 @@ static ushort AscInitMicroCodeVar(ASC_DVC_VAR *asc_dvc)
 	return (warn_code);
 }
 
-static int __init AscTestExternalLram(ASC_DVC_VAR *asc_dvc)
+static int __devinit AscTestExternalLram(ASC_DVC_VAR *asc_dvc)
 {
 	PortAddr iop_base;
 	ushort q_addr;
@@ -11128,7 +11068,7 @@ static int __init AscTestExternalLram(ASC_DVC_VAR *asc_dvc)
 	return (sta);
 }
 
-static int __init AscWriteEEPCmdReg(PortAddr iop_base, uchar cmd_reg)
+static int __devinit AscWriteEEPCmdReg(PortAddr iop_base, uchar cmd_reg)
 {
 	uchar read_back;
 	int retry;
@@ -11147,7 +11087,7 @@ static int __init AscWriteEEPCmdReg(PortAddr iop_base, uchar cmd_reg)
 	}
 }
 
-static int __init AscWriteEEPDataReg(PortAddr iop_base, ushort data_reg)
+static int __devinit AscWriteEEPDataReg(PortAddr iop_base, ushort data_reg)
 {
 	ushort read_back;
 	int retry;
@@ -11166,19 +11106,19 @@ static int __init AscWriteEEPDataReg(PortAddr iop_base, ushort data_reg)
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
@@ -11193,7 +11133,7 @@ static ushort __init AscReadEEPWord(PortAddr iop_base, uchar addr)
 	return (read_wval);
 }
 
-static ushort __init
+static ushort __devinit
 AscWriteEEPWord(PortAddr iop_base, uchar addr, ushort word_val)
 {
 	ushort read_wval;
@@ -11214,7 +11154,7 @@ AscWriteEEPWord(PortAddr iop_base, uchar addr, ushort word_val)
 	return (read_wval);
 }
 
-static ushort __init
+static ushort __devinit
 AscGetEEPConfig(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort bus_type)
 {
 	ushort wval;
@@ -11261,7 +11201,7 @@ AscGetEEPConfig(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort bus_type)
 	return (sum);
 }
 
-static int __init
+static int __devinit
 AscSetEEPConfigOnce(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort bus_type)
 {
 	int n_error;
@@ -11357,7 +11297,7 @@ AscSetEEPConfigOnce(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort bus_type)
 	return (n_error);
 }
 
-static int __init
+static int __devinit
 AscSetEEPConfig(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort bus_type)
 {
 	int retry;
@@ -13769,7 +13709,7 @@ static ADV_DCNT _adv_asc38C1600_chksum = 0x0604EF77UL;	/* Expanded little-endian
  * on big-endian platforms so char fields read as words are actually being
  * unswapped on big-endian platforms.
  */
-static ADVEEP_3550_CONFIG Default_3550_EEPROM_Config __initdata = {
+static ADVEEP_3550_CONFIG Default_3550_EEPROM_Config __devinitdata = {
 	ADV_EEPROM_BIOS_ENABLE,	/* cfg_lsw */
 	0x0000,			/* cfg_msw */
 	0xFFFF,			/* disc_enable */
@@ -13807,7 +13747,7 @@ static ADVEEP_3550_CONFIG Default_3550_EEPROM_Config __initdata = {
 	0			/* num_of_err */
 };
 
-static ADVEEP_3550_CONFIG ADVEEP_3550_Config_Field_IsChar __initdata = {
+static ADVEEP_3550_CONFIG ADVEEP_3550_Config_Field_IsChar __devinitdata = {
 	0,			/* cfg_lsw */
 	0,			/* cfg_msw */
 	0,			/* -disc_enable */
@@ -13845,7 +13785,7 @@ static ADVEEP_3550_CONFIG ADVEEP_3550_Config_Field_IsChar __initdata = {
 	0			/* num_of_err */
 };
 
-static ADVEEP_38C0800_CONFIG Default_38C0800_EEPROM_Config __initdata = {
+static ADVEEP_38C0800_CONFIG Default_38C0800_EEPROM_Config __devinitdata = {
 	ADV_EEPROM_BIOS_ENABLE,	/* 00 cfg_lsw */
 	0x0000,			/* 01 cfg_msw */
 	0xFFFF,			/* 02 disc_enable */
@@ -13910,7 +13850,7 @@ static ADVEEP_38C0800_CONFIG Default_38C0800_EEPROM_Config __initdata = {
 	0			/* 63 reserved */
 };
 
-static ADVEEP_38C0800_CONFIG ADVEEP_38C0800_Config_Field_IsChar __initdata = {
+static ADVEEP_38C0800_CONFIG ADVEEP_38C0800_Config_Field_IsChar __devinitdata = {
 	0,			/* 00 cfg_lsw */
 	0,			/* 01 cfg_msw */
 	0,			/* 02 disc_enable */
@@ -13975,7 +13915,7 @@ static ADVEEP_38C0800_CONFIG ADVEEP_38C0800_Config_Field_IsChar __initdata = {
 	0			/* 63 reserved */
 };
 
-static ADVEEP_38C1600_CONFIG Default_38C1600_EEPROM_Config __initdata = {
+static ADVEEP_38C1600_CONFIG Default_38C1600_EEPROM_Config __devinitdata = {
 	ADV_EEPROM_BIOS_ENABLE,	/* 00 cfg_lsw */
 	0x0000,			/* 01 cfg_msw */
 	0xFFFF,			/* 02 disc_enable */
@@ -14040,7 +13980,7 @@ static ADVEEP_38C1600_CONFIG Default_38C1600_EEPROM_Config __initdata = {
 	0			/* 63 reserved */
 };
 
-static ADVEEP_38C1600_CONFIG ADVEEP_38C1600_Config_Field_IsChar __initdata = {
+static ADVEEP_38C1600_CONFIG ADVEEP_38C1600_Config_Field_IsChar __devinitdata = {
 	0,			/* 00 cfg_lsw */
 	0,			/* 01 cfg_msw */
 	0,			/* 02 disc_enable */
@@ -14113,7 +14053,7 @@ static ADVEEP_38C1600_CONFIG ADVEEP_38C1600_Config_Field_IsChar __initdata = {
  * For a non-fatal error return a warning code. If there are no warnings
  * then 0 is returned.
  */
-static int __init AdvInitGetConfig(ADV_DVC_VAR *asc_dvc)
+static int __devinit AdvInitGetConfig(ADV_DVC_VAR *asc_dvc)
 {
 	ushort warn_code;
 	AdvPortAddr iop_base;
@@ -16057,7 +15997,7 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
  *
  * Note: Chip is stopped on entry.
  */
-static int __init AdvInitFrom3550EEP(ADV_DVC_VAR *asc_dvc)
+static int __devinit AdvInitFrom3550EEP(ADV_DVC_VAR *asc_dvc)
 {
 	AdvPortAddr iop_base;
 	ushort warn_code;
@@ -16211,7 +16151,7 @@ static int __init AdvInitFrom3550EEP(ADV_DVC_VAR *asc_dvc)
  *
  * Note: Chip is stopped on entry.
  */
-static int __init AdvInitFrom38C0800EEP(ADV_DVC_VAR *asc_dvc)
+static int __devinit AdvInitFrom38C0800EEP(ADV_DVC_VAR *asc_dvc)
 {
 	AdvPortAddr iop_base;
 	ushort warn_code;
@@ -16414,7 +16354,7 @@ static int __init AdvInitFrom38C0800EEP(ADV_DVC_VAR *asc_dvc)
  *
  * Note: Chip is stopped on entry.
  */
-static int __init AdvInitFrom38C1600EEP(ADV_DVC_VAR *asc_dvc)
+static int __devinit AdvInitFrom38C1600EEP(ADV_DVC_VAR *asc_dvc)
 {
 	AdvPortAddr iop_base;
 	ushort warn_code;
@@ -16655,7 +16595,7 @@ static int __init AdvInitFrom38C1600EEP(ADV_DVC_VAR *asc_dvc)
  *
  * Return a checksum based on the EEPROM configuration read.
  */
-static ushort __init
+static ushort __devinit
 AdvGet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
 {
 	ushort wval, chksum;
@@ -16698,7 +16638,7 @@ AdvGet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
  *
  * Return a checksum based on the EEPROM configuration read.
  */
-static ushort __init
+static ushort __devinit
 AdvGet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cfg_buf)
 {
 	ushort wval, chksum;
@@ -16741,7 +16681,7 @@ AdvGet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cfg_buf)
  *
  * Return a checksum based on the EEPROM configuration read.
  */
-static ushort __init
+static ushort __devinit
 AdvGet38C1600EEPConfig(AdvPortAddr iop_base, ADVEEP_38C1600_CONFIG *cfg_buf)
 {
 	ushort wval, chksum;
@@ -16782,7 +16722,7 @@ AdvGet38C1600EEPConfig(AdvPortAddr iop_base, ADVEEP_38C1600_CONFIG *cfg_buf)
 /*
  * Read the EEPROM from specified location
  */
-static ushort __init AdvReadEEPWord(AdvPortAddr iop_base, int eep_word_addr)
+static ushort __devinit AdvReadEEPWord(AdvPortAddr iop_base, int eep_word_addr)
 {
 	AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
 			     ASC_EEP_CMD_READ | eep_word_addr);
@@ -16793,7 +16733,7 @@ static ushort __init AdvReadEEPWord(AdvPortAddr iop_base, int eep_word_addr)
 /*
  * Wait for EEPROM command to complete
  */
-static void __init AdvWaitEEPCmd(AdvPortAddr iop_base)
+static void __devinit AdvWaitEEPCmd(AdvPortAddr iop_base)
 {
 	int eep_delay_ms;
 
@@ -16814,7 +16754,7 @@ static void __init AdvWaitEEPCmd(AdvPortAddr iop_base)
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void __init
+void __devinit
 AdvSet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
 {
 	ushort *wbuf;
@@ -16882,7 +16822,7 @@ AdvSet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void __init
+void __devinit
 AdvSet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cfg_buf)
 {
 	ushort *wbuf;
@@ -16950,7 +16890,7 @@ AdvSet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cfg_buf)
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void __init
+void __devinit
 AdvSet38C1600EEPConfig(AdvPortAddr iop_base, ADVEEP_38C1600_CONFIG *cfg_buf)
 {
 	ushort *wbuf;
@@ -17838,13 +17778,10 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	if (!shost)
 		return NULL;
 
-	/* Save a pointer to the Scsi_Host of each board found. */
-	asc_host[asc_board_count++] = shost;
-
 	/* Initialize private per board data */
 	boardp = ASC_BOARDP(shost);
 	memset(boardp, 0, sizeof(asc_board_t));
-	boardp->id = asc_board_count - 1;
+	boardp->id = asc_board_count++;
 
 	/* Initialize spinlock. */
 	spin_lock_init(&boardp->lock);
@@ -18518,7 +18455,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		iounmap(boardp->ioremap_addr);
  err_shost:
 	scsi_host_put(shost);
-	asc_board_count--;
 	return NULL;
 }
 
@@ -18540,27 +18476,11 @@ static int __init advansys_detect(void)
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
+	struct Scsi_Host *shost;
 
 	ASC_DBG(1, "advansys_detect: begin\n");
 
-	asc_board_count = 0;
+	asc_legacy_count = 0;
 
 	/*
 	 * If I/O port probing has been modified, then verify and
@@ -18595,10 +18515,10 @@ static int __init advansys_detect(void)
 			 bus, asc_bus_name[bus]);
 		iop = 0;
 
-		while (asc_board_count < ASC_NUM_BOARD_SUPPORTED) {
+		while (asc_legacy_count < ASC_NUM_BOARD_SUPPORTED) {
 
-			ASC_DBG1(2, "advansys_detect: asc_board_count %d\n",
-				 asc_board_count);
+			ASC_DBG1(2, "advansys_detect: asc_legacy_count %d\n",
+				 asc_legacy_count);
 
 			switch (asc_bus[bus]) {
 			case ASC_IS_ISA:
@@ -18693,97 +18613,6 @@ static int __init advansys_detect(void)
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
@@ -18795,17 +18624,19 @@ static int __init advansys_detect(void)
 			/*
 			 * Adapter not found, try next bus type.
 			 */
-			if (iop == 0) {
+			if (iop == 0)
 				break;
-			}
 
-			advansys_board_found(iop, dev, asc_bus[bus]);
+			shost = advansys_board_found(iop, NULL, asc_bus[bus]);
+			if (shost) {
+				asc_host[asc_legacy_count++] = shost;
+			}
 		}
 	}
 
-	ASC_DBG1(1, "advansys_detect: done: asc_board_count %d\n",
-		 asc_board_count);
-	return asc_board_count;
+	ASC_DBG1(1, "advansys_detect: done: asc_legacy_count %d\n",
+		 asc_legacy_count);
+	return asc_legacy_count;
 }
 
 /*
@@ -18836,7 +18667,6 @@ static int advansys_release(struct Scsi_Host *shost)
 	return 0;
 }
 
-#ifdef CONFIG_PCI
 /* PCI Devices supported by this driver */
 static struct pci_device_id advansys_pci_tbl[] __devinitdata = {
 	{PCI_VENDOR_ID_ASP, PCI_DEVICE_ID_ASP_1200A,
@@ -18855,23 +18685,73 @@ static struct pci_device_id advansys_pci_tbl[] __devinitdata = {
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
+	if (pci_resource_len(pdev, 0) == 0)
+		goto nodev;
+
+	ioport = pci_resource_start(pdev, 0);
+	shost = advansys_board_found(ioport, &pdev->dev, ASC_IS_PCI);
+
+	if (!shost)
+		goto nodev;
+
+	pci_set_drvdata(pdev, shost);
+	return 0;
+
+ nodev:
+	err = -ENODEV;
+	pci_disable_device(pdev);
+ fail:
+	return err;
+}
+
+static void __devexit advansys_pci_remove(struct pci_dev *pdev)
+{
+	advansys_release(pci_get_drvdata(pdev));
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
-	count = advansys_detect();
-	if (count == 0)
-		return -ENODEV;
+	int i, error;
+	advansys_detect();
+	error = pci_register_driver(&advansys_pci_driver);
+	if (error)
+		goto fail;
 
 	return 0;
+
+ fail:
+	for (i = 0; i < asc_legacy_count; i++)
+		advansys_release(asc_host[i]);
+
+	return error;
 }
 
 static void __exit advansys_exit(void)
 {
 	int i;
 
-	for (i = 0; i < asc_board_count; i++)
+	pci_unregister_driver(&advansys_pci_driver);
+
+	for (i = 0; i < asc_legacy_count; i++)
 		advansys_release(asc_host[i]);
 }
 
-- 
1.4.4.4

