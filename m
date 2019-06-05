From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/13] nvme-pci: don't limit DMA segement size
Date: Wed,  5 Jun 2019 21:08:24 +0200
Message-ID: <20190605190836.32354-2-hch@lst.de>
References: <20190605190836.32354-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190605190836.32354-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Sebastian Ott <sebott@linux.ibm.com>, Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bvanassche@acm.org>, Ulf Hansson <ulf.hansson@linaro.org>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.com>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

NVMe uses PRPs (or optionally unlimited SGLs) for data transfers and
has no specific limit for a single DMA segement.  Limiting the size
will cause problems because the block layer assumes PRP-ish devices
using a virt boundary mask don't have a segment limit.  And while this
is true, we also really need to tell the DMA mapping layer about it,
otherwise dma-debug will trip over it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Sebastian Ott <sebott@linux.ibm.com>
---
 drivers/nvme/host/pci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index f562154551ce..524d6bd6d095 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2513,6 +2513,12 @@ static void nvme_reset_work(struct work_struct *work)
 	 */
 	dev->ctrl.max_hw_sectors = NVME_MAX_KB_SZ << 1;
 	dev->ctrl.max_segments = NVME_MAX_SEGS;
+
+	/*
+	 * Don't limit the IOMMU merged segment size.
+	 */
+	dma_set_max_seg_size(dev->dev, 0xffffffff);
+
 	mutex_unlock(&dev->shutdown_lock);
 
 	/*
-- 
2.20.1
