From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH/RFC] scsi LLD alpha ordering
Date: Sun, 27 Jun 2004 12:41:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040627124106.0bcdf020.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:35998 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262080AbUF0Tqu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jun 2004 15:46:50 -0400
Received: from midway.verizon.net (build.pdx.osdl.net [172.20.1.2])
	by mail.osdl.org (8.11.6/8.11.6) with SMTP id i5RJklZ12114
	for <linux-scsi@vger.kernel.org>; Sun, 27 Jun 2004 12:46:47 -0700
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>


linux-267-bk10

1.  Puts SCSI drivers in more alpha order, but not totally,
because some of the platform-specific drivers are still grouped
together.
2.  scsi/arm/Kconfig used a comment:
  "The following drivers are not fully supported"
This patch adds an ending comment:
  "End of drivers not fully supported"
so that someone reading the menu can know the end of the
unsupported drivers list.
3.  Adds a "Platform/Machine-specific drivers" comment before
the platform-specific drivers are lsited.

Signed-off-by: Randy Dunlap <rddunlap@osdl.org>


diffstat:=
 drivers/scsi/Kconfig     |  585 +++++++++++++++++++++++------------------------
 drivers/scsi/arm/Kconfig |    3 
 2 files changed, 297 insertions(+), 291 deletions(-)

diff -Naurp ./drivers/scsi/arm/Kconfig~scsi_menu ./drivers/scsi/arm/Kconfig
--- ./drivers/scsi/arm/Kconfig~scsi_menu	2004-06-15 22:18:58.000000000 -0700
+++ ./drivers/scsi/arm/Kconfig	2004-06-27 11:48:29.000000000 -0700
@@ -87,3 +87,6 @@ config SCSI_OAK1
 	  This enables support for the Oak SCSI card. If you have an Acorn
 	  system with one of these, say Y. If unsure, say N.
 
+comment "End of drivers not fully supported"
+	depends on ARCH_ACORN && EXPERIMENTAL
+
diff -Naurp ./drivers/scsi/Kconfig~scsi_menu ./drivers/scsi/Kconfig
--- ./drivers/scsi/Kconfig~scsi_menu	2004-06-27 11:46:21.000000000 -0700
+++ ./drivers/scsi/Kconfig	2004-06-27 12:05:45.000000000 -0700
@@ -188,13 +188,6 @@ config SCSI_LOGGING
 menu "SCSI Transport Attributes"
 	depends on SCSI
 
-config SCSI_SPI_ATTRS
-	tristate "Parallel SCSI (SPI) Transport Attributes"
-	depends on SCSI
-	help
-	  If you wish to export transport-specific information about
-	  each attached SCSI device to sysfs, say Y.  Otherwise, say N.
-
 config SCSI_FC_ATTRS
 	tristate "FiberChannel Transport Attributes"
 	depends on SCSI
@@ -203,29 +196,18 @@ config SCSI_FC_ATTRS
 	  each attached FiberChannel device to sysfs, say Y.
 	  Otherwise, say N.
 
+config SCSI_SPI_ATTRS
+	tristate "Parallel SCSI (SPI) Transport Attributes"
+	depends on SCSI
+	help
+	  If you wish to export transport-specific information about
+	  each attached SCSI device to sysfs, say Y.  Otherwise, say N.
+
 endmenu
 
 menu "SCSI low-level drivers"
 	depends on SCSI!=n
 
-config SGIWD93_SCSI
-	tristate "SGI WD93C93 SCSI Driver"
-	depends on SGI_IP22 && SCSI
-  	help
-	  If you have a Western Digital WD93 SCSI controller on
-	  an SGI MIPS system, say Y.  Otherwise, say N.
-
-config SCSI_DECNCR
-	tristate "DEC NCR53C94 Scsi Driver"
-	depends on DECSTATION && TC && SCSI
-	help
-	  Say Y here to support the NCR53C94 SCSI controller chips on IOASIC
-	  based TURBOchannel DECstations and TURBOchannel PMAZ-A cards.
-
-config SCSI_DECSII
-	tristate "DEC SII Scsi Driver"
-	depends on DECSTATION && SCSI
-
 config BLK_DEV_3W_XXXX_RAID
 	tristate "3ware 5/6/7/8xxx ATA-RAID support"
 	depends on PCI && SCSI
