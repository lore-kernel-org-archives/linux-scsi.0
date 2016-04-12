From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 1/2] scsi: add a max_segment_size limitation to struct Scsi_Host
Date: Tue, 12 Apr 2016 07:13:24 -0700
Message-ID: <1460470405-11673-2-git-send-email-hch@lst.de>
References: <1460470405-11673-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460470405-11673-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

RDMA drivers need segments that aren't larger than a single HCA page
for memory registrations to work properly, so wire up this limitation
in the host.

While we could just call blk_queue_max_segment_size from ->slave_configure,
that would override the global limit based on the DMA device, so let's do
it the traditional way by adding a field to the Scsi_Host structure.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/scsi/scsi_lib.c  | 3 ++-
 include/scsi/scsi_host.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8106515..ad79372 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2120,7 +2120,8 @@ static void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 	blk_queue_segment_boundary(q, shost->dma_boundary);
 	dma_set_seg_boundary(dev, shost->dma_boundary);
 
-	blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));
+	blk_queue_max_segment_size(q, min_not_zero(shost->max_segment_size,
+						   dma_get_max_seg_size(dev)));
 
 	if (!shost->use_clustering)
 		q->limits.cluster = 0;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index fcfa3d7..f11d3fe 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -621,6 +621,7 @@ struct Scsi_Host {
 	short unsigned int sg_tablesize;
 	short unsigned int sg_prot_tablesize;
 	unsigned int max_sectors;
+	unsigned int max_segment_size;
 	unsigned long dma_boundary;
 	/*
 	 * In scsi-mq mode, the number of hardware queues supported by the LLD.
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
