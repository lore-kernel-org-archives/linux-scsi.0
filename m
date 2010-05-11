From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 1/7] qla4xxx: added BSG support
Date: Tue, 11 May 2010 13:25:26 +0530
Message-ID: <20100511075526.GA30474@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:38639
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1755143Ab0EKH70 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 May 2010 03:59:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com

This BSG interface is on top of patch :
http://marc.info/?l=linux-scsi&m=126884917217355&w=2

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |   45 +++++++
 drivers/scsi/qla4xxx/ql4_glbl.h |   18 +++
 drivers/scsi/qla4xxx/ql4_mbx.c  |  266 ++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla4xxx/ql4_os.c   |  219 ++++++++++++++++++++++++++++++++
 4 files changed, 547 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 4288026..527a7ae 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -471,6 +471,51 @@ struct scsi_qla_host {
 	struct in6_addr ipv6_default_router_addr;
 };
 
+struct qla4xxx_dma_mem {
+	void *va;
+	dma_addr_t dma;
+	uint32_t size;
+	uint32_t req_sg_cnt;
+	uint32_t rsp_sg_cnt;
+};
+
+struct qla4xxx_bsg_cmd {
+	uint32_t opcode;
+	uint32_t subcode;
+	uint32_t instance;
+	uint32_t data_size;
+	uint32_t offset;
+	uint32_t option0;
+	uint32_t option1;
+	uint32_t option2;
+	uint32_t option3;
+};
+
+enum ql4_vendor_priv_cmd {
+	QL4_GET_DATA,
+	QL4_SET_DATA,
+	QL4_RESTORE_FACTORY_DEF,
+	QL4_DISABLE_ACB,
+};
+
+enum ql4_get_data_cmd {
+	QL4_GET_FLASH,
+	QL4_GET_DDB_DEF,
+	QL4_GET_DDB,
+	QL4_GET_IFCB_DEF,
+	QL4_GET_IFCB,
+	QL4_GET_ACB,
+	QL4_GET_ISCSI_STAT,
+};
+
+enum ql4_set_data_cmd {
+	QL4_SET_FLASH,
+	QL4_SET_DDB,
+	QL4_SET_IFCB,
+	QL4_SET_ACB,
+	QL4_RESET_ISCSI_STAT,
+};
+
 static inline int is_ipv4_enabled(struct scsi_qla_host *ha)
 {
 	return ((ha->ipv4_options & IPOPT_IPv4_PROTOCOL_ENABLE) != 0);
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index c4636f6..c1af9d6 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -35,6 +35,24 @@ int qla4xxx_get_flash(struct scsi_qla_host * ha, dma_addr_t dma_addr,
 int qla4xxx_get_firmware_status(struct scsi_qla_host * ha);
 int qla4xxx_get_firmware_state(struct scsi_qla_host * ha);
 int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha);
+int qla4xxx_get_default_ddb(struct scsi_qla_host *ha,
+		dma_addr_t dma_addr);
+int qla4xxx_bsg_get_ifcb(struct scsi_qla_host *ha, dma_addr_t data_dma,
+		uint32_t sub_cmd);
+int qla4xxx_get_acb(struct scsi_qla_host *ha, dma_addr_t data_dma,
+		uint32_t instance, uint32_t data_len);
+int qla4xxx_get_iscsi_stat(struct scsi_qla_host *ha, uint32_t device_index,
+		dma_addr_t data_dma);
+int qla4xxx_set_flash(struct scsi_qla_host *ha, dma_addr_t dma_addr,
+		uint32_t offset, uint32_t option, uint32_t data_len);
+int qla4xxx_bsg_set_ifcb(struct scsi_qla_host *ha, dma_addr_t data_dma);
+int qla4xxx_set_acb(struct scsi_qla_host *ha, dma_addr_t data_dma,
+		uint32_t instance, uint32_t acb_len);
+int qla4xxx_reset_iscsi_stat(struct scsi_qla_host *ha, uint32_t device_index);
+int qla4xxx_restore_factory_defaults(struct iscsi_bsg_job *job,
+		struct qla4xxx_bsg_cmd *qla4xxx_cmd);
+int qla4xxx_disable_acb(struct iscsi_bsg_job *bsg_job,
+		struct qla4xxx_bsg_cmd *qla4xxx_cmd);
 
 /* FIXME: Goodness!  this really wants a small struct to hold the
  * parameters. On x86 the args will get passed on the stack! */
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index e1315cd..12f2e0c 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -954,7 +954,7 @@ int qla4xxx_get_fw_version(struct scsi_qla_host * ha)
 	return QLA_SUCCESS;
 }
 
