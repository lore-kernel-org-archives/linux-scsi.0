From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 29/30] Use menuconfig objects - SCSI
Date: Tue, 10 Apr 2007 23:42:45 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704102342050.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tmailer.gwdg.de ([134.76.10.23]:58036 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669AbXDJVne (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Apr 2007 17:43:34 -0400
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org


Use menuconfigs instead of menus, so the whole menu can be disabled at        
once instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/drivers/scsi/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/scsi/Kconfig
+++ linux-2.6.21-rc5/drivers/scsi/Kconfig
@@ -279,12 +279,16 @@ source "drivers/scsi/libsas/Kconfig"
 
 endmenu
 
-menu "SCSI low-level drivers"
+menuconfig SCSI_LOWLEVEL
+	bool "SCSI low-level drivers"
 	depends on SCSI!=n
+	default y
+
+if SCSI_LOWLEVEL
 
 config ISCSI_TCP
 	tristate "iSCSI Initiator over TCP/IP"
-	depends on SCSI && INET
+	depends on INET
 	select CRYPTO
 	select CRYPTO_MD5
 	select CRYPTO_CRC32C
@@ -308,25 +312,25 @@ config ISCSI_TCP
 
 config SGIWD93_SCSI
 	tristate "SGI WD93C93 SCSI Driver"
-	depends on SGI_IP22 && SCSI
+	depends on SGI_IP22
   	help
 	  If you have a Western Digital WD93 SCSI controller on
 	  an SGI MIPS system, say Y.  Otherwise, say N.
 
 config SCSI_DECNCR
 	tristate "DEC NCR53C94 Scsi Driver"
-	depends on MACH_DECSTATION && SCSI && TC
+	depends on MACH_DECSTATION && TC
 	help
 	  Say Y here to support the NCR53C94 SCSI controller chips on IOASIC
 	  based TURBOchannel DECstations and TURBOchannel PMAZ-A cards.
 
 config SCSI_DECSII
 	tristate "DEC SII Scsi Driver"
-	depends on MACH_DECSTATION && SCSI && 32BIT
+	depends on MACH_DECSTATION && 32BIT
 
 config BLK_DEV_3W_XXXX_RAID
 	tristate "3ware 5/6/7/8xxx ATA-RAID support"
-	depends on PCI && SCSI
+	depends on PCI
 	help
 	  3ware is the only hardware ATA-Raid product in Linux to date.
 	  This card is 2,4, or 8 channel master mode support only.
@@ -339,7 +343,7 @@ config BLK_DEV_3W_XXXX_RAID
 
 config SCSI_3W_9XXX
 	tristate "3ware 9xxx SATA-RAID support"
-	depends on PCI && SCSI
+	depends on PCI
 	help
 	  This driver supports the 9000 series 3ware SATA-RAID cards.
 
@@ -350,7 +354,7 @@ config SCSI_3W_9XXX
 
 config SCSI_7000FASST
 	tristate "7000FASST SCSI support"
-	depends on ISA && SCSI && ISA_DMA_API
+	depends on ISA && ISA_DMA_API
 	help
 	  This driver supports the Western Digital 7000 SCSI host adapter
 	  family.  Some information is in the source:
@@ -361,7 +365,7 @@ config SCSI_7000FASST
 
 config SCSI_ACARD
 	tristate "ACARD SCSI support"
-	depends on PCI && SCSI
+	depends on PCI
 	help
 	  This driver supports the ACARD SCSI host adapter.
 	  Support Chip <ATP870 ATP876 ATP880 ATP885>
@@ -370,7 +374,7 @@ config SCSI_ACARD
 
 config SCSI_AHA152X
 	tristate "Adaptec AHA152X/2825 support"
-	depends on ISA && SCSI && !64BIT
+	depends on ISA && !64BIT
 	select SCSI_SPI_ATTRS
 	---help---
 	  This is a driver for the AHA-1510, AHA-1520, AHA-1522, and AHA-2825
@@ -386,7 +390,7 @@ config SCSI_AHA152X
 
 config SCSI_AHA1542
 	tristate "Adaptec AHA1542 support"
-	depends on ISA && SCSI && ISA_DMA_API
+	depends on ISA && ISA_DMA_API
 	---help---
 	  This is support for a SCSI host adapter.  It is explained in section
 	  3.4 of the SCSI-HOWTO, available from
@@ -400,7 +404,7 @@ config SCSI_AHA1542
 
 config SCSI_AHA1740
 	tristate "Adaptec AHA1740 support"
-	depends on EISA && SCSI
+	depends on EISA
 	---help---
 	  This is support for a SCSI host adapter.  It is explained in section
 	  3.5 of the SCSI-HOWTO, available from
@@ -413,7 +417,7 @@ config SCSI_AHA1740
 
 config SCSI_AACRAID
 	tristate "Adaptec AACRAID support"
-	depends on SCSI && PCI
+	depends on PCI
 	help
 	  This driver supports a variety of Dell, HP, Adaptec, IBM and
 	  ICP storage products. For a list of supported products, refer
@@ -427,7 +431,7 @@ source "drivers/scsi/aic7xxx/Kconfig.aic
 
 config SCSI_AIC7XXX_OLD
 	tristate "Adaptec AIC7xxx support (old driver)"
-	depends on (ISA || EISA || PCI ) && SCSI
+	depends on ISA || EISA || PCI
 	help
 	  WARNING This driver is an older aic7xxx driver and is no longer
 	  under active development.  Adaptec, Inc. is writing a new driver to
@@ -471,7 +475,7 @@ source "drivers/scsi/aic94xx/Kconfig"
 # All the I2O code and drivers do not seem to be 64bit safe.
 config SCSI_DPT_I2O
 	tristate "Adaptec I2O RAID support "
-	depends on !64BIT && SCSI && PCI
+	depends on !64BIT && PCI
 	help
 	  This driver supports all of Adaptec's I2O based RAID controllers as 
 	  well as the DPT SmartRaid V cards.  This is an Adaptec maintained
@@ -482,7 +486,6 @@ config SCSI_DPT_I2O
 
 config SCSI_ADVANSYS
 	tristate "AdvanSys SCSI support"
-	depends on SCSI
 	depends on ISA || EISA || PCI
 	depends on BROKEN || X86_32
 	help
@@ -495,7 +498,7 @@ config SCSI_ADVANSYS
 
 config SCSI_IN2000
 	tristate "Always IN2000 SCSI support"
-	depends on ISA && SCSI
+	depends on ISA
 	help
 	  This is support for an ISA bus SCSI host adapter.  You'll find more
 	  information in <file:Documentation/scsi/in2000.txt>. If it doesn't work
@@ -507,7 +510,7 @@ config SCSI_IN2000
 
 config SCSI_ARCMSR
 	tristate "ARECA ARC11X0[PCI-X]/ARC12X0[PCI-EXPRESS] SATA-RAID support"
-	depends on PCI && SCSI
+	depends on PCI
 	help
 	  This driver supports all of ARECA's SATA RAID controller cards.
 	  This is an ARECA-maintained driver by Erich Chen.
@@ -523,7 +526,7 @@ source "drivers/scsi/megaraid/Kconfig.me
 
 config SCSI_HPTIOP
 	tristate "HighPoint RocketRAID 3xxx Controller support"
-	depends on SCSI && PCI
+	depends on PCI
 	help
 	  This option enables support for HighPoint RocketRAID 3xxx
 	  controllers.
@@ -533,7 +536,7 @@ config SCSI_HPTIOP
 
 config SCSI_BUSLOGIC
 	tristate "BusLogic SCSI support"
-	depends on (PCI || ISA || MCA) && SCSI && ISA_DMA_API
+	depends on (PCI || ISA || MCA) && ISA_DMA_API
 	---help---
 	  This is support for BusLogic MultiMaster and FlashPoint SCSI Host
 	  Adapters. Consult the SCSI-HOWTO, available from
@@ -555,7 +558,7 @@ config SCSI_OMIT_FLASHPOINT
 
 config SCSI_DMX3191D
 	tristate "DMX3191D SCSI support"
-	depends on PCI && SCSI
+	depends on PCI
 	select SCSI_SPI_ATTRS
 	help
 	  This is support for Domex DMX3191D SCSI Host Adapters.
@@ -565,7 +568,7 @@ config SCSI_DMX3191D
 
 config SCSI_DTC3280
 	tristate "DTC3180/3280 SCSI support"
-	depends on ISA && SCSI
+	depends on ISA
 	select SCSI_SPI_ATTRS
 	help
 	  This is support for DTC 3180/3280 SCSI Host Adapters.  Please read
@@ -578,7 +581,7 @@ config SCSI_DTC3280
 
 config SCSI_EATA
 	tristate "EATA ISA/EISA/PCI (DPT and generic EATA/DMA-compliant boards) support"
-	depends on (ISA || EISA || PCI) && SCSI && ISA_DMA_API
+	depends on (ISA || EISA || PCI) && ISA_DMA_API
 	---help---
 	  This driver supports all EATA/DMA-compliant SCSI host adapters.  DPT
 	  ISA and all EISA I/O addresses are probed looking for the "EATA"
@@ -626,7 +629,7 @@ config SCSI_EATA_MAX_TAGS
 
 config SCSI_EATA_PIO
 	tristate "EATA-PIO (old DPT PM2001, PM2012A) support"
-	depends on (ISA || EISA || PCI) && SCSI && BROKEN
+	depends on (ISA || EISA || PCI) && BROKEN
 	---help---
 	  This driver supports all EATA-PIO protocol compliant SCSI Host
 	  Adapters like the DPT PM2001 and the PM2012A.  EATA-DMA compliant
@@ -640,7 +643,7 @@ config SCSI_EATA_PIO
 
 config SCSI_FUTURE_DOMAIN
 	tristate "Future Domain 16xx SCSI/AHA-2920A support"
-	depends on (ISA || PCI) && SCSI
+	depends on ISA || PCI
 	---help---
 	  This is support for Future Domain's 16-bit SCSI host adapters
 	  (TMC-1660/1680, TMC-1650/1670, TMC-3260, TMC-1610M/MER/MEX) and
@@ -659,7 +662,7 @@ config SCSI_FUTURE_DOMAIN
 
 config SCSI_FD_MCS
 	tristate "Future Domain MCS-600/700 SCSI support"
-	depends on MCA_LEGACY && SCSI
+	depends on MCA_LEGACY
 	---help---
 	  This is support for Future Domain MCS 600/700 MCA SCSI adapters.
 	  Some PS/2 computers are equipped with IBM Fast SCSI Adapter/A which
@@ -672,7 +675,7 @@ config SCSI_FD_MCS
 
 config SCSI_GDTH
 	tristate "Intel/ICP (former GDT SCSI Disk Array) RAID Controller support"
-	depends on (ISA || EISA || PCI) && SCSI && ISA_DMA_API
+	depends on (ISA || EISA || PCI) && ISA_DMA_API
 	---help---
 	  Formerly called GDT SCSI Disk Array Controller Support.
 
@@ -686,7 +689,7 @@ config SCSI_GDTH
 
 config SCSI_GENERIC_NCR5380
 	tristate "Generic NCR5380/53c400 SCSI PIO support"
-	depends on ISA && SCSI
+	depends on ISA
 	select SCSI_SPI_ATTRS
 	---help---
 	  This is a driver for the old NCR 53c80 series of SCSI controllers
@@ -706,7 +709,7 @@ config SCSI_GENERIC_NCR5380
 
 config SCSI_GENERIC_NCR5380_MMIO
 	tristate "Generic NCR5380/53c400 SCSI MMIO support"
-	depends on ISA && SCSI
+	depends on ISA
 	select SCSI_SPI_ATTRS
 	---help---
 	  This is a driver for the old NCR 53c80 series of SCSI controllers
@@ -732,7 +735,7 @@ config SCSI_GENERIC_NCR53C400
 
 config SCSI_IBMMCA
 	tristate "IBMMCA SCSI support"
-	depends on MCA_LEGACY && SCSI
+	depends on MCA_LEGACY
 	---help---
 	  This is support for the IBM SCSI adapter found in many of the PS/2
 	  series computers.  These machines have an MCA bus, so you need to
@@ -802,7 +805,7 @@ config IBMMCA_SCSI_DEV_RESET
 
 config SCSI_IPS
 	tristate "IBM ServeRAID support"
-	depends on PCI && SCSI
+	depends on PCI
 	---help---
 	  This is support for the IBM ServeRAID hardware RAID controllers.
 	  See <http://www.developer.ibm.com/welcome/netfinity/serveraid.html>
@@ -838,7 +841,7 @@ config SCSI_IBMVSCSIS
 
 config SCSI_INITIO
 	tristate "Initio 9100U(W) support"
-	depends on PCI && SCSI
+	depends on PCI
 	help
 	  This is support for the Initio 91XXU(W) SCSI host adapter.  Please
 	  read the SCSI-HOWTO, available from
@@ -849,7 +852,7 @@ config SCSI_INITIO
 
 config SCSI_INIA100
 	tristate "Initio INI-A100U2W support"
-	depends on PCI && SCSI
+	depends on PCI
 	help
 	  This is support for the Initio INI-A100U2W SCSI host adapter.
 	  Please read the SCSI-HOWTO, available from
@@ -860,7 +863,7 @@ config SCSI_INIA100
 
 config SCSI_PPA
 	tristate "IOMEGA parallel port (ppa - older drives)"
-	depends on SCSI && PARPORT_PC
+	depends on PARPORT_PC
 	---help---
 	  This driver supports older versions of IOMEGA's parallel port ZIP
 	  drive (a 100 MB removable media device).
@@ -887,7 +890,7 @@ config SCSI_PPA
 
 config SCSI_IMM
 	tristate "IOMEGA parallel port (imm - newer drives)"
-	depends on SCSI && PARPORT_PC
+	depends on PARPORT_PC
 	---help---
 	  This driver supports newer versions of IOMEGA's parallel port ZIP
 	  drive (a 100 MB removable media device).
@@ -943,7 +946,7 @@ config SCSI_IZIP_SLOW_CTR
 
 config SCSI_NCR53C406A
 	tristate "NCR53c406a SCSI support"
-	depends on ISA && SCSI
+	depends on ISA
 	help
 	  This is support for the NCR53c406a SCSI host adapter.  For user
 	  configurable parameters, check out <file:drivers/scsi/NCR53c406a.c>
@@ -955,7 +958,7 @@ config SCSI_NCR53C406A
 
 config SCSI_NCR_D700
 	tristate "NCR Dual 700 MCA SCSI support"
-	depends on MCA && SCSI
+	depends on MCA
 	select SCSI_SPI_ATTRS
 	help
 	  This is a driver for the MicroChannel Dual 700 card produced by
@@ -967,7 +970,7 @@ config SCSI_NCR_D700
 
 config SCSI_LASI700
 	tristate "HP Lasi SCSI support for 53c700/710"
-	depends on GSC && SCSI
+	depends on GSC
 	select SCSI_SPI_ATTRS
 	help
 	  This is a driver for the SCSI controller in the Lasi chip found in
@@ -976,7 +979,7 @@ config SCSI_LASI700
 
 config SCSI_SNI_53C710
 	tristate "SNI RM SCSI support for 53c710"
-	depends on SNI_RM && SCSI
+	depends on SNI_RM
 	select SCSI_SPI_ATTRS
 	select 53C700_LE_ON_BE
 	help
@@ -990,7 +993,7 @@ config 53C700_LE_ON_BE
 
 config SCSI_STEX
 	tristate "Promise SuperTrak EX Series support"
-	depends on PCI && SCSI
+	depends on PCI
 	---help---
 	  This driver supports Promise SuperTrak EX series storage controllers.
 
@@ -1002,7 +1005,7 @@ config SCSI_STEX
 
 config SCSI_SYM53C8XX_2
 	tristate "SYM53C8XX Version 2 SCSI support"
-	depends on PCI && SCSI
+	depends on PCI
 	select SCSI_SPI_ATTRS
 	---help---
 	  This driver supports the whole NCR53C8XX/SYM53C8XX family of
@@ -1069,7 +1072,7 @@ config SCSI_SYM53C8XX_MMIO
 
 config SCSI_IPR
 	tristate "IBM Power Linux RAID adapter support"
-	depends on PCI && SCSI && ATA
+	depends on PCI && ATA
 	select FW_LOADER
 	---help---
 	  This driver supports the IBM Power Linux family RAID adapters.
@@ -1096,7 +1099,7 @@ config SCSI_IPR_DUMP
 
 config SCSI_ZALON
 	tristate "Zalon SCSI support"
-	depends on GSC && SCSI
+	depends on GSC
 	select SCSI_SPI_ATTRS
 	help
 	  The Zalon is a GSC/HSC bus interface chip that sits between the
@@ -1107,7 +1110,7 @@ config SCSI_ZALON
 
 config SCSI_NCR_Q720
 	tristate "NCR Quad 720 MCA SCSI support"
-	depends on MCA && SCSI
+	depends on MCA
 	select SCSI_SPI_ATTRS
 	help
 	  This is a driver for the MicroChannel Quad 720 card produced by
@@ -1217,7 +1220,7 @@ config SCSI_NCR53C8XX_NO_DISCONNECT
 
 config SCSI_MCA_53C9X
 	tristate "NCR MCA 53C9x SCSI support"
-	depends on MCA_LEGACY && SCSI && BROKEN_ON_SMP
+	depends on MCA_LEGACY && BROKEN_ON_SMP
 	help
 	  Some MicroChannel machines, notably the NCR 35xx line, use a SCSI
 	  controller based on the NCR 53C94.  This driver will allow use of
@@ -1228,7 +1231,7 @@ config SCSI_MCA_53C9X
 
 config SCSI_PAS16
 	tristate "PAS16 SCSI support"
-	depends on ISA && SCSI
+	depends on ISA
 	select SCSI_SPI_ATTRS
 	---help---
 	  This is support for a SCSI host adapter.  It is explained in section
@@ -1242,7 +1245,7 @@ config SCSI_PAS16
 
 config SCSI_PSI240I
 	tristate "PSI240i support"
-	depends on ISA && SCSI
+	depends on ISA
 	help
 	  This is support for the PSI240i EIDE interface card which acts as a
 	  SCSI host adapter.  Please read the SCSI-HOWTO, available from
@@ -1253,7 +1256,7 @@ config SCSI_PSI240I
 
 config SCSI_QLOGIC_FAS
 	tristate "Qlogic FAS SCSI support"
-	depends on ISA && SCSI
+	depends on ISA
 	---help---
 	  This is a driver for the ISA, VLB, and PCMCIA versions of the Qlogic
 	  FastSCSI! cards as well as any other card based on the FASXX chip
@@ -1281,7 +1284,7 @@ config SCSI_QLOGIC_FC_FIRMWARE
 
 config SCSI_QLOGIC_1280
 	tristate "Qlogic QLA 1240/1x80/1x160 SCSI support"
-	depends on PCI && SCSI
+	depends on PCI
 	help
 	  Say Y if you have a QLogic ISP1240/1x80/1x160 SCSI host adapter.
 
@@ -1290,7 +1293,7 @@ config SCSI_QLOGIC_1280
 
 config SCSI_QLOGICPTI
 	tristate "PTI Qlogic, ISP Driver"
-	depends on SBUS && SCSI
+	depends on SBUS
 	help
 	  This driver supports SBUS SCSI controllers from PTI or QLogic. These
 	  controllers are known under Solaris as qpti and in the openprom as
@@ -1305,7 +1308,7 @@ source "drivers/scsi/qla4xxx/Kconfig"
 
 config SCSI_LPFC
 	tristate "Emulex LightPulse Fibre Channel Support"
-	depends on PCI && SCSI
+	depends on PCI
 	select SCSI_FC_ATTRS
 	help
           This lpfc driver supports the Emulex LightPulse
@@ -1313,7 +1316,7 @@ config SCSI_LPFC
 
 config SCSI_SEAGATE
 	tristate "Seagate ST-02 and Future Domain TMC-8xx SCSI support"
-	depends on X86 && ISA && SCSI
+	depends on X86 && ISA
 	---help---
 	  These are 8-bit SCSI controllers; the ST-01 is also supported by
 	  this driver.  It is explained in section 3.9 of the SCSI-HOWTO,
@@ -1327,7 +1330,7 @@ config SCSI_SEAGATE
 # definitely looks not 64bit safe:
 config SCSI_SIM710
 	tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
-	depends on (EISA || MCA) && SCSI
+	depends on EISA || MCA
 	select SCSI_SPI_ATTRS
 	---help---
 	  This driver for NCR53c710 based SCSI host adapters.
@@ -1341,7 +1344,7 @@ config 53C700_IO_MAPPED
 
 config SCSI_SYM53C416
 	tristate "Symbios 53c416 SCSI support"
-	depends on ISA && SCSI
+	depends on ISA
 	---help---
 	  This is support for the sym53c416 SCSI host adapter, the SCSI
 	  adapter that comes with some HP scanners. This driver requires that
@@ -1359,7 +1362,7 @@ config SCSI_SYM53C416
 
 config SCSI_DC395x
 	tristate "Tekram DC395(U/UW/F) and DC315(U) SCSI support (EXPERIMENTAL)"
-	depends on PCI && SCSI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL
 	---help---
 	  This driver supports PCI SCSI host adapters based on the ASIC
 	  TRM-S1040 chip, e.g Tekram DC395(U/UW/F) and DC315(U) variants.
@@ -1374,7 +1377,7 @@ config SCSI_DC395x
 
 config SCSI_DC390T
 	tristate "Tekram DC390(T) and Am53/79C974 SCSI support"
-	depends on PCI && SCSI
+	depends on PCI
 	---help---
 	  This driver supports PCI SCSI host adapters based on the Am53C974A
 	  chip, e.g. Tekram DC390(T), DawiControl 2974 and some onboard
@@ -1390,7 +1393,7 @@ config SCSI_DC390T
 
 config SCSI_T128
 	tristate "Trantor T128/T128F/T228 SCSI support"
-	depends on ISA && SCSI
+	depends on ISA
 	select SCSI_SPI_ATTRS
 	---help---
 	  This is support for a SCSI host adapter. It is explained in section
@@ -1406,7 +1409,7 @@ config SCSI_T128
 
 config SCSI_U14_34F
 	tristate "UltraStor 14F/34F support"
-	depends on ISA && SCSI && ISA_DMA_API
+	depends on ISA && ISA_DMA_API
 	---help---
 	  This is support for the UltraStor 14F and 34F SCSI-2 host adapters.
 	  The source at <file:drivers/scsi/u14-34f.c> contains some
@@ -1455,7 +1458,7 @@ config SCSI_U14_34F_MAX_TAGS
 
 config SCSI_ULTRASTOR
 	tristate "UltraStor SCSI support"
-	depends on X86 && ISA && SCSI
+	depends on X86 && ISA
 	---help---
 	  This is support for the UltraStor 14F, 24F and 34F SCSI-2 host
 	  adapter family.  This driver is explained in section 3.12 of the
@@ -1472,7 +1475,7 @@ config SCSI_ULTRASTOR
 
 config SCSI_NSP32
 	tristate "Workbit NinjaSCSI-32Bi/UDE support"
-	depends on PCI && SCSI && !64BIT
+	depends on PCI && !64BIT
 	help
 	  This is support for the Workbit NinjaSCSI-32Bi/UDE PCI/Cardbus
 	  SCSI host adapter. Please read the SCSI-HOWTO, available from
@@ -1483,7 +1486,6 @@ config SCSI_NSP32
 
 config SCSI_DEBUG
 	tristate "SCSI debugging host simulator"
-	depends on SCSI
 	help
 	  This is a host adapter simulator that can simulate multiple hosts
 	  each with multiple dummy SCSI devices (disks). It defaults to one
@@ -1496,7 +1498,7 @@ config SCSI_DEBUG
 
 config SCSI_MESH
 	tristate "MESH (Power Mac internal SCSI) support"
-	depends on PPC32 && PPC_PMAC && SCSI
+	depends on PPC32 && PPC_PMAC
 	help
 	  Many Power Macintoshes and clones have a MESH (Macintosh Enhanced
 	  SCSI Hardware) SCSI bus adaptor (the 7200 doesn't, but all of the
@@ -1527,7 +1529,7 @@ config SCSI_MESH_RESET_DELAY_MS
 
 config SCSI_MAC53C94
 	tristate "53C94 (Power Mac external SCSI) support"
-	depends on PPC32 && PPC_PMAC && SCSI
+	depends on PPC32 && PPC_PMAC
 	help
 	  On Power Macintoshes (and clones) with two SCSI buses, the external
 	  SCSI bus is usually controlled by a 53C94 SCSI bus adaptor. Older
@@ -1541,7 +1543,7 @@ source "drivers/scsi/arm/Kconfig"
 
 config JAZZ_ESP
 	bool "MIPS JAZZ FAS216 SCSI support"
-	depends on MACH_JAZZ && SCSI
+	depends on MACH_JAZZ
 	help
 	  This is the driver for the onboard SCSI host adapter of MIPS Magnum
 	  4000, Acer PICA, Olivetti M700-10 and a few other identical OEM
@@ -1549,7 +1551,7 @@ config JAZZ_ESP
 
 config A3000_SCSI
 	tristate "A3000 WD33C93A support"
-	depends on AMIGA && SCSI
+	depends on AMIGA
 	help
 	  If you have an Amiga 3000 and have SCSI devices connected to the
 	  built-in SCSI controller, say Y. Otherwise, say N.
@@ -1559,7 +1561,7 @@ config A3000_SCSI
 
 config A2091_SCSI
 	tristate "A2091/A590 WD33C93A support"
-	depends on ZORRO && SCSI
+	depends on ZORRO
 	help
 	  If you have a Commodore A2091 SCSI controller, say Y. Otherwise,
 	  say N.
@@ -1569,7 +1571,7 @@ config A2091_SCSI
 
 config GVP11_SCSI
 	tristate "GVP Series II WD33C93A support"
-	depends on ZORRO && SCSI
+	depends on ZORRO
 	---help---
 	  If you have a Great Valley Products Series II SCSI controller,
 	  answer Y. Also say Y if you have a later model of GVP SCSI
@@ -1582,7 +1584,7 @@ config GVP11_SCSI
 
 config CYBERSTORM_SCSI
 	tristate "CyberStorm SCSI support"
-	depends on ZORRO && SCSI
+	depends on ZORRO
 	help
 	  If you have an Amiga with an original (MkI) Phase5 Cyberstorm
 	  accelerator board and the optional Cyberstorm SCSI controller,
@@ -1590,7 +1592,7 @@ config CYBERSTORM_SCSI
 
 config CYBERSTORMII_SCSI
 	tristate "CyberStorm Mk II SCSI support"
-	depends on ZORRO && SCSI
+	depends on ZORRO
 	help
 	  If you have an Amiga with a Phase5 Cyberstorm MkII accelerator board
 	  and the optional Cyberstorm SCSI controller, say Y. Otherwise,
@@ -1598,7 +1600,7 @@ config CYBERSTORMII_SCSI
 
 config BLZ2060_SCSI
 	tristate "Blizzard 2060 SCSI support"
-	depends on ZORRO && SCSI
+	depends on ZORRO
 	help
 	  If you have an Amiga with a Phase5 Blizzard 2060 accelerator board
 	  and want to use the onboard SCSI controller, say Y. Otherwise,
@@ -1606,7 +1608,7 @@ config BLZ2060_SCSI
 
 config BLZ1230_SCSI
 	tristate "Blizzard 1230IV/1260 SCSI support"
-	depends on ZORRO && SCSI
+	depends on ZORRO
 	help
 	  If you have an Amiga 1200 with a Phase5 Blizzard 1230IV or Blizzard
 	  1260 accelerator, and the optional SCSI module, say Y. Otherwise,
@@ -1614,14 +1616,14 @@ config BLZ1230_SCSI
 
 config FASTLANE_SCSI
 	tristate "Fastlane SCSI support"
-	depends on ZORRO && SCSI
+	depends on ZORRO
 	help
 	  If you have the Phase5 Fastlane Z3 SCSI controller, or plan to use
 	  one in the near future, say Y to this question. Otherwise, say N.
 
 config SCSI_AMIGA7XX
 	bool "Amiga NCR53c710 SCSI support (EXPERIMENTAL)"
-	depends on AMIGA && SCSI && EXPERIMENTAL && BROKEN
+	depends on AMIGA && EXPERIMENTAL && BROKEN
 	help
 	  Support for various NCR53c710-based SCSI controllers on the Amiga.
 	  This includes:
@@ -1640,7 +1642,7 @@ config SCSI_AMIGA7XX
 
 config OKTAGON_SCSI
 	tristate "BSC Oktagon SCSI support (EXPERIMENTAL)"
-	depends on ZORRO && SCSI && EXPERIMENTAL
+	depends on ZORRO && EXPERIMENTAL
 	help
 	  If you have the BSC Oktagon SCSI disk controller for the Amiga, say
 	  Y to this question.  If you're in doubt about whether you have one,
@@ -1649,7 +1651,7 @@ config OKTAGON_SCSI
 
 config ATARI_SCSI
 	tristate "Atari native SCSI support"
-	depends on ATARI && SCSI && BROKEN
+	depends on ATARI && BROKEN
 	select SCSI_SPI_ATTRS
 	---help---
 	  If you have an Atari with built-in NCR5380 SCSI controller (TT,
@@ -1701,7 +1703,7 @@ config MAC_SCSI
 
 config SCSI_MAC_ESP
 	tristate "Macintosh NCR53c9[46] SCSI"
-	depends on MAC && SCSI
+	depends on MAC
 	help
 	  This is the NCR 53c9x SCSI controller found on most of the 68040
 	  based Macintoshes.  If you have one of these say Y and read the
@@ -1721,7 +1723,7 @@ config MVME147_SCSI
 
 config MVME16x_SCSI
 	bool "NCR53C710 SCSI driver for MVME16x"
-	depends on MVME16x && SCSI && BROKEN
+	depends on MVME16x && BROKEN
 	select SCSI_SPI_ATTRS
 	help
 	  The Motorola MVME162, 166, 167, 172 and 177 boards use the NCR53C710
@@ -1730,7 +1732,7 @@ config MVME16x_SCSI
 
 config BVME6000_SCSI
 	bool "NCR53C710 SCSI driver for BVME6000"
-	depends on BVME6000 && SCSI && BROKEN
+	depends on BVME6000 && BROKEN
 	select SCSI_SPI_ATTRS
 	help
 	  The BVME4000 and BVME6000 boards from BVM Ltd use the NCR53C710
@@ -1747,7 +1749,7 @@ config SCSI_NCR53C7xx_FAST
 
 config SUN3_SCSI
 	tristate "Sun3 NCR5380 SCSI"
-	depends on SUN3 && SCSI
+	depends on SUN3
 	select SCSI_SPI_ATTRS
 	help
 	  This option will enable support for the OBIO (onboard io) NCR5380
@@ -1765,7 +1767,7 @@ config SUN3X_ESP
 
 config SCSI_SUNESP
 	tristate "Sparc ESP Scsi Driver"
-	depends on SBUS && SCSI
+	depends on SBUS
 	help
 	  This is the driver for the Sun ESP SCSI host adapter. The ESP
 	  chipset is present in most SPARC SBUS-based computers.
@@ -1777,7 +1779,7 @@ config SCSI_SUNESP
 
 config ZFCP
 	tristate "FCP host bus adapter driver for IBM eServer zSeries"
-	depends on S390 && QDIO && SCSI
+	depends on S390 && QDIO
 	select SCSI_FC_ATTRS
 	help
           If you want to access SCSI devices attached to your IBM eServer
@@ -1791,7 +1793,7 @@ config ZFCP
 
 config SCSI_SRP
 	tristate "SCSI RDMA Protocol helper library"
-	depends on SCSI && PCI
+	depends on PCI
 	select SCSI_TGT
 	help
 	  If you wish to use SRP target drivers, say Y.
@@ -1799,7 +1801,7 @@ config SCSI_SRP
 	  To compile this driver as a module, choose M here: the
 	  module will be called libsrp.
 
-endmenu
+endif # SCSI_LOWLEVEL
 
 source "drivers/scsi/pcmcia/Kconfig"
 
Index: linux-2.6.21-rc5/drivers/scsi/aic7xxx/Kconfig.aic79xx
===================================================================
--- linux-2.6.21-rc5.orig/drivers/scsi/aic7xxx/Kconfig.aic79xx
+++ linux-2.6.21-rc5/drivers/scsi/aic7xxx/Kconfig.aic79xx
@@ -4,7 +4,7 @@
 #
 config SCSI_AIC79XX
 	tristate "Adaptec AIC79xx U320 support"
-	depends on PCI && SCSI
+	depends on PCI
 	select SCSI_SPI_ATTRS
 	help
 	This driver supports all of Adaptec's Ultra 320 PCI-X
Index: linux-2.6.21-rc5/drivers/scsi/arm/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/scsi/arm/Kconfig
+++ linux-2.6.21-rc5/drivers/scsi/arm/Kconfig
@@ -3,7 +3,7 @@
 #
 config SCSI_ACORNSCSI_3
 	tristate "Acorn SCSI card (aka30) support"
-	depends on ARCH_ACORN && SCSI && BROKEN
+	depends on ARCH_ACORN && BROKEN
 	select SCSI_SPI_ATTRS
 	help
 	  This enables support for the Acorn SCSI card (aka30). If you have an
@@ -32,7 +32,7 @@ config SCSI_ACORNSCSI_SYNC
 
 config SCSI_ARXESCSI
 	tristate "ARXE SCSI support"
-	depends on ARCH_ACORN && SCSI
+	depends on ARCH_ACORN
 	help
 	  Around 1991, Arxe Systems Limited released a high density floppy
 	  disc interface for the Acorn Archimedes range, to allow the use of
@@ -44,21 +44,21 @@ config SCSI_ARXESCSI
 
 config SCSI_CUMANA_2
 	tristate "CumanaSCSI II support"
-	depends on ARCH_ACORN && SCSI
+	depends on ARCH_ACORN
 	help
 	  This enables support for the Cumana SCSI II card. If you have an
 	  Acorn system with one of these, say Y. If unsure, say N.
 
 config SCSI_EESOXSCSI
 	tristate "EESOX support"
-	depends on ARCH_ACORN && SCSI
+	depends on ARCH_ACORN
 	help
 	  This enables support for the EESOX SCSI card. If you have an Acorn
 	  system with one of these, say Y, otherwise say N.
 
 config SCSI_POWERTECSCSI
 	tristate "PowerTec support"
-	depends on ARCH_ACORN && SCSI
+	depends on ARCH_ACORN
 	help
 	  This enables support for the Powertec SCSI card on Acorn systems. If
 	  you have one of these, say Y. If unsure, say N.
@@ -68,7 +68,7 @@ comment "The following drivers are not f
 
 config SCSI_CUMANA_1
 	tristate "CumanaSCSI I support (EXPERIMENTAL)"
-	depends on ARCH_ACORN && EXPERIMENTAL && SCSI
+	depends on ARCH_ACORN && EXPERIMENTAL
 	select SCSI_SPI_ATTRS
 	help
 	  This enables support for the Cumana SCSI I card. If you have an
@@ -76,7 +76,7 @@ config SCSI_CUMANA_1
 
 config SCSI_ECOSCSI
 	tristate "EcoScsi support (EXPERIMENTAL)"
-	depends on ARCH_ACORN && EXPERIMENTAL && (ARCH_ARC || ARCH_A5K) && SCSI
+	depends on ARCH_ACORN && EXPERIMENTAL && (ARCH_ARC || ARCH_A5K)
 	select SCSI_SPI_ATTRS
 	help
 	  This enables support for the EcoSCSI card -- a small card that sits
@@ -85,7 +85,7 @@ config SCSI_ECOSCSI
 
 config SCSI_OAK1
 	tristate "Oak SCSI support (EXPERIMENTAL)"
-	depends on ARCH_ACORN && EXPERIMENTAL && SCSI
+	depends on ARCH_ACORN && EXPERIMENTAL
 	select SCSI_SPI_ATTRS
 	help
 	  This enables support for the Oak SCSI card. If you have an Acorn
Index: linux-2.6.21-rc5/drivers/scsi/megaraid/Kconfig.megaraid
===================================================================
--- linux-2.6.21-rc5.orig/drivers/scsi/megaraid/Kconfig.megaraid
+++ linux-2.6.21-rc5/drivers/scsi/megaraid/Kconfig.megaraid
@@ -1,12 +1,12 @@
 config MEGARAID_NEWGEN
 	bool "LSI Logic New Generation RAID Device Drivers"
-	depends on PCI && SCSI
+	depends on PCI
 	help
 	LSI Logic RAID Device Drivers
 
 config MEGARAID_MM
 	tristate "LSI Logic Management Module (New Driver)"
-	depends on PCI && SCSI && MEGARAID_NEWGEN
+	depends on PCI && MEGARAID_NEWGEN
 	help
 	Management Module provides ioctl, sysfs support for LSI Logic
 	RAID controllers.
@@ -16,7 +16,7 @@ config MEGARAID_MM
 
 config MEGARAID_MAILBOX
 	tristate "LSI Logic MegaRAID Driver (New Driver)"
-	depends on PCI && SCSI && MEGARAID_MM
+	depends on PCI && MEGARAID_MM
 	help
 	List of supported controllers
 
@@ -66,7 +66,7 @@ config MEGARAID_MAILBOX
 
 config MEGARAID_LEGACY
 	tristate "LSI Logic Legacy MegaRAID Driver"
-	depends on PCI && SCSI
+	depends on PCI
 	help
 	This driver supports the LSI MegaRAID 418, 428, 438, 466, 762, 490
 	and 467 SCSI host adapters. This driver also support the all U320
@@ -77,7 +77,7 @@ config MEGARAID_LEGACY
 
 config MEGARAID_SAS
 	tristate "LSI Logic MegaRAID SAS RAID Module"
-	depends on PCI && SCSI
+	depends on PCI
 	help
 	Module for LSI Logic's SAS based RAID controllers.
 	To compile this driver as a module, choose 'm' here.
Index: linux-2.6.21-rc5/drivers/scsi/pcmcia/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/scsi/pcmcia/Kconfig
+++ linux-2.6.21-rc5/drivers/scsi/pcmcia/Kconfig
@@ -2,8 +2,12 @@
 # PCMCIA SCSI adapter configuration
 #
 
-menu "PCMCIA SCSI adapter support"
+menuconfig SCSI_PCMCIA
+	bool "PCMCIA SCSI adapter support"
 	depends on SCSI!=n && PCMCIA!=n && MODULES
+	default y
+
+if SCSI_PCMCIA
 
 config PCMCIA_AHA152X
 	tristate "Adaptec AHA152X PCMCIA support"
@@ -80,4 +84,4 @@ config PCMCIA_SYM53C500
 	  To compile this driver as a module, choose M here: the
 	  module will be called sym53c500_cs.
 
-endmenu
+endif # SCSI_PCMCIA
Index: linux-2.6.21-rc5/drivers/scsi/qla2xxx/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/scsi/qla2xxx/Kconfig
+++ linux-2.6.21-rc5/drivers/scsi/qla2xxx/Kconfig
@@ -1,6 +1,6 @@
 config SCSI_QLA_FC
 	tristate "QLogic QLA2XXX Fibre Channel Support"
-	depends on PCI && SCSI
+	depends on PCI
 	select SCSI_FC_ATTRS
 	select FW_LOADER
 	---help---
Index: linux-2.6.21-rc5/drivers/scsi/qla4xxx/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/scsi/qla4xxx/Kconfig
+++ linux-2.6.21-rc5/drivers/scsi/qla4xxx/Kconfig
@@ -1,6 +1,6 @@
 config SCSI_QLA_ISCSI
 	tristate "QLogic ISP4XXX host adapter family support"
-	depends on PCI && SCSI && NET
+	depends on PCI && NET
 	select SCSI_ISCSI_ATTRS
 	---help---
 	This driver supports the QLogic 40xx (ISP4XXX) iSCSI host
#<EOF>
