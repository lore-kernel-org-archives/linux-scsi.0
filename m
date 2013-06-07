From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 1/3] [SCSI] megaraid: Remove 64-bit DMA_BIT_MASK capability
Date: Fri, 07 Jun 2013 10:23:35 -0600
Message-ID: <20130607162335.11205.24556.stgit@amt.stowe>
References: <20130607162329.11205.95093.stgit@amt.stowe>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130607162329.11205.95093.stgit@amt.stowe>
Sender: linux-kernel-owner@vger.kernel.org
To: megaraidlinux@lsi.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If the megaraid device is 64-bit DMA capable then, once it is setup, any
subsequent DMA allocations for "internal commands" would not be properly
restricted due to megaraid_probe_one() having called pci_set_dma_mask() on
pdev with DMA_BIT_MASK(64).  The driver attempts to solve this by using
make_local_pdev() to dynamically create local pci_dev structures which are
then set and used for allocating 32-bit address space restricted DMA
buffers but I don't believe that the implementation works as intended.

For a 64-bit DMA capable device, the "originating pdev" will have its
'dma_mask' set to 0xffffffffffffffff after the driver attaches.
Subsequently, when an internal command is initiated, make_local_pdev() is
called.  make_local_pdev() uses the PCI's core to allocate a "local pdev"
and then copies the "originating pdev" content into the newly allocated
"local pdev".  As a result of copying the "originating pdev" content into
the "local pdev", pdev->dev.dma_mask will be pointing back to the
"originating pdev's" 'dma_mask' member, not the "local pdev's" as
intended.  Thus, when make_local_pdev() calls pci_set_dma_mask() in an
attempt to set the "local pdev's" DMA mask to 32 it will instead overwrite
the "originating pdev's" DMA mask.  So, after any user initiated commands
are issued, all subsequent DMA allocations will be 32-bit restricted from
that point onward regardless of whether they are internal commands or
otherwise.

This patch fixes the issue by removing the setup of DMA_BIT_MASK to 64 in
megaraid_probe_one(), leaving the driver setup for default 32-bit DMA
capabilities, as it currently ends up in such a state anyway after any
internal commands are initiated.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/scsi/megaraid.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 846f475..32cca61 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4535,14 +4535,9 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	mcontroller[i].uid = (pci_bus << 8) | pci_dev_func;
 
 
-	/* Set the Mode of addressing to 64 bit if we can */
-	if ((adapter->flag & BOARD_64BIT) && (sizeof(dma_addr_t) == 8)) {
-		pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
-		adapter->has_64bit_addr = 1;
-	} else  {
-		pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-		adapter->has_64bit_addr = 0;
-	}
+	/* Set the Mode of addressing to 32 bit */
+	pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	adapter->has_64bit_addr = 0;
 		
 	mutex_init(&adapter->int_mtx);
 	init_completion(&adapter->int_waitq);
