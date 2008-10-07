From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: [PATCH] qla2xxx: config support for QLA8432 using SCSI Netlink
	Transport
Date: Mon, 06 Oct 2008 18:02:50 -0700
Message-ID: <1223341370.3820.5.camel@ISCSI00>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:55914 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759682AbYJGBCt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2008 21:02:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: David Somayajulu <david.somayajulu@qlogic.com>

his patch adds support for managing Qlogic's QLA84xx HBA using netlink messages via SCSI Netlink Transport. This is essentially a repost of the patch 
http://marc.info/?l=linux-scsi&m=121745486321823&w=2 using the new scheme. The patch is against scsi-misc

Signed-off-by: David C Somayajulu <david.somayajulu@qlogic.com>
---
 drivers/scsi/qla2xxx/Makefile   |    2 +-
 drivers/scsi/qla2xxx/qla_def.h  |    8 +
 drivers/scsi/qla2xxx/qla_gbl.h  |   13 ++
 drivers/scsi/qla2xxx/qla_mbx.c  |   25 +++-
 drivers/scsi/qla2xxx/qla_nlnk.c |  323 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_nlnk.h |  166 ++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c   |    9 +
 7 files changed, 544 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
index c51fd1f..6322a7d 100644
--- a/drivers/scsi/qla2xxx/Makefile
+++ b/drivers/scsi/qla2xxx/Makefile
@@ -1,4 +1,4 @@
 qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
-		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o qla_dfs.o
+		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o qla_dfs.o qla_nlnk.o
 
 obj-$(CONFIG_SCSI_QLA_FC) += qla2xxx.o
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 83c8192..453f263 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2160,6 +2160,13 @@ struct qla_statistics {
 	uint64_t output_bytes;
 };
 
+/* place holder for fw buffer parameters for netlink */
+struct qlfc_fw {
+	void *fw_buf;
+	dma_addr_t fw_dma;
+	uint32_t len;
+};
+
 /*
  * Linux Host Adapter structure
  */
@@ -2610,6 +2617,7 @@ typedef struct scsi_qla_host {
 
 	struct qla_chip_state_84xx *cs84xx;
 	struct qla_statistics qla_stats;
+	struct qlfc_fw fw_buf;
 } scsi_qla_host_t;
 
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 753dbe6..4bd3338 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -258,6 +258,11 @@ qla2x00_set_idma_speed(scsi_qla_host_t *, uint16_t, uint16_t, uint16_t *);
 
 extern int qla84xx_verify_chip(struct scsi_qla_host *, uint16_t *);
 
+extern int qla84xx_reset(struct scsi_qla_host *, uint32_t);
+
+extern int qla2x00_issue_iocb_timeout(scsi_qla_host_t *, void *, dma_addr_t,
+		size_t, uint32_t);
+
 /*
  * Global Function Prototypes in qla_isr.c source file.
  */
@@ -367,4 +372,12 @@ extern void qla2x00_free_sysfs_attr(scsi_qla_host_t *);
  */
 extern int qla2x00_dfs_setup(scsi_qla_host_t *);
 extern int qla2x00_dfs_remove(scsi_qla_host_t *);
+
+/*
+ * Global functions in qla_nlk.c
+ */
+extern int ql_nl_register(struct Scsi_Host *, struct scsi_host_template *);
+extern void ql_nl_unregister(void);
+extern void qla_free_nlnk_dmabuf(scsi_qla_host_t *);
+
 #endif /* _QLA_GBL_H */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 36bc685..2f5759c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -681,7 +681,7 @@ qla2x00_verify_checksum(scsi_qla_host_t *ha, uint32_t risc_addr)
  * Context:
  *	Kernel context.
  */
