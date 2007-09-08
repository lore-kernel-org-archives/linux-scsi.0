From: Andi Kleen <andi@firstfloor.org>
Subject: Re: sata & scsi suggestion for make menuconfig
Date: 08 Sep 2007 18:07:00 +0200
Message-ID: <p73fy1p9m57.fsf@bingen.suse.de>
References: <20070907124800.GP16806@vanheusden.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:46507 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbXIHQHC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Sep 2007 12:07:02 -0400
In-Reply-To: <20070907124800.GP16806@vanheusden.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Folkert van Heusden <folkert@vanheusden.com> writes:

> Hi,
> 
> Maybe it is a nice enhancement for make menuconfig to more explicitly
> give a pop-up or so when someone selects for example a sata controller
> while no 'scsi-disk' support was selected?

This has also bitten me one or two times. A reasonable way would
be to just select SD automatically for !EMBEDDED

Here's a patch:

-Andi

Select BLK_DEV_SD for all SCSI/libata drivers

This avoid a common user mistake.


Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6.23-rc1-misc/drivers/ata/Kconfig
===================================================================
--- linux-2.6.23-rc1-misc.orig/drivers/ata/Kconfig
+++ linux-2.6.23-rc1-misc/drivers/ata/Kconfig
@@ -42,6 +42,7 @@ config ATA_ACPI
 
 config SATA_AHCI
 	tristate "AHCI SATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for AHCI Serial ATA.
@@ -50,6 +51,7 @@ config SATA_AHCI
 
 config SATA_SVW
 	tristate "ServerWorks Frodo / Apple K2 SATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for Broadcom/Serverworks/Apple K2
@@ -59,6 +61,7 @@ config SATA_SVW
 
 config ATA_PIIX
 	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for ICH5/6/7/8 Serial ATA
@@ -69,6 +72,7 @@ config ATA_PIIX
 
 config SATA_MV
 	tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the Marvell Serial ATA family.
@@ -78,6 +82,7 @@ config SATA_MV
 
 config SATA_NV
 	tristate "NVIDIA SATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for NVIDIA Serial ATA.
@@ -86,6 +91,7 @@ config SATA_NV
 
 config PDC_ADMA
 	tristate "Pacific Digital ADMA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for Pacific Digital ADMA controllers
@@ -94,6 +100,7 @@ config PDC_ADMA
 
 config SATA_QSTOR
 	tristate "Pacific Digital SATA QStor support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for Pacific Digital Serial ATA QStor.
@@ -102,6 +109,7 @@ config SATA_QSTOR
 
 config SATA_PROMISE
 	tristate "Promise SATA TX2/TX4 support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for Promise Serial ATA TX2/TX4.
@@ -110,6 +118,7 @@ config SATA_PROMISE
 
 config SATA_SX4
 	tristate "Promise SATA SX4 support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for Promise Serial ATA SX4.
@@ -118,6 +127,7 @@ config SATA_SX4
 
 config SATA_SIL
 	tristate "Silicon Image SATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for Silicon Image Serial ATA.
@@ -126,6 +136,7 @@ config SATA_SIL
 
 config SATA_SIL24
 	tristate "Silicon Image 3124/3132 SATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for Silicon Image 3124/3132 Serial ATA.
@@ -134,6 +145,7 @@ config SATA_SIL24
 
 config SATA_SIS
 	tristate "SiS 964/965/966/180 SATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	select PATA_SIS
 	help
@@ -145,6 +157,7 @@ config SATA_SIS
 
 config SATA_ULI
 	tristate "ULi Electronics SATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for ULi Electronics SATA.
@@ -153,6 +166,7 @@ config SATA_ULI
 
 config SATA_VIA
 	tristate "VIA SATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for VIA Serial ATA.
@@ -161,6 +175,7 @@ config SATA_VIA
 
 config SATA_VITESSE
 	tristate "VITESSE VSC-7174 / INTEL 31244 SATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for Vitesse VSC7174 and Intel 31244 Serial ATA.
@@ -169,12 +184,14 @@ config SATA_VITESSE
 
 config SATA_INIC162X
 	tristate "Initio 162x SATA support (HIGHLY EXPERIMENTAL)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for Initio 162x Serial ATA.
 
 config PATA_ALI
 	tristate "ALi PATA support (Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the ALi ATA interfaces
@@ -184,6 +201,7 @@ config PATA_ALI
 
 config PATA_AMD
 	tristate "AMD/NVidia PATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for the AMD and NVidia PATA
@@ -193,6 +211,7 @@ config PATA_AMD
 
 config PATA_ARTOP
 	tristate "ARTOP 6210/6260 PATA support (Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for ARTOP PATA controllers.
@@ -201,6 +220,7 @@ config PATA_ARTOP
 
 config PATA_ATIIXP
 	tristate "ATI PATA support (Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the ATI ATA interfaces
@@ -210,6 +230,7 @@ config PATA_ATIIXP
 
 config PATA_CMD640_PCI
 	tristate "CMD640 PCI PATA support (Very Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the CMD640 PCI IDE
@@ -220,6 +241,7 @@ config PATA_CMD640_PCI
 
 config PATA_CMD64X
 	tristate "CMD64x PATA support (Very Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI&& EXPERIMENTAL
 	help
 	  This option enables support for the CMD64x series chips
@@ -229,6 +251,7 @@ config PATA_CMD64X
 
 config PATA_CS5520
 	tristate "CS5510/5520 PATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for the Cyrix 5510/5520
@@ -238,6 +261,7 @@ config PATA_CS5520
 
 config PATA_CS5530
 	tristate "CS5530 PATA support (Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the Cyrix/NatSemi/AMD CS5530
@@ -247,6 +271,7 @@ config PATA_CS5530
 
 config PATA_CS5535
 	tristate "CS5535 PATA support (Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && X86 && !X86_64 && EXPERIMENTAL
 	help
 	  This option enables support for the NatSemi/AMD CS5535
