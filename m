From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] RFC scsi_error: handle REPORT_LUNS_DATA_CHANGED, CAPACITY_DATA_CHANGED,
Date: Thu, 21 May 2009 10:23:15 -0500
Message-ID: <4A1571E3.6010305@cs.wisc.edu>
References: <12385252751209-git-send-email-michaelc@cs.wisc.edu>	<49E90243.7080806@cs.wisc.edu>	<49EC46A8.1070704@suse.de> <20090508094158T.fujita.tomonori@lab.ntt.co.jp> <4A1417CB.7000009@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060703000407040609090203"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49142 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbZEUPX0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 May 2009 11:23:26 -0400
In-Reply-To: <4A1417CB.7000009@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060703000407040609090203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hannes Reinecke wrote:
> Hi all,
> 
> FUJITA Tomonori wrote:
>> On Mon, 20 Apr 2009 11:55:52 +0200
>> Hannes Reinecke <hare@suse.de> wrote:
>>
>>> Hi Mike,
>>>
> [ .. ]
>>>> I was thinking that maybe using kobject_uevent_env would be better. The
>>>> info that gets passed to userspace would be the decoded sense and
>>>> asc/ascq based on values from the drivers/scsi/constants.c.
>>>>
>>> No. This patch has the possibility of generating _huge_ amounts of
>>> messages, most of which are information only and of no influence
>>> to the actual operation.
>>> udev would be flooded with it and won't be able to react to 'important'
>>> messages while processing them.
>> Do we really have huge amount of messages, errors, unit attentions,
>> etc?
>>
> There is a potential for that. Things which would normally ignored/retried
> silently (like UNIT ATTENTION) will suddenly be visible.
> And what's more, we'll be likely be getting plenty of errors if the
> target has some failure. And these will get multiplied when having
> a multipathed setup.
> But this is exactly when we rely on udev to process any 'real' events
> like device remove etc in time. So I'd rather use a separate mechanism
> for this.
> 
>> We already have a mechanism to send events to user space,
>> sdev_evt_send(). Could we simply use (or extend) it?
>>
> No, not really for above reasons.
> 

I attached an updated patch made against scsi-misc. Patch is still just 
an RFC.

In the patch I also converted libiscsi and qla4xxx so that they could 
pass in sense they get from iscsi async pdus if the target does that 
instead of sending it in the scsi command.

I also removed the QUEUE_FULL handling since in those other patches I am 
just handling it in the kernel since we want to change the queue depth 
before we start queueing more IO and hit the queue full again.

--------------060703000407040609090203
Content-Type: text/x-patch;
 name="scsi-send-all-sense-to-userspace.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-send-all-sense-to-userspace.patch"

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 759e150..4574c47 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -42,9 +42,14 @@ config SCSI_TGT
 	  If you choose M, the module will be called scsi_tgt.
 
 config SCSI_NETLINK
-	bool
+	bool "SCSI netlink event support"
 	default	n
 	select NET
+	---help---
+	   If you want to be able to send SCSI sense to userspace using
+	   the SCSI netlink socket interface say Y here. This is needed
+	   for handling events like REPORT_LUNS_DATA_CHANGED. Userspace
+	   can listen for events and rescan hosts or devices.
 
 config SCSI_PROC_FS
 	bool "legacy /proc/scsi/ support"
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 59908ae..49a6ddc 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -857,6 +857,48 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	return 0;
 }
 
