Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1EBC3B187
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0AE2206DB
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="mtb2Dwve"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgBLVrQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:47:16 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12670 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728185AbgBLVrQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:47:16 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLejnk001672;
        Wed, 12 Feb 2020 13:45:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=tIwHx9L5MR9YdpTPbeosSA8TBBFy+pdev3IeKgJI8MU=;
 b=mtb2Dwveg/0tuRc9Iucma5Qvy1WNXqPl0VL0It7sjJItHh0ck9tyXBFzSaxPrCrbAgUh
 SYjROAc6DfLIrkxs775D9liF5ghe7fNiME4vVN+K7z7YdwCN6Ewf+tRGLCLmiV3qmOQx
 CYCHIxfcsfpgHJpDNW8XkDozKTCJXKHGDsAWZ1R1TfjCeIaxALbvZf1xdRIUWbW2z7p+
 Gy/VudRR64W/OjSpCXDllH/wTHylnlLXcI52bpPqOlPheqAJGIPPVMm45YgHyEY/bOfC
 ej43QgAIeeKBTBbE8fgfMMEGXvTY7FOqo/WC5h6SMXUrW67nYP7N+PIwVCzVMuBODbYk bA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5jt4xh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:45:06 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:45:04 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:45:03 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:45:03 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 5F8E83F705A;
        Wed, 12 Feb 2020 13:45:02 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLj2Tb025612;
        Wed, 12 Feb 2020 13:45:02 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLj2tB025611;
        Wed, 12 Feb 2020 13:45:02 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 09/25] qla2xxx: Add vendor extended FDMI commands
Date:   Wed, 12 Feb 2020 13:44:20 -0800
Message-ID: <20200212214436.25532-10-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200212214436.25532-1-hmadhani@marvell.com>
References: <20200212214436.25532-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-12_10:2020-02-12,2020-02-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

