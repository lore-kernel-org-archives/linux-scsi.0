From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] scsi/Kconfig tidyup
Date: Wed, 11 Feb 2004 19:46:00 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040211194600.GS13351@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:3038 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265728AbUBKTqC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2004 14:46:02 -0500
Received: from willy by www.linux.org.uk with local (Exim 4.22)
	id 1Ar0J6-0003VV-NX
	for linux-scsi@vger.kernel.org; Wed, 11 Feb 2004 19:46:00 +0000
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch corrects a couple of typos in drivers/scsi/Kconfig and
makes the SCSI drivers menu depend on SCSI rather than on SCSI!=n.
That has the effect of making every driver depend on SCSI, so we don't
need the explicit dependency for every driver.

Index: drivers/scsi/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/Kconfig,v
retrieving revision 1.13
diff -u -p -r1.13 Kconfig
--- a/drivers/scsi/Kconfig	7 Feb 2004 14:02:43 -0000	1.13
+++ b/drivers/scsi/Kconfig	11 Feb 2004 19:31:44 -0000
@@ -27,10 +27,10 @@ config SCSI_PROC_FS
 	default y
 	---help---
 	  This option enables support for the various files in
-	  /proc/scsi.  In Linux 2.6 this has been superceeded by
+	  /proc/scsi.  In Linux 2.6 this has been superseded by
 	  files in sysfs but many legacy applications rely on this.
 
-	  If unusure say Y.
+	  If unsure say Y.
 
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
@@ -198,29 +198,29 @@ config SCSI_LOGGING
 
 
 menu "SCSI low-level drivers"
-	depends on SCSI!=n
+	depends on SCSI
 
 config SGIWD93_SCSI
 	tristate "SGI WD93C93 SCSI Driver"
-	depends on SGI_IP22 && SCSI
+	depends on SGI_IP22
   	help
 	  If you have a Western Digital WD93 SCSI controller on
 	  an SGI MIPS system, say Y.  Otherwise, say N.
 
 config SCSI_DECNCR
 	tristate "DEC NCR53C94 Scsi Driver"
-	depends on DECSTATION && TC && SCSI
+	depends on DECSTATION && TC
 	help
 	  Say Y here to support the NCR53C94 SCSI controller chips on IOASIC
 	  based TURBOchannel DECstations and TURBOchannel PMAZ-A cards.
 
 config SCSI_DECSII
 	tristate "DEC SII Scsi Driver"
-	depends on DECSTATION && SCSI
+	depends on DECSTATION
 
 config BLK_DEV_3W_XXXX_RAID
 	tristate "3ware Hardware ATA-RAID support"
-	depends on PCI && SCSI
+	depends on PCI
 	help
 	  3ware is the only hardware ATA-Raid product in Linux to date.
 	  This card is 2,4, or 8 channel master mode support only.
@@ -233,7 +233,7 @@ config BLK_DEV_3W_XXXX_RAID
 
 config SCSI_7000FASST
 	tristate "7000FASST SCSI support"
-	depends on ISA && SCSI
+	depends on ISA
 	help
 	  This driver supports the Western Digital 7000 SCSI host adapter
 	  family.  Some information is in the source:
@@ -244,7 +244,7 @@ config SCSI_7000FASST
 
 config SCSI_ACARD
 	tristate "ACARD SCSI support"
-	depends on PCI && SCSI
+	depends on PCI
 	help
 	  This driver supports the ACARD 870U/W SCSI host adapter.
 
@@ -253,7 +253,7 @@ config SCSI_ACARD
 
 config SCSI_AHA152X
 	tristate "Adaptec AHA152X/2825 support"
-	depends on ISA && SCSI && !64BIT
+	depends on ISA && !64BIT
 	---help---
 	  This is a driver for the AHA-1510, AHA-1520, AHA-1522, and AHA-2825
 	  SCSI host adapters. It also works for the AVA-1505, but the IRQ etc.
@@ -268,7 +268,7 @@ config SCSI_AHA152X
 
 config SCSI_AHA1542
 	tristate "Adaptec AHA1542 support"
-	depends on ISA && SCSI
+	depends on ISA
 	---help---
 	  This is support for a SCSI host adapter.  It is explained in section
 	  3.4 of the SCSI-HOWTO, available from
