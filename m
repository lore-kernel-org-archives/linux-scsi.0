From: William Breathitt Gray <vilhelm.gray@gmail.com>
Subject: [PATCH 4/4] isa: Remove the ISA_BUS Kconfig option
Date: Mon, 11 Apr 2016 09:25:54 -0400
Message-ID: <e39b277cbe0c6fcf4d7ea834e14c11ca40e7dff3.1460379702.git.vilhelm.gray@gmail.com>
References: <cover.1460379702.git.vilhelm.gray@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1460379702.git.vilhelm.gray@gmail.com>
In-Reply-To: <cover.1460379702.git.vilhelm.gray@gmail.com>
References: <cover.1460379702.git.vilhelm.gray@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org, William Breathitt Gray <vilhelm.gray@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The introduction of the ISA_BUS option blocks the compilation of ISA
drivers on non-x86 platforms. The ISA_BUS configuration option should
not be necessary if the X86_32 dependency can be decoupled from the ISA
configuration option. This patch both removes the ISA_BUS configuration
option entirely and removes the X86_32 dependency from the ISA
configuration option.

Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
---
 arch/x86/Kconfig      | 10 ++--------
 drivers/base/Makefile |  2 +-
 include/linux/isa.h   |  2 +-
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a597798..280e5eb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2472,16 +2472,8 @@ config ISA_DMA_API
 	  Enables ISA-style DMA support for devices requiring such controllers.
 	  If unsure, say Y.
 
-config ISA_BUS
-	bool "ISA bus support"
-	help
-	  Enables ISA bus support for devices requiring such controllers.
-
-if X86_32
-
 config ISA
 	bool "ISA support"
-	depends on ISA_BUS
 	---help---
 	  Find out whether you have ISA slots on your motherboard.  ISA is the
 	  name of a bus system, i.e. the way the CPU talks to the other stuff
@@ -2489,6 +2481,8 @@ config ISA
 	  (MCA) or VESA.  ISA is an older system, now being displaced by PCI;
 	  newer boards don't support it.  If you have ISA, say Y, otherwise N.
 
+if X86_32
+
 config EISA
 	bool "EISA support"
 	depends on ISA
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 4ebfb81..6b2a84e 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
-obj-$(CONFIG_ISA_BUS)	+= isa.o
+obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
 obj-$(CONFIG_MEMORY_HOTPLUG_SPARSE) += memory.o
diff --git a/include/linux/isa.h b/include/linux/isa.h
index 2a02862..b0270e3 100644
--- a/include/linux/isa.h
+++ b/include/linux/isa.h
@@ -22,7 +22,7 @@ struct isa_driver {
 
 #define to_isa_driver(x) container_of((x), struct isa_driver, driver)
 
-#ifdef CONFIG_ISA_BUS
+#ifdef CONFIG_ISA
 int isa_register_driver(struct isa_driver *, unsigned int);
 void isa_unregister_driver(struct isa_driver *);
 #else
-- 
2.7.3
