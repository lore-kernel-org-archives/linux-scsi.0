From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH/RFC] scsi LLD menu ordering v2
Date: Mon, 28 Jun 2004 21:29:49 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040628212949.3bb3b208.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:12510 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S265424AbUF2Efp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jun 2004 00:35:45 -0400
Received: from midway.verizon.net (build.pdx.osdl.net [172.20.1.2])
	by mail.osdl.org (8.11.6/8.11.6) with SMTP id i5T4ZdG31781
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jun 2004 21:35:39 -0700
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>


How about this one?


linux-267-bk11

1.  Puts SCSI drivers in more alpha order, but not totally,
because some of the platform-specific drivers are still grouped
together.  Platform-specific drivers are alpha by platform.
Zalon driver is platform-specific but makes more Kconfig sense
by NCR Q720, so there is a note/comment back up to it there.
2.  scsi/arm/Kconfig used a comment:
  "The following drivers are not fully supported"
This patch adds an ending comment:
  "End of drivers not fully supported"
so that someone reading the menu can know the end of the
unsupported drivers list.
3.  Adds "<platform>-specific drivers" comment before
each of the platform-specific drivers sections.
4.  use MACH_JAZZ instead of MIPS_JAZZ for MIPS JAZZ

Signed-off-by: Randy Dunlap <rddunlap@osdl.org>


diffstat:=
 drivers/scsi/Kconfig     |  756 ++++++++++++++++++++++++-----------------------
 drivers/scsi/arm/Kconfig |    6 
 2 files changed, 402 insertions(+), 360 deletions(-)

diff -Naurp ./drivers/scsi/arm/Kconfig~scsi_menu ./drivers/scsi/arm/Kconfig
--- ./drivers/scsi/arm/Kconfig~scsi_menu	2004-06-15 22:18:58.000000000 -0700
+++ ./drivers/scsi/arm/Kconfig	2004-06-28 20:59:22.000000000 -0700
@@ -1,6 +1,9 @@
 #
 # SCSI driver configuration for Acorn
 #
+comment "--- Acorn drivers ---"
+	depends on ARCH_ACORN && SCSI
+
 config SCSI_ACORNSCSI_3
 	tristate "Acorn SCSI card (aka30) support"
 	depends on ARCH_ACORN && SCSI
@@ -87,3 +90,6 @@ config SCSI_OAK1
 	  This enables support for the Oak SCSI card. If you have an Acorn
 	  system with one of these, say Y. If unsure, say N.
 
+comment "End of drivers not fully supported"
+	depends on ARCH_ACORN && EXPERIMENTAL
+
diff -Naurp ./drivers/scsi/Kconfig~scsi_menu ./drivers/scsi/Kconfig
--- ./drivers/scsi/Kconfig~scsi_menu	2004-06-28 20:57:13.000000000 -0700
+++ ./drivers/scsi/Kconfig	2004-06-28 21:14:02.000000000 -0700
@@ -208,24 +208,6 @@ endmenu
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
@@ -767,6 +640,31 @@ config IBMMCA_SCSI_DEV_RESET
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
@@ -802,6 +700,20 @@ config SCSI_INIA100
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
@@ -914,179 +826,69 @@ config 53C700_IO_MAPPED
 	depends on SCSI_NCR_D700
 	default y
 
-config SCSI_LASI700
-	tristate "HP Lasi SCSI support for 53c700/710"
-	depends on GSC && SCSI
-	select SCSI_SPI_ATTRS
+config SCSI_NCR_Q720
+	tristate "NCR Quad 720 MCA SCSI support"
+	depends on MCA && SCSI
 	help
-	  This is a driver for the SCSI controller in the Lasi chip found in
-	  many PA-RISC workstations & servers.  If you do not know whether you
-	  have a Lasi chip, it is safe to say "Y" here.
+	  This is a driver for the MicroChannel Quad 720 card produced by
+	  NCR and commonly used in 345x/35xx/4100 class machines.  It always
+	  tries to negotiate sync and uses tag command queueing.
 
