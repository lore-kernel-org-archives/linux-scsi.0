From: Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v17 4/4] PCI: Remove PCI pool macro functions
Date: Tue,  2 Jan 2018 18:53:56 +0100
Message-ID: <20180102175356.7999-5-romain.perier@gmail.com>
References: <20180102175356.7999-1-romain.perier@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180102175356.7999-1-romain.perier@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Aviad Krawczyk <aviad.krawczyk@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Cc: dmaengine@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Romain Perier <romain.perier@collabora.com>
List-Id: linux-scsi@vger.kernel.org

From: Romain Perier <romain.perier@collabora.com>

Now that all the drivers use dma pool API, we can remove the macro
functions for PCI pool.

Signed-off-by: Romain Perier <romain.perier@collabora.com>
Reviewed-by: Peter Senna Tschudin <peter.senna@collabora.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
---
 include/linux/pci.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 66cca1c6f742..c5dd05021b14 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1314,15 +1314,6 @@ int pci_set_vga_state(struct pci_dev *pdev, bool decode,
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
 	u32	vector;	/* Kernel uses to write allocated vector */
 	u16	entry;	/* Driver uses to specify entry, OS writes */
-- 
2.14.1
