From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 2/6] virtio-scsi: replace target spinlock with seqcount
Date: Wed,  4 Jun 2014 12:11:39 +0200
Message-ID: <1401876703-10236-3-git-send-email-pbonzini@redhat.com>
References: <1401876703-10236-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:40842 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaFDKL6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2014 06:11:58 -0400
In-Reply-To: <1401876703-10236-1-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, JBottomley@Parallels.com, venkateshs@google.com, Ming Lei <ming.lei@canonical.com>

From: Ming Lei <ming.lei@canonical.com>

The spinlock of tgt_lock is only for serializing read and write
req_vq, one lockless seqcount is enough for the purpose.

On one 16core VM with vhost-scsi backend, the patch can improve
IOPS with 3% on random read test.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
[Add initialization in virtscsi_target_alloc. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index fc054935eb1f..f0b4cdbfceb0 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -26,6 +26,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
+#include <linux/seqlock.h>
 
 #define VIRTIO_SCSI_MEMPOOL_SZ 64
 #define VIRTIO_SCSI_EVENT_LEN 8
@@ -73,18 +74,16 @@ struct virtio_scsi_vq {
  * queue, and also lets the driver optimize the IRQ affinity for the virtqueues
  * (each virtqueue's affinity is set to the CPU that "owns" the queue).
  *
- * tgt_lock is held to serialize reading and writing req_vq. Reading req_vq
- * could be done locklessly, but we do not do it yet.
+ * tgt_seq is held to serialize reading and writing req_vq.
  *
  * Decrements of reqs are never concurrent with writes of req_vq: before the
  * decrement reqs will be != 0; after the decrement the virtqueue completion
  * routine will not use the req_vq so it can be changed by a new request.
- * Thus they can happen outside the tgt_lock, provided of course we make reqs
+ * Thus they can happen outside the tgt_seq, provided of course we make reqs
  * an atomic_t.
  */
 struct virtio_scsi_target_state {
-	/* This spinlock never held at the same time as vq_lock. */
-	spinlock_t tgt_lock;
+	seqcount_t tgt_seq;
 
 	/* Count of outstanding requests. */
 	atomic_t reqs;
@@ -521,19 +520,33 @@ static struct virtio_scsi_vq *virtscsi_pick_vq(struct virtio_scsi *vscsi,
 	unsigned long flags;
 	u32 queue_num;
 
-	spin_lock_irqsave(&tgt->tgt_lock, flags);
+	local_irq_save(flags);
+	if (atomic_inc_return(&tgt->reqs) > 1) {
+		unsigned long seq;
+
+		do {
+			seq = read_seqcount_begin(&tgt->tgt_seq);
+			vq = tgt->req_vq;
+		} while (read_seqcount_retry(&tgt->tgt_seq, seq));
+	} else {
+		/* no writes can be concurrent because of atomic_t */
+		write_seqcount_begin(&tgt->tgt_seq);
+
+		/* keep previous req_vq if there is reader found */
+		if (unlikely(atomic_read(&tgt->reqs) > 1)) {
+			vq = tgt->req_vq;
+			goto unlock;
+		}
 
-	if (atomic_inc_return(&tgt->reqs) > 1)
-		vq = tgt->req_vq;
-	else {
 		queue_num = smp_processor_id();
 		while (unlikely(queue_num >= vscsi->num_queues))
 			queue_num -= vscsi->num_queues;
-
 		tgt->req_vq = vq = &vscsi->req_vqs[queue_num];
+ unlock:
+		write_seqcount_end(&tgt->tgt_seq);
 	}
+	local_irq_restore(flags);
 
-	spin_unlock_irqrestore(&tgt->tgt_lock, flags);
 	return vq;
 }
 
@@ -618,14 +631,17 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
 
 static int virtscsi_target_alloc(struct scsi_target *starget)
 {
+	struct Scsi_Host *sh = dev_to_shost(starget->dev.parent);
+	struct virtio_scsi *vscsi = shost_priv(sh);
+
 	struct virtio_scsi_target_state *tgt =
 				kmalloc(sizeof(*tgt), GFP_KERNEL);
 	if (!tgt)
 		return -ENOMEM;
 
-	spin_lock_init(&tgt->tgt_lock);
+	seqcount_init(&tgt->tgt_seq);
 	atomic_set(&tgt->reqs, 0);
-	tgt->req_vq = NULL;
+	tgt->req_vq = &vscsi->req_vqs[0];
 
 	starget->hostdata = tgt;
 	return 0;
-- 
1.8.3.1


