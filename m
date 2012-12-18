From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 3/5] virtio-scsi: redo allocation of target data
Date: Tue, 18 Dec 2012 13:32:50 +0100
Message-ID: <1355833972-20319-4-git-send-email-pbonzini@redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
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
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com, hutao@cn.fujitsu.com, virtualization@lists.linux-foundation.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

virtio_scsi_target_state is now empty, but we will find new uses
for it in the next few patches.  However, dropping the sglist lets
us turn the array-of-pointers into a simple array, which simplifies
the allocation.

However, we do not leave the virtio_scsi_target_state structs in the
flexible array member at the end of struct virtio_scsi, because
we will place the virtqueues there in the next patches.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v1->v2: new

 drivers/scsi/virtio_scsi.c |   43 ++++++++++++++-----------------------------
 1 files changed, 14 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 2b93b6e..4a3abaf 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -74,7 +74,7 @@ struct virtio_scsi {
 	/* Get some buffers ready for event vq */
 	struct virtio_scsi_event_node event_list[VIRTIO_SCSI_EVENT_LEN];
 
-	struct virtio_scsi_target_state *tgt[];
+	struct virtio_scsi_target_state *tgt;
 };
 
 static struct kmem_cache *virtscsi_cmd_cache;
@@ -426,7 +426,7 @@ static int virtscsi_kick_cmd(struct virtio_scsi_target_state *tgt,
 static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 {
 	struct virtio_scsi *vscsi = shost_priv(sh);
-	struct virtio_scsi_target_state *tgt = vscsi->tgt[sc->device->id];
+	struct virtio_scsi_target_state *tgt = &vscsi->tgt[sc->device->id];
 	struct virtio_scsi_cmd *cmd;
 	int ret;
 
@@ -474,7 +474,7 @@ out:
 static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 {
 	DECLARE_COMPLETION_ONSTACK(comp);
-	struct virtio_scsi_target_state *tgt = vscsi->tgt[cmd->sc->device->id];
+	struct virtio_scsi_target_state *tgt = &vscsi->tgt[cmd->sc->device->id];
 	int ret = FAILED;
 
 	cmd->comp = &comp;
@@ -578,19 +578,9 @@ static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
 	virtscsi_vq->vq = vq;
 }
 
-static struct virtio_scsi_target_state *virtscsi_alloc_tgt(
-	struct virtio_device *vdev, int sg_elems)
+static void virtscsi_init_tgt(struct virtio_scsi_target_state *tgt)
 {
-	struct virtio_scsi_target_state *tgt;
-	gfp_t gfp_mask = GFP_KERNEL;
-
-	/* We need extra sg elements at head and tail.  */
-	tgt = kmalloc(sizeof(*tgt), gfp_mask);
-	if (!tgt)
-		return NULL;
-
 	spin_lock_init(&tgt->tgt_lock);
-	return tgt;
 }
 
 static void virtscsi_scan(struct virtio_device *vdev)
@@ -604,16 +594,12 @@ static void virtscsi_remove_vqs(struct virtio_device *vdev)
 {
 	struct Scsi_Host *sh = virtio_scsi_host(vdev);
 	struct virtio_scsi *vscsi = shost_priv(sh);
-	u32 i, num_targets;
 
 	/* Stop all the virtqueues. */
 	vdev->config->reset(vdev);
 
-	num_targets = sh->max_id;
-	for (i = 0; i < num_targets; i++) {
-		kfree(vscsi->tgt[i]);
-		vscsi->tgt[i] = NULL;
-	}
+	kfree(vscsi->tgt);
+	vscsi->tgt = NULL;
 
 	vdev->config->del_vqs(vdev);
 }
@@ -654,13 +640,14 @@ static int virtscsi_init(struct virtio_device *vdev,
 	/* We need to know how many segments before we allocate.  */
 	sg_elems = virtscsi_config_get(vdev, seg_max) ?: 1;
 
-	for (i = 0; i < num_targets; i++) {
-		vscsi->tgt[i] = virtscsi_alloc_tgt(vdev, sg_elems);
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
@@ -679,9 +666,7 @@ static int __devinit virtscsi_probe(struct virtio_device *vdev)
 
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
