From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] SCSI support for REQ_TYPE_LINUX_BLOCK requests
Date: Wed, 26 Mar 2008 15:23:05 +0100
Message-ID: <87r6dxy37a.fsf@denkblock.local>
References: <871w60j9ai.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:53261 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795AbYCZO3M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Mar 2008 10:29:12 -0400
Received: from c-134-104-218.k.dial.de.ignite.net ([62.134.104.218] helo=denkblock.local)
	by mail.nebensachen.de with esmtpsa (TLS-1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <eo@nebensachen.de>)
	id 1JeWcR-0003hQ-Il
	for linux-scsi@vger.kernel.org; Wed, 26 Mar 2008 15:28:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--=-=-=

Elias Oltmanns <eo@nebensachen.de> wrote:
> Hi all,
>
> this patch adds support for REQ_TYPE_LINUX_BLOCK requests to the scsi
> midlayer. Low level drivers have the option to register their own
> handlers for these special requests if necessary.
>
[...]
> +static void scsi_finish_lb_req(struct request *req)
> +{
> +	struct request_queue *q = req->q;
> +	struct scsi_device *sdev = q->queuedata;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(q->queue_lock, flags);
> +	end_that_request_last(req, 1);

That's obsolete, of course. Sorry for missing that. See the correct
patch for 2.6.25-rc7 below.

Regards,

Elias


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=scsi-req_lb-support

---

 drivers/scsi/scsi_lib.c  |   66 +++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.c        |    9 ++++++
 drivers/scsi/sr.c        |    9 ++++++
 include/linux/blkdev.h   |    1 +
 include/scsi/scsi_host.h |   22 +++++++++++++++
 5 files changed, 105 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f40898d..5e72640 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1262,6 +1262,15 @@ int scsi_prep_fn(struct request_queue *q, struct request *req)
 
 	if (req->cmd_type == REQ_TYPE_BLOCK_PC)
 		ret = scsi_setup_blk_pc_cmnd(sdev, req);
+	else if (req->cmd_type == REQ_TYPE_LINUX_BLOCK) {
+		get_device(&sdev->sdev_gendev);
+		/*
+		 * Since these requests don't need preparation, we'll
+		 * basically just accept them unconditionally at this
+		 * point.
+		 */
+		ret = BLKPREP_OK;
+	}
 	return scsi_prep_return(q, req, ret);
 }
 
@@ -1371,12 +1380,31 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 	__scsi_done(cmd);
 }
 
+static void scsi_finish_lb_req(struct request *req)
+{
+	struct scsi_device *sdev = req->q->queuedata;
+
+	/*
+	 * TODO: Perhaps the data_len or extra_len of
+	 * REQ_TYPE_LINUX_BLOCK requests are allowed to be different
+	 * from 0?
+	 */
+	blk_end_request(req, 0, 0);
+	put_device(&sdev->sdev_gendev);
+}
+
 static void scsi_softirq_done(struct request *rq)
 {
 	struct scsi_cmnd *cmd = rq->completion_data;
-	unsigned long wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
+	unsigned long wait_for;
 	int disposition;
 
+	if (blk_lb_request(rq)) {
+		scsi_finish_lb_req(rq);
+		return;
+	}
+
+	wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
 	INIT_LIST_HEAD(&cmd->eh_entry);
 
 	disposition = scsi_decide_disposition(cmd);
@@ -1406,6 +1434,24 @@ static void scsi_softirq_done(struct request *rq)
 	}
 }
 
+static void scsi_exec_lb_req(struct request *req)
+{
+	struct scsi_device *sdev = req->q->queuedata;
+	struct scsi_host_template *shostt = sdev->host->hostt;
+	int rc;
+
+	if (shostt->lb_request_fn)
+		rc = shostt->lb_request_fn(req);
+	else
+		rc = FAILED;
+
+	if (rc == FAILED)
+		req->errors = -EIO;
+	else if (rc == QUEUED)
+		return;
+	blk_complete_request(req);
+}
+
 /*
  * Function:    scsi_request_fn()
  *
@@ -1448,7 +1494,23 @@ static void scsi_request_fn(struct request_queue *q)
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
+		if (blk_lb_request(req)) {
+			blkdev_dequeue_request(req);
+			scsi_exec_lb_req(req);
+			continue;
+		}
+
+		if (!scsi_dev_queue_ready(q, sdev))
 			break;
 
 		if (unlikely(!scsi_device_online(sdev))) {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5fe7aae..95eba9f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -357,6 +357,15 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
 		goto out;
+	} else if (rq->cmd_type == REQ_TYPE_LINUX_BLOCK) {
+		get_device(&sdp->sdev_gendev);
+		/*
+		 * Since these requests don't need preparation, we'll
+		 * basically just accept them unconditionally at this
+		 * point.
+		 */
+		ret = BLKPREP_OK;
+		goto out;
 	} else if (rq->cmd_type != REQ_TYPE_FS) {
 		ret = BLKPREP_KILL;
 		goto out;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7ee86d4..24bdfae 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -337,6 +337,15 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
 		goto out;
+	} else if (rq->cmd_type == REQ_TYPE_LINUX_BLOCK) {
+		get_device(&sdp->sdev_gendev);
+		/*
+		 * Since these requests don't need preparation, we'll
+		 * basically just accept them unconditionally at this
+		 * point.
+		 */
+		ret = BLKPREP_OK;
+		goto out;
 	} else if (rq->cmd_type != REQ_TYPE_FS) {
 		ret = BLKPREP_KILL;
 		goto out;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6f79d40..f4ed034 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -453,6 +453,7 @@ enum {
 
 #define blk_fs_request(rq)	((rq)->cmd_type == REQ_TYPE_FS)
 #define blk_pc_request(rq)	((rq)->cmd_type == REQ_TYPE_BLOCK_PC)
+#define blk_lb_request(rq)	((rq)->cmd_type == REQ_TYPE_LINUX_BLOCK)
 #define blk_special_request(rq)	((rq)->cmd_type == REQ_TYPE_SPECIAL)
 #define blk_sense_request(rq)	((rq)->cmd_type == REQ_TYPE_SENSE)
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 530ff4c..1765855 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -9,6 +9,7 @@
 #include <scsi/scsi.h>
 
 struct request_queue;
+struct request;
 struct block_device;
 struct completion;
 struct module;
@@ -153,6 +154,27 @@ struct scsi_host_template {
 				  void (*done)(struct scsi_cmnd *));
 
 	/*
+	 * The lb_request_fn function is used to pass
+	 * REQ_TYPE_LINUX_BLOCK requests to the LLDD. The return value
+	 * FAILED indicates that the command opcode has not been known
+	 * by lb_request_fn. In contrast, the return value SUCCESS
+	 * means that the opcode has been recognised and the request
+	 * has been processed accordingly. Note, however, that SUCCESS
+	 * does not necessarily mean that all actions have been
+	 * performed successfully; errors are recorded in req->errors.
+	 * lb_request_fn can also return QUEUED in order to prevent
+	 * midlayer from enqueueng the request for completion.
+	 * Obviously, the LLDD must take care that the request will be
+	 * completed by means of blk_complete_request eventually.
+	 *
+	 * Status: OPTIONAL
+	 */
+	/* TODO: We might need to accept a return value NEEDS_RETRY some
+	 * time.
+	 */
+	int (* lb_request_fn)(struct request *req);
+
+	/*
 	 * This is an error handling strategy routine.  You don't need to
 	 * define one of these if you don't want to - there is a default
 	 * routine that is present that should work in most cases.  For those

--=-=-=--