@@ -282,7 +282,7 @@ config SCSI_AHA1542
 
 config SCSI_AHA1740
 	tristate "Adaptec AHA1740 support"
-	depends on EISA && SCSI
+	depends on EISA
 	---help---
 	  This is support for a SCSI host adapter.  It is explained in section
 	  3.5 of the SCSI-HOWTO, available from
@@ -295,13 +295,13 @@ config SCSI_AHA1740
 
 config SCSI_AACRAID
 	tristate "Adaptec AACRAID support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && SCSI && PCI
+	depends on EXPERIMENTAL && PCI
 
 source "drivers/scsi/aic7xxx/Kconfig.aic7xxx"
 
 config SCSI_AIC7XXX_OLD
 	tristate "Adaptec AIC7xxx support (old driver)"
-	depends on SCSI
+	depends on ISA || EISA || PCI
 	help
 	  WARNING This driver is an older aic7xxx driver and is no longer
 	  under active development.  Adaptec, Inc. is writing a new driver to
@@ -344,7 +344,7 @@ source "drivers/scsi/aic7xxx/Kconfig.aic
 # All the I2O code and drivers do not seem to be 64bit safe.
 config SCSI_DPT_I2O
 	tristate "Adaptec I2O RAID support "
-	depends on !64BIT && SCSI && BROKEN
+	depends on !64BIT && BROKEN
 	help
 	  This driver supports all of Adaptec's I2O based RAID controllers as 
 	  well as the DPT SmartRaid V cards.  This is an Adaptec maintained
@@ -355,7 +355,7 @@ config SCSI_DPT_I2O
 
 config SCSI_ADVANSYS
 	tristate "AdvanSys SCSI support"
-	depends on (ISA || EISA || PCI) && SCSI
+	depends on ISA || EISA || PCI
 	help
 	  This is a driver for all SCSI host adapters manufactured by
 	  AdvanSys. It is documented in the kernel source in
@@ -366,7 +366,7 @@ config SCSI_ADVANSYS
 
 config SCSI_IN2000
 	tristate "Always IN2000 SCSI support"
-	depends on ISA && SCSI
+	depends on ISA
 	help
 	  This is support for an ISA bus SCSI host adapter.  You'll find more
 	  information in <file:Documentation/scsi/in2000.txt>. If it doesn't work
@@ -378,7 +378,7 @@ config SCSI_IN2000
 
 config SCSI_MEGARAID
 	tristate "AMI MegaRAID support"
-	depends on PCI && SCSI
+	depends on PCI
 	help
 	  This driver supports the AMI MegaRAID 418, 428, 438, 466, 762, 490
 	  and 467 SCSI host adapters.
@@ -388,7 +388,7 @@ config SCSI_MEGARAID
 
 config SCSI_SATA
 	bool "Serial ATA (SATA) support"
-	depends on SCSI && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	help
 	  This driver family supports Serial ATA host controllers
 	  and devices.
@@ -397,7 +397,7 @@ config SCSI_SATA
 
 config SCSI_SATA_SVW
 	tristate "ServerWorks Frodo / Apple K2 SATA support (EXPERIMENTAL)"
-	depends on SCSI_SATA && PCI && EXPERIMENTAL
+	depends on SCSI_SATA && PCI && (X86 || PPC) && EXPERIMENTAL
 	help
 	  This option enables support for Broadcom/Serverworks/Apple K2
 	  SATA support.
@@ -406,7 +406,7 @@ config SCSI_SATA_SVW
 
 config SCSI_ATA_PIIX
 	tristate "Intel PIIX/ICH SATA support"
-	depends on SCSI_SATA && PCI
+	depends on SCSI_SATA && PCI && X86
 	help
 	  This option enables support for ICH5 Serial ATA.
 	  If PATA support was enabled previously, this enables
@@ -440,7 +440,7 @@ config SCSI_SATA_VIA
 
 config SCSI_BUSLOGIC
 	tristate "BusLogic SCSI support"
-	depends on (PCI || ISA || MCA) && SCSI
+	depends on PCI || ISA || MCA
 	---help---
 	  This is support for BusLogic MultiMaster and FlashPoint SCSI Host
 	  Adapters. Consult the SCSI-HOWTO, available from
@@ -464,14 +464,14 @@ config SCSI_OMIT_FLASHPOINT
 
 config SCSI_CPQFCTS
 	tristate "Compaq Fibre Channel 64-bit/66Mhz HBA support"
