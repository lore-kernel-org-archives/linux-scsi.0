Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5526C41514
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A36920665
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c98zTZUS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfHMH03 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:26:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53854 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbfHMH02 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 03:26:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=i/KxoBQjxzKY5/+yq3WEKZiRg2xAz/CxQmGkT41MBPQ=; b=c98zTZUSRVznjTdxKjwpt+uYfk
        OZZ8MNxLcXw8Tb22yTIeaJBXVGotIWouUa48+jlZxLZVD11rYjVzg/AxC7JT+UoOGdjidc06wwQ3g
        uGztdLfKxu9RU2Y8kZ5h9pacVLCoqRIimQD/lFaYCGMJIcIQur6cXuqDRv2nzxVegJHEc8VsYcols
        ou84PX53D3ieyBQGnpb3aebncVKuQdvPvO6A1RsLDk20tySaUSPyAqXdPStbtda9vVfyi2lXOcrA3
        arfuB1d77bduN3YkaJg9EvUvV6qkoN8wANySvL6cXIVVkiG6MZEHNPbps7sS+mmyp6HCZuGsiNNfR
        6paLwaFQ==;
Received: from [2001:4bb8:180:1ec3:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxRCK-0006kN-RF; Tue, 13 Aug 2019 07:26:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <sivanich@hpe.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 20/28] ia64: remove the zx1 swiotlb machvec
Date:   Tue, 13 Aug 2019 09:25:06 +0200
Message-Id: <20190813072514.23299-21-hch@lst.de>
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

The aim of this machvec is to support devices with < 32-bit dma
masks.  But given that ia64 only has a ZONE_DMA32 and not a ZONE_DMA
that isn't supported by swiotlb either.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 .../admin-guide/kernel-parameters.txt         |  2 +-
 arch/ia64/Kconfig                             | 13 +---
 arch/ia64/Kconfig.debug                       |  2 +-
 arch/ia64/Makefile                            |  2 -
 arch/ia64/hp/common/Makefile                  |  2 -
 arch/ia64/hp/common/hwsw_iommu.c              | 60 -------------------
 arch/ia64/hp/common/sba_iommu.c               | 15 +----
 arch/ia64/hp/zx1/Makefile                     |  2 +-
 arch/ia64/hp/zx1/hpzx1_swiotlb_machvec.c      |  3 -
 arch/ia64/include/asm/acpi.h                  |  2 -
 arch/ia64/include/asm/dma-mapping.h           |  8 +--
 arch/ia64/include/asm/machvec.h               | 15 -----
 arch/ia64/include/asm/machvec_hpzx1_swiotlb.h | 20 -------
 arch/ia64/kernel/dma-mapping.c                |  6 --
 drivers/char/agp/Kconfig                      |  2 +-
 15 files changed, 7 insertions(+), 147 deletions(-)
 delete mode 100644 arch/ia64/hp/common/hwsw_iommu.c
 delete mode 100644 arch/ia64/hp/zx1/hpzx1_swiotlb_machvec.c
 delete mode 100644 arch/ia64/include/asm/machvec_hpzx1_swiotlb.h

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 47d981a86e2f..33ab47447ef1 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2373,7 +2373,7 @@
 
 	machvec=	[IA-64] Force the use of a particular machine-vector
 			(machvec) in a generic kernel.
-			Example: machvec=hpzx1_swiotlb
+			Example: machvec=hpzx1
 
 	machtype=	[Loongson] Share the same kernel image file between different
 			 yeeloong laptop.
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 63db7a5378ac..a42ab41ee8ab 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -138,7 +138,6 @@ config IA64_GENERIC
 	  DIG-compliant		For DIG ("Developer's Interface Guide") compliant systems
 	  DIG+Intel+IOMMU	For DIG systems with Intel IOMMU
 	  HP-zx1/sx1000		For HP systems
-	  HP-zx1/sx1000+swiotlb	For HP systems with (broken) DMA-constrained devices.
 	  SGI-UV		For SGI UV systems
 
 	  If you don't know what to do, choose "generic".
