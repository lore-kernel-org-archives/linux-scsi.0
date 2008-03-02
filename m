From: michaelc@cs.wisc.edu
Subject: [PATCH 6/9] fc class: add fc queueing helper
Date: Sun,  2 Mar 2008 03:03:19 -0600
Message-ID: <1204448602-5435-6-git-send-email-michaelc@cs.wisc.edu>
References: <1204448602-5435-1-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-2-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-3-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-4-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-5-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbYCBJEL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Mar 2008 04:04:11 -0500
In-Reply-To: <1204448602-5435-5-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, david.somayajulu@qlogic.com, andrew.vasquez@qlogic.com, James.Smart@Emulex.com, Eric.Moore@lsil.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Add a queueing helper which will return SCSI_MLQUEUE_TARGET_BUSY
if we are transitioning because there is no need to call into
the driver anymore at that point.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 include/scsi/scsi_transport_fc.h |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 4769efd..62a6a74 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -29,6 +29,7 @@
 
 #include <linux/sched.h>
 #include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_netlink.h>
 
 struct scsi_transport_template;
@@ -640,6 +641,38 @@ struct fc_function_template {
 	unsigned long	disable_target_scan:1;
 };
 
+/**
+ * fc_remote_port_queue_ready - called to validate the remote port state
+ * @rport: remote port to be checked
+ *
+ * Returns 0 if IO can be queued or if there the cmd should be
+ * completed by a call to cmd->scsi_done. Caller must check cmd->result.
+ * Returns SCSI_MLQUEUE value if IO cannot be queued temporarily.
+ **/
+static inline int
+fc_remote_port_queue_ready(struct fc_rport *rport, struct scsi_cmnd *cmd)
+{
+	int result = 0;
+
+	cmd->result = 0;
+	switch (rport->port_state) {
+	case FC_PORTSTATE_ONLINE:
+		if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
+			result = 0;
+		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
+			result = SCSI_MLQUEUE_TARGET_BUSY;
+		else
+			cmd->result = DID_NO_CONNECT << 16;
+		break;
+	case FC_PORTSTATE_BLOCKED:
+		result = SCSI_MLQUEUE_TARGET_BUSY;
+		break;
+	default:
+		cmd->result = DID_NO_CONNECT << 16;
+		break;
+	}
+	return result;
+}
 
 /**
  * fc_remote_port_chkready - called to validate the remote port state
-- 
1.5.4.1

