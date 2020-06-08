Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE92C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 18:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B3782063A
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 18:47:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="O6JUUaA3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbgFHSrs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 14:47:48 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40394 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725280AbgFHSrr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 14:47:47 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 058IetQO017180
        for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2020 11:47:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=mfwimV6KlK6UET8FDvPbVa776p6Rvmbh7bJdJSVabCE=;
 b=O6JUUaA3uBjdSJvHN6Xp6WR6nUxUpK5XM0gbh+n1R61ZkPQLI2i6bJa+wxgU6jUPiid6
 xGwZgM1UMTAsDz+pqtbt94sZWipblIVk2XyoDHyuE/D4RRyvSX2NRZsp9pi9fHkComwu
 NuC8qxzSYBb5N5H1i/1bbGVLcBS8STqXS4wm3RdrEbGMWkwTtAJdumaTNqizFII4IKKy
 p2QW4HDS0S4Ct3IZ4rOXjprx79vqhrh8TiMVdBXQheWLDpgp6P9eBFE+TPTTnCwPr5CO
 McKOdEc/jBvU9CcC95kvpTbtD4b8CIDXWf4xilm2SWSRDwWWjg5NsiGtySxaXqODYL1V hA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 31g8gnxsed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jun 2020 11:47:44 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 8 Jun
 2020 11:47:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 8 Jun 2020 11:47:43 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 88F8F3F7041;
        Mon,  8 Jun 2020 11:47:43 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 058IlhFb031633;
        Mon, 8 Jun 2020 11:47:43 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 058Ilhg6031624;
        Mon, 8 Jun 2020 11:47:43 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 2/2] qla2xxx: SAN congestion management(SCM) implementation.
Date:   Mon, 8 Jun 2020 11:46:30 -0700
Message-ID: <20200608184630.31574-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200608184630.31574-1-njavali@marvell.com>
References: <20200608184630.31574-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-08_17:2020-06-08,2020-06-08 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shyam Sundar <ssundar@marvell.com>

* Firmware Initialization with SCM enabled based on NVRAM setting and
  firmware support (About Firmware).
* Enable PUREX and add support for fabric performance impact
  notification(FPIN) handling.
* Allocate a default purex item for each vha, to handle memory
  allocation failures in ISR.

Signed-off-by: Shyam Sundar <ssundar@marvell.com>
Reviewed-by: Arun Easi <aeasi@marvell.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |  13 +--
 drivers/scsi/qla2xxx/qla_def.h  |  51 +++++++++
 drivers/scsi/qla2xxx/qla_fw.h   |   6 +-
 drivers/scsi/qla2xxx/qla_gbl.h  |   1 +
 drivers/scsi/qla2xxx/qla_init.c |   9 +-
 drivers/scsi/qla2xxx/qla_isr.c  | 191 ++++++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_mbx.c  |  42 ++++++-
 drivers/scsi/qla2xxx/qla_os.c   |  18 +++
 8 files changed, 297 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 1206f7c1ce6a..8af26be684d4 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -11,10 +11,8 @@
  * ----------------------------------------------------------------------
  * |             Level            |   Last Value Used  |     Holes	|
  * ----------------------------------------------------------------------
- * | Module Init and Probe        |       0x0193       | 0x0146         |
- * |                              |                    | 0x015b-0x0160	|
- * |                              |                    | 0x016e		|
- * | Mailbox commands             |       0x1206       | 0x11a2-0x11ff	|
+ * | Module Init and Probe        |       0x0199       |                |
+ * | Mailbox commands             |       0x1206       | 0x11a5-0x11ff	|
  * | Device Discovery             |       0x2134       | 0x210e-0x2116  |
  * |				  | 		       | 0x211a         |
  * |                              |                    | 0x211c-0x2128  |
@@ -26,11 +24,7 @@
  * |                              |                    | 0x3036,0x3038  |
  * |                              |                    | 0x303a		|
  * | DPC Thread                   |       0x4023       | 0x4002,0x4013  |
