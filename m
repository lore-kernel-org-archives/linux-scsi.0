From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/13] rsxx: don't call dma_set_max_seg_size
Date: Wed,  5 Jun 2019 21:08:25 +0200
Message-ID: <20190605190836.32354-3-hch@lst.de>
References: <20190605190836.32354-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190605190836.32354-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Sebastian Ott <sebott@linux.ibm.com>, Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bvanassche@acm.org>, Ulf Hansson <ulf.hansson@linaro.org>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.com>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This driver does never uses dma_map_sg, so the setting is rather
pointless.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/rsxx/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index de9b2d2f8654..76b73ddf8fd7 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -767,7 +767,6 @@ static int rsxx_pci_probe(struct pci_dev *dev,
 		goto failed_enable;
 
 	pci_set_master(dev);
-	dma_set_max_seg_size(&dev->dev, RSXX_HW_BLK_SIZE);
 
 	st = dma_set_mask(&dev->dev, DMA_BIT_MASK(64));
 	if (st) {
-- 
2.20.1