+static int iscsi_handle_async_event(struct iscsi_conn *conn,
+				    struct iscsi_hdr *hdr, char *data,
+				    int datalen)
+{
+	struct iscsi_async *async_hdr = (struct iscsi_async *)hdr;
+	struct iscsi_session *session = conn->session;
+	uint16_t senselen;
+	int rc = 0;
+
+	conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
+
+	if (async_hdr->async_event != ISCSI_ASYNC_MSG_SCSI_EVENT) {
+		if (iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen))
+			rc = ISCSI_ERR_CONN_FAILED;
+		return rc;
+	}
+
+	if (datalen < 2) {
+		iscsi_conn_printk(KERN_ERR, conn, "Invalid data length of "
+				  "%d. Not enought room for SCSI sense. "
+				  "Dropping ISCSI ASYNC SCSI MSG.\n",
+				  datalen);
+		return 0;
+	}
+
+	senselen = get_unaligned_be16(data);
+	if (datalen < senselen) {
+		iscsi_conn_printk(KERN_ERR, conn, "Invalid sense length of "
+				  "%d. Length of buffer is only %d. Dropping "
+				  "ISCSI ASYNC MSG with SCSI SENSE.\n",
+				  senselen, datalen);
+		return 0;
+	}
+
+	scsi_post_error(session->host->host_no, 0,
+			session->cls_session->target_id,
+			scsilun_to_int((struct scsi_lun *) async_hdr->lun),
+			SAM_STAT_CHECK_CONDITION, data + 2,
+			min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));
+	return 0;
+}
+
 /**
  * iscsi_itt_to_task - look up task by itt
  * @conn: iscsi connection
@@ -937,9 +979,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			rc = iscsi_handle_reject(conn, hdr, data, datalen);
 			break;
 		case ISCSI_OP_ASYNC_EVENT:
-			conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
-			if (iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen))
-				rc = ISCSI_ERR_CONN_FAILED;
+			rc = iscsi_handle_async_event(conn, hdr, data, datalen);
 			break;
 		default:
 			rc = ISCSI_ERR_BAD_OPCODE;
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index b586f27..752d0b6 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -297,6 +297,7 @@ struct scsi_qla_host {
 #define DPC_ISNS_RESTART		7 /* 0x00000080 */
 #define DPC_AEN				9 /* 0x00000200 */
 #define DPC_GET_DHCP_IP_ADDR		15 /* 0x00008000 */
+#define DPC_ASYNC_MSG_PDU		16 /* 0x00010000 */
 
 	struct Scsi_Host *host; /* pointer to host data */
 	uint32_t tot_ddbs;
@@ -435,7 +436,14 @@ struct scsi_qla_host {
 
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
index 96ebfb0..d2f40b7 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -31,6 +31,11 @@ int qla4xxx_reset_target(struct scsi_qla_host * ha,
 			 struct ddb_entry * ddb_entry);
 int qla4xxx_get_flash(struct scsi_qla_host * ha, dma_addr_t dma_addr,
 		      uint32_t offset, uint32_t len);
+int qla4xxx_issue_iocb(struct scsi_qla_host *ha, uint32_t comp_offset,
+		       dma_addr_t phys_addr);
+int qla4xxx_conn_close_sess_logout(struct scsi_qla_host *ha,
+				   uint16_t fw_ddb_index,
+				   uint16_t connection_id, uint16_t option);
 int qla4xxx_get_firmware_status(struct scsi_qla_host * ha);
 int qla4xxx_get_firmware_state(struct scsi_qla_host * ha);
 int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha);
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 799120f..ae7f7bd 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -4,6 +4,7 @@
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
+#include <scsi/iscsi_proto.h>
 
 #include "ql4_def.h"
 #include "ql4_glbl.h"
@@ -285,6 +286,10 @@ static void qla4xxx_process_response_queue(struct scsi_qla_host * ha)
 	uint32_t count = 0;
 	struct srb *srb = NULL;
 	struct status_entry *sts_entry;