- * | Async Events                 |       0x5090       | 0x502b-0x502f  |
- * |				  | 		       | 0x5047         |
- * |                              |                    | 0x5084,0x5075	|
- * |                              |                    | 0x503d,0x5044  |
- * |                              |                    | 0x505f		|
+ * | Async Events                 |       0x509c       |                |
  * | Timer Routines               |       0x6012       |                |
  * | User Space Interactions      |       0x70e3       | 0x7018,0x702e  |
  * |				  |		       | 0x7020,0x7024  |
@@ -2752,7 +2746,6 @@ ql_dump_regs(uint level, scsi_qla_host_t *vha, uint id)
 		    "mbox[%d] %#04x\n", i, RD_REG_WORD(mbx_reg));
 }
 
-
 void
 ql_dump_buffer(uint level, scsi_qla_host_t *vha, uint id, const void *buf,
 	       uint size)
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 2e058ac4fec7..964567a8b48c 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1020,6 +1020,7 @@ static inline bool qla2xxx_is_valid_mbs(unsigned int mbs)
 #define MBA_LIP_F8		0x8016	/* Received a LIP F8. */
 #define MBA_LOOP_INIT_ERR	0x8017	/* Loop Initialization Error. */
 #define MBA_FABRIC_AUTH_REQ	0x801b	/* Fabric Authentication Required. */
+#define MBA_CONGN_NOTI_RECV	0x801e	/* Congestion Notification Received */
 #define MBA_SCSI_COMPLETION	0x8020	/* SCSI Command Complete. */
 #define MBA_CTIO_COMPLETION	0x8021	/* CTIO Complete. */
 #define MBA_IP_COMPLETION	0x8022	/* IP Transmit Command Complete. */
@@ -1480,6 +1481,25 @@ typedef struct {
 	uint8_t  reserved_3[26];
 } init_cb_t;
 
+/* Special Features Control Block */
+struct init_sf_cb {
+	uint8_t	format;
+	uint8_t	reserved0;
+	/*
+	 * BIT 15-14 = Reserved
+	 * BIT_13 = SAN Congestion Management (1 - Enabled, 0 - Disabled)
+	 * BIT_12 = Remote Write Optimization (1 - Enabled, 0 - Disabled)
+	 * BIT 11-0 = Reserved
+	 */
+	uint16_t flags;
+	uint8_t	reserved1[32];
+	uint16_t discard_OHRB_timeout_value;
+	uint16_t remote_write_opt_queue_num;
+	uint8_t	reserved2[40];
+	uint8_t scm_related_parameter[16];
+	uint8_t reserved3[32];
+};
+
 /*
  * Get Link Status mailbox command return buffer.
  */
@@ -2153,6 +2173,8 @@ typedef struct {
 	struct dsd64 rsp_dsd;
 } ms_iocb_entry_t;
 
+#define SCM_EDC_ACC_RECEIVED		BIT_6
+#define SCM_RDF_ACC_RECEIVED		BIT_7
 
 /*
  * ISP queue - Mailbox Command entry structure definition.
@@ -3822,6 +3844,12 @@ struct qla_hw_data {
 		uint32_t        n2n_bigger:1;
 		uint32_t	secure_adapter:1;
 		uint32_t	secure_fw:1;
+				/* Supported by Adapter */
+		uint32_t	scm_supported_a:1;
+				/* Supported by Firmware */
+		uint32_t	scm_supported_f:1;
+				/* Enabled in Driver */
+		uint32_t	scm_enabled:1;
 	} flags;
 
 	uint16_t max_exchg;