@@ -256,6 +281,7 @@ config PATA_CS5535
 
 config PATA_CYPRESS
 	tristate "Cypress CY82C693 PATA support (Very Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the Cypress/Contaq CY82C693
@@ -265,6 +291,7 @@ config PATA_CYPRESS
 
 config PATA_EFAR
 	tristate "EFAR SLC90E66 support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for the EFAR SLC90E66
@@ -274,6 +301,7 @@ config PATA_EFAR
 
 config ATA_GENERIC
 	tristate "Generic ATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for generic BIOS configured
@@ -283,6 +311,7 @@ config ATA_GENERIC
 
 config PATA_HPT366
 	tristate "HPT 366/368 PATA support (Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the HPT 366 and 368
@@ -292,6 +321,7 @@ config PATA_HPT366
 
 config PATA_HPT37X
 	tristate "HPT 370/370A/371/372/374/302 PATA support (Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the majority of the later HPT
@@ -301,6 +331,7 @@ config PATA_HPT37X
 
 config PATA_HPT3X2N
 	tristate "HPT 372N/302N PATA support (Very Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the N variant HPT PATA
@@ -310,6 +341,7 @@ config PATA_HPT3X2N
 
 config PATA_HPT3X3
 	tristate "HPT 343/363 PATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for the HPT 343/363
@@ -327,6 +359,7 @@ config PATA_HPT3X3_DMA
 
 config PATA_ISAPNP
 	tristate "ISA Plug and Play PATA support (Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on EXPERIMENTAL && ISAPNP
 	help
 	  This option enables support for ISA plug & play ATA
@@ -336,6 +369,7 @@ config PATA_ISAPNP
 
 config PATA_IT821X
 	tristate "IT8211/2 PATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for the ITE 8211 and 8212
@@ -346,6 +380,7 @@ config PATA_IT821X
 
 config PATA_IT8213
 	tristate "IT8213 PATA support (Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the ITE 821 PATA
@@ -355,6 +390,7 @@ config PATA_IT8213
 
 config PATA_JMICRON
 	tristate "JMicron PATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  Enable support for the JMicron IDE controller, via the new
@@ -364,6 +400,7 @@ config PATA_JMICRON
 
 config PATA_LEGACY
 	tristate "Legacy ISA PATA support (Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ISA && EXPERIMENTAL
 	help
 	  This option enables support for ISA/VLB bus legacy PATA
@@ -373,6 +410,7 @@ config PATA_LEGACY
 
 config PATA_TRIFLEX
 	tristate "Compaq Triflex PATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  Enable support for the Compaq 'Triflex' IDE controller as found
@@ -382,6 +420,7 @@ config PATA_TRIFLEX
 
 config PATA_MARVELL
 	tristate "Marvell PATA support via legacy mode"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables limited support for the Marvell 88SE6145 ATA
@@ -391,6 +430,7 @@ config PATA_MARVELL
 
 config PATA_MPC52xx
 	tristate "Freescale MPC52xx SoC internal IDE"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PPC_MPC52xx
 	help
 	  This option enables support for integrated IDE controller
@@ -400,6 +440,7 @@ config PATA_MPC52xx
 
 config PATA_MPIIX
 	tristate "Intel PATA MPIIX support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for MPIIX PATA support.
@@ -408,6 +449,7 @@ config PATA_MPIIX
 
 config PATA_OLDPIIX
 	tristate "Intel PATA old PIIX support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for early PIIX PATA support.
@@ -416,6 +458,7 @@ config PATA_OLDPIIX
 
 config PATA_NETCELL
 	tristate "NETCELL Revolution RAID support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for the Netcell Revolution RAID
@@ -425,6 +468,7 @@ config PATA_NETCELL
 
 config PATA_NS87410
 	tristate "Nat Semi NS87410 PATA support (Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the National Semiconductor
@@ -434,6 +478,7 @@ config PATA_NS87410
 
 config PATA_OPTI
 	tristate "OPTI621/6215 PATA support (Very Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables full PIO support for the early Opti ATA
@@ -443,6 +488,7 @@ config PATA_OPTI
 
 config PATA_OPTIDMA
 	tristate "OPTI FireStar PATA support (Very Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables DMA/PIO support for the later OPTi
@@ -462,6 +508,7 @@ config PATA_PCMCIA
 
 config PATA_PDC_OLD
 	tristate "Older Promise PATA controller support (Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the Promise 20246, 20262, 20263,
@@ -471,12 +518,14 @@ config PATA_PDC_OLD
 
 config PATA_QDI
 	tristate "QDI VLB PATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ISA
 	help
 	  Support for QDI 6500 and 6580 PATA controllers on VESA local bus.
 
 config PATA_RADISYS
 	tristate "RADISYS 82600 PATA support (Very Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the RADISYS 82600
@@ -486,6 +535,7 @@ config PATA_RADISYS
 
 config PATA_RZ1000
 	tristate "PC Tech RZ1000 PATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables basic support for the PC Tech RZ1000/1
@@ -495,6 +545,7 @@ config PATA_RZ1000
 
 config PATA_SC1200
 	tristate "SC1200 PATA support (Very Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the NatSemi/AMD SC1200 SoC
@@ -504,6 +555,7 @@ config PATA_SC1200
 
 config PATA_SERVERWORKS
 	tristate "SERVERWORKS OSB4/CSB5/CSB6/HT1000 PATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for the Serverworks OSB4/CSB5/CSB6 and
@@ -513,6 +565,7 @@ config PATA_SERVERWORKS
 
 config PATA_PDC2027X
 	tristate "Promise PATA 2027x support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for Promise PATA pdc20268 to pdc20277 host adapters.
