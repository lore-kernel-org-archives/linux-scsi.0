From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: drivers/scsi/Kconfig
Date: Sat, 31 May 2003 04:34:13 -0400
Sender: ultralinux-owner@vger.kernel.org
Message-ID: <20030531043413.D4327@devserv.devel.redhat.com>
References: <20030530163817.GM28581@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ultralinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030530163817.GM28581@parcelfarce.linux.theplanet.co.uk>; from willy@debian.org on Fri, May 30, 2003 at 05:38:17PM +0100
To: Matthew Wilcox <willy@debian.org>
Cc: sparclinux@vger.kernel.org, ultralinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> Date: 	Fri, 30 May 2003 17:38:17 +0100
> From: Matthew Wilcox <willy@debian.org>

> http://ftp.linux.org.uk/pub/linux/willy/patches/scsi-kconfig.diff

The sparc32 part had a minor problem: deleted "menu" but not "endmenu",
and so lost the balance. Also, I'd need a better defconfig.

I noticed that killing of a symbios driver was stuffed into
this patch, I'm wondering if it would be better to separate
flies and patties, so to speak.

-- Pete

diff -urN -X dontdiff linux-2.5.70/arch/sparc/defconfig linux-2.5.70-sparc/arch/sparc/defconfig
--- linux-2.5.70/arch/sparc/defconfig	2003-05-26 18:00:45.000000000 -0700
+++ linux-2.5.70-sparc/arch/sparc/defconfig	2003-05-31 01:21:47.000000000 -0700
@@ -138,29 +138,61 @@
 CONFIG_SCSI=y
 
 #
-# SCSI support type (disk, tape, CDrom)
+# SCSI support type (disk, tape, CD-ROM)
 #
 CONFIG_BLK_DEV_SD=y
-CONFIG_SD_EXTRA_DEVS=40
 # CONFIG_CHR_DEV_ST is not set
 # CONFIG_CHR_DEV_OSST is not set
 CONFIG_BLK_DEV_SR=m
 # CONFIG_BLK_DEV_SR_VENDOR is not set
-CONFIG_SR_EXTRA_DEVS=2
 CONFIG_CHR_DEV_SG=m
 
 #
 # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
 #
 # CONFIG_SCSI_MULTI_LUN is not set
+CONFIG_SCSI_REPORT_LUNS=y
 # CONFIG_SCSI_CONSTANTS is not set
 # CONFIG_SCSI_LOGGING is not set
 
 #
 # SCSI low-level drivers
 #
-CONFIG_SCSI_SUNESP=y
+# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
+# CONFIG_SCSI_ACARD is not set
+# CONFIG_SCSI_AACRAID is not set
+# CONFIG_SCSI_AIC7XXX is not set
+# CONFIG_SCSI_AIC7XXX_OLD is not set
+# CONFIG_SCSI_AIC79XX is not set
+# CONFIG_SCSI_DPT_I2O is not set
+# CONFIG_SCSI_ADVANSYS is not set
+# CONFIG_SCSI_AM53C974 is not set
+# CONFIG_SCSI_MEGARAID is not set
+# CONFIG_SCSI_BUSLOGIC is not set
+# CONFIG_SCSI_CPQFCTS is not set
+# CONFIG_SCSI_DMX3191D is not set
+# CONFIG_SCSI_EATA is not set
+# CONFIG_SCSI_EATA_PIO is not set
+# CONFIG_SCSI_FUTURE_DOMAIN is not set
+# CONFIG_SCSI_GDTH is not set
+# CONFIG_SCSI_GENERIC_NCR5380 is not set
+# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
+# CONFIG_SCSI_INITIO is not set
+# CONFIG_SCSI_INIA100 is not set
+# CONFIG_SCSI_SYM53C8XX_2 is not set
+# CONFIG_SCSI_NCR53C8XX is not set
+# CONFIG_SCSI_PCI2000 is not set
+# CONFIG_SCSI_PCI2220I is not set
+# CONFIG_SCSI_QLOGIC_ISP is not set
+# CONFIG_SCSI_QLOGIC_FC is not set
+# CONFIG_SCSI_QLOGIC_1280 is not set
 CONFIG_SCSI_QLOGICPTI=m
