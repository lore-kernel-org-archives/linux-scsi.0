From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] fc transport: restore missing dev_loss_tmo callback to LLDD
Date: Mon, 5 Jan 2009 12:14:18 -0500
Message-ID: <1231175658.3923.0.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:45801 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbZAEROd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 12:14:33 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n05HEU5v026486
	for <linux-scsi@vger.kernel.org>; Mon, 5 Jan 2009 09:14:31 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When we reworked the transport for the rport lifetimes, in cases where the
rport was reused as a container for tgt id bindings, we inadvertantly
removed the callback to the driver indicating that dev_loss_tmo had fired.

This patch restores that functionality.

-- james s



 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 drivers/scsi/scsi_transport_fc.c |   21 +++++++++++++++++++--
 include/scsi/scsi_transport_fc.h |    1 +
 2 files changed, 20 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2009-01-05 11:50:40.000000000 -0500
+++ b/drivers/scsi/scsi_transport_fc.c	2009-01-05 12:01:46.000000000 -0500
@@ -2407,8 +2407,12 @@ fc_rport_final_delete(struct work_struct
 	/*
 	 * Notify the driver that the rport is now dead. The LLDD will
 	 * also guarantee that any communication to the rport is terminated
+	 *
+	 * Avoid this call if we already called it when we preserved the
+	 * rport for the binding.
 	 */
-	if (i->f->dev_loss_tmo_callbk)
+	if (!(rport->flags & FC_RPORT_DEVLOSS_CALLBK_DONE) &&
+	    (i->f->dev_loss_tmo_callbk))
 		i->f->dev_loss_tmo_callbk(rport);
 
 	transport_remove_device(dev);
@@ -2647,7 +2651,8 @@ fc_remote_port_add(struct Scsi_Host *sho
 				spin_lock_irqsave(shost->host_lock, flags);
 
 				rport->flags &= ~(FC_RPORT_FAST_FAIL_TIMEDOUT |
-						  FC_RPORT_DEVLOSS_PENDING);
+						  FC_RPORT_DEVLOSS_PENDING |
+						  FC_RPORT_DEVLOSS_CALLBK_DONE);
 
 				/* if target, initiate a scan */
 				if (rport->scsi_target_id != -1) {
@@ -2944,6 +2949,7 @@ fc_timeout_deleted_rport(struct work_str
 	struct fc_rport *rport =
 		container_of(work, struct fc_rport, dev_loss_work.work);
 	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
 	unsigned long flags;
 
@@ -3011,6 +3017,7 @@ fc_timeout_deleted_rport(struct work_str
 	rport->roles = FC_PORT_ROLE_UNKNOWN;
 	rport->port_state = FC_PORTSTATE_NOTPRESENT;
 	rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
+	rport->flags |= FC_RPORT_DEVLOSS_CALLBK_DONE;
 
 	/*
 	 * Pre-emptively kill I/O rather than waiting for the work queue
@@ -3046,8 +3053,18 @@ fc_timeout_deleted_rport(struct work_str
 	 * all attached scsi devices.
 	 */
 	fc_queue_work(shost, &rport->stgt_delete_work);
+
+	/*
+	 * Notify the driver that the rport is now dead. The LLDD will
+	 * also guarantee that any communication to the rport is terminated
+	 *
+	 * Note: we set the CALLBK_DONE flag above to correspond
+	 */
+	if (i->f->dev_loss_tmo_callbk)
+		i->f->dev_loss_tmo_callbk(rport);
 }
 
+
 /**
  * fc_timeout_fail_rport_io - Timeout handler for a fast io failing on a disconnected SCSI target.
  * @work:	rport to terminate io on.
diff -upNr a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h	2008-12-04 12:38:38.000000000 -0500
+++ b/include/scsi/scsi_transport_fc.h	2009-01-05 11:55:49.000000000 -0500
@@ -358,6 +358,7 @@ struct fc_rport {	/* aka fc_starget_attr
 #define FC_RPORT_DEVLOSS_PENDING	0x01
 #define FC_RPORT_SCAN_PENDING		0x02
 #define FC_RPORT_FAST_FAIL_TIMEDOUT	0x04
+#define FC_RPORT_DEVLOSS_CALLBK_DONE	0x08
 
 #define	dev_to_rport(d)				\
 	container_of(d, struct fc_rport, dev)