@@ -521,6 +574,7 @@ config PATA_PDC2027X
 
 config PATA_SIL680
 	tristate "CMD / Silicon Image 680 PATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for CMD / Silicon Image 680 PATA.
@@ -529,6 +583,7 @@ config PATA_SIL680
 
 config PATA_SIS
 	tristate "SiS PATA support (Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for SiS PATA controllers
@@ -537,6 +592,7 @@ config PATA_SIS
 
 config PATA_VIA
 	tristate "VIA PATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for the VIA PATA interfaces
@@ -546,6 +602,7 @@ config PATA_VIA
 
 config PATA_WINBOND
 	tristate "Winbond SL82C105 PATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	help
 	  This option enables support for SL82C105 PATA devices found in the
@@ -555,6 +612,7 @@ config PATA_WINBOND
 
 config PATA_WINBOND_VLB
 	tristate "Winbond W83759A VLB PATA support (Experimental)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ISA && EXPERIMENTAL
 	help
 	  Support for the Winbond W83759A controller on Vesa Local Bus
@@ -562,6 +620,7 @@ config PATA_WINBOND_VLB
 
 config PATA_PLATFORM
 	tristate "Generic platform device PATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on EMBEDDED || ARCH_RPC
 	help
 	  This option enables support for generic directly connected ATA
@@ -571,6 +630,7 @@ config PATA_PLATFORM
 
 config PATA_ICSIDE
 	tristate "Acorn ICS PATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ARM && ARCH_ACORN
 	help
 	  On Acorn systems, say Y here if you wish to use the ICS PATA
@@ -579,6 +639,7 @@ config PATA_ICSIDE
 
 config PATA_IXP4XX_CF
 	tristate "IXP4XX Compact Flash support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ARCH_IXP4XX
 	help
 	  This option enables support for a Compact Flash connected on
@@ -589,6 +650,7 @@ config PATA_IXP4XX_CF
 
 config PATA_SCC
 	tristate "Toshiba's Cell Reference Set IDE support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && PPC_CELLEB
 	help
 	  This option enables support for the built-in IDE controller on
Index: linux-2.6.23-rc1-misc/drivers/scsi/Kconfig
===================================================================
--- linux-2.6.23-rc1-misc.orig/drivers/scsi/Kconfig
+++ linux-2.6.23-rc1-misc/drivers/scsi/Kconfig
@@ -305,6 +305,7 @@ config ISCSI_TCP
 	select CRYPTO_MD5
 	select CRYPTO_CRC32C
 	select SCSI_ISCSI_ATTRS
+	select BLK_DEV_SD if !EMBEDDED
 	help
 	 The iSCSI Driver provides a host with the ability to access storage
 	 through an IP network. The driver uses the iSCSI protocol to transport
@@ -325,6 +326,7 @@ config ISCSI_TCP
 config SGIWD93_SCSI
 	tristate "SGI WD93C93 SCSI Driver"
 	depends on SGI_IP22 && SCSI
+	select BLK_DEV_SD if !EMBEDDED
   	help
 	  If you have a Western Digital WD93 SCSI controller on
 	  an SGI MIPS system, say Y.  Otherwise, say N.
@@ -332,16 +334,19 @@ config SGIWD93_SCSI
 config SCSI_DECNCR
 	tristate "DEC NCR53C94 Scsi Driver"
 	depends on MACH_DECSTATION && SCSI && TC
+	select BLK_DEV_SD if !EMBEDDED
 	help
 	  Say Y here to support the NCR53C94 SCSI controller chips on IOASIC
 	  based TURBOchannel DECstations and TURBOchannel PMAZ-A cards.
 
 config SCSI_DECSII
 	tristate "DEC SII Scsi Driver"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on MACH_DECSTATION && SCSI && 32BIT
 
 config BLK_DEV_3W_XXXX_RAID
 	tristate "3ware 5/6/7/8xxx ATA-RAID support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI
 	help
 	  3ware is the only hardware ATA-Raid product in Linux to date.
@@ -355,6 +360,7 @@ config BLK_DEV_3W_XXXX_RAID
 
 config SCSI_3W_9XXX
 	tristate "3ware 9xxx SATA-RAID support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI
 	help
 	  This driver supports the 9000 series 3ware SATA-RAID cards.
@@ -366,6 +372,7 @@ config SCSI_3W_9XXX
 
 config SCSI_7000FASST
 	tristate "7000FASST SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ISA && SCSI && ISA_DMA_API
 	help
 	  This driver supports the Western Digital 7000 SCSI host adapter
@@ -377,6 +384,7 @@ config SCSI_7000FASST
 
 config SCSI_ACARD
 	tristate "ACARD SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI
 	help
 	  This driver supports the ACARD SCSI host adapter.
@@ -387,6 +395,7 @@ config SCSI_ACARD
 config SCSI_AHA152X
 	tristate "Adaptec AHA152X/2825 support"
 	depends on ISA && SCSI && !64BIT
+	select BLK_DEV_SD if !EMBEDDED
 	select SCSI_SPI_ATTRS
 	---help---
 	  This is a driver for the AHA-1510, AHA-1520, AHA-1522, and AHA-2825
@@ -402,6 +411,7 @@ config SCSI_AHA152X
 
 config SCSI_AHA1542
 	tristate "Adaptec AHA1542 support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ISA && SCSI && ISA_DMA_API
 	---help---
 	  This is support for a SCSI host adapter.  It is explained in section
@@ -416,6 +426,7 @@ config SCSI_AHA1542
 
 config SCSI_AHA1740
 	tristate "Adaptec AHA1740 support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on EISA && SCSI
 	---help---
 	  This is support for a SCSI host adapter.  It is explained in section
@@ -429,6 +440,7 @@ config SCSI_AHA1740
 
 config SCSI_AACRAID
 	tristate "Adaptec AACRAID support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on SCSI && PCI
 	help
 	  This driver supports a variety of Dell, HP, Adaptec, IBM and
