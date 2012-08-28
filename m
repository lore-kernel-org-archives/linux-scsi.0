From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5/5] virtio-scsi: introduce multiqueue support
Date: Tue, 28 Aug 2012 13:54:17 +0200
Message-ID: <1346154857-12487-6-git-send-email-pbonzini@redhat.com>
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

This patch adds queue steering to virtio-scsi.  When a target is sent
multiple requests, we always drive them to the same queue so that FIFO
processing order is kept.  However, if a target was idle, we can choose
a queue arbitrarily.  In this case the queue is chosen according to the
current VCPU, so the driver expects the number of request queues to be
equal to the number of VCPUs.  This makes it easy and fast to select
the queue, and also lets the driver optimize the IRQ affinity for the
virtqueues (each virtqueue's affinity is set to the CPU that "owns"
the queue).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c |  162 +++++++++++++++++++++++++++++++++++---------
 1 files changed, 130 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 6414ea0..0c4b096 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -26,6 +26,7 @@
 
 #define VIRTIO_SCSI_MEMPOOL_SZ 64
 #define VIRTIO_SCSI_EVENT_LEN 8
+#define VIRTIO_SCSI_VQ_BASE 2
 
 /* Command queue element */
 struct virtio_scsi_cmd {
@@ -59,9 +60,13 @@ struct virtio_scsi_vq {
 
 /* Per-target queue state */
 struct virtio_scsi_target_state {
-	/* Protects sg.  Lock hierarchy is tgt_lock -> vq_lock.  */
+	/* Protects sg, req_vq.  Lock hierarchy is tgt_lock -> vq_lock.  */
 	spinlock_t tgt_lock;
 
+	struct virtio_scsi_vq *req_vq;
+
+	atomic_t reqs;
+
 	/* For sglist construction when adding commands to the virtqueue.  */
 	struct scatterlist sg[];
 };
@@ -70,14 +75,15 @@ struct virtio_scsi_target_state {
 struct virtio_scsi {
 	struct virtio_device *vdev;
 
-	struct virtio_scsi_vq ctrl_vq;
-	struct virtio_scsi_vq event_vq;
-	struct virtio_scsi_vq req_vq;
-
 	/* Get some buffers ready for event vq */
 	struct virtio_scsi_event_node event_list[VIRTIO_SCSI_EVENT_LEN];
 
+	u32 num_queues;
 	struct virtio_scsi_target_state **tgt;
+
+	struct virtio_scsi_vq ctrl_vq;
+	struct virtio_scsi_vq event_vq;
+	struct virtio_scsi_vq req_vqs[];
 };
 
 static struct kmem_cache *virtscsi_cmd_cache;
@@ -112,6 +118,9 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 	struct virtio_scsi_cmd *cmd = buf;
 	struct scsi_cmnd *sc = cmd->sc;
 	struct virtio_scsi_cmd_resp *resp = &cmd->resp.cmd;
+	struct virtio_scsi_target_state *tgt = vscsi->tgt[sc->device->id];
+
+	atomic_dec(&tgt->reqs);
 
 	dev_dbg(&sc->device->sdev_gendev,
 		"cmd %p response %u status %#02x sense_len %u\n",
@@ -185,11 +194,13 @@ static void virtscsi_req_done(struct virtqueue *vq)
 {
 	struct Scsi_Host *sh = virtio_scsi_host(vq->vdev);
 	struct virtio_scsi *vscsi = shost_priv(sh);
+	int index = virtqueue_get_queue_index(vq) - VIRTIO_SCSI_VQ_BASE;
+	struct virtio_scsi_vq *req_vq = &vscsi->req_vqs[index];
 	unsigned long flags;
 
-	spin_lock_irqsave(&vscsi->req_vq.vq_lock, flags);
+	spin_lock_irqsave(&req_vq->vq_lock, flags);
 	virtscsi_vq_done(vscsi, vq, virtscsi_complete_cmd);
-	spin_unlock_irqrestore(&vscsi->req_vq.vq_lock, flags);
+	spin_unlock_irqrestore(&req_vq->vq_lock, flags);
 };
 
 static void virtscsi_complete_free(struct virtio_scsi *vscsi, void *buf)
@@ -429,10 +440,10 @@ static int virtscsi_kick_cmd(struct virtio_scsi_target_state *tgt,
 	return ret;
 }
 
-static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
+static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
+				 struct virtio_scsi_target_state *tgt,
+				 struct scsi_cmnd *sc)
 {
-	struct virtio_scsi *vscsi = shost_priv(sh);
-	struct virtio_scsi_target_state *tgt = vscsi->tgt[sc->device->id];
 	struct virtio_scsi_cmd *cmd;
 	int ret;
 
@@ -466,7 +477,7 @@ static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
 	memcpy(cmd->req.cmd.cdb, sc->cmnd, sc->cmd_len);
 
-	if (virtscsi_kick_cmd(tgt, &vscsi->req_vq, cmd,
+	if (virtscsi_kick_cmd(tgt, tgt->req_vq, cmd,
 			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
 			      GFP_ATOMIC) >= 0)
 		ret = 0;
@@ -475,6 +486,38 @@ out:
 	return ret;
 }
 
+static int virtscsi_queuecommand_single(struct Scsi_Host *sh,
+					struct scsi_cmnd *sc)
+{
+	struct virtio_scsi *vscsi = shost_priv(sh);
+	struct virtio_scsi_target_state *tgt = vscsi->tgt[sc->device->id];
+
+	atomic_inc(&tgt->reqs);
+	return virtscsi_queuecommand(vscsi, tgt, sc);
+}
+
+static int virtscsi_queuecommand_multi(struct Scsi_Host *sh,
+				       struct scsi_cmnd *sc)
+{
+	struct virtio_scsi *vscsi = shost_priv(sh);
+	struct virtio_scsi_target_state *tgt = vscsi->tgt[sc->device->id];
+	unsigned long flags;
+	u32 queue_num;
+
+	/* Using an atomic_t for tgt->reqs lets the virtqueue handler
+	 * decrement it without taking the spinlock.
+	 */
+	spin_lock_irqsave(&tgt->tgt_lock, flags);
+	if (atomic_inc_return(&tgt->reqs) == 1) {
+		queue_num = smp_processor_id();
+		while (unlikely(queue_num >= vscsi->num_queues))
+			queue_num -= vscsi->num_queues;
+		tgt->req_vq = &vscsi->req_vqs[queue_num];
+	}
+	spin_unlock_irqrestore(&tgt->tgt_lock, flags);
+	return virtscsi_queuecommand(vscsi, tgt, sc);
+}
+
 static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 {
 	DECLARE_COMPLETION_ONSTACK(comp);
@@ -544,12 +585,26 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
 	return virtscsi_tmf(vscsi, cmd);
 }
 
-static struct scsi_host_template virtscsi_host_template = {
+static struct scsi_host_template virtscsi_host_template_single = {
 	.module = THIS_MODULE,
 	.name = "Virtio SCSI HBA",
 	.proc_name = "virtio_scsi",
-	.queuecommand = virtscsi_queuecommand,
 	.this_id = -1,
+	.queuecommand = virtscsi_queuecommand_single,
+	.eh_abort_handler = virtscsi_abort,
+	.eh_device_reset_handler = virtscsi_device_reset,
+
+	.can_queue = 1024,
+	.dma_boundary = UINT_MAX,
+	.use_clustering = ENABLE_CLUSTERING,
+};
+
+static struct scsi_host_template virtscsi_host_template_multi = {
+	.module = THIS_MODULE,
+	.name = "Virtio SCSI HBA",
+	.proc_name = "virtio_scsi",
+	.this_id = -1,
+	.queuecommand = virtscsi_queuecommand_multi,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
 
@@ -575,15 +630,19 @@ static struct scsi_host_template virtscsi_host_template = {
 				  &__val, sizeof(__val)); \
 	})
 
+
 static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
-			     struct virtqueue *vq)
+			     struct virtqueue *vq, bool affinity)
 {
 	spin_lock_init(&virtscsi_vq->vq_lock);
 	virtscsi_vq->vq = vq;
+	if (affinity)
+		virtqueue_set_affinity(vq, virtqueue_get_queue_index(vq) -
+				       VIRTIO_SCSI_VQ_BASE);
 }
 
 static struct virtio_scsi_target_state *virtscsi_alloc_tgt(
-	struct virtio_device *vdev, int sg_elems)
+	struct virtio_scsi *vscsi, u32 sg_elems)
 {
 	struct virtio_scsi_target_state *tgt;
 	gfp_t gfp_mask = GFP_KERNEL;
@@ -597,6 +656,13 @@ static struct virtio_scsi_target_state *virtscsi_alloc_tgt(
 
 	spin_lock_init(&tgt->tgt_lock);
 	sg_init_table(tgt->sg, sg_elems + 2);
+	atomic_set(&tgt->reqs, 0);
+
+	/*
+	 * The default is unused for multiqueue, but with a single queue
+	 * or target we use it in virtscsi_queuecommand.
+	 */
+	tgt->req_vq = &vscsi->req_vqs[0];
 	return tgt;
 }
 
@@ -632,28 +698,41 @@ static int virtscsi_init(struct virtio_device *vdev,
 			 struct virtio_scsi *vscsi, int num_targets)
 {
 	int err;
-	struct virtqueue *vqs[3];
 	u32 i, sg_elems;
+	u32 num_vqs;
+	vq_callback_t **callbacks;
+	const char **names;
+	struct virtqueue **vqs;
 
-	vq_callback_t *callbacks[] = {
-		virtscsi_ctrl_done,
-		virtscsi_event_done,
-		virtscsi_req_done
-	};
-	const char *names[] = {
-		"control",
-		"event",
-		"request"
-	};
+	num_vqs = vscsi->num_queues + VIRTIO_SCSI_VQ_BASE;
+	vqs = kmalloc(num_vqs * sizeof(struct virtqueue *), GFP_KERNEL);
+	callbacks = kmalloc(num_vqs * sizeof(vq_callback_t *), GFP_KERNEL);
+	names = kmalloc(num_vqs * sizeof(char *), GFP_KERNEL);
+
+	if (!callbacks || !vqs || !names) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	callbacks[0] = virtscsi_ctrl_done;
+	callbacks[1] = virtscsi_event_done;
+	names[0] = "control";
+	names[1] = "event";
+	for (i = VIRTIO_SCSI_VQ_BASE; i < num_vqs; i++) {
+		callbacks[i] = virtscsi_req_done;
+		names[i] = "request";
+	}
 
 	/* Discover virtqueues and write information to configuration.  */
-	err = vdev->config->find_vqs(vdev, 3, vqs, callbacks, names);
+	err = vdev->config->find_vqs(vdev, num_vqs, vqs, callbacks, names);
 	if (err)
 		return err;
 
-	virtscsi_init_vq(&vscsi->ctrl_vq, vqs[0]);
-	virtscsi_init_vq(&vscsi->event_vq, vqs[1]);
-	virtscsi_init_vq(&vscsi->req_vq, vqs[2]);
+	virtscsi_init_vq(&vscsi->ctrl_vq, vqs[0], false);
+	virtscsi_init_vq(&vscsi->event_vq, vqs[1], false);
+	for (i = VIRTIO_SCSI_VQ_BASE; i < num_vqs; i++)
+		virtscsi_init_vq(&vscsi->req_vqs[i - VIRTIO_SCSI_VQ_BASE],
+				 vqs[i], vscsi->num_queues > 1);
 
 	virtscsi_config_set(vdev, cdb_size, VIRTIO_SCSI_CDB_SIZE);
 	virtscsi_config_set(vdev, sense_size, VIRTIO_SCSI_SENSE_SIZE);
@@ -671,7 +750,7 @@ static int virtscsi_init(struct virtio_device *vdev,
 		goto out;
 	}
 	for (i = 0; i < num_targets; i++) {
-		vscsi->tgt[i] = virtscsi_alloc_tgt(vdev, sg_elems);
+		vscsi->tgt[i] = virtscsi_alloc_tgt(vscsi, sg_elems);
 		if (!vscsi->tgt[i]) {
 			err = -ENOMEM;
 			goto out;
@@ -680,6 +759,9 @@ static int virtscsi_init(struct virtio_device *vdev,
 	err = 0;
 
 out:
+	kfree(names);
+	kfree(callbacks);
+	kfree(vqs);
 	if (err)
 		virtscsi_remove_vqs(vdev);
 	return err;
@@ -692,11 +774,26 @@ static int __devinit virtscsi_probe(struct virtio_device *vdev)
 	int err;
 	u32 sg_elems, num_targets;
 	u32 cmd_per_lun;
+	u32 num_queues;
+	struct scsi_host_template *hostt;
+
+	/* We need to know how many queues before we allocate.  */
+	num_queues = virtscsi_config_get(vdev, num_queues) ?: 1;
 
 	/* Allocate memory and link the structs together.  */
 	num_targets = virtscsi_config_get(vdev, max_target) + 1;
-	shost = scsi_host_alloc(&virtscsi_host_template, sizeof(*vscsi));
 
+	/* Multiqueue is not beneficial with a single target.  */
+	if (num_targets == 1)
+		num_queues = 1;
+
+	if (num_queues == 1)
+		hostt = &virtscsi_host_template_single;
+	else
+		hostt = &virtscsi_host_template_multi;
+
+	shost = scsi_host_alloc(hostt,
+		sizeof(*vscsi) + sizeof(vscsi->req_vqs[0]) * num_queues);
 	if (!shost)
 		return -ENOMEM;
 
@@ -704,6 +801,7 @@ static int __devinit virtscsi_probe(struct virtio_device *vdev)
 	shost->sg_tablesize = sg_elems;
 	vscsi = shost_priv(shost);
 	vscsi->vdev = vdev;
+	vscsi->num_queues = num_queues;
 	vdev->priv = shost;
 
 	err = virtscsi_init(vdev, vscsi, num_targets);
-- 
1.7.1
