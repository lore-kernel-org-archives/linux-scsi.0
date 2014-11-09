From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 2/2] virtio_scsi: support multi hw queue of blk-mq
Date: Mon, 10 Nov 2014 00:57:04 +0800
Message-ID: <1415552224-31145-3-git-send-email-ming.lei@canonical.com>
References: <1415552224-31145-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46333 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaKIQ51 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2014 11:57:27 -0500
Received: by mail-pa0-f47.google.com with SMTP id kx10so6601317pab.6
        for <linux-scsi@vger.kernel.org>; Sun, 09 Nov 2014 08:57:27 -0800 (PST)
In-Reply-To: <1415552224-31145-1-git-send-email-ming.lei@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Ming Lei <ming.lei@canonical.com>, Paolo Bonzini <pbonzini@redhat.com>

Since virtio_scsi has supported multi virtqueue already,
it is natural to map virtque to hw-queue of blk-mq.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/scsi/virtio_scsi.c |  154 ++++----------------------------------------
 1 file changed, 14 insertions(+), 140 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index b83846f..719adb2 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -65,36 +65,6 @@ struct virtio_scsi_vq {
 	struct virtqueue *vq;
 };
 
-/*
- * Per-target queue state.
- *
- * This struct holds the data needed by the queue steering policy.  When a
- * target is sent multiple requests, we need to drive them to the same queue so
- * that FIFO processing order is kept.  However, if a target was idle, we can
- * choose a queue arbitrarily.  In this case the queue is chosen according to
- * the current VCPU, so the driver expects the number of request queues to be
- * equal to the number of VCPUs.  This makes it easy and fast to select the
- * queue, and also lets the driver optimize the IRQ affinity for the virtqueues
- * (each virtqueue's affinity is set to the CPU that "owns" the queue).
- *
- * tgt_seq is held to serialize reading and writing req_vq.
- *
- * Decrements of reqs are never concurrent with writes of req_vq: before the
- * decrement reqs will be != 0; after the decrement the virtqueue completion
- * routine will not use the req_vq so it can be changed by a new request.
- * Thus they can happen outside the tgt_seq, provided of course we make reqs
- * an atomic_t.
- */
-struct virtio_scsi_target_state {
-	seqcount_t tgt_seq;
-
-	/* Count of outstanding requests. */
-	atomic_t reqs;
-
-	/* Currently active virtqueue for requests sent to this target. */
-	struct virtio_scsi_vq *req_vq;
-};
-
 /* Driver instance state */
 struct virtio_scsi {
 	struct virtio_device *vdev;
@@ -150,8 +120,6 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 	struct virtio_scsi_cmd *cmd = buf;
 	struct scsi_cmnd *sc = cmd->sc;
 	struct virtio_scsi_cmd_resp *resp = &cmd->resp.cmd;
-	struct virtio_scsi_target_state *tgt =
-				scsi_target(sc->device)->hostdata;
 
 	dev_dbg(&sc->device->sdev_gendev,
 		"cmd %p response %u status %#02x sense_len %u\n",
@@ -205,8 +173,6 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 	}
 
 	sc->scsi_done(sc);
-
-	atomic_dec(&tgt->reqs);
 }
 
 static void virtscsi_vq_done(struct virtio_scsi *vscsi,
@@ -514,9 +480,9 @@ static void virtio_scsi_init_hdr_pi(struct virtio_scsi_cmd_req_pi *cmd_pi,
 		cmd_pi->pi_bytesin = blk_rq_sectors(rq) * bi->tuple_size;
 }
 
-static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
-				 struct virtio_scsi_vq *req_vq,
-				 struct scsi_cmnd *sc)
+static int __virtscsi_queuecommand(struct virtio_scsi *vscsi,
+				   struct virtio_scsi_vq *req_vq,
+				   struct scsi_cmnd *sc)
 {
 	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
 	struct virtio_scsi_cmd *cmd = scsi_cmd_priv(sc);
@@ -550,63 +516,15 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
 	return 0;
 }
 
