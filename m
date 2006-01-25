From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC 1/3] SCSI Userspace Target: scsi-ml changes
Date: Tue, 24 Jan 2006 20:58:05 -0600
Message-ID: <1138157885.11692.32.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:4993 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750971AbWAYC6Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 21:58:25 -0500
Received: from max (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k0P2wOt2023599
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2006 20:58:24 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Export functions needed by tgt_scsi_lib and its LLDs.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 5881079..0147af7 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -264,6 +264,9 @@ static void scsi_host_dev_release(struct
 	if (shost->work_q)
 		destroy_workqueue(shost->work_q);
 
+	if (shost->uspace_req_q)
+		scsi_free_queue(shost->uspace_req_q);
+
 	scsi_destroy_command_freelist(shost);
 	kfree(shost->shost_data);
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 245ca99..f145117 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -236,6 +236,59 @@ static struct scsi_cmnd *__scsi_get_comm
 }
 
 /*
+ * Function:	scsi_host_get_command()
+ *
+ * Purpose:	Allocate and setup a scsi command block and blk request
+ *
+ * Arguments:	shost	- scsi host
+ *		data_dir - dma data dir
+ *		gfp_mask- allocator flags
+ *
+ * Returns:	The allocated scsi command structure.
+ *
+ * This should be called by target LLDs to get a command.
+ */
+struct scsi_cmnd *scsi_host_get_command(struct Scsi_Host *shost,
+					enum dma_data_direction data_dir,
+					gfp_t gfp_mask)
+{
+	int write = (data_dir == DMA_TO_DEVICE);
+	struct request *rq;
+	struct scsi_cmnd *cmd;
+
+	rq = blk_get_request(shost->uspace_req_q, write, gfp_mask);
+	if (!rq)
+		return NULL;
+
+	/* Bail if we can't get a reference to the device */
+	if (!get_device(&shost->shost_gendev))
+		goto release_rq;
+
+	cmd = __scsi_get_command(shost, gfp_mask);
+	if (!cmd)
+		goto put_dev;
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->sc_data_direction = data_dir;
+	cmd->jiffies_at_alloc = jiffies;
+	cmd->shost = shost;
+	cmd->request = rq;
+
+	rq->special = cmd;
+	rq->flags |= REQ_SPECIAL | REQ_BLOCK_PC;
+
+	return cmd;
+
+put_dev:
+	put_device(&shost->shost_gendev);
+release_rq:
+	blk_put_request(rq);
+	return NULL;
+
+}				
+EXPORT_SYMBOL_GPL(scsi_host_get_command);
+
+/*
  * Function:	scsi_get_command()
  *
  * Purpose:	Allocate and setup a scsi command block
@@ -274,6 +327,45 @@ struct scsi_cmnd *scsi_get_command(struc
 EXPORT_SYMBOL(scsi_get_command);
 
 /*
+ * Function:	scsi_host_put_command()
+ *
+ * Purpose:	Free a scsi command block
+ *
+ * Arguments:	cmd	- command block to free
+ *
+ * Returns:	Nothing.
+ *
+ * Notes:	The command must not belong to any lists.
+ */
+void scsi_host_put_command(struct scsi_cmnd *cmd)
+{
+	struct Scsi_Host *shost = cmd->shost;
+	struct request_queue *q = cmd->shost->uspace_req_q;
+	struct request *rq = cmd->request;
+	unsigned long flags;
+	
+	/* changing locks here, don't need to restore the irq state */
+	spin_lock_irqsave(&shost->free_list_lock, flags);
+	if (unlikely(list_empty(&shost->free_list))) {
+		list_add(&cmd->list, &shost->free_list);
+		cmd = NULL;
+	}
+	spin_unlock(&shost->free_list_lock);
+
+	spin_lock(q->queue_lock);
+	if (blk_rq_tagged(rq))
+		blk_queue_end_tag(q, rq);
+	__blk_put_request(q, rq);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	if (likely(cmd != NULL))
+		kmem_cache_free(shost->cmd_pool->slab, cmd);
+
+	put_device(&shost->shost_gendev);
+}
+EXPORT_SYMBOL_GPL(scsi_host_put_command);
+
+/*
  * Function:	scsi_put_command()
  *
  * Purpose:	Free a scsi command block
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3574ba9..79f1bdd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1685,29 +1685,40 @@ u64 scsi_calculate_bounce_limit(struct S
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
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 752fb5d..0fdd11a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1013,7 +1013,7 @@ static void scsi_sequential_lun_scan(str
  *     Given a struct scsi_lun of: 0a 04 0b 03 00 00 00 00, this function returns
  *     the integer: 0x0b030a04
  **/
-static int scsilun_to_int(struct scsi_lun *scsilun)
+int scsilun_to_int(struct scsi_lun *scsilun)
 {
 	int i;
 	unsigned int lun;
@@ -1024,6 +1024,7 @@ static int scsilun_to_int(struct scsi_lu
 			      scsilun->scsi_lun[i + 1]) << (i * 8));
 	return lun;
 }
