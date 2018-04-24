From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 2/5] ide: kill ide_toggle_bounce
Date: Tue, 24 Apr 2018 20:16:22 +0200
Message-ID: <20180424181625.22410-3-hch@lst.de>
References: <20180424181625.22410-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180424181625.22410-1-hch-jcswGhMUV9g@public.gmane.org>
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
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

ide_toggle_bounce did select various strange block bounce limits, including
not bouncing at all as soon as an iommu is present in the system.  Given
that the dma_map routines now handle any required bounce buffering except
for ISA DMA, and the ide code already must handle either ISA DMA or highmem
at least for iommu equipped systems we can get rid of the block layer
bounce limit setting entirely.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/ide/ide-dma.c   |  2 --
 drivers/ide/ide-lib.c   | 26 --------------------------
 drivers/ide/ide-probe.c |  3 ---
 include/linux/ide.h     |  2 --
 4 files changed, 33 deletions(-)

diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 54d4d78ca46a..6f344654ef22 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -180,7 +180,6 @@ EXPORT_SYMBOL_GPL(ide_dma_unmap_sg);
 void ide_dma_off_quietly(ide_drive_t *drive)
 {
 	drive->dev_flags &= ~IDE_DFLAG_USING_DMA;
-	ide_toggle_bounce(drive, 0);
 
 	drive->hwif->dma_ops->dma_host_set(drive, 0);
 }
@@ -211,7 +210,6 @@ EXPORT_SYMBOL(ide_dma_off);
 void ide_dma_on(ide_drive_t *drive)
 {
 	drive->dev_flags |= IDE_DFLAG_USING_DMA;
-	ide_toggle_bounce(drive, 1);
 
 	drive->hwif->dma_ops->dma_host_set(drive, 1);
 }
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index e1180fa46196..78cb79eddc8b 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -6,32 +6,6 @@
 #include <linux/ide.h>
 #include <linux/bitops.h>
 
-/**
- *	ide_toggle_bounce	-	handle bounce buffering
- *	@drive: drive to update
- *	@on: on/off boolean
- *
- *	Enable or disable bounce buffering for the device. Drives move
- *	between PIO and DMA and that changes the rules we need.
- */
-
-void ide_toggle_bounce(ide_drive_t *drive, int on)
-{
-	u64 addr = BLK_BOUNCE_HIGH;	/* dma64_addr_t */
-
-	if (!PCI_DMA_BUS_IS_PHYS) {
-		addr = BLK_BOUNCE_ANY;
-	} else if (on && drive->media == ide_disk) {
-		struct device *dev = drive->hwif->dev;
-
-		if (dev && dev->dma_mask)
-			addr = *dev->dma_mask;
-	}
-
-	if (drive->queue)
-		blk_queue_bounce_limit(drive->queue, addr);
-}
-
 u64 ide_get_lba_addr(struct ide_cmd *cmd, int lba48)
 {
 	struct ide_taskfile *tf = &cmd->tf;
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 2019e66eada7..8d8ed036ca0a 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -805,9 +805,6 @@ static int ide_init_queue(ide_drive_t *drive)
 	/* assign drive queue */
 	drive->queue = q;
 
-	/* needs drive->queue to be set */
-	ide_toggle_bounce(drive, 1);
-
 	return 0;
 }
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index ca9d34feb572..11f0dd03a4b4 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1508,8 +1508,6 @@ static inline void ide_set_hwifdata (ide_hwif_t * hwif, void *data)
 	hwif->hwif_data = data;
 }
 
-extern void ide_toggle_bounce(ide_drive_t *drive, int on);
-
 u64 ide_get_lba_addr(struct ide_cmd *, int);
 u8 ide_dump_status(ide_drive_t *, const char *, u8);
 
-- 
2.17.0
