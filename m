From: Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v15 5/5] PCI: Remove PCI pool macro functions
Date: Mon, 20 Nov 2017 20:32:47 +0100
Message-ID: <20171120193247.8187-6-romain.perier@gmail.com>
References: <20171120193247.8187-1-romain.perier@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171120193247.8187-1-romain.perier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Aviad Krawczyk <aviad.krawczyk@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Cc: dmaengine@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Romain Perier <romain.perier@collabora.com>
List-Id: linux-scsi@vger.kernel.org

From: Romain Perier <romain.perier@collabora.com>

Now that all the drivers use dma pool API, we can remove the macro
functions for PCI pool.

Signed-off-by: Romain Perier <romain.perier@collabora.com>
Reviewed-by: Peter Senna Tschudin <peter.senna@collabora.com>
---
 include/linux/pci.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 96c94980d1ff..d03b4a20033d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1324,15 +1324,6 @@ int pci_set_vga_state(struct pci_dev *pdev, bool decode,
 #include <linux/pci-dma.h>
 #include <linux/dmapool.h>
 
-#define	pci_pool dma_pool
-#define pci_pool_create(name, pdev, size, align, allocation) \
-		dma_pool_create(name, &pdev->dev, size, align, allocation)
-#define	pci_pool_destroy(pool) dma_pool_destroy(pool)
-#define	pci_pool_alloc(pool, flags, handle) dma_pool_alloc(pool, flags, handle)
-#define	pci_pool_zalloc(pool, flags, handle) \
-		dma_pool_zalloc(pool, flags, handle)
-#define	pci_pool_free(pool, vaddr, addr) dma_pool_free(pool, vaddr, addr)
-
 struct msix_entry {
 	u32	vector;	/* kernel uses to write allocated vector */
 	u16	entry;	/* driver uses to specify entry, OS writes */
-- 
2.14.1