@@ -443,6 +455,7 @@ source "drivers/scsi/aic7xxx/Kconfig.aic
 
 config SCSI_AIC7XXX_OLD
 	tristate "Adaptec AIC7xxx support (old driver)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on (ISA || EISA || PCI ) && SCSI
 	help
 	  WARNING This driver is an older aic7xxx driver and is no longer
@@ -487,6 +500,7 @@ source "drivers/scsi/aic94xx/Kconfig"
 # All the I2O code and drivers do not seem to be 64bit safe.
 config SCSI_DPT_I2O
 	tristate "Adaptec I2O RAID support "
+	select BLK_DEV_SD if !EMBEDDED
 	depends on !64BIT && SCSI && PCI && VIRT_TO_BUS
 	help
 	  This driver supports all of Adaptec's I2O based RAID controllers as 
@@ -501,6 +515,7 @@ config SCSI_ADVANSYS
 	depends on SCSI
 	depends on ISA || EISA || PCI
 	depends on BROKEN || X86_32
+	select BLK_DEV_SD if !EMBEDDED
 	help
 	  This is a driver for all SCSI host adapters manufactured by
 	  AdvanSys. It is documented in the kernel source in
@@ -512,6 +527,7 @@ config SCSI_ADVANSYS
 config SCSI_IN2000
 	tristate "Always IN2000 SCSI support"
 	depends on ISA && SCSI
+	select BLK_DEV_SD if !EMBEDDED
 	help
 	  This is support for an ISA bus SCSI host adapter.  You'll find more
 	  information in <file:Documentation/scsi/in2000.txt>. If it doesn't work
@@ -524,6 +540,7 @@ config SCSI_IN2000
 config SCSI_ARCMSR
 	tristate "ARECA ARC11X0[PCI-X]/ARC12X0[PCI-EXPRESS] SATA-RAID support"
 	depends on PCI && SCSI
+	select BLK_DEV_SD if !EMBEDDED
 	help
 	  This driver supports all of ARECA's SATA RAID controller cards.
 	  This is an ARECA-maintained driver by Erich Chen.
@@ -540,6 +557,7 @@ source "drivers/scsi/megaraid/Kconfig.me
 config SCSI_HPTIOP
 	tristate "HighPoint RocketRAID 3xxx Controller support"
 	depends on SCSI && PCI
+	select BLK_DEV_SD if !EMBEDDED
 	help
 	  This option enables support for HighPoint RocketRAID 3xxx
 	  controllers.
@@ -549,6 +567,7 @@ config SCSI_HPTIOP
 
 config SCSI_BUSLOGIC
 	tristate "BusLogic SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on (PCI || ISA || MCA) && SCSI && ISA_DMA_API && VIRT_TO_BUS
 	---help---
 	  This is support for BusLogic MultiMaster and FlashPoint SCSI Host
@@ -563,6 +582,7 @@ config SCSI_BUSLOGIC
 config SCSI_OMIT_FLASHPOINT
 	bool "Omit FlashPoint support"
 	depends on SCSI_BUSLOGIC
+	select BLK_DEV_SD if !EMBEDDED
 	help
 	  This option allows you to omit the FlashPoint support from the
 	  BusLogic SCSI driver. The FlashPoint SCCB Manager code is
@@ -573,6 +593,7 @@ config SCSI_DMX3191D
 	tristate "DMX3191D SCSI support"
 	depends on PCI && SCSI
 	select SCSI_SPI_ATTRS
+	select BLK_DEV_SD if !EMBEDDED
 	help
 	  This is support for Domex DMX3191D SCSI Host Adapters.
 
@@ -583,6 +604,7 @@ config SCSI_DTC3280
 	tristate "DTC3180/3280 SCSI support"
 	depends on ISA && SCSI
 	select SCSI_SPI_ATTRS
+	select BLK_DEV_SD if !EMBEDDED
 	help
 	  This is support for DTC 3180/3280 SCSI Host Adapters.  Please read
 	  the SCSI-HOWTO, available from
@@ -595,6 +617,7 @@ config SCSI_DTC3280
 config SCSI_EATA
 	tristate "EATA ISA/EISA/PCI (DPT and generic EATA/DMA-compliant boards) support"
 	depends on (ISA || EISA || PCI) && SCSI && ISA_DMA_API
+	select BLK_DEV_SD if !EMBEDDED
 	---help---
 	  This driver supports all EATA/DMA-compliant SCSI host adapters.  DPT
 	  ISA and all EISA I/O addresses are probed looking for the "EATA"
@@ -656,6 +679,7 @@ config SCSI_EATA_PIO
 
 config SCSI_FUTURE_DOMAIN
 	tristate "Future Domain 16xx SCSI/AHA-2920A support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on (ISA || PCI) && SCSI
 	---help---
 	  This is support for Future Domain's 16-bit SCSI host adapters
@@ -675,6 +699,7 @@ config SCSI_FUTURE_DOMAIN
 
 config SCSI_FD_MCS
 	tristate "Future Domain MCS-600/700 SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on MCA_LEGACY && SCSI
 	---help---
 	  This is support for Future Domain MCS 600/700 MCA SCSI adapters.
@@ -688,6 +713,7 @@ config SCSI_FD_MCS
 
 config SCSI_GDTH
 	tristate "Intel/ICP (former GDT SCSI Disk Array) RAID Controller support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on (ISA || EISA || PCI) && SCSI && ISA_DMA_API
 	---help---
 	  Formerly called GDT SCSI Disk Array Controller Support.
@@ -702,6 +728,7 @@ config SCSI_GDTH
 
 config SCSI_GENERIC_NCR5380
 	tristate "Generic NCR5380/53c400 SCSI PIO support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ISA && SCSI
 	select SCSI_SPI_ATTRS
 	---help---
