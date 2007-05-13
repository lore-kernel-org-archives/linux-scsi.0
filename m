From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aha152x: use wait_for_completion_timeout
Date: Sun, 13 May 2007 17:52:12 +0200
Message-ID: <20070513155212.GA9384@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:43124 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758866AbXEMPwV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 May 2007 11:52:21 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, fischer@norbit.de
Cc: linux-scsi@vger.kernel.org

Use wait_for_completion_timeout instead a semaphore + timer.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/aha152x.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aha152x.c	2007-05-13 16:14:29.000000000 +0200
+++ linux-2.6/drivers/scsi/aha152x.c	2007-05-13 16:22:01.000000000 +0200
@@ -240,6 +240,7 @@
 #include <linux/io.h>
 #include <linux/blkdev.h>
 #include <asm/system.h>
+#include <linux/completion.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/wait.h>
@@ -253,7 +254,6 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/list.h>
-#include <asm/semaphore.h>
 #include <scsi/scsicam.h>
 
 #include "scsi.h"
@@ -551,7 +551,7 @@ struct aha152x_hostdata {
  */
 struct aha152x_scdata {
 	Scsi_Cmnd *next;	/* next sc in queue */
-	struct semaphore *sem;	/* semaphore to block on */
+	struct completion *done;/* semaphore to block on */
 	unsigned char cmd_len;
 	unsigned char cmnd[MAX_COMMAND_SIZE];
 	unsigned short use_sg;
@@ -608,7 +608,7 @@ struct aha152x_scdata {
 
 #define SCDATA(SCpnt)		((struct aha152x_scdata *) (SCpnt)->host_scribble)
 #define SCNEXT(SCpnt)		SCDATA(SCpnt)->next
-#define SCSEM(SCpnt)		SCDATA(SCpnt)->sem
+#define SCSEM(SCpnt)		SCDATA(SCpnt)->done
 
 #define SG_ADDRESS(buffer)	((char *) (page_address((buffer)->page)+(buffer)->offset))
 
@@ -969,7 +969,8 @@ static int setup_expected_interrupts(str
 /* 
  *  Queue a command and setup interrupts for a free bus.
  */
-static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct semaphore *sem, int phase, void (*done)(Scsi_Cmnd *))
+static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
+		int phase, void (*done)(Scsi_Cmnd *))
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 	unsigned long flags;
@@ -1013,7 +1014,7 @@ static int aha152x_internal_queue(Scsi_C
 	}
 
 	SCNEXT(SCpnt)		= NULL;
-	SCSEM(SCpnt)		= sem;
+	SCSEM(SCpnt)		= complete;
 
 	/* setup scratch area
 	   SCp.ptr              : buffer pointer
@@ -1084,9 +1085,9 @@ static void reset_done(Scsi_Cmnd *SCpnt)
 	DPRINTK(debug_eh, INFO_LEAD "reset_done called\n", CMDINFO(SCpnt));
 #endif
 	if(SCSEM(SCpnt)) {
-		up(SCSEM(SCpnt));
+		complete(SCSEM(SCpnt));
 	} else {
-		printk(KERN_ERR "aha152x: reset_done w/o semaphore\n");
+		printk(KERN_ERR "aha152x: reset_done w/o completion\n");
 	}
 }
 
@@ -1139,21 +1140,6 @@ static int aha152x_abort(Scsi_Cmnd *SCpn
 	return FAILED;
 }
 
-static void timer_expired(unsigned long p)
-{
-	Scsi_Cmnd	 *SCp   = (Scsi_Cmnd *)p;
-	struct semaphore *sem   = SCSEM(SCp);
-	struct Scsi_Host *shpnt = SCp->device->host;
-	unsigned long flags;
-
-	/* remove command from issue queue */
-	DO_LOCK(flags);
-	remove_SC(&ISSUE_SC, SCp);
-	DO_UNLOCK(flags);
-
-	up(sem);
-}
-
 /*
  * Reset a device
  *
@@ -1161,14 +1147,14 @@ static void timer_expired(unsigned long 
 static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
-	DECLARE_MUTEX_LOCKED(sem);
-	struct timer_list timer;
+	DECLARE_COMPLETION(done);
 	int ret, issued, disconnected;
 	unsigned char old_cmd_len = SCpnt->cmd_len;
 	unsigned short old_use_sg = SCpnt->use_sg;
 	void *old_buffer = SCpnt->request_buffer;
 	unsigned old_bufflen = SCpnt->request_bufflen;
 	unsigned long flags;
+	unsigned long timeleft;
 
 #if defined(AHA152X_DEBUG)
 	if(HOSTDATA(shpnt)->debug & debug_eh) {
@@ -1192,15 +1178,15 @@ static int aha152x_device_reset(Scsi_Cmn
 	SCpnt->request_buffer  = NULL;
 	SCpnt->request_bufflen = 0;
 
-	init_timer(&timer);
-	timer.data     = (unsigned long) SCpnt;
-	timer.expires  = jiffies + 100*HZ;   /* 10s */
-	timer.function = (void (*)(unsigned long)) timer_expired;
-
-	aha152x_internal_queue(SCpnt, &sem, resetting, reset_done);
-	add_timer(&timer);
-	down(&sem);
-	del_timer(&timer);
+	aha152x_internal_queue(SCpnt, &done, resetting, reset_done);
+
+	timeleft = wait_for_completion_timeout(&done, 100*HZ);
+	if (!timeleft) {
+		/* remove command from issue queue */
+		DO_LOCK(flags);
+		remove_SC(&ISSUE_SC, SCpnt);
+		DO_UNLOCK(flags);
+	}
 
 	SCpnt->cmd_len         = old_cmd_len;
 	SCpnt->use_sg          = old_use_sg;
