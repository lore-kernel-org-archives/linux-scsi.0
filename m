From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] fc transport: pre-emptively terminate i/o upon
	dev_loss_tmo timeout
Date: Fri, 5 Dec 2008 12:18:03 -0500
Message-ID: <1228497483.8775.1.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:59809 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756946AbYLERQy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 12:16:54 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mB5HGq4J018152
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2008 09:16:53 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Pre-emptively terminate i/o on the rport if dev_loss_tmo has fired.
The desire is to terminate everything, so that the i/o is cleaned up
prior to the sdev's being unblocked, thus any outstanding timeouts/aborts
are avoided.

Also, we do this early enough such that the rport's port_id field is
still valid. FCOE libFC code needs this info to find the i/o's to
terminate.

-- james s

 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 scsi_transport_fc.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2008-10-18 10:32:52.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2008-12-05 12:13:54.000000000 -0500
@@ -3012,6 +3012,16 @@ fc_timeout_deleted_rport(struct work_str
 	rport->port_state = FC_PORTSTATE_NOTPRESENT;
 	rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
 
+	/*
+	 * Pre-emptively kill I/O rather than waiting for the work queue
+	 * item to teardown the starget. (FCOE libFC folks prefer this
+	 * and to have the rport_port_id still set when it's done).
+	 */
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	fc_terminate_rport_io(rport);
+
+	BUG_ON(rport->port_state != FC_PORTSTATE_NOTPRESENT);
+
 	/* remove the identifiers that aren't used in the consisting binding */
 	switch (fc_host->tgtid_bind_type) {
 	case FC_TGTID_BIND_BY_WWPN:
@@ -3035,7 +3045,6 @@ fc_timeout_deleted_rport(struct work_str
 	 * went away and didn't come back - we'll remove
 	 * all attached scsi devices.
 	 */
-	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	scsi_target_unblock(&rport->dev);
 	fc_queue_work(shost, &rport->stgt_delete_work);