-	depends on PCI && SCSI
+	depends on PCI
 	help
 	  Say Y here to compile in support for the Compaq StorageWorks Fibre
 	  Channel 64-bit/66Mhz Host Bus Adapter.
 
 config SCSI_DMX3191D
 	tristate "DMX3191D SCSI support"
-	depends on PCI && SCSI
+	depends on PCI
 	help
 	  This is support for Domex DMX3191D SCSI Host Adapters.
 
@@ -480,7 +480,7 @@ config SCSI_DMX3191D
 
 config SCSI_DTC3280
 	tristate "DTC3180/3280 SCSI support"
-	depends on ISA && SCSI
+	depends on ISA
 	help
 	  This is support for DTC 3180/3280 SCSI Host Adapters.  Please read
 	  the SCSI-HOWTO, available from
@@ -492,7 +492,7 @@ config SCSI_DTC3280
 
 config SCSI_EATA
 	tristate "EATA ISA/EISA/PCI (DPT and generic EATA/DMA-compliant boards) support"
-	depends on (ISA || EISA || PCI) && SCSI
+	depends on ISA || EISA || PCI
 	---help---
 	  This driver supports all EATA/DMA-compliant SCSI host adapters.  DPT
 	  ISA and all EISA I/O addresses are probed looking for the "EATA"
@@ -540,7 +540,7 @@ config SCSI_EATA_MAX_TAGS
 
 config SCSI_EATA_PIO
 	tristate "EATA-PIO (old DPT PM2001, PM2012A) support"
-	depends on SCSI
+	depends on ISA || EISA || PCI
 	---help---
 	  This driver supports all EATA-PIO protocol compliant SCSI Host
 	  Adapters like the DPT PM2001 and the PM2012A.  EATA-DMA compliant
@@ -554,7 +554,7 @@ config SCSI_EATA_PIO
 
 config SCSI_FUTURE_DOMAIN
 	tristate "Future Domain 16xx SCSI/AHA-2920A support"
-	depends on (ISA || PCI) && SCSI
+	depends on ISA || PCI
 	---help---
 	  This is support for Future Domain's 16-bit SCSI host adapters
 	  (TMC-1660/1680, TMC-1650/1670, TMC-3260, TMC-1610M/MER/MEX) and
@@ -573,7 +573,7 @@ config SCSI_FUTURE_DOMAIN
 
 config SCSI_FD_MCS
 	tristate "Future Domain MCS-600/700 SCSI support"
-	depends on MCA && SCSI
+	depends on MCA
 	---help---
 	  This is support for Future Domain MCS 600/700 MCA SCSI adapters.
 	  Some PS/2 computers are equipped with IBM Fast SCSI Adapter/A which
@@ -586,7 +586,7 @@ config SCSI_FD_MCS
 
 config SCSI_GDTH
 	tristate "Intel/ICP (former GDT SCSI Disk Array) RAID Controller support"
-	depends on (ISA || EISA || PCI) && SCSI
+	depends on ISA || EISA || PCI
 	---help---
 	  Formerly called GDT SCSI Disk Array Controller Support.
 
@@ -600,7 +600,7 @@ config SCSI_GDTH
 
 config SCSI_GENERIC_NCR5380
 	tristate "Generic NCR5380/53c400 SCSI PIO support"
-	depends on ISA && SCSI
+	depends on ISA
 	---help---
 	  This is a driver for the old NCR 53c80 series of SCSI controllers
 	  on boards using PIO. Most boards such as the Trantor T130 fit this
@@ -619,7 +619,7 @@ config SCSI_GENERIC_NCR5380
 
 config SCSI_GENERIC_NCR5380_MMIO
 	tristate "Generic NCR5380/53c400 SCSI MMIO support"
-	depends on ISA && SCSI
+	depends on ISA
 	---help---
 	  This is a driver for the old NCR 53c80 series of SCSI controllers
 	  on boards using memory mapped I/O. 
@@ -644,7 +644,7 @@ config SCSI_GENERIC_NCR53C400
 
 config SCSI_IBMMCA
 	tristate "IBMMCA SCSI support"
-	depends on MCA && SCSI
+	depends on MCA
 	---help---
 	  This is support for the IBM SCSI adapter found in many of the PS/2
 	  series computers.  These machines have an MCA bus, so you need to
