From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH V5 1/5] virtio-scsi: redo allocation of target data
Date: Tue, 19 Mar 2013 17:57:33 +0800
Message-ID: <1363687057-13580-2-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1363687057-13580-1-git-send-email-gaowanlong@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1363687057-13580-1-git-send-email-gaowanlong@cn.fujitsu.com>
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
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, JBottomley@parallels.com, virtualization@lists.linux-foundation.org, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

virtio_scsi_target_state is now empty.  We will find new uses for it in
the next few patches, so this patch does not drop it completely.
However, having dropped the sglist flexible array member, we can turn
the tgt array-of-pointers into a simple array.  This simplifies the
allocation.

Even simpler would be to place the virtio_scsi_target_state structs in a
flexible array member at the end of struct virtio_scsi.  But we do not
do that, because we will place the virtqueues there in the next patches.

Cc: linux-scsi@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/scsi/virtio_scsi.c | 40 +++++++++++-----------------------------
 1 file changed, 11 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index b53ba9e..3256c51 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -76,7 +76,7 @@ struct virtio_scsi {
 	/* Get some buffers ready for event vq */
 	struct virtio_scsi_event_node event_list[VIRTIO_SCSI_EVENT_LEN];
 
-	struct virtio_scsi_target_state *tgt[];
+	struct virtio_scsi_target_state *tgt;
 };
 
 static struct kmem_cache *virtscsi_cmd_cache;
@@ -568,18 +568,9 @@ static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
 	virtscsi_vq->vq = vq;
 }
 
-static struct virtio_scsi_target_state *virtscsi_alloc_tgt(
-	struct virtio_device *vdev)
+static void virtscsi_init_tgt(struct virtio_scsi_target_state *tgt)
 {
-	struct virtio_scsi_target_state *tgt;
-	gfp_t gfp_mask = GFP_KERNEL;
-
-	tgt = kmalloc(sizeof(*tgt), gfp_mask);
-	if (!tgt)
-		return NULL;
-
 	spin_lock_init(&tgt->tgt_lock);
-	return tgt;
 }
 
 static void virtscsi_scan(struct virtio_device *vdev)
@@ -593,17 +584,10 @@ static void virtscsi_remove_vqs(struct virtio_device *vdev)
 {
 	struct Scsi_Host *sh = virtio_scsi_host(vdev);
 	struct virtio_scsi *vscsi = shost_priv(sh);
-	u32 i, num_targets;
 
 	/* Stop all the virtqueues. */
 	vdev->config->reset(vdev);
-
-	num_targets = sh->max_id;
-	for (i = 0; i < num_targets; i++) {
-		kfree(vscsi->tgt[i]);
-		vscsi->tgt[i] = NULL;
-	}
-
+	kfree(vscsi->tgt);
 	vdev->config->del_vqs(vdev);
 }
 
@@ -640,13 +624,14 @@ static int virtscsi_init(struct virtio_device *vdev,
 	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
 		virtscsi_kick_event_all(vscsi);
 
-	for (i = 0; i < num_targets; i++) {
-		vscsi->tgt[i] = virtscsi_alloc_tgt(vdev);
-		if (!vscsi->tgt[i]) {
-			err = -ENOMEM;
-			goto out;
-		}
+	vscsi->tgt = kmalloc(num_targets * sizeof(vscsi->tgt[0]), GFP_KERNEL);
+	if (!vscsi->tgt) {
+		err = -ENOMEM;
+		goto out;
 	}
+	for (i = 0; i < num_targets; i++)
+		virtscsi_init_tgt(&vscsi->tgt[i]);
+
 	err = 0;
 
 out:
@@ -665,10 +650,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
 
 	/* Allocate memory and link the structs together.  */
 	num_targets = virtscsi_config_get(vdev, max_target) + 1;
-	shost = scsi_host_alloc(&virtscsi_host_template,
-		sizeof(*vscsi)
-		+ num_targets * sizeof(struct virtio_scsi_target_state));
-
+	shost = scsi_host_alloc(&virtscsi_host_template, sizeof(*vscsi));
 	if (!shost)
 		return -ENOMEM;
 
-- 
1.8.2.rc2