+	struct async_pdu_iocb *apdu;
+	struct iscsi_hdr *pdu_hdr;
+	struct async_msg_pdu_iocb *apdu_iocb;
+	unsigned long flags;
 
 	/* Process all responses from response queue */
 	while ((ha->response_in =
@@ -315,6 +320,31 @@ static void qla4xxx_process_response_queue(struct scsi_qla_host * ha)
 		case ET_PASSTHRU_STATUS:
 			break;
 
+		case ET_ASYNC_PDU:
+			apdu = (struct async_pdu_iocb *)sts_entry;
+			if (apdu->status != ASYNC_PDU_IOCB_STS_OK)
+				break;
+
+			pdu_hdr = (struct iscsi_hdr *)apdu->iscsi_pdu_hdr;
+			if (pdu_hdr->hlength || pdu_hdr->dlength[0] ||
+			    pdu_hdr->dlength[1] || pdu_hdr->dlength[2]) {
+				apdu_iocb = kmalloc(sizeof(
+						struct async_msg_pdu_iocb),
+						GFP_ATOMIC);
+				if (!apdu_iocb)
+					break;
+
+				memcpy(apdu_iocb->iocb, apdu,
+					sizeof(struct async_pdu_iocb));
+				spin_lock_irqsave(&ha->hardware_lock, flags);
+				list_add_tail(&apdu_iocb->list,
+					      &ha->async_iocb_list);
+				set_bit(DPC_ASYNC_MSG_PDU, &ha->dpc_flags);
+				spin_unlock_irqrestore(&ha->hardware_lock,
+						       flags);
+			}
+			break;
+
 		case ET_STATUS_CONTINUATION:
 			/* Just throw away the status continuation entries */
 			DEBUG2(printk("scsi%ld: %s: Status Continuation entry "
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 051b0f5..00da6ed 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -862,7 +862,6 @@ static int qla4xxx_req_ddb_entry(struct scsi_qla_host *ha, uint32_t *ddb_index)
 	return QLA_SUCCESS;
 }
 
-
 int qla4xxx_send_tgts(struct scsi_qla_host *ha, char *ip, uint16_t port)
 {
 	struct dev_db_entry *fw_ddb_entry;
@@ -915,3 +914,51 @@ qla4xxx_send_tgts_exit:
 	return ret_val;
 }
 
+int
+qla4xxx_issue_iocb(struct scsi_qla_host *ha, uint32_t comp_offset,
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
+					 &mbox_sts[0]);
+	return status;
+}
+
+int qla4xxx_conn_close_sess_logout(struct scsi_qla_host *ha,
+				   uint16_t fw_ddb_index,
+				   uint16_t connection_id, uint16_t option)
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
+				    &mbox_sts[0]) != QLA_SUCCESS) {
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
index ec9da6c..59276e7 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -8,6 +8,8 @@
 
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
+#include <scsi/iscsi_proto.h>
+#include <scsi/scsi_eh.h>
 
 #include "ql4_def.h"
 #include "ql4_version.h"
@@ -481,10 +483,24 @@ qc_fail_command:
  **/
 static void qla4xxx_mem_free(struct scsi_qla_host *ha)
 {
+	struct async_msg_pdu_iocb *apdu_iocb, *tmp;
+	unsigned long flags;
+
 	if (ha->queues)
 		dma_free_coherent(&ha->pdev->dev, ha->queues_len, ha->queues,
 				  ha->queues_dma);
 
+	if (ha->gen_req_rsp_iocb)
+		dma_free_coherent(&ha->pdev->dev, PAGE_SIZE,
+			ha->gen_req_rsp_iocb, ha->gen_req_rsp_iocb_dma);
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	list_for_each_entry_safe(apdu_iocb, tmp, &ha->async_iocb_list, list) {
+		list_del_init(&apdu_iocb->list);
+		kfree(apdu_iocb);
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 	ha->queues_len = 0;
 	ha->queues = NULL;
 	ha->queues_dma = 0;
@@ -569,6 +585,15 @@ static int qla4xxx_mem_alloc(struct scsi_qla_host *ha)
 
 		goto mem_alloc_error_exit;
 	}
+	ha->gen_req_rsp_iocb = dma_alloc_coherent(&ha->pdev->dev, PAGE_SIZE,
+						  &ha->gen_req_rsp_iocb_dma,
+						  GFP_KERNEL);
+	if (ha->gen_req_rsp_iocb == NULL) {
+		dev_warn(&ha->pdev->dev,
+			"Memory Allocation failed - gen_req_rsp_iocb.\n");
+
+		goto mem_alloc_error_exit;
+	}
 
 	return QLA_SUCCESS;
 
@@ -667,7 +692,8 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 	     test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags) ||
 	     test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
 	     test_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags) ||