@@ -714,7 +714,7 @@ config IBMMCA_SCSI_DEV_RESET
 
 config SCSI_IPS
 	tristate "IBM ServeRAID support"
-	depends on PCI && SCSI
+	depends on PCI
 	---help---
 	  This is support for the IBM ServeRAID hardware RAID controllers.
 	  See <http://www.developer.ibm.com/welcome/netfinity/serveraid.html>
@@ -727,7 +727,7 @@ config SCSI_IPS
 
 config SCSI_INITIO
 	tristate "Initio 9100U(W) support"
-	depends on PCI && SCSI && BROKEN
+	depends on PCI && BROKEN
 	help
 	  This is support for the Initio 91XXU(W) SCSI host adapter.  Please
 	  read the SCSI-HOWTO, available from
@@ -738,7 +738,7 @@ config SCSI_INITIO
 
 config SCSI_INIA100
 	tristate "Initio INI-A100U2W support"
-	depends on PCI && SCSI
+	depends on PCI
 	help
 	  This is support for the Initio INI-A100U2W SCSI host adapter.
 	  Please read the SCSI-HOWTO, available from
@@ -749,7 +749,7 @@ config SCSI_INIA100
 
 config SCSI_PPA
 	tristate "IOMEGA parallel port (ppa - older drives)"
-	depends on SCSI && PARPORT
+	depends on PARPORT
 	---help---
 	  This driver supports older versions of IOMEGA's parallel port ZIP
 	  drive (a 100 MB removable media device).
@@ -776,7 +776,7 @@ config SCSI_PPA
 
 config SCSI_IMM
 	tristate "IOMEGA parallel port (imm - newer drives)"
-	depends on SCSI && PARPORT
+	depends on PARPORT
 	---help---
 	  This driver supports newer versions of IOMEGA's parallel port ZIP
 	  drive (a 100 MB removable media device).
@@ -832,7 +832,7 @@ config SCSI_IZIP_SLOW_CTR
 
 config SCSI_NCR53C406A
 	tristate "NCR53c406a SCSI support"
-	depends on ISA && SCSI
+	depends on ISA
 	help
 	  This is support for the NCR53c406a SCSI host adapter.  For user
 	  configurable parameters, check out <file:drivers/scsi/NCR53c406a.c>
@@ -844,7 +844,7 @@ config SCSI_NCR53C406A
 
 config SCSI_NCR_D700
 	tristate "NCR Dual 700 MCA SCSI support"
-	depends on MCA && SCSI
+	depends on MCA
 	help
 	  This is a driver for the MicroChannel Dual 700 card produced by
 	  NCR and commonly used in 345x/35xx/4100 class machines.  It always
@@ -860,7 +860,7 @@ config 53C700_IO_MAPPED
 
 config SCSI_LASI700
 	tristate "HP Lasi SCSI support for 53c700/710"
-	depends on GSC && SCSI
+	depends on GSC
 	help
 	  This is a driver for the SCSI controller in the Lasi chip found in
 	  many PA-RISC workstations & servers.  If you do not know whether you
@@ -878,7 +878,7 @@ config 53C700_LE_ON_BE
 
 config SCSI_SYM53C8XX_2
 	tristate "SYM53C8XX Version 2 SCSI support"
-	depends on PCI && SCSI
+	depends on PCI
 	---help---
 	  This driver supports the whole NCR53C8XX/SYM53C8XX family of
 	  PCI-SCSI controllers.  It also supports the subset of LSI53C10XX
@@ -943,7 +943,7 @@ config SCSI_SYM53C8XX_IOMAPPED
 
 config SCSI_ZALON
 	tristate "Zalon SCSI support"
-	depends on GSC && SCSI
+	depends on GSC
 	help
 	  The Zalon is a GSC/HSC bus interface chip that sits between the
 	  PA-RISC processor and the NCR 53c720 SCSI controller on C100,
@@ -953,7 +953,7 @@ config SCSI_ZALON
 
 config SCSI_NCR_Q720
 	tristate "NCR Quad 720 MCA SCSI support"
-	depends on MCA && SCSI
+	depends on MCA
 	help
 	  This is a driver for the MicroChannel Quad 720 card produced by
 	  NCR and commonly used in 345x/35xx/4100 class machines.  It always
