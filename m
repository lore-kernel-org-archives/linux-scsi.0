From: michaelc@cs.wisc.edu
Subject: [RFC PATCH 4/7] fc class: don't return from fc_block_scsi_eh until IO has been cleaned up
Date: Thu, 23 Sep 2010 00:17:22 -0500
Message-ID: <1285219045-14645-5-git-send-email-michaelc@cs.wisc.edu>
References: <1285219045-14645-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab0IWFLf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2010 01:11:35 -0400
In-Reply-To: <1285219045-14645-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If a lld does:

        ret = fc_block_scsi_eh(cmnd);
        if (ret)
                return ret;

in the eh callbacks, then it could cause the following race:

1 the LLD will call fc_block_scsi_eh from the scsi eh thread.
2 From the FC class thread, the fast io fail tmo will fire and set
FC_RPORT_FAST_FAIL_TIMEDOUT, then begin to call terminate_rport_io.
3 The scsi eh thread and the LLD will then break from the
fc_block_scsi_eh block and will return FAST_IO_FAIL.
4 The scsi eh will then assume it owns the command and will start to
process it. It will call scsi_eh_flush_done_q which might fail it or
retry it.
5 But then in the FC class thread, the LLD terminate_rport_io callback
could be processing the IO and possibly accessing a scsi_cmnd struct
that the scsi eh thread has now started to retry or failed and
reallocated to a new request in #4.

This patch has fc_block_scsi_eh wait until the terminate_rport_io
callback has completed before returning. This allows LLDs to not
have to worry about the race.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_fc.c |   54 ++++++++++++++++++++++++++++---------
 include/scsi/scsi_transport_fc.h |    1 +
 2 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index a15e815..93a8edc 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1575,6 +1575,7 @@ store_fc_private_host_tgtid_bind_type(struct device *dev,
 				&fc_host_rport_bindings(shost), peers);
 			list_del(&rport->peers);
 			rport->port_state = FC_PORTSTATE_DELETED;
+			rport->flags |= FC_RPORT_TERMINATING_RPORT;
 			fc_queue_work(shost, &rport->rport_delete_work);
 		}
 		spin_unlock_irqrestore(shost->host_lock, flags);
@@ -2316,6 +2317,7 @@ fc_remove_host(struct Scsi_Host *shost)
 			&fc_host->rports, peers) {
 		list_del(&rport->peers);
 		rport->port_state = FC_PORTSTATE_DELETED;
+		rport->flags |= FC_RPORT_TERMINATING_RPORT;
 		fc_queue_work(shost, &rport->rport_delete_work);
 	}
 
@@ -2323,6 +2325,7 @@ fc_remove_host(struct Scsi_Host *shost)
 			&fc_host->rport_bindings, peers) {
 		list_del(&rport->peers);
 		rport->port_state = FC_PORTSTATE_DELETED;
+		rport->flags |= FC_RPORT_TERMINATING_RPORT;
 		fc_queue_work(shost, &rport->rport_delete_work);
 	}
 
@@ -2351,11 +2354,20 @@ static void fc_terminate_rport_io(struct fc_rport *rport)
 {
 	struct Scsi_Host *shost = rport_to_shost(rport);
 	struct fc_internal *i = to_fc_internal(shost->transportt);
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	rport->flags |= FC_RPORT_TERMINATING_RPORT;
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	/* Involve the LLDD if possible to terminate all io on the rport. */
 	if (i->f->terminate_rport_io)
 		i->f->terminate_rport_io(rport);
 
+	spin_lock_irqsave(shost->host_lock, flags);
+	rport->flags &= ~FC_RPORT_TERMINATING_RPORT;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 	/*
 	 * must unblock to flush queued IO. The caller will have set
 	 * the port_state or flags, so that fc_remote_port_chkready will
@@ -2696,7 +2708,8 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 
 				rport->flags &= ~(FC_RPORT_FAST_FAIL_TIMEDOUT |
 						  FC_RPORT_DEVLOSS_PENDING |
-						  FC_RPORT_DEVLOSS_CALLBK_DONE);
+						  FC_RPORT_DEVLOSS_CALLBK_DONE |
+						  FC_RPORT_TERMINATING_RPORT);
 
 				/* if target, initiate a scan */
 				if (rport->scsi_target_id != -1) {
@@ -2773,8 +2786,8 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 				sizeof(rport->port_name));
 			rport->port_id = ids->port_id;
 			rport->roles = ids->roles;
-			rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
-
+			rport->flags &= ~(FC_RPORT_FAST_FAIL_TIMEDOUT |
+					  FC_RPORT_TERMINATING_RPORT);
 			if (fci->f->dd_fcrport_size)
 				memset(rport->dd_data, 0,
 						fci->f->dd_fcrport_size);
@@ -2975,7 +2988,8 @@ fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles)
 
 		spin_lock_irqsave(shost->host_lock, flags);
 		rport->flags &= ~(FC_RPORT_FAST_FAIL_TIMEDOUT |
-				  FC_RPORT_DEVLOSS_PENDING);
+				  FC_RPORT_DEVLOSS_PENDING |
+				  FC_RPORT_TERMINATING_RPORT);
 		spin_unlock_irqrestore(shost->host_lock, flags);
 
 		/* initiate a scan of the target */
