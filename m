From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/8] rapidio: consolidate RAPIDIO config entry in drivers/rapidio
Date: Sat, 13 Oct 2018 17:10:14 +0200
Message-ID: <20181013151016.31674-7-hch@lst.de>
References: <20181013151016.31674-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181013151016.31674-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Matt Porter <mporter@kernel.crashing.org>, Alexandre Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-kbuild@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

There is no good reason to duplicate the RAPIDIO menu in various
architectures.  Instead provide a selectable HAS_RAPIDIO symbol
that indicates native availability of RAPIDIO support and the handle
the rest in drivers/pci.  This also means we now provide support
for PCI(e) to Rapidio bridges for every architecture instead of a
limited subset.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/mips/Kconfig       | 13 -------------
 arch/powerpc/Kconfig    | 13 -------------
 arch/x86/Kconfig        | 10 ----------
 drivers/Kconfig         |  1 +
 drivers/rapidio/Kconfig | 11 +++++++++++
 5 files changed, 12 insertions(+), 36 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index fc74fd685e6a..70a9e09329bb 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -3090,19 +3090,6 @@ config ZONE_DMA
 config ZONE_DMA32
 	bool
 
-config HAS_RAPIDIO
-	bool
-	default n
-
-config RAPIDIO
-	tristate "RapidIO support"
-	depends on HAS_RAPIDIO || PCI
-	help
-	  If you say Y here, the kernel will include drivers and
-	  infrastructure code to support RapidIO interconnect devices.
-
-source "drivers/rapidio/Kconfig"
-
 endmenu
 
 config TRAD_SIGNALS
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 8959ce594b08..b1c3a47f1f30 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -971,17 +971,6 @@ config PCI_8260
 	select PPC_INDIRECT_PCI
 	default y
 
-config HAS_RAPIDIO
-	bool
-	default n
-
-config RAPIDIO
-	tristate "RapidIO support"
-	depends on HAS_RAPIDIO || PCI
-	help
-	  If you say Y here, the kernel will include drivers and
-	  infrastructure code to support RapidIO interconnect devices.
-
 config FSL_RIO
 	bool "Freescale Embedded SRIO Controller support"
 	depends on RAPIDIO = y && HAS_RAPIDIO
@@ -990,8 +979,6 @@ config FSL_RIO
 	  Include support for RapidIO controller on Freescale embedded
 	  processors (MPC8548, MPC8641, etc).
 
-source "drivers/rapidio/Kconfig"
-
 endmenu
 
 config NONSTATIC_KERNEL
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dc48280bdac9..f731ad1a043a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2810,16 +2810,6 @@ config AMD_NB
 	def_bool y
 	depends on CPU_SUP_AMD && PCI
 
-config RAPIDIO
-	tristate "RapidIO support"
-	depends on PCI
-	default n
-	help
-	  If enabled this option will include drivers and the core
-	  infrastructure code to support RapidIO interconnect devices.
-
-source "drivers/rapidio/Kconfig"
-
 config X86_SYSFB
 	bool "Mark VGA/VBE/EFI FB as generic system framebuffer"
 	help
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 58ee88c36cf5..065d308fcb00 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -6,6 +6,7 @@ menu "Device Drivers"
 source "drivers/amba/Kconfig"
 source "drivers/pci/Kconfig"
 source "drivers/pcmcia/Kconfig"
+source "drivers/rapidio/Kconfig"
 
 
 source "drivers/base/Kconfig"
diff --git a/drivers/rapidio/Kconfig b/drivers/rapidio/Kconfig
index d6d2f20c4597..102f4989c11a 100644
--- a/drivers/rapidio/Kconfig
+++ b/drivers/rapidio/Kconfig
@@ -1,6 +1,17 @@
 #
 # RapidIO configuration
 #
+
+config HAS_RAPIDIO
+	bool
+
+menuconfig RAPIDIO
+	tristate "RapidIO support"
+	depends on HAS_RAPIDIO || PCI
+	help
+	  If you say Y here, the kernel will include drivers and
+	  infrastructure code to support RapidIO interconnect devices.
+
 source "drivers/rapidio/devices/Kconfig"
 
 config RAPIDIO_DISC_TIMEOUT
-- 
2.19.1
