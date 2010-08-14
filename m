From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] Documentation: move SCSI parameters to their own text file
Date: Sat, 14 Aug 2010 12:36:14 -0700
Message-ID: <20100814123614.e1498058.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:62969 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab0HNThT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Aug 2010 15:37:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lkml <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>
Cc: jejbscsi <james.bottomley@suse.de>, torvalds <torvalds@linux-foundation.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Move SCSI parameters from kernel-parameters.txt to their own text file.

This continues a trend of moving non-core parameters out of
kernel-parameters.txt.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt    |  128 ---------------------
 Documentation/scsi/scsi-parameters.txt |  139 +++++++++++++++++++++++
 2 files changed, 141 insertions(+), 126 deletions(-)

--- linux-2.6.35-git15.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.35-git15/Documentation/kernel-parameters.txt
@@ -88,8 +88,8 @@ parameter is applicable:
 	RAM	RAM disk support is enabled.
 	S390	S390 architecture is enabled.
 	SCSI	Appropriate SCSI support is enabled.
-			A lot of drivers has their options described inside of
-			Documentation/scsi/.
+			A lot of drivers have their options described inside
+			the Documentation/scsi/ sub-directory.
 	SECURITY Different security models are enabled.
 	SELINUX SELinux support is enabled.
 	APPARMOR AppArmor support is enabled.
@@ -284,27 +284,12 @@ and is between 256 and 4096 characters. 
 	add_efi_memmap	[EFI; X86] Include EFI memory map in
 			kernel's map of available physical RAM.
 
-	advansys=	[HW,SCSI]
-			See header of drivers/scsi/advansys.c.
-
 	agp=		[AGP]
 			{ off | try_unsupported }
 			off: disable AGP support
 			try_unsupported: try to drive unsupported chipsets
 				(may crash computer or cause data corruption)
 
-	aha152x=	[HW,SCSI]
-			See Documentation/scsi/aha152x.txt.
-
-	aha1542=	[HW,SCSI]
-			Format: <portbase>[,<buson>,<busoff>[,<dmaspeed>]]
-
-	aic7xxx=	[HW,SCSI]
-			See Documentation/scsi/aic7xxx.txt.
-
-	aic79xx=	[HW,SCSI]
-			See Documentation/scsi/aic79xx.txt.
-
 	ALSA		[HW,ALSA]
 			See Documentation/sound/alsa/alsa-parameters.txt
 
@@ -368,8 +353,6 @@ and is between 256 and 4096 characters. 
 
 	atarimouse=	[HW,MOUSE] Atari Mouse
 
-	atascsi=	[HW,SCSI] Atari SCSI
-
 	atkbd.extra=	[HW] Enable extra LEDs and keys on IBM RapidAccess,
 			EzKey and similar keyboards
 
@@ -419,10 +402,6 @@ and is between 256 and 4096 characters. 
 	bttv.pll=	See Documentation/video4linux/bttv/Insmod-options
 	bttv.tuner=	and Documentation/video4linux/bttv/CARDLIST
 
-	BusLogic=	[HW,SCSI]
-			See drivers/scsi/BusLogic.c, comment before function
-			BusLogic_ParseDriverOptions().
-
 	c101=		[NET] Moxa C101 synchronous serial card
 
 	cachesize=	[BUGS=X86-32] Override level 2 CPU cache size detection.
@@ -671,8 +650,6 @@ and is between 256 and 4096 characters. 
 
 	dscc4.setup=	[NET]
 
-	dtc3181e=	[HW,SCSI]
-
 	dynamic_printk	Enables pr_debug()/dev_dbg() calls if
 			CONFIG_DYNAMIC_PRINTK_DEBUG has been enabled.
 			These can also be switched on/off via
@@ -713,8 +690,6 @@ and is between 256 and 4096 characters. 
 			This is desgined to be used in conjunction with
 			the boot argument: earlyprintk=vga
 
-	eata=		[HW,SCSI]
-
 	edd=		[EDD]
 			Format: {"off" | "on" | "skip[mbr]"}
 
@@ -770,12 +745,6 @@ and is between 256 and 4096 characters. 
 			Format: <interval>,<probability>,<space>,<times>
 			See also /Documentation/fault-injection/.
 
-	fd_mcs=		[HW,SCSI]
-			See header of drivers/scsi/fd_mcs.c.
-
-	fdomain=	[HW,SCSI]
-			See header of drivers/scsi/fdomain.c.
-
 	floppy=		[HW]
 			See Documentation/blockdev/floppy.txt.
 
@@ -835,14 +804,9 @@ and is between 256 and 4096 characters. 
 			When zero, profiling data is discarded and associated
 			debugfs files are removed at module unload time.
 
