From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
Date: Thu, 10 Jul 2008 15:53:31 +0100
Message-ID: <20080710155331.49d41e35@the-village.bc.nu>
References: <20080710121350.52d854c7@the-village.bc.nu>
	<E1KGa1W-0004nG-Cw@n2o.xs4all.nl>
	<20080709113547.19235.15424.stgit@warthog.procyon.org.uk>
	<4561.1215612914@redhat.com>
	<20080709164929.799e4e05@the-village.bc.nu>
	<1215630402.18506.10.camel@localhost.localdomain>
	<27706.1215691933@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760101AbYGJP3w@vger.kernel.org>
In-Reply-To: <27706.1215691933@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: dhowells@redhat.com, Miquel van Smoorenburg <miquels@cistron.nl>, akpm@linux-foundation.org, alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 10 Jul 2008 13:12:13 +0100
David Howells <dhowells@redhat.com> wrote:

> 
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > -static inline int i2o_dma_alloc(struct device *dev, struct i2o_dma *addr,
> > -				size_t len, gfp_t gfp_mask)
> > ...
> > +extern int i2o_dma_alloc(struct device *dev, struct i2o_dma *addr, size_t len);
> 
> But where is it now?  Have you forgotten to attach a new file?  i2o/memory.c
> perhaps?

i2o: Fix the passthru configuration

From: Alan Cox <alan@redhat.com>

The I2O ioctls assume 32bits. In itself that is fine as they are old cards
and nobody uses 64bit. However on LKML it was noted this assumption is also
made for allocated memory and is unsafe on 64bit systems.

Fixing this is a mess. It turns out there is tons of crap buried in a header
file that does racy 32/64bit filtering on the masks.

So we:
- Verify all callers of the racy code can sleep (i2o_dma_[re]alloc)
- Move the code into a new i2o/memory.c file
- Remove the gfp_mask argument so nobody can try and misuse the function
- Wrap a mutex around the problem area (a single mutex is easy to do and
  none of this is performance relevant)
- Switch the remaining problem kmalloc holdout to use i2o_dma_alloc
---

 drivers/message/i2o/Makefile     |    2 
 drivers/message/i2o/device.c     |    2 
 drivers/message/i2o/exec-osm.c   |    4 
 drivers/message/i2o/i2o_config.c |   22 +--
 drivers/message/i2o/iop.c        |    2 
 drivers/message/i2o/memory.c     |  315 ++++++++++++++++++++++++++++++++++++++
 drivers/message/i2o/pci.c        |   16 +-
 include/linux/i2o.h              |  291 +----------------------------------
 8 files changed, 350 insertions(+), 304 deletions(-)
 create mode 100644 drivers/message/i2o/memory.c


diff --git a/drivers/message/i2o/Makefile b/drivers/message/i2o/Makefile
index 2c2e39a..b0982da 100644
--- a/drivers/message/i2o/Makefile
+++ b/drivers/message/i2o/Makefile
@@ -5,7 +5,7 @@
 # In the future, some of these should be built conditionally.
 #
 
-i2o_core-y		+= iop.o driver.o device.o debug.o pci.o exec-osm.o
+i2o_core-y		+= iop.o driver.o device.o debug.o pci.o exec-osm.o memory.o
 i2o_bus-y		+= bus-osm.o
 i2o_config-y		+= config-osm.o
 obj-$(CONFIG_I2O)	+= i2o_core.o
