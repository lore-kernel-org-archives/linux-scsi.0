From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 1/2] Wean NCR_Q720 off the dma_declare_coherent_memory interface
Date: Tue, 30 Oct 2007 15:43:24 -0400
Message-ID: <1193773405-15799-1-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:34956 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbXJ3Tnl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 15:43:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, linux-scsi@vger.kernel.org, jejb@steeleye.com
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

By restructuring the ncr53c8xx driver a little, we can provide
the same functionality as the dma_declare_coherent_memory interface
without touching the generic dma paths.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/NCR_Q720.c  |   45 ++++++++-----------
 drivers/scsi/ncr53c8xx.c |  113 +++++++++++++++++++++++++++++++++++++---------
 drivers/scsi/ncr53c8xx.h |   13 +++++
 3 files changed, 124 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/NCR_Q720.c b/drivers/scsi/NCR_Q720.c
index a8bbdc2..8db20a6 100644
--- a/drivers/scsi/NCR_Q720.c
+++ b/drivers/scsi/NCR_Q720.c
@@ -36,9 +36,10 @@ MODULE_LICENSE("GPL");
 
 #define NCR_Q720_VERSION		"0.9"
 
-/* We needs this helper because we have up to four hosts per struct device */
+/* We have up to four hosts per struct device */
 struct NCR_Q720_private {
 	struct device		*dev;
+	struct ncr_mem		ncr_mem;
 	void __iomem *		mem_base;
 	__u32			phys_mem_base;
 	__u32			mem_size;
@@ -105,6 +106,7 @@ NCR_Q720_probe_one(struct NCR_Q720_private *p, int siop,
 	device.slot.base_v	= vaddr;
 	device.slot.irq		= irq;
 	device.differential	= differential ? 2 : 0;
+	device.ncr_mem		= &p->ncr_mem;
 	printk("Q720 probe unit %d (siop%d) at 0x%lx, diff = %d, vers = %d\n", unit, siop,
 	       (unsigned long)paddr, differential, version);
 
@@ -214,28 +216,21 @@ NCR_Q720_probe(struct device *dev)
 		       (unsigned long)(base_addr + mem_size));
 		goto out_free;
 	}
-	
-	if (dma_declare_coherent_memory(dev, base_addr, base_addr,
-					mem_size, DMA_MEMORY_MAP)
-	    != DMA_MEMORY_MAP) {
-		printk(KERN_ERR "NCR_Q720: DMA declare memory failed\n");
-		goto out_release_region;
-	}
 
-	/* The first 1k of the memory buffer is a memory map of the registers
-	 */
-	mem_base = dma_mark_declared_memory_occupied(dev, base_addr,
-							    1024);
-	if (IS_ERR(mem_base)) {
-		printk("NCR_Q720 failed to reserve memory mapped region\n");
-		goto out_release;
-	}
+	mem_base = ioremap(base_addr, mem_size);
+	if (!mem_base)
+		goto out_free;
+
+	p->ncr_mem.virt_base = mem_base;
+	p->ncr_mem.device_base = base_addr;
+	ncr_declare_coherent_memory(&p->ncr_mem, mem_size);
+
+	/* The first 1k of the memory buffer are the registers */
+	ncr_reserve_declared_memory(&p->ncr_mem, 0, 1024);
 
 	/* now also enable accesses in asr 2 */
 	asr2 = inb(io_base + 0x0a);
-
 	asr2 |= 0x01;
-
 	outb(asr2, io_base + 0x0a);
 
 	/* get the number of SIOPs (this should be 2 or 4) */
@@ -250,7 +245,6 @@ NCR_Q720_probe(struct device *dev)
 
 	irq = readb(mem_base + 5) & 0x0f;
 	
-	
 	/* now do the bus related transforms */
 	irq = mca_device_transform_irq(mca_dev, irq);
 
@@ -297,10 +291,8 @@ NCR_Q720_probe(struct device *dev)
 			found++;
 	}
 
-	if (!found) {
-		kfree(p);
-		return -ENODEV;
-	}
+	if (!found)
+		goto out_release;
 
 	mca_device_set_claim(mca_dev, 1);
 	mca_device_set_name(mca_dev, "NCR_Q720");
@@ -309,8 +301,8 @@ NCR_Q720_probe(struct device *dev)
 	return 0;
 
  out_release:
-	dma_release_declared_memory(dev);
- out_release_region:
+	ncr_release_declared_memory(&p->ncr_mem);
+	iounmap(mem_base);
 	release_mem_region(base_addr, mem_size);
  out_free:
 	kfree(p);
@@ -335,7 +327,8 @@ NCR_Q720_remove(struct device *dev)
 		if(p->hosts[i])
 			NCR_Q720_remove_one(p->hosts[i]);
 
-	dma_release_declared_memory(dev);
+	ncr_release_declared_memory(&p->ncr_mem);
+	iounmap(p->ncr_mem.virt_base);
 	release_mem_region(p->phys_mem_base, p->mem_size);
 	free_irq(p->irq, p);
 	kfree(p);
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 016c462..149a42b 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -128,6 +128,14 @@
 
 #define NAME53C8XX		"ncr53c8xx"
 
