From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 9/9] eisa: consolidate EISA Kconfig entry in drivers/eisa
Date: Fri, 19 Oct 2018 14:09:52 +0200
Message-ID: <20181019120952.32763-10-hch@lst.de>
References: <20181019120952.32763-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019120952.32763-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Matt Porter <mporter@kernel.crashing.org>, Alexandre Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

Let architectures opt into EISA support by selecting HAS_EISA and
handle everything else in drivers/eisa.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/Kconfig     | 15 ++++++++-------
 arch/mips/Kconfig      | 31 +++++--------------------------
 arch/powerpc/Kconfig   |  3 ---
 arch/x86/Kconfig       | 19 +------------------
 drivers/Kconfig        |  1 +
 drivers/eisa/Kconfig   | 21 ++++++++++++++++++++-
 drivers/parisc/Kconfig | 11 +----------
 7 files changed, 36 insertions(+), 65 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 96f02268ea16..b723cd8ee6fb 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -128,11 +128,13 @@ choice
 config ALPHA_GENERIC
 	bool "Generic"
 	depends on TTY
+	select HAVE_EISA
 	help
 	  A generic kernel will run on all supported Alpha hardware.
 
 config ALPHA_ALCOR
 	bool "Alcor/Alpha-XLT"
+	select HAVE_EISA
 	help
 	  For systems using the Digital ALCOR chipset: 5 chips (4, 64-bit data
 	  slices (Data Switch, DSW) - 208-pin PQFP and 1 control (Control, I/O
@@ -206,6 +208,7 @@ config ALPHA_JENSEN
 	bool "Jensen"
 	depends on BROKEN
 	select DMA_DIRECT_OPS
+	select HAVE_EISA
 	help
 	  DEC PC 150 AXP (aka Jensen): This is a very old Digital system - one
 	  of the first-generation Alpha systems. A number of these systems
@@ -222,6 +225,7 @@ config ALPHA_LX164
 
 config ALPHA_LYNX
 	bool "Lynx"
+	select HAVE_EISA
 	help
 	  AlphaServer 2100A-based systems.
 
@@ -232,6 +236,7 @@ config ALPHA_MARVEL
 
 config ALPHA_MIATA
 	bool "Miata"
+	select HAVE_EISA
 	help
 	  The Digital PersonalWorkStation (PWS 433a, 433au, 500a, 500au, 600a,
 	  or 600au).
@@ -251,6 +256,7 @@ config ALPHA_NONAME_CH
 
 config ALPHA_NORITAKE
 	bool "Noritake"
+	select HAVE_EISA
 	help
 	  AlphaServer 1000A, AlphaServer 600A, and AlphaServer 800-based
 	  systems.
@@ -263,6 +269,7 @@ config ALPHA_P2K
 
 config ALPHA_RAWHIDE
 	bool "Rawhide"
+	select HAVE_EISA
 	help
 	  AlphaServer 1200, AlphaServer 4000 and AlphaServer 4100 machines.
 	  See HOWTO at
@@ -282,6 +289,7 @@ config ALPHA_SX164
 
 config ALPHA_SABLE
 	bool "Sable"
+	select HAVE_EISA
 	help
 	  Digital AlphaServer 2000 and 2100-based systems.
 
@@ -518,11 +526,6 @@ config ALPHA_SRM
 
 	  If unsure, say N.
 
-config EISA
-	bool
-	depends on ALPHA_GENERIC || ALPHA_JENSEN || ALPHA_ALCOR || ALPHA_MIKASA || ALPHA_SABLE || ALPHA_LYNX || ALPHA_NORITAKE || ALPHA_RAWHIDE
-	default y
-
 config ARCH_MAY_HAVE_PC_FDC
 	def_bool y
 
@@ -673,8 +676,6 @@ config HZ
 	default 1200 if HZ_1200
 	default 1024
 
-source "drivers/eisa/Kconfig"
-
 config SRM_ENV
 	tristate "SRM environment through procfs"
 	depends on PROC_FS
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 96198f8375e1..7cf58031a43e 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -23,6 +23,7 @@ config MIPS
 	select GENERIC_CPU_AUTOPROBE
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select GENERIC_ISA_DMA if EISA
 	select GENERIC_LIB_ASHLDI3
 	select GENERIC_LIB_ASHRDI3
 	select GENERIC_LIB_CMPDI2
@@ -72,6 +73,7 @@ config MIPS
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_VIRT_CPU_ACCOUNTING_GEN if 64BIT || !SMP
 	select IRQ_FORCED_THREADING
+	select ISA if EISA
 	select MODULES_USE_ELF_RELA if MODULES && 64BIT
 	select MODULES_USE_ELF_REL if MODULES
 	select PCI_DOMAINS if PCI
@@ -634,7 +636,7 @@ config SGI_IP22
 	select CSRC_R4K
 	select DEFAULT_SGI_PARTITION
 	select DMA_NONCOHERENT
-	select HW_HAS_EISA
+	select HAVE_EISA
 	select I8253
 	select I8259
 	select IP22_CPU_SCACHE
@@ -699,7 +701,7 @@ config SGI_IP28
 	select DMA_NONCOHERENT
 	select GENERIC_ISA_DMA_SUPPORT_BROKEN
 	select IRQ_MIPS_CPU
-	select HW_HAS_EISA
+	select HAVE_EISA
 	select I8253
 	select I8259
 	select SGI_HAS_I8042
@@ -842,8 +844,8 @@ config SNI_RM
 	select DEFAULT_SGI_PARTITION if CPU_BIG_ENDIAN
 	select DMA_NONCOHERENT
 	select GENERIC_ISA_DMA
+	select HAVE_EISA
 	select HAVE_PCSPKR_PLATFORM
-	select HW_HAS_EISA
 	select HAVE_PCI
 	select IRQ_MIPS_CPU
 	select I8253
@@ -2991,9 +2993,6 @@ config MIPS_AUTO_PFN_OFFSET
 
 menu "Bus options (PCI, PCMCIA, EISA, ISA, TC)"
 
-config HW_HAS_EISA
-	bool
-
 config HT_PCI
 	bool "Support for HT-linked PCI"
 	default y
@@ -3027,26 +3026,6 @@ config PCI_DRIVERS_LEGACY
 config ISA
 	bool
 
-config EISA
-	bool "EISA support"
-	depends on HW_HAS_EISA
-	select ISA
-	select GENERIC_ISA_DMA
-	---help---
-	  The Extended Industry Standard Architecture (EISA) bus was
-	  developed as an open alternative to the IBM MicroChannel bus.
-
-	  The EISA bus provided some of the features of the IBM MicroChannel
-	  bus while maintaining backward compatibility with cards made for
-	  the older ISA bus.  The EISA bus saw limited use between 1988 and
-	  1995 when it was made obsolete by the PCI bus.
-
-	  Say Y here if you are building a kernel for an EISA-based machine.
-
-	  Otherwise, say N.
-
-source "drivers/eisa/Kconfig"
-
 config TC
 	bool "TURBOchannel support"
 	depends on MACH_DECSTATION
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 6b29c27770db..f3ec13765639 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -900,9 +900,6 @@ config PPC_INDIRECT_PCI
 	default y if 40x || 44x
 	default n
 
-config EISA
-	bool
-
 config SBUS
 	bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6fe3740018f6..c9f9f62700d8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -144,6 +144,7 @@ config X86
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS
 	select HAVE_EBPF_JIT
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
+	select HAVE_EISA
 	select HAVE_EXIT_THREAD
 	select HAVE_FENTRY			if X86_64 || DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
@@ -2680,24 +2681,6 @@ config ISA
 	  (MCA) or VESA.  ISA is an older system, now being displaced by PCI;
 	  newer boards don't support it.  If you have ISA, say Y, otherwise N.
 
-config EISA
-	bool "EISA support"
-	depends on ISA
-	---help---
-	  The Extended Industry Standard Architecture (EISA) bus was
-	  developed as an open alternative to the IBM MicroChannel bus.
-
-	  The EISA bus provided some of the features of the IBM MicroChannel
-	  bus while maintaining backward compatibility with cards made for
-	  the older ISA bus.  The EISA bus saw limited use between 1988 and
-	  1995 when it was made obsolete by the PCI bus.
-
-	  Say Y here if you are building a kernel for an EISA-based machine.
-
-	  Otherwise, say N.
-
-source "drivers/eisa/Kconfig"
-
 config SCx200
 	tristate "NatSemi SCx200 support"
 	---help---
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 065d308fcb00..ea58a6b99288 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -4,6 +4,7 @@ menu "Device Drivers"
 # Keep I/O buses first
 
 source "drivers/amba/Kconfig"
+source "drivers/eisa/Kconfig"
 source "drivers/pci/Kconfig"
 source "drivers/pcmcia/Kconfig"
 source "drivers/rapidio/Kconfig"
diff --git a/drivers/eisa/Kconfig b/drivers/eisa/Kconfig
index 2705284f6223..4570e3bca42c 100644
--- a/drivers/eisa/Kconfig
+++ b/drivers/eisa/Kconfig
@@ -1,6 +1,26 @@
 #
 # EISA configuration
 #
+
+config HAVE_EISA
+	bool
+
+menuconfig EISA
+	bool "EISA support"
+	depends on HAVE_EISA
+	---help---
+	  The Extended Industry Standard Architecture (EISA) bus was
+	  developed as an open alternative to the IBM MicroChannel bus.
+
+	  The EISA bus provided some of the features of the IBM MicroChannel
+	  bus while maintaining backward compatibility with cards made for
+	  the older ISA bus.  The EISA bus saw limited use between 1988 and
+	  1995 when it was made obsolete by the PCI bus.
+
+	  Say Y here if you are building a kernel for an EISA-based machine.
+
+	  Otherwise, say N.
+
 config EISA_VLB_PRIMING
 	bool "Vesa Local Bus priming"
 	depends on X86 && EISA
@@ -53,4 +73,3 @@ config EISA_NAMES
 	  names.
 
 	  When in doubt, say Y.
-
diff --git a/drivers/parisc/Kconfig b/drivers/parisc/Kconfig
index 1a55763d1245..74e119adca01 100644
--- a/drivers/parisc/Kconfig
+++ b/drivers/parisc/Kconfig
@@ -2,6 +2,7 @@ menu "Bus options (PCI, PCMCIA, EISA, GSC, ISA)"
 
 config GSC
 	bool "VSC/GSC/HSC bus support"
+	select HAVE_EISA
 	default y
 	help
 	  The VSC, GSC and HSC busses were used from the earliest 700-series
@@ -46,16 +47,6 @@ config GSC_WAX
 	  used), a HIL interface chip and is also known to be used as the
 	  GSC bridge for an X.25 GSC card.
 
-config EISA
-	bool "EISA support"
-	depends on GSC
-	help
-	  Say Y here if you have an EISA bus in your machine.  This code
-	  supports both the Mongoose & Wax EISA adapters.  It is sadly
-	  incomplete and lacks support for card-to-host DMA.
-
-source "drivers/eisa/Kconfig"
-
 config ISA
 	bool "ISA support"
 	depends on EISA
-- 
2.19.1