This patch adds support for extended FDMI commands
and cleans up code to reduce duplication.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  134 ++--
 drivers/scsi/qla2xxx/qla_gs.c  | 1687 ++++++++++++++++++----------------------
 2 files changed, 830 insertions(+), 991 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6ea0ef24a2a8..09853b624aff 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2627,10 +2627,11 @@ static const char * const port_dstate_str[] = {
 #define GFF_ID_RSP_SIZE (16 + 128)
 
 /*
- * HBA attribute types.
+ * FDMI HBA attribute types.
  */
-#define FDMI_HBA_ATTR_COUNT			9
-#define FDMIV2_HBA_ATTR_COUNT			17
+#define FDMI1_HBA_ATTR_COUNT			9
+#define FDMI2_HBA_ATTR_COUNT			17
+
 #define FDMI_HBA_NODE_NAME			0x1
 #define FDMI_HBA_MANUFACTURER			0x2
 #define FDMI_HBA_SERIAL_NUMBER			0x3
@@ -2642,12 +2643,13 @@ static const char * const port_dstate_str[] = {
 #define FDMI_HBA_FIRMWARE_VERSION		0x9
 #define FDMI_HBA_OS_NAME_AND_VERSION		0xa
 #define FDMI_HBA_MAXIMUM_CT_PAYLOAD_LENGTH	0xb
+
 #define FDMI_HBA_NODE_SYMBOLIC_NAME		0xc
-#define FDMI_HBA_VENDOR_ID			0xd
+#define FDMI_HBA_VENDOR_SPECIFIC_INFO		0xd
 #define FDMI_HBA_NUM_PORTS			0xe
 #define FDMI_HBA_FABRIC_NAME			0xf
 #define FDMI_HBA_BOOT_BIOS_NAME			0x10
-#define FDMI_HBA_TYPE_VENDOR_IDENTIFIER		0xe0
+#define FDMI_HBA_VENDOR_IDENTIFIER		0xe0
 
 struct ct_fdmi_hba_attr {
 	uint16_t type;
@@ -2664,31 +2666,9 @@ struct ct_fdmi_hba_attr {
 		uint8_t fw_version[32];
 		uint8_t os_version[128];
 		uint32_t max_ct_len;
-	} a;
-};
-
-struct ct_fdmi_hba_attributes {
-	uint32_t count;
-	struct ct_fdmi_hba_attr entry[FDMI_HBA_ATTR_COUNT];
-};
 
-struct ct_fdmiv2_hba_attr {
-	uint16_t type;
-	uint16_t len;
-	union {
-		uint8_t node_name[WWN_SIZE];
-		uint8_t manufacturer[64];
-		uint8_t serial_num[32];
-		uint8_t model[16+1];
-		uint8_t model_desc[80];
-		uint8_t hw_version[16];
-		uint8_t driver_version[32];
-		uint8_t orom_version[16];
-		uint8_t fw_version[32];
-		uint8_t os_version[128];
-		uint32_t max_ct_len;
 		uint8_t sym_name[256];
-		uint32_t vendor_id;
+		uint32_t vendor_specific_info;
 		uint32_t num_ports;
 		uint8_t fabric_name[WWN_SIZE];
 		uint8_t bios_name[32];
@@ -2696,22 +2676,30 @@ struct ct_fdmiv2_hba_attr {
 	} a;
 };
 
-struct ct_fdmiv2_hba_attributes {
+struct ct_fdmi1_hba_attributes {
 	uint32_t count;
-	struct ct_fdmiv2_hba_attr entry[FDMIV2_HBA_ATTR_COUNT];
+	struct ct_fdmi_hba_attr entry[FDMI1_HBA_ATTR_COUNT];
+};
+
+struct ct_fdmi2_hba_attributes {
+	uint32_t count;
+	struct ct_fdmi_hba_attr entry[FDMI2_HBA_ATTR_COUNT];
 };
 
 /*
- * Port attribute types.
+ * FDMI Port attribute types.
  */
-#define FDMI_PORT_ATTR_COUNT		6
-#define FDMIV2_PORT_ATTR_COUNT		16
+#define FDMI1_PORT_ATTR_COUNT		6
+#define FDMI2_PORT_ATTR_COUNT		16
+#define FDMI2_SMARTSAN_PORT_ATTR_COUNT	23
+
 #define FDMI_PORT_FC4_TYPES		0x1
 #define FDMI_PORT_SUPPORT_SPEED		0x2
 #define FDMI_PORT_CURRENT_SPEED		0x3
 #define FDMI_PORT_MAX_FRAME_SIZE	0x4
 #define FDMI_PORT_OS_DEVICE_NAME	0x5
 #define FDMI_PORT_HOST_NAME		0x6
+
 #define FDMI_PORT_NODE_NAME		0x7
 #define FDMI_PORT_NAME			0x8
 #define FDMI_PORT_SYM_NAME		0x9
@@ -2721,7 +2709,15 @@ struct ct_fdmiv2_hba_attributes {
 #define FDMI_PORT_FC4_TYPE		0xd
 #define FDMI_PORT_STATE			0x101
 #define FDMI_PORT_COUNT			0x102
-#define FDMI_PORT_ID			0x103
+#define FDMI_PORT_IDENTIFIER		0x103
+
+#define FDMI_SMARTSAN_SERVICE		0xF100
+#define FDMI_SMARTSAN_GUID		0xF101
+#define FDMI_SMARTSAN_VERSION		0xF102
+#define FDMI_SMARTSAN_PROD_NAME		0xF103
+#define FDMI_SMARTSAN_PORT_INFO		0xF104
+#define FDMI_SMARTSAN_QOS_SUPPORT	0xF105
+#define FDMI_SMARTSAN_SECURITY_SUPPORT	0xF106
 
 #define FDMI_PORT_SPEED_1GB		0x1
 #define FDMI_PORT_SPEED_2GB		0x2
@@ -2737,7 +2733,7 @@ struct ct_fdmiv2_hba_attributes {
 #define FC_CLASS_3	0x08
 #define FC_CLASS_2_3	0x0C
 
-struct ct_fdmiv2_port_attr {
+struct ct_fdmi_port_attr {
 	uint16_t type;
 	uint16_t len;
 	union {
@@ -2747,6 +2743,7 @@ struct ct_fdmiv2_port_attr {
 		uint32_t max_frame_size;
 		uint8_t os_dev_name[32];
 		uint8_t host_name[256];
+
 		uint8_t node_name[WWN_SIZE];
 		uint8_t port_name[WWN_SIZE];
 		uint8_t port_sym_name[128];
@@ -2757,35 +2754,38 @@ struct ct_fdmiv2_port_attr {
 		uint32_t port_state;
 		uint32_t num_ports;
 		uint32_t port_id;
+
+		uint8_t smartsan_service[24];
+		uint8_t smartsan_guid[16];
+		uint8_t smartsan_version[24];
+		uint8_t smartsan_prod_name[16];
+		uint32_t smartsan_port_info;
+		uint32_t smartsan_qos_support;
+		uint32_t smartsan_security_support;
 	} a;
 };
 
-/*
- * Port Attribute Block.
- */
-struct ct_fdmiv2_port_attributes {
+struct ct_fdmi1_port_attributes {
 	uint32_t count;
-	struct ct_fdmiv2_port_attr entry[FDMIV2_PORT_ATTR_COUNT];
+	struct ct_fdmi_port_attr entry[FDMI1_PORT_ATTR_COUNT];
 };
 
-struct ct_fdmi_port_attr {
-	uint16_t type;
-	uint16_t len;
-	union {
-		uint8_t fc4_types[32];
-		uint32_t sup_speed;
-		uint32_t cur_speed;
-		uint32_t max_frame_size;
-		uint8_t os_dev_name[32];
-		uint8_t host_name[256];
-	} a;
-};
-
-struct ct_fdmi_port_attributes {
+struct ct_fdmi2_port_attributes {
 	uint32_t count;
-	struct ct_fdmi_port_attr entry[FDMI_PORT_ATTR_COUNT];
+	struct ct_fdmi_port_attr entry[FDMI2_PORT_ATTR_COUNT];
 };
 
+#define FDMI_ATTR_TYPELEN(obj) \
+	(sizeof((obj)->type) + sizeof((obj)->len))
+
+#define FDMI_ATTR_ALIGNMENT(len) \
+	(4 - ((len) & 3))
+
+/* FDMI register call options */
+#define CALLOPT_FDMI1		0
+#define CALLOPT_FDMI2		1
+#define CALLOPT_FDMI2_SMARTSAN	2
+
 /* FDMI definitions. */
 #define GRHL_CMD	0x100
 #define GHAT_CMD	0x101
@@ -2796,10 +2796,13 @@ struct ct_fdmi_port_attributes {
 #define RHBA_RSP_SIZE	16
 
 #define RHAT_CMD	0x201
+
 #define RPRT_CMD	0x210
+#define RPRT_RSP_SIZE	24
 
 #define RPA_CMD		0x211
 #define RPA_RSP_SIZE	16
+#define SMARTSAN_RPA_RSP_SIZE	24
 
 #define DHBA_CMD	0x300
 #define DHBA_REQ_SIZE	(16 + 8)
@@ -2882,30 +2885,24 @@ struct ct_sns_req {
 			uint8_t hba_identifier[8];
 			uint32_t entry_count;
 			uint8_t port_name[8];
-			struct ct_fdmi_hba_attributes attrs;
+			struct ct_fdmi2_hba_attributes attrs;
 		} rhba;
 
 		struct {
 			uint8_t hba_identifier[8];
-			uint32_t entry_count;
-			uint8_t port_name[8];
-			struct ct_fdmiv2_hba_attributes attrs;
-		} rhba2;
-
-		struct {
-			uint8_t hba_identifier[8];
-			struct ct_fdmi_hba_attributes attrs;
+			struct ct_fdmi1_hba_attributes attrs;
 		} rhat;
 
 		struct {
 			uint8_t port_name[8];
-			struct ct_fdmi_port_attributes attrs;
+			struct ct_fdmi2_port_attributes attrs;
 		} rpa;
 
 		struct {
+			uint8_t hba_identifier[8];
 			uint8_t port_name[8];
-			struct ct_fdmiv2_port_attributes attrs;
-		} rpa2;
+			struct ct_fdmi2_port_attributes attrs;
+		} rprt;
 
 		struct {
 			uint8_t port_name[8];
@@ -3019,7 +3016,7 @@ struct ct_sns_rsp {
 		struct {
 			uint32_t entry_count;
 			uint8_t port_name[8];
-			struct ct_fdmi_hba_attributes attrs;
+			struct ct_fdmi1_hba_attributes attrs;
 		} ghat;
 
 		struct {
@@ -3690,6 +3687,7 @@ struct rdp_rsp_payload {
 #define RDP_PORT_SPEED_8GB		BIT_11
 #define RDP_PORT_SPEED_16GB		BIT_10
 #define RDP_PORT_SPEED_32GB		BIT_9
+#define RDP_PORT_SPEED_64GB             BIT_8
 #define RDP_PORT_SPEED_UNKNOWN		BIT_0
 
 struct scsi_qlt_host {
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index c01eb87c709f..f57bfcb9c548 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -19,6 +19,8 @@ static int qla_async_rffid(scsi_qla_host_t *, port_id_t *, u8, u8);
 static int qla_async_rnnid(scsi_qla_host_t *, port_id_t *, u8*);
 static int qla_async_rsnn_nn(scsi_qla_host_t *);
 
+
+
 /**
  * qla2x00_prep_ms_iocb() - Prepare common MS/CT IOCB fields for SNS CT query.
  * @vha: HA context
@@ -1500,747 +1502,732 @@ qla2x00_prep_ct_fdmi_req(struct ct_sns_pkt *p, uint16_t cmd,
 	return &p->p.req;
 }
 
+static uint
+qla25xx_fdmi_port_speed_capability(struct qla_hw_data *ha)
+{
+	if (IS_CNA_CAPABLE(ha))
+		return FDMI_PORT_SPEED_10GB;
+	if (IS_QLA28XX(ha) || IS_QLA27XX(ha)) {
+		uint speeds = 0;
+
+		if (ha->max_supported_speed == 2) {
+			if (ha->min_supported_speed <= 6)
+				speeds |= FDMI_PORT_SPEED_64GB;
+		}
+		if (ha->max_supported_speed == 2 ||
+		    ha->max_supported_speed == 1) {
+			if (ha->min_supported_speed <= 5)
+				speeds |= FDMI_PORT_SPEED_32GB;
+		}
+		if (ha->max_supported_speed == 2 ||
+		    ha->max_supported_speed == 1 ||
+		    ha->max_supported_speed == 0) {
+			if (ha->min_supported_speed <= 4)
+				speeds |= FDMI_PORT_SPEED_16GB;
+		}
+		if (ha->max_supported_speed == 1 ||
+		    ha->max_supported_speed == 0) {
+			if (ha->min_supported_speed <= 3)
+				speeds |= FDMI_PORT_SPEED_8GB;
+		}
+		if (ha->max_supported_speed == 0) {
+			if (ha->min_supported_speed <= 2)
+				speeds |= FDMI_PORT_SPEED_4GB;
+		}
+		return speeds;
+	}
+	if (IS_QLA2031(ha))
+		return FDMI_PORT_SPEED_16GB|FDMI_PORT_SPEED_8GB|
+			FDMI_PORT_SPEED_4GB;
+	if (IS_QLA25XX(ha))
+		return FDMI_PORT_SPEED_8GB|FDMI_PORT_SPEED_4GB|
+			FDMI_PORT_SPEED_2GB|FDMI_PORT_SPEED_1GB;
+	if (IS_QLA24XX_TYPE(ha))
+		return FDMI_PORT_SPEED_4GB|FDMI_PORT_SPEED_2GB|
+			FDMI_PORT_SPEED_1GB;
+	if (IS_QLA23XX(ha))
+		return FDMI_PORT_SPEED_2GB|FDMI_PORT_SPEED_1GB;
+	return FDMI_PORT_SPEED_1GB;
+}
+static uint
+qla25xx_fdmi_port_speed_currently(struct qla_hw_data *ha)
+{
+	switch (ha->link_data_rate) {
+	case PORT_SPEED_1GB:
+		return FDMI_PORT_SPEED_1GB;
+	case PORT_SPEED_2GB:
+		return FDMI_PORT_SPEED_2GB;
+	case PORT_SPEED_4GB:
+		return FDMI_PORT_SPEED_4GB;
+	case PORT_SPEED_8GB:
+		return FDMI_PORT_SPEED_8GB;
+	case PORT_SPEED_10GB:
+		return FDMI_PORT_SPEED_10GB;
+	case PORT_SPEED_16GB:
+		return FDMI_PORT_SPEED_16GB;
+	case PORT_SPEED_32GB:
+		return FDMI_PORT_SPEED_32GB;
+	case PORT_SPEED_64GB:
+		return FDMI_PORT_SPEED_64GB;
+	default:
+		return FDMI_PORT_SPEED_UNKNOWN;
+	}
+}
+
 /**
- * qla2x00_fdmi_rhba() - perform RHBA FDMI registration
+ * qla2x00_hba_attributes() perform HBA attributes registration
  * @vha: HA context
+ * @entries: number of entries to use
+ * @callopt: Option to issue extended or standard FDMI
+ *           command parameter
  *
  * Returns 0 on success.
  */
-static int
-qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
+static unsigned long
+qla2x00_hba_attributes(scsi_qla_host_t *vha, void *entries,
+    unsigned int callopt)
 {
-	int rval, alen;
-	uint32_t size, sn;
-
-	ms_iocb_entry_t *ms_pkt;
-	struct ct_sns_req *ct_req;
-	struct ct_sns_rsp *ct_rsp;
-	void *entries;
-	struct ct_fdmi_hba_attr *eiter;
 	struct qla_hw_data *ha = vha->hw;
-
-	/* Issue RHBA */
-	/* Prepare common MS IOCB */
-	/*   Request size adjusted after CT preparation */
-	ms_pkt = ha->isp_ops->prep_ms_fdmi_iocb(vha, 0, RHBA_RSP_SIZE);
-
-	/* Prepare CT request */
-	ct_req = qla2x00_prep_ct_fdmi_req(ha->ct_sns, RHBA_CMD, RHBA_RSP_SIZE);
-	ct_rsp = &ha->ct_sns->p.rsp;
-
-	/* Prepare FDMI command arguments -- attribute block, attributes. */
-	memcpy(ct_req->req.rhba.hba_identifier, vha->port_name, WWN_SIZE);
-	ct_req->req.rhba.entry_count = cpu_to_be32(1);
-	memcpy(ct_req->req.rhba.port_name, vha->port_name, WWN_SIZE);
-	size = 2 * WWN_SIZE + 4 + 4;
-
-	/* Attributes */
-	ct_req->req.rhba.attrs.count =
-	    cpu_to_be32(FDMI_HBA_ATTR_COUNT);
-	entries = &ct_req->req;
+	struct init_cb_24xx *icb24 = (void *)ha->init_cb;
+	struct new_utsname *p_sysid = utsname();
+	struct ct_fdmi_hba_attr *eiter;
+	uint16_t alen;
+	unsigned long size = 0;
 
 	/* Nodename. */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_HBA_NODE_NAME);
-	eiter->len = cpu_to_be16(4 + WWN_SIZE);
-	memcpy(eiter->a.node_name, vha->node_name, WWN_SIZE);
-	size += 4 + WWN_SIZE;
-
-	ql_dbg(ql_dbg_disc, vha, 0x2025,
-	    "NodeName = %8phN.\n", eiter->a.node_name);
-
+	memcpy(eiter->a.node_name, vha->node_name, sizeof(eiter->a.node_name));
+	alen = sizeof(eiter->a.node_name);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20a0,
+	    "NODENAME = %016llx.\n", wwn_to_u64(eiter->a.node_name));
 	/* Manufacturer. */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_HBA_MANUFACTURER);
-	alen = strlen(QLA2XXX_MANUFACTURER);
-	snprintf(eiter->a.manufacturer, sizeof(eiter->a.manufacturer),
-	    "%s", "QLogic Corporation");
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x2026,
-	    "Manufacturer = %s.\n", eiter->a.manufacturer);
-
+	alen = scnprintf(
+		eiter->a.manufacturer, sizeof(eiter->a.manufacturer),
+		"%s", "QLogic Corporation");
+	alen += FDMI_ATTR_ALIGNMENT(alen);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20a1,
+	    "MANUFACTURER = %s.\n", eiter->a.manufacturer);
 	/* Serial number. */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_HBA_SERIAL_NUMBER);
-	if (IS_FWI2_CAPABLE(ha))
-		qla2xxx_get_vpd_field(vha, "SN", eiter->a.serial_num,
-		    sizeof(eiter->a.serial_num));
-	else {
-		sn = ((ha->serial0 & 0x1f) << 16) |
+	alen = 0;
+	if (IS_FWI2_CAPABLE(ha)) {
+		alen = qla2xxx_get_vpd_field(vha, "SN",
+		    eiter->a.serial_num, sizeof(eiter->a.serial_num));
+	}
+	if (!alen) {
+		uint32_t sn = ((ha->serial0 & 0x1f) << 16) |
 			(ha->serial2 << 8) | ha->serial1;
-		snprintf(eiter->a.serial_num, sizeof(eiter->a.serial_num),
-		    "%c%05d", 'A' + sn / 100000, sn % 100000);
+		alen = scnprintf(
+			eiter->a.serial_num, sizeof(eiter->a.serial_num),
+			"%c%05d", 'A' + sn / 100000, sn % 100000);
 	}
-	alen = strlen(eiter->a.serial_num);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x2027,
-	    "Serial no. = %s.\n", eiter->a.serial_num);
-
+	alen += FDMI_ATTR_ALIGNMENT(alen);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20a2,
+	    "SERIAL NUMBER = %s.\n", eiter->a.serial_num);
 	/* Model name. */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_HBA_MODEL);
-	snprintf(eiter->a.model, sizeof(eiter->a.model),
-	    "%s", ha->model_number);
-	alen = strlen(eiter->a.model);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x2028,
-	    "Model Name = %s.\n", eiter->a.model);
-
+	alen = scnprintf(
+		eiter->a.model, sizeof(eiter->a.model),
+		"%s", ha->model_number);
+	alen += FDMI_ATTR_ALIGNMENT(alen);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20a3,
+	    "MODEL NAME = %s.\n", eiter->a.model);
 	/* Model description. */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_HBA_MODEL_DESCRIPTION);
-	snprintf(eiter->a.model_desc, sizeof(eiter->a.model_desc),
-	    "%s", ha->model_desc);
-	alen = strlen(eiter->a.model_desc);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x2029,
-	    "Model Desc = %s.\n", eiter->a.model_desc);
-
+	alen = scnprintf(
+		eiter->a.model_desc, sizeof(eiter->a.model_desc),
+		"%s", ha->model_desc);
+	alen += FDMI_ATTR_ALIGNMENT(alen);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20a4,
+	    "MODEL DESCRIPTION = %s.\n", eiter->a.model_desc);
 	/* Hardware version. */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_HBA_HARDWARE_VERSION);
-	if (!IS_FWI2_CAPABLE(ha)) {
-		snprintf(eiter->a.hw_version, sizeof(eiter->a.hw_version),
-		    "HW:%s", ha->adapter_id);
-	} else if (qla2xxx_get_vpd_field(vha, "MN", eiter->a.hw_version,
-		    sizeof(eiter->a.hw_version))) {
-		;
-	} else if (qla2xxx_get_vpd_field(vha, "EC", eiter->a.hw_version,
-		    sizeof(eiter->a.hw_version))) {
-		;
-	} else {
-		snprintf(eiter->a.hw_version, sizeof(eiter->a.hw_version),
-		    "HW:%s", ha->adapter_id);
+	alen = 0;
+	if (IS_FWI2_CAPABLE(ha)) {
+		if (!alen) {
+			alen = qla2xxx_get_vpd_field(vha, "MN",
+			    eiter->a.hw_version, sizeof(eiter->a.hw_version));
+		}
+		if (!alen) {
+			alen = qla2xxx_get_vpd_field(vha, "EC",
+			    eiter->a.hw_version, sizeof(eiter->a.hw_version));
+		}
 	}
-	alen = strlen(eiter->a.hw_version);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x202a,
-	    "Hardware ver = %s.\n", eiter->a.hw_version);
-
+	if (!alen) {
+		alen = scnprintf(
+			eiter->a.hw_version, sizeof(eiter->a.hw_version),
+			"HW:%s", ha->adapter_id);
+	}
+	alen += FDMI_ATTR_ALIGNMENT(alen);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20a5,
+	    "HARDWARE VERSION = %s.\n", eiter->a.hw_version);
 	/* Driver version. */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_HBA_DRIVER_VERSION);
-	snprintf(eiter->a.driver_version, sizeof(eiter->a.driver_version),
-	    "%s", qla2x00_version_str);
-	alen = strlen(eiter->a.driver_version);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x202b,
-	    "Driver ver = %s.\n", eiter->a.driver_version);
-
+	alen = scnprintf(
+		eiter->a.driver_version, sizeof(eiter->a.driver_version),
+		"%s", qla2x00_version_str);
+	alen += FDMI_ATTR_ALIGNMENT(alen);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20a6,
+	    "DRIVER VERSION = %s.\n", eiter->a.driver_version);
 	/* Option ROM version. */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_HBA_OPTION_ROM_VERSION);
