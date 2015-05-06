From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 01/12] scsi_transport_srp: Introduce srp_wait_for_queuecommand()
Date: Wed, 6 May 2015 11:59:28 +0200
Message-ID: <5549E600.9050208@sandisk.com>
References: <5541EE21.3050809@sandisk.com> <5541EE4A.30803@sandisk.com>
 <20150430093719.GA23486@infradead.org> <5542034D.5010300@sandisk.com>
 <554204D7.9050204@dev.mellanox.co.il> <55420AEA.10108@sandisk.com>
 <20150430172516.GA19200@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0087.outbound.protection.outlook.com ([157.56.111.87]:31040
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751885AbbEFJ7i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 May 2015 05:59:38 -0400
In-Reply-To: <20150430172516.GA19200@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>, James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Jens Axboe <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 04/30/15 19:25, Christoph Hellwig wrote:
> On Thu, Apr 30, 2015 at 12:58:50PM +0200, Bart Van Assche wrote:
>> The only callers in upstream code of scsi_target_block() and
>> scsi_target_unblock() I am aware of are the FC, iSCSI and SRP transport
>> layers and the drivers that use these transport layers. As far as I can see
>> both functions are always called from thread context and without holding any
>> spinlocks. A possible alternative to what I proposed in my previous e-mail
>> could be to provide a new function that waits for active queuecommand()
>> calls and that has to be called explicitly.
> 
> A separate helper sounds fine for now, although I suspect we'll
> eventually migrate the call to it into scsi_target_block().

(+Jens)

How about the patch below (lightly tested so far) ?

[PATCH] Introduce scsi_wait_for_queuecommand()

Move the functionality for waiting until active queuecommand()
calls have finished from the SRP transport layer into the SCSI
core. Add support for blk-mq in scsi_wait_for_queuecommand().
Introduce a request_fn_active counter in struct blk_mq_hw_ctx
to make it possible to implement this functionality for blk-mq.
---
 block/blk-mq.c                    | 19 ++++++++--------
 drivers/scsi/scsi_lib.c           | 48 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_transport_srp.c | 24 +-------------------
 include/linux/blk-mq.h            |  1 +
 include/scsi/scsi_device.h        |  1 +
 5 files changed, 60 insertions(+), 33 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ade8a2d..d0063e4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -786,12 +786,11 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 	 * If we have previous entries on our dispatch list, grab them
 	 * and stuff them at the front for more fair dispatch.
 	 */
-	if (!list_empty_careful(&hctx->dispatch)) {
-		spin_lock(&hctx->lock);
-		if (!list_empty(&hctx->dispatch))
-			list_splice_init(&hctx->dispatch, &rq_list);
-		spin_unlock(&hctx->lock);
-	}
+	spin_lock(&hctx->lock);
+	hctx->request_fn_active++;
+	if (!list_empty(&hctx->dispatch))
+		list_splice_init(&hctx->dispatch, &rq_list);
+	spin_unlock(&hctx->lock);
 
 	/*
 	 * Start off with dptr being NULL, so we start the first request
@@ -851,11 +850,11 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 	 * Any items that need requeuing? Stuff them into hctx->dispatch,
 	 * that is where we will continue on next queue run.
 	 */
-	if (!list_empty(&rq_list)) {
-		spin_lock(&hctx->lock);
+	spin_lock(&hctx->lock);
+	if (!list_empty(&rq_list))
 		list_splice(&rq_list, &hctx->dispatch);
-		spin_unlock(&hctx->lock);
-	}
+	hctx->request_fn_active--;
+	spin_unlock(&hctx->lock);
 }
 
 /*
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b1a2631..1466ef2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3073,6 +3073,54 @@ scsi_target_unblock(struct device *dev, enum scsi_device_state new_state)
 EXPORT_SYMBOL_GPL(scsi_target_unblock);
 
 /**
+ * scsi_request_fn_active() - number of ongoing scsi_request_fn() calls.
+ * @shost: SCSI host.
+ */
+static int scsi_request_fn_active(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+	struct request_queue *q;
+	struct blk_mq_hw_ctx *hctx;
+	unsigned int i;
+	int request_fn_active = 0;
+
+	shost_for_each_device(sdev, shost) {
+		q = sdev->request_queue;
+
+		if (q->mq_ops) {
+			queue_for_each_hw_ctx(q, hctx, i) {
+				spin_lock(&hctx->lock);
+				request_fn_active += q->request_fn_active;
+				spin_unlock(&hctx->lock);
+			}
+		} else {
+			spin_lock_irq(q->queue_lock);
+			request_fn_active += q->request_fn_active;
+			spin_unlock_irq(q->queue_lock);
+		}
+	}
+
+	return request_fn_active;
+}
+
+/**
+ * scsi_wait_for_queuecommand() - wait until queuecommand() calls have finished
+ * @shost: SCSI host.
+ *
+ * Although functions like scsi_target_block() and scsi_target_unblock(shost,
+ * SDEV_TRANSPORT_OFFLINE) prevent new calls to the queuecommand() callback
+ * function these functions do not wait until ongoing queucommand() calls have
+ * finished. Hence this function that waits until any ongoing queucommand()
+ * calls have finished.
+ */
+void scsi_wait_for_queuecommand(struct Scsi_Host *shost)
+{
+	while (scsi_request_fn_active(shost))
+		msleep(20);
+}
+EXPORT_SYMBOL(scsi_wait_for_queuecommand);
+
+/**
  * scsi_kmap_atomic_sg - find and atomically map an sg-elemnt
  * @sgl:	scatter-gather list
  * @sg_count:	number of segments in sg
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index ae45bd9..aaf4581 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -504,27 +504,6 @@ void srp_start_tl_fail_timers(struct srp_rport *rport)
 EXPORT_SYMBOL(srp_start_tl_fail_timers);
 
 /**
- * scsi_request_fn_active() - number of kernel threads inside scsi_request_fn()
- * @shost: SCSI host for which to count the number of scsi_request_fn() callers.
- */
-static int scsi_request_fn_active(struct Scsi_Host *shost)
-{
-	struct scsi_device *sdev;
-	struct request_queue *q;
-	int request_fn_active = 0;
-
-	shost_for_each_device(sdev, shost) {
-		q = sdev->request_queue;
-
-		spin_lock_irq(q->queue_lock);
-		request_fn_active += q->request_fn_active;
-		spin_unlock_irq(q->queue_lock);
-	}
-
-	return request_fn_active;
-}
-
-/**
  * srp_reconnect_rport() - reconnect to an SRP target port
  * @rport: SRP target port.
  *
@@ -559,8 +538,7 @@ int srp_reconnect_rport(struct srp_rport *rport)
 	if (res)
 		goto out;
 	scsi_target_block(&shost->shost_gendev);
-	while (scsi_request_fn_active(shost))
-		msleep(20);
+	scsi_wait_for_queuecommand(shost);
 	res = rport->state != SRP_RPORT_LOST ? i->f->reconnect(rport) : -ENODEV;
 	pr_debug("%s (state %d): transport.reconnect() returned %d\n",
 		 dev_name(&shost->shost_gendev), rport->state, res);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2056a99..732b746 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -22,6 +22,7 @@ struct blk_mq_hw_ctx {
 	struct {
 		spinlock_t		lock;
 		struct list_head	dispatch;
+		int			request_fn_active;
 	} ____cacheline_aligned_in_smp;
 
 	unsigned long		state;		/* BLK_MQ_S_* flags */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index a4c9336..5540d02 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -412,6 +412,7 @@ extern void scsi_scan_target(struct device *parent, unsigned int channel,
 extern void scsi_target_reap(struct scsi_target *);
 extern void scsi_target_block(struct device *);
 extern void scsi_target_unblock(struct device *, enum scsi_device_state);
+extern void scsi_wait_for_queuecommand(struct Scsi_Host *shost);
 extern void scsi_remove_target(struct device *);
 extern void int_to_scsilun(u64, struct scsi_lun *);
 extern u64 scsilun_to_int(struct scsi_lun *);
-- 
2.1.4



