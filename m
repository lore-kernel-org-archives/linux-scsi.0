From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 2/2] Remove dma_coherent_mem interface
Date: Tue, 30 Oct 2007 15:43:25 -0400
Message-ID: <1193773405-15799-2-git-send-email-matthew@wil.cx>
References: <1193773405-15799-1-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:32919 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbXJ3Tnn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 15:43:43 -0400
In-Reply-To: <1193773405-15799-1-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, linux-scsi@vger.kernel.org, jejb@steeleye.com
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

This interface only had one user (and two implementations).
It complicates other work, so remove it.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 Documentation/DMA-API.txt             |   78 ------------------------
 Documentation/driver-model/devres.txt |    1 -
 arch/cris/arch-v32/drivers/pci/dma.c  |  106 +--------------------------------
 arch/x86/kernel/pci-dma_32.c          |  108 +--------------------------------
 drivers/base/dma-mapping.c            |   55 -----------------
 include/asm-cris/dma-mapping.h        |   14 ----
 include/asm-mips/dma-mapping.h        |   10 ---
 include/asm-x86/dma-mapping_32.h      |   12 ----
 include/linux/device.h                |    2 -
 include/linux/dma-mapping.h           |   39 ------------
 10 files changed, 2 insertions(+), 423 deletions(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index b939ebb..9cebf5b 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -469,81 +469,3 @@ Do a partial sync of memory that was allocated by
 dma_alloc_noncoherent(), starting at virtual address vaddr and
 continuing on for size.  Again, you *must* observe the cache line
 boundaries when doing this.
-
-int
-dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-			    dma_addr_t device_addr, size_t size, int
-			    flags)
-
-Declare region of memory to be handed out by dma_alloc_coherent when
-it's asked for coherent memory for this device.
-
-bus_addr is the physical address to which the memory is currently
-assigned in the bus responding region (this will be used by the
-platform to perform the mapping).
-
-device_addr is the physical address the device needs to be programmed
-with actually to address this memory (this will be handed out as the
-dma_addr_t in dma_alloc_coherent()).
-
-size is the size of the area (must be multiples of PAGE_SIZE).
-
-flags can be or'd together and are:
-
-DMA_MEMORY_MAP - request that the memory returned from
-dma_alloc_coherent() be directly writable.
-
-DMA_MEMORY_IO - request that the memory returned from
-dma_alloc_coherent() be addressable using read/write/memcpy_toio etc.
-
-One or both of these flags must be present.
-
-DMA_MEMORY_INCLUDES_CHILDREN - make the declared memory be allocated by
-dma_alloc_coherent of any child devices of this one (for memory residing
-on a bridge).
-
-DMA_MEMORY_EXCLUSIVE - only allocate memory from the declared regions. 
-Do not allow dma_alloc_coherent() to fall back to system memory when
-it's out of memory in the declared region.
-
-The return value will be either DMA_MEMORY_MAP or DMA_MEMORY_IO and
-must correspond to a passed in flag (i.e. no returning DMA_MEMORY_IO
-if only DMA_MEMORY_MAP were passed in) for success or zero for
-failure.
-
-Note, for DMA_MEMORY_IO returns, all subsequent memory returned by
-dma_alloc_coherent() may no longer be accessed directly, but instead
-must be accessed using the correct bus functions.  If your driver
-isn't prepared to handle this contingency, it should not specify
-DMA_MEMORY_IO in the input flags.
-
-As a simplification for the platforms, only *one* such region of
-memory may be declared per device.
-
-For reasons of efficiency, most platforms choose to track the declared
-region only at the granularity of a page.  For smaller allocations,
-you should use the dma_pool() API.
-
-void
-dma_release_declared_memory(struct device *dev)
-
-Remove the memory region previously declared from the system.  This
-API performs *no* in-use checking for this region and will return
-unconditionally having removed all the required structures.  It is the
-driver's job to ensure that no parts of this memory region are
-currently in use.
-
-void *
-dma_mark_declared_memory_occupied(struct device *dev,
-				  dma_addr_t device_addr, size_t size)
-
-This is used to occupy specific regions of the declared space
-(dma_alloc_coherent() will hand out the first free region it finds).
-
-device_addr is the *device* address of the region requested.
-
-size is the size (and should be a page-sized multiple).
-
-The return value will be either a pointer to the processor virtual
-address of the memory, or an error (via PTR_ERR()) if any part of the
-region is occupied.
diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 387b8a7..24d74e9 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -248,7 +248,6 @@ DMA
   dmam_free_coherent()
   dmam_alloc_noncoherent()
   dmam_free_noncoherent()