-	snprintf(eiter->a.orom_version, sizeof(eiter->a.orom_version),
-	    "%d.%02d", ha->bios_revision[1], ha->bios_revision[0]);
-	alen = strlen(eiter->a.orom_version);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha , 0x202c,
-	    "Optrom vers = %s.\n", eiter->a.orom_version);
+	alen = scnprintf(
+		eiter->a.orom_version, sizeof(eiter->a.orom_version),
+		"%d.%02d", ha->bios_revision[1], ha->bios_revision[0]);
+	alen += FDMI_ATTR_ALIGNMENT(alen);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
 
+	ql_dbg(ql_dbg_disc, vha, 0x20a7,
+	    "OPTROM VERSION = %d.%02d.\n",
+	    eiter->a.orom_version[1], eiter->a.orom_version[0]);
 	/* Firmware version */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_HBA_FIRMWARE_VERSION);
 	ha->isp_ops->fw_version_str(vha, eiter->a.fw_version,
 	    sizeof(eiter->a.fw_version));
-	alen = strlen(eiter->a.fw_version);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x202d,
-	    "Firmware vers = %s.\n", eiter->a.fw_version);
-
-	/* Update MS request size. */
-	qla2x00_update_ms_fdmi_iocb(vha, size + 16);
-
-	ql_dbg(ql_dbg_disc, vha, 0x202e,
-	    "RHBA identifier = %8phN size=%d.\n",
-	    ct_req->req.rhba.hba_identifier, size);
-	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x2076,
-	    entries, size);
-
-	/* Execute MS IOCB */
-	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
-	    sizeof(ms_iocb_entry_t));
-	if (rval != QLA_SUCCESS) {
-		/*EMPTY*/
-		ql_dbg(ql_dbg_disc, vha, 0x2030,
-		    "RHBA issue IOCB failed (%d).\n", rval);
-	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "RHBA") !=
-	    QLA_SUCCESS) {
-		rval = QLA_FUNCTION_FAILED;
-		if (ct_rsp->header.reason_code == CT_REASON_CANNOT_PERFORM &&
-		    ct_rsp->header.explanation_code ==
-		    CT_EXPL_ALREADY_REGISTERED) {
-			ql_dbg(ql_dbg_disc, vha, 0x2034,
-			    "HBA already registered.\n");
-			rval = QLA_ALREADY_REGISTERED;
-		} else {
-			ql_dbg(ql_dbg_disc, vha, 0x20ad,
-			    "RHBA FDMI registration failed, CT Reason code: 0x%x, CT Explanation 0x%x\n",
-			    ct_rsp->header.reason_code,
-			    ct_rsp->header.explanation_code);
-		}
-	} else {
-		ql_dbg(ql_dbg_disc, vha, 0x2035,
-		    "RHBA exiting normally.\n");
+	alen += FDMI_ATTR_ALIGNMENT(alen);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20a8,
+	    "FIRMWARE VERSION = %s.\n", eiter->a.fw_version);
+	if (callopt == CALLOPT_FDMI1)
+		goto done;
+	/* OS Name and Version */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_HBA_OS_NAME_AND_VERSION);
+	alen = 0;
+	if (p_sysid) {
+		alen = scnprintf(
+			eiter->a.os_version, sizeof(eiter->a.os_version),
+			"%s %s %s",
+			p_sysid->sysname, p_sysid->release, p_sysid->machine);
 	}
-
-	return rval;
+	if (!alen) {
+		alen = scnprintf(
+			eiter->a.os_version, sizeof(eiter->a.os_version),
+			"%s %s",
+			"Linux", fc_host_system_hostname(vha->host));
+	}
+	alen += FDMI_ATTR_ALIGNMENT(alen);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20a9,
+	    "OS VERSION = %s.\n", eiter->a.os_version);
+	/* MAX CT Payload Length */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_HBA_MAXIMUM_CT_PAYLOAD_LENGTH);
+	eiter->a.max_ct_len = cpu_to_be32(le16_to_cpu(IS_FWI2_CAPABLE(ha) ?
+		icb24->frame_payload_size : ha->init_cb->frame_payload_size));
+	alen = sizeof(eiter->a.max_ct_len);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20aa,
+	    "CT PAYLOAD LENGTH = 0x%x.\n", be32_to_cpu(eiter->a.max_ct_len));
+	/* Node Sybolic Name */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_HBA_NODE_SYMBOLIC_NAME);
+	alen = qla2x00_get_sym_node_name(vha, eiter->a.sym_name,
+	    sizeof(eiter->a.sym_name));
+	alen += FDMI_ATTR_ALIGNMENT(alen);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20ab,
+	    "SYMBOLIC NAME = %s.\n", eiter->a.sym_name);
+	/* Vendor Specific information */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_HBA_VENDOR_SPECIFIC_INFO);
+	eiter->a.vendor_specific_info = cpu_to_be32(PCI_VENDOR_ID_QLOGIC);
+	alen = sizeof(eiter->a.vendor_specific_info);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20ac,
+	    "VENDOR SPECIFIC INFO = 0x%x.\n",
+	    be32_to_cpu(eiter->a.vendor_specific_info));
+	/* Num Ports */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_HBA_NUM_PORTS);
+	eiter->a.num_ports = cpu_to_be32(1);
+	alen = sizeof(eiter->a.num_ports);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20ad,
+	    "PORT COUNT = %x.\n", be32_to_cpu(eiter->a.num_ports));
+	/* Fabric Name */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_HBA_FABRIC_NAME);
+	memcpy(eiter->a.fabric_name, vha->fabric_node_name,
+	    sizeof(eiter->a.fabric_name));
+	alen = sizeof(eiter->a.fabric_name);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20ae,
+	    "FABRIC NAME = %016llx.\n", wwn_to_u64(eiter->a.fabric_name));
+	/* BIOS Version */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_HBA_BOOT_BIOS_NAME);
+	alen = scnprintf(
+		eiter->a.bios_name, sizeof(eiter->a.bios_name),
+		"BIOS %d.%02d", ha->bios_revision[1], ha->bios_revision[0]);
+	alen += FDMI_ATTR_ALIGNMENT(alen);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20af,
+	    "BIOS NAME = %s\n", eiter->a.bios_name);
+	/* Vendor Identifier */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_HBA_VENDOR_IDENTIFIER);
+	alen = scnprintf(
+		eiter->a.vendor_identifier, sizeof(eiter->a.vendor_identifier),
+		"%s", "QLGC");
+	alen += FDMI_ATTR_ALIGNMENT(alen);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20b0,
+	    "VENDOR IDENTIFIER = %s.\n", eiter->a.vendor_identifier);
+done:
+	return size;
 }
 
 /**
- * qla2x00_fdmi_rpa() - perform RPA registration
+ * qla2x00_port_attributes() perform Port attributes registration
  * @vha: HA context
+ * @entries: number of entries to use
+ * @callopt: Option to issue extended or standard FDMI
+ *           command parameter
  *
  * Returns 0 on success.
  */
-static int
-qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
+static unsigned long
+qla2x00_port_attributes(scsi_qla_host_t *vha, void *entries,
+    unsigned int callopt)
 {
-	int rval, alen;
-	uint32_t size;
 	struct qla_hw_data *ha = vha->hw;
-	ms_iocb_entry_t *ms_pkt;
-	struct ct_sns_req *ct_req;
-	struct ct_sns_rsp *ct_rsp;
-	void *entries;
+	struct init_cb_24xx *icb24 = (void *)ha->init_cb;
+	struct new_utsname *p_sysid = utsname();
+	char *hostname = p_sysid ?
+		p_sysid->nodename : fc_host_system_hostname(vha->host);
 	struct ct_fdmi_port_attr *eiter;
-	struct init_cb_24xx *icb24 = (struct init_cb_24xx *)ha->init_cb;
-	struct new_utsname *p_sysid = NULL;
-
-	/* Issue RPA */
-	/* Prepare common MS IOCB */
-	/*   Request size adjusted after CT preparation */
-	ms_pkt = ha->isp_ops->prep_ms_fdmi_iocb(vha, 0, RPA_RSP_SIZE);
-
-	/* Prepare CT request */
-	ct_req = qla2x00_prep_ct_fdmi_req(ha->ct_sns, RPA_CMD,
-	    RPA_RSP_SIZE);
-	ct_rsp = &ha->ct_sns->p.rsp;
-
-	/* Prepare FDMI command arguments -- attribute block, attributes. */
-	memcpy(ct_req->req.rpa.port_name, vha->port_name, WWN_SIZE);
-	size = WWN_SIZE + 4;
-
-	/* Attributes */
-	ct_req->req.rpa.attrs.count = cpu_to_be32(FDMI_PORT_ATTR_COUNT);
-	entries = &ct_req->req;
+	uint16_t alen;
+	unsigned long size = 0;
 
 	/* FC4 types. */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_PORT_FC4_TYPES);