@@ -4139,6 +4167,13 @@ struct qla_hw_data {
 	int		init_cb_size;
 	dma_addr_t	ex_init_cb_dma;
 	struct ex_init_cb_81xx *ex_init_cb;
+	dma_addr_t	sf_init_cb_dma;
+	struct init_sf_cb *sf_init_cb;
+
+	void		*scm_fpin_els_buff;
+	uint64_t	scm_fpin_els_buff_size;
+	bool		scm_fpin_valid;
+	bool		scm_fpin_payload_size;
 
 	void		*async_pd;
 	dma_addr_t	async_pd_dma;
@@ -4201,6 +4236,12 @@ struct qla_hw_data {
 #define FW_ATTR_H_NVME		BIT_10
 #define FW_ATTR_H_NVME_UPDATED  BIT_14
 
+	/* About firmware SCM support */
+#define FW_ATTR_EXT0_SCM_SUPPORTED	BIT_12
+	/* Brocade fabric attached */
+#define FW_ATTR_EXT0_SCM_BROCADE	0x00001000
+	/* Cisco fabric attached */
+#define FW_ATTR_EXT0_SCM_CISCO		0x00002000
 	uint16_t	fw_attributes_ext[2];
 	uint32_t	fw_memory_size;
 	uint32_t	fw_transfer_size;
@@ -4511,6 +4552,15 @@ struct purex_item {
 	} iocb;
 };
 
+#define SCM_FLAG_RDF_REJECT		0x00
+#define SCM_FLAG_RDF_COMPLETED		0x01
+
+#define QLA_CON_PRIMITIVE_RECEIVED	0x1
+#define QLA_CONGESTION_ARB_WARNING	0x1
+#define QLA_CONGESTION_ARB_ALARM	0X2
+struct qla_scm_port {
+} __packed;
+
 /*
  * Qlogic scsi host structure
  */
@@ -4719,6 +4769,7 @@ typedef struct scsi_qla_host {
 	__le16 dport_data[4];
 	struct list_head gpnid_list;
 	struct fab_scan scan;
+	uint8_t	scm_fabric_connection_flags;
 
 	unsigned int irq_offset;
 } scsi_qla_host_t;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index f9bad5bd7198..a0d83c67dc23 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -723,6 +723,8 @@ struct ct_entry_24xx {
 	struct dsd64 dsd[2];
 };
 
+#define PURX_ELS_HEADER_SIZE	0x18
+
 /*
  * ISP queue - PUREX IOCB entry structure definition
  */
@@ -2020,7 +2022,9 @@ struct nvram_81xx {
 	 * BIT 0    = Extended BB credits for LR
 	 * BIT 1    = Virtual Fabric Enable
 	 * BIT 2-5  = Distance Support if BIT 0 is on
-	 * BIT 6-15 = Unused
+	 * BIT 6    = Prefer FCP
+	 * BIT 7    = SCM Disabled if BIT is set (1)
+	 * BIT 8-15 = Unused
 	 */
 	uint16_t enhanced_features;
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 54d82f7d478f..3ba21368d5b6 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -127,6 +127,7 @@ int qla_post_iidma_work(struct scsi_qla_host *vha, fc_port_t *fcport);
 void qla_do_iidma_work(struct scsi_qla_host *vha, fc_port_t *fcport);
 int qla2x00_reserve_mgmt_server_loop_id(scsi_qla_host_t *);
 void qla_rscn_replay(fc_port_t *fcport);
+void qla24xx_free_purex_item(struct purex_item *item);
 extern bool qla24xx_risc_firmware_invalid(uint32_t *);
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 95b6166ae0cc..35009ee93c97 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3752,7 +3752,7 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 		}
 
 		/* Enable PUREX PASSTHRU */
-		if (ql2xrdpenable)
+		if (ql2xrdpenable || ha->flags.scm_supported_f)
 			qla25xx_set_els_cmds_supported(vha);
 	} else
 		goto failed;
@@ -3965,7 +3965,7 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
 			ha->fw_options[2] &= ~BIT_8;
 	}
 
-	if (ql2xrdpenable)
+	if (ql2xrdpenable || ha->flags.scm_supported_f)
 		ha->fw_options[1] |= ADD_FO1_ENABLE_PUREX_IOCB;
 
 	/* Enable Async 8130/8131 events -- transceiver insertion/removal */
