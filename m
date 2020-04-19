Return-Path: <SRS0=TURL=6D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58CDC38A29
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Apr 2020 05:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F7DD21744
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Apr 2020 05:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgDSFCe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Apr 2020 01:02:34 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38198 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgDSFCe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Apr 2020 01:02:34 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id 611582A03DF
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel@collabora.com, martin.petersen@oracle.com,
        jejb@linux.ibm.com,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
Subject: [RESEND PATCH v2] scsi: core: Change function comments to kernel-doc style
Date:   Sun, 19 Apr 2020 02:01:48 -0300
Message-Id: <20200419050148.33371-1-andrealmeid@collabora.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Despite of functions being documented, they are not in the kernel-doc
specification, and could not be included in kernel documentation. Change
the style of functions comments to be compliant to the kernel-doc style.
When the function comment is outdated, update then.

Signed-off-by: André Almeida <andrealmeid@collabora.com>
---
Hello,

This v2 is from a commit originally from this serie:
https://patchwork.kernel.org/patch/11141867/

This patched was tested with kernel-doc script and the HTML output was
verified as well.

Thanks,
	André

Changes from v1:
- Update "midlevel queue" to "scheduler queue". This seems to be the
correct term after following the call stack until reach a call to
blk_mq_sched_requeue_request().
- Update names of functions at scsi_io_completion() comment.
- Remove duplicated comment at scsi_io_completion().
---
 drivers/scsi/scsi_lib.c | 169 +++++++++++++++-------------------------
 1 file changed, 62 insertions(+), 107 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 47835c4b4ee0..8e5195816150 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -202,24 +202,17 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool unbusy)
 	blk_mq_requeue_request(cmd->request, true);
 }
 
-/*
- * Function:    scsi_queue_insert()
- *
- * Purpose:     Insert a command in the midlevel queue.
- *
- * Arguments:   cmd    - command that we are adding to queue.
- *              reason - why we are inserting command to queue.
- *
- * Lock status: Assumed that lock is not held upon entry.
+/**
+ * scsi_queue_insert - Reinsert a command in the scheduler queue.
+ * @cmd:    command that we are adding to queue.
+ * @reason: why we are inserting command to queue.
  *
- * Returns:     Nothing.
+ * We do this for one of two cases. Either the host is busy and it cannot accept
+ * any more commands for the time being, or the device returned QUEUE_FULL and
+ * can accept no more commands.
  *
- * Notes:       We do this for one of two cases.  Either the host is busy
- *              and it cannot accept any more commands for the time being,
- *              or the device returned QUEUE_FULL and can accept no more
- *              commands.
- * Notes:       This could be called either from an interrupt context or a
- *              normal process context.
+ * Context: This could be called either from an interrupt context or a normal
+ * process context.
  */
 void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 {
@@ -301,16 +294,12 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 }
 EXPORT_SYMBOL(__scsi_execute);
 