-	eiter->len = cpu_to_be16(4 + 32);
+	eiter->a.fc4_types[0] = 0x00;
+	eiter->a.fc4_types[1] = 0x00;
 	eiter->a.fc4_types[2] = 0x01;
-	size += 4 + 32;
-
-	ql_dbg(ql_dbg_disc, vha, 0x2039,
-	    "FC4_TYPES=%02x %02x.\n",
-	    eiter->a.fc4_types[2],
-	    eiter->a.fc4_types[1]);
-
+	eiter->a.fc4_types[3] = 0x00;
+	alen = sizeof(eiter->a.fc4_types);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20c0,
+	    "FC4 TYPES = %016llx.\n", *(uint64_t *)eiter->a.fc4_types);
+	if (vha->flags.nvme_enabled) {
+		eiter->a.fc4_types[6] = 1;      /* NVMe type 28h */
+		ql_dbg(ql_dbg_disc, vha, 0x211f,
+		    "NVME FC4 Type = %02x 0x0 0x0 0x0 0x0 0x0.\n",
+		    eiter->a.fc4_types[6]);
+	}
 	/* Supported speed. */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_PORT_SUPPORT_SPEED);
-	eiter->len = cpu_to_be16(4 + 4);
-	if (IS_CNA_CAPABLE(ha))
-		eiter->a.sup_speed = cpu_to_be32(
-		    FDMI_PORT_SPEED_10GB);
-	else if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
-		eiter->a.sup_speed = cpu_to_be32(
-		    FDMI_PORT_SPEED_32GB|
-		    FDMI_PORT_SPEED_16GB|
-		    FDMI_PORT_SPEED_8GB);
-	else if (IS_QLA2031(ha))
-		eiter->a.sup_speed = cpu_to_be32(
-		    FDMI_PORT_SPEED_16GB|
-		    FDMI_PORT_SPEED_8GB|
-		    FDMI_PORT_SPEED_4GB);
-	else if (IS_QLA25XX(ha))
-		eiter->a.sup_speed = cpu_to_be32(
-		    FDMI_PORT_SPEED_8GB|
-		    FDMI_PORT_SPEED_4GB|
-		    FDMI_PORT_SPEED_2GB|
-		    FDMI_PORT_SPEED_1GB);
-	else if (IS_QLA24XX_TYPE(ha))
-		eiter->a.sup_speed = cpu_to_be32(
-		    FDMI_PORT_SPEED_4GB|
-		    FDMI_PORT_SPEED_2GB|
-		    FDMI_PORT_SPEED_1GB);
-	else if (IS_QLA23XX(ha))
-		eiter->a.sup_speed = cpu_to_be32(
-		    FDMI_PORT_SPEED_2GB|
-		    FDMI_PORT_SPEED_1GB);
-	else
-		eiter->a.sup_speed = cpu_to_be32(
-		    FDMI_PORT_SPEED_1GB);
-	size += 4 + 4;
-
-	ql_dbg(ql_dbg_disc, vha, 0x203a,
-	    "Supported_Speed=%x.\n", eiter->a.sup_speed);
-
+	eiter->a.sup_speed = cpu_to_be32(
+		qla25xx_fdmi_port_speed_capability(ha));
+	alen = sizeof(eiter->a.sup_speed);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20c1,
+	    "SUPPORTED SPEED = %x.\n", be32_to_cpu(eiter->a.sup_speed));
 	/* Current speed. */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_PORT_CURRENT_SPEED);
-	eiter->len = cpu_to_be16(4 + 4);
-	switch (ha->link_data_rate) {
-	case PORT_SPEED_1GB:
-		eiter->a.cur_speed =
-		    cpu_to_be32(FDMI_PORT_SPEED_1GB);
-		break;
-	case PORT_SPEED_2GB:
-		eiter->a.cur_speed =
-		    cpu_to_be32(FDMI_PORT_SPEED_2GB);
-		break;
-	case PORT_SPEED_4GB:
-		eiter->a.cur_speed =
-		    cpu_to_be32(FDMI_PORT_SPEED_4GB);
-		break;
-	case PORT_SPEED_8GB:
-		eiter->a.cur_speed =
-		    cpu_to_be32(FDMI_PORT_SPEED_8GB);
-		break;
-	case PORT_SPEED_10GB:
-		eiter->a.cur_speed =
-		    cpu_to_be32(FDMI_PORT_SPEED_10GB);
-		break;
-	case PORT_SPEED_16GB:
-		eiter->a.cur_speed =
-		    cpu_to_be32(FDMI_PORT_SPEED_16GB);
-		break;
-	case PORT_SPEED_32GB:
-		eiter->a.cur_speed =
-		    cpu_to_be32(FDMI_PORT_SPEED_32GB);
-		break;
-	default:
-		eiter->a.cur_speed =
-		    cpu_to_be32(FDMI_PORT_SPEED_UNKNOWN);
-		break;
-	}
-	size += 4 + 4;
-
-	ql_dbg(ql_dbg_disc, vha, 0x203b,
-	    "Current_Speed=%x.\n", eiter->a.cur_speed);
-
+	eiter->a.cur_speed = cpu_to_be32(
+		qla25xx_fdmi_port_speed_currently(ha));
+	alen = sizeof(eiter->a.cur_speed);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20c2,
+	    "CURRENT SPEED = %x.\n", be32_to_cpu(eiter->a.cur_speed));
 	/* Max frame size. */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_PORT_MAX_FRAME_SIZE);
-	eiter->len = cpu_to_be16(4 + 4);
-	eiter->a.max_frame_size = IS_FWI2_CAPABLE(ha) ?
-	    le16_to_cpu(icb24->frame_payload_size) :
-	    le16_to_cpu(ha->init_cb->frame_payload_size);
-	eiter->a.max_frame_size = cpu_to_be32(eiter->a.max_frame_size);
-	size += 4 + 4;
-
-	ql_dbg(ql_dbg_disc, vha, 0x203c,
-	    "Max_Frame_Size=%x.\n", eiter->a.max_frame_size);
-
+	eiter->a.max_frame_size = cpu_to_be32(le16_to_cpu(IS_FWI2_CAPABLE(ha) ?
+		icb24->frame_payload_size : ha->init_cb->frame_payload_size));
+	alen = sizeof(eiter->a.max_frame_size);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20c3,
+	    "MAX FRAME SIZE = %x.\n", be32_to_cpu(eiter->a.max_frame_size));
 	/* OS device name. */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_PORT_OS_DEVICE_NAME);
-	snprintf(eiter->a.os_dev_name, sizeof(eiter->a.os_dev_name),
-	    "%s:host%lu", QLA2XXX_DRIVER_NAME, vha->host_no);
-	alen = strlen(eiter->a.os_dev_name);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x204b,
-	    "OS_Device_Name=%s.\n", eiter->a.os_dev_name);
-
+	alen = scnprintf(
+		eiter->a.os_dev_name, sizeof(eiter->a.os_dev_name),
+		"%s:host%lu", QLA2XXX_DRIVER_NAME, vha->host_no);
+	alen += FDMI_ATTR_ALIGNMENT(alen);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20c4,
+	    "OS DEVICE NAME = %s.\n", eiter->a.os_dev_name);
 	/* Hostname. */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_PORT_HOST_NAME);
-	p_sysid = utsname();
-	if (p_sysid) {
-		snprintf(eiter->a.host_name, sizeof(eiter->a.host_name),
-		    "%s", p_sysid->nodename);
-	} else {
-		snprintf(eiter->a.host_name, sizeof(eiter->a.host_name),
-		    "%s", fc_host_system_hostname(vha->host));
-	}
-	alen = strlen(eiter->a.host_name);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
+	if (!*hostname || !strncmp(hostname, "(none)", 6))
+		hostname = "Linux-default";
+	alen = scnprintf(
+		eiter->a.host_name, sizeof(eiter->a.host_name),
+		"%s", hostname);
+	alen += FDMI_ATTR_ALIGNMENT(alen);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20c5,
+	    "HOSTNAME = %s.\n", eiter->a.host_name);
 
-	ql_dbg(ql_dbg_disc, vha, 0x203d, "HostName=%s.\n", eiter->a.host_name);
+	if (callopt == CALLOPT_FDMI1)
+		goto done;
 
-	/* Update MS request size. */
-	qla2x00_update_ms_fdmi_iocb(vha, size + 16);
+	/* Node Name */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_PORT_NODE_NAME);
+	memcpy(eiter->a.node_name, vha->node_name, sizeof(eiter->a.node_name));
+	alen = sizeof(eiter->a.node_name);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20c6,
+	    "NODENAME = %016llx.\n", wwn_to_u64(eiter->a.node_name));
 
-	ql_dbg(ql_dbg_disc, vha, 0x203e,
-	    "RPA portname  %016llx, size = %d.\n",
-	    wwn_to_u64(ct_req->req.rpa.port_name), size);
-	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x2079,
-	    entries, size);
+	/* Port Name */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_PORT_NAME);
+	memcpy(eiter->a.port_name, vha->port_name, sizeof(eiter->a.port_name));
+	alen = sizeof(eiter->a.port_name);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20c7,
+	    "PORTNAME = %016llx.\n", wwn_to_u64(eiter->a.port_name));
 
-	/* Execute MS IOCB */
-	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
-	    sizeof(ms_iocb_entry_t));
-	if (rval != QLA_SUCCESS) {
-		/*EMPTY*/
-		ql_dbg(ql_dbg_disc, vha, 0x2040,
-		    "RPA issue IOCB failed (%d).\n", rval);
-	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "RPA") !=
-	    QLA_SUCCESS) {
-		rval = QLA_FUNCTION_FAILED;
-		if (ct_rsp->header.reason_code == CT_REASON_CANNOT_PERFORM &&
-		    ct_rsp->header.explanation_code ==
-		    CT_EXPL_ALREADY_REGISTERED) {
-			ql_dbg(ql_dbg_disc, vha, 0x20cd,
-			    "RPA already registered.\n");
-			rval = QLA_ALREADY_REGISTERED;
-		}
+	/* Port Symbolic Name */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_PORT_SYM_NAME);
+	alen = qla2x00_get_sym_node_name(vha, eiter->a.port_sym_name,
+	    sizeof(eiter->a.port_sym_name));
+	alen += FDMI_ATTR_ALIGNMENT(alen);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20c8,
+	    "PORT SYMBOLIC NAME = %s\n", eiter->a.port_sym_name);
 
-	} else {
-		ql_dbg(ql_dbg_disc, vha, 0x2041,
-		    "RPA exiting normally.\n");
-	}
+	/* Port Type */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_PORT_TYPE);
+	eiter->a.port_type = cpu_to_be32(NS_NX_PORT_TYPE);
+	alen = sizeof(eiter->a.port_type);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20c9,
+	    "PORT TYPE = %x.\n", be32_to_cpu(eiter->a.port_type));
+
+	/* Supported Class of Service */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_PORT_SUPP_COS);
+	eiter->a.port_supported_cos = cpu_to_be32(FC_CLASS_3);
+	alen = sizeof(eiter->a.port_supported_cos);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20ca,
+	    "SUPPORTED COS = %08x\n", be32_to_cpu(eiter->a.port_supported_cos));
 
