Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DCDC32750
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2651120665
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HtbNDFnv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfHMH0i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:26:38 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54806 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbfHMH0i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 03:26:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0h4xwOf46H43ITuwuwvNRenUGPZH3+Sh6TGdQBEZSKM=; b=HtbNDFnvGJxDpHY9+WyPxHauqP
        8k7SU5Ij5ZfIt8LpWn8gBgPDPD1x8l3GygrqHsNU2poN1c/psOTexYNlDQyKgaQA5SrbU76Xkiz/j
        B62lSsfmvbGCc+Wh4snSjb4qJivj/w4AVe4J2kgJqSj/166JE4HCtj9gCToYreuQh1WD/JA0jIh3j
        aTl+WOIDeqQr/DtWXJxQ/uuk1b5f5uiC4/GT6Px+wPuwAgIXrAKmHzmKJ0T3mE7ZVxcpkb+ZgiBvN
        /10OtrCQwseKmj+n0C7HkcBse+S4ETNLdVblLMAOu354PYocLvTF2Vk3mPxpDNjP4XXQgw8cuHhgN
        O7ol+8YA==;
Received: from [2001:4bb8:180:1ec3:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxRCU-0006wq-JD; Tue, 13 Aug 2019 07:26:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <sivanich@hpe.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 23/28] ia64: rework iommu probing
Date:   Tue, 13 Aug 2019 09:25:09 +0200
Message-Id: <20190813072514.23299-24-hch@lst.de>
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

ia64 currently organizes the iommu probing along machves, which isn't
very helpful.  Instead just try to probe for Intel IOMMUs in mem_init
as they are properly described in ACPI and if none was found initialize
the swiotlb buffer.  The HP SBA handling is then only done delayed when
the actual hardware is probed. Only in the case that we actually found
usable IOMMUs we then set up the DMA ops and free the not needed
swiotlb buffer.  This scheme gets rid of the need for the dma_init
machvec operation, and the dig_vtd machvec.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/ia64/Kconfig                       |  5 --
 arch/ia64/Makefile                      |  1 -
 arch/ia64/dig/Makefile                  |  5 --
 arch/ia64/dig/machvec_vtd.c             |  3 -
 arch/ia64/hp/common/sba_iommu.c         | 82 +++++++++----------------
 arch/ia64/include/asm/acpi.h            |  2 -
 arch/ia64/include/asm/machvec.h         | 11 ----
 arch/ia64/include/asm/machvec_dig_vtd.h | 19 ------
 arch/ia64/include/asm/machvec_hpzx1.h   |  2 -
 arch/ia64/include/asm/pci.h             |  3 -
 arch/ia64/kernel/acpi.c                 | 15 -----
 arch/ia64/kernel/dma-mapping.c          |  6 --
 arch/ia64/kernel/pci-dma.c              | 21 -------
 arch/ia64/mm/init.c                     | 16 +++--
 14 files changed, 40 insertions(+), 151 deletions(-)
 delete mode 100644 arch/ia64/dig/machvec_vtd.c
 delete mode 100644 arch/ia64/include/asm/machvec_dig_vtd.h

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index a42ab41ee8ab..9a8c7ec60cfc 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -146,11 +146,6 @@ config IA64_DIG
 	bool "DIG-compliant"
 	select SWIOTLB
 
-config IA64_DIG_VTD
-	bool "DIG+Intel+IOMMU"
-	select INTEL_IOMMU
-	select PCI_MSI
-
 config IA64_HP_ZX1
 	bool "HP-zx1/sx1000"
 	help
diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
index 0b3647efde5d..22deb5e6f346 100644
--- a/arch/ia64/Makefile
+++ b/arch/ia64/Makefile
@@ -51,7 +51,6 @@ head-y := arch/ia64/kernel/head.o
 libs-y				+= arch/ia64/lib/
 core-y				+= arch/ia64/kernel/ arch/ia64/mm/
 core-$(CONFIG_IA64_DIG) 	+= arch/ia64/dig/
