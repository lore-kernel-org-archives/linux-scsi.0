Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86177C32753
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3444520840
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:26:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="izxlLgHW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfHMH0s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:26:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55780 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbfHMH0s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 03:26:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oSfjRWDzkzfLybr/Rjqun0GoYseo5Se6OrzuwUEf3M8=; b=izxlLgHWVyCgkExDcBKWVrYOkm
        fBqGisnlyvjIfJcHZcpJxWyP/TQICvGGqxESh0W+WXD5hxIK1SMx0xmG88rH2QbCqCVQGer87m560
        AguVyGBUzU49HdWi1lKNNjpbyzOZt+7YSsmk3M7gCNY9NvuDFksCt98Nw+lfGIFHEx/6WFeljXw+N
        Sb3rK2fx5wxU2ByFeXPJIEpIvpnhAHbrrtXWc21cXascXYd63Pfzs8Y0RarT8R1Wv2rl//Zr8Fcrk
        BGcjYT9+yHIRXhhmtOpdpbxMy454vG1d+oeUKfwxAROVbqIo2R5uiw6u8BMZrk+X8aZ9gEE37JCS6
        P8AW/1Dw==;
Received: from [2001:4bb8:180:1ec3:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxRCe-00077p-AG; Tue, 13 Aug 2019 07:26:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <sivanich@hpe.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 26/28] ia64: remove support for machvecs
Date:   Tue, 13 Aug 2019 09:25:12 +0200
Message-Id: <20190813072514.23299-27-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813072514.23299-1-hch@lst.de>
References: <20190813072514.23299-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The only thing remaining of the machvecs is a few checks if we are
running on an SGI UV system.  Replace those with the existing
is_uv_system() check that has been rewritten to simply check the
OEM ID directly.

That leaves us with a generic kernel that is as fast as the previous
DIG/ZX1/UV kernels, but can support all hardware.  Support for UV
and the HP SBA IOMMU is now optional based on new config options.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/ia64/Kconfig                     | 72 ++++++++-------------------
 arch/ia64/Kconfig.debug               |  2 +-
 arch/ia64/Makefile                    |  7 +--
 arch/ia64/configs/bigsur_defconfig    |  1 -
 arch/ia64/configs/tiger_defconfig     |  1 -
 arch/ia64/configs/zx1_defconfig       |  1 -
 arch/ia64/dig/Makefile                | 10 ----
 arch/ia64/dig/machvec.c               |  3 --
 arch/ia64/dig/setup.c                 | 32 ------------
 arch/ia64/hp/common/Makefile          |  2 +-
 arch/ia64/hp/zx1/Makefile             |  9 ----
 arch/ia64/hp/zx1/hpzx1_machvec.c      |  3 --
 arch/ia64/include/asm/acpi.h          | 16 ------
 arch/ia64/include/asm/hw_irq.h        |  5 +-
 arch/ia64/include/asm/io.h            |  1 -
 arch/ia64/include/asm/iommu.h         |  1 -
 arch/ia64/include/asm/machvec.h       | 69 -------------------------
 arch/ia64/include/asm/machvec_dig.h   | 17 -------
 arch/ia64/include/asm/machvec_hpzx1.h | 17 -------
 arch/ia64/include/asm/machvec_init.h  | 11 ----
 arch/ia64/include/asm/machvec_uv.h    | 26 ----------
 arch/ia64/include/asm/mmzone.h        | 13 ++---
 arch/ia64/include/asm/processor.h     |  2 -
 arch/ia64/include/asm/tlb.h           |  1 -
 arch/ia64/include/asm/uv/uv.h         | 23 ++++++++-
 arch/ia64/kernel/Makefile             |  4 +-
 arch/ia64/kernel/acpi.c               | 55 --------------------
 arch/ia64/kernel/iosapic.c            |  1 -
 arch/ia64/kernel/irq_ia64.c           |  5 +-
 arch/ia64/kernel/machvec.c            | 70 --------------------------
 arch/ia64/kernel/mca.c                |  1 -
 arch/ia64/kernel/mca_drv.c            |  1 -
 arch/ia64/kernel/pci-dma.c            |  1 -
 arch/ia64/kernel/setup.c              | 24 ++++-----
 arch/ia64/kernel/smp.c                |  1 -
 arch/ia64/kernel/smpboot.c            |  1 -
 arch/ia64/kernel/time.c               |  1 -
 arch/ia64/kernel/vmlinux.lds.S        | 10 ----
 arch/ia64/mm/init.c                   |  1 -
 arch/ia64/pci/fixup.c                 |  6 +--
 arch/ia64/pci/pci.c                   |  1 -
 arch/ia64/uv/kernel/Makefile          |  1 -
 arch/ia64/uv/kernel/machvec.c         | 11 ----
 arch/ia64/uv/kernel/setup.c           | 34 +++++++++++++
 drivers/acpi/Kconfig                  |  2 +-
 drivers/char/agp/Kconfig              |  4 +-
 drivers/iommu/Kconfig                 |  2 +-
 drivers/misc/Kconfig                  |  2 +-
 drivers/misc/sgi-xp/xp_uv.c           |  6 +--
 drivers/misc/sgi-xp/xpc_uv.c          | 14 +++---
 50 files changed, 116 insertions(+), 488 deletions(-)
 delete mode 100644 arch/ia64/dig/Makefile
 delete mode 100644 arch/ia64/dig/machvec.c
 delete mode 100644 arch/ia64/dig/setup.c
 delete mode 100644 arch/ia64/hp/zx1/Makefile
 delete mode 100644 arch/ia64/hp/zx1/hpzx1_machvec.c
 delete mode 100644 arch/ia64/include/asm/machvec.h
 delete mode 100644 arch/ia64/include/asm/machvec_dig.h
 delete mode 100644 arch/ia64/include/asm/machvec_hpzx1.h
 delete mode 100644 arch/ia64/include/asm/machvec_init.h
 delete mode 100644 arch/ia64/include/asm/machvec_uv.h
 delete mode 100644 arch/ia64/kernel/machvec.c
 delete mode 100644 arch/ia64/uv/kernel/machvec.c

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 9a8c7ec60cfc..13d49c232556 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -11,11 +11,13 @@ config IA64
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select ACPI
+	select ACPI_NUMA if NUMA
 	select ARCH_SUPPORTS_ACPI
 	select ACPI_SYSTEM_POWER_STATES_SUPPORT if ACPI
 	select ARCH_MIGHT_HAVE_ACPI_PDC if ACPI
 	select FORCE_PCI
 	select PCI_DOMAINS if PCI