@@ -8514,6 +8514,11 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 		icb->node_name[0] &= 0xF0;
 	}
 
+	if (IS_QLA28XX(ha) || IS_QLA27XX(ha)) {
+		if ((nv->enhanced_features & BIT_7) == 0)
+			ha->flags.scm_supported_a = 1;
+	}
+
 	/* Set host adapter parameters. */
 	ha->flags.disable_risc_code_load = 0;
 	ha->flags.enable_lip_reset = 0;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 401ce0023cd5..fd4ead7fb047 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -22,6 +22,31 @@ static void qla2x00_status_entry(scsi_qla_host_t *, struct rsp_que *, void *);
 static void qla2x00_status_cont_entry(struct rsp_que *, sts_cont_entry_t *);
 static int qla2x00_error_entry(scsi_qla_host_t *, struct rsp_que *,
 	sts_entry_t *);
+static void qla27xx_process_purex_fpin(struct scsi_qla_host *vha,
+	struct purex_item *item);
+static struct purex_item *qla24xx_alloc_purex_item(scsi_qla_host_t *vha,
+	uint16_t size);
+static struct purex_item *qla24xx_copy_std_pkt(struct scsi_qla_host *vha,
+	void *pkt);
+static struct purex_item *qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha,
+	void **pkt, struct rsp_que **rsp);
+
+static void
+qla27xx_process_purex_fpin(struct scsi_qla_host *vha, struct purex_item *item)
+{
+	void *pkt = &item->iocb;
+	uint16_t pkt_size = item->size;
+
+	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x508d,
+	       "%s: Enter\n", __func__);
+
+	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x508e,
+	       "-------- ELS REQ -------\n");
+	ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, vha, 0x508f,
+		       pkt, pkt_size);
+
+	fc_host_fpin_rcv(vha->host, pkt_size, (char *)pkt);
+}
 
 const char *const port_state_str[] = {
 	"Unknown",
@@ -822,7 +847,7 @@ qla24xx_queue_purex_item(scsi_qla_host_t *vha, struct purex_item *pkt,
  * @vha: SCSI driver HA context
  * @pkt: ELS packet
  */
-struct purex_item
+static struct purex_item
 *qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
 {
 	struct purex_item *item;
@@ -836,6 +861,111 @@ struct purex_item
 	return item;
 }
 
+/**
+ * qla27xx_copy_fpin_pkt() - Copy over fpin packets that can
+ * span over multiple IOCBs.
+ * @vha: SCSI driver HA context
+ * @pkt: ELS packet
+ * @rsp: Response queue
+ */
+static struct purex_item *
+qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
+		      struct rsp_que **rsp)
+{
+	struct purex_entry_24xx *purex = *pkt;
+	struct rsp_que *rsp_q = *rsp;
+	sts_cont_entry_t *new_pkt;
+	uint16_t no_bytes = 0, total_bytes = 0, pending_bytes = 0;
+	uint16_t buffer_copy_offset = 0;
+	uint16_t entry_count, entry_count_remaining;
+	struct purex_item *item;
+	void *fpin_pkt = NULL;
+
+	total_bytes = le16_to_cpu(purex->frame_size & 0x0FFF)
+	    - PURX_ELS_HEADER_SIZE;
+	pending_bytes = total_bytes;
+	entry_count = entry_count_remaining = purex->entry_count;
+	no_bytes = (pending_bytes > sizeof(purex->els_frame_payload))  ?
+		   sizeof(purex->els_frame_payload) : pending_bytes;
+	ql_log(ql_log_info, vha, 0x509a,
+	       "FPIN ELS, frame_size 0x%x, entry count %d\n",
+	       total_bytes, entry_count);
+
+	item = qla24xx_alloc_purex_item(vha, total_bytes);
+	if (!item)
+		return item;
+
+	fpin_pkt = &item->iocb;
+
+	memcpy(fpin_pkt, &purex->els_frame_payload[0], no_bytes);
+	buffer_copy_offset += no_bytes;
+	pending_bytes -= no_bytes;
+	--entry_count_remaining;
+
+	((response_t *)purex)->signature = RESPONSE_PROCESSED;
+	wmb();
+
+	do {
+		while ((total_bytes > 0) && (entry_count_remaining > 0)) {
+			if (rsp_q->ring_ptr->signature == RESPONSE_PROCESSED) {
+				ql_dbg(ql_dbg_async, vha, 0x5084,
+				       "Ran out of IOCBs, partial data 0x%x\n",
+				       buffer_copy_offset);
+				cpu_relax();
+				continue;
+			}
+
+			new_pkt = (sts_cont_entry_t *)rsp_q->ring_ptr;
+			*pkt = new_pkt;
+
+			if (new_pkt->entry_type != STATUS_CONT_TYPE) {
+				ql_log(ql_log_warn, vha, 0x507a,
+				       "Unexpected IOCB type, partial data 0x%x\n",
+				       buffer_copy_offset);
+				break;
+			}
+
+			rsp_q->ring_index++;
+			if (rsp_q->ring_index == rsp_q->length) {
+				rsp_q->ring_index = 0;
+				rsp_q->ring_ptr = rsp_q->ring;
+			} else {
+				rsp_q->ring_ptr++;
+			}
+			no_bytes = (pending_bytes > sizeof(new_pkt->data)) ?
+			    sizeof(new_pkt->data) : pending_bytes;
+			if ((buffer_copy_offset + no_bytes) <= total_bytes) {
+				memcpy(((uint8_t *)fpin_pkt +
+				    buffer_copy_offset), new_pkt->data,
+				    no_bytes);
+				buffer_copy_offset += no_bytes;
+				pending_bytes -= no_bytes;
+				--entry_count_remaining;
+			} else {
+				ql_log(ql_log_warn, vha, 0x5044,
+				       "Attempt to copy more that we got, optimizing..%x\n",
+				       buffer_copy_offset);
+				memcpy(((uint8_t *)fpin_pkt +
+				    buffer_copy_offset), new_pkt->data,
+				    total_bytes - buffer_copy_offset);
+			}
+
+			((response_t *)new_pkt)->signature = RESPONSE_PROCESSED;
+			wmb();
+		}
+
+		if (pending_bytes != 0 || entry_count_remaining != 0) {
+			ql_log(ql_log_fatal, vha, 0x508b,
+			       "Dropping partial FPIN, underrun bytes = 0x%x, entry cnts 0x%x\n",
+			       total_bytes, entry_count_remaining);
+			qla24xx_free_purex_item(item);
+			return NULL;
+		}
+	} while (entry_count_remaining > 0);
+	host_to_fcp_swap((uint8_t *)&item->iocb, total_bytes);
+	return item;
+}
+
 /**
  * qla2x00_async_event() - Process aynchronous events.
  * @vha: SCSI driver HA context
@@ -1350,6 +1480,19 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 			qla2x00_post_aen_work(vha, FCH_EVT_RSCN, rscn_entry);
 		}
 		break;
+	case MBA_CONGN_NOTI_RECV:
+		if (!ha->flags.scm_enabled ||
+		    mb[1] != QLA_CON_PRIMITIVE_RECEIVED)
+			break;
+
+		if (mb[2] == QLA_CONGESTION_ARB_WARNING) {
+			ql_dbg(ql_dbg_async, vha, 0x509b,
+			       "Congestion Warning %04x %04x.\n", mb[1], mb[2]);
+		} else if (mb[2] == QLA_CONGESTION_ARB_ALARM) {
+			ql_log(ql_log_warn, vha, 0x509b,
+			       "Congestion Alarm %04x %04x.\n", mb[1], mb[2]);
+		}
+		break;
 	/* case MBA_RIO_RESPONSE: */
 	case MBA_ZIO_RESPONSE:
 		ql_dbg(ql_dbg_async, vha, 0x5015,
@@ -3279,6 +3422,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 {
 	struct sts_entry_24xx *pkt;
 	struct qla_hw_data *ha = vha->hw;
+	struct purex_entry_24xx *purex_entry;
 	struct purex_item *pure_item;
 
 	if (!ha->flags.fw_started)
@@ -3334,7 +3478,6 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 				pure_item = qla24xx_copy_std_pkt(vha, pkt);
 				if (!pure_item)
 					break;
-
 				qla24xx_queue_purex_item(vha, pure_item,
 							 qla24xx_process_abts);
 				break;
@@ -3384,29 +3527,39 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			    (struct vp_ctrl_entry_24xx *)pkt);
 			break;
 		case PUREX_IOCB_TYPE:
-		{
-			struct purex_entry_24xx *purex = (void *)pkt;
-
-			if (purex->els_frame_payload[3] != ELS_COMMAND_RDP) {
-				ql_dbg(ql_dbg_init, vha, 0x5091,
-				    "Discarding ELS Request opcode %#x...\n",
-				    purex->els_frame_payload[3]);
+			purex_entry = (void *)pkt;
+			switch (purex_entry->els_frame_payload[3]) {
+			case ELS_COMMAND_RDP:
+				pure_item = qla24xx_copy_std_pkt(vha, pkt);
+				if (!pure_item)
+					break;
+				qla24xx_queue_purex_item(vha, pure_item,
+						 qla24xx_process_purex_rdp);
 				break;
-			}
-			pure_item = qla24xx_copy_std_pkt(vha, pkt);
-			if (!pure_item)
+			case ELS_COMMAND_FPIN:
+				if (!vha->hw->flags.scm_enabled) {
+					ql_log(ql_log_warn, vha, 0x5094,
+					       "SCM not active for this port\n");
+					break;
+				}
+				pure_item = qla27xx_copy_fpin_pkt(vha,
+							  (void **)&pkt, &rsp);
+				if (!pure_item)
+					break;
+				qla24xx_queue_purex_item(vha, pure_item,
+						 qla27xx_process_purex_fpin);
 				break;
-
-			qla24xx_queue_purex_item(vha, pure_item,
-						 qla24xx_process_purex_rdp);
+			default:
+				ql_log(ql_log_warn, vha, 0x509c,
+				       "Discarding ELS Request opcode 0x%x\n",
+				       purex_entry->els_frame_payload[3]);
+			}
 			break;
-		}
 		default:
 			/* Type Not Supported. */
 			ql_dbg(ql_dbg_async, vha, 0x5042,
-			    "Received unknown response pkt type %x "
-			    "entry status=%x.\n",
-			    pkt->entry_type, pkt->entry_status);
+			       "Received unknown response pkt type 0x%x entry status=%x.\n",
+			       pkt->entry_type, pkt->entry_status);
 			break;
 		}
 		((response_t *)pkt)->signature = RESPONSE_PROCESSED;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index a1f899bb8c94..9d7e00652437 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1126,6 +1126,16 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 			    (ha->flags.secure_fw) ? "Supported" :
 			    "Not Supported");
 		}
