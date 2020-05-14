Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39FDC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 10:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C8DF2065D
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 10:11:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="A62WFJWJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgENKLr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 06:11:47 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15266 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725974AbgENKLq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 May 2020 06:11:46 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04EAA7kE018646
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 03:11:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=jqj6W8bJ5mJLTS0H4PAU6YFm5WTSKEZYOLWhKEFdUgM=;
 b=A62WFJWJYLBhJdWV+KgeiS9fg2uThS2F1PYIcqgLDXrZP2HA7yGko3w+Tm71KS3baPVK
 3L/ElBid81ph0sndTB3rpAp/p/7yjsWBkpDfKCuR3s2RQD5tfDGEbHMuYtKWuTeVACuw
 fHd/++/ktZNhvOFrmFV2UBCQox4UmrnvW9/TvrGUljHxuS6oxj36iPHERMQGSWrbTT6O
 VqXkGkds3EoWjuEcuonpvVMfKrO5hLmqWaeqZ9PLY6La8pVNgr1l0QGLp7Z6hNANgqDm
 XD92Cr36PqvvIRw+72vIbW4iZvpGGcNDC7Iw7ny51Kittio0DheI76Uvl7hChnCndBfU zw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3100xk1sss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 03:11:42 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 May
 2020 03:11:39 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 May
 2020 03:11:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 May 2020 03:11:38 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9B7293F703F;
        Thu, 14 May 2020 03:11:38 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 04EABcDL010091;
        Thu, 14 May 2020 03:11:38 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 04EABckB010082;
        Thu, 14 May 2020 03:11:38 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 2/3] qla2xxx: SAN congestion management(SCM) implementation.
Date:   Thu, 14 May 2020 03:10:25 -0700
Message-ID: <20200514101026.10040-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200514101026.10040-1-njavali@marvell.com>
References: <20200514101026.10040-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_02:2020-05-13,2020-05-14 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shyam Sundar <ssundar@marvell.com>

* Firmware Initialization with SCM enabled based on NVRAM setting and
  firmware support (About Firmware).
* Enable PUREX and add support for fabric performance impact
  notification(FPIN) handling.
* Support for the following FPIN descriptors:
  	1. Link Integrity Notification.
	2. Delivery Notification.
	3. Peer Congestion Notification.
	4. Congestion Notification.
* Mark a device as slow when a Peer Congestion Notification is received.
* Allocate a default purex item for each vha, to handle memory
  allocation failures in ISR.

Signed-off-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.h  | 115 +++++++
 drivers/scsi/qla2xxx/qla_dbg.c  |  13 +-
 drivers/scsi/qla2xxx/qla_def.h  |  89 ++++++
 drivers/scsi/qla2xxx/qla_fw.h   |   7 +-
 drivers/scsi/qla2xxx/qla_gbl.h  |   1 +
 drivers/scsi/qla2xxx/qla_init.c |   9 +-
 drivers/scsi/qla2xxx/qla_isr.c  | 532 ++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_mbx.c  |  45 ++-
 drivers/scsi/qla2xxx/qla_os.c   |  18 ++
 9 files changed, 795 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index 7594fad7b5b5..0b308859047c 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -290,4 +290,119 @@ struct qla_active_regions {
 	uint8_t reserved[32];
 } __packed;
 
