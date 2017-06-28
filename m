From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 4/5] target: user: Fix sense data handling
Date: Wed, 28 Jun 2017 14:58:59 +0900
Message-ID: <20170628055900.22889-5-damien.lemoal@wdc.com>
References: <20170628055900.22889-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:26441 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751685AbdF1F7t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2017 01:59:49 -0400
In-Reply-To: <20170628055900.22889-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A . Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>

If the user request handler completed the request with a CHECK CONDITION
status, tcmu_handle_completion() copies the command entry sense data
into the session request structure sense data. However, the sense data
length indicated by the field scsi_sense_length is not set and equal to
0, resulting in the copy being a no-op and failure to propagate the
sense data back to the initiator. To fix this, properly set the session
command sense data length and also set the session command
SCF_TRANSPORT_TASK_SENSE flag to indicate that the command has valid
sense data.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/target/target_core_user.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index beb5f09..7426b4c 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -831,7 +831,9 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 		entry->rsp.scsi_status = SAM_STAT_CHECK_CONDITION;
 	} else if (entry->rsp.scsi_status == SAM_STAT_CHECK_CONDITION) {
 		memcpy(se_cmd->sense_buffer, entry->rsp.sense_buffer,
-			       se_cmd->scsi_sense_length);
+		       TRANSPORT_SENSE_BUFFER);
+		se_cmd->scsi_sense_length = TRANSPORT_SENSE_BUFFER;
+		se_cmd->se_cmd_flags |= SCF_TRANSPORT_TASK_SENSE;
 	} else if (se_cmd->se_cmd_flags & SCF_BIDI) {
 		/* Get Data-In buffer before clean up */
 		gather_data_area(udev, cmd, true);
-- 
2.9.4
