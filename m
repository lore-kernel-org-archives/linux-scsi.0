From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: virtio_scsi: Use struct_size() helper
Date: Wed, 19 Jun 2019 14:28:33 -0500
Message-ID: <20190619192833.GA825@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct virtio_scsi {
	...
        struct virtio_scsi_vq req_vqs[];
};

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

So, replace the following form:

sizeof(*vscsi) + sizeof(vscsi->req_vqs[0]) * num_queues

with:

struct_size(vscsi, req_vqs, num_queues)

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/virtio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 13f1b3b9923a..ed4f79bffc73 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -795,7 +795,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	num_targets = virtscsi_config_get(vdev, max_target) + 1;
 
 	shost = scsi_host_alloc(&virtscsi_host_template,
-		sizeof(*vscsi) + sizeof(vscsi->req_vqs[0]) * num_queues);
+				struct_size(vscsi, req_vqs, num_queues));
 	if (!shost)
 		return -ENOMEM;
 
-- 
2.21.0
