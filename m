From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Update: [PATCH] FC transport: Allow LLDD to disable LUN scanning
Date: Wed, 22 Aug 2007 10:34:25 +0200
Message-ID: <20070822083425.GB4761@schmichrtp.de.ibm.com>
References: <20070821153716.GB11101@schmichrtp.de.ibm.com> <20070821154634.GA9163@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:52011 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbXHVIg0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Aug 2007 04:36:26 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate8.uk.ibm.com (8.13.8/8.13.8) with ESMTP id l7M8aPhY339136
	for <linux-scsi@vger.kernel.org>; Wed, 22 Aug 2007 08:36:25 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7M8aPde2347056
	for <linux-scsi@vger.kernel.org>; Wed, 22 Aug 2007 09:36:25 +0100
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7M8a8eU030732
	for <linux-scsi@vger.kernel.org>; Wed, 22 Aug 2007 09:36:09 +0100
Content-Disposition: inline
In-Reply-To: <20070821154634.GA9163@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <James.Smart@Emulex.Com>, Matthew Wilcox <matthew@wil.cx>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Introduce a flag that allows the SCSI low level device driver to
disable the automatic scanning for LUNs from the FC transport class.

This is for the zfcp device driver that manages the attached units on
its own and does not want to have the automatic discovery of other
LUNs.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/scsi/scsi_transport_fc.c |    4 +++-
 include/scsi/scsi_transport_fc.h |    2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

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
@@ -632,6 +632,8 @@ struct fc_function_template {
 	unsigned long	show_host_fabric_name:1;
 	unsigned long	show_host_symbolic_name:1;
 	unsigned long	show_host_system_hostname:1;
+
+	unsigned long	disable_target_scan:1;
 };
 
 