-	return rval;
+	/* Port Fabric Name */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_PORT_FABRIC_NAME);
+	memcpy(eiter->a.fabric_name, vha->fabric_node_name,
+	    sizeof(eiter->a.fabric_name));
+	alen = sizeof(eiter->a.fabric_name);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20cb,
+	    "FABRIC NAME = %016llx.\n", wwn_to_u64(eiter->a.fabric_name));
+
+	/* FC4_type */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_PORT_FC4_TYPE);
+	eiter->a.port_fc4_type[0] = 0x00;
+	eiter->a.port_fc4_type[1] = 0x00;
+	eiter->a.port_fc4_type[2] = 0x01;
+	eiter->a.port_fc4_type[3] = 0x00;
+	alen = sizeof(eiter->a.port_fc4_type);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20cc,
+	    "PORT ACTIVE FC4 TYPE = %016llx.\n",
+	    *(uint64_t *)eiter->a.port_fc4_type);
+
+	/* Port State */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_PORT_STATE);
+	eiter->a.port_state = cpu_to_be32(2);
+	alen = sizeof(eiter->a.port_state);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20cd,
+	    "PORT_STATE = %x.\n", be32_to_cpu(eiter->a.port_state));
+
+	/* Number of Ports */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_PORT_COUNT);
+	eiter->a.num_ports = cpu_to_be32(1);
+	alen = sizeof(eiter->a.num_ports);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20ce,
+	    "PORT COUNT = %x.\n", be32_to_cpu(eiter->a.num_ports));
+
+	/* Port Identifier */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_PORT_IDENTIFIER);
+	eiter->a.port_id = cpu_to_be32(vha->d_id.b24);
+	alen = sizeof(eiter->a.port_id);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20cf,
+	    "PORT ID = %x.\n", be32_to_cpu(eiter->a.port_id));
+
+	if (callopt == CALLOPT_FDMI2 || !ql2xsmartsan)
+		goto done;
+
+	/* Smart SAN Service Category (Populate Smart SAN Initiator)*/
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_SMARTSAN_SERVICE);
+	alen = scnprintf(
+		eiter->a.smartsan_service, sizeof(eiter->a.smartsan_service),
+		"%s", "Smart SAN Initiator");
+	alen += FDMI_ATTR_ALIGNMENT(alen);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20d0,
+	    "SMARTSAN SERVICE CATEGORY = %s.\n", eiter->a.smartsan_service);
+
+	/* Smart SAN GUID (NWWN+PWWN) */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_SMARTSAN_GUID);
+	memcpy(eiter->a.smartsan_guid, vha->node_name, WWN_SIZE);
+	memcpy(eiter->a.smartsan_guid + WWN_SIZE, vha->port_name, WWN_SIZE);
+	alen = sizeof(eiter->a.smartsan_guid);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20d1,
+	    "Smart SAN GUID = %016llx-%016llx\n",
+	    wwn_to_u64(eiter->a.smartsan_guid),
+	    wwn_to_u64(eiter->a.smartsan_guid + WWN_SIZE));
+
+	/* Smart SAN Version (populate "Smart SAN Version 1.0") */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_SMARTSAN_VERSION);
+	alen = scnprintf(
+		eiter->a.smartsan_version, sizeof(eiter->a.smartsan_version),
+		"%s", "Smart SAN Version 2.0");
+	alen += FDMI_ATTR_ALIGNMENT(alen);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20d2,
+	    "SMARTSAN VERSION = %s\n", eiter->a.smartsan_version);
+
+	/* Smart SAN Product Name (Specify Adapter Model No) */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_SMARTSAN_PROD_NAME);
+	alen = scnprintf(eiter->a.smartsan_prod_name,
+		sizeof(eiter->a.smartsan_prod_name),
+		"ISP%04x", ha->pdev->device);
+	alen += FDMI_ATTR_ALIGNMENT(alen);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20d3,
+	    "SMARTSAN PRODUCT NAME = %s\n", eiter->a.smartsan_prod_name);
+
+	/* Smart SAN Port Info (specify: 1=Physical, 2=NPIV, 3=SRIOV) */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_SMARTSAN_PORT_INFO);
+	eiter->a.smartsan_port_info = cpu_to_be32(vha->vp_idx ? 2 : 1);
+	alen = sizeof(eiter->a.smartsan_port_info);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20d4,
+	    "SMARTSAN PORT INFO = %x\n", eiter->a.smartsan_port_info);
+
+	/* Smart SAN Security Support */
+	eiter = entries + size;
+	eiter->type = cpu_to_be16(FDMI_SMARTSAN_SECURITY_SUPPORT);
+	eiter->a.smartsan_security_support = cpu_to_be32(1);
+	alen = sizeof(eiter->a.smartsan_security_support);
+	alen += FDMI_ATTR_TYPELEN(eiter);
+	eiter->len = cpu_to_be16(alen);
+	size += alen;
+	ql_dbg(ql_dbg_disc, vha, 0x20d6,
+	    "SMARTSAN SECURITY SUPPORT = %d\n",
+	    be32_to_cpu(eiter->a.smartsan_security_support));
+
+done:
+	return size;
 }
 
 /**
- * qla2x00_fdmiv2_rhba() - perform RHBA FDMI v2 registration
+ * qla2x00_fdmi_rhba() - perform RHBA FDMI registration
  * @vha: HA context
+ * @callopt: Option to issue FDMI registration
  *
  * Returns 0 on success.
  */
 static int
-qla2x00_fdmiv2_rhba(scsi_qla_host_t *vha)
+qla2x00_fdmi_rhba(scsi_qla_host_t *vha, unsigned int callopt)
 {
-	int rval, alen;
-	uint32_t size, sn;
+	struct qla_hw_data *ha = vha->hw;
+	unsigned long size = 0;
+	unsigned int rval, count;
 	ms_iocb_entry_t *ms_pkt;
 	struct ct_sns_req *ct_req;
 	struct ct_sns_rsp *ct_rsp;
 	void *entries;
-	struct ct_fdmiv2_hba_attr *eiter;
-	struct qla_hw_data *ha = vha->hw;
-	struct new_utsname *p_sysid = NULL;
 
-	/* Issue RHBA */
-	/* Prepare common MS IOCB */
-	/*   Request size adjusted after CT preparation */
-	ms_pkt = ha->isp_ops->prep_ms_fdmi_iocb(vha, 0, RHBA_RSP_SIZE);
+	count = callopt != CALLOPT_FDMI1 ?
+	    FDMI2_HBA_ATTR_COUNT : FDMI1_HBA_ATTR_COUNT;
 
-	/* Prepare CT request */
-	ct_req = qla2x00_prep_ct_fdmi_req(ha->ct_sns, RHBA_CMD,
-	    RHBA_RSP_SIZE);
-	ct_rsp = &ha->ct_sns->p.rsp;
-
-	/* Prepare FDMI command arguments -- attribute block, attributes. */
-	memcpy(ct_req->req.rhba2.hba_identifier, vha->port_name, WWN_SIZE);
-	ct_req->req.rhba2.entry_count = cpu_to_be32(1);
-	memcpy(ct_req->req.rhba2.port_name, vha->port_name, WWN_SIZE);
-	size = 2 * WWN_SIZE + 4 + 4;
-
-	/* Attributes */
-	ct_req->req.rhba2.attrs.count = cpu_to_be32(FDMIV2_HBA_ATTR_COUNT);
-	entries = &ct_req->req;
-
-	/* Nodename. */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_HBA_NODE_NAME);
-	eiter->len = cpu_to_be16(4 + WWN_SIZE);
-	memcpy(eiter->a.node_name, vha->node_name, WWN_SIZE);
-	size += 4 + WWN_SIZE;
-
-	ql_dbg(ql_dbg_disc, vha, 0x207d,
-	    "NodeName = %016llx.\n", wwn_to_u64(eiter->a.node_name));
-
-	/* Manufacturer. */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_HBA_MANUFACTURER);
-	snprintf(eiter->a.manufacturer, sizeof(eiter->a.manufacturer),
-	    "%s", "QLogic Corporation");
-	eiter->a.manufacturer[strlen("QLogic Corporation")] = '\0';
-	alen = strlen(eiter->a.manufacturer);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x20a5,
-	    "Manufacturer = %s.\n", eiter->a.manufacturer);
-
-	/* Serial number. */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_HBA_SERIAL_NUMBER);
-	if (IS_FWI2_CAPABLE(ha))
-		qla2xxx_get_vpd_field(vha, "SN", eiter->a.serial_num,
-		    sizeof(eiter->a.serial_num));
-	else {
-		sn = ((ha->serial0 & 0x1f) << 16) |
-			(ha->serial2 << 8) | ha->serial1;
-		snprintf(eiter->a.serial_num, sizeof(eiter->a.serial_num),
-		    "%c%05d", 'A' + sn / 100000, sn % 100000);
-	}
-	alen = strlen(eiter->a.serial_num);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x20a6,
-	    "Serial no. = %s.\n", eiter->a.serial_num);
-
-	/* Model name. */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_HBA_MODEL);
-	snprintf(eiter->a.model, sizeof(eiter->a.model),
-	    "%s", ha->model_number);
-	alen = strlen(eiter->a.model);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x20a7,
-	    "Model Name = %s.\n", eiter->a.model);
-
-	/* Model description. */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_HBA_MODEL_DESCRIPTION);
-	snprintf(eiter->a.model_desc, sizeof(eiter->a.model_desc),
-	    "%s", ha->model_desc);
-	alen = strlen(eiter->a.model_desc);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x20a8,
-	    "Model Desc = %s.\n", eiter->a.model_desc);
-
-	/* Hardware version. */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_HBA_HARDWARE_VERSION);
-	if (!IS_FWI2_CAPABLE(ha)) {
-		snprintf(eiter->a.hw_version, sizeof(eiter->a.hw_version),
-		    "HW:%s", ha->adapter_id);
-	} else if (qla2xxx_get_vpd_field(vha, "MN", eiter->a.hw_version,
-		    sizeof(eiter->a.hw_version))) {
-		;
-	} else if (qla2xxx_get_vpd_field(vha, "EC", eiter->a.hw_version,
-		    sizeof(eiter->a.hw_version))) {
-		;
-	} else {
-		snprintf(eiter->a.hw_version, sizeof(eiter->a.hw_version),
-		    "HW:%s", ha->adapter_id);
-	}
-	alen = strlen(eiter->a.hw_version);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x20a9,
-	    "Hardware ver = %s.\n", eiter->a.hw_version);
-
-	/* Driver version. */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_HBA_DRIVER_VERSION);
-	snprintf(eiter->a.driver_version, sizeof(eiter->a.driver_version),
-	    "%s", qla2x00_version_str);
-	alen = strlen(eiter->a.driver_version);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x20aa,
-	    "Driver ver = %s.\n", eiter->a.driver_version);
-
-	/* Option ROM version. */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_HBA_OPTION_ROM_VERSION);
-	snprintf(eiter->a.orom_version, sizeof(eiter->a.orom_version),
-	    "%d.%02d", ha->bios_revision[1], ha->bios_revision[0]);
-	alen = strlen(eiter->a.orom_version);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha , 0x20ab,
-	    "Optrom version = %d.%02d.\n", eiter->a.orom_version[1],
-	    eiter->a.orom_version[0]);
-
-	/* Firmware version */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_HBA_FIRMWARE_VERSION);
-	ha->isp_ops->fw_version_str(vha, eiter->a.fw_version,
-	    sizeof(eiter->a.fw_version));
-	alen = strlen(eiter->a.fw_version);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x20ac,
-	    "Firmware vers = %s.\n", eiter->a.fw_version);
-
-	/* OS Name and Version */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_HBA_OS_NAME_AND_VERSION);
-	p_sysid = utsname();
-	if (p_sysid) {
-		snprintf(eiter->a.os_version, sizeof(eiter->a.os_version),
-		    "%s %s %s",
-		    p_sysid->sysname, p_sysid->release, p_sysid->version);
-	} else {
-		snprintf(eiter->a.os_version, sizeof(eiter->a.os_version),
-		    "%s %s", "Linux", fc_host_system_hostname(vha->host));
-	}
-	alen = strlen(eiter->a.os_version);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x20ae,
-	    "OS Name and Version = %s.\n", eiter->a.os_version);
-
-	/* MAX CT Payload Length */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_HBA_MAXIMUM_CT_PAYLOAD_LENGTH);
-	eiter->a.max_ct_len = cpu_to_be32(ha->frame_payload_size);
-	eiter->a.max_ct_len = cpu_to_be32(eiter->a.max_ct_len);
-	eiter->len = cpu_to_be16(4 + 4);
-	size += 4 + 4;
-
-	ql_dbg(ql_dbg_disc, vha, 0x20af,
-	    "CT Payload Length = 0x%x.\n", eiter->a.max_ct_len);
+	size = RHBA_RSP_SIZE;
 
