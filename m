From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 19/19] target: return SAM_STAT_TASK_SET_FULL for TCM_OUT_OF_RESOURCES
Date: Sun, 29 Oct 2017 22:44:39 -0500
Message-ID: <1509335079-5276-20-git-send-email-mchristi@redhat.com>
References: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56232 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751730AbdJ3DpK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 29 Oct 2017 23:45:10 -0400
In-Reply-To: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Mike Christie <mchristi@redhat.com>

TCM_OUT_OF_RESOURCES is getting translated to
TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE which seems like a heavy
error when we just cannot allocate a resource that may be
allocatable later. This has us translate TCM_OUT_OF_RESOURCES
to SAM_STAT_TASK_SET_FULL instead.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_transport.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 836d552..a3b264b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1772,8 +1772,8 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	case TCM_UNSUPPORTED_SEGMENT_DESC_TYPE_CODE:
 		break;
 	case TCM_OUT_OF_RESOURCES:
-		sense_reason = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-		break;
+		cmd->scsi_status = SAM_STAT_TASK_SET_FULL;
+		goto queue_status;
 	case TCM_RESERVATION_CONFLICT:
 		/*
 		 * No SENSE Data payload for this case, set SCSI Status
@@ -1795,11 +1795,8 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 					       cmd->orig_fe_lun, 0x2C,
 					ASCQ_2CH_PREVIOUS_RESERVATION_CONFLICT_STATUS);
 		}
-		trace_target_cmd_complete(cmd);
-		ret = cmd->se_tfo->queue_status(cmd);
-		if (ret)
-			goto queue_full;
-		goto check_stop;
+
+		goto queue_status;
 	default:
 		pr_err("Unknown transport error for CDB 0x%02x: %d\n",
 			cmd->t_task_cdb[0], sense_reason);
@@ -1816,6 +1813,11 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	transport_cmd_check_stop_to_fabric(cmd);
 	return;
 
+queue_status:
+	trace_target_cmd_complete(cmd);
+	ret = cmd->se_tfo->queue_status(cmd);
+	if (!ret)
+		goto check_stop;
 queue_full:
 	transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
 }
-- 
1.8.3.1
