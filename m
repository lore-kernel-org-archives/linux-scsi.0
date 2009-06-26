From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: FC transport: Calling fc_remote_port_add for online port
Date: Fri, 26 Jun 2009 17:23:03 +0200
Message-ID: <20090626152303.GA21058@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:33294 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbZFZPXO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2009 11:23:14 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.14.3/8.13.8) with ESMTP id n5QFN4TP114494
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2009 15:23:04 GMT
Received: from d12av01.megacenter.de.ibm.com (d12av01.megacenter.de.ibm.com [9.149.165.212])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5QFN3AS2256988
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2009 17:23:03 +0200
Received: from d12av01.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av01.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5QFN32C014442
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2009 17:23:03 +0200
Received: from schmichrtp.de.ibm.com (schmichrtp.mainz.de.ibm.com [9.155.23.82])
	by d12av01.megacenter.de.ibm.com (8.12.11.20060308/8.12.11) with SMTP id n5QFN3UH014439
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2009 17:23:03 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When a LLD calls fc_remote_port_add for a port that is already in the
state FC_PORTSTATE_ONLINE, the FC transport class will create a new
fc_rport struct and sysfs will show two entries for the same port.

How should this be handled? Does the LLD have to track the state and
only call fc_remote_port add for new ports and ports in the state
FC_PORTSTATE_BLOCKED or FC_PORTTYPE_NOTPRESENT?

Or should the FC transport class allow that a LLD can call
fc_remote_port_add at any time? The patch does this change in the FC
transport class.

Thoughts, comments?

--
Christof Schmitt

---
 drivers/scsi/scsi_transport_fc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/scsi/scsi_transport_fc.c	2009-06-23 14:41:20.000000000 +0200
+++ b/drivers/scsi/scsi_transport_fc.c	2009-06-23 15:22:21.000000000 +0200
@@ -2580,9 +2580,7 @@ fc_remote_port_add(struct Scsi_Host *sho
 	spin_lock_irqsave(shost->host_lock, flags);
 
 	list_for_each_entry(rport, &fc_host->rports, peers) {
-
-		if ((rport->port_state == FC_PORTSTATE_BLOCKED) &&
-			(rport->channel == channel)) {
+		if (rport->channel == channel) {
 
 			switch (fc_host->tgtid_bind_type) {
 			case FC_TGTID_BIND_BY_WWPN:
