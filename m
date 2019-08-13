Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA354C32750
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C52120665
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:26:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mAGxZLJD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfHMH0W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:26:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53038 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbfHMH0V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 03:26:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FLx64LSOSPcimlkrN6COawu3ttWW5oBYzEVvPxVpntA=; b=mAGxZLJDTn+EckVF9qUmlekQ/l
        sWigehpNYdaDARh757EP58i7xhMOGq1VS9Cr2S5m+lKbglJWiZ8sUY2nF+j5atop8ScRvrog18C2C
        DgxMZR08HKJb/4sRIUs3oTH/qF8HhLq6KUP7m9UgUsuN8rAqLCAvKchd9I/pVIa0GWi5fzitJUeq5
        QKqp+U11BriBEPhHg3jP3vngd4nQ34zM4SzKexlP9DgHZ2bsTZ6JE+6SxrGfbgq59qkRuXdkuSyBc
        625Dycfd6lZPs2Fn0ui68nUvpdOptehtBzcbI9KRs5fSTW21s0oSlXchtPDcLHqpM8Vr6hLHBUE+o
        KqdhPJ1w==;
Received: from [2001:4bb8:180:1ec3:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxRCE-0006dc-QI; Tue, 13 Aug 2019 07:26:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <sivanich@hpe.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 18/28] ia64: remove CONFIG_PCI ifdefs
Date:   Tue, 13 Aug 2019 09:25:04 +0200
Message-Id: <20190813072514.23299-19-hch@lst.de>
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

Now that hpsim support is gone, CONFIG_PCI is forced on for ia64, and
we can remove a few ifdefs for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/ia64/Makefile              |  2 +-
 arch/ia64/hp/common/sba_iommu.c | 10 +---------
 arch/ia64/include/asm/dma.h     |  6 +-----
 arch/ia64/kernel/sys_ia64.c     | 18 ------------------
 arch/ia64/mm/init.c             |  2 --
 5 files changed, 3 insertions(+), 35 deletions(-)

diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
index 8b866fc1f9cb..c06802799659 100644
--- a/arch/ia64/Makefile
+++ b/arch/ia64/Makefile
@@ -57,7 +57,7 @@ core-$(CONFIG_IA64_HP_ZX1)	+= arch/ia64/dig/
 core-$(CONFIG_IA64_HP_ZX1_SWIOTLB) += arch/ia64/dig/
 core-$(CONFIG_IA64_SGI_UV)	+= arch/ia64/uv/
 
-drivers-$(CONFIG_PCI)		+= arch/ia64/pci/
+drivers-y			+= arch/ia64/pci/
 drivers-$(CONFIG_IA64_HP_ZX1)	+= arch/ia64/hp/common/ arch/ia64/hp/zx1/
 drivers-$(CONFIG_IA64_HP_ZX1_SWIOTLB) += arch/ia64/hp/common/ arch/ia64/hp/zx1/
 drivers-$(CONFIG_IA64_GENERIC)	+= arch/ia64/hp/common/ arch/ia64/hp/zx1/ arch/ia64/uv/
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 3d24cc43385b..18321ce8bfa0 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -251,12 +251,8 @@ static SBA_INLINE void sba_free_range(struct ioc *, dma_addr_t, size_t);
 static u64 prefetch_spill_page;
 #endif
 
-#ifdef CONFIG_PCI
-# define GET_IOC(dev)	((dev_is_pci(dev))						\
+#define GET_IOC(dev)	((dev_is_pci(dev))						\
 			 ? ((struct ioc *) PCI_CONTROLLER(to_pci_dev(dev))->iommu) : NULL)
-#else
-# define GET_IOC(dev)	NULL
-#endif
 
 /*
 ** DMA_CHUNK_SIZE is used by the SCSI mid-layer to break up
@@ -1741,9 +1737,7 @@ ioc_sac_init(struct ioc *ioc)
 	controller->iommu = ioc;
 	sac->sysdata = controller;
 	sac->dma_mask = 0xFFFFFFFFUL;
-#ifdef CONFIG_PCI
 	sac->dev.bus = &pci_bus_type;
-#endif
 	ioc->sac_only_dev = sac;
 }
 
@@ -2121,13 +2115,11 @@ sba_init(void)
 	}
 #endif
 
-#ifdef CONFIG_PCI
 	{
 		struct pci_bus *b = NULL;
 		while ((b = pci_find_next_bus(b)) != NULL)
 			sba_connect_bus(b);
 	}
-#endif
 
 #ifdef CONFIG_PROC_FS
 	ioc_proc_init();
diff --git a/arch/ia64/include/asm/dma.h b/arch/ia64/include/asm/dma.h
index 23604d6a2cb2..59625e9c1f9c 100644
--- a/arch/ia64/include/asm/dma.h
+++ b/arch/ia64/include/asm/dma.h
@@ -12,11 +12,7 @@
 
 extern unsigned long MAX_DMA_ADDRESS;
 
-#ifdef CONFIG_PCI
-  extern int isa_dma_bridge_buggy;
-#else
-# define isa_dma_bridge_buggy 	(0)
-#endif
+extern int isa_dma_bridge_buggy;
 
 #define free_dma(x)
 
diff --git a/arch/ia64/kernel/sys_ia64.c b/arch/ia64/kernel/sys_ia64.c
index 9ebe1d633abc..e14db25146c2 100644
--- a/arch/ia64/kernel/sys_ia64.c
+++ b/arch/ia64/kernel/sys_ia64.c
@@ -166,21 +166,3 @@ ia64_mremap (unsigned long addr, unsigned long old_len, unsigned long new_len, u
 		force_successful_syscall_return();
 	return addr;
 }
-
-#ifndef CONFIG_PCI
-
-asmlinkage long
-sys_pciconfig_read (unsigned long bus, unsigned long dfn, unsigned long off, unsigned long len,
-		    void *buf)
-{
-	return -ENOSYS;
-}
-
-asmlinkage long
-sys_pciconfig_write (unsigned long bus, unsigned long dfn, unsigned long off, unsigned long len,
-		     void *buf)
-{
-	return -ENOSYS;
-}
-
-#endif /* CONFIG_PCI */
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index aae75fd7b810..9a4a16439900 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -632,14 +632,12 @@ mem_init (void)
 	BUG_ON(PTRS_PER_PMD * sizeof(pmd_t) != PAGE_SIZE);
 	BUG_ON(PTRS_PER_PTE * sizeof(pte_t) != PAGE_SIZE);
 
-#ifdef CONFIG_PCI
 	/*
 	 * This needs to be called _after_ the command line has been parsed but _before_
 	 * any drivers that may need the PCI DMA interface are initialized or bootmem has
 	 * been freed.
 	 */
 	platform_dma_init();
-#endif
 
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
-- 
2.20.1

