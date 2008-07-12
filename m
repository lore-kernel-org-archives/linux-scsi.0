From: michaelc@cs.wisc.edu
Subject: [PATCH 1/2] fc class: unblock target after calling terminate callback
Date: Fri, 11 Jul 2008 21:40:40 -0500
Message-ID: <1215830441-20259-2-git-send-email-michaelc@cs.wisc.edu>
References: <1215830441-20259-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbYGLCkt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2008 22:40:49 -0400
In-Reply-To: <1215830441-20259-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Smart@Emulex.Com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

When we block a rport and the driver implements the terminate
callback we will fail IO that was running quickly. However
IO that was in the scsi_device/block queue sits there until
the dev_loss_tmo fires, and this can make it look like IO is
lost because new IO will get executed but that IO stuck in
the blocked queue sits there for some time longer.

With this patch when the fast io fail tmo fires, we will
fail the blocked IO and any new IO. This patch also allows
all drivers to partially support the fast io fail tmo. If the
terminate io callback is not implemented, we will still fail blocked
IO and any new IO, so multipath can handle that.

This patch also allows the fc and iscsi classes to implement the
same behavior. The timers are just unfornately named differently.

This patch also fixes the problem where drivers were unblocking
the target in their terminate callback, which was needed for
rport removal, but for fast io fail timeout it would cause
IO to bounce arround the scsi/block layer and the LLD queuecommand.
And it for drivers that could have IO stuck but did not have
a terminate callback the unblock calls in the class will fix
them.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_fc.c |   43 +++++++++++++++++++++++---------------
 include/scsi/scsi_transport_fc.h |    6 ++++-
 2 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 5fd64e7..ba2ad97 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2156,8 +2156,7 @@ fc_attach_transport(struct fc_function_template *ft)
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(roles);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_state);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(scsi_target_id);
-	if (ft->terminate_rport_io)
-		SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(fast_io_fail_tmo);
+	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(fast_io_fail_tmo);
 
 	BUG_ON(count > FC_RPORT_NUM_ATTRS);
 
@@ -2351,6 +2350,22 @@ fc_remove_host(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL(fc_remove_host);
 
+static void fc_terminate_rport_io(struct fc_rport *rport)
+{
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+
+	/* Involve the LLDD if possible to terminate all io on the rport. */
+	if (i->f->terminate_rport_io)
+		i->f->terminate_rport_io(rport);
+
+	/*
+	 * must unblock to flush queued IO. The caller will have set
+	 * the port_state or flags, so that fc_remote_port_chkready will
+	 * fail IO.
+	 */
+	scsi_target_unblock(&rport->dev);
+}
 
 /**
  * fc_starget_delete - called to delete the scsi decendents of an rport
@@ -2363,13 +2378,8 @@ fc_starget_delete(struct work_struct *work)
 {
 	struct fc_rport *rport =
 		container_of(work, struct fc_rport, stgt_delete_work);
-	struct Scsi_Host *shost = rport_to_shost(rport);
-	struct fc_internal *i = to_fc_internal(shost->transportt);
-
-	/* Involve the LLDD if possible to terminate all io on the rport. */
-	if (i->f->terminate_rport_io)
-		i->f->terminate_rport_io(rport);
 
+	fc_terminate_rport_io(rport);
 	scsi_remove_target(&rport->dev);
 }
 
@@ -2395,10 +2405,7 @@ fc_rport_final_delete(struct work_struct *work)
 	if (rport->flags & FC_RPORT_SCAN_PENDING)
 		scsi_flush_work(shost);
 
-	/* involve the LLDD to terminate all pending i/o */
-	if (i->f->terminate_rport_io)
-		i->f->terminate_rport_io(rport);
-
+	fc_terminate_rport_io(rport);
 	/*
 	 * Cancel any outstanding timers. These should really exist
 	 * only when rmmod'ing the LLDD and we're asking for
@@ -2662,6 +2669,7 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 
 				spin_lock_irqsave(shost->host_lock, flags);
 
+				rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
 				rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
 
 				/* if target, initiate a scan */
@@ -2725,6 +2733,7 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 			rport->port_id = ids->port_id;
 			rport->roles = ids->roles;
 			rport->port_state = FC_PORTSTATE_ONLINE;
+			rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
 
 			if (fci->f->dd_fcrport_size)
 				memset(rport->dd_data, 0,
@@ -2807,7 +2816,6 @@ void
 fc_remote_port_delete(struct fc_rport  *rport)
 {
 	struct Scsi_Host *shost = rport_to_shost(rport);
-	struct fc_internal *i = to_fc_internal(shost->transportt);
 	int timeout = rport->dev_loss_tmo;
 	unsigned long flags;
 
@@ -2853,7 +2861,7 @@ fc_remote_port_delete(struct fc_rport  *rport)
 
 	/* see if we need to kill io faster than waiting for device loss */
 	if ((rport->fast_io_fail_tmo != -1) &&
-	    (rport->fast_io_fail_tmo < timeout) && (i->f->terminate_rport_io))
+	    (rport->fast_io_fail_tmo < timeout))
 		fc_queue_devloss_work(shost, &rport->fail_io_work,
 					rport->fast_io_fail_tmo * HZ);
 
@@ -2930,6 +2938,7 @@ fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles)
 
 		spin_lock_irqsave(shost->host_lock, flags);
 		rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
+		rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
 		spin_unlock_irqrestore(shost->host_lock, flags);
 
 		/* ensure any stgt delete functions are done */
@@ -3024,6 +3033,7 @@ fc_timeout_deleted_rport(struct work_struct *work)
 	rport->supported_classes = FC_COS_UNSPECIFIED;
 	rport->roles = FC_PORT_ROLE_UNKNOWN;
 	rport->port_state = FC_PORTSTATE_NOTPRESENT;
+	rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
 
 	/* remove the identifiers that aren't used in the consisting binding */
 	switch (fc_host->tgtid_bind_type) {
@@ -3066,13 +3076,12 @@ fc_timeout_fail_rport_io(struct work_struct *work)
 {
 	struct fc_rport *rport =
 		container_of(work, struct fc_rport, fail_io_work.work);
-	struct Scsi_Host *shost = rport_to_shost(rport);
-	struct fc_internal *i = to_fc_internal(shost->transportt);
 
 	if (rport->port_state != FC_PORTSTATE_BLOCKED)
 		return;
 
-	i->f->terminate_rport_io(rport);
+	rport->flags |= FC_RPORT_FAST_FAIL_TIMEDOUT;
+	fc_terminate_rport_io(rport);
 }
 
 /**
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 06f72ba..72fc9af 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -338,6 +338,7 @@ struct fc_rport {	/* aka fc_starget_attrs */
 /* bit field values for struct fc_rport "flags" field: */
 #define FC_RPORT_DEVLOSS_PENDING	0x01
 #define FC_RPORT_SCAN_PENDING		0x02
+#define FC_RPORT_FAST_FAIL_TIMEDOUT	0x03
 
 #define	dev_to_rport(d)				\
 	container_of(d, struct fc_rport, dev)
@@ -664,7 +665,10 @@ fc_remote_port_chkready(struct fc_rport *rport)
 			result = DID_NO_CONNECT << 16;
 		break;
 	case FC_PORTSTATE_BLOCKED:
-		result = DID_IMM_RETRY << 16;
+		if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
+			result = DID_NO_CONNECT << 16;
+		else
+			result = DID_IMM_RETRY << 16;
 		break;
 	default:
 		result = DID_NO_CONNECT << 16;
-- 
1.5.4.1