+# CONFIG_SCSI_DC395x is not set
+# CONFIG_SCSI_DC390T is not set
+# CONFIG_SCSI_U14_34F is not set
+# CONFIG_SCSI_NSP32 is not set
+# CONFIG_SCSI_DEBUG is not set
+CONFIG_SCSI_SUNESP=y
 
 #
 # Fibre Channel support
diff -urN -X dontdiff linux-2.5.70/arch/sparc/Kconfig linux-2.5.70-sparc/arch/sparc/Kconfig
--- linux-2.5.70/arch/sparc/Kconfig	2003-05-26 18:00:19.000000000 -0700
+++ linux-2.5.70-sparc/arch/sparc/Kconfig	2003-05-31 00:22:26.000000000 -0700
@@ -626,232 +626,7 @@
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI device.
 
-comment "SCSI support type (disk, tape, CDrom)"
-	depends on SCSI
-
-config BLK_DEV_SD
-	tristate "SCSI disk support"
-	depends on SCSI
-	---help---
-	  If you want to use a SCSI hard disk or the SCSI or parallel port
-	  version of the IOMEGA ZIP drive under Linux, say Y and read the
-	  SCSI-HOWTO, the Disk-HOWTO and the Multi-Disk-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>. This is NOT for SCSI
-	  CD-ROMs.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called sd_mod.  If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.  Do not compile this driver as a
-	  module if your root file system (the one containing the directory /)
-	  is located on a SCSI disk. In this case, do not compile the driver
-	  for your SCSI host adapter (below) as a module either.
-
-config SD_EXTRA_DEVS
-	int "Maximum number of SCSI disks that can be loaded as modules"
-	depends on BLK_DEV_SD
-	default "40"
-	---help---
-	  This controls the amount of additional space allocated in tables for
-	  drivers that are loaded as modules after the kernel is booted.  In
-	  the event that the SCSI core itself was loaded as a module, this
-	  value is the number of additional disks that can be loaded after the
-	  first host driver is loaded.
-
-	  Admittedly this isn't pretty, but there are tons of race conditions
-	  involved with resizing the internal arrays on the fly.  Someday this
-	  flag will go away, and everything will work automatically.
-
-	  If you don't understand what's going on, go with the default.
-
-config CHR_DEV_ST
-	tristate "SCSI tape support"
-	depends on SCSI
-	---help---
-	  If you want to use a SCSI tape drive under Linux, say Y and read the
-	  SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, and
-	  <file:Documentation/scsi/st.txt> in the kernel source.  This is NOT
-	  for SCSI CD-ROMs.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called st. If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.
-
-config CHR_DEV_OSST
-	tristate "SCSI OnStream SC-x0 tape support"
-	depends on SCSI
-	---help---
-	  The OnStream SC-x0 SCSI tape drives can not be driven by the
-	  standard st driver, but instead need this special osst driver and
-	  use the  /dev/osstX char device nodes (major 206).  Via usb-storage
-	  and ide-scsi, you may be able to drive the USB-x0 and DI-x0 drives
-	  as well.  Note that there is also a second generation of OnStream
-	  tape drives (ADR-x0) that supports the standard SCSI-2 commands for
-	  tapes (QIC-157) and can be driven by the standard driver st.
-	  For more information, you may have a look at the SCSI-HOWTO
-	  <http://www.tldp.org/docs.html#howto>  and
-	  <file:Documentation/scsi/osst.txt>  in the kernel source.
-	  More info on the OnStream driver may be found on
-	  <http://linux1.onstream.nl/test/>
-	  Please also have a look at the standard st docu, as most of it
-	  applies to osst as well.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called osst. If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.
-
-config BLK_DEV_SR
-	tristate "SCSI CDROM support"
-	depends on SCSI
-	---help---
-	  If you want to use a SCSI CD-ROM under Linux, say Y and read the
-	  SCSI-HOWTO and the CD-ROM-HOWTO at
-	  <http://www.tldp.org/docs.html#howto>. Also make sure to say Y
-	  or M to "ISO 9660 CD-ROM file system support" later.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called sr_mod. If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.
-
-config BLK_DEV_SR_VENDOR
-	bool "Enable vendor-specific extensions (for SCSI CDROM)"
-	depends on BLK_DEV_SR
-	help
-	  This enables the usage of vendor specific SCSI commands. This is
-	  required to support multisession CDs with old NEC/TOSHIBA cdrom
-	  drives (and HP Writers). If you have such a drive and get the first
-	  session only, try saying Y here; everybody else says N.
-
-config SR_EXTRA_DEVS
-	int "Maximum number of CDROM devices that can be loaded as modules"
-	depends on BLK_DEV_SR
-	default "2"
-	---help---
-	  This controls the amount of additional space allocated in tables for
-	  drivers that are loaded as modules after the kernel is booted. In
-	  the event that the SCSI core itself was loaded as a module, this
-	  value is the number of additional CD-ROMs that can be loaded after
-	  the first host driver is loaded.
-
-	  Admittedly this isn't pretty, but there are tons of race conditions
-	  involved with resizing the internal arrays on the fly.  Someday this
-	  flag will go away, and everything will work automatically.
-
-	  If you don't understand what's going on, go with the default.
-
-config CHR_DEV_SG
-	tristate "SCSI generic support"
-	depends on SCSI
-	---help---
-	  If you want to use SCSI scanners, synthesizers or CD-writers or just
-	  about anything having "SCSI" in its name other than hard disks,
-	  CD-ROMs or tapes, say Y here. These won't be supported by the kernel
-	  directly, so you need some additional software which knows how to
-	  talk to these devices using the SCSI protocol:
-
-	  For scanners, look at SANE (<http://www.mostang.com/sane/>). For CD
-	  writer software look at Cdrtools
-	  (<http://www.fokus.gmd.de/research/cc/glone/employees/joerg.schilling/private/cdrecord.html>)
-	  and for burning a "disk at once": CDRDAO
-	  (<http://cdrdao.sourceforge.net/>). Cdparanoia is a high
-	  quality digital reader of audio CDs (<http://www.xiph.org/paranoia/>).
-	  For other devices, it's possible that you'll have to write the
-	  driver software yourself. Please read the file
-	  <file:Documentation/scsi/scsi-generic.txt> for more information.
-
-	  If you want to compile this as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>. The module will be called sg.
-	  If unsure, say N.
-
-comment "Some SCSI devices (e.g. CD jukebox) support multiple LUNs"
-	depends on SCSI
-
-config SCSI_MULTI_LUN
-	bool "Probe all LUNs on each SCSI device"
-	depends on SCSI
-	help
-	  If you have a SCSI device that supports more than one LUN (Logical
-	  Unit Number), e.g. a CD jukebox, and only one LUN is detected, you
-	  can say Y here to force the SCSI driver to probe for multiple LUNs.
-	  A SCSI device with multiple LUNs acts logically like multiple SCSI
-	  devices. The vast majority of SCSI devices have only one LUN, and
-	  so most people can say N here and should in fact do so, because it
-	  is safer.
-
-config SCSI_CONSTANTS
-	bool "Verbose SCSI error reporting (kernel size +=12K)"
-	depends on SCSI
-	help
-	  The error messages regarding your SCSI hardware will be easier to
-	  understand if you say Y here; it will enlarge your kernel by about
-	  12 KB. If in doubt, say Y.
-
-config SCSI_LOGGING
-	bool "SCSI logging facility"
-	depends on SCSI
-	---help---
-	  This turns on a logging facility that can be used to debug a number
-	  of SCSI related problems.
-
-	  If you say Y here, no logging output will appear by default, but you
-	  can enable logging by saying Y to "/proc file system support" and
-	  "Sysctl support" below and executing the command
-
-	  echo "scsi log token [level]" > /proc/scsi/scsi
-
-	  at boot time after the /proc file system has been mounted.
-
-	  There are a number of things that can be used for 'token' (you can
-	  find them in the source: <file:drivers/scsi/scsi.c>), and this
-	  allows you to select the types of information you want, and the
-	  level allows you to select the level of verbosity.
-
-	  If you say N here, it may be harder to track down some types of SCSI
-	  problems. If you say Y here your kernel will be somewhat larger, but
-	  there should be no noticeable performance impact as long as you have
-	  logging turned off.
-
-
-menu "SCSI low-level drivers"
-	depends on SCSI!=n
-
-config SCSI_SUNESP
-	tristate "Sparc ESP Scsi Driver"
-	depends on SCSI
-	help
-	  This is the driver for the Sun ESP SCSI host adapter. The ESP
-	  chipset is present in most SPARC SBUS-based computers.
-
-	  This support is also available as a module called esp ( = code
-	  which can be inserted in and removed from the running kernel
-	  whenever you want). If you want to compile it as a module, say M
-	  here and read <file:Documentation/modules.txt>.
-
-config SCSI_QLOGICPTI
-	tristate "PTI Qlogic,ISP Driver"
-	depends on SCSI
-	help
-	  This driver supports SBUS SCSI controllers from PTI or QLogic. These
-	  controllers are known under Solaris as qpti and in the openprom as
-	  PTI,ptisp or QLGC,isp. Note that PCI QLogic SCSI controllers are
-	  driven by a different driver.
-
-	  This support is also available as a module called qlogicpti ( =
-	  code which can be inserted in and removed from the running kernel
-	  whenever you want). If you want to compile it as a module, say M
-	  here and read <file:Documentation/modules.txt>.
-
-endmenu
+source "drivers/scsi/Kconfig"
 
 endmenu
 
diff -urN -X dontdiff linux-2.5.70/drivers/scsi/Kconfig linux-2.5.70-sparc/drivers/scsi/Kconfig
--- linux-2.5.70/drivers/scsi/Kconfig	2003-05-26 18:00:57.000000000 -0700
+++ linux-2.5.70-sparc/drivers/scsi/Kconfig	2003-05-31 00:21:29.000000000 -0700
@@ -27,8 +27,8 @@
 	  If you want to use a SCSI tape drive under Linux, say Y and read the
 	  SCSI-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>, and
-	  <file:Documentation/scsi/st.txt> in the kernel source.  This is NOT for
-	  SCSI CD-ROMs.
+	  <file:Documentation/scsi/st.txt> in the kernel source.  This is NOT
+	  for SCSI CD-ROMs.
 
 	  This driver is also available as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want).
@@ -131,11 +131,11 @@
 	depends on SCSI
 	default y
 	help
-	  If you want to build with SCSI REPORT LUNS support in the kernel, say Y here.
-	  The REPORT LUNS command is useful for devices (such as disk arrays) with
-	  large numbers of LUNs where the LUN values are not contiguous (sparse LUN).
-	  REPORT LUNS scanning is done only for SCSI-3 devices. Most users can safely
-	  answer N here.
+	  If you want support for SCSI REPORT LUNS, say Y here.
+	  The REPORT LUNS command is useful for devices (such as disk arrays)
+	  with large numbers of LUNs where the LUN values are not contiguous
+	  (sparse LUN).  REPORT LUNS scanning is done only for SCSI-3 devices.
+	  Most users can safely answer N here.
 
 config SCSI_CONSTANTS
 	bool "Verbose SCSI error reporting (kernel size +=12K)"
@@ -220,7 +220,7 @@
 
 config SCSI_ACARD
 	tristate "ACARD SCSI support"
-	depends on SCSI
+	depends on PCI && SCSI
 	help
 	  This driver supports the ACARD 870U/W SCSI host adapter.
 
@@ -285,6 +285,7 @@
 
 config SCSI_AIC7XXX_OLD
 	tristate "Adaptec AIC7xxx support (old driver)"
+	depends on SCSI
 	help
 	  WARNING This driver is an older aic7xxx driver and is no longer
 	  under active development.  Adaptec, Inc. is writing a new driver to
@@ -343,7 +344,7 @@
 
 config SCSI_ADVANSYS
 	tristate "AdvanSys SCSI support"
-	depends on SCSI
+	depends on (ISA || EISA || PCI) && SCSI
 	help
 	  This is a driver for all SCSI host adapters manufactured by
 	  AdvanSys. It is documented in the kernel source in
@@ -357,7 +358,7 @@
 
 config SCSI_IN2000
 	tristate "Always IN2000 SCSI support"
-	depends on SCSI
+	depends on ISA && SCSI
 	help
 	  This is support for an ISA bus SCSI host adapter.  You'll find more
 	  information in <file:Documentation/scsi/in2000.txt>. If it doesn't work
@@ -876,60 +877,6 @@
 	depends on SCSI_LASI700
 	default y
 
-config SCSI_NCR53C7xx
-	tristate "NCR53c7,8xx SCSI support"
-	depends on SCSI && PCI
-	---help---
-	  This is a driver for the 53c7 and 8xx NCR family of SCSI
-	  controllers, not to be confused with the NCR 5380 controllers.  It
-	  is explained in section 3.8 of the SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.  If it doesn't work out
-	  of the box, you may have to change some settings in
-	  <file:drivers/scsi/53c7,8xx.h>.  Please read
-	  <file:Documentation/scsi/ncr53c7xx.txt> for the available boot time
-	  command line options.
-
-	  Note: there is another driver for the 53c8xx family of controllers
-	  ("NCR53C8XX SCSI support" below).  If you want to use them both, you
-	  need to say M to both and build them as modules, but only one may be
-	  active at a time. If you have a 53c8xx board, it's better to use the
-	  other driver.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called 53c7,8xx.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt>.
-
-config SCSI_NCR53C7xx_sync
-	bool "always negotiate synchronous transfers"
-	depends on SCSI_NCR53C7xx
-	help
-	  In general, this is good; however, it is a bit dangerous since there
-	  are some broken SCSI devices out there. Take your chances. Safe bet
-	  is N.
-
-config SCSI_NCR53C7xx_FAST
-	bool "allow FAST-SCSI [10MHz]"
-	depends on SCSI_NCR53C7xx
-	help
-	  This will enable 10MHz FAST-SCSI transfers with your host
-	  adapter. Some systems have problems with that speed, so it's safest
-	  to say N here.
-
-config SCSI_NCR53C7xx_DISCONNECT
-	bool "allow DISCONNECT"
-	depends on SCSI_NCR53C7xx
-	help
-	  This enables the disconnect/reconnect feature of the NCR SCSI
-	  controller. When you say Y here, a slow SCSI device will not lock
-	  the SCSI bus while processing a request, allowing simultaneous use
-	  of e.g. a SCSI hard disk and SCSI tape or CD-ROM drive, and
-	  providing much better performance when using slow and fast SCSI
-	  devices at the same time. Some devices, however, do not operate
-	  properly with this option enabled, and will cause your SCSI system
-	  to hang, which might cause a system crash. The safe answer
-	  therefore is to say N.
-
 config SCSI_SYM53C8XX_2
 	tristate "SYM53C8XX Version 2 SCSI support"
 	depends on PCI && SCSI
@@ -1022,45 +969,12 @@
 	  Recent versions of the 53C8XX chips are better supported by the
 	  option "SYM53C8XX SCSI support", below.
 
-	  Note: there is yet another driver for the 53c8xx family of
-	  controllers ("NCR53c7,8xx SCSI support" above).  If you want to use
-	  them both, you need to say M to both and build them as modules, but
-	  only one may be active at a time.  If you have a 53c8xx board, you
-	  probably do not want to use the "NCR53c7,8xx SCSI support".
-
-	  Please read <file:Documentation/scsi/ncr53c8xx.txt> for more
-	  information.
-
-config SCSI_SYM53C8XX
-	tristate "SYM53C8XX SCSI support"
-	depends on PCI && SCSI_SYM53C8XX_2!=y && SCSI
-	---help---
-	  This driver supports all the features of recent 53C8XX chips (used
-	  in PCI SCSI controllers), notably the hardware phase mismatch
-	  feature of the SYM53C896.
-
-	  Older versions of the 53C8XX chips are not supported by this
-	  driver.  If your system uses either a 810 rev. < 16, a 815, or a 825
-	  rev. < 16 PCI SCSI processor, you must use the generic NCR53C8XX
-	  driver ("NCR53C8XX SCSI support" above) or configure both the
-	  NCR53C8XX and this SYM53C8XX drivers either as module or linked to
-	  the kernel image.
-
-	  When both drivers are linked into the kernel, the SYM53C8XX driver
-	  is called first at initialization and you can use the 'excl=ioaddr'
-	  driver boot option to exclude attachment of adapters by the
-	  SYM53C8XX driver.  For example, entering
-	  'sym53c8xx=excl:0xb400,excl=0xc000' at the lilo prompt prevents
-	  adapters at io address 0xb400 and 0xc000 from being attached by the
-	  SYM53C8XX driver, thus allowing the NCR53C8XX driver to attach them.
-	  The 'excl' option is also supported by the NCR53C8XX driver.
-
 	  Please read <file:Documentation/scsi/ncr53c8xx.txt> for more
 	  information.
 
 config SCSI_NCR53C8XX_DEFAULT_TAGS
 	int "default tagged command queue depth"
-	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_SYM53C8XX || SCSI_ZALON)
+	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_ZALON)
 	default "8"
 	---help---
 	  "Tagged command queuing" is a feature of SCSI-2 which improves
@@ -1086,7 +1000,7 @@
 
 config SCSI_NCR53C8XX_MAX_TAGS
 	int "maximum number of queued commands"
-	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_SYM53C8XX || SCSI_ZALON)
+	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_ZALON)
 	default "32"
 	---help---
 	  This option allows you to specify the maximum number of commands
