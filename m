From: "Andi Kleen" <ak@suse.de>
Subject: [PATCH] [29/82] x86_64: Rename IOMMU option, fix help and mark
 option embedded.
Date: Sat, 24 Jun 2006 02:19:56 +0200
Message-ID: <449C852C.mailCZT11F9YB@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33955 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1752197AbWFXAT5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jun 2006 20:19:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@osdl.org
Cc: discuss@x86-64.org, akpm@osdl.org, markh@osdl.org, alan@redhat.com, linux-scsi@vger.kernel.org


- Rename the GART_IOMMU option to IOMMU to make clear it's not
just for AMD
- Rewrite the help text to better emphatise this fact
- Make it an embedded option because too many people get it wrong.

To my astonishment I discovered the aacraid driver tests this
symbol directly. This looks quite broken to me - it's an internal
implementation detail of the PCI DMA API. Can the maintainer
please clarify what this test was intended to do? 

Cc: linux-scsi@vger.kernel.org
Cc: alan@redhat.com
Cc: markh@osdl.org

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/Kconfig             |   28 +++++++++++++++-------------
 arch/x86_64/Kconfig.debug       |    2 +-
 arch/x86_64/kernel/Makefile     |    2 +-
 arch/x86_64/kernel/io_apic.c    |    2 +-
 arch/x86_64/kernel/pci-dma.c    |    2 +-
 arch/x86_64/kernel/setup.c      |    2 +-
 drivers/char/agp/Kconfig        |    4 ++--
 drivers/char/agp/amd64-agp.c    |    4 ++--
 drivers/scsi/aacraid/comminit.c |    5 ++++-
 include/asm-x86_64/pci.h        |    2 +-
 include/asm-x86_64/proto.h      |    2 +-
 11 files changed, 30 insertions(+), 25 deletions(-)

Index: linux/arch/x86_64/Kconfig
===================================================================
--- linux.orig/arch/x86_64/Kconfig
+++ linux/arch/x86_64/Kconfig
@@ -386,24 +386,26 @@ config HPET_EMULATE_RTC
 	bool "Provide RTC interrupt"
 	depends on HPET_TIMER && RTC=y
 
-config GART_IOMMU
-	bool "K8 GART IOMMU support"
+# Mark as embedded because too many people got it wrong.
+# The code disables itself when not needed.
+config IOMMU
+	bool "IOMMU support" if EMBEDDED
 	default y
 	select SWIOTLB
 	select AGP
 	depends on PCI
 	help
-	  Support for hardware IOMMU in AMD's Opteron/Athlon64 Processors
-	  and for the bounce buffering software IOMMU.
-	  Needed to run systems with more than 3GB of memory properly with
-	  32-bit PCI devices that do not support DAC (Double Address Cycle).
-	  The IOMMU can be turned off at runtime with the iommu=off parameter.
-  	  Normally the kernel will take the right choice by itself.
-  	  This option includes a driver for the AMD Opteron/Athlon64 IOMMU
-  	  northbridge and a software emulation used on other systems without
-	  hardware IOMMU.  If unsure, say Y.
+	  Support for full DMA access of devices with 32bit memory access only
+	  on systems with more than 3GB. This is usually needed for USB,
+	  sound, many IDE/SATA chipsets and some other devices.
+	  Provides a driver for the AMD Athlon64/Opteron/Turion/Sempron GART
+	  based IOMMU and a software bounce buffer based IOMMU used on Intel
+	  systems and as fallback.
+	  The code is only active when needed (enough memory and limited
+	  device) unless CONFIG_IOMMU_DEBUG or iommu=force is specified
+	  too.
 
-# need this always selected by GART_IOMMU for the VIA workaround
+# need this always selected by IOMMU for the VIA workaround
 config SWIOTLB
 	bool
 
@@ -503,7 +505,7 @@ config REORDER
 
 config K8_NB
 	def_bool y
-	depends on AGP_AMD64 || GART_IOMMU || (PCI && NUMA)
+	depends on AGP_AMD64 || IOMMU || (PCI && NUMA)
 
 endmenu
 
Index: linux/arch/x86_64/Kconfig.debug
===================================================================
--- linux.orig/arch/x86_64/Kconfig.debug
+++ linux/arch/x86_64/Kconfig.debug
@@ -13,7 +13,7 @@ config DEBUG_RODATA
 	 If in doubt, say "N".
 
 config IOMMU_DEBUG
-       depends on GART_IOMMU && DEBUG_KERNEL
+       depends on IOMMU && DEBUG_KERNEL
        bool "Enable IOMMU debugging"
        help
          Force the IOMMU to on even when you have less than 4GB of
Index: linux/arch/x86_64/kernel/Makefile
===================================================================
--- linux.orig/arch/x86_64/kernel/Makefile
+++ linux/arch/x86_64/kernel/Makefile
@@ -28,7 +28,7 @@ obj-$(CONFIG_PM)		+= suspend.o
 obj-$(CONFIG_SOFTWARE_SUSPEND)	+= suspend_asm.o
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
-obj-$(CONFIG_GART_IOMMU)	+= pci-gart.o aperture.o
+obj-$(CONFIG_IOMMU)		+= pci-gart.o aperture.o
 obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer.o
