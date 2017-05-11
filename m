From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Re-add check to reject control WRITEs with overflow data
Date: Thu, 11 May 2017 18:04:02 +0000
Message-ID: <1494525842-9389-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

During v4.3 when the overflow/underflow check was relaxed by
commit c72c525022:

  commit c72c5250224d475614a00c1d7e54a67f77cd3410
  Author: Roland Dreier <roland@purestorage.com>
  Date:   Wed Jul 22 15:08:18 2015 -0700

       target: allow underflow/overflow for PR OUT etc. commands

to allow underflow/overflow for Windows compliance + FCP, a
consequence was to allow control CDBs to process overflow
data for iscsi-target with immediate data as well.

As per Roland's original change, continue to allow underflow
cases for control CDBs to make Windows compliance + FCP happy,
but until then explicitly reject all control WRITEs with
overflow following pre v4.3.y logic.

Reported-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 37f5735..6025935 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1160,15 +1160,28 @@ int transport_dump_vpd_ident(
 	if (cmd->unknown_data_length) {
 		cmd->data_length = size;
 	} else if (size != cmd->data_length) {
-		pr_warn("TARGET_CORE[%s]: Expected Transfer Length:"
+		pr_warn_ratelimited("TARGET_CORE[%s]: Expected Transfer Length:"
 			" %u does not match SCSI CDB Length: %u for SAM Opcode:"
 			" 0x%02x\n", cmd->se_tfo->get_fabric_name(),
 				cmd->data_length, size, cmd->t_task_cdb[0]);
 
-		if (cmd->data_direction == DMA_TO_DEVICE &&
-		    cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) {
-			pr_err("Rejecting underflow/overflow WRITE data\n");
-			return TCM_INVALID_CDB_FIELD;
+		if (cmd->data_direction == DMA_TO_DEVICE) {
+			if (cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) {
+				pr_err_ratelimited("Rejecting underflow/overflow"
+						   " for WRITE data CDB\n");
+				return TCM_INVALID_CDB_FIELD;
+			}
+			/*
+			 * Some fabric drivers like iscsi-target still expect to
+			 * always reject overflow writes.  Reject this case until
+			 * full fabric driver level support for overflow writes
+			 * is introduced tree-wide.
+			 */
+			if (size > cmd->data_length) {
+				pr_err_ratelimited("Rejecting overflow for"
+						   " WRITE control CDB\n");
+				return TCM_INVALID_CDB_FIELD;
+			}
 		}
 		/*
 		 * Reject READ_* or WRITE_* with overflow/underflow for
-- 
1.9.1
