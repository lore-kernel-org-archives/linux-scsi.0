Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49EDBC32753
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D89920665
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E9/wFTGP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbfHMH1k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:27:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50056 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727584AbfHMHZ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 03:25:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CS+ezjzkKTEfOqsL9OL+ba5pHMNosTvC9SwTRt1MZUs=; b=E9/wFTGPFFtpcYyiC5e+N5RHw/
        Kc0iTuG2K1A/+x/O6Auo2HA3fAuYBWmjIWGM1oXq4dJvdbCr1qwl0FpV8vWTUaWTd1ThzciIenS3/
        PGnO2e3wr/OEe5IylS3iRygl+WUEhcHFKa2oJG1lyt102ooJhpaxFkG7woZ52HZV1uLYcEukoX6ch
        PasfPY3vwIT07f8vlBB5mQs+FP7b5P9wTzj+uZwaVg5/azCBitW1AJKPoXeUFhY883O+rG+f9+pR5
        zAUy8uZFx9osCMM6e/yKJoFvtPJvzjR/CUFcmhcBAkYVsVw+Y2JRftHXTBisAOAxUgNbtTf+p3pue
        +PSUtRzg==;
Received: from [2001:4bb8:180:1ec3:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxRBN-000654-Ni; Tue, 13 Aug 2019 07:25:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <sivanich@hpe.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/28] char/agp: remove the sgi-agp driver
Date:   Tue, 13 Aug 2019 09:24:49 +0200
Message-Id: <20190813072514.23299-4-hch@lst.de>
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

The SGI SN2 support is about to be removed.  Remove this driver that
depends on the SN2 support.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/ia64/configs/generic_defconfig   |   1 -
 arch/ia64/configs/gensparse_defconfig |   1 -
 drivers/char/agp/Kconfig              |   7 -
 drivers/char/agp/Makefile             |   1 -
 drivers/char/agp/sgi-agp.c            | 338 --------------------------
 5 files changed, 348 deletions(-)
 delete mode 100644 drivers/char/agp/sgi-agp.c

diff --git a/arch/ia64/configs/generic_defconfig b/arch/ia64/configs/generic_defconfig
index 1fc4d5a77e0d..79b88384c885 100644
--- a/arch/ia64/configs/generic_defconfig
+++ b/arch/ia64/configs/generic_defconfig
@@ -104,7 +104,6 @@ CONFIG_HPET=y
 CONFIG_AGP=m
 CONFIG_AGP_I460=m
 CONFIG_AGP_HP_ZX1=m
-CONFIG_AGP_SGI_TIOCA=m
 CONFIG_DRM=m
 CONFIG_DRM_TDFX=m
 CONFIG_DRM_R128=m
diff --git a/arch/ia64/configs/gensparse_defconfig b/arch/ia64/configs/gensparse_defconfig
index 289ed714ad8b..f1490580ed69 100644
--- a/arch/ia64/configs/gensparse_defconfig
+++ b/arch/ia64/configs/gensparse_defconfig
@@ -94,7 +94,6 @@ CONFIG_HPET=y
 CONFIG_AGP=m
 CONFIG_AGP_I460=m
 CONFIG_AGP_HP_ZX1=m
-CONFIG_AGP_SGI_TIOCA=m
 CONFIG_DRM=m
 CONFIG_DRM_TDFX=m
 CONFIG_DRM_R128=m
diff --git a/drivers/char/agp/Kconfig b/drivers/char/agp/Kconfig
index 6231714ef3c8..be50d7a93f4c 100644
--- a/drivers/char/agp/Kconfig
+++ b/drivers/char/agp/Kconfig
@@ -150,13 +150,6 @@ config AGP_EFFICEON
 	  This option gives you AGP support for the Transmeta Efficeon
 	  series processors with integrated northbridges.
 
-config AGP_SGI_TIOCA
-        tristate "SGI TIO chipset AGP support"
-        depends on AGP && (IA64_SGI_SN2 || IA64_GENERIC)
-        help
-          This option gives you AGP GART support for the SGI TIO chipset
-          for IA64 processors.
-
 config INTEL_GTT
 	tristate
 	depends on X86 && PCI
