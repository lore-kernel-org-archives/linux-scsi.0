From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/8] scsi: add a host / host template field for the virt boundary
Date: Mon, 17 Jun 2019 14:19:53 +0200
Message-ID: <20190617122000.22181-2-hch@lst.de>
References: <20190617122000.22181-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190617122000.22181-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This allows drivers setting it up easily instead of branching out to
block layer calls in slave_alloc, and ensures the upgraded
max_segment_size setting gets picked up by the DMA layer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/hosts.c     | 3 +++
 drivers/scsi/scsi_lib.c  | 3 ++-
 include/scsi/scsi_host.h | 3 +++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index ff0d8c6a8d0c..55522b7162d3 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -462,6 +462,9 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	else
 		shost->dma_boundary = 0xffffffff;
 
+	if (sht->virt_boundary_mask)
+		shost->virt_boundary_mask = sht->virt_boundary_mask;
+
 	device_initialize(&shost->shost_gendev);
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
 	shost->shost_gendev.bus = &scsi_bus_type;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 65d0a10c76ad..d333bb6b1c59 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1775,7 +1775,8 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 	dma_set_seg_boundary(dev, shost->dma_boundary);
 
 	blk_queue_max_segment_size(q, shost->max_segment_size);
-	dma_set_max_seg_size(dev, shost->max_segment_size);
+	blk_queue_virt_boundary(q, shost->virt_boundary_mask);
+	dma_set_max_seg_size(dev, queue_max_segment_size(q));
 
 	/*
 	 * Set a reasonable default alignment:  The larger of 32-byte (dword),
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index a5fcdad4a03e..cc139dbd71e5 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -369,6 +369,8 @@ struct scsi_host_template {
 	 */
 	unsigned long dma_boundary;
 
+	unsigned long virt_boundary_mask;
+
 	/*
 	 * This specifies "machine infinity" for host templates which don't
 	 * limit the transfer size.  Note this limit represents an absolute
@@ -587,6 +589,7 @@ struct Scsi_Host {
 	unsigned int max_sectors;
 	unsigned int max_segment_size;
 	unsigned long dma_boundary;
+	unsigned long virt_boundary_mask;
 	/*
 	 * In scsi-mq mode, the number of hardware queues supported by the LLD.
 	 *
-- 
2.20.1
