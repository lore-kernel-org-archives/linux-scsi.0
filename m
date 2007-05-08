From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Tue, 08 May 2007 21:53:24 +0300
Message-ID: <4640C724.8030409@panasas.com>
References: <20070508112553C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020001040008050006080001"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:41736 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754631AbXEHSzT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 14:55:19 -0400
In-Reply-To: <20070508112553C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, bhalevy@panasas.com, jens.axboe@oracle.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

This is a multi-part message in MIME format.
--------------020001040008050006080001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

FUJITA Tomonori wrote:
> Here is an updated version of the patch to add bidi support to block
> pc requests. Bugs spotted by Benny were fixed.
> 
> This patch can be applied cleanly to the scsi-misc git tree and is on
> the top of the following patch to add linked request support:
> 
> http://marc.info/?l=linux-scsi&m=117835587615642&w=2
> 
> ---
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Mon, 7 May 2007 16:42:24 +0900
> Subject: [PATCH] add bidi support to scsi pc commands
> 
> This adds bidi support to block pc requests.
> 
> A bidi request uses req->next_rq pointer for an in request.
> 
> This patch introduces a new structure, scsi_data_buffer to hold the
> data buffer information. To avoid make scsi_cmnd structure fatter, the
> scsi mid-layer uses cmnd->request->next_rq->special pointer for
> a scsi_data_buffer structure. LLDs don't touch the second request
> (req->next_rq) so it's safe to use req->special.
> 
> scsi_blk_pc_done() always completes the whole command so
> scsi_end_request() simply completes the bidi chunk too.
> 
> A helper function, scsi_bidi_data_buffer() is for LLDs to access to
> the scsi_data_buffer structure easily.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
> @@ -685,6 +696,14 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int uptodate,
>  		}
>  	}
>  
> +	/*
> +	 * a REQ_BLOCK_PC command is always completed fully so just do
> +	 * end the bidi chunk.
> +	 */
> +	if (sdb)
> +		end_that_request_chunk(req->next_rq, uptodate,
> +				       sdb->request_bufflen);
> +

sdb->request_bufflen was zeroed in scsi_release_buffers which is called before
scsi_end_request.