-static int qla4xxx_get_default_ddb(struct scsi_qla_host *ha,
+int qla4xxx_get_default_ddb(struct scsi_qla_host *ha,
 				   dma_addr_t dma_addr)
 {
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
@@ -1056,3 +1056,267 @@ qla4xxx_send_tgts_exit:
 	return ret_val;
 }
 
+int qla4xxx_bsg_get_ifcb(struct scsi_qla_host *ha, dma_addr_t data_dma,
+    uint32_t sub_cmd)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	switch (sub_cmd) {
+	case QL4_GET_IFCB_DEF:
+		mbox_cmd[0] = MBOX_CMD_GET_INIT_FW_CTRL_BLOCK_DEFAULTS;
+		break;
+	case QL4_GET_IFCB:
+		mbox_cmd[0] = MBOX_CMD_GET_INIT_FW_CTRL_BLOCK;
+		break;
+	}
+
+	mbox_cmd[2] = LSDW(data_dma);
+	mbox_cmd[3] = MSDW(data_dma);
+	mbox_cmd[4] = sizeof(struct init_fw_ctrl_blk);
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0],
+	    &mbox_sts[0]) != QLA_SUCCESS) {
+		printk("scsi%ld: %s: "
+		    "Failed to get init_fw_ctrl_blk, staus: %04X\n",
+		    ha->host_no, __func__, mbox_sts[0]);
+		return QLA_ERROR;
+	}
+	return QLA_SUCCESS;
+}
+
+int qla4xxx_get_acb(struct scsi_qla_host *ha, dma_addr_t data_dma,
+    uint32_t instance, uint32_t data_len)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_GET_ACB;
+	mbox_cmd[1] = instance;  /* Primary/Secondary */
+	mbox_cmd[2] = LSDW(data_dma);
+	mbox_cmd[3] = MSDW(data_dma);
+	mbox_cmd[4] = data_len;
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0],
+	    &mbox_sts[0]) != QLA_SUCCESS) {
+		printk("scsi%ld: %s: "
+		    "Failed to get acb, staus: %04X\n",
+		    ha->host_no, __func__, mbox_sts[0]);
+		return QLA_ERROR;
+	}
+	return QLA_SUCCESS;
+}
+
+int qla4xxx_get_iscsi_stat(struct scsi_qla_host *ha, uint32_t device_index,
+    dma_addr_t data_dma)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_GET_MANAGEMENT_DATA;
+	mbox_cmd[1] = device_index;
+	mbox_cmd[2] = LSDW(data_dma);
+	mbox_cmd[3] = MSDW(data_dma);
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0],
+	    &mbox_sts[0]) != QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_GET_MANAGEMENT_DATA,"
+		    " failed w/ status %04X\n",
+		    ha->host_no, __func__, mbox_sts[0]));
+		return QLA_ERROR;
+	}
+
+	return QLA_SUCCESS;
+}
+
+int qla4xxx_set_flash(struct scsi_qla_host *ha, dma_addr_t dma_addr,
+    uint32_t offset, uint32_t option, uint32_t data_len)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_WRITE_FLASH;
+	mbox_cmd[1] = LSDW(dma_addr);
+	mbox_cmd[2] = MSDW(dma_addr);
+	mbox_cmd[3] = offset;
+	mbox_cmd[4] = data_len;
+	mbox_cmd[5] = option;
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0],
+	    &mbox_sts[0]) != QLA_SUCCESS) {
+		printk("scsi%ld: %s: "
+		    "MBOX_CMD_WRITE_FLASH failed w/ status %04X\n",
+		    ha->host_no, __func__, mbox_sts[0]);
+		return QLA_ERROR;
+	}
+
+	return QLA_SUCCESS;
+}
+
+int qla4xxx_bsg_set_ifcb(struct scsi_qla_host *ha, dma_addr_t data_dma)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_INITIALIZE_FIRMWARE;
+	mbox_cmd[1] = 0;
+	mbox_cmd[2] = LSDW(data_dma);
+	mbox_cmd[3] = MSDW(data_dma);
+	mbox_cmd[4] = sizeof(struct init_fw_ctrl_blk);
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 2, &mbox_cmd[0],
+	    &mbox_sts[0]) != QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_INITIALIZE_FIRMWARE,"
+		    " failed w/ status %04X\n",
+		    ha->host_no, __func__, mbox_sts[0]));
+		return QLA_ERROR;
+	}
+
+	return QLA_SUCCESS;
+}
+
+int qla4xxx_set_acb(struct scsi_qla_host *ha, dma_addr_t data_dma,
+		uint32_t instance, uint32_t acb_len)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_SET_ACB;
+	mbox_cmd[1] = instance;
+	mbox_cmd[2] = LSDW(data_dma);
+	mbox_cmd[3] = MSDW(data_dma);
+	mbox_cmd[4] = acb_len;
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 2, &mbox_cmd[0],
+				&mbox_sts[0]) != QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_SET_ACB, failed w/ "
+		    "status %04X\n", ha->host_no, __func__, mbox_sts[0]));
+		return QLA_ERROR;
+	}
+
+	return QLA_SUCCESS;
+}
+
+int qla4xxx_reset_iscsi_stat(struct scsi_qla_host *ha, uint32_t device_index)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_GET_MANAGEMENT_DATA;
+	mbox_cmd[1] = device_index;
+	mbox_cmd[2] = 0;
+	mbox_cmd[3] = 0;
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0],
+	    &mbox_sts[0]) != QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_GET_MANAGEMENT_DATA,"
+		    " failed w/ status %04X\n",
+		    ha->host_no, __func__, mbox_sts[0]));
+		return QLA_ERROR;
+	}
+
+	return QLA_SUCCESS;
+}
+
+/**
+ * qla4xxx_restore_factory_defaults - restore hba factory defaults
+ * @job: iscsi_bsg_job to handle
+ **/
+int qla4xxx_restore_factory_defaults(struct iscsi_bsg_job *bsg_job,
+    struct qla4xxx_bsg_cmd *qla4xxx_cmd)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	struct scsi_qla_host *ha = to_qla_host(bsg_job->shost);
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_RESTORE_FACTORY_DEFAULTS;
+	mbox_cmd[3] = qla4xxx_cmd->option0;
+	mbox_cmd[4] = qla4xxx_cmd->option1;
+	mbox_cmd[5] = qla4xxx_cmd->option2;
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0],
+	    &mbox_sts[0]) != QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_RESTORE_FACTORY_DEFAULTS,"
+		    " failed w/ status %04X\n",
+		    ha->host_no, __func__, mbox_sts[0]));
+		return QLA_ERROR;
+	}
+
+	return QLA_SUCCESS;
+}
+
+int qla4xxx_disable_acb(struct iscsi_bsg_job *bsg_job,
+    struct qla4xxx_bsg_cmd *qla4xxx_cmd)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	struct scsi_qla_host *ha = to_qla_host(bsg_job->shost);
+	int ret = QLA_SUCCESS;
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_DISABLE_ACB;
+	mbox_cmd[1] = qla4xxx_cmd->instance;
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 2, &mbox_cmd[0],
+	    &mbox_sts[0]) != QLA_SUCCESS) {
+		if (mbox_sts[0] == MBOX_STS_INTERMEDIATE_COMPLETION) {
+			unsigned long  wait_cnt;
+
+			wait_cnt = jiffies + (WAIT_CMD_TOV * HZ);
+
+			while (time_before(jiffies, wait_cnt)) {
+				set_current_state(TASK_INTERRUPTIBLE);
+				schedule_timeout(HZ);
+
+				memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+				memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+				mbox_cmd[0] = MBOX_CMD_GET_IP_ADDR_STATE;
+				mbox_cmd[1] = qla4xxx_cmd->instance;
+				/*TODO: check fw specs*/
+
+				if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT,
+				    2, &mbox_cmd[0], &mbox_sts[0]) ==
+				    QLA_SUCCESS) {
+					if (!(mbox_sts[1] & 0xF0000000))
+						break;
+				} else {
+					DEBUG2(printk("scsi%ld: %s: Command "
+					    "failed\n", ha->host_no,
+					    __func__));
+					ret = QLA_ERROR;
+					break;
+				}
+			}
+		} else
+			ret = QLA_ERROR;
+	}
+
+	return ret;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 38b1d38..24eaeae 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -15,6 +15,8 @@
 #include "ql4_glbl.h"
 #include "ql4_dbg.h"
 #include "ql4_inline.h"