+EXPORT_SYMBOL(scsilun_to_int);
 
 /**
  * int_to_scsilun: reverts an int into a scsi_lun
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 7529f43..0bcc352 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -8,6 +8,7 @@
 
 struct request;
 struct scatterlist;
+struct Scsi_Host;
 struct scsi_device;
 struct scsi_request;
 
@@ -31,6 +32,7 @@ struct scsi_pointer {
 struct scsi_cmnd {
 	int     sc_magic;
 
+	struct Scsi_Host *shost;
 	struct scsi_device *device;
 	struct scsi_request *sc_request;
 
@@ -131,6 +133,11 @@ struct scsi_cmnd {
 
 	unsigned char tag;	/* SCSI-II queued command tag */
 	unsigned long pid;	/* Process ID, starts at 0. Unique per host. */
+	/*
+	 * Work struct to process completion of scsi commands in process
+	 * context. (this should be ifdefd, we could try to do the SG_IO option)
+	 */
+	struct work_struct work;
 };
 
 /*
@@ -147,7 +154,10 @@ struct scsi_cmnd {
 #define SCSI_STATE_MLQUEUE         0x100b
 
 
+extern struct scsi_cmnd *scsi_host_get_command(struct Scsi_Host *,
+					       enum dma_data_direction, gfp_t);
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
+extern void scsi_host_put_command(struct scsi_cmnd *);
 extern void scsi_put_command(struct scsi_cmnd *);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int, unsigned int);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index e94ca4d..1b09f4f 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -264,6 +264,7 @@ extern void scsi_target_block(struct dev
 extern void scsi_target_unblock(struct device *);
 extern void scsi_remove_target(struct device *);
 extern void int_to_scsilun(unsigned int, struct scsi_lun *);
+extern int scsilun_to_int(struct scsi_lun *);
 extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 467274a..fbab68c 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -7,6 +7,7 @@
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
 
+struct request_queue;
 struct block_device;
 struct completion;
 struct module;
@@ -123,6 +124,21 @@ struct scsi_host_template {
 			     void (*done)(struct scsi_cmnd *));
 
 	/*
+	 * The transfer functions are used to queue a scsi command to
+	 * the LLD. When the driver is finished processing the command
+	 * the done callback is invoked.
+	 *
+	 * return values: see queuecommand
+	 *
+	 * STATUS: REQUIRED FOR TARGET DRIVERS
+	 */
+	/* TODO: rename */
+	int (* transfer_response)(struct scsi_cmnd *,
+				  void (*done)(struct scsi_cmnd *));
+	int (* transfer_data)(struct scsi_cmnd *,
+			      void (*done)(struct scsi_cmnd *));
+
+	/*
 	 * This is an error handling strategy routine.  You don't need to
 	 * define one of these if you don't want to - there is a default
 	 * routine that is present that should work in most cases.  For those
@@ -573,6 +589,12 @@ struct Scsi_Host {
 	 */
 	unsigned int max_host_blocked;
 
+	/*
+	 * q used for scsi_tgt msgs, async events or any other requests that
+	 * need to be processed in userspace
+ 	 */
+	struct request_queue *uspace_req_q;
+
 	/* legacy crap */
 	unsigned long base;
 	unsigned long io_port;
@@ -675,6 +697,9 @@ extern void scsi_unblock_requests(struct
 extern void scsi_block_requests(struct Scsi_Host *);
 
 struct class_container;
+
+extern struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
+					     void (*) (struct request_queue *));
 /*
  * These two functions are used to allocate and free a pseudo device
  * which will connect to the host adapter itself rather than any


