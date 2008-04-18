From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: [PATCH]qla4xxx:Add support for Async Message PDUs
Date: Fri, 18 Apr 2008 13:44:47 -0700
Message-ID: <1208551487.5159.5.camel@d5102avq18960.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29465 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbYDRUox (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Apr 2008 16:44:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, David Somayajulu <david.somayajulu@qlogic.com>, David Wagner <david.wagner@qlogic.com>

The following patch adds support for Async Message PDUs. It also has minor clean up mainly removing references to iSNS.

Signed-off-by: David C Somayajulu <david.somayajulu@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h     |    8 ++
 drivers/scsi/qla4xxx/ql4_fw.h      |   39 +++++++----
 drivers/scsi/qla4xxx/ql4_glbl.h    |    4 +
 drivers/scsi/qla4xxx/ql4_isr.c     |   23 ++++++
 drivers/scsi/qla4xxx/ql4_mbx.c     |   48 ++++++++++++-
 drivers/scsi/qla4xxx/ql4_os.c      |  137 +++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-
 7 files changed, 244 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index d6be076..12b5623 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -296,6 +296,7 @@ struct scsi_qla_host {
 #define DPC_ISNS_RESTART		7 /* 0x00000080 */
 #define DPC_AEN				9 /* 0x00000200 */
 #define DPC_GET_DHCP_IP_ADDR		15 /* 0x00008000 */
+#define DPC_ASYNC_MSG_PDU		16 /* 0x00010000 */
 
 	struct Scsi_Host *host; /* pointer to host data */
 	uint32_t tot_ddbs;
@@ -434,7 +435,14 @@ struct scsi_qla_host {
 
 	/* Map ddb_list entry by FW ddb index */
 	struct ddb_entry *fw_ddb_index_map[MAX_DDB_ENTRIES];
+	struct list_head async_iocb_list;
+	dma_addr_t gen_req_rsp_iocb_dma;
+	void *gen_req_rsp_iocb;
+};
 
+struct async_msg_pdu_iocb {
+	struct list_head list;
+	uint8_t iocb[0x40];
 };
 
 static inline int is_qla4010(struct scsi_qla_host *ha)
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 1b667a7..5023f6f 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -227,8 +227,8 @@ union external_hw_config_reg {
 #define MBOX_CMD_READ_FLASH			0x0026
 #define MBOX_CMD_CLEAR_DATABASE_ENTRY		0x0031
 #define MBOX_CMD_CONN_CLOSE_SESS_LOGOUT		0x0056
-#define LOGOUT_OPTION_CLOSE_SESSION		0x01
-#define LOGOUT_OPTION_RELOGIN			0x02
+#define LOGOUT_OPTION_CLOSE_SESSION		0x02
+#define LOGOUT_OPTION_RESET			0x04
 #define MBOX_CMD_EXECUTE_IOCB_A64		0x005A
 #define MBOX_CMD_INITIALIZE_FIRMWARE		0x0060
 #define MBOX_CMD_GET_INIT_FW_CTRL_BLOCK		0x0061
@@ -576,13 +576,14 @@ struct conn_event_log_entry {
 /* IOCB header structure */
 struct qla4_header {
 	uint8_t entryType;
-#define ET_STATUS		 0x03
-#define ET_MARKER		 0x04
-#define ET_CONT_T1		 0x0A
-#define ET_STATUS_CONTINUATION	 0x10
-#define ET_CMND_T3		 0x19
-#define ET_PASSTHRU0		 0x3A
-#define ET_PASSTHRU_STATUS	 0x3C
+#define ET_STATUS		0x03
+#define ET_MARKER		0x04
+#define ET_CONT_T1		0x0A
+#define ET_STATUS_CONTINUATION	0x10
+#define ET_CMND_T3		0x19
+#define ET_ASYNC_PDU		0x37
+#define ET_PASSTHRU0		0x3A
+#define ET_PASSTHRU_STATUS	0x3C
 
 	uint8_t entryStatus;
 	uint8_t systemDefined;
@@ -691,6 +692,18 @@ struct qla4_marker_entry {
 	uint64_t reserved6;	/* 38-3F */
 };
 
+/* Asynchronous PDU IOCB structure */
+struct async_pdu_iocb {
+	struct qla4_header hdr;		/* 00-02 */
+	uint32_t async_pdu_handle;	/* 03-06 */
+	uint16_t target_id;		/* 07-08 */
+	uint16_t status;		/* 09-0A */
+#define ASYNC_PDU_IOCB_STS_OK  0x01
+
+	uint32_t rsrvd;			/* 0B-0F */
+	uint8_t iscsi_pdu_hdr[48];	/* 10-3F */
+};
+
 /* Status entry structure*/
 struct status_entry {
 	struct qla4_header hdr;	/* 00-03 */
@@ -738,11 +751,8 @@ struct passthru0 {
 	uint32_t handle;	/* 04-07 */
 	uint16_t target;	/* 08-09 */
 	uint16_t connectionID;	/* 0A-0B */
-#define ISNS_DEFAULT_SERVER_CONN_ID	((uint16_t)0x8000)
-
 	uint16_t controlFlags;	/* 0C-0D */
-#define PT_FLAG_ETHERNET_FRAME		0x8000
-#define PT_FLAG_ISNS_PDU		0x8000
+#define PT_FLAG_ISCSI_PDU		0x1000
 #define PT_FLAG_SEND_BUFFER		0x0200
 #define PT_FLAG_WAIT_4_RESPONSE		0x0100
 
@@ -752,7 +762,8 @@ struct passthru0 {
 	struct data_seg_a64 outDataSeg64;	/* 10-1B */
 	uint32_t res1;		/* 1C-1F */
 	struct data_seg_a64 inDataSeg64;	/* 20-2B */
-	uint8_t res2[20];	/* 2C-3F */
+	uint8_t res2[16];	/* 2C-3B */
+	uint32_t async_pdu_handle;
 };
 
 struct passthru_status {
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 96ebfb0..7542996 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -31,6 +31,10 @@ int qla4xxx_reset_target(struct scsi_qla
 			 struct ddb_entry * ddb_entry);
 int qla4xxx_get_flash(struct scsi_qla_host * ha, dma_addr_t dma_addr,
 		      uint32_t offset, uint32_t len);
+int qla4xxx_issue_iocb(struct scsi_qla_host * ha, uint32_t comp_offset,
+		dma_addr_t phys_addr);
+int qla4xxx_conn_close_sess_logout(struct scsi_qla_host * ha,
+	   uint16_t fw_ddb_index, uint16_t connection_id, uint16_t option);
 int qla4xxx_get_firmware_status(struct scsi_qla_host * ha);
 int qla4xxx_get_firmware_state(struct scsi_qla_host * ha);
 int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha);
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index a91a57c..77b2f65 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -9,6 +9,7 @@
 #include "ql4_glbl.h"
 #include "ql4_dbg.h"
 #include "ql4_inline.h"
+#include <scsi/iscsi_proto.h>
 
 /**
  * qla4xxx_status_entry - processes status IOCBs
@@ -285,6 +286,9 @@ static void qla4xxx_process_response_que
 	uint32_t count = 0;
 	struct srb *srb = NULL;
 	struct status_entry *sts_entry;
+	struct async_pdu_iocb *apdu;
+	struct iscsi_hdr *pdu_hdr;
+	struct async_msg_pdu_iocb *apdu_iocb;
 
 	/* Process all responses from response queue */
 	while ((ha->response_in =
@@ -315,6 +319,25 @@ static void qla4xxx_process_response_que
 		case ET_PASSTHRU_STATUS:
 			break;
 
+		case ET_ASYNC_PDU:
+			apdu = (struct async_pdu_iocb *)sts_entry;
+			if (apdu->status != ASYNC_PDU_IOCB_STS_OK)
+				break;
+
+			pdu_hdr = (struct iscsi_hdr *)apdu->iscsi_pdu_hdr;
+			if (pdu_hdr->hlength || pdu_hdr->dlength[0] ||
+				pdu_hdr->dlength[1] || pdu_hdr->dlength[2]){
+				apdu_iocb = vmalloc(sizeof (struct async_msg_pdu_iocb));
+				if (apdu_iocb) {
+					memcpy(apdu_iocb->iocb, apdu,
+						sizeof(struct async_pdu_iocb));
+					list_add_tail(&apdu_iocb->list,
+						&ha->async_iocb_list);
+					set_bit(DPC_ASYNC_MSG_PDU, &ha->dpc_flags);
+				}
+			}
+			break;
+
 		case ET_STATUS_CONTINUATION:
 			/* Just throw away the status continuation entries */
 			DEBUG2(printk("scsi%ld: %s: Status Continuation entry "
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index c577d79..75bcf2b 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -862,7 +862,6 @@ static int qla4xxx_req_ddb_entry(struct
 	return QLA_SUCCESS;
 }
 
-
 int qla4xxx_send_tgts(struct scsi_qla_host *ha, char *ip, uint16_t port)
 {
 	struct dev_db_entry *fw_ddb_entry;
@@ -915,3 +914,50 @@ qla4xxx_send_tgts_exit:
 	return ret_val;
 }
 
+int
+qla4xxx_issue_iocb(struct scsi_qla_host * ha, uint32_t comp_offset,
+		   dma_addr_t phys_addr)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	int status;
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_EXECUTE_IOCB_A64;
+	mbox_cmd[1] = comp_offset;
+	mbox_cmd[2] = LSDW(phys_addr);
+	mbox_cmd[3] = MSDW(phys_addr);
+
+	status = qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0],
+			&mbox_sts[0]);
+	return status;
+}
+
+int qla4xxx_conn_close_sess_logout(struct scsi_qla_host * ha,
+	   uint16_t fw_ddb_index, uint16_t connection_id, uint16_t option)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_CONN_CLOSE_SESS_LOGOUT;
+	mbox_cmd[1] = fw_ddb_index;
+	mbox_cmd[2] = connection_id;
+	mbox_cmd[3] = LOGOUT_OPTION_RESET;
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 2, &mbox_cmd[0],
+		&mbox_sts[0]) != QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_CONN_CLOSE_SESS_LOGOUT "
+			      "option %04x failed sts %04X %04X",
+			      ha->host_no, __func__,
+			      option, mbox_sts[0], mbox_sts[1]));
+		if (mbox_sts[0] == 0x4005)
+			DEBUG2(printk("%s reason %04X\n", __func__,
+				      mbox_sts[1]));
+	}
+	return QLA_SUCCESS;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 0c78694..b6cc961 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -8,6 +8,8 @@
 
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
+#include <scsi/iscsi_proto.h>
+#include <scsi/scsi_eh.h>
 
 #include "ql4_def.h"
 #include "ql4_version.h"
@@ -482,10 +484,24 @@ qc_fail_command:
  **/
 static void qla4xxx_mem_free(struct scsi_qla_host *ha)
 {
+	struct list_head *ptr;
+	struct async_msg_pdu_iocb *apdu_iocb;
+
 	if (ha->queues)
 		dma_free_coherent(&ha->pdev->dev, ha->queues_len, ha->queues,
 				  ha->queues_dma);
 
+	if (ha->gen_req_rsp_iocb)
+		dma_free_coherent(&ha->pdev->dev, PAGE_SIZE,
+			ha->gen_req_rsp_iocb, ha->gen_req_rsp_iocb_dma);
+
+	while (!list_empty(&ha->async_iocb_list)){
+		ptr = ha->async_iocb_list.next;
+		apdu_iocb = list_entry(ptr, struct async_msg_pdu_iocb, list);
+		list_del_init(&apdu_iocb->list);
+		vfree(apdu_iocb);
+	}
+
 	ha->queues_len = 0;
 	ha->queues = NULL;
 	ha->queues_dma = 0;
@@ -570,6 +586,14 @@ static int qla4xxx_mem_alloc(struct scsi
 
 		goto mem_alloc_error_exit;
 	}
+	ha->gen_req_rsp_iocb = dma_alloc_coherent(&ha->pdev->dev, PAGE_SIZE,
+					&ha->gen_req_rsp_iocb_dma, GFP_KERNEL);
+	if (ha->gen_req_rsp_iocb == NULL){
+		dev_warn(&ha->pdev->dev,
+			"Memory Allocation failed - gen_req_rsp_iocb.\n");
+
+		goto mem_alloc_error_exit;
+	}
 
 	return QLA_SUCCESS;
 
@@ -668,7 +692,8 @@ static void qla4xxx_timer(struct scsi_ql
 	     test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags) ||
 	     test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
 	     test_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags) ||
-	     test_bit(DPC_AEN, &ha->dpc_flags)) &&
+	     test_bit(DPC_AEN, &ha->dpc_flags) ||
+	     test_bit(DPC_ASYNC_MSG_PDU, &ha->dpc_flags)) &&
 	     ha->dpc_thread) {
 		DEBUG2(printk("scsi%ld: %s: scheduling dpc routine"
 			      " - dpc flags = 0x%lx\n",
@@ -985,6 +1010,102 @@ static int qla4xxx_recover_adapter(struc
 	return status;
 }
 
+/*
+ * qla4xxx_async_iocbs - processes ASYNC PDU IOCBS, if they are greater in
+ * length than 48 bytes (i.e., more than just the iscsi header). Used for
+ * unsolicited pdus received from target.
+ */
+static void qla4xxx_async_iocbs(struct scsi_qla_host *ha,
+		struct async_msg_pdu_iocb *amsg_pdu_iocb)
+{
+	struct iscsi_hdr *hdr;
+	struct async_pdu_iocb *apdu;
+	uint32_t len;
+	void *buf_addr;
+	dma_addr_t buf_addr_dma;
+	uint32_t offset;
+	struct passthru0 *pthru0_iocb;
+	struct scsi_sense_hdr sshdr;
+	struct ddb_entry *ddb_entry = NULL;
+	uint8_t using_prealloc = 1;
+	uint8_t async_event_type;
+
+	apdu = (struct async_pdu_iocb *)amsg_pdu_iocb->iocb;
+	hdr = (struct iscsi_hdr *)apdu->iscsi_pdu_hdr;
+	len = hdr->hlength + hdr->dlength[2] +
+		(hdr->dlength[1]<<8) + (hdr->dlength[0]<<16);
+
+	offset = sizeof (struct passthru0) + sizeof (struct passthru_status);
+	if (len <= (PAGE_SIZE - offset)) {
+		buf_addr_dma = ha->gen_req_rsp_iocb_dma + offset;
+		buf_addr = (uint8_t *)ha->gen_req_rsp_iocb + offset;
+	} else {
+		using_prealloc = 0;
+		buf_addr = dma_alloc_coherent(&ha->pdev->dev, len,
+                                        &buf_addr_dma, GFP_KERNEL);
+		if (!buf_addr) {
+			dev_info(&ha->pdev->dev,
+				"%s: dma_alloc_coherent failed\n", __func__);
+			return;
+		}
+	}
+	/* Create the pass-thru0 iocb */
+	pthru0_iocb = ha->gen_req_rsp_iocb;
+	memset(pthru0_iocb, 0, offset);
+
+	pthru0_iocb->hdr.entryType = ET_PASSTHRU0;
+	pthru0_iocb->controlFlags =
+		cpu_to_le16(PT_FLAG_ISCSI_PDU | PT_FLAG_WAIT_4_RESPONSE);
+	pthru0_iocb->timeout = cpu_to_le16(PT_DEFAULT_TIMEOUT);
+	pthru0_iocb->inDataSeg64.base.addrHigh =
+		cpu_to_le32(MSDW(buf_addr_dma));
+	pthru0_iocb->inDataSeg64.base.addrLow =
+		cpu_to_le32(LSDW(buf_addr_dma));
+	pthru0_iocb->inDataSeg64.count = cpu_to_le32(len);
+
+	if (qla4xxx_issue_iocb(ha, sizeof(struct passthru0),
+		ha->gen_req_rsp_iocb_dma) != QLA_SUCCESS) {
+		dev_info(&ha->pdev->dev,
+			"%s: qla4xxx_issue_iocb failed\n", __func__);
+		goto exit_async_pdu_iocb;
+	}
+ 
+	async_event_type = ((struct iscsi_async *)hdr)->async_event;
+	ddb_entry = ha->fw_ddb_index_map[apdu->target_id];
+
+	if (ddb_entry == NULL)
+		goto exit_async_pdu_iocb;
+
+	switch (async_event_type) {
+	case ISCSI_ASYNC_MSG_SCSI_EVENT:
+		if (!scsi_normalize_sense((uint8_t *)buf_addr, len, &sshdr)) {
+			dev_info(&ha->pdev->dev,
+				"%s: scsi_normalize_sense failed\n", __func__);
+			break;
+		}
+		if (sshdr.asc == 0x3f && sshdr.ascq == 0x0e) {
+			scsi_scan_target(&ddb_entry->sess->dev, 0,
+				ddb_entry->sess->target_id, SCAN_WILD_CARD, 0);
+		}
+		break;
+	case ISCSI_ASYNC_MSG_REQUEST_LOGOUT:
+		qla4xxx_conn_close_sess_logout(ha, apdu->target_id,0,0);
+		break;
+	default:
+		dev_info(&ha->pdev->dev,
+			"%s: async msg event 0x%x not processed\n",
+			__func__, async_event_type);
+		break;
+	};
+
+exit_async_pdu_iocb:
+	if (!using_prealloc)
+		dma_free_coherent(&ha->pdev->dev, len,
+			buf_addr, buf_addr_dma);
+
+	return;
+}
+
 /**
  * qla4xxx_do_dpc - dpc routine
  * @data: in our case pointer to adapter structure
@@ -1001,6 +1122,7 @@ static void qla4xxx_do_dpc(struct work_s
 	struct scsi_qla_host *ha =
 		container_of(work, struct scsi_qla_host, dpc_work);
 	struct ddb_entry *ddb_entry, *dtemp;
+	struct async_msg_pdu_iocb *apdu_iocb, *apdu_iocb_tmp;
 	int status = QLA_ERROR;
 
 	DEBUG2(printk("scsi%ld: %s: DPC handler waking up."
@@ -1076,6 +1198,18 @@ static void qla4xxx_do_dpc(struct work_s
 			}
 		}
 	}
+	/* Check for ASYNC PDU IOCBs */
+	if (adapter_up(ha) &&
+		test_bit(DPC_ASYNC_MSG_PDU, &ha->dpc_flags)) {
+
+		list_for_each_entry_safe(apdu_iocb, apdu_iocb_tmp,
+					 &ha->async_iocb_list, list) {
+			qla4xxx_async_iocbs(ha, apdu_iocb);
+			list_del_init(&apdu_iocb->list);
+			vfree(apdu_iocb);
+		}
+		clear_bit(DPC_ASYNC_MSG_PDU, &ha->dpc_flags);
+	}
 }
 
 /**
@@ -1229,6 +1363,7 @@ static int __devinit qla4xxx_probe_adapt
 	/* Initialize lists and spinlocks. */
 	INIT_LIST_HEAD(&ha->ddb_list);
 	INIT_LIST_HEAD(&ha->free_srb_q);
+	INIT_LIST_HEAD(&ha->async_iocb_list);
 
 	mutex_init(&ha->mbox_sem);
 
diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
index ab984cb..6980cb2 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,5 +5,5 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.01.00-k8"
+#define QLA4XXX_DRIVER_VERSION	"5.01.00-k9"
 