@@ -250,17 +232,6 @@ config SCSI_3W_9XXX
 	  Please read the comments at the top of
 	  <file:drivers/scsi/3w-9xxx.c>.
 
-config SCSI_7000FASST
-	tristate "7000FASST SCSI support"
-	depends on ISA && SCSI
-	help
-	  This driver supports the Western Digital 7000 SCSI host adapter
-	  family.  Some information is in the source:
-	  <file:drivers/scsi/wd7000.c>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called wd7000.
-
 config SCSI_ACARD
 	tristate "ACARD SCSI support"
 	depends on PCI && SCSI
@@ -405,90 +376,6 @@ config SCSI_MEGARAID
 	  To compile this driver as a module, choose M here: the
 	  module will be called megaraid.
 
-config SCSI_SATA
-	bool "Serial ATA (SATA) support"
-	depends on SCSI && EXPERIMENTAL
-	help
-	  This driver family supports Serial ATA host controllers
-	  and devices.
-
-	  If unsure, say N.
-
-config SCSI_SATA_SVW
-	tristate "ServerWorks Frodo / Apple K2 SATA support (EXPERIMENTAL)"
-	depends on SCSI_SATA && PCI && EXPERIMENTAL
-	help
-	  This option enables support for Broadcom/Serverworks/Apple K2
-	  SATA support.
-
-	  If unsure, say N.
-
-config SCSI_ATA_PIIX
-	tristate "Intel PIIX/ICH SATA support"
-	depends on SCSI_SATA && PCI
-	help
-	  This option enables support for ICH5 Serial ATA.
-	  If PATA support was enabled previously, this enables
-	  support for select Intel PIIX/ICH PATA host controllers.
-
-	  If unsure, say N.
-
-config SCSI_SATA_NV
-	tristate "NVIDIA SATA support"
-	depends on SCSI_SATA && PCI && EXPERIMENTAL
-	help
-	  This option enables support for NVIDIA Serial ATA.
-
-	  If unsure, say N.
-
-config SCSI_SATA_PROMISE
-	tristate "Promise SATA TX2/TX4 support"
-	depends on SCSI_SATA && PCI
-	help
-	  This option enables support for Promise Serial ATA TX2/TX4.
-
-	  If unsure, say N.
-
-config SCSI_SATA_SX4
-	tristate "Promise SATA SX4 support"
-	depends on SCSI_SATA && PCI && EXPERIMENTAL
-	help
-	  This option enables support for Promise Serial ATA SX4.
-
-	  If unsure, say N.
-
-config SCSI_SATA_SIL
-	tristate "Silicon Image SATA support"
-	depends on SCSI_SATA && PCI && EXPERIMENTAL
-	help
-	  This option enables support for Silicon Image Serial ATA.
-
-	  If unsure, say N.
-
-config SCSI_SATA_SIS
-	tristate "SiS 964/180 SATA support"
-	depends on SCSI_SATA && PCI
-	help
-	  This option enables support for SiS Serial ATA 964/180.
-
-	  If unsure, say N.
-
-config SCSI_SATA_VIA
-	tristate "VIA SATA support"
-	depends on SCSI_SATA && PCI && EXPERIMENTAL
-	help
-	  This option enables support for VIA Serial ATA.
-
-	  If unsure, say N.
-
-config SCSI_SATA_VITESSE
-	tristate "VITESSE VSC-7174 SATA support"
-	depends on SCSI_SATA && PCI && EXPERIMENTAL
-	help
-	  This option enables support for Vitesse VSC7174 Serial ATA.
-
-	  If unsure, say N.
-
 config SCSI_BUSLOGIC
 	tristate "BusLogic SCSI support"
 	depends on (PCI || ISA || MCA) && SCSI
@@ -639,20 +526,6 @@ config SCSI_FD_MCS
 	  To compile this driver as a module, choose M here: the
 	  module will be called fd_mcs.
 
-config SCSI_GDTH
-	tristate "Intel/ICP (former GDT SCSI Disk Array) RAID Controller support"
-	depends on (ISA || EISA || PCI) && SCSI
-	---help---
-	  Formerly called GDT SCSI Disk Array Controller Support.
-
-	  This is a driver for RAID/SCSI Disk Array Controllers (EISA/ISA/PCI) 
-	  manufactured by Intel Corporation/ICP vortex GmbH. It is documented
-	  in the kernel source in <file:drivers/scsi/gdth.c> and
-	  <file:drivers/scsi/gdth.h.>
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called gdth.
-
 config SCSI_GENERIC_NCR5380
 	tristate "Generic NCR5380/53c400 SCSI PIO support"
 	depends on ISA && SCSI
