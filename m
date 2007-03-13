From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] fc_transport: make all rports wait dev_loss_tmo before
	removing them
Date: Tue, 13 Mar 2007 11:06:49 -0500
Message-ID: <1173802009.4861.8.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46540 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbXCMQGn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Mar 2007 12:06:43 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l2DG6gjb016763
	for <linux-scsi@vger.kernel.org>; Tue, 13 Mar 2007 09:06:42 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Per the comment in the change - it's not always prudent to immediately
remove the rport upon first notice of a disconnect. Make all rports
wait dev_loss_tmo before being deleted (and each could have a separate
dev_loss_tmo value).

-- james s

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2007-03-12 13:56:16.000000000 -0500
+++ b/drivers/scsi/scsi_transport_fc.c	2007-03-12 14:25:58.000000000 -0500
@@ -2156,14 +2156,18 @@ fc_remote_port_delete(struct fc_rport  *
 
 	spin_lock_irqsave(shost->host_lock, flags);
 
-	/* If no scsi target id mapping, delete it */
-	if (rport->scsi_target_id == -1) {
-		list_del(&rport->peers);
-		rport->port_state = FC_PORTSTATE_DELETED;
-		fc_queue_work(shost, &rport->rport_delete_work);
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		return;
-	}
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
 
 	rport->port_state = FC_PORTSTATE_BLOCKED;
 


