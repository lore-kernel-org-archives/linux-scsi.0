From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] fix wait/complete in scsi error handling
Date: Tue, 30 Nov 2010 21:47:32 +0800
Message-ID: <AANLkTinj09f70jWjVqt=S3GmmeDm+m4fWN7Rx92QNLb9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:56540 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab0K3Nre (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2010 08:47:34 -0500
Received: by wwb39 with SMTP id 39so158845wwb.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2010 05:47:33 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: devel@open-fcoe.org

After calling the queuecommand callback, say fc_queuecommand in libfc,
scsi cmnd could be not delivered to LLD, and done function could also
be not issued. Thus there could be nobody responsible for completing
the waiter later.

What is more, the subsequent computation based on the timeleft after
wait is unreasonable, same for the abort operation since scmd is not
sent to underlying device.

Fix is to jump wait if no completion will occur.

The patch is prepared according to the implementation of
fc_queuecommand, and there is room for fix for other cases.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/scsi_error.c	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/scsi/scsi_error.c	2010-11-30 21:31:46.000000000 +0800
@@ -790,9 +790,19 @@ static int scsi_send_eh_cmnd(struct scsi

 	spin_lock_irqsave(shost->host_lock, flags);
 	scsi_log_send(scmd);
-	shost->hostt->queuecommand(scmd, scsi_eh_done);
+	rtn = shost->hostt->queuecommand(scmd, scsi_eh_done);
 	spin_unlock_irqrestore(shost->host_lock, flags);

+	if (rtn != 0) {
+		/*
+		 * scmd could not send to sdev, and
+		 * scsi_eh_done() not called, so
+		 * skip wait for completing.
+		 */
+		 rtn = NEEDS_RETRY;
+		 goto out;
+	}
+
 	timeleft = wait_for_completion_timeout(&done, timeout);

 	shost->eh_action = NULL;
@@ -831,7 +841,7 @@ static int scsi_send_eh_cmnd(struct scsi
 		scsi_abort_eh_cmnd(scmd);
 		rtn = FAILED;
 	}
-
+ out:
 	scsi_eh_restore_cmnd(scmd, &ses);
 	return rtn;
 }