+#include <scsi/scsi_bsg_iscsi.h>
+#include <scsi/scsi_netlink.h>
 
 /*
  * Driver version
@@ -68,6 +70,7 @@ static int qla4xxx_host_get_param(struct Scsi_Host *shost,
 				  enum iscsi_host_param param, char *buf);
 static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session);
 static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc);
+static int qla4xxx_bsg_request(struct iscsi_bsg_job *job);
 
 /*
  * SCSI host template entry points
@@ -108,6 +111,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.sg_tablesize		= SG_ALL,
 
 	.max_sectors		= 0xFFFF,
+	.vendor_id              = SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_QLOGIC,
 };
 
 static struct iscsi_transport qla4xxx_iscsi_transport = {
@@ -125,10 +129,225 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 	.get_session_param	= qla4xxx_sess_get_param,
 	.get_host_param		= qla4xxx_host_get_param,
 	.session_recovery_timedout = qla4xxx_recovery_timedout,
+	.bsg_request		= qla4xxx_bsg_request,
 };
 
 static struct scsi_transport_template *qla4xxx_scsi_transport;
 
+/**
+ * qla4xxx_get_data - data from driver to application
+ * @job: iscsi_bsg_job to handle
+ **/
+int qla4xxx_get_data(struct iscsi_bsg_job *bsg_job,
+    struct qla4xxx_bsg_cmd *qla4xxx_cmd,
+    struct qla4xxx_dma_mem mem)
+{
+	int rval = QLA_SUCCESS;
+	struct scsi_qla_host *ha = to_qla_host(bsg_job->shost);
+
+	switch (qla4xxx_cmd->subcode) {
+	case QL4_GET_FLASH:
+		rval = qla4xxx_get_flash(ha, mem.dma, qla4xxx_cmd->offset,
+		    mem.size);
+		break;
+	case QL4_GET_DDB_DEF:
+		rval = qla4xxx_get_default_ddb(ha, mem.dma);
+		break;
+	case QL4_GET_DDB:
+		rval = qla4xxx_get_fwddb_entry(ha, qla4xxx_cmd->instance,
+		    NULL, mem.dma, NULL, NULL,
+		    NULL, NULL, NULL, NULL);
+		break;
+	case QL4_GET_IFCB_DEF:
+	case QL4_GET_IFCB:
+		rval = qla4xxx_bsg_get_ifcb(ha, mem.dma,
+		    qla4xxx_cmd->subcode);
+		break;
+	case QL4_GET_ACB:
+		rval = qla4xxx_get_acb(ha, mem.dma, qla4xxx_cmd->instance,
+		    mem.size);
+		break;
+	case QL4_GET_ISCSI_STAT:
+		rval = qla4xxx_get_iscsi_stat(ha, qla4xxx_cmd->instance,
+		    mem.dma);
+		break;
+	default:
+		DEBUG2(printk("scsi %ld: %s: invalid sub command code: 0x%x\n",
+		    ha->host_no, __func__, qla4xxx_cmd->opcode));
+		rval = -EINVAL;
+	}
+
+	bsg_job->reply->reply_payload_rcv_len = mem.size;
+	return rval;
+}
+
+/**
+ * qla4xxx_set_data - data from application to driver
+ * @ha: Pointer to host adapter structure.
+ * @job: iscsi_bsg_job to handle
+ * @vendor_cmd: bsg vendor specific command structure
+ * @data: data buffer
+ * @data_dma: DMA address of data buffer
+ **/
+int qla4xxx_set_data(struct iscsi_bsg_job *bsg_job,
+    struct qla4xxx_bsg_cmd *qla4xxx_cmd,
+    struct qla4xxx_dma_mem mem)
+{
+	int rval = QLA_SUCCESS;
+	struct scsi_qla_host *ha = to_qla_host(bsg_job->shost);
+
+	/* Copy the request buffer in req_data now */
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, mem.va,
+	    mem.size);
+
+	switch (qla4xxx_cmd->subcode) {
+	case QL4_SET_FLASH:
+		rval = qla4xxx_set_flash(ha, mem.dma, qla4xxx_cmd->offset,
+		    qla4xxx_cmd->option0, mem.size);
+		break;
+	case QL4_SET_DDB:
+		rval = qla4xxx_set_ddb_entry(ha, qla4xxx_cmd->instance,
+		    mem.dma);
+		break;
+	case QL4_SET_IFCB:
+		rval = qla4xxx_bsg_set_ifcb(ha, mem.dma);
+		break;
+	case QL4_SET_ACB:
+		rval = qla4xxx_set_acb(ha, mem.dma, qla4xxx_cmd->instance,
+		    mem.size);
+		break;
+	case QL4_RESET_ISCSI_STAT:
+		rval = qla4xxx_reset_iscsi_stat(ha, qla4xxx_cmd->instance);
+		break;
+	default:
+		DEBUG2(printk("scsi %ld: %s: invalid sub command code: 0x%x\n",
+		    ha->host_no, __func__, qla4xxx_cmd->opcode));
+		rval = -EINVAL;
+	}
+	bsg_job->reply->reply_payload_rcv_len = 0;
+	return rval;
+}
+
+/**
+ * qla4xxx_process_vendor_specific - handle vendor specific bsg request
+ * @job: iscsi_bsg_job to handle
+ **/
+int qla4xxx_process_vendor_specific(struct iscsi_bsg_job *bsg_job)
+{
+	struct scsi_qla_host *ha = to_qla_host(bsg_job->shost);
+	struct qla4xxx_bsg_cmd *qla4xxx_cmd;
+	struct qla4xxx_dma_mem mem;
+	int rval = QLA_SUCCESS;
+
+	qla4xxx_cmd = (struct qla4xxx_bsg_cmd *) ((char *)bsg_job->request +
+	    sizeof(struct iscsi_bsg_request));
+
+	mem.req_sg_cnt =
+		dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
+		    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+
+	if (!mem.req_sg_cnt) {
+		rval = -ENOMEM;
+		goto done;
+	}
+
+	mem.rsp_sg_cnt =
+		dma_map_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
+		    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+
+	if (!mem.rsp_sg_cnt) {
+		rval = -ENOMEM;
+		goto done;
+	}
+
+	if ((mem.req_sg_cnt != bsg_job->request_payload.sg_cnt) ||
+			(mem.rsp_sg_cnt != bsg_job->reply_payload.sg_cnt)) {
+		DEBUG2(printk(KERN_INFO
+		    "dma mapping resulted in different sg counts \
+		    [request_sg_cnt: %x dma_request_sg_cnt: %x\
+		    reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
+		    bsg_job->request_payload.sg_cnt, mem.req_sg_cnt,
+		    bsg_job->reply_payload.sg_cnt, mem.rsp_sg_cnt));
+
+		rval = -EAGAIN;
+		goto done_unmap_sg;
+	}
+
+	mem.size = qla4xxx_cmd->data_size;
+	mem.va = dma_alloc_coherent(&ha->pdev->dev, mem.size,
+	    &mem.dma, GFP_KERNEL);
+	if (mem.va == NULL) {
+		DEBUG2(printk("scsi %ld: %s: fail to allocate dma memory "
+		    "for data", ha->host_no, __func__));
+		rval = -EIO;
+		goto done_free_dma;
+	}
+
+	switch (qla4xxx_cmd->opcode) {
+	case QL4_GET_DATA:
+		rval = qla4xxx_get_data(bsg_job, qla4xxx_cmd, mem);
+		break;
+	case QL4_SET_DATA:
+		rval = qla4xxx_set_data(bsg_job, qla4xxx_cmd, mem);
+		break;
+	case QL4_RESTORE_FACTORY_DEF:
+		rval = qla4xxx_restore_factory_defaults(bsg_job, qla4xxx_cmd);
+		break;
+	case QL4_DISABLE_ACB:
+		rval = qla4xxx_disable_acb(bsg_job, qla4xxx_cmd);
+		break;
+	default:
+		DEBUG2(printk("scsi %ld: %s: invalid command code: 0x%x\n",
+		    ha->host_no, __func__, qla4xxx_cmd->opcode));
+		rval = -EINVAL;
+	}
+	bsg_job->reply->result = rval;
+	bsg_job->job_done(bsg_job);
+
+
+done_free_dma:
+	dma_free_coherent(&ha->pdev->dev, mem.size, mem.va, mem.dma);
+done_unmap_sg:
+	dma_unmap_sg(&ha->pdev->dev,
+	    bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+
+	dma_unmap_sg(&ha->pdev->dev,
+	    bsg_job->reply_payload.sg_list,
+	    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+done:
+	return rval;
+}
+
+/**
+ * qla4xxx_bsg_request - handle bsg request from ISCSI transport
+ * @job: iscsi_bsg_job to handle
+ */
+static int qla4xxx_bsg_request(struct iscsi_bsg_job *job)
+{
+	uint32_t msgcode;
+	int rval = -EINVAL;
+
+	msgcode = job->request->msgcode;
+
+	switch (msgcode) {
+	case ISCSI_BSG_HST_VENDOR:
+		rval = qla4xxx_process_vendor_specific(job);
+		break;
+	case ISCSI_BSG_HST_NET_CONFIG:
+		printk(KERN_ERR "ISCSI_BSG_HST_NET_CONFIG Commands "
+		    "NOT Supported\n");
+		rval = -ENOSYS;
+		break;
+	default:
+		rval = -EINVAL;
+		break;
+	}
+
+	return rval;
+}
+
 static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc)
 {
 	struct iscsi_cls_session *session;
-- 
1.7.0.5