@@ -697,6 +570,25 @@ config SCSI_GENERIC_NCR53C400
 	  not detect your card.  See the file
 	  <file:Documentation/scsi/g_NCR5380.txt> for details.
 
+config SCSI_LASI700
+	tristate "HP Lasi SCSI support for 53c700/710"
+	depends on GSC && SCSI
+	select SCSI_SPI_ATTRS
+	help
+	  This is a driver for the SCSI controller in the Lasi chip found in
+	  many PA-RISC workstations & servers.  If you do not know whether you
+	  have a Lasi chip, it is safe to say "Y" here.
+
+config 53C700_MEM_MAPPED
+	bool
+	depends on SCSI_LASI700
+	default y
+
+config 53C700_LE_ON_BE
+	bool
+	depends on SCSI_LASI700
+	default y
+
 config SCSI_IBMMCA
 	tristate "IBMMCA SCSI support"
 	depends on MCA && SCSI
@@ -767,6 +659,31 @@ config IBMMCA_SCSI_DEV_RESET
 	  you know that one of your older devices needs it; N is the safe
 	  answer.
 
+config SCSI_IPR
+	tristate "IBM Power Linux RAID adapter support"
+	depends on PCI && SCSI
+	select FW_LOADER
+	---help---
+	  This driver supports the IBM Power Linux family RAID adapters.
+	  This includes IBM pSeries 5712, 5703, 5709, and 570A, as well
+	  as IBM iSeries 5702, 5703, 5709, and 570A.
+
+config SCSI_IPR_TRACE
+	bool "enable driver internal trace"
+	depends on SCSI_IPR
+	help
+	  If you say Y here, the driver will trace all commands issued
+	  to the adapter. Performance impact is minimal. Trace can be
+	  dumped using /sys/bus/class/scsi_host/hostXX/trace.
+
+config SCSI_IPR_DUMP
+	bool "enable adapter dump support"
+	depends on SCSI_IPR
+	help
+	  If you say Y here, the driver will support adapter crash dump.
+	  If you enable this support, the iprdump daemon can be used
+	  to capture adapter failure analysis information.
+
 config SCSI_IPS
 	tristate "IBM ServeRAID support"
 	depends on PCI && SCSI
@@ -802,6 +719,20 @@ config SCSI_INIA100
 	  To compile this driver as a module, choose M here: the
 	  module will be called a100u2w.
 
+config SCSI_GDTH
+	tristate "Intel/ICP (former GDT SCSI Disk Array) RAID Controller support"
+	depends on (ISA || EISA || PCI) && SCSI
+	---help---
+	  Formerly called GDT SCSI Disk Array Controller Support.
+
+	  This is a driver for RAID/SCSI Disk Array Controllers (EISA/ISA/PCI) 
+	  manufactured by Intel Corporation/ICP vortex GmbH. It is documented
+	  in the kernel source in <file:drivers/scsi/gdth.c> and
+	  <file:drivers/scsi/gdth.h.>
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called gdth.
+
 config SCSI_PPA
 	tristate "IOMEGA parallel port (ppa - older drives)"
 	depends on SCSI && PARPORT
@@ -885,144 +816,34 @@ config SCSI_IZIP_SLOW_CTR
 
 	  Generally, saying N is fine.
 