+	select PCI_MSI
 	select PCI_SYSCALL if PCI
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_EXIT_THREAD
@@ -30,8 +32,8 @@ config IA64
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_VIRT_CPU_ACCOUNTING
-	select ARCH_HAS_DMA_COHERENT_TO_PFN if SWIOTLB
-	select ARCH_HAS_SYNC_DMA_FOR_CPU if SWIOTLB
+	select ARCH_HAS_DMA_COHERENT_TO_PFN
+	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
@@ -45,6 +47,7 @@ config IA64
 	select ARCH_THREAD_STACK_ALLOCATOR
 	select ARCH_CLOCKSOURCE_DATA
 	select GENERIC_TIME_VSYSCALL
+	select SWIOTLB
 	select SYSCTL_ARCH_UNALIGN_NO_WARN
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
@@ -52,6 +55,7 @@ config IA64
 	select HAVE_ARCH_AUDITSYSCALL
 	select NEED_DMA_MAP_STATE
 	select NEED_SG_DMA_LENGTH
+	select NUMA if !FLATMEM
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
@@ -119,53 +123,6 @@ config AUDIT_ARCH
 	bool
 	default y
 
-choice
-	prompt "System type"
-	default IA64_GENERIC
-
-config IA64_GENERIC
-	bool "generic"
-	select NUMA
-	select ACPI_NUMA
-	select SWIOTLB
-	select PCI_MSI
-	help
-	  This selects the system type of your hardware.  A "generic" kernel
-	  will run on any supported IA-64 system.  However, if you configure
-	  a kernel for your specific system, it will be faster and smaller.
-
-	  generic		For any supported IA-64 system
-	  DIG-compliant		For DIG ("Developer's Interface Guide") compliant systems
-	  DIG+Intel+IOMMU	For DIG systems with Intel IOMMU
-	  HP-zx1/sx1000		For HP systems
-	  SGI-UV		For SGI UV systems
-
-	  If you don't know what to do, choose "generic".
-
-config IA64_DIG
-	bool "DIG-compliant"
-	select SWIOTLB
-
-config IA64_HP_ZX1
-	bool "HP-zx1/sx1000"
-	help
-	  Build a kernel that runs on HP zx1 and sx1000 systems.  This adds
-	  support for the HP I/O MMU.
-
-config IA64_SGI_UV
-	bool "SGI-UV"
-	select NUMA
-	select ACPI_NUMA
-	select SWIOTLB
-	help
-	  Selecting this option will optimize the kernel for use on UV based
-	  systems, but the resulting kernel binary will not run on other
-	  types of ia64 systems.  If you have an SGI UV system, it's safe
-	  to select this option.  If in doubt, select ia64 generic support
-	  instead.
-
-endchoice
-
 choice
 	prompt "Processor type"
 	default ITANIUM
@@ -230,6 +187,20 @@ config IA64_L1_CACHE_SHIFT
 	default "7" if MCKINLEY
 	default "6" if ITANIUM
 
+config IA64_SGI_UV
+	bool "SGI-UV support"
+	help
+	  Selecting this option will add specific support for running on SGI
+	  UV based systems.  If you have an SGI UV system or are building a
+	  distro kernel, select this option.
+
+config IA64_HP_SBA_IOMMU
+	bool "HP SBA IOMMU support"
+	default y
+	help
+	  Say Y here to add support for the SBA IOMMU found on HP zx1 and
+	  sx1000 systems.  If you're unsure, answer Y.
+
 config IA64_CYCLONE
 	bool "Cyclone (EXA) Time Source support"
 	help
@@ -334,13 +305,12 @@ config ARCH_SPARSEMEM_ENABLE
 	select SPARSEMEM_VMEMMAP_ENABLE
 
 config ARCH_DISCONTIGMEM_DEFAULT
-	def_bool y if (IA64_GENERIC || IA64_HP_ZX1)
+	def_bool y
 	depends on ARCH_DISCONTIGMEM_ENABLE
 
 config NUMA
 	bool "NUMA support"
 	depends on !FLATMEM
-	select ACPI_NUMA if ACPI
 	help
 	  Say Y to compile the kernel to support NUMA (Non-Uniform Memory
 	  Access).  This option is for configuring high-end multiprocessor
diff --git a/arch/ia64/Kconfig.debug b/arch/ia64/Kconfig.debug
index abf8d04ab6ab..40ca23bd228d 100644
--- a/arch/ia64/Kconfig.debug
+++ b/arch/ia64/Kconfig.debug
@@ -14,7 +14,7 @@ config IA64_GRANULE_16MB
 
 config IA64_GRANULE_64MB
 	bool "64MB"
-	depends on !(IA64_GENERIC || IA64_HP_ZX1)
+	depends on BROKEN
 
 endchoice
 
diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
index 22deb5e6f346..e0bb2b6aaa35 100644
--- a/arch/ia64/Makefile
+++ b/arch/ia64/Makefile
@@ -50,14 +50,9 @@ head-y := arch/ia64/kernel/head.o
 
 libs-y				+= arch/ia64/lib/
 core-y				+= arch/ia64/kernel/ arch/ia64/mm/
-core-$(CONFIG_IA64_DIG) 	+= arch/ia64/dig/
-core-$(CONFIG_IA64_GENERIC) 	+= arch/ia64/dig/
-core-$(CONFIG_IA64_HP_ZX1)	+= arch/ia64/dig/
 core-$(CONFIG_IA64_SGI_UV)	+= arch/ia64/uv/
 
-drivers-y			+= arch/ia64/pci/
-drivers-$(CONFIG_IA64_HP_ZX1)	+= arch/ia64/hp/common/ arch/ia64/hp/zx1/
-drivers-$(CONFIG_IA64_GENERIC)	+= arch/ia64/hp/common/ arch/ia64/hp/zx1/ arch/ia64/uv/
+drivers-y			+= arch/ia64/pci/ arch/ia64/hp/common/
 drivers-$(CONFIG_OPROFILE)	+= arch/ia64/oprofile/
 
 PHONY += compressed check
diff --git a/arch/ia64/configs/bigsur_defconfig b/arch/ia64/configs/bigsur_defconfig
index b6bda1838629..b630bd7351c4 100644
--- a/arch/ia64/configs/bigsur_defconfig
+++ b/arch/ia64/configs/bigsur_defconfig
@@ -7,7 +7,6 @@ CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_PARTITION_ADVANCED=y
 CONFIG_SGI_PARTITION=y
-CONFIG_IA64_DIG=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
 CONFIG_PREEMPT=y
diff --git a/arch/ia64/configs/tiger_defconfig b/arch/ia64/configs/tiger_defconfig
index 192ed157c9ce..1d6e2a01452b 100644
--- a/arch/ia64/configs/tiger_defconfig
+++ b/arch/ia64/configs/tiger_defconfig
@@ -12,7 +12,6 @@ CONFIG_MODULE_SRCVERSION_ALL=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_PARTITION_ADVANCED=y
 CONFIG_SGI_PARTITION=y
-CONFIG_IA64_DIG=y
 CONFIG_MCKINLEY=y
 CONFIG_IA64_PAGE_SIZE_64KB=y
 CONFIG_IA64_CYCLONE=y
