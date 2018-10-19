From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/9] PCI: consolidate PCI config entry in drivers/pci
Date: Fri, 19 Oct 2018 14:09:49 +0200
Message-ID: <20181019120952.32763-7-hch@lst.de>
References: <20181019120952.32763-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019120952.32763-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Matt Porter <mporter@kernel.crashing.org>, Alexandre Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

There is no good reason to duplicate the PCI menu in every architecture.
Instead provide a selectable HAVE_PCI symbol that indicates availability
of PCI support and the handle the rest in drivers/pci.

Note that for powerpc we now select HAVE_PCI globally instead of the
convoluted mess of conditional or or non-conditional support per board,
similar to what we do e.g. on x86.  For alpha PCI is selected for the
non-jensen configs as it was the default before, and a lot of code does
not compile without PCI enabled.  On other architectures with limited
PCI support that wasn't as complicated I've left the selection as-is.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Max Filippov <jcmvbkbc@gmail.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/alpha/Kconfig                     | 15 ++-------
 arch/arc/Kconfig                       | 20 ------------
 arch/arc/plat-axs10x/Kconfig           |  2 +-
 arch/arc/plat-hsdk/Kconfig             |  2 +-
 arch/arm/Kconfig                       | 19 ++----------
 arch/arm/mach-ks8695/Kconfig           | 10 +++---
 arch/arm/mach-pxa/Kconfig              |  2 +-
 arch/arm64/Kconfig                     | 10 +-----
 arch/hexagon/Kconfig                   |  3 --
 arch/ia64/Kconfig                      |  9 +-----
 arch/m68k/Kconfig.bus                  | 11 -------
 arch/m68k/Kconfig.cpu                  |  1 +
 arch/microblaze/Kconfig                |  6 +---
 arch/mips/Kconfig                      | 43 +++++++++-----------------
 arch/mips/alchemy/Kconfig              |  6 ++--
 arch/mips/ath25/Kconfig                |  2 +-
 arch/mips/ath79/Kconfig                |  8 ++---
 arch/mips/bcm63xx/Kconfig              | 14 ++++-----
 arch/mips/lantiq/Kconfig               |  2 +-
 arch/mips/loongson64/Kconfig           |  6 ++--
 arch/mips/pmcs-msp71xx/Kconfig         | 10 +++---
 arch/mips/ralink/Kconfig               |  8 ++---
 arch/mips/sibyte/Kconfig               | 10 +++---
 arch/mips/txx9/Kconfig                 |  8 ++---
 arch/mips/vr41xx/Kconfig               |  8 ++---
 arch/parisc/Kconfig                    |  1 +
 arch/powerpc/Kconfig                   | 25 ++++-----------
 arch/powerpc/platforms/44x/Kconfig     |  1 -
 arch/powerpc/platforms/512x/Kconfig    |  1 -
 arch/powerpc/platforms/52xx/Kconfig    |  1 -
 arch/powerpc/platforms/83xx/Kconfig    |  1 -
 arch/powerpc/platforms/85xx/Kconfig    |  1 -
 arch/powerpc/platforms/86xx/Kconfig    |  2 --
 arch/powerpc/platforms/Kconfig         |  1 -
 arch/powerpc/platforms/Kconfig.cputype |  2 --
 arch/powerpc/platforms/ps3/Kconfig     |  1 -
 arch/riscv/Kconfig                     | 18 ++---------
 arch/s390/Kconfig                      | 23 +++++---------
 arch/sh/Kconfig                        | 19 ++----------
 arch/sh/boards/Kconfig                 | 30 +++++++++---------
 arch/sparc/Kconfig                     | 15 +--------
 arch/um/Kconfig                        |  3 --
 arch/unicore32/Kconfig                 | 11 +------
 arch/x86/Kconfig                       | 12 +------
 arch/x86/configs/i386_defconfig        |  1 +
 arch/x86/configs/x86_64_defconfig      |  1 +
 arch/xtensa/Kconfig                    | 16 +---------
 arch/xtensa/configs/common_defconfig   |  1 +
 arch/xtensa/configs/iss_defconfig      |  1 -
 drivers/Kconfig                        |  4 +++
 drivers/parisc/Kconfig                 | 11 -------
 drivers/pci/Kconfig                    | 12 +++++++
 drivers/pci/endpoint/Kconfig           |  2 +-
 53 files changed, 133 insertions(+), 319 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 5b4f88363453..bb89924c0361 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -6,6 +6,8 @@ config ALPHA
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select ARCH_NO_PREEMPT
 	select ARCH_USE_CMPXCHG_LOCKREF
+	select HAVE_PCI if !ALPHA_JENSEN
+	select PCI if !ALPHA_JENSEN
 	select HAVE_AOUT
 	select HAVE_IDE
 	select HAVE_OPROFILE
@@ -15,6 +17,7 @@ config ALPHA
 	select NEED_SG_DMA_LENGTH
 	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
+	select GENERIC_PCI_IOMAP if PCI
 	select AUTO_IRQ_AFFINITY if SMP
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_IPC_PARSE_VERSION
@@ -319,17 +322,6 @@ config ISA_DMA_API
 	bool
 	default y
 
-config PCI
-	bool
-	depends on !ALPHA_JENSEN
-	select GENERIC_PCI_IOMAP
-	default y
-	help
-	  Find out whether you have a PCI motherboard. PCI is the name of a
-	  bus system, i.e. the way the CPU talks to the other stuff inside
-	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
-	  VESA. If you have PCI, say Y, otherwise N.
-
 config PCI_DOMAINS
 	bool
 	default y
@@ -681,7 +673,6 @@ config HZ
 	default 1200 if HZ_1200
 	default 1024
 
-source "drivers/pci/Kconfig"
 source "drivers/eisa/Kconfig"
 
 source "drivers/pcmcia/Kconfig"
diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index a045f3086047..55a6953e9239 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -53,9 +53,6 @@ config ARC
 config ARCH_HAS_CACHE_LINE_SIZE
 	def_bool y
 
-config MIGHT_HAVE_PCI
-	bool
-
 config TRACE_IRQFLAGS_SUPPORT
 	def_bool y
 
@@ -555,24 +552,7 @@ config FORCE_MAX_ZONEORDER
 	default "12" if ARC_HUGEPAGE_16M
 	default "11"
 
-menu "Bus Support"
-
-config PCI
-	bool "PCI support" if MIGHT_HAVE_PCI
-	help
-	  PCI is the name of a bus system, i.e., the way the CPU talks to
-	  the other stuff inside your box.  Find out if your board/platform
-	  has PCI.
-
-	  Note: PCIe support for Synopsys Device will be available only
-	  when HAPS DX is configured with PCIe RC bitmap. If you have PCI,
-	  say Y, otherwise N.
-
 config PCI_SYSCALL
 	def_bool PCI
 
-source "drivers/pci/Kconfig"
-
-endmenu
-
 source "kernel/power/Kconfig"
diff --git a/arch/arc/plat-axs10x/Kconfig b/arch/arc/plat-axs10x/Kconfig
index 4e0df7b7a248..27b9eb97a6bf 100644
--- a/arch/arc/plat-axs10x/Kconfig
+++ b/arch/arc/plat-axs10x/Kconfig
@@ -11,7 +11,7 @@ menuconfig ARC_PLAT_AXS10X
 	select DW_APB_ICTL
 	select GPIO_DWAPB
 	select OF_GPIO
-	select MIGHT_HAVE_PCI
+	select HAVE_PCI
 	select GENERIC_IRQ_CHIP
 	select GPIOLIB
 	select AXS101 if ISA_ARCOMPACT
diff --git a/arch/arc/plat-hsdk/Kconfig b/arch/arc/plat-hsdk/Kconfig
index 9356753c2ed8..f25c085b9874 100644
--- a/arch/arc/plat-hsdk/Kconfig
+++ b/arch/arc/plat-hsdk/Kconfig
@@ -11,4 +11,4 @@ menuconfig ARC_SOC_HSDK
 	select ARC_HAS_ACCL_REGS
 	select CLK_HSDK
 	select RESET_HSDK
