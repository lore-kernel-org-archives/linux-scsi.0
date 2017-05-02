From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v2] ibmvscsis: Do not send aborted task response
Date: Tue,  2 May 2017 13:54:21 -0500
Message-ID: <1493751261-81647-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: nab@linux-iscsi.org, Bart.VanAssche@sandisk.com, martin.petersen@oracle.com
Cc: turtle.in.the.kernel@gmail.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The driver is sending a response to the actual scsi op that was
aborted by an abort task TM, while LIO is sending a response to
the abort task TM.

ibmvscsis_tgt does not send the response to the client until
release_cmd time. The reason for this was because if we did it
at queue_status time, then the client would be free to reuse the
tag for that command, but we're still using the tag until the
command is released at release_cmd time, so we chose to delay
sending the response until then. That then caused this issue, because
release_cmd is always called, even if queue_status is not.

SCSI spec says that the initiator that sends the abort task
TM NEVER gets a response to the aborted op and with the current
code it will send a response. Thus this fix will remove that response
if the TAS bit is set.

Cc: <stable@vger.kernel.org> # v4.8+
Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Reviewed-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 66 ++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 4bb5635..d6e62ce 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -1758,33 +1758,46 @@ static void ibmvscsis_send_messages(struct scsi_info *vscsi)
 
 	if (!(vscsi->flags & RESPONSE_Q_DOWN)) {
 		list_for_each_entry_safe(cmd, nxt, &vscsi->waiting_rsp, list) {
-			iue = cmd->iue;
-
-			crq->valid = VALID_CMD_RESP_EL;
-			crq->format = cmd->rsp.format;
+			/*
+			 * If Task Abort Status Bit is set, then dont send a
+			 * response.
+			 */
+			if (cmd->se_cmd.transport_state & CMD_T_ABORTED &&
+			    !(cmd->se_cmd.transport_state & CMD_T_TAS)) {
+				list_del(&cmd->list);
+				ibmvscsis_free_cmd_resources(vscsi, cmd);
+			} else {
+				iue = cmd->iue;
 
-			if (cmd->flags & CMD_FAST_FAIL)
-				crq->status = VIOSRP_ADAPTER_FAIL;
+				crq->valid = VALID_CMD_RESP_EL;
+				crq->format = cmd->rsp.format;
 
-			crq->IU_length = cpu_to_be16(cmd->rsp.len);
+				if (cmd->flags & CMD_FAST_FAIL)
+					crq->status = VIOSRP_ADAPTER_FAIL;
 
-			rc = h_send_crq(vscsi->dma_dev->unit_address,
-					be64_to_cpu(msg_hi),
-					be64_to_cpu(cmd->rsp.tag));
+				crq->IU_length = cpu_to_be16(cmd->rsp.len);
 
-			pr_debug("send_messages: cmd %p, tag 0x%llx, rc %ld\n",
-				 cmd, be64_to_cpu(cmd->rsp.tag), rc);
+				rc = h_send_crq(vscsi->dma_dev->unit_address,
+						be64_to_cpu(msg_hi),
+						be64_to_cpu(cmd->rsp.tag));
 
-			/* if all ok free up the command element resources */
-			if (rc == H_SUCCESS) {
-				/* some movement has occurred */
-				vscsi->rsp_q_timer.timer_pops = 0;
-				list_del(&cmd->list);
+				pr_debug("send_messages: cmd %p, tag 0x%llx, rc %ld\n",
+					 cmd, be64_to_cpu(cmd->rsp.tag), rc);
 
-				ibmvscsis_free_cmd_resources(vscsi, cmd);
-			} else {
-				srp_snd_msg_failed(vscsi, rc);
-				break;
+				/* if all ok free up the command element
+				 * resources
+				 */
+				if (rc == H_SUCCESS) {
+					/* some movement has occurred */
+					vscsi->rsp_q_timer.timer_pops = 0;
+					list_del(&cmd->list);
+
+					ibmvscsis_free_cmd_resources(vscsi,
+								     cmd);
+				} else {
+					srp_snd_msg_failed(vscsi, rc);
+					break;
+				}
 			}
 		}
 
@@ -3581,9 +3594,20 @@ static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
 {
 	struct ibmvscsis_cmd *cmd = container_of(se_cmd, struct ibmvscsis_cmd,
 						 se_cmd);
+	struct scsi_info *vscsi = cmd->adapter;
 	struct iu_entry *iue = cmd->iue;
 	int rc;
 
+	/*
+	 * If CLIENT_FAILED OR RESPONSE_Q_DOWN, then just return success
+	 * since LIO can't do anything about it, and we dont want to
+	 * attempt an srp_transfer_data.
+	 */
+	if ((vscsi->flags & (CLIENT_FAILED | RESPONSE_Q_DOWN))) {
+		pr_err("write_pending failed since: %d\n", vscsi->flags);
+		return 0;
+	}
+
 	rc = srp_transfer_data(cmd, &vio_iu(iue)->srp.cmd, ibmvscsis_rdma,
 			       1, 1);
 	if (rc) {
-- 
2.5.4 (Apple Git-61)