-	gdth=		[HW,SCSI]
-			See header of drivers/scsi/gdth.c.
-
 	gpt		[EFI] Forces disk with valid GPT signature but
 			invalid Protective MBR to be treated as GPT.
 
-	gvp11=		[HW,SCSI]
-
 	hashdist=	[KNL,NUMA] Large hashes allocated during boot
 			are distributed across NUMA nodes.  Defaults on
 			for 64bit NUMA, off otherwise.
@@ -931,9 +895,6 @@ and is between 256 and 4096 characters. 
 	i8k.restricted	[HW] Allow controlling fans only if SYS_ADMIN
 			capability is set.
 
-	ibmmcascsi=	[HW,MCA,SCSI] IBM MicroChannel SCSI adapter
-			See Documentation/mca.txt.
-
 	icn=		[HW,ISDN]
 			Format: <io>[,<membase>[,<icn_id>[,<icn_id2>]]]
 
@@ -983,9 +944,6 @@ and is between 256 and 4096 characters. 
 			programs exec'd, files mmap'd for exec, and all files
 			opened for read by uid=0.
 
-	in2000=		[HW,SCSI]
-			See header of drivers/scsi/in2000.c.
-
 	init=		[KNL]
 			Format: <full_path>
 			Run specified binary instead of /sbin/init as init
@@ -1063,9 +1021,6 @@ and is between 256 and 4096 characters. 
 			See comment before ip2_setup() in
 			drivers/char/ip2/ip2base.c.
 
-	ips=		[HW,SCSI] Adaptec / IBM ServeRAID controller
-			See header of drivers/scsi/ips.c.
-
 	irqfixup	[HW]
 			When an interrupt is not handled search all handlers
 			for it. Intended to get systems with badly broken
@@ -1341,9 +1296,6 @@ and is between 256 and 4096 characters. 
 	ltpc=		[NET]
 			Format: <io>,<irq>,<dma>
 
-	mac5380=	[HW,SCSI] Format:
-			<can_queue>,<cmd_per_lun>,<sg_tablesize>,<hostid>,<use_tags>
-
 	machvec=	[IA64] Force the use of a particular machine-vector
 			(machvec) in a generic kernel.
 			Example: machvec=hpzx1_swiotlb
@@ -1365,13 +1317,6 @@ and is between 256 and 4096 characters. 
 			be mounted
 			Format: <1-256>
 
-	max_luns=	[SCSI] Maximum number of LUNs to probe.
-			Should be between 1 and 2^32-1.
-
-	max_report_luns=
-			[SCSI] Maximum number of LUNs received.
-			Should be between 1 and 16384.
-
 	mcatest=	[IA-64]
 
 	mce		[X86-32] Machine Check Exception
@@ -1568,19 +1513,6 @@ and is between 256 and 4096 characters. 
 
 	n2=		[NET] SDL Inc. RISCom/N2 synchronous serial card
 
-	NCR_D700=	[HW,SCSI]
-			See header of drivers/scsi/NCR_D700.c.
-
-	ncr5380=	[HW,SCSI]
-
-	ncr53c400=	[HW,SCSI]
-
-	ncr53c400a=	[HW,SCSI]
-
-	ncr53c406a=	[HW,SCSI]
-
-	ncr53c8xx=	[HW,SCSI]
-
 	netdev=		[NET] Network devices parameters
 			Format: <irq>,<io>,<mem_start>,<mem_end>,<name>
 			Note that mem_start is often overloaded to mean
@@ -1859,10 +1791,6 @@ and is between 256 and 4096 characters. 
 	OSS		[HW,OSS]
 			See Documentation/sound/oss/oss-parameters.txt
 
-	osst=		[HW,SCSI] SCSI Tape Driver
-			Format: <buffer_size>,<write_threshold>
-			See also Documentation/scsi/st.txt.
-
 	panic=		[KNL] Kernel behaviour on panic
 			Format: <timeout>
 
@@ -1895,9 +1823,6 @@ and is between 256 and 4096 characters. 
 			Currently this function knows 686a and 8231 chips.
 			Format: [spp|ps2|epp|ecp|ecpepp]
 
-	pas16=		[HW,SCSI]
-			See header of drivers/scsi/pas16.c.
-
 	pause_on_oops=
 			Halt all CPUs after the first oops has been printed for
 			the specified number of seconds.  This is to be used if
@@ -2264,30 +2189,6 @@ and is between 256 and 4096 characters. 
 
 	sched_debug	[KNL] Enables verbose scheduler debug messages.
 