-	select MIGHT_HAVE_PCI
+	select HAVE_PCI
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e33735ce1c14..7495d0a0aa31 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -149,9 +149,6 @@ config ARM_DMA_IOMMU_ALIGNMENT
 
 endif
 
-config MIGHT_HAVE_PCI
-	bool
-
 config SYS_SUPPORTS_APM_EMULATION
 	bool
 
@@ -320,7 +317,7 @@ config ARCH_MULTIPLATFORM
 	select COMMON_CLK
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_IRQ_MULTI_HANDLER
-	select MIGHT_HAVE_PCI
+	select HAVE_PCI
 	select PCI_DOMAINS if PCI
 	select SPARSE_IRQ
 	select USE_OF
@@ -436,7 +433,7 @@ config ARCH_IXP4XX
 	select DMABOUNCE if PCI
 	select GENERIC_CLOCKEVENTS
 	select GPIOLIB
-	select MIGHT_HAVE_PCI
+	select HAVE_PCI
 	select NEED_MACH_IO_H
 	select USB_EHCI_BIG_ENDIAN_DESC
 	select USB_EHCI_BIG_ENDIAN_MMIO
@@ -449,7 +446,7 @@ config ARCH_DOVE
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_IRQ_MULTI_HANDLER
 	select GPIOLIB
-	select MIGHT_HAVE_PCI
+	select HAVE_PCI
 	select MVEBU_MBUS
 	select PINCTRL
 	select PINCTRL_DOVE
@@ -1216,14 +1213,6 @@ config ISA_DMA
 config ISA_DMA_API
 	bool
 
-config PCI
-	bool "PCI support" if MIGHT_HAVE_PCI
-	help
-	  Find out whether you have a PCI motherboard. PCI is the name of a
-	  bus system, i.e. the way the CPU talks to the other stuff inside
-	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
-	  VESA. If you have PCI, say Y, otherwise N.
-
 config PCI_DOMAINS
 	bool "Support for multiple PCI domains"
 	depends on PCI
@@ -1252,8 +1241,6 @@ config PCI_HOST_ITE8152
 	default y
 	select DMABOUNCE
 
-source "drivers/pci/Kconfig"
-
 source "drivers/pcmcia/Kconfig"
 
 endmenu
diff --git a/arch/arm/mach-ks8695/Kconfig b/arch/arm/mach-ks8695/Kconfig
index a545976bdbd6..b3185c05fffa 100644
--- a/arch/arm/mach-ks8695/Kconfig
+++ b/arch/arm/mach-ks8695/Kconfig
@@ -4,7 +4,7 @@ menu "Kendin/Micrel KS8695 Implementations"
 
 config MACH_KS8695
 	bool "KS8695 development board"
-	select MIGHT_HAVE_PCI
+	select HAVE_PCI
 	help
 	  Say 'Y' here if you want your kernel to run on the original
 	  Kendin-Micrel KS8695 development board.
@@ -52,7 +52,7 @@ config MACH_CM4002
 
 config MACH_CM4008
 	bool "OpenGear CM4008"
-	select MIGHT_HAVE_PCI
+	select HAVE_PCI
 	help
 	  Say 'Y' here if you want your kernel to support the OpenGear
 	  CM4008 Console Server. See http://www.opengear.com for more
@@ -60,7 +60,7 @@ config MACH_CM4008
 
 config MACH_CM41xx
 	bool "OpenGear CM41xx"
-	select MIGHT_HAVE_PCI
+	select HAVE_PCI
 	help
 	  Say 'Y' here if you want your kernel to support the OpenGear
 	  CM4016 or CM4048 Console Servers. See http://www.opengear.com for
@@ -68,7 +68,7 @@ config MACH_CM41xx
 
 config MACH_IM4004
 	bool "OpenGear IM4004"
-	select MIGHT_HAVE_PCI
+	select HAVE_PCI
 	help
 	  Say 'Y' here if you want your kernel to support the OpenGear
 	  IM4004 Secure Access Server. See http://www.opengear.com for
@@ -76,7 +76,7 @@ config MACH_IM4004
 
 config MACH_IM42xx
 	bool "OpenGear IM42xx"
-	select MIGHT_HAVE_PCI
+	select HAVE_PCI
 	help
 	  Say 'Y' here if you want your kernel to support the OpenGear
 	  IM4216 or IM4248 Console Servers. See http://www.opengear.com for
diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index a68b34183107..b185794549be 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -125,7 +125,7 @@ config MACH_ARMCORE
 	bool "CompuLab CM-X255/CM-X270 modules"
 	select ARCH_HAS_DMA_SET_COHERENT_MASK if PCI
 	select IWMMXT
-	select MIGHT_HAVE_PCI
+	select HAVE_PCI
 	select NEED_MACH_IO_H if PCI
 	select PXA25x
 	select PXA27x
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1b1a0e95c751..ae0f1ef0a748 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -98,6 +98,7 @@ config ARM64
 	select GENERIC_TIME_VSYSCALL
 	select HANDLE_DOMAIN_IRQ
 	select HARDIRQS_SW_RESEND
+	select HAVE_PCI
 	select HAVE_ACPI_APEI if (ACPI && EFI)
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
 	select HAVE_ARCH_AUDITSYSCALL
@@ -284,13 +285,6 @@ source "arch/arm64/Kconfig.platforms"
 
 menu "Bus support"
 
-config PCI
-	bool "PCI support"
-	help
-	  This feature enables support for PCI bus system. If you say Y
-	  here, the kernel will include drivers and infrastructure code
-	  to support PCI bus devices.
-
 config PCI_DOMAINS
 	def_bool PCI
 
@@ -300,8 +294,6 @@ config PCI_DOMAINS_GENERIC
 config PCI_SYSCALL
 	def_bool PCI
 
-source "drivers/pci/Kconfig"
-
 endmenu
 
 menu "Kernel Features"
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 89a4b22f34d9..1bc856c61ed8 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -44,9 +44,6 @@ config FRAME_POINTER
 config LOCKDEP_SUPPORT
 	def_bool y
 
-config PCI
-	def_bool n
-
 config EARLY_PRINTK
 	def_bool y
 
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 8b4a0c1748c0..89da763d7c17 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -51,6 +51,7 @@ config IA64
 	select MODULES_USE_ELF_RELA
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select HAVE_ARCH_AUDITSYSCALL
+	select HAVE_PCI if !IA64_HP_SIM
 	select NEED_DMA_MAP_STATE
 	select NEED_SG_DMA_LENGTH
 	default y
@@ -546,20 +547,12 @@ if !IA64_HP_SIM
 
 menu "Bus options (PCI, PCMCIA)"
 
-config PCI
-	bool "PCI support"
-	help
-	  Real IA-64 machines all have PCI/PCI-X/PCI Express busses.  Say Y
-	  here unless you are using a simulator without PCI support.
-
 config PCI_DOMAINS
 	def_bool PCI
 
 config PCI_SYSCALL
 	def_bool PCI
 
-source "drivers/pci/Kconfig"
-
 source "drivers/pcmcia/Kconfig"
 
 endmenu
diff --git a/arch/m68k/Kconfig.bus b/arch/m68k/Kconfig.bus
index aef698fa50e5..8cb0604b195b 100644
--- a/arch/m68k/Kconfig.bus
+++ b/arch/m68k/Kconfig.bus
@@ -63,17 +63,6 @@ source "drivers/zorro/Kconfig"
 
 endif
 
-config PCI
-	bool "PCI support"
-	depends on M54xx
-	help
-	  Enable the PCI bus. Support for the PCI bus hardware built into the
-	  ColdFire 547x and 548x processors.
-
-if PCI
-source "drivers/pci/Kconfig"
-endif
-
 if !MMU
 
 config ISA_DMA_API
diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index 21f00349af52..60ac1cd8b96f 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -299,6 +299,7 @@ config M53xx
 	bool
 
 config M54xx
+	select HAVE_PCI
 	bool
 
 endif # COLDFIRE
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index ace5c5bf1836..3d352862db30 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -32,6 +32,7 @@ config MICROBLAZE
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_OPROFILE
+	select HAVE_PCI
 	select IRQ_DOMAIN
 	select XILINX_INTC
 	select MODULES_USE_ELF_RELA
@@ -268,9 +269,6 @@ endmenu
 
 menu "Bus Options"
 
-config PCI
-	bool "PCI support"
-
 config PCI_DOMAINS
 	def_bool PCI
 
@@ -284,6 +282,4 @@ config PCI_XILINX
 	bool "Xilinx PCI host bridge support"
 	depends on PCI
 
-source "drivers/pci/Kconfig"
-
 endmenu
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 35511999156a..09b93d5a55cb 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -74,6 +74,7 @@ config MIPS
 	select IRQ_FORCED_THREADING
 	select MODULES_USE_ELF_RELA if MODULES && 64BIT
 	select MODULES_USE_ELF_REL if MODULES
+	select PCI_DOMAINS if PCI
 	select PERF_USE_VMALLOC
 	select RTC_LIB if !MACH_LOONGSON64
 	select SYSCTL_EXCEPTION_TRACE
@@ -96,7 +97,7 @@ config MIPS_GENERIC
 	select CPU_MIPSR2_IRQ_EI
 	select CSRC_R4K
 	select DMA_PERDEV_COHERENT
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select IRQ_MIPS_CPU
 	select LIBFDT
 	select MIPS_AUTO_PFN_OFFSET
@@ -256,7 +257,7 @@ config BCM47XX
 	select CEVT_R4K
 	select CSRC_R4K
 	select DMA_NONCOHERENT
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select IRQ_MIPS_CPU
 	select SYS_HAS_CPU_MIPS32_R1
 	select NO_EXCEPT_FILL
@@ -299,7 +300,7 @@ config MIPS_COBALT
 	select CSRC_R4K
 	select CEVT_GT641XX
 	select DMA_NONCOHERENT
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select I8253
 	select I8259
 	select IRQ_MIPS_CPU
@@ -422,7 +423,7 @@ config LASAT
 	select CSRC_R4K
 	select DMA_NONCOHERENT
 	select SYS_HAS_EARLY_PRINTK
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select IRQ_MIPS_CPU
 	select PCI_GT64XXX_PCI0
 	select MIPS_NILE4
@@ -502,7 +503,7 @@ config MIPS_MALTA
 	select HAVE_PCSPKR_PLATFORM
 	select IRQ_MIPS_CPU
 	select MIPS_GIC
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select I8253
 	select I8259
 	select MIPS_BONITO64
@@ -556,7 +557,7 @@ config MACH_PIC32
 config NEC_MARKEINS
 	bool "NEC EMMA2RH Mark-eins board"
 	select SOC_EMMA2RH
-	select HW_HAS_PCI
+	select HAVE_PCI
 	help
 	  This enables support for the NEC Electronics Mark-eins boards.
 
@@ -673,7 +674,7 @@ config SGI_IP27
 	select BOOT_ELF64
 	select DEFAULT_SGI_PARTITION
 	select SYS_HAS_EARLY_PRINTK
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select NR_CPUS_DEFAULT_64
 	select SYS_HAS_CPU_R10000
 	select SYS_SUPPORTS_64BIT_KERNEL
@@ -733,7 +734,7 @@ config SGI_IP32
 	select CEVT_R4K
 	select CSRC_R4K
 	select DMA_NONCOHERENT
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select IRQ_MIPS_CPU
 	select R5000_CPU_SCACHE
 	select RM7000_CPU_SCACHE
@@ -843,7 +844,7 @@ config SNI_RM
 	select GENERIC_ISA_DMA
 	select HAVE_PCSPKR_PLATFORM
 	select HW_HAS_EISA
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select IRQ_MIPS_CPU
 	select I8253
 	select I8259
@@ -876,7 +877,7 @@ config MIKROTIK_RB532
 	select CEVT_R4K
 	select CSRC_R4K
 	select DMA_NONCOHERENT
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select IRQ_MIPS_CPU
 	select SYS_HAS_CPU_MIPS32_R1
 	select SYS_SUPPORTS_32BIT_KERNEL
@@ -903,7 +904,7 @@ config CAVIUM_OCTEON_SOC
 	select SYS_SUPPORTS_HOTPLUG_CPU if CPU_BIG_ENDIAN
 	select SYS_HAS_EARLY_PRINTK
 	select SYS_HAS_CPU_CAVIUM_OCTEON
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select ZONE_DMA32
 	select HOLES_IN_ZONE
 	select GPIOLIB
@@ -936,7 +937,7 @@ config NLM_XLR_BOARD
 	select NLM_COMMON
 	select SYS_HAS_CPU_XLR
 	select SYS_SUPPORTS_SMP
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select SWAP_IO_SPACE
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select SYS_SUPPORTS_64BIT_KERNEL
@@ -962,7 +963,7 @@ config NLM_XLP_BOARD
 	select NLM_COMMON
 	select SYS_HAS_CPU_XLP
 	select SYS_SUPPORTS_SMP
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select SYS_SUPPORTS_64BIT_KERNEL
 	select PHYS_ADDR_T_64BIT
@@ -997,7 +998,7 @@ config MIPS_PARAVIRT
 	select SYS_HAS_CPU_MIPS32_R2
 	select SYS_HAS_CPU_MIPS64_R2
 	select SYS_HAS_CPU_CAVIUM_OCTEON
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select SWAP_IO_SPACE
 	help
 	  This option supports guest running under ????
@@ -2992,18 +2993,6 @@ menu "Bus options (PCI, PCMCIA, EISA, ISA, TC)"
 
 config HW_HAS_EISA
 	bool
-config HW_HAS_PCI
-	bool
-
-config PCI
-	bool "Support for PCI controller"
-	depends on HW_HAS_PCI
-	select PCI_DOMAINS
-	help
-	  Find out whether you have a PCI motherboard. PCI is the name of a
-	  bus system, i.e. the way the CPU talks to the other stuff inside
-	  your box. Other bus systems are ISA, EISA, or VESA. If you have PCI,
-	  say Y, otherwise N.
 
 config HT_PCI
 	bool "Support for HT-linked PCI"
@@ -3030,8 +3019,6 @@ config PCI_DRIVERS_LEGACY
 	def_bool !PCI_DRIVERS_GENERIC
 	select NO_GENERIC_PCI_IOPORT_MAP
 
-source "drivers/pci/Kconfig"
-
 #
 # ISA support is now enabled via select.  Too many systems still have the one
 # or other ISA chip on the board that users don't know about so don't expect
diff --git a/arch/mips/alchemy/Kconfig b/arch/mips/alchemy/Kconfig
index 7d73f7f4202b..83b288b95b16 100644
--- a/arch/mips/alchemy/Kconfig
+++ b/arch/mips/alchemy/Kconfig
@@ -14,7 +14,7 @@ choice
 
 config MIPS_MTX1
 	bool "4G Systems MTX-1 board"
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select ALCHEMY_GPIOINT_AU1000
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_HAS_EARLY_PRINTK
@@ -22,7 +22,7 @@ config MIPS_MTX1
 config MIPS_DB1XXX
 	bool "Alchemy DB1XXX / PB1XXX boards"
 	select GPIOLIB
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_HAS_EARLY_PRINTK
 	help
@@ -40,7 +40,7 @@ config MIPS_XXS1500
 config MIPS_GPR
 	bool "Trapeze ITS GPR board"
 	select ALCHEMY_GPIOINT_AU1000
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_HAS_EARLY_PRINTK
 
