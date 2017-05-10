From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v2] ibmvscsis: Fix the incorrect req_lim_delta
Date: Wed, 10 May 2017 14:35:47 -0500
Message-ID: <1494444947-77322-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: mikecyr@linux.vnet.ibm.com, mikecyr@us.ibm.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The current code is not correctly calculating the req_lim_delta.

We want to make sure vscsi->credit is always incremented when
we do not send a response for the scsi op. Thus for the case where
there is a successfully aborted task we need to make sure the
vscsi->credit is incremented.

v2 - Moves the original location of the vscsi->credit increment
to a better spot. Since if we increment credit, the next command
we send back will have increased req_lim_delta. But we probably
shouldn't be doing that until the aborted cmd is actually released.
Otherwise the client will think that it can send a new command, and
we could find ourselves short of command elements. Not likely, but could
happen.

This patch depends on both:
commit 25e78531268e ("ibmvscsis: Do not send aborted task response")
commit 38b2788edbd6 ("ibmvscsis: Clear left-over abort_cmd pointers")

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Reviewed-by: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org> # v4.8+
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index ee64241..abf6026 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -1791,6 +1791,25 @@ static void ibmvscsis_send_messages(struct scsi_info *vscsi)
 					list_del(&cmd->list);
 					ibmvscsis_free_cmd_resources(vscsi,
 								     cmd);
+					/*
+					 * With a successfully aborted op
+					 * through LIO we want to increment the
+					 * the vscsi credit so that when we dont
+					 * send a rsp to the original scsi abort
+					 * op (h_send_crq), but the tm rsp to
+					 * the abort is sent, the credit is
+					 * correctly sent with the abort tm rsp.
+					 * We would need 1 for the abort tm rsp
+					 * and 1 credit for the aborted scsi op.
+					 * Thus we need to increment here.
+					 * Also we want to increment the credit
+					 * here because we want to make sure
+					 * cmd is actually released first
+					 * otherwise the client will think it
+					 * it can send a new cmd, and we could
+					 * find ourselves short of cmd elements.
+					 */
+					vscsi->credit += 1;
 				} else {
 					iue = cmd->iue;
 
@@ -2965,10 +2984,7 @@ static long srp_build_response(struct scsi_info *vscsi,
 
 	rsp->opcode = SRP_RSP;
 
-	if (vscsi->credit > 0 && vscsi->state == SRP_PROCESSING)
-		rsp->req_lim_delta = cpu_to_be32(vscsi->credit);
-	else
-		rsp->req_lim_delta = cpu_to_be32(1 + vscsi->credit);
+	rsp->req_lim_delta = cpu_to_be32(1 + vscsi->credit);
 	rsp->tag = cmd->rsp.tag;
 	rsp->flags = 0;
 
-- 
2.5.4 (Apple Git-61)