@@ -722,6 +749,7 @@ config SCSI_GENERIC_NCR5380
 
 config SCSI_GENERIC_NCR5380_MMIO
 	tristate "Generic NCR5380/53c400 SCSI MMIO support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ISA && SCSI
 	select SCSI_SPI_ATTRS
 	---help---
@@ -748,6 +776,7 @@ config SCSI_GENERIC_NCR53C400
 
 config SCSI_IBMMCA
 	tristate "IBMMCA SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on MCA && SCSI
 	---help---
 	  This is support for the IBM SCSI adapter found in many of the PS/2
@@ -818,6 +847,7 @@ config IBMMCA_SCSI_DEV_RESET
 
 config SCSI_IPS
 	tristate "IBM ServeRAID support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI
 	---help---
 	  This is support for the IBM ServeRAID hardware RAID controllers.
@@ -831,6 +861,7 @@ config SCSI_IPS
 
 config SCSI_IBMVSCSI
 	tristate "IBM Virtual SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PPC_PSERIES || PPC_ISERIES
 	help
 	  This is the IBM POWER Virtual SCSI Client
@@ -840,6 +871,7 @@ config SCSI_IBMVSCSI
 
 config SCSI_IBMVSCSIS
 	tristate "IBM Virtual SCSI Server support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PPC_PSERIES && SCSI_TGT && SCSI_SRP
 	help
 	  This is the SRP target driver for IBM pSeries virtual environments.
@@ -854,6 +886,7 @@ config SCSI_IBMVSCSIS
 
 config SCSI_INITIO
 	tristate "Initio 9100U(W) support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI
 	help
 	  This is support for the Initio 91XXU(W) SCSI host adapter.  Please
@@ -865,6 +898,7 @@ config SCSI_INITIO
 
 config SCSI_INIA100
 	tristate "Initio INI-A100U2W support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI
 	help
 	  This is support for the Initio INI-A100U2W SCSI host adapter.
@@ -876,6 +910,7 @@ config SCSI_INIA100
 
 config SCSI_PPA
 	tristate "IOMEGA parallel port (ppa - older drives)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on SCSI && PARPORT_PC
 	---help---
 	  This driver supports older versions of IOMEGA's parallel port ZIP
@@ -903,6 +938,7 @@ config SCSI_PPA
 
 config SCSI_IMM
 	tristate "IOMEGA parallel port (imm - newer drives)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on SCSI && PARPORT_PC
 	---help---
 	  This driver supports newer versions of IOMEGA's parallel port ZIP
@@ -959,6 +995,7 @@ config SCSI_IZIP_SLOW_CTR
 
 config SCSI_NCR53C406A
 	tristate "NCR53c406a SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ISA && SCSI
 	help
 	  This is support for the NCR53c406a SCSI host adapter.  For user
@@ -971,6 +1008,7 @@ config SCSI_NCR53C406A
 
 config SCSI_NCR_D700
 	tristate "NCR Dual 700 MCA SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on MCA && SCSI
 	select SCSI_SPI_ATTRS
 	help
@@ -983,6 +1021,7 @@ config SCSI_NCR_D700
 
 config SCSI_LASI700
 	tristate "HP Lasi SCSI support for 53c700/710"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on GSC && SCSI
 	select SCSI_SPI_ATTRS
 	help
@@ -992,6 +1031,7 @@ config SCSI_LASI700
 
 config SCSI_SNI_53C710
 	tristate "SNI RM SCSI support for 53c710"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on SNI_RM && SCSI
 	select SCSI_SPI_ATTRS
 	select 53C700_LE_ON_BE
@@ -1006,6 +1046,7 @@ config 53C700_LE_ON_BE
 
 config SCSI_STEX
 	tristate "Promise SuperTrak EX Series support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI
 	---help---
 	  This driver supports Promise SuperTrak EX series storage controllers.
@@ -1023,6 +1064,7 @@ config 53C700_BE_BUS
 
 config SCSI_SYM53C8XX_2
 	tristate "SYM53C8XX Version 2 SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI
 	select SCSI_SPI_ATTRS
 	---help---
@@ -1090,6 +1132,7 @@ config SCSI_SYM53C8XX_MMIO
 
 config SCSI_IPR
 	tristate "IBM Power Linux RAID adapter support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI && ATA
 	select FW_LOADER
 	---help---
@@ -1117,6 +1160,7 @@ config SCSI_IPR_DUMP
 
 config SCSI_ZALON
 	tristate "Zalon SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on GSC && SCSI
 	select SCSI_SPI_ATTRS
 	help
@@ -1128,6 +1172,7 @@ config SCSI_ZALON
 
 config SCSI_NCR_Q720
 	tristate "NCR Quad 720 MCA SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on MCA && SCSI
 	select SCSI_SPI_ATTRS
 	help
@@ -1227,6 +1272,7 @@ config SCSI_NCR53C8XX_NO_DISCONNECT
 
 config SCSI_MCA_53C9X
 	tristate "NCR MCA 53C9x SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on MCA_LEGACY && SCSI && BROKEN_ON_SMP
 	help
 	  Some MicroChannel machines, notably the NCR 35xx line, use a SCSI
@@ -1238,6 +1284,7 @@ config SCSI_MCA_53C9X
 
 config SCSI_PAS16
 	tristate "PAS16 SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ISA && SCSI
 	select SCSI_SPI_ATTRS
 	---help---
@@ -1263,6 +1310,7 @@ config SCSI_PSI240I
 
 config SCSI_QLOGIC_FAS
 	tristate "Qlogic FAS SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ISA && SCSI
 	---help---
 	  This is a driver for the ISA, VLB, and PCMCIA versions of the Qlogic