diff --git a/arch/mips/ath25/Kconfig b/arch/mips/ath25/Kconfig
index 2c1dfd06c366..4c1b4579c814 100644
--- a/arch/mips/ath25/Kconfig
+++ b/arch/mips/ath25/Kconfig
@@ -13,6 +13,6 @@ config PCI_AR2315
 	bool "Atheros AR2315 PCI controller support"
 	depends on SOC_AR2315
 	select ARCH_HAS_PHYS_TO_DMA
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select PCI
 	default y
diff --git a/arch/mips/ath79/Kconfig b/arch/mips/ath79/Kconfig
index 9547cf1ea38d..191c3910eac5 100644
--- a/arch/mips/ath79/Kconfig
+++ b/arch/mips/ath79/Kconfig
@@ -75,11 +75,11 @@ config ATH79_MACH_UBNT_XM
 endmenu
 
 config SOC_AR71XX
-	select HW_HAS_PCI
+	select HAVE_PCI
 	def_bool n
 
 config SOC_AR724X
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select PCI_AR724X if PCI
 	def_bool n
 
@@ -90,12 +90,12 @@ config SOC_AR933X
 	def_bool n
 
 config SOC_AR934X
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select PCI_AR724X if PCI
 	def_bool n
 
 config SOC_QCA955X
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select PCI_AR724X if PCI
 	def_bool n
 
diff --git a/arch/mips/bcm63xx/Kconfig b/arch/mips/bcm63xx/Kconfig
index 96ed735a4f4a..837f6e5a2f37 100644
--- a/arch/mips/bcm63xx/Kconfig
+++ b/arch/mips/bcm63xx/Kconfig
@@ -5,17 +5,17 @@ menu "CPU support"
 config BCM63XX_CPU_3368
 	bool "support 3368 CPU"
 	select SYS_HAS_CPU_BMIPS4350
-	select HW_HAS_PCI
+	select HAVE_PCI
 
 config BCM63XX_CPU_6328
 	bool "support 6328 CPU"
 	select SYS_HAS_CPU_BMIPS4350
-	select HW_HAS_PCI
+	select HAVE_PCI
 
 config BCM63XX_CPU_6338
 	bool "support 6338 CPU"
 	select SYS_HAS_CPU_BMIPS32_3300
-	select HW_HAS_PCI
+	select HAVE_PCI
 
 config BCM63XX_CPU_6345
 	bool "support 6345 CPU"
@@ -24,22 +24,22 @@ config BCM63XX_CPU_6345
 config BCM63XX_CPU_6348
 	bool "support 6348 CPU"
 	select SYS_HAS_CPU_BMIPS32_3300
-	select HW_HAS_PCI
+	select HAVE_PCI
 
 config BCM63XX_CPU_6358
 	bool "support 6358 CPU"
 	select SYS_HAS_CPU_BMIPS4350
-	select HW_HAS_PCI
+	select HAVE_PCI
 
 config BCM63XX_CPU_6362
 	bool "support 6362 CPU"
 	select SYS_HAS_CPU_BMIPS4350
-	select HW_HAS_PCI
+	select HAVE_PCI
 
 config BCM63XX_CPU_6368
 	bool "support 6368 CPU"
 	select SYS_HAS_CPU_BMIPS4350
-	select HW_HAS_PCI
+	select HAVE_PCI
 endmenu
 
 source "arch/mips/bcm63xx/boards/Kconfig"
diff --git a/arch/mips/lantiq/Kconfig b/arch/mips/lantiq/Kconfig
index 8e3a1fc2bc39..188de95d6dbd 100644
--- a/arch/mips/lantiq/Kconfig
+++ b/arch/mips/lantiq/Kconfig
@@ -19,7 +19,7 @@ config SOC_AMAZON_SE
 config SOC_XWAY
 	bool "XWAY"
 	select SOC_TYPE_XWAY
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select MFD_SYSCON
 	select MFD_CORE
 
diff --git a/arch/mips/loongson64/Kconfig b/arch/mips/loongson64/Kconfig
index c865b4b9b775..edd23dc4589d 100644
--- a/arch/mips/loongson64/Kconfig
+++ b/arch/mips/loongson64/Kconfig
@@ -15,7 +15,7 @@ config LEMOTE_FULOONG2E
 	select DMA_NONCOHERENT
 	select BOOT_ELF32
 	select BOARD_SCACHE
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select I8259
 	select ISA
 	select IRQ_MIPS_CPU
@@ -46,7 +46,7 @@ config LEMOTE_MACH2F
 	select DMA_NONCOHERENT
 	select GENERIC_ISA_DMA_SUPPORT_BROKEN
 	select HAVE_CLK
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select I8259
 	select IRQ_MIPS_CPU
 	select ISA
@@ -74,7 +74,7 @@ config LOONGSON_MACH3X
 	select CSRC_R4K
 	select CEVT_R4K
 	select CPU_HAS_WB
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select ISA
 	select HT_PCI
 	select I8259
diff --git a/arch/mips/pmcs-msp71xx/Kconfig b/arch/mips/pmcs-msp71xx/Kconfig
index d319bc0c3df6..b185b7620c97 100644
--- a/arch/mips/pmcs-msp71xx/Kconfig
+++ b/arch/mips/pmcs-msp71xx/Kconfig
@@ -6,25 +6,25 @@ choice
 config PMC_MSP4200_EVAL
 	bool "PMC-Sierra MSP4200 Eval Board"
 	select IRQ_MSP_SLP
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select MIPS_L1_CACHE_SHIFT_4
 
 config PMC_MSP4200_GW
 	bool "PMC-Sierra MSP4200 VoIP Gateway"
 	select IRQ_MSP_SLP
-	select HW_HAS_PCI
+	select HAVE_PCI
 
 config PMC_MSP7120_EVAL
 	bool "PMC-Sierra MSP7120 Eval Board"
 	select SYS_SUPPORTS_MULTITHREADING
 	select IRQ_MSP_CIC
-	select HW_HAS_PCI
+	select HAVE_PCI
 
 config PMC_MSP7120_GW
 	bool "PMC-Sierra MSP7120 Residential Gateway"
 	select SYS_SUPPORTS_MULTITHREADING
 	select IRQ_MSP_CIC
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select MSP_HAS_USB
 	select MSP_ETH
 
@@ -32,7 +32,7 @@ config PMC_MSP7120_FPGA
 	bool "PMC-Sierra MSP7120 FPGA"
 	select SYS_SUPPORTS_MULTITHREADING
 	select IRQ_MSP_CIC
-	select HW_HAS_PCI
+	select HAVE_PCI
 
 endchoice
 
diff --git a/arch/mips/ralink/Kconfig b/arch/mips/ralink/Kconfig
index 1f9cb0e3c79a..4c8006b4a5f7 100644
--- a/arch/mips/ralink/Kconfig
+++ b/arch/mips/ralink/Kconfig
@@ -27,18 +27,18 @@ choice
 	config SOC_RT288X
 		bool "RT288x"
 		select MIPS_L1_CACHE_SHIFT_4
-		select HW_HAS_PCI
+		select HAVE_PCI
 
 	config SOC_RT305X
 		bool "RT305x"
 
 	config SOC_RT3883
 		bool "RT3883"
-		select HW_HAS_PCI
+		select HAVE_PCI
 
 	config SOC_MT7620
 		bool "MT7620/8"
-		select HW_HAS_PCI
+		select HAVE_PCI
 
 	config SOC_MT7621
 		bool "MT7621"
@@ -50,7 +50,7 @@ choice
 		select MIPS_GIC
 		select COMMON_CLK
 		select CLKSRC_MIPS_GIC
-		select HW_HAS_PCI
+		select HAVE_PCI
 endchoice
 
 choice
diff --git a/arch/mips/sibyte/Kconfig b/arch/mips/sibyte/Kconfig
index 7ec278d72096..470d46183677 100644
--- a/arch/mips/sibyte/Kconfig
+++ b/arch/mips/sibyte/Kconfig
@@ -3,7 +3,7 @@ config SIBYTE_SB1250
 	bool
 	select CEVT_SB1250
 	select CSRC_SB1250
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select IRQ_MIPS_CPU
 	select SIBYTE_ENABLE_LDT_IF_PCI
 	select SIBYTE_HAS_ZBUS_PROFILING