-core-$(CONFIG_IA64_DIG_VTD) 	+= arch/ia64/dig/
 core-$(CONFIG_IA64_GENERIC) 	+= arch/ia64/dig/
 core-$(CONFIG_IA64_HP_ZX1)	+= arch/ia64/dig/
 core-$(CONFIG_IA64_SGI_UV)	+= arch/ia64/uv/
diff --git a/arch/ia64/dig/Makefile b/arch/ia64/dig/Makefile
index e7f830825470..5c2f638c31f4 100644
--- a/arch/ia64/dig/Makefile
+++ b/arch/ia64/dig/Makefile
@@ -7,9 +7,4 @@
 #
 
 obj-y := setup.o
-ifeq ($(CONFIG_INTEL_IOMMU), y)
-obj-$(CONFIG_IA64_GENERIC) += machvec.o machvec_vtd.o
-else
 obj-$(CONFIG_IA64_GENERIC) += machvec.o
-endif
-
diff --git a/arch/ia64/dig/machvec_vtd.c b/arch/ia64/dig/machvec_vtd.c
deleted file mode 100644
index 7cd3eb471cad..000000000000
--- a/arch/ia64/dig/machvec_vtd.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#define MACHVEC_PLATFORM_NAME		dig_vtd
-#define MACHVEC_PLATFORM_HEADER		<asm/machvec_dig_vtd.h>
-#include <asm/machvec_init.h>
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 215fa688b729..a7eff5e6d260 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -35,6 +35,7 @@
 #include <linux/iommu-helper.h>
 #include <linux/dma-mapping.h>
 #include <linux/prefetch.h>
+#include <linux/swiotlb.h>
 
 #include <asm/delay.h>		/* ia64_get_itc() */
 #include <asm/io.h>
@@ -43,8 +44,6 @@
 
 #include <asm/acpi-ext.h>
 
-extern int swiotlb_late_init_with_default_size (size_t size);
-
 #define PFX "IOC: "
 
 /*
@@ -2056,27 +2055,33 @@ static int __init acpi_sba_ioc_init_acpi(void)
 /* This has to run before acpi_scan_init(). */
 arch_initcall(acpi_sba_ioc_init_acpi);
 
+static int sba_dma_supported (struct device *dev, u64 mask)
+{
+	/* make sure it's at least 32bit capable */
+	return ((mask & 0xFFFFFFFFUL) == 0xFFFFFFFFUL);
+}
+
+static const struct dma_map_ops sba_dma_ops = {
+	.alloc			= sba_alloc_coherent,
+	.free			= sba_free_coherent,
+	.map_page		= sba_map_page,
+	.unmap_page		= sba_unmap_page,
+	.map_sg			= sba_map_sg_attrs,
+	.unmap_sg		= sba_unmap_sg_attrs,
+	.dma_supported		= sba_dma_supported,
+};
+
 static int __init
 sba_init(void)
 {
-	if (!ia64_platform_is("hpzx1"))
-		return 0;
-
-#if defined(CONFIG_IA64_GENERIC)
-	/* If we are booting a kdump kernel, the sba_iommu will
-	 * cause devices that were not shutdown properly to MCA
-	 * as soon as they are turned back on.  Our only option for
-	 * a successful kdump kernel boot is to use the swiotlb.
+	/*
+	 * If we are booting a kdump kernel, the sba_iommu will cause devices
+	 * that were not shutdown properly to MCA as soon as they are turned
+	 * back on.  Our only option for a successful kdump kernel boot is to
+	 * use swiotlb.
 	 */
-	if (is_kdump_kernel()) {
-		dma_ops = NULL;
-		if (swiotlb_late_init_with_default_size(64 * (1<<20)) != 0)
-			panic("Unable to initialize software I/O TLB:"
-				  " Try machvec=dig boot option");
-		machvec_init("dig");
+	if (is_kdump_kernel())
 		return 0;
-	}
-#endif
 
 	/*
 	 * ioc_found should be populated by the acpi_sba_ioc_handler's .attach()
@@ -2085,22 +2090,8 @@ sba_init(void)
 	while (ioc_found)
 		acpi_sba_ioc_add(ioc_found);
 
-	if (!ioc_list) {
-#ifdef CONFIG_IA64_GENERIC
-		/*
-		 * If we didn't find something sba_iommu can claim, we
-		 * need to setup the swiotlb and switch to the dig machvec.
-		 */
-		dma_ops = NULL;
-		if (swiotlb_late_init_with_default_size(64 * (1<<20)) != 0)
-			panic("Unable to find SBA IOMMU or initialize "
-			      "software I/O TLB: Try machvec=dig boot option");
-		machvec_init("dig");
-#else
-		panic("Unable to find SBA IOMMU: Try a generic or DIG kernel");
-#endif
+	if (!ioc_list)
 		return 0;
-	}
 
 	{
 		struct pci_bus *b = NULL;
@@ -2108,6 +2099,10 @@ sba_init(void)
 			sba_connect_bus(b);
 	}
 
