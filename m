From: Matthew Wilcox <willy@debian.org>
Subject: Re: Unification of the SCSI Kconfig menus
Date: Fri, 30 May 2003 16:53:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030530155358.GL28581@parcelfarce.linux.theplanet.co.uk>
References: <20030530125318.GK28581@parcelfarce.linux.theplanet.co.uk> <20030530141451.A9352@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:8851 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263759AbTE3Pkj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 May 2003 11:40:39 -0400
Content-Disposition: inline
In-Reply-To: <20030530141451.A9352@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@debian.org>, linux-scsi@vger.kernel.org, Janitors <kernel-janitor-discuss@lists.sourceforge.net>

On Fri, May 30, 2003 at 02:14:51PM +0100, Christoph Hellwig wrote:
> On Fri, May 30, 2003 at 01:53:18PM +0100, Matthew Wilcox wrote:
> > I think it would be useful to split the existing drivers/scsi/Kconfig into
> > drivers/scsi/Kconfig_core and drivers/scsi/Kconfig_drivers.  That allows
> > um to use Kconfig_core without using the drivers.
> 
> You should be using the drivers for everything even if that means adding
> the missing bus depencies.

All right, here's a first pass at doing some of that.  It's a bit tedious..

 - Make some more options depend on bus types
 - Eliminate the Kconfig option for 53c7,8xx and some references to it
 - Eliminate the original sym53c8xx driver from the config (leave it in the
   makefile for now though)
 - Merge the m68k Kconfig bits into the main scsi Kconfig file
 - Tidy up some formatting

diffstat scsi-kconfig.diff 
 arch/m68k/Kconfig    |  412 ---------------------------------------------------
 drivers/scsi/Kconfig |  235 ++++++++++++++++-------------
 2 files changed, 131 insertions(+), 516 deletions(-)

Index: arch/m68k/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/arch/m68k/Kconfig,v
retrieving revision 1.13
diff -u -p -r1.13 Kconfig
--- arch/m68k/Kconfig	5 May 2003 17:05:41 -0000	1.13
+++ arch/m68k/Kconfig	30 May 2003 15:27:12 -0000
@@ -731,417 +731,7 @@ config SCSI
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI device.
 