diff --git a/arch/ia64/configs/zx1_defconfig b/arch/ia64/configs/zx1_defconfig
index b504c8e2fd52..8c92e095f8bb 100644
--- a/arch/ia64/configs/zx1_defconfig
+++ b/arch/ia64/configs/zx1_defconfig
@@ -4,7 +4,6 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_KPROBES=y
 CONFIG_MODULES=y
 CONFIG_PARTITION_ADVANCED=y
-CONFIG_IA64_HP_ZX1=y
 CONFIG_MCKINLEY=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=16
diff --git a/arch/ia64/dig/Makefile b/arch/ia64/dig/Makefile
deleted file mode 100644
index 5c2f638c31f4..000000000000
--- a/arch/ia64/dig/Makefile
+++ /dev/null
@@ -1,10 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-#
-# ia64/platform/dig/Makefile
-#
-# Copyright (C) 1999 Silicon Graphics, Inc.
-# Copyright (C) Srinivasa Thirumalachar (sprasad@engr.sgi.com)
-#
-
-obj-y := setup.o
-obj-$(CONFIG_IA64_GENERIC) += machvec.o
diff --git a/arch/ia64/dig/machvec.c b/arch/ia64/dig/machvec.c
deleted file mode 100644
index 0c55bdafb473..000000000000
--- a/arch/ia64/dig/machvec.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#define MACHVEC_PLATFORM_NAME		dig
-#define MACHVEC_PLATFORM_HEADER		<asm/machvec_dig.h>
-#include <asm/machvec_init.h>
diff --git a/arch/ia64/dig/setup.c b/arch/ia64/dig/setup.c
deleted file mode 100644
index ca8be4617b2e..000000000000
--- a/arch/ia64/dig/setup.c
+++ /dev/null
@@ -1,32 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Platform dependent support for DIG64 platforms.
- *
- * Copyright (C) 1999 Intel Corp.
- * Copyright (C) 1999, 2001 Hewlett-Packard Co
- * Copyright (C) 1999, 2001, 2003 David Mosberger-Tang <davidm@hpl.hp.com>
- * Copyright (C) 1999 VA Linux Systems
- * Copyright (C) 1999 Walt Drummond <drummond@valinux.com>
- * Copyright (C) 1999 Vijay Chander <vijay@engr.sgi.com>
- */
-
-#include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/screen_info.h>
-#include <linux/console.h>
-#include <linux/timex.h>
-#include <linux/sched.h>
-
-#include <asm/io.h>
-#include <asm/machvec.h>
-#include <asm/setup.h>
-
-void __init
-dig_setup (char **cmdline_p)
-{
-#ifdef CONFIG_SMP
-	init_smp_config();
-#endif
-}
diff --git a/arch/ia64/hp/common/Makefile b/arch/ia64/hp/common/Makefile
index 47c8f6ecb6f4..11a56ed38229 100644
--- a/arch/ia64/hp/common/Makefile
+++ b/arch/ia64/hp/common/Makefile
@@ -6,5 +6,5 @@
 # Copyright (C) Alex Williamson (alex_williamson@hp.com)
 #
 
-obj-y := sba_iommu.o
+obj-$(CONFIG_IA64_HP_SBA_IOMMU) += sba_iommu.o
 obj-$(CONFIG_IA64_HP_AML_NFW) += aml_nfw.o
diff --git a/arch/ia64/hp/zx1/Makefile b/arch/ia64/hp/zx1/Makefile
deleted file mode 100644
index bea44b4ed173..000000000000
--- a/arch/ia64/hp/zx1/Makefile
+++ /dev/null
@@ -1,9 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-#
-# ia64/hp/zx1/Makefile
-#
-# Copyright (C) 2002 Hewlett Packard
-# Copyright (C) Alex Williamson (alex_williamson@hp.com)
-#
-
-obj-$(CONFIG_IA64_GENERIC) += hpzx1_machvec.o
diff --git a/arch/ia64/hp/zx1/hpzx1_machvec.c b/arch/ia64/hp/zx1/hpzx1_machvec.c
deleted file mode 100644
index 32518b0f923e..000000000000
--- a/arch/ia64/hp/zx1/hpzx1_machvec.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#define MACHVEC_PLATFORM_NAME		hpzx1
-#define MACHVEC_PLATFORM_HEADER		<asm/machvec_hpzx1.h>
-#include <asm/machvec_init.h>
diff --git a/arch/ia64/include/asm/acpi.h b/arch/ia64/include/asm/acpi.h
index be6bf3e499a6..f886d4dc9d55 100644
--- a/arch/ia64/include/asm/acpi.h
+++ b/arch/ia64/include/asm/acpi.h
@@ -32,22 +32,6 @@ static inline bool acpi_has_cpu_in_madt(void)
 #define acpi_processor_cstate_check(x) (x) /* no idle limits on IA64 :) */
 static inline void disable_acpi(void) { }
 
-#ifdef CONFIG_IA64_GENERIC
-const char *acpi_get_sysname (void);
-#else
-static inline const char *acpi_get_sysname (void)
-{
-# if defined (CONFIG_IA64_HP_ZX1)
-	return "hpzx1";
-# elif defined (CONFIG_IA64_SGI_UV)
-	return "uv";
-# elif defined (CONFIG_IA64_DIG)
-	return "dig";
-# else
-#	error Unknown platform.  Fix acpi.c.
-# endif
-}
-#endif
 int acpi_request_vector (u32 int_type);
 int acpi_gsi_to_irq (u32 gsi, unsigned int *irq);
 
diff --git a/arch/ia64/include/asm/hw_irq.h b/arch/ia64/include/asm/hw_irq.h
index 12808111a767..e6385c7bdeb0 100644
--- a/arch/ia64/include/asm/hw_irq.h
+++ b/arch/ia64/include/asm/hw_irq.h
@@ -12,7 +12,6 @@
 #include <linux/types.h>
 #include <linux/profile.h>
 
-#include <asm/machvec.h>
 #include <asm/ptrace.h>
 #include <asm/smp.h>
 
@@ -56,7 +55,7 @@ typedef u8 ia64_vector;
 extern int ia64_first_device_vector;
 extern int ia64_last_device_vector;
 
-#if defined(CONFIG_SMP) && (defined(CONFIG_IA64_GENERIC) || defined (CONFIG_IA64_DIG))
+#ifdef CONFIG_SMP
 /* Reserve the lower priority vector than device vectors for "move IRQ" IPI */
 #define IA64_IRQ_MOVE_VECTOR		0x30	/* "move IRQ" IPI */
 #define IA64_DEF_FIRST_DEVICE_VECTOR	0x31
@@ -127,7 +126,7 @@ extern void ia64_send_ipi (int cpu, int vector, int delivery_mode, int redirect)
 extern void ia64_native_register_percpu_irq (ia64_vector vec, struct irqaction *action);
 extern void destroy_and_reserve_irq (unsigned int irq);
 