@@ -23,7 +23,7 @@ config SIBYTE_BCM1125
 	bool
 	select CEVT_SB1250
 	select CSRC_SB1250
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select IRQ_MIPS_CPU
 	select SIBYTE_BCM112X
 	select SIBYTE_HAS_ZBUS_PROFILING
@@ -33,7 +33,7 @@ config SIBYTE_BCM1125H
 	bool
 	select CEVT_SB1250
 	select CSRC_SB1250
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select IRQ_MIPS_CPU
 	select SIBYTE_BCM112X
 	select SIBYTE_ENABLE_LDT_IF_PCI
@@ -52,7 +52,7 @@ config SIBYTE_BCM1x80
 	bool
 	select CEVT_BCM1480
 	select CSRC_BCM1480
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select IRQ_MIPS_CPU
 	select SIBYTE_HAS_ZBUS_PROFILING
 	select SIBYTE_SB1xxx_SOC
@@ -62,7 +62,7 @@ config SIBYTE_BCM1x55
 	bool
 	select CEVT_BCM1480
 	select CSRC_BCM1480
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select IRQ_MIPS_CPU
 	select SIBYTE_SB1xxx_SOC
 	select SIBYTE_HAS_ZBUS_PROFILING
diff --git a/arch/mips/txx9/Kconfig b/arch/mips/txx9/Kconfig
index d2509c93f0ee..9a22a182b7a4 100644
--- a/arch/mips/txx9/Kconfig
+++ b/arch/mips/txx9/Kconfig
@@ -59,7 +59,7 @@ config SOC_TX3927
 	bool
 	select CEVT_TXX9
 	select HAS_TXX9_SERIAL
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select IRQ_TXX9
 	select GPIO_TXX9
 
@@ -67,7 +67,7 @@ config SOC_TX4927
 	bool
 	select CEVT_TXX9
 	select HAS_TXX9_SERIAL
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select IRQ_TXX9
 	select PCI_TX4927
 	select GPIO_TXX9
@@ -77,7 +77,7 @@ config SOC_TX4938
 	bool
 	select CEVT_TXX9
 	select HAS_TXX9_SERIAL
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select IRQ_TXX9
 	select PCI_TX4927
 	select GPIO_TXX9
@@ -87,7 +87,7 @@ config SOC_TX4939
 	bool
 	select CEVT_TXX9
 	select HAS_TXX9_SERIAL
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select PCI_TX4927
 	select HAS_TXX9_ACLC
 
diff --git a/arch/mips/vr41xx/Kconfig b/arch/mips/vr41xx/Kconfig
index 992c988b83b0..e0b651db371d 100644
--- a/arch/mips/vr41xx/Kconfig
+++ b/arch/mips/vr41xx/Kconfig
@@ -30,7 +30,7 @@ config TANBAC_TB022X
 	select CSRC_R4K
 	select DMA_NONCOHERENT
 	select IRQ_MIPS_CPU
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	help
@@ -46,7 +46,7 @@ config VICTOR_MPC30X
 	select CSRC_R4K
 	select DMA_NONCOHERENT
 	select IRQ_MIPS_CPU
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select PCI_VR41XX
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select SYS_SUPPORTS_LITTLE_ENDIAN
@@ -57,7 +57,7 @@ config ZAO_CAPCELLA
 	select CSRC_R4K
 	select DMA_NONCOHERENT
 	select IRQ_MIPS_CPU
-	select HW_HAS_PCI
+	select HAVE_PCI
 	select PCI_VR41XX
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select SYS_SUPPORTS_LITTLE_ENDIAN
@@ -99,6 +99,6 @@ endchoice
 
 config PCI_VR41XX
 	bool "Add PCI control unit support of NEC VR4100 series"
-	depends on MACH_VR41XX && HW_HAS_PCI
+	depends on MACH_VR41XX && HAVE_PCI
 	default y
 	select PCI
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 8e6d83f79e72..b2b08ad9f411 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -19,6 +19,7 @@ config PARISC
 	select NO_BOOTMEM
 	select BUG
 	select BUILDTIME_EXTABLE_SORT
+	select HAVE_PCI
 	select HAVE_PERF_EVENTS
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_GZIP
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index d4e97469a5f0..086d78c7c2c8 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -168,6 +168,7 @@ config PPC
 	select GENERIC_CPU_VULNERABILITIES	if PPC_BARRIER_NOSPEC
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
+	select GENERIC_PCI_IOMAP		if PCI
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
@@ -190,6 +191,11 @@ config PPC
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACER
+	# Platforms that what PCI turned unconditionally just do select PCI
+	# in their config node, otherwise allow the user to enable it.
+	# This means we can enable PCI even on platforms that don't support
+	# it, which is harmless except for wasted memory.
+	select HAVE_PCI
 	select HAVE_GCC_PLUGINS			if GCC_VERSION >= 50200   # plugin support on gcc <= 5.1 is buggy on PPC
 	select HAVE_GENERIC_GUP
 	select HAVE_HW_BREAKPOINT		if PERF_EVENTS && (PPC_BOOK3S || PPC_8xx)
@@ -941,23 +947,6 @@ config FSL_GTM
 	help
 	  Freescale General-purpose Timers support
 
-# Platforms that what PCI turned unconditionally just do select PCI
-# in their config node.  Platforms that want to choose at config
-# time should select PPC_PCI_CHOICE
-config PPC_PCI_CHOICE
-	bool
-
-config PCI
-	bool "PCI support" if PPC_PCI_CHOICE
-	default y if !40x && !CPM2 && !PPC_8xx && !PPC_83xx \
-		&& !PPC_85xx && !PPC_86xx && !GAMECUBE_COMMON
-	select GENERIC_PCI_IOMAP
-	help
-	  Find out whether your system includes a PCI bus. PCI is the name of
-	  a bus system, i.e. the way the CPU talks to the other stuff inside
-	  your box.  If you say Y here, the kernel will include drivers and
-	  infrastructure code to support PCI bus devices.
-
 config PCI_DOMAINS
 	def_bool PCI
 
@@ -970,8 +959,6 @@ config PCI_8260
 	select PPC_INDIRECT_PCI
 	default y
 
-source "drivers/pci/Kconfig"
-
 source "drivers/pcmcia/Kconfig"
 
 config HAS_RAPIDIO
diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index 70856a213663..9c6c77984ac3 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -272,7 +272,6 @@ config XILINX_VIRTEX440_GENERIC_BOARD
 config XILINX_ML510
 	bool "Xilinx ML510 extra support"
 	depends on XILINX_VIRTEX440_GENERIC_BOARD
-	select PPC_PCI_CHOICE
 	select XILINX_PCI if PCI
 	select PPC_INDIRECT_PCI if PCI
 	select PPC_I8259 if PCI
diff --git a/arch/powerpc/platforms/512x/Kconfig b/arch/powerpc/platforms/512x/Kconfig
index b59eab6cbb1b..3639a2a89eb4 100644
--- a/arch/powerpc/platforms/512x/Kconfig
+++ b/arch/powerpc/platforms/512x/Kconfig
@@ -5,7 +5,6 @@ config PPC_MPC512x
 	select COMMON_CLK
 	select FSL_SOC
 	select IPIC
-	select PPC_PCI_CHOICE
 	select FSL_PCI if PCI
 	select USB_EHCI_BIG_ENDIAN_MMIO if USB_EHCI_HCD
 	select USB_EHCI_BIG_ENDIAN_DESC if USB_EHCI_HCD
