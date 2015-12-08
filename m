From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 15/20] qla2xxx: Add selective command queuing
Date: Mon, 7 Dec 2015 19:49:02 -0500
Message-ID: <1449535747-2850-16-git-send-email-himanshu.madhani@qlogic.com>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:28235 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932590AbbLHB3d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2015 20:29:33 -0500
In-Reply-To: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com

From: Quinn Tran <quinn.tran@qlogic.com>

queue work element to specific process lessen cache miss

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c         |    2 +-
 drivers/scsi/qla2xxx/qla_target.c      |   13 ++++++++++++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |    4 ++--
 drivers/target/target_core_transport.c |    5 ++++-
 include/target/target_core_base.h      |    1 +
 5 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e879802d..26fa4d8 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3302,7 +3302,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *notify,
 	}
 }
 
-void qla_irq_affinity_release(struct kref *ref)
+static void qla_irq_affinity_release(struct kref *ref)
 {
 	struct irq_affinity_notify *notify =
 		container_of(ref, struct irq_affinity_notify, kref);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index dc6ac4e..b33c018 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4004,13 +4004,24 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 
 	cmd->cmd_in_wq = 1;
 	cmd->cmd_flags |= BIT_0;
+	cmd->se_cmd.cpuid = -1;
 
 	spin_lock(&vha->cmd_list_lock);
 	list_add_tail(&cmd->cmd_list, &vha->qla_cmd_list);
 	spin_unlock(&vha->cmd_list_lock);
 
 	INIT_WORK(&cmd->work, qlt_do_work);
-	queue_work(qla_tgt_wq, &cmd->work);
+	if (ha->msix_count) {
+		cmd->se_cmd.cpuid = ha->tgt.rspq_vector_cpuid;
+		if (cmd->atio.u.isp24.fcp_cmnd.rddata)
+			queue_work_on(smp_processor_id(), qla_tgt_wq,
+			    &cmd->work);
+		else
+			queue_work_on(cmd->se_cmd.cpuid, qla_tgt_wq,
+			    &cmd->work);
+	} else {
+		queue_work(qla_tgt_wq, &cmd->work);
+	}
 	return 0;
 
 }
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 833dec2..d7a34d1 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -303,7 +303,7 @@ static void tcm_qla2xxx_free_cmd(struct qla_tgt_cmd *cmd)
 	cmd->cmd_flags |= BIT_20;
 
 	INIT_WORK(&cmd->work, tcm_qla2xxx_complete_free);
-	queue_work(tcm_qla2xxx_free_wq, &cmd->work);
+	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
 }
 
 /*
@@ -535,7 +535,7 @@ static void tcm_qla2xxx_handle_data(struct qla_tgt_cmd *cmd)
 	cmd->cmd_flags |= BIT_10;
 	cmd->cmd_in_wq = 1;
 	INIT_WORK(&cmd->work, tcm_qla2xxx_handle_data_work);
-	queue_work(tcm_qla2xxx_free_wq, &cmd->work);
+	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
 }
 
 static void tcm_qla2xxx_handle_dif_work(struct work_struct *work)
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index cdd18bf..a37db6d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -720,7 +720,10 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 	cmd->transport_state |= (CMD_T_COMPLETE | CMD_T_ACTIVE);
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-	queue_work(target_completion_wq, &cmd->work);
+	if (cmd->cpuid == -1)
+		queue_work(target_completion_wq, &cmd->work);
+	else
+		queue_work_on(cmd->cpuid, target_completion_wq, &cmd->work);
 }
 EXPORT_SYMBOL(target_complete_cmd);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index efccd71..ce26a3a 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -527,6 +527,7 @@ struct se_cmd {
 	unsigned int		t_prot_nents;
 	sense_reason_t		pi_err;
 	sector_t		bad_sector;
+	int cpuid;
 };
 
 struct se_ua {
-- 
1.7.7

