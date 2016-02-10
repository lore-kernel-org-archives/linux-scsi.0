From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 2/2] qla2xxx: use TARGET_SCF_USE_CPUID flag to indiate CPU Affinity
Date: Wed, 10 Feb 2016 18:59:14 -0500
Message-ID: <1455148754-17330-3-git-send-email-himanshu.madhani@qlogic.com>
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
 drivers/scsi/qla2xxx/qla_target.c  |    4 ++--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 49a421a..9852319 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4013,7 +4013,8 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 
 	cmd->cmd_in_wq = 1;
 	cmd->cmd_flags |= BIT_0;
-	cmd->se_cmd.cpuid = -1;
+	cmd->se_cmd.cpuid = ha->msix_count ?
+		ha->tgt.rspq_vector_cpuid : WORK_CPU_UNBOUND;
 
 	spin_lock(&vha->cmd_list_lock);
 	list_add_tail(&cmd->cmd_list, &vha->qla_cmd_list);
@@ -4021,7 +4022,6 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 
 	INIT_WORK(&cmd->work, qlt_do_work);
 	if (ha->msix_count) {
-		cmd->se_cmd.cpuid = ha->tgt.rspq_vector_cpuid;
 		if (cmd->atio.u.isp24.fcp_cmnd.rddata)
 			queue_work_on(smp_processor_id(), qla_tgt_wq,
 			    &cmd->work);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7c8e255..c1461d2 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -462,6 +462,9 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 	if (bidi)
 		flags |= TARGET_SCF_BIDI_OP;
 
+	if (se_cmd->cpuid != WORK_CPU_UNBOUND)
+		flags |= TARGET_SCF_USE_CPUID;
+
 	sess = cmd->sess;
 	if (!sess) {
 		pr_err("Unable to locate struct qla_tgt_sess from qla_tgt_cmd\n");
-- 
1.7.7
