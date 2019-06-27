From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 70/87] scsi: aacraid: remove memset after dma_alloc_coherent in rx.c
Date: Fri, 28 Jun 2019 01:46:05 +0800
Message-ID: <20190627174605.6260-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/aacraid/rx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index 3dea348bd25d..4d3484cbca26 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -353,7 +353,6 @@ static int aac_rx_check_health(struct aac_dev *dev)
 			dma_free_coherent(&dev->pdev->dev, 512, buffer, baddr);
 			return ret;
 		}
-		memset(buffer, 0, 512);
 		post->Post_Command = cpu_to_le32(COMMAND_POST_RESULTS);
 		post->Post_Address = cpu_to_le32(baddr);
 		rx_writel(dev, MUnit.IMRx[0], paddr);
-- 
2.11.0
