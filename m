From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH] wd719x: remove dma_cache_sync call
Date: Wed, 26 Nov 2014 21:37:57 +0100
Message-ID: <1417034277-14412-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Kernel development list <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

dma_cache_sync() call breaks build on some architectures and
Arnd Bergmann said:
> dma_cache_sync only makes sense with buffers allocated through
> dma_alloc_noncoherent(), which this one is not. I suspect we can just
> remove the call to dma_cache_sync here, in particular since the
> buffer is passed to the device next, and dma_map_single has
> already done all the necessary synchronization.

Remove dma_cache_sync call to fix build on other architectures.
Driver still works fine on x86 without that.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/wd719x.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 23bb5a3..170f228 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -243,8 +243,6 @@ static int wd719x_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	scb->sense_buf_length = SCSI_SENSE_BUFFERSIZE;
 	cmd->SCp.dma_handle = dma_map_single(&wd->pdev->dev, cmd->sense_buffer,
 			SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
-	dma_cache_sync(&wd->pdev->dev, cmd->sense_buffer,
-			SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 	scb->sense_buf = cpu_to_le32(cmd->SCp.dma_handle);
 
 	/* request autosense */
-- 
Ondrej Zary
