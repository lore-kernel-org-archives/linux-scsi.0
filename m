From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH][REPOST] fc_transport: make all rports wait dev_loss_tmo
	before removing them
Date: Fri, 27 Apr 2007 11:53:17 -0400
Message-ID: <1177689197.26084.3.camel@localhost.localdomain>
References: <1173802009.4861.8.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60299 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948AbXD0Oxb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Apr 2007 10:53:31 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3RErUAQ024877
	for <linux-scsi@vger.kernel.org>; Fri, 27 Apr 2007 07:53:30 -0700 (PDT)
In-Reply-To: <1173802009.4861.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Per the comment in the change - it's not always prudent to immediately
remove the rport upon first notice of a disconnect. Make all rports
wait dev_loss_tmo before being deleted (and each could have a separate
dev_loss_tmo value).

The original post was:
http://marc.info/?l=linux-scsi&m=117392196006703&w=2

The repost contains the following changes:
 - Bug fix in fc_starget_delete(). Dev_loss_tmo_callbk() was called prior to
   tearing down the target. The callback is to be the last thing called, as
   it tells the LLDD that the rport is completely finished and can be torn
   down.  Rework so that terminate_rport_io() is called to terminate the
   outstanding io. Isolated work so it's is simply "starget" work.
 - Fix holes in original patch. There were code paths that did not expect
   the dev_loss_tmo timer to be running for the non-fcp rports.
 - Bug Fix: the transport wasn't protecting against a LLDD calling
   fc_remote_port_delete() back-to-back. Thus, the dev_loss_tmo timer
   could be restarted such that it fires after the rport had been deleted.
   Validate rport state before starting the timer.

-- james s

Signed-off-by: James Smart <James.Smart@emulex.com>



diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2007-03-30 21:14:18.000000000 -0500
+++ b/drivers/scsi/scsi_transport_fc.c	2007-04-19 20:56:21.000000000 -0400
@@ -1718,31 +1718,12 @@ fc_starget_delete(struct work_struct *wo
 	struct fc_rport *rport =
 		container_of(work, struct fc_rport, stgt_delete_work);
 	struct Scsi_Host *shost = rport_to_shost(rport);
-	unsigned long flags;
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 
-	/*
-	 * Involve the LLDD if possible. All io on the rport is to
-	 * be terminated, either as part of the dev_loss_tmo callback
-	 * processing, or via the terminate_rport_io function.
-	 */
-	if (i->f->dev_loss_tmo_callbk)
-		i->f->dev_loss_tmo_callbk(rport);
-	else if (i->f->terminate_rport_io)
+	/* Involve the LLDD if possible to terminate all io on the rport. */
+	if (i->f->terminate_rport_io)
 		i->f->terminate_rport_io(rport);
 
-	spin_lock_irqsave(shost->host_lock, flags);
-	if (rport->flags & FC_RPORT_DEVLOSS_PENDING) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		if (!cancel_delayed_work(&rport->fail_io_work))
-			fc_flush_devloss(shost);
-		if (!cancel_delayed_work(&rport->dev_loss_work))
-			fc_flush_devloss(shost);
-		spin_lock_irqsave(shost->host_lock, flags);
-		rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
-	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
 	scsi_remove_target(&rport->dev);
 }
 