-  dmam_declare_coherent_memory()
   dmam_pool_create()
   dmam_pool_destroy()
 
diff --git a/arch/cris/arch-v32/drivers/pci/dma.c b/arch/cris/arch-v32/drivers/pci/dma.c
index 66f9500..88954fd 100644
--- a/arch/cris/arch-v32/drivers/pci/dma.c
+++ b/arch/cris/arch-v32/drivers/pci/dma.c
@@ -15,36 +15,14 @@
 #include <linux/pci.h>
 #include <asm/io.h>
 
-struct dma_coherent_mem {
-	void		*virt_base;
-	u32		device_base;
-	int		size;
-	int		flags;
-	unsigned long	*bitmap;
-};
-
 void *dma_alloc_coherent(struct device *dev, size_t size,
 			   dma_addr_t *dma_handle, gfp_t gfp)
 {
 	void *ret;
-	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
 	int order = get_order(size);
 	/* ignore region specifiers */
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
 
-	if (mem) {
-		int page = bitmap_find_free_region(mem->bitmap, mem->size,
-						     order);
-		if (page >= 0) {
-			*dma_handle = mem->device_base + (page << PAGE_SHIFT);
-			ret = mem->virt_base + (page << PAGE_SHIFT);
-			memset(ret, 0, size);
-			return ret;
-		}
-		if (mem->flags & DMA_MEMORY_EXCLUSIVE)
-			return NULL;
-	}
-
 	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
 		gfp |= GFP_DMA;
 
@@ -60,88 +38,6 @@ void *dma_alloc_coherent(struct device *dev, size_t size,
 void dma_free_coherent(struct device *dev, size_t size,
 			 void *vaddr, dma_addr_t dma_handle)
 {
-	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
 	int order = get_order(size);
-
-	if (mem && vaddr >= mem->virt_base && vaddr < (mem->virt_base + (mem->size << PAGE_SHIFT))) {
-		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
-
-		bitmap_release_region(mem->bitmap, page, order);
-	} else
-		free_pages((unsigned long)vaddr, order);
-}
-
-int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-				dma_addr_t device_addr, size_t size, int flags)
-{
-	void __iomem *mem_base;
-	int pages = size >> PAGE_SHIFT;
-	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
-
-	if ((flags & (DMA_MEMORY_MAP | DMA_MEMORY_IO)) == 0)
-		goto out;
-	if (!size)
-		goto out;
-	if (dev->dma_mem)
-		goto out;
-
-	/* FIXME: this routine just ignores DMA_MEMORY_INCLUDES_CHILDREN */
-
-	mem_base = ioremap(bus_addr, size);
-	if (!mem_base)
-		goto out;
-
-	dev->dma_mem = kzalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
-	if (!dev->dma_mem)
-		goto out;
-	dev->dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
-	if (!dev->dma_mem->bitmap)
-		goto free1_out;
-
-	dev->dma_mem->virt_base = mem_base;
-	dev->dma_mem->device_base = device_addr;
-	dev->dma_mem->size = pages;
-	dev->dma_mem->flags = flags;
-
-	if (flags & DMA_MEMORY_MAP)
-		return DMA_MEMORY_MAP;
-
-	return DMA_MEMORY_IO;
-
- free1_out:
-	kfree(dev->dma_mem);
- out:
-	return 0;
-}
-EXPORT_SYMBOL(dma_declare_coherent_memory);
-
-void dma_release_declared_memory(struct device *dev)
-{
-	struct dma_coherent_mem *mem = dev->dma_mem;
-
-	if(!mem)
-		return;
-	dev->dma_mem = NULL;
-	iounmap(mem->virt_base);
-	kfree(mem->bitmap);
-	kfree(mem);
-}
-EXPORT_SYMBOL(dma_release_declared_memory);
-
-void *dma_mark_declared_memory_occupied(struct device *dev,
-					dma_addr_t device_addr, size_t size)
-{
-	struct dma_coherent_mem *mem = dev->dma_mem;
-	int pages = (size + (device_addr & ~PAGE_MASK) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	int pos, err;
-
-	if (!mem)
-		return ERR_PTR(-EINVAL);
-
-	pos = (device_addr - mem->device_base) >> PAGE_SHIFT;
-	err = bitmap_allocate_region(mem->bitmap, pos, get_order(pages));
-	if (err != 0)
-		return ERR_PTR(err);
-	return mem->virt_base + (pos << PAGE_SHIFT);
+	free_pages((unsigned long)vaddr, order);
 }
-EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
index 5133032..028cbd5 100644
--- a/arch/x86/kernel/pci-dma_32.c
+++ b/arch/x86/kernel/pci-dma_32.c
@@ -14,36 +14,13 @@
 #include <linux/module.h>
 #include <asm/io.h>
 
-struct dma_coherent_mem {
-	void		*virt_base;
-	u32		device_base;
-	int		size;
-	int		flags;
-	unsigned long	*bitmap;
-};
-
 void *dma_alloc_coherent(struct device *dev, size_t size,
 			   dma_addr_t *dma_handle, gfp_t gfp)
 {
 	void *ret;
-	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
 	int order = get_order(size);
 	/* ignore region specifiers */
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
-
-	if (mem) {
-		int page = bitmap_find_free_region(mem->bitmap, mem->size,
-						     order);
-		if (page >= 0) {
-			*dma_handle = mem->device_base + (page << PAGE_SHIFT);
-			ret = mem->virt_base + (page << PAGE_SHIFT);
-			memset(ret, 0, size);
-			return ret;
-		}
-		if (mem->flags & DMA_MEMORY_EXCLUSIVE)
-			return NULL;
-	}
-
 	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
 		gfp |= GFP_DMA;
 
@@ -60,96 +37,13 @@ EXPORT_SYMBOL(dma_alloc_coherent);
 void dma_free_coherent(struct device *dev, size_t size,
 			 void *vaddr, dma_addr_t dma_handle)
 {
-	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
 	int order = get_order(size);
 
 	WARN_ON(irqs_disabled());	/* for portability */
-	if (mem && vaddr >= mem->virt_base && vaddr < (mem->virt_base + (mem->size << PAGE_SHIFT))) {
-		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
-
-		bitmap_release_region(mem->bitmap, page, order);
-	} else
-		free_pages((unsigned long)vaddr, order);
+	free_pages((unsigned long)vaddr, order);
 }
 EXPORT_SYMBOL(dma_free_coherent);
 
-int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-				dma_addr_t device_addr, size_t size, int flags)
-{
-	void __iomem *mem_base = NULL;
-	int pages = size >> PAGE_SHIFT;
-	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
-
-	if ((flags & (DMA_MEMORY_MAP | DMA_MEMORY_IO)) == 0)
-		goto out;
-	if (!size)
-		goto out;
-	if (dev->dma_mem)
-		goto out;
-
-	/* FIXME: this routine just ignores DMA_MEMORY_INCLUDES_CHILDREN */
-
-	mem_base = ioremap(bus_addr, size);
-	if (!mem_base)
-		goto out;
-
-	dev->dma_mem = kzalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
-	if (!dev->dma_mem)
-		goto out;
-	dev->dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
-	if (!dev->dma_mem->bitmap)
-		goto free1_out;
-
-	dev->dma_mem->virt_base = mem_base;
-	dev->dma_mem->device_base = device_addr;
-	dev->dma_mem->size = pages;
-	dev->dma_mem->flags = flags;
-
-	if (flags & DMA_MEMORY_MAP)
-		return DMA_MEMORY_MAP;
-
-	return DMA_MEMORY_IO;
-
- free1_out:
-	kfree(dev->dma_mem);
- out:
-	if (mem_base)
-		iounmap(mem_base);
-	return 0;
-}
-EXPORT_SYMBOL(dma_declare_coherent_memory);
-
-void dma_release_declared_memory(struct device *dev)
-{
-	struct dma_coherent_mem *mem = dev->dma_mem;
-	
-	if(!mem)
-		return;
-	dev->dma_mem = NULL;
-	iounmap(mem->virt_base);
-	kfree(mem->bitmap);
-	kfree(mem);
-}
-EXPORT_SYMBOL(dma_release_declared_memory);
-
-void *dma_mark_declared_memory_occupied(struct device *dev,
-					dma_addr_t device_addr, size_t size)
-{
-	struct dma_coherent_mem *mem = dev->dma_mem;
-	int pages = (size + (device_addr & ~PAGE_MASK) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	int pos, err;
-
-	if (!mem)
-		return ERR_PTR(-EINVAL);
-
-	pos = (device_addr - mem->device_base) >> PAGE_SHIFT;
-	err = bitmap_allocate_region(mem->bitmap, pos, get_order(pages));
-	if (err != 0)
-		return ERR_PTR(err);
-	return mem->virt_base + (pos << PAGE_SHIFT);
-}
-EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
-
 #ifdef CONFIG_PCI
 /* Many VIA bridges seem to corrupt data for DAC. Disable it here */
 
diff --git a/drivers/base/dma-mapping.c b/drivers/base/dma-mapping.c
index ca9186f..7778ef7 100644
--- a/drivers/base/dma-mapping.c
+++ b/drivers/base/dma-mapping.c
@@ -161,58 +161,3 @@ void dmam_free_noncoherent(struct device *dev, size_t size, void *vaddr,
 				&match_data));
 }
 EXPORT_SYMBOL(dmam_free_noncoherent);
-
-#ifdef ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
-
-static void dmam_coherent_decl_release(struct device *dev, void *res)
-{
-	dma_release_declared_memory(dev);
-}
-
-/**
- * dmam_declare_coherent_memory - Managed dma_declare_coherent_memory()
- * @dev: Device to declare coherent memory for
- * @bus_addr: Bus address of coherent memory to be declared
- * @device_addr: Device address of coherent memory to be declared
- * @size: Size of coherent memory to be declared
- * @flags: Flags
- *
- * Managed dma_declare_coherent_memory().
- *
- * RETURNS:
- * 0 on success, -errno on failure.
- */
-int dmam_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-				 dma_addr_t device_addr, size_t size, int flags)
-{
-	void *res;
-	int rc;
-
-	res = devres_alloc(dmam_coherent_decl_release, 0, GFP_KERNEL);
-	if (!res)
-		return -ENOMEM;
-
-	rc = dma_declare_coherent_memory(dev, bus_addr, device_addr, size,
-					 flags);
-	if (rc == 0)
-		devres_add(dev, res);
-	else
-		devres_free(res);
-
-	return rc;
-}
-EXPORT_SYMBOL(dmam_declare_coherent_memory);
-
-/**
- * dmam_release_declared_memory - Managed dma_release_declared_memory().
- * @dev: Device to release declared coherent memory for
- *
- * Managed dmam_release_declared_memory().
- */
-void dmam_release_declared_memory(struct device *dev)
-{
-	WARN_ON(devres_destroy(dev, dmam_coherent_decl_release, NULL, NULL));
-}
-EXPORT_SYMBOL(dmam_release_declared_memory);
-
-#endif
diff --git a/include/asm-cris/dma-mapping.h b/include/asm-cris/dma-mapping.h
index 662cea7..5f17836 100644
--- a/include/asm-cris/dma-mapping.h
+++ b/include/asm-cris/dma-mapping.h
@@ -163,17 +163,3 @@ dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction)
 {
 }
