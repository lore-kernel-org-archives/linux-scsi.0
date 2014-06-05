From: Steven Haber <steven@qumulo.com>
Subject: SCSI eats error from flush failure during hot plug
Date: Thu, 5 Jun 2014 16:52:29 -0700
Message-ID: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:51348 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaFEXwa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2014 19:52:30 -0400
Received: by mail-pd0-f175.google.com with SMTP id z10so1760408pdj.34
        for <linux-scsi@vger.kernel.org>; Thu, 05 Jun 2014 16:52:30 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I am testing ATA device durability during hot unplug. I have a power
fault test suite that has turned up issues with the fsync->SCSI->ATA
codepath. If a device is unplugged while an fsync is in progress, ATA
returns a flush error to the SCSI driver but scsi_io_completion()
seems to disregard it. fsync() returns no error, which should mean
that the write was durably flushed to disk. I expect fsync() to return
EIO or something similar when the flush isn't acked by the device.

When the failure occurs, the SCSI sense key is set to ABORTED_COMMAND.
However, scsi_end_command() is called without any of the sense context
and scsi_io_completion() returns early without checking sense at all.

This commit may be related:
d6b0c53723753fc0cfda63f56735b225c43e1e9a
(http://git.opencores.org/?a=commitdiff&p=linux&h=d6b0c53723753fc0cfda63f56735b225c43e1e9a)

The following patch fixes the issue, but it's a hack. I only have a
vague understanding of Linux drivers, so I'm looking for advice on how
to make this fix better and get it upstream.

Thanks!

Steven Haber
Qumulo, Inc.





diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9db097a..789af39 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -822,40 +822,44 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
unsigned int good_bytes)
  /*
  * Recovered errors need reporting, but they're always treated
  * as success, so fiddle the result code here.  For BLOCK_PC
  * we already took a copy of the original into rq->errors which
  * is what gets returned to the user
  */
  if (sense_valid && (sshdr.sense_key == RECOVERED_ERROR)) {
  /* if ATA PASS-THROUGH INFORMATION AVAILABLE skip
  * print since caller wants ATA registers. Only occurs on
  * SCSI ATA PASS_THROUGH commands when CK_COND=1
  */
  if ((sshdr.asc == 0x0) && (sshdr.ascq == 0x1d))
  ;
  else if (!(req->cmd_flags & REQ_QUIET))
  scsi_print_sense("", cmd);
  result = 0;
  /* BLOCK_PC may have set error */
  error = 0;
  }

+ if (sense_valid && (sshdr.sense_key == ABORTED_COMMAND) &&
+    good_bytes == 0)
+ error = (sshdr.asc == 0x10) ? -EILSEQ : -EIO;
+
  /*
  * A number of bytes were successfully read.  If there
  * are leftovers and there is some kind of error
  * (result != 0), retry the rest.
  */
  if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
  return;

  error = __scsi_error_from_host_byte(cmd, result);

  if (host_byte(result) == DID_RESET) {
  /* Third party bus reset or reset for error recovery
  * reasons.  Just retry the command and see what
  * happens.
  */
  action = ACTION_RETRY;
  } else if (sense_valid && !sense_deferred) {
  switch (sshdr.sense_key) {
  case UNIT_ATTENTION:
  if (cmd->device->removable) {
