From: Matthew Wilcox <matthew@wil.cx>
Subject: New module parameters for sym2
Date: Sun, 10 Oct 2004 17:14:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041010161446.GA16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:18131 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268342AbUJJQOt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Oct 2004 12:14:49 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: parisc-linux@parisc-linux.org


This is advisory; I've already committed it to the parisc-linux tree and
I'll send this to James as part of the changes for 2.6.10 in a few days.
Anyone who wants to spot bugs in it is more than welcome ;-)

 - Bump version to 2.1.18m
 - Convert to new-style module parameters
 - Rename tags to cmd_per_lun (consistency!)
 - Split extended tags functionality into the new tag_ctrl parameter
 - Remove SYM_LINUX_BOOT_COMMAND_LINE_SUPPORT ifdef
 - Fix debug parameter support
 - Restructure sym_config_pqs() a little
 - Add myself as MODULE_AUTHOR
 - Add a MODULE_DESCRIPTION

Index: Documentation/scsi/sym53c8xx_2.txt
===================================================================
RCS file: /var/cvs/linux-2.6/Documentation/scsi/sym53c8xx_2.txt,v
retrieving revision 1.3
diff -u -p -r1.3 sym53c8xx_2.txt
--- Documentation/scsi/sym53c8xx_2.txt	28 Sep 2004 12:32:22 -0000	1.3
+++ Documentation/scsi/sym53c8xx_2.txt	10 Oct 2004 15:55:56 -0000
@@ -6,7 +6,7 @@ Written by Gerard Roudier <groudier@free
 
 Updated by Matthew Wilcox <matthew@wil.cx>
 
-2004-09-28
+2004-10-09
 ===============================================================================
 
 1.  Introduction
@@ -43,7 +43,7 @@ Updated by Matthew Wilcox <matthew@wil.c
              10.2.10 Settle delay
              10.2.11 Serial NVRAM
              10.2.12 Exclude a host from being attached
-      10.3 Serial NVRAM support boot option
+      10.3 Converting from old options
       10.4 SCSI BUS checking boot option
 11. SCSI problem troubleshooting
       15.1 Problem tracking
@@ -278,11 +278,10 @@ setting verbose level to zero, as follow
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
 
