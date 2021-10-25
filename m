Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91598C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 14:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73FB160F0F
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 14:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhJYOmU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 10:42:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231428AbhJYOmS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Oct 2021 10:42:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635172796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qi8Ur0wkNUJlDPOKm89KiDQQH4Qv7IkArSPtNrLZQr0=;
        b=YVOowHK/FoEp+AF0VvYVxf7/jzgGcJPdcuotaYXC8T/KmCGXAkKR625pW/LccqATzK/oIQ
        FZvvdQ+OZiVG5UFphqDnte3jq+qzNu2BJ5JPFXHY3rtjcIg6i9yGFxvHEurGC3Kqqyz4gd
        5xhWAa+GRXO7vEOL3PyKQOKifruVkuY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-UVUFWwSSNM6ps63DNjV8ZA-1; Mon, 25 Oct 2021 10:39:54 -0400
X-MC-Unique: UVUFWwSSNM6ps63DNjV8ZA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDC54112C143
        for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2021 14:39:53 +0000 (UTC)
Received: from emilne.bos.redhat.com (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B7D75D9D5
        for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2021 14:39:53 +0000 (UTC)
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     linux-scsi@vger.kernel.org
Subject: [PATCH 2/2] scsi: core: simplify control flow in scmd_eh_abort_handler
Date:   Mon, 25 Oct 2021 10:39:52 -0400
Message-Id: <20211025143952.17128-3-emilne@redhat.com>
In-Reply-To: <20211025143952.17128-1-emilne@redhat.com>
References: <20211025143952.17128-1-emilne@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Simplify the nested conditionals in the function by using
a label for the error path, and remove duplicate code.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_error.c | 104 ++++++++++++++++++++--------------------------
 1 file changed, 46 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 9f4001e..e8248bb 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -159,72 +159,60 @@ scmd_eh_abort_handler(struct work_struct *work)
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
-		rtn = scsi_try_to_abort_cmd(shost->hostt, scmd);
-		if (rtn == SUCCESS) {
-			set_host_byte(scmd, DID_TIME_OUT);
-			if (scsi_host_eh_past_deadline(shost)) {
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
-
-				spin_lock_irqsave(shost->host_lock, flags);
-				list_del_init(&scmd->eh_entry);
-
-				/*
-				 * If the abort succeeds, and there is no further
-				 * EH action, clear the ->last_reset time.
-				 */
-				if (list_empty(&shost->eh_abort_list) &&
-				    list_empty(&shost->eh_cmd_q))
-					if (shost->eh_deadline != -1)
-						shost->last_reset = 0;
-
-				spin_unlock_irqrestore(shost->host_lock, flags);
-
-				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
-				return;
-			} else {
-				SCSI_LOG_ERROR_RECOVERY(3,
-					scmd_printk(KERN_WARNING, scmd,
-						    "finish aborted command\n"));
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
+	}
 
-				spin_lock_irqsave(shost->host_lock, flags);
-				list_del_init(&scmd->eh_entry);
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_del_init(&scmd->eh_entry);
 
-				/*
-				 * If the abort succeeds, and there is no further
-				 * EH action, clear the ->last_reset time.
-				 */
-				if (list_empty(&shost->eh_abort_list) &&
-				    list_empty(&shost->eh_cmd_q))
-					if (shost->eh_deadline != -1)
-						shost->last_reset = 0;
+	/*
+	 * If the abort succeeds, and there is no further
+	 * EH action, clear the ->last_reset time.
+	 */
+	if (list_empty(&shost->eh_abort_list) &&
+	    list_empty(&shost->eh_cmd_q))
+		if (shost->eh_deadline != -1)
+			shost->last_reset = 0;
 
-				spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
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
 	}
+	return;
 
+out:
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_del_init(&scmd->eh_entry);
 	spin_unlock_irqrestore(shost->host_lock, flags);
-- 
2.1.0

