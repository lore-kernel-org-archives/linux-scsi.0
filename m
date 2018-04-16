From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 04/12] DAC960: don't use block layer bounce buffers
Date: Mon, 16 Apr 2018 10:50:24 +0200
Message-ID: <20180416085032.7367-5-hch@lst.de>
References: <20180416085032.7367-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180416085032.7367-1-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

DAC960 just sets the block bounce limit to the dma mask, which means
that the iommu or swiotlb already take care of the bounce buffering,
and the block bouncing can be removed.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/block/DAC960.c | 9 ++-------
 drivers/block/DAC960.h | 1 -
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index f781eff7d23e..c9ba48519d0f 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -1179,7 +1179,6 @@ static bool DAC960_V1_EnableMemoryMailboxInterface(DAC960_Controller_T
 
   if (pci_set_dma_mask(Controller->PCIDevice, DMA_BIT_MASK(32)))
 	return DAC960_Failure(Controller, "DMA mask out of range");
-  Controller->BounceBufferLimit = DMA_BIT_MASK(32);
 
   if ((hw_type == DAC960_PD_Controller) || (hw_type == DAC960_P_Controller)) {
     CommandMailboxesSize =  0;
@@ -1380,11 +1379,8 @@ static bool DAC960_V2_EnableMemoryMailboxInterface(DAC960_Controller_T
   dma_addr_t	CommandMailboxDMA;
   DAC960_V2_CommandStatus_T CommandStatus;
 
-	if (!pci_set_dma_mask(Controller->PCIDevice, DMA_BIT_MASK(64)))
-		Controller->BounceBufferLimit = DMA_BIT_MASK(64);
-	else if (!pci_set_dma_mask(Controller->PCIDevice, DMA_BIT_MASK(32)))
-		Controller->BounceBufferLimit = DMA_BIT_MASK(32);
-	else
+	if (pci_set_dma_mask(Controller->PCIDevice, DMA_BIT_MASK(64)) &&
+	    pci_set_dma_mask(Controller->PCIDevice, DMA_BIT_MASK(32)))
 		return DAC960_Failure(Controller, "DMA mask out of range");
 
   /* This is a temporary dma mapping, used only in the scope of this function */
@@ -2540,7 +2536,6 @@ static bool DAC960_RegisterBlockDevice(DAC960_Controller_T *Controller)
 		continue;
   	}
   	Controller->RequestQueue[n] = RequestQueue;
-  	blk_queue_bounce_limit(RequestQueue, Controller->BounceBufferLimit);
   	RequestQueue->queuedata = Controller;
 	blk_queue_max_segments(RequestQueue, Controller->DriverScatterGatherLimit);
 	blk_queue_max_hw_sectors(RequestQueue, Controller->MaxBlocksPerCommand);
diff --git a/drivers/block/DAC960.h b/drivers/block/DAC960.h
index 21aff470d268..1439e651928b 100644
--- a/drivers/block/DAC960.h
+++ b/drivers/block/DAC960.h
@@ -2295,7 +2295,6 @@ typedef struct DAC960_Controller
   unsigned short MaxBlocksPerCommand;
   unsigned short ControllerScatterGatherLimit;
   unsigned short DriverScatterGatherLimit;
-  u64		BounceBufferLimit;
   unsigned int CombinedStatusBufferLength;
   unsigned int InitialStatusLength;
   unsigned int CurrentStatusLength;
-- 
2.17.0