@@ -1062,7 +1062,7 @@ config SCSI_NCR53C8XX_NO_DISCONNECT
 
 config SCSI_MCA_53C9X
 	tristate "NCR MCA 53C9x SCSI support"
-	depends on MCA && SCSI && BROKEN_ON_SMP
+	depends on MCA && BROKEN_ON_SMP
 	help
 	  Some MicroChannel machines, notably the NCR 35xx line, use a SCSI
 	  controller based on the NCR 53C94.  This driver will allow use of
@@ -1073,7 +1073,7 @@ config SCSI_MCA_53C9X
 
 config SCSI_PAS16
 	tristate "PAS16 SCSI support"
-	depends on ISA && SCSI
+	depends on ISA
 	---help---
 	  This is support for a SCSI host adapter.  It is explained in section
 	  3.10 of the SCSI-HOWTO, available from
@@ -1086,7 +1086,7 @@ config SCSI_PAS16
 
 config SCSI_PCI2000
 	tristate "PCI2000 support"
-	depends on PCI && SCSI && BROKEN
+	depends on PCI && BROKEN
 	help
 	  This is support for the PCI2000I EIDE interface card which acts as a
 	  SCSI host adapter.  Please read the SCSI-HOWTO, available from
@@ -1097,7 +1097,7 @@ config SCSI_PCI2000
 
 config SCSI_PCI2220I
 	tristate "PCI2220i support"
-	depends on PCI && SCSI && BROKEN
+	depends on PCI && BROKEN
 	help
 	  This is support for the PCI2220i EIDE interface card which acts as a
 	  SCSI host adapter.  Please read the SCSI-HOWTO, available from
@@ -1108,7 +1108,7 @@ config SCSI_PCI2220I
 
 config SCSI_PSI240I
 	tristate "PSI240i support"
-	depends on ISA && SCSI
+	depends on ISA
 	help
 	  This is support for the PSI240i EIDE interface card which acts as a
 	  SCSI host adapter.  Please read the SCSI-HOWTO, available from
@@ -1119,7 +1119,7 @@ config SCSI_PSI240I
 
 config SCSI_QLOGIC_FAS
 	tristate "Qlogic FAS SCSI support"
-	depends on ISA && SCSI
+	depends on ISA || PCMCIA
 	---help---
 	  This is a driver for the ISA, VLB, and PCMCIA versions of the Qlogic
 	  FastSCSI! cards as well as any other card based on the FASXX chip
@@ -1139,7 +1139,7 @@ config SCSI_QLOGIC_FAS
 
 config SCSI_QLOGIC_ISP
 	tristate "Qlogic ISP SCSI support"