-comment "SCSI support type (disk, tape, CD-ROM)"
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
-	  <file:Documentation/scsi/st.txt> in the kernel source.  This is NOT for
-	  SCSI CD-ROMs.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called st. If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt> and
-	  <file:Documentation/scsi/scsi.txt>.
-
-config ST_EXTRA_DEVS
-	int "Maximum number of SCSI tapes that can be loaded as modules"
-	depends on CHR_DEV_ST
-	default "2"
-	---help---
-	  This controls the amount of additional space allocated in tables for
-	  drivers that are loaded as modules after the kernel is booted.  In
-	  the event that the SCSI core itself was loaded as a module, this
-	  value is the number of additional tapes that can be loaded after the
-	  first host driver is loaded.
-
-	  Admittedly this isn't pretty, but there are tons of race conditions
-	  involved with resizing the internal arrays on the fly.  Someday this
-	  flag will go away, and everything will work automatically.
-
-	  If you don't understand what's going on, go with the default.
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
-config A3000_SCSI
-	tristate "A3000 WD33C93A support"
-	depends on AMIGA && SCSI
-	help
-	  If you have an Amiga 3000 and have SCSI devices connected to the
-	  built-in SCSI controller, say Y. Otherwise, say N. This driver is
-	  also available as a module ( = code which can be inserted in and
-	  removed from the running kernel whenever you want). The module is
-	  called wd33c93. If you want to compile it as a module, say M here
-	  and read <file:Documentation/modules.txt>.
-
-config A4000T_SCSI
-	bool "A4000T SCSI support (EXPERIMENTAL)"
-	depends on AMIGA && EXPERIMENTAL
-	help
-	  Support for the NCR53C710 SCSI controller on the Amiga 4000T.
-
-config A2091_SCSI
-	tristate "A2091 WD33C93A support"
-	depends on ZORRO && SCSI
-	help
-	  If you have a Commodore A2091 SCSI controller, say Y. Otherwise,
-	  say N. This driver is also available as a module ( = code which can
-	  be inserted in and removed from the running kernel whenever you
-	  want). The module is called wd33c93. If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt>.
-
-config GVP11_SCSI
-	tristate "GVP Series II WD33C93A support"
-	depends on ZORRO && SCSI
-	---help---
-	  If you have a Great Valley Products Series II SCSI controller,
-	  answer Y. Also say Y if you have a later model of GVP SCSI
-	  controller (such as the GVP A4008 or a Combo board). Otherwise,
-	  answer N. This driver does NOT work for the T-Rex series of
-	  accelerators from TekMagic and GVP-M.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you
-	  want). The module will be called gvp11. If you want to compile it
-	  as a module, say M here and read <file:Documentation/modules.txt>.
-
-config CYBERSTORM_SCSI
-	tristate "CyberStorm SCSI support"
-	depends on ZORRO && SCSI
-	help
-	  If you have an Amiga with an original (MkI) Phase5 Cyberstorm
-	  accelerator board and the optional Cyberstorm SCSI controller,
-	  answer Y. Otherwise, say N.
-
-config CYBERSTORMII_SCSI
-	tristate "CyberStorm Mk II SCSI support"
-	depends on ZORRO && SCSI
-	help
-	  If you have an Amiga with a Phase5 Cyberstorm MkII accelerator board
-	  and the optional Cyberstorm SCSI controller, say Y. Otherwise,
-	  answer N.
-
-config BLZ2060_SCSI
-	tristate "Blizzard 2060 SCSI support"
-	depends on ZORRO && SCSI
-	help
-	  If you have an Amiga with a Phase5 Blizzard 2060 accelerator board
-	  and want to use the onboard SCSI controller, say Y. Otherwise,
-	  answer N.
-
-config BLZ1230_SCSI
-	tristate "Blizzard 1230IV/1260 SCSI support"
-	depends on ZORRO && SCSI
-	help
-	  If you have an Amiga 1200 with a Phase5 Blizzard 1230IV or Blizzard
-	  1260 accelerator, and the optional SCSI module, say Y. Otherwise,
-	  say N.
-
-config FASTLANE_SCSI
-	tristate "Fastlane SCSI support"
-	depends on ZORRO && SCSI
-	help
-	  If you have the Phase5 Fastlane Z3 SCSI controller, or plan to use
-	  one in the near future, say Y to this question. Otherwise, say N.
-
-config A4091_SCSI
-	bool "A4091 SCSI support (EXPERIMENTAL)"
-	depends on ZORRO && EXPERIMENTAL
-	help
-	  Support for the NCR53C710 chip on the Amiga 4091 Z3 SCSI2 controller
-	  (1993).  Very obscure -- the 4091 was part of an Amiga 4000 upgrade
-	  plan at the time the Amiga business was sold to DKB.
-
-config WARPENGINE_SCSI
-	bool "WarpEngine SCSI support (EXPERIMENTAL)"
-	depends on ZORRO && EXPERIMENTAL
-	help
-	  Support for MacroSystem Development's WarpEngine Amiga SCSI-2
-	  controller. Info at
-	  <http://www.lysator.liu.se/amiga/ar/guide/ar310.guide?FEATURE5>.
-
-config BLZ603EPLUS_SCSI
-	bool "Blizzard PowerUP 603e+ SCSI (EXPERIMENTAL)"
-	depends on ZORRO && EXPERIMENTAL
-	help
-	  If you have an Amiga 1200 with a Phase5 Blizzard PowerUP 603e+
-	  accelerator, say Y. Otherwise, say N.
-
-config OKTAGON_SCSI
-	tristate "BSC Oktagon SCSI support (EXPERIMENTAL)"
-	depends on ZORRO && EXPERIMENTAL && SCSI
-	help
-	  If you have the BSC Oktagon SCSI disk controller for the Amiga, say
-	  Y to this question.  If you're in doubt about whether you have one,
-	  see the picture at
-	  <http://amiga.multigraph.com/photos/oktagon.html>.
-
-#	 bool 'Cyberstorm Mk III SCSI support (EXPERIMENTAL)' CONFIG_CYBERSTORMIII_SCSI
-#	 bool 'GVP Turbo 040/060 SCSI support (EXPERIMENTAL)' CONFIG_GVP_TURBO_SCSI
-config ATARI_SCSI
-	tristate "Atari native SCSI support"
-	depends on ATARI && SCSI
-	---help---
-	  If you have an Atari with built-in NCR5380 SCSI controller (TT,
-	  Falcon, ...) say Y to get it supported. Of course also, if you have
-	  a compatible SCSI controller (e.g. for Medusa).  This driver is also
-	  available as a module ( = code which can be inserted in and removed
-	  from the running kernel whenever you want).  The module is called
-	  atari_scsi.  If you want to compile it as a module, say M here and
-	  read <file:Documentation/modules.txt>.  This driver supports both
-	  styles of NCR integration into the system: the TT style (separate
-	  DMA), and the Falcon style (via ST-DMA, replacing ACSI).  It does
-	  NOT support other schemes, like in the Hades (without DMA).
-
-config ATARI_SCSI_TOSHIBA_DELAY
-	bool "Long delays for Toshiba CD-ROMs"
-	depends on ATARI_SCSI
-	help
-	  This option increases the delay after a SCSI arbitration to
-	  accommodate some flaky Toshiba CD-ROM drives. Say Y if you intend to
-	  use a Toshiba CD-ROM drive; otherwise, the option is not needed and
-	  would impact performance a bit, so say N.
-
-config ATARI_SCSI_RESET_BOOT
-	bool "Reset SCSI-devices at boottime"
-	depends on ATARI_SCSI
-	help
-	  Reset the devices on your Atari whenever it boots.  This makes the
-	  boot process fractionally longer but may assist recovery from errors
-	  that leave the devices with SCSI operations partway completed.
-
-config TT_DMA_EMUL
-	bool "Hades SCSI DMA emulator"
-	depends on ATARI_SCSI && HADES
-	help
-	  This option enables code which emulates the TT SCSI DMA chip on the
-	  Hades. This increases the SCSI transfer rates at least ten times
-	  compared to PIO transfers.
-
-config MAC_SCSI
-	bool "Macintosh NCR5380 SCSI"
-	depends on MAC
-	help
-	  This is the NCR 5380 SCSI controller included on most of the 68030
-	  based Macintoshes.  If you have one of these say Y and read the
-	  SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
-
-config SCSI_MAC_ESP
-	tristate "Macintosh NCR53c9[46] SCSI"
-	depends on MAC && SCSI
-	help
-	  This is the NCR 53c9x SCSI controller found on most of the 68040
-	  based Macintoshes.  If you have one of these say Y and read the
-	  SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called mac_esp.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt>.
-
-#   dep_tristate 'SCSI debugging host adapter' CONFIG_SCSI_DEBUG $CONFIG_SCSI
-config MVME147_SCSI
-	bool "WD33C93 SCSI driver for MVME147"
-	depends on MVME147
-	help
-	  Support for the on-board SCSI controller on the Motorola MVME147
-	  single-board computer.
-
-config MVME16x_SCSI
-	bool "NCR53C710 SCSI driver for MVME16x"
-	depends on MVME16x
-	help
-	  The Motorola MVME162, 166, 167, 172 and 177 boards use the NCR53C710
-	  SCSI controller chip.  Almost everyone using one of these boards
-	  will want to say Y to this question.
-
-config BVME6000_SCSI
-	bool "NCR53C710 SCSI driver for BVME6000"
-	depends on BVME6000
-	help
-	  The BVME4000 and BVME6000 boards from BVM Ltd use the NCR53C710
-	  SCSI controller chip.  Almost everyone using one of these boards
-	  will want to say Y to this question.
-
-config SUN3_SCSI
-	tristate "Sun3 NCR5380 SCSI"
-	depends on SUN3 && SCSI
-	help
-	  This option will enable support for the OBIO (onboard io) NCR5380
-	  SCSI controller found in the Sun 3/50 and 3/60, as well as for
-	  "Sun3" type VME scsi controllers also based on the NCR5380.
-	  General Linux information on the Sun 3 series (now discontinued)
-	  is at <http://www.angelfire.com/ca2/tech68k/sun3.html>.
-
-config SUN3X_ESP
-	bool "Sun3x ESP SCSI"
-	depends on SUN3X
-	help
-	  The ESP was an on-board SCSI controller used on Sun 3/80
-	  machines.  Say Y here to compile in support for it.
-
-endmenu
+source "drivers/scsi/Kconfig"
 
 endmenu
 
