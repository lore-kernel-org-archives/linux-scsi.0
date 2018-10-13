From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/8] eisa: consolidate EISA Kconfig entry in drivers/eisa
Date: Sat, 13 Oct 2018 17:10:15 +0200
Message-ID: <20181013151016.31674-8-hch@lst.de>
References: <20181013151016.31674-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181013151016.31674-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Matt Porter <mporter@kernel.crashing.org>, Alexandre Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-kbuild@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

Let architectures opt into EISA support by selecting HAS_EISA and
handle everything else in drivers/eisa.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/alpha/Kconfig     |  8 +++-----
 arch/arm/Kconfig       | 16 +---------------
 arch/mips/Kconfig      | 31 +++++--------------------------
 arch/powerpc/Kconfig   |  3 ---
 arch/x86/Kconfig       | 19 +------------------
 drivers/eisa/Kconfig   | 21 ++++++++++++++++++++-
 drivers/parisc/Kconfig | 11 +----------
 7 files changed, 31 insertions(+), 78 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 73a7558c71bd..6a9be9cb74e6 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -6,6 +6,9 @@ config ALPHA
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select ARCH_NO_PREEMPT
 	select ARCH_USE_CMPXCHG_LOCKREF
+	select HAS_EISA if ALPHA_GENERIC || ALPHA_JENSEN || ALPHA_ALCOR || \
+				ALPHA_MIKASA || ALPHA_SABLE || ALPHA_LYNX || \
+				ALPHA_NORITAKE || ALPHA_RAWHIDE
 	select HAS_PCI if !ALPHA_JENSEN
 	select PCI if !ALPHA_JENSEN
 	select HAVE_AOUT
@@ -518,11 +521,6 @@ config ALPHA_SRM
 
 	  If unsure, say N.
 
-config EISA
-	bool
-	depends on ALPHA_GENERIC || ALPHA_JENSEN || ALPHA_ALCOR || ALPHA_MIKASA || ALPHA_SABLE || ALPHA_LYNX || ALPHA_NORITAKE || ALPHA_RAWHIDE
-	default y
-
 config ARCH_MAY_HAVE_PC_FDC
 	def_bool y
 
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 0339c074147f..1903f73d42e7 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -49,6 +49,7 @@ config ARM
 	select GENERIC_STRNLEN_USER
 	select HANDLE_DOMAIN_IRQ
 	select HARDIRQS_SW_RESEND
+	select HAS_EISA
 	select HAVE_ARCH_AUDITSYSCALL if (AEABI && !OABI_COMPAT)
 	select HAVE_ARCH_BITREVERSE if (CPU_32v7M || CPU_32v7) && !CPU_32v6
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL && !CPU_ENDIAN_BE32 && MMU
@@ -162,21 +163,6 @@ config HAVE_PROC_CPU
 config NO_IOPORT_MAP
 	bool
 
-config EISA
-	bool
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
 config SBUS
 	bool
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 70a9e09329bb..b3e6b2adf510 100644
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
+	select HAS_EISA
 	select I8253
 	select I8259
 	select IP22_CPU_SCACHE
@@ -699,7 +701,7 @@ config SGI_IP28
 	select DMA_NONCOHERENT
 	select GENERIC_ISA_DMA_SUPPORT_BROKEN
 	select IRQ_MIPS_CPU
-	select HW_HAS_EISA
+	select HAS_EISA
 	select I8253
 	select I8259
 	select SGI_HAS_I8042
@@ -843,7 +845,7 @@ config SNI_RM
 	select DMA_NONCOHERENT
 	select GENERIC_ISA_DMA
 	select HAVE_PCSPKR_PLATFORM
-	select HW_HAS_EISA
+	select HAS_EISA
 	select HAS_PCI
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
index b1c3a47f1f30..f0ea460653cd 100644
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
index f731ad1a043a..6a4fb550a206 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -113,6 +113,7 @@ config X86
 	select GENERIC_STRNLEN_USER
 	select GENERIC_TIME_VSYSCALL
 	select HARDLOCKUP_CHECK_TIMESTAMP	if X86_64
+	select HAS_EISA
 	select HAS_PCI
 	select HAVE_ACPI_APEI			if ACPI
 	select HAVE_ACPI_APEI_NMI		if ACPI
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
diff --git a/drivers/eisa/Kconfig b/drivers/eisa/Kconfig
index 2705284f6223..bd35daffee3b 100644
--- a/drivers/eisa/Kconfig
+++ b/drivers/eisa/Kconfig
@@ -1,6 +1,26 @@
 #
 # EISA configuration
 #
+
+config HAS_EISA
+	bool
+
+menuconfig EISA
+	bool "EISA support"
+	depends on HAS_EISA
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
index 1a55763d1245..09c5e59f5374 100644
--- a/drivers/parisc/Kconfig
+++ b/drivers/parisc/Kconfig
@@ -2,6 +2,7 @@ menu "Bus options (PCI, PCMCIA, EISA, GSC, ISA)"
 
 config GSC
 	bool "VSC/GSC/HSC bus support"
+	select HAS_EISA
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