+/* Linux host data structure */
+
+struct host_data {
+	struct ncb *ncb;
+	struct ncr_mem *ncr_mem;
+	struct device *dev;
+};
+
 /*==========================================================
 **
 **	Debugging tags
@@ -172,6 +180,74 @@ static inline struct list_head *ncr_list_pop(struct list_head *head)
 	return NULL;
 }
 
+/*
+ * Support the onboard memory on the NCR Q720
+ *
+ * XXX: This is only coherent because it's only present on x86.
+ */
+
+int ncr_declare_coherent_memory(struct ncr_mem *mem, unsigned size)
+{
+	int pages = size >> PAGE_SHIFT;
+	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
+
+	mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
+	if (!mem->bitmap)
+		return -ENOMEM;
+
+	mem->size = pages;
+	return 0;
+}
+EXPORT_SYMBOL(ncr_declare_coherent_memory);
+
+void ncr_release_declared_memory(struct ncr_mem *mem)
+{
+	kfree(mem->bitmap);
+}
+EXPORT_SYMBOL(ncr_release_declared_memory);
+
+void ncr_reserve_declared_memory(struct ncr_mem *mem, unsigned start,
+								unsigned len)
+{
+	int pages = (start & ~PAGE_MASK) + len + PAGE_SIZE - 1;
+	start >>= PAGE_SHIFT;
+	bitmap_allocate_region(mem->bitmap, start, get_order(pages));
+}
+EXPORT_SYMBOL(ncr_reserve_declared_memory);
+
+static void *ncr_alloc_coherent(struct host_data *hd, size_t size,
+					dma_addr_t *dma_handle, gfp_t gfp)
+{
+	struct ncr_mem *mem = hd->ncr_mem;
+	if (mem) { 
+		unsigned order = get_order(size);
+		int page = bitmap_find_free_region(mem->bitmap,
+						mem->size, order);
+		if (page >= 0) {
+			void *addr = mem->virt_base + (page << PAGE_SHIFT);
+			*dma_handle = mem->device_base + (page << PAGE_SHIFT);
+			memset(addr, 0, size);
+			return addr;
+		}
+	}
+
+	return dma_alloc_coherent(hd->dev, size, dma_handle, gfp);
+}
+
+static void ncr_free_coherent(struct host_data *hd, size_t size,
+			void *vaddr, dma_addr_t dma_handle)
+{
+	struct ncr_mem *mem = hd->ncr_mem;
+	if (mem && (vaddr >= mem->virt_base) &&
+	    (vaddr < (mem->virt_base + (mem->size << PAGE_SHIFT)))) {
+		unsigned order = get_order(size);
+		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
+		bitmap_release_region(mem->bitmap, page, order);
+	} else {
+		dma_free_coherent(hd->dev, size, vaddr, dma_handle);
+	}
+}
+
 /*==========================================================
 **
 **	Simple power of two buddy-like allocator.
@@ -204,7 +280,7 @@ static inline struct list_head *ncr_list_pop(struct list_head *head)
 #define MEMO_CLUSTER_MASK	(MEMO_CLUSTER_SIZE-1)
 
 typedef u_long m_addr_t;	/* Enough bits to bit-hack addresses */