@@ -1103,7 +1017,7 @@
 
 config SCSI_NCR53C8XX_SYNC
 	int "synchronous transfers frequency in MHz"
-	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_SYM53C8XX || SCSI_ZALON)
+	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_ZALON)
 	default "20"
 	---help---
 	  The SCSI Parallel Interface-2 Standard defines 5 classes of transfer
@@ -1137,7 +1051,7 @@
 
 config SCSI_NCR53C8XX_PROFILE
 	bool "enable profiling"
-	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_SYM53C8XX || SCSI_ZALON)
+	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_ZALON)
 	help
 	  This option allows you to enable profiling information gathering.
 	  These statistics are not very accurate due to the low frequency
@@ -1148,7 +1062,7 @@
 
 config SCSI_NCR53C8XX_IOMAPPED
 	bool "use normal IO"
-	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_SYM53C8XX) && !SCSI_ZALON
+	depends on PCI && SCSI_SYM53C8XX_2!=y && SCSI_NCR53C8XX && !SCSI_ZALON
 	help
 	  If you say Y here, the driver will use normal IO, as opposed to
 	  memory mapped IO. Memory mapped IO has less latency than normal IO
@@ -1161,7 +1075,7 @@
 
 config SCSI_NCR53C8XX_PQS_PDS
 	bool "include support for the NCR PQS/PDS SCSI card"
