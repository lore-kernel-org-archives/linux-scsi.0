From: Dongli Zhang <dongli.zhang@oracle.com>
Subject: [PATCH 2/2] scsi: virtio_scsi: limit number of hw queues by nr_cpu_ids
Date: Wed, 27 Mar 2019 18:36:35 +0800
Message-ID: <1553682995-5682-3-git-send-email-dongli.zhang@oracle.com>
References: <1553682995-5682-1-git-send-email-dongli.zhang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553682995-5682-1-git-send-email-dongli.zhang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com, cohuck@redhat.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When tag_set->nr_maps is 1, the block layer limits the number of hw queues
by nr_cpu_ids. No matter how many hw queues are used by virtio-scsi, as it
has (tag_set->nr_maps == 1), it can use at most nr_cpu_ids hw queues.

In addition, specifically for pci scenario, when the 'num_queues' specified
by qemu is more than maxcpus, virtio-scsi would not be able to allocate
more than maxcpus vectors in order to have a vector for each queue. As a
result, it falls back into MSI-X with one vector for config and one shared
for queues.

Considering above reasons, this patch limits the number of hw queues used
by virtio-scsi by nr_cpu_ids.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/scsi/virtio_scsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 8af0177..9c4a3e1 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -793,6 +793,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
 
 	/* We need to know how many queues before we allocate. */
 	num_queues = virtscsi_config_get(vdev, num_queues) ? : 1;
+	num_queues = min_t(unsigned int, nr_cpu_ids, num_queues);
 
 	num_targets = virtscsi_config_get(vdev, max_target) + 1;
 
-- 
2.7.4
