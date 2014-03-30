From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: misc scsi midlayer updates
Date: Sun, 30 Mar 2014 18:33:27 +0300
Message-ID: <53383947.3050001@gmail.com>
References: <1395936862-6938-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090100060009050203020301"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54971 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaC3Pdd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Mar 2014 11:33:33 -0400
Received: by mail-pd0-f182.google.com with SMTP id y10so6909415pdj.13
        for <linux-scsi@vger.kernel.org>; Sun, 30 Mar 2014 08:33:32 -0700 (PDT)
In-Reply-To: <1395936862-6938-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090100060009050203020301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/27/2014 06:14 PM, Christoph Hellwig wrote:
> Various patches from the scsi multiqueue development that make sense on their
> own.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Christoph

Many years ago I have sent these exact patches but no-one cared Including
me I guess.

(one instance is here, I sent it several times)
	http://comments.gmane.org/gmane.linux.scsi/63347

Please note the 4th patch which is a real BUG, titled:
	scsi_lib: Can't RETRY scsi_cmnd if some bytes were completed

I think my:
	scsi_lib: Remove that __scsi_release_buffers contraption
Is more elegant, is layered better and is smaller code. (please
consider my version)

Also the first patch is some more cleanup you'd like.

The main patch of collapsing  scsi_end_request is basically the same.

Funny that I've just rebased an exactly 2 years ago version and it
rebased cleanly. So here they are for your reference.

[PATCH 1/4] scsi_lib: request_queue is only needed inside
[PATCH 2/4] scsi_lib: Remove that __scsi_release_buffers contraption
[PATCH 3/4] scsi_lib: Collapse scsi_end_request into only user
[PATCH 4/4] scsi_lib: BUG: Can't RETRY scsi_cmnd if some bytes were

[Your patches have been tested within my MQ testing right?]

Thanks for pushing on this
Boaz


--------------090100060009050203020301
Content-Type: text/x-patch;
 name="0001-scsi_lib-request_queue-is-only-needed-inside-scsi_re.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-scsi_lib-request_queue-is-only-needed-inside-scsi_re.pa";
 filename*1="tch"

>From 9809b82bbb9813370738ac00400c01d61b0c51b4 Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Mon, 4 Jan 2010 10:45:56 +0200
Subject: [PATCH 1/4] scsi_lib: request_queue is only needed inside
 scsi_requeue_command

This is a pure cleanup. Just starting the engines for things
to come.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 62ec84b..dd834ca 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -491,10 +491,11 @@ void scsi_requeue_run_queue(struct work_struct *work)
  *		sector.
  * Notes:	Upon return, cmd is a stale pointer.
  */
-static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
+static void scsi_requeue_command(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
 	struct request *req = cmd->request;
+	struct request_queue *q = req->q;
 	unsigned long flags;
 
 	/*
@@ -565,7 +566,6 @@ static void __scsi_release_buffers(struct scsi_cmnd *, int);
 static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 					  int bytes, int requeue)
 {
-	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 
 	/*
@@ -584,7 +584,7 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 				 * queue, and goose the queue again.
 				 */
 				scsi_release_buffers(cmd);
-				scsi_requeue_command(q, cmd);
+				scsi_requeue_command(cmd);
 				cmd = NULL;
 			}
 			return cmd;
@@ -779,7 +779,6 @@ static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int error = 0;
 	struct scsi_sense_hdr sshdr;
@@ -1003,7 +1002,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			scsi_print_command(cmd);
 		}
 		if (blk_end_request_err(req, error))
-			scsi_requeue_command(q, cmd);
+			scsi_requeue_command(cmd);
 		else
 			scsi_next_command(cmd);
 		break;
@@ -1012,7 +1011,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		 * A new command will be prepared and issued.
 		 */
 		scsi_release_buffers(cmd);
-		scsi_requeue_command(q, cmd);
+		scsi_requeue_command(cmd);
 		break;
 	case ACTION_RETRY:
 		/* Retry the same command immediately */
-- 
1.8.5.3


--------------090100060009050203020301
Content-Type: text/x-patch;
 name="0002-scsi_lib-Remove-that-__scsi_release_buffers-contrapt.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-scsi_lib-Remove-that-__scsi_release_buffers-contrapt.pa";
 filename*1="tch"

>From aac579b02c7d3665665a1f1f7c064a82b70b873a Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Mon, 4 Jan 2010 12:46:06 +0200
Subject: [PATCH 2/4] scsi_lib: Remove that __scsi_release_buffers contraption

Remove "do_bidi_check" by checking and nullifying cmd->request
when blk_end_* indicates the request is no longer valid.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c | 41 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index dd834ca..c4cdc6a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -539,8 +539,6 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 		scsi_run_queue(sdev->request_queue);
 }
 
