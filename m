From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH -mm 02/11] PCI: add device_dma_parameters support
Date: Wed, 24 Oct 2007 19:48:06 +0900
Message-ID: <20071024165323F.tomof@acm.org>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:38553 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbXJXK6F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 06:58:05 -0400
In-Reply-To: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, greg@kroah.com, James.Bottomley@SteelEye.com, jeff@garzik.org, fujita.tomonori@lab.ntt.co.jp

This adds struct device_dma_parameters in struct pci_dev and properly
sets up a pointer in struct device.

The default max_segment_size is set to 64K, same to the block layer's
default value.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/pci/pci.c   |    8 ++++++++
 drivers/pci/probe.c |    3 +++
 include/linux/pci.h |    4 ++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 71d561f..de97c2b 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1397,6 +1397,14 @@ pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
 }
 #endif
 
+#ifndef HAVE_ARCH_PCI_SET_DMA_MAX_SEGMENT_SIZE
+int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size)
+{
+	return dma_set_max_seg_size(&dev->dev, size);
+}
+EXPORT_SYMBOL(pci_set_dma_max_seg_size);
+#endif
+
 /**
  * pcix_get_max_mmrbc - get PCI-X maximum designed memory read byte count
  * @dev: PCI device to query
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 463a5a9..54edea2 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -985,8 +985,11 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 
 	set_dev_node(&dev->dev, pcibus_to_node(bus));
 	dev->dev.dma_mask = &dev->dma_mask;
+	dev->dev.dma_parms = &dev->dma_parms;
 	dev->dev.coherent_dma_mask = 0xffffffffull;
 
+	pci_set_dma_max_seg_size(dev, 65536);
+
 	/* Fix up broken headers */
 	pci_fixup_device(pci_fixup_header, dev);
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5d2281f..f8cba3b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -152,6 +152,8 @@ struct pci_dev {
 					   this if your device has broken DMA
 					   or supports 64-bit transfers.  */
 
+	struct device_dma_parameters dma_parms;
+
 	pci_power_t     current_state;  /* Current operating state. In ACPI-speak,
 					   this is D0-D3, D0 being fully functional,
 					   and D3 being off. */
@@ -556,6 +558,7 @@ void pci_intx(struct pci_dev *dev, int enable);
 void pci_msi_off(struct pci_dev *dev);
 int pci_set_dma_mask(struct pci_dev *dev, u64 mask);
 int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask);
+int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size);
 int pcix_get_max_mmrbc(struct pci_dev *dev);
 int pcix_get_mmrbc(struct pci_dev *dev);
 int pcix_set_mmrbc(struct pci_dev *dev, int mmrbc);
@@ -744,6 +747,7 @@ static inline void pci_set_master(struct pci_dev *dev) { }
 static inline int pci_enable_device(struct pci_dev *dev) { return -EIO; }
 static inline void pci_disable_device(struct pci_dev *dev) { }
 static inline int pci_set_dma_mask(struct pci_dev *dev, u64 mask) { return -EIO; }
+static inline int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size) { return -EIO; }
 static inline int pci_assign_resource(struct pci_dev *dev, int i) { return -EBUSY;}
 static inline int __pci_register_driver(struct pci_driver *drv, struct module *owner) { return 0;}
 static inline int pci_register_driver(struct pci_driver *drv) { return 0;}
-- 
1.5.2.4