>  static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
>  {
>  	BUG_ON(!blk_pc_request(cmd->request));
> @@ -1090,10 +1159,22 @@ static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
>  static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
>  {
>  	struct scsi_cmnd *cmd;
> +	struct scsi_data_buffer *sdb = NULL;
> +
> +	if (blk_bidi_rq(req)) {
> +		sdb = kzalloc(sizeof(*sdb), GFP_ATOMIC);
> +		if (unlikely(!sdb))
> +			return BLKPREP_DEFER;
> +	}
>  
>  	cmd = scsi_get_cmd_from_req(sdev, req);
> -	if (unlikely(!cmd))
> +	if (unlikely(!cmd)) {
> +		kfree(sdb);
>  		return BLKPREP_DEFER;
> +	}
> +
> +	if (sdb)
> +		req->next_rq->special = sdb;
>  
>  	/*
>  	 * BLOCK_PC requests may transfer data, in which case they must

Before I get to my main concern here I have one comment. in scsi_get_cmd_from_req()
there is a code path in which a scsi_cmnd is taken from special and is not newly
allocated. It is best to move bidi allocation to scsi_get_cmd_from_req() and allocate
new sdb only if we get a new Command. (See my attached patch for an example)

OK! My main concern is with kzalloc(sizeof(*sdb), GFP_ATOMIC);
All IO allocations should come from slabs in case of a memory starved system.
There are 3 possible solutions I see:
1. Use struct scsi_cmnd for bidi_read and not a special scsi_data_buffer.
   Attached is above solution. It is by far the simplest of the three.
   So simple that even Jens's BigIO patch can almost apply at scsi_lib.c. (and vise versa)
   What's hanged on the request->next_rq->special is a second scsi_cmnd.
   The command is taken from regular command pool. This solution, though
   wasteful of some memory is very stable.

2. Force the users of BIDI to allocate scsi_data_buffer(s)
   Users will allocate a slab for scsi_data_buffers and hang them on nex_rq->special before
   hand. Than free them together with second request. This approach can be very stable, But
   it is bad because it is a layering violation. When block and SCSI layers decide to change
   the wiring of bidi. Users will have to change with them.

3. Let SCSI-ml manage a slab for scsi_data_buff's
   Have a flag to  scsi_setup_command_freelist() or a new API. When a device is flagged
   bidi-able we could 1-Allocate bigger slots to have extra memory for SDBs together
   with the command itself. or 2-allocate yet another slab for SDBs.

The 3rd approach is clean, and I can submit a patch for it. But I think it is not currently
necessary. The first solution (See attached patch) we can all live with, I hope. Since for
me it gives me the stability I need. And for the rest of the kernel it is the minimum
change, layered on existing building blocks.

If any one wants to try it out I put up the usual patchset that exercise this approach here.
http://www.bhalevy.com/open-osd/download/double_rq_bidi

Thanks
Boaz


--------------020001040008050006080001
Content-Type: text/plain;
 name="0002-scsi-ml-bidi-support.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0002-scsi-ml-bidi-support.patch"

>From ac8f0d3df711c5d01a269fde6a4ecce3000c3f68 Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Tue, 8 May 2007 14:04:46 +0300
Subject: [PATCH] scsi-ml bidi support

    At the block level bidi request uses req->next_rq pointer for a second
    bidi_read request.
    At Scsi-midlayer a second scsi_cmnd structure is used for the sglists
    of the bidi_read part. This command is put on request->next_rq->special.
    So struct scsi_cmnd is not changed. And scsi-ml minimally changes.

    - Define scsi_end_bidi_request() to do what scsi_end_request() does but for a
      bidi request. This is necessary because bidi commands are a bit tricky here.
      (See comments in body)

    - scsi_release_buffers() will also release the bidi_read buffers.
      I have changed the check from "if (cmd->use_sg)" to
      "if(cmd->request_buffer)" because it can now be called on half
      prepared commands. (and use_sg is no longer relevant here)

    - scsi_io_completion() will now call scsi_end_bidi_request on bidi commands
      and return.

    - The previous work done in scsi_init_io() is now done in a new
      scsi_init_data_buf() (which is 95% identical to old scsi_init_io())
      The new scsi_init_io() will call the above twice if needed also for
      the bidi_read command.

    - scsi_get_cmd_from_req() (called from scsi_setup_blk_pc_cmnd()) in the
      case that a new command is allocated, will also allocate a bidi_read
      command and hang it on cmd->request->next_rq->special. Only at this
      point is a command bidi.

    - scsi_setup_blk_pc_cmnd() will update sc_dma_direction to DMA_BIDIRECTIONAL
      which is not correct. It is only here for compatibility with iSCSI bidi
      driver. At final patch this will be a DMA_TO_DEVICE for this command and
      DMA_FROM_DEVICE for the bidi_read command. A driver must call scsi_bidi_cmnd()
      to work on bidi commands.

    - Define scsi_bidi_cmnd() to return true if it is a bidi command and a
      second command was allocated.

    - Define scsi_in()/scsi_out() to return the in or out commands from this command
      This API is to isolate users from the mechanics of bidi, and is also a short
      hand to common used code. (Even in scsi_lib.c)

    - In scsi_error.c at scsi_send_eh_cmnd() make sure bidi-lld is not confused by
      a get-sense command that looks like bidi. This is done by puting NULL at
      request->next_rq, and restoring before exit.
---
 drivers/scsi/scsi_error.c |    5 ++
 drivers/scsi/scsi_lib.c   |  133 ++++++++++++++++++++++++++++++++++++++++++---
 include/scsi/scsi_cmnd.h  |   19 ++++++-
 3 files changed, 148 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index e8350c5..169f4b4 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -620,6 +620,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	unsigned char old_cmd_len;
 	unsigned old_bufflen;
 	void *old_buffer;
+	struct request* old_next_rq;
 	int rtn;
 
 	/*
@@ -636,6 +637,9 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	old_cmd_len = scmd->cmd_len;
 	old_use_sg = scmd->use_sg;
 
+	old_next_rq = scmd->request->next_rq;
+	scmd->request->next_rq = NULL;
+
 	memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
 	memcpy(scmd->cmnd, cmnd, cmnd_size);
 
@@ -734,6 +738,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	/*
 	 * Restore original data
 	 */
+	scmd->request->next_rq = old_next_rq;
 	scmd->request_buffer = old_buffer;
 	scmd->request_bufflen = old_bufflen;
 	memcpy(scmd->cmnd, old_cmnd, sizeof(scmd->cmnd));
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 61fbcdc..0f49195 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -85,6 +85,10 @@ static void scsi_unprep_request(struct request *req)
 	req->cmd_flags &= ~REQ_DONTPREP;
 	req->special = NULL;
 
+	if (scsi_bidi_cmnd(cmd)) {
+		scsi_put_command(scsi_in(cmd));
+		cmd->request->next_rq->special = NULL;
+	}
 	scsi_put_command(cmd);
 }
 
@@ -701,6 +705,52 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int uptodate,
 	return NULL;
 }
 
