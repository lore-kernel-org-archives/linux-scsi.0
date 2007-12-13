From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] scsi: bidi support
Date: Thu, 13 Dec 2007 13:50:53 +0200
Message-ID: <47611C9D.5070105@panasas.com>
References: <47611977.5080702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:10051 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751759AbXLMLvJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Dec 2007 06:51:09 -0500
In-Reply-To: <47611977.5080702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>


  At the block level bidi request uses req->next_rq pointer for a second
  bidi_read request.
  At Scsi-midlayer a second scsi_data_buffer structure is used for the
  bidi_read part. This bidi scsi_data_buffer is put on
  request->next_rq->special. Struct scsi_cmnd is not changed.

  - Define scsi_bidi_cmnd() to return true if it is a bidi request and a
    second sgtable was allocated.

  - Define scsi_in()/scsi_out() to return the in or out scsi_data_buffer
    from this command This API is to isolate users from the mechanics of
    bidi.

  - Define scsi_end_bidi_request() to do what scsi_end_request() does but
    for a bidi request. This is necessary because bidi commands are a bit
    tricky here. (See comments in body)

  - scsi_release_buffers() will also release the bidi_read scsi_data_buffer

  - scsi_io_completion() on bidi commands will now call
    scsi_end_bidi_request() and return.

  - The previous work done in scsi_init_io() is now done in a new
    scsi_init_sgtable() (which is 99% identical to old scsi_init_io())
    The new scsi_init_io() will call the above twice if needed also for
    the bidi_read command. Only at this point is a command bidi.

  - In scsi_error.c at scsi_eh_prep/restore_cmnd() make sure bidi-lld is not
    confused by a get-sense command that looks like bidi. This is done
    by puting NULL at request->next_rq, and restoring.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_error.c |    3 +
 drivers/scsi/scsi_lib.c   |  144 ++++++++++++++++++++++++++++++++++++---------
 include/scsi/scsi_cmnd.h  |   23 +++++++-
 include/scsi/scsi_eh.h    |    1 +
 4 files changed, 141 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 241ab48..5c8ba6a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -618,9 +618,11 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	memcpy(ses->cmnd, scmd->cmnd, sizeof(scmd->cmnd));
 	ses->data_direction = scmd->sc_data_direction;
 	ses->sdb = scmd->sdb;
+	ses->next_rq = scmd->request->next_rq;
 	ses->result = scmd->result;
 
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
+	scmd->request->next_rq = NULL;
 
 	if (sense_bytes) {
 		scmd->sdb.length = min_t(unsigned,
@@ -673,6 +675,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 	memcpy(scmd->cmnd, ses->cmnd, sizeof(scmd->cmnd));
 	scmd->sc_data_direction = ses->data_direction;
 	scmd->sdb = ses->sdb;
+	scmd->request->next_rq = ses->next_rq;
 	scmd->result = ses->result;
 }
 EXPORT_SYMBOL(scsi_eh_restore_cmnd);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7ac36fe..a6aae56 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -64,6 +64,8 @@ static struct scsi_host_sg_pool scsi_sg_pools[] = {
 };
 #undef SP
 
+static struct kmem_cache *scsi_bidi_sdb_cache;
+
 static void scsi_run_queue(struct request_queue *q);
 
 /*
@@ -627,6 +629,28 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 		scsi_run_queue(sdev->request_queue);
 }
 
+static void scsi_finalize_request(struct scsi_cmnd *cmd, int uptodate)
+{
+	struct request_queue *q = cmd->device->request_queue;
+	struct request *req = cmd->request;
+	unsigned long flags;
+
+	add_disk_randomness(req->rq_disk);
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (blk_rq_tagged(req))
+		blk_queue_end_tag(q, req);
+
+	end_that_request_last(req, uptodate);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	/*
+	 * This will goose the queue request function at the end, so we don't
+	 * need to worry about launching another command.
+	 */
+	scsi_next_command(cmd);
+}
+
 /*
  * Function:    scsi_end_request()
  *
@@ -654,7 +678,6 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int uptodate,
 {
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
-	unsigned long flags;
 
 	/*
 	 * If there are blocks left over at the end, set up the command
@@ -683,19 +706,7 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int uptodate,
 		}
 	}
 
-	add_disk_randomness(req->rq_disk);
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	if (blk_rq_tagged(req))
-		blk_queue_end_tag(q, req);
-	end_that_request_last(req, uptodate);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
-	/*
-	 * This will goose the queue request function at the end, so we don't
-	 * need to worry about launching another command.
-	 */
-	scsi_next_command(cmd);
+	scsi_finalize_request(cmd, uptodate);
 	return NULL;
 }
 
