From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 3/9] scsi_dh: scsi handling of REQ_LB_OP_TRANSITION
Date: Wed, 23 Jan 2008 16:30:59 -0800
Message-ID: <20080124003059.18871.89111.sendpatchset@localhost.localdomain>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:45821 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbYAXAbB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2008 19:31:01 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0O0V1IP004047
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 19:31:01 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0O0V1LX095856
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 17:31:01 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0O0V0V3030104
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 17:31:00 -0700
In-Reply-To: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, Chandra Seetharaman <sekharan@us.ibm.com>, jens.axboe@oracle.com

Subject: scsi_dh: scsi handling of REQ_LB_OP_TRANSITION

From: Mike Christie <michaelc@cs.wisc.edu>

This patch adds a scsi handler for REQ_LB_OP_TRANSITION commands.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---

---
 drivers/scsi/scsi_lib.c    |  113 	111 +	2 -	0 !
 include/scsi/scsi_cmnd.h   |    1 	1 +	0 -	0 !
 include/scsi/scsi_device.h |   13 	13 +	0 -	0 !
 3 files changed, 125 insertions(+), 2 deletions(-)

Index: linux-2.6.24-rc8/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.24-rc8.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6.24-rc8/drivers/scsi/scsi_lib.c
@@ -1163,6 +1163,38 @@ static struct scsi_cmnd *scsi_get_cmd_fr
 	return cmd;
 }
 
