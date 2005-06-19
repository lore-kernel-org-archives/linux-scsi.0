From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove scsi_cmnd->state
Date: Sun, 19 Jun 2005 13:42:05 +0200
Message-ID: <20050619114205.GE18801@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:12972 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262249AbVFSLmI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 07:42:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

We never look at it except for the old megaraid driver that abuses it
for sending internal commands.  That usage can be fixed easily because
thos internal commands are single-threaded by a mutex and we can easily
use a completion there.


Index: linux-2.6/drivers/scsi/megaraid.c
===================================================================
--- linux-2.6.orig/drivers/scsi/megaraid.c	2005-06-19 12:27:27.000000000 +0200
+++ linux-2.6/drivers/scsi/megaraid.c	2005-06-19 12:29:53.000000000 +0200
@@ -35,6 +35,7 @@
 #include <linux/blkdev.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
+#include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/proc_fs.h>
 #include <linux/reboot.h>
@@ -4490,8 +4491,6 @@
 
 	scb->idx = CMDID_INT_CMDS;
 
-	scmd->state = 0;
-
 	/*
 	 * Get the lock only if the caller has not acquired it already
 	 */
@@ -4501,15 +4500,7 @@
 
 	if( ls == LOCK_INT ) spin_unlock_irqrestore(&adapter->lock, flags);
 
-	/*
-	 * Wait till this command finishes. Do not use
-	 * wait_event_interruptible(). It causes panic if CTRL-C is hit when
-	 * dumping e.g., physical disk information through /proc interface.
-	 */
-#if 0
-	wait_event_interruptible(adapter->int_waitq, scmd->state);
-#endif
-	wait_event(adapter->int_waitq, scmd->state);
+	wait_for_completion(&adapter->int_waitq);
 
 	rval = scmd->result;
 	mc->status = scmd->result;
@@ -4543,16 +4534,7 @@
 
 	adapter = (adapter_t *)scmd->device->host->hostdata;
 
-	scmd->state = 1; /* thread waiting for its command to complete */
-
-	/*
-	 * See comment in mega_internal_command() routine for
-	 * wait_event_interruptible()
-	 */
-#if 0
-	wake_up_interruptible(&adapter->int_waitq);
-#endif
-	wake_up(&adapter->int_waitq);
+	complete(&adapter->int_waitq);
 
 }
 
@@ -4874,7 +4856,7 @@
 	}
 		
 	init_MUTEX(&adapter->int_mtx);
-	init_waitqueue_head(&adapter->int_waitq);
+	init_completion(&adapter->int_waitq);
 
 	adapter->this_id = DEFAULT_INITIATOR_ID;
 	adapter->host->this_id = DEFAULT_INITIATOR_ID;
Index: linux-2.6/drivers/scsi/megaraid.h
===================================================================
--- linux-2.6.orig/drivers/scsi/megaraid.h	2005-06-19 12:27:27.000000000 +0200
+++ linux-2.6/drivers/scsi/megaraid.h	2005-06-19 12:28:08.000000000 +0200
@@ -891,7 +891,7 @@
 	Scsi_Cmnd		int_scmd;
 	struct semaphore	int_mtx;	/* To synchronize the internal
 						commands */
-	wait_queue_head_t	int_waitq;	/* wait queue for internal
+	struct completion	int_waitq;	/* wait queue for internal
 						 cmds */
 
 	int	has_cluster;	/* cluster support on this HBA */
Index: linux-2.6/drivers/scsi/scsi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi.c	2005-06-19 12:28:07.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi.c	2005-06-19 12:28:08.000000000 +0200
@@ -257,7 +257,6 @@
 
 		memset(cmd, 0, sizeof(*cmd));
 		cmd->device = dev;
-		cmd->state = SCSI_STATE_UNUSED;
 		init_timer(&cmd->eh_timeout);
 		INIT_LIST_HEAD(&cmd->list);
 		spin_lock_irqsave(&dev->list_lock, flags);
@@ -607,9 +606,6 @@
 	 * We will use a queued command if possible, otherwise we will
 	 * emulate the queuing and calling of completion function ourselves.
 	 */
-
-	cmd->state = SCSI_STATE_QUEUED;
-
 	atomic_inc(&cmd->device->iorequest_cnt);
 
 	/*
@@ -762,7 +758,6 @@
 	 * Set the serial numbers back to zero
 	 */
 	cmd->serial_number = 0;
-	cmd->state = SCSI_STATE_BHQUEUE;
 
 	atomic_inc(&cmd->device->iodone_cnt);
 	if (cmd->result)
@@ -883,8 +878,6 @@
 	SCSI_LOG_MLCOMPLETE(4, printk("Notifying upper driver of completion "
 				"for device %d %x\n", sdev->id, cmd->result));
 
-	cmd->state = SCSI_STATE_FINISHED;
-
 	/*
 	 * We can get here with use_sg=0, causing a panic in the upper level
 	 */
Index: linux-2.6/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_error.c	2005-06-19 12:28:07.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi_error.c	2005-06-19 12:29:22.000000000 +0200
@@ -74,10 +74,6 @@
 	spin_lock_irqsave(shost->host_lock, flags);
 
 	scsi_eh_eflags_set(scmd, eh_flag);
-	/*
-	 * FIXME: Can we stop setting owner and state.
-	 */
-	scmd->state = SCSI_STATE_FAILED;
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
 	set_bit(SHOST_RECOVERY, &shost->shost_state);
 	shost->host_failed++;
@@ -634,8 +630,6 @@
 			       struct list_head *done_q)
 {
 	scmd->device->host->host_failed--;
-	scmd->state = SCSI_STATE_BHQUEUE;
-
 	scsi_eh_eflags_clr_all(scmd);
 
 	/*
@@ -1803,7 +1797,6 @@
 	scmd->request = &req;
 	memset(&scmd->eh_timeout, 0, sizeof(scmd->eh_timeout));
 	scmd->request->rq_status      	= RQ_SCSI_BUSY;
-	scmd->state                   	= SCSI_STATE_INITIALIZING;
 
 	memset(&scmd->cmnd, '\0', sizeof(scmd->cmnd));
     
Index: linux-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_lib.c	2005-06-19 12:28:07.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi_lib.c	2005-06-19 12:28:08.000000000 +0200
@@ -146,11 +146,6 @@
 		device->device_blocked = device->max_device_blocked;
 
 	/*
-	 * Register the fact that we own the thing for now.
-	 */
-	cmd->state = SCSI_STATE_MLQUEUE;
-
-	/*
 	 * Decrement the counters, since these commands are no longer
 	 * active on the host/device.
 	 */
Index: linux-2.6/include/scsi/scsi_cmnd.h
===================================================================
--- linux-2.6.orig/include/scsi/scsi_cmnd.h	2005-06-19 12:28:07.000000000 +0200
+++ linux-2.6/include/scsi/scsi_cmnd.h	2005-06-19 12:28:08.000000000 +0200
@@ -31,7 +31,6 @@
 	int     sc_magic;
 
 	struct scsi_device *device;
-	unsigned short state;
 	struct scsi_request *sc_request;
 
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