diff --git a/arch/powerpc/platforms/52xx/Kconfig b/arch/powerpc/platforms/52xx/Kconfig
index 55a587070342..121235b25305 100644
--- a/arch/powerpc/platforms/52xx/Kconfig
+++ b/arch/powerpc/platforms/52xx/Kconfig
@@ -3,7 +3,6 @@ config PPC_MPC52xx
 	bool "52xx-based boards"
 	depends on 6xx
 	select COMMON_CLK
-	select PPC_PCI_CHOICE
 
 config PPC_MPC5200_SIMPLE
 	bool "Generic support for simple MPC5200 based boards"
diff --git a/arch/powerpc/platforms/83xx/Kconfig b/arch/powerpc/platforms/83xx/Kconfig
index 071f53b0c0a0..8f65ec7feb06 100644
--- a/arch/powerpc/platforms/83xx/Kconfig
+++ b/arch/powerpc/platforms/83xx/Kconfig
@@ -3,7 +3,6 @@ menuconfig PPC_83xx
 	bool "83xx-based boards"
 	depends on 6xx
 	select PPC_UDBG_16550
-	select PPC_PCI_CHOICE
 	select FSL_PCI if PCI
 	select FSL_SOC
 	select IPIC
diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
index 68920d42b4bc..20867a23f3f2 100644
--- a/arch/powerpc/platforms/85xx/Kconfig
+++ b/arch/powerpc/platforms/85xx/Kconfig
@@ -5,7 +5,6 @@ menuconfig FSL_SOC_BOOKE
 	select FSL_SOC
 	select PPC_UDBG_16550
 	select MPIC
-	select PPC_PCI_CHOICE
 	select FSL_PCI if PCI
 	select SERIAL_8250_EXTENDED if SERIAL_8250
 	select SERIAL_8250_SHARE_IRQ if SERIAL_8250
diff --git a/arch/powerpc/platforms/86xx/Kconfig b/arch/powerpc/platforms/86xx/Kconfig
index bcd179d3ed92..87220554dd6f 100644
--- a/arch/powerpc/platforms/86xx/Kconfig
+++ b/arch/powerpc/platforms/86xx/Kconfig
@@ -70,7 +70,6 @@ endif
 
 config MPC8641
 	bool
-	select PPC_PCI_CHOICE
 	select FSL_PCI if PCI
 	select PPC_UDBG_16550
 	select MPIC
@@ -79,7 +78,6 @@ config MPC8641
 
 config MPC8610
 	bool
-	select PPC_PCI_CHOICE
 	select FSL_PCI if PCI
 	select PPC_UDBG_16550
 	select MPIC
diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index 14ef17e10ec9..2d28af3681e8 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -285,7 +285,6 @@ config CPM2
 	bool "Enable support for the CPM2 (Communications Processor Module)"
 	depends on (FSL_SOC_BOOKE && PPC32) || 8260
 	select CPM
-	select PPC_PCI_CHOICE
 	select GPIOLIB
 	help
 	  The CPM2 (Communications Processor Module) is a coprocessor on
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 6c6a7c72cae4..c89500c0747a 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -40,14 +40,12 @@ config 40x
 	select PPC_DCR_NATIVE
 	select PPC_UDBG_16550
 	select 4xx_SOC
-	select PPC_PCI_CHOICE
 
 config 44x
 	bool "AMCC 44x, 46x or 47x"
 	select PPC_DCR_NATIVE
 	select PPC_UDBG_16550
 	select 4xx_SOC
-	select PPC_PCI_CHOICE
 	select PHYS_64BIT
 
 config E200
diff --git a/arch/powerpc/platforms/ps3/Kconfig b/arch/powerpc/platforms/ps3/Kconfig
index 6f7525555b19..a68c14221523 100644
--- a/arch/powerpc/platforms/ps3/Kconfig
+++ b/arch/powerpc/platforms/ps3/Kconfig
@@ -6,7 +6,6 @@ config PPC_PS3
 	select USB_OHCI_LITTLE_ENDIAN
 	select USB_OHCI_BIG_ENDIAN_MMIO
 	select USB_EHCI_BIG_ENDIAN_MMIO
-	select PPC_PCI_CHOICE
 	help
 	  This option enables support for the Sony PS3 game console
 	  and other platforms using the PS3 hypervisor.  Enabling this
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index a344980287a5..071952cd4cae 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -39,8 +39,10 @@ config RISCV
 	select SPARSE_IRQ
 	select SYSCTL_EXCEPTION_TRACE
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_PCI
 	select MODULES_USE_ELF_RELA if MODULES
 	select THREAD_INFO_IN_TASK
+	select PCI_MSI if PCI
 	select RISCV_TIMER
 	select GENERIC_IRQ_MULTI_HANDLER
 	select ARCH_HAS_PTE_SPECIAL
@@ -216,28 +218,12 @@ source "kernel/Kconfig.hz"
 
 endmenu
 
-menu "Bus support"
-
-config PCI
-	bool "PCI support"
-	select PCI_MSI
-	help
-	  This feature enables support for PCI bus system. If you say Y
-	  here, the kernel will include drivers and infrastructure code
-	  to support PCI bus devices.
-
-	  If you don't know what to do here, say Y.
-
 config PCI_DOMAINS
 	def_bool PCI
 
 config PCI_DOMAINS_GENERIC
 	def_bool PCI
 
-source "drivers/pci/Kconfig"
-
-endmenu
-
 menu "Power management options"
 
 source kernel/power/Kconfig
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 9a9c7a6fe925..1f56c96bb1c9 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -160,15 +160,21 @@ config S390
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NOP_MCOUNT
 	select HAVE_OPROFILE
+	select HAVE_PCI
 	select HAVE_PERF_EVENTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RSEQ
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_VIRT_CPU_ACCOUNTING
+	select IOMMU_HELPER		if PCI
+	select IOMMU_SUPPORT		if PCI
 	select MODULES_USE_ELF_RELA
+	select NEED_DMA_MAP_STATE	if PCI
+	select NEED_SG_DMA_LENGTH	if PCI
 	select NO_BOOTMEM
 	select OLD_SIGACTION
 	select OLD_SIGSUSPEND3
+	select PCI_MSI			if PCI
 	select SPARSE_IRQ
 	select SYSCTL_EXCEPTION_TRACE
 	select THREAD_INFO_IN_TASK
@@ -698,17 +704,6 @@ config QDIO
 
 	  If unsure, say Y.
 
-menuconfig PCI
-	bool "PCI support"
-	select PCI_MSI
-	select IOMMU_HELPER
-	select IOMMU_SUPPORT
-	select NEED_DMA_MAP_STATE
-	select NEED_SG_DMA_LENGTH
-
-	help
-	  Enable PCI support.
-
 if PCI
 
 config PCI_NR_FUNCTIONS
@@ -719,13 +714,11 @@ config PCI_NR_FUNCTIONS
 	  This allows you to specify the maximum number of PCI functions which
 	  this kernel will support.
 
-source "drivers/pci/Kconfig"
-
-endif	# PCI
-
 config PCI_DOMAINS
 	def_bool PCI
 
+endif	# PCI
+
 config HAS_IOMEM
 	def_bool PCI
 
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 1fb7b6d72baf..2ff6855811a5 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -41,13 +41,16 @@ config SUPERH
 	select GENERIC_IDLE_POLL_SETUP
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CMOS_UPDATE if SH_SH03 || SH_DREAMCAST
+	select GENERIC_PCI_IOMAP if PCI
 	select GENERIC_SCHED_CLOCK
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select HAVE_MOD_ARCH_SPECIFIC if DWARF_UNWINDER
 	select MODULES_USE_ELF_RELA
+	select NO_GENERIC_PCI_IOPORT_MAP if PCI
 	select OLD_SIGSUSPEND
 	select OLD_SIGACTION
+	select PCI_DOMAINS if PCI
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_NMI
@@ -131,9 +134,6 @@ config SYS_SUPPORTS_SMP
 config SYS_SUPPORTS_NUMA
 	bool
 