+/*
+ * Bidi commands Must be complete as a whole, both sides at once.
+ * If part of the bytes were written and lld returned
+ * scsi_in()->resid or scsi_out()->resid this information will be left
+ * in req->data_len and req->next_rq->data_len. The upper-layer driver can
+ * decide what to do with this information.
+ */
+void scsi_end_bidi_request(struct scsi_cmnd *cmd)
+{
+	struct scsi_cmnd* bidi_in = scsi_in(cmd);
+	request_queue_t *q = cmd->device->request_queue;
+	struct request *req = cmd->request;
+	unsigned long flags;
+
+	end_that_request_chunk(req, 1, req->data_len);
+	req->data_len = cmd->resid;
+	end_that_request_chunk(req->next_rq, 1, req->next_rq->data_len);
+	req->next_rq->data_len = bidi_in->resid;
+
+	req->next_rq->special = NULL;
+	scsi_put_command(bidi_in);
+
+	/*
+	 *FIXME: If ll_rw_blk.c is changed to also put_request(req->next_rq)
+	 *       in end_that_request_last() then this WARN_ON must be removed.
+	 *       Otherwise, upper-driver must have registered an end_io.
+	 */
+	WARN_ON(!req->end_io);
+
+	/* FIXME: the following code can be shared with scsi_end_request */
+	add_disk_randomness(req->rq_disk);
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (blk_rq_tagged(req))
+		blk_queue_end_tag(q, req);
+
+	end_that_request_last(req, 1); /*allways good for now*/
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	/*
+	 * This will goose the queue request function at the end, so we don't
+	 * need to worry about launching another command.
+	 */
+	scsi_next_command(cmd);
+}
+
 struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
 	struct scsi_host_sg_pool *sgp;
@@ -775,7 +825,7 @@ EXPORT_SYMBOL(scsi_free_sgtable);
  */
 static void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
-	if (cmd->use_sg)
+	if (cmd->request_buffer)
 		scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
 
 	/*
@@ -784,6 +834,15 @@ static void scsi_release_buffers(struct scsi_cmnd *cmd)
 	 */
 	cmd->request_buffer = NULL;
 	cmd->request_bufflen = 0;
+
+	if (scsi_bidi_cmnd(cmd)) {
+		struct scsi_cmnd* bidi_in = scsi_in(cmd);
+		if (bidi_in->request_buffer)
+			scsi_free_sgtable(bidi_in->request_buffer,
+			                           bidi_in->sglist_len);
+		bidi_in->request_buffer = NULL;
+		bidi_in->request_bufflen = 0;
+	}
 }
 
 /*
@@ -849,9 +908,15 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				req->sense_len = len;
 			}
 		}
+		if (scsi_bidi_cmnd(cmd)) {
+			scsi_end_bidi_request(cmd);
+			return;
+		}
 		req->data_len = cmd->resid;
 	}
 
+	BUG_ON(blk_bidi_rq(req));
+
 	/*
 	 * Next deal with any sectors which we were able to correctly
 	 * handle.
@@ -978,17 +1043,18 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 EXPORT_SYMBOL(scsi_io_completion);
 
 /*
- * Function:    scsi_init_io()
+ * Function:    scsi_init_data_buf()
  *
- * Purpose:     SCSI I/O initialize function.
+ * Purpose:     SCSI I/O initialize helper.
+ *              maps the request buffers for the given cmd.
  *
- * Arguments:   cmd   - Command descriptor we wish to initialize
+ * Arguments:   cmd   - Command whos data we wish to initialize
  *
  * Returns:     0 on success
  *		BLKPREP_DEFER if the failure is retryable
  *		BLKPREP_KILL if the failure is fatal
  */
