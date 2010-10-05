From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [PATCH v2] scsi: Remove QUEUE_FLAG_REENTER from SCSI code
Date: Tue, 5 Oct 2010 11:00:44 +0200
Message-ID: <20101005090043.GA18744@schmichrtp.mainz.de.ibm.com>
References: <Pine.LNX.4.64.1008281908150.13508@ask.diku.dk>
 <20100902105326.GA4097@schmichrtp.mainz.de.ibm.com>
 <4C7FA91B.60607@suse.de>
 <20100902142835.GA4992@schmichrtp.mainz.de.ibm.com>
 <20100902150158.GA10556@schmichrtp.mainz.de.ibm.com>
 <1285574293.2888.107.camel@mulgrave.site>
 <20101004134700.GA12628@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:51477 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab0JEJAv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2010 05:00:51 -0400
Received: from d06nrmr1707.portsmouth.uk.ibm.com (d06nrmr1707.portsmouth.uk.ibm.com [9.149.39.225])
	by mtagate1.uk.ibm.com (8.13.1/8.13.1) with ESMTP id o9590kRD018401
	for <linux-scsi@vger.kernel.org>; Tue, 5 Oct 2010 09:00:46 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1707.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o9590kRp2338890
	for <linux-scsi@vger.kernel.org>; Tue, 5 Oct 2010 10:00:46 +0100
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o9590jHa010839
	for <linux-scsi@vger.kernel.org>; Tue, 5 Oct 2010 10:00:46 +0100
Content-Disposition: inline
In-Reply-To: <20101004134700.GA12628@schmichrtp.mainz.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Hannes Reinecke <hare@suse.de>, Julia Lawall <julia@diku.dk>, linux-scsi@vger.kernel.org, joe@perches.com, James Smart <James.Smart@Emulex.Com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

fc_bsg_goose_queue is only called from fc_remote_port_add which
already requires to be run from thread context. For this case simply
replace fc_bsg_goose_queue with a call to blk_run_queue.

The code in scsi_run_queue needs a mechanism to avoid recursing
through
scsi_run_queue->blk_run_queue->scsi_request_fn->scsi_dispatch_cmd
->scsi_queue_insert->scsi_run_queue for each entry in the
starved_list. Instead of using QUEUE_FLAG_PLUGGED, always defer
running the queue for starved devices to the block layer workqueue.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/scsi/scsi_lib.c          |   17 +++--------------
 drivers/scsi/scsi_transport_fc.c |   34 ++--------------------------------
 2 files changed, 5 insertions(+), 46 deletions(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -411,8 +411,6 @@ static void scsi_run_queue(struct reques
 	list_splice_init(&shost->starved_list, &starved_list);
 
 	while (!list_empty(&starved_list)) {
-		int flagset;
-
 		/*
 		 * As long as shost is accepting commands and we have
 		 * starved queues, call blk_run_queue. scsi_request_fn
@@ -435,20 +433,11 @@ static void scsi_run_queue(struct reques
 			continue;
 		}
 
-		spin_unlock(shost->host_lock);
-
 		spin_lock(sdev->request_queue->queue_lock);
-		flagset = test_bit(QUEUE_FLAG_REENTER, &q->queue_flags) &&
-				!test_bit(QUEUE_FLAG_REENTER,
-					&sdev->request_queue->queue_flags);
-		if (flagset)
-			queue_flag_set(QUEUE_FLAG_REENTER, sdev->request_queue);
-		__blk_run_queue(sdev->request_queue);
-		if (flagset)
-			queue_flag_clear(QUEUE_FLAG_REENTER, sdev->request_queue);
+		queue_flag_set(QUEUE_FLAG_PLUGGED, sdev->request_queue);
+		kblockd_schedule_work(sdev->request_queue,
+				      &sdev->request_queue->unplug_work);
 		spin_unlock(sdev->request_queue->queue_lock);
-
-		spin_lock(shost->host_lock);
 	}
 	/* put any unprocessed entries back */
 	list_splice(&starved_list, &shost->starved_list);
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -50,7 +50,6 @@ static int fc_vport_setup(struct Scsi_Ho
 static int fc_bsg_hostadd(struct Scsi_Host *, struct fc_host_attrs *);
 static int fc_bsg_rportadd(struct Scsi_Host *, struct fc_rport *);
 static void fc_bsg_remove(struct request_queue *);
-static void fc_bsg_goose_queue(struct fc_rport *);
 
 /*
  * Redefine so that we can have same named attributes in the
@@ -2737,7 +2736,8 @@ fc_remote_port_add(struct Scsi_Host *sho
 					spin_unlock_irqrestore(shost->host_lock,
 							flags);
 
-				fc_bsg_goose_queue(rport);
+				if (rport->rqst_q)
+					blk_run_queue(rport->rqst_q);
 
 				return rport;
 			}
@@ -3752,36 +3752,6 @@ fail_host_msg:
 	return FC_DISPATCH_UNLOCKED;
 }
 
-
-/*
- * fc_bsg_goose_queue - restart rport queue in case it was stopped
- * @rport:	rport to be restarted
- */
-static void
-fc_bsg_goose_queue(struct fc_rport *rport)
-{
-	int flagset;
-	unsigned long flags;
-
-	if (!rport->rqst_q)
-		return;
-
-	get_device(&rport->dev);
-
-	spin_lock_irqsave(rport->rqst_q->queue_lock, flags);
-	flagset = test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags) &&
-		  !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
-	if (flagset)
-		queue_flag_set(QUEUE_FLAG_REENTER, rport->rqst_q);
-	__blk_run_queue(rport->rqst_q);
-	if (flagset)
-		queue_flag_clear(QUEUE_FLAG_REENTER, rport->rqst_q);
-	spin_unlock_irqrestore(rport->rqst_q->queue_lock, flags);
-
-	put_device(&rport->dev);
-}
-
-
 /**
  * fc_bsg_rport_dispatch - process rport bsg requests and dispatch to LLDD
  * @q:		rport request queue