-config SYS_SUPPORTS_PCI
-	bool
-
 config STACKTRACE_SUPPORT
 	def_bool y
 
@@ -858,22 +858,9 @@ config MAPLE
 	 Dreamcast with a serial line terminal or a remote network
 	 connection.
 
-config PCI
-	bool "PCI support"
-	depends on SYS_SUPPORTS_PCI
-	select PCI_DOMAINS
-	select GENERIC_PCI_IOMAP
-	select NO_GENERIC_PCI_IOPORT_MAP
-	help
-	  Find out whether you have a PCI motherboard. PCI is the name of a
-	  bus system, i.e. the way the CPU talks to the other stuff inside
-	  your box. If you have PCI, say Y, otherwise N.
-
 config PCI_DOMAINS
 	bool
 
-source "drivers/pci/Kconfig"
-
 source "drivers/pcmcia/Kconfig"
 
 endmenu
diff --git a/arch/sh/boards/Kconfig b/arch/sh/boards/Kconfig
index 6394b4f0a69b..b9a37057b77a 100644
--- a/arch/sh/boards/Kconfig
+++ b/arch/sh/boards/Kconfig
@@ -101,7 +101,7 @@ config SH_7751_SOLUTION_ENGINE
 config SH_7780_SOLUTION_ENGINE
 	bool "SolutionEngine7780"
 	select SOLUTION_ENGINE
-	select SYS_SUPPORTS_PCI
+	select HAVE_PCI
 	depends on CPU_SUBTYPE_SH7780
 	help
 	  Select 7780 SolutionEngine if configuring for a Renesas SH7780
@@ -129,7 +129,7 @@ config SH_HP6XX
 
 config SH_DREAMCAST
 	bool "Dreamcast"
-	select SYS_SUPPORTS_PCI
+	select HAVE_PCI
 	depends on CPU_SUBTYPE_SH7091
 	help
 	  Select Dreamcast if configuring for a SEGA Dreamcast.
@@ -139,7 +139,7 @@ config SH_SH03
 	bool "Interface CTP/PCI-SH03"
 	depends on CPU_SUBTYPE_SH7751
 	select CPU_HAS_IPR_IRQ
-	select SYS_SUPPORTS_PCI
+	select HAVE_PCI
 	help
 	  CTP/PCI-SH03 is a CPU module computer that is produced
 	  by Interface Corporation.
@@ -149,7 +149,7 @@ config SH_SECUREEDGE5410
 	bool "SecureEdge5410"
 	depends on CPU_SUBTYPE_SH7751R
 	select CPU_HAS_IPR_IRQ
-	select SYS_SUPPORTS_PCI
+	select HAVE_PCI
 	help
 	  Select SecureEdge5410 if configuring for a SnapGear SH board.
 	  This includes both the OEM SecureEdge products as well as the
@@ -158,7 +158,7 @@ config SH_SECUREEDGE5410
 config SH_RTS7751R2D
 	bool "RTS7751R2D"
 	depends on CPU_SUBTYPE_SH7751R
-	select SYS_SUPPORTS_PCI
+	select HAVE_PCI
 	select IO_TRAPPED if MMU
 	help
 	  Select RTS7751R2D if configuring for a Renesas Technology
@@ -176,7 +176,7 @@ config SH_RSK
 config SH_SDK7780
 	bool "SDK7780R3"
 	depends on CPU_SUBTYPE_SH7780
-	select SYS_SUPPORTS_PCI
+	select HAVE_PCI
 	help
 	  Select SDK7780 if configuring for a Renesas SH7780 SDK7780R3
 	  evaluation board.
@@ -184,7 +184,7 @@ config SH_SDK7780
 config SH_SDK7786
 	bool "SDK7786"
 	depends on CPU_SUBTYPE_SH7786
-	select SYS_SUPPORTS_PCI
+	select HAVE_PCI
 	select NO_IOPORT_MAP if !PCI
 	select HAVE_SRAM_POOL
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
@@ -195,7 +195,7 @@ config SH_SDK7786
 config SH_HIGHLANDER
 	bool "Highlander"
 	depends on CPU_SUBTYPE_SH7780 || CPU_SUBTYPE_SH7785
-	select SYS_SUPPORTS_PCI
+	select HAVE_PCI
 	select IO_TRAPPED if MMU
 
 config SH_SH7757LCR
@@ -207,7 +207,7 @@ config SH_SH7757LCR
 config SH_SH7785LCR
 	bool "SH7785LCR"
 	depends on CPU_SUBTYPE_SH7785
-	select SYS_SUPPORTS_PCI
+	select HAVE_PCI
 
 config SH_SH7785LCR_29BIT_PHYSMAPS
 	bool "SH7785LCR 29bit physmaps"
@@ -229,7 +229,7 @@ config SH_URQUELL
 	bool "Urquell"
 	depends on CPU_SUBTYPE_SH7786
 	select GPIOLIB
-	select SYS_SUPPORTS_PCI
+	select HAVE_PCI
 	select NO_IOPORT_MAP if !PCI
 
 config SH_MIGOR
@@ -302,7 +302,7 @@ config SH_SH4202_MICRODEV
 config SH_LANDISK
 	bool "LANDISK"
 	depends on CPU_SUBTYPE_SH7751R
-	select SYS_SUPPORTS_PCI
+	select HAVE_PCI
 	help
 	  I-O DATA DEVICE, INC. "LANDISK Series" support.
 
@@ -310,7 +310,7 @@ config SH_TITAN
 	bool "TITAN"
 	depends on CPU_SUBTYPE_SH7751R
 	select CPU_HAS_IPR_IRQ
-	select SYS_SUPPORTS_PCI
+	select HAVE_PCI
 	help
 	  Select Titan if you are configuring for a Nimble Microsystems
 	  NetEngine NP51R.
@@ -325,7 +325,7 @@ config SH_SHMIN
 config SH_LBOX_RE2
 	bool "L-BOX RE2"
 	depends on CPU_SUBTYPE_SH7751R
-	select SYS_SUPPORTS_PCI
+	select HAVE_PCI
 	help
 	  Select L-BOX RE2 if configuring for the NTT COMWARE L-BOX RE2.
 
@@ -346,7 +346,7 @@ config SH_MAGIC_PANEL_R2
 config SH_CAYMAN
 	bool "Hitachi Cayman"
 	depends on CPU_SUBTYPE_SH5_101 || CPU_SUBTYPE_SH5_103
-	select SYS_SUPPORTS_PCI
+	select HAVE_PCI
 	select ARCH_MIGHT_HAVE_PC_SERIO
 
 config SH_POLARIS
@@ -380,7 +380,7 @@ config SH_APSH4A3A
 config SH_APSH4AD0A
 	bool "AP-SH4AD-0A"
 	select SH_ALPHA_BOARD
-	select SYS_SUPPORTS_PCI
+	select HAVE_PCI
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	depends on CPU_SUBTYPE_SH7786
 	help
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index e6f2a38d2e61..fc311b8dc46b 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -21,6 +21,7 @@ config SPARC
 	select HAVE_ARCH_KGDB if !SMP || SPARC64
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_EXIT_THREAD
+	select HAVE_PCI
 	select SYSCTL_EXCEPTION_TRACE
 	select RTC_CLASS
 	select RTC_DRV_M48T59
@@ -474,18 +475,6 @@ config SUN_LDOMS
 	  Say Y here is you want to support virtual devices via
 	  Logical Domains.
 
-config PCI
-	bool "Support for PCI and PS/2 keyboard/mouse"
-	help
-	  Find out whether your system includes a PCI bus. PCI is the name of
-	  a bus system, i.e. the way the CPU talks to the other stuff inside
-	  your box.  If you say Y here, the kernel will include drivers and
-	  infrastructure code to support PCI bus devices.
-
-	  CONFIG_PCI is needed for all JavaStation's (including MrCoffee),
-	  CP-1200, JavaEngine-1, Corona, Red October, and Serengeti SGSC.
-	  All of these platforms are extremely obscure, so say N if unsure.
-
 config PCI_DOMAINS
 	def_bool PCI if SPARC64
 
