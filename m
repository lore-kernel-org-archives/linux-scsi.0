From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 09/17] Update the virtgpu driver to use idr helper functions.
Date: Tue, 15 Sep 2015 09:46:09 -0700
Message-ID: <83e5daa0708729d4a3b6fda61c6ab8d70e501606.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Lee Duncan <lduncan@suse.com>, Gerd Hoffmann <kraxel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/gpu/drm/virtio/virtgpu_vq.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index 1698669f4185..380947dad306 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -41,21 +41,14 @@
 void virtio_gpu_resource_id_get(struct virtio_gpu_device *vgdev,
 				uint32_t *resid)
 {
-	int handle;
-
-	idr_preload(GFP_KERNEL);
-	spin_lock(&vgdev->resource_idr_lock);
-	handle = idr_alloc(&vgdev->resource_idr, NULL, 1, 0, GFP_NOWAIT);
-	spin_unlock(&vgdev->resource_idr_lock);
-	idr_preload_end();
-	*resid = handle;
+	*resid = idr_get_index_in_range(&vgdev->resource_idr,
+					&vgdev->resource_idr_lock,
+					NULL, 1, 0);
 }
 
 void virtio_gpu_resource_id_put(struct virtio_gpu_device *vgdev, uint32_t id)
 {
-	spin_lock(&vgdev->resource_idr_lock);
-	idr_remove(&vgdev->resource_idr, id);
-	spin_unlock(&vgdev->resource_idr_lock);
+	idr_put_index(&vgdev->resource_idr, &vgdev->resource_idr_lock, id);
 }
 
 void virtio_gpu_ctrl_ack(struct virtqueue *vq)
-- 
2.1.4
