From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [PATCH] FC transport: Allow LLDD to disable LUN scanning
Date: Tue, 21 Aug 2007 17:37:17 +0200
Message-ID: <20070821153716.GB11101@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:24946 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760586AbXHUPiq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Aug 2007 11:38:46 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.8/8.13.8) with ESMTP id l7LFcjIQ036186
	for <linux-scsi@vger.kernel.org>; Tue, 21 Aug 2007 15:38:45 GMT
Received: from d12av01.megacenter.de.ibm.com (d12av01.megacenter.de.ibm.com [9.149.165.212])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7LFcjbw2310318
	for <linux-scsi@vger.kernel.org>; Tue, 21 Aug 2007 17:38:45 +0200
Received: from d12av01.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av01.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7LFciPu017865
	for <linux-scsi@vger.kernel.org>; Tue, 21 Aug 2007 17:38:45 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <James.Smart@Emulex.Com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Introduce a flag that allows the SCSI low level device driver to
disable the automatic scanning for LUNs from the FC transport class.

This is for the zfcp device driver that manages the attached units on
its own and does not want to have the automatic discovery of other
LUNs.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/scsi/scsi_transport_fc.c |    4 +++-
 include/scsi/scsi_transport_fc.h |    3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- linux-2.6.orig/drivers/scsi/scsi_transport_fc.c
+++ linux-2.6/drivers/scsi/scsi_transport_fc.c
@@ -2988,10 +2988,12 @@ fc_scsi_scan_rport(struct work_struct *w
 	struct fc_rport *rport =
 		container_of(work, struct fc_rport, scan_work);
 	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
 	unsigned long flags;
 
 	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
-	    (rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
+	    (rport->roles & FC_PORT_ROLE_FCP_TARGET) &&
+	    !(i->f->disable_target_scan)) {
 		scsi_scan_target(&rport->dev, rport->channel,
 			rport->scsi_target_id, SCAN_WILD_CARD, 1);
 	}
--- linux-2.6.orig/include/scsi/scsi_transport_fc.h
+++ linux-2.6/include/scsi/scsi_transport_fc.h
@@ -632,6 +632,9 @@ struct fc_function_template {
 	unsigned long	show_host_fabric_name:1;
 	unsigned long	show_host_symbolic_name:1;
 	unsigned long	show_host_system_hostname:1;
+
+	/* The driver can disable the LUN scanning from the FC transport class */
+	unsigned long	disable_target_scan:1;
 };
 
 