@@ -1760,6 +1741,7 @@ fc_rport_final_delete(struct work_struct
 	struct device *dev = &rport->dev;
 	struct Scsi_Host *shost = rport_to_shost(rport);
 	struct fc_internal *i = to_fc_internal(shost->transportt);
+	unsigned long flags;
 
 	/*
 	 * if a scan is pending, flush the SCSI Host work_q so that 
@@ -1768,13 +1750,37 @@ fc_rport_final_delete(struct work_struct
 	if (rport->flags & FC_RPORT_SCAN_PENDING)
 		scsi_flush_work(shost);
 
+	/* involve the LLDD to terminate all pending i/o */
+	if (i->f->terminate_rport_io)
+		i->f->terminate_rport_io(rport);
+
+	/*
+	 * Cancel any outstanding timers. These should really exist
+	 * only when rmmod'ing the LLDD and we're asking for
+	 * immediate termination of the rports
+	 */
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (rport->flags & FC_RPORT_DEVLOSS_PENDING) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		if (!cancel_delayed_work(&rport->fail_io_work))
+			fc_flush_devloss(shost);
+		if (!cancel_delayed_work(&rport->dev_loss_work))
+			fc_flush_devloss(shost);
+		spin_lock_irqsave(shost->host_lock, flags);
+		rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 	/* Delete SCSI target and sdevs */
 	if (rport->scsi_target_id != -1)
 		fc_starget_delete(&rport->stgt_delete_work);
-	else if (i->f->dev_loss_tmo_callbk)
+
+	/*
+	 * Notify the driver that the rport is now dead. The LLDD will
+	 * also guarantee that any communication to the rport is terminated
+	 */
+	if (i->f->dev_loss_tmo_callbk)
 		i->f->dev_loss_tmo_callbk(rport);
-	else if (i->f->terminate_rport_io)
-		i->f->terminate_rport_io(rport);
 
 	transport_remove_device(dev);
 	device_del(dev);
@@ -1963,8 +1969,6 @@ fc_remote_port_add(struct Scsi_Host *sho
 			}
 
 			if (match) {
-				struct delayed_work *work =
-							&rport->dev_loss_work;
 
 				memcpy(&rport->node_name, &ids->node_name,
 					sizeof(rport->node_name));
@@ -1982,46 +1986,61 @@ fc_remote_port_add(struct Scsi_Host *sho
 						fci->f->dd_fcrport_size);
 
 				/*
-				 * If we were blocked, we were a target.
-				 * If no longer a target, we leave the timer
-				 * running in case the port changes roles
-				 * prior to the timer expiring. If the timer
-				 * fires, the target will be torn down.
+				 * If we were not a target, cancel the
+				 * io terminate and rport timers, and
+				 * we're done.
+				 *
+				 * If we were a target, but our new role
+				 * doesn't indicate a target, leave the
+				 * timers running expecting the role to
+				 * change as the target fully logs in. If
+				 * it doesn't, the target will be torn down.
+				 *
+				 * If we were a target, and our role shows
+				 * we're still a target, cancel the timers
+				 * and kick off a scan.
 				 */
-				if (!(ids->roles & FC_RPORT_ROLE_FCP_TARGET))
-					return rport;
 
-				/* restart the target */
+				/* was a target, not in roles */
+				if ((rport->scsi_target_id != -1) &&
+				    (!(ids->roles & FC_RPORT_ROLE_FCP_TARGET)))
+					return rport;
 
 				/*
-				 * Stop the target timers first. Take no action
-				 * on the del_timer failure as the state
-				 * machine state change will validate the
-				 * transaction.
+				 * Stop the fail io and dev_loss timers.
+				 * If they flush, the port_state will
+				 * be checked and will NOOP the function.
 				 */
 				if (!cancel_delayed_work(&rport->fail_io_work))
 					fc_flush_devloss(shost);
-				if (!cancel_delayed_work(work))
+				if (!cancel_delayed_work(&rport->dev_loss_work))
 					fc_flush_devloss(shost);
 
 				spin_lock_irqsave(shost->host_lock, flags);
 
 				rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
 
-				/* initiate a scan of the target */
-				rport->flags |= FC_RPORT_SCAN_PENDING;
-				scsi_queue_work(shost, &rport->scan_work);
-
-				spin_unlock_irqrestore(shost->host_lock, flags);
-
-				scsi_target_unblock(&rport->dev);
+				/* if target, initiate a scan */
+				if (rport->scsi_target_id != -1) {
+					rport->flags |= FC_RPORT_SCAN_PENDING;
+					scsi_queue_work(shost,
+							&rport->scan_work);
+					spin_unlock_irqrestore(shost->host_lock,
+							flags);
+					scsi_target_unblock(&rport->dev);
+				} else
+					spin_unlock_irqrestore(shost->host_lock,
+							flags);
 
 				return rport;
 			}
 		}
 	}
 
