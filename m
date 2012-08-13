From: Masatake YAMATO <yamato@redhat.com>
Subject: [PATCH] libiscsi: avoid unnecessary multiple NULL assignments
Date: Mon, 13 Aug 2012 20:59:32 +0900
Message-ID: <1344859172-31808-1-git-send-email-yamato@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from h219-110-095-176.catv01.itscom.jp ([219.110.95.176]:47906 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753539Ab2HMREk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Aug 2012 13:04:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Masatake YAMATO <yamato@redhat.com>

In iscsi_free_task, NULL is assigned to task->sc twice: before and
after kfifo_in invocatoin. Allocating and freeing iscsi_task are guarded
with session->lock, so multiple NULL assignments cause no trouble. But
people reading the source code may be confused.

The second NULL assignment comes from commit:

    3e5c28ad0391389959ccae81c938c7533efb3490

It seems that the line after kfifo_in invocation was introduced
accidentally.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 82c3fd4..7aacf3a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -500,21 +500,20 @@ static void iscsi_free_task(struct iscsi_task *task)
 	task->sc = NULL;
 	/*
 	 * login task is preallocated so do not free
 	 */
 	if (conn->login_task == task)
 		return;
 
 	kfifo_in(&session->cmdpool.queue, (void*)&task, sizeof(void*));
 
 	if (sc) {
-		task->sc = NULL;
 		/* SCSI eh reuses commands to verify us */
 		sc->SCp.ptr = NULL;
 		/*
 		 * queue command may call this to free the task, so
 		 * it will decide how to return sc to scsi-ml.
 		 */
 		if (oldstate != ISCSI_TASK_REQUEUE_SCSIQ)
 			sc->scsi_done(sc);
 	}
 }
-- 
1.7.11.2