-config 53C700_MEM_MAPPED
-	bool
-	depends on SCSI_LASI700
-	default y
+	  Unless you have an NCR manufactured machine, the chances are that
+	  you do not have this SCSI card, so say N.
 
-config 53C700_LE_ON_BE
-	bool
-	depends on SCSI_LASI700
-	default y
+config SCSI_ZALON
+	tristate "Zalon SCSI support"
+	depends on GSC && SCSI
+	help
+	  The Zalon is a GSC/HSC bus interface chip that sits between the
+	  PA-RISC processor and the NCR 53c720 SCSI controller on C100,
+	  C110, J200, J210 and some D, K & R-class machines.  It's also
+	  used on the add-in Bluefish, Barracuda & Shrike SCSI cards.
+	  Say Y here if you have one of these machines or cards.
 
-config SCSI_SYM53C8XX_2
-	tristate "SYM53C8XX Version 2 SCSI support"
-	depends on PCI && SCSI
-	select SCSI_SPI_ATTRS
+config SCSI_NCR53C8XX_DEFAULT_TAGS
+	int "  default tagged command queue depth"
+	depends on SCSI_ZALON || SCSI_NCR_Q720
+	default "8"
 	---help---
-	  This driver supports the whole NCR53C8XX/SYM53C8XX family of
-	  PCI-SCSI controllers.  It also supports the subset of LSI53C10XX
-	  Ultra-160 controllers that are based on the SYM53C8XX SCRIPTS
-	  language.  It does not support LSI53C10XX Ultra-320 PCI-X SCSI
-	  controllers; you need to use the Fusion MPT driver for that.
+	  "Tagged command queuing" is a feature of SCSI-2 which improves
+	  performance: the host adapter can send several SCSI commands to a
+	  device's queue even if previous commands haven't finished yet.
+	  Because the device is intelligent, it can optimize its operations
+	  (like head positioning) based on its own request queue. Some SCSI
+	  devices don't implement this properly; if you want to disable this
+	  feature, enter 0 or 1 here (it doesn't matter which).
 
-	  Please read <file:Documentation/scsi/sym53c8xx_2.txt> for more
-	  information.
+	  The default value is 8 and should be supported by most hard disks.
+	  This value can be overridden from the boot command line using the
+	  'tags' option as follows (example):
+	  'ncr53c8xx=tags:4/t2t3q16/t0u2q10' will set default queue depth to
+	  4, set queue depth to 16 for target 2 and target 3 on controller 0
+	  and set queue depth to 10 for target 0 / lun 2 on controller 1.
 
-config SCSI_SYM53C8XX_DMA_ADDRESSING_MODE
-	int "DMA addressing mode"
-	depends on SCSI_SYM53C8XX_2
-	default "1"
+	  The normal answer therefore is to go with the default 8 and to use
+	  a boot command line option for devices that need to use a different
+	  command queue depth.
+
+	  There is no safe option other than using good SCSI devices.
+
+config SCSI_NCR53C8XX_MAX_TAGS
+	int "  maximum number of queued commands"
+	depends on SCSI_ZALON || SCSI_NCR_Q720
+	default "32"
 	---help---
-	  This option only applies to PCI-SCSI chips that are PCI DAC
-	  capable (875A, 895A, 896, 1010-33, 1010-66, 1000).
+	  This option allows you to specify the maximum number of commands
+	  that can be queued to any device, when tagged command queuing is
+	  possible. The default value is 32. Minimum is 2, maximum is 64.
+	  Modern hard disks are able to support 64 tags and even more, but
+	  do not seem to be faster when more than 32 tags are being used.
 
-	  When set to 0, the driver will program the chip to only perform
-	  32-bit DMA.  When set to 1, the chip will be able to perform DMA
-	  to addresses up to 1TB.  When set to 2, the driver supports the
-	  full 64-bit DMA address range, but can only address 16 segments
-	  of 4 GB each.  This limits the total addressable range to 64 GB.
+	  So, the normal answer here is to go with the default value 32 unless
+	  you are using very large hard disks with large cache (>= 1 MB) that
+	  are able to take advantage of more than 32 tagged commands.
 
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
-	help
-	  If you say Y here, the driver will trace all commands issued
-	  to the adapter. Performance impact is minimal. Trace can be
-	  dumped using /sys/bus/class/scsi_host/hostXX/trace.
-
-config SCSI_IPR_DUMP
-	bool "enable adapter dump support"
-	depends on SCSI_IPR
-	help
-	  If you say Y here, the driver will support adapter crash dump.
-	  If you enable this support, the iprdump daemon can be used
-	  to capture adapter failure analysis information.
-
-config SCSI_ZALON
-	tristate "Zalon SCSI support"
-	depends on GSC && SCSI
-	help
-	  The Zalon is a GSC/HSC bus interface chip that sits between the
-	  PA-RISC processor and the NCR 53c720 SCSI controller on C100,
-	  C110, J200, J210 and some D, K & R-class machines.  It's also
-	  used on the add-in Bluefish, Barracuda & Shrike SCSI cards.
-	  Say Y here if you have one of these machines or cards.
-
-config SCSI_NCR_Q720
-	tristate "NCR Quad 720 MCA SCSI support"
-	depends on MCA && SCSI
-	help
-	  This is a driver for the MicroChannel Quad 720 card produced by
-	  NCR and commonly used in 345x/35xx/4100 class machines.  It always
-	  tries to negotiate sync and uses tag command queueing.
-
-	  Unless you have an NCR manufactured machine, the chances are that
-	  you do not have this SCSI card, so say N.
-
-config SCSI_NCR53C8XX_DEFAULT_TAGS
-	int "  default tagged command queue depth"
-	depends on SCSI_ZALON || SCSI_NCR_Q720
-	default "8"
-	---help---
-	  "Tagged command queuing" is a feature of SCSI-2 which improves
-	  performance: the host adapter can send several SCSI commands to a
-	  device's queue even if previous commands haven't finished yet.
-	  Because the device is intelligent, it can optimize its operations
-	  (like head positioning) based on its own request queue. Some SCSI
-	  devices don't implement this properly; if you want to disable this
-	  feature, enter 0 or 1 here (it doesn't matter which).
-
-	  The default value is 8 and should be supported by most hard disks.
-	  This value can be overridden from the boot command line using the
-	  'tags' option as follows (example):
-	  'ncr53c8xx=tags:4/t2t3q16/t0u2q10' will set default queue depth to
-	  4, set queue depth to 16 for target 2 and target 3 on controller 0
-	  and set queue depth to 10 for target 0 / lun 2 on controller 1.
-
-	  The normal answer therefore is to go with the default 8 and to use
-	  a boot command line option for devices that need to use a different
-	  command queue depth.
-
-	  There is no safe option other than using good SCSI devices.
-
-config SCSI_NCR53C8XX_MAX_TAGS
-	int "  maximum number of queued commands"
-	depends on SCSI_ZALON || SCSI_NCR_Q720
-	default "32"
-	---help---
-	  This option allows you to specify the maximum number of commands
-	  that can be queued to any device, when tagged command queuing is
-	  possible. The default value is 32. Minimum is 2, maximum is 64.
-	  Modern hard disks are able to support 64 tags and even more, but
-	  do not seem to be faster when more than 32 tags are being used.
-
-	  So, the normal answer here is to go with the default value 32 unless
-	  you are using very large hard disks with large cache (>= 1 MB) that
-	  are able to take advantage of more than 32 tagged commands.
-
-	  There is no safe option and the default answer is recommended.
+	  There is no safe option and the default answer is recommended.
 
 config SCSI_NCR53C8XX_SYNC
 	int "  synchronous transfers frequency in MHz"
@@ -1255,17 +1057,8 @@ config SCSI_QLOGIC_FC_FIRMWARE
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
@@ -1276,6 +1069,15 @@ config SCSI_QLOGICPTI
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
@@ -1291,6 +1093,97 @@ config SCSI_SEAGATE
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
@@ -1324,6 +1217,72 @@ config SCSI_SYM53C416
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
@@ -1436,6 +1395,17 @@ config SCSI_ULTRASTOR
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
@@ -1460,58 +1430,10 @@ config SCSI_DEBUG
 	  information. This driver is primarily of use to those testing the
 	  SCSI and block subsystems. If unsure, say N.
 
-config SCSI_MESH
-	tristate "MESH (Power Mac internal SCSI) support"
-	depends on PPC_PMAC && SCSI
-	help
-	  Many Power Macintoshes and clones have a MESH (Macintosh Enhanced
-	  SCSI Hardware) SCSI bus adaptor (the 7200 doesn't, but all of the
-	  other Power Macintoshes do). Say Y to include support for this SCSI
-	  adaptor.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called mesh.
-
-config SCSI_MESH_SYNC_RATE
-	int "maximum synchronous transfer rate (MB/s) (0 = async)"
-	depends on SCSI_MESH
-	default "5"
-	help
-	  On Power Macintoshes (and clones) where the MESH SCSI bus adaptor
-	  drives a bus which is entirely internal to the machine (such as the
-	  7500, 7600, 8500, etc.), the MESH is capable of synchronous
-	  operation at up to 10 MB/s. On machines where the SCSI bus
-	  controlled by the MESH can have external devices connected, it is
-	  usually rated at 5 MB/s. 5 is a safe value here unless you know the
-	  MESH SCSI bus is internal only; in that case you can say 10. Say 0
-	  to disable synchronous operation.
-
-config SCSI_MESH_RESET_DELAY_MS
-	int "initial bus reset delay (ms) (0 = no reset)"
-	depends on SCSI_MESH
-	default "4000"
-
-config SCSI_MAC53C94
-	tristate "53C94 (Power Mac external SCSI) support"
-	depends on PPC_PMAC && SCSI
-	help
-	  On Power Macintoshes (and clones) with two SCSI buses, the external
-	  SCSI bus is usually controlled by a 53C94 SCSI bus adaptor. Older
-	  machines which only have one SCSI bus, such as the 7200, also use
-	  the 53C94. Say Y to include support for the 53C94.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called mac53c94.
-
 source "drivers/scsi/arm/Kconfig"
 
-config JAZZ_ESP
-	bool "MIPS JAZZ FAS216 SCSI support"
-	depends on MIPS_JAZZ && SCSI
-	help
-	  This is the driver for the onboard SCSI host adapter of MIPS Magnum
-	  4000, Acer PICA, Olivetti M700-10 and a few other identical OEM
-	  systems.
+comment "--- Amiga drivers ---"
+	depends on AMIGA && SCSI
 
 config A3000_SCSI
 	tristate "A3000 WD33C93A support"
@@ -1613,6 +1535,9 @@ config OKTAGON_SCSI
 	  see the picture at
 	  <http://amiga.resource.cx/exp/search.pl?product=oktagon>.
 
+comment "--- Atari drivers ---"
+	depends on ATARI && SCSI
+
 config ATARI_SCSI
 	tristate "Atari native SCSI support"
 	depends on ATARI && SCSI && BROKEN
@@ -1654,6 +1579,48 @@ config TT_DMA_EMUL
 	  Hades. This increases the SCSI transfer rates at least ten times
 	  compared to PIO transfers.
 
+comment "--- DECSTATION drivers ---"
+	depends on DECSTATION && SCSI
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
+comment "--- HP PA-RISC drivers ---"
+	depends on GSC && SCSI
+
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
+comment "Zalon SCSI --- see after NCR Quad 720"
+	depends on GSC && SCSI
+
+comment "--- Macintosh drivers ---"
+	depends on MAC && SCSI
+
 config MAC_SCSI
 	bool "Macintosh NCR5380 SCSI"
 	depends on MAC && SCSI
@@ -1675,6 +1642,20 @@ config SCSI_MAC_ESP
 	  To compile this driver as a module, choose M here: the
 	  module will be called mac_esp.
 
+comment "--- MIPS drivers ---"
+	depends on MACH_JAZZ && SCSI
+
+config JAZZ_ESP
+	bool "MIPS JAZZ FAS216 SCSI support"
+	depends on MACH_JAZZ && SCSI
+	help
+	  This is the driver for the onboard SCSI host adapter of MIPS Magnum
+	  4000, Acer PICA, Olivetti M700-10 and a few other identical OEM
+	  systems.
+
+comment "--- MVME1xx/BVME6000 drivers ---"
+	depends on (MVME147 || MVME16x || BVME6000) && SCSI
+
 config MVME147_SCSI
 	bool "WD33C93 SCSI driver for MVME147"
 	depends on MVME147 && SCSI
@@ -1706,6 +1687,68 @@ config SCSI_NCR53C7xx_FAST
 	  adapter. Some systems have problems with that speed, so it's safest
 	  to say N here.
 
+comment "--- Power Mac drivers ---"
+	depends on PPC_PMAC && SCSI
+
+config SCSI_MESH
+	tristate "MESH (Power Mac internal SCSI) support"
+	depends on PPC_PMAC && SCSI
+	help
+	  Many Power Macintoshes and clones have a MESH (Macintosh Enhanced
+	  SCSI Hardware) SCSI bus adaptor (the 7200 doesn't, but all of the
+	  other Power Macintoshes do). Say Y to include support for this SCSI
+	  adaptor.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mesh.
+
+config SCSI_MESH_SYNC_RATE
+	int "maximum synchronous transfer rate (MB/s) (0 = async)"
+	depends on SCSI_MESH
+	default "5"
+	help
+	  On Power Macintoshes (and clones) where the MESH SCSI bus adaptor
+	  drives a bus which is entirely internal to the machine (such as the
+	  7500, 7600, 8500, etc.), the MESH is capable of synchronous
+	  operation at up to 10 MB/s. On machines where the SCSI bus
+	  controlled by the MESH can have external devices connected, it is
+	  usually rated at 5 MB/s. 5 is a safe value here unless you know the
+	  MESH SCSI bus is internal only; in that case you can say 10. Say 0
+	  to disable synchronous operation.
+
+config SCSI_MESH_RESET_DELAY_MS
+	int "initial bus reset delay (ms) (0 = no reset)"
+	depends on SCSI_MESH
+	default "4000"
+
+config SCSI_MAC53C94
+	tristate "53C94 (Power Mac external SCSI) support"
+	depends on PPC_PMAC && SCSI
+	help
+	  On Power Macintoshes (and clones) with two SCSI buses, the external
+	  SCSI bus is usually controlled by a 53C94 SCSI bus adaptor. Older
+	  machines which only have one SCSI bus, such as the 7200, also use
+	  the 53C94. Say Y to include support for the 53C94.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mac53c94.
+
+comment "--- Sparc ESP drivers ---"
+	depends on SBUS && SCSI
+
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
+comment "--- Sun3 drivers ---"
+	depends on SUN3 && SCSI
+
 config SUN3_SCSI
 	tristate "Sun3 NCR5380 SCSI"
 	depends on SUN3 && SCSI
@@ -1723,18 +1766,11 @@ config SUN3X_ESP
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
 
+comment "--- IBM zSeries drivers ---"
+	depends on ARCH_S390 && SCSI
+
 config ZFCP
 	tristate "FCP host bus adapter driver for IBM eServer zSeries"
 	depends on ARCH_S390 && SCSI
