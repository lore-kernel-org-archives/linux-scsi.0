From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH 2/2] virtio: virtio_scsi: Set can_queue to the length of the virtqueue.
Date: Thu, 10 Aug 2017 17:40:35 +0100
Message-ID: <20170810164035.19963-3-rjones@redhat.com>
References: <20170810164035.19963-1-rjones@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59282 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752776AbdHJQks (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 12:40:48 -0400
In-Reply-To: <20170810164035.19963-1-rjones@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com
Cc: martin.petersen@oracle.com, mst@redhat.com, jasowang@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, hch@lst.de, pbonzini@redhat.com

Since switching to blk-mq as the default in commit 5c279bd9e406
("scsi: default to scsi-mq"), virtio-scsi LUNs consume about 10x as
much kernel memory.

qemu currently allocates a fixed 128 entry virtqueue.  can_queue
currently is set to 1024.  But with indirect descriptors, each command
in the queue takes 1 virtqueue entry, so the number of commands which
can be queued is equal to the length of the virtqueue.

Note I intend to send a patch to qemu to allow the virtqueue size to
be configured from the qemu command line.

Thanks Paolo Bonzini, Christoph Hellwig.

Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 9be211d68b15..d6b4ff634c0d 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -972,6 +972,8 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	if (err)
 		goto virtscsi_init_failed;
 
+	shost->can_queue = virtqueue_get_vring_size(vscsi->req_vqs[0].vq);
+
 	cmd_per_lun = virtscsi_config_get(vdev, cmd_per_lun) ?: 1;
 	shost->cmd_per_lun = min_t(u32, cmd_per_lun, shost->can_queue);
 	shost->max_sectors = virtscsi_config_get(vdev, max_sectors) ?: 0xFFFF;
-- 
2.13.1