Index: linux/arch/x86_64/kernel/io_apic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/io_apic.c
+++ linux/arch/x86_64/kernel/io_apic.c
@@ -319,7 +319,7 @@ void __init check_ioapic(void) 
 				vendor &= 0xffff;
 				switch (vendor) { 
 				case PCI_VENDOR_ID_VIA:
-#ifdef CONFIG_GART_IOMMU
+#ifdef CONFIG_IOMMU
 					if ((end_pfn > MAX_DMA32_PFN ||
 					     force_iommu) &&
 					    !iommu_aperture_allowed) {
Index: linux/arch/x86_64/kernel/pci-dma.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-dma.c
+++ linux/arch/x86_64/kernel/pci-dma.c
@@ -266,7 +266,7 @@ __init int iommu_setup(char *p)
 		    swiotlb = 1;
 #endif
 
-#ifdef CONFIG_GART_IOMMU
+#ifdef CONFIG_IOMMU
 	    gart_parse_options(p);
 #endif
 
Index: linux/arch/x86_64/kernel/setup.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup.c
+++ linux/arch/x86_64/kernel/setup.c
@@ -797,7 +797,7 @@ void __init setup_arch(char **cmdline_p)
 
 	e820_setup_gap();
 
-#ifdef CONFIG_GART_IOMMU
+#ifdef CONFIG_IOMMU
 	iommu_hole_init();
 #endif
 
Index: linux/drivers/char/agp/Kconfig
===================================================================
--- linux.orig/drivers/char/agp/Kconfig
+++ linux/drivers/char/agp/Kconfig
@@ -55,9 +55,9 @@ config AGP_AMD
 	  X on AMD Irongate, 761, and 762 chipsets.
 
 config AGP_AMD64
-	tristate "AMD Opteron/Athlon64 on-CPU GART support" if !GART_IOMMU
+	tristate "AMD Opteron/Athlon64 on-CPU GART support" if !IOMMU
 	depends on AGP && X86
-	default y if GART_IOMMU
+	default y if IOMMU
 	help
 	  This option gives you AGP support for the GLX component of
 	  X using the on-CPU northbridge of the AMD Athlon64/Opteron CPUs.
Index: linux/drivers/char/agp/amd64-agp.c
===================================================================
--- linux.orig/drivers/char/agp/amd64-agp.c
+++ linux/drivers/char/agp/amd64-agp.c
@@ -292,7 +292,7 @@ static int __devinit aperture_valid(u64 
 /*
  * W*s centric BIOS sometimes only set up the aperture in the AGP
  * bridge, not the northbridge. On AMD64 this is handled early
- * in aperture.c, but when GART_IOMMU is not enabled or we run
+ * in aperture.c, but when IOMMU is not enabled or we run
  * on a 32bit kernel this needs to be redone.
  * Unfortunately it is impossible to fix the aperture here because it's too late
  * to allocate that much memory. But at least error out cleanly instead of
@@ -775,7 +775,7 @@ static void __exit agp_amd64_cleanup(voi
 
 /* On AMD64 the PCI driver needs to initialize this driver early
    for the IOMMU, so it has to be called via a backdoor. */
-#ifndef CONFIG_GART_IOMMU
+#ifndef CONFIG_IOMMU
 module_init(agp_amd64_init);
 module_exit(agp_amd64_cleanup);
 #endif
Index: linux/drivers/scsi/aacraid/comminit.c
===================================================================
--- linux.orig/drivers/scsi/aacraid/comminit.c
+++ linux/drivers/scsi/aacraid/comminit.c
@@ -104,8 +104,11 @@ static int aac_alloc_comm(struct aac_dev
 	 * always true on real computers. It also has some slight problems
 	 * with the GART on x86-64. I've btw never tried DMA from PCI space
 	 * on this platform but don't be surprised if its problematic.
+	 * [AK: something is very very wrong when a driver tests this symbol.
+ 	 *  Someone should figure out what the comment writer really meant here and fix
+	 *  the code. Or just remove that bad code. ]
 	 */
-#ifndef CONFIG_GART_IOMMU
+#ifndef CONFIG_IOMMU
 	if ((num_physpages << (PAGE_SHIFT - 12)) <= AAC_MAX_HOSTPHYSMEMPAGES) {
 		init->HostPhysMemPages = 
 			cpu_to_le32(num_physpages << (PAGE_SHIFT-12));
Index: linux/include/asm-x86_64/pci.h
===================================================================
--- linux.orig/include/asm-x86_64/pci.h
+++ linux/include/asm-x86_64/pci.h
@@ -52,7 +52,7 @@ extern int iommu_setup(char *opt);
  */
 #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
 
-#ifdef CONFIG_GART_IOMMU
+#ifdef CONFIG_IOMMU
 
 /*
  * x86-64 always supports DAC, but sometimes it is useful to force
Index: linux/include/asm-x86_64/proto.h
===================================================================
--- linux.orig/include/asm-x86_64/proto.h
+++ linux/include/asm-x86_64/proto.h
@@ -116,7 +116,7 @@ extern int skip_ioapic_setup;
 extern int acpi_ht;
 extern int acpi_disabled;
 
-#ifdef CONFIG_GART_IOMMU
+#ifdef CONFIG_IOMMU
 extern int fallback_aper_order;
 extern int fallback_aper_force;
 extern int iommu_aperture;
