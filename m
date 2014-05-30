From: Liu Ping Fan <kernelfans@gmail.com>
Subject: [RFC 2/9] scsi: ensure request is dequeue when finishing scmd
Date: Fri, 30 May 2014 16:15:40 +0800
Message-ID: <1401437747-2097-3-git-send-email-pingfank@linux.vnet.ibm.com>
References: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:48561 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbaE3IM5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 May 2014 04:12:57 -0400
Received: by mail-yk0-f170.google.com with SMTP id 10so1246512ykt.29
        for <linux-scsi@vger.kernel.org>; Fri, 30 May 2014 01:12:56 -0700 (PDT)
In-Reply-To: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Jeff Moyer <jmoyer@redhat.com>

When a timer requeue a request, it clears out REQ_ATOM_COMPLETE bit.
Hence if there is an in-flight scmd asks scsi-eh to handle an error by
joining the eh_entry list, then when scsi_error_handler() handles a scmd,
the scmd->request may be still on request_queue.  This will trigger
the BUG_ON(!list_empty(&req->queuelist)) in __blk_put_request().

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
note: I hit this bug in my test, and the above comment is my guess. Hope for
more comments about it.

---
 block/blk.h               |  1 -
 drivers/scsi/scsi_error.c |  1 +
 drivers/scsi/scsi_lib.c   | 20 +++++++++++++++++++-
 drivers/scsi/scsi_priv.h  |  1 +
 include/linux/blkdev.h    |  1 +
 5 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index c90e1d8..a9cad62 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -29,7 +29,6 @@ int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 		      struct bio *bio);
 void blk_queue_bypass_start(struct request_queue *q);
 void blk_queue_bypass_end(struct request_queue *q);
-void blk_dequeue_request(struct request *rq);
 void __blk_queue_free_tags(struct request_queue *q);
 bool __blk_end_bidi_request(struct request *rq, int error,
 			    unsigned int nr_bytes, unsigned int bidi_bytes);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c5f49cf..3b8b95b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2068,6 +2068,7 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush finish"
 							" cmd: %p\n",
 							current->comm, scmd));
+			scsi_queue_dequeue(scmd);
 			scsi_finish_command(scmd);
 		}
 	}
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7fb2afe..e117579 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -210,6 +210,21 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 {
 	__scsi_queue_insert(cmd, reason, 1);
 }
+
+void scsi_queue_dequeue(struct scsi_cmnd *cmd)
+{
+	struct scsi_device *device = cmd->device;
+	struct request_queue *q = device->request_queue;
+	struct request *req = cmd->request;
+	unsigned long flags;
+
+	if (list_empty(&cmd->request->queuelist))
+		return;
+	spin_lock_irqsave(q->queue_lock, flags);
+	blk_dequeue_request(req);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
 /**
  * scsi_execute - insert request and wait for the result
  * @sdev:	scsi device
@@ -859,6 +874,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			 */
 			req->next_rq->resid_len = scsi_in(cmd)->resid;
 
+			scsi_queue_dequeue(cmd);
 			scsi_release_buffers(cmd);
 			blk_end_request_all(req, 0);
 
@@ -1038,8 +1054,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		}
 		if (blk_end_request_err(req, error))
 			scsi_requeue_command(q, cmd);
-		else
+		else {
+			scsi_queue_dequeue(cmd);
 			scsi_next_command(cmd);
+		}
 		break;
 	case ACTION_REPREP:
 		/* Unprep the request and put it back at the head of the queue.
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index f079a59..601b964 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -84,6 +84,7 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd);
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
 extern void scsi_device_unbusy(struct scsi_device *sdev);
 extern void scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
+extern void scsi_queue_dequeue(struct scsi_cmnd *cmd);
 extern void scsi_next_command(struct scsi_cmnd *cmd);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8168524..ee7ddcd 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -916,6 +916,7 @@ static inline unsigned int blk_rq_count_bios(struct request *rq)
  */
 extern struct request *blk_peek_request(struct request_queue *q);
 extern void blk_start_request(struct request *rq);
+extern void blk_dequeue_request(struct request *rq);
 extern struct request *blk_fetch_request(struct request_queue *q);
 
 /*
-- 
1.8.1.4

