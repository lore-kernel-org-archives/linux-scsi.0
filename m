From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2 11/16] qla2xxx: Add selective command queuing
Date: Tue, 29 Dec 2015 10:32:03 +0100
Message-ID: <56825313.4080405@sandisk.com>
References: <1450382231-4259-1-git-send-email-himanshu.madhani@qlogic.com>
 <1450382231-4259-12-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0055.outbound.protection.outlook.com ([207.46.100.55]:32867
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752706AbbL2JcK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Dec 2015 04:32:10 -0500
In-Reply-To: <1450382231-4259-12-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 12/17/2015 08:57 PM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@qlogic.com>
> 
> queue work element to specific process lessen cache miss

How about replacing this patch by something like the (untested) patch
below ? The advantage of the patch below is that it doesn't require to
modify other target driver to keep their current behavior.

Thanks,

Bart.

---
 drivers/scsi/qla2xxx/qla_target.c      | 5 ++++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     | 2 +-
 drivers/target/target_core_transport.c | 4 +++-
 include/target/target_core_base.h      | 2 ++
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 83214fc..1bd1511 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3982,13 +3982,16 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 
 	cmd->cmd_in_wq = 1;
 	cmd->cmd_flags |= BIT_0;
+	cmd->se_cmd.cpuid = (ha->msix_count &&
+			     !cmd->atio.u.isp24.fcp_cmnd.rddata) ?
+		ha->tgt.rspq_vector_cpuid : WORK_CPU_UNBOUND;
 
 	spin_lock(&vha->cmd_list_lock);
 	list_add_tail(&cmd->cmd_list, &vha->qla_cmd_list);
 	spin_unlock(&vha->cmd_list_lock);
 
 	INIT_WORK(&cmd->work, qlt_do_work);
-	queue_work(qla_tgt_wq, &cmd->work);
+	queue_work_on(cmd->se_cmd.cpuid, qla_tgt_wq, &cmd->work);
 	return 0;
 
 }
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index a6fd02a..e65ba34 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -419,7 +419,7 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct se_session *se_sess;
 	struct qla_tgt_sess *sess;
-	int flags = TARGET_SCF_ACK_KREF;
+	int flags = TARGET_SCF_ACK_KREF | TARGET_SCF_USE_CPUID;
 
 	if (bidi)
 		flags |= TARGET_SCF_BIDI_OP;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a8e21fb..3b1a002 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -681,7 +681,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 	cmd->transport_state |= CMD_T_COMPLETE;
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-	queue_work(target_completion_wq, &cmd->work);
+	queue_work_on(cmd->cpuid, target_completion_wq, &cmd->work);
 }
 EXPORT_SYMBOL(target_complete_cmd);
 
@@ -1390,6 +1390,8 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	 */
 	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
 				data_length, data_dir, task_attr, sense);
+	if (!(flags & TARGET_SCF_USE_CPUID))
+		se_cmd->cpuid = WORK_CPU_UNBOUND;
 	if (flags & TARGET_SCF_UNKNOWN_SIZE)
 		se_cmd->unknown_data_length = 1;
 	/*
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index e9e507a..38a1871 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -186,6 +186,7 @@ enum target_sc_flags_table {
 	TARGET_SCF_BIDI_OP		= 0x01,
 	TARGET_SCF_ACK_KREF		= 0x02,
 	TARGET_SCF_UNKNOWN_SIZE		= 0x04,
+	TARGET_SCF_USE_CPUID		= 0x08,
 };
 
 /* fabric independent task management function values */
@@ -519,6 +520,7 @@ struct se_cmd {
 	unsigned int		t_prot_nents;
 	sense_reason_t		pi_err;
 	sector_t		bad_sector;
+	int			cpuid;
 };
 
 struct se_ua {
-- 
2.1.4