+#define SCM_LINK_EVENT_UNKNOWN			0x0
+#define SCM_LINK_EVENT_LINK_FAILURE			0x1
+#define SCM_LINK_EVENT_LOSS_OF_SYNC			0x2
+#define SCM_LINK_EVENT_LOSS_OF_SIGNAL		0x3
+#define SCM_LINK_EVENT_PRIMITIVE_SEQ_PROTOCOL_ERROR	0x4
+#define SCM_LINK_EVENT_INVALID_TX_WORD		0x5
+#define SCM_LINK_EVENT_INVALID_CRC			0x6
+#define SCM_LINK_EVENT_DEVICE_SPECIFIC		0xF
+#define SCM_LINK_EVENT_V1_SIZE			20
+struct qla_scm_link_event {
+	uint64_t	timestamp;
+	uint16_t	event_type;
+	uint16_t	event_modifier;
+	uint32_t	event_threshold;
+	uint32_t	event_count;
+	uint8_t		reserved[12];
+} __packed;
+
+#define SCM_DELIVERY_REASON_UNKNOWN		0x0
+#define SCM_DELIVERY_REASON_TIMEOUT		0x1
+#define SCM_DELIVERY_REASON_UNABLE_TO_ROUTE	0x2
+#define SCM_DELIVERY_REASON_DEVICE_SPECIFIC	0xF
+struct qla_scm_delivery_event {
+	uint64_t	timestamp;
+	uint32_t	delivery_reason;
+	uint8_t		deliver_frame_hdr[24];
+	uint8_t		reserved[28];
+
+} __packed;
+
+#define SCM_CONGESTION_EVENT_CLEAR		0x0
+#define SCM_CONGESTION_EVENT_LOST_CREDIT	0x1
+#define SCM_CONGESTION_EVENT_CREDIT_STALL	0x2
+#define SCM_CONGESTION_EVENT_OVERSUBSCRIPTION	0x3
+#define SCM_CONGESTION_EVENT_DEVICE_SPECIFIC	0xF
+struct qla_scm_peer_congestion_event {
+	uint64_t	timestamp;
+	uint16_t	event_type;
+	uint16_t	event_modifier;
+	uint32_t	event_period;
+	uint8_t		reserved[16];
+} __packed;
+
+#define SCM_CONGESTION_SEVERITY_WARNING	0xF1
+#define SCM_CONGESTION_SEVERITY_ERROR	0xF7
+struct qla_scm_congestion_event {
+	uint64_t	timestamp;
+	uint16_t	event_type;
+	uint16_t	event_modifier;
+	uint32_t	event_period;
+	uint8_t		severity;
+	uint8_t		reserved[15];
+} __packed;
+
+#define SCM_FLAG_RDF_REJECT		0x00
+#define SCM_FLAG_RDF_COMPLETED		0x01
+#define SCM_FLAG_BROCADE_CONNECTED	0x02
+#define SCM_FLAG_CISCO_CONNECTED	0x04
+
+#define SCM_STATE_CONGESTION	0x1
+#define SCM_STATE_DELIVERY		0x2
+#define SCM_STATE_LINK_INTEGRITY	0x4
+#define SCM_STATE_PEER_CONGESTION	0x8
+
+#define QLA_CON_PRIMITIVE_RECEIVED	0x1
+#define QLA_CONGESTION_ARB_WARNING	0x1
+#define QLA_CONGESTION_ARB_ALARM	0X2
+struct qla_scm_port {
+	uint32_t			current_events;
+
+	struct qla_scm_link_event	link_integrity;
+	struct qla_scm_delivery_event	delivery;
+	struct qla_scm_congestion_event	congestion;
+	uint64_t			scm_congestion_alarm;
+	uint64_t			scm_congestion_warning;
+	uint8_t				scm_fabric_connection_flags;
+	uint8_t				reserved[43];
+} __packed;
+
+struct qla_scm_target {
+	uint8_t		wwpn[8];
+	uint32_t	current_events;
+
+	struct qla_scm_link_event		link_integrity;
+	struct qla_scm_delivery_event		delivery;
+	struct qla_scm_peer_congestion_event	peer_congestion;
+
+	uint32_t	link_failure_count;
+	uint32_t	loss_of_sync_count;
+	uint32_t        loss_of_signals_count;
+	uint32_t        primitive_seq_protocol_err_count;
+	uint32_t        invalid_transmission_word_count;
+	uint32_t        invalid_crc_count;
+
+	uint32_t        delivery_failure_unknown;
+	uint32_t        delivery_timeout;
+	uint32_t        delivery_unable_to_route;
+	uint32_t        delivery_failure_device_specific;
+
+	uint32_t        peer_congestion_clear;
+	uint32_t        peer_congestion_lost_credit;
+	uint32_t        peer_congestion_credit_stall;
+	uint32_t        peer_congestion_oversubscription;
+	uint32_t        peer_congestion_device_specific;
+	uint32_t	link_unknown_event;
+	uint32_t	link_device_specific_event;
+	uint8_t		reserved[48];
+} __packed;
+
+#define QLA_DRV_ATTR_SCM_SUPPORTED	0x00800000
+struct qla_drv_attr {
+	uint32_t	attributes;
+	uint8_t		reserved[28];
+} __packed;
+
 #endif
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
index 954d1a230b8a..882961d7246b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1018,6 +1018,7 @@ static inline bool qla2xxx_is_valid_mbs(unsigned int mbs)
 #define MBA_LIP_F8		0x8016	/* Received a LIP F8. */
 #define MBA_LOOP_INIT_ERR	0x8017	/* Loop Initialization Error. */
 #define MBA_FABRIC_AUTH_REQ	0x801b	/* Fabric Authentication Required. */