-typedef struct device *m_bush_t;	/* Something that addresses DMAable */
+typedef struct host_data *m_bush_t;	/* Something that addresses DMAable */
 
 typedef struct m_link {		/* Link between free memory chunks */
 	struct m_link *next;
@@ -388,7 +464,7 @@ static m_addr_t ___dma_getp(m_pool_s *mp)
 	vbp = __m_calloc(&mp0, sizeof(*vbp), "VTOB");
 	if (vbp) {
 		dma_addr_t daddr;
-		vp = (m_addr_t) dma_alloc_coherent(mp->bush,
+		vp = (m_addr_t) ncr_alloc_coherent(mp->bush,
 						PAGE_SIZE<<MEMO_PAGE_ORDER,
 						&daddr, GFP_ATOMIC);
 		if (vp) {
@@ -417,7 +493,7 @@ static void ___dma_freep(m_pool_s *mp, m_addr_t m)
 	if (*vbpp) {
 		vbp = *vbpp;
 		*vbpp = (*vbpp)->next;
-		dma_free_coherent(mp->bush, PAGE_SIZE<<MEMO_PAGE_ORDER,
+		ncr_free_coherent(mp->bush, PAGE_SIZE<<MEMO_PAGE_ORDER,
 				  (void *)vbp->vaddr, (dma_addr_t)vbp->baddr);
 		__m_free(&mp0, vbp, sizeof(*vbp), "VTOB");
 		--mp->nump;
@@ -510,11 +586,11 @@ static m_addr_t __vtobus(m_bush_t bush, void *m)
 	return vp ? vp->baddr + (((m_addr_t) m) - a) : 0;
 }
 
-#define _m_calloc_dma(np, s, n)		__m_calloc_dma(np->dev, s, n)
-#define _m_free_dma(np, p, s, n)	__m_free_dma(np->dev, p, s, n)
+#define _m_calloc_dma(np, s, n)		__m_calloc_dma(np->hd, s, n)
+#define _m_free_dma(np, p, s, n)	__m_free_dma(np->hd, p, s, n)
 #define m_calloc_dma(s, n)		_m_calloc_dma(np, s, n)
 #define m_free_dma(p, s, n)		_m_free_dma(np, p, s, n)
-#define _vtobus(np, p)			__vtobus(np->dev, p)
+#define _vtobus(np, p)			__vtobus(np->hd, p)
 #define vtobus(p)			_vtobus(np, p)
 
 /*
@@ -525,7 +601,7 @@ static m_addr_t __vtobus(m_bush_t bush, void *m)
 #define __data_mapped	SCp.phase
 #define __data_mapping	SCp.have_data_in
 
-static void __unmap_scsi_data(struct device *dev, struct scsi_cmnd *cmd)
+static void __unmap_scsi_data(struct scsi_cmnd *cmd)
 {
 	switch(cmd->__data_mapped) {
 	case 2:
@@ -535,7 +611,7 @@ static void __unmap_scsi_data(struct device *dev, struct scsi_cmnd *cmd)
 	cmd->__data_mapped = 0;
 }
 
-static int __map_scsi_sg_data(struct device *dev, struct scsi_cmnd *cmd)
+static int __map_scsi_sg_data(struct scsi_cmnd *cmd)
 {
 	int use_sg;
 
@@ -549,8 +625,8 @@ static int __map_scsi_sg_data(struct device *dev, struct scsi_cmnd *cmd)
 	return use_sg;
 }
 
-#define unmap_scsi_data(np, cmd)	__unmap_scsi_data(np->dev, cmd)
-#define map_scsi_sg_data(np, cmd)	__map_scsi_sg_data(np->dev, cmd)
+#define unmap_scsi_data(np, cmd)	__unmap_scsi_data(cmd)
+#define map_scsi_sg_data(np, cmd)	__map_scsi_sg_data(cmd)
 
 /*==========================================================
 **
@@ -1679,7 +1755,8 @@ struct ncb {
 	**	General controller parameters and configuration.
 	**----------------------------------------------------------------
 	*/
-	struct device	*dev;
+	struct host_data *hd;
+
 	u_char		revision_id;	/* PCI device revision id	*/
 	u32		irq;		/* IRQ level			*/
 	u32		features;	/* Chip features map		*/
@@ -3666,14 +3743,6 @@ ncr_script_copy_and_bind (struct ncb *np, ncrcmd *src, ncrcmd *dst, int len)
 	}
 }
 
-/*
-**	Linux host data structure
-*/
-
-struct host_data {
-     struct ncb *ncb;
-};
-
 #define PRINT_ADDR(cmd, arg...) dev_info(&cmd->device->sdev_gendev , ## arg)
 
 static void ncr_print_msg(struct ccb *cp, char *label, u_char *msg)
@@ -8324,12 +8393,14 @@ struct Scsi_Host * __init ncr_attach(struct scsi_host_template *tpnt,
 	if (!instance)
 	        goto attach_error;
 	host_data = (struct host_data *) instance->hostdata;
+	host_data->dev = device->dev;
+	host_data->ncr_mem = device->ncr_mem;
 
-	np = __m_calloc_dma(device->dev, sizeof(struct ncb), "NCB");
+	np = __m_calloc_dma(host_data, sizeof(struct ncb), "NCB");
 	if (!np)
 		goto attach_error;
 	spin_lock_init(&np->smp_lock);
-	np->dev = device->dev;
+	np->hd = host_data;
 	np->p_ncb = vtobus(np);
 	host_data->ncb = np;
 
diff --git a/drivers/scsi/ncr53c8xx.h b/drivers/scsi/ncr53c8xx.h
index 0e008da..23d2f6c 100644
--- a/drivers/scsi/ncr53c8xx.h
+++ b/drivers/scsi/ncr53c8xx.h
@@ -1314,6 +1314,7 @@ struct ncr_slot {
 */
 struct ncr_device {
 	struct device  *dev;
+	struct ncr_mem *ncr_mem;
 	struct ncr_slot  slot;
 	struct ncr_chip  chip;
 	u_char host_id;
@@ -1326,4 +1327,16 @@ irqreturn_t ncr53c8xx_intr(int irq, void *dev_id);
 extern int ncr53c8xx_init(void);
 extern void ncr53c8xx_exit(void);
 
+struct ncr_mem {
+	void *virt_base;
+	unsigned long *bitmap;
+	dma_addr_t device_base;
+	int size;
+};
+
+extern int ncr_declare_coherent_memory(struct ncr_mem *mem, unsigned size);
+extern void ncr_release_declared_memory(struct ncr_mem *mem);
+extern void ncr_reserve_declared_memory(struct ncr_mem *mem, unsigned start,
+					unsigned len);
+
 #endif /* NCR53C8XX_H */
-- 
1.5.3.4