@@ -158,16 +157,6 @@ config IA64_HP_ZX1
 	  Build a kernel that runs on HP zx1 and sx1000 systems.  This adds
 	  support for the HP I/O MMU.
 
-config IA64_HP_ZX1_SWIOTLB
-	bool "HP-zx1/sx1000 with software I/O TLB"
-	select SWIOTLB
-	help
-	  Build a kernel that runs on HP zx1 and sx1000 systems even when they
-	  have broken PCI devices which cannot DMA to full 32 bits.  Apart
-	  from support for the HP I/O MMU, this includes support for the software
-	  I/O TLB, which allows supporting the broken devices at the expense of
-	  wasting some kernel memory (about 2MB by default).
-
 config IA64_SGI_UV
 	bool "SGI-UV"
 	select NUMA
@@ -350,7 +339,7 @@ config ARCH_SPARSEMEM_ENABLE
 	select SPARSEMEM_VMEMMAP_ENABLE
 
 config ARCH_DISCONTIGMEM_DEFAULT
-	def_bool y if (IA64_GENERIC || IA64_HP_ZX1 || IA64_HP_ZX1_SWIOTLB)
+	def_bool y if (IA64_GENERIC || IA64_HP_ZX1)
 	depends on ARCH_DISCONTIGMEM_ENABLE
 
 config NUMA
diff --git a/arch/ia64/Kconfig.debug b/arch/ia64/Kconfig.debug
index 793a613c54ab..abf8d04ab6ab 100644
--- a/arch/ia64/Kconfig.debug
+++ b/arch/ia64/Kconfig.debug
@@ -14,7 +14,7 @@ config IA64_GRANULE_16MB
 
 config IA64_GRANULE_64MB
 	bool "64MB"
-	depends on !(IA64_GENERIC || IA64_HP_ZX1 || IA64_HP_ZX1_SWIOTLB)
+	depends on !(IA64_GENERIC || IA64_HP_ZX1)
 
 endchoice
 
diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
index c06802799659..0b3647efde5d 100644
--- a/arch/ia64/Makefile
+++ b/arch/ia64/Makefile
@@ -54,12 +54,10 @@ core-$(CONFIG_IA64_DIG) 	+= arch/ia64/dig/
 core-$(CONFIG_IA64_DIG_VTD) 	+= arch/ia64/dig/
 core-$(CONFIG_IA64_GENERIC) 	+= arch/ia64/dig/
 core-$(CONFIG_IA64_HP_ZX1)	+= arch/ia64/dig/
-core-$(CONFIG_IA64_HP_ZX1_SWIOTLB) += arch/ia64/dig/
 core-$(CONFIG_IA64_SGI_UV)	+= arch/ia64/uv/
 
 drivers-y			+= arch/ia64/pci/
 drivers-$(CONFIG_IA64_HP_ZX1)	+= arch/ia64/hp/common/ arch/ia64/hp/zx1/
-drivers-$(CONFIG_IA64_HP_ZX1_SWIOTLB) += arch/ia64/hp/common/ arch/ia64/hp/zx1/
 drivers-$(CONFIG_IA64_GENERIC)	+= arch/ia64/hp/common/ arch/ia64/hp/zx1/ arch/ia64/uv/
 drivers-$(CONFIG_OPROFILE)	+= arch/ia64/oprofile/
 
diff --git a/arch/ia64/hp/common/Makefile b/arch/ia64/hp/common/Makefile
index 6026308f9a62..47c8f6ecb6f4 100644
--- a/arch/ia64/hp/common/Makefile
+++ b/arch/ia64/hp/common/Makefile
@@ -7,6 +7,4 @@
 #
 
 obj-y := sba_iommu.o
-obj-$(CONFIG_IA64_HP_ZX1_SWIOTLB) += hwsw_iommu.o
-obj-$(CONFIG_IA64_GENERIC) += hwsw_iommu.o
 obj-$(CONFIG_IA64_HP_AML_NFW) += aml_nfw.o
