From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH 1/2] virtio-scsi: split out request queue set affinity function
Date: Tue, 15 Jan 2013 17:48:19 +0800
Message-ID: <50F525E3.1000100@cn.fujitsu.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
Reply-To: gaowanlong@cn.fujitsu.com
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
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com, hutao@cn.fujitsu.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

These two patches are based on the multi-queue virtio-scsi patch set.

We set cpu affinity when the num_queues equals to the number
of VCPUs. Split out the set affinity function, this also
fix the bug when CPU IDs are not consecutive.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/scsi/virtio_scsi.c | 50 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 3641d5f..16b0ef2 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -106,6 +106,9 @@ struct virtio_scsi {
 
 	u32 num_queues;
 
+	/* Does the affinity hint is set for virtqueues? */
+	bool affinity_hint_set;
+
 	struct virtio_scsi_vq ctrl_vq;
 	struct virtio_scsi_vq event_vq;
 	struct virtio_scsi_vq req_vqs[];
@@ -701,14 +704,45 @@ static struct scsi_host_template virtscsi_host_template_multi = {
 				  &__val, sizeof(__val)); \
 	})
 
+static void virtscsi_set_affinity(struct virtio_scsi *vscsi, bool affinity)
+{
+	int i;
+	int cpu;
+
+	/* In multiqueue mode, when the number of cpu is equal
+	 * to the number of request queues, we let the qeueues
+	 * to be private to one cpu by setting the affinity hint
+	 * to eliminate the contention.
+	 */
+	if ((vscsi->num_queues == 1 ||
+	     vscsi->num_queues != num_online_cpus()) && affinity) {
+		if (vscsi->affinity_hint_set)
+			affinity = false;
+		else
+			return;
+	}
+
+	if (affinity) {
+		i = 0;
+		for_each_online_cpu(cpu) {
+			virtqueue_set_affinity(vscsi->req_vqs[i].vq, cpu);
+			i++;
+		}
+
+		vscsi->affinity_hint_set = true;
+	} else {
+		for (i = 0; i < vscsi->num_queues - VIRTIO_SCSI_VQ_BASE; i++)
+			virtqueue_set_affinity(vscsi->req_vqs[i].vq, -1);
+
+		vscsi->affinity_hint_set = false;
+	}
+}
 
 static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
-			     struct virtqueue *vq, bool affinity)
+			     struct virtqueue *vq)
 {
 	spin_lock_init(&virtscsi_vq->vq_lock);
 	virtscsi_vq->vq = vq;
-	if (affinity)
-		virtqueue_set_affinity(vq, vq->index - VIRTIO_SCSI_VQ_BASE);
 }
 
 static void virtscsi_init_tgt(struct virtio_scsi *vscsi, int i)
@@ -736,6 +770,8 @@ static void virtscsi_remove_vqs(struct virtio_device *vdev)
 	struct Scsi_Host *sh = virtio_scsi_host(vdev);
 	struct virtio_scsi *vscsi = shost_priv(sh);
 
+	virtscsi_set_affinity(vscsi, false);
+
 	/* Stop all the virtqueues. */
 	vdev->config->reset(vdev);
 
@@ -779,11 +815,13 @@ static int virtscsi_init(struct virtio_device *vdev,
 	if (err)
 		return err;
 
-	virtscsi_init_vq(&vscsi->ctrl_vq, vqs[0], false);
-	virtscsi_init_vq(&vscsi->event_vq, vqs[1], false);
+	virtscsi_init_vq(&vscsi->ctrl_vq, vqs[0]);
+	virtscsi_init_vq(&vscsi->event_vq, vqs[1]);
 	for (i = VIRTIO_SCSI_VQ_BASE; i < num_vqs; i++)
 		virtscsi_init_vq(&vscsi->req_vqs[i - VIRTIO_SCSI_VQ_BASE],
-				 vqs[i], vscsi->num_queues > 1);
+				 vqs[i]);
+
+	virtscsi_set_affinity(vscsi, true);
 
 	virtscsi_config_set(vdev, cdb_size, VIRTIO_SCSI_CDB_SIZE);
 	virtscsi_config_set(vdev, sense_size, VIRTIO_SCSI_SENSE_SIZE);
-- 
1.8.1
