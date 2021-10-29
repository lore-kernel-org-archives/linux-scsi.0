Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 261ECC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A10C60FC3
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhJ2Tpq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 15:45:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57830 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230202AbhJ2Tpo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 Oct 2021 15:45:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635536595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xDZnQ4yC2efa7G70nt8lzHw2Sm+JfUkp7prj/1sAJ8k=;
        b=hOs7aHi/V1YYYNIP0VJMj/nXmP30rEJ3DLfI9fmrjxnM9cQcxN6lnxt5yZ0AINWcpkZXxt
        /I4VSInuTUbR55Yzsv+OyGUnGx2JgYNFyfo5Hxie4mchR0O5yoYQWpXDeHUmOCW6XLq1GY
        xjhXPZrtyiBsOkRe7czncB/EMZLm7Ns=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-yZjxMfqXOamAWVN89nluTg-1; Fri, 29 Oct 2021 15:43:13 -0400
X-MC-Unique: yZjxMfqXOamAWVN89nluTg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1635F10A8E00
        for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2021 19:43:13 +0000 (UTC)
Received: from emilne.bos.redhat.com (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D61196788F
        for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2021 19:43:12 +0000 (UTC)
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     linux-scsi@vger.kernel.org
Subject: [PATCH v2 2/2] scsi: core: simplify control flow in scmd_eh_abort_handler()
Date:   Fri, 29 Oct 2021 15:43:11 -0400
Message-Id: <20211029194311.17504-3-emilne@redhat.com>
In-Reply-To: <20211029194311.17504-1-emilne@redhat.com>
References: <20211029194311.17504-1-emilne@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Simplify the nested conditionals in the function by using
a label for the error path.  Introduce local "shost" to avoid
repeated "sdev->shost" usage.  Also remove scsi_eh_complete_abort()
since there is now only one place it would be called.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_error.c | 109 +++++++++++++++++++++++-----------------------
 1 file changed, 55 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 408d49c..e8248bb 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -135,23 +135,6 @@ static bool scsi_eh_should_retry_cmd(struct scsi_cmnd *cmd)
 	return true;
 }
 
-static void scsi_eh_complete_abort(struct scsi_cmnd *scmd, struct Scsi_Host *shost)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	list_del_init(&scmd->eh_entry);
-	/*
-	 * If the abort succeeds, and there is no further
-	 * EH action, clear the ->last_reset time.
-	 */
-	if (list_empty(&shost->eh_abort_list) &&
-	    list_empty(&shost->eh_cmd_q))
-		if (shost->eh_deadline != -1)
-			shost->last_reset = 0;
-	spin_unlock_irqrestore(shost->host_lock, flags);
-}
-
 /**
  * scmd_eh_abort_handler - Handle command aborts
  * @work:	command to be aborted.
@@ -168,54 +151,72 @@ scmd_eh_abort_handler(struct work_struct *work)
 	struct scsi_cmnd *scmd =
 		container_of(work, struct scsi_cmnd, abort_work.work);
 	struct scsi_device *sdev = scmd->device;
+	struct Scsi_Host *shost = sdev->host;
 	enum scsi_disposition rtn;
 	unsigned long flags;
 
-	if (scsi_host_eh_past_deadline(sdev->host)) {
+	if (scsi_host_eh_past_deadline(shost)) {
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
 				    "eh timeout, not aborting\n"));
-	} else {
-		SCSI_LOG_ERROR_RECOVERY(3,
+		goto out;
+	}
+
+	SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
 				    "aborting command\n"));
-		rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
-		if (rtn == SUCCESS) {
-			set_host_byte(scmd, DID_TIME_OUT);
-			if (scsi_host_eh_past_deadline(sdev->host)) {
-				SCSI_LOG_ERROR_RECOVERY(3,
-					scmd_printk(KERN_INFO, scmd,
-						    "eh timeout, not retrying "
-						    "aborted command\n"));
-			} else if (!scsi_noretry_cmd(scmd) &&
-				   scsi_cmd_retry_allowed(scmd) &&
-				scsi_eh_should_retry_cmd(scmd)) {
-				SCSI_LOG_ERROR_RECOVERY(3,
-					scmd_printk(KERN_WARNING, scmd,
-						    "retry aborted command\n"));
-				scsi_eh_complete_abort(scmd, sdev->host);
-				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
-				return;
-			} else {
-				SCSI_LOG_ERROR_RECOVERY(3,
-					scmd_printk(KERN_WARNING, scmd,
-						    "finish aborted command\n"));
-				scsi_eh_complete_abort(scmd, sdev->host);
-				scsi_finish_command(scmd);
-				return;
-			}
-		} else {
-			SCSI_LOG_ERROR_RECOVERY(3,
-				scmd_printk(KERN_INFO, scmd,
-					    "cmd abort %s\n",
-					    (rtn == FAST_IO_FAIL) ?
-					    "not send" : "failed"));
-		}
+	rtn = scsi_try_to_abort_cmd(shost->hostt, scmd);
+	if (rtn != SUCCESS) {
+		SCSI_LOG_ERROR_RECOVERY(3,
+			scmd_printk(KERN_INFO, scmd,
+				    "cmd abort %s\n",
+				    (rtn == FAST_IO_FAIL) ?
+				    "not send" : "failed"));
+		goto out;
+	}
+	set_host_byte(scmd, DID_TIME_OUT);
+	if (scsi_host_eh_past_deadline(shost)) {
+		SCSI_LOG_ERROR_RECOVERY(3,
+			scmd_printk(KERN_INFO, scmd,
+				    "eh timeout, not retrying "
+				    "aborted command\n"));
+		goto out;
 	}
 
-	spin_lock_irqsave(sdev->host->host_lock, flags);
+	spin_lock_irqsave(shost->host_lock, flags);
 	list_del_init(&scmd->eh_entry);
-	spin_unlock_irqrestore(sdev->host->host_lock, flags);
+
+	/*
+	 * If the abort succeeds, and there is no further
+	 * EH action, clear the ->last_reset time.
+	 */
+	if (list_empty(&shost->eh_abort_list) &&
+	    list_empty(&shost->eh_cmd_q))
+		if (shost->eh_deadline != -1)
+			shost->last_reset = 0;
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	if (!scsi_noretry_cmd(scmd) &&
+	    scsi_cmd_retry_allowed(scmd) &&
+	    scsi_eh_should_retry_cmd(scmd)) {
+		SCSI_LOG_ERROR_RECOVERY(3,
+			scmd_printk(KERN_WARNING, scmd,
+				    "retry aborted command\n"));
+		scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
+	} else {
+		SCSI_LOG_ERROR_RECOVERY(3,
+			scmd_printk(KERN_WARNING, scmd,
+				    "finish aborted command\n"));
+		scsi_finish_command(scmd);
+	}
+	return;
+
+out:
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_del_init(&scmd->eh_entry);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 	scsi_eh_scmd_add(scmd);
 }
 
-- 
2.1.0

