From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 1/2] target/transport: add flag to indicate CPU Affinity is observed
Date: Wed, 10 Feb 2016 18:59:13 -0500
Message-ID: <1455148754-17330-2-git-send-email-himanshu.madhani@qlogic.com>
References: <1455148754-17330-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1455148754-17330-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@qlogic.com>

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Fixes: fb3269b ("qla2xxx: Add selective command queuing")
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/target/target_core_transport.c |   12 +++++++++---
 include/target/target_core_base.h      |    2 ++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3e6a98b..6348ae0 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -776,10 +776,10 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 	cmd->transport_state |= (CMD_T_COMPLETE | CMD_T_ACTIVE);
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-	if (cmd->cpuid == -1)
-		queue_work(target_completion_wq, &cmd->work);
-	else
+	if (cmd->se_cmd_flags & SCF_USE_CPUID)
 		queue_work_on(cmd->cpuid, target_completion_wq, &cmd->work);
+	else
+		queue_work(target_completion_wq, &cmd->work);
 }
 EXPORT_SYMBOL(target_complete_cmd);
 
@@ -1491,6 +1491,12 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	 */
 	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
 				data_length, data_dir, task_attr, sense);
+
+	if (flags & TARGET_SCF_USE_CPUID)
+		se_cmd->se_cmd_flags |= SCF_USE_CPUID;
+	else
+		se_cmd->cpuid = WORK_CPU_UNBOUND;
+
 	if (flags & TARGET_SCF_UNKNOWN_SIZE)
 		se_cmd->unknown_data_length = 1;
 	/*
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index d71a3ea..e8c8c08 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -141,6 +141,7 @@ enum se_cmd_flags_table {
 	SCF_COMPARE_AND_WRITE_POST	= 0x00100000,
 	SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC = 0x00200000,
 	SCF_ACK_KREF			= 0x00400000,
+	SCF_USE_CPUID			= 0x00800000,
 };
 
 /* struct se_dev_entry->lun_flags and struct se_lun->lun_access */
@@ -188,6 +189,7 @@ enum target_sc_flags_table {
 	TARGET_SCF_BIDI_OP		= 0x01,
 	TARGET_SCF_ACK_KREF		= 0x02,
 	TARGET_SCF_UNKNOWN_SIZE		= 0x04,
+	TARGET_SCF_USE_CPUID	= 0x08,
 };
 
 /* fabric independent task management function values */
-- 
1.7.7