@@ -894,10 +905,39 @@ void scsi_release_buffers(struct scsi_cmnd *cmd)
 		scsi_free_sgtable(&cmd->sdb);
 
 	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
+
+	if (scsi_bidi_cmnd(cmd)) {
+		struct scsi_data_buffer *bidi_sdb =
+			cmd->request->next_rq->special;
+		scsi_free_sgtable(bidi_sdb);
+		kmem_cache_free(scsi_bidi_sdb_cache, bidi_sdb);
+		cmd->request->next_rq->special = NULL;
+	}
 }
 EXPORT_SYMBOL(scsi_release_buffers);
 
 /*
+ * Bidi commands Must be complete as a whole, both sides at once.
+ * If part of the bytes were written and lld returned
+ * scsi_in()->resid and/or scsi_out()->resid this information will be left
+ * in req->data_len and req->next_rq->data_len. The upper-layer driver can
+ * decide what to do with this information.
+ */
+void scsi_end_bidi_request(struct scsi_cmnd *cmd)
+{
+	struct request *req = cmd->request;
+
+	end_that_request_chunk(req, 1, req->data_len);
+	req->data_len = scsi_out(cmd)->resid;
+
+	end_that_request_chunk(req->next_rq, 1, req->next_rq->data_len);
+	req->next_rq->data_len = scsi_in(cmd)->resid;
+
+	scsi_release_buffers(cmd);
+	scsi_finalize_request(cmd, 1);
+}
+
+/*
  * Function:    scsi_io_completion()
  *
  * Purpose:     Completion processing for block device I/O requests.
@@ -958,9 +998,15 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				req->sense_len = len;
 			}
 		}
+		if (scsi_bidi_cmnd(cmd)) {
+			/* will also release_buffers */
+			scsi_end_bidi_request(cmd);
+			return;
+		}
 		req->data_len = scsi_get_resid(cmd);
 	}
 
+	BUG_ON(blk_bidi_rq(req)); /* bidi not support for !blk_pc_request yet */
 	scsi_release_buffers(cmd);
 
 	/*
@@ -1086,24 +1132,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	scsi_end_request(cmd, 0, this_count, !result);
 }
 
-/*
- * Function:    scsi_init_io()
- *
- * Purpose:     SCSI I/O initialize function.
- *
- * Arguments:   cmd   - Command descriptor we wish to initialize
- *
- * Returns:     0 on success
- *		BLKPREP_DEFER if the failure is retryable
- */
-int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
+								 gfp_t gfp_mask)
 {
-	struct request     *req = cmd->request;
-	int		   count;
-	struct scsi_data_buffer *sdb = &cmd->sdb;
+	int count;
 
 	if (scsi_alloc_sgtable(sdb, req->nr_phys_segments, gfp_mask)) {
-		scsi_unprep_request(req);
 		return BLKPREP_DEFER;
 	}
 
@@ -1122,6 +1156,50 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 	sdb->sg_count = count;
 	return BLKPREP_OK;
 }