-static int scsi_init_io(struct scsi_cmnd *cmd)
+static int scsi_init_data_buff(struct scsi_cmnd *cmd)
 {
 	struct request     *req = cmd->request;
 	struct scatterlist *sgpnt;
@@ -1032,12 +1098,45 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 	printk(KERN_ERR "req nr_sec %lu, cur_nr_sec %u\n", req->nr_sectors,
 			req->current_nr_sectors);
 
-	/* release the command and kill it */
-	scsi_release_buffers(cmd);
-	scsi_put_command(cmd);
 	return BLKPREP_KILL;
 }
 
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
+static int scsi_init_io(struct scsi_cmnd *cmd)
+{
+	struct request *req = cmd->request;
+	int error;
+
+	error = scsi_init_data_buff(cmd);
+	if (error)
+		goto err_exit;
+
+	if (scsi_bidi_cmnd(cmd)) {
+		error = scsi_init_data_buff(scsi_in(cmd));
+		if (error)
+			goto err_exit;
+	}
+
+	req->buffer = NULL;
+	return 0;
+
+err_exit:
+	scsi_release_buffers(cmd);
+	if (error == BLKPREP_KILL)
+		scsi_unprep_request(req);
+	return error;
+}
+
 static int scsi_issue_flush_fn(request_queue_t *q, struct gendisk *disk,
 			       sector_t *error_sector)
 {
@@ -1064,6 +1163,22 @@ static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 		if (unlikely(!cmd))
 			return NULL;
 		req->special = cmd;
+		if (blk_bidi_rq(req)) {
+			struct scsi_cmnd *bidi_in_cmd;
+			/*
+			 * second bidi request must be blk_pc_request for use of
+			 * correct sizes.
+			 */
+			WARN_ON(!blk_pc_request(req->next_rq));
+
+			bidi_in_cmd = scsi_get_command(sdev, GFP_ATOMIC);
+			if (unlikely(!bidi_in_cmd)) {
+				scsi_put_command(cmd);
+				return NULL;
+			}
+			req->next_rq->special = bidi_in_cmd;
+			bidi_in_cmd->request = req->next_rq;
+		}
 	} else {
 		cmd = req->special;
 	}
@@ -1124,6 +1239,8 @@ static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 	cmd->cmd_len = req->cmd_len;
 	if (!req->data_len)
 		cmd->sc_data_direction = DMA_NONE;
+	else if (blk_bidi_rq(req))
+		cmd->sc_data_direction = DMA_BIDIRECTIONAL;
 	else if (rq_data_dir(req) == WRITE)
 		cmd->sc_data_direction = DMA_TO_DEVICE;
 	else
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a2e0c10..1223412 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -2,11 +2,11 @@
 #define _SCSI_SCSI_CMND_H
 
 #include <linux/dma-mapping.h>
+#include <linux/blkdev.h>
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/timer.h>
 
-struct request;
 struct scatterlist;
 struct Scsi_Host;
 struct scsi_device;
@@ -135,4 +135,21 @@ extern void scsi_kunmap_atomic_sg(void *virt);
 extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
 extern void scsi_free_sgtable(struct scatterlist *, int);
 
+static inline int scsi_bidi_cmnd(struct scsi_cmnd *cmd)
+{
+	return blk_bidi_rq(cmd->request) &&
+	       (cmd->request->next_rq->special != NULL);
+}
+
+static inline struct scsi_cmnd *scsi_in(struct scsi_cmnd *cmd)
+{
+	return scsi_bidi_cmnd(cmd) ?
+	       cmd->request->next_rq->special : cmd;
+}
+
+static inline struct scsi_cmnd *scsi_out(struct scsi_cmnd *cmd)
+{
+	return cmd;
+}
+
 #endif /* _SCSI_SCSI_CMND_H */
-- 
1.5.0.4.402.g8035


--------------020001040008050006080001--
