From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [PATCH] scsi: Remove QUEUE_FLAG_REENTER from SCSI code
Date: Thu, 2 Sep 2010 17:01:58 +0200
Message-ID: <20100902150158.GA10556@schmichrtp.mainz.de.ibm.com>
References: <Pine.LNX.4.64.1008281908150.13508@ask.diku.dk>
 <20100902105326.GA4097@schmichrtp.mainz.de.ibm.com>
 <4C7FA91B.60607@suse.de>
 <20100902142835.GA4992@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:58815 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab0IBPCG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2010 11:02:06 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.1/8.13.1) with ESMTP id o82F1xp4025463
	for <linux-scsi@vger.kernel.org>; Thu, 2 Sep 2010 15:01:59 GMT
Received: from d12av03.megacenter.de.ibm.com (d12av03.megacenter.de.ibm.com [9.149.165.213])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o82F1x6L4063300
	for <linux-scsi@vger.kernel.org>; Thu, 2 Sep 2010 17:01:59 +0200
Received: from d12av03.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av03.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o82F1w6X026157
	for <linux-scsi@vger.kernel.org>; Thu, 2 Sep 2010 17:01:59 +0200
Content-Disposition: inline
In-Reply-To: <20100902142835.GA4992@schmichrtp.mainz.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Julia Lawall <julia@diku.dk>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, joe@perches.com, James Smart <James.Smart@Emulex.Com>

scsi_run_queue and fc_bsg_goose_queue try to call __blk_run_queue with
the flag QUEUE_FLAG_REENTER set. Since __blk_run_queue already sets
the flag internally, this part can be removed from the SCSI and FC
transport code. With this change, the function fc_bsg_goose_queue can
simply be replaced with a conditional call to blk_run_queue.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/scsi/scsi_lib.c          |   15 +--------------
 drivers/scsi/scsi_transport_fc.c |   34 ++--------------------------------
 2 files changed, 3 insertions(+), 46 deletions(-)

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
@@ -436,18 +434,7 @@ static void scsi_run_queue(struct reques
 		}
 
 		spin_unlock(shost->host_lock);
-
-		spin_lock(sdev->request_queue->queue_lock);
-		flagset = test_bit(QUEUE_FLAG_REENTER, &q->queue_flags) &&
-				!test_bit(QUEUE_FLAG_REENTER,
-					&sdev->request_queue->queue_flags);
-		if (flagset)
-			queue_flag_set(QUEUE_FLAG_REENTER, sdev->request_queue);
-		__blk_run_queue(sdev->request_queue);
-		if (flagset)
-			queue_flag_clear(QUEUE_FLAG_REENTER, sdev->request_queue);
-		spin_unlock(sdev->request_queue->queue_lock);
-
+		blk_run_queue(sdev->request_queue);
 		spin_lock(shost->host_lock);
 	}
 	/* put any unprocessed entries back */
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