-	scsi_debug_*=	[SCSI]
-			See drivers/scsi/scsi_debug.c.
-
-	scsi_default_dev_flags=
-			[SCSI] SCSI default device flags
-			Format: <integer>
-
-	scsi_dev_flags=	[SCSI] Black/white list entry for vendor and model
-			Format: <vendor>:<model>:<flags>
-			(flags are integer value)
-
-	scsi_logging_level=	[SCSI] a bit mask of logging levels
-			See drivers/scsi/scsi_logging.h for bits.  Also
-			settable via sysctl at dev.scsi.logging_level
-			(/proc/sys/dev/scsi/logging_level).
-			There is also a nice 'scsi_logging_level' script in the
-			S390-tools package, available for download at
-			http://www-128.ibm.com/developerworks/linux/linux390/s390-tools-1.5.4.html
-
-	scsi_mod.scan=	[SCSI] sync (default) scans SCSI busses as they are
-			discovered.  async scans them in kernel threads,
-			allowing boot to proceed.  none ignores them, expecting
-			user space to do the scan.
-
 	security=	[SECURITY] Choose a security module to enable at boot.
 			If this boot parameter is not specified, only the first
 			security module asking for security registration will be
@@ -2321,9 +2222,6 @@ and is between 256 and 4096 characters. 
 			The parameter means the number of CPUs to show,
 			for example 1 means boot CPU only.
 
-	sim710=		[SCSI,HW]
-			See header of drivers/scsi/sim710.c.
-
 	simeth=		[IA-64]
 	simscsi=
 
@@ -2395,9 +2293,6 @@ and is between 256 and 4096 characters. 
 	spia_pedr=
 	spia_peddr=
 
-	st=		[HW,SCSI] SCSI tape parameters (buffers, etc.)
-			See Documentation/scsi/st.txt.
-
 	stacktrace	[FTRACE]
 			Enabled the stack tracer on boot up.
 
@@ -2455,18 +2350,12 @@ and is between 256 and 4096 characters. 
 
 	switches=	[HW,M68k]
 
-	sym53c416=	[HW,SCSI]
-			See header of drivers/scsi/sym53c416.c.
-
 	sysrq_always_enabled
 			[KNL]
 			Ignore sysrq setting - this boot parameter will
 			neutralize any effect of /proc/sys/kernel/sysrq.
 			Useful for debugging.
 
-	t128=		[HW,SCSI]
-			See header of drivers/scsi/t128.c.
-
 	tdfx=		[HW,DRM]
 
 	test_suspend=	[SUSPEND]
@@ -2503,10 +2392,6 @@ and is between 256 and 4096 characters. 
 			<deci-seconds>: poll all this frequency
 			0: no polling (default)
 
-	tmscsim=	[HW,SCSI]
-			See comment before function dc390_setup() in
-			drivers/scsi/tmscsim.c.
-
 	topology=	[S390]
 			Format: {off | on}
 			Specify if the kernel should make use of the cpu
@@ -2547,9 +2432,6 @@ and is between 256 and 4096 characters. 
 			<port#>,<js1>,<js2>,<js3>,<js4>,<js5>,<js6>,<js7>
 			See also Documentation/input/joystick-parport.txt
 
-	u14-34f=	[HW,SCSI] UltraStor 14F/34F SCSI host adapter
-			See header of drivers/scsi/u14-34f.c.
-
 	uhash_entries=	[KNL,NET]
 			Set number of hash buckets for UDP/UDP-Lite connections
 
@@ -2715,12 +2597,6 @@ and is between 256 and 4096 characters. 
 			overridden by individual drivers. 0 will hide
 			cursors, 1 will display them.
 
-	wd33c93=	[HW,SCSI]
-			See header of drivers/scsi/wd33c93.c.
-
-	wd7000=		[HW,SCSI]
-			See header of drivers/scsi/wd7000.c.
-
 	watchdog timers	[HW,WDT] For information on watchdog timers,
 			see Documentation/watchdog/watchdog-parameters.txt
 			or other driver-specific files in the
