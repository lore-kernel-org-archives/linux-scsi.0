From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] Documentation: move scsi parameters to their own file
Date: Wed, 30 Jun 2010 16:00:12 -0700
Message-ID: <20100630160012.3b01b274.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:49574 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab0F3XAv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jun 2010 19:00:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejbscsi <james.bottomley@suse.de>

From: Randy Dunlap <randy.dunlap@oracle.com>

Move SCSI driver parameters from Documentation/kernel-parameters.txt
to their own file.  This reduces patch contention (conflicts) in
kernel-parameters.txt and allows kernel-parameters.txt to be used
primarily for core kernel parameters, while subsystems can have
their own files for parameters.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt    |  130 ---------------------
 Documentation/scsi/scsi-parameters.txt |  139 +++++++++++++++++++++++
 2 files changed, 141 insertions(+), 128 deletions(-)

--- linux-2.6.35-rc3.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.35-rc3/Documentation/kernel-parameters.txt
@@ -89,8 +89,8 @@ parameter is applicable:
 	RAM	RAM disk support is enabled.
 	S390	S390 architecture is enabled.
 	SCSI	Appropriate SCSI support is enabled.
-			A lot of drivers has their options described inside of
-			Documentation/scsi/.
+			A lot of drivers have their options described inside
+			the Documentation/scsi/ sub-directory.
 	SECURITY Different security models are enabled.
 	SELINUX SELinux support is enabled.
 	SERIAL	Serial support is enabled.
@@ -286,9 +286,6 @@ and is between 256 and 4096 characters. 
 	add_efi_memmap	[EFI; X86] Include EFI memory map in
 			kernel's map of available physical RAM.
 
-	advansys=	[HW,SCSI]
-			See header of drivers/scsi/advansys.c.
-
 	aedsp16=	[HW,OSS] Audio Excel DSP 16
 			Format: <io>,<irq>,<dma>,<mss_io>,<mpu_io>,<mpu_irq>
 			See also header of sound/oss/aedsp16.c.
@@ -299,18 +296,6 @@ and is between 256 and 4096 characters. 
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
 	alignment=	[KNL,ARM]
 			Allow the default userspace alignment fault handler
 			behaviour to be specified.  Bit 0 enables warnings,
@@ -371,8 +356,6 @@ and is between 256 and 4096 characters. 
 
 	atarimouse=	[HW,MOUSE] Atari Mouse
 
-	atascsi=	[HW,SCSI] Atari SCSI
-
 	atkbd.extra=	[HW] Enable extra LEDs and keys on IBM RapidAccess,
 			EzKey and similar keyboards
 
@@ -422,10 +405,6 @@ and is between 256 and 4096 characters. 
 	bttv.pll=	See Documentation/video4linux/bttv/Insmod-options
 	bttv.tuner=	and Documentation/video4linux/bttv/CARDLIST
 
-	BusLogic=	[HW,SCSI]
-			See drivers/scsi/BusLogic.c, comment before function
-			BusLogic_ParseDriverOptions().
-
 	c101=		[NET] Moxa C101 synchronous serial card
 
 	cachesize=	[BUGS=X86-32] Override level 2 CPU cache size detection.
@@ -676,8 +655,6 @@ and is between 256 and 4096 characters. 
 
 	dscc4.setup=	[NET]
 
-	dtc3181e=	[HW,SCSI]
-
 	dynamic_printk	Enables pr_debug()/dev_dbg() calls if
 			CONFIG_DYNAMIC_PRINTK_DEBUG has been enabled.
 			These can also be switched on/off via
@@ -715,8 +692,6 @@ and is between 256 and 4096 characters. 
 			This is desgined to be used in conjunction with
 			the boot argument: earlyprintk=vga
 
-	eata=		[HW,SCSI]
-
 	edd=		[EDD]
 			Format: {"off" | "on" | "skip[mbr]"}
 
@@ -772,12 +747,6 @@ and is between 256 and 4096 characters. 
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
 
@@ -837,14 +806,9 @@ and is between 256 and 4096 characters. 
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
@@ -936,9 +900,6 @@ and is between 256 and 4096 characters. 
 	i8k.restricted	[HW] Allow controlling fans only if SYS_ADMIN
 			capability is set.
 
-	ibmmcascsi=	[HW,MCA,SCSI] IBM MicroChannel SCSI adapter
-			See Documentation/mca.txt.
-
 	icn=		[HW,ISDN]
 			Format: <io>[,<membase>[,<icn_id>[,<icn_id2>]]]
 
@@ -988,9 +949,6 @@ and is between 256 and 4096 characters. 
 			programs exec'd, files mmap'd for exec, and all files
 			opened for read by uid=0.
 