-static int
+int
 qla2x00_issue_iocb_timeout(scsi_qla_host_t *ha, void *buffer,
     dma_addr_t phys_addr, size_t size, uint32_t tov)
 {
@@ -2946,6 +2946,29 @@ qla2x00_dump_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t addr,
 
 /* 84XX Support **************************************************************/
 
+int
+qla84xx_reset(struct scsi_qla_host *vha, uint32_t diag_fw)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	mcp->mb[0] = MBC_ISP84XX_RESET;
+	mcp->mb[1] = diag_fw;
+	mcp->out_mb = MBX_1 | MBX_0;
+	mcp->in_mb = MBX_1 | MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval != QLA_SUCCESS)
+		printk("%s(%ld): failed mb[0]=0x%x mb[1]=0x%x\n",
+			__func__, vha->host_no, mcp->mb[0], mcp->mb[1]);
+
+	return (rval);
+}
+
 struct cs84xx_mgmt_cmd {
 	union {
 		struct verify_chip_entry_84xx req;
diff --git a/drivers/scsi/qla2xxx/qla_nlnk.c b/drivers/scsi/qla2xxx/qla_nlnk.c
new file mode 100644
index 0000000..e94f0f9
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_nlnk.c
@@ -0,0 +1,323 @@
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
+ *
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
+
+#include "qla_def.h"
+#include <net/sock.h>
+#include <net/netlink.h>
+#include "qla_nlnk.h"
+
+
+/*
+ * local functions
+ */
+
+static int qla84xx_update_fw(struct scsi_qla_host *ha, int rlen,
+		struct msg_update_fw *upd_fw)
+{
+	struct qlfc_fw *qlfw;
+	struct verify_chip_entry_84xx *mn;
+	dma_addr_t mn_dma;
+	int ret = 0;
+	uint32_t fw_ver;
+	uint16_t options;
+
+	if (rlen < (sizeof(struct msg_update_fw) + upd_fw->len +
+		offsetof(struct qla_fc_msg, u))){
+		printk(KERN_ERR "%s(%lu): invalid len\n",
+			__func__, ha->host_no);
+		return -EINVAL;
+	}
+
+	qlfw = &ha->fw_buf;
+
+	if (!upd_fw->offset) {
+		if (qlfw->fw_buf || !upd_fw->fw_len ||
+			upd_fw->len > upd_fw->fw_len) {
+			printk(KERN_ERR "%s(%lu): invalid offset or fw_len\n",
+				__func__, ha->host_no);
+			return -EINVAL;
+		} else {
+			qlfw->fw_buf = dma_alloc_coherent(&ha->pdev->dev,
+						upd_fw->fw_len, &qlfw->fw_dma,
+						GFP_KERNEL);
+			if (qlfw->fw_buf == NULL) {
+				printk(KERN_ERR "%s: dma alloc failed%lu\n",
+					__func__, ha->host_no);
+				return (-ENOMEM);
+			}
+			qlfw->len = upd_fw->fw_len;
+		}
+		fw_ver = le32_to_cpu(*((uint32_t *)
+				((uint32_t *)upd_fw->fw_bytes + 2)));
+		if (!fw_ver) {
+			printk(KERN_ERR "%s(%lu): invalid fw revision 0x%x\n",
+				__func__, ha->host_no, fw_ver);
+			return -EINVAL;
+		}
+	} else {
+		/* make sure we have a buffer allocated */
+		if (!qlfw->fw_buf || upd_fw->fw_len != qlfw->len ||
+			((upd_fw->offset + upd_fw->len) > upd_fw->fw_len)){
+			printk(KERN_ERR "%s(%lu): invalid size of offset=0"
+				" expected\n", __func__, ha->host_no);
+			return -EINVAL;
+		}
+	}
+	/* Copy the firmware into DMA Buffer */
+	memcpy(((uint8_t *)qlfw->fw_buf + upd_fw->offset),
+		upd_fw->fw_bytes, upd_fw->len);
+
+	if ((upd_fw->offset+upd_fw->len) != qlfw->len)
+		return 0;
+
+	mn = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &mn_dma);
+	if (mn == NULL) {
+		printk(KERN_ERR "%s: dma alloc for fw buffer failed%lu\n",
+			__func__, ha->host_no);
+		return -ENOMEM;
+	}
+
+	fw_ver = le32_to_cpu(*((uint32_t *)((uint32_t *)qlfw->fw_buf + 2)));
+
+	/* Create iocb and issue it */
+	memset(mn, 0, sizeof(*mn));
+
+	mn->entry_type = VERIFY_CHIP_IOCB_TYPE;
+	mn->entry_count = 1;
+
+	options = VCO_FORCE_UPDATE | VCO_END_OF_DATA;
+	if (upd_fw->diag_fw)
+		options |= VCO_DIAG_FW;
+	mn->options = cpu_to_le16(options);
+
+	mn->fw_ver = cpu_to_le32(fw_ver);
+	mn->fw_size = cpu_to_le32(qlfw->len);
+	mn->fw_seq_size = cpu_to_le32(qlfw->len);
+
+	mn->dseg_address[0] = cpu_to_le32(LSD(qlfw->fw_dma));
+	mn->dseg_address[1] = cpu_to_le32(MSD(qlfw->fw_dma));
+	mn->dseg_length = cpu_to_le32(qlfw->len);
+	mn->data_seg_cnt = cpu_to_le16(1);
+
+	ret = qla2x00_issue_iocb_timeout(ha, mn, mn_dma, 0, 120);
+
+	if (ret != QLA_SUCCESS) {
+		printk(KERN_ERR "%s(%lu): failed\n", __func__, ha->host_no);
+	}
+
+	dma_pool_free(ha->s_dma_pool, mn, mn_dma);
+	qla_free_nlnk_dmabuf(ha);
+	return ret;
+}
+
+static int
+qla84xx_mgmt_cmd(scsi_qla_host_t *ha, struct qla_fc_msg *cmd, int rlen,
+	uint32_t pid)
+{
+	struct access_chip_84xx *mn;
+	dma_addr_t mn_dma, mgmt_dma;
+	void *mgmt_b = NULL;
+	int ret = 0, len = 0;
+	struct qla84_msg_mgmt *ql84_mgmt;
+	void *rsp_buf;
+	int rsp_len;
+	struct qla_fc_msg *rsp;
+
+	ql84_mgmt = &cmd->u.utok.mgmt;
+
+	rsp_len = MGMT_RSP_HDR_LEN;
+
+	mn = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &mn_dma);
+	if (mn == NULL) {
+		printk(KERN_ERR "%s: dma alloc for fw buffer failed%lu\n",
+			__FUNCTION__, ha->host_no);
+		return (-ENOMEM);
+	}
+
+	memset(mn, 0, sizeof (struct access_chip_84xx));
+
+	mn->entry_type = ACCESS_CHIP_IOCB_TYPE;
+	mn->entry_count = 1;
+
+	switch (ql84_mgmt->cmd) {
+	case QLA84_MGMT_READ_MEM:
+		mn->options = cpu_to_le16(ACO_DUMP_MEMORY);
+		mn->parameter1 = cpu_to_le32(ql84_mgmt->mgmtp.u.mem.start_addr);
+		rsp_len += ql84_mgmt->len;
+		break;
+	case QLA84_MGMT_WRITE_MEM:
+		if (rlen < (MGMT_HDR_LEN + ql84_mgmt->len +
+			offsetof(struct qla_fc_msg, u))){
+			ret = -EINVAL;
+			goto exit_mgmt0;
+		}
+		mn->options = cpu_to_le16(ACO_LOAD_MEMORY);
+		mn->parameter1 = cpu_to_le32(ql84_mgmt->mgmtp.u.mem.start_addr);
+		break;
+	case QLA84_MGMT_CHNG_CONFIG:
+		mn->options = cpu_to_le16(ACO_CHANGE_CONFIG_PARAM);
+		mn->parameter1 = cpu_to_le32(ql84_mgmt->mgmtp.u.config.id);
+		mn->parameter2 = cpu_to_le32(ql84_mgmt->mgmtp.u.config.param0);
+		mn->parameter3 = cpu_to_le32(ql84_mgmt->mgmtp.u.config.param1);
+		break;
+	case QLA84_MGMT_GET_INFO:
+		mn->options = cpu_to_le16(ACO_REQUEST_INFO);
+		mn->parameter1 = cpu_to_le32(ql84_mgmt->mgmtp.u.info.type);
+		mn->parameter2 = cpu_to_le32(ql84_mgmt->mgmtp.u.info.context);
+		rsp_len += ql84_mgmt->len;
+		break;
+	default:
+		ret = -EIO;
+		goto exit_mgmt0;
+	}
+
+	if (!(rsp_buf = kzalloc(rsp_len, GFP_KERNEL)))
+		goto exit_mgmt0;
+
+	if ((len = ql84_mgmt->len) &&
+		ql84_mgmt->cmd != QLA84_MGMT_CHNG_CONFIG) {
+		mgmt_b = dma_alloc_coherent(&ha->pdev->dev, len,
+				&mgmt_dma, GFP_KERNEL);
+		if (mgmt_b == NULL) {
+			printk(KERN_ERR "%s: dma alloc mgmt_b failed%lu\n",
+				__func__, ha->host_no);
+			ret = -ENOMEM;
+			goto exit_mgmt0;
+		}
+		mn->total_byte_cnt = cpu_to_le32(ql84_mgmt->len);
+		mn->dseg_count = cpu_to_le16(1);
+		mn->dseg_address[0] = cpu_to_le32(LSD(mgmt_dma));
+		mn->dseg_address[1] = cpu_to_le32(MSD(mgmt_dma));
+		mn->dseg_length = cpu_to_le32(len);
+
+		if (ql84_mgmt->cmd == QLA84_MGMT_WRITE_MEM) {
+			memcpy(mgmt_b, ql84_mgmt->payload, len);
+		}
+	}
+
+	ret = qla2x00_issue_iocb(ha, mn, mn_dma, 0);
+	rsp = rsp_buf;
+	rsp->magic = QL_FC_NL_MAGIC;
+	rsp->host_no = ha->host_no;
+	rsp->cmd = cmd->cmd;
+	rsp->error = ret;
+	memcpy((void *)((char *)rsp + RSP_HDR_LEN), ql84_mgmt, MGMT_HDR_LEN);
+
+	if ((ret != QLA_SUCCESS)||(ql84_mgmt->cmd == QLA84_MGMT_WRITE_MEM)||
+		(ql84_mgmt->cmd == QLA84_MGMT_CHNG_CONFIG)) {
+
+		if (ret != QLA_SUCCESS)
+			printk(KERN_ERR "%s(%lu): failed\n", __func__,
+				ha->host_no);
+
+		ret = scsi_nl_send_vendor_msg(pid, ha->host_no,
+			QL_FC_NL_MAGIC, rsp_buf, MGMT_RSP_HDR_LEN);
+
+	} else if ((ql84_mgmt->cmd == QLA84_MGMT_READ_MEM)||
+			(ql84_mgmt->cmd == QLA84_MGMT_GET_INFO)) {
+
+		memcpy((void *)((char *)rsp_buf + MGMT_RSP_HDR_LEN), mgmt_b,
+			len);
+
+		ret = scsi_nl_send_vendor_msg(pid, ha->host_no,
+			QL_FC_NL_MAGIC, rsp_buf, rsp_len);
+	}
+
+	kfree(rsp_buf);
+	if (mgmt_b)
+		dma_free_coherent(&ha->pdev->dev, len, mgmt_b, mgmt_dma);
+
+exit_mgmt0:
+	dma_pool_free(ha->s_dma_pool, mn, mn_dma);
+	return ret;
+}
+
+static int
+ql_fc_proc_nl_rcv_msg(struct Scsi_Host *shost, void *payload, uint32_t len,
+	uint32_t pid)
+{
+	struct qla_fc_msg *ql_cmd, *ql_rsp;
+	struct scsi_qla_host *ha;
+	int err = 0;
+
+	ql_cmd = (struct qla_fc_msg *)
+			((char *)payload - offsetof(struct qla_fc_msg, cmd));
+
+	ha = (struct scsi_qla_host *)shost_priv(shost);
+
+	if (!ha || !IS_QLA84XX(ha)) {
+		printk(KERN_ERR "%s: invalid host ha = %p dtype = 0x%x\n",
+			__FUNCTION__, ha, (ha ? DT_MASK(ha): ~0));
+		err = -ENODEV;
+		goto exit_proc_nl_rcv_msg;
+	}
+
+	if (!(ql_rsp = (struct qla_fc_msg *)
+		kzalloc(sizeof (struct qla_fc_msg), GFP_KERNEL)))
+		goto exit_proc_nl_rcv_msg;
+
+	ql_rsp->magic = QL_FC_NL_MAGIC;
+	ql_rsp->host_no = ha->host_no;
+	ql_rsp->cmd = ql_cmd->cmd;
+
+	switch (ql_cmd->cmd) {
+
+	case QLA84_RESET:
+		ql_rsp->error = qla84xx_reset(ha,
+					ql_cmd->u.utok.qla84_reset.diag_fw);
+		err = scsi_nl_send_vendor_msg(pid, ha->host_no,
+				QL_FC_NL_MAGIC, (void *)ql_rsp, RSP_HDR_LEN);
+		break;
+
+	case QLA84_UPDATE_FW:
+		ql_rsp->error = qla84xx_update_fw(ha, len,
+					&ql_cmd->u.utok.qla84_update_fw);
+		err = scsi_nl_send_vendor_msg(pid, ha->host_no,
+				QL_FC_NL_MAGIC, (void *)ql_rsp, RSP_HDR_LEN);
+		break;
+
+	case QLA84_MGMT_CMD:
+		err = qla84xx_mgmt_cmd(ha, ql_cmd, len, pid);
+		break;
+
+	default:
+		err = -EBADMSG;
+	}
+
+	kfree((void *)ql_rsp);
+exit_proc_nl_rcv_msg:
+	return err;
+}
+
+void qla_free_nlnk_dmabuf(scsi_qla_host_t *ha)
+{
+	struct qlfc_fw *qlfw;
+
+	qlfw = &ha->fw_buf;
+
+	if (qlfw->fw_buf) {
+		dma_free_coherent(&ha->pdev->dev, qlfw->len, qlfw->fw_buf,
+			qlfw->fw_dma);
+		memset(qlfw, 0, sizeof(struct qlfc_fw));
+	}
+}
+
+int
+ql_nl_register(struct Scsi_Host *host, struct scsi_host_template *hostt)
+{
+	int error;
+
+	error = scsi_nl_add_driver(QL_FC_NL_MAGIC, hostt,
+			ql_fc_proc_nl_rcv_msg, NULL);
+	return (error);
+}
+
+void
+ql_nl_unregister()
+{
+	scsi_nl_remove_driver(QL_FC_NL_MAGIC);
+}
diff --git a/drivers/scsi/qla2xxx/qla_nlnk.h b/drivers/scsi/qla2xxx/qla_nlnk.h
new file mode 100644
index 0000000..76caad4
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_nlnk.h
@@ -0,0 +1,166 @@
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
+ *
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
+#ifndef _QLA_NLNK_H_
+#define _QLA_NLNK_H_
+
+#ifndef NETLINK_FCTRANSPORT
+#define NETLINK_FCTRANSPORT 20
+#endif
+#define QL_FC_NL_GROUP_CNT	0
+
+#define FC_TRANSPORT_MSG		NLMSG_MIN_TYPE + 1
+
+/*
+ * Transport Message Types
+ */
+#define FC_NL_VNDR_SPECIFIC	0x8000
+
+/*
+ * Structures
+ */
+
+struct qla84_mgmt_param {
+	union {
+		struct {
+			uint32_t start_addr;
+		} mem; /* for QLA84_MGMT_READ/WRITE_MEM */
+		struct {
+			uint32_t id;
+#define QLA84_MGMT_CONFIG_ID_UIF	1
+#define QLA84_MGMT_CONFIG_ID_FCOE_COS	2
+#define QLA84_MGMT_CONFIG_ID_PAUSE	3
+#define QLA84_MGMT_CONFIG_ID_TIMEOUTS	4
+
+			uint32_t param0;
+			uint32_t param1;
+		} config; /* for QLA84_MGMT_CHNG_CONFIG */
+
+		struct {
+			uint32_t type;
+#define QLA84_MGMT_INFO_CONFIG_LOG_DATA		1 /* Get Config Log Data */
+#define QLA84_MGMT_INFO_LOG_DATA		2 /* Get Log Data */
+#define QLA84_MGMT_INFO_PORT_STAT		3 /* Get Port Statistics */
+#define QLA84_MGMT_INFO_LIF_STAT		4 /* Get LIF Statistics  */
+#define QLA84_MGMT_INFO_ASIC_STAT		5 /* Get ASIC Statistics */
+#define QLA84_MGMT_INFO_CONFIG_PARAMS		6 /* Get Config Parameters */
+#define QLA84_MGMT_INFO_PANIC_LOG		7 /* Get Panic Log */
+
+			uint32_t context;
+/*
+ * context definitions for QLA84_MGMT_INFO_CONFIG_LOG_DATA
+ */
+#define IC_LOG_DATA_LOG_ID_DEBUG_LOG			0
+#define IC_LOG_DATA_LOG_ID_LEARN_LOG			1
+#define IC_LOG_DATA_LOG_ID_FC_ACL_INGRESS_LOG		2
+#define IC_LOG_DATA_LOG_ID_FC_ACL_EGRESS_LOG		3
+#define IC_LOG_DATA_LOG_ID_ETHERNET_ACL_INGRESS_LOG	4
+#define IC_LOG_DATA_LOG_ID_ETHERNET_ACL_EGRESS_LOG	5
+#define IC_LOG_DATA_LOG_ID_MESSAGE_TRANSMIT_LOG		6
+#define IC_LOG_DATA_LOG_ID_MESSAGE_RECEIVE_LOG		7
+#define IC_LOG_DATA_LOG_ID_LINK_EVENT_LOG		8
+#define IC_LOG_DATA_LOG_ID_DCX_LOG			9
+
+/*
+ * context definitions for QLA84_MGMT_INFO_PORT_STAT
+ */
+#define IC_PORT_STATISTICS_PORT_NUMBER_ETHERNET_PORT0	0
+#define IC_PORT_STATISTICS_PORT_NUMBER_ETHERNET_PORT1	1
+#define IC_PORT_STATISTICS_PORT_NUMBER_NSL_PORT0	2
+#define IC_PORT_STATISTICS_PORT_NUMBER_NSL_PORT1	3
+#define IC_PORT_STATISTICS_PORT_NUMBER_FC_PORT0		4
+#define IC_PORT_STATISTICS_PORT_NUMBER_FC_PORT1		5
+
+
+/*
+ * context definitions for QLA84_MGMT_INFO_LIF_STAT
+ */
+#define IC_LIF_STATISTICS_LIF_NUMBER_ETHERNET_PORT0	0
+#define IC_LIF_STATISTICS_LIF_NUMBER_ETHERNET_PORT1	1
+#define IC_LIF_STATISTICS_LIF_NUMBER_FC_PORT0		2
+#define IC_LIF_STATISTICS_LIF_NUMBER_FC_PORT1		3
+#define IC_LIF_STATISTICS_LIF_NUMBER_CPU		6
+
+		} info; /* for QLA84_MGMT_GET_INFO */
+	} u;
+};
+
+struct qla84_msg_mgmt {
+	uint16_t cmd;
+#define QLA84_MGMT_READ_MEM	0x00
+#define QLA84_MGMT_WRITE_MEM	0x01
+#define QLA84_MGMT_CHNG_CONFIG	0x02
+#define QLA84_MGMT_GET_INFO	0x03
+	uint16_t rsrvd;
+	struct qla84_mgmt_param mgmtp;/* parameters for cmd */
+	uint32_t len; /* bytes in payload following this struct */
+	uint8_t payload[0]; /* payload for cmd */
+};
+
+struct msg_update_fw {
+	/*
+	 * diag_fw = 0  operational fw
+	 *	otherwise diagnostic fw
+	 * offset, len, fw_len are present to overcome the current limitation
+	 * of 128Kb xfer size. The fw is sent in smaller chunks. Each chunk
+	 * specifies the byte "offset" where it fits in the fw buffer. The
+	 * number of bytes in each chunk is specified in "len". "fw_len"
+	 * is the total size of fw. The first chunk should start at offset = 0.
+	 * When offset+len == fw_len, the fw is written to the HBA.
+	 */
+	uint32_t diag_fw;
+	uint32_t offset;/* start offset */
+	uint32_t len;	/* num bytes in cur xfer */
+	uint32_t fw_len; /* size of fw in bytes */
+	uint8_t fw_bytes[0];
+};
+
+#define QL_FC_NL_MAGIC	0x107784DDFCAB1FC1
+
+/*
+ *  Note: The user mode application sends and receives messages
+ *	confirming to struct qla_fc_msg.
+ *	On the received messages the first three fields
+ *	magic, host_no, vmsg_datalen are private to the SCSI netlink
+ *	layer. The driver should not be accessing these three fields.
+ *	These three fields correspond to the vendor_id, host_no and
+ *	vmsg_datalen in struct struct scsi_nl_host_vendor_msg
+ */
+struct qla_fc_msg {
+	uint64_t magic;
+	uint16_t host_no;
+	uint16_t vmsg_datalen;
+	uint32_t cmd;
+#define QLA84_RESET	0x01
+#define QLA84_UPDATE_FW	0x02
+#define QLA84_MGMT_CMD	0x03
+#define QLFC_GET_AEN	0x04
+	uint32_t error;
+	union {
+		union {
+			struct msg_reset {
+				/*
+				 * diag_fw = 0  for operational fw
+				 * otherwise diagnostic fw
+				 */
+				uint32_t diag_fw;
+			} qla84_reset;
+
+			struct msg_update_fw qla84_update_fw;
+			struct qla84_msg_mgmt mgmt;
+		} utok;
+
+		union {
+			struct qla84_msg_mgmt mgmt;
+		} ktou;
+	} u;
+} __attribute__ ((aligned (sizeof(uint64_t))));
+
+#define RSP_HDR_LEN offsetof(struct qla_fc_msg, u)
+#define MGMT_HDR_LEN offsetof(struct qla84_msg_mgmt, payload)
+#define MGMT_RSP_HDR_LEN RSP_HDR_LEN + MGMT_HDR_LEN
+
+#endif /* _QLA_NLNK_H_ */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index fcbcd44..f34db7d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1741,6 +1741,9 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	scsi_scan_host(host);
 
+	if (ql_nl_register(host, sht))
+		goto nl_reg_failed;
+
 	qla2x00_alloc_sysfs_attr(ha);
 
 	qla2x00_init_host_attr(ha);
@@ -1759,6 +1762,9 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
+nl_reg_failed:
+	scsi_remove_host(host);
+
 probe_failed:
 	qla2x00_free_device(ha);
 
@@ -1789,6 +1795,8 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	qla2x00_free_sysfs_attr(ha);
 
+	qla_free_nlnk_dmabuf(ha);
+
 	fc_remove_host(ha->host);
 
 	scsi_remove_host(ha->host);
@@ -2921,6 +2929,7 @@ qla2x00_module_exit(void)
 {
 	pci_unregister_driver(&qla2xxx_pci_driver);
 	qla2x00_release_firmware();
+	ql_nl_unregister();
 	kmem_cache_destroy(srb_cachep);
 	fc_release_transport(qla2xxx_transport_template);
 	fc_release_transport(qla2xxx_transport_vport_template);

