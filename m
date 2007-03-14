From: michaelc@cs.wisc.edu
Subject: [PATCH 4/4] fc class: use transport host byte values
Date: Wed, 14 Mar 2007 14:52:48 -0500
Message-ID: <11739019713208-git-send-email-michaelc@cs.wisc.edu>
References: <11739019681346-git-send-email-michaelc@cs.wisc.edu> <11739019693216-git-send-email-michaelc@cs.wisc.edu> <11739019703157-git-send-email-michaelc@cs.wisc.edu> <11739019701684-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030861AbXCNTxD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Mar 2007 15:53:03 -0400
In-Reply-To: <11739019701684-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch is just an example. It is not tested and it is probably
better to not use the fast_io_fail_tmo variable and instead modify
the state machine.

This patch also does not convert any FC drivers to use the new codes.

The patch does modify the port ready function to return the new
host byte values and modifies the rport fast io fail tmo to
do the same thing as iscsi (fail queued and running IO).
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_fc.c |    4 ++++
 include/scsi/scsi_transport_fc.h |    8 ++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 58afdb4..af1ff02 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1970,6 +1970,7 @@ fc_remote_port_add(struct Scsi_Host *sho
 					sizeof(rport->port_name));
 				rport->port_id = ids->port_id;
 
+				rport->fast_io_fail_timeout = 0;
 				rport->port_state = FC_PORTSTATE_ONLINE;
 				rport->roles = ids->roles;
 
@@ -2059,6 +2060,7 @@ fc_remote_port_add(struct Scsi_Host *sho
 				sizeof(rport->port_name));
 			rport->port_id = ids->port_id;
 			rport->roles = ids->roles;
+			rport->fast_io_fail_timeout = 0;
 			rport->port_state = FC_PORTSTATE_ONLINE;
 
 			if (fci->f->dd_fcrport_size)
@@ -2381,7 +2383,9 @@ fc_timeout_fail_rport_io(struct work_str
 	if (rport->port_state != FC_PORTSTATE_BLOCKED)
 		return;
 
+	rport->fast_io_fail_timeout = 1;
 	i->f->terminate_rport_io(rport);
+	scsi_target_unblock(&rport->dev);
 }
 
 /**
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 798f7c7..b7f7e51 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -196,6 +196,7 @@ struct fc_rport {	/* aka fc_starget_attr
 	enum fc_port_state port_state;	/* Will only be ONLINE or UNKNOWN */
 	u32 scsi_target_id;
 	u32 fast_io_fail_tmo;
+	u8 fast_io_fail_timeout;
 
 	/* exported data */
 	void *dd_data;			/* Used for driver-specific storage */
@@ -508,17 +509,20 @@ fc_remote_port_chkready(struct fc_rport 
 {
 	int result;
 
+	if (rport->fastfail_timeout)
+		return DID_TRANSPORT_FAILFAST;
+
 	switch (rport->port_state) {
 	case FC_PORTSTATE_ONLINE:
 		if (rport->roles & FC_RPORT_ROLE_FCP_TARGET)
 			result = 0;
 		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
-			result = DID_IMM_RETRY << 16;
+			result = DID_TRANSPORT_BLOCKED << 16;
 		else
 			result = DID_NO_CONNECT << 16;
 		break;
 	case FC_PORTSTATE_BLOCKED:
-		result = DID_IMM_RETRY << 16;
+		result = DID_TRANSPORT_BLOCKED << 16;
 		break;
 	default:
 		result = DID_NO_CONNECT << 16;
-- 
1.4.1.1

