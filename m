From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] fc_transport: stop creating duplicate rport entries.
Date: Tue, 14 Feb 2006 14:22:14 -0800
Message-ID: <20060214222214.GJ2051@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:20026 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1422834AbWBNWWQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2006 17:22:16 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Current fc_transport consumers initially register rports
with an UNKNOWN role-state and follow-up with a call to
fc_remote_port_rolechg().  Modify code in
fc_remote_port_add() to scan the fc_host_rport_bindings()
array for consistent bindings regardless of role-type.
Original code would only scan bindings array for targets,
causing duplicate fc_remote_ports/rport-X:Y-Z entries to be
created for the yet-to-be-role-changed rports.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

This should go into 2.6.16.

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index f2c9acf..929032e 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1498,8 +1498,7 @@ fc_remote_port_add(struct Scsi_Host *sho
 	}
 
 	/* Search the bindings array */
-	if (likely((ids->roles & FC_RPORT_ROLE_FCP_TARGET) &&
-		(fc_host_tgtid_bind_type(shost) != FC_TGTID_BIND_NONE))) {
+	if (fc_host_tgtid_bind_type(shost) != FC_TGTID_BIND_NONE) {
 
 		/* search for a matching consistent binding */
 
