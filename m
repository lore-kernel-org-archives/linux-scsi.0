From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/8] scsi-ml: export scsi-ml functions needed by
 tgt_scsi_lib and its LLDs
Date: Thu, 16 Nov 2006 19:24:10 +0900
Message-ID: <20061116192410A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:24294 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1422935AbWKPKYE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Nov 2006 05:24:04 -0500
Received: from mfs3.rdh.ecl.ntt.co.jp (mfs3.rdh.ecl.ntt.co.jp [129.60.39.112])
	by tama5.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id kAGAO2aA002457
	for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2006 19:24:03 +0900 (JST)
Received: from nttmail3.ecl.ntt.co.jp (nttmail3.ecl.ntt.co.jp [129.60.39.100])
	by mfs3.rdh.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id kAGAO2br004621
	for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2006 19:24:02 +0900 (JST)
Received: from dmailsv1.y.ecl.ntt.co.jp (dmailsv1.y.ecl.ntt.co.jp [129.60.53.14])
	by nttmail3.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id kAGAO2tE013157
	for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2006 19:24:02 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch contains the needed changes to the scsi-ml for the target
mode support.

Note, per the last review we moved almost all the fields we added
to the scsi_cmnd to our internal data structure which we are going
to try and kill off when we can replace it with support from other
parts of the kernel.

The one field we left on was the offset variable. This is needed to handle
the case where the target gets request that is so large that it cannot
execute it in one dma operation. So max_secotors or a segment limit may
limit the size of the transfer. In this case our tgt core code will
break up the command into managable transfers and send them to the
LLD one at a time. The offset is then used to tell the LLD where in
the command we are at. Is there another field on the scsi_cmd for
that?


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
---
 drivers/scsi/hosts.c     |    4 ++++
 drivers/scsi/scsi.c      |   43 ++++++++++++++++++++++++++-----------------
 drivers/scsi/scsi_lib.c  |   33 ++++++++++++++++++++++++---------
 include/scsi/scsi_cmnd.h |   10 ++++++++++
 include/scsi/scsi_host.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 107 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 68ef163..ee5927f 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -263,6 +263,10 @@ static void scsi_host_dev_release(struct
 		kthread_stop(shost->ehandler);
 	if (shost->work_q)
 		destroy_workqueue(shost->work_q);
+	if (shost->uspace_req_q) {
+		kfree(shost->uspace_req_q->queuedata);
+		scsi_free_queue(shost->uspace_req_q);
+	}
 
 	scsi_destroy_command_freelist(shost);
 	if (shost->bqt)
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c59f315..680d72e 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -156,8 +156,7 @@ static struct scsi_host_cmd_pool scsi_cm
 
 static DEFINE_MUTEX(host_cmd_pool_mutex);
 
-static struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost,
-					    gfp_t gfp_mask)
+struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 {
 	struct scsi_cmnd *cmd;
 
@@ -178,6 +177,7 @@ static struct scsi_cmnd *__scsi_get_comm
 
 	return cmd;
 }
+EXPORT_SYMBOL_GPL(__scsi_get_command);
 
 /*
  * Function:	scsi_get_command()
@@ -214,9 +214,29 @@ struct scsi_cmnd *scsi_get_command(struc
 		put_device(&dev->sdev_gendev);
 
 	return cmd;
-}				
+}
 EXPORT_SYMBOL(scsi_get_command);
 
+void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
+			struct device *dev)
+{
+	unsigned long flags;
+
+	/* changing locks here, don't need to restore the irq state */
+	spin_lock_irqsave(&shost->free_list_lock, flags);
+	if (unlikely(list_empty(&shost->free_list))) {
+		list_add(&cmd->list, &shost->free_list);
+		cmd = NULL;
+	}
+	spin_unlock_irqrestore(&shost->free_list_lock, flags);
+
+	if (likely(cmd != NULL))
+		kmem_cache_free(shost->cmd_pool->slab, cmd);
+
+	put_device(dev);
+}
+EXPORT_SYMBOL(__scsi_put_command);
+
 /*
  * Function:	scsi_put_command()
  *
@@ -231,26 +251,15 @@ EXPORT_SYMBOL(scsi_get_command);
 void scsi_put_command(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
-	struct Scsi_Host *shost = sdev->host;
 	unsigned long flags;
-	
+
 	/* serious error if the command hasn't come from a device list */
 	spin_lock_irqsave(&cmd->device->list_lock, flags);
 	BUG_ON(list_empty(&cmd->list));
 	list_del_init(&cmd->list);