@@ -1291,6 +1339,7 @@ config SCSI_QLOGIC_FC_FIRMWARE
 
 config SCSI_QLOGIC_1280
 	tristate "Qlogic QLA 1240/1x80/1x160 SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI
 	help
 	  Say Y if you have a QLogic ISP1240/1x80/1x160 SCSI host adapter.
@@ -1300,6 +1349,7 @@ config SCSI_QLOGIC_1280
 
 config SCSI_QLOGICPTI
 	tristate "PTI Qlogic, ISP Driver"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on SBUS && SCSI
 	help
 	  This driver supports SBUS SCSI controllers from PTI or QLogic. These
@@ -1315,6 +1365,7 @@ source "drivers/scsi/qla4xxx/Kconfig"
 
 config SCSI_LPFC
 	tristate "Emulex LightPulse Fibre Channel Support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI
 	select SCSI_FC_ATTRS
 	help
@@ -1323,6 +1374,7 @@ config SCSI_LPFC
 
 config SCSI_SEAGATE
 	tristate "Seagate ST-02 and Future Domain TMC-8xx SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on X86 && ISA && SCSI
 	---help---
 	  These are 8-bit SCSI controllers; the ST-01 is also supported by
@@ -1337,6 +1389,7 @@ config SCSI_SEAGATE
 # definitely looks not 64bit safe:
 config SCSI_SIM710
 	tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on (EISA || MCA) && SCSI
 	select SCSI_SPI_ATTRS
 	---help---
@@ -1346,6 +1399,7 @@ config SCSI_SIM710
 
 config SCSI_SYM53C416
 	tristate "Symbios 53c416 SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ISA && SCSI
 	---help---
 	  This is support for the sym53c416 SCSI host adapter, the SCSI
@@ -1364,6 +1418,7 @@ config SCSI_SYM53C416
 
 config SCSI_DC395x
 	tristate "Tekram DC395(U/UW/F) and DC315(U) SCSI support (EXPERIMENTAL)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI && EXPERIMENTAL
 	---help---
 	  This driver supports PCI SCSI host adapters based on the ASIC
@@ -1379,6 +1434,7 @@ config SCSI_DC395x
 
 config SCSI_DC390T
 	tristate "Tekram DC390(T) and Am53/79C974 SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI
 	---help---
 	  This driver supports PCI SCSI host adapters based on the Am53C974A
@@ -1395,6 +1451,7 @@ config SCSI_DC390T
 
 config SCSI_T128
 	tristate "Trantor T128/T128F/T228 SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ISA && SCSI
 	select SCSI_SPI_ATTRS
 	---help---
@@ -1411,6 +1468,7 @@ config SCSI_T128
 
 config SCSI_U14_34F
 	tristate "UltraStor 14F/34F support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ISA && SCSI && ISA_DMA_API
 	---help---
 	  This is support for the UltraStor 14F and 34F SCSI-2 host adapters.
@@ -1460,6 +1518,7 @@ config SCSI_U14_34F_MAX_TAGS
 
 config SCSI_ULTRASTOR
 	tristate "UltraStor SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on X86 && ISA && SCSI
 	---help---
 	  This is support for the UltraStor 14F, 24F and 34F SCSI-2 host
@@ -1477,6 +1536,7 @@ config SCSI_ULTRASTOR
 
 config SCSI_NSP32
 	tristate "Workbit NinjaSCSI-32Bi/UDE support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI && !64BIT
 	help
 	  This is support for the Workbit NinjaSCSI-32Bi/UDE PCI/Cardbus
