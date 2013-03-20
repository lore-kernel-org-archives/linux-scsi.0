From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH V6 4/5] virtio-scsi: introduce multiqueue support
Date: Wed, 20 Mar 2013 15:01:23 +0800
Message-ID: <1363762884-11000-5-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1363762884-11000-1-git-send-email-gaowanlong@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1363762884-11000-1-git-send-email-gaowanlong@cn.fujitsu.com>
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

This patch adds queue steering to virtio-scsi.  When a target is sent
multiple requests, we always drive them to the same queue so that FIFO
processing order is kept.  However, if a target was idle, we can choose
a queue arbitrarily.  In this case the queue is chosen according to the
current VCPU, so the driver expects the number of request queues to be
equal to the number of VCPUs.  This makes it easy and fast to select
the queue, and also lets the driver optimize the IRQ affinity for the
virtqueues (each virtqueue's affinity is set to the CPU that "owns"
the queue).

The speedup comes from improving cache locality and giving CPU affinity
to the virtqueues, which is why this scheme was selected.  Assuming that
the thread that is sending requests to the device is I/O-bound, it is
likely to be sleeping at the time the ISR is executed, and thus executing
the ISR on the same processor that sent the requests is cheap.

However, the kernel will not execute the ISR on the "best" processor
unless you explicitly set the affinity.  This is because in practice
you will have many such I/O-bound processes and thus many otherwise
idle processors.  Then the kernel will execute the ISR on a random
processor, rather than the one that is sending requests to the device.

The alternative to per-CPU virtqueues is per-target virtqueues.  To
achieve the same locality, we could dynamically choose the virtqueue's
affinity based on the CPU of the last task that sent a request.  This
is less appealing because we do not set the affinity directly---we only
provide a hint to the irqbalanced running in userspace.  Dynamically
changing the affinity only works if the userspace applies the hint
fast enough.

Cc: linux-scsi@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reviewed-by: Asias He <asias@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 282 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 254 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index dc2daec..13d7672 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -22,12 +22,14 @@
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 #include <linux/virtio_scsi.h>
+#include <linux/cpu.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
 
 #define VIRTIO_SCSI_MEMPOOL_SZ 64
 #define VIRTIO_SCSI_EVENT_LEN 8