+#define MBA_CONGN_NOTI_RECV	0x801e	/* Congestion Notification Received */
 #define MBA_SCSI_COMPLETION	0x8020	/* SCSI Command Complete. */
 #define MBA_CTIO_COMPLETION	0x8021	/* CTIO Complete. */
 #define MBA_IP_COMPLETION	0x8022	/* IP Transmit Command Complete. */
@@ -1479,6 +1480,25 @@ typedef struct {
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
@@ -2152,6 +2172,52 @@ typedef struct {
 	struct dsd64 rsp_dsd;
 } ms_iocb_entry_t;
 
+#define SCM_EDC_ACC_RECEIVED		BIT_6
+#define SCM_RDF_ACC_RECEIVED		BIT_7
+#define SCM_NOTIFICATION_TYPE_LINK_INTEGRITY	0x00020001
+#define SCM_NOTIFICATION_TYPE_DELIVERY		0x00020002
+#define SCM_NOTIFICATION_TYPE_PEER_CONGESTION	0x00020003
+#define SCM_NOTIFICATION_TYPE_CONGESTION	0x00020004
+#define FPIN_DESCRIPTOR_HEADER_SIZE	4
+#define FPIN_ELS_DESCRIPTOR_LIST_OFFSET	8
+struct fpin_descriptor {
+	__be32 descriptor_tag;
+	__be32 descriptor_length;
+	union {
+		uint8_t common_detecting_port_name[WWN_SIZE];
+		struct {
+			uint8_t detecting_port_name[WWN_SIZE];
+			uint8_t attached_port_name[WWN_SIZE];
+			__be16 event_type;
+			__be16 event_modifier;
+			__be32 event_threshold;
+			__be32 event_count;
+			__be32 port_name_count;
+			uint8_t port_name_list[1][WWN_SIZE];
+		} link_integrity;
+		struct {
+			uint8_t detecting_port_name[WWN_SIZE];
+			uint8_t attached_port_name[WWN_SIZE];
+			__be32 delivery_reason_code;
+		} delivery;
+		struct {
+			uint8_t detecting_port_name[WWN_SIZE];
+			uint8_t attached_port_name[WWN_SIZE];
+			__be16 event_type;
+			__be16 event_modifier;
+			__be32 event_period;
+			__be32 port_name_count;
+			uint8_t port_name_list[1][WWN_SIZE];
+		} peer_congestion;
+		struct {
+			__be16 event_type;
+			__be16 event_modifier;
+			__be32 event_period;
+			uint8_t severity;
+			uint8_t reserved[3];
+		} congestion;
+	};
+};
 
 /*
  * ISP queue - Mailbox Command entry structure definition.
@@ -2412,6 +2478,7 @@ typedef struct fc_port {
 	unsigned int n2n_flag:1;
 	unsigned int explicit_logout:1;
 	unsigned int prli_pend_timer:1;
+	unsigned int slow_device:1;
 
 	struct completion nvme_del_done;
 	uint32_t nvme_prli_service_param;
@@ -2491,6 +2558,8 @@ typedef struct fc_port {
 	u8 last_login_state;
 	u16 n2n_link_reset_cnt;
 	u16 n2n_chip_reset;
+
+	struct qla_scm_target scm_stats;
 } fc_port_t;
 
 enum {
@@ -3821,6 +3890,12 @@ struct qla_hw_data {
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
@@ -4138,6 +4213,13 @@ struct qla_hw_data {
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
@@ -4200,6 +4282,12 @@ struct qla_hw_data {
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
@@ -4718,6 +4806,7 @@ typedef struct scsi_qla_host {
 	__le16 dport_data[4];
 	struct list_head gpnid_list;
 	struct fab_scan scan;
+	struct qla_scm_port scm_stats;
 
 	unsigned int irq_offset;
 } scsi_qla_host_t;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index f9bad5bd7198..fa45fc7e6e2b 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -723,6 +723,9 @@ struct ct_entry_24xx {
 	struct dsd64 dsd[2];
 };
 
+#define PURX_ELS_HEADER_SIZE	0x18
+#define FPIN_ELS_DESCRIPTOR_LIST_OFFSET	8
+
 /*
  * ISP queue - PUREX IOCB entry structure definition
  */
@@ -2020,7 +2023,9 @@ struct nvram_81xx {
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
index 95b6166ae0cc..dcadf1719711 100644
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
+		if ((le16_to_cpu(nv->enhanced_features) & BIT_7) == 0)
+			ha->flags.scm_supported_a = 1;
+	}
+
 	/* Set host adapter parameters. */
 	ha->flags.disable_risc_code_load = 0;
 	ha->flags.enable_lip_reset = 0;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 401ce0023cd5..7ba8a881fd4b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -23,6 +23,372 @@ static void qla2x00_status_cont_entry(struct rsp_que *, sts_cont_entry_t *);
 static int qla2x00_error_entry(scsi_qla_host_t *, struct rsp_que *,
 	sts_entry_t *);
 
+void
+qla_link_integrity_tgt_stats_update(struct fpin_descriptor *fpin_desc,
+				    fc_port_t *fcport)
+{
+	ql_log(ql_log_info, fcport->vha, 0x502d,
+	       "Link Integrity Event Type %d for Port %8phN\n",
+	       be16_to_cpu(fpin_desc->link_integrity.event_type),
+	       fcport->port_name);
+
+	fcport->scm_stats.link_integrity.event_type =
+	    be16_to_cpu(fpin_desc->link_integrity.event_type);
+	fcport->scm_stats.link_integrity.event_modifier =
+	    be16_to_cpu(fpin_desc->link_integrity.event_modifier);
+	fcport->scm_stats.link_integrity.event_threshold =
+	    be32_to_cpu(fpin_desc->link_integrity.event_threshold);
+	fcport->scm_stats.link_integrity.event_count =
+	    be32_to_cpu(fpin_desc->link_integrity.event_count);
+	fcport->scm_stats.link_integrity.timestamp = ktime_get_real_seconds();
+
+	fcport->scm_stats.current_events |= SCM_STATE_LINK_INTEGRITY;
+	switch (be16_to_cpu(fpin_desc->link_integrity.event_type)) {
+	case SCM_LINK_EVENT_UNKNOWN:
+		fcport->scm_stats.link_unknown_event +=
+		    be32_to_cpu(fpin_desc->link_integrity.event_count);
+		break;
+	case SCM_LINK_EVENT_LINK_FAILURE:
+		fcport->scm_stats.link_failure_count +=
+		    be32_to_cpu(fpin_desc->link_integrity.event_count);
+		break;
+	case SCM_LINK_EVENT_LOSS_OF_SYNC:
+		fcport->scm_stats.loss_of_sync_count +=
+		    be32_to_cpu(fpin_desc->link_integrity.event_count);
+		break;
+	case SCM_LINK_EVENT_LOSS_OF_SIGNAL:
+		fcport->scm_stats.loss_of_signals_count +=
+		    be32_to_cpu(fpin_desc->link_integrity.event_count);
+		break;
+	case SCM_LINK_EVENT_PRIMITIVE_SEQ_PROTOCOL_ERROR:
+		fcport->scm_stats.primitive_seq_protocol_err_count +=
+		    be32_to_cpu(fpin_desc->link_integrity.event_count);
+		break;
+	case SCM_LINK_EVENT_INVALID_TX_WORD:
+		fcport->scm_stats.invalid_transmission_word_count +=
+		    be32_to_cpu(fpin_desc->link_integrity.event_count);
+		break;
+	case SCM_LINK_EVENT_INVALID_CRC:
+		fcport->scm_stats.invalid_crc_count +=
+		    be32_to_cpu(fpin_desc->link_integrity.event_count);
+		break;
+	case SCM_LINK_EVENT_DEVICE_SPECIFIC:
+		fcport->scm_stats.link_device_specific_event +=
+		    be32_to_cpu(fpin_desc->link_integrity.event_count);
+		break;
+	}
+}
+
+void
+qla_scm_process_link_integrity_d(struct scsi_qla_host *vha,
+				 struct fpin_descriptor *fpin_desc)
+{
+	int i;
+	fc_port_t *fcport =  NULL;
+	fc_port_t *d_fcport = NULL, *a_fcport = NULL;
+
+	fcport = qla2x00_find_fcport_by_wwpn(vha,
+				fpin_desc->link_integrity.detecting_port_name,
+				0);
+	if (fcport) {
+		d_fcport = fcport;
+		qla_link_integrity_tgt_stats_update(fpin_desc, fcport);
+	}
+
+	fcport = qla2x00_find_fcport_by_wwpn(vha,
+				fpin_desc->link_integrity.attached_port_name,
+				0);
+	if (fcport) {
+		a_fcport = fcport;
+		qla_link_integrity_tgt_stats_update(fpin_desc, fcport);
+	}
+
+	if (fpin_desc->link_integrity.port_name_count > 0) {
+		for (i = 0;
+		    i < be32_to_cpu(fpin_desc->link_integrity.port_name_count);
+		    i++) {
+			fcport = qla2x00_find_fcport_by_wwpn(vha,
+				fpin_desc->link_integrity.port_name_list[i],
+				0);
+			if (fcport && (fcport != d_fcport) &&
+			    (fcport != a_fcport)) {
+				qla_link_integrity_tgt_stats_update(fpin_desc,
+								    fcport);
+			}
+		}
+	}
+
+	if (memcmp(vha->port_name, fpin_desc->link_integrity.attached_port_name,
+		   WWN_SIZE) == 0) {
+		ql_log(ql_log_info, vha, 0x5093,
+		       "Link Integrity Event Type %d for HBA WWN %8phN\n",
+		       be16_to_cpu(fpin_desc->link_integrity.event_type),
+		       vha->port_name);
+
+		vha->scm_stats.current_events |= SCM_STATE_LINK_INTEGRITY;
+		vha->scm_stats.link_integrity.event_type =
+		    be16_to_cpu(fpin_desc->link_integrity.event_type);
+		vha->scm_stats.link_integrity.event_modifier =
+		    be16_to_cpu(fpin_desc->link_integrity.event_modifier);
+		vha->scm_stats.link_integrity.event_threshold =
+		    be32_to_cpu(fpin_desc->link_integrity.event_threshold);
+		vha->scm_stats.link_integrity.event_count =
+		    be32_to_cpu(fpin_desc->link_integrity.event_count);
+		vha->scm_stats.link_integrity.timestamp =
+		    ktime_get_real_seconds();
+	}
+}
+
+void
+qla_delivery_tgt_stats_update(struct fpin_descriptor *fpin_desc,
+			      fc_port_t *fcport)
+{
+	ql_log(ql_log_info, fcport->vha, 0x5095,
+	       "Delivery Notification Reason Code %d for Port %8phN\n",
+	       be32_to_cpu(fpin_desc->delivery.delivery_reason_code),
+	       fcport->port_name);
+
+	switch (be32_to_cpu(fpin_desc->delivery.delivery_reason_code)) {
+	case SCM_DELIVERY_REASON_UNKNOWN:
+		fcport->scm_stats.delivery_failure_unknown++;
+		break;
+	case SCM_DELIVERY_REASON_TIMEOUT:
+		fcport->scm_stats.delivery_timeout++;
+		break;
+	case SCM_DELIVERY_REASON_UNABLE_TO_ROUTE:
+		fcport->scm_stats.delivery_unable_to_route++;
+		break;
+	case SCM_DELIVERY_REASON_DEVICE_SPECIFIC:
+		fcport->scm_stats.delivery_failure_device_specific++;
+		break;
+	}
+	fcport->scm_stats.delivery.timestamp =
+	    ktime_get_real_seconds();
+}
+
+/*
+ * Process Delivery Notification Descriptor
+ */
+void
+qla_scm_process_delivery_notification_d(struct scsi_qla_host *vha,
+					struct fpin_descriptor *fpin_desc)
+{
+	fc_port_t *fcport =  NULL;
+
+	fcport = qla2x00_find_fcport_by_wwpn(vha,
+				fpin_desc->delivery.detecting_port_name, 0);
+	if (fcport)
+		qla_delivery_tgt_stats_update(fpin_desc, fcport);
+
+	fcport = qla2x00_find_fcport_by_wwpn(vha,
+				fpin_desc->delivery.attached_port_name, 0);
+	if (fcport)
+		qla_delivery_tgt_stats_update(fpin_desc, fcport);
+
+	if (memcmp(vha->port_name, fpin_desc->delivery.attached_port_name,
+		   WWN_SIZE) == 0) {
+		ql_log(ql_log_info, vha, 0x5096,
+		       "Delivery Notification Reason Code %d for HBA WWN %8phN\n",
+		       be32_to_cpu(fpin_desc->delivery.delivery_reason_code),
+		       vha->port_name);
+
+		vha->scm_stats.delivery.delivery_reason =
+		    be32_to_cpu(fpin_desc->delivery.delivery_reason_code);
+		vha->scm_stats.current_events |= SCM_STATE_DELIVERY;
+		vha->scm_stats.delivery.timestamp =
+		    ktime_get_real_seconds();
+	}
+}
+
+void
+qla_scm_set_target_device_state(fc_port_t *fcport,
+				struct fpin_descriptor *fpin_desc)
+{
+	switch (be16_to_cpu(fpin_desc->peer_congestion.event_type)) {
+	case SCM_CONGESTION_EVENT_CLEAR:
+		ql_log(ql_log_warn, fcport->vha, 0x5097,
+		       "Port %8phN Slow Device: Cleared\n", fcport->port_name);
+		fcport->slow_device = 0;
+		break;
+	case SCM_CONGESTION_EVENT_LOST_CREDIT:
+		break;
+	case SCM_CONGESTION_EVENT_CREDIT_STALL:
+	case SCM_CONGESTION_EVENT_OVERSUBSCRIPTION:
+		ql_log(ql_log_warn, fcport->vha, 0x508c,
+		       "Port %8phN Slow Device: Set\n", fcport->port_name);
+		fcport->slow_device = 1;
+		break;
+	case SCM_CONGESTION_EVENT_DEVICE_SPECIFIC:
+		break;
+	}
+}
+
+void
+qla_peer_congestion_tgt_stats_update(struct fpin_descriptor *fpin_desc,
+				     fc_port_t *fcport)
+{
+	ql_log(ql_log_info, fcport->vha, 0x5098,
+	       "Peer Congestion Event Type %d for Port %8phN\n",
+	       be16_to_cpu(fpin_desc->peer_congestion.event_type),
+	       fcport->port_name);
+
+	fcport->scm_stats.peer_congestion.timestamp = ktime_get_real_seconds();
+	fcport->scm_stats.peer_congestion.event_type =
+	    be16_to_cpu(fpin_desc->peer_congestion.event_type);
+	fcport->scm_stats.peer_congestion.event_modifier =
+	    be16_to_cpu(fpin_desc->peer_congestion.event_modifier);
+	fcport->scm_stats.peer_congestion.event_period =
+	    fpin_desc->peer_congestion.event_period;
+
+	// What is the API to get system time ?
+	fcport->scm_stats.current_events |= SCM_STATE_PEER_CONGESTION;
+	switch (be16_to_cpu(fpin_desc->peer_congestion.event_type)) {
+	case SCM_CONGESTION_EVENT_CLEAR:
+		fcport->scm_stats.peer_congestion_clear++;
+		fcport->scm_stats.current_events &= ~SCM_STATE_PEER_CONGESTION;
+		break;
+	case SCM_CONGESTION_EVENT_LOST_CREDIT:
+		fcport->scm_stats.peer_congestion_lost_credit++;
+		break;
+	case SCM_CONGESTION_EVENT_CREDIT_STALL:
+		fcport->scm_stats.peer_congestion_credit_stall++;
+		break;
+	case SCM_CONGESTION_EVENT_OVERSUBSCRIPTION:
+		fcport->scm_stats.peer_congestion_oversubscription++;
+		break;
+	case SCM_CONGESTION_EVENT_DEVICE_SPECIFIC:
+		fcport->scm_stats.peer_congestion_device_specific++;
+		break;
+	}
+	qla_scm_set_target_device_state(fcport, fpin_desc);
+}
+
+/*
+ * Process Peer-Congestion Notification Descriptor
+ */
+void
+qla_scm_process_peer_congestion_notification_d(struct scsi_qla_host *vha,
+					struct fpin_descriptor *fpin_desc)
+{
+	int i;
+	fc_port_t *fcport =  NULL;
+	fc_port_t *d_fcport = NULL, *a_fcport = NULL;
+
+	fcport = qla2x00_find_fcport_by_wwpn(vha,
+			fpin_desc->peer_congestion.detecting_port_name, 0);
+	if (fcport) {
+		d_fcport = fcport;
+		qla_peer_congestion_tgt_stats_update(fpin_desc, fcport);
+	}
+
+	fcport = qla2x00_find_fcport_by_wwpn(vha,
+			fpin_desc->peer_congestion.attached_port_name, 0);
+	if (fcport) {
+		a_fcport = fcport;
+		qla_peer_congestion_tgt_stats_update(fpin_desc, fcport);
+	}
+
+	if (be32_to_cpu(fpin_desc->peer_congestion.port_name_count) > 0) {
+		for (i = 0;
+		    i < be32_to_cpu(fpin_desc->peer_congestion.port_name_count);
+		    i++) {
+			fcport = qla2x00_find_fcport_by_wwpn(vha,
+			fpin_desc->peer_congestion.port_name_list[i], 0);
+			if (fcport && fcport != d_fcport &&
+			    fcport != a_fcport) {
+				qla_peer_congestion_tgt_stats_update(fpin_desc,
+								fcport);
+			}
+		}
+	}
+}
+
+/*
+ * qla_scm_process_congestion_notification_d() - Process
+ * Process Congestion Notification Descriptor
+ * @rsp: response queue
+ * @pkt: Entry pointer
+ */
+void
+qla_scm_process_congestion_notification_d(struct scsi_qla_host *vha,
+					  struct fpin_descriptor *fpin_desc)
+{
+	ql_log(ql_log_info, vha, 0x5099,
+	       "Congestion Notification Event Type %d\n",
+	       be16_to_cpu(fpin_desc->congestion.event_type));
+
+	vha->scm_stats.congestion.event_type =
+	    be16_to_cpu(fpin_desc->congestion.event_type);
+	vha->scm_stats.congestion.event_modifier =
+	    be16_to_cpu(fpin_desc->congestion.event_modifier);
+	vha->scm_stats.congestion.event_period =
+	    be32_to_cpu(fpin_desc->congestion.event_period);
+	vha->scm_stats.congestion.severity =
+	    fpin_desc->congestion.severity;
+
+	if (be16_to_cpu(fpin_desc->congestion.event_type) ==
+	    SCM_CONGESTION_EVENT_CLEAR)
+		vha->scm_stats.current_events &= ~SCM_STATE_CONGESTION;
+	else
+		vha->scm_stats.current_events |= SCM_STATE_CONGESTION;
+
+	if (fpin_desc->congestion.severity == SCM_CONGESTION_SEVERITY_WARNING)
+		vha->scm_stats.scm_congestion_warning++;
+	else if (fpin_desc->congestion.severity ==
+	     SCM_CONGESTION_SEVERITY_ERROR)
+		vha->scm_stats.scm_congestion_alarm++;
+}
+
+void
+qla27xx_process_purex_fpin(struct scsi_qla_host *vha, struct purex_item *item)
+{
+	struct fpin_descriptor *fpin_desc;
+	uint16_t fpin_desc_len;
+	uint32_t fpin_offset = 0;
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
+	fpin_desc = (struct fpin_descriptor *)((uint8_t *)pkt +
+	    FPIN_ELS_DESCRIPTOR_LIST_OFFSET);
+
+	fpin_desc_len = pkt_size - FPIN_ELS_DESCRIPTOR_LIST_OFFSET;
+	while (fpin_offset <= fpin_desc_len) {
+		fpin_desc = (struct fpin_descriptor *)((uint8_t *)fpin_desc +
+		    fpin_offset);
+
+		if (fpin_offset >= fpin_desc_len - 8)
+			return;
+
+		switch (be32_to_cpu(fpin_desc->descriptor_tag)) {
+		case SCM_NOTIFICATION_TYPE_LINK_INTEGRITY:
+			qla_scm_process_link_integrity_d(vha, fpin_desc);
+			break;
+		case SCM_NOTIFICATION_TYPE_DELIVERY:
+			qla_scm_process_delivery_notification_d(vha, fpin_desc);
+			break;
+		case SCM_NOTIFICATION_TYPE_PEER_CONGESTION:
+			qla_scm_process_peer_congestion_notification_d(vha,
+								fpin_desc);
+			break;
+		case SCM_NOTIFICATION_TYPE_CONGESTION:
+			qla_scm_process_congestion_notification_d(vha,
+								fpin_desc);
+			break;
+		}
+		fpin_offset += be32_to_cpu(fpin_desc->descriptor_length) +
+		    FPIN_DESCRIPTOR_HEADER_SIZE;
+	}
+	fc_host_fpin_rcv(vha->host, pkt_size, (char *)pkt);
+}
+
 const char *const port_state_str[] = {
 	"Unknown",
 	"UNCONFIGURED",
@@ -836,6 +1202,111 @@ struct purex_item
 	return item;
 }
 
+/**
+ * qla27xx_copy_fpin_pkt() - Copy over fpin packets that can
+ * span over multiple IOCBs.
+ * @vha: SCSI driver HA context
+ * @pkt: ELS packet
+ * @rsp: Response queue
+ */
+struct purex_item *
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
@@ -1350,6 +1821,19 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 			qla2x00_post_aen_work(vha, FCH_EVT_RSCN, rscn_entry);
 		}
 		break;