@@ -3041,6 +3055,7 @@ fc_timeout_deleted_rport(struct work_struct *work)
 	    (rport->scsi_target_id == -1)) {
 		list_del(&rport->peers);
 		rport->port_state = FC_PORTSTATE_DELETED;
+		rport->flags |= FC_RPORT_TERMINATING_RPORT;
 		dev_printk(KERN_ERR, &rport->dev,
 			"blocked FC remote port time out: removing"
 			" rport%s\n",
@@ -3070,6 +3085,12 @@ fc_timeout_deleted_rport(struct work_struct *work)
 	rport->roles = FC_PORT_ROLE_UNKNOWN;
 	rport->port_state = FC_PORTSTATE_NOTPRESENT;
 	rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
+	/*
+	 * We changed the port_state and are going to drop the lock, so
+	 * we set this now because we want fc_block_scsi_eh to stay blocked
+	 * until terminate_rport_io has completed.
+	 */
+	rport->flags |= FC_RPORT_TERMINATING_RPORT;
 
 	/*
 	 * Pre-emptively kill I/O rather than waiting for the work queue
@@ -3137,12 +3158,17 @@ fc_timeout_fail_rport_io(struct work_struct *work)
 {
 	struct fc_rport *rport =
 		container_of(work, struct fc_rport, fail_io_work.work);
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	unsigned long flags;
 
 	if (rport->port_state != FC_PORTSTATE_BLOCKED)
 		return;
 
-	rport->flags |= FC_RPORT_FAST_FAIL_TIMEDOUT;
 	fc_terminate_rport_io(rport);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	rport->flags |= FC_RPORT_FAST_FAIL_TIMEDOUT;
+	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
 /**
@@ -3176,9 +3202,10 @@ fc_scsi_scan_rport(struct work_struct *work)
  *
  * This routine can be called from a FC LLD scsi_eh callback. It
  * blocks the scsi_eh thread until the fc_rport leaves the
- * FC_PORTSTATE_BLOCKED, or the fast_io_fail_tmo fires. This is
- * necessary to avoid the scsi_eh failing recovery actions for blocked
- * rports which would lead to offlined SCSI devices.
+ * FC_PORTSTATE_BLOCKED, or the fast_io_fail_tmo fires and the IO
+ * on the rport has been terminated with the terminate_port_io callback.
+ * This is necessary to avoid the scsi_eh failing recovery actions for
+ * blocked rports which would lead to offlined SCSI devices.
  *
  * Returns: 0 if the fc_rport left the state FC_PORTSTATE_BLOCKED.
  *	    TRANSPORT_FAILED if the fast_io_fail_tmo fired, this should be
@@ -3191,18 +3218,19 @@ int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	while (rport->port_state == FC_PORTSTATE_BLOCKED &&
-	       !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)) {
+	while ((rport->port_state == FC_PORTSTATE_BLOCKED &&
+	       !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)) ||
+	       rport->flags & FC_RPORT_TERMINATING_RPORT) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		msleep(1000);
 		spin_lock_irqsave(shost->host_lock, flags);
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
-		return TRANSPORT_FAILED;
+	if (rport->port_state == FC_PORTSTATE_ONLINE)
+		return 0;
 
-	return 0;
+	return TRANSPORT_FAILED;
 }
 EXPORT_SYMBOL(fc_block_scsi_eh);
 
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 9f98fca..f392570 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -359,6 +359,7 @@ struct fc_rport {	/* aka fc_starget_attrs */
 #define FC_RPORT_SCAN_PENDING		0x02
 #define FC_RPORT_FAST_FAIL_TIMEDOUT	0x04
 #define FC_RPORT_DEVLOSS_CALLBK_DONE	0x08
+#define FC_RPORT_TERMINATING_RPORT	0x10
 
 #define	dev_to_rport(d)				\
 	container_of(d, struct fc_rport, dev)
-- 
1.7.2.2