-	/* Node Sybolic Name */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_HBA_NODE_SYMBOLIC_NAME);
-	qla2x00_get_sym_node_name(vha, eiter->a.sym_name,
-	    sizeof(eiter->a.sym_name));
-	alen = strlen(eiter->a.sym_name);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x20b0,
-	    "Symbolic Name = %s.\n", eiter->a.sym_name);
-
-	/* Vendor Id */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_HBA_VENDOR_ID);
-	eiter->a.vendor_id = cpu_to_be32(0x1077);
-	eiter->len = cpu_to_be16(4 + 4);
-	size += 4 + 4;
+	ql_dbg(ql_dbg_disc, vha, 0x20e0,
+	    "RHBA (callopt=%x count=%u size=%lu).\n", callopt, count, size);
 
-	ql_dbg(ql_dbg_disc, vha, 0x20b1,
-	    "Vendor Id = %x.\n", eiter->a.vendor_id);
-
-	/* Num Ports */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_HBA_NUM_PORTS);
-	eiter->a.num_ports = cpu_to_be32(1);
-	eiter->len = cpu_to_be16(4 + 4);
-	size += 4 + 4;
+	/*   Request size adjusted after CT preparation */
+	ms_pkt = ha->isp_ops->prep_ms_fdmi_iocb(vha, 0, size);
 
-	ql_dbg(ql_dbg_disc, vha, 0x20b2,
-	    "Port Num = %x.\n", eiter->a.num_ports);
+	/* Prepare CT request */
+	ct_req = qla2x00_prep_ct_fdmi_req(ha->ct_sns, RHBA_CMD, size);
+	ct_rsp = &ha->ct_sns->p.rsp;
 
-	/* Fabric Name */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_HBA_FABRIC_NAME);
-	memcpy(eiter->a.fabric_name, vha->fabric_node_name, WWN_SIZE);
-	eiter->len = cpu_to_be16(4 + WWN_SIZE);
-	size += 4 + WWN_SIZE;
+	/* Prepare FDMI command entries */
+	memcpy(ct_req->req.rhba.hba_identifier, vha->port_name,
+	    sizeof(ct_req->req.rhba.hba_identifier));
+	size += sizeof(ct_req->req.rhba.hba_identifier);
 
-	ql_dbg(ql_dbg_disc, vha, 0x20b3,
-	    "Fabric Name = %016llx.\n", wwn_to_u64(eiter->a.fabric_name));
+	ct_req->req.rhba.entry_count = cpu_to_be32(1);
+	size += sizeof(ct_req->req.rhba.entry_count);
 
-	/* BIOS Version */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_HBA_BOOT_BIOS_NAME);
-	snprintf(eiter->a.bios_name, sizeof(eiter->a.bios_name),
-	    "BIOS %d.%02d", ha->bios_revision[1], ha->bios_revision[0]);
-	alen = strlen(eiter->a.bios_name);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
+	memcpy(ct_req->req.rhba.port_name, vha->port_name,
+	    sizeof(ct_req->req.rhba.port_name));
+	size += sizeof(ct_req->req.rhba.port_name);
 
-	ql_dbg(ql_dbg_disc, vha, 0x20b4,
-	    "BIOS Name = %s\n", eiter->a.bios_name);
+	/* Attribute count */
+	ct_req->req.rhba.attrs.count = cpu_to_be32(count);
+	size += sizeof(ct_req->req.rhba.attrs.count);
 
-	/* Vendor Identifier */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_HBA_TYPE_VENDOR_IDENTIFIER);
-	snprintf(eiter->a.vendor_identifier, sizeof(eiter->a.vendor_identifier),
-	    "%s", "QLGC");
-	alen = strlen(eiter->a.vendor_identifier);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
+	/* Attribute block */
+	entries = &ct_req->req.rhba.attrs.entry;
 
-	ql_dbg(ql_dbg_disc, vha, 0x201b,
-	    "Vendor Identifier = %s.\n", eiter->a.vendor_identifier);
+	size += qla2x00_hba_attributes(vha, entries, callopt);
 
 	/* Update MS request size. */
 	qla2x00_update_ms_fdmi_iocb(vha, size + 16);
 
-	ql_dbg(ql_dbg_disc, vha, 0x20b5,
-	    "RHBA identifier = %016llx.\n",
-	    wwn_to_u64(ct_req->req.rhba2.hba_identifier));
-	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x20b6,
+	ql_dbg(ql_dbg_disc, vha, 0x20e1,
+	    "RHBA %016llx %016llx.\n",
+	    wwn_to_u64(ct_req->req.rhba.hba_identifier),
+	    wwn_to_u64(ct_req->req.rhba.port_name));
+
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x20e2,
 	    entries, size);
 
 	/* Execute MS IOCB */
 	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
-	    sizeof(ms_iocb_entry_t));
-	if (rval != QLA_SUCCESS) {
-		/*EMPTY*/
-		ql_dbg(ql_dbg_disc, vha, 0x20b7,
-		    "RHBA issue IOCB failed (%d).\n", rval);
-	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "RHBA") !=
-	    QLA_SUCCESS) {
-		rval = QLA_FUNCTION_FAILED;
+	    sizeof(*ha->ms_iocb));
+	if (rval) {
+		ql_dbg(ql_dbg_disc, vha, 0x20e3,
+		    "RHBA iocb failed (%d).\n", rval);
+		return rval;
+	}
 
+	rval = qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "RHBA");
+	if (rval) {
 		if (ct_rsp->header.reason_code == CT_REASON_CANNOT_PERFORM &&
 		    ct_rsp->header.explanation_code ==
 		    CT_EXPL_ALREADY_REGISTERED) {
-			ql_dbg(ql_dbg_disc, vha, 0x20b8,
-			    "HBA already registered.\n");
-			rval = QLA_ALREADY_REGISTERED;
-		} else {
-			ql_dbg(ql_dbg_disc, vha, 0x2016,
-			    "RHBA FDMI v2 failed, CT Reason code: 0x%x, CT Explanation 0x%x\n",
-			    ct_rsp->header.reason_code,
-			    ct_rsp->header.explanation_code);
+			ql_dbg(ql_dbg_disc, vha, 0x20e4,
+			    "RHBA already registered.\n");
+			return QLA_ALREADY_REGISTERED;
 		}
-	} else {
-		ql_dbg(ql_dbg_disc, vha, 0x20b9,
-		    "RHBA FDMI V2 exiting normally.\n");
+
+		ql_dbg(ql_dbg_disc, vha, 0x20e5,
+		    "RHBA failed, CT Reason %#x, CT Explanation %#x\n",
+		    ct_rsp->header.reason_code,
+		    ct_rsp->header.explanation_code);
+		return rval;
 	}
 
+	ql_dbg(ql_dbg_disc, vha, 0x20e6, "RHBA exiting normally.\n");
 	return rval;
 }
 
-/**
- * qla2x00_fdmi_dhba() -
- * @vha: HA context
- *
- * Returns 0 on success.
- */
+
 static int
 qla2x00_fdmi_dhba(scsi_qla_host_t *vha)
 {
@@ -2249,22 +2236,17 @@ qla2x00_fdmi_dhba(scsi_qla_host_t *vha)
 	ms_iocb_entry_t *ms_pkt;
 	struct ct_sns_req *ct_req;
 	struct ct_sns_rsp *ct_rsp;
-
 	/* Issue RPA */
 	/* Prepare common MS IOCB */
 	ms_pkt = ha->isp_ops->prep_ms_fdmi_iocb(vha, DHBA_REQ_SIZE,
 	    DHBA_RSP_SIZE);
-
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_fdmi_req(ha->ct_sns, DHBA_CMD, DHBA_RSP_SIZE);
 	ct_rsp = &ha->ct_sns->p.rsp;
-
 	/* Prepare FDMI command arguments -- portname. */
 	memcpy(ct_req->req.dhba.port_name, vha->port_name, WWN_SIZE);
-
 	ql_dbg(ql_dbg_disc, vha, 0x2036,
 	    "DHBA portname = %8phN.\n", ct_req->req.dhba.port_name);
-
 	/* Execute MS IOCB */
 	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
 	    sizeof(ms_iocb_entry_t));
@@ -2279,337 +2261,178 @@ qla2x00_fdmi_dhba(scsi_qla_host_t *vha)
 		ql_dbg(ql_dbg_disc, vha, 0x2038,
 		    "DHBA exiting normally.\n");
 	}
-
 	return rval;
 }
 
 /**
- * qla2x00_fdmiv2_rpa() -
+ * qla2x00_fdmi_rprt() perform RPRT registration
  * @vha: HA context
+ * @callopt: Option to issue extended or standard FDMI
+ *           command parameter
  *
  * Returns 0 on success.
  */
 static int
