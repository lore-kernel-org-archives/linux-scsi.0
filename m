From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] add yielding cpu in scsi_error_handler()
Date: Mon, 1 Nov 2010 21:41:57 +0800
Message-ID: <AANLkTinU0iZ9jdOKmAQX2gdKb6VHxsHNDRyMqv=UX3GA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50860 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab0KANl6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2010 09:41:58 -0400
Received: by wyf28 with SMTP id 28so5519122wyf.19
        for <linux-scsi@vger.kernel.org>; Mon, 01 Nov 2010 06:41:57 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In cases that it is not ready to unjam host, the operation could be
deferred by yielding cpu since busy testing earns little help.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/scsi_error.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/scsi_error.c	2010-11-01 20:56:36.000000000 +0800
@@ -1765,6 +1765,7 @@ int scsi_error_handler(void *data)
 			SCSI_LOG_ERROR_RECOVERY(1,
 				printk("Error handler scsi_eh_%d sleeping\n",
 					shost->host_no));
+	yield:
 			schedule();
 			set_current_state(TASK_INTERRUPTIBLE);
 			continue;
@@ -1785,7 +1786,8 @@ int scsi_error_handler(void *data)
 				printk(KERN_ERR "Error handler scsi_eh_%d "
 						"unable to autoresume\n",
 						shost->host_no));
-			continue;
+			set_current_state(TASK_INTERRUPTIBLE);
+			goto yield;
 		}

 		if (shost->transportt->eh_strategy_handler)