diff --git a/drivers/char/agp/Makefile b/drivers/char/agp/Makefile
index 4a786ffd9dee..cb2497d157f6 100644
--- a/drivers/char/agp/Makefile
+++ b/drivers/char/agp/Makefile
@@ -16,7 +16,6 @@ obj-$(CONFIG_AGP_I460)		+= i460-agp.o
 obj-$(CONFIG_AGP_INTEL)		+= intel-agp.o
 obj-$(CONFIG_INTEL_GTT)		+= intel-gtt.o
 obj-$(CONFIG_AGP_NVIDIA)	+= nvidia-agp.o
-obj-$(CONFIG_AGP_SGI_TIOCA)	+= sgi-agp.o
 obj-$(CONFIG_AGP_SIS)		+= sis-agp.o
 obj-$(CONFIG_AGP_SWORKS)	+= sworks-agp.o
 obj-$(CONFIG_AGP_UNINORTH)	+= uninorth-agp.o
diff --git a/drivers/char/agp/sgi-agp.c b/drivers/char/agp/sgi-agp.c
deleted file mode 100644
index e7d5bdc02d93..000000000000
--- a/drivers/char/agp/sgi-agp.c
+++ /dev/null
@@ -1,338 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2003-2005 Silicon Graphics, Inc.  All Rights Reserved.
- */
-
-/*
- * SGI TIOCA AGPGART routines.
- *
- */
-
-#include <linux/acpi.h>
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/slab.h>
-#include <linux/agp_backend.h>
-#include <asm/sn/addrs.h>
-#include <asm/sn/io.h>
-#include <asm/sn/pcidev.h>
-#include <asm/sn/pcibus_provider_defs.h>
-#include <asm/sn/tioca_provider.h>
-#include "agp.h"
-
-extern int agp_memory_reserved;
-extern uint32_t tioca_gart_found;
-extern struct list_head tioca_list;
-static struct agp_bridge_data **sgi_tioca_agp_bridges;
-
-/*
- * The aperature size and related information is set up at TIOCA init time.
- * Values for this table will be extracted and filled in at
- * sgi_tioca_fetch_size() time.
- */
-
-static struct aper_size_info_fixed sgi_tioca_sizes[] = {
-	{0, 0, 0},
-};
-
-static struct page *sgi_tioca_alloc_page(struct agp_bridge_data *bridge)
-{
-	struct page *page;
-	int nid;
-	struct tioca_kernel *info =
-	    (struct tioca_kernel *)bridge->dev_private_data;
-
-	nid = info->ca_closest_node;
-	page = alloc_pages_node(nid, GFP_KERNEL, 0);
-	if (!page)
-		return NULL;
-
-	get_page(page);
-	atomic_inc(&agp_bridge->current_memory_agp);
-	return page;
-}
-
-/*
- * Flush GART tlb's.  Cannot selectively flush based on memory so the mem
- * arg is ignored.
- */
-
-static void sgi_tioca_tlbflush(struct agp_memory *mem)
-{
-	tioca_tlbflush(mem->bridge->dev_private_data);
-}
-
-/*
- * Given an address of a host physical page, turn it into a valid gart
- * entry.
- */
-static unsigned long
-sgi_tioca_mask_memory(struct agp_bridge_data *bridge, dma_addr_t addr,
-		      int type)
-{
-	return tioca_physpage_to_gart(addr);
-}
-
-static void sgi_tioca_agp_enable(struct agp_bridge_data *bridge, u32 mode)
-{
-	tioca_fastwrite_enable(bridge->dev_private_data);
-}
-
-/*
- * sgi_tioca_configure() doesn't have anything to do since the base CA driver
- * has alreay set up the GART.
- */
-
-static int sgi_tioca_configure(void)
-{
-	return 0;
-}
-
-/*
- * Determine gfx aperature size.  This has already been determined by the
- * CA driver init, so just need to set agp_bridge values accordingly.
- */
-
-static int sgi_tioca_fetch_size(void)
-{
-	struct tioca_kernel *info =
-	    (struct tioca_kernel *)agp_bridge->dev_private_data;
-
-	sgi_tioca_sizes[0].size = info->ca_gfxap_size / MB(1);
-	sgi_tioca_sizes[0].num_entries = info->ca_gfxgart_entries;
-
-	return sgi_tioca_sizes[0].size;
-}
-
-static int sgi_tioca_create_gatt_table(struct agp_bridge_data *bridge)
-{
-	struct tioca_kernel *info =
-	    (struct tioca_kernel *)bridge->dev_private_data;
-
-	bridge->gatt_table_real = (u32 *) info->ca_gfxgart;
-	bridge->gatt_table = bridge->gatt_table_real;
-	bridge->gatt_bus_addr = info->ca_gfxgart_base;
-
-	return 0;
-}
-
-static int sgi_tioca_free_gatt_table(struct agp_bridge_data *bridge)
-{
-	return 0;
-}
-
-static int sgi_tioca_insert_memory(struct agp_memory *mem, off_t pg_start,
-				   int type)
-{
-	int num_entries;
-	size_t i;
-	off_t j;
-	void *temp;
-	struct agp_bridge_data *bridge;
-	u64 *table;
-
-	bridge = mem->bridge;
-	if (!bridge)
-		return -EINVAL;
-
-	table = (u64 *)bridge->gatt_table;
-
-	temp = bridge->current_size;
-
-	switch (bridge->driver->size_type) {
-	case U8_APER_SIZE:
-		num_entries = A_SIZE_8(temp)->num_entries;
-		break;
-	case U16_APER_SIZE:
-		num_entries = A_SIZE_16(temp)->num_entries;
-		break;
-	case U32_APER_SIZE:
-		num_entries = A_SIZE_32(temp)->num_entries;
-		break;
-	case FIXED_APER_SIZE:
-		num_entries = A_SIZE_FIX(temp)->num_entries;
-		break;
-	case LVL2_APER_SIZE:
-		return -EINVAL;
-	default:
-		num_entries = 0;
-		break;
-	}
-
-	num_entries -= agp_memory_reserved / PAGE_SIZE;
-	if (num_entries < 0)
-		num_entries = 0;
-
-	if (type != 0 || mem->type != 0) {
-		return -EINVAL;
-	}
-
-	if ((pg_start + mem->page_count) > num_entries)
-		return -EINVAL;
-
-	j = pg_start;
-
-	while (j < (pg_start + mem->page_count)) {
-		if (table[j])
-			return -EBUSY;
-		j++;
-	}
-
-	if (!mem->is_flushed) {
-		bridge->driver->cache_flush();
-		mem->is_flushed = true;
-	}
-
-	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
-		table[j] =
-		    bridge->driver->mask_memory(bridge,
-						page_to_phys(mem->pages[i]),
-						mem->type);
-	}
-
-	bridge->driver->tlb_flush(mem);
-	return 0;
-}
-
-static int sgi_tioca_remove_memory(struct agp_memory *mem, off_t pg_start,
-				   int type)
-{
-	size_t i;
-	struct agp_bridge_data *bridge;
-	u64 *table;
-
-	bridge = mem->bridge;
-	if (!bridge)
-		return -EINVAL;
-
-	if (type != 0 || mem->type != 0) {
-		return -EINVAL;
-	}
-
-	table = (u64 *)bridge->gatt_table;
-
-	for (i = pg_start; i < (mem->page_count + pg_start); i++) {
-		table[i] = 0;
-	}
-
-	bridge->driver->tlb_flush(mem);
-	return 0;
-}
-
-static void sgi_tioca_cache_flush(void)
-{
-}
-
-/*
- * Cleanup.  Nothing to do as the CA driver owns the GART.
- */
-
-static void sgi_tioca_cleanup(void)
-{
-}
-
-static struct agp_bridge_data *sgi_tioca_find_bridge(struct pci_dev *pdev)
-{
-	struct agp_bridge_data *bridge;
-
-	list_for_each_entry(bridge, &agp_bridges, list) {
-		if (bridge->dev->bus == pdev->bus)
-			break;
-	}
-	return bridge;
-}
-
-const struct agp_bridge_driver sgi_tioca_driver = {
-	.owner = THIS_MODULE,
-	.size_type = U16_APER_SIZE,
-	.configure = sgi_tioca_configure,
-	.fetch_size = sgi_tioca_fetch_size,
-	.cleanup = sgi_tioca_cleanup,
-	.tlb_flush = sgi_tioca_tlbflush,
-	.mask_memory = sgi_tioca_mask_memory,
-	.agp_enable = sgi_tioca_agp_enable,
-	.cache_flush = sgi_tioca_cache_flush,
-	.create_gatt_table = sgi_tioca_create_gatt_table,
-	.free_gatt_table = sgi_tioca_free_gatt_table,
-	.insert_memory = sgi_tioca_insert_memory,
-	.remove_memory = sgi_tioca_remove_memory,
-	.alloc_by_type = agp_generic_alloc_by_type,
-	.free_by_type = agp_generic_free_by_type,
-	.agp_alloc_page = sgi_tioca_alloc_page,
-	.agp_destroy_page = agp_generic_destroy_page,
-	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
-	.cant_use_aperture = true,
-	.needs_scratch_page = false,
-	.num_aperture_sizes = 1,
-};
-
-static int agp_sgi_init(void)
-{
-	unsigned int j;
-	struct tioca_kernel *info;
-	struct pci_dev *pdev = NULL;
-
-	if (tioca_gart_found)
-		printk(KERN_INFO PFX "SGI TIO CA GART driver initialized.\n");
-	else
-		return 0;
-
-	sgi_tioca_agp_bridges = kmalloc_array(tioca_gart_found,
-					      sizeof(struct agp_bridge_data *),
-					      GFP_KERNEL);
-	if (!sgi_tioca_agp_bridges)
-		return -ENOMEM;
-
-	j = 0;
-	list_for_each_entry(info, &tioca_list, ca_list) {
-		if (list_empty(info->ca_devices))
-			continue;
-		list_for_each_entry(pdev, info->ca_devices, bus_list) {
-			u8 cap_ptr;
-
-			if (pdev->class != (PCI_CLASS_DISPLAY_VGA << 8))
-				continue;
-			cap_ptr = pci_find_capability(pdev, PCI_CAP_ID_AGP);
-			if (!cap_ptr)
-				continue;
-		}
-		sgi_tioca_agp_bridges[j] = agp_alloc_bridge();
-		printk(KERN_INFO PFX "bridge %d = 0x%p\n", j,
-		       sgi_tioca_agp_bridges[j]);
-		if (sgi_tioca_agp_bridges[j]) {
-			sgi_tioca_agp_bridges[j]->dev = pdev;
-			sgi_tioca_agp_bridges[j]->dev_private_data = info;
-			sgi_tioca_agp_bridges[j]->driver = &sgi_tioca_driver;
-			sgi_tioca_agp_bridges[j]->gart_bus_addr =
-			    info->ca_gfxap_base;
-			sgi_tioca_agp_bridges[j]->mode = (0x7D << 24) |	/* 126 requests */
-			    (0x1 << 9) |	/* SBA supported */
-			    (0x1 << 5) |	/* 64-bit addresses supported */
-			    (0x1 << 4) |	/* FW supported */
-			    (0x1 << 3) |	/* AGP 3.0 mode */
-			    0x2;	/* 8x transfer only */
-			sgi_tioca_agp_bridges[j]->current_size =
-			    sgi_tioca_agp_bridges[j]->previous_size =
-			    (void *)&sgi_tioca_sizes[0];
-			agp_add_bridge(sgi_tioca_agp_bridges[j]);
-		}
-		j++;
-	}
-
-	agp_find_bridge = &sgi_tioca_find_bridge;
-	return 0;
-}
-
-static void agp_sgi_cleanup(void)
-{
-	kfree(sgi_tioca_agp_bridges);
-	sgi_tioca_agp_bridges = NULL;
-}
-
-module_init(agp_sgi_init);
-module_exit(agp_sgi_cleanup);
-
-MODULE_LICENSE("GPL and additional rights");
-- 
2.20.1