-qla2x00_fdmiv2_rpa(scsi_qla_host_t *vha)
+qla2x00_fdmi_rprt(scsi_qla_host_t *vha, int callopt)
 {
-	int rval, alen;
-	uint32_t size;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(vha->hw->pdev);
 	struct qla_hw_data *ha = vha->hw;
+	ulong size = 0;
+	uint rval, count;
 	ms_iocb_entry_t *ms_pkt;
 	struct ct_sns_req *ct_req;
 	struct ct_sns_rsp *ct_rsp;
 	void *entries;
-	struct ct_fdmiv2_port_attr *eiter;
-	struct init_cb_24xx *icb24 = (struct init_cb_24xx *)ha->init_cb;
-	struct new_utsname *p_sysid = NULL;
-
-	/* Issue RPA */
-	/* Prepare common MS IOCB */
-	/*   Request size adjusted after CT preparation */
-	ms_pkt = ha->isp_ops->prep_ms_fdmi_iocb(vha, 0, RPA_RSP_SIZE);
-
+	count = callopt == CALLOPT_FDMI2_SMARTSAN && ql2xsmartsan ?
+		FDMI2_SMARTSAN_PORT_ATTR_COUNT :
+		callopt != CALLOPT_FDMI1 ?
+		FDMI2_PORT_ATTR_COUNT : FDMI1_PORT_ATTR_COUNT;
+
+	size = RPRT_RSP_SIZE;
+	ql_dbg(ql_dbg_disc, vha, 0x20e8,
+	    "RPRT (callopt=%x count=%u size=%lu).\n", callopt, count, size);
+	/* Request size adjusted after CT preparation */
+	ms_pkt = ha->isp_ops->prep_ms_fdmi_iocb(vha, 0, size);
 	/* Prepare CT request */
-	ct_req = qla2x00_prep_ct_fdmi_req(ha->ct_sns, RPA_CMD, RPA_RSP_SIZE);
+	ct_req = qla2x00_prep_ct_fdmi_req(ha->ct_sns, RPRT_CMD, size);
 	ct_rsp = &ha->ct_sns->p.rsp;
-
-	/* Prepare FDMI command arguments -- attribute block, attributes. */
-	memcpy(ct_req->req.rpa2.port_name, vha->port_name, WWN_SIZE);
-	size = WWN_SIZE + 4;
-
-	/* Attributes */
-	ct_req->req.rpa2.attrs.count = cpu_to_be32(FDMIV2_PORT_ATTR_COUNT);
-	entries = &ct_req->req;
-
-	/* FC4 types. */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_PORT_FC4_TYPES);
-	eiter->len = cpu_to_be16(4 + 32);
-	eiter->a.fc4_types[2] = 0x01;
-	size += 4 + 32;
-
-	ql_dbg(ql_dbg_disc, vha, 0x20ba,
-	    "FC4_TYPES=%02x %02x.\n",
-	    eiter->a.fc4_types[2],
-	    eiter->a.fc4_types[1]);
-
-	if (vha->flags.nvme_enabled) {
-		eiter->a.fc4_types[6] = 1;	/* NVMe type 28h */
-		ql_dbg(ql_dbg_disc, vha, 0x211f,
-		    "NVME FC4 Type = %02x 0x0 0x0 0x0 0x0 0x0.\n",
-		    eiter->a.fc4_types[6]);
-	}
-
-	/* Supported speed. */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_PORT_SUPPORT_SPEED);
-	eiter->len = cpu_to_be16(4 + 4);
-	if (IS_CNA_CAPABLE(ha))
-		eiter->a.sup_speed = cpu_to_be32(
-		    FDMI_PORT_SPEED_10GB);
-	else if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
-		eiter->a.sup_speed = cpu_to_be32(
-		    FDMI_PORT_SPEED_32GB|
-		    FDMI_PORT_SPEED_16GB|
-		    FDMI_PORT_SPEED_8GB);
-	else if (IS_QLA2031(ha))
-		eiter->a.sup_speed = cpu_to_be32(
-		    FDMI_PORT_SPEED_16GB|
-		    FDMI_PORT_SPEED_8GB|
-		    FDMI_PORT_SPEED_4GB);
-	else if (IS_QLA25XX(ha))
-		eiter->a.sup_speed = cpu_to_be32(
-		    FDMI_PORT_SPEED_8GB|
-		    FDMI_PORT_SPEED_4GB|
-		    FDMI_PORT_SPEED_2GB|
-		    FDMI_PORT_SPEED_1GB);
-	else if (IS_QLA24XX_TYPE(ha))
-		eiter->a.sup_speed = cpu_to_be32(
-		    FDMI_PORT_SPEED_4GB|
-		    FDMI_PORT_SPEED_2GB|
-		    FDMI_PORT_SPEED_1GB);
-	else if (IS_QLA23XX(ha))
-		eiter->a.sup_speed = cpu_to_be32(
-		    FDMI_PORT_SPEED_2GB|
-		    FDMI_PORT_SPEED_1GB);
-	else
-		eiter->a.sup_speed = cpu_to_be32(
-		    FDMI_PORT_SPEED_1GB);
-	size += 4 + 4;
-
-	ql_dbg(ql_dbg_disc, vha, 0x20bb,
-	    "Supported Port Speed = %x.\n", eiter->a.sup_speed);
-
-	/* Current speed. */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_PORT_CURRENT_SPEED);
-	eiter->len = cpu_to_be16(4 + 4);
-	switch (ha->link_data_rate) {
-	case PORT_SPEED_1GB:
-		eiter->a.cur_speed = cpu_to_be32(FDMI_PORT_SPEED_1GB);
-		break;
-	case PORT_SPEED_2GB:
-		eiter->a.cur_speed = cpu_to_be32(FDMI_PORT_SPEED_2GB);
-		break;
-	case PORT_SPEED_4GB:
-		eiter->a.cur_speed = cpu_to_be32(FDMI_PORT_SPEED_4GB);
-		break;
-	case PORT_SPEED_8GB:
-		eiter->a.cur_speed = cpu_to_be32(FDMI_PORT_SPEED_8GB);
-		break;
-	case PORT_SPEED_10GB:
-		eiter->a.cur_speed = cpu_to_be32(FDMI_PORT_SPEED_10GB);
-		break;
-	case PORT_SPEED_16GB:
-		eiter->a.cur_speed = cpu_to_be32(FDMI_PORT_SPEED_16GB);
-		break;
-	case PORT_SPEED_32GB:
-		eiter->a.cur_speed = cpu_to_be32(FDMI_PORT_SPEED_32GB);
-		break;
-	default:
-		eiter->a.cur_speed = cpu_to_be32(FDMI_PORT_SPEED_UNKNOWN);
-		break;
+	/* Prepare FDMI command entries */
+	memcpy(ct_req->req.rprt.hba_identifier, base_vha->port_name,
+	    sizeof(ct_req->req.rprt.hba_identifier));
+	size += sizeof(ct_req->req.rprt.hba_identifier);
+	memcpy(ct_req->req.rprt.port_name, vha->port_name,
+	    sizeof(ct_req->req.rprt.port_name));
+	size += sizeof(ct_req->req.rprt.port_name);
+	/* Attribute count */
+	ct_req->req.rprt.attrs.count = cpu_to_be32(count);
+	size += sizeof(ct_req->req.rprt.attrs.count);
+	/* Attribute block */
+	entries = ct_req->req.rprt.attrs.entry;
+	size += qla2x00_port_attributes(vha, entries, callopt);
+	/* Update MS request size. */
+	qla2x00_update_ms_fdmi_iocb(vha, size + 16);
+	ql_dbg(ql_dbg_disc, vha, 0x20e9,
+	    "RPRT %016llx  %016llx.\n",
+	    wwn_to_u64(ct_req->req.rprt.port_name),
+	    wwn_to_u64(ct_req->req.rprt.port_name));
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x20ea,
+	    entries, size);
+	/* Execute MS IOCB */
+	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
+	    sizeof(*ha->ms_iocb));
+	if (rval) {
+		ql_dbg(ql_dbg_disc, vha, 0x20eb,
+		    "RPRT iocb failed (%d).\n", rval);
+		return rval;
 	}
-	size += 4 + 4;
-
-	ql_dbg(ql_dbg_disc, vha, 0x2017,
-	    "Current_Speed = %x.\n", eiter->a.cur_speed);
-
-	/* Max frame size. */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_PORT_MAX_FRAME_SIZE);
-	eiter->len = cpu_to_be16(4 + 4);
-	eiter->a.max_frame_size = IS_FWI2_CAPABLE(ha) ?
-	    le16_to_cpu(icb24->frame_payload_size) :
-	    le16_to_cpu(ha->init_cb->frame_payload_size);
-	eiter->a.max_frame_size = cpu_to_be32(eiter->a.max_frame_size);
-	size += 4 + 4;
-
-	ql_dbg(ql_dbg_disc, vha, 0x20bc,
-	    "Max_Frame_Size = %x.\n", eiter->a.max_frame_size);
-
-	/* OS device name. */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_PORT_OS_DEVICE_NAME);
-	alen = strlen(QLA2XXX_DRIVER_NAME);
-	snprintf(eiter->a.os_dev_name, sizeof(eiter->a.os_dev_name),
-	    "%s:host%lu", QLA2XXX_DRIVER_NAME, vha->host_no);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x20be,
-	    "OS_Device_Name = %s.\n", eiter->a.os_dev_name);
+	rval = qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "RPRT");
+	if (rval) {
+		if (ct_rsp->header.reason_code == CT_REASON_CANNOT_PERFORM &&
+		    ct_rsp->header.explanation_code ==
+		    CT_EXPL_ALREADY_REGISTERED) {
+			ql_dbg(ql_dbg_disc, vha, 0x20ec,
+			    "RPRT already registered.\n");
+			return QLA_ALREADY_REGISTERED;
+		}
 
-	/* Hostname. */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_PORT_HOST_NAME);
-	p_sysid = utsname();
-	if (p_sysid) {
-		snprintf(eiter->a.host_name, sizeof(eiter->a.host_name),
-		    "%s", p_sysid->nodename);
-	} else {
-		snprintf(eiter->a.host_name, sizeof(eiter->a.host_name),
-		    "%s", fc_host_system_hostname(vha->host));
+		ql_dbg(ql_dbg_disc, vha, 0x20ed,
+		    "RPRT failed, CT Reason code: %#x, CT Explanation %#x\n",
+		    ct_rsp->header.reason_code,
+		    ct_rsp->header.explanation_code);
+		return rval;
 	}
-	alen = strlen(eiter->a.host_name);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x201a,
-	    "HostName=%s.\n", eiter->a.host_name);
-
-	/* Node Name */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_PORT_NODE_NAME);
-	memcpy(eiter->a.node_name, vha->node_name, WWN_SIZE);
-	eiter->len = cpu_to_be16(4 + WWN_SIZE);
-	size += 4 + WWN_SIZE;
-
-	ql_dbg(ql_dbg_disc, vha, 0x20c0,
-	    "Node Name = %016llx.\n", wwn_to_u64(eiter->a.node_name));
-
-	/* Port Name */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_PORT_NAME);
-	memcpy(eiter->a.port_name, vha->port_name, WWN_SIZE);
-	eiter->len = cpu_to_be16(4 + WWN_SIZE);
-	size += 4 + WWN_SIZE;
-
-	ql_dbg(ql_dbg_disc, vha, 0x20c1,
-	    "Port Name = %016llx.\n", wwn_to_u64(eiter->a.port_name));
-
-	/* Port Symbolic Name */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_PORT_SYM_NAME);
-	qla2x00_get_sym_node_name(vha, eiter->a.port_sym_name,
-	    sizeof(eiter->a.port_sym_name));
-	alen = strlen(eiter->a.port_sym_name);
-	alen += 4 - (alen & 3);
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
-
-	ql_dbg(ql_dbg_disc, vha, 0x20c2,
-	    "port symbolic name = %s\n", eiter->a.port_sym_name);
-
-	/* Port Type */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_PORT_TYPE);
-	eiter->a.port_type = cpu_to_be32(NS_NX_PORT_TYPE);
-	eiter->len = cpu_to_be16(4 + 4);
-	size += 4 + 4;
-
-	ql_dbg(ql_dbg_disc, vha, 0x20c3,
-	    "Port Type = %x.\n", eiter->a.port_type);
-
-	/* Class of Service  */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_PORT_SUPP_COS);
-	eiter->a.port_supported_cos = cpu_to_be32(FC_CLASS_3);
-	eiter->len = cpu_to_be16(4 + 4);
-	size += 4 + 4;
-
-	ql_dbg(ql_dbg_disc, vha, 0x20c4,
-	    "Supported COS = %08x\n", eiter->a.port_supported_cos);
-
-	/* Port Fabric Name */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_PORT_FABRIC_NAME);
-	memcpy(eiter->a.fabric_name, vha->fabric_node_name, WWN_SIZE);
-	eiter->len = cpu_to_be16(4 + WWN_SIZE);
-	size += 4 + WWN_SIZE;
+	ql_dbg(ql_dbg_disc, vha, 0x20ee, "RPRT exiting normally.\n");
+	return rval;
+}
 