+	/* no need for swiotlb with the iommu */
+	swiotlb_exit();
+	dma_ops = &sba_dma_ops;
+
 #ifdef CONFIG_PROC_FS
 	ioc_proc_init();
 #endif
@@ -2123,12 +2118,6 @@ nosbagart(char *str)
 	return 1;
 }
 
-static int sba_dma_supported (struct device *dev, u64 mask)
-{
-	/* make sure it's at least 32bit capable */
-	return ((mask & 0xFFFFFFFFUL) == 0xFFFFFFFFUL);
-}
-
 __setup("nosbagart", nosbagart);
 
 static int __init
@@ -2153,18 +2142,3 @@ sba_page_override(char *str)
 }
 
 __setup("sbapagesize=",sba_page_override);
-
-const struct dma_map_ops sba_dma_ops = {
-	.alloc			= sba_alloc_coherent,
-	.free			= sba_free_coherent,
-	.map_page		= sba_map_page,
-	.unmap_page		= sba_unmap_page,
-	.map_sg			= sba_map_sg_attrs,
-	.unmap_sg		= sba_unmap_sg_attrs,
-	.dma_supported		= sba_dma_supported,
-};
-
-void sba_dma_init(void)
-{
-	dma_ops = &sba_dma_ops;
-}
diff --git a/arch/ia64/include/asm/acpi.h b/arch/ia64/include/asm/acpi.h
index 9e563df73038..be6bf3e499a6 100644
--- a/arch/ia64/include/asm/acpi.h
+++ b/arch/ia64/include/asm/acpi.h
@@ -43,8 +43,6 @@ static inline const char *acpi_get_sysname (void)
 	return "uv";
 # elif defined (CONFIG_IA64_DIG)
 	return "dig";
-# elif defined(CONFIG_IA64_DIG_VTD)
-	return "dig_vtd";
 # else
 #	error Unknown platform.  Fix acpi.c.
 # endif
diff --git a/arch/ia64/include/asm/machvec.h b/arch/ia64/include/asm/machvec.h
index fa867e980d87..b22d0499b58c 100644
--- a/arch/ia64/include/asm/machvec.h
+++ b/arch/ia64/include/asm/machvec.h
@@ -16,14 +16,11 @@
 struct device;
 
 typedef void ia64_mv_setup_t (char **);
-typedef void ia64_mv_dma_init (void);
 
 extern void machvec_setup (char **);
 
 # if defined (CONFIG_IA64_DIG)
 #  include <asm/machvec_dig.h>
-# elif defined(CONFIG_IA64_DIG_VTD)
-#  include <asm/machvec_dig_vtd.h>
 # elif defined (CONFIG_IA64_HP_ZX1)
 #  include <asm/machvec_hpzx1.h>
 # elif defined (CONFIG_IA64_SGI_UV)
@@ -35,7 +32,6 @@ extern void machvec_setup (char **);
 # else
 #  define ia64_platform_name	ia64_mv.name
 #  define platform_setup	ia64_mv.setup