-	depends on (SCSI_NCR53C8XX || SCSI_SYM53C8XX) && SCSI_SYM53C8XX
+	depends on SCSI_NCR53C8XX
 	help
 	  Say Y here if you have a special SCSI adapter produced by NCR
 	  corporation called a PCI Quad SCSI or PCI Dual SCSI. You do not need
@@ -1173,7 +1087,7 @@
 
 config SCSI_NCR53C8XX_NO_DISCONNECT
 	bool "not allow targets to disconnect"
-	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_SYM53C8XX || SCSI_ZALON) && SCSI_NCR53C8XX_DEFAULT_TAGS=0
+	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_ZALON) && SCSI_NCR53C8XX_DEFAULT_TAGS=0
 	help
 	  This option is only provided for safety if you suspect some SCSI
 	  device of yours to not support properly the target-disconnect
@@ -1183,7 +1097,7 @@
 
 config SCSI_NCR53C8XX_SYMBIOS_COMPAT
 	bool "assume boards are SYMBIOS compatible (EXPERIMENTAL)"
-	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_SYM53C8XX || SCSI_ZALON) && EXPERIMENTAL
+	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_ZALON) && EXPERIMENTAL
 	---help---
 	  This option allows you to enable some features depending on GPIO
 	  wiring. These General Purpose Input/Output pins can be used for
