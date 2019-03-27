From: Dongli Zhang <dongli.zhang@oracle.com>
Subject: [PATCH 1/2] virtio-blk: limit number of hw queues by nr_cpu_ids
Date: Wed, 27 Mar 2019 18:36:34 +0800
Message-ID: <1553682995-5682-2-git-send-email-dongli.zhang@oracle.com>
References: <1553682995-5682-1-git-send-email-dongli.zhang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553682995-5682-1-git-send-email-dongli.zhang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com, cohuck@redhat.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When tag_set->nr_maps is 1, the block layer limits the number of hw queues
by nr_cpu_ids. No matter how many hw queues are used by virtio-blk, as it
has (tag_set->nr_maps == 1), it can use at most nr_cpu_ids hw queues.

In addition, specifically for pci scenario, when the 'num-queues' specified
by qemu is more than maxcpus, virtio-blk would not be able to allocate more
than maxcpus vectors in order to have a vector for each queue. As a result,
it falls back into MSI-X with one vector for config and one shared for
queues.

Considering above reasons, this patch limits the number of hw queues used
by virtio-blk by nr_cpu_ids.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/block/virtio_blk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 4bc083b..b83cb45 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -513,6 +513,8 @@ static int init_vq(struct virtio_blk *vblk)
 	if (err)
 		num_vqs = 1;
 
+	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
+
 	vblk->vqs = kmalloc_array(num_vqs, sizeof(*vblk->vqs), GFP_KERNEL);
 	if (!vblk->vqs)
 		return -ENOMEM;
-- 
2.7.4