-	in2000=		[HW,SCSI]
-			See header of drivers/scsi/in2000.c.
-
 	init=		[KNL]
 			Format: <full_path>
 			Run specified binary instead of /sbin/init as init
@@ -1068,9 +1026,6 @@ and is between 256 and 4096 characters. 
 			See comment before ip2_setup() in
 			drivers/char/ip2/ip2base.c.
 
-	ips=		[HW,SCSI] Adaptec / IBM ServeRAID controller
-			See header of drivers/scsi/ips.c.
-
 	irqfixup	[HW]
 			When an interrupt is not handled search all handlers
 			for it. Intended to get systems with badly broken
@@ -1343,9 +1298,6 @@ and is between 256 and 4096 characters. 
 	ltpc=		[NET]
 			Format: <io>,<irq>,<dma>
 
-	mac5380=	[HW,SCSI] Format:
-			<can_queue>,<cmd_per_lun>,<sg_tablesize>,<hostid>,<use_tags>
-
 	machvec=	[IA64] Force the use of a particular machine-vector
 			(machvec) in a generic kernel.
 			Example: machvec=hpzx1_swiotlb
@@ -1367,13 +1319,6 @@ and is between 256 and 4096 characters. 
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
@@ -1573,19 +1518,6 @@ and is between 256 and 4096 characters. 
 
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
@@ -1687,8 +1619,6 @@ and is between 256 and 4096 characters. 
 
 	nodelayacct	[KNL] Disable per-task delay accounting
 
-	nodisconnect	[HW,SCSI,M68K] Disables SCSI disconnects.
-
 	nodsp		[SH] Disable hardware DSP at boot time.
 
 	noefi		[X86] Disable EFI runtime services support.
@@ -1863,10 +1793,6 @@ and is between 256 and 4096 characters. 
 				perfmon on Intel CPUs instead of the
 				CPU specific event set.
 
-	osst=		[HW,SCSI] SCSI Tape Driver
-			Format: <buffer_size>,<write_threshold>
-			See also Documentation/scsi/st.txt.
-
 	panic=		[KNL] Kernel behaviour on panic
 			Format: <timeout>
 
@@ -1902,9 +1828,6 @@ and is between 256 and 4096 characters. 
 	pas2=		[HW,OSS] Format:
 			<io>,<irq>,<dma>,<dma16>,<sb_io>,<sb_irq>,<sb_dma>,<sb_dma16>
 
-	pas16=		[HW,SCSI]
-			See header of drivers/scsi/pas16.c.
-
 	pause_on_oops=
 			Halt all CPUs after the first oops has been printed for
 			the specified number of seconds.  This is to be used if
@@ -2271,30 +2194,6 @@ and is between 256 and 4096 characters. 
 
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
@@ -2321,9 +2220,6 @@ and is between 256 and 4096 characters. 
 			The parameter means the number of CPUs to show,
 			for example 1 means boot CPU only.
 
-	sim710=		[SCSI,HW]
-			See header of drivers/scsi/sim710.c.
-
 	simeth=		[IA-64]
 	simscsi=
 
@@ -2520,9 +2416,6 @@ and is between 256 and 4096 characters. 
 	sscape=		[HW,OSS]
 			Format: <io>,<irq>,<dma>,<mpu_io>,<mpu_irq>
 
-	st=		[HW,SCSI] SCSI tape parameters (buffers, etc.)
-			See Documentation/scsi/st.txt.
-
 	stacktrace	[FTRACE]
 			Enabled the stack tracer on boot up.
 
@@ -2580,18 +2473,12 @@ and is between 256 and 4096 characters. 
 
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
@@ -2628,10 +2515,6 @@ and is between 256 and 4096 characters. 
 			<deci-seconds>: poll all this frequency
 			0: no polling (default)
 
-	tmscsim=	[HW,SCSI]
-			See comment before function dc390_setup() in
-			drivers/scsi/tmscsim.c.
-
 	topology=	[S390]
 			Format: {off | on}
 			Specify if the kernel should make use of the cpu
@@ -2676,9 +2559,6 @@ and is between 256 and 4096 characters. 
 			<port#>,<js1>,<js2>,<js3>,<js4>,<js5>,<js6>,<js7>
 			See also Documentation/input/joystick-parport.txt
 
-	u14-34f=	[HW,SCSI] UltraStor 14F/34F SCSI host adapter
-			See header of drivers/scsi/u14-34f.c.
-
 	uart401=	[HW,OSS]
 			Format: <io>,<irq>
 
@@ -2853,12 +2733,6 @@ and is between 256 and 4096 characters. 
 	waveartist=	[HW,OSS]
 			Format: <io>,<irq>,<dma>,<dma2>
 
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
+++ linux-2.6.35-rc3/Documentation/scsi/scsi-parameters.txt
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