@@ -1501,6 +1561,7 @@ config SCSI_DEBUG
 
 config SCSI_MESH
 	tristate "MESH (Power Mac internal SCSI) support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PPC32 && PPC_PMAC && SCSI
 	help
 	  Many Power Macintoshes and clones have a MESH (Macintosh Enhanced
@@ -1555,6 +1616,7 @@ config JAZZ_ESP
 
 config A3000_SCSI
 	tristate "A3000 WD33C93A support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on AMIGA && SCSI
 	help
 	  If you have an Amiga 3000 and have SCSI devices connected to the
@@ -1565,6 +1627,7 @@ config A3000_SCSI
 
 config A2091_SCSI
 	tristate "A2091/A590 WD33C93A support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ZORRO && SCSI
 	help
 	  If you have a Commodore A2091 SCSI controller, say Y. Otherwise,
@@ -1575,6 +1638,7 @@ config A2091_SCSI
 
 config GVP11_SCSI
 	tristate "GVP Series II WD33C93A support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ZORRO && SCSI
 	---help---
 	  If you have a Great Valley Products Series II SCSI controller,
@@ -1588,6 +1652,7 @@ config GVP11_SCSI
 
 config CYBERSTORM_SCSI
 	tristate "CyberStorm SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ZORRO && SCSI
 	help
 	  If you have an Amiga with an original (MkI) Phase5 Cyberstorm
@@ -1596,6 +1661,7 @@ config CYBERSTORM_SCSI
 
 config CYBERSTORMII_SCSI
 	tristate "CyberStorm Mk II SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ZORRO && SCSI
 	help
 	  If you have an Amiga with a Phase5 Cyberstorm MkII accelerator board
@@ -1604,6 +1670,7 @@ config CYBERSTORMII_SCSI
 
 config BLZ2060_SCSI
 	tristate "Blizzard 2060 SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ZORRO && SCSI
 	help
 	  If you have an Amiga with a Phase5 Blizzard 2060 accelerator board
@@ -1612,6 +1679,7 @@ config BLZ2060_SCSI
 
 config BLZ1230_SCSI
 	tristate "Blizzard 1230IV/1260 SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ZORRO && SCSI
 	help
 	  If you have an Amiga 1200 with a Phase5 Blizzard 1230IV or Blizzard
@@ -1620,6 +1688,7 @@ config BLZ1230_SCSI
 
 config FASTLANE_SCSI
 	tristate "Fastlane SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ZORRO && SCSI
 	help
 	  If you have the Phase5 Fastlane Z3 SCSI controller, or plan to use
@@ -1627,6 +1696,7 @@ config FASTLANE_SCSI
 
 config SCSI_A4000T
 	tristate "A4000T NCR53c710 SCSI support (EXPERIMENTAL)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on AMIGA && SCSI && EXPERIMENTAL
 	select SCSI_SPI_ATTRS
 	help
@@ -1638,6 +1708,7 @@ config SCSI_A4000T
 
 config SCSI_ZORRO7XX
 	tristate "Zorro NCR53c710 SCSI support (EXPERIMENTAL)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ZORRO && SCSI && EXPERIMENTAL
 	select SCSI_SPI_ATTRS
 	help
@@ -1654,6 +1725,7 @@ config SCSI_ZORRO7XX
 
 config OKTAGON_SCSI
 	tristate "BSC Oktagon SCSI support (EXPERIMENTAL)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ZORRO && SCSI && EXPERIMENTAL
 	help
 	  If you have the BSC Oktagon SCSI disk controller for the Amiga, say
@@ -1663,6 +1735,7 @@ config OKTAGON_SCSI
 
 config ATARI_SCSI
 	tristate "Atari native SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ATARI && SCSI
 	select SCSI_SPI_ATTRS
 	---help---
@@ -1715,6 +1788,7 @@ config MAC_SCSI
 
 config SCSI_MAC_ESP
 	tristate "Macintosh NCR53c9[46] SCSI"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on MAC && SCSI
 	help
 	  This is the NCR 53c9x SCSI controller found on most of the 68040
@@ -1735,6 +1809,7 @@ config MVME147_SCSI
 
 config MVME16x_SCSI
 	tristate "NCR53C710 SCSI driver for MVME16x"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on MVME16x && SCSI
 	select SCSI_SPI_ATTRS
 	help
@@ -1744,6 +1819,7 @@ config MVME16x_SCSI
 
 config BVME6000_SCSI
 	tristate "NCR53C710 SCSI driver for BVME6000"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on BVME6000 && SCSI
 	select SCSI_SPI_ATTRS
 	help
@@ -1753,6 +1829,7 @@ config BVME6000_SCSI
 
 config SUN3_SCSI
 	tristate "Sun3 NCR5380 SCSI"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on SUN3 && SCSI
 	select SCSI_SPI_ATTRS
 	help
@@ -1771,6 +1848,7 @@ config SUN3X_ESP
 
 config SCSI_SUNESP
 	tristate "Sparc ESP Scsi Driver"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on SBUS && SCSI
 	select SCSI_SPI_ATTRS
 	help
@@ -1782,6 +1860,7 @@ config SCSI_SUNESP
 
 config ZFCP
 	tristate "FCP host bus adapter driver for IBM eServer zSeries"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on S390 && QDIO && SCSI
 	select SCSI_FC_ATTRS
 	help
@@ -1796,6 +1875,7 @@ config ZFCP
 
 config SCSI_SRP
 	tristate "SCSI RDMA Protocol helper library"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on SCSI && PCI
 	select SCSI_TGT
 	help
Index: linux-2.6.23-rc1-misc/drivers/scsi/aic7xxx/Kconfig.aic79xx
===================================================================
--- linux-2.6.23-rc1-misc.orig/drivers/scsi/aic7xxx/Kconfig.aic79xx
+++ linux-2.6.23-rc1-misc/drivers/scsi/aic7xxx/Kconfig.aic79xx
@@ -4,6 +4,7 @@
 #
 config SCSI_AIC79XX
 	tristate "Adaptec AIC79xx U320 support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI
 	select SCSI_SPI_ATTRS
 	help
Index: linux-2.6.23-rc1-misc/drivers/scsi/aic7xxx/Kconfig.aic7xxx
===================================================================
--- linux-2.6.23-rc1-misc.orig/drivers/scsi/aic7xxx/Kconfig.aic7xxx
+++ linux-2.6.23-rc1-misc/drivers/scsi/aic7xxx/Kconfig.aic7xxx
@@ -4,6 +4,7 @@
 #
 config SCSI_AIC7XXX
 	tristate "Adaptec AIC7xxx Fast -> U160 support (New Driver)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on (PCI || EISA) && SCSI
 	select SCSI_SPI_ATTRS
 	---help---
Index: linux-2.6.23-rc1-misc/drivers/scsi/aic94xx/Kconfig
===================================================================
--- linux-2.6.23-rc1-misc.orig/drivers/scsi/aic94xx/Kconfig
+++ linux-2.6.23-rc1-misc/drivers/scsi/aic94xx/Kconfig
@@ -26,6 +26,7 @@
 
 config SCSI_AIC94XX
 	tristate "Adaptec AIC94xx SAS/SATA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI
 	select SCSI_SAS_LIBSAS
 	select FW_LOADER
Index: linux-2.6.23-rc1-misc/drivers/scsi/arm/Kconfig
===================================================================
--- linux-2.6.23-rc1-misc.orig/drivers/scsi/arm/Kconfig
+++ linux-2.6.23-rc1-misc/drivers/scsi/arm/Kconfig
@@ -3,6 +3,7 @@
 #
 config SCSI_ACORNSCSI_3
 	tristate "Acorn SCSI card (aka30) support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ARCH_ACORN && SCSI && BROKEN
 	select SCSI_SPI_ATTRS
 	help
@@ -32,6 +33,7 @@ config SCSI_ACORNSCSI_SYNC
 
 config SCSI_ARXESCSI
 	tristate "ARXE SCSI support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ARCH_ACORN && SCSI
 	help
 	  Around 1991, Arxe Systems Limited released a high density floppy
@@ -44,6 +46,7 @@ config SCSI_ARXESCSI
 
 config SCSI_CUMANA_2
 	tristate "CumanaSCSI II support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ARCH_ACORN && SCSI
 	help
 	  This enables support for the Cumana SCSI II card. If you have an
@@ -51,6 +54,7 @@ config SCSI_CUMANA_2
 
 config SCSI_EESOXSCSI
 	tristate "EESOX support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ARCH_ACORN && SCSI
 	help
 	  This enables support for the EESOX SCSI card. If you have an Acorn
@@ -58,6 +62,7 @@ config SCSI_EESOXSCSI
 
 config SCSI_POWERTECSCSI
 	tristate "PowerTec support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ARCH_ACORN && SCSI
 	help
 	  This enables support for the Powertec SCSI card on Acorn systems. If
@@ -68,6 +73,7 @@ comment "The following drivers are not f
 
 config SCSI_CUMANA_1
 	tristate "CumanaSCSI I support (EXPERIMENTAL)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ARCH_ACORN && EXPERIMENTAL && SCSI
 	select SCSI_SPI_ATTRS
 	help
@@ -76,6 +82,7 @@ config SCSI_CUMANA_1
 
 config SCSI_ECOSCSI
 	tristate "EcoScsi support (EXPERIMENTAL)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on ARCH_ACORN && EXPERIMENTAL && (ARCH_ARC || ARCH_A5K) && SCSI
 	select SCSI_SPI_ATTRS
 	help
Index: linux-2.6.23-rc1-misc/drivers/scsi/megaraid/Kconfig.megaraid
===================================================================
--- linux-2.6.23-rc1-misc.orig/drivers/scsi/megaraid/Kconfig.megaraid
+++ linux-2.6.23-rc1-misc/drivers/scsi/megaraid/Kconfig.megaraid
@@ -6,6 +6,7 @@ config MEGARAID_NEWGEN
 
 config MEGARAID_MM
 	tristate "LSI Logic Management Module (New Driver)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI && MEGARAID_NEWGEN
 	help
 	Management Module provides ioctl, sysfs support for LSI Logic
@@ -16,6 +17,7 @@ config MEGARAID_MM
 
 config MEGARAID_MAILBOX
 	tristate "LSI Logic MegaRAID Driver (New Driver)"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI && MEGARAID_MM
 	help
 	List of supported controllers
@@ -77,6 +79,7 @@ config MEGARAID_LEGACY
 
 config MEGARAID_SAS
 	tristate "LSI Logic MegaRAID SAS RAID Module"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI
 	help
 	Module for LSI Logic's SAS based RAID controllers.
Index: linux-2.6.23-rc1-misc/drivers/scsi/pcmcia/Kconfig
===================================================================
--- linux-2.6.23-rc1-misc.orig/drivers/scsi/pcmcia/Kconfig
+++ linux-2.6.23-rc1-misc/drivers/scsi/pcmcia/Kconfig
@@ -10,6 +10,7 @@ if SCSI_LOWLEVEL_PCMCIA && SCSI && PCMCI
 
 config PCMCIA_AHA152X
 	tristate "Adaptec AHA152X PCMCIA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on !64BIT
 	select SCSI_SPI_ATTRS
 	help
@@ -21,6 +22,7 @@ config PCMCIA_AHA152X
 
 config PCMCIA_FDOMAIN
 	tristate "Future Domain PCMCIA support"
+	select BLK_DEV_SD if !EMBEDDED
 	help
 	  Say Y here if you intend to attach this type of PCMCIA SCSI host
 	  adapter to your computer.
@@ -30,6 +32,7 @@ config PCMCIA_FDOMAIN
 
 config PCMCIA_NINJA_SCSI
 	tristate "NinjaSCSI-3 / NinjaSCSI-32Bi (16bit) PCMCIA support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on !64BIT
 	help
 	  If you intend to attach this type of PCMCIA SCSI host adapter to
@@ -64,6 +67,7 @@ config PCMCIA_NINJA_SCSI
 
 config PCMCIA_QLOGIC
 	tristate "Qlogic PCMCIA support"
+	select BLK_DEV_SD if !EMBEDDED
 	help
 	  Say Y here if you intend to attach this type of PCMCIA SCSI host
 	  adapter to your computer.
@@ -73,6 +77,7 @@ config PCMCIA_QLOGIC
 
 config PCMCIA_SYM53C500
 	tristate "Symbios 53c500 PCMCIA support"
+	select BLK_DEV_SD if !EMBEDDED
 	help
 	  Say Y here if you have a New Media Bus Toaster or other PCMCIA
 	  SCSI adapter based on the Symbios 53c500 controller.
Index: linux-2.6.23-rc1-misc/drivers/scsi/qla2xxx/Kconfig
===================================================================
--- linux-2.6.23-rc1-misc.orig/drivers/scsi/qla2xxx/Kconfig
+++ linux-2.6.23-rc1-misc/drivers/scsi/qla2xxx/Kconfig
@@ -1,5 +1,6 @@
 config SCSI_QLA_FC
 	tristate "QLogic QLA2XXX Fibre Channel Support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI
 	select SCSI_FC_ATTRS
 	select FW_LOADER
Index: linux-2.6.23-rc1-misc/drivers/scsi/qla4xxx/Kconfig
===================================================================
--- linux-2.6.23-rc1-misc.orig/drivers/scsi/qla4xxx/Kconfig
+++ linux-2.6.23-rc1-misc/drivers/scsi/qla4xxx/Kconfig
@@ -1,5 +1,6 @@
 config SCSI_QLA_ISCSI
 	tristate "QLogic ISP4XXX host adapter family support"
+	select BLK_DEV_SD if !EMBEDDED
 	depends on PCI && SCSI && NET
 	select SCSI_ISCSI_ATTRS
 	---help---
