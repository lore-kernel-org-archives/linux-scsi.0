From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 3/5] add sg segment limitation info to device structure
Date: Wed, 3 Oct 2007 23:19:22 +0900
Message-ID: <20071003231034P.tomof@acm.org>
References: <3ae72650710020823j17219ab5u6c2aefe491884ca6@mail.gmail.com>
	<20071002152534.GT12049@parisc-linux.org>
	<20071002164413.GA12571@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:52281 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbXJCOUl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 10:20:41 -0400
In-Reply-To: <20071002164413.GA12571@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@suse.de
Cc: matthew@wil.cx, kay.sievers@vrfy.org, James.Bottomley@steeleye.com, tomof@acm.org, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Tue, 2 Oct 2007 09:44:13 -0700
Greg KH <gregkh@suse.de> wrote:

> On Tue, Oct 02, 2007 at 09:25:34AM -0600, Matthew Wilcox wrote:
> > On Tue, Oct 02, 2007 at 05:23:39PM +0200, Kay Sievers wrote:
> > > Just looking at the number of devices, it seems that allocating it
> > > dynamically would be the better deal. We allocate the name of every
> > > kobject dynamically today, so I guess it's fine to do that with the
> > > DMA data too.
> > 
> > But we don't need to allocate it dynamically.  We can embed it in the
> > pci_dev, eisa_dev, zorro_dev, mca_dev and parisc_device.
> 
> But then you run into the issue that James pointed out originally.
> 
> Anyway, I don't care which, let's see some patches :)

How about this (based on James' proposal)?

- Currently, there are only max_segment_size and segment_boundary_mask
in struct device_dma_parameters (I'll add segment_boundary_mask
support later after I finish the iommu part). We'll move more dma
stuff in struct device (like dma_mask) to struct device_dma_parameters
later (needs some cleanups before that).

- New accessors for the dma parameters are added. So we can easily
change where to place struct device_dma_parameters in the future.

- the default max_segment_size is set to 64K, same to the block
layer's default value.


diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 37c00f6..c93ebe8 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1392,6 +1392,13 @@ pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
 }
 #endif
 
+#ifndef HAVE_ARCH_PCI_SET_DMA_MAX_SEGMENT_SIZE
+int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size)
+{
+	return dma_set_max_seg_size(&dev->dev, size);
+}
+#endif
+
 /**
  * pcix_get_max_mmrbc - get PCI-X maximum designed memory read byte count
  * @dev: PCI device to query
@@ -1624,6 +1631,7 @@ EXPORT_SYMBOL(pci_clear_mwi);
 EXPORT_SYMBOL_GPL(pci_intx);
 EXPORT_SYMBOL(pci_set_dma_mask);
 EXPORT_SYMBOL(pci_set_consistent_dma_mask);
+EXPORT_SYMBOL(pci_set_dma_max_seg_size);
 EXPORT_SYMBOL(pci_assign_resource);
 EXPORT_SYMBOL(pci_find_parent_resource);
 EXPORT_SYMBOL(pci_select_bars);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 171ca71..2a18134 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -948,8 +948,11 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 
 	set_dev_node(&dev->dev, pcibus_to_node(bus));
 	dev->dev.dma_mask = &dev->dma_mask;
+	dev->dev.dma_parms = &dev->dma_parms;
 	dev->dev.coherent_dma_mask = 0xffffffffull;
 
+	pci_set_dma_max_seg_size(dev, 65536);
+
 	/* Fix up broken headers */
 	pci_fixup_device(pci_fixup_header, dev);
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 3a38d1f..3c24932 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -404,6 +404,15 @@ extern int devres_release_group(struct device *dev, void *id);
 extern void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp);
 extern void devm_kfree(struct device *dev, void *p);
 
+struct device_dma_parameters {
+	/*
+	 * a low level driver may set these to teach IOMMU code about
+	 * sg limitations.
+	 */
+	unsigned int max_segment_size;
+	unsigned long segment_boundary_mask;
+};
+
 struct device {
 	struct klist		klist_children;
 	struct klist_node	knode_parent;		/* node in sibling list */
@@ -439,6 +448,8 @@ struct device {
 					     64 bit addresses for consistent
 					     allocations such descriptors. */
 
+	struct device_dma_parameters *dma_parms;
+
 	struct list_head	dma_pools;	/* dma pools (if dma'ble) */
 
 	struct dma_coherent_mem	*dma_mem; /* internal for coherent mem
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 2dc21cb..02854c8 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -43,6 +43,21 @@ static inline int valid_dma_direction(int dma_direction)
 
 extern u64 dma_get_required_mask(struct device *dev);
 
+static inline unsigned int dma_get_max_seg_size(struct device *dev)
+{
+	return dev->dma_parms ? dev->dma_parms->max_segment_size : 65536;
+}
+
+static inline unsigned int dma_set_max_seg_size(struct device *dev,
+						unsigned int size)
+{
+	if (dev->dma_parms) {
+		dev->dma_parms->max_segment_size = size;
+		return 0;
+	} else
+		return -EIO;
+}
+
 /* flags for the coherent memory api */
 #define	DMA_MEMORY_MAP			0x01
 #define DMA_MEMORY_IO			0x02
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 038a0dc..1d630b5 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -151,6 +151,8 @@ struct pci_dev {
 					   this if your device has broken DMA
 					   or supports 64-bit transfers.  */
 
+	struct device_dma_parameters dma_parms;
+
 	pci_power_t     current_state;  /* Current operating state. In ACPI-speak,
 					   this is D0-D3, D0 being fully functional,
 					   and D3 being off. */
@@ -554,6 +556,7 @@ void pci_intx(struct pci_dev *dev, int enable);
 void pci_msi_off(struct pci_dev *dev);
 int pci_set_dma_mask(struct pci_dev *dev, u64 mask);
 int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask);
+int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size);
 int pcix_get_max_mmrbc(struct pci_dev *dev);
 int pcix_get_mmrbc(struct pci_dev *dev);
 int pcix_set_mmrbc(struct pci_dev *dev, int mmrbc);
@@ -739,6 +742,7 @@ static inline void pci_set_master(struct pci_dev *dev) { }
 static inline int pci_enable_device(struct pci_dev *dev) { return -EIO; }
 static inline void pci_disable_device(struct pci_dev *dev) { }
 static inline int pci_set_dma_mask(struct pci_dev *dev, u64 mask) { return -EIO; }
+static inline int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size) { return -EIO; }
 static inline int pci_assign_resource(struct pci_dev *dev, int i) { return -EBUSY;}
 static inline int __pci_register_driver(struct pci_driver *drv, struct module *owner) { return 0;}
 static inline int pci_register_driver(struct pci_driver *drv) { return 0;}