-	depends on PCI && SCSI
+	depends on PCI
 	---help---
 	  This driver works for all QLogic PCI SCSI host adapters (IQ-PCI,
 	  IQ-PCI-10, IQ_PCI-D) except for the PCI-basic card.  (This latter
@@ -1157,7 +1157,7 @@ config SCSI_QLOGIC_ISP
 
 config SCSI_QLOGIC_1280
 	tristate "Qlogic QLA 1280 SCSI support"
-	depends on PCI && SCSI
+	depends on PCI
 	help
 	  Say Y if you have a QLogic ISP1x80/1x160 SCSI host adapter.
 
@@ -1166,7 +1166,7 @@ config SCSI_QLOGIC_1280
 
 config SCSI_QLOGICPTI
 	tristate "PTI Qlogic, ISP Driver"
-	depends on SBUS && SCSI
+	depends on SBUS
 	help
 	  This driver supports SBUS SCSI controllers from PTI or QLogic. These
 	  controllers are known under Solaris as qpti and in the openprom as
@@ -1180,7 +1180,7 @@ source "drivers/scsi/qla2xxx/Kconfig"
 
 config SCSI_SEAGATE
 	tristate "Seagate ST-02 and Future Domain TMC-8xx SCSI support"
-	depends on X86 && ISA && SCSI && BROKEN
+	depends on X86 && ISA && BROKEN
 	---help---
 	  These are 8-bit SCSI controllers; the ST-01 is also supported by
 	  this driver.  It is explained in section 3.9 of the SCSI-HOWTO,
@@ -1194,7 +1194,7 @@ config SCSI_SEAGATE
 # definitely looks not 64bit safe:
 config SCSI_SIM710
 	tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
-	depends on (EISA || MCA) && SCSI
+	depends on EISA || MCA
 	---help---
 	  This driver for NCR53c710 based SCSI host adapters.
 
@@ -1207,7 +1207,7 @@ config 53C700_IO_MAPPED
 
 config SCSI_SYM53C416
 	tristate "Symbios 53c416 SCSI support"
-	depends on ISA && SCSI
+	depends on ISA
 	---help---
 	  This is support for the sym53c416 SCSI host adapter, the SCSI
 	  adapter that comes with some HP scanners. This driver requires that
@@ -1225,7 +1225,7 @@ config SCSI_SYM53C416
 
 config SCSI_DC395x
 	tristate "Tekram DC395(U/UW/F) and DC315(U) SCSI support (EXPERIMENTAL)"
-	depends on PCI && SCSI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL
 	---help---
 	  This driver supports PCI SCSI host adapters based on the ASIC
 	  TRM-S1040 chip, e.g Tekram DC395(U/UW/F) and DC315(U) variants.
@@ -1240,7 +1240,7 @@ config SCSI_DC395x
 
 config SCSI_DC390T
 	tristate "Tekram DC390(T) and Am53/79C974 SCSI support"
-	depends on PCI && SCSI
+	depends on PCI
 	---help---
 	  This driver supports PCI SCSI host adapters based on the Am53C974A
 	  chip, e.g. Tekram DC390(T), DawiControl 2974 and some onboard
@@ -1275,7 +1275,7 @@ config SCSI_DC390T_NOGENSUPP
 
 config SCSI_T128
 	tristate "Trantor T128/T128F/T228 SCSI support"
-	depends on ISA && SCSI
+	depends on ISA
 	---help---
 	  This is support for a SCSI host adapter. It is explained in section
 	  3.11 of the SCSI-HOWTO, available from
@@ -1290,7 +1290,7 @@ config SCSI_T128
 
 config SCSI_U14_34F
 	tristate "UltraStor 14F/34F support"
-	depends on ISA && SCSI
+	depends on ISA
 	---help---
 	  This is support for the UltraStor 14F and 34F SCSI-2 host adapters.
 	  The source at <file:drivers/scsi/u14-34f.c> contains some
@@ -1339,7 +1339,7 @@ config SCSI_U14_34F_MAX_TAGS
 
 config SCSI_ULTRASTOR
 	tristate "UltraStor SCSI support"
-	depends on X86 && ISA && SCSI
+	depends on X86 && ISA
 	---help---
 	  This is support for the UltraStor 14F, 24F and 34F SCSI-2 host
 	  adapter family.  This driver is explained in section 3.12 of the
@@ -1356,7 +1356,7 @@ config SCSI_ULTRASTOR
 
 config SCSI_NSP32
 	tristate "Workbit NinjaSCSI-32Bi/UDE support"
-	depends on PCI && SCSI && !64BIT
+	depends on PCI
 	help
 	  This is support for the Workbit NinjaSCSI-32Bi/UDE PCI/Cardbus
 	  SCSI host adapter. Please read the SCSI-HOWTO, available from
@@ -1367,7 +1367,6 @@ config SCSI_NSP32
 
 config SCSI_DEBUG
 	tristate "SCSI debugging host simulator"
-	depends on SCSI
 	help
 	  This is a host adapter simulator that can simulate multiple hosts
 	  each with multiple dummy SCSI devices (disks). It defaults to one
@@ -1380,7 +1379,7 @@ config SCSI_DEBUG
 
 config SCSI_MESH
 	tristate "MESH (Power Mac internal SCSI) support"
-	depends on PPC_PMAC && SCSI
+	depends on PPC_PMAC
 	help
 	  Many Power Macintoshes and clones have a MESH (Macintosh Enhanced
 	  SCSI Hardware) SCSI bus adaptor (the 7200 doesn't, but all of the
@@ -1411,7 +1410,7 @@ config SCSI_MESH_RESET_DELAY_MS
 
 config SCSI_MAC53C94
 	tristate "53C94 (Power Mac external SCSI) support"
-	depends on PPC_PMAC && SCSI
+	depends on PPC_PMAC
 	help
 	  On Power Macintoshes (and clones) with two SCSI buses, the external
 	  SCSI bus is usually controlled by a 53C94 SCSI bus adaptor. Older
@@ -1425,7 +1424,7 @@ source "drivers/scsi/arm/Kconfig"
 
 config JAZZ_ESP
 	bool "MIPS JAZZ FAS216 SCSI support"
-	depends on MIPS_JAZZ && SCSI
+	depends on MIPS_JAZZ
 	help
 	  This is the driver for the onboard SCSI host adapter of MIPS Magnum
 	  4000, Acer PICA, Olivetti M700-10 and a few other identical OEM
@@ -1433,7 +1432,7 @@ config JAZZ_ESP
 
 config A3000_SCSI
 	tristate "A3000 WD33C93A support"
-	depends on AMIGA && SCSI
+	depends on AMIGA
 	help
 	  If you have an Amiga 3000 and have SCSI devices connected to the
 	  built-in SCSI controller, say Y. Otherwise, say N.
@@ -1443,7 +1442,7 @@ config A3000_SCSI
 
 config A2091_SCSI
 	tristate "A2091/A590 WD33C93A support"
-	depends on ZORRO && SCSI
+	depends on ZORRO
 	help
 	  If you have a Commodore A2091 SCSI controller, say Y. Otherwise,
 	  say N.
@@ -1453,7 +1452,7 @@ config A2091_SCSI
 
 config GVP11_SCSI
 	tristate "GVP Series II WD33C93A support"
-	depends on ZORRO && SCSI
+	depends on ZORRO
 	---help---
 	  If you have a Great Valley Products Series II SCSI controller,
 	  answer Y. Also say Y if you have a later model of GVP SCSI
@@ -1466,7 +1465,7 @@ config GVP11_SCSI
 
 config CYBERSTORM_SCSI
 	tristate "CyberStorm SCSI support"
-	depends on ZORRO && SCSI
+	depends on ZORRO
 	help
 	  If you have an Amiga with an original (MkI) Phase5 Cyberstorm
 	  accelerator board and the optional Cyberstorm SCSI controller,
@@ -1474,7 +1473,7 @@ config CYBERSTORM_SCSI
 
 config CYBERSTORMII_SCSI
 	tristate "CyberStorm Mk II SCSI support"
-	depends on ZORRO && SCSI
+	depends on ZORRO
 	help
 	  If you have an Amiga with a Phase5 Cyberstorm MkII accelerator board
 	  and the optional Cyberstorm SCSI controller, say Y. Otherwise,
@@ -1482,7 +1481,7 @@ config CYBERSTORMII_SCSI
 
 config BLZ2060_SCSI
 	tristate "Blizzard 2060 SCSI support"
-	depends on ZORRO && SCSI
+	depends on ZORRO
 	help
 	  If you have an Amiga with a Phase5 Blizzard 2060 accelerator board
 	  and want to use the onboard SCSI controller, say Y. Otherwise,
@@ -1490,7 +1489,7 @@ config BLZ2060_SCSI
 
 config BLZ1230_SCSI
 	tristate "Blizzard 1230IV/1260 SCSI support"
-	depends on ZORRO && SCSI
+	depends on ZORRO
 	help
 	  If you have an Amiga 1200 with a Phase5 Blizzard 1230IV or Blizzard
 	  1260 accelerator, and the optional SCSI module, say Y. Otherwise,
@@ -1498,14 +1497,14 @@ config BLZ1230_SCSI
 
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
@@ -1524,7 +1523,7 @@ config SCSI_AMIGA7XX
 
 config OKTAGON_SCSI
 	tristate "BSC Oktagon SCSI support (EXPERIMENTAL)"
-	depends on ZORRO && SCSI && EXPERIMENTAL
+	depends on ZORRO && EXPERIMENTAL
 	help
 	  If you have the BSC Oktagon SCSI disk controller for the Amiga, say
 	  Y to this question.  If you're in doubt about whether you have one,
@@ -1533,7 +1532,7 @@ config OKTAGON_SCSI
 
 config ATARI_SCSI
 	tristate "Atari native SCSI support"
-	depends on ATARI && SCSI && BROKEN
+	depends on ATARI && BROKEN
 	---help---
 	  If you have an Atari with built-in NCR5380 SCSI controller (TT,
 	  Falcon, ...) say Y to get it supported. Of course also, if you have
@@ -1574,7 +1573,7 @@ config TT_DMA_EMUL
 
 config MAC_SCSI
 	bool "Macintosh NCR5380 SCSI"
-	depends on MAC && SCSI
+	depends on MAC
 	help
 	  This is the NCR 5380 SCSI controller included on most of the 68030
 	  based Macintoshes.  If you have one of these say Y and read the
@@ -1583,7 +1582,7 @@ config MAC_SCSI
 
 config SCSI_MAC_ESP
 	tristate "Macintosh NCR53c9[46] SCSI"
-	depends on MAC && SCSI
+	depends on MAC
 	help
 	  This is the NCR 53c9x SCSI controller found on most of the 68040
 	  based Macintoshes.  If you have one of these say Y and read the
@@ -1595,14 +1594,14 @@ config SCSI_MAC_ESP
 
 config MVME147_SCSI
 	bool "WD33C93 SCSI driver for MVME147"
-	depends on MVME147 && SCSI
+	depends on MVME147
 	help
 	  Support for the on-board SCSI controller on the Motorola MVME147
 	  single-board computer.
 
 config MVME16x_SCSI
 	bool "NCR53C710 SCSI driver for MVME16x"
-	depends on MVME16x && SCSI && BROKEN
+	depends on MVME16x && BROKEN
 	help
 	  The Motorola MVME162, 166, 167, 172 and 177 boards use the NCR53C710
 	  SCSI controller chip.  Almost everyone using one of these boards
@@ -1610,7 +1609,7 @@ config MVME16x_SCSI
 
 config BVME6000_SCSI
 	bool "NCR53C710 SCSI driver for BVME6000"
-	depends on BVME6000 && SCSI && BROKEN
+	depends on BVME6000 && BROKEN
 	help
 	  The BVME4000 and BVME6000 boards from BVM Ltd use the NCR53C710
 	  SCSI controller chip.  Almost everyone using one of these boards
@@ -1626,7 +1625,7 @@ config SCSI_NCR53C7xx_FAST
 
 config SUN3_SCSI
 	tristate "Sun3 NCR5380 SCSI"
-	depends on SUN3 && SCSI
+	depends on SUN3
 	help
 	  This option will enable support for the OBIO (onboard io) NCR5380
 	  SCSI controller found in the Sun 3/50 and 3/60, as well as for
@@ -1636,14 +1635,14 @@ config SUN3_SCSI
 
 config SUN3X_ESP
 	bool "Sun3x ESP SCSI"
-	depends on SUN3X && SCSI
+	depends on SUN3X
 	help
 	  The ESP was an on-board SCSI controller used on Sun 3/80
 	  machines.  Say Y here to compile in support for it.
 
 config SCSI_SUNESP
 	tristate "Sparc ESP Scsi Driver"
-	depends on SBUS && SCSI
+	depends on SBUS
 	help
 	  This is the driver for the Sun ESP SCSI host adapter. The ESP
 	  chipset is present in most SPARC SBUS-based computers.
@@ -1653,7 +1652,7 @@ config SCSI_SUNESP
 
 config SCSI_PC980155
 	tristate "NEC PC-9801-55 SCSI support"
-	depends on X86_PC9800 && SCSI
+	depends on X86_PC9800
 	help
 	  If you have the NEC PC-9801-55 SCSI interface card or compatibles
 	  for NEC PC-9801/PC-9821, say Y.
@@ -1667,7 +1666,7 @@ config WD33C93_PIO
 
 config ZFCP
 	tristate "IBM z900 OpenFCP/SCSI support"
-	depends on ARCH_S390 && SCSI
+	depends on ARCH_S390
 
 endmenu
 
Index: drivers/scsi/pcmcia/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/pcmcia/Kconfig,v
retrieving revision 1.5
diff -u -p -r1.5 Kconfig
--- a/drivers/scsi/pcmcia/Kconfig	7 Jan 2004 21:30:32 -0000	1.5
+++ b/drivers/scsi/pcmcia/Kconfig	11 Feb 2004 19:31:44 -0000
@@ -3,7 +3,7 @@
 #
 
 menu "PCMCIA SCSI adapter support"
-	depends on SCSI!=n && PCMCIA!=n && MODULES
+	depends on SCSI && PCMCIA && MODULES
 
 config PCMCIA_AHA152X
 	tristate "Adaptec AHA152X PCMCIA support"

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