diff --git a/arch/ia64/hp/common/hwsw_iommu.c b/arch/ia64/hp/common/hwsw_iommu.c
deleted file mode 100644
index 8840ed97712f..000000000000
--- a/arch/ia64/hp/common/hwsw_iommu.c
+++ /dev/null
@@ -1,60 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2004 Hewlett-Packard Development Company, L.P.
- *   Contributed by David Mosberger-Tang <davidm@hpl.hp.com>
- *
- * This is a pseudo I/O MMU which dispatches to the hardware I/O MMU
- * whenever possible.  We assume that the hardware I/O MMU requires
- * full 32-bit addressability, as is the case, e.g., for HP zx1-based
- * systems (there, the I/O MMU window is mapped at 3-4GB).  If a
- * device doesn't provide full 32-bit addressability, we fall back on
- * the sw I/O TLB.  This is good enough to let us support broken
- * hardware such as soundcards which have a DMA engine that can
- * address only 28 bits.
- */
-
-#include <linux/device.h>
-#include <linux/dma-mapping.h>
-#include <linux/swiotlb.h>
-#include <linux/export.h>
-#include <asm/machvec.h>
-
-extern const struct dma_map_ops sba_dma_ops;
-
-/* swiotlb declarations & definitions: */
-extern int swiotlb_late_init_with_default_size (size_t size);
-
-/*
- * Note: we need to make the determination of whether or not to use
- * the sw I/O TLB based purely on the device structure.  Anything else
- * would be unreliable or would be too intrusive.
- */
-static inline int use_swiotlb(struct device *dev)
-{
-	return dev && dev->dma_mask &&
-		!sba_dma_ops.dma_supported(dev, *dev->dma_mask);
-}
-
-const struct dma_map_ops *hwsw_dma_get_ops(struct device *dev)
-{
-	if (use_swiotlb(dev))
-		return NULL;
-	return &sba_dma_ops;
-}
-EXPORT_SYMBOL(hwsw_dma_get_ops);
-
-void __init
-hwsw_init (void)
-{
-	/* default to a smallish 2MB sw I/O TLB */
-	if (swiotlb_late_init_with_default_size (2 * (1<<20)) != 0) {
-#ifdef CONFIG_IA64_GENERIC
-		/* Better to have normal DMA than panic */
-		printk(KERN_WARNING "%s: Failed to initialize software I/O TLB,"
-		       " reverting to hpzx1 platform vector\n", __func__);
-		machvec_init("hpzx1");
-#else
-		panic("Unable to initialize software I/O TLB services");
-#endif
-	}
-}
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 18321ce8bfa0..215fa688b729 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -2059,7 +2059,7 @@ arch_initcall(acpi_sba_ioc_init_acpi);
 static int __init
 sba_init(void)
 {
-	if (!ia64_platform_is("hpzx1") && !ia64_platform_is("hpzx1_swiotlb"))
+	if (!ia64_platform_is("hpzx1"))
 		return 0;
 
 #if defined(CONFIG_IA64_GENERIC)
@@ -2102,19 +2102,6 @@ sba_init(void)
 		return 0;
 	}
 