@@ -520,8 +509,6 @@ config SPARC_GRPCI2
 	help
 	  Say Y here to include the GRPCI2 Host Bridge Driver.
 
-source "drivers/pci/Kconfig"
-
 source "drivers/pcmcia/Kconfig"
 
 config SUN_OPENPROMFS
diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index 6b9938919f0b..de982541a059 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -31,9 +31,6 @@ config ISA
 config SBUS
 	bool
 
-config PCI
-	bool
-
 config PCMCIA
 	bool
 
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index 60eae744d8fd..601dcad2560e 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -11,6 +11,7 @@ config UNICORE32
 	select GENERIC_ATOMIC64
 	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_LZMA
+	select HAVE_PCI
 	select VIRT_TO_BUS
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select GENERIC_FIND_FIRST_BIT
@@ -119,16 +120,6 @@ endmenu
 
 menu "Bus support"
 
-config PCI
-	bool "PCI Support"
-	help
-	  Find out whether you have a PCI motherboard. PCI is the name of a
-	  bus system, i.e. the way the CPU talks to the other stuff inside
-	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
-	  VESA. If you have PCI, say Y, otherwise N.
-
-source "drivers/pci/Kconfig"
-
 source "drivers/pcmcia/Kconfig"
 
 endmenu
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1a0be022f91d..5816e20a3ff9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -178,6 +178,7 @@ config X86
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_EVENTS_NMI
 	select HAVE_HARDLOCKUP_DETECTOR_PERF	if PERF_EVENTS && HAVE_PERF_EVENTS_NMI
+	select HAVE_PCI
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_RCU_TABLE_FREE		if PARAVIRT
@@ -2567,15 +2568,6 @@ endmenu
 
 menu "Bus options (PCI etc.)"
 
-config PCI
-	bool "PCI support"
-	default y
-	---help---
-	  Find out whether you have a PCI motherboard. PCI is the name of a
-	  bus system, i.e. the way the CPU talks to the other stuff inside
-	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
-	  VESA. If you have PCI, say Y, otherwise N.
-
 choice
 	prompt "PCI access mode"
 	depends on X86_32 && PCI
@@ -2658,8 +2650,6 @@ config PCI_CNB20LE_QUIRK
 
 	  You should say N unless you know you need this.
 
-source "drivers/pci/Kconfig"
-
 config ISA_BUS
 	bool "ISA bus support on modern systems" if EXPERT
 	help
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 0eb9f92f3717..f08a74eeb1fe 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -69,6 +69,7 @@ CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
 CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
 CONFIG_CPU_FREQ_GOV_ONDEMAND=y
 CONFIG_X86_ACPI_CPUFREQ=y
+CONFIG_PCI=y
 CONFIG_PCIEPORTBUS=y
 CONFIG_PCI_MSI=y
 CONFIG_PCCARD=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index e32fc1f274d8..d053ae4a8098 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -67,6 +67,7 @@ CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
 CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
 CONFIG_CPU_FREQ_GOV_ONDEMAND=y
 CONFIG_X86_ACPI_CPUFREQ=y
+CONFIG_PCI=y
 CONFIG_PCI_MMCONFIG=y
 CONFIG_PCIEPORTBUS=y
 CONFIG_PCCARD=y
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index b9ad83a0ee5d..f057c16a48a5 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -30,6 +30,7 @@ config XTENSA
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_MEMBLOCK
 	select HAVE_OPROFILE
+	select HAVE_PCI
 	select HAVE_PERF_EVENTS
 	select HAVE_STACKPROTECTOR
 	select IRQ_DOMAIN
@@ -384,21 +385,6 @@ config XTENSA_CALIBRATE_CCOUNT
 config SERIAL_CONSOLE
 	def_bool n
 
-menu "Bus options"
-
-config PCI
-	bool "PCI support"
-	default y
-	help
-	  Find out whether you have a PCI motherboard. PCI is the name of a
-	  bus system, i.e. the way the CPU talks to the other stuff inside
-	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
-	  VESA. If you have PCI, say Y, otherwise N.
-
-source "drivers/pci/Kconfig"
-
-endmenu
-
 menu "Platform options"
 
 choice
diff --git a/arch/xtensa/configs/common_defconfig b/arch/xtensa/configs/common_defconfig
index 4bcc76b02109..fa9389869154 100644
--- a/arch/xtensa/configs/common_defconfig
+++ b/arch/xtensa/configs/common_defconfig
@@ -1,3 +1,4 @@
+CONFIG_PCI=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
diff --git a/arch/xtensa/configs/iss_defconfig b/arch/xtensa/configs/iss_defconfig
index 4bb5b76d9524..68bf923aec8f 100644
--- a/arch/xtensa/configs/iss_defconfig
+++ b/arch/xtensa/configs/iss_defconfig
@@ -4,7 +4,6 @@ CONFIG_EXPERT=y
 CONFIG_SYSCTL_SYSCALL=y
 # CONFIG_IOSCHED_DEADLINE is not set
 # CONFIG_IOSCHED_CFQ is not set
-# CONFIG_PCI is not set
 CONFIG_CMDLINE_BOOL=y
 CONFIG_CMDLINE="console=ttyS0,38400 eth0=tuntap,,tap0 ip=192.168.168.5:192.168.168.1 root=nfs nfsroot=192.168.168.1:/opt/montavista/pro/devkit/xtensa/linux_be/target memmap=128M@0"
 # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
diff --git a/drivers/Kconfig b/drivers/Kconfig
index ab4d43923c4d..059573823387 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -1,7 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0
 menu "Device Drivers"
 
+# Keep I/O buses first
+
 source "drivers/amba/Kconfig"
+source "drivers/pci/Kconfig"
+
 
 source "drivers/base/Kconfig"
 
diff --git a/drivers/parisc/Kconfig b/drivers/parisc/Kconfig
index 5a48b5606110..5bbfea1a019c 100644
--- a/drivers/parisc/Kconfig
+++ b/drivers/parisc/Kconfig
@@ -63,17 +63,6 @@ config ISA
 	  If you want to plug an ISA card into your EISA bus, say Y here.
 	  Most people should say N.
 
-config PCI
-	bool "PCI support"
-	help
-	  All recent HP machines have PCI slots, and you should say Y here
-	  if you have a recent machine.  If you are convinced you do not have
-	  PCI slots in your machine (eg a 712), then you may say "N" here.
-	  Beware that some GSC cards have a Dino onboard and PCI inside them,
-	  so it may be safest to say "Y" anyway.
-
-source "drivers/pci/Kconfig"
-
 config GSC_DINO
 	bool "GSCtoPCI/Dino PCI support"
 	depends on PCI && GSC
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 56ff8f6d31fc..6ec796c5931f 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -3,6 +3,18 @@
 # PCI configuration
 #
 
+config HAVE_PCI
+	bool
+
+menuconfig PCI
+	bool "PCI support"
+	depends on HAVE_PCI
+
+	help
+	  This option enables support for the PCI local bus, including
+	  support for PCI-X and the fundations for PCI Express support.
+	  Say 'Y' here unless you know what you are doing.
+
 source "drivers/pci/pcie/Kconfig"
 
 config PCI_MSI
diff --git a/drivers/pci/endpoint/Kconfig b/drivers/pci/endpoint/Kconfig
index d1e7e4199432..17bbdc9bbde0 100644
--- a/drivers/pci/endpoint/Kconfig
+++ b/drivers/pci/endpoint/Kconfig
@@ -7,7 +7,7 @@ menu "PCI Endpoint"
 
 config PCI_ENDPOINT
 	bool "PCI Endpoint Support"
-	depends on HAS_DMA
+	depends on HAVE_PCI
 	help
 	   Enable this configuration option to support configurable PCI
 	   endpoint. This should be enabled if the platform has a PCI
-- 
2.19.1