--- /dev/null
+++ linux-2.6.35-git15/Documentation/scsi/scsi-parameters.txt
@@ -0,0 +1,139 @@
+                          SCSI Kernel Parameters
+                          ~~~~~~~~~~~~~~~~~~~~~~
+
+See Documentation/kernel-parameters.txt for general information on
+specifying module parameters.
+
+This document may not be entirely up to date and comprehensive. The command
+"modinfo -p ${modulename}" shows a current list of all parameters of a loadable
+module. Loadable modules, after being loaded into the running kernel, also
+reveal their parameters in /sys/module/${modulename}/parameters/. Some of these
+parameters may be changed at runtime by the command
+"echo -n ${value} > /sys/module/${modulename}/parameters/${parm}".
+
+
+	advansys=	[HW,SCSI]
+			See header of drivers/scsi/advansys.c.
+
+	aha152x=	[HW,SCSI]
+			See Documentation/scsi/aha152x.txt.
+
+	aha1542=	[HW,SCSI]
+			Format: <portbase>[,<buson>,<busoff>[,<dmaspeed>]]
+
+	aic7xxx=	[HW,SCSI]
+			See Documentation/scsi/aic7xxx.txt.
+
+	aic79xx=	[HW,SCSI]
+			See Documentation/scsi/aic79xx.txt.
+
+	atascsi=	[HW,SCSI] Atari SCSI
+
+	BusLogic=	[HW,SCSI]
+			See drivers/scsi/BusLogic.c, comment before function
+			BusLogic_ParseDriverOptions().
+
+	dtc3181e=	[HW,SCSI]
+
+	eata=		[HW,SCSI]
+
+	fd_mcs=		[HW,SCSI]
+			See header of drivers/scsi/fd_mcs.c.
+
+	fdomain=	[HW,SCSI]
+			See header of drivers/scsi/fdomain.c.
+
+	gdth=		[HW,SCSI]
+			See header of drivers/scsi/gdth.c.
+
+	gvp11=		[HW,SCSI]
+
+	ibmmcascsi=	[HW,MCA,SCSI] IBM MicroChannel SCSI adapter
+			See Documentation/mca.txt.
+
+	in2000=		[HW,SCSI]
+			See header of drivers/scsi/in2000.c.
+
+	ips=		[HW,SCSI] Adaptec / IBM ServeRAID controller
+			See header of drivers/scsi/ips.c.
+
+	mac5380=	[HW,SCSI] Format:
+			<can_queue>,<cmd_per_lun>,<sg_tablesize>,<hostid>,<use_tags>
+
+	max_luns=	[SCSI] Maximum number of LUNs to probe.
+			Should be between 1 and 2^32-1.
+
+	max_report_luns=
+			[SCSI] Maximum number of LUNs received.
+			Should be between 1 and 16384.
+
+	NCR_D700=	[HW,SCSI]
+			See header of drivers/scsi/NCR_D700.c.
+
+	ncr5380=	[HW,SCSI]
+
+	ncr53c400=	[HW,SCSI]
+
+	ncr53c400a=	[HW,SCSI]
+
+	ncr53c406a=	[HW,SCSI]
+
+	ncr53c8xx=	[HW,SCSI]
+
+	nodisconnect	[HW,SCSI,M68K] Disables SCSI disconnects.
+
+	osst=		[HW,SCSI] SCSI Tape Driver
+			Format: <buffer_size>,<write_threshold>
+			See also Documentation/scsi/st.txt.
+
+	pas16=		[HW,SCSI]
+			See header of drivers/scsi/pas16.c.
+
+	scsi_debug_*=	[SCSI]
+			See drivers/scsi/scsi_debug.c.
+
+	scsi_default_dev_flags=
+			[SCSI] SCSI default device flags
+			Format: <integer>
+
+	scsi_dev_flags=	[SCSI] Black/white list entry for vendor and model
+			Format: <vendor>:<model>:<flags>
+			(flags are integer value)
+
+	scsi_logging_level=	[SCSI] a bit mask of logging levels
+			See drivers/scsi/scsi_logging.h for bits.  Also
+			settable via sysctl at dev.scsi.logging_level
+			(/proc/sys/dev/scsi/logging_level).
+			There is also a nice 'scsi_logging_level' script in the
+			S390-tools package, available for download at
+			http://www-128.ibm.com/developerworks/linux/linux390/s390-tools-1.5.4.html
+
+	scsi_mod.scan=	[SCSI] sync (default) scans SCSI busses as they are
+			discovered.  async scans them in kernel threads,
+			allowing boot to proceed.  none ignores them, expecting
+			user space to do the scan.
+
+	sim710=		[SCSI,HW]
+			See header of drivers/scsi/sim710.c.
+
+	st=		[HW,SCSI] SCSI tape parameters (buffers, etc.)
+			See Documentation/scsi/st.txt.
+
+	sym53c416=	[HW,SCSI]
+			See header of drivers/scsi/sym53c416.c.
+
+	t128=		[HW,SCSI]
+			See header of drivers/scsi/t128.c.
+
+	tmscsim=	[HW,SCSI]
+			See comment before function dc390_setup() in
+			drivers/scsi/tmscsim.c.
+
+	u14-34f=	[HW,SCSI] UltraStor 14F/34F SCSI host adapter
+			See header of drivers/scsi/u14-34f.c.
+
+	wd33c93=	[HW,SCSI]
+			See header of drivers/scsi/wd33c93.c.
+
+	wd7000=		[HW,SCSI]
+			See header of drivers/scsi/wd7000.c.