diff --git a/drivers/message/i2o/device.c b/drivers/message/i2o/device.c
index 489d7c5..a491dd6 100644
--- a/drivers/message/i2o/device.c
+++ b/drivers/message/i2o/device.c
@@ -437,7 +437,7 @@ int i2o_parm_issue(struct i2o_device *i2o_dev, int cmd, void *oplist,
 
 	res.virt = NULL;
 
-	if (i2o_dma_alloc(dev, &res, reslen, GFP_KERNEL))
+	if (i2o_dma_alloc(dev, &res, reslen))
 		return -ENOMEM;
 
 	msg = i2o_msg_get_wait(c, I2O_TIMEOUT_MESSAGE_GET);
diff --git a/drivers/message/i2o/exec-osm.c b/drivers/message/i2o/exec-osm.c
index 6cbcc21..56faef1 100644
--- a/drivers/message/i2o/exec-osm.c
+++ b/drivers/message/i2o/exec-osm.c
@@ -388,8 +388,8 @@ static int i2o_exec_lct_notify(struct i2o_controller *c, u32 change_ind)
 
 	dev = &c->pdev->dev;
 
-	if (i2o_dma_realloc
-	    (dev, &c->dlct, le32_to_cpu(sb->expected_lct_size), GFP_KERNEL))
+	if (i2o_dma_realloc(dev, &c->dlct,
+					le32_to_cpu(sb->expected_lct_size)))
 		return -ENOMEM;
 
 	msg = i2o_msg_get_wait(c, I2O_TIMEOUT_MESSAGE_GET);
diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index c0fb77d..ecd5d00 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -780,12 +780,11 @@ static int i2o_cfg_passthru(unsigned long arg)
 	u32 size = 0;
 	u32 reply_size = 0;
 	u32 rcode = 0;
-	void *sg_list[SG_TABLESIZE];
+	struct i2o_dma sg_list[SG_TABLESIZE];
 	u32 sg_offset = 0;
 	u32 sg_count = 0;
 	int sg_index = 0;
 	u32 i = 0;
-	void *p = NULL;
 	i2o_status_block *sb;
 	struct i2o_message *msg;
 	unsigned int iop;
@@ -842,6 +841,7 @@ static int i2o_cfg_passthru(unsigned long arg)
 	memset(sg_list, 0, sizeof(sg_list[0]) * SG_TABLESIZE);
 	if (sg_offset) {
 		struct sg_simple_element *sg;
+		struct i2o_dma *p;
 
 		if (sg_offset * 4 >= size) {
 			rcode = -EFAULT;
@@ -871,22 +871,23 @@ static int i2o_cfg_passthru(unsigned long arg)
 				goto sg_list_cleanup;
 			}
 			sg_size = sg[i].flag_count & 0xffffff;
+			p = &(sg_list[sg_index]);
+			if (i2o_dma_alloc(&c->pdev->dev, p, sg_size,
+						PCI_DMA_BIDIRECTIONAL)) {
 			/* Allocate memory for the transfer */
-			p = kmalloc(sg_size, GFP_KERNEL);
-			if (!p) {
 				printk(KERN_DEBUG
 				       "%s: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
 				       c->name, sg_size, i, sg_count);
 				rcode = -ENOMEM;
 				goto sg_list_cleanup;
 			}
-			sg_list[sg_index++] = p;	// sglist indexed with input frame, not our internal frame.
+			sg_index++;
 			/* Copy in the user's SG buffer if necessary */
 			if (sg[i].
 			    flag_count & 0x04000000 /*I2O_SGL_FLAGS_DIR */ ) {
 				// TODO 64bit fix
 				if (copy_from_user
-				    (p, (void __user *)sg[i].addr_bus,
+				    (p->virt, (void __user *)sg[i].addr_bus,
 				     sg_size)) {
 					printk(KERN_DEBUG
 					       "%s: Could not copy SG buf %d FROM user\n",
@@ -895,8 +896,7 @@ static int i2o_cfg_passthru(unsigned long arg)
 					goto sg_list_cleanup;
 				}
 			}
-			//TODO 64bit fix
-			sg[i].addr_bus = virt_to_bus(p);
+			sg[i].addr_bus = p->phys;
 		}
 	}
 
@@ -908,7 +908,7 @@ static int i2o_cfg_passthru(unsigned long arg)
 	}
 
 	if (sg_offset) {
-		u32 rmsg[128];
+		u32 rmsg[I2O_OUTBOUND_MSG_FRAME_SIZE];
 		/* Copy back the Scatter Gather buffers back to user space */
 		u32 j;
 		// TODO 64bit fix
@@ -942,7 +942,7 @@ static int i2o_cfg_passthru(unsigned long arg)
 				sg_size = sg[j].flag_count & 0xffffff;
 				// TODO 64bit fix
 				if (copy_to_user
-				    ((void __user *)sg[j].addr_bus, sg_list[j],
+				    ((void __user *)sg[j].addr_bus, sg_list[j].virt,
 				     sg_size)) {
 					printk(KERN_WARNING
 					       "%s: Could not copy %p TO user %x\n",
@@ -973,7 +973,7 @@ sg_list_cleanup:
 	}
 
 	for (i = 0; i < sg_index; i++)
-		kfree(sg_list[i]);
+		i2o_dma_free(&c->pdev->dev, &sg_list[i]);
 
 cleanup:
 	kfree(reply);
diff --git a/drivers/message/i2o/iop.c b/drivers/message/i2o/iop.c
index da715e1..be2b592 100644
--- a/drivers/message/i2o/iop.c
+++ b/drivers/message/i2o/iop.c
@@ -1004,7 +1004,7 @@ static int i2o_hrt_get(struct i2o_controller *c)
 
 		size = hrt->num_entries * hrt->entry_len << 2;
 		if (size > c->hrt.len) {
-			if (i2o_dma_realloc(dev, &c->hrt, size, GFP_KERNEL))
+			if (i2o_dma_realloc(dev, &c->hrt, size))
 				return -ENOMEM;
 			else
 				hrt = c->hrt.virt;
diff --git a/drivers/message/i2o/memory.c b/drivers/message/i2o/memory.c
new file mode 100644
index 0000000..e3d4130
--- /dev/null
+++ b/drivers/message/i2o/memory.c
@@ -0,0 +1,315 @@
+/*
+ *	Functions to handle I2O memory
+ *
+ *	Pulled from the inlines in i2o headers and uninlined
+ *
+ *
+ *	This program is free software; you can redistribute it and/or modify it
+ *	under the terms of the GNU General Public License as published by the
+ *	Free Software Foundation; either version 2 of the License, or (at your
+ *	option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/i2o.h>
+#include <linux/delay.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include "core.h"
+
+/* Protects our 32/64bit mask switching */
+static DEFINE_MUTEX(mem_lock);
+
+/**
+ *	i2o_sg_tablesize - Calculate the maximum number of elements in a SGL
+ *	@c: I2O controller for which the calculation should be done
+ *	@body_size: maximum body size used for message in 32-bit words.
+ *
+ *	Return the maximum number of SG elements in a SG list.
+ */
+
+u16 i2o_sg_tablesize(struct i2o_controller *c, u16 body_size)
+{
+	i2o_status_block *sb = c->status_block.virt;
+	u16 sg_count =
+	    (sb->inbound_frame_size - sizeof(struct i2o_message) / 4) -
+	    body_size;
+
+	if (c->pae_support) {
+		/*
+		 * for 64-bit a SG attribute element must be added and each
+		 * SG element needs 12 bytes instead of 8.
+		 */
+		sg_count -= 2;
+		sg_count /= 3;
+	} else
+		sg_count /= 2;
+
+	if (c->short_req && (sg_count > 8))
+		sg_count = 8;
+
+	return sg_count;
+};
+EXPORT_SYMBOL_GPL(i2o_sg_tablesize);
+
+/**
+ *	i2o_dma_map_single - Map pointer to controller and fill in I2O message.
+ *	@c: I2O controller
+ *	@ptr: pointer to the data which should be mapped
+ *	@size: size of data in bytes
+ *	@direction: DMA_TO_DEVICE / DMA_FROM_DEVICE
+ *	@sg_ptr: pointer to the SG list inside the I2O message
+ *
+ *	This function does all necessary DMA handling and also writes the I2O
+ *	SGL elements into the I2O message. For details on DMA handling see also
+ *	dma_map_single(). The pointer sg_ptr will only be set to the end of the
+ *	SG list if the allocation was successful.
+ *
+ *	Returns DMA address which must be checked for failures using
+ *	dma_mapping_error().
+ */
+dma_addr_t i2o_dma_map_single(struct i2o_controller *c, void *ptr,
+					    size_t size,
+					    enum dma_data_direction direction,
+					    u32 ** sg_ptr)
+{
+	u32 sg_flags;
+	u32 *mptr = *sg_ptr;
+	dma_addr_t dma_addr;
+
+	switch (direction) {
+	case DMA_TO_DEVICE:
+		sg_flags = 0xd4000000;
+		break;
+	case DMA_FROM_DEVICE:
+		sg_flags = 0xd0000000;
+		break;
+	default:
+		return 0;
+	}
+
+	dma_addr = dma_map_single(&c->pdev->dev, ptr, size, direction);
+	if (!dma_mapping_error(dma_addr)) {
+#ifdef CONFIG_I2O_EXT_ADAPTEC_DMA64
+		if ((sizeof(dma_addr_t) > 4) && c->pae_support) {
+			*mptr++ = cpu_to_le32(0x7C020002);
+			*mptr++ = cpu_to_le32(PAGE_SIZE);
+		}
+#endif
+
+		*mptr++ = cpu_to_le32(sg_flags | size);
+		*mptr++ = cpu_to_le32(i2o_dma_low(dma_addr));
+#ifdef CONFIG_I2O_EXT_ADAPTEC_DMA64
+		if ((sizeof(dma_addr_t) > 4) && c->pae_support)
+			*mptr++ = cpu_to_le32(i2o_dma_high(dma_addr));
+#endif
+		*sg_ptr = mptr;
+	}
+	return dma_addr;
+};
+EXPORT_SYMBOL_GPL(i2o_dma_map_single);
+
+/**
+ *	i2o_dma_map_sg - Map a SG List to controller and fill in I2O message.
+ *	@c: I2O controller
+ *	@sg: SG list to be mapped
+ *	@sg_count: number of elements in the SG list
+ *	@direction: DMA_TO_DEVICE / DMA_FROM_DEVICE
+ *	@sg_ptr: pointer to the SG list inside the I2O message
+ *
+ *	This function does all necessary DMA handling and also writes the I2O
+ *	SGL elements into the I2O message. For details on DMA handling see also
+ *	dma_map_sg(). The pointer sg_ptr will only be set to the end of the SG
+ *	list if the allocation was successful.
+ *
+ *	Returns 0 on failure or 1 on success.
+ */
+int i2o_dma_map_sg(struct i2o_controller *c,
+				 struct scatterlist *sg, int sg_count,
+				 enum dma_data_direction direction,
+				 u32 ** sg_ptr)
+{
+	u32 sg_flags;
+	u32 *mptr = *sg_ptr;
+
+	switch (direction) {
+	case DMA_TO_DEVICE:
+		sg_flags = 0x14000000;
+		break;
+	case DMA_FROM_DEVICE:
+		sg_flags = 0x10000000;
+		break;
+	default:
+		return 0;
+	}
+
+	sg_count = dma_map_sg(&c->pdev->dev, sg, sg_count, direction);
+	if (!sg_count)
+		return 0;
+
+#ifdef CONFIG_I2O_EXT_ADAPTEC_DMA64
+	if ((sizeof(dma_addr_t) > 4) && c->pae_support) {
+		*mptr++ = cpu_to_le32(0x7C020002);
+		*mptr++ = cpu_to_le32(PAGE_SIZE);
+	}
+#endif
+
+	while (sg_count-- > 0) {
+		if (!sg_count)
+			sg_flags |= 0xC0000000;
+		*mptr++ = cpu_to_le32(sg_flags | sg_dma_len(sg));
+		*mptr++ = cpu_to_le32(i2o_dma_low(sg_dma_address(sg)));
+#ifdef CONFIG_I2O_EXT_ADAPTEC_DMA64
+		if ((sizeof(dma_addr_t) > 4) && c->pae_support)
+			*mptr++ = cpu_to_le32(i2o_dma_high(sg_dma_address(sg)));
+#endif
+		sg = sg_next(sg);
+	}
+	*sg_ptr = mptr;
+
+	return 1;
+};
+EXPORT_SYMBOL_GPL(i2o_dma_map_sg);
+
+/**
+ *	i2o_dma_alloc - Allocate DMA memory
+ *	@dev: struct device pointer to the PCI device of the I2O controller
+ *	@addr: i2o_dma struct which should get the DMA buffer
+ *	@len: length of the new DMA memory
+ *
+ *	Allocate a coherent DMA memory and write the pointers into addr. A
+ *	32bit allocation is used as the messages for these allocations are
+ *	32bit only.
+ *
+ *	Returns 0 on success or -ENOMEM on failure.
+ */
+int i2o_dma_alloc(struct device *dev, struct i2o_dma *addr, size_t len)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	int dma_64 = 0;
+
+	mutex_lock(&mem_lock);
+	if ((sizeof(dma_addr_t) > 4) && (pdev->dma_mask == DMA_64BIT_MASK)) {
+		dma_64 = 1;
+		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+			mutex_unlock(&mem_lock);
+			return -ENOMEM;
+		}
+	}
+	addr->virt = dma_alloc_coherent(dev, len, &addr->phys, GFP_KERNEL);
+
+	if ((sizeof(dma_addr_t) > 4) && dma_64)
+		if (pci_set_dma_mask(pdev, DMA_64BIT_MASK))
+			printk(KERN_WARNING "i2o: unable to set 64-bit DMA");
+
+	mutex_unlock(&mem_lock);
+	if (!addr->virt)
+		return -ENOMEM;
+
+	memset(addr->virt, 0, len);
+	addr->len = len;
+
+	return 0;
+};
+EXPORT_SYMBOL_GPL(i2o_dma_alloc);
+
+/**
+ *	i2o_dma_free - Free DMA memory
+ *	@dev: struct device pointer to the PCI device of the I2O controller
+ *	@addr: i2o_dma struct which contains the DMA buffer
+ *
+ *	Free a coherent DMA memory and set virtual address of addr to NULL.
+ */
+void i2o_dma_free(struct device *dev, struct i2o_dma *addr)
+{
+	if (addr->virt) {
+		if (addr->phys)
+			dma_free_coherent(dev, addr->len, addr->virt,
+					  addr->phys);
+		else
+			kfree(addr->virt);
+		addr->virt = NULL;
+	}
+};
+EXPORT_SYMBOL_GPL(i2o_dma_free);
+
+/**
+ *	i2o_dma_realloc - Realloc DMA memory
+ *	@dev: struct device pointer to the PCI device of the I2O controller
+ *	@addr: pointer to a i2o_dma struct DMA buffer
+ *	@len: new length of memory
+ *
+ *	If there was something allocated in the addr, free it first. If len > 0
+ *	than try to allocate it and write the addresses back to the addr
+ *	structure. If len == 0 set the virtual address to NULL.
+ *
+ *	Returns the 0 on success or negative error code on failure.
+ */
+int i2o_dma_realloc(struct device *dev, struct i2o_dma *addr, size_t len)
+{
+	i2o_dma_free(dev, addr);
+
+	if (len)
+		return i2o_dma_alloc(dev, addr, len);
+
+	return 0;
+};
+EXPORT_SYMBOL_GPL(i2o_dma_realloc);
+
+/*
+ *	i2o_pool_alloc - Allocate an slab cache and mempool
+ *	@mempool: pointer to struct i2o_pool to write data into.
+ *	@name: name which is used to identify cache
+ *	@size: size of each object
+ *	@min_nr: minimum number of objects
+ *
+ *	First allocates a slab cache with name and size. Then allocates a
+ *	mempool which uses the slab cache for allocation and freeing.
+ *
+ *	Returns 0 on success or negative error code on failure.
+ */
+int i2o_pool_alloc(struct i2o_pool *pool, const char *name,
+				 size_t size, int min_nr)
+{
+	pool->name = kmalloc(strlen(name) + 1, GFP_KERNEL);
+	if (!pool->name)
+		goto exit;
+	strcpy(pool->name, name);
+
+	pool->slab = kmem_cache_create(pool->name, size, 0,
+						SLAB_HWCACHE_ALIGN, NULL);
+	if (!pool->slab)
+		goto free_name;
+
+	pool->mempool = mempool_create_slab_pool(min_nr, pool->slab);
+	if (!pool->mempool)
+		goto free_slab;
+
+	return 0;
+
+free_slab:
+	kmem_cache_destroy(pool->slab);
+
+free_name:
+	kfree(pool->name);
+
+exit:
+	return -ENOMEM;
+};
+EXPORT_SYMBOL_GPL(i2o_pool_alloc);
+
+/*
+ *	i2o_pool_free - Free slab cache and mempool again
+ *	@mempool: pointer to struct i2o_pool which should be freed
+ *
+ *	Note that you have to return all objects to the mempool again before
+ *	calling i2o_pool_free().
+ */
+void i2o_pool_free(struct i2o_pool *pool)
+{
+	mempool_destroy(pool->mempool);
+	kmem_cache_destroy(pool->slab);
+	kfree(pool->name);
+};
+EXPORT_SYMBOL_GPL(i2o_pool_free);
+
diff --git a/drivers/message/i2o/pci.c b/drivers/message/i2o/pci.c
index 685a895..610ef12 100644
--- a/drivers/message/i2o/pci.c
+++ b/drivers/message/i2o/pci.c
@@ -186,31 +186,29 @@ static int __devinit i2o_pci_alloc(struct i2o_controller *c)
 		}
 	}
 
-	if (i2o_dma_alloc(dev, &c->status, 8, GFP_KERNEL)) {
+	if (i2o_dma_alloc(dev, &c->status, 8)) {
 		i2o_pci_free(c);
 		return -ENOMEM;
 	}
 
-	if (i2o_dma_alloc(dev, &c->hrt, sizeof(i2o_hrt), GFP_KERNEL)) {
+	if (i2o_dma_alloc(dev, &c->hrt, sizeof(i2o_hrt))) {
 		i2o_pci_free(c);
 		return -ENOMEM;
 	}
 
-	if (i2o_dma_alloc(dev, &c->dlct, 8192, GFP_KERNEL)) {
+	if (i2o_dma_alloc(dev, &c->dlct, 8192)) {
 		i2o_pci_free(c);
 		return -ENOMEM;
 	}
 
-	if (i2o_dma_alloc(dev, &c->status_block, sizeof(i2o_status_block),
-			  GFP_KERNEL)) {
+	if (i2o_dma_alloc(dev, &c->status_block, sizeof(i2o_status_block))) {
 		i2o_pci_free(c);
 		return -ENOMEM;
 	}
 
-	if (i2o_dma_alloc
-	    (dev, &c->out_queue,
-	     I2O_MAX_OUTBOUND_MSG_FRAMES * I2O_OUTBOUND_MSG_FRAME_SIZE *
-	     sizeof(u32), GFP_KERNEL)) {
+	if (i2o_dma_alloc(dev, &c->out_queue,
+		I2O_MAX_OUTBOUND_MSG_FRAMES * I2O_OUTBOUND_MSG_FRAME_SIZE *
+				sizeof(u32))) {
 		i2o_pci_free(c);
 		return -ENOMEM;
 	}
diff --git a/include/linux/i2o.h b/include/linux/i2o.h
index 7d51cbc..81d22d2 100644
--- a/include/linux/i2o.h
+++ b/include/linux/i2o.h
@@ -570,7 +570,6 @@ struct i2o_controller {
 #endif
 	spinlock_t lock;	/* lock for controller
 				   configuration */
-
 	void *driver_data[I2O_MAX_DRIVERS];	/* storage for drivers */
 };
 
@@ -691,288 +690,22 @@ static inline u32 i2o_dma_high(dma_addr_t dma_addr)
 };
 #endif
 
-/**
- *	i2o_sg_tablesize - Calculate the maximum number of elements in a SGL
- *	@c: I2O controller for which the calculation should be done
- *	@body_size: maximum body size used for message in 32-bit words.
- *
- *	Return the maximum number of SG elements in a SG list.
- */
-static inline u16 i2o_sg_tablesize(struct i2o_controller *c, u16 body_size)
-{
-	i2o_status_block *sb = c->status_block.virt;
-	u16 sg_count =
-	    (sb->inbound_frame_size - sizeof(struct i2o_message) / 4) -
-	    body_size;
-
-	if (c->pae_support) {
-		/*
-		 * for 64-bit a SG attribute element must be added and each
-		 * SG element needs 12 bytes instead of 8.
-		 */
-		sg_count -= 2;
-		sg_count /= 3;
-	} else
-		sg_count /= 2;
-
-	if (c->short_req && (sg_count > 8))
-		sg_count = 8;
-
-	return sg_count;
-};
-
-/**
- *	i2o_dma_map_single - Map pointer to controller and fill in I2O message.
- *	@c: I2O controller
- *	@ptr: pointer to the data which should be mapped
- *	@size: size of data in bytes
- *	@direction: DMA_TO_DEVICE / DMA_FROM_DEVICE
- *	@sg_ptr: pointer to the SG list inside the I2O message
- *
- *	This function does all necessary DMA handling and also writes the I2O
- *	SGL elements into the I2O message. For details on DMA handling see also
- *	dma_map_single(). The pointer sg_ptr will only be set to the end of the
- *	SG list if the allocation was successful.
- *
- *	Returns DMA address which must be checked for failures using
- *	dma_mapping_error().
- */
-static inline dma_addr_t i2o_dma_map_single(struct i2o_controller *c, void *ptr,
+extern u16 i2o_sg_tablesize(struct i2o_controller *c, u16 body_size);
+extern dma_addr_t i2o_dma_map_single(struct i2o_controller *c, void *ptr,
 					    size_t size,
 					    enum dma_data_direction direction,
-					    u32 ** sg_ptr)
-{
-	u32 sg_flags;
-	u32 *mptr = *sg_ptr;
-	dma_addr_t dma_addr;
-
-	switch (direction) {
-	case DMA_TO_DEVICE:
-		sg_flags = 0xd4000000;
-		break;
-	case DMA_FROM_DEVICE:
-		sg_flags = 0xd0000000;
-		break;
-	default:
-		return 0;
-	}
-
-	dma_addr = dma_map_single(&c->pdev->dev, ptr, size, direction);
-	if (!dma_mapping_error(dma_addr)) {
-#ifdef CONFIG_I2O_EXT_ADAPTEC_DMA64
-		if ((sizeof(dma_addr_t) > 4) && c->pae_support) {
-			*mptr++ = cpu_to_le32(0x7C020002);
-			*mptr++ = cpu_to_le32(PAGE_SIZE);
-		}
-#endif
-
-		*mptr++ = cpu_to_le32(sg_flags | size);
-		*mptr++ = cpu_to_le32(i2o_dma_low(dma_addr));
-#ifdef CONFIG_I2O_EXT_ADAPTEC_DMA64
-		if ((sizeof(dma_addr_t) > 4) && c->pae_support)
-			*mptr++ = cpu_to_le32(i2o_dma_high(dma_addr));
-#endif
-		*sg_ptr = mptr;
-	}
-	return dma_addr;
-};
-
-/**
- *	i2o_dma_map_sg - Map a SG List to controller and fill in I2O message.
- *	@c: I2O controller
- *	@sg: SG list to be mapped
- *	@sg_count: number of elements in the SG list
- *	@direction: DMA_TO_DEVICE / DMA_FROM_DEVICE
- *	@sg_ptr: pointer to the SG list inside the I2O message
- *
- *	This function does all necessary DMA handling and also writes the I2O
- *	SGL elements into the I2O message. For details on DMA handling see also
- *	dma_map_sg(). The pointer sg_ptr will only be set to the end of the SG
- *	list if the allocation was successful.
- *
- *	Returns 0 on failure or 1 on success.
- */
-static inline int i2o_dma_map_sg(struct i2o_controller *c,
+					    u32 ** sg_ptr);
+extern int i2o_dma_map_sg(struct i2o_controller *c,
 				 struct scatterlist *sg, int sg_count,
 				 enum dma_data_direction direction,
-				 u32 ** sg_ptr)
-{
-	u32 sg_flags;
-	u32 *mptr = *sg_ptr;
-
-	switch (direction) {
-	case DMA_TO_DEVICE:
-		sg_flags = 0x14000000;
-		break;
-	case DMA_FROM_DEVICE:
-		sg_flags = 0x10000000;
-		break;
-	default:
-		return 0;
-	}
-
-	sg_count = dma_map_sg(&c->pdev->dev, sg, sg_count, direction);
-	if (!sg_count)
-		return 0;
-
-#ifdef CONFIG_I2O_EXT_ADAPTEC_DMA64
-	if ((sizeof(dma_addr_t) > 4) && c->pae_support) {
-		*mptr++ = cpu_to_le32(0x7C020002);
-		*mptr++ = cpu_to_le32(PAGE_SIZE);
-	}
-#endif
-
-	while (sg_count-- > 0) {
-		if (!sg_count)
-			sg_flags |= 0xC0000000;
-		*mptr++ = cpu_to_le32(sg_flags | sg_dma_len(sg));
-		*mptr++ = cpu_to_le32(i2o_dma_low(sg_dma_address(sg)));
-#ifdef CONFIG_I2O_EXT_ADAPTEC_DMA64
-		if ((sizeof(dma_addr_t) > 4) && c->pae_support)
-			*mptr++ = cpu_to_le32(i2o_dma_high(sg_dma_address(sg)));
-#endif
-		sg = sg_next(sg);
-	}
-	*sg_ptr = mptr;
-
-	return 1;
-};
-
-/**
- *	i2o_dma_alloc - Allocate DMA memory
- *	@dev: struct device pointer to the PCI device of the I2O controller
- *	@addr: i2o_dma struct which should get the DMA buffer
- *	@len: length of the new DMA memory
- *	@gfp_mask: GFP mask
- *
- *	Allocate a coherent DMA memory and write the pointers into addr.
- *
- *	Returns 0 on success or -ENOMEM on failure.
- */
-static inline int i2o_dma_alloc(struct device *dev, struct i2o_dma *addr,
-				size_t len, gfp_t gfp_mask)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	int dma_64 = 0;
-
-	if ((sizeof(dma_addr_t) > 4) && (pdev->dma_mask == DMA_64BIT_MASK)) {
-		dma_64 = 1;
-		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK))
-			return -ENOMEM;
-	}
-
-	addr->virt = dma_alloc_coherent(dev, len, &addr->phys, gfp_mask);
-
-	if ((sizeof(dma_addr_t) > 4) && dma_64)
-		if (pci_set_dma_mask(pdev, DMA_64BIT_MASK))
-			printk(KERN_WARNING "i2o: unable to set 64-bit DMA");
-
-	if (!addr->virt)
-		return -ENOMEM;
-
-	memset(addr->virt, 0, len);
-	addr->len = len;
-
-	return 0;
-};
-
-/**
- *	i2o_dma_free - Free DMA memory
- *	@dev: struct device pointer to the PCI device of the I2O controller
- *	@addr: i2o_dma struct which contains the DMA buffer
- *
- *	Free a coherent DMA memory and set virtual address of addr to NULL.
- */
-static inline void i2o_dma_free(struct device *dev, struct i2o_dma *addr)
-{
-	if (addr->virt) {
-		if (addr->phys)
-			dma_free_coherent(dev, addr->len, addr->virt,
-					  addr->phys);
-		else
-			kfree(addr->virt);
-		addr->virt = NULL;
-	}
-};
-
-/**
- *	i2o_dma_realloc - Realloc DMA memory
- *	@dev: struct device pointer to the PCI device of the I2O controller
- *	@addr: pointer to a i2o_dma struct DMA buffer
- *	@len: new length of memory
- *	@gfp_mask: GFP mask
- *
- *	If there was something allocated in the addr, free it first. If len > 0
- *	than try to allocate it and write the addresses back to the addr
- *	structure. If len == 0 set the virtual address to NULL.
- *
- *	Returns the 0 on success or negative error code on failure.
- */
-static inline int i2o_dma_realloc(struct device *dev, struct i2o_dma *addr,
-				  size_t len, gfp_t gfp_mask)
-{
-	i2o_dma_free(dev, addr);
-
-	if (len)
-		return i2o_dma_alloc(dev, addr, len, gfp_mask);
-
-	return 0;
-};
-
-/*
- *	i2o_pool_alloc - Allocate an slab cache and mempool
- *	@mempool: pointer to struct i2o_pool to write data into.
- *	@name: name which is used to identify cache
- *	@size: size of each object
- *	@min_nr: minimum number of objects
- *
- *	First allocates a slab cache with name and size. Then allocates a
- *	mempool which uses the slab cache for allocation and freeing.
- *
- *	Returns 0 on success or negative error code on failure.
- */
-static inline int i2o_pool_alloc(struct i2o_pool *pool, const char *name,
-				 size_t size, int min_nr)
-{
-	pool->name = kmalloc(strlen(name) + 1, GFP_KERNEL);
-	if (!pool->name)
-		goto exit;
-	strcpy(pool->name, name);
-
-	pool->slab =
-	    kmem_cache_create(pool->name, size, 0, SLAB_HWCACHE_ALIGN, NULL);
-	if (!pool->slab)
-		goto free_name;
-
-	pool->mempool = mempool_create_slab_pool(min_nr, pool->slab);
-	if (!pool->mempool)
-		goto free_slab;
-
-	return 0;
-
-      free_slab:
-	kmem_cache_destroy(pool->slab);
-
-      free_name:
-	kfree(pool->name);
-
-      exit:
-	return -ENOMEM;
-};
-
-/*
- *	i2o_pool_free - Free slab cache and mempool again
- *	@mempool: pointer to struct i2o_pool which should be freed
- *
- *	Note that you have to return all objects to the mempool again before
- *	calling i2o_pool_free().
- */
-static inline void i2o_pool_free(struct i2o_pool *pool)
-{
-	mempool_destroy(pool->mempool);
-	kmem_cache_destroy(pool->slab);
-	kfree(pool->name);
-};
+				 u32 ** sg_ptr);
+extern int i2o_dma_alloc(struct device *dev, struct i2o_dma *addr, size_t len);
+extern void i2o_dma_free(struct device *dev, struct i2o_dma *addr);
+extern int i2o_dma_realloc(struct device *dev, struct i2o_dma *addr,
+								size_t len);
+extern int i2o_pool_alloc(struct i2o_pool *pool, const char *name,
+				 size_t size, int min_nr);
+extern void i2o_pool_free(struct i2o_pool *pool);
 
 /* I2O driver (OSM) functions */
 extern int i2o_driver_register(struct i2o_driver *);