-#  define platform_dma_init		ia64_mv.dma_init
 # endif
 
 /* __attribute__((__aligned__(16))) is required to make size of the
@@ -46,14 +42,12 @@ extern void machvec_setup (char **);
 struct ia64_machine_vector {
 	const char *name;
 	ia64_mv_setup_t *setup;
-	ia64_mv_dma_init *dma_init;
 } __attribute__((__aligned__(16))); /* align attrib? see above comment */
 
 #define MACHVEC_INIT(name)			\
 {						\
 	#name,					\
 	platform_setup,				\
-	platform_dma_init,			\
 }
 
 extern struct ia64_machine_vector ia64_mv;
@@ -64,8 +58,6 @@ extern void machvec_init_from_cmdline(const char *cmdline);
 #  error Unknown configuration.  Update arch/ia64/include/asm/machvec.h.
 # endif /* CONFIG_IA64_GENERIC */
 
-extern void swiotlb_dma_init(void);
-
 /*
  * Define default versions so we can extend machvec for new platforms without having
  * to update the machvec files for all existing platforms.
@@ -73,8 +65,5 @@ extern void swiotlb_dma_init(void);
 #ifndef platform_setup
 # define platform_setup			machvec_setup
 #endif
-#ifndef platform_dma_init
-# define platform_dma_init		swiotlb_dma_init
-#endif
 
 #endif /* _ASM_IA64_MACHVEC_H */
diff --git a/arch/ia64/include/asm/machvec_dig_vtd.h b/arch/ia64/include/asm/machvec_dig_vtd.h
deleted file mode 100644
index bb44eb9039dd..000000000000
--- a/arch/ia64/include/asm/machvec_dig_vtd.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_IA64_MACHVEC_DIG_VTD_h
-#define _ASM_IA64_MACHVEC_DIG_VTD_h
-
-extern ia64_mv_setup_t			dig_setup;
-extern ia64_mv_dma_init			pci_iommu_alloc;
-
-/*
- * This stuff has dual use!
- *
- * For a generic kernel, the macros are used to initialize the
- * platform's machvec structure.  When compiling a non-generic kernel,
- * the macros are used directly.
- */
-#define ia64_platform_name			"dig_vtd"
-#define platform_setup				dig_setup
-#define platform_dma_init			pci_iommu_alloc
-
-#endif /* _ASM_IA64_MACHVEC_DIG_VTD_h */
diff --git a/arch/ia64/include/asm/machvec_hpzx1.h b/arch/ia64/include/asm/machvec_hpzx1.h
index 5299ac38bfb6..7d37998ffdbf 100644
--- a/arch/ia64/include/asm/machvec_hpzx1.h
+++ b/arch/ia64/include/asm/machvec_hpzx1.h
@@ -3,7 +3,6 @@
 #define _ASM_IA64_MACHVEC_HPZX1_h
 
 extern ia64_mv_setup_t			dig_setup;
-extern ia64_mv_dma_init			sba_dma_init;
 
 /*
  * This stuff has dual use!
@@ -14,6 +13,5 @@ extern ia64_mv_dma_init			sba_dma_init;
  */
 #define ia64_platform_name			"hpzx1"
 #define platform_setup				dig_setup
-#define platform_dma_init			sba_dma_init
 
 #endif /* _ASM_IA64_MACHVEC_HPZX1_h */
diff --git a/arch/ia64/include/asm/pci.h b/arch/ia64/include/asm/pci.h
index ef91b780a3f2..8c163d1d0189 100644
--- a/arch/ia64/include/asm/pci.h
+++ b/arch/ia64/include/asm/pci.h
@@ -69,7 +69,4 @@ static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
 	return channel ? isa_irq_to_vector(15) : isa_irq_to_vector(14);
 }
 
-#ifdef CONFIG_INTEL_IOMMU
-extern void pci_iommu_alloc(void);
-#endif
 #endif /* _ASM_IA64_PCI_H */
diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index a63e472f5317..644f34e4342e 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -65,9 +65,6 @@ acpi_get_sysname(void)
 	struct acpi_table_rsdp *rsdp;
 	struct acpi_table_xsdt *xsdt;
 	struct acpi_table_header *hdr;