+	case MBA_CONGN_NOTI_RECV:
+		if (!ha->flags.scm_enabled ||
+		    mb[1] != QLA_CON_PRIMITIVE_RECEIVED)
+			break;
+
+		if (mb[2] == QLA_CONGESTION_ARB_WARNING) {
+			vha->scm_stats.scm_congestion_warning++;
+		} else if (mb[2] == QLA_CONGESTION_ARB_ALARM) {
+			ql_log(ql_log_warn, vha, 0x509b,
+			       "Congestion Alarm %04x %04x.\n", mb[1], mb[2]);
+			vha->scm_stats.scm_congestion_alarm++;
+		}
+		break;
 	/* case MBA_RIO_RESPONSE: */
 	case MBA_ZIO_RESPONSE:
 		ql_dbg(ql_dbg_async, vha, 0x5015,
@@ -3279,6 +3763,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 {
 	struct sts_entry_24xx *pkt;
 	struct qla_hw_data *ha = vha->hw;
+	struct purex_entry_24xx *purex_entry;
 	struct purex_item *pure_item;
 
 	if (!ha->flags.fw_started)
@@ -3334,7 +3819,6 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 				pure_item = qla24xx_copy_std_pkt(vha, pkt);
 				if (!pure_item)
 					break;
-
 				qla24xx_queue_purex_item(vha, pure_item,
 							 qla24xx_process_abts);
 				break;
@@ -3384,29 +3868,41 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
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
+			case ELS_COMMAND_PUN:
+				break;
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
index 76a4f2bfdbed..3c411b5914ce 100644
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
+				vha->scm_stats.scm_fabric_connection_flags |=
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
@@ -4902,7 +4940,8 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
 
 	/* List of Purex ELS */
 	cmd_opcode[0] = ELS_COMMAND_FPIN;
-	cmd_opcode[1] = ELS_COMMAND_PUN;
+	cmd_opcode[1] = ELS_COMMAND_RDP;
+	cmd_opcode[2] = ELS_COMMAND_PUN;
 
 	for (i = 0; i < PUREX_CMD_COUNT; i++) {
 		index = cmd_opcode[i] / 8;
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

