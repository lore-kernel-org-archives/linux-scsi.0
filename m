From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v1] ibmvscsis: Fix the incorrect req_lim_delta
Date: Wed, 10 May 2017 13:53:09 -0500
Message-ID: <1494442389-75706-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: mikecyr@linux.vnet.ibm.com, mikecyr@us.ibm.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The current code is not correctly calculating the req_lim_delta.

We want to make sure vscsi->credit is always incremented when
we do not send a response for the scsi op. Thus for the case where
there is a successfully aborted task we need to make sure the
vscsi->credit is incremented.

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Reviewed-by: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org> # v4.8+
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index ee64241..2d97f02 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -2965,10 +2965,7 @@ static long srp_build_response(struct scsi_info *vscsi,
 
 	rsp->opcode = SRP_RSP;
 
-	if (vscsi->credit > 0 && vscsi->state == SRP_PROCESSING)
-		rsp->req_lim_delta = cpu_to_be32(vscsi->credit);
-	else
-		rsp->req_lim_delta = cpu_to_be32(1 + vscsi->credit);
+	rsp->req_lim_delta = cpu_to_be32(1 + vscsi->credit);
 	rsp->tag = cmd->rsp.tag;
 	rsp->flags = 0;
 
@@ -3739,6 +3736,22 @@ static void ibmvscsis_queue_tm_rsp(struct se_cmd *se_cmd)
 
 static void ibmvscsis_aborted_task(struct se_cmd *se_cmd)
 {
+	struct ibmvscsis_cmd *cmd = container_of(se_cmd, struct ibmvscsis_cmd,
+						 se_cmd);
+	struct scsi_info *vscsi = cmd->adapter;
+
+	/*
+	 * With a successfully aborted op through LIO we want to increment the
+	 * the vscsi credit so that when we dont send a rsp to the original
+	 * scsi abort op but the tm rsp to the abort is sent, the credit is
+	 * correctly sent with the abort tm rsp. We would need 1 for the abort
+	 * tm rsp and 1 credit for the aborted scsi op. Thus we need to
+	 * increment here.
+	 */
+	spin_lock_bh(&vscsi->intr_lock);
+	vscsi->credit += 1;
+	spin_unlock_bh(&vscsi->intr_lock);
+
 	pr_debug("ibmvscsis_aborted_task %p task_tag: %llu\n",
 		 se_cmd, se_cmd->tag);
 }
-- 
2.5.4 (Apple Git-61)