@@ -427,75 +426,66 @@ Synchronous transfers frequency       (d
 
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
-
-    insmod sym53c8xx.o sym53c8xx="tags:4 sync:10 debug:0x200"
-
-The integer list of arguments is discarded by the driver. 
+The following command will install the driver module with the same
+options as above.
 
-Each string argument must be specified as "keyword:value". Only lower-case 
-characters and digits are allowed.
+    modprobe sym53c8xx cmd_per_lun=4 sync=10 debug=0x200"
 
 10.2 Available arguments
 
 10.2.1  Default number of tagged commands
-        tags:0     (or tags:1 ) tagged command queuing disabled
-        tags:#tags (#tags  > 1) tagged command queuing enabled
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
 
-10.2.2 Burst max
-        burst:0    burst disabled
-        burst:255  get burst length from initial IO register settings.
-        burst:#x   burst enabled (1<<#x burst transfers max)
+10.2.3 Burst max
+        burst=0    burst disabled
+        burst=255  get burst length from initial IO register settings.
+        burst=#x   burst enabled (1<<#x burst transfers max)
   #x is an integer value which is log base 2 of the burst transfers max.
   By default the driver uses the maximum value supported by the chip.
 
-10.2.3 LED support
-        led:1      enable  LED support
-        led:0      disable LED support
+10.2.4 LED support
+        led=1      enable  LED support
+        led=0      disable LED support
   Do not enable LED support if your scsi board does not use SDMS BIOS.
   (See 'Configuration parameters')
 
 10.2.4 Differential mode
-        diff:0	never set up diff mode
-        diff:1	set up diff mode if BIOS set it
-        diff:2	always set up diff mode
-        diff:3	set diff mode if GPIO3 is not set
+        diff=0	never set up diff mode
+        diff=1	set up diff mode if BIOS set it
+        diff=2	always set up diff mode
+        diff=3	set diff mode if GPIO3 is not set
 
 10.2.5 IRQ mode
-        irqm:0     always open drain
-        irqm:1     same as initial settings (assumed BIOS settings)
-        irqm:2     always totem pole
+        irqm=0     always open drain
+        irqm=1     same as initial settings (assumed BIOS settings)
+        irqm=2     always totem pole
 
 10.2.6 Check SCSI BUS 
-        buschk:<option bits>
+        buschk=<option bits>
 
     Available option bits:
         0x0:   No check.
@@ -503,8 +493,8 @@ characters and digits are allowed.
         0x2:   Check and just warn on error.
 
 10.2.7 Suggest a default SCSI id for hosts
-        hostid:255	no id suggested.
-        hostid:#x   (0 < x < 7) x suggested for hosts SCSI id.
+        hostid=255	no id suggested.
+        hostid=#x   (0 < x < 7) x suggested for hosts SCSI id.
 
     If a host SCSI id is available from the NVRAM, the driver will ignore 
     any value suggested as boot option. Otherwise, if a suggested value 
@@ -513,13 +503,13 @@ characters and digits are allowed.
     7 if the hardware value is zero.
 
 10.2.8  Verbosity level
-        verb:0     minimal
-        verb:1     normal
-        verb:2     too much
+        verb=0     minimal
+        verb=1     normal
+        verb=2     too much
 
 10.2.9 Debug mode
-        debug:0	 clear debug flags
-        debug:#x   set debug flags
+        debug=0	 clear debug flags
+        debug=#x   set debug flags
   #x is an integer value combining the following power-of-2 values:
   DEBUG_ALLOC       0x1
   DEBUG_PHASE       0x2
@@ -539,15 +529,16 @@ characters and digits are allowed.
   generate bunches of syslog messages. 
 
 10.2.10 Settle delay
-        settle:n	delay for n seconds
+        settle=n	delay for n seconds
 
   After a bus reset, the driver will delay for n seconds before talking
   to any device on the bus.  The default is 3 seconds and safe mode will
   default it to 10.
 
 10.2.11 Serial NVRAM
-        nvram:n     do not look for serial NVRAM
-        nvram:y     test controllers for onboard serial NVRAM
+	NB: option not currently implemented.
+        nvram=n     do not look for serial NVRAM
+        nvram=y     test controllers for onboard serial NVRAM
         (alternate binary form)
         nvram=<bits options>
         0x01   look for NVRAM  (equivalent to nvram=y)
@@ -557,62 +548,25 @@ characters and digits are allowed.
         0x80   also attach controllers set to OFF in the NVRAM (sym53c8xx only)
 
 10.2.12 Exclude a host from being attached
-        excl=<io_address>
+        excl=<io_address>,...
 
     Prevent host at a given io address from being attached.
-    For example 'sym53c8xx=excl:0xb400,excl:0xc000' indicate to the 
+    For example 'excl=0xb400,0xc000' indicate to the 
     driver not to attach hosts at address 0xb400 and 0xc000.
 
-10.3 Serial NVRAM support boot option
-
-nvram:n     do not look for serial NVRAM
-nvram:y     test controllers for onboard serial NVRAM
+10.3 Converting from old style options
 
-This option can also been entered as an hexadecimal value that allows 
-to control what information the driver will get from the NVRAM and what 
-information it will ignore.
-For details see '17. Serial NVRAM support'.
+Previously, the sym2 driver accepted arguments of the form
+	sym53c8xx=tags:4,sync:10,debug:0x200
 
-When this option is enabled, the driver tries to detect all boards using 
-a Serial NVRAM. This memory is used to hold user set up parameters.
+As a result of the new module parameters, this is no longer available.
+Most of the options have remained the same, but tags has split into
+cmd_per_lun and tag_ctrl for its two different purposes.  The sample above
+would be specified as:
+	modprobe sym53c8xx cmd_per_lun=4 sync=10 debug=0x200
 
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
+or on the kernel boot line as:
+	sym53c8xx.cmd_per_lun=4 sym53c8xx.sync=10 sym53c8xx.debug=0x200
 
 10.4 SCSI BUS checking boot option.
 
@@ -747,14 +701,8 @@ serial NVRAM is used by Symbios and Tekr
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
@@ -765,6 +713,26 @@ used together with the Symbios cards usi
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
Index: drivers/scsi/sym53c8xx_2/sym53c8xx.h
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym53c8xx.h,v
retrieving revision 1.12
diff -u -p -r1.12 sym53c8xx.h
--- drivers/scsi/sym53c8xx_2/sym53c8xx.h	28 Sep 2004 12:34:20 -0000	1.12
+++ drivers/scsi/sym53c8xx_2/sym53c8xx.h	10 Oct 2004 15:56:14 -0000
@@ -68,7 +68,6 @@
  */
 #if 1
 #define	SYM_LINUX_PROC_INFO_SUPPORT
-#define SYM_LINUX_BOOT_COMMAND_LINE_SUPPORT
 #define SYM_LINUX_USER_COMMAND_SUPPORT
 #define SYM_LINUX_USER_INFO_SUPPORT
 #define SYM_LINUX_DEBUG_CONTROL_SUPPORT
@@ -130,7 +129,6 @@ struct sym_driver_setup {
 	u_char	host_id;
 
 	u_char	verbose;
-	u_short	debug;
 	u_char	settle_delay;
 	u_char	use_nvram;
 	u_long	excludes[8];
@@ -144,6 +142,7 @@ struct sym_driver_setup {
 #define SYM_SETUP_IRQ_MODE		sym_driver_setup.irq_mode
 #define SYM_SETUP_SCSI_BUS_CHECK	sym_driver_setup.scsi_bus_check
 #define SYM_SETUP_HOST_ID		sym_driver_setup.host_id
+#define boot_verbose			sym_driver_setup.verbose
 
 /* Always enable parity. */
 #define SYM_SETUP_PCI_PARITY		1
@@ -163,51 +162,12 @@ struct sym_driver_setup {
 	.scsi_bus_check	= 1,					\
 	.host_id	= 7,					\
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
Index: drivers/scsi/sym53c8xx_2/sym_defs.h
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h,v
retrieving revision 1.5
diff -u -p -r1.5 sym_defs.h
--- drivers/scsi/sym53c8xx_2/sym_defs.h	13 Sep 2004 15:23:29 -0000	1.5
+++ drivers/scsi/sym53c8xx_2/sym_defs.h	10 Oct 2004 15:56:15 -0000
@@ -40,7 +40,7 @@
 #ifndef SYM_DEFS_H
 #define SYM_DEFS_H
 
-#define SYM_VERSION "2.1.18k"
+#define SYM_VERSION "2.1.18m"
 #define SYM_DRIVER_NAME	"sym-" SYM_VERSION
 
 /*
Index: drivers/scsi/sym53c8xx_2/sym_glue.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c,v
retrieving revision 1.64
diff -u -p -r1.64 sym_glue.c
--- drivers/scsi/sym53c8xx_2/sym_glue.c	4 Oct 2004 22:23:07 -0000	1.64
+++ drivers/scsi/sym53c8xx_2/sym_glue.c	10 Oct 2004 15:56:16 -0000
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
@@ -919,7 +989,6 @@ static void sym_tune_dev_queuing(struct 
 	}
 }
 
-#ifdef	SYM_LINUX_BOOT_COMMAND_LINE_SUPPORT
 /*
  *  Linux select queue depths function
  */
@@ -972,9 +1041,6 @@ static int device_queue_depth(struct sym
 	}
 	return DEF_DEPTH;
 }
-#else
-#define device_queue_depth(np, t, l)	(sym_driver_setup.max_tag)
-#endif	/* SYM_LINUX_BOOT_COMMAND_LINE_SUPPORT */
 
 /*
  * Linux entry point for device queue sizing.
@@ -1767,142 +1833,6 @@ static inline void sym_get_nvram(struct 
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
-#define OPT_VERBOSE		8
-#define OPT_DEBUG		9
-#define OPT_SETTLE_DELAY	10
-#define OPT_USE_NVRAM		11
-#define OPT_EXCLUDE		12
-#define OPT_SAFE_SETUP		13
-
-static char setup_token[] __initdata =
-	"tags:"		"burst:"
-	"led:"		"diff:"
-	"irqm:"		"buschk:"
-	"hostid:"	"verb:"
-	"debug:"	"settle:"
-	"nvram:"	"excl:"
-	"safe:"		;
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
@@ -2081,9 +2011,9 @@ sym_init_device(struct pci_dev *pdev, st
 void sym_config_pqs(struct pci_dev *pdev, struct sym_device *sym_dev)
 {
 	int slot;
+	u8 tmp;
 
 	for (slot = 0; slot < 256; slot++) {
-		u8 tmp;
 		struct pci_dev *memc = pci_get_slot(pdev->bus, slot);
 
 		if (!memc || memc->vendor != 0x101a || memc->device == 0x0009) {
@@ -2091,28 +2021,26 @@ void sym_config_pqs(struct pci_dev *pdev
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
@@ -2141,9 +2069,6 @@ static int sym_detach(struct sym_hcb *np
 	return 1;
 }
 
-MODULE_LICENSE("GPL");
-MODULE_VERSION(SYM_VERSION);
-
 /*
  * Driver host template.
  */
@@ -2427,6 +2352,8 @@ static struct pci_driver sym2_driver = {
 static int __init sym2_init(void)
 {
 	int error;
+
+	sym2_setup_params();
 	sym2_transport_template = spi_attach_transport(&sym2_transport_functions);
 	if (!sym2_transport_template)
 		return -ENODEV;

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