Index: drivers/scsi/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/drivers/scsi/Kconfig,v
retrieving revision 1.13
diff -u -p -r1.13 Kconfig
--- drivers/scsi/Kconfig	27 May 2003 17:25:20 -0000	1.13
+++ drivers/scsi/Kconfig	30 May 2003 15:48:31 -0000
@@ -27,8 +27,8 @@ config CHR_DEV_ST
 	  If you want to use a SCSI tape drive under Linux, say Y and read the
 	  SCSI-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>, and
-	  <file:Documentation/scsi/st.txt> in the kernel source.  This is NOT for
-	  SCSI CD-ROMs.
+	  <file:Documentation/scsi/st.txt> in the kernel source.  This is NOT
+	  for SCSI CD-ROMs.
 
 	  This driver is also available as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want).
@@ -131,11 +131,11 @@ config SCSI_REPORT_LUNS
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
@@ -220,7 +220,7 @@ config SCSI_7000FASST
 
 config SCSI_ACARD
 	tristate "ACARD SCSI support"
-	depends on SCSI
+	depends on PCI && SCSI
 	help
 	  This driver supports the ACARD 870U/W SCSI host adapter.
 
@@ -285,6 +285,7 @@ source "drivers/scsi/aic7xxx/Kconfig.aic
 
 config SCSI_AIC7XXX_OLD
 	tristate "Adaptec AIC7xxx support (old driver)"
+	depends on SCSI
 	help
 	  WARNING This driver is an older aic7xxx driver and is no longer
 	  under active development.  Adaptec, Inc. is writing a new driver to