-	     test_bit(DPC_AEN, &ha->dpc_flags)) &&
+	     test_bit(DPC_AEN, &ha->dpc_flags) ||
+	     test_bit(DPC_ASYNC_MSG_PDU, &ha->dpc_flags)) &&
 	     ha->dpc_thread) {
 		DEBUG2(printk("scsi%ld: %s: scheduling dpc routine"
 			      " - dpc flags = 0x%lx\n",
@@ -984,6 +1010,101 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha,
 	return status;
 }
 
+/*
+ * qla4xxx_async_iocbs - processes ASYNC PDU IOCBS, if they are greater in
+ * length than 48 bytes (i.e., more than just the iscsi header). Used for
+ * unsolicited pdus received from target.
+ */
+static void qla4xxx_async_iocbs(struct scsi_qla_host *ha,
+				struct async_msg_pdu_iocb *amsg_pdu_iocb)
+{
+	struct iscsi_hdr *hdr;
+	struct async_pdu_iocb *apdu;
+	uint32_t len;
+	void *buf_addr;
+	dma_addr_t buf_addr_dma;
+	uint32_t offset;
+	struct passthru0 *pthru0_iocb;
+	struct ddb_entry *ddb_entry = NULL;
+	uint8_t using_prealloc = 1;
+	uint8_t async_event_type;
+
+	apdu = (struct async_pdu_iocb *)amsg_pdu_iocb->iocb;
+	hdr = (struct iscsi_hdr *)apdu->iscsi_pdu_hdr;
+	len = hdr->hlength + hdr->dlength[2] +
+		(hdr->dlength[1] << 8) + (hdr->dlength[0] << 16);
+
+	offset = sizeof(struct passthru0) + sizeof(struct passthru_status);
+	if (len <= (PAGE_SIZE - offset)) {
+		buf_addr_dma = ha->gen_req_rsp_iocb_dma + offset;
+		buf_addr = (uint8_t *)ha->gen_req_rsp_iocb + offset;
+	} else {
+		using_prealloc = 0;
+		buf_addr = dma_alloc_coherent(&ha->pdev->dev, len,
+					      &buf_addr_dma, GFP_KERNEL);
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
+	pthru0_iocb->hdr.entryCount = 1;
+	pthru0_iocb->target = cpu_to_le16(apdu->target_id);
+	pthru0_iocb->controlFlags =
+		cpu_to_le16(PT_FLAG_ISCSI_PDU | PT_FLAG_WAIT_4_RESPONSE);
+	pthru0_iocb->timeout = cpu_to_le16(PT_DEFAULT_TIMEOUT);
+	pthru0_iocb->inDataSeg64.base.addrHigh =
+		cpu_to_le32(MSDW(buf_addr_dma));
+	pthru0_iocb->inDataSeg64.base.addrLow =
+		cpu_to_le32(LSDW(buf_addr_dma));
+	pthru0_iocb->inDataSeg64.count = cpu_to_le32(len);
+	pthru0_iocb->async_pdu_handle = cpu_to_le32(apdu->async_pdu_handle);
+
+	if (qla4xxx_issue_iocb(ha, sizeof(struct passthru0),
+			       ha->gen_req_rsp_iocb_dma) != QLA_SUCCESS) {
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
+		scsi_post_error(ha->host_no, 0, apdu->target_id,
+				scsilun_to_int((struct scsi_lun *) hdr->lun),
+				SAM_STAT_CHECK_CONDITION, buf_addr, len);
+		break;
+	case ISCSI_ASYNC_MSG_REQUEST_LOGOUT:
+		qla4xxx_conn_close_sess_logout(ha, apdu->target_id, 0, 0);
+		iscsi_block_session(ddb_entry->sess);
+
+		/* Re-establish session */
+		qla4xxx_set_ddb_entry(ha, ddb_entry->fw_ddb_index, 0);
+		/* Session gets unblocked due to AEN at session establishment */
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
+}
+
 /**
  * qla4xxx_do_dpc - dpc routine
  * @data: in our case pointer to adapter structure
@@ -994,13 +1115,15 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha,
  * so you can do anything (i.e. put the process to sleep etc).  In fact,
  * the mid-level tries to sleep when it reaches the driver threshold
  * "host->can_queue". This can cause a panic if we were in our interrupt code.
- **/
+ */
 static void qla4xxx_do_dpc(struct work_struct *work)
 {
 	struct scsi_qla_host *ha =
 		container_of(work, struct scsi_qla_host, dpc_work);
 	struct ddb_entry *ddb_entry, *dtemp;
+	struct async_msg_pdu_iocb *apdu_iocb;
 	int status = QLA_ERROR;
+	unsigned long flags;
 
 	DEBUG2(printk("scsi%ld: %s: DPC handler waking up."
 		"flags = 0x%08lx, dpc_flags = 0x%08lx ctrl_stat = 0x%08x\n",
@@ -1075,6 +1198,23 @@ static void qla4xxx_do_dpc(struct work_struct *work)
 			}
 		}
 	}
+	/* Check for ASYNC PDU IOCBs */
+	if (adapter_up(ha) && test_bit(DPC_ASYNC_MSG_PDU, &ha->dpc_flags)) {
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		while (!list_empty(&ha->async_iocb_list)) {
+			apdu_iocb = list_entry(ha->async_iocb_list.next,
+						struct async_msg_pdu_iocb,
+						list);
+			list_del_init(&apdu_iocb->list);
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+			qla4xxx_async_iocbs(ha, apdu_iocb);
+			kfree(apdu_iocb);
+			spin_lock_irqsave(&ha->hardware_lock, flags);
+		}
+		clear_bit(DPC_ASYNC_MSG_PDU, &ha->dpc_flags);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	}
 }
 
 /**
@@ -1228,6 +1368,7 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
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
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 0c2c73b..cf35f91 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
+#include <net/netlink.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -33,6 +34,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_netlink.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -213,10 +215,97 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
 }
 #endif
 
+#ifdef CONFIG_SCSI_NETLINK
+/**
+ * scsi_post_error - Pass failure info to userspace parser
+ * @host_no: host number
+ * @channel: bus/channel number
+ * @id: target number
+ * @lun: logical unit number
+ * @result: cmd result
+ * @sense_buf: sense buffer to copy to userspace
+ * @sense_len: number os bytes of sense buffer to copy
+ */
+void scsi_post_error(unsigned int host_no, unsigned int channel,
+		     unsigned int id, unsigned int lun, int result,
+		     const u8 *sense_buf, int sense_len) 
+{
+	struct sk_buff *skb;
+	struct nlmsghdr *nlh;
+	struct scsi_nl_cmd_err_event *ev;
+	u32 len, skblen;
+
+	if (!scsi_nl_sock)
+		return;
+
+	len = SCSI_NL_MSGALIGN(sizeof(*ev) + sense_len);
+	skblen = NLMSG_SPACE(len);
+
+	skb = alloc_skb(skblen, GFP_ATOMIC);
+	if (!skb) {
+		printk(KERN_INFO "Could not pass sense to userspace. "
+		       "Could not allocate buffer.\n");
+		return;
+	}
+
+	nlh = nlmsg_put(skb, 0, 0, SCSI_TRANSPORT_MSG,
+			skblen - sizeof(*nlh), 0);
+	if (!nlh) {
+		printk(KERN_INFO "Could not pass sense to userspace. "
+		       "Could not setup buffer space.\n");
+		goto free_skb;
+	}
+
+	ev = NLMSG_DATA(nlh);
+	INIT_SCSI_NL_HDR(&ev->snlh, 0, SCSI_NL_CMD_ERR, len);
+	ev->seconds = get_seconds();
+	ev->host_no = host_no;
+	ev->id = id;
+	ev->channel = channel;
+	ev->lun = lun;
+
+	ev->status = result & 0xff;
+	ev->masked_status = status_byte(result);
+	ev->msg_status = msg_byte(result);
+	ev->host_status = host_byte(result);
+	ev->driver_status = driver_byte(result);
+	ev->sense_len = sense_len;
+
+	if (sense_len && sense_buf)
+		memcpy(&ev[1], sense_buf, sense_len);
+	nlmsg_multicast(scsi_nl_sock, skb, 0, SCSI_NL_GRP_CMD_ERR, GFP_ATOMIC);
+	return;
+
+free_skb:
+	kfree_skb(skb);
+}
+EXPORT_SYMBOL_GPL(scsi_post_error);
+
+#endif
+
+/**
+ * scsi_post_cmd_error - Pass scsi command failure info to userspace parser
+ * @scmd: scsi command
+ */
+static void scsi_post_cmd_error(struct scsi_cmnd *scmd)
+{
+	struct scsi_device *sdev = scmd->device;
+	struct scsi_sense_hdr sshdr;
+	int sense_len = 0;
+
+	if (status_byte(scmd->result) == CHECK_CONDITION &&
+	    scsi_command_normalize_sense(scmd, &sshdr))
+		sense_len = SCSI_SENSE_BUFFERSIZE;
+
+	scsi_post_error(sdev->host->host_no, sdev->channel,
+			sdev->id, sdev->lun, scmd->result,
+			scmd->sense_buffer, sense_len);
+}
+
 /**
  * scsi_check_sense - Examine scsi cmd sense
  * @scmd:	Cmd to have sense checked.
- *
+ * @post_err:	bool indicating whether to notify userspace
  * Return value:
  * 	SUCCESS or FAILED or NEEDS_RETRY
  *
@@ -224,7 +313,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
  *	When a deferred error is detected the current command has
  *	not been executed and needs retrying.
  */
-static int scsi_check_sense(struct scsi_cmnd *scmd)
+static int scsi_check_sense(struct scsi_cmnd *scmd, bool post_err)
 {
 	struct scsi_device *sdev = scmd->device;
 	struct scsi_sense_hdr sshdr;
@@ -232,6 +321,9 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
 		return FAILED;	/* no valid sense data */
 
+	if (post_err)
+		scsi_post_cmd_error(scmd);
+
 	if (scsi_sense_is_deferred(&sshdr))
 		return NEEDS_RETRY;
 
@@ -354,7 +446,7 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 		 * is valid, we have a pretty good idea of what to do.
 		 * if not, we mark it as FAILED.
 		 */
-		return scsi_check_sense(scmd);
+		return scsi_check_sense(scmd, 1);
 	}
 	if (host_byte(scmd->result) != DID_OK)
 		return FAILED;
@@ -374,7 +466,7 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 	case COMMAND_TERMINATED:
 		return SUCCESS;
 	case CHECK_CONDITION:
-		return scsi_check_sense(scmd);
+		return scsi_check_sense(scmd, 1);
 	case CONDITION_GOOD:
 	case INTERMEDIATE_GOOD:
 	case INTERMEDIATE_C_GOOD:
@@ -951,7 +1043,7 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 		stu_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry)
 			if (scmd->device == sdev && SCSI_SENSE_VALID(scmd) &&
-			    scsi_check_sense(scmd) == FAILED ) {
+			    scsi_check_sense(scmd, 0) == FAILED ) {
 				stu_scmd = scmd;
 				break;
 			}
@@ -1398,7 +1490,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	case TASK_ABORTED:
 		goto maybe_retry;
 	case CHECK_CONDITION:
-		rtn = scsi_check_sense(scmd);
+		rtn = scsi_check_sense(scmd, 1);
 		if (rtn == NEEDS_RETRY)
 			goto maybe_retry;
 		/* if rtn == FAILED, we have no sense information;
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 06a8790..6ce525b 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -47,6 +47,17 @@ extern int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 extern int scsi_command_normalize_sense(struct scsi_cmnd *cmd,
 		struct scsi_sense_hdr *sshdr);
 
+#ifdef CONFIG_SCSI_NETLINK
+extern void scsi_post_error(unsigned int host_no, unsigned int channel,
+			    unsigned int id, unsigned int lun, int result,
+			    const u8 *sense_buf, int sense_len);
+#else
+static inline void scsi_post_error(unsigned int host_no, unsigned int channel,
+				   unsigned int id, unsigned int lun,
+				   int result, const u8 *sense_buf,
+				   int sense_len) {}
+#endif
+
 static inline int scsi_sense_is_deferred(struct scsi_sense_hdr *sshdr)
 {
 	return ((sshdr->response_code >= 0x70) && (sshdr->response_code & 1));
diff --git a/include/scsi/scsi_netlink.h b/include/scsi/scsi_netlink.h
index 536752c..2cac0f5 100644
--- a/include/scsi/scsi_netlink.h
+++ b/include/scsi/scsi_netlink.h
@@ -35,8 +35,8 @@
 /* SCSI Transport Broadcast Groups */
 	/* leaving groups 0 and 1 unassigned */
 #define SCSI_NL_GRP_FC_EVENTS		(1<<2)		/* Group 2 */
-#define SCSI_NL_GRP_CNT			3
-
+#define SCSI_NL_GRP_CMD_ERR		(1<<3)
+#define SCSI_NL_GRP_CNT			4
 
 /* SCSI_TRANSPORT_MSG event message header */
 struct scsi_nl_hdr {
@@ -65,6 +65,7 @@ struct scsi_nl_hdr {
  */
 	/* kernel -> user */
 #define SCSI_NL_SHOST_VENDOR			0x0001
+#define SCSI_NL_CMD_ERR				0x0002
 	/* user -> kernel */
 /* SCSI_NL_SHOST_VENDOR msgtype is kernel->user and user->kernel */
 
@@ -76,6 +77,26 @@ struct scsi_nl_hdr {
 /* macro to round up message lengths to 8byte boundary */
 #define SCSI_NL_MSGALIGN(len)		(((len) + 7) & ~7)
 
+/*
+ * SCSI CMD error event:
+ *   SCSI_NL_CMD_ERR
+ *
+ * Note: The sense buffer is placed after this structure.
+ */
+struct scsi_nl_cmd_err_event {
+	struct scsi_nl_hdr snlh;	/* must be 1st element ! */
+	uint64_t seconds;
+	uint64_t host_no;
+	uint64_t lun;
+	uint32_t channel;
+	uint32_t id;
+	uint16_t sense_len;		/* len of sense buffer */	
+	uint8_t status;			/* scsi status */
+	uint8_t masked_status;		/* shifted, masked scsi status */
+	uint8_t msg_status;		/* messaging level data (optional) */
+	uint8_t host_status;		/* errors from host adapter */
+	uint8_t driver_status;		/* errors from software driver */
+} __attribute__((aligned(sizeof(uint64_t))));
 
 /*
  * SCSI HOST Vendor Unique messages :

--------------060703000407040609090203--
