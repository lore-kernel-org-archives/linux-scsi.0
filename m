From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/8] ufshcd: set max_segment_size in the scsi host template
Date: Mon, 17 Jun 2019 14:19:55 +0200
Message-ID: <20190617122000.22181-4-hch@lst.de>
References: <20190617122000.22181-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190617122000.22181-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We need to also mirror the value to the device to ensure IOMMU merging
doesn't undo it, and the SCSI host level parameter will ensure that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ufs/ufshcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3fe3029617a8..505d625ed28d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4587,8 +4587,6 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	struct request_queue *q = sdev->request_queue;
 
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
-	blk_queue_max_segment_size(q, PRDT_DATA_BYTE_COUNT_MAX);
-
 	return 0;
 }
 
@@ -6991,6 +6989,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
 	.can_queue		= UFSHCD_CAN_QUEUE,
+	.max_segment_size	= PRDT_DATA_BYTE_COUNT_MAX,
 	.max_host_blocked	= 1,
 	.track_queue_depth	= 1,
 	.sdev_groups		= ufshcd_driver_groups,
-- 
2.20.1