-config SCSI_NCR53C406A
-	tristate "NCR53c406a SCSI support"
-	depends on ISA && SCSI
-	help
-	  This is support for the NCR53c406a SCSI host adapter.  For user
-	  configurable parameters, check out <file:drivers/scsi/NCR53c406a.c>
-	  in the kernel source.  Also read the SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called NCR53c406.
-
-config SCSI_NCR_D700
-	tristate "NCR Dual 700 MCA SCSI support"
-	depends on MCA && SCSI
-	select SCSI_SPI_ATTRS
-	help
-	  This is a driver for the MicroChannel Dual 700 card produced by
-	  NCR and commonly used in 345x/35xx/4100 class machines.  It always
-	  tries to negotiate sync and uses tag command queueing.
-
-	  Unless you have an NCR manufactured machine, the chances are that
-	  you do not have this SCSI card, so say N.
-
-config 53C700_IO_MAPPED
-	bool
-	depends on SCSI_NCR_D700
-	default y
-
-config SCSI_LASI700
-	tristate "HP Lasi SCSI support for 53c700/710"
-	depends on GSC && SCSI
-	select SCSI_SPI_ATTRS
-	help
-	  This is a driver for the SCSI controller in the Lasi chip found in
-	  many PA-RISC workstations & servers.  If you do not know whether you
-	  have a Lasi chip, it is safe to say "Y" here.
-
-config 53C700_MEM_MAPPED
-	bool
-	depends on SCSI_LASI700
-	default y
-
-config 53C700_LE_ON_BE
-	bool
-	depends on SCSI_LASI700
-	default y
-
-config SCSI_SYM53C8XX_2
-	tristate "SYM53C8XX Version 2 SCSI support"
-	depends on PCI && SCSI
-	select SCSI_SPI_ATTRS
-	---help---
-	  This driver supports the whole NCR53C8XX/SYM53C8XX family of
-	  PCI-SCSI controllers.  It also supports the subset of LSI53C10XX
-	  Ultra-160 controllers that are based on the SYM53C8XX SCRIPTS
-	  language.  It does not support LSI53C10XX Ultra-320 PCI-X SCSI
-	  controllers; you need to use the Fusion MPT driver for that.
-
-	  Please read <file:Documentation/scsi/sym53c8xx_2.txt> for more
-	  information.
-
-config SCSI_SYM53C8XX_DMA_ADDRESSING_MODE
-	int "DMA addressing mode"
-	depends on SCSI_SYM53C8XX_2
-	default "1"
-	---help---
-	  This option only applies to PCI-SCSI chips that are PCI DAC
-	  capable (875A, 895A, 896, 1010-33, 1010-66, 1000).
-
-	  When set to 0, the driver will program the chip to only perform
-	  32-bit DMA.  When set to 1, the chip will be able to perform DMA
-	  to addresses up to 1TB.  When set to 2, the driver supports the
-	  full 64-bit DMA address range, but can only address 16 segments
-	  of 4 GB each.  This limits the total addressable range to 64 GB.
-
-	  Most machines with less than 4GB of memory should use a setting
-	  of 0 for best performance.  If your machine has 4GB of memory
-	  or more, you should set this option to 1 (the default).
-
-	  The still experimental value 2 (64 bit DMA addressing with 16
-	  x 4GB segments limitation) can be used on systems that require
-	  PCI address bits past bit 39 to be set for the addressing of
-	  memory using PCI DAC cycles.
-
-config SCSI_SYM53C8XX_DEFAULT_TAGS
-	int "default tagged command queue depth"
-	depends on SCSI_SYM53C8XX_2
-	default "16"
-	help
-	  This is the default value of the command queue depth the
-	  driver will announce to the generic SCSI layer for devices
-	  that support tagged command queueing. This value can be changed
-	  from the boot command line.  This is a soft limit that cannot
-	  exceed CONFIG_SCSI_SYM53C8XX_MAX_TAGS.
-
-config SCSI_SYM53C8XX_MAX_TAGS
-	int "maximum number of queued commands"
-	depends on SCSI_SYM53C8XX_2
-	default "64"
-	help
-	  This option allows you to specify the maximum number of commands
-	  that can be queued to any device, when tagged command queuing is
-	  possible. The driver supports up to 256 queued commands per device.
-	  This value is used as a compiled-in hard limit.
-
-config SCSI_SYM53C8XX_IOMAPPED
-	bool "use port IO"
-	depends on SCSI_SYM53C8XX_2
-	help
-	  If you say Y here, the driver will use port IO to access
-	  the card.  This is significantly slower then using memory
-	  mapped IO.  Most people should answer N.
-
-config SCSI_IPR
-	tristate "IBM Power Linux RAID adapter support"
-	depends on PCI && SCSI
-	select FW_LOADER
-	---help---
-	  This driver supports the IBM Power Linux family RAID adapters.
-	  This includes IBM pSeries 5712, 5703, 5709, and 570A, as well
-	  as IBM iSeries 5702, 5703, 5709, and 570A.
-
-config SCSI_IPR_TRACE
-	bool "enable driver internal trace"
-	depends on SCSI_IPR
+config SCSI_NCR53C406A
+	tristate "NCR53c406a SCSI support"
+	depends on ISA && SCSI
 	help
