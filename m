From: Christoph Hellwig <hch@lst.de>
Subject: Re: Increased memory usage with scsi-mq
Date: Sat, 5 Aug 2017 15:39:54 +0200
Message-ID: <20170805133954.GA17694@lst.de>
References: <20170804210035.GA10017@redhat.com> <20170805084436.GA14264@lst.de> <20170805092704.GD20914@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170805092704.GD20914@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

For now can you apply this testing patch to the guest kernel?

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 9be211d68b15..0cbe2c882e1c 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -818,7 +818,7 @@ static struct scsi_host_template virtscsi_host_template_single = {
 	.eh_timed_out = virtscsi_eh_timed_out,
 	.slave_alloc = virtscsi_device_alloc,
 
-	.can_queue = 1024,
+	.can_queue = 64,
 	.dma_boundary = UINT_MAX,
 	.use_clustering = ENABLE_CLUSTERING,
 	.target_alloc = virtscsi_target_alloc,
@@ -839,7 +839,7 @@ static struct scsi_host_template virtscsi_host_template_multi = {
 	.eh_timed_out = virtscsi_eh_timed_out,
 	.slave_alloc = virtscsi_device_alloc,
 
-	.can_queue = 1024,
+	.can_queue = 64,
 	.dma_boundary = UINT_MAX,
 	.use_clustering = ENABLE_CLUSTERING,
 	.target_alloc = virtscsi_target_alloc,
@@ -983,7 +983,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	shost->max_id = num_targets;
 	shost->max_channel = 0;
 	shost->max_cmd_len = VIRTIO_SCSI_CDB_SIZE;
-	shost->nr_hw_queues = num_queues;
+	shost->nr_hw_queues = 1;
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_T10_PI)) {