-static int virtscsi_queuecommand_single(struct Scsi_Host *sh,
-					struct scsi_cmnd *sc)
-{
-	struct virtio_scsi *vscsi = shost_priv(sh);
-	struct virtio_scsi_target_state *tgt =
-				scsi_target(sc->device)->hostdata;
-
-	atomic_inc(&tgt->reqs);
-	return virtscsi_queuecommand(vscsi, &vscsi->req_vqs[0], sc);
-}
-
-static struct virtio_scsi_vq *virtscsi_pick_vq(struct virtio_scsi *vscsi,
-					       struct virtio_scsi_target_state *tgt)
-{
-	struct virtio_scsi_vq *vq;
-	unsigned long flags;
-	u32 queue_num;
-
-	local_irq_save(flags);
-	if (atomic_inc_return(&tgt->reqs) > 1) {
-		unsigned long seq;
-
-		do {
-			seq = read_seqcount_begin(&tgt->tgt_seq);
-			vq = tgt->req_vq;
-		} while (read_seqcount_retry(&tgt->tgt_seq, seq));
-	} else {
-		/* no writes can be concurrent because of atomic_t */
-		write_seqcount_begin(&tgt->tgt_seq);
-
-		/* keep previous req_vq if a reader just arrived */
-		if (unlikely(atomic_read(&tgt->reqs) > 1)) {
-			vq = tgt->req_vq;
-			goto unlock;
-		}
-
-		queue_num = smp_processor_id();
-		while (unlikely(queue_num >= vscsi->num_queues))
-			queue_num -= vscsi->num_queues;
-		tgt->req_vq = vq = &vscsi->req_vqs[queue_num];
- unlock:
-		write_seqcount_end(&tgt->tgt_seq);
-	}
-	local_irq_restore(flags);
-
-	return vq;
-}
-
-static int virtscsi_queuecommand_multi(struct Scsi_Host *sh,
-				       struct scsi_cmnd *sc)
+static int virtscsi_queuecommand(struct Scsi_Host *sh,
+				 struct scsi_cmnd *sc)
 {
 	struct virtio_scsi *vscsi = shost_priv(sh);
-	struct virtio_scsi_target_state *tgt =
-				scsi_target(sc->device)->hostdata;
-	struct virtio_scsi_vq *req_vq = virtscsi_pick_vq(vscsi, tgt);
+	u32 tag = blk_mq_unique_tag(sc->request);
+	u16 hwq = blk_mq_unique_tag_to_hwq(tag);
+	struct virtio_scsi_vq *req_vq = &vscsi->req_vqs[hwq];
 
-	return virtscsi_queuecommand(vscsi, req_vq, sc);
+	return __virtscsi_queuecommand(vscsi, req_vq, sc);
 }
 
 static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
@@ -718,37 +636,13 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
 	return virtscsi_tmf(vscsi, cmd);
 }
 
-static int virtscsi_target_alloc(struct scsi_target *starget)
-{
-	struct Scsi_Host *sh = dev_to_shost(starget->dev.parent);
-	struct virtio_scsi *vscsi = shost_priv(sh);
-
-	struct virtio_scsi_target_state *tgt =
-				kmalloc(sizeof(*tgt), GFP_KERNEL);
-	if (!tgt)
-		return -ENOMEM;
-
-	seqcount_init(&tgt->tgt_seq);
-	atomic_set(&tgt->reqs, 0);
-	tgt->req_vq = &vscsi->req_vqs[0];
-
-	starget->hostdata = tgt;
-	return 0;
-}
-
-static void virtscsi_target_destroy(struct scsi_target *starget)
-{
-	struct virtio_scsi_target_state *tgt = starget->hostdata;
-	kfree(tgt);
-}
-
-static struct scsi_host_template virtscsi_host_template_single = {
+static struct scsi_host_template virtscsi_host_template = {
 	.module = THIS_MODULE,
 	.name = "Virtio SCSI HBA",
 	.proc_name = "virtio_scsi",
 	.this_id = -1,
 	.cmd_size = sizeof(struct virtio_scsi_cmd),
-	.queuecommand = virtscsi_queuecommand_single,
+	.queuecommand = virtscsi_queuecommand,
 	.change_queue_depth = virtscsi_change_queue_depth,
 	.eh_abort_handler = virtscsi_abort,
 	.eh_device_reset_handler = virtscsi_device_reset,
@@ -756,26 +650,8 @@ static struct scsi_host_template virtscsi_host_template_single = {
 	.can_queue = 1024,
 	.dma_boundary = UINT_MAX,
 	.use_clustering = ENABLE_CLUSTERING,
-	.target_alloc = virtscsi_target_alloc,
-	.target_destroy = virtscsi_target_destroy,
-};
 
-static struct scsi_host_template virtscsi_host_template_multi = {
-	.module = THIS_MODULE,
-	.name = "Virtio SCSI HBA",
-	.proc_name = "virtio_scsi",
-	.this_id = -1,
-	.cmd_size = sizeof(struct virtio_scsi_cmd),
-	.queuecommand = virtscsi_queuecommand_multi,
-	.change_queue_depth = virtscsi_change_queue_depth,
-	.eh_abort_handler = virtscsi_abort,
-	.eh_device_reset_handler = virtscsi_device_reset,
-
-	.can_queue = 1024,
-	.dma_boundary = UINT_MAX,
-	.use_clustering = ENABLE_CLUSTERING,
-	.target_alloc = virtscsi_target_alloc,
-	.target_destroy = virtscsi_target_destroy,
+	.force_blk_mq = true,
 };
 
 #define virtscsi_config_get(vdev, fld) \
@@ -944,10 +820,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
 
 	num_targets = virtscsi_config_get(vdev, max_target) + 1;
 
-	if (num_queues == 1)
-		hostt = &virtscsi_host_template_single;
-	else
-		hostt = &virtscsi_host_template_multi;
+	hostt = &virtscsi_host_template;
 
 	shost = scsi_host_alloc(hostt,
 		sizeof(*vscsi) + sizeof(vscsi->req_vqs[0]) * num_queues);
@@ -983,6 +856,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	shost->max_id = num_targets;
 	shost->max_channel = 0;
 	shost->max_cmd_len = VIRTIO_SCSI_CDB_SIZE;
+	shost->nr_hw_queues = num_queues;
 
 	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_T10_PI)) {
 		host_prot = SHOST_DIF_TYPE1_PROTECTION | SHOST_DIF_TYPE2_PROTECTION |
-- 
1.7.9.5