+
+/*
+ * Function:    scsi_init_io()
+ *
+ * Purpose:     SCSI I/O initialize function.
+ *
+ * Arguments:   cmd   - Command descriptor we wish to initialize
+ *
+ * Returns:     0 on success
+ *		BLKPREP_DEFER if the failure is retryable
+ *		BLKPREP_KILL if the failure is fatal
+ */
+int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+{
+	int error = scsi_init_sgtable(cmd->request, &cmd->sdb, gfp_mask);
+	if (error)
+		goto err_exit;
+
+	if (blk_bidi_rq(cmd->request)) {
+		struct scsi_data_buffer *bidi_sdb = kmem_cache_zalloc(
+			scsi_bidi_sdb_cache, GFP_ATOMIC);
+		if (!bidi_sdb) {
+			error = BLKPREP_DEFER;
+			goto err_exit;
+		}
+
+		cmd->request->next_rq->special = bidi_sdb;
+		error = scsi_init_sgtable(cmd->request->next_rq, bidi_sdb,
+								    GFP_ATOMIC);
+		if (error)
+			goto err_exit;
+	}
+
+	return BLKPREP_OK ;
+
+err_exit:
+	scsi_release_buffers(cmd);
+	if (error == BLKPREP_KILL)
+		scsi_put_command(cmd);
+	else /* BLKPREP_DEFER */
+		scsi_unprep_request(cmd->request);
+
+	return error;
+}
 EXPORT_SYMBOL(scsi_init_io);
 
 static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
@@ -1731,6 +1809,14 @@ int __init scsi_init_queue(void)
 		return -ENOMEM;
 	}
 
+	scsi_bidi_sdb_cache = kmem_cache_create("scsi_bidi_sdb",
+					sizeof(struct scsi_data_buffer),
+					0, 0, NULL);
+	if (!scsi_bidi_sdb_cache) {
+		printk(KERN_ERR "SCSI: can't init scsi bidi sdb cache\n");
+		return -ENOMEM;
+	}
+
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
 		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
 		int size = sgp->size * sizeof(struct scatterlist);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 887a12a..cd2851a 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -2,12 +2,12 @@
 #define _SCSI_SCSI_CMND_H
 
 #include <linux/dma-mapping.h>
+#include <linux/blkdev.h>
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
 
-struct request;
 struct scatterlist;
 struct Scsi_Host;
 struct scsi_device;
@@ -162,4 +162,25 @@ static inline int scsi_get_resid(struct scsi_cmnd *cmd)
 #define scsi_for_each_sg(cmd, sg, nseg, __i)			\
 	for_each_sg(scsi_sglist(cmd), sg, nseg, __i)
 
+static inline int scsi_bidi_cmnd(struct scsi_cmnd *cmd)
+{
+	return blk_bidi_rq(cmd->request) &&
+		(cmd->request->next_rq->special != NULL);
+}
+
+static inline struct scsi_data_buffer *scsi_in(struct scsi_cmnd *cmd)
+{
+	WARN_ON((cmd->sc_data_direction != DMA_FROM_DEVICE) &&
+							!scsi_bidi_cmnd(cmd));
+	return scsi_bidi_cmnd(cmd) ?
+		cmd->request->next_rq->special : &cmd->sdb;
+}
+
+static inline struct scsi_data_buffer *scsi_out(struct scsi_cmnd *cmd)
+{
+	WARN_ON((cmd->sc_data_direction != DMA_TO_DEVICE) &&
+							!scsi_bidi_cmnd(cmd));
+	return &cmd->sdb;
+}
+
 #endif /* _SCSI_SCSI_CMND_H */
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 1e08be1..25071d5 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -74,6 +74,7 @@ struct scsi_eh_save {
 	unsigned char cmd_len;
 	unsigned char cmnd[MAX_COMMAND_SIZE];
 	struct scsi_data_buffer sdb;
+	struct request *next_rq;
 
 	/* new command support */
 	struct scatterlist sense_sgl;
-- 
1.5.3.3