+
+		if (ha->flags.scm_supported_a &&
+		    (ha->fw_attributes_ext[0] & FW_ATTR_EXT0_SCM_SUPPORTED)) {
+			ha->flags.scm_supported_f = 1;
+			memset(ha->sf_init_cb, 0, sizeof(struct init_sf_cb));
+			ha->sf_init_cb->flags |= BIT_13;
+		}
+		ql_log(ql_log_info, vha, 0x11a3, "SCM in FW: %s\n",
+		       (ha->flags.scm_supported_f) ? "Supported" :
+		       "Not Supported");
 	}
 
 failed:
@@ -1635,8 +1645,11 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
 		mcp->in_mb |= MBX_13|MBX_12|MBX_11|MBX_10;
 	if (IS_FWI2_CAPABLE(vha->hw))
 		mcp->in_mb |= MBX_19|MBX_18|MBX_17|MBX_16;
-	if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw))
+	if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw)) {
 		mcp->in_mb |= MBX_15;
+		mcp->out_mb |= MBX_7|MBX_21|MBX_22|MBX_23;
+	}
+
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
@@ -1689,8 +1702,22 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
 			}
 		}
 
-		if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw))
+		if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw)) {
 			vha->bbcr = mcp->mb[15];
+			if (mcp->mb[7] & SCM_EDC_ACC_RECEIVED) {
+				ql_log(ql_log_info, vha, 0x11a4,
+				       "SCM: EDC ELS completed, flags 0x%x\n",
+				       mcp->mb[21]);
+			}
+			if (mcp->mb[7] & SCM_RDF_ACC_RECEIVED) {
+				vha->hw->flags.scm_enabled = 1;
+				vha->scm_fabric_connection_flags |=
+				    SCM_FLAG_RDF_COMPLETED;
+				ql_log(ql_log_info, vha, 0x11a5,
+				       "SCM: RDF ELS completed, flags 0x%x\n",
+				       mcp->mb[23]);
+			}
+		}
 	}
 
 	return rval;