+#define VIRTIO_SCSI_VQ_BASE 2
 
 /* Command queue element */
 struct virtio_scsi_cmd {
@@ -59,22 +61,58 @@ struct virtio_scsi_vq {
 	struct virtqueue *vq;
 };
 
-/* Per-target queue state */
+/*
+ * Per-target queue state.
+ *
+ * This struct holds the data needed by the queue steering policy.  When a
+ * target is sent multiple requests, we need to drive them to the same queue so
+ * that FIFO processing order is kept.  However, if a target was idle, we can
+ * choose a queue arbitrarily.  In this case the queue is chosen according to
+ * the current VCPU, so the driver expects the number of request queues to be
+ * equal to the number of VCPUs.  This makes it easy and fast to select the
+ * queue, and also lets the driver optimize the IRQ affinity for the virtqueues
+ * (each virtqueue's affinity is set to the CPU that "owns" the queue).
+ *
+ * An interesting effect of this policy is that only writes to req_vq need to
+ * take the tgt_lock.  Read can be done outside the lock because:
+ *
+ * - writes of req_vq only occur when atomic_inc_return(&tgt->reqs) returns 1.
+ *   In that case, no other CPU is reading req_vq: even if they were in
+ *   virtscsi_queuecommand_multi, they would be spinning on tgt_lock.
+ *
+ * - reads of req_vq only occur when the target is not idle (reqs != 0).
+ *   A CPU that enters virtscsi_queuecommand_multi will not modify req_vq.
+ *
+ * Similarly, decrements of reqs are never concurrent with writes of req_vq.
+ * Thus they can happen outside the tgt_lock, provided of course we make reqs
+ * an atomic_t.
+ */
 struct virtio_scsi_target_state {
-	/* Never held at the same time as vq_lock.  */
+	/* This spinlock never held at the same time as vq_lock. */
 	spinlock_t tgt_lock;
+
+	/* Count of outstanding requests. */
+	atomic_t reqs;
+
+	/* Currently active virtqueue for requests sent to this target. */
+	struct virtio_scsi_vq *req_vq;
 };
 
 /* Driver instance state */
 struct virtio_scsi {
 	struct virtio_device *vdev;
 
-	struct virtio_scsi_vq ctrl_vq;
-	struct virtio_scsi_vq event_vq;
-	struct virtio_scsi_vq req_vq;
-
 	/* Get some buffers ready for event vq */
 	struct virtio_scsi_event_node event_list[VIRTIO_SCSI_EVENT_LEN];
+
+	u32 num_queues;
+
+	/* If the affinity hint is set for virtqueues */
+	bool affinity_hint_set;
+
+	struct virtio_scsi_vq ctrl_vq;
+	struct virtio_scsi_vq event_vq;
+	struct virtio_scsi_vq req_vqs[];
 };
 
 static struct kmem_cache *virtscsi_cmd_cache;
@@ -109,6 +147,8 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 	struct virtio_scsi_cmd *cmd = buf;
 	struct scsi_cmnd *sc = cmd->sc;
 	struct virtio_scsi_cmd_resp *resp = &cmd->resp.cmd;
+	struct virtio_scsi_target_state *tgt =
+				scsi_target(sc->device)->hostdata;
 
 	dev_dbg(&sc->device->sdev_gendev,
 		"cmd %p response %u status %#02x sense_len %u\n",
@@ -163,6 +203,8 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 
 	mempool_free(cmd, virtscsi_cmd_pool);
 	sc->scsi_done(sc);
+
+	atomic_dec(&tgt->reqs);
 }
 
 static void virtscsi_vq_done(struct virtio_scsi *vscsi,
@@ -187,8 +229,42 @@ static void virtscsi_req_done(struct virtqueue *vq)
 {
 	struct Scsi_Host *sh = virtio_scsi_host(vq->vdev);
 	struct virtio_scsi *vscsi = shost_priv(sh);
+	int index = vq->index - VIRTIO_SCSI_VQ_BASE;
+	struct virtio_scsi_vq *req_vq = &vscsi->req_vqs[index];
 
-	virtscsi_vq_done(vscsi, &vscsi->req_vq, virtscsi_complete_cmd);
+	/*
+	 * Read req_vq before decrementing the reqs field in
+	 * virtscsi_complete_cmd.
+	 *
+	 * With barriers:
+	 *
+	 * 	CPU #0			virtscsi_queuecommand_multi (CPU #1)
+	 * 	------------------------------------------------------------
+	 * 	lock vq_lock
+	 * 	read req_vq
+	 * 	read reqs (reqs = 1)
+	 * 	write reqs (reqs = 0)
+	 * 				increment reqs (reqs = 1)
+	 * 				write req_vq
+	 *
+	 * Possible reordering without barriers:
+	 *
+	 * 	CPU #0			virtscsi_queuecommand_multi (CPU #1)
+	 * 	------------------------------------------------------------
+	 * 	lock vq_lock
+	 * 	read reqs (reqs = 1)
+	 * 	write reqs (reqs = 0)
+	 * 				increment reqs (reqs = 1)
+	 * 				write req_vq
+	 * 	read (wrong) req_vq
+	 *
+	 * We do not need a full smp_rmb, because req_vq is required to get
+	 * to tgt->reqs: tgt is &vscsi->tgt[sc->device->id], where sc is stored
+	 * in the virtqueue as the user token.
+	 */
+	smp_read_barrier_depends();
+
+	virtscsi_vq_done(vscsi, req_vq, virtscsi_complete_cmd);
 };
 
 static void virtscsi_complete_free(struct virtio_scsi *vscsi, void *buf)
@@ -251,7 +327,7 @@ static void virtscsi_cancel_event_work(struct virtio_scsi *vscsi)
 }
 
 static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
-						struct virtio_scsi_event *event)
+					    struct virtio_scsi_event *event)
 {
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
@@ -410,9 +486,10 @@ static int virtscsi_kick_cmd(struct virtio_scsi_vq *vq,
 	return err;
 }
 
-static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
+static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
+				 struct virtio_scsi_vq *req_vq,
+				 struct scsi_cmnd *sc)
 {
-	struct virtio_scsi *vscsi = shost_priv(sh);
 	struct virtio_scsi_cmd *cmd;
 	int ret;
 
@@ -446,7 +523,7 @@ static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
 	memcpy(cmd->req.cmd.cdb, sc->cmnd, sc->cmd_len);
 
-	if (virtscsi_kick_cmd(&vscsi->req_vq, cmd,
+	if (virtscsi_kick_cmd(req_vq, cmd,
 			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
 			      GFP_ATOMIC) == 0)
 		ret = 0;
@@ -457,6 +534,55 @@ out:
 	return ret;
 }
 
+static int virtscsi_queuecommand_single(struct Scsi_Host *sh,
+					struct scsi_cmnd *sc)
+{
+	struct virtio_scsi *vscsi = shost_priv(sh);
+	struct virtio_scsi_target_state *tgt =
+				scsi_target(sc->device)->hostdata;
+
+	atomic_inc(&tgt->reqs);
+	return virtscsi_queuecommand(vscsi, &vscsi->req_vqs[0], sc);
+}
+
+static struct virtio_scsi_vq *virtscsi_pick_vq(struct virtio_scsi *vscsi,
+					       struct virtio_scsi_target_state *tgt)
+{
+	struct virtio_scsi_vq *vq;
+	unsigned long flags;
+	u32 queue_num;
+
+	spin_lock_irqsave(&tgt->tgt_lock, flags);
+
+	/*
+	 * The memory barrier after atomic_inc_return matches
+	 * the smp_read_barrier_depends() in virtscsi_req_done.
+	 */
+	if (atomic_inc_return(&tgt->reqs) > 1)
+		vq = ACCESS_ONCE(tgt->req_vq);
+	else {
+		queue_num = smp_processor_id();
+		while (unlikely(queue_num >= vscsi->num_queues))
+			queue_num -= vscsi->num_queues;
+
+		tgt->req_vq = vq = &vscsi->req_vqs[queue_num];
+	}
+
+	spin_unlock_irqrestore(&tgt->tgt_lock, flags);
+	return vq;
+}
+
+static int virtscsi_queuecommand_multi(struct Scsi_Host *sh,
+				       struct scsi_cmnd *sc)
+{
+	struct virtio_scsi *vscsi = shost_priv(sh);
+	struct virtio_scsi_target_state *tgt =
+				scsi_target(sc->device)->hostdata;
+	struct virtio_scsi_vq *req_vq = virtscsi_pick_vq(vscsi, tgt);
+
+	return virtscsi_queuecommand(vscsi, req_vq, sc);
+}
+
 static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 {
 	DECLARE_COMPLETION_ONSTACK(comp);
@@ -533,6 +659,8 @@ static int virtscsi_target_alloc(struct scsi_target *starget)
 		return -ENOMEM;
 
 	spin_lock_init(&tgt->tgt_lock);
+	atomic_set(&tgt->reqs, 0);
+	tgt->req_vq = NULL;
 
 	starget->hostdata = tgt;
 	return 0;
@@ -544,12 +672,28 @@ static void virtscsi_target_destroy(struct scsi_target *starget)
 	kfree(tgt);
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
+	.target_alloc = virtscsi_target_alloc,
+	.target_destroy = virtscsi_target_destroy,
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
 
@@ -577,6 +721,47 @@ static struct scsi_host_template virtscsi_host_template = {
 				  &__val, sizeof(__val)); \
 	})
 
+static void __virtscsi_set_affinity(struct virtio_scsi *vscsi, bool affinity)
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
+
+static void virtscsi_set_affinity(struct virtio_scsi *vscsi, bool affinity)
+{
+	get_online_cpus();
+	__virtscsi_set_affinity(vscsi, affinity);
+	put_online_cpus();
+}
+
 static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
 			     struct virtqueue *vq)
 {
@@ -593,6 +778,11 @@ static void virtscsi_scan(struct virtio_device *vdev)
 
 static void virtscsi_remove_vqs(struct virtio_device *vdev)
 {
+	struct Scsi_Host *sh = virtio_scsi_host(vdev);
+	struct virtio_scsi *vscsi = shost_priv(sh);
+
+	virtscsi_set_affinity(vscsi, false);
+
 	/* Stop all the virtqueues. */
 	vdev->config->reset(vdev);
 
@@ -603,27 +793,43 @@ static int virtscsi_init(struct virtio_device *vdev,
 			 struct virtio_scsi *vscsi)
 {
 	int err;
-	struct virtqueue *vqs[3];
+	u32 i;
+	u32 num_vqs;
+	vq_callback_t **callbacks;
+	const char **names;
+	struct virtqueue **vqs;
+
+	num_vqs = vscsi->num_queues + VIRTIO_SCSI_VQ_BASE;
+	vqs = kmalloc(num_vqs * sizeof(struct virtqueue *), GFP_KERNEL);
+	callbacks = kmalloc(num_vqs * sizeof(vq_callback_t *), GFP_KERNEL);
+	names = kmalloc(num_vqs * sizeof(char *), GFP_KERNEL);
+
+	if (!callbacks || !vqs || !names) {
+		err = -ENOMEM;
+		goto out;
+	}
 
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
-		return err;
+		goto out;
 
 	virtscsi_init_vq(&vscsi->ctrl_vq, vqs[0]);
 	virtscsi_init_vq(&vscsi->event_vq, vqs[1]);
-	virtscsi_init_vq(&vscsi->req_vq, vqs[2]);
+	for (i = VIRTIO_SCSI_VQ_BASE; i < num_vqs; i++)
+		virtscsi_init_vq(&vscsi->req_vqs[i - VIRTIO_SCSI_VQ_BASE],
+				 vqs[i]);
+
+	virtscsi_set_affinity(vscsi, true);
 
 	virtscsi_config_set(vdev, cdb_size, VIRTIO_SCSI_CDB_SIZE);
 	virtscsi_config_set(vdev, sense_size, VIRTIO_SCSI_SENSE_SIZE);
@@ -631,6 +837,14 @@ static int virtscsi_init(struct virtio_device *vdev,
 	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG))
 		virtscsi_kick_event_all(vscsi);
 
+	err = 0;
+
+out:
+	kfree(names);
+	kfree(callbacks);
+	kfree(vqs);
+	if (err)
+		virtscsi_remove_vqs(vdev);
 	return err;
 }
 
@@ -641,10 +855,21 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	int err;
 	u32 sg_elems, num_targets;
 	u32 cmd_per_lun;
+	u32 num_queues;
+	struct scsi_host_template *hostt;
+
+	/* We need to know how many queues before we allocate. */
+	num_queues = virtscsi_config_get(vdev, num_queues) ? : 1;
 
 	num_targets = virtscsi_config_get(vdev, max_target) + 1;
 
-	shost = scsi_host_alloc(&virtscsi_host_template, sizeof(*vscsi));
+	if (num_queues == 1)
+		hostt = &virtscsi_host_template_single;
+	else
+		hostt = &virtscsi_host_template_multi;
+
+	shost = scsi_host_alloc(hostt,
+		sizeof(*vscsi) + sizeof(vscsi->req_vqs[0]) * num_queues);
 	if (!shost)
 		return -ENOMEM;
 
@@ -652,6 +877,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	shost->sg_tablesize = sg_elems;
 	vscsi = shost_priv(shost);
 	vscsi->vdev = vdev;
+	vscsi->num_queues = num_queues;
 	vdev->priv = shost;
 
 	err = virtscsi_init(vdev, vscsi);
-- 
1.8.2.rc2
