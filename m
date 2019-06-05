From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/13] IB/srp: set virt_boundary_mask in the scsi host
Date: Wed,  5 Jun 2019 21:08:32 +0200
Message-ID: <20190605190836.32354-10-hch@lst.de>
References: <20190605190836.32354-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190605190836.32354-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Sebastian Ott <sebott@linux.ibm.com>, Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bvanassche@acm.org>, Ulf Hansson <ulf.hansson@linaro.org>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.com>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This ensures all proper DMA layer handling is taken care of by the
SCSI midlayer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index be9ddcad8f28..944fe8eee1ea 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3061,20 +3061,6 @@ static int srp_target_alloc(struct scsi_target *starget)
 	return 0;
 }
 
-static int srp_slave_alloc(struct scsi_device *sdev)
-{
-	struct Scsi_Host *shost = sdev->host;
-	struct srp_target_port *target = host_to_target(shost);
-	struct srp_device *srp_dev = target->srp_host->srp_dev;
-	struct ib_device *ibdev = srp_dev->dev;
-
-	if (!(ibdev->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG))
-		blk_queue_virt_boundary(sdev->request_queue,
-					~srp_dev->mr_page_mask);
-
-	return 0;
-}
-
 static int srp_slave_configure(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -3277,7 +3263,6 @@ static struct scsi_host_template srp_template = {
 	.name				= "InfiniBand SRP initiator",
 	.proc_name			= DRV_NAME,
 	.target_alloc			= srp_target_alloc,
-	.slave_alloc			= srp_slave_alloc,
 	.slave_configure		= srp_slave_configure,
 	.info				= srp_target_info,
 	.queuecommand			= srp_queuecommand,
@@ -3812,6 +3797,9 @@ static ssize_t srp_create_target(struct device *dev,
 	target_host->max_cmd_len = sizeof ((struct srp_cmd *) (void *) 0L)->cdb;
 	target_host->max_segment_size = ib_dma_max_seg_size(ibdev);
 
+	if (!(ibdev->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG))
+		target_host->virt_boundary_mask = ~srp_dev->mr_page_mask;
+
 	target = host_to_target(target_host);
 
 	target->net		= kobj_ns_grab_current(KOBJ_NS_TYPE_NET);
-- 
2.20.1