-
-#define ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
-extern int
-dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-			    dma_addr_t device_addr, size_t size, int flags);
-
-extern void
-dma_release_declared_memory(struct device *dev);
-
-extern void *
-dma_mark_declared_memory_occupied(struct device *dev,
-				  dma_addr_t device_addr, size_t size);
-
-#endif
diff --git a/include/asm-mips/dma-mapping.h b/include/asm-mips/dma-mapping.h
index 230b3f1..8364dce 100644
--- a/include/asm-mips/dma-mapping.h
+++ b/include/asm-mips/dma-mapping.h
@@ -68,14 +68,4 @@ extern int dma_is_consistent(struct device *dev, dma_addr_t dma_addr);
 extern void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction);
 
-#if 0
-#define ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
-
-extern int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-	dma_addr_t device_addr, size_t size, int flags);
-extern void dma_release_declared_memory(struct device *dev);
-extern void * dma_mark_declared_memory_occupied(struct device *dev,
-	dma_addr_t device_addr, size_t size);
-#endif
-
 #endif /* _ASM_DMA_MAPPING_H */
diff --git a/include/asm-x86/dma-mapping_32.h b/include/asm-x86/dma-mapping_32.h
index 55f01bd..215eced 100644
--- a/include/asm-x86/dma-mapping_32.h
+++ b/include/asm-x86/dma-mapping_32.h
@@ -172,16 +172,4 @@ dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	flush_write_buffers();
 }
 