@@ -1803,6 +1830,17 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 		mcp->mb[14] = sizeof(*ha->ex_init_cb);
 		mcp->out_mb |= MBX_14|MBX_13|MBX_12|MBX_11|MBX_10;
 	}
+
+	if (ha->flags.scm_supported_f) {
+		mcp->mb[1] |= BIT_1;
+		mcp->mb[16] = MSW(ha->sf_init_cb_dma);
+		mcp->mb[17] = LSW(ha->sf_init_cb_dma);
+		mcp->mb[18] = MSW(MSD(ha->sf_init_cb_dma));
+		mcp->mb[19] = LSW(MSD(ha->sf_init_cb_dma));
+		mcp->mb[15] = sizeof(*ha->sf_init_cb);
+		mcp->out_mb |= MBX_19|MBX_18|MBX_17|MBX_16|MBX_15;
+	}
+
 	/* 1 and 2 should normally be captured. */
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
 	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 007f39128dbf..70241506d0ca 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4220,6 +4220,16 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 		    "ex_init_cb=%p.\n", ha->ex_init_cb);
 	}
 
+	/* Get consistent memory allocated for Special Features-CB. */
+	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		ha->sf_init_cb = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
+						&ha->sf_init_cb_dma);
+		if (!ha->sf_init_cb)
+			goto fail_sf_init_cb;
+		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0199,
+			   "sf_init_cb=%p.\n", ha->sf_init_cb);
+	}
+
 	INIT_LIST_HEAD(&ha->gbl_dsd_list);
 
 	/* Get consistent memory allocated for Async Port-Database. */