-static void __scsi_release_buffers(struct scsi_cmnd *, int);
-
 /*
  * Function:    scsi_end_request()
  *
@@ -591,11 +589,12 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 		}
 	}
 
+	cmd->request = NULL;
 	/*
 	 * This will goose the queue request function at the end, so we don't
 	 * need to worry about launching another command.
 	 */
-	__scsi_release_buffers(cmd, 0);
+	scsi_release_buffers(cmd);
 	scsi_next_command(cmd);
 	return NULL;
 }
@@ -651,26 +650,6 @@ static void scsi_free_sgtable(struct scsi_data_buffer *sdb)
 	__sg_free_table(&sdb->table, SCSI_MAX_SG_SEGMENTS, scsi_sg_free);
 }
 
-static void __scsi_release_buffers(struct scsi_cmnd *cmd, int do_bidi_check)
-{
-
-	if (cmd->sdb.table.nents)
-		scsi_free_sgtable(&cmd->sdb);
-
-	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
-
-	if (do_bidi_check && scsi_bidi_cmnd(cmd)) {
-		struct scsi_data_buffer *bidi_sdb =
-			cmd->request->next_rq->special;
-		scsi_free_sgtable(bidi_sdb);
-		kmem_cache_free(scsi_sdb_cache, bidi_sdb);
-		cmd->request->next_rq->special = NULL;
-	}
-
-	if (scsi_prot_sg_count(cmd))
-		scsi_free_sgtable(cmd->prot_sdb);
-}
-
 /*
  * Function:    scsi_release_buffers()
  *
@@ -690,7 +669,21 @@ static void __scsi_release_buffers(struct scsi_cmnd *cmd, int do_bidi_check)
  */
 void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
-	__scsi_release_buffers(cmd, 1);
+	if (cmd->sdb.table.nents)
+		scsi_free_sgtable(&cmd->sdb);
+
+	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
+
+	if (cmd->request && scsi_bidi_cmnd(cmd)) {
+		struct scsi_data_buffer *bidi_sdb =
+			cmd->request->next_rq->special;
+		scsi_free_sgtable(bidi_sdb);
+		kmem_cache_free(scsi_sdb_cache, bidi_sdb);
+		cmd->request->next_rq->special = NULL;
+	}
+
+	if (scsi_prot_sg_count(cmd))
+		scsi_free_sgtable(cmd->prot_sdb);
 }
 EXPORT_SYMBOL(scsi_release_buffers);
 
-- 
1.8.5.3


--------------090100060009050203020301
Content-Type: text/x-patch;
 name="0003-scsi_lib-Collapse-scsi_end_request-into-only-user.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-scsi_lib-Collapse-scsi_end_request-into-only-user.patch"

>From a93c49e5cbc1b3bd0bcda49318499b557a25e622 Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <Boaz Harrosh bharrosh@panasas.com>
Date: Tue, 5 Apr 2011 18:40:10 -0700
Subject: [PATCH 3/4] scsi_lib: Collapse scsi_end_request into only user

Embedding scsi_end_request() into scsi_io_completion actually simplifies
the code and makes it clearer what's going on.

There is absolutely no functional and/or side effects changes after this
patch.

Patch was inspired by Alan Stern.

CC: Hannes Reinecke <hare@suse.de>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c | 94 +++++++++++--------------------------------------
 1 file changed, 21 insertions(+), 73 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c4cdc6a..fa8612d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -539,66 +539,6 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 		scsi_run_queue(sdev->request_queue);
 }
 
-/*
- * Function:    scsi_end_request()
- *
- * Purpose:     Post-processing of completed commands (usually invoked at end
- *		of upper level post-processing and scsi_io_completion).
- *
- * Arguments:   cmd	 - command that is complete.
- *              error    - 0 if I/O indicates success, < 0 for I/O error.
- *              bytes    - number of bytes of completed I/O
- *		requeue  - indicates whether we should requeue leftovers.
- *
- * Lock status: Assumed that lock is not held upon entry.
- *
- * Returns:     cmd if requeue required, NULL otherwise.
- *
- * Notes:       This is called for block device requests in order to
- *              mark some number of sectors as complete.
- * 
- *		We are guaranteeing that the request queue will be goosed
- *		at some point during this call.
- * Notes:	If cmd was requeued, upon return it will be a stale pointer.
- */
-static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
-					  int bytes, int requeue)
-{
-	struct request *req = cmd->request;
-
-	/*
-	 * If there are blocks left over at the end, set up the command
-	 * to queue the remainder of them.
-	 */
-	if (blk_end_request(req, error, bytes)) {
-		/* kill remainder if no retrys */
-		if (error && scsi_noretry_cmd(cmd))
-			blk_end_request_all(req, error);
-		else {
-			if (requeue) {
-				/*
-				 * Bleah.  Leftovers again.  Stick the
-				 * leftovers in the front of the
-				 * queue, and goose the queue again.
-				 */
-				scsi_release_buffers(cmd);
-				scsi_requeue_command(cmd);
-				cmd = NULL;
-			}
-			return cmd;
-		}
-	}
-
-	cmd->request = NULL;
-	/*
-	 * This will goose the queue request function at the end, so we don't
-	 * need to worry about launching another command.
-	 */
-	scsi_release_buffers(cmd);
-	scsi_next_command(cmd);
-	return NULL;
-}
-
 static inline unsigned int scsi_sgtable_index(unsigned short nents)
 {
 	unsigned int index;
@@ -777,7 +717,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int sense_deferred = 0;
-	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
+	enum {ACTION_NEXT_CMND, ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
 	      ACTION_DELAYED_RETRY} action;
 	char *description = NULL;
 
@@ -856,17 +796,19 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		error = 0;
 	}
 