-	ql_dbg(ql_dbg_disc, vha, 0x20c5,
-	    "Fabric Name = %016llx.\n", wwn_to_u64(eiter->a.fabric_name));
+/**
+ * qla2x00_fdmi_rpa() - perform RPA registration
+ * @vha: HA context
+ * @callopt: Option to issue FDMI registration
+ *
+ * Returns 0 on success.
+ */
+static int
+qla2x00_fdmi_rpa(scsi_qla_host_t *vha, uint callopt)
+{
+	struct qla_hw_data *ha = vha->hw;
+	ulong size = 0;
+	uint rval, count;
+	ms_iocb_entry_t *ms_pkt;
+	struct ct_sns_req *ct_req;
+	struct ct_sns_rsp *ct_rsp;
+	void *entries;
 
-	/* FC4_type */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_PORT_FC4_TYPE);
-	eiter->a.port_fc4_type[0] = 0;
-	eiter->a.port_fc4_type[1] = 0;
-	eiter->a.port_fc4_type[2] = 1;
-	eiter->a.port_fc4_type[3] = 0;
-	eiter->len = cpu_to_be16(4 + 32);
-	size += 4 + 32;
+	count =
+	    callopt == CALLOPT_FDMI2_SMARTSAN && ql2xsmartsan ?
+		FDMI2_SMARTSAN_PORT_ATTR_COUNT :
+	    callopt != CALLOPT_FDMI1 ?
+		FDMI2_PORT_ATTR_COUNT : FDMI1_PORT_ATTR_COUNT;
 
-	ql_dbg(ql_dbg_disc, vha, 0x20c6,
-	    "Port Active FC4 Type = %02x %02x.\n",
-	    eiter->a.port_fc4_type[2], eiter->a.port_fc4_type[1]);
+	size =
+	    callopt != CALLOPT_FDMI1 ?
+		SMARTSAN_RPA_RSP_SIZE : RPA_RSP_SIZE;
 
-	if (vha->flags.nvme_enabled) {
-		eiter->a.port_fc4_type[4] = 0;
-		eiter->a.port_fc4_type[5] = 0;
-		eiter->a.port_fc4_type[6] = 1;	/* NVMe type 28h */
-		ql_dbg(ql_dbg_disc, vha, 0x2120,
-		    "NVME Port Active FC4 Type = %02x 0x0 0x0 0x0 0x0 0x0.\n",
-		    eiter->a.port_fc4_type[6]);
-	}
+	ql_dbg(ql_dbg_disc, vha, 0x20f0,
+	    "RPA (callopt=%x count=%u size=%lu).\n", callopt, count, size);
 
-	/* Port State */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_PORT_STATE);
-	eiter->a.port_state = cpu_to_be32(1);
-	eiter->len = cpu_to_be16(4 + 4);
-	size += 4 + 4;
+	/* Request size adjusted after CT preparation */
+	ms_pkt = ha->isp_ops->prep_ms_fdmi_iocb(vha, 0, size);
 
-	ql_dbg(ql_dbg_disc, vha, 0x20c7,
-	    "Port State = %x.\n", eiter->a.port_state);
+	/* Prepare CT request */
+	ct_req = qla2x00_prep_ct_fdmi_req(ha->ct_sns, RPA_CMD, size);
+	ct_rsp = &ha->ct_sns->p.rsp;
 
-	/* Number of Ports */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_PORT_COUNT);
-	eiter->a.num_ports = cpu_to_be32(1);
-	eiter->len = cpu_to_be16(4 + 4);
-	size += 4 + 4;
+	/* Prepare FDMI command entries. */
+	memcpy(ct_req->req.rpa.port_name, vha->port_name,
+	    sizeof(ct_req->req.rpa.port_name));
+	size += sizeof(ct_req->req.rpa.port_name);
 
-	ql_dbg(ql_dbg_disc, vha, 0x20c8,
-	    "Number of ports = %x.\n", eiter->a.num_ports);
+	/* Attribute count */
+	ct_req->req.rpa.attrs.count = cpu_to_be32(count);
+	size += sizeof(ct_req->req.rpa.attrs.count);
 
-	/* Port Id */
-	eiter = entries + size;
-	eiter->type = cpu_to_be16(FDMI_PORT_ID);
-	eiter->a.port_id = cpu_to_be32(vha->d_id.b24);
-	eiter->len = cpu_to_be16(4 + 4);
-	size += 4 + 4;
+	/* Attribute block */
+	entries = ct_req->req.rpa.attrs.entry;
 
-	ql_dbg(ql_dbg_disc, vha, 0x201c,
-	    "Port Id = %x.\n", eiter->a.port_id);
+	size += qla2x00_port_attributes(vha, entries, callopt);
 
 	/* Update MS request size. */
 	qla2x00_update_ms_fdmi_iocb(vha, size + 16);
 
-	ql_dbg(ql_dbg_disc, vha, 0x2018,
-	    "RPA portname= %8phN size=%d.\n", ct_req->req.rpa.port_name, size);
-	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x20ca,
+	ql_dbg(ql_dbg_disc, vha, 0x20f1,
+	    "RPA %016llx.\n", wwn_to_u64(ct_req->req.rpa.port_name));
+
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x20f2,
 	    entries, size);
 
 	/* Execute MS IOCB */
 	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
-	    sizeof(ms_iocb_entry_t));
-	if (rval != QLA_SUCCESS) {
-		/*EMPTY*/
-		ql_dbg(ql_dbg_disc, vha, 0x20cb,
-		    "RPA FDMI v2 issue IOCB failed (%d).\n", rval);
-	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "RPA") !=
-	    QLA_SUCCESS) {
-		rval = QLA_FUNCTION_FAILED;
+	    sizeof(*ha->ms_iocb));
+	if (rval) {
+		ql_dbg(ql_dbg_disc, vha, 0x20f3,
+		    "RPA iocb failed (%d).\n", rval);
+		return rval;
+	}
+
+	rval = qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "RPA");
+	if (rval) {
 		if (ct_rsp->header.reason_code == CT_REASON_CANNOT_PERFORM &&
 		    ct_rsp->header.explanation_code ==
 		    CT_EXPL_ALREADY_REGISTERED) {
-			ql_dbg(ql_dbg_disc, vha, 0x20ce,
-			    "RPA FDMI v2 already registered\n");
-			rval = QLA_ALREADY_REGISTERED;
-		} else {
-			ql_dbg(ql_dbg_disc, vha, 0x2020,
-			    "RPA FDMI v2 failed, CT Reason code: 0x%x, CT Explanation 0x%x\n",
-			    ct_rsp->header.reason_code,
-			    ct_rsp->header.explanation_code);
+			ql_dbg(ql_dbg_disc, vha, 0x20f4,
+			    "RPA already registered.\n");
+			return QLA_ALREADY_REGISTERED;
 		}
-	} else {
-		ql_dbg(ql_dbg_disc, vha, 0x20cc,
-		    "RPA FDMI V2 exiting normally.\n");
+
+		ql_dbg(ql_dbg_disc, vha, 0x20f5,
+		    "RPA failed, CT Reason code: %#x, CT Explanation %#x\n",
+		    ct_rsp->header.reason_code,
+		    ct_rsp->header.explanation_code);
+		return rval;
 	}
 
+	ql_dbg(ql_dbg_disc, vha, 0x20f6, "RPA exiting normally.\n");
 	return rval;
 }
 
@@ -2622,18 +2445,31 @@ qla2x00_fdmiv2_rpa(scsi_qla_host_t *vha)
 int
 qla2x00_fdmi_register(scsi_qla_host_t *vha)
 {
-	int rval = QLA_FUNCTION_FAILED;
+	int rval = QLA_SUCCESS;
 	struct qla_hw_data *ha = vha->hw;
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha) ||
 	    IS_QLAFX00(ha))
-		return QLA_FUNCTION_FAILED;
+		return rval;
 
 	rval = qla2x00_mgmt_svr_login(vha);
 	if (rval)
 		return rval;
 
-	rval = qla2x00_fdmiv2_rhba(vha);
+	/* For npiv/vport send rprt only */
+	if (vha->vp_idx) {
+		if (ql2xsmartsan)
+			rval = qla2x00_fdmi_rprt(vha, CALLOPT_FDMI2_SMARTSAN);
+		if (rval || !ql2xsmartsan)
+			rval = qla2x00_fdmi_rprt(vha, CALLOPT_FDMI2);
+		if (rval)
+			rval = qla2x00_fdmi_rprt(vha, CALLOPT_FDMI1);
+
+		return rval;
+	}
+
+	/* Try fdmi2 first, if fails then try fdmi1 */
+	rval = qla2x00_fdmi_rhba(vha, CALLOPT_FDMI2);
 	if (rval) {
 		if (rval != QLA_ALREADY_REGISTERED)
 			goto try_fdmi;
@@ -2642,18 +2478,22 @@ qla2x00_fdmi_register(scsi_qla_host_t *vha)
 		if (rval)
 			goto try_fdmi;
 
-		rval = qla2x00_fdmiv2_rhba(vha);
+		rval = qla2x00_fdmi_rhba(vha, CALLOPT_FDMI2);
 		if (rval)
 			goto try_fdmi;
 	}
-	rval = qla2x00_fdmiv2_rpa(vha);
+
+	if (ql2xsmartsan)
+		rval = qla2x00_fdmi_rpa(vha, CALLOPT_FDMI2_SMARTSAN);
+	if (rval || !ql2xsmartsan)
+		rval = qla2x00_fdmi_rpa(vha, CALLOPT_FDMI2);
 	if (rval)
 		goto try_fdmi;
 
-	goto out;
+	return rval;
 
 try_fdmi:
-	rval = qla2x00_fdmi_rhba(vha);
+	rval = qla2x00_fdmi_rhba(vha, CALLOPT_FDMI1);
 	if (rval) {
 		if (rval != QLA_ALREADY_REGISTERED)
 			return rval;
@@ -2662,12 +2502,13 @@ qla2x00_fdmi_register(scsi_qla_host_t *vha)
 		if (rval)
 			return rval;
 
-		rval = qla2x00_fdmi_rhba(vha);
+		rval = qla2x00_fdmi_rhba(vha, CALLOPT_FDMI1);
 		if (rval)
 			return rval;
 	}
-	rval = qla2x00_fdmi_rpa(vha);
-out:
+
+	rval = qla2x00_fdmi_rpa(vha, CALLOPT_FDMI1);
+
 	return rval;
 }
 
-- 
2.12.0