-/*
- * Function:    scsi_init_cmd_errh()
- *
- * Purpose:     Initialize cmd fields related to error handling.
- *
- * Arguments:   cmd	- command that is ready to be queued.
+/**
+ * scsi_init_cmd_errh - Initialize cmd fields related to error handling.
+ * @cmd:  command that is ready to be queued.
  *
- * Notes:       This function has the job of initializing a number of
- *              fields related to error handling.   Typically this will
- *              be called once for each command, as required.
+ * This function has the job of initializing a number of fields related to error
+ * handling. Typically this will be called once for each command, as required.
  */
 static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 {
@@ -496,17 +485,11 @@ static void scsi_starved_list_run(struct Scsi_Host *shost)
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
-/*
- * Function:   scsi_run_queue()
- *
- * Purpose:    Select a proper request queue to serve next
- *
- * Arguments:  q       - last request's queue
- *
- * Returns:     Nothing
+/**
+ * scsi_run_queue - Select a proper request queue to serve next.
+ * @q:  last request's queue
  *
- * Notes:      The previous command was completely finished, start
- *             a new one if possible.
+ * The previous command was completely finished, start a new one if possible.
  */
 static void scsi_run_queue(struct request_queue *q)
 {
@@ -896,34 +879,27 @@ static int scsi_io_completion_nz_result(struct scsi_cmnd *cmd, int result,
 	return result;
 }
 
-/*
- * Function:    scsi_io_completion()
- *
- * Purpose:     Completion processing for block device I/O requests.
- *
- * Arguments:   cmd   - command that is finished.
- *
- * Lock status: Assumed that no lock is held upon entry.
- *
- * Returns:     Nothing
- *
- * Notes:       We will finish off the specified number of sectors.  If we
- *		are done, the command block will be released and the queue
- *		function will be goosed.  If we are not done then we have to
- *		figure out what to do next:
- *
- *		a) We can call scsi_requeue_command().  The request
- *		   will be unprepared and put back on the queue.  Then
- *		   a new command will be created for it.  This should
- *		   be used if we made forward progress, or if we want
- *		   to switch from READ(10) to READ(6) for example.
- *
- *		b) We can call __scsi_queue_insert().  The request will
- *		   be put back on the queue and retried using the same
- *		   command as before, possibly after a delay.
- *
- *		c) We can call scsi_end_request() with blk_stat other than
- *		   BLK_STS_OK, to fail the remainder of the request.
+/**
+ * scsi_io_completion - Completion processing for SCSI commands.
+ * @cmd:	command that is finished.
+ * @good_bytes:	number of processed bytes.
+ *
+ * We will finish off the specified number of sectors. If we are done, the
+ * command block will be released and the queue function will be goosed. If we
+ * are not done then we have to figure out what to do next:
+ *
+ *   a) We can call scsi_io_completion_reprep().  The request
+ *	will be unprepared and put back on the queue.  Then
+ *	a new command will be created for it.  This should
+ *	be used if we made forward progress, or if we want
+ *	to switch from READ(10) to READ(6) for example.
+ *
+ *   b) We can call scsi_io_completion_action().  The request will
+ *	be put back on the queue and retried using the same
+ *	command as before, possibly after a delay.
+ *
+ *   c) We can call scsi_end_request() with blk_stat other than
+ *	BLK_STS_OK, to fail the remainder of the request.
  */
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
@@ -951,8 +927,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		blk_rq_sectors(req), good_bytes));
 
 	/*
-	 * Next deal with any sectors which we were able to correctly
-	 * handle. Failed, zero length commands always need to drop down
+	 * Failed, zero length commands always need to drop down
 	 * to retry code. Fast path should return in this block.
 	 */
 	if (likely(blk_rq_bytes(req) > 0 || blk_stat == BLK_STS_OK)) {
@@ -1002,16 +977,14 @@ static blk_status_t scsi_init_sgtable(struct request *req,
 	return BLK_STS_OK;
 }
 
-/*
- * Function:    scsi_init_io()
- *
- * Purpose:     SCSI I/O initialize function.
- *
- * Arguments:   cmd   - Command descriptor we wish to initialize
+/**
+ * scsi_init_io - SCSI I/O initialize function.
+ * @cmd:  command descriptor we wish to initialize
  *
- * Returns:     BLK_STS_OK on success
- *		BLK_STS_RESOURCE if the failure is retryable
- *		BLK_STS_IOERR if the failure is fatal
+ * Returns:
+ * * BLK_STS_OK       - on success
+ * * BLK_STS_RESOURCE - if the failure is retryable
+ * * BLK_STS_IOERR    - if the failure is fatal
  */
 blk_status_t scsi_init_io(struct scsi_cmnd *cmd)
 {
@@ -1921,21 +1894,13 @@ struct scsi_device *scsi_device_from_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(scsi_device_from_queue);
 
-/*
- * Function:    scsi_block_requests()
- *
- * Purpose:     Utility function used by low-level drivers to prevent further
- *		commands from being queued to the device.
- *
- * Arguments:   shost       - Host in question
- *
- * Returns:     Nothing
- *
- * Lock status: No locks are assumed held.
+/**
+ * scsi_block_requests - Utility function used by low-level drivers to prevent
+ * further commands from being queued to the device.
+ * @shost:  host in question
  *
- * Notes:       There is no timer nor any other means by which the requests
- *		get unblocked other than the low-level driver calling
- *		scsi_unblock_requests().
+ * There is no timer nor any other means by which the requests get unblocked
+ * other than the low-level driver calling scsi_unblock_requests().
  */
 void scsi_block_requests(struct Scsi_Host *shost)
 {
@@ -1943,25 +1908,15 @@ void scsi_block_requests(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL(scsi_block_requests);
 
-/*
- * Function:    scsi_unblock_requests()
- *
- * Purpose:     Utility function used by low-level drivers to allow further
- *		commands from being queued to the device.
- *
- * Arguments:   shost       - Host in question
- *
- * Returns:     Nothing
- *
- * Lock status: No locks are assumed held.
- *
- * Notes:       There is no timer nor any other means by which the requests
- *		get unblocked other than the low-level driver calling
- *		scsi_unblock_requests().
- *
- *		This is done as an API function so that changes to the
- *		internals of the scsi mid-layer won't require wholesale
- *		changes to drivers that use this feature.
+/**
+ * scsi_unblock_requests - Utility function used by low-level drivers to allow
+ * further commands from being queued to the device.
+ * @shost:  host in question
+ *
+ * There is no timer nor any other means by which the requests get unblocked
+ * other than the low-level driver calling scsi_unblock_requests(). This is done
+ * as an API function so that changes to the internals of the scsi mid-layer
+ * won't require wholesale changes to drivers that use this feature.
  */
 void scsi_unblock_requests(struct Scsi_Host *shost)
 {
-- 
2.26.1