-	/*
-	 * A number of bytes were successfully read.  If there
-	 * are leftovers and there is some kind of error
-	 * (result != 0), retry the rest.
-	 */
-	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
-		return;
-
-	error = __scsi_error_from_host_byte(cmd, result);
-
-	if (host_byte(result) == DID_RESET) {
+	if (likely(0 == blk_end_request(req, error, good_bytes))) {
+		/* All is done and good move to next command */
+		cmd->request = NULL;
+		action = ACTION_NEXT_CMND;
+	} else if (result == 0) {
+		/* Wrote some bytes but request was split */
+		action = ACTION_REPREP;
+	} else if (error && scsi_noretry_cmd(cmd)) {
+		/* kill remainder if no retries */
+		blk_end_request_all(req, error);
+		cmd->request = NULL;
+		action = ACTION_NEXT_CMND;
+	} else if (host_byte(result) == DID_RESET) {
 		/* Third party bus reset or reset for error recovery
 		 * reasons.  Just retry the command and see what
 		 * happens.
@@ -981,7 +923,13 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		action = ACTION_FAIL;
 	}
 
+	error = __scsi_error_from_host_byte(cmd, result);
+
 	switch (action) {
+	case ACTION_NEXT_CMND :
+		scsi_release_buffers(cmd);
+		scsi_next_command(cmd);
+		break;
 	case ACTION_FAIL:
 		/* Give up and fail the remainder of the request */
 		scsi_release_buffers(cmd);
@@ -994,7 +942,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				scsi_print_sense("", cmd);
 			scsi_print_command(cmd);
 		}
-		if (blk_end_request_err(req, error))
+		if (blk_end_request_err(req, error ? error : -EIO))
 			scsi_requeue_command(cmd);
 		else
 			scsi_next_command(cmd);
-- 
1.8.5.3


--------------090100060009050203020301
Content-Type: text/x-patch;
 name="0004-scsi_lib-BUG-Can-t-RETRY-scsi_cmnd-if-some-bytes-wer.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0004-scsi_lib-BUG-Can-t-RETRY-scsi_cmnd-if-some-bytes-wer.pa";
 filename*1="tch"

>From 3879be0877262643aa0d1884a13e6f7296cb3738 Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <Boaz Harrosh bharrosh@panasas.com>
Date: Tue, 5 Apr 2011 18:54:44 -0700
Subject: [PATCH 4/4] scsi_lib: BUG: Can't RETRY scsi_cmnd if some bytes were
 completed

In scsi_io_completion() there are many cases where action is
set to ACTION_RETRY or ACTION_DELAYED_RETRY. But we are not
allowed to just RETRY a command if some bytes where already
completed by blk_end_request(). This is a bad memory overrun
of DMA writing/reading random memory. We must re-prepare the
command in this case.

It is possible that all the cases that set ACTION_RETRY* have
actually come with good_bytes=0 (.i.e resid = everything) But
both the error and resid value come from LLDs and/or targets
and should not be trusted with such a BAD crash. Better safe
than sorry.

It is possible that this fix is actually not good enough and
in the case of some of these RETRYs we need to not call
blk_end_request() in the first place. But this calls for
a structural reorganisation of scsi_io_completion(). James
this is your turf please have a look.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fa8612d..50a0bc6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -925,6 +925,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 
 	error = __scsi_error_from_host_byte(cmd, result);
 
+	if (action >= ACTION_RETRY && good_bytes)
+		/* We cannot just retry if above blk_end_request advanced on
+		 * some good_bytes, so ACTION_REPREP
+		 */
+		action = ACTION_REPREP;
+
 	switch (action) {
 	case ACTION_NEXT_CMND :
 		scsi_release_buffers(cmd);
-- 
1.8.5.3


--------------090100060009050203020301--