-#ifdef CONFIG_INTEL_IOMMU
-	u64 i, nentries;
-#endif
 
 	rsdp_phys = acpi_find_rsdp();
 	if (!rsdp_phys) {
@@ -98,18 +95,6 @@ acpi_get_sysname(void)
 			return "uv";
 	}
 
-#ifdef CONFIG_INTEL_IOMMU
-	/* Look for Intel IOMMU */
-	nentries = (hdr->length - sizeof(*hdr)) /
-			 sizeof(xsdt->table_offset_entry[0]);
-	for (i = 0; i < nentries; i++) {
-		hdr = __va(xsdt->table_offset_entry[i]);
-		if (strncmp(hdr->signature, ACPI_SIG_DMAR,
-			sizeof(ACPI_SIG_DMAR) - 1) == 0)
-			return "dig_vtd";
-	}
-#endif
-
 	return "dig";
 }
 #endif /* CONFIG_IA64_GENERIC */
diff --git a/arch/ia64/kernel/dma-mapping.c b/arch/ia64/kernel/dma-mapping.c
index 4be5ee04ccfa..53aaa8597920 100644
--- a/arch/ia64/kernel/dma-mapping.c
+++ b/arch/ia64/kernel/dma-mapping.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/dma-direct.h>
-#include <linux/swiotlb.h>
 #include <linux/export.h>
 
 /* Set this to 1 if there is a HW IOMMU in the system */
@@ -27,9 +26,4 @@ long arch_dma_coherent_to_pfn(struct device *dev, void *cpu_addr,
 {
 	return page_to_pfn(virt_to_page(cpu_addr));
 }
-
-void __init swiotlb_dma_init(void)
-{
-	swiotlb_init(1);
-}
 #endif
diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index fe988c49f01c..c5a8df9e77d0 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -34,24 +34,3 @@ static int __init pci_iommu_init(void)
 
 /* Must execute after PCI subsystem */
 fs_initcall(pci_iommu_init);
-
-void __init pci_iommu_alloc(void)
-{
-	/*
-	 * The order of these functions is important for
-	 * fall-back/fail-over reasons
-	 */
-	detect_intel_iommu();
-
-#ifdef CONFIG_SWIOTLB
-	if (!iommu_detected) {
-#ifdef CONFIG_IA64_GENERIC
-		printk(KERN_INFO "PCI-DMA: Re-initialize machine vector.\n");
-		machvec_init("dig");
-		swiotlb_dma_init();
-#else
-		panic("Unable to find Intel IOMMU");
-#endif /* CONFIG_IA64_GENERIC */
-	}
-#endif /* CONFIG_SWIOTLB */
-}
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 9a4a16439900..ed3ced65705e 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -9,6 +9,7 @@
 #include <linux/init.h>
 
 #include <linux/dma-noncoherent.h>
+#include <linux/dmar.h>
 #include <linux/efi.h>
 #include <linux/elf.h>
 #include <linux/memblock.h>
@@ -23,6 +24,7 @@
 #include <linux/proc_fs.h>
 #include <linux/bitops.h>
 #include <linux/kexec.h>
+#include <linux/swiotlb.h>
 
 #include <asm/dma.h>
 #include <asm/io.h>
@@ -633,11 +635,17 @@ mem_init (void)
 	BUG_ON(PTRS_PER_PTE * sizeof(pte_t) != PAGE_SIZE);
 
 	/*
-	 * This needs to be called _after_ the command line has been parsed but _before_
-	 * any drivers that may need the PCI DMA interface are initialized or bootmem has
-	 * been freed.
+	 * This needs to be called _after_ the command line has been parsed but
+	 * _before_ any drivers that may need the PCI DMA interface are
+	 * initialized or bootmem has been freed.
 	 */
-	platform_dma_init();
+#ifdef CONFIG_INTEL_IOMMU
+	detect_intel_iommu();
+	if (!iommu_detected)
+#endif
+#ifdef CONFIG_SWIOTLB
+		swiotlb_init(1);
+#endif
 
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
-- 
2.20.1