@@ -4273,6 +4283,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 fail_loop_id_map:
 	dma_pool_free(ha->s_dma_pool, ha->async_pd, ha->async_pd_dma);
 fail_async_pd:
+	dma_pool_free(ha->s_dma_pool, ha->sf_init_cb, ha->sf_init_cb_dma);
+fail_sf_init_cb:
 	dma_pool_free(ha->s_dma_pool, ha->ex_init_cb, ha->ex_init_cb_dma);
 fail_ex_init_cb:
 	kfree(ha->npiv_info);
@@ -4695,6 +4707,10 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	ha->ms_iocb = NULL;
 	ha->ms_iocb_dma = 0;
 
+	if (ha->sf_init_cb)
+		dma_pool_free(ha->s_dma_pool,
+			      ha->sf_init_cb, ha->sf_init_cb_dma);
+
 	if (ha->ex_init_cb)
 		dma_pool_free(ha->s_dma_pool,
 			ha->ex_init_cb, ha->ex_init_cb_dma);
@@ -4782,6 +4798,8 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	kfree(ha->swl);
 	ha->swl = NULL;
 	kfree(ha->loop_id_map);
+	ha->sf_init_cb = NULL;
+	ha->sf_init_cb_dma = 0;
 	ha->loop_id_map = NULL;
 }
 
-- 
2.19.0.rc0