@@ -343,7 +344,7 @@ config SCSI_DPT_I2O
 
 config SCSI_ADVANSYS
 	tristate "AdvanSys SCSI support"
-	depends on SCSI
+	depends on (ISA || EISA || PCI) && SCSI
 	help
 	  This is a driver for all SCSI host adapters manufactured by
 	  AdvanSys. It is documented in the kernel source in
@@ -357,7 +358,7 @@ config SCSI_ADVANSYS
 
 config SCSI_IN2000
 	tristate "Always IN2000 SCSI support"
-	depends on SCSI
+	depends on ISA && SCSI
 	help
 	  This is support for an ISA bus SCSI host adapter.  You'll find more
 	  information in <file:Documentation/scsi/in2000.txt>. If it doesn't work
@@ -876,60 +877,6 @@ config 53C700_LE_ON_BE
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
@@ -1022,45 +969,12 @@ config SCSI_NCR53C8XX
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
@@ -1086,7 +1000,7 @@ config SCSI_NCR53C8XX_DEFAULT_TAGS
 
 config SCSI_NCR53C8XX_MAX_TAGS
 	int "maximum number of queued commands"
-	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_SYM53C8XX || SCSI_ZALON)
+	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_ZALON)
 	default "32"
 	---help---
 	  This option allows you to specify the maximum number of commands
@@ -1103,7 +1017,7 @@ config SCSI_NCR53C8XX_MAX_TAGS
 
 config SCSI_NCR53C8XX_SYNC
 	int "synchronous transfers frequency in MHz"
-	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_SYM53C8XX || SCSI_ZALON)
+	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_ZALON)
 	default "20"
 	---help---
 	  The SCSI Parallel Interface-2 Standard defines 5 classes of transfer
@@ -1137,7 +1051,7 @@ config SCSI_NCR53C8XX_SYNC
 
 config SCSI_NCR53C8XX_PROFILE
 	bool "enable profiling"
-	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_SYM53C8XX || SCSI_ZALON)
+	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_ZALON)
 	help
 	  This option allows you to enable profiling information gathering.
 	  These statistics are not very accurate due to the low frequency
@@ -1148,7 +1062,7 @@ config SCSI_NCR53C8XX_PROFILE
 
 config SCSI_NCR53C8XX_IOMAPPED
 	bool "use normal IO"
-	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_SYM53C8XX) && !SCSI_ZALON
+	depends on PCI && SCSI_SYM53C8XX_2!=y && SCSI_NCR53C8XX && !SCSI_ZALON
 	help
 	  If you say Y here, the driver will use normal IO, as opposed to
 	  memory mapped IO. Memory mapped IO has less latency than normal IO
@@ -1161,7 +1075,7 @@ config SCSI_NCR53C8XX_IOMAPPED
 
 config SCSI_NCR53C8XX_PQS_PDS
 	bool "include support for the NCR PQS/PDS SCSI card"
-	depends on (SCSI_NCR53C8XX || SCSI_SYM53C8XX) && SCSI_SYM53C8XX
+	depends on SCSI_NCR53C8XX
 	help
 	  Say Y here if you have a special SCSI adapter produced by NCR
 	  corporation called a PCI Quad SCSI or PCI Dual SCSI. You do not need
@@ -1173,7 +1087,7 @@ config SCSI_NCR53C8XX_PQS_PDS
 
 config SCSI_NCR53C8XX_NO_DISCONNECT
 	bool "not allow targets to disconnect"
-	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_SYM53C8XX || SCSI_ZALON) && SCSI_NCR53C8XX_DEFAULT_TAGS=0
+	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_ZALON) && SCSI_NCR53C8XX_DEFAULT_TAGS=0
 	help
 	  This option is only provided for safety if you suspect some SCSI
 	  device of yours to not support properly the target-disconnect
@@ -1183,7 +1097,7 @@ config SCSI_NCR53C8XX_NO_DISCONNECT
 
 config SCSI_NCR53C8XX_SYMBIOS_COMPAT
 	bool "assume boards are SYMBIOS compatible (EXPERIMENTAL)"
-	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_SYM53C8XX || SCSI_ZALON) && EXPERIMENTAL
+	depends on PCI && SCSI_SYM53C8XX_2!=y && (SCSI_NCR53C8XX || SCSI_ZALON) && EXPERIMENTAL
 	---help---
 	  This option allows you to enable some features depending on GPIO
 	  wiring. These General Purpose Input/Output pins can be used for
@@ -1724,6 +1638,117 @@ config OKTAGON_SCSI
 	  Y to this question.  If you're in doubt about whether you have one,
 	  see the picture at
 	  <http://amiga.multigraph.com/photos/oktagon.html>.
+
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
 
 config SCSI_PC980155
 	tristate "NEC PC-9801-55 SCSI support"


-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