-	  If you say Y here, the driver will trace all commands issued
-	  to the adapter. Performance impact is minimal. Trace can be
-	  dumped using /sys/bus/class/scsi_host/hostXX/trace.
+	  This is support for the NCR53c406a SCSI host adapter.  For user
+	  configurable parameters, check out <file:drivers/scsi/NCR53c406a.c>
+	  in the kernel source.  Also read the SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.
 
-config SCSI_IPR_DUMP
-	bool "enable adapter dump support"
-	depends on SCSI_IPR
+	  To compile this driver as a module, choose M here: the
+	  module will be called NCR53c406.
+
+config SCSI_NCR_D700
+	tristate "NCR Dual 700 MCA SCSI support"
+	depends on MCA && SCSI
+	select SCSI_SPI_ATTRS
 	help
-	  If you say Y here, the driver will support adapter crash dump.
-	  If you enable this support, the iprdump daemon can be used
-	  to capture adapter failure analysis information.
+	  This is a driver for the MicroChannel Dual 700 card produced by
+	  NCR and commonly used in 345x/35xx/4100 class machines.  It always
+	  tries to negotiate sync and uses tag command queueing.
+
+	  Unless you have an NCR manufactured machine, the chances are that
+	  you do not have this SCSI card, so say N.
+
+config 53C700_IO_MAPPED
+	bool
+	depends on SCSI_NCR_D700
+	default y
 
 config SCSI_ZALON
 	tristate "Zalon SCSI support"
@@ -1255,17 +1076,8 @@ config SCSI_QLOGIC_FC_FIRMWARE
 	  expanded LUN addressing and FcTape (FCP-2) support, in the
 	  qlogicfc driver. This is required on some platforms.
 
-config SCSI_QLOGIC_1280
-	tristate "Qlogic QLA 1280 SCSI support"
-	depends on PCI && SCSI
-	help
-	  Say Y if you have a QLogic ISP1x80/1x160 SCSI host adapter.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called qla1280.
-
 config SCSI_QLOGICPTI
-	tristate "PTI Qlogic, ISP Driver"
+	tristate "Qlogic/PTI, ISP Driver"
 	depends on SBUS && SCSI
 	help
 	  This driver supports SBUS SCSI controllers from PTI or QLogic. These
@@ -1276,6 +1088,15 @@ config SCSI_QLOGICPTI
 	  To compile this driver as a module, choose M here: the
 	  module will be called qlogicpti.
 
+config SCSI_QLOGIC_1280
+	tristate "Qlogic QLA 1280 SCSI support"
+	depends on PCI && SCSI
+	help
+	  Say Y if you have a QLogic ISP1x80/1x160 SCSI host adapter.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called qla1280.
+
 source "drivers/scsi/qla2xxx/Kconfig"
 
 config SCSI_SEAGATE
@@ -1291,6 +1112,97 @@ config SCSI_SEAGATE
 	  To compile this driver as a module, choose M here: the
 	  module will be called seagate.
 