-#define ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
-extern int
-dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-			    dma_addr_t device_addr, size_t size, int flags);
-
-extern void
-dma_release_declared_memory(struct device *dev);
-
-extern void *
-dma_mark_declared_memory_occupied(struct device *dev,
-				  dma_addr_t device_addr, size_t size);
-
 #endif
diff --git a/include/linux/device.h b/include/linux/device.h
index 2e15822..a2775ff 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -434,8 +434,6 @@ struct device {
 
 	struct list_head	dma_pools;	/* dma pools (if dma'ble) */
 
-	struct dma_coherent_mem	*dma_mem; /* internal for coherent mem
-					     override */
 	/* arch specific additions */
 	struct dev_archdata	archdata;
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 101a2d4..b672c89 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -66,27 +66,6 @@ extern u64 dma_get_required_mask(struct device *dev);
 #define DMA_MEMORY_INCLUDES_CHILDREN	0x04
 #define DMA_MEMORY_EXCLUSIVE		0x08
 
-#ifndef ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
-static inline int
-dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-			    dma_addr_t device_addr, size_t size, int flags)
-{
-	return 0;
-}
-
-static inline void
-dma_release_declared_memory(struct device *dev)
-{
-}
-
-static inline void *
-dma_mark_declared_memory_occupied(struct device *dev,
-				  dma_addr_t device_addr, size_t size)
-{
-	return ERR_PTR(-EBUSY);
-}
-#endif
-
 /*
  * Managed DMA API
  */
@@ -98,22 +77,4 @@ extern void *dmam_alloc_noncoherent(struct device *dev, size_t size,
 				    dma_addr_t *dma_handle, gfp_t gfp);
 extern void dmam_free_noncoherent(struct device *dev, size_t size, void *vaddr,
 				  dma_addr_t dma_handle);
-#ifdef ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
-extern int dmam_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-					dma_addr_t device_addr, size_t size,
-					int flags);
-extern void dmam_release_declared_memory(struct device *dev);
-#else /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
-static inline int dmam_declare_coherent_memory(struct device *dev,
-				dma_addr_t bus_addr, dma_addr_t device_addr,
-				size_t size, gfp_t gfp)
-{
-	return 0;
-}
-
-static inline void dmam_release_declared_memory(struct device *dev)
-{
-}
-#endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
-
 #endif
-- 
1.5.3.4

