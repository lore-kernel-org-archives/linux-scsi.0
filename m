From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 36/78] ncr5380: Use work_struct instead of delayed_work
Date: Sun, 03 Jan 2016 16:05:37 +1100
Message-ID: <20160103050510.561799136@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49438 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbcACFSR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jan 2016 00:18:17 -0500
Content-Disposition: inline; filename=ncr5380-work_struct-instead
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Each host instance now has it's own work queue so the main() work item can
sleep when necessary. That means we can use a simple work item rather than
a delayed work item. This brings NCR5380.c closer to atari_NCR5380.c.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>

---
 drivers/scsi/NCR5380.c |   12 +++++-------
 drivers/scsi/NCR5380.h |    1 -
 2 files changed, 5 insertions(+), 8 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:03:46.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:03:47.000000000 +1100
@@ -697,7 +697,7 @@ static int NCR5380_init(struct Scsi_Host
 	hostdata->issue_queue = NULL;
 	hostdata->disconnected_queue = NULL;
 	
-	INIT_DELAYED_WORK(&hostdata->coroutine, NCR5380_main);
+	INIT_WORK(&hostdata->main_task, NCR5380_main);
 	hostdata->work_q = alloc_workqueue("ncr5380_%d",
 	                        WQ_UNBOUND | WQ_MEM_RECLAIM,
 	                        1, instance->host_no);
@@ -797,7 +797,7 @@ static void NCR5380_exit(struct Scsi_Hos
 {
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 
-	cancel_delayed_work_sync(&hostdata->coroutine);
+	cancel_work_sync(&hostdata->main_task);
 	destroy_workqueue(hostdata->work_q);
 }
 
@@ -859,9 +859,8 @@ static int NCR5380_queue_command(struct
 
 	dprintk(NDEBUG_QUEUES, "scsi%d : command added to %s of queue\n", instance->host_no, (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail");
 
-	/* Run the coroutine if it isn't already running. */
 	/* Kick off command processing */
-	queue_delayed_work(hostdata->work_q, &hostdata->coroutine, 0);
+	queue_work(hostdata->work_q, &hostdata->main_task);
 	return 0;
 }
 
@@ -880,7 +879,7 @@ static int NCR5380_queue_command(struct
 static void NCR5380_main(struct work_struct *work)
 {
 	struct NCR5380_hostdata *hostdata =
-		container_of(work, struct NCR5380_hostdata, coroutine.work);
+		container_of(work, struct NCR5380_hostdata, main_task);
 	struct Scsi_Host *instance = hostdata->host;
 	struct scsi_cmnd *tmp, *prev;
 	int done;
@@ -1037,8 +1036,7 @@ static irqreturn_t NCR5380_intr(int dumm
 		}	/* if BASR_IRQ */
 		spin_unlock_irqrestore(instance->host_lock, flags);
 		if(!done)
-			queue_delayed_work(hostdata->work_q,
-			                   &hostdata->coroutine, 0);
+			queue_work(hostdata->work_q, &hostdata->main_task);
 	} while (!done);
 	return IRQ_HANDLED;
 }
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2016-01-03 16:03:33.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2016-01-03 16:03:47.000000000 +1100
@@ -256,7 +256,6 @@ struct NCR5380_hostdata {
 	volatile struct scsi_cmnd *issue_queue;	/* waiting to be issued */
 	volatile struct scsi_cmnd *disconnected_queue;	/* waiting for reconnect */
 	int flags;
-	struct delayed_work coroutine;		/* our co-routine */
 	struct scsi_eh_save ses;
 	char info[256];
 	int read_overruns;                /* number of bytes to cut from a


