From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3/5] virtio-scsi: allocate target pointers in a separate
	memory block
Date: Tue, 28 Aug 2012 13:54:15 +0200
Message-ID: <1346154857-12487-4-git-send-email-pbonzini@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

We will place the request virtqueues in the flexible array member.

Refining the virtqueue API would let us drop the sglist copy, at
which point the pointer-to-array-of-pointers can become a simple
pointer-to-array.  It would both simplify the allocation and remove a
dereference in several hot paths.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 595af1a..62fec04 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -77,7 +77,7 @@ struct virtio_scsi {
 	/* Get some buffers ready for event vq */
 	struct virtio_scsi_event_node event_list[VIRTIO_SCSI_EVENT_LEN];
 
-	struct virtio_scsi_target_state *tgt[];
+	struct virtio_scsi_target_state **tgt;
 };
 
 static struct kmem_cache *virtscsi_cmd_cache;
@@ -615,10 +615,13 @@ static void virtscsi_remove_vqs(struct virtio_device *vdev)
 	/* Stop all the virtqueues. */
 	vdev->config->reset(vdev);
 
-	num_targets = sh->max_id;
-	for (i = 0; i < num_targets; i++) {
-		kfree(vscsi->tgt[i]);
-		vscsi->tgt[i] = NULL;
+	if (vscsi->tgt) {
+		num_targets = sh->max_id;
+		for (i = 0; i < num_targets; i++) {
+			kfree(vscsi->tgt[i]);
+			vscsi->tgt[i] = NULL;
+		}
+		kfree(vscsi->tgt);
 	}
 
 	vdev->config->del_vqs(vdev);
@@ -660,6 +663,12 @@ static int virtscsi_init(struct virtio_device *vdev,
 	/* We need to know how many segments before we allocate.  */
 	sg_elems = virtscsi_config_get(vdev, seg_max) ?: 1;
 
+	vscsi->tgt = kmalloc(num_targets *
+			sizeof(struct virtio_scsi_target_state *), GFP_KERNEL);
+	if (!vscsi->tgt) {
+		err = -ENOMEM;
+		goto out;
+	}
 	for (i = 0; i < num_targets; i++) {
 		vscsi->tgt[i] = virtscsi_alloc_tgt(vdev, sg_elems);
 		if (!vscsi->tgt[i]) {
@@ -685,9 +694,7 @@ static int __devinit virtscsi_probe(struct virtio_device *vdev)
 
 	/* Allocate memory and link the structs together.  */
 	num_targets = virtscsi_config_get(vdev, max_target) + 1;
-	shost = scsi_host_alloc(&virtscsi_host_template,
-		sizeof(*vscsi)
-		+ num_targets * sizeof(struct virtio_scsi_target_state));
+	shost = scsi_host_alloc(&virtscsi_host_template, sizeof(*vscsi));
 
 	if (!shost)
 		return -ENOMEM;
-- 
1.7.1
