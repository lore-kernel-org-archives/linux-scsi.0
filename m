From: michaelc@cs.wisc.edu
Subject: [RFC PATCH 1/7] fc class: fix rport re-add dev_loss handling race
Date: Thu, 23 Sep 2010 00:17:19 -0500
Message-ID: <1285219045-14645-2-git-send-email-michaelc@cs.wisc.edu>
References: <1285219045-14645-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab0IWFLj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2010 01:11:39 -0400
In-Reply-To: <1285219045-14645-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

fc_remote_port_add calls fc_flush_work before matching and
readding a rport, but there is nothing that stops the class
from queueing a deletion right after the fc_flush_work call and
before we grab the host_lock. To fix this this adds a cancel_work_sync
call for the stgt_delete_work when we have the rport partially
resetup.

There is also a problem where fc_timeout_deleted_rport can
begin the rport timeout handling and move the rport to the
rport_bindings list. Then when fc_timeout_deleted_rport drops
the host_lock to call fc_terminate_rport_io or dev_loss_tmo_callbk,
fc_remote_port_add will grab the lock, see the rport is on the
rport_bindings list and then add the rport back while
fc_timeout_deleted_rport is still running fc_terminate_rport_io
or dev_loss_tmo_callbk. This patch also fixes this by adding
cancel_delayed_work_sync calls for the dev_loss_work work in
this code path.

Note: this patch replaces the cancel_delayed_work/fc_flush_devloss
calls with cancel_delayed_work_sync. I think this should
be more efficient, because we do not have to wait for all
work to complete (just have to wait for the work and anything
queued before it).

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_fc.c |   66 ++++++++++++++++++--------------------
 1 files changed, 31 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 78486d5..d43f69a 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2300,25 +2300,6 @@ fc_queue_devloss_work(struct Scsi_Host *shost, struct delayed_work *work,
 }
 
 /**
- * fc_flush_devloss - Flush a fc_host's devloss workqueue.
- * @shost:	Pointer to Scsi_Host bound to fc_host.
- */
-static void
-fc_flush_devloss(struct Scsi_Host *shost)
-{
-	if (!fc_host_devloss_work_q(shost)) {
-		printk(KERN_ERR
-			"ERROR: FC host '%s' attempted to flush work, "
-			"when no workqueue created.\n", shost->hostt->name);
-		dump_stack();
-		return;
-	}
-
-	flush_workqueue(fc_host_devloss_work_q(shost));
-}
-
-
-/**
  * fc_remove_host - called to terminate any fc_transport-related elements for a scsi host.
  * @shost:	Which &Scsi_Host
  *
@@ -2417,6 +2398,19 @@ fc_starget_delete(struct work_struct *work)
 	scsi_remove_target(&rport->dev);
 }
 
+/**
+ * fc_cancel_remote_port_delete - cancel rport deletion related work
+ * @rport: rport to sync up
+ *
+ * This does not cancel rport_delete_work, because if that is queued
+ * the rport will have been destroyed when the sync completes.
+ */
+static void fc_cancel_remote_port_delete(struct fc_rport *rport)
+{
+	cancel_delayed_work_sync(&rport->fail_io_work);
+	cancel_delayed_work_sync(&rport->dev_loss_work);
+	cancel_work_sync(&rport->stgt_delete_work);
+}
 
 /**
  * fc_rport_final_delete - finish rport termination and delete it.
@@ -2450,10 +2444,9 @@ fc_rport_final_delete(struct work_struct *work)
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (rport->flags & FC_RPORT_DEVLOSS_PENDING) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
-		if (!cancel_delayed_work(&rport->fail_io_work))
-			fc_flush_devloss(shost);
-		if (!cancel_delayed_work(&rport->dev_loss_work))
-			fc_flush_devloss(shost);
+
+		fc_cancel_remote_port_delete(rport);
+
 		spin_lock_irqsave(shost->host_lock, flags);
 		rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
 	}
@@ -2718,10 +2711,7 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 				 * If they flush, the port_state will
 				 * be checked and will NOOP the function.
 				 */
-				if (!cancel_delayed_work(&rport->fail_io_work))
-					fc_flush_devloss(shost);
-				if (!cancel_delayed_work(&rport->dev_loss_work))
-					fc_flush_devloss(shost);
+				fc_cancel_remote_port_delete(rport);
 
 				spin_lock_irqsave(shost->host_lock, flags);
 
@@ -2785,13 +2775,25 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 		}
 
 		if (match) {
+			rport->port_state = FC_PORTSTATE_ONLINE;
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			/*
+			 * A stgt delete could be queued after the
+			 * flush call, or a fc_timeout_deleted_rport
+			 * could be in a fc_terminate_rport_io or
+			 * dev_loss_tmo_callbk call so we must
+			 * cancel all work for the rport before
+			 * proceeding.
+			 */
+			fc_cancel_remote_port_delete(rport);
+
+			spin_lock_irqsave(shost->host_lock, flags);
 			memcpy(&rport->node_name, &ids->node_name,
 				sizeof(rport->node_name));
 			memcpy(&rport->port_name, &ids->port_name,
 				sizeof(rport->port_name));
 			rport->port_id = ids->port_id;
 			rport->roles = ids->roles;
-			rport->port_state = FC_PORTSTATE_ONLINE;
 			rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
 
 			if (fci->f->dd_fcrport_size)
@@ -2990,19 +2992,13 @@ fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles)
 		 * machine state change will validate the
 		 * transaction.
 		 */
-		if (!cancel_delayed_work(&rport->fail_io_work))
-			fc_flush_devloss(shost);
-		if (!cancel_delayed_work(&rport->dev_loss_work))
-			fc_flush_devloss(shost);
+		fc_cancel_remote_port_delete(rport);
 
 		spin_lock_irqsave(shost->host_lock, flags);
 		rport->flags &= ~(FC_RPORT_FAST_FAIL_TIMEDOUT |
 				  FC_RPORT_DEVLOSS_PENDING);
 		spin_unlock_irqrestore(shost->host_lock, flags);
 
-		/* ensure any stgt delete functions are done */
-		fc_flush_work(shost);
-
 		/* initiate a scan of the target */
 		spin_lock_irqsave(shost->host_lock, flags);
 		rport->flags |= FC_RPORT_SCAN_PENDING;
-- 
1.7.2.2

