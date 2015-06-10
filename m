From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 2/9] qla2xxx: Enable target mode for ISP27XX
Date: Wed, 10 Jun 2015 11:05:18 -0400
Message-ID: <1433948725-4073-3-git-send-email-himanshu.madhani@qlogic.com>
References: <1433948725-4073-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:29215 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965998AbbFJPtM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2015 11:49:12 -0400
In-Reply-To: <1433948725-4073-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c   |    2 +-
 drivers/scsi/qla2xxx/qla_def.h    |    8 ++++----
 drivers/scsi/qla2xxx/qla_init.c   |    4 ++--
 drivers/scsi/qla2xxx/qla_mbx.c    |    7 ++++---
 drivers/scsi/qla2xxx/qla_os.c     |    1 +
 drivers/scsi/qla2xxx/qla_sup.c    |    2 +-
 drivers/scsi/qla2xxx/qla_target.c |    2 +-
 7 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 82b92c4..437254e 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -738,7 +738,7 @@ qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
 		ql_log(ql_log_info, vha, 0x706f,
 		    "Issuing MPI reset.\n");
 
-		if (IS_QLA83XX(ha)) {
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
 			uint32_t idc_control;
 
 			qla83xx_idc_lock(vha, 0);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index e86201d..787f901 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3154,13 +3154,13 @@ struct qla_hw_data {
 /* Bit 21 of fw_attributes decides the MCTP capabilities */
 #define IS_MCTP_CAPABLE(ha)	(IS_QLA2031(ha) && \
 				((ha)->fw_attributes_ext[0] & BIT_0))
-#define IS_PI_UNINIT_CAPABLE(ha)	(IS_QLA83XX(ha))
-#define IS_PI_IPGUARD_CAPABLE(ha)	(IS_QLA83XX(ha))
+#define IS_PI_UNINIT_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha))
+#define IS_PI_IPGUARD_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha))
 #define IS_PI_DIFB_DIX0_CAPABLE(ha)	(0)
-#define IS_PI_SPLIT_DET_CAPABLE_HBA(ha)	(IS_QLA83XX(ha))
+#define IS_PI_SPLIT_DET_CAPABLE_HBA(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha))
 #define IS_PI_SPLIT_DET_CAPABLE(ha)	(IS_PI_SPLIT_DET_CAPABLE_HBA(ha) && \
     (((ha)->fw_attributes_h << 16 | (ha)->fw_attributes) & BIT_22))
-#define IS_ATIO_MSIX_CAPABLE(ha) (IS_QLA83XX(ha))
+#define IS_ATIO_MSIX_CAPABLE(ha) (IS_QLA83XX(ha) || IS_QLA27XX(ha))
 #define IS_TGT_MODE_CAPABLE(ha)	(ha->tgt.atio_q_length)
 #define IS_SHADOW_REG_CAPABLE(ha)  (IS_QLA27XX(ha))
 #define IS_DPORT_CAPABLE(ha)  (IS_QLA83XX(ha) || IS_QLA27XX(ha))
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3c1550a..6e6cce8 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1538,7 +1538,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		mem_size = (ha->fw_memory_size - 0x11000 + 1) *
 		    sizeof(uint16_t);
 	} else if (IS_FWI2_CAPABLE(ha)) {
-		if (IS_QLA83XX(ha))
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha))
 			fixed_size = offsetof(struct qla83xx_fw_dump, ext_mem);
 		else if (IS_QLA81XX(ha))
 			fixed_size = offsetof(struct qla81xx_fw_dump, ext_mem);
@@ -1550,7 +1550,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		mem_size = (ha->fw_memory_size - 0x100000 + 1) *
 		    sizeof(uint32_t);
 		if (ha->mqenable) {
-			if (!IS_QLA83XX(ha))
+			if (!IS_QLA83XX(ha) && !IS_QLA27XX(ha))
 				mq_size = sizeof(struct qla2xxx_mq_chain);
 			/*
 			 * Allocate maximum buffer size for all queues.
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 02b1c1c..b2f713a 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2415,7 +2415,8 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *vha, uint16_t *cur_xchg_cnt,
 			*orig_iocb_cnt = mcp->mb[10];
 		if (vha->hw->flags.npiv_supported && max_npiv_vports)
 			*max_npiv_vports = mcp->mb[11];
-		if ((IS_QLA81XX(vha->hw) || IS_QLA83XX(vha->hw)) && max_fcfs)
+		if ((IS_QLA81XX(vha->hw) || IS_QLA83XX(vha->hw) ||
+		    IS_QLA27XX(vha->hw)) && max_fcfs)
 			*max_fcfs = mcp->mb[12];
 	}
 
@@ -3898,7 +3899,7 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	if (!(rsp->options & BIT_0)) {
 		WRT_REG_DWORD(rsp->rsp_q_out, 0);
-		if (!IS_QLA83XX(ha))
+		if (!IS_QLA83XX(ha) && !IS_QLA27XX(ha))
 			WRT_REG_DWORD(rsp->rsp_q_in, 0);
 	}
 
@@ -5345,7 +5346,7 @@ qla83xx_restart_nic_firmware(scsi_qla_host_t *vha)
 	mbx_cmd_t *mcp = &mc;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!IS_QLA83XX(ha))
+	if (!IS_QLA83XX(ha) && !IS_QLA27XX(ha))
 		return QLA_FUNCTION_FAILED;
 
 	ql_dbg(ql_dbg_mbx, vha, 0x1143, "Entered %s.\n", __func__);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7462dd7..ee9a5ca 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2504,6 +2504,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
 		req_length = REQUEST_ENTRY_CNT_24XX;
 		rsp_length = RESPONSE_ENTRY_CNT_2300;
+		ha->tgt.atio_q_length = ATIO_ENTRY_CNT_24XX;
 		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
 		ha->init_cb_size = sizeof(struct mid_init_cb_81xx);
 		ha->gid_list_info_size = 8;
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 028e8c8..2feb5f3 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1697,7 +1697,7 @@ qla83xx_select_led_port(struct qla_hw_data *ha)
 {
 	uint32_t led_select_value = 0;
 
-	if (!IS_QLA83XX(ha))
+	if (!IS_QLA83XX(ha) && !IS_QLA27XX(ha))
 		goto out;
 
 	if (ha->port_no == 0)
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index ed39ed2..c70754b 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5791,7 +5791,7 @@ qlt_probe_one_stage1(struct scsi_qla_host *base_vha, struct qla_hw_data *ha)
 	if (!QLA_TGT_MODE_ENABLED())
 		return;
 
-	if  (ha->mqenable || IS_QLA83XX(ha)) {
+	if  (ha->mqenable || IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
 		ISP_ATIO_Q_IN(base_vha) = &ha->mqiobase->isp25mq.atio_q_in;
 		ISP_ATIO_Q_OUT(base_vha) = &ha->mqiobase->isp25mq.atio_q_out;
 	} else {
-- 
1.7.7

