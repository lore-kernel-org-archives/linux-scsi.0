From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [RFC] FC transport: Disable LUN scanning from low level driver
Date: Tue, 21 Aug 2007 14:36:40 +0200
Message-ID: <20070821123640.GA4821@schmichrtp.de.ibm.com>
References: <20070820112121.GA1487@schmichrtp.de.ibm.com> <46CA3ACB.7070708@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:60853 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbXHUMiG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Aug 2007 08:38:06 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.13.8/8.13.8) with ESMTP id l7LCc4gj105754
	for <linux-scsi@vger.kernel.org>; Tue, 21 Aug 2007 12:38:04 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7LCc48j1601636
	for <linux-scsi@vger.kernel.org>; Tue, 21 Aug 2007 14:38:04 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7LCc3ZI024653
	for <linux-scsi@vger.kernel.org>; Tue, 21 Aug 2007 14:38:03 +0200
Content-Disposition: inline
In-Reply-To: <46CA3ACB.7070708@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org

James,

thanks for the feedback.

On Mon, Aug 20, 2007 at 09:07:23PM -0400, James Smart wrote:
> I'd prefer a flag/bit in the fc template to indicate no scanning by the
> transport. Thus, it's up to the driver to call __scsi_add_device, or
> perform the appropriate scans...

I attached a new patch that adds a flag to the fc template. So far, it
is untested. What is the better approach? Avoid scanning with the flag
being 1 or use the 1 to enable scaning and make this change in all FC
drivers?

> Note: this doesn't stop the problem in absolute. as long as there's scan
> interfaces via sysfs, any tool/admin could request a scan and hit your
> issues. To truly solve it, you need, within the LLDD, to munge what the
> midlayer sees for LUN lists.

We had the discussion about zfcp inventing LUNs in the past
(http://www.spinics.net/lists/linux-scsi/msg17125.html).

Disabling the scanning in the FC transport class is the most important
step at the moment, since the admin can only prevent the warning
messages by changing the LUN 0 to something else on the storage
system. I think for the user requested scan, we can now advice the
user not to issue it for zfcp, if he does anyway he will simply get
the warning message.

Christof Schmitt

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
+	    !(i->f->no_target_scan)) {
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
+	unsigned long	no_target_scan:1;
 };
 
 

---
 drivers/s390/scsi/zfcp_scsi.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.orig/drivers/s390/scsi/zfcp_scsi.c
+++ linux-2.6/drivers/s390/scsi/zfcp_scsi.c
@@ -800,6 +800,7 @@ struct fc_function_template zfcp_transpo
 	.show_host_port_type = 1,
 	.show_host_speed = 1,
 	.show_host_port_id = 1,
+	.no_target_scan = 1,
 };
 
 /**