-	spin_unlock(&cmd->device->list_lock);
-	/* changing locks here, don't need to restore the irq state */
-	spin_lock(&shost->free_list_lock);
-	if (unlikely(list_empty(&shost->free_list))) {
-		list_add(&cmd->list, &shost->free_list);
-		cmd = NULL;
-	}
-	spin_unlock_irqrestore(&shost->free_list_lock, flags);
+	spin_unlock_irqrestore(&cmd->device->list_lock, flags);
 
-	if (likely(cmd != NULL))
-		kmem_cache_free(shost->cmd_pool->slab, cmd);
-
-	put_device(&sdev->sdev_gendev);
+	__scsi_put_command(cmd->device->host, cmd, &sdev->sdev_gendev);
 }
 EXPORT_SYMBOL(scsi_put_command);
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d2c02df..5286675 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -703,7 +703,7 @@ static struct scsi_cmnd *scsi_end_reques
 	return NULL;
 }
 
-static struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
 	struct scsi_host_sg_pool *sgp;
 	struct scatterlist *sgl;
@@ -744,7 +744,9 @@ #endif
 	return sgl;
 }
 
-static void scsi_free_sgtable(struct scatterlist *sgl, int index)
+EXPORT_SYMBOL(scsi_alloc_sgtable);
+
+void scsi_free_sgtable(struct scatterlist *sgl, int index)
 {
 	struct scsi_host_sg_pool *sgp;
 
@@ -754,6 +756,8 @@ static void scsi_free_sgtable(struct sca
 	mempool_free(sgl, sgp->pool);
 }
 
+EXPORT_SYMBOL(scsi_free_sgtable);
+
 /*
  * Function:    scsi_release_buffers()
  *
@@ -1547,29 +1551,40 @@ u64 scsi_calculate_bounce_limit(struct S
 }
 EXPORT_SYMBOL(scsi_calculate_bounce_limit);
 
-struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
+struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
+					 request_fn_proc *request_fn)
 {
-	struct Scsi_Host *shost = sdev->host;
 	struct request_queue *q;
 
-	q = blk_init_queue(scsi_request_fn, NULL);
+	q = blk_init_queue(request_fn, NULL);
 	if (!q)
 		return NULL;
 
-	blk_queue_prep_rq(q, scsi_prep_fn);
-
 	blk_queue_max_hw_segments(q, shost->sg_tablesize);
 	blk_queue_max_phys_segments(q, SCSI_MAX_PHYS_SEGMENTS);
 	blk_queue_max_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
-	blk_queue_issue_flush_fn(q, scsi_issue_flush_fn);
-	blk_queue_softirq_done(q, scsi_softirq_done);
 
 	if (!shost->use_clustering)
 		clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 	return q;
 }
+EXPORT_SYMBOL(__scsi_alloc_queue);
+
+struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
+{
+	struct request_queue *q;
+
+	q = __scsi_alloc_queue(sdev->host, scsi_request_fn);
+	if (!q)
+		return NULL;
+
+	blk_queue_prep_rq(q, scsi_prep_fn);
+	blk_queue_issue_flush_fn(q, scsi_issue_flush_fn);
+	blk_queue_softirq_done(q, scsi_softirq_done);
+	return q;
+}
 
 void scsi_free_queue(struct request_queue *q)
 {
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index be117f8..d6948d0 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -8,6 +8,7 @@ #include <linux/timer.h>
 
 struct request;
 struct scatterlist;
+struct Scsi_Host;
 struct scsi_device;
 
 
@@ -72,6 +73,9 @@ #define MAX_COMMAND_SIZE	16
 	unsigned short use_sg;	/* Number of pieces of scatter-gather */
 	unsigned short sglist_len;	/* size of malloc'd scatter-gather list */
 
+	/* offset in cmd we are at (for multi-transfer tgt cmds) */
+	unsigned offset;
+
 	unsigned underflow;	/* Return error if less than
 				   this amount is transferred */
 
@@ -119,7 +123,10 @@ #define SCSI_SENSE_BUFFERSIZE 	96
 };
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
+extern struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *, gfp_t);
 extern void scsi_put_command(struct scsi_cmnd *);
+extern void __scsi_put_command(struct Scsi_Host *, struct scsi_cmnd *,
+			       struct device *);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 extern void scsi_req_abort_cmd(struct scsi_cmnd *cmd);
@@ -128,4 +135,7 @@ extern void *scsi_kmap_atomic_sg(struct
 				 size_t *offset, size_t *len);
 extern void scsi_kunmap_atomic_sg(void *virt);
 
+extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
+extern void scsi_free_sgtable(struct scatterlist *, int);
+
 #endif /* _SCSI_SCSI_CMND_H */
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 39c6f8c..c79eafb 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -7,6 +7,7 @@ #include <linux/types.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
 
+struct request_queue;
 struct block_device;
 struct completion;
 struct module;
@@ -124,6 +125,39 @@ #endif
 			     void (*done)(struct scsi_cmnd *));
 
 	/*
+	 * The transfer functions are used to queue a scsi command to
+	 * the LLD. When the driver is finished processing the command
+	 * the done callback is invoked.
+	 *
+	 * return values: see queuecommand
+	 *
+	 * If the LLD accepts the cmd, it should set the result to an
+	 * appropriate value when completed before calling the done function.
+	 *
+	 * STATUS: REQUIRED FOR TARGET DRIVERS
+	 */
+	/* TODO: rename */
+	int (* transfer_response)(struct scsi_cmnd *,
+				  void (*done)(struct scsi_cmnd *));
+	/*
+	 * This is called to inform the LLD to transfer cmd->request_bufflen
+	 * bytes of the cmd at cmd->offset in the cmd. The cmd->use_sg
+	 * speciefies the number of scatterlist entried in the command
+	 * and cmd->request_buffer contains the scatterlist.
+	 *
+	 * If the command cannot be processed in one transfer_data call
+	 * becuase a scatterlist within the LLD's limits cannot be
+	 * created then transfer_data will be called multiple times.
+	 * It is initially called from process context, and later
+	 * calls are from the interrup context.
+	 */
+	int (* transfer_data)(struct scsi_cmnd *,
+			      void (*done)(struct scsi_cmnd *));
+
+	/* Used as callback for the completion of task management request. */
+	int (* tsk_mgmt_response)(u64 mid, int result);
+
+	/*
 	 * This is an error handling strategy routine.  You don't need to
 	 * define one of these if you don't want to - there is a default
 	 * routine that is present that should work in most cases.  For those
@@ -568,6 +602,12 @@ struct Scsi_Host {
 	 */
 	unsigned int max_host_blocked;
 
+	/*
+	 * q used for scsi_tgt msgs, async events or any other requests that
+	 * need to be processed in userspace
+	 */
+	struct request_queue *uspace_req_q;
+
 	/* legacy crap */
 	unsigned long base;
 	unsigned long io_port;
@@ -671,6 +711,9 @@ extern void scsi_unblock_requests(struct
 extern void scsi_block_requests(struct Scsi_Host *);
 
 struct class_container;
+
+extern struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
+						void (*) (struct request_queue *));
 /*
  * These two functions are used to allocate and free a pseudo device
  * which will connect to the host adapter itself rather than any
-- 
1.4.3.2