-	/* Search the bindings array */
+	/*
+	 * Search the bindings array
+	 * Note: if never a FCP target, you won't be on this list
+	 */
 	if (fc_host->tgtid_bind_type != FC_TGTID_BIND_NONE) {
 
 		/* search for a matching consistent binding */
@@ -2158,15 +2177,24 @@ fc_remote_port_delete(struct fc_rport  *
 
 	spin_lock_irqsave(shost->host_lock, flags);
 
-	/* If no scsi target id mapping, delete it */
-	if (rport->scsi_target_id == -1) {
-		list_del(&rport->peers);
-		rport->port_state = FC_PORTSTATE_DELETED;
-		fc_queue_work(shost, &rport->rport_delete_work);
+	if (rport->port_state != FC_PORTSTATE_ONLINE) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		return;
 	}
 
+	/*
+	 * In the past, we if this was not an FCP-Target, we would 
+	 * unconditionally just jump to deleting the rport.
+	 * However, rports can be used as node containers by the LLDD,
+	 * and its not appropriate to just terminate the rport at the
+	 * first sign of a loss in connectivity. The LLDD may want to
+	 * send ELS traffic to re-validate the login. If the rport is
+	 * immediately deleted, it makes it inappropriate for a node
+	 * container.
+	 * So... we now unconditionally wait dev_loss_tmo before 
+	 * destroying an rport.
+	 */
+
 	rport->port_state = FC_PORTSTATE_BLOCKED;
 
 	rport->flags |= FC_RPORT_DEVLOSS_PENDING;
@@ -2263,11 +2291,11 @@ fc_remote_port_rolechg(struct fc_rport  
 EXPORT_SYMBOL(fc_remote_port_rolechg);
 
 /**
- * fc_timeout_deleted_rport - Timeout handler for a deleted remote port that
- *                       was a SCSI target (thus was blocked), and failed
- *                       to return in the alloted time.
+ * fc_timeout_deleted_rport - Timeout handler for a deleted remote port,
+ * 			which we blocked, and has now failed to return
+ * 			in the allotted time.
  * 
- * @work:	rport target that failed to reappear in the alloted time.
+ * @work:	rport target that failed to reappear in the allotted time.
  **/
 static void
 fc_timeout_deleted_rport(struct work_struct *work)
@@ -2283,10 +2311,12 @@ fc_timeout_deleted_rport(struct work_str
 	rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
 
 	/*
-	 * If the port is ONLINE, then it came back. Validate it's still an
-	 * FCP target. If not, tear down the scsi_target on it.
+	 * If the port is ONLINE, then it came back. If it was a SCSI
+	 * target, validate it still is. If not, tear down the
+	 * scsi_target on it.
 	 */
 	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
+	    (rport->scsi_target_id != -1) &&
 	    !(rport->roles & FC_RPORT_ROLE_FCP_TARGET)) {
 		dev_printk(KERN_ERR, &rport->dev,
 			"blocked FC remote port time out: no longer"
@@ -2297,18 +2327,24 @@ fc_timeout_deleted_rport(struct work_str
 		return;
 	}
 
+	/* NOOP state - we're flushing workq's */
 	if (rport->port_state != FC_PORTSTATE_BLOCKED) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		dev_printk(KERN_ERR, &rport->dev,
-			"blocked FC remote port time out: leaving target alone\n");
+			"blocked FC remote port time out: leaving"
+			" rport%s alone\n",
+			(rport->scsi_target_id != -1) ?  " and starget" : "");
 		return;
 	}
 
-	if (fc_host->tgtid_bind_type == FC_TGTID_BIND_NONE) {
+	if ((fc_host->tgtid_bind_type == FC_TGTID_BIND_NONE) ||
+	    (rport->scsi_target_id == -1)) {
 		list_del(&rport->peers);
 		rport->port_state = FC_PORTSTATE_DELETED;
 		dev_printk(KERN_ERR, &rport->dev,
-			"blocked FC remote port time out: removing target\n");
+			"blocked FC remote port time out: removing"
+			" rport%s\n",
+			(rport->scsi_target_id != -1) ?  " and starget" : "");
 		fc_queue_work(shost, &rport->rport_delete_work);
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		return;


