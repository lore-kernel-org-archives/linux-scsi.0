From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [patch] 5/5 scsi-locking-2.5 remove extra sdev2, remove extra logging
Date: Wed, 9 Apr 2003 16:48:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030409164820.E23701@beaverton.ibm.com>
References: <20030409164612.A23701@beaverton.ibm.com> <20030409164701.B23701@beaverton.ibm.com> <20030409164733.C23701@beaverton.ibm.com> <20030409164756.D23701@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:37867 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S263947AbTDIXk0 (for <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Apr 2003 19:40:26 -0400
Content-Disposition: inline
In-Reply-To: <20030409164756.D23701@beaverton.ibm.com>; from patmans@us.ibm.com on Wed, Apr 09, 2003 at 04:47:56PM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Remove unneeded sdev2 variable. 

Remove extra log message.

diff -purN -X /home/patman/dontdiff 04_scan_changes/drivers/scsi/scsi_lib.c 05_cleanup/drivers/scsi/scsi_lib.c
--- 04_scan_changes/drivers/scsi/scsi_lib.c	Wed Apr  9 12:39:22 2003
+++ 05_cleanup/drivers/scsi/scsi_lib.c	Wed Apr  9 12:39:32 2003
@@ -411,7 +411,7 @@ static void scsi_single_lun_run(struct s
  */
 void scsi_queue_next_request(request_queue_t *q, struct scsi_cmnd *cmd)
 {
-	struct scsi_device *sdev, *sdev2;
+	struct scsi_device *sdev;
 	struct Scsi_Host *shost;
 	unsigned long flags;
 
@@ -460,14 +460,14 @@ void scsi_queue_next_request(request_que
 		 * scsi_request_fn must get the host_lock before checking
 		 * or modifying starved_list or starved_entry.
 		 */
-		sdev2 = list_entry(shost->starved_list.next,
+		sdev = list_entry(shost->starved_list.next,
 					  struct scsi_device, starved_entry);
-		list_del_init(&sdev2->starved_entry);
+		list_del_init(&sdev->starved_entry);
 		spin_unlock_irqrestore(shost->host_lock, flags);
 
-		spin_lock_irqsave(sdev2->request_queue->queue_lock, flags);
-		__blk_run_queue(sdev2->request_queue);
-		spin_unlock_irqrestore(sdev2->request_queue->queue_lock, flags);
+		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+		__blk_run_queue(sdev->request_queue);
+		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
 		spin_lock_irqsave(shost->host_lock, flags);
 		if (unlikely(!list_empty(&sdev->starved_entry)))
@@ -1123,15 +1123,7 @@ static inline int scsi_host_queue_ready(
 		return 0;
 	if ((shost->can_queue > 0 && shost->host_busy >= shost->can_queue) ||
 	    shost->host_blocked || shost->host_self_blocked) {
-		SCSI_LOG_MLQUEUE(3,
-			printk("add starved dev <%d,%d,%d,%d>; host "
-			       "limit %d, busy %d, blocked %d selfblocked %d\n",
-			       sdev->host->host_no, sdev->channel,
-			       sdev->id, sdev->lun,
-			       shost->can_queue, shost->host_busy,
-			       shost->host_blocked, shost->host_self_blocked));
-		list_add_tail(&sdev->starved_entry,
-			      &shost->starved_list);
+		list_add_tail(&sdev->starved_entry, &shost->starved_list);
 		return 0;
 	}
 
