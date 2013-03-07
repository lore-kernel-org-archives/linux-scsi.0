From: vikas.chaudhary@qlogic.com
Subject: [PATCH 7/8] qla4xxx: Fixed request queue count manipulation on response path
Date: Thu,  7 Mar 2013 05:43:13 -0500
Message-ID: <1362652994-7593-8-git-send-email-vikas.chaudhary@qlogic.com>
References: <1362652994-7593-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:49777 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756387Ab3CGLFW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Mar 2013 06:05:22 -0500
In-Reply-To: <1362652994-7593-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>, Shyam Sundar <shyam.sundar@qlogic.com>

From: Tej Parkash <tej.parkash@qlogic.com>

Issue:
Request queue count holds the information about free space in request queue
which has to be manipulated based on request in and out pointer.
But in driver response path, this count was incremented unconditionally,
which could move req_in pointer beyond req_out pointer.
This scenario leads fw hang during IO.

Solution:
Request queue count manipulation has to be done in IO path only, keeping
req_in and req_out pointer two IOCB count away

Signed-off-by: Tej Parkash <tej.parkash@qlogic.com>
Signed-off-by: Shyam Sundar <shyam.sundar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_glbl.h |  2 --
 drivers/scsi/qla4xxx/ql4_isr.c  |  2 --
 drivers/scsi/qla4xxx/ql4_os.c   | 15 ++-------------
 3 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 982293e..22706f6 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -224,8 +224,6 @@ void qla4_83xx_interrupt_service_routine(struct scsi_qla_host *ha,
 int qla4_83xx_isp_reset(struct scsi_qla_host *ha);
 void qla4_83xx_queue_iocb(struct scsi_qla_host *ha);
 void qla4_83xx_complete_iocb(struct scsi_qla_host *ha);
-uint16_t qla4_83xx_rd_shdw_req_q_out(struct scsi_qla_host *ha);
-uint16_t qla4_83xx_rd_shdw_rsp_q_in(struct scsi_qla_host *ha);
 uint32_t qla4_83xx_rd_reg(struct scsi_qla_host *ha, ulong addr);
 void qla4_83xx_wr_reg(struct scsi_qla_host *ha, ulong addr, uint32_t val);
 int qla4_83xx_rd_reg_indirect(struct scsi_qla_host *ha, uint32_t addr,
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index e02a884..7bef448 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -396,7 +396,6 @@ static void qla4xxx_passthru_status_entry(struct scsi_qla_host *ha,
 
 	task_data = task->dd_data;
 	memcpy(&task_data->sts, sts_entry, sizeof(struct passthru_status));
-	ha->req_q_count += task_data->iocb_req_cnt;
 	ha->iocb_cnt -= task_data->iocb_req_cnt;
 	queue_work(ha->task_wq, &task_data->task_work);
 }
@@ -416,7 +415,6 @@ static struct mrb *qla4xxx_del_mrb_from_active_array(struct scsi_qla_host *ha,
 		return mrb;
 
 	/* update counters */
-	ha->req_q_count += mrb->iocb_cnt;
 	ha->iocb_cnt -= mrb->iocb_cnt;
 
 	return mrb;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ade1ba6..a6ce04d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3751,8 +3751,8 @@ static struct isp_operations qla4_83xx_isp_ops = {
 	.reset_firmware		= qla4_8xxx_stop_firmware,
 	.queue_iocb		= qla4_83xx_queue_iocb,
 	.complete_iocb		= qla4_83xx_complete_iocb,
-	.rd_shdw_req_q_out	= qla4_83xx_rd_shdw_req_q_out,
-	.rd_shdw_rsp_q_in	= qla4_83xx_rd_shdw_rsp_q_in,
+	.rd_shdw_req_q_out	= qla4xxx_rd_shdw_req_q_out,
+	.rd_shdw_rsp_q_in	= qla4xxx_rd_shdw_rsp_q_in,
 	.get_sys_info		= qla4_8xxx_get_sys_info,
 	.rd_reg_direct		= qla4_83xx_rd_reg,
 	.wr_reg_direct		= qla4_83xx_wr_reg,
@@ -3775,11 +3775,6 @@ uint16_t qla4_82xx_rd_shdw_req_q_out(struct scsi_qla_host *ha)
 	return (uint16_t)le32_to_cpu(readl(&ha->qla4_82xx_reg->req_q_out));
 }
 
-uint16_t qla4_83xx_rd_shdw_req_q_out(struct scsi_qla_host *ha)
-{
-	return (uint16_t)le32_to_cpu(readl(&ha->qla4_83xx_reg->req_q_out));
-}
-
 uint16_t qla4xxx_rd_shdw_rsp_q_in(struct scsi_qla_host *ha)
 {
 	return (uint16_t)le32_to_cpu(ha->shadow_regs->rsp_q_in);
@@ -3790,11 +3785,6 @@ uint16_t qla4_82xx_rd_shdw_rsp_q_in(struct scsi_qla_host *ha)
 	return (uint16_t)le32_to_cpu(readl(&ha->qla4_82xx_reg->rsp_q_in));
 }
 
-uint16_t qla4_83xx_rd_shdw_rsp_q_in(struct scsi_qla_host *ha)
-{
-	return (uint16_t)le32_to_cpu(readl(&ha->qla4_83xx_reg->rsp_q_in));
-}
-
 static ssize_t qla4xxx_show_boot_eth_info(void *data, int type, char *buf)
 {
 	struct scsi_qla_host *ha = data;
@@ -5683,7 +5673,6 @@ struct srb *qla4xxx_del_from_active_array(struct scsi_qla_host *ha,
 
 	/* update counters */
 	if (srb->flags & SRB_DMA_VALID) {
-		ha->req_q_count += srb->iocb_cnt;
 		ha->iocb_cnt -= srb->iocb_cnt;
 		if (srb->cmd)
 			srb->cmd->host_scribble =
-- 
1.8.0

