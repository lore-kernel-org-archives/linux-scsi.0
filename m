From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] target: Add missing DATA_SG_IO transport_cmd_get_valid_sectors check
Date: Thu, 11 Aug 2011 01:52:49 +0000
Message-ID: <1313027569-27640-4-git-send-email-nab@linux-iscsi.org>
References: <1313027569-27640-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41714 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab1HKCRk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2011 22:17:40 -0400
In-Reply-To: <1313027569-27640-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the missing transport_cmd_get_valid_sectors() check for
SCF_SCSI_DATA_SG_IO_CDB type payloads to ensure that a received LBA + range
does not exeed past the end of associated backend struct se_device.

This patch also fixes a bug in the failure path of transport_new_cmd_obj()
where this check can fail, so change to use a signed 'rc' and return '-EINVAL'
to signal proper transport_generic_request_failure() handling.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0abbf08..b12b541 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3893,9 +3893,7 @@ EXPORT_SYMBOL(transport_generic_map_mem_to_cmd);
 static int transport_new_cmd_obj(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	u32 task_cdbs;
-	u32 rc;
-	int set_counts = 1;
+	int set_counts = 1, rc, task_cdbs;
 
 	/*
 	 * Setup any BIDI READ tasks and memory from
@@ -3913,7 +3911,7 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 			cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 			cmd->scsi_sense_reason =
 				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-			return PYX_TRANSPORT_LU_COMM_FAILURE;
+			return -EINVAL;
 		}
 		atomic_inc(&cmd->t_fe_count);
 		atomic_inc(&cmd->t_se_count);
@@ -3932,7 +3930,7 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		cmd->scsi_sense_reason =
 			TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-		return PYX_TRANSPORT_LU_COMM_FAILURE;
+		return -EINVAL;
 	}
 
 	if (set_counts) {
@@ -4250,10 +4248,13 @@ static u32 transport_allocate_tasks(
 	struct scatterlist *sgl,
 	unsigned int sgl_nents)
 {
-	if (cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB)
+	if (cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) {
+		if (transport_cmd_get_valid_sectors(cmd) < 0)
+			return -EINVAL;
+
 		return transport_allocate_data_tasks(cmd, lba, data_direction,
 						     sgl, sgl_nents);
-	else
+	} else
 		return transport_allocate_control_task(cmd);
 
 }
-- 
1.7.2.5

