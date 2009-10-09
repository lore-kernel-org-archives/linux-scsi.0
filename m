From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 1/1] remove invalid BUG_ON in scsi_transport_fc.c
Date: Fri, 09 Oct 2009 14:15:59 -0500
Message-ID: <4ACF8BEF.6040105@sgi.com>
References: <4AB3D773.50108@sgi.com> <4AB3DB7C.2050004@emulex.com> <4AB3DE99.3080602@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:57679 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752880AbZJITQl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Oct 2009 15:16:41 -0400
In-Reply-To: <4AB3DE99.3080602@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Smart <James.Smart@Emulex.Com>

I was doing some large lun count testing with 2.6.31 and hit
a BUG_ON() in fc_timeout_deleted_rport(), and it seems like it
should have been just a matter of time before someone did.

It seems invalid to set port_state under lock, then expect it to
remain set after releasing the lock.  Another thread called
fc_remote_port_add() when the lock was released, changing the
port_state.

This patch removes the BUG_ON and moves the test of the
port_state to inside the host_lock.  It's been running for
several weeks now with no ill effect.

Applies to 2.6.31 and 2.6.32-rc3.

Signed-off-by: Michael Reed <mdr@sgi.com>


--- a/drivers/scsi/scsi_transport_fc.c	2009-09-09 17:13:59.000000000 -0500
+++ b/drivers/scsi/scsi_transport_fc.c	2009-10-02 15:09:00.298487474 -0500
@@ -2384,6 +2384,7 @@ fc_rport_final_delete(struct work_struct
 	struct Scsi_Host *shost = rport_to_shost(rport);
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	unsigned long flags;
+	int do_callback = 0;
 
 	/*
 	 * if a scan is pending, flush the SCSI Host work_q so that
@@ -2422,8 +2423,15 @@ fc_rport_final_delete(struct work_struct
 	 * Avoid this call if we already called it when we preserved the
 	 * rport for the binding.
 	 */
+	spin_lock_irqsave(shost->host_lock, flags);
 	if (!(rport->flags & FC_RPORT_DEVLOSS_CALLBK_DONE) &&
-	    (i->f->dev_loss_tmo_callbk))
+	    (i->f->dev_loss_tmo_callbk)) {
+		rport->flags |= FC_RPORT_DEVLOSS_CALLBK_DONE;
+		do_callback = 1;
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	if (do_callback)
 		i->f->dev_loss_tmo_callbk(rport);
 
 	fc_bsg_remove(rport->rqst_q);
@@ -2970,6 +2978,7 @@ fc_timeout_deleted_rport(struct work_str
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
 	unsigned long flags;
+	int do_callback = 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 
@@ -3035,7 +3044,6 @@ fc_timeout_deleted_rport(struct work_str
 	rport->roles = FC_PORT_ROLE_UNKNOWN;
 	rport->port_state = FC_PORTSTATE_NOTPRESENT;
 	rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
-	rport->flags |= FC_RPORT_DEVLOSS_CALLBK_DONE;
 
 	/*
 	 * Pre-emptively kill I/O rather than waiting for the work queue
@@ -3045,32 +3053,40 @@ fc_timeout_deleted_rport(struct work_str
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	fc_terminate_rport_io(rport);
 
-	BUG_ON(rport->port_state != FC_PORTSTATE_NOTPRESENT);
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	if (rport->port_state == FC_PORTSTATE_NOTPRESENT) {	/* still missing */
+
+		/* remove the identifiers that aren't used in the consisting binding */
+		switch (fc_host->tgtid_bind_type) {
+		case FC_TGTID_BIND_BY_WWPN:
+			rport->node_name = -1;
+			rport->port_id = -1;
+			break;
+		case FC_TGTID_BIND_BY_WWNN:
+			rport->port_name = -1;
+			rport->port_id = -1;
+			break;
+		case FC_TGTID_BIND_BY_ID:
+			rport->node_name = -1;
+			rport->port_name = -1;
+			break;
+		case FC_TGTID_BIND_NONE:	/* to keep compiler happy */
+			break;
+		}
 
-	/* remove the identifiers that aren't used in the consisting binding */
-	switch (fc_host->tgtid_bind_type) {
-	case FC_TGTID_BIND_BY_WWPN:
-		rport->node_name = -1;
-		rport->port_id = -1;
-		break;
-	case FC_TGTID_BIND_BY_WWNN:
-		rport->port_name = -1;
-		rport->port_id = -1;
-		break;
-	case FC_TGTID_BIND_BY_ID:
-		rport->node_name = -1;
-		rport->port_name = -1;
-		break;
-	case FC_TGTID_BIND_NONE:	/* to keep compiler happy */
-		break;
+		/*
+		 * As this only occurs if the remote port (scsi target)
+		 * went away and didn't come back - we'll remove
+		 * all attached scsi devices.
+		 */
+		rport->flags |= FC_RPORT_DEVLOSS_CALLBK_DONE;
+		fc_queue_work(shost, &rport->stgt_delete_work);
+
+		do_callback = 1;
 	}
 
-	/*
-	 * As this only occurs if the remote port (scsi target)
-	 * went away and didn't come back - we'll remove
-	 * all attached scsi devices.
-	 */
-	fc_queue_work(shost, &rport->stgt_delete_work);
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	/*
 	 * Notify the driver that the rport is now dead. The LLDD will
@@ -3078,7 +3094,7 @@ fc_timeout_deleted_rport(struct work_str
 	 *
 	 * Note: we set the CALLBK_DONE flag above to correspond
 	 */
-	if (i->f->dev_loss_tmo_callbk)
+	if (do_callback && i->f->dev_loss_tmo_callbk)
 		i->f->dev_loss_tmo_callbk(rport);
 }
 

