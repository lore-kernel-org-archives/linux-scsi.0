From: akpm@osdl.org
Subject: [patch 2/5] scsi_error thread exits in TASK_INTERRUPTIBLE state.
Date: Fri, 28 Oct 2005 15:07:50 -0700
Message-ID: <200510282207.j9SM7WuB022257@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:49846 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030263AbVJ1WHn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 18:07:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, rostedt@goodmis.org


From: Steven Rostedt <rostedt@goodmis.org>

Found in the -rt patch set.  The scsi_error thread likely will be in the
TASK_INTERRUPTIBLE state upon exit.  This patch fixes this bug.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/scsi_error.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/scsi/scsi_error.c~scsi_error-thread-exits-in-task_interruptible-state drivers/scsi/scsi_error.c
--- 25/drivers/scsi/scsi_error.c~scsi_error-thread-exits-in-task_interruptible-state	Fri Oct 28 15:06:03 2005
+++ 25-akpm/drivers/scsi/scsi_error.c	Fri Oct 28 15:06:03 2005
@@ -1644,6 +1644,7 @@ int scsi_error_handler(void *data)
 		scsi_restart_operations(shost);
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
+	__set_current_state(TASK_RUNNING);
 
 	__set_current_state(TASK_RUNNING);
 
_
