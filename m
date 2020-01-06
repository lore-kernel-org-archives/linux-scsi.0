Return-Path: <SRS0=I90e=23=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C540C33C8C
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 18:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDB0F2072C
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 18:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgAFSO2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jan 2020 13:14:28 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35632 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgAFSO2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2020 13:14:28 -0500
Received: from turingmachine.home (unknown [IPv6:2804:431:c7f4:447f:d711:794d:1c68:5ed3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tonyk)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 5AF11290C87;
        Mon,  6 Jan 2020 18:14:22 +0000 (GMT)
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     kernel@collabora.com, krisman@collabora.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
Subject: [RESEND PATCH v2] scsi: core: Change function comments to kernel-doc style
Date:   Mon,  6 Jan 2020 15:12:14 -0300
Message-Id: <20200106181214.86249-1-andrealmeid@collabora.com>
X-Mailer: git-send-email 2.24.1
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
index 610ee41fa54c..d94803ff67f7 100644
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
@@ -897,34 +880,27 @@ static int scsi_io_completion_nz_result(struct scsi_cmnd *cmd, int result,
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
@@ -952,8 +928,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		blk_rq_sectors(req), good_bytes));
 
 	/*
-	 * Next deal with any sectors which we were able to correctly
-	 * handle. Failed, zero length commands always need to drop down
+	 * Failed, zero length commands always need to drop down
 	 * to retry code. Fast path should return in this block.
 	 */
 	if (likely(blk_rq_bytes(req) > 0 || blk_stat == BLK_STS_OK)) {
@@ -1003,16 +978,14 @@ static blk_status_t scsi_init_sgtable(struct request *req,
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
@@ -1932,21 +1905,13 @@ struct scsi_device *scsi_device_from_queue(struct request_queue *q)
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
@@ -1954,25 +1919,15 @@ void scsi_block_requests(struct Scsi_Host *shost)
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
2.24.1