@@ -1340,6 +1254,20 @@
 	  The module will be called qla1280. If you want to compile it as
 	  a module, say M here and read <file:Documentation/modules.txt>.
 
+config SCSI_QLOGICPTI
+	tristate "PTI Qlogic, ISP Driver"
+	depends on SBUS && SCSI
+	help
+	  This driver supports SBUS SCSI controllers from PTI or QLogic. These
+	  controllers are known under Solaris as qpti and in the openprom as
+	  PTI,ptisp or QLGC,isp. Note that PCI QLogic SCSI controllers are
+	  driven by a different driver.
+
+	  This support is also available as a module called qlogicpti ( =
+	  code which can be inserted in and removed from the running kernel
+	  whenever you want). If you want to compile it as a module, say M
+	  here and read <file:Documentation/modules.txt>.
+
 config SCSI_SEAGATE
 	tristate "Seagate ST-02 and Future Domain TMC-8xx SCSI support"
 	depends on X86 && ISA && SCSI
@@ -1725,6 +1653,129 @@
 	  see the picture at
 	  <http://amiga.multigraph.com/photos/oktagon.html>.
 
+config ATARI_SCSI
+	tristate "Atari native SCSI support"
+	depends on ATARI && SCSI
+	---help---
+	  If you have an Atari with built-in NCR5380 SCSI controller (TT,
+	  Falcon, ...) say Y to get it supported. Of course also, if you have
+	  a compatible SCSI controller (e.g. for Medusa).  This driver is also
+	  available as a module ( = code which can be inserted in and removed
+	  from the running kernel whenever you want).  The module is called
+	  atari_scsi.  If you want to compile it as a module, say M here and
+	  read <file:Documentation/modules.txt>.  This driver supports both
+	  styles of NCR integration into the system: the TT style (separate
+	  DMA), and the Falcon style (via ST-DMA, replacing ACSI).  It does
+	  NOT support other schemes, like in the Hades (without DMA).
+
+config ATARI_SCSI_TOSHIBA_DELAY
+	bool "Long delays for Toshiba CD-ROMs"
+	depends on ATARI_SCSI
+	help
+	  This option increases the delay after a SCSI arbitration to
+	  accommodate some flaky Toshiba CD-ROM drives. Say Y if you intend to
+	  use a Toshiba CD-ROM drive; otherwise, the option is not needed and
+	  would impact performance a bit, so say N.
+
+config ATARI_SCSI_RESET_BOOT
+	bool "Reset SCSI-devices at boottime"
+	depends on ATARI_SCSI
+	help
+	  Reset the devices on your Atari whenever it boots.  This makes the
+	  boot process fractionally longer but may assist recovery from errors
+	  that leave the devices with SCSI operations partway completed.
+
+config TT_DMA_EMUL
+	bool "Hades SCSI DMA emulator"
+	depends on ATARI_SCSI && HADES
+	help
+	  This option enables code which emulates the TT SCSI DMA chip on the
+	  Hades. This increases the SCSI transfer rates at least ten times
+	  compared to PIO transfers.
+
+config MAC_SCSI
+	bool "Macintosh NCR5380 SCSI"
+	depends on MAC
+	help
+	  This is the NCR 5380 SCSI controller included on most of the 68030
+	  based Macintoshes.  If you have one of these say Y and read the
+	  SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.
+
+config SCSI_MAC_ESP
+	tristate "Macintosh NCR53c9[46] SCSI"
+	depends on MAC && SCSI
+	help
+	  This is the NCR 53c9x SCSI controller found on most of the 68040
+	  based Macintoshes.  If you have one of these say Y and read the
+	  SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.
+
+	  This driver is also available as a module ( = code which can be
+	  inserted in and removed from the running kernel whenever you want).
+	  The module will be called mac_esp.  If you want to compile it as
+	  a module, say M here and read <file:Documentation/modules.txt>.
+
+config MVME147_SCSI
+	bool "WD33C93 SCSI driver for MVME147"
+	depends on MVME147
+	help
+	  Support for the on-board SCSI controller on the Motorola MVME147
+	  single-board computer.
+
+config MVME16x_SCSI
+	bool "NCR53C710 SCSI driver for MVME16x"
+	depends on MVME16x
+	help
+	  The Motorola MVME162, 166, 167, 172 and 177 boards use the NCR53C710
+	  SCSI controller chip.  Almost everyone using one of these boards
+	  will want to say Y to this question.
+
+config BVME6000_SCSI
+	bool "NCR53C710 SCSI driver for BVME6000"
+	depends on BVME6000
+	help
+	  The BVME4000 and BVME6000 boards from BVM Ltd use the NCR53C710
+	  SCSI controller chip.  Almost everyone using one of these boards
+	  will want to say Y to this question.
+
+config SCSI_NCR53C7xx_FAST
+	bool "allow FAST-SCSI [10MHz]"
+	depends on A4000T_SCSI || A4091_SCSI || BLZ603EPLUS_SCSI || WARPENGINE_SCSI || MVME16x_SCSI || BVME6000_SCSI
+	help
+	  This will enable 10MHz FAST-SCSI transfers with your host
+	  adapter. Some systems have problems with that speed, so it's safest
+	  to say N here.
+
+config SUN3_SCSI
+	tristate "Sun3 NCR5380 SCSI"
+	depends on SUN3 && SCSI
+	help
+	  This option will enable support for the OBIO (onboard io) NCR5380
+	  SCSI controller found in the Sun 3/50 and 3/60, as well as for
+	  "Sun3" type VME scsi controllers also based on the NCR5380.
+	  General Linux information on the Sun 3 series (now discontinued)
+	  is at <http://www.angelfire.com/ca2/tech68k/sun3.html>.
+
+config SUN3X_ESP
+	bool "Sun3x ESP SCSI"
+	depends on SUN3X
+	help
+	  The ESP was an on-board SCSI controller used on Sun 3/80
+	  machines.  Say Y here to compile in support for it.
+
+config SCSI_SUNESP
+	tristate "Sparc ESP Scsi Driver"
+	depends on SBUS && SCSI
+	help
+	  This is the driver for the Sun ESP SCSI host adapter. The ESP
+	  chipset is present in most SPARC SBUS-based computers.
+
+	  This support is also available as a module called esp ( = code
+	  which can be inserted in and removed from the running kernel
+	  whenever you want). If you want to compile it as a module, say M
+	  here and read <file:Documentation/modules.txt>.
+
 config SCSI_PC980155
 	tristate "NEC PC-9801-55 SCSI support"
 	depends on X86_PC9800 && SCSI