-#if defined(CONFIG_SMP) && (defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_DIG))
+#ifdef CONFIG_SMP
 extern int irq_prepare_move(int irq, int cpu);
 extern void irq_complete_move(unsigned int irq);
 #else
diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
index edd5c262d360..54e70c21352a 100644
--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -71,7 +71,6 @@ extern unsigned int num_io_spaces;
 #define HAVE_ARCH_PIO_SIZE
 
 #include <asm/intrinsics.h>
-#include <asm/machvec.h>
 #include <asm/page.h>
 #include <asm-generic/iomap.h>
 
diff --git a/arch/ia64/include/asm/iommu.h b/arch/ia64/include/asm/iommu.h
index 7429a72f3f92..679854fbdfc5 100644
--- a/arch/ia64/include/asm/iommu.h
+++ b/arch/ia64/include/asm/iommu.h
@@ -15,6 +15,5 @@ extern int iommu_detected;
 #define no_iommu		(1)
 #define iommu_detected		(0)
 #endif
-extern void machvec_init(const char *name);
 
 #endif
diff --git a/arch/ia64/include/asm/machvec.h b/arch/ia64/include/asm/machvec.h
deleted file mode 100644
index b22d0499b58c..000000000000
--- a/arch/ia64/include/asm/machvec.h
+++ /dev/null
@@ -1,69 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Machine vector for IA-64.
- *
- * Copyright (C) 1999 Silicon Graphics, Inc.
- * Copyright (C) Srinivasa Thirumalachar <sprasad@engr.sgi.com>
- * Copyright (C) Vijay Chander <vijay@engr.sgi.com>
- * Copyright (C) 1999-2001, 2003-2004 Hewlett-Packard Co.
- *	David Mosberger-Tang <davidm@hpl.hp.com>
- */
-#ifndef _ASM_IA64_MACHVEC_H
-#define _ASM_IA64_MACHVEC_H
-
-#include <linux/types.h>
-
-struct device;
-
-typedef void ia64_mv_setup_t (char **);
-
-extern void machvec_setup (char **);
-
-# if defined (CONFIG_IA64_DIG)
-#  include <asm/machvec_dig.h>
-# elif defined (CONFIG_IA64_HP_ZX1)
-#  include <asm/machvec_hpzx1.h>
-# elif defined (CONFIG_IA64_SGI_UV)
-#  include <asm/machvec_uv.h>
-# elif defined (CONFIG_IA64_GENERIC)
-
-# ifdef MACHVEC_PLATFORM_HEADER
-#  include MACHVEC_PLATFORM_HEADER
-# else
-#  define ia64_platform_name	ia64_mv.name
-#  define platform_setup	ia64_mv.setup
-# endif
-
-/* __attribute__((__aligned__(16))) is required to make size of the
- * structure multiple of 16 bytes.
- * This will fillup the holes created because of section 3.3.1 in
- * Software Conventions guide.
- */
-struct ia64_machine_vector {
-	const char *name;
-	ia64_mv_setup_t *setup;
-} __attribute__((__aligned__(16))); /* align attrib? see above comment */
-
-#define MACHVEC_INIT(name)			\
-{						\
-	#name,					\
-	platform_setup,				\
-}
-
-extern struct ia64_machine_vector ia64_mv;
-extern void machvec_init (const char *name);
-extern void machvec_init_from_cmdline(const char *cmdline);
-
-# else
-#  error Unknown configuration.  Update arch/ia64/include/asm/machvec.h.
-# endif /* CONFIG_IA64_GENERIC */
-
-/*
- * Define default versions so we can extend machvec for new platforms without having
- * to update the machvec files for all existing platforms.
- */
-#ifndef platform_setup
-# define platform_setup			machvec_setup
-#endif
-
-#endif /* _ASM_IA64_MACHVEC_H */
diff --git a/arch/ia64/include/asm/machvec_dig.h b/arch/ia64/include/asm/machvec_dig.h
deleted file mode 100644
index bc230f69faeb..000000000000
--- a/arch/ia64/include/asm/machvec_dig.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_IA64_MACHVEC_DIG_h
-#define _ASM_IA64_MACHVEC_DIG_h
-
-extern ia64_mv_setup_t dig_setup;
-
-/*
- * This stuff has dual use!
- *
- * For a generic kernel, the macros are used to initialize the
- * platform's machvec structure.  When compiling a non-generic kernel,
- * the macros are used directly.
- */
-#define ia64_platform_name	"dig"
-#define platform_setup		dig_setup
-
-#endif /* _ASM_IA64_MACHVEC_DIG_h */
diff --git a/arch/ia64/include/asm/machvec_hpzx1.h b/arch/ia64/include/asm/machvec_hpzx1.h
deleted file mode 100644
index 7d37998ffdbf..000000000000
--- a/arch/ia64/include/asm/machvec_hpzx1.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_IA64_MACHVEC_HPZX1_h
-#define _ASM_IA64_MACHVEC_HPZX1_h
-
-extern ia64_mv_setup_t			dig_setup;
-
-/*
- * This stuff has dual use!
- *
- * For a generic kernel, the macros are used to initialize the
- * platform's machvec structure.  When compiling a non-generic kernel,
- * the macros are used directly.
- */
-#define ia64_platform_name			"hpzx1"
-#define platform_setup				dig_setup
-
-#endif /* _ASM_IA64_MACHVEC_HPZX1_h */
diff --git a/arch/ia64/include/asm/machvec_init.h b/arch/ia64/include/asm/machvec_init.h
deleted file mode 100644
index 7a82e3ea0aff..000000000000
--- a/arch/ia64/include/asm/machvec_init.h
+++ /dev/null
@@ -1,11 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#include <asm/iommu.h>
-#include <asm/machvec.h>
-
-#define MACHVEC_HELPER(name)									\
- struct ia64_machine_vector machvec_##name __attribute__ ((unused, __section__ (".machvec")))	\
-	= MACHVEC_INIT(name);
-
-#define MACHVEC_DEFINE(name)	MACHVEC_HELPER(name)
-
-MACHVEC_DEFINE(MACHVEC_PLATFORM_NAME)
diff --git a/arch/ia64/include/asm/machvec_uv.h b/arch/ia64/include/asm/machvec_uv.h
deleted file mode 100644
index 2c50853f35ac..000000000000
--- a/arch/ia64/include/asm/machvec_uv.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * SGI UV Core Functions
- *
- * Copyright (C) 2008 Silicon Graphics, Inc. All rights reserved.
- */
-
-#ifndef _ASM_IA64_MACHVEC_UV_H
-#define _ASM_IA64_MACHVEC_UV_H
-
-extern ia64_mv_setup_t uv_setup;
-
-/*
- * This stuff has dual use!
- *
- * For a generic kernel, the macros are used to initialize the
- * platform's machvec structure.  When compiling a non-generic kernel,
- * the macros are used directly.
- */
-#define ia64_platform_name		"uv"
-#define platform_setup			uv_setup
-
-#endif /* _ASM_IA64_MACHVEC_UV_H */
diff --git a/arch/ia64/include/asm/mmzone.h b/arch/ia64/include/asm/mmzone.h
index e5f461fd6a58..767201f66c93 100644
--- a/arch/ia64/include/asm/mmzone.h
+++ b/arch/ia64/include/asm/mmzone.h
@@ -27,16 +27,9 @@ static inline int pfn_to_nid(unsigned long pfn)
 		return nid;
 }
 
