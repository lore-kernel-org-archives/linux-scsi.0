From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] sym2 2.1.18m
Date: Fri, 22 Oct 2004 00:03:25 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041021230325.GH16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:6595 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S271078AbUJUXD0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 19:03:26 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.33)
	id 1CKlxt-0008FE-6u
	for linux-scsi@vger.kernel.org; Fri, 22 Oct 2004 00:03:25 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch against 2.6.9-bk6 is the 2.1.18m release of the sym2 driver.


sym2 2.1.18m:
 - Improve documentation
 - Remove host-level command queueing (Christoph Hellwig)
 - Add support for IU and QAS
 - sparse annotation (Randolph Chung)
 - Remove SYM_LINUX_BOOT_COMMAND_LINE_SUPPORT ifdefs
 - Switch to the new module_param interface
   - Rename tags to cmd_per_lun for consistency
   - Fix debug param
   - Split extended tags functionality into the new tag_ctrl parameter
   - rewrite how safe param works
   - reverse_probe param has had no effect for a while, remove it.
   - Add descriptions for all the parameters
 - Add MODULE_AUTHOR and MODULE_DESCRIPTION
 - Restructure sym_config_pqs() a little
 - Move hostid setup to a more sensible place
 - Do away with SYM_GLUE_C
 - Use a completion instead of a semaphore (Thomas Gleixner)
 - Use IDENTIFY() instead of M_IDENTIFY
 - Define messages in terms of those defined in <scsi/scsi.h>
 - Define PCI IDs in terms of those in <linux/pci_ids.h>
 - Define sym2's status codes in terms of the SAM ones defined in <scsi/scsi.h>

diff -urpNX dontdiff linus-2.6/Documentation/scsi/sym53c8xx_2.txt parisc-2.6/Documentation/scsi/sym53c8xx_2.txt
--- linus-2.6/Documentation/scsi/sym53c8xx_2.txt	Thu Oct 21 14:35:39 2004
+++ parisc-2.6/Documentation/scsi/sym53c8xx_2.txt	Thu Oct 21 12:03:00 2004
@@ -4,7 +4,9 @@ Written by Gerard Roudier <groudier@free
 21 Rue Carnot
 95170 DEUIL LA BARRE - FRANCE
 
-Decembre 28 2000
+Updated by Matthew Wilcox <matthew@wil.cx>
+
+2004-10-09
 ===============================================================================
 
 1.  Introduction
@@ -29,26 +31,20 @@ Decembre 28 2000
 10. Boot setup commands
       10.1 Syntax
       10.2 Available arguments
-             10.2.1  Master parity checking
-             10.2.2  Scsi parity checking
-             10.2.3  Default number of tagged commands
-             10.2.4  Default synchronous period factor
-             10.2.5  Verbosity level
-             10.2.6  Debug mode
-             10.2.7  Burst max
-             10.2.8  LED support
-             10.2.9  Max wide
-             10.2.10 Differential mode
-             10.2.11 IRQ mode
-             10.2.12 Reverse probe
-             10.2.13 Fix up PCI configuration space
-             10.2.14 Serial NVRAM
-             10.2.15 Check SCSI BUS 
-             10.2.16 Exclude a host from being attached
-             10.2.17 Suggest a default SCSI id for hosts
-      10.3 PCI configuration fix-up boot option
-      10.4 Serial NVRAM support boot option
-      10.5 SCSI BUS checking boot option
+             10.2.1  Default number of tagged commands
+             10.2.2  Burst max
+             10.2.3  LED support
+             10.2.4  Differential mode
+             10.2.5  IRQ mode
+             10.2.6  Check SCSI BUS 
+             10.2.7  Suggest a default SCSI id for hosts
+             10.2.8  Verbosity level
+             10.2.9  Debug mode
+             10.2.10 Settle delay
+             10.2.11 Serial NVRAM
+             10.2.12 Exclude a host from being attached
+      10.3 Converting from old options
+      10.4 SCSI BUS checking boot option
 11. SCSI problem troubleshooting
       15.1 Problem tracking
       15.2 Understanding hardware error reports
@@ -94,6 +90,9 @@ The history of this driver can be summer
       Write a glue code for Linux.
           Gerard Roudier
 
+2004: Remove FreeBSD compatibility code.  Remove support for versions of
+      Linux before 2.6.  Start using Linux facilities.
+
 This README file addresses the Linux version of the driver. Under FreeBSD, 
 the driver documentation is the sym.8 man page.
 
@@ -279,11 +278,10 @@ setting verbose level to zero, as follow
 6. Parity checking
 
 The driver supports SCSI parity checking and PCI bus master parity
-checking. These features must be enabled in order to ensure safe data
-transfers. However, some flawed devices or mother boards will have
-problems with parity. You can disable either PCI parity or SCSI parity 
-checking by entering appropriate options from the boot command line.
-(See 10: Boot setup commands).
+checking.  These features must be enabled in order to ensure safe
+data transfers.  Some flawed devices or mother boards may have problems
+with parity.  The options to defeat parity checking have been removed
+from the driver.
 
 7. Profiling information
 
