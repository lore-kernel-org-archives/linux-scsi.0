From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH -mm 2/4] PCI: add dma segment boundary support
Date: Thu, 22 Nov 2007 11:43:26 +0900
Message-ID: <20071122113934N.tomof@acm.org>
References: <522edb7703e4a70374b0c689cd7bae659fb0908b.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47150 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756645AbXKVCoD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2007 21:44:03 -0500
In-Reply-To: <522edb7703e4a70374b0c689cd7bae659fb0908b.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, greg@kroah.com, jeff@garzik.org, fujita.tomonori@lab.ntt.co.jp

This adds PCI's accessor for segment_boundary_mask in
device_dma_parameters.

The default segment_boundary is set to 0xffffffff, same to the block
layer's default value (and the scsi mid layer uses the same value).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/pci/pci.c   |    8 ++++++++
 drivers/pci/probe.c |    1 +
 include/linux/pci.h |    2 ++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index de623cf..3b7e0e0 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1435,6 +1435,14 @@ int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size)
 EXPORT_SYMBOL(pci_set_dma_max_seg_size);
 #endif
 
+#ifndef HAVE_ARCH_PCI_SET_DMA_SEGMENT_BOUNDARY
+int pci_set_dma_seg_boundary(struct pci_dev *dev, unsigned long mask)
+{
+	return dma_set_seg_boundary(&dev->dev, mask);
+}
+EXPORT_SYMBOL(pci_set_dma_seg_boundary);
+#endif
+
 /**
  * pcix_get_max_mmrbc - get PCI-X maximum designed memory read byte count
  * @dev: PCI device to query
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index aa343e1..2e8b539 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -987,6 +987,7 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 	dev->dev.coherent_dma_mask = 0xffffffffull;
 
 	pci_set_dma_max_seg_size(dev, 65536);
+	pci_set_dma_seg_boundary(dev, 0xffffffff);
 
 	/* Fix up broken headers */
 	pci_fixup_device(pci_fixup_header, dev);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d56d0b6..a05a843 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -567,6 +567,7 @@ void pci_msi_off(struct pci_dev *dev);
 int pci_set_dma_mask(struct pci_dev *dev, u64 mask);
 int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask);
 int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size);
+int pci_set_dma_seg_boundary(struct pci_dev *dev, unsigned long mask);
 int pcix_get_max_mmrbc(struct pci_dev *dev);
 int pcix_get_mmrbc(struct pci_dev *dev);
 int pcix_set_mmrbc(struct pci_dev *dev, int mmrbc);
@@ -753,6 +754,7 @@ static inline int pci_enable_device(struct pci_dev *dev) { return -EIO; }
 static inline void pci_disable_device(struct pci_dev *dev) { }
 static inline int pci_set_dma_mask(struct pci_dev *dev, u64 mask) { return -EIO; }
 static inline int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size) { return -EIO; }
+static inline int pci_set_dma_seg_boundary(struct pci_dev *dev, unsigned long mask) { return -EIO; }
 static inline int pci_assign_resource(struct pci_dev *dev, int i) { return -EBUSY;}
 static inline int __pci_register_driver(struct pci_driver *drv, struct module *owner) { return 0;}
 static inline int pci_register_driver(struct pci_driver *drv) { return 0;}
-- 
1.5.3.4

