From: Michael Cyr <mikecyr@us.ibm.com>
Subject: [PATCH] Return TCMU-generated sense data to fabric module
Date: Fri, 26 Aug 2016 14:52:51 -0500
Message-ID: <1472241171-1269-1-git-send-email-mikecyr@us.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49895 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751014AbcHZTxe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 15:53:34 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7QJrRjv009137
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2016 15:53:34 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0a-001b2d01.pphosted.com with ESMTP id 252b0dw2b3-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2016 15:53:34 -0400
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mikecyr@us.ibm.com>;
        Fri, 26 Aug 2016 13:53:33 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, joe@perches.com
Cc: hch@infradead.org, bryantly@linux.vnet.ibm.com, agrover@redhat.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com, Michael Cyr <mikecyr@us.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>

If an error status is passed to target_complete_cmd, then by default it
queues the command to target_complete_failure_work, which will generate
Logical Unit Communication Failure sense data, overwriting any sense data
already set in the command.  This means that any sense data returned by
TCMU does not get returned to the fabric module.

This change implements a transport_complete function for target-user which
will set the SCF_TRANSPORT_TASK_SENSE flag if we have valid sense data,
which will cause target_complete_cmd to queue the command to
target_complete_ok_work instead of target_complete_failure_work.

Signed-off-by: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Reviewed-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_user.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 62bf4fe..81ab42e 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -158,6 +158,14 @@ static struct genl_family tcmu_genl_family = {
 	.netnsok = true,
 };
 
+/* Sense Key = 2 (Not Ready)
+ * ASC/ASCQ = 0x0800 (Logical Unit Communication Failure)
+ */
+static const char lu_comm_failure_sense[18] = {
+	0x70, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x0a,
+	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00,
+	0x00, 0x00 };
+
 static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 {
 	struct se_device *se_dev = se_cmd->se_dev;
@@ -574,9 +582,11 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 		pr_warn("TCMU: Userspace set UNKNOWN_OP flag on se_cmd %p\n",
 			cmd->se_cmd);
 		entry->rsp.scsi_status = SAM_STAT_CHECK_CONDITION;
+		memcpy(se_cmd->sense_buffer, lu_comm_failure_sense,
+		       sizeof(lu_comm_failure_sense));
 	} else if (entry->rsp.scsi_status == SAM_STAT_CHECK_CONDITION) {
 		memcpy(se_cmd->sense_buffer, entry->rsp.sense_buffer,
-			       se_cmd->scsi_sense_length);
+			       TRANSPORT_SENSE_BUFFER);
 		free_data_area(udev, cmd);
 	} else if (se_cmd->se_cmd_flags & SCF_BIDI) {
 		DECLARE_BITMAP(bitmap, DATA_BLOCK_BITS);
@@ -679,6 +689,8 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
 		return 0;
 
 	set_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
+	memcpy(cmd->se_cmd->sense_buffer, lu_comm_failure_sense,
+	       sizeof(lu_comm_failure_sense));
 	target_complete_cmd(cmd->se_cmd, SAM_STAT_CHECK_CONDITION);
 	cmd->se_cmd = NULL;
 
@@ -1145,6 +1157,17 @@ tcmu_parse_cdb(struct se_cmd *cmd)
 	return passthrough_parse_cdb(cmd, tcmu_pass_op);
 }
 
+static void tcmu_transport_complete(struct se_cmd *cmd, struct scatterlist *sg,
+				    unsigned char *sense_buffer)
+{
+	if (cmd->scsi_status == SAM_STAT_CHECK_CONDITION)
+		/* Setting this flag will prevent target_complete_cmd from
+		 * calling target_complete_failure_work, which would overwrite
+		 * the sense data we already set.
+		 */
+		cmd->se_cmd_flags |= SCF_TRANSPORT_TASK_SENSE;
+}
+
 static const struct target_backend_ops tcmu_ops = {
 	.name			= "user",
 	.owner			= THIS_MODULE,
@@ -1155,6 +1178,7 @@ static const struct target_backend_ops tcmu_ops = {
 	.configure_device	= tcmu_configure_device,
 	.free_device		= tcmu_free_device,
 	.parse_cdb		= tcmu_parse_cdb,
+	.transport_complete	= tcmu_transport_complete,
 	.set_configfs_dev_params = tcmu_set_configfs_dev_params,
 	.show_configfs_dev_params = tcmu_show_configfs_dev_params,
 	.get_device_type	= sbc_get_device_type,
-- 
2.5.0

