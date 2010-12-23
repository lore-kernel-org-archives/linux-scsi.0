From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH] dma_declare_coherent_memory: push ioremap() up to caller
Date: Fri, 24 Dec 2010 00:20:32 +0100
Message-ID: <201012240020.37208.jkrzyszt@tis.icnet.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: linux-arch@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Russell King - ARM Linux <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, Dan Williams <dan.j.williams@intel.com>, linux-sh@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>, Sascha Hauer <kernel@pengutronix.de>, linux-usb@vger.kernel.org, David Brownell <dbrownell@users.sourceforge.net>, linux-media@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-scsi@vger.kernel.org

The patch tries to implement a solution suggested by Russell King, 
http://lists.infradead.org/pipermail/linux-arm-kernel/2010-December/035264.html. 
It is expected to solve video buffer allocation issues for at least a 
few soc_camera I/O memory less host interface drivers, designed around 
the videobuf_dma_contig layer, which allocates video buffers using 
dma_alloc_coherent().

Created against linux-2.6.37-rc5.

Tested on ARM OMAP1 based Amstrad Delta with a WIP OMAP1 camera patch, 
patterned upon two mach-mx3 machine types which already try to use the 
dma_declare_coherent_memory() method for reserving a region of system 
RAM preallocated with another dma_alloc_coherent(). Compile tested for 
all modified files except arch/sh/drivers/pci/fixups-dreamcast.c.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
I intended to quote Russell in my commit message and even asked him for 
his permission, but since he didn't respond, I decided to include a link 
to his original message only.

 Documentation/DMA-API.txt                  |   18 +++++++----
 arch/arm/mach-mx3/mach-mx31moboard.c       |    2 -
 arch/arm/mach-mx3/mach-pcm037.c            |    2 -
 arch/sh/drivers/pci/fixups-dreamcast.c     |    6 +++
 drivers/base/dma-coherent.c                |   12 +------
 drivers/base/dma-mapping.c                 |    4 +-
 drivers/media/video/sh_mobile_ceu_camera.c |   20 +++++++++++-
 drivers/scsi/NCR_Q720.c                    |   15 +++++++--
 drivers/usb/gadget/langwell_udc.c          |   25 ++++++++++++----
 drivers/usb/gadget/langwell_udc.h          |    1
 drivers/usb/host/ohci-sm501.c              |   45 ++++++++++++++++++++---------
 drivers/usb/host/ohci-tmio.c               |   14 ++++++++-
 include/asm-generic/dma-coherent.h         |    2 -
 include/linux/dma-mapping.h                |    6 +--
 14 files changed, 122 insertions(+), 50 deletions(-)

--- linux-2.6.37-rc5/include/linux/dma-mapping.h.orig	2010-12-09 23:09:05.000000000 +0100
+++ linux-2.6.37-rc5/include/linux/dma-mapping.h	2010-12-23 18:32:24.000000000 +0100
@@ -164,7 +164,7 @@ static inline int dma_get_cache_alignmen
 
 #ifndef ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
 static inline int
-dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
+dma_declare_coherent_memory(struct device *dev, void *virt_addr,
 			    dma_addr_t device_addr, size_t size, int flags)
 {
 	return 0;
@@ -195,13 +195,13 @@ extern void *dmam_alloc_noncoherent(stru
 extern void dmam_free_noncoherent(struct device *dev, size_t size, void *vaddr,
 				  dma_addr_t dma_handle);
 #ifdef ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
-extern int dmam_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
+extern int dmam_declare_coherent_memory(struct device *dev, void *virt_addr,
 					dma_addr_t device_addr, size_t size,
 					int flags);
 extern void dmam_release_declared_memory(struct device *dev);
 #else /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
 static inline int dmam_declare_coherent_memory(struct device *dev,
-				dma_addr_t bus_addr, dma_addr_t device_addr,
+				void *virt_addr, dma_addr_t device_addr,
 				size_t size, gfp_t gfp)
 {
 	return 0;
--- linux-2.6.37-rc5/include/asm-generic/dma-coherent.h.orig	2010-12-09 23:09:04.000000000 +0100
+++ linux-2.6.37-rc5/include/asm-generic/dma-coherent.h	2010-12-23 18:32:24.000000000 +0100
@@ -15,7 +15,7 @@ int dma_release_from_coherent(struct dev
  */
 #define ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
 extern int
-dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
+dma_declare_coherent_memory(struct device *dev, void *virt_addr,
 			    dma_addr_t device_addr, size_t size, int flags);
 
 extern void
--- linux-2.6.37-rc5/Documentation/DMA-API.txt.orig	2010-12-09 23:07:27.000000000 +0100
+++ linux-2.6.37-rc5/Documentation/DMA-API.txt	2010-12-23 18:32:24.000000000 +0100
@@ -477,20 +477,25 @@ continuing on for size.  Again, you *mus
 boundaries when doing this.
 
 int
-dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
+dma_declare_coherent_memory(struct device *dev, void *virt_addr,
 			    dma_addr_t device_addr, size_t size, int
 			    flags)
 
 Declare region of memory to be handed out by dma_alloc_coherent when
 it's asked for coherent memory for this device.
 
-bus_addr is the physical address to which the memory is currently
-assigned in the bus responding region (this will be used by the
-platform to perform the mapping).
+virt_addr is the virtual address to which the pysical memory in the bus
+responding region is currently mapped (this will be handed out by
+dma_alloc_coherent() directly as its return value). Both a pointer to
+the ioremaped memory on the peripheral's bus, as well as a
+dma_alloc_coherent() obtained pointer to a host memory region can be
+cached.
 
 device_addr is the physical address the device needs to be programmed
 with actually to address this memory (this will be handed out as the
-dma_addr_t in dma_alloc_coherent()).
+dma_addr_t in dma_alloc_coherent()). Either the peripheral's memory
+physical address or a dma_alloc_coherent() obtained host memory region's
+dma handle is passed.
 
 size is the size of the area (must be multiples of PAGE_SIZE).
 
@@ -537,7 +542,8 @@ Remove the memory region previously decl
 API performs *no* in-use checking for this region and will return
 unconditionally having removed all the required structures.  It is the
 driver's job to ensure that no parts of this memory region are
-currently in use.
+currently in use. The driver should also revert any memory mapping done
+in preparation for dma_declare_coherent_memory().
 
 void *
 dma_mark_declared_memory_occupied(struct device *dev,
--- linux-2.6.37-rc5/arch/sh/drivers/pci/fixups-dreamcast.c.orig	2010-12-09 23:07:50.000000000 +0100
+++ linux-2.6.37-rc5/arch/sh/drivers/pci/fixups-dreamcast.c	2010-12-23 20:44:27.000000000 +0100
@@ -31,6 +31,7 @@
 static void __init gapspci_fixup_resources(struct pci_dev *dev)
 {
 	struct pci_channel *p = dev->sysdata;
+	void __iomem *virt_base;
 
 	printk(KERN_NOTICE "PCI: Fixing up device %s\n", pci_name(dev));
 
@@ -51,8 +52,11 @@ static void __init gapspci_fixup_resourc
 		/*
 		 * Redirect dma memory allocations to special memory window.
 		 */
+		virt_base = ioremap(GAPSPCI_DMA_BASE, GAPSPCI_DMA_SIZE);
+		BUG_ON(!virt_base);
+
 		BUG_ON(!dma_declare_coherent_memory(&dev->dev,
-						GAPSPCI_DMA_BASE,
+						virt_base,
 						GAPSPCI_DMA_BASE,
 						GAPSPCI_DMA_SIZE,
 						DMA_MEMORY_MAP |
--- linux-2.6.37-rc5/arch/arm/mach-mx3/mach-pcm037.c.orig	2010-12-09 23:07:34.000000000 +0100
+++ linux-2.6.37-rc5/arch/arm/mach-mx3/mach-pcm037.c	2010-12-23 18:32:24.000000000 +0100
@@ -431,7 +431,7 @@ static int __init pcm037_camera_alloc_dm
 	memset(buf, 0, buf_size);
 
 	dma = dma_declare_coherent_memory(&mx3_camera.dev,
-					dma_handle, dma_handle, buf_size,
+					buf, dma_handle, buf_size,
 					DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
 
 	/* The way we call dma_declare_coherent_memory only a malloc can fail */
--- linux-2.6.37-rc5/arch/arm/mach-mx3/mach-mx31moboard.c.orig	2010-12-09 23:07:34.000000000 +0100
+++ linux-2.6.37-rc5/arch/arm/mach-mx3/mach-mx31moboard.c	2010-12-23 18:32:24.000000000 +0100
@@ -486,7 +486,7 @@ static int __init mx31moboard_cam_alloc_
 	memset(buf, 0, buf_size);
 
 	dma = dma_declare_coherent_memory(&mx3_camera.dev,
-					dma_handle, dma_handle, buf_size,
+					buf, dma_handle, buf_size,
 					DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
 
 	/* The way we call dma_declare_coherent_memory only a malloc can fail */
--- linux-2.6.37-rc5/drivers/base/dma-mapping.c.orig	2010-12-09 23:08:03.000000000 +0100
+++ linux-2.6.37-rc5/drivers/base/dma-mapping.c	2010-12-23 18:32:24.000000000 +0100
@@ -183,7 +183,7 @@ static void dmam_coherent_decl_release(s
  * RETURNS:
  * 0 on success, -errno on failure.
  */
-int dmam_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
+int dmam_declare_coherent_memory(struct device *dev, void *virt_addr,
 				 dma_addr_t device_addr, size_t size, int flags)
 {
 	void *res;
@@ -193,7 +193,7 @@ int dmam_declare_coherent_memory(struct 
 	if (!res)
 		return -ENOMEM;
 
-	rc = dma_declare_coherent_memory(dev, bus_addr, device_addr, size,
+	rc = dma_declare_coherent_memory(dev, virt_addr, device_addr, size,
 					 flags);
 	if (rc == 0)
 		devres_add(dev, res);
--- linux-2.6.37-rc5/drivers/base/dma-coherent.c.orig	2010-12-09 23:08:03.000000000 +0100
+++ linux-2.6.37-rc5/drivers/base/dma-coherent.c	2010-12-23 18:32:24.000000000 +0100
@@ -14,10 +14,9 @@ struct dma_coherent_mem {
 	unsigned long	*bitmap;
 };
 
-int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
+int dma_declare_coherent_memory(struct device *dev, void *virt_addr,
 				dma_addr_t device_addr, size_t size, int flags)
 {
-	void __iomem *mem_base = NULL;
 	int pages = size >> PAGE_SHIFT;
 	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
 
@@ -30,10 +29,6 @@ int dma_declare_coherent_memory(struct d
 
 	/* FIXME: this routine just ignores DMA_MEMORY_INCLUDES_CHILDREN */
 
-	mem_base = ioremap(bus_addr, size);
-	if (!mem_base)
-		goto out;
-
 	dev->dma_mem = kzalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
 	if (!dev->dma_mem)
 		goto out;
@@ -41,7 +36,7 @@ int dma_declare_coherent_memory(struct d
 	if (!dev->dma_mem->bitmap)
 		goto free1_out;
 
-	dev->dma_mem->virt_base = mem_base;
+	dev->dma_mem->virt_base = virt_addr;
 	dev->dma_mem->device_base = device_addr;
 	dev->dma_mem->size = pages;
 	dev->dma_mem->flags = flags;
@@ -54,8 +49,6 @@ int dma_declare_coherent_memory(struct d
  free1_out:
 	kfree(dev->dma_mem);
  out:
-	if (mem_base)
-		iounmap(mem_base);
 	return 0;
 }
 EXPORT_SYMBOL(dma_declare_coherent_memory);
@@ -67,7 +60,6 @@ void dma_release_declared_memory(struct 
 	if (!mem)
 		return;
 	dev->dma_mem = NULL;
-	iounmap(mem->virt_base);
 	kfree(mem->bitmap);
 	kfree(mem);
 }
--- linux-2.6.37-rc5/drivers/usb/host/ohci-sm501.c.orig	2010-12-09 23:08:51.000000000 +0100
+++ linux-2.6.37-rc5/drivers/usb/host/ohci-sm501.c	2010-12-23 22:38:19.000000000 +0100
@@ -42,7 +42,8 @@ static int ohci_sm501_start(struct usb_h
 static const struct hc_driver ohci_sm501_hc_driver = {
 	.description =		hcd_name,
 	.product_desc =		"SM501 OHCI",
-	.hcd_priv_size =	sizeof(struct ohci_hcd),
+	.hcd_priv_size =	sizeof(struct ohci_hcd) +
+						sizeof(void __iomem *),
 
 	/*
 	 * generic hardware linkage
@@ -89,6 +90,8 @@ static int ohci_hcd_sm501_drv_probe(stru
 	const struct hc_driver *driver = &ohci_sm501_hc_driver;
 	struct device *dev = &pdev->dev;
 	struct resource	*res, *mem;
+	void __iomem *mem_vaddr;
+	void __iomem **mem_vaddr_p;
 	int retval, irq;
 	struct usb_hcd *hcd = NULL;
 
@@ -124,14 +127,21 @@ static int ohci_hcd_sm501_drv_probe(stru
 	 * regular memory. The HCD_LOCAL_MEM flag does just that.
 	 */
 
-	if (!dma_declare_coherent_memory(dev, mem->start,
+	mem_vaddr = ioremap(mem->start, mem->end - mem->start + 1);
+	if (!mem_vaddr) {
+		dev_err(dev, "ioremap failed\n");
+		retval = -EIO;
+		goto err1;
+	}
+
+	if (!dma_declare_coherent_memory(dev, mem_vaddr,
 					 mem->start - mem->parent->start,
 					 (mem->end - mem->start) + 1,
 					 DMA_MEMORY_MAP |
 					 DMA_MEMORY_EXCLUSIVE)) {
 		dev_err(dev, "cannot declare coherent memory\n");
 		retval = -ENXIO;
-		goto err1;
+		goto err2;
 	}
 
 	/* allocate, reserve and remap resources for registers */
@@ -139,36 +149,39 @@ static int ohci_hcd_sm501_drv_probe(stru
 	if (res == NULL) {
 		dev_err(dev, "no resource definition for registers\n");
 		retval = -ENOENT;
-		goto err2;
+		goto err3;
 	}
 
 	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
 	if (!hcd) {
 		retval = -ENOMEM;
-		goto err2;
+		goto err3;
 	}
 
+	mem_vaddr_p = (void __iomem **)(hcd_to_ohci(hcd) + 1);
+	*mem_vaddr_p = mem_vaddr;
+
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = res->end - res->start + 1;
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,	pdev->name)) {
 		dev_err(dev, "request_mem_region failed\n");
 		retval = -EBUSY;
-		goto err3;
+		goto err4;
 	}
 
 	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
 	if (hcd->regs == NULL) {
 		dev_err(dev, "cannot remap registers\n");
 		retval = -ENXIO;
-		goto err4;
+		goto err5;
 	}
 
 	ohci_hcd_init(hcd_to_ohci(hcd));
 
 	retval = usb_add_hcd(hcd, irq, IRQF_DISABLED | IRQF_SHARED);
 	if (retval)
-		goto err5;
+		goto err6;
 
 	/* enable power and unmask interrupts */
 
@@ -176,14 +189,16 @@ static int ohci_hcd_sm501_drv_probe(stru
 	sm501_modify_reg(dev->parent, SM501_IRQ_MASK, 1 << 6, 0);
 
 	return 0;
-err5:
+err6:
 	iounmap(hcd->regs);
-err4:
+err5:
 	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-err3:
+err4:
 	usb_put_hcd(hcd);
-err2:
+err3:
 	dma_release_declared_memory(dev);
+err2:
+	iounmap(mem_vaddr);
 err1:
 	release_mem_region(mem->start, mem->end - mem->start + 1);
 err0:
@@ -193,6 +208,7 @@ err0:
 static int ohci_hcd_sm501_drv_remove(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd = platform_get_drvdata(pdev);
+	void __iomem **mem_vaddr_p;
 	struct resource	*mem;
 
 	usb_remove_hcd(hcd);
@@ -200,8 +216,11 @@ static int ohci_hcd_sm501_drv_remove(str
 	usb_put_hcd(hcd);
 	dma_release_declared_memory(&pdev->dev);
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (mem)
+	if (mem) {
+		mem_vaddr_p = (void __iomem **)(hcd_to_ohci(hcd) + 1);
+		iounmap(*mem_vaddr_p);
 		release_mem_region(mem->start, mem->end - mem->start + 1);
+	}
 
 	/* mask interrupts and disable power */
 
--- linux-2.6.37-rc5/drivers/usb/host/ohci-tmio.c.orig	2010-12-09 23:08:51.000000000 +0100
+++ linux-2.6.37-rc5/drivers/usb/host/ohci-tmio.c	2010-12-23 22:40:45.000000000 +0100
@@ -67,6 +67,7 @@
 
 struct tmio_hcd {
 	void __iomem		*ccr;
+	void __iomem		*sram_vaddr;
 	spinlock_t		lock; /* protects RMW cycles */
 };
 
@@ -226,7 +227,13 @@ static int __devinit ohci_hcd_tmio_drv_p
 		goto err_ioremap_regs;
 	}
 
-	if (!dma_declare_coherent_memory(&dev->dev, sram->start,
+	tmio->sram_vaddr = ioremap(sram->start, sram->end - sram->start + 1);
+	if (!tmio->sram_vaddr) {
+		ret = -EIO;
+		goto err_ioremap_sram;
+	}
+
+	if (!dma_declare_coherent_memory(&dev->dev, tmio->sram_vaddr,
 				sram->start,
 				sram->end - sram->start + 1,
 				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE)) {
@@ -260,6 +267,8 @@ err_add_hcd:
 err_enable:
 	dma_release_declared_memory(&dev->dev);
 err_dma_declare:
+	iounmap(tmio->sram_vaddr);
+err_ioremap_sram:
 	iounmap(hcd->regs);
 err_ioremap_regs:
 	iounmap(tmio->ccr);
@@ -275,12 +284,15 @@ static int __devexit ohci_hcd_tmio_drv_r
 	struct usb_hcd *hcd = platform_get_drvdata(dev);
 	struct tmio_hcd *tmio = hcd_to_tmio(hcd);
 	struct mfd_cell *cell = dev->dev.platform_data;
+	struct resource *sram = platform_get_resource(dev, IORESOURCE_MEM, 2);
 
 	usb_remove_hcd(hcd);
 	tmio_stop_hc(dev);
 	if (cell->disable)
 		cell->disable(dev);
 	dma_release_declared_memory(&dev->dev);
+	if (sram)
+		iounmap(tmio->sram_vaddr);
 	iounmap(hcd->regs);
 	iounmap(tmio->ccr);
 	usb_put_hcd(hcd);
--- linux-2.6.37-rc5/drivers/usb/gadget/langwell_udc.c.orig	2010-12-09 23:08:46.000000000 +0100
+++ linux-2.6.37-rc5/drivers/usb/gadget/langwell_udc.c	2010-12-23 22:05:17.000000000 +0100
@@ -3024,14 +3024,26 @@ static void sram_init(struct langwell_ud
 
 	if (pci_request_region(pdev, 1, kobject_name(&pdev->dev.kobj))) {
 		dev_warn(&dev->pdev->dev, "SRAM request failed\n");
-		dev->got_sram = 0;
-	} else if (!dma_declare_coherent_memory(&pdev->dev, dev->sram_addr,
-			dev->sram_addr, dev->sram_size, DMA_MEMORY_MAP)) {
-		dev_warn(&dev->pdev->dev, "SRAM DMA declare failed\n");
-		pci_release_region(pdev, 1);
-		dev->got_sram = 0;
+		goto out_no_sram;
 	}
 
+	dev->sram_vaddr = ioremap(dev->sram_addr, dev->sram_size);
+	if (!dev->sram_vaddr) {
+		dev_warn(&dev->pdev->dev, "SRAM ioremap failed\n");
+		goto out_release;
+	}
+
+	if (dma_declare_coherent_memory(&pdev->dev, dev->sram_vaddr,
+			dev->sram_addr, dev->sram_size, DMA_MEMORY_MAP))
+		goto out;
+	dev_warn(&dev->pdev->dev, "SRAM DMA declare failed\n");
+
+	iounmap(dev->sram_vaddr);
+out_release:
+	pci_release_region(pdev, 1);
+out_no_sram:
+	dev->got_sram = 0;
+out:
 	dev_dbg(&dev->pdev->dev, "<--- %s()\n", __func__);
 }
 
@@ -3044,6 +3056,7 @@ static void sram_deinit(struct langwell_
 	dev_dbg(&dev->pdev->dev, "---> %s()\n", __func__);
 
 	dma_release_declared_memory(&pdev->dev);
+	iounmap(dev->sram_vaddr);
 	pci_release_region(pdev, 1);
 
 	dev->got_sram = 0;
--- linux-2.6.37-rc5/drivers/usb/gadget/langwell_udc.h.orig	2010-12-09 23:08:46.000000000 +0100
+++ linux-2.6.37-rc5/drivers/usb/gadget/langwell_udc.h	2010-12-23 22:03:56.000000000 +0100
@@ -226,6 +226,7 @@ struct langwell_udc {
 	/* for private SRAM caching */
 	unsigned int		sram_addr;
 	unsigned int		sram_size;
+	void __iomem		*sram_vaddr;
 
 	/* device status data for get_status request */
 	u16			dev_status;
--- linux-2.6.37-rc5/drivers/media/video/sh_mobile_ceu_camera.c.orig	2010-12-09 23:08:15.000000000 +0100
+++ linux-2.6.37-rc5/drivers/media/video/sh_mobile_ceu_camera.c	2010-12-23 22:21:25.000000000 +0100
@@ -97,6 +97,7 @@ struct sh_mobile_ceu_dev {
 
 	unsigned int irq;
 	void __iomem *base;
+	void __iomem *buf;
 	unsigned long video_limit;
 
 	/* lock used to protect videobuf */
@@ -1888,6 +1889,7 @@ static int __devinit sh_mobile_ceu_probe
 	struct sh_mobile_ceu_dev *pcdev;
 	struct resource *res;
 	void __iomem *base;
+	void __iomem *buf = NULL;
 	unsigned int irq;
 	int err = 0;
 	struct bus_wait wait = {
@@ -1934,7 +1936,14 @@ static int __devinit sh_mobile_ceu_probe
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (res) {
-		err = dma_declare_coherent_memory(&pdev->dev, res->start,
+		buf = ioremap(res->start, resource_size(res));
+		if (!buf) {
+			dev_err(&pdev->dev, "Unable to ioremap CEU memory.\n");
+			err = -ENXIO;
+			goto exit_iounmap_base;
+		}
+
+		err = dma_declare_coherent_memory(&pdev->dev, buf,
 						  res->start,
 						  resource_size(res),
 						  DMA_MEMORY_MAP |
@@ -1945,6 +1954,7 @@ static int __devinit sh_mobile_ceu_probe
 			goto exit_iounmap;
 		}
 
+		pcdev->buf = buf;
 		pcdev->video_limit = resource_size(res);
 	}
 
@@ -2021,6 +2031,9 @@ exit_release_mem:
 	if (platform_get_resource(pdev, IORESOURCE_MEM, 1))
 		dma_release_declared_memory(&pdev->dev);
 exit_iounmap:
+	if (buf)
+		iounmap(buf);
+exit_iounmap_base:
 	iounmap(base);
 exit_kfree:
 	kfree(pcdev);
@@ -2034,12 +2047,15 @@ static int __devexit sh_mobile_ceu_remov
 	struct sh_mobile_ceu_dev *pcdev = container_of(soc_host,
 					struct sh_mobile_ceu_dev, ici);
 	struct device *csi2 = pcdev->pdata->csi2_dev;
+	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 
 	soc_camera_host_unregister(soc_host);
 	pm_runtime_disable(&pdev->dev);
 	free_irq(pcdev->irq, pcdev);
-	if (platform_get_resource(pdev, IORESOURCE_MEM, 1))
+	if (res) {
 		dma_release_declared_memory(&pdev->dev);
+		iounmap(pcdev->buf);
+	}
 	iounmap(pcdev->base);
 	if (csi2 && csi2->driver)
 		module_put(csi2->driver->owner);
--- linux-2.6.37-rc5/drivers/scsi/NCR_Q720.c.orig	2010-12-09 23:08:35.000000000 +0100
+++ linux-2.6.37-rc5/drivers/scsi/NCR_Q720.c	2010-12-23 22:13:19.000000000 +0100
@@ -147,7 +147,7 @@ NCR_Q720_probe(struct device *dev)
 	__u8 pos2, pos4, asr2, asr9, asr10;
 	__u16 io_base;
 	__u32 base_addr, mem_size;
-	void __iomem *mem_base;
+	void __iomem *mem_base, *dma_mem_base;
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
@@ -216,11 +216,17 @@ NCR_Q720_probe(struct device *dev)
 		goto out_free;
 	}
 	
-	if (dma_declare_coherent_memory(dev, base_addr, base_addr,
+	dma_mem_base = ioremap(base_addr, mem_size);
+	if (!dma_mem_base) {
+		printk(KERN_ERR "NCR_Q720: ioremap DMA memory failed\n");
+		goto out_release_region;
+	}
+
+	if (dma_declare_coherent_memory(dev, dma_mem_base, base_addr,
 					mem_size, DMA_MEMORY_MAP)
 	    != DMA_MEMORY_MAP) {
 		printk(KERN_ERR "NCR_Q720: DMA declare memory failed\n");
-		goto out_release_region;
+		goto out_iounmap;
 	}
 
 	/* The first 1k of the memory buffer is a memory map of the registers
@@ -311,6 +317,8 @@ NCR_Q720_probe(struct device *dev)
 
  out_release:
 	dma_release_declared_memory(dev);
+ out_iounmap:
+	iounmap(dma_mem_base);
  out_release_region:
 	release_mem_region(base_addr, mem_size);
  out_free:
@@ -337,6 +345,7 @@ NCR_Q720_remove(struct device *dev)
 			NCR_Q720_remove_one(p->hosts[i]);
 
 	dma_release_declared_memory(dev);
+	iounmap(p->mem_base);
 	release_mem_region(p->phys_mem_base, p->mem_size);
 	free_irq(p->irq, p);
 	kfree(p);