+config SCSI_SATA
+	bool "Serial ATA (SATA) support"
+	depends on SCSI && EXPERIMENTAL
+	help
+	  This driver family supports Serial ATA host controllers
+	  and devices.
+
+	  If unsure, say N.
+
+config SCSI_SATA_SVW
+	tristate "ServerWorks Frodo / Apple K2 SATA support (EXPERIMENTAL)"
+	depends on SCSI_SATA && PCI && EXPERIMENTAL
+	help
+	  This option enables support for Broadcom/Serverworks/Apple K2
+	  SATA support.
+
+	  If unsure, say N.
+
+config SCSI_ATA_PIIX
+	tristate "Intel PIIX/ICH SATA support"
+	depends on SCSI_SATA && PCI
+	help
+	  This option enables support for ICH5 Serial ATA.
+	  If PATA support was enabled previously, this enables
+	  support for select Intel PIIX/ICH PATA host controllers.
+
+	  If unsure, say N.
+
+config SCSI_SATA_NV
+	tristate "NVIDIA SATA support"
+	depends on SCSI_SATA && PCI && EXPERIMENTAL
+	help
+	  This option enables support for NVIDIA Serial ATA.
+
+	  If unsure, say N.
+
+config SCSI_SATA_PROMISE
+	tristate "Promise SATA TX2/TX4 support"
+	depends on SCSI_SATA && PCI
+	help
+	  This option enables support for Promise Serial ATA TX2/TX4.
+
+	  If unsure, say N.
+
+config SCSI_SATA_SX4
+	tristate "Promise SATA SX4 support"
+	depends on SCSI_SATA && PCI && EXPERIMENTAL
+	help
+	  This option enables support for Promise Serial ATA SX4.
+
+	  If unsure, say N.
+
+config SCSI_SATA_SIL
+	tristate "Silicon Image SATA support"
+	depends on SCSI_SATA && PCI && EXPERIMENTAL
+	help
+	  This option enables support for Silicon Image Serial ATA.
+
+	  If unsure, say N.
+
+config SCSI_SATA_SIS
+	tristate "SiS 964/180 SATA support"
+	depends on SCSI_SATA && PCI
+	help
+	  This option enables support for SiS Serial ATA 964/180.
+
+	  If unsure, say N.
+
+config SCSI_SATA_VIA
+	tristate "VIA SATA support"
+	depends on SCSI_SATA && PCI && EXPERIMENTAL
+	help
+	  This option enables support for VIA Serial ATA.
+
+	  If unsure, say N.
+
+config SCSI_SATA_VITESSE
+	tristate "VITESSE VSC-7174 SATA support"
+	depends on SCSI_SATA && PCI && EXPERIMENTAL
+	help
+	  This option enables support for Vitesse VSC7174 Serial ATA.
+
+	  If unsure, say N.
+
+config SGIWD93_SCSI
+	tristate "SGI WD93C93 SCSI Driver"
+	depends on SGI_IP22 && SCSI
+  	help
+	  If you have a Western Digital WD93 SCSI controller on
+	  an SGI MIPS system, say Y.  Otherwise, say N.
+
 # definitely looks not 64bit safe:
 config SCSI_SIM710
 	tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
@@ -1324,6 +1236,72 @@ config SCSI_SYM53C416
 	  To compile this driver as a module, choose M here: the
 	  module will be called sym53c416.
 
+config SCSI_SYM53C8XX_2
+	tristate "SYM53C8XX Version 2 SCSI support"
+	depends on PCI && SCSI
+	select SCSI_SPI_ATTRS
+	---help---
+	  This driver supports the whole NCR53C8XX/SYM53C8XX family of
+	  PCI-SCSI controllers.  It also supports the subset of LSI53C10XX
+	  Ultra-160 controllers that are based on the SYM53C8XX SCRIPTS
+	  language.  It does not support LSI53C10XX Ultra-320 PCI-X SCSI
+	  controllers; you need to use the Fusion MPT driver for that.
+
+	  Please read <file:Documentation/scsi/sym53c8xx_2.txt> for more
+	  information.
+
+config SCSI_SYM53C8XX_DMA_ADDRESSING_MODE
+	int "DMA addressing mode"
+	depends on SCSI_SYM53C8XX_2
+	default "1"
+	---help---
+	  This option only applies to PCI-SCSI chips that are PCI DAC
+	  capable (875A, 895A, 896, 1010-33, 1010-66, 1000).
+
+	  When set to 0, the driver will program the chip to only perform
+	  32-bit DMA.  When set to 1, the chip will be able to perform DMA
+	  to addresses up to 1TB.  When set to 2, the driver supports the
+	  full 64-bit DMA address range, but can only address 16 segments
+	  of 4 GB each.  This limits the total addressable range to 64 GB.
+
+	  Most machines with less than 4GB of memory should use a setting
+	  of 0 for best performance.  If your machine has 4GB of memory
+	  or more, you should set this option to 1 (the default).
+
+	  The still experimental value 2 (64 bit DMA addressing with 16
+	  x 4GB segments limitation) can be used on systems that require
+	  PCI address bits past bit 39 to be set for the addressing of
+	  memory using PCI DAC cycles.
+
+config SCSI_SYM53C8XX_DEFAULT_TAGS
+	int "default tagged command queue depth"
+	depends on SCSI_SYM53C8XX_2
+	default "16"
+	help
+	  This is the default value of the command queue depth the
+	  driver will announce to the generic SCSI layer for devices
+	  that support tagged command queueing. This value can be changed
+	  from the boot command line.  This is a soft limit that cannot
+	  exceed CONFIG_SCSI_SYM53C8XX_MAX_TAGS.
+
+config SCSI_SYM53C8XX_MAX_TAGS
+	int "maximum number of queued commands"
+	depends on SCSI_SYM53C8XX_2
+	default "64"
+	help
+	  This option allows you to specify the maximum number of commands
+	  that can be queued to any device, when tagged command queuing is
+	  possible. The driver supports up to 256 queued commands per device.
+	  This value is used as a compiled-in hard limit.
+
+config SCSI_SYM53C8XX_IOMAPPED
+	bool "use port IO"
+	depends on SCSI_SYM53C8XX_2
+	help
+	  If you say Y here, the driver will use port IO to access
+	  the card.  This is significantly slower then using memory
+	  mapped IO.  Most people should answer N.
+
 config SCSI_DC395x
 	tristate "Tekram DC395(U/UW/F) and DC315(U) SCSI support (EXPERIMENTAL)"
 	depends on PCI && SCSI && EXPERIMENTAL