-#ifdef CONFIG_IA64_DIG /* DIG systems are small */
-# define MAX_PHYSNODE_ID	8
-# define NR_NODE_MEMBLKS	(MAX_NUMNODES * 8)
-#else 
-# define MAX_PHYSNODE_ID	2048
-# define NR_NODE_MEMBLKS	(MAX_NUMNODES * 4)
-#endif
-
-#else /* CONFIG_NUMA */
-# define NR_NODE_MEMBLKS	(MAX_NUMNODES * 4)
+#define MAX_PHYSNODE_ID		2048
 #endif /* CONFIG_NUMA */
 
+#define NR_NODE_MEMBLKS		(MAX_NUMNODES * 4)
+
 #endif /* _ASM_IA64_MMZONE_H */
diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
index c91ef98ed6bf..95a2ec37400f 100644
--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -679,8 +679,6 @@ enum idle_boot_override {IDLE_NO_OVERRIDE=0, IDLE_HALT, IDLE_FORCE_MWAIT,
 
 void default_idle(void);
 
-#define ia64_platform_is(x) (strcmp(x, ia64_platform_name) == 0)
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_IA64_PROCESSOR_H */
diff --git a/arch/ia64/include/asm/tlb.h b/arch/ia64/include/asm/tlb.h
index 86ec034ba499..f1f257d632b3 100644
--- a/arch/ia64/include/asm/tlb.h
+++ b/arch/ia64/include/asm/tlb.h
@@ -45,7 +45,6 @@
 #include <asm/pgalloc.h>
 #include <asm/processor.h>
 #include <asm/tlbflush.h>
-#include <asm/machvec.h>
 
 #include <asm-generic/tlb.h>
 
diff --git a/arch/ia64/include/asm/uv/uv.h b/arch/ia64/include/asm/uv/uv.h
index 502cf1c56369..48d4526bf4cd 100644
--- a/arch/ia64/include/asm/uv/uv.h
+++ b/arch/ia64/include/asm/uv/uv.h
@@ -2,10 +2,29 @@
 #ifndef _ASM_IA64_UV_UV_H
 #define _ASM_IA64_UV_UV_H
 
+#ifdef CONFIG_IA64_SGI_UV
+extern bool ia64_is_uv;
+
+static inline int is_uv_system(void)
+{
+	return ia64_is_uv;
+}
+
+void __init uv_probe_system_type(void);
+void __init uv_setup(char **cmdline_p);
+#else /* CONFIG_IA64_SGI_UV */
 static inline int is_uv_system(void)
 {
-	/* temporary support for running on hardware simulator */
-	return ia64_platform_is("uv");
+	return false;
+}
+
+static inline void __init uv_probe_system_type(void)
+{
+}
+
+static inline void __init uv_setup(char **cmdline_p)
+{
 }
+#endif /* CONFIG_IA64_SGI_UV */
 
 #endif	/* _ASM_IA64_UV_UV_H */
diff --git a/arch/ia64/kernel/Makefile b/arch/ia64/kernel/Makefile
index dbde36702cf2..1a8df6669eee 100644
--- a/arch/ia64/kernel/Makefile
+++ b/arch/ia64/kernel/Makefile
@@ -10,7 +10,7 @@ endif
 extra-y	:= head.o vmlinux.lds
 
 obj-y := entry.o efi.o efi_stub.o gate-data.o fsys.o ia64_ksyms.o irq.o irq_ia64.o	\
-	 irq_lsapic.o ivt.o machvec.o pal.o patch.o process.o perfmon.o ptrace.o sal.o		\
+	 irq_lsapic.o ivt.o pal.o patch.o process.o perfmon.o ptrace.o sal.o		\
 	 salinfo.o setup.o signal.o sys_ia64.o time.o traps.o unaligned.o \
 	 unwind.o mca.o mca_asm.o topology.o dma-mapping.o iosapic.o acpi.o \
 	 acpi-ext.o
@@ -30,7 +30,7 @@ obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_IA64_UNCACHED_ALLOCATOR)	+= uncached.o
 obj-$(CONFIG_AUDIT)		+= audit.o
-obj-$(CONFIG_PCI_MSI)		+= msi_ia64.o
+obj-y				+= msi_ia64.o
 mca_recovery-y			+= mca_drv.o mca_drv_asm.o
 obj-$(CONFIG_IA64_MC_ERR_INJECT)+= err_inject.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 644f34e4342e..70d1587ddcd4 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -31,7 +31,6 @@
 #include <acpi/processor.h>
 #include <asm/io.h>
 #include <asm/iosapic.h>
-#include <asm/machvec.h>
 #include <asm/page.h>
 #include <asm/numa.h>
 #include <asm/sal.h>
@@ -45,60 +44,6 @@ unsigned int acpi_cpei_phys_cpuid;
 
 unsigned long acpi_wakeup_address = 0;
 
-#ifdef CONFIG_IA64_GENERIC
-static unsigned long __init acpi_find_rsdp(void)
-{
-	unsigned long rsdp_phys = 0;
-
-	if (efi.acpi20 != EFI_INVALID_TABLE_ADDR)
-		rsdp_phys = efi.acpi20;
-	else if (efi.acpi != EFI_INVALID_TABLE_ADDR)
-		printk(KERN_WARNING PREFIX
-		       "v1.0/r0.71 tables no longer supported\n");
-	return rsdp_phys;
-}
-
-const char __init *
-acpi_get_sysname(void)
-{
-	unsigned long rsdp_phys;
-	struct acpi_table_rsdp *rsdp;
-	struct acpi_table_xsdt *xsdt;
-	struct acpi_table_header *hdr;
-
-	rsdp_phys = acpi_find_rsdp();
-	if (!rsdp_phys) {
-		printk(KERN_ERR
-		       "ACPI 2.0 RSDP not found, default to \"dig\"\n");
-		return "dig";
-	}
-
-	rsdp = (struct acpi_table_rsdp *)__va(rsdp_phys);
-	if (strncmp(rsdp->signature, ACPI_SIG_RSDP, sizeof(ACPI_SIG_RSDP) - 1)) {
-		printk(KERN_ERR
-		       "ACPI 2.0 RSDP signature incorrect, default to \"dig\"\n");
-		return "dig";
-	}
-
-	xsdt = (struct acpi_table_xsdt *)__va(rsdp->xsdt_physical_address);
-	hdr = &xsdt->header;
-	if (strncmp(hdr->signature, ACPI_SIG_XSDT, sizeof(ACPI_SIG_XSDT) - 1)) {
-		printk(KERN_ERR
-		       "ACPI 2.0 XSDT signature incorrect, default to \"dig\"\n");
-		return "dig";
-	}
-
-	if (!strcmp(hdr->oem_id, "HP")) {
-		return "hpzx1";
-	} else if (!strcmp(hdr->oem_id, "SGI")) {
-		if (!strcmp(hdr->oem_table_id + 4, "UV"))
-			return "uv";
-	}
-
-	return "dig";
-}
-#endif /* CONFIG_IA64_GENERIC */
-
 #define ACPI_MAX_PLATFORM_INTERRUPTS	256
 
 /* Array to record platform interrupt vectors for generic interrupt routing. */
