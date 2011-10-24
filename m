From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 6/9] ib_srpt: Remove legacy use_port_guid_in_session_name module parameter
Date: Mon, 24 Oct 2011 05:33:39 +0000
Message-ID: <1319434422-15354-7-git-send-email-nab@linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the legacy use_port_guid_in_session_name module parameter
that is no longer required in modern ib_srpt code.

Reported-by: Roland Dreier <roland@purestorage.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   36 +++++---------------------------
 1 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index ae9fd0e..5c61ba4 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -103,12 +103,6 @@ module_param(srpt_sq_size, int, 0444);
 MODULE_PARM_DESC(srpt_sq_size,
 		 "Per-channel send queue (SQ) size.");
 
-static bool use_port_guid_in_session_name;
-module_param(use_port_guid_in_session_name, bool, 0444);
-MODULE_PARM_DESC(use_port_guid_in_session_name,
-		 "Use target port ID in the session name such that"
-		 " redundant paths between multiport systems can be masked.");
-
 static int srpt_get_u64_x(char *buffer, struct kernel_param *kp)
 {
 	return sprintf(buffer, "0x%016llx", *(u64 *)kp->arg);
@@ -2605,30 +2599,12 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		       " RTR failed (error code = %d)\n", ret);
 		goto destroy_ib;
 	}
-
-	if (use_port_guid_in_session_name) {
-		/*
-		 * If the kernel module parameter use_port_guid_in_session_name
-		 * has been specified, use a combination of the target port
-		 * GUID and the initiator port ID as the session name. This
-		 * was the original behavior of the SRP target implementation
-		 * (i.e. before the SRPT was included in OFED 1.3).
-		 */
-		snprintf(ch->sess_name, sizeof(ch->sess_name),
-			 "0x%016llx%016llx",
-			 be64_to_cpu(*(__be64 *)
-				&sdev->port[param->port - 1].gid.raw[8]),
-			 be64_to_cpu(*(__be64 *)(ch->i_port_id + 8)));
-	} else {
-		/*
-		 * Default behavior: use the initator port identifier as the
-		 * session name.
-		 */
-		snprintf(ch->sess_name, sizeof(ch->sess_name),
-			 "0x%016llx%016llx",
-			 be64_to_cpu(*(__be64 *)ch->i_port_id),
-			 be64_to_cpu(*(__be64 *)(ch->i_port_id + 8)));
-	}
+	/*
+	 * Use the initator port identifier as the session name.
+	 */
+	snprintf(ch->sess_name, sizeof(ch->sess_name), "0x%016llx%016llx",
+			be64_to_cpu(*(__be64 *)ch->i_port_id),
+			be64_to_cpu(*(__be64 *)(ch->i_port_id + 8)));
 
 	pr_debug("registering session %s\n", ch->sess_name);
 
-- 
1.7.2.5