+static int scsi_setup_blk_linux_cmnd(struct scsi_device *sdev,
+				     struct request *rq)
+{
+	if (!get_device(&sdev->sdev_gendev)) {
+		rq->errors = BLKERR_DEV_OFFLINED;
+		return BLKPREP_KILL;
+	}
+
+	switch (rq->cmd[0]) {
+	case REQ_LB_OP_TRANSITION:
+		if (!sdev->sdev_dh || !sdev->sdev_dh->transition) {
+			/* set REQ_LB_OP_TRANSITION specific error */
+			rq->errors = BLKERR_NOSYS;
+			goto kill;
+		}
+		if (!try_module_get(sdev->sdev_dh->module)) {
+			rq->errors = BLKERR_DEV_OFFLINED;
+			goto kill;
+		}
+
+		break;
+	default:
+		rq->errors = BLKERR_INVALID_IO;
+		goto kill;
+	}
+	return BLKPREP_OK;
+
+kill:
+	put_device(&sdev->sdev_gendev);
+	return BLKPREP_KILL;
+}
+
 int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 {
 	struct scsi_cmnd *cmd;
@@ -1332,6 +1364,8 @@ int scsi_prep_fn(struct request_queue *q
 
 	if (req->cmd_type == REQ_TYPE_BLOCK_PC)
 		ret = scsi_setup_blk_pc_cmnd(sdev, req);
+	else if (req->cmd_type == REQ_TYPE_LINUX_BLOCK)
+		ret = scsi_setup_blk_linux_cmnd(sdev, req);
 	return scsi_prep_return(q, req, ret);
 }
 EXPORT_SYMBOL(scsi_prep_fn);
@@ -1445,9 +1479,24 @@ static void scsi_kill_request(struct req
 static void scsi_softirq_done(struct request *rq)
 {
 	struct scsi_cmnd *cmd = rq->completion_data;
-	unsigned long wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
 	int disposition;
+	struct request_queue *q;
+	unsigned long wait_for, flags;
 
+	if (blk_linux_request(rq)) {
+		q = rq->q;
+		spin_lock_irqsave(q->queue_lock, flags);
+		/*
+		 * we always return 1 and the caller should
+		 * check rq->errors for the complete status
+		 */
+		end_that_request_last(rq, 1);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+		return;
+	}
+
+
+	wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
 	INIT_LIST_HEAD(&cmd->eh_entry);
 
 	disposition = scsi_decide_disposition(cmd);
@@ -1477,6 +1526,50 @@ static void scsi_softirq_done(struct req
 	}
 }
 
+/**
+ * scsi_blk_linux_cmd_done - Complete a REQ_TYPE_LINUX_BLOCK request.
+ * @req: REQ_TYPE_LINUX_BLOCK request being processed
+ * @err: return value
+ *
+ * This function should be called by the REQ_TYPE_LINUX_BLOCK handler
+ * to return the request to its caller. This function queues the
+ * the completion to the blk softirq so the queue lock does not have
+ * to be held here.
+ */
+void scsi_blk_linux_cmd_done(struct request *rq, int err)
+{
+	struct scsi_device *sdev = rq->q->queuedata;
+
+	switch (rq->cmd[0]) {
+	case REQ_LB_OP_TRANSITION:
+		module_put(sdev->sdev_dh->module);
+		break;
+	}
+
+	put_device(&sdev->sdev_gendev);
+	rq->errors = err;
+	rq->completion_data = NULL;
+	blk_complete_request(rq);
+}
+EXPORT_SYMBOL_GPL(scsi_blk_linux_cmd_done);
+
+static void scsi_execute_blk_linux_cmd(struct request *rq)
+{
+	struct request_queue *q = rq->q;
+	struct scsi_device *sdev = q->queuedata;
+
+	switch (rq->cmd[0]) {
+	case REQ_LB_OP_TRANSITION:
+		spin_unlock_irq(q->queue_lock);
+		sdev->sdev_dh->transition(rq);
+		spin_lock_irq(q->queue_lock);
+		break;
+	default:
+		/* should have checked in scsi_prep_fn already */
+		BUG();
+	}
+}
+
 /*
  * Function:    scsi_request_fn()
  *
@@ -1519,7 +1612,23 @@ static void scsi_request_fn(struct reque
 		 * accept it.
 		 */
 		req = elv_next_request(q);
-		if (!req || !scsi_dev_queue_ready(q, sdev))
+		if (!req)
+			break;
+
+		/*
+		 * We do not account for linux blk req in the device
+		 * or host busy accounting because it is not necessarily
+		 * a scsi command that is sent to some object. The lower
+		 * level can translate it into a request/scsi_cmnd, if
+		 * necessary, and then queue that up using REQ_TYPE_BLOCK_PC.
+		 */
+		if (blk_linux_request(req)) {
+			blkdev_dequeue_request(req);
+			scsi_execute_blk_linux_cmd(req);
+			continue;
+		}
+
+		if (!scsi_dev_queue_ready(q, sdev))
 			break;
 
 		if (unlikely(!scsi_device_online(sdev))) {
Index: linux-2.6.24-rc8/include/scsi/scsi_cmnd.h
===================================================================
--- linux-2.6.24-rc8.orig/include/scsi/scsi_cmnd.h
+++ linux-2.6.24-rc8/include/scsi/scsi_cmnd.h
@@ -123,6 +123,7 @@ extern void __scsi_put_command(struct Sc
 			       struct device *);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 extern void scsi_req_abort_cmd(struct scsi_cmnd *cmd);
+extern void scsi_blk_linux_cmd_done(struct request *req, int err);
 
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
Index: linux-2.6.24-rc8/include/scsi/scsi_device.h
===================================================================
--- linux-2.6.24-rc8.orig/include/scsi/scsi_device.h
+++ linux-2.6.24-rc8/include/scsi/scsi_device.h
@@ -160,9 +160,22 @@ struct scsi_device {
 
 	struct execute_work	ew; /* used to get process context on put */
 
+	struct scsi_device_handler *sdev_dh;
+	void			*sdev_dh_data;
 	enum scsi_device_state sdev_state;
 	unsigned long		sdev_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
+
+struct scsi_device_handler {
+	struct module *module;
+	const char *name;
+
+	struct notifier_block nb;
+
+	int (*check_sense)(struct scsi_device *, struct scsi_sense_hdr *);
+	void (*transition)(struct request *);
+};
+
 #define	to_scsi_device(d)	\
 	container_of(d, struct scsi_device, sdev_gendev)
 #define	class_to_sdev(d)	\

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