diff --git a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
index 2d25958a7ed7..fad4db20ce65 100644
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -93,7 +93,6 @@
 #include <asm/hw_irq.h>
 #include <asm/io.h>
 #include <asm/iosapic.h>
-#include <asm/machvec.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 
diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index b989731bbeac..f10208478131 100644
--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -37,7 +37,6 @@
 #include <asm/intrinsics.h>
 #include <asm/io.h>
 #include <asm/hw_irq.h>
-#include <asm/machvec.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 
@@ -249,7 +248,7 @@ void __setup_vector_irq(int cpu)
 	}
 }
 
-#if defined(CONFIG_SMP) && (defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_DIG))
+#ifdef CONFIG_SMP
 
 static enum vector_domain_type {
 	VECTOR_DOMAIN_NONE,
@@ -637,11 +636,9 @@ init_IRQ (void)
 	ia64_register_ipi();
 	register_percpu_irq(IA64_SPURIOUS_INT_VECTOR, NULL);
 #ifdef CONFIG_SMP
-#if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_DIG)
 	if (vector_domain_type != VECTOR_DOMAIN_NONE)
 		register_percpu_irq(IA64_IRQ_MOVE_VECTOR, &irq_move_irqaction);
 #endif
-#endif
 #ifdef CONFIG_PERFMON
 	pfm_init_percpu();
 #endif
diff --git a/arch/ia64/kernel/machvec.c b/arch/ia64/kernel/machvec.c
deleted file mode 100644
index 3db3be7aaae5..000000000000
--- a/arch/ia64/kernel/machvec.c
+++ /dev/null
@@ -1,70 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <linux/module.h>
-#include <linux/dma-mapping.h>
-#include <asm/machvec.h>
-
-#ifdef CONFIG_IA64_GENERIC
-
-#include <linux/kernel.h>
-#include <linux/string.h>
-
-#include <asm/page.h>
-
-struct ia64_machine_vector ia64_mv = {
-};
-EXPORT_SYMBOL(ia64_mv);
-
-static struct ia64_machine_vector * __init
-lookup_machvec (const char *name)
-{
-	extern struct ia64_machine_vector machvec_start[];
-	extern struct ia64_machine_vector machvec_end[];
-	struct ia64_machine_vector *mv;
-
-	for (mv = machvec_start; mv < machvec_end; ++mv)
-		if (strcmp (mv->name, name) == 0)
-			return mv;
-
-	return 0;
-}
-
-void __init
-machvec_init (const char *name)
-{
-	struct ia64_machine_vector *mv;
-
-	if (!name)
-		name = acpi_get_sysname();
-	mv = lookup_machvec(name);
-	if (!mv)
-		panic("generic kernel failed to find machine vector for"
-		      " platform %s!", name);
-
-	ia64_mv = *mv;
-	printk(KERN_INFO "booting generic kernel on platform %s\n", name);
-}
-
-void __init
-machvec_init_from_cmdline(const char *cmdline)
-{
-	char str[64];
-	const char *start;
-	char *end;
-
-	if (! (start = strstr(cmdline, "machvec=")) )
-		return machvec_init(NULL);
-
-	strlcpy(str, start + strlen("machvec="), sizeof(str));
-	if ( (end = strchr(str, ' ')) )
-		*end = '\0';
-
-	return machvec_init(str);
-}
-
-#endif /* CONFIG_IA64_GENERIC */
-
-void
-machvec_setup (char **arg)
-{
-}
-EXPORT_SYMBOL(machvec_setup);
diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index a7f05883935b..bf2cb9294795 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -91,7 +91,6 @@
 #include <linux/gfp.h>
 
 #include <asm/delay.h>
-#include <asm/machvec.h>
 #include <asm/meminit.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
diff --git a/arch/ia64/kernel/mca_drv.c b/arch/ia64/kernel/mca_drv.c
index cd7972ede1d6..4d0ab323dee8 100644
--- a/arch/ia64/kernel/mca_drv.c
+++ b/arch/ia64/kernel/mca_drv.c
@@ -26,7 +26,6 @@
 #include <linux/slab.h>
 
 #include <asm/delay.h>
-#include <asm/machvec.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include <asm/sal.h>
diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index c5a8df9e77d0..7885b4a22a59 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -10,7 +10,6 @@
 #include <linux/module.h>
 #include <linux/dmar.h>
 #include <asm/iommu.h>
-#include <asm/machvec.h>
 #include <linux/dma-mapping.h>
 #include <linux/kernel.h>
 #include <asm/page.h>
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index 65d07c60f12d..18de565d5825 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -52,7 +52,6 @@
 #include <linux/kexec.h>
 #include <linux/crash_dump.h>
 
-#include <asm/machvec.h>
 #include <asm/mca.h>
 #include <asm/meminit.h>
 #include <asm/page.h>
@@ -65,11 +64,14 @@
 #include <asm/smp.h>
 #include <asm/tlbflush.h>
 #include <asm/unistd.h>
+#include <asm/uv/uv.h>
 
 #if defined(CONFIG_SMP) && (IA64_CPU_SIZE > PAGE_SIZE)
 # error "struct cpuinfo_ia64 too big!"
 #endif
 
+char ia64_platform_name[64];
+
 #ifdef CONFIG_SMP
 unsigned long __per_cpu_offset[NR_CPUS];
 EXPORT_SYMBOL(__per_cpu_offset);
@@ -265,7 +267,7 @@ __initcall(register_memory);
  */
 static int __init check_crashkernel_memory(unsigned long pbase, size_t size)
 {
-	if (ia64_platform_is("uv"))
+	if (is_uv_system())
 		return 1;
 	else
 		return pbase < (1UL << 32);
@@ -558,15 +560,7 @@ setup_arch (char **cmdline_p)
 	efi_init();
 	io_port_init();
 
-#ifdef CONFIG_IA64_GENERIC
-	/* machvec needs to be parsed from the command line
-	 * before parse_early_param() is called to ensure
-	 * that ia64_mv is initialised before any command line
-	 * settings may cause console setup to occur
-	 */
-	machvec_init_from_cmdline(*cmdline_p);
-#endif
-
+	uv_probe_system_type();
 	parse_early_param();
 
 	if (early_console_setup(*cmdline_p) == 0)
@@ -641,7 +635,13 @@ setup_arch (char **cmdline_p)
 	 */
 	ROOT_DEV = Root_SDA2;		/* default to second partition on first drive */
 
-	platform_setup(cmdline_p);
+	if (is_uv_system())
+		uv_setup(cmdline_p);
+#ifdef CONFIG_SMP
+	else
+		init_smp_config();
+#endif
+
 	screen_info_setup();
 	paging_init();
 
diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index 4825b0b41d49..de35c54f033d 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -36,7 +36,6 @@
 #include <linux/atomic.h>
 #include <asm/current.h>
 #include <asm/delay.h>
-#include <asm/machvec.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/page.h>
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index f7058659526c..6501d9a9a21b 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -47,7 +47,6 @@
 #include <asm/delay.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/machvec.h>
 #include <asm/mca.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index d9ad93a6d825..1e95d32c8877 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -25,7 +25,6 @@
 #include <linux/platform_device.h>
 #include <linux/sched/cputime.h>
 
-#include <asm/machvec.h>
 #include <asm/delay.h>
 #include <asm/hw_irq.h>
 #include <asm/ptrace.h>
diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index 0da58cf8e213..d9d4e21107cd 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -141,16 +141,6 @@ SECTIONS {
 		__end___mckinley_e9_bundles = .;
 	}
 
-#if defined(CONFIG_IA64_GENERIC)
-	/* Machine Vector */
-	. = ALIGN(16);
-	.machvec : AT(ADDR(.machvec) - LOAD_OFFSET) {
-		machvec_start = .;
-		*(.machvec)
-		machvec_end = .;
-	}
-#endif
-
 #ifdef	CONFIG_SMP
 	. = ALIGN(PERCPU_PAGE_SIZE);
 	__cpu0_per_cpu = .;
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index ed3ced65705e..1979cdb61d7c 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -28,7 +28,6 @@
 
 #include <asm/dma.h>
 #include <asm/io.h>
-#include <asm/machvec.h>
 #include <asm/numa.h>
 #include <asm/patch.h>
 #include <asm/pgalloc.h>
diff --git a/arch/ia64/pci/fixup.c b/arch/ia64/pci/fixup.c
index e1fa45b2148c..acb55a41260d 100644
--- a/arch/ia64/pci/fixup.c
+++ b/arch/ia64/pci/fixup.c
@@ -8,8 +8,7 @@
 #include <linux/init.h>
 #include <linux/vgaarb.h>
 #include <linux/screen_info.h>
-
-#include <asm/machvec.h>
+#include <asm/uv/uv.h>
 
 /*
  * Fixup to mark boot BIOS video selected by BIOS before it changes
@@ -35,8 +34,7 @@ static void pci_fixup_video(struct pci_dev *pdev)
 	u16 config;
 	struct resource *res;
 
-	if ((strcmp(ia64_platform_name, "dig") != 0)
-	    && (strcmp(ia64_platform_name, "hpzx1")  != 0))
+	if (is_uv_system())
 		return;
 	/* Maybe, this machine supports legacy memory map. */
 
diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 89c9f36dc94d..211757e34198 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -24,7 +24,6 @@
 #include <linux/memblock.h>
 #include <linux/export.h>
 
-#include <asm/machvec.h>
 #include <asm/page.h>
 #include <asm/io.h>
 #include <asm/sal.h>
diff --git a/arch/ia64/uv/kernel/Makefile b/arch/ia64/uv/kernel/Makefile
index 124e441d383d..297196578d19 100644
--- a/arch/ia64/uv/kernel/Makefile
+++ b/arch/ia64/uv/kernel/Makefile
@@ -10,4 +10,3 @@
 ccflags-y := -Iarch/ia64/sn/include
 
 obj-y				+= setup.o
-obj-$(CONFIG_IA64_GENERIC)      += machvec.o
diff --git a/arch/ia64/uv/kernel/machvec.c b/arch/ia64/uv/kernel/machvec.c
deleted file mode 100644
index 50737a9dca74..000000000000
--- a/arch/ia64/uv/kernel/machvec.c
+++ /dev/null
@@ -1,11 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
- */
-
-#define MACHVEC_PLATFORM_NAME	uv
-#define MACHVEC_PLATFORM_HEADER	<asm/machvec_uv.h>
-#include <asm/machvec_init.h>
diff --git a/arch/ia64/uv/kernel/setup.c b/arch/ia64/uv/kernel/setup.c
index b081f5138f5c..bb025486d791 100644
--- a/arch/ia64/uv/kernel/setup.c
+++ b/arch/ia64/uv/kernel/setup.c
@@ -8,11 +8,17 @@
  * Copyright (C) 2008 Silicon Graphics, Inc. All rights reserved.
  */
 
+#include <linux/acpi.h>
+#include <linux/efi.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
+#include <asm/uv/uv.h>
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
 
+bool ia64_is_uv;
+EXPORT_SYMBOL_GPL(ia64_is_uv);
+
 DEFINE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 EXPORT_PER_CPU_SYMBOL_GPL(__uv_hub_info);
 
@@ -47,6 +53,34 @@ static __init void get_lowmem_redirect(unsigned long *base, unsigned long *size)
 	BUG();
 }
 
+void __init uv_probe_system_type(void)
+{
+	struct acpi_table_rsdp *rsdp;
+	struct acpi_table_xsdt *xsdt;
+
+	if (efi.acpi20 == EFI_INVALID_TABLE_ADDR) {
+		pr_err("ACPI 2.0 RSDP not found.\n");
+		return;
+	}
+
+	rsdp = (struct acpi_table_rsdp *)__va(efi.acpi20);
+	if (strncmp(rsdp->signature, ACPI_SIG_RSDP, sizeof(ACPI_SIG_RSDP) - 1)) {
+		pr_err("ACPI 2.0 RSDP signature incorrect.\n");
+		return;
+	}
+
+	xsdt = (struct acpi_table_xsdt *)__va(rsdp->xsdt_physical_address);
+	if (strncmp(xsdt->header.signature, ACPI_SIG_XSDT,
+			sizeof(ACPI_SIG_XSDT) - 1)) {
+		pr_err("ACPI 2.0 XSDT signature incorrect.\n");
+		return;
+	}
+
+	if (!strcmp(xsdt->header.oem_id, "SGI") &&
+	    !strcmp(xsdt->header.oem_table_id + 4, "UV"))
+		ia64_is_uv = true;
+}
+
 void __init uv_setup(char **cmdline_p)
 {
 	union uvh_si_addr_map_config_u m_n_config;
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 06a16dc5cfb5..ebe1e9e5fd81 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -323,7 +323,7 @@ config ACPI_NUMA
 	bool "NUMA support"
 	depends on NUMA
 	depends on (X86 || IA64 || ARM64)
-	default y if IA64_GENERIC || ARM64
+	default y if IA64 || ARM64
 
 config ACPI_CUSTOM_DSDT_FILE
 	string "Custom DSDT Table file to include"
diff --git a/drivers/char/agp/Kconfig b/drivers/char/agp/Kconfig
index 42d45e97c2ae..812d6aa6e013 100644
--- a/drivers/char/agp/Kconfig
+++ b/drivers/char/agp/Kconfig
@@ -111,14 +111,14 @@ config AGP_VIA
 
 config AGP_I460
 	tristate "Intel 460GX chipset support"
-	depends on AGP && (IA64_DIG || IA64_GENERIC)
+	depends on AGP && IA64
 	help
 	  This option gives you AGP GART support for the Intel 460GX chipset
 	  for IA64 processors.
 
 config AGP_HP_ZX1
 	tristate "HP ZX1 chipset AGP support"
-	depends on AGP && (IA64_HP_ZX1 || IA64_GENERIC)
+	depends on AGP && IA64
 	help
 	  This option gives you AGP GART support for the HP ZX1 chipset
 	  for IA64 processors.
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index e15cdcd8cb3c..9a618459d067 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -177,7 +177,7 @@ config DMAR_TABLE
 
 config INTEL_IOMMU
 	bool "Support for Intel IOMMU using DMA Remapping Devices"
-	depends on PCI_MSI && ACPI && (X86 || IA64_GENERIC)
+	depends on PCI_MSI && ACPI && (X86 || IA64)
 	select IOMMU_API
 	select IOMMU_IOVA
 	select NEED_DMA_MAP_STATE
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 423d2d26d8f7..4ef2b751410c 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -188,7 +188,7 @@ config ENCLOSURE_SERVICES
 config SGI_XP
 	tristate "Support communication between SGI SSIs"
 	depends on NET
-	depends on (IA64_GENERIC || IA64_SGI_UV || X86_UV) && SMP
+	depends on (IA64_SGI_UV || X86_UV) && SMP
 	depends on X86_64 || BROKEN
 	select SGI_GRU if X86_64 && SMP
 	---help---
diff --git a/drivers/misc/sgi-xp/xp_uv.c b/drivers/misc/sgi-xp/xp_uv.c
index 5e335e93459c..c4a50baa16c2 100644
--- a/drivers/misc/sgi-xp/xp_uv.c
+++ b/drivers/misc/sgi-xp/xp_uv.c
@@ -17,7 +17,7 @@
 #include <asm/uv/uv_hub.h>
 #if defined CONFIG_X86_64
 #include <asm/uv/bios.h>
-#elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
+#elif defined CONFIG_IA64_SGI_UV
 #include <asm/sn/sn_sal.h>
 #endif
 #include "../sgi-gru/grukservices.h"
@@ -99,7 +99,7 @@ xp_expand_memprotect_uv(unsigned long phys_addr, unsigned long size)
 		return xpBiosError;
 	}
 
-#elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
+#elif defined defined CONFIG_IA64_SGI_UV
 	u64 nasid_array;
 
 	ret = sn_change_memprotect(phys_addr, size, SN_MEMPROT_ACCESS_CLASS_1,
@@ -129,7 +129,7 @@ xp_restrict_memprotect_uv(unsigned long phys_addr, unsigned long size)
 		return xpBiosError;
 	}
 
-#elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
+#elif defined CONFIG_IA64_SGI_UV
 	u64 nasid_array;
 
 	ret = sn_change_memprotect(phys_addr, size, SN_MEMPROT_ACCESS_CLASS_0,
diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
index d8a6fe16e4f5..54115415d88e 100644
--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -27,7 +27,7 @@
 #if defined CONFIG_X86_64
 #include <asm/uv/bios.h>
 #include <asm/uv/uv_irq.h>
-#elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
+#elif defined defined CONFIG_IA64_SGI_UV
 #include <asm/sn/intr.h>
 #include <asm/sn/sn_sal.h>
 #endif
@@ -35,7 +35,7 @@
 #include "../sgi-gru/grukservices.h"
 #include "xpc.h"
 
-#if defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
+#if defined CONFIG_IA64_SGI_UV
 struct uv_IO_APIC_route_entry {
 	__u64	vector		:  8,
 		delivery_mode	:  3,
@@ -121,7 +121,7 @@ xpc_get_gru_mq_irq_uv(struct xpc_gru_mq_uv *mq, int cpu, char *irq_name)
 
 	mq->mmr_value = uv_read_global_mmr64(mmr_pnode, mq->mmr_offset);
 
-#elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
+#elif defined defined CONFIG_IA64_SGI_UV
 	if (strcmp(irq_name, XPC_ACTIVATE_IRQ_NAME) == 0)
 		mq->irq = SGI_XPC_ACTIVATE;
 	else if (strcmp(irq_name, XPC_NOTIFY_IRQ_NAME) == 0)
@@ -144,7 +144,7 @@ xpc_release_gru_mq_irq_uv(struct xpc_gru_mq_uv *mq)
 #if defined CONFIG_X86_64
 	uv_teardown_irq(mq->irq);
 
-#elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
+#elif defined defined CONFIG_IA64_SGI_UV
 	int mmr_pnode;
 	unsigned long mmr_value;
 
@@ -162,7 +162,7 @@ xpc_gru_mq_watchlist_alloc_uv(struct xpc_gru_mq_uv *mq)
 {
 	int ret;
 
-#if defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
+#if defined defined CONFIG_IA64_SGI_UV
 	int mmr_pnode = uv_blade_to_pnode(mq->mmr_blade);
 
 	ret = sn_mq_watchlist_alloc(mmr_pnode, (void *)uv_gpa(mq->address),
@@ -197,7 +197,7 @@ xpc_gru_mq_watchlist_free_uv(struct xpc_gru_mq_uv *mq)
 #if defined CONFIG_X86_64
 	ret = uv_bios_mq_watchlist_free(mmr_pnode, mq->watchlist_num);
 	BUG_ON(ret != BIOS_STATUS_SUCCESS);
-#elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
+#elif defined CONFIG_IA64_SGI_UV
 	ret = sn_mq_watchlist_free(mmr_pnode, mq->watchlist_num);
 	BUG_ON(ret != SALRET_OK);
 #else
@@ -796,7 +796,7 @@ xpc_get_partition_rsvd_page_pa_uv(void *buf, u64 *cookie, unsigned long *rp_pa,
 	else
 		ret = xpBiosError;
 
-#elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
+#elif defined defined CONFIG_IA64_SGI_UV
 	status = sn_partition_reserved_page_pa((u64)buf, cookie, rp_pa, len);
 	if (status == SALRET_OK)
 		ret = xpSuccess;
-- 
2.20.1