@@ -1436,6 +1414,17 @@ config SCSI_ULTRASTOR
 	  To compile this driver as a module, choose M here: the
 	  module will be called ultrastor.
 
+config SCSI_7000FASST
+	tristate "WD7000-FASST SCSI support"
+	depends on ISA && SCSI
+	help
+	  This driver supports the Western Digital 7000 SCSI host adapter
+	  family.  Some information is in the source:
+	  <file:drivers/scsi/wd7000.c>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wd7000.
+
 config SCSI_NSP32
 	tristate "Workbit NinjaSCSI-32Bi/UDE support"
 	depends on PCI && SCSI && !64BIT
@@ -1460,6 +1449,22 @@ config SCSI_DEBUG
 	  information. This driver is primarily of use to those testing the
 	  SCSI and block subsystems. If unsure, say N.
 
+comment "--- Platform/Machine-specific drivers ---"
+	depends on SCSI
+
+source "drivers/scsi/arm/Kconfig"
+
+config SCSI_DECNCR
+	tristate "DEC NCR53C94 Scsi Driver"
+	depends on DECSTATION && TC && SCSI
+	help
+	  Say Y here to support the NCR53C94 SCSI controller chips on IOASIC
+	  based TURBOchannel DECstations and TURBOchannel PMAZ-A cards.
+
+config SCSI_DECSII
+	tristate "DEC SII Scsi Driver"
+	depends on DECSTATION && SCSI
+
 config SCSI_MESH
 	tristate "MESH (Power Mac internal SCSI) support"
 	depends on PPC_PMAC && SCSI
@@ -1503,8 +1508,6 @@ config SCSI_MAC53C94
 	  To compile this driver as a module, choose M here: the
 	  module will be called mac53c94.
 
-source "drivers/scsi/arm/Kconfig"
-
 config JAZZ_ESP
 	bool "MIPS JAZZ FAS216 SCSI support"
 	depends on MIPS_JAZZ && SCSI
@@ -1706,6 +1709,16 @@ config SCSI_NCR53C7xx_FAST
 	  adapter. Some systems have problems with that speed, so it's safest
 	  to say N here.
 
+config SCSI_SUNESP
+	tristate "Sparc ESP Scsi Driver"
+	depends on SBUS && SCSI
+	help
+	  This is the driver for the Sun ESP SCSI host adapter. The ESP
+	  chipset is present in most SPARC SBUS-based computers.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called esp.
+
 config SUN3_SCSI
 	tristate "Sun3 NCR5380 SCSI"
 	depends on SUN3 && SCSI
@@ -1723,16 +1736,6 @@ config SUN3X_ESP
 	  The ESP was an on-board SCSI controller used on Sun 3/80
 	  machines.  Say Y here to compile in support for it.
 
-config SCSI_SUNESP
-	tristate "Sparc ESP Scsi Driver"
-	depends on SBUS && SCSI
-	help
-	  This is the driver for the Sun ESP SCSI host adapter. The ESP
-	  chipset is present in most SPARC SBUS-based computers.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called esp.
-
 #      bool 'Cyberstorm Mk III SCSI support (EXPERIMENTAL)' CONFIG_CYBERSTORMIII_SCSI
 
 config ZFCP


--