@@ -428,77 +426,90 @@ Synchronous transfers frequency       (d
 
 10.1 Syntax
 
-Setup commands can be passed to the driver either at boot time or as a 
-string variable using 'insmod'.
-
-A boot setup command for this driver begins with the driver name "sym53c8xx=".
-The kernel syntax parser then expects an optionnal list of integers separated 
-with comma followed by an optional list of  comma-separated strings.
+Setup commands can be passed to the driver either at boot time or as
+parameters to modprobe, as described in Documentation/kernel-parameters.txt
 
 Example of boot setup command under lilo prompt:
 
-lilo: linux root=/dev/sda2 sym53c8xx=tags:4,sync:10,debug:0x200
+lilo: linux root=/dev/sda2 sym53c8xx.cmd_per_lun=4 sym53c8xx.sync=10 sym53c8xx.debug=0x200
 
 - enable tagged commands, up to 4 tagged commands queued.
 - set synchronous negotiation speed to 10 Mega-transfers / second.
 - set DEBUG_NEGO flag.
 
-Since comma seems not to be allowed when defining a string variable using  
-'insmod', the driver also accepts <space> as option separator. 
-The following command will install driver module with the same options as 
-above.
+The following command will install the driver module with the same
+options as above.
 
-    insmod sym53c8xx.o sym53c8xx="tags:4 sync:10 debug:0x200"
-
-The integer list of arguments is discarded by the driver. 
-
-Each string argument must be specified as "keyword:value". Only lower-case 
-characters and digits are allowed.
+    modprobe sym53c8xx cmd_per_lun=4 sync=10 debug=0x200"
 
 10.2 Available arguments
 
-10.2.1  Master parity checking
-        mpar:y     enabled
-        mpar:n     disabled
-
-10.2.2  Scsi parity checking
-        spar:y     enabled
-        spar:n     disabled
-
-10.2.3  Default number of tagged commands
-        tags:0     (or tags:1 ) tagged command queuing disabled
-        tags:#tags (#tags  > 1) tagged command queuing enabled
+10.2.1  Default number of tagged commands
+        cmd_per_lun=0 (or cmd_per_lun=1) tagged command queuing disabled
+        cmd_per_lun=#tags (#tags > 1) tagged command queuing enabled
   #tags will be truncated to the max queued commands configuration parameter.
-  This option also allows to specify a command queue depth for each device 
-  that support tagged command queueing.
+
+10.2.2  Detailed control of tagged commands
+  This option allows you to specify a command queue depth for each device 
+  that supports tagged command queueing.
   Example:
-      sym53c8xx=tags:10/t2t3q16-t5q24/t1u2q32
-               will set devices queue depth as follow:
+      tag_ctrl=10/t2t3q16-t5q24/t1u2q32
+  will set devices queue depth as follow:
       - controller #0 target #2 and target #3                  -> 16 commands,
       - controller #0 target #5                                -> 24 commands,
       - controller #1 target #1 logical unit #2                -> 32 commands,
       - all other logical units (all targets, all controllers) -> 10 commands.
 
-10.2.4  Default synchronous period factor
-        sync:255     disabled (asynchronous transfer mode)
-        sync:#factor
-  #factor =  9     Ultra-3 SCSI 80 Mega-transfers / second (Wide only)
-  #factor = 10     Ultra-2 SCSI 40 Mega-transfers / second
-  #factor = 11     Ultra-2 SCSI 33 Mega-transfers / second
-  #factor < 25     Ultra   SCSI 20 Mega-transfers / second
-  #factor < 50     Fast    SCSI-2
-
-  In all cases, the driver will use the minimum transfer period supported by 
-  controllers according to SYM53C8XX chip type.
-
-10.2.5  Verbosity level
-        verb:0     minimal
-        verb:1     normal
-        verb:2     too much
-
-10.2.6 Debug mode
-        debug:0	 clear debug flags
-        debug:#x   set debug flags
+10.2.3 Burst max
+        burst=0    burst disabled
+        burst=255  get burst length from initial IO register settings.
+        burst=#x   burst enabled (1<<#x burst transfers max)
+  #x is an integer value which is log base 2 of the burst transfers max.
+  By default the driver uses the maximum value supported by the chip.
+
+10.2.4 LED support
+        led=1      enable  LED support
+        led=0      disable LED support
+  Do not enable LED support if your scsi board does not use SDMS BIOS.
+  (See 'Configuration parameters')
+
+10.2.4 Differential mode
+        diff=0	never set up diff mode
+        diff=1	set up diff mode if BIOS set it
+        diff=2	always set up diff mode
+        diff=3	set diff mode if GPIO3 is not set
+
+10.2.5 IRQ mode
+        irqm=0     always open drain
+        irqm=1     same as initial settings (assumed BIOS settings)
+        irqm=2     always totem pole
+
+10.2.6 Check SCSI BUS 
+        buschk=<option bits>
+
+    Available option bits:
+        0x0:   No check.
+        0x1:   Check and do not attach the controller on error.  
+        0x2:   Check and just warn on error.
+
+10.2.7 Suggest a default SCSI id for hosts
+        hostid=255	no id suggested.
+        hostid=#x   (0 < x < 7) x suggested for hosts SCSI id.
+
+    If a host SCSI id is available from the NVRAM, the driver will ignore 
+    any value suggested as boot option. Otherwise, if a suggested value 
+    different from 255 has been supplied, it will use it. Otherwise, it will 
+    try to deduce the value previously set in the hardware and use value 
+    7 if the hardware value is zero.
+
+10.2.8  Verbosity level
+        verb=0     minimal
+        verb=1     normal
+        verb=2     too much
+
+10.2.9 Debug mode
+        debug=0	 clear debug flags
+        debug=#x   set debug flags
   #x is an integer value combining the following power-of-2 values:
   DEBUG_ALLOC       0x1
   DEBUG_PHASE       0x2
@@ -517,55 +528,17 @@ characters and digits are allowed.
   You can play safely with DEBUG_NEGO. However, some of these flags may 
   generate bunches of syslog messages. 
 
-10.2.7 Burst max
-        burst:0    burst disabled
-        burst:255  get burst length from initial IO register settings.
-        burst:#x   burst enabled (1<<#x burst transfers max)
-  #x is an integer value which is log base 2 of the burst transfers max.
-  By default the driver uses the maximum value supported by the chip.
-
-10.2.8 LED support
-        led:1      enable  LED support
-        led:0      disable LED support
-  Donnot enable LED support if your scsi board does not use SDMS BIOS.
-  (See 'Configuration parameters')
-
-10.2.9 Max wide
-        wide:1      wide scsi enabled
-        wide:0      wide scsi disabled
-  Some scsi boards use a 875 (ultra wide) and only supply narrow connectors.
-  If you have connected a wide device with a 50 pins to 68 pins cable 
-  converter, any accepted wide negotiation will break further data transfers.
-  In such a case, using "wide:0" in the bootup command will be helpfull. 
-
-10.2.10 Differential mode
-        diff:0	never set up diff mode
-        diff:1	set up diff mode if BIOS set it
-        diff:2	always set up diff mode
-        diff:3	set diff mode if GPIO3 is not set
-
-10.2.11 IRQ mode
-        irqm:0     always open drain
-        irqm:1     same as initial settings (assumed BIOS settings)
-        irqm:2     always totem pole
-
-10.2.12 Reverse probe
-        revprob:n   probe chip ids from the PCI configuration in this order:
-                    810, 815, 825, 860, 875, 885, 875A, 895, 896, 895A,
-                    1510D, 1010-33, 1010-66.
-        revprob:y   probe chip ids in the reverse order.
-
-10.2.13 Fix up PCI configuration space
-        pcifix:<option bits>
+10.2.10 Settle delay
+        settle=n	delay for n seconds
 
-    Available option bits:
-        0x0:   No attempt to fix PCI configuration space registers values.
-        0x1:   Set PCI cache-line size register if not set.
-        0x2:   Set write and invalidate bit in PCI command register.
-
-10.2.14 Serial NVRAM
-        nvram:n     do not look for serial NVRAM
-        nvram:y     test controllers for onboard serial NVRAM
+  After a bus reset, the driver will delay for n seconds before talking
+  to any device on the bus.  The default is 3 seconds and safe mode will
+  default it to 10.
+
+10.2.11 Serial NVRAM
+	NB: option not currently implemented.
+        nvram=n     do not look for serial NVRAM
+        nvram=y     test controllers for onboard serial NVRAM
         (alternate binary form)
         nvram=<bits options>
         0x01   look for NVRAM  (equivalent to nvram=y)
@@ -574,105 +547,28 @@ characters and digits are allowed.
         0x08   ignore NVRAM "Scan at boot time" parameter for all devices
         0x80   also attach controllers set to OFF in the NVRAM (sym53c8xx only)
 
-10.2.15 Check SCSI BUS 
-        buschk:<option bits>
-
-    Available option bits:
-        0x0:   No check.
-        0x1:   Check and do not attach the controller on error.  
-        0x2:   Check and just warn on error.
-
-10.2.16 Exclude a host from being attached
-        excl=<io_address>
+10.2.12 Exclude a host from being attached
+        excl=<io_address>,...
 
     Prevent host at a given io address from being attached.
-    For example 'sym53c8xx=excl:0xb400,excl:0xc000' indicate to the 
+    For example 'excl=0xb400,0xc000' indicate to the 
     driver not to attach hosts at address 0xb400 and 0xc000.
 
-10.2.17 Suggest a default SCSI id for hosts
-        hostid:255	no id suggested.
-        hostid:#x   (0 < x < 7) x suggested for hosts SCSI id.
-
-    If a host SCSI id is available from the NVRAM, the driver will ignore 
-    any value suggested as boot option. Otherwise, if a suggested value 
-    different from 255 has been supplied, it will use it. Otherwise, it will 
-    try to deduce the value previously set in the hardware and use value 
-    7 if the hardware value is zero.
-
-10.3 PCI configuration fix-up boot option
-
-pcifix:<option bits>
+10.3 Converting from old style options
 
-Available option bits:
-    0x1:     Set PCI cache-line size register if not set.
-    0x2:     Set write and invalidate bit in PCI command register.
+Previously, the sym2 driver accepted arguments of the form
+	sym53c8xx=tags:4,sync:10,debug:0x200
 
-Use 'pcifix:3' in order to allow the driver to fix both PCI features.
+As a result of the new module parameters, this is no longer available.
+Most of the options have remained the same, but tags has split into
+cmd_per_lun and tag_ctrl for its two different purposes.  The sample above
+would be specified as:
+	modprobe sym53c8xx cmd_per_lun=4 sync=10 debug=0x200
 
-Recent SYMBIOS 53C8XX scsi processors are able to use PCI read multiple 
-and PCI write and invalidate commands. These features require the 
-cache line size register to be properly set in the PCI configuration 
-space of the chips. On the other hand, chips will use PCI write and 
-invalidate commands only if the corresponding bit is set to 1 in the 
-PCI command register.
+or on the kernel boot line as:
+	sym53c8xx.cmd_per_lun=4 sym53c8xx.sync=10 sym53c8xx.debug=0x200
 
-Not all PCI bioses set the PCI cache line register and the PCI write and 
-invalidate bit in the PCI configuration space of 53C8XX chips.
-Optimized PCI accesses may be broken for some PCI/memory controllers or 
-make problems with some PCI boards.
-
-10.4 Serial NVRAM support boot option
-
-nvram:n     do not look for serial NVRAM
-nvram:y     test controllers for onboard serial NVRAM
-
-This option can also been entered as an hexadecimal value that allows 
-to control what information the driver will get from the NVRAM and what 
-information it will ignore.
-For details see '17. Serial NVRAM support'.
-
-When this option is enabled, the driver tries to detect all boards using 
-a Serial NVRAM. This memory is used to hold user set up parameters.
-
-The parameters the driver is able to get from the NVRAM depend on the 
-data format used, as follow:
-
-                                 Tekram format      Symbios format
-General and host parameters
-    Boot order                         N                   Y
-    Host SCSI ID                       Y                   Y
-    SCSI parity checking               Y                   Y
-    Verbose boot messages              N                   Y
-SCSI devices parameters
-    Synchronous transfer speed         Y                   Y
-    Wide 16 / Narrow                   Y                   Y
-    Tagged Command Queuing enabled     Y                   Y
-    Disconnections enabled             Y                   Y
-    Scan at boot time                  N                   Y
-
-In order to speed up the system boot, for each device configured without 
-the "scan at boot time" option, the driver forces an error on the 
-first TEST UNIT READY command received for this device.
-
-Some SDMS BIOS revisions seem to be unable to boot cleanly with very fast 
-hard disks. In such a situation you cannot configure the NVRAM with 
-optimized parameters value.
-
-The 'nvram' boot option can be entered in hexadecimal form in order 
-to ignore some options configured in the NVRAM, as follow:
-
-nvram=<bits options>
-      0x01   look for NVRAM  (equivalent to nvram=y)
-      0x02   ignore NVRAM "Synchronous negotiation" parameters for all devices
-      0x04   ignore NVRAM "Wide negotiation"  parameter for all devices
-      0x08   ignore NVRAM "Scan at boot time" parameter for all devices
-      0x80   also attach controllers set to OFF in the NVRAM (sym53c8xx only)
-
-Option 0x80 is disabled by default.
-Result is that, by default (option not set), the sym53c8xx driver will not 
-attach controllers set to OFF in the NVRAM.
-
-10.5 SCSI BUS checking boot option.
+10.4 SCSI BUS checking boot option.
 
 When this option is set to a non-zero value, the driver checks SCSI lines 
 logic state, 100 micro-seconds after having asserted the SCSI RESET line.
@@ -805,14 +701,8 @@ serial NVRAM is used by Symbios and Tekr
 host adaptor and it's attached drives.
 
 The Symbios NVRAM also holds data on the boot order of host adaptors in a
-system with more than one host adaptor. This enables the order of scanning
-the cards for drives to be changed from the default used during host adaptor
-detection.
-
-This can be done to a limited extent at the moment using "reverse probe" but
-this only changes the order of detection of different types of cards. The
-NVRAM boot order settings can do this as well as change the order the same
-types of cards are scanned in, something "reverse probe" cannot do.
+system with more than one host adaptor.  This information is no longer used
+as it's fundamentally incompatible with the hotplug PCI model.
 
 Tekram boards using Symbios chips, DC390W/F/U, which have NVRAM are detected
 and this is used to distinguish between Symbios compatible and Tekram host 
@@ -823,6 +713,26 @@ used together with the Symbios cards usi
 "diff" support. ("led pin" support for Symbios compatible cards can remain
 enabled when using Tekram cards. It does nothing useful for Tekram host
 adaptors but does not cause problems either.)
+
+The parameters the driver is able to get from the NVRAM depend on the 
+data format used, as follow:
+
+                                 Tekram format      Symbios format
+General and host parameters
+    Boot order                         N                   Y
+    Host SCSI ID                       Y                   Y
+    SCSI parity checking               Y                   Y
+    Verbose boot messages              N                   Y
+SCSI devices parameters
+    Synchronous transfer speed         Y                   Y
+    Wide 16 / Narrow                   Y                   Y
+    Tagged Command Queuing enabled     Y                   Y
+    Disconnections enabled             Y                   Y
+    Scan at boot time                  N                   Y
+
+In order to speed up the system boot, for each device configured without 
+the "scan at boot time" option, the driver forces an error on the 
+first TEST UNIT READY command received for this device.
 
 
 17.2 Symbios NVRAM layout
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym53c8xx.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym53c8xx.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym53c8xx.h	Thu Oct 21 14:39:25 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym53c8xx.h	Thu Oct 21 12:06:28 2004
@@ -68,7 +68,6 @@
  */
 #if 1
 #define	SYM_LINUX_PROC_INFO_SUPPORT
-#define SYM_LINUX_BOOT_COMMAND_LINE_SUPPORT
 #define SYM_LINUX_USER_COMMAND_SUPPORT
 #define SYM_LINUX_USER_INFO_SUPPORT
 #define SYM_LINUX_DEBUG_CONTROL_SUPPORT
@@ -129,9 +128,7 @@ struct sym_driver_setup {
 	u_char	scsi_bus_check;
 	u_char	host_id;
 
-	u_char	reverse_probe;
 	u_char	verbose;
-	u_short	debug;
 	u_char	settle_delay;
 	u_char	use_nvram;
 	u_long	excludes[8];
@@ -145,6 +142,7 @@ struct sym_driver_setup {
 #define SYM_SETUP_IRQ_MODE		sym_driver_setup.irq_mode
 #define SYM_SETUP_SCSI_BUS_CHECK	sym_driver_setup.scsi_bus_check
 #define SYM_SETUP_HOST_ID		sym_driver_setup.host_id
+#define boot_verbose			sym_driver_setup.verbose
 
 /* Always enable parity. */
 #define SYM_SETUP_PCI_PARITY		1
@@ -163,54 +161,13 @@ struct sym_driver_setup {
 	.irq_mode	= 0,					\
 	.scsi_bus_check	= 1,					\
 	.host_id	= 7,					\
-	.reverse_probe	= 0,					\
 	.verbose	= 0,					\
-	.debug		= 0,					\
 	.settle_delay	= 3,					\
 	.use_nvram	= 1,					\
 }
 
-/*
- *  Boot fail safe setup.
- *
- *  Override initial setup from boot command line:
- *    sym53c8xx=safe:y
- */
-#define SYM_LINUX_DRIVER_SAFE_SETUP {				\
-	.max_tag	= 0,					\
-	.burst_order	= 0,					\
-	.scsi_led	= 0,					\
-	.scsi_diff	= 1,					\
-	.irq_mode	= 0,					\
-	.scsi_bus_check	= 2,					\
-	.host_id	= 7,					\
-	.reverse_probe	= 0,					\
-	.verbose	= 2,					\
-	.debug		= 0,					\
-	.settle_delay	= 10,					\
-	.use_nvram	= 1,					\
-}
-
-/*
- *  This structure is initialized from linux config options.
- *  It can be overridden at boot-up by the boot command line.
- */
-#ifdef SYM_GLUE_C
-struct sym_driver_setup
-	sym_driver_setup = SYM_LINUX_DRIVER_SETUP;
-#ifdef SYM_LINUX_DEBUG_CONTROL_SUPPORT
-u_int	sym_debug_flags = 0;
-#endif
-#else
 extern struct sym_driver_setup sym_driver_setup;
-#ifdef SYM_LINUX_DEBUG_CONTROL_SUPPORT
-extern u_int sym_debug_flags;
-#endif
-#endif /* SYM_GLUE_C */
-
-#ifdef SYM_LINUX_DEBUG_CONTROL_SUPPORT
+extern unsigned int sym_debug_flags;
 #define DEBUG_FLAGS	sym_debug_flags
-#endif
-#define boot_verbose	sym_driver_setup.verbose
 
 #endif /* SYM53C8XX_H */
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h	Thu Oct 21 14:39:25 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h	Thu Oct 21 12:13:55 2004
@@ -40,33 +40,28 @@
 #ifndef SYM_DEFS_H
 #define SYM_DEFS_H
 
-#define SYM_VERSION "2.1.18k"
+#define SYM_VERSION "2.1.18m"
 #define SYM_DRIVER_NAME	"sym-" SYM_VERSION
 
 /*
- *  Vendor.
- */
-#define PCI_VENDOR_NCR		0x1000
-
-/*
  *  PCI device identifier of SYMBIOS chips.
  */
-#define PCI_ID_SYM53C810	1
-#define PCI_ID_SYM53C810AP	5
-#define PCI_ID_SYM53C815	4
-#define PCI_ID_SYM53C820	2
-#define PCI_ID_SYM53C825	3
-#define PCI_ID_SYM53C860	6
-#define PCI_ID_SYM53C875	0xf
-#define PCI_ID_SYM53C875_2	0x8f
-#define PCI_ID_SYM53C885	0xd
-#define PCI_ID_SYM53C895	0xc
-#define PCI_ID_SYM53C896	0xb
-#define PCI_ID_SYM53C895A	0x12
-#define PCI_ID_SYM53C875A	0x13
-#define PCI_ID_LSI53C1010_33	0x20
-#define PCI_ID_LSI53C1010_66	0x21
-#define PCI_ID_LSI53C1510D	0xa
+#define PCI_ID_SYM53C810	PCI_DEVICE_ID_NCR_53C810
+#define PCI_ID_SYM53C810AP	PCI_DEVICE_ID_LSI_53C810AP
+#define PCI_ID_SYM53C815	PCI_DEVICE_ID_NCR_53C815
+#define PCI_ID_SYM53C820	PCI_DEVICE_ID_NCR_53C820
+#define PCI_ID_SYM53C825	PCI_DEVICE_ID_NCR_53C825
+#define PCI_ID_SYM53C860	PCI_DEVICE_ID_NCR_53C860
+#define PCI_ID_SYM53C875	PCI_DEVICE_ID_NCR_53C875
+#define PCI_ID_SYM53C875_2	PCI_DEVICE_ID_NCR_53C875J
+#define PCI_ID_SYM53C885	PCI_DEVICE_ID_NCR_53C885
+#define PCI_ID_SYM53C895	PCI_DEVICE_ID_NCR_53C895
+#define PCI_ID_SYM53C896	PCI_DEVICE_ID_NCR_53C896
+#define PCI_ID_SYM53C895A	PCI_DEVICE_ID_LSI_53C895A
+#define PCI_ID_SYM53C875A	PCI_DEVICE_ID_LSI_53C875A
+#define PCI_ID_LSI53C1010_33	PCI_DEVICE_ID_LSI_53C1010_33
+#define PCI_ID_LSI53C1010_66	PCI_DEVICE_ID_LSI_53C1010_66
+#define PCI_ID_LSI53C1510D	PCI_DEVICE_ID_LSI_53C1510
 
 /*
  *	SYM53C8XX device features descriptor.
@@ -763,33 +758,32 @@ struct sym_tblsel {
  *	Messages
  */
 
-#define	M_COMPLETE	(0x00)
-#define	M_EXTENDED	(0x01)
-#define	M_SAVE_DP	(0x02)
-#define	M_RESTORE_DP	(0x03)
-#define	M_DISCONNECT	(0x04)
-#define	M_ID_ERROR	(0x05)
-#define	M_ABORT		(0x06)
-#define	M_REJECT	(0x07)
-#define	M_NOOP		(0x08)
-#define	M_PARITY	(0x09)
-#define	M_LCOMPLETE	(0x0a)
-#define	M_FCOMPLETE	(0x0b)
-#define	M_RESET		(0x0c)
+#define	M_COMPLETE	COMMAND_COMPLETE
+#define	M_EXTENDED	EXTENDED_MESSAGE
+#define	M_SAVE_DP	SAVE_POINTERS
+#define	M_RESTORE_DP	RESTORE_POINTERS
+#define	M_DISCONNECT	DISCONNECT
+#define	M_ID_ERROR	INITIATOR_ERROR
+#define	M_ABORT		ABORT
+#define	M_REJECT	MESSAGE_REJECT
+#define	M_NOOP		NOP
+#define	M_PARITY	MSG_PARITY_ERROR
+#define	M_LCOMPLETE	LINKED_CMD_COMPLETE
+#define	M_FCOMPLETE	LINKED_FLG_CMD_COMPLETE
+#define	M_RESET		BUS_DEVICE_RESET
 #define	M_ABORT_TAG	(0x0d)
 #define	M_CLEAR_QUEUE	(0x0e)
-#define	M_INIT_REC	(0x0f)
-#define	M_REL_REC	(0x10)
+#define	M_INIT_REC	INITIATE_RECOVERY
+#define	M_REL_REC	RELEASE_RECOVERY
 #define	M_TERMINATE	(0x11)
-#define	M_SIMPLE_TAG	(0x20)
-#define	M_HEAD_TAG	(0x21)
-#define	M_ORDERED_TAG	(0x22)
+#define	M_SIMPLE_TAG	SIMPLE_QUEUE_TAG
+#define	M_HEAD_TAG	HEAD_OF_QUEUE_TAG
+#define	M_ORDERED_TAG	ORDERED_QUEUE_TAG
 #define	M_IGN_RESIDUE	(0x23)
-#define	M_IDENTIFY   	(0x80)
 
-#define	M_X_MODIFY_DP	(0x00)
-#define	M_X_SYNC_REQ	(0x01)
-#define	M_X_WIDE_REQ	(0x03)
+#define	M_X_MODIFY_DP	EXTENDED_MODIFY_DATA_POINTER
+#define	M_X_SYNC_REQ	EXTENDED_SDTR
+#define	M_X_WIDE_REQ	EXTENDED_WDTR
 #define	M_X_PPR_REQ	(0x04)
 
 /*
@@ -804,15 +798,15 @@ struct sym_tblsel {
  *	Status
  */
 
-#define	S_GOOD		(0x00)
-#define	S_CHECK_COND	(0x02)
-#define	S_COND_MET	(0x04)
-#define	S_BUSY		(0x08)
-#define	S_INT		(0x10)
-#define	S_INT_COND_MET	(0x14)
-#define	S_CONFLICT	(0x18)
-#define	S_TERMINATED	(0x20)
-#define	S_QUEUE_FULL	(0x28)
+#define	S_GOOD		SAM_STAT_GOOD
+#define	S_CHECK_COND	SAM_STAT_CHECK_CONDITION
+#define	S_COND_MET	SAM_STAT_CONDITION_MET
+#define	S_BUSY		SAM_STAT_BUSY
+#define	S_INT		SAM_STAT_INTERMEDIATE
+#define	S_INT_COND_MET	SAM_STAT_INTERMEDIATE_CONDITION_MET
+#define	S_CONFLICT	SAM_STAT_RESERVATION_CONFLICT
+#define	S_TERMINATED	SAM_STAT_COMMAND_TERMINATED
+#define	S_QUEUE_FULL	SAM_STAT_TASK_SET_FULL
 #define	S_ILLEGAL	(0xff)
 
 #endif /* defined SYM_DEFS_H */
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c	Thu Oct 21 14:39:25 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c	Thu Oct 21 15:10:19 2004
@@ -37,12 +37,11 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
-#define SYM_GLUE_C
-
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/spinlock.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
@@ -56,6 +55,77 @@
 #define NAME53C		"sym53c"
 #define NAME53C8XX	"sym53c8xx"
 
+struct sym_driver_setup sym_driver_setup = SYM_LINUX_DRIVER_SETUP;
+unsigned int sym_debug_flags = 0;
+
+static char *excl_string;
+static char *safe_string;
+module_param_named(cmd_per_lun, sym_driver_setup.max_tag, ushort, 0);
+module_param_string(tag_ctrl, sym_driver_setup.tag_ctrl, 100, 0);
+module_param_named(burst, sym_driver_setup.burst_order, byte, 0);
+module_param_named(led, sym_driver_setup.scsi_led, byte, 0);
+module_param_named(diff, sym_driver_setup.scsi_diff, byte, 0);
+module_param_named(irqm, sym_driver_setup.irq_mode, byte, 0);
+module_param_named(buschk, sym_driver_setup.scsi_bus_check, byte, 0);
+module_param_named(hostid, sym_driver_setup.host_id, byte, 0);
+module_param_named(verb, sym_driver_setup.verbose, byte, 0);
+module_param_named(debug, sym_debug_flags, uint, 0);
+module_param_named(settle, sym_driver_setup.settle_delay, byte, 0);
+module_param_named(nvram, sym_driver_setup.use_nvram, byte, 0);
+module_param_named(excl, excl_string, charp, 0);
+module_param_named(safe, safe_string, charp, 0);
+
+MODULE_PARM_DESC(cmd_per_lun, "The maximum number of tags to use by default");
+MODULE_PARM_DESC(tag_ctrl, "More detailed control over tags per LUN");
+MODULE_PARM_DESC(burst, "Maximum burst.  0 to disable, 255 to read from registers");
+MODULE_PARM_DESC(led, "Set to 1 to enable LED support");
+MODULE_PARM_DESC(diff, "0 for no differential mode, 1 for BIOS, 2 for always, 3 for not GPIO3");
+MODULE_PARM_DESC(irqm, "0 for open drain, 1 to leave alone, 2 for totem pole");
+MODULE_PARM_DESC(buschk, "0 to not check, 1 for detach on error, 2 for warn on error");
+MODULE_PARM_DESC(hostid, "The SCSI ID to use for the host adapters");
+MODULE_PARM_DESC(verb, "0 for minimal verbosity, 1 for normal, 2 for excessive");
+MODULE_PARM_DESC(debug, "Set bits to enable debugging");
+MODULE_PARM_DESC(settle, "Settle delay in seconds.  Default 3");
+MODULE_PARM_DESC(nvram, "Option currently not used");
+MODULE_PARM_DESC(excl, "List ioport addresses here to prevent controllers from being attached");
+MODULE_PARM_DESC(safe, "Set other settings to a \"safe mode\"");
+
+MODULE_LICENSE("GPL");
+MODULE_VERSION(SYM_VERSION);
+MODULE_AUTHOR("Matthew Wilcox <matthew@wil.cx>");
+MODULE_DESCRIPTION("NCR, Symbios and LSI 8xx and 1010 PCI SCSI adapters");
+
+static void sym2_setup_params(void)
+{
+	char *p = excl_string;
+	int xi = 0;
+
+	while (p && (xi < 8)) {
+		char *next_p;
+		int val = (int) simple_strtoul(p, &next_p, 0);
+		sym_driver_setup.excludes[xi++] = val;
+		p = next_p;
+	}
+
+	if (safe_string) {
+		if (*safe_string == 'y') {
+			sym_driver_setup.max_tag = 0;
+			sym_driver_setup.burst_order = 0;
+			sym_driver_setup.scsi_led = 0;
+			sym_driver_setup.scsi_diff = 1;
+			sym_driver_setup.irq_mode = 0;
+			sym_driver_setup.scsi_bus_check = 2;
+			sym_driver_setup.host_id = 7;
+			sym_driver_setup.verbose = 2;
+			sym_driver_setup.settle_delay = 10;
+			sym_driver_setup.use_nvram = 1;
+		} else if (*safe_string != 'n') {
+			printk(KERN_WARNING NAME53C8XX "Ignoring parameter %s"
+					" passed to safe option", safe_string);
+		}
+	}
+}
+
 static int __devinit
 pci_get_base_address(struct pci_dev *pdev, int index, u_long *base)
 {
@@ -135,7 +205,7 @@ m_addr_t __vtobus(m_pool_ident_t dev_dma
  *  It is allocated on the eh thread stack.
  */
 struct sym_eh_wait {
-	struct semaphore sem;
+	struct completion done;
 	struct timer_list timer;
 	void (*old_done)(struct scsi_cmnd *);
 	int to_do;
@@ -146,7 +216,6 @@ struct sym_eh_wait {
  *  Driver private area in the SCSI command structure.
  */
 struct sym_ucmd {		/* Override the SCSI pointer structure */
-	SYM_QUEHEAD link_cmdq;	/* Must stay at offset ZERO */
 	dma_addr_t data_mapping;
 	u_char	data_mapped;
 	struct sym_eh_wait *eh_wait;
@@ -212,7 +281,6 @@ static int __map_scsi_sg_data(struct pci
  */
 void sym_xpt_done(struct sym_hcb *np, struct scsi_cmnd *ccb)
 {
-	sym_remque(&SYM_UCMD_PTR(ccb)->link_cmdq);
 	unmap_scsi_data(np, ccb);
 	ccb->scsi_done(ccb);
 }
@@ -648,31 +716,6 @@ void sym_log_bus_error(struct sym_hcb *n
 	}
 }
 
-
-/*
- *  Requeue awaiting commands.
- */
-static void sym_requeue_awaiting_cmds(struct sym_hcb *np)
-{
-	struct sym_ucmd *ucp;
-	SYM_QUEHEAD tmp_cmdq;
-	int sts;
-
-	sym_que_move(&np->s.wait_cmdq, &tmp_cmdq);
-
-	while ((ucp = (struct sym_ucmd *) sym_remque_head(&tmp_cmdq)) != 0) {
-		struct scsi_cmnd *cmd;
-
-		sym_insque_tail(&ucp->link_cmdq, &np->s.busy_cmdq);
-		cmd = SYM_SCMD_PTR(ucp);
-		sts = sym_queue_command(np, cmd);
-		if (sts) {
-			sym_remque(&ucp->link_cmdq);
-			sym_insque_head(&ucp->link_cmdq, &np->s.wait_cmdq);
-		}
-	}
-}
-
 /*
  * queuecommand method.  Entered with the host adapter lock held and
  * interrupts disabled.
@@ -700,18 +743,12 @@ static int sym53c8xx_queue_command(struc
 		}
 	}
 
-	if (np->s.settle_time_valid || !sym_que_empty(&np->s.wait_cmdq)) {
-		sym_insque_tail(&ucp->link_cmdq, &np->s.wait_cmdq);
-		goto out;
-	}
+	if (np->s.settle_time_valid)
+		return SCSI_MLQUEUE_HOST_BUSY;
 
-	sym_insque_tail(&ucp->link_cmdq, &np->s.busy_cmdq);
 	sts = sym_queue_command(np, cmd);
-	if (sts) {
-		sym_remque(&ucp->link_cmdq);
-		sym_insque_tail(&ucp->link_cmdq, &np->s.wait_cmdq);
-	}
-out:
+	if (sts)
+		return SCSI_MLQUEUE_HOST_BUSY;
 	return 0;
 }
 
@@ -726,15 +763,7 @@ static irqreturn_t sym53c8xx_intr(int ir
 	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("[");
 
 	spin_lock_irqsave(np->s.host->host_lock, flags);
-
 	sym_interrupt(np);
-
-	/*
-	 * push queue walk-through to tasklet
-	 */
-	if (!sym_que_empty(&np->s.wait_cmdq) && !np->s.settle_time_valid)
-		sym_requeue_awaiting_cmds(np);
-
 	spin_unlock_irqrestore(np->s.host->host_lock, flags);
 
 	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("]\n");
@@ -751,12 +780,7 @@ static void sym53c8xx_timer(unsigned lon
 	unsigned long flags;
 
 	spin_lock_irqsave(np->s.host->host_lock, flags);
-
 	sym_timer(np);
-
-	if (!sym_que_empty(&np->s.wait_cmdq) && !np->s.settle_time_valid)
-		sym_requeue_awaiting_cmds(np);
-
 	spin_unlock_irqrestore(np->s.host->host_lock, flags);
 }
 
@@ -798,7 +822,7 @@ static void __sym_eh_done(struct scsi_cm
 
 	/* Wake up the eh thread if it wants to sleep */
 	if (ep->to_do == SYM_EH_DO_WAIT)
-		up(&ep->sem);
+		complete(&ep->done);
 }
 
 /*
@@ -834,14 +858,6 @@ static int sym_eh_handler(int op, char *
 		goto prepare;
 #endif
 
-	/* This one is not queued to the core driver -> to complete here */ 
-	FOR_EACH_QUEUED_ELEMENT(&np->s.wait_cmdq, qp) {
-		if (SYM_SCMD_PTR(qp) == cmd) {
-			to_do = SYM_EH_DO_COMPLETE;
-			goto prepare;
-		}
-	}
-
 	/* This one is queued in some place -> to wait for completion */
 	FOR_EACH_QUEUED_ELEMENT(&np->busy_ccbq, qp) {
 		struct sym_ccb *cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
@@ -858,7 +874,7 @@ prepare:
 	case SYM_EH_DO_IGNORE:
 		break;
 	case SYM_EH_DO_WAIT:
-		init_MUTEX_LOCKED(&ep->sem);
+		init_completion(&ep->done);
 		/* fall through */
 	case SYM_EH_DO_COMPLETE:
 		ep->old_done = cmd->scsi_done;
@@ -909,7 +925,7 @@ prepare:
 		ep->timed_out = 1;	/* Be pessimistic for once :) */
 		add_timer(&ep->timer);
 		spin_unlock_irq(np->s.host->host_lock);
-		down(&ep->sem);
+		wait_for_completion(&ep->done);
 		spin_lock_irq(np->s.host->host_lock);
 		if (ep->timed_out)
 			sts = -2;
@@ -973,7 +989,6 @@ static void sym_tune_dev_queuing(struct 
 	}
 }
 
-#ifdef	SYM_LINUX_BOOT_COMMAND_LINE_SUPPORT
 /*
  *  Linux select queue depths function
  */
@@ -1026,9 +1041,6 @@ static int device_queue_depth(struct sym
 	}
 	return DEF_DEPTH;
 }
-#else
-#define device_queue_depth(np, t, l)	(sym_driver_setup.max_tag)
-#endif	/* SYM_LINUX_BOOT_COMMAND_LINE_SUPPORT */
 
 /*
  * Linux entry point for device queue sizing.
@@ -1164,7 +1176,7 @@ static void sym_exec_user_command (struc
 				if (uc->data <= 9 && np->minsync_dt) {
 					if (uc->data < np->minsync_dt)
 						uc->data = np->minsync_dt;
-					tp->tinfo.goal.options = PPR_OPT_DT;
+					tp->tinfo.goal.options = PPR_OPT_MASK;
 					tp->tinfo.goal.width   = 1;
 					tp->tinfo.goal.period = uc->data;
 					tp->tinfo.goal.offset = np->maxoffs_dt;
@@ -1732,12 +1744,6 @@ static struct Scsi_Host * __devinit sym_
 		goto reset_failed;
 
 	/*
-	 *  Initialize some queue headers.
-	 */
-	sym_que_init(&np->s.wait_cmdq);
-	sym_que_init(&np->s.busy_cmdq);
-
-	/*
 	 *  Start the SCRIPTS.
 	 */
 	sym_start_up (np, 1);
@@ -1828,145 +1834,6 @@ static inline void sym_get_nvram(struct 
 }
 #endif	/* SYM_CONF_NVRAM_SUPPORT */
 
-/*
- *  Driver setup from the boot command line
- */
-#ifdef	SYM_LINUX_BOOT_COMMAND_LINE_SUPPORT
-
-static struct sym_driver_setup
-	sym_driver_safe_setup __initdata = SYM_LINUX_DRIVER_SAFE_SETUP;
-#ifdef	MODULE
-char *sym53c8xx;	/* command line passed by insmod */
-MODULE_PARM(sym53c8xx, "s");
-#endif
-
-#define OPT_MAX_TAG		1
-#define OPT_BURST_ORDER		2
-#define OPT_SCSI_LED		3
-#define OPT_SCSI_DIFF		4
-#define OPT_IRQ_MODE		5
-#define OPT_SCSI_BUS_CHECK	6
-#define	OPT_HOST_ID		7
-#define OPT_REVERSE_PROBE	8
-#define OPT_VERBOSE		9
-#define OPT_DEBUG		10
-#define OPT_SETTLE_DELAY	11
-#define OPT_USE_NVRAM		12
-#define OPT_EXCLUDE		13
-#define OPT_SAFE_SETUP		14
-
-static char setup_token[] __initdata =
-	"tags:"		"burst:"
-	"led:"		"diff:"
-	"irqm:"		"buschk:"
-	"hostid:"	"revprob:"
-	"verb:"		"debug:"
-	"settle:"	"nvram:"
-	"excl:"		"safe:"
-	;
-
-#ifdef MODULE
-#define	ARG_SEP	' '
-#else
-#define	ARG_SEP	','
-#endif
-
-static int __init get_setup_token(char *p)
-{
-	char *cur = setup_token;
-	char *pc;
-	int i = 0;
-
-	while (cur != NULL && (pc = strchr(cur, ':')) != NULL) {
-		++pc;
-		++i;
-		if (!strncmp(p, cur, pc - cur))
-			return i;
-		cur = pc;
-	}
-	return 0;
-}
-#endif	/* SYM_LINUX_BOOT_COMMAND_LINE_SUPPORT */
-
-int __init sym53c8xx_setup(char *str)
-{
-#ifdef	SYM_LINUX_BOOT_COMMAND_LINE_SUPPORT
-	char *cur = str;
-	char *pc, *pv;
-	unsigned long val;
-	unsigned int i,  c;
-	int xi = 0;
-
-	while (cur != NULL && (pc = strchr(cur, ':')) != NULL) {
-		char *pe;
-
-		val = 0;
-		pv = pc;
-		c = *++pv;
-
-		if	(c == 'n')
-			val = 0;
-		else if	(c == 'y')
-			val = 1;
-		else
-			val = (int) simple_strtoul(pv, &pe, 0);
-
-		switch (get_setup_token(cur)) {
-		case OPT_MAX_TAG:
-			sym_driver_setup.max_tag = val;
-			if (!(pe && *pe == '/'))
-				break;
-			i = 0;
-			while (*pe && *pe != ARG_SEP && 
-				i < sizeof(sym_driver_setup.tag_ctrl)-1) {
-				sym_driver_setup.tag_ctrl[i++] = *pe++;
-			}
-			sym_driver_setup.tag_ctrl[i] = '\0';
-			break;
-		case OPT_SAFE_SETUP:
-			memcpy(&sym_driver_setup, &sym_driver_safe_setup,
-				sizeof(sym_driver_setup));
-			break;
-		case OPT_EXCLUDE:
-			if (xi < 8)
-				sym_driver_setup.excludes[xi++] = val;
-			break;
-
-#define __SIMPLE_OPTION(NAME, name) \
-		case OPT_ ## NAME :		\
-			sym_driver_setup.name = val;\
-			break;
-
-		__SIMPLE_OPTION(BURST_ORDER, burst_order)
-		__SIMPLE_OPTION(SCSI_LED, scsi_led)
-		__SIMPLE_OPTION(SCSI_DIFF, scsi_diff)
-		__SIMPLE_OPTION(IRQ_MODE, irq_mode)
-		__SIMPLE_OPTION(SCSI_BUS_CHECK, scsi_bus_check)
-		__SIMPLE_OPTION(HOST_ID, host_id)
-		__SIMPLE_OPTION(REVERSE_PROBE, reverse_probe)
-		__SIMPLE_OPTION(VERBOSE, verbose)
-		__SIMPLE_OPTION(DEBUG, debug)
-		__SIMPLE_OPTION(SETTLE_DELAY, settle_delay)
-		__SIMPLE_OPTION(USE_NVRAM, use_nvram)
-
-#undef __SIMPLE_OPTION
-
-		default:
-			printk("sym53c8xx_setup: unexpected boot option '%.*s' ignored\n", (int)(pc-cur+1), cur);
-			break;
-		}
-
-		if ((cur = strchr(cur, ARG_SEP)) != NULL)
-			++cur;
-	}
-#endif	/* SYM_LINUX_BOOT_COMMAND_LINE_SUPPORT */
-	return 1;
-}
-
-#ifndef MODULE
-__setup("sym53c8xx=", sym53c8xx_setup);
-#endif
-
 static int __devinit sym_check_supported(struct sym_device *device)
 {
 	struct sym_pci_chip *chip;
@@ -2029,7 +1896,7 @@ static int __devinit sym_check_raid(stru
 {
 	unsigned long base_2_c = device->s.base_2_c;
 	unsigned int ram_size, ram_val;
-	void *ram_ptr;
+	void __iomem *ram_ptr;
 
 	if (!base_2_c)
 		return 0;
@@ -2111,6 +1978,7 @@ sym_init_device(struct pci_dev *pdev, st
 	unsigned long base, base_2; 
 	int i;
 
+	device->host_id = SYM_SETUP_HOST_ID;
 	device->pdev = pdev;
 	device->s.irq = pdev->irq;
 
@@ -2145,9 +2013,9 @@ sym_init_device(struct pci_dev *pdev, st
 void sym_config_pqs(struct pci_dev *pdev, struct sym_device *sym_dev)
 {
 	int slot;
+	u8 tmp;
 
 	for (slot = 0; slot < 256; slot++) {
-		u8 tmp;
 		struct pci_dev *memc = pci_get_slot(pdev->bus, slot);
 
 		if (!memc || memc->vendor != 0x101a || memc->device == 0x0009) {
@@ -2155,28 +2023,26 @@ void sym_config_pqs(struct pci_dev *pdev
 			continue;
 		}
 
-		/*
-		 * We set these bits in the memory controller once per 875.
-		 * This isn't a problem in practice.
-		 */
-
 		/* bit 1: allow individual 875 configuration */
 		pci_read_config_byte(memc, 0x44, &tmp);
-		tmp |= 0x2;
-		pci_write_config_byte(memc, 0x44, tmp);
+		if ((tmp & 0x2) == 0) {
+			tmp |= 0x2;
+			pci_write_config_byte(memc, 0x44, tmp);
+		}
 
 		/* bit 2: drive individual 875 interrupts to the bus */
 		pci_read_config_byte(memc, 0x45, &tmp);
-		tmp |= 0x4;
-		pci_write_config_byte(memc, 0x45, tmp);
-
-		pci_read_config_byte(pdev, 0x84, &tmp);
-		sym_dev->host_id = tmp;
+		if ((tmp & 0x4) == 0) {
+			tmp |= 0x4;
+			pci_write_config_byte(memc, 0x45, tmp);
+		}
 
 		pci_dev_put(memc);
-
 		break;
 	}
+
+	pci_read_config_byte(pdev, 0x84, &tmp);
+	sym_dev->host_id = tmp;
 }
 
 /*
@@ -2205,9 +2071,6 @@ static int sym_detach(struct sym_hcb *np
 	return 1;
 }
 
-MODULE_LICENSE("GPL");
-MODULE_VERSION(SYM_VERSION);
-
 /*
  * Driver host template.
  */
@@ -2249,8 +2112,6 @@ static int __devinit sym2_probe(struct p
 	if (pci_request_regions(pdev, NAME53C8XX))
 		goto disable;
 
-	sym_dev.host_id = SYM_SETUP_HOST_ID;
-
 	sym_init_device(pdev, &sym_dev);
 	if (sym_check_supported(&sym_dev))
 		goto free;
@@ -2381,9 +2242,10 @@ static void sym2_set_width(struct scsi_t
 	struct sym_hcb *np = ((struct host_data *)shost->hostdata)->ncb;
 	struct sym_tcb *tp = &np->target[starget->id];
 
-	/* It is illegal to have DT set on narrow transfers */
+	/* It is illegal to have DT set on narrow transfers.  If DT is
+	 * clear, we must also clear IU and QAS.  */
 	if (width == 0)
-		tp->tinfo.goal.options &= ~PPR_OPT_DT;
+		tp->tinfo.goal.options &= ~PPR_OPT_MASK;
 
 	tp->tinfo.goal.width = width;
 }
@@ -2403,12 +2265,55 @@ static void sym2_set_dt(struct scsi_targ
 	struct sym_hcb *np = ((struct host_data *)shost->hostdata)->ncb;
 	struct sym_tcb *tp = &np->target[starget->id];
 
+	/* We must clear QAS and IU if DT is clear */
 	if (dt)
 		tp->tinfo.goal.options |= PPR_OPT_DT;
 	else
-		tp->tinfo.goal.options &= ~PPR_OPT_DT;
+		tp->tinfo.goal.options &= ~PPR_OPT_MASK;
 }
-	
+
+static void sym2_get_iu(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct sym_hcb *np = ((struct host_data *)shost->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[starget->id];
+
+	spi_iu(starget) = (tp->tinfo.curr.options & PPR_OPT_IU) ? 1 : 0;
+}
+
+static void sym2_set_iu(struct scsi_target *starget, int iu)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct sym_hcb *np = ((struct host_data *)shost->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[starget->id];
+
+	if (iu)
+		tp->tinfo.goal.options |= PPR_OPT_IU | PPR_OPT_DT;
+	else
+		tp->tinfo.goal.options &= ~PPR_OPT_IU;
+}
+
+static void sym2_get_qas(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct sym_hcb *np = ((struct host_data *)shost->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[starget->id];
+
+	spi_qas(starget) = (tp->tinfo.curr.options & PPR_OPT_QAS) ? 1 : 0;
+}
+
+static void sym2_set_qas(struct scsi_target *starget, int qas)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct sym_hcb *np = ((struct host_data *)shost->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[starget->id];
+
+	if (starget)
+		tp->tinfo.goal.options |= PPR_OPT_QAS | PPR_OPT_DT;
+	else
+		tp->tinfo.goal.options &= ~PPR_OPT_QAS;
+}
+
 
 static struct spi_function_template sym2_transport_functions = {
 	.set_offset	= sym2_set_offset,
@@ -2423,6 +2328,12 @@ static struct spi_function_template sym2
 	.get_dt		= sym2_get_dt,
 	.set_dt		= sym2_set_dt,
 	.show_dt	= 1,
+	.get_iu		= sym2_get_iu,
+	.set_iu		= sym2_set_iu,
+	.show_iu	= 1,
+	.get_qas	= sym2_get_qas,
+	.set_qas	= sym2_set_qas,
+	.show_qas	= 1,
 	.get_signalling	= sym2_get_signalling,
 };
 
@@ -2475,12 +2386,17 @@ static struct pci_driver sym2_driver = {
 
 static int __init sym2_init(void)
 {
+	int error;
+
+	sym2_setup_params();
 	sym2_transport_template = spi_attach_transport(&sym2_transport_functions);
 	if (!sym2_transport_template)
 		return -ENODEV;
 
-	pci_register_driver(&sym2_driver);
-	return 0;
+	error = pci_module_init(&sym2_driver);
+	if (error)
+		spi_release_transport(sym2_transport_template);
+	return error;
 }
 
 static void __exit sym2_exit(void)
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h	Thu Oct 21 14:39:25 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h	Thu Oct 21 12:06:28 2004
@@ -381,9 +381,6 @@ struct sym_shcb {
 	u_short		io_ws;		/* IO window size		*/
 	int		irq;		/* IRQ number			*/
 
-	SYM_QUEHEAD	wait_cmdq;	/* Awaiting SCSI commands	*/
-	SYM_QUEHEAD	busy_cmdq;	/* Enqueued SCSI commands	*/
-
 	struct timer_list timer;	/* Timer handler link header	*/
 	u_long		lasttime;
 	u_long		settle_time;	/* Resetting the SCSI BUS	*/
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c	Thu Oct 21 14:39:25 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c	Thu Oct 21 12:06:29 2004
@@ -1503,6 +1503,7 @@ static void sym_check_goals(struct scsi_
 		if (st->period > np->maxsync_dt)
 			st->period = np->maxsync_dt;
 	} else {
+		st->options &= ~PPR_OPT_MASK;
 		if (st->offset > np->maxoffs)
 			st->offset = np->maxoffs;
 		if (st->period < np->minsync)
@@ -1510,7 +1511,7 @@ static void sym_check_goals(struct scsi_
 		if (st->period > np->maxsync)
 			st->period = np->maxsync;
 	}
-}		
+}
 
 /*
  *  Prepare the next negotiation message if needed.
@@ -1575,7 +1576,7 @@ static int sym_prepare_nego(hcb_p np, cc
 		msgptr[msglen++] = 0;
 		msgptr[msglen++] = tp->tinfo.goal.offset;
 		msgptr[msglen++] = tp->tinfo.goal.width;
-		msgptr[msglen++] = tp->tinfo.goal.options & PPR_OPT_DT;
+		msgptr[msglen++] = tp->tinfo.goal.options & PPR_OPT_MASK;
 		break;
 	};
 
@@ -2009,7 +2010,7 @@ void sym_start_up (hcb_p np, int reason)
 /*
  *  Switch trans mode for current job and it's target.
  */
-static void sym_settrans(hcb_p np, int target, u_char dt, u_char ofs,
+static void sym_settrans(hcb_p np, int target, u_char opts, u_char ofs,
 			 u_char per, u_char wide, u_char div, u_char fak)
 {
 	SYM_QUEHEAD *qp;
@@ -2060,7 +2061,7 @@ static void sym_settrans(hcb_p np, int t
 	 */
 	if (np->features & FE_C10) {
 		uval = uval & ~(U3EN|AIPCKEN);
-		if (dt)	{
+		if (opts)	{
 			assert(np->features & FE_U3EN);
 			uval |= U3EN;
 		}
@@ -2163,17 +2164,17 @@ sym_setsync(hcb_p np, int target,
  *  Let everything be aware of the changes.
  */
 static void 
-sym_setpprot(hcb_p np, int target, u_char dt, u_char ofs,
+sym_setpprot(hcb_p np, int target, u_char opts, u_char ofs,
              u_char per, u_char wide, u_char div, u_char fak)
 {
 	tcb_p tp = &np->target[target];
 
-	sym_settrans(np, target, dt, ofs, per, wide, div, fak);
+	sym_settrans(np, target, opts, ofs, per, wide, div, fak);
 
 	tp->tinfo.goal.width	= tp->tinfo.curr.width  = wide;
 	tp->tinfo.goal.period	= tp->tinfo.curr.period = per;
 	tp->tinfo.goal.offset	= tp->tinfo.curr.offset = ofs;
-	tp->tinfo.goal.options	= tp->tinfo.curr.options = dt;
+	tp->tinfo.goal.options	= tp->tinfo.curr.options = opts;
 
 	sym_xpt_async_nego_ppr(np, target);
 }
@@ -2734,7 +2735,7 @@ unexpected_phase:
 		if	(dsp == SCRIPTA_BA (np, send_ident)) {
 			if (cp->tag != NO_TAG && olen - rest <= 3) {
 				cp->host_status = HS_BUSY;
-				np->msgout[0] = M_IDENTIFY | cp->lun;
+				np->msgout[0] = IDENTIFY(0, cp->lun);
 				nxtdsp = SCRIPTB_BA (np, ident_break_atn);
 			}
 			else
@@ -3163,10 +3164,7 @@ static void sym_sir_bad_scsi_status(hcb_
 		 *  requesting sense data.
 		 */
 
-		/*
-		 *  identify message
-		 */
-		cp->scsi_smsg2[0] = M_IDENTIFY | cp->lun;
+		cp->scsi_smsg2[0] = IDENTIFY(0, cp->lun);
 		msglen = 1;
 
 		/*
@@ -3525,8 +3523,8 @@ static void sym_sir_task_recovery(hcb_p 
 		 */
 		if (lun != -1) {
 			lcb_p lp = sym_lp(np, tp, lun);
-			lp->to_clear = 0; /* We donnot expect to fail here */
-			np->abrt_msg[0] = M_IDENTIFY | lun;
+			lp->to_clear = 0; /* We don't expect to fail here */
+			np->abrt_msg[0] = IDENTIFY(0, lun);
 			np->abrt_msg[1] = M_ABORT;
 			np->abrt_tbl.size = 2;
 			break;
@@ -3567,7 +3565,7 @@ static void sym_sir_task_recovery(hcb_p 
 		 *  We have some task to abort.
 		 *  Set the IDENTIFY(lun)
 		 */
-		np->abrt_msg[0] = M_IDENTIFY | cp->lun;
+		np->abrt_msg[0] = IDENTIFY(0, cp->lun);
 
 		/*
 		 *  If we want to abort an untagged command, we 
@@ -3578,8 +3576,7 @@ static void sym_sir_task_recovery(hcb_p 
 		if (cp->tag == NO_TAG) {
 			np->abrt_msg[1] = M_ABORT;
 			np->abrt_tbl.size = 2;
-		}
-		else {
+		} else {
 			np->abrt_msg[1] = cp->scsi_smsg[1];
 			np->abrt_msg[2] = cp->scsi_smsg[2];
 			np->abrt_msg[3] = M_ABORT_TAG;
@@ -4139,20 +4136,17 @@ static int 
 sym_ppr_nego_check(hcb_p np, int req, int target)
 {
 	tcb_p tp = &np->target[target];
-	u_char	chg, ofs, per, fak, dt, div, wide;
+	unsigned char fak, div;
+	int dt, chg = 0;
+
+	unsigned char per = np->msgin[3];
+	unsigned char ofs = np->msgin[5];
+	unsigned char wide = np->msgin[6];
+	unsigned char opts = np->msgin[7] & PPR_OPT_MASK;
 
 	if (DEBUG_FLAGS & DEBUG_NEGO) {
 		sym_print_nego_msg(np, target, "ppr msgin", np->msgin);
-	};
-
-	/*
-	 *  Get requested values.
-	 */
-	chg  = 0;
-	per  = np->msgin[3];
-	ofs  = np->msgin[5];
-	wide = np->msgin[6];
-	dt   = np->msgin[7] & PPR_OPT_DT;
+	}
 
 	/*
 	 *  Check values against our limits.
@@ -4162,29 +4156,30 @@ sym_ppr_nego_check(hcb_p np, int req, in
 		wide = np->maxwide;
 	}
 	if (!wide || !(np->features & FE_ULTRA3))
-		dt &= ~PPR_OPT_DT;
+		opts = 0;
 
 	if (!(np->features & FE_U3EN))	/* Broken U3EN bit not supported */
-		dt &= ~PPR_OPT_DT;
+		opts = 0;
+
+	if (opts != (np->msgin[7] & PPR_OPT_MASK))
+		chg = 1;
 
-	if (dt != (np->msgin[7] & PPR_OPT_MASK)) chg = 1;
+	dt = opts & PPR_OPT_DT;
 
 	if (ofs) {
-		if (dt) {
-			if (ofs > np->maxoffs_dt)
-				{chg = 1; ofs = np->maxoffs_dt;}
+		unsigned char maxoffs = dt ? np->maxoffs_dt : np->maxoffs;
+		if (ofs > maxoffs) {
+			chg = 1;
+			ofs = maxoffs;
 		}
-		else if (ofs > np->maxoffs)
-			{chg = 1; ofs = np->maxoffs;}
 	}
 
 	if (ofs) {
-		if (dt) {
-			if (per < np->minsync_dt)
-				{chg = 1; per = np->minsync_dt;}
+		unsigned char minsync = dt ? np->minsync_dt : np->minsync;
+		if (per < np->minsync_dt) {
+			chg = 1;
+			per = minsync;
 		}
-		else if (per < np->minsync)
-			{chg = 1; per = np->minsync;}
 	}
 
 	/*
@@ -4204,7 +4199,7 @@ sym_ppr_nego_check(hcb_p np, int req, in
 	/*
 	 *  Apply new values.
 	 */
-	sym_setpprot (np, target, dt, ofs, per, wide, div, fak);
+	sym_setpprot(np, target, opts, ofs, per, wide, div, fak);
 
 	/*
 	 *  It was an answer. We are done.
@@ -4222,7 +4217,7 @@ sym_ppr_nego_check(hcb_p np, int req, in
 	np->msgout[4] = 0;
 	np->msgout[5] = ofs;
 	np->msgout[6] = wide;
-	np->msgout[7] = dt;
+	np->msgout[7] = opts;
 
 	if (DEBUG_FLAGS & DEBUG_NEGO) {
 		sym_print_nego_msg(np, target, "ppr msgout", np->msgout);
@@ -4238,7 +4233,7 @@ reject_it:
 	 *  If it is a device response that should result in  
 	 *  ST, we may want to try a legacy negotiation later.
 	 */
-	if (!req && !dt) {
+	if (!req && !opts) {
 		tp->tinfo.goal.options = 0;
 		tp->tinfo.goal.width   = wide;
 		tp->tinfo.goal.period  = per;
@@ -5271,8 +5266,9 @@ int sym_queue_scsiio(hcb_p np, cam_scsii
 {
 	tcb_p	tp;
 	lcb_p	lp;
-	u_char	idmsg, *msgptr;
+	u_char	*msgptr;
 	u_int   msglen;
+	int can_disconnect;
 
 	/*
 	 *  Keep track of the IO in our CCB.
@@ -5280,25 +5276,21 @@ int sym_queue_scsiio(hcb_p np, cam_scsii
 	cp->cam_ccb = (cam_ccb_p) csio;
 
 	/*
-	 *  Retreive the target descriptor.
+	 *  Retrieve the target descriptor.
 	 */
 	tp = &np->target[cp->target];
 
 	/*
-	 *  Retreive the lun descriptor.
+	 *  Retrieve the lun descriptor.
 	 */
 	lp = sym_lp(np, tp, cp->lun);
 
-	/*
-	 *  Build the IDENTIFY message.
-	 */
-	idmsg = M_IDENTIFY | cp->lun;
-	if (cp->tag != NO_TAG || (lp && (lp->curr_flags & SYM_DISC_ENABLED)))
-		idmsg |= 0x40;
+	can_disconnect = (cp->tag != NO_TAG) ||
+		(lp && (lp->curr_flags & SYM_DISC_ENABLED));
 
 	msgptr = cp->scsi_smsg;
 	msglen = 0;
-	msgptr[msglen++] = idmsg;
+	msgptr[msglen++] = IDENTIFY(can_disconnect, cp->lun);
 
 	/*
 	 *  Build the tag message if present.
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_misc.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_misc.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_misc.c	Thu Oct 21 14:39:25 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_misc.c	Thu Oct 21 12:06:29 2004
@@ -190,10 +190,12 @@ void sym_announce_transfer_rate(hcb_p np
 			mb10 = (f10 + period/2) / period;
 		}
 		printf_info (
-		    "%s:%d: %s %sSCSI %d.%d MB/s %s (%d.%d ns, offset %d)\n",
+		    "%s:%d: %s %sSCSI %d.%d MB/s %s%s%s (%d.%d ns, offset %d)\n",
 		    sym_name(np), target, scsi, __tcurr.width? "WIDE " : "",
 		    mb10/10, mb10%10,
 		    (__tcurr.options & PPR_OPT_DT) ? "DT" : "ST",
+		    (__tcurr.options & PPR_OPT_IU) ? " IU" : "",
+		    (__tcurr.options & PPR_OPT_QAS) ? " QAS" : "",
 		    period/10, period%10, __tcurr.offset);
 	}
 	else

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