-#if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_HP_ZX1_SWIOTLB)
-	/*
-	 * hpzx1_swiotlb needs to have a fairly small swiotlb bounce
-	 * buffer setup to support devices with smaller DMA masks than
-	 * sba_iommu can handle.
-	 */
-	if (ia64_platform_is("hpzx1_swiotlb")) {
-		extern void hwsw_init(void);
-
-		hwsw_init();
-	}
-#endif
-
 	{
 		struct pci_bus *b = NULL;
 		while ((b = pci_find_next_bus(b)) != NULL)
diff --git a/arch/ia64/hp/zx1/Makefile b/arch/ia64/hp/zx1/Makefile
index 46b37d820b59..bea44b4ed173 100644
--- a/arch/ia64/hp/zx1/Makefile
+++ b/arch/ia64/hp/zx1/Makefile
@@ -6,4 +6,4 @@
 # Copyright (C) Alex Williamson (alex_williamson@hp.com)
 #
 
-obj-$(CONFIG_IA64_GENERIC) += hpzx1_machvec.o hpzx1_swiotlb_machvec.o
+obj-$(CONFIG_IA64_GENERIC) += hpzx1_machvec.o
diff --git a/arch/ia64/hp/zx1/hpzx1_swiotlb_machvec.c b/arch/ia64/hp/zx1/hpzx1_swiotlb_machvec.c
deleted file mode 100644
index 4392a96b3c58..000000000000
--- a/arch/ia64/hp/zx1/hpzx1_swiotlb_machvec.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#define MACHVEC_PLATFORM_NAME		hpzx1_swiotlb
-#define MACHVEC_PLATFORM_HEADER		<asm/machvec_hpzx1_swiotlb.h>
-#include <asm/machvec_init.h>
diff --git a/arch/ia64/include/asm/acpi.h b/arch/ia64/include/asm/acpi.h
index 01c1c269aa13..9e563df73038 100644
--- a/arch/ia64/include/asm/acpi.h
+++ b/arch/ia64/include/asm/acpi.h
@@ -39,8 +39,6 @@ static inline const char *acpi_get_sysname (void)
 {
 # if defined (CONFIG_IA64_HP_ZX1)
 	return "hpzx1";
-# elif defined (CONFIG_IA64_HP_ZX1_SWIOTLB)
-	return "hpzx1_swiotlb";
 # elif defined (CONFIG_IA64_SGI_UV)
 	return "uv";
 # elif defined (CONFIG_IA64_DIG)
diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index f7ec71e4001e..a5d9d788eede 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -6,17 +6,11 @@
  * Copyright (C) 2003-2004 Hewlett-Packard Co
  *	David Mosberger-Tang <davidm@hpl.hp.com>
  */
-#include <asm/machvec.h>
-#include <linux/scatterlist.h>
-#include <linux/dma-debug.h>
-
 extern const struct dma_map_ops *dma_ops;
-extern struct ia64_machine_vector ia64_mv;
-extern void set_iommu_machvec(void);
 
 static inline const struct dma_map_ops *get_arch_dma_ops(struct bus_type *bus)
 {
-	return platform_dma_get_ops(NULL);
+	return dma_ops;
 }
 
 #endif /* _ASM_IA64_DMA_MAPPING_H */
diff --git a/arch/ia64/include/asm/machvec.h b/arch/ia64/include/asm/machvec.h
index 5a9a8af79308..fa867e980d87 100644
--- a/arch/ia64/include/asm/machvec.h
+++ b/arch/ia64/include/asm/machvec.h
@@ -17,12 +17,6 @@ struct device;
 
 typedef void ia64_mv_setup_t (char **);
 typedef void ia64_mv_dma_init (void);
-typedef const struct dma_map_ops *ia64_mv_dma_get_ops(struct device *);
-
-static inline void
-machvec_noop (void)
-{
-}
 
 extern void machvec_setup (char **);
 
@@ -32,8 +26,6 @@ extern void machvec_setup (char **);
 #  include <asm/machvec_dig_vtd.h>
 # elif defined (CONFIG_IA64_HP_ZX1)
 #  include <asm/machvec_hpzx1.h>
-# elif defined (CONFIG_IA64_HP_ZX1_SWIOTLB)
-#  include <asm/machvec_hpzx1_swiotlb.h>
 # elif defined (CONFIG_IA64_SGI_UV)
 #  include <asm/machvec_uv.h>
 # elif defined (CONFIG_IA64_GENERIC)
@@ -44,7 +36,6 @@ extern void machvec_setup (char **);
 #  define ia64_platform_name	ia64_mv.name
 #  define platform_setup	ia64_mv.setup
 #  define platform_dma_init		ia64_mv.dma_init
-#  define platform_dma_get_ops		ia64_mv.dma_get_ops
 # endif
 
 /* __attribute__((__aligned__(16))) is required to make size of the
@@ -56,7 +47,6 @@ struct ia64_machine_vector {
 	const char *name;
 	ia64_mv_setup_t *setup;
 	ia64_mv_dma_init *dma_init;
-	ia64_mv_dma_get_ops *dma_get_ops;
 } __attribute__((__aligned__(16))); /* align attrib? see above comment */
 
 #define MACHVEC_INIT(name)			\
@@ -64,7 +54,6 @@ struct ia64_machine_vector {
 	#name,					\
 	platform_setup,				\
 	platform_dma_init,			\
-	platform_dma_get_ops,			\
 }
 
 extern struct ia64_machine_vector ia64_mv;
@@ -76,7 +65,6 @@ extern void machvec_init_from_cmdline(const char *cmdline);
 # endif /* CONFIG_IA64_GENERIC */
 
 extern void swiotlb_dma_init(void);
-extern const struct dma_map_ops *dma_get_ops(struct device *);
 
 /*
  * Define default versions so we can extend machvec for new platforms without having
@@ -88,8 +76,5 @@ extern const struct dma_map_ops *dma_get_ops(struct device *);
 #ifndef platform_dma_init
 # define platform_dma_init		swiotlb_dma_init
 #endif
-#ifndef platform_dma_get_ops
-# define platform_dma_get_ops		dma_get_ops
-#endif
 
 #endif /* _ASM_IA64_MACHVEC_H */
diff --git a/arch/ia64/include/asm/machvec_hpzx1_swiotlb.h b/arch/ia64/include/asm/machvec_hpzx1_swiotlb.h
deleted file mode 100644
index 5aec6a008c61..000000000000
--- a/arch/ia64/include/asm/machvec_hpzx1_swiotlb.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_IA64_MACHVEC_HPZX1_SWIOTLB_h
-#define _ASM_IA64_MACHVEC_HPZX1_SWIOTLB_h
-
-extern ia64_mv_setup_t				dig_setup;
-extern ia64_mv_dma_get_ops			hwsw_dma_get_ops;
-
-/*
- * This stuff has dual use!
- *
- * For a generic kernel, the macros are used to initialize the
- * platform's machvec structure.  When compiling a non-generic kernel,
- * the macros are used directly.
- */
-#define ia64_platform_name			"hpzx1_swiotlb"
-#define platform_setup				dig_setup
-#define platform_dma_init			machvec_noop
-#define platform_dma_get_ops			hwsw_dma_get_ops
-
-#endif /* _ASM_IA64_MACHVEC_HPZX1_SWIOTLB_h */
diff --git a/arch/ia64/kernel/dma-mapping.c b/arch/ia64/kernel/dma-mapping.c
index ad7d9963de34..4be5ee04ccfa 100644
--- a/arch/ia64/kernel/dma-mapping.c
+++ b/arch/ia64/kernel/dma-mapping.c
@@ -9,12 +9,6 @@ int iommu_detected __read_mostly;
 const struct dma_map_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
-const struct dma_map_ops *dma_get_ops(struct device *dev)
-{
-	return dma_ops;
-}
-EXPORT_SYMBOL(dma_get_ops);
-
 #ifdef CONFIG_SWIOTLB
 void *arch_dma_alloc(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
diff --git a/drivers/char/agp/Kconfig b/drivers/char/agp/Kconfig
index be50d7a93f4c..42d45e97c2ae 100644
--- a/drivers/char/agp/Kconfig
+++ b/drivers/char/agp/Kconfig
@@ -118,7 +118,7 @@ config AGP_I460
 
 config AGP_HP_ZX1
 	tristate "HP ZX1 chipset AGP support"
-	depends on AGP && (IA64_HP_ZX1 || IA64_HP_ZX1_SWIOTLB || IA64_GENERIC)
+	depends on AGP && (IA64_HP_ZX1 || IA64_GENERIC)
 	help
 	  This option gives you AGP GART support for the HP ZX1 chipset
 	  for IA64 processors.
-- 
2.20.1

