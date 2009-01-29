From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] scsi: replace uses of __constant_{endian}
Date: Thu, 29 Jan 2009 13:51:35 -0800
Message-ID: <1233265895.5594.3.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:56829 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZA2WFa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2009 17:05:30 -0500
Received: by wf-out-1314.google.com with SMTP id 27so145452wfd.4
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2009 14:05:29 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>

The base versions handle constant folding now.  Almost entirely
in qla2xxx/qla4xxx.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/fcoe/fcoe_sw.c     |    2 +-
 drivers/scsi/qla2xxx/qla_dbg.c  |   16 ++--
 drivers/scsi/qla2xxx/qla_gs.c   |   98 ++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_init.c |  138 +++++++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_iocb.c |   22 +++---
 drivers/scsi/qla2xxx/qla_isr.c  |    4 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |   22 +++---
 drivers/scsi/qla2xxx/qla_sup.c  |   12 ++--
 drivers/scsi/qla4xxx/ql4_init.c |    4 +-
 drivers/scsi/qla4xxx/ql4_iocb.c |    2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c  |    8 +-
 11 files changed, 164 insertions(+), 164 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_sw.c b/drivers/scsi/fcoe/fcoe_sw.c
index dc4cd5e..9853667 100644
--- a/drivers/scsi/fcoe/fcoe_sw.c
+++ b/drivers/scsi/fcoe/fcoe_sw.c
@@ -217,7 +217,7 @@ static int fcoe_sw_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	 * on the ethertype for the given device
 	 */
 	fc->fcoe_packet_type.func = fcoe_rcv;
-	fc->fcoe_packet_type.type = __constant_htons(ETH_P_FCOE);
+	fc->fcoe_packet_type.type = cpu_to_be16(ETH_P_FCOE);
 	fc->fcoe_packet_type.dev = fc->real_dev;
 	dev_add_pack(&fc->fcoe_packet_type);
 
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 34760f8..21a8fe8 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -331,7 +331,7 @@ qla25xx_copy_fce(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 		return ptr;
 
 	*last_chain = &fcec->type;
-	fcec->type = __constant_htonl(DUMP_CHAIN_FCE);
+	fcec->type = cpu_to_be32(DUMP_CHAIN_FCE);
 	fcec->chain_size = htonl(sizeof(struct qla2xxx_fce_chain) +
 	    fce_calc_size(ha->fce_bufs));
 	fcec->size = htonl(fce_calc_size(ha->fce_bufs));
@@ -360,8 +360,8 @@ qla25xx_copy_mq(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 
 	mq = ptr;
 	*last_chain = &mq->type;
-	mq->type = __constant_htonl(DUMP_CHAIN_MQ);
-	mq->chain_size = __constant_htonl(sizeof(struct qla2xxx_mq_chain));
+	mq->type = cpu_to_be32(DUMP_CHAIN_MQ);
+	mq->chain_size = cpu_to_be32(sizeof(struct qla2xxx_mq_chain));
 
 	req_cnt = find_first_zero_bit(ha->req_qid_map, ha->max_queues);
 	rsp_cnt = find_first_zero_bit(ha->rsp_qid_map, ha->max_queues);
@@ -1042,7 +1042,7 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	}
 	fw = &ha->fw_dump->isp.isp25;
 	qla2xxx_prep_dump(ha, ha->fw_dump);
-	ha->fw_dump->version = __constant_htonl(2);
+	ha->fw_dump->version = cpu_to_be32(2);
 
 	fw->host_status = htonl(RD_REG_DWORD(&reg->host_status));
 
@@ -1303,8 +1303,8 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	/* Chain entries -- started with MQ. */
 	qla25xx_copy_fce(ha, nxt_chain, &last_chain);
 	if (last_chain) {
-		ha->fw_dump->version |= __constant_htonl(DUMP_CHAIN_VARIANT);
-		*last_chain |= __constant_htonl(DUMP_CHAIN_LAST);
+		ha->fw_dump->version |= cpu_to_be32(DUMP_CHAIN_VARIANT);
+		*last_chain |= cpu_to_be32(DUMP_CHAIN_LAST);
 	}
 
 qla25xx_fw_dump_failed_0:
@@ -1626,8 +1626,8 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	/* Chain entries -- started with MQ. */
 	qla25xx_copy_fce(ha, nxt_chain, &last_chain);
 	if (last_chain) {
-		ha->fw_dump->version |= __constant_htonl(DUMP_CHAIN_VARIANT);
-		*last_chain |= __constant_htonl(DUMP_CHAIN_LAST);
+		ha->fw_dump->version |= cpu_to_be32(DUMP_CHAIN_VARIANT);
+		*last_chain |= cpu_to_be32(DUMP_CHAIN_LAST);
 	}
 
 qla81xx_fw_dump_failed_0:
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 557f58d..cc8ab4d 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -33,10 +33,10 @@ qla2x00_prep_ms_iocb(scsi_qla_host_t *vha, uint32_t req_size, uint32_t rsp_size)
 	ms_pkt->entry_type = MS_IOCB_TYPE;
 	ms_pkt->entry_count = 1;
 	SET_TARGET_ID(ha, ms_pkt->loop_id, SIMPLE_NAME_SERVER);
-	ms_pkt->control_flags = __constant_cpu_to_le16(CF_READ | CF_HEAD_TAG);
+	ms_pkt->control_flags = cpu_to_le16(CF_READ | CF_HEAD_TAG);
 	ms_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
-	ms_pkt->cmd_dsd_count = __constant_cpu_to_le16(1);
-	ms_pkt->total_dsd_count = __constant_cpu_to_le16(2);
+	ms_pkt->cmd_dsd_count = cpu_to_le16(1);
+	ms_pkt->total_dsd_count = cpu_to_le16(2);
 	ms_pkt->rsp_bytecount = cpu_to_le32(rsp_size);
 	ms_pkt->req_bytecount = cpu_to_le32(req_size);
 
@@ -70,10 +70,10 @@ qla24xx_prep_ms_iocb(scsi_qla_host_t *vha, uint32_t req_size, uint32_t rsp_size)
 
 	ct_pkt->entry_type = CT_IOCB_TYPE;
 	ct_pkt->entry_count = 1;
-	ct_pkt->nport_handle = __constant_cpu_to_le16(NPH_SNS);
+	ct_pkt->nport_handle = cpu_to_le16(NPH_SNS);
 	ct_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
-	ct_pkt->cmd_dsd_count = __constant_cpu_to_le16(1);
-	ct_pkt->rsp_dsd_count = __constant_cpu_to_le16(1);
+	ct_pkt->cmd_dsd_count = cpu_to_le16(1);
+	ct_pkt->rsp_dsd_count = cpu_to_le16(1);
 	ct_pkt->rsp_byte_count = cpu_to_le32(rsp_size);
 	ct_pkt->cmd_byte_count = cpu_to_le32(req_size);
 
@@ -134,7 +134,7 @@ qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
 		case CS_DATA_UNDERRUN:
 		case CS_DATA_OVERRUN:		/* Overrun? */
 			if (ct_rsp->header.response !=
-			    __constant_cpu_to_be16(CT_ACCEPT_RESPONSE)) {
+			    cpu_to_be16(CT_ACCEPT_RESPONSE)) {
 				DEBUG2_3(printk("scsi(%ld): %s failed, "
 				    "rejected request:\n", vha->host_no,
 				    routine));
@@ -1140,10 +1140,10 @@ qla2x00_prep_ms_fdmi_iocb(scsi_qla_host_t *vha, uint32_t req_size,
 	ms_pkt->entry_type = MS_IOCB_TYPE;
 	ms_pkt->entry_count = 1;
 	SET_TARGET_ID(ha, ms_pkt->loop_id, vha->mgmt_svr_loop_id);
-	ms_pkt->control_flags = __constant_cpu_to_le16(CF_READ | CF_HEAD_TAG);
+	ms_pkt->control_flags = cpu_to_le16(CF_READ | CF_HEAD_TAG);
 	ms_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
-	ms_pkt->cmd_dsd_count = __constant_cpu_to_le16(1);
-	ms_pkt->total_dsd_count = __constant_cpu_to_le16(2);
+	ms_pkt->cmd_dsd_count = cpu_to_le16(1);
+	ms_pkt->total_dsd_count = cpu_to_le16(2);
 	ms_pkt->rsp_bytecount = cpu_to_le32(rsp_size);
 	ms_pkt->req_bytecount = cpu_to_le32(req_size);
 
@@ -1180,8 +1180,8 @@ qla24xx_prep_ms_fdmi_iocb(scsi_qla_host_t *vha, uint32_t req_size,
 	ct_pkt->entry_count = 1;
 	ct_pkt->nport_handle = cpu_to_le16(vha->mgmt_svr_loop_id);
 	ct_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
-	ct_pkt->cmd_dsd_count = __constant_cpu_to_le16(1);
-	ct_pkt->rsp_dsd_count = __constant_cpu_to_le16(1);
+	ct_pkt->cmd_dsd_count = cpu_to_le16(1);
+	ct_pkt->rsp_dsd_count = cpu_to_le16(1);
 	ct_pkt->rsp_byte_count = cpu_to_le32(rsp_size);
 	ct_pkt->cmd_byte_count = cpu_to_le32(req_size);
 
@@ -1269,19 +1269,19 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 
 	/* Prepare FDMI command arguments -- attribute block, attributes. */
 	memcpy(ct_req->req.rhba.hba_identifier, vha->port_name, WWN_SIZE);
-	ct_req->req.rhba.entry_count = __constant_cpu_to_be32(1);
+	ct_req->req.rhba.entry_count = cpu_to_be32(1);
 	memcpy(ct_req->req.rhba.port_name, vha->port_name, WWN_SIZE);
 	size = 2 * WWN_SIZE + 4 + 4;
 
 	/* Attributes */
 	ct_req->req.rhba.attrs.count =
-	    __constant_cpu_to_be32(FDMI_HBA_ATTR_COUNT);
+	    cpu_to_be32(FDMI_HBA_ATTR_COUNT);
 	entries = ct_req->req.rhba.hba_identifier;
 
 	/* Nodename. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
-	eiter->type = __constant_cpu_to_be16(FDMI_HBA_NODE_NAME);
-	eiter->len = __constant_cpu_to_be16(4 + WWN_SIZE);
+	eiter->type = cpu_to_be16(FDMI_HBA_NODE_NAME);
+	eiter->len = cpu_to_be16(4 + WWN_SIZE);
 	memcpy(eiter->a.node_name, vha->node_name, WWN_SIZE);
 	size += 4 + WWN_SIZE;
 
@@ -1293,7 +1293,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 
 	/* Manufacturer. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
-	eiter->type = __constant_cpu_to_be16(FDMI_HBA_MANUFACTURER);
+	eiter->type = cpu_to_be16(FDMI_HBA_MANUFACTURER);
 	strcpy(eiter->a.manufacturer, "QLogic Corporation");
 	alen = strlen(eiter->a.manufacturer);
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
@@ -1305,7 +1305,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 
 	/* Serial number. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
-	eiter->type = __constant_cpu_to_be16(FDMI_HBA_SERIAL_NUMBER);
+	eiter->type = cpu_to_be16(FDMI_HBA_SERIAL_NUMBER);
 	sn = ((ha->serial0 & 0x1f) << 16) | (ha->serial2 << 8) | ha->serial1;
 	sprintf(eiter->a.serial_num, "%c%05d", 'A' + sn / 100000, sn % 100000);
 	alen = strlen(eiter->a.serial_num);
@@ -1318,7 +1318,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 
 	/* Model name. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
-	eiter->type = __constant_cpu_to_be16(FDMI_HBA_MODEL);
+	eiter->type = cpu_to_be16(FDMI_HBA_MODEL);
 	strcpy(eiter->a.model, ha->model_number);
 	alen = strlen(eiter->a.model);
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
@@ -1330,7 +1330,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 
 	/* Model description. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
-	eiter->type = __constant_cpu_to_be16(FDMI_HBA_MODEL_DESCRIPTION);
+	eiter->type = cpu_to_be16(FDMI_HBA_MODEL_DESCRIPTION);
 	if (ha->model_desc)
 		strncpy(eiter->a.model_desc, ha->model_desc, 80);
 	alen = strlen(eiter->a.model_desc);
@@ -1343,7 +1343,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 
 	/* Hardware version. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
-	eiter->type = __constant_cpu_to_be16(FDMI_HBA_HARDWARE_VERSION);
+	eiter->type = cpu_to_be16(FDMI_HBA_HARDWARE_VERSION);
 	strcpy(eiter->a.hw_version, ha->adapter_id);
 	alen = strlen(eiter->a.hw_version);
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
@@ -1355,7 +1355,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 
 	/* Driver version. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
-	eiter->type = __constant_cpu_to_be16(FDMI_HBA_DRIVER_VERSION);
+	eiter->type = cpu_to_be16(FDMI_HBA_DRIVER_VERSION);
 	strcpy(eiter->a.driver_version, qla2x00_version_str);
 	alen = strlen(eiter->a.driver_version);
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
@@ -1367,7 +1367,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 
 	/* Option ROM version. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
-	eiter->type = __constant_cpu_to_be16(FDMI_HBA_OPTION_ROM_VERSION);
+	eiter->type = cpu_to_be16(FDMI_HBA_OPTION_ROM_VERSION);
 	strcpy(eiter->a.orom_version, "0.00");
 	alen = strlen(eiter->a.orom_version);
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
@@ -1379,7 +1379,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 
 	/* Firmware version */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
-	eiter->type = __constant_cpu_to_be16(FDMI_HBA_FIRMWARE_VERSION);
+	eiter->type = cpu_to_be16(FDMI_HBA_FIRMWARE_VERSION);
 	ha->isp_ops->fw_version_str(vha, eiter->a.fw_version);
 	alen = strlen(eiter->a.fw_version);
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
@@ -1517,13 +1517,13 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 
 	/* Attributes */
 	ct_req->req.rpa.attrs.count =
-	    __constant_cpu_to_be32(FDMI_PORT_ATTR_COUNT - 1);
+	    cpu_to_be32(FDMI_PORT_ATTR_COUNT - 1);
 	entries = ct_req->req.rpa.port_name;
 
 	/* FC4 types. */
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
-	eiter->type = __constant_cpu_to_be16(FDMI_PORT_FC4_TYPES);
-	eiter->len = __constant_cpu_to_be16(4 + 32);
+	eiter->type = cpu_to_be16(FDMI_PORT_FC4_TYPES);
+	eiter->len = cpu_to_be16(4 + 32);
 	eiter->a.fc4_types[2] = 0x01;
 	size += 4 + 32;
 
@@ -1533,24 +1533,24 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 
 	/* Supported speed. */
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
-	eiter->type = __constant_cpu_to_be16(FDMI_PORT_SUPPORT_SPEED);
-	eiter->len = __constant_cpu_to_be16(4 + 4);
+	eiter->type = cpu_to_be16(FDMI_PORT_SUPPORT_SPEED);
+	eiter->len = cpu_to_be16(4 + 4);
 	if (IS_QLA81XX(ha))
-		eiter->a.sup_speed = __constant_cpu_to_be32(
+		eiter->a.sup_speed = cpu_to_be32(
 		    FDMI_PORT_SPEED_10GB);
 	else if (IS_QLA25XX(ha))
-		eiter->a.sup_speed = __constant_cpu_to_be32(
+		eiter->a.sup_speed = cpu_to_be32(
 		    FDMI_PORT_SPEED_1GB|FDMI_PORT_SPEED_2GB|
 		    FDMI_PORT_SPEED_4GB|FDMI_PORT_SPEED_8GB);
 	else if (IS_QLA24XX_TYPE(ha))
-		eiter->a.sup_speed = __constant_cpu_to_be32(
+		eiter->a.sup_speed = cpu_to_be32(
 		    FDMI_PORT_SPEED_1GB|FDMI_PORT_SPEED_2GB|
 		    FDMI_PORT_SPEED_4GB);
 	else if (IS_QLA23XX(ha))
-		eiter->a.sup_speed =__constant_cpu_to_be32(
+		eiter->a.sup_speed =cpu_to_be32(
 		    FDMI_PORT_SPEED_1GB|FDMI_PORT_SPEED_2GB);
 	else
-		eiter->a.sup_speed = __constant_cpu_to_be32(
+		eiter->a.sup_speed = cpu_to_be32(
 		    FDMI_PORT_SPEED_1GB);
 	size += 4 + 4;
 
@@ -1559,32 +1559,32 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 
 	/* Current speed. */
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
-	eiter->type = __constant_cpu_to_be16(FDMI_PORT_CURRENT_SPEED);
-	eiter->len = __constant_cpu_to_be16(4 + 4);
+	eiter->type = cpu_to_be16(FDMI_PORT_CURRENT_SPEED);
+	eiter->len = cpu_to_be16(4 + 4);
 	switch (ha->link_data_rate) {
 	case PORT_SPEED_1GB:
 		eiter->a.cur_speed =
-		    __constant_cpu_to_be32(FDMI_PORT_SPEED_1GB);
+		    cpu_to_be32(FDMI_PORT_SPEED_1GB);
 		break;
 	case PORT_SPEED_2GB:
 		eiter->a.cur_speed =
-		    __constant_cpu_to_be32(FDMI_PORT_SPEED_2GB);
+		    cpu_to_be32(FDMI_PORT_SPEED_2GB);
 		break;
 	case PORT_SPEED_4GB:
 		eiter->a.cur_speed =
-		    __constant_cpu_to_be32(FDMI_PORT_SPEED_4GB);
+		    cpu_to_be32(FDMI_PORT_SPEED_4GB);
 		break;
 	case PORT_SPEED_8GB:
 		eiter->a.cur_speed =
-		    __constant_cpu_to_be32(FDMI_PORT_SPEED_8GB);
+		    cpu_to_be32(FDMI_PORT_SPEED_8GB);
 		break;
 	case PORT_SPEED_10GB:
 		eiter->a.cur_speed =
-		    __constant_cpu_to_be32(FDMI_PORT_SPEED_10GB);
+		    cpu_to_be32(FDMI_PORT_SPEED_10GB);
 		break;
 	default:
 		eiter->a.cur_speed =
-		    __constant_cpu_to_be32(FDMI_PORT_SPEED_UNKNOWN);
+		    cpu_to_be32(FDMI_PORT_SPEED_UNKNOWN);
 		break;
 	}
 	size += 4 + 4;
@@ -1594,8 +1594,8 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 
 	/* Max frame size. */
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
-	eiter->type = __constant_cpu_to_be16(FDMI_PORT_MAX_FRAME_SIZE);
-	eiter->len = __constant_cpu_to_be16(4 + 4);
+	eiter->type = cpu_to_be16(FDMI_PORT_MAX_FRAME_SIZE);
+	eiter->len = cpu_to_be16(4 + 4);
 	max_frame_size = IS_FWI2_CAPABLE(ha) ?
 	    le16_to_cpu(icb24->frame_payload_size):
 	    le16_to_cpu(ha->init_cb->frame_payload_size);
@@ -1607,7 +1607,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 
 	/* OS device name. */
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
-	eiter->type = __constant_cpu_to_be16(FDMI_PORT_OS_DEVICE_NAME);
+	eiter->type = cpu_to_be16(FDMI_PORT_OS_DEVICE_NAME);
 	strcpy(eiter->a.os_dev_name, QLA2XXX_DRIVER_NAME);
 	alen = strlen(eiter->a.os_dev_name);
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
@@ -1620,9 +1620,9 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 	/* Hostname. */
 	if (strlen(fc_host_system_hostname(vha->host))) {
 		ct_req->req.rpa.attrs.count =
-		    __constant_cpu_to_be32(FDMI_PORT_ATTR_COUNT);
+		    cpu_to_be32(FDMI_PORT_ATTR_COUNT);
 		eiter = (struct ct_fdmi_port_attr *) (entries + size);
-		eiter->type = __constant_cpu_to_be16(FDMI_PORT_HOST_NAME);
+		eiter->type = cpu_to_be16(FDMI_PORT_HOST_NAME);
 		snprintf(eiter->a.host_name, sizeof(eiter->a.host_name),
 		    "%s", fc_host_system_hostname(vha->host));
 		alen = strlen(eiter->a.host_name);
@@ -1770,8 +1770,8 @@ qla24xx_prep_ms_fm_iocb(scsi_qla_host_t *vha, uint32_t req_size,
 	ct_pkt->entry_count = 1;
 	ct_pkt->nport_handle = cpu_to_le16(vha->mgmt_svr_loop_id);
 	ct_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
-	ct_pkt->cmd_dsd_count = __constant_cpu_to_le16(1);
-	ct_pkt->rsp_dsd_count = __constant_cpu_to_le16(1);
+	ct_pkt->cmd_dsd_count = cpu_to_le16(1);
+	ct_pkt->rsp_dsd_count = cpu_to_le16(1);
 	ct_pkt->rsp_byte_count = cpu_to_le32(rsp_size);
 	ct_pkt->cmd_byte_count = cpu_to_le32(req_size);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f6368a1..fd568ad 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -878,7 +878,7 @@ cont_alloc:
 	ha->fw_dump->signature[1] = 'L';
 	ha->fw_dump->signature[2] = 'G';
 	ha->fw_dump->signature[3] = 'C';
-	ha->fw_dump->version = __constant_htonl(1);
+	ha->fw_dump->version = cpu_to_be32(1);
 
 	ha->fw_dump->fixed_size = htonl(fixed_size);
 	ha->fw_dump->mem_size = htonl(mem_size);
@@ -1169,8 +1169,8 @@ qla2x00_config_rings(struct scsi_qla_host *vha)
 	struct rsp_que *rsp = ha->rsp_q_map[0];
 
 	/* Setup ring parameters in initialization control block. */
-	ha->init_cb->request_q_outpointer = __constant_cpu_to_le16(0);
-	ha->init_cb->response_q_inpointer = __constant_cpu_to_le16(0);
+	ha->init_cb->request_q_outpointer = cpu_to_le16(0);
+	ha->init_cb->response_q_inpointer = cpu_to_le16(0);
 	ha->init_cb->request_q_length = cpu_to_le16(req->length);
 	ha->init_cb->response_q_length = cpu_to_le16(rsp->length);
 	ha->init_cb->request_q_address[0] = cpu_to_le32(LSD(req->dma));
@@ -1199,8 +1199,8 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 
 /* Setup ring parameters in initialization control block. */
 	icb = (struct init_cb_24xx *)ha->init_cb;
-	icb->request_q_outpointer = __constant_cpu_to_le16(0);
-	icb->response_q_inpointer = __constant_cpu_to_le16(0);
+	icb->request_q_outpointer = cpu_to_le16(0);
+	icb->response_q_inpointer = cpu_to_le16(0);
 	icb->request_q_length = cpu_to_le16(req->length);
 	icb->response_q_length = cpu_to_le16(rsp->length);
 	icb->request_q_address[0] = cpu_to_le32(LSD(req->dma));
@@ -1209,8 +1209,8 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 	icb->response_q_address[1] = cpu_to_le32(MSD(rsp->dma));
 
 	if (ha->mqenable) {
-		icb->qos = __constant_cpu_to_le16(QLA_DEFAULT_QUE_QOS);
-		icb->rid = __constant_cpu_to_le16(rid);
+		icb->qos = cpu_to_le16(QLA_DEFAULT_QUE_QOS);
+		icb->rid = cpu_to_le16(rid);
 		if (ha->flags.msix_enabled) {
 			msix = &ha->msix_entries[1];
 			DEBUG2_17(printk(KERN_INFO
@@ -1220,14 +1220,14 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 		/* Use alternate PCI bus number */
 		if (MSB(rid))
 			icb->firmware_options_2 |=
-				__constant_cpu_to_le32(BIT_19);
+				cpu_to_le32(BIT_19);
 		/* Use alternate PCI devfn */
 		if (LSB(rid))
 			icb->firmware_options_2 |=
-				__constant_cpu_to_le32(BIT_18);
+				cpu_to_le32(BIT_18);
 
-		icb->firmware_options_2 |= __constant_cpu_to_le32(BIT_22);
-		icb->firmware_options_2 |= __constant_cpu_to_le32(BIT_23);
+		icb->firmware_options_2 |= cpu_to_le32(BIT_22);
+		icb->firmware_options_2 |= cpu_to_le32(BIT_23);
 		ha->rsp_q_map[0]->options = icb->firmware_options_2;
 
 		WRT_REG_DWORD(&reg->isp25mq.req_q_in, 0);
@@ -1312,7 +1312,7 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 	if (ha->flags.npiv_supported)
 		mid_init_cb->count = cpu_to_le16(ha->max_npiv_vports);
 
-	mid_init_cb->options = __constant_cpu_to_le16(BIT_1);
+	mid_init_cb->options = cpu_to_le16(BIT_1);
 
 	rval = qla2x00_init_firmware(vha, ha->init_cb_size);
 	if (rval) {
@@ -1694,22 +1694,22 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 			nv->firmware_options[1] = BIT_7 | BIT_5;
 			nv->add_firmware_options[0] = BIT_5;
 			nv->add_firmware_options[1] = BIT_5 | BIT_4;
-			nv->frame_payload_size = __constant_cpu_to_le16(2048);
+			nv->frame_payload_size = cpu_to_le16(2048);
 			nv->special_options[1] = BIT_7;
 		} else if (IS_QLA2200(ha)) {
 			nv->firmware_options[0] = BIT_2 | BIT_1;
 			nv->firmware_options[1] = BIT_7 | BIT_5;
 			nv->add_firmware_options[0] = BIT_5;
 			nv->add_firmware_options[1] = BIT_5 | BIT_4;
-			nv->frame_payload_size = __constant_cpu_to_le16(1024);
+			nv->frame_payload_size = cpu_to_le16(1024);
 		} else if (IS_QLA2100(ha)) {
 			nv->firmware_options[0] = BIT_3 | BIT_1;
 			nv->firmware_options[1] = BIT_5;
-			nv->frame_payload_size = __constant_cpu_to_le16(1024);
+			nv->frame_payload_size = cpu_to_le16(1024);
 		}
 
-		nv->max_iocb_allocation = __constant_cpu_to_le16(256);
-		nv->execution_throttle = __constant_cpu_to_le16(16);
+		nv->max_iocb_allocation = cpu_to_le16(256);
+		nv->execution_throttle = cpu_to_le16(16);
 		nv->retry_count = 8;
 		nv->retry_delay = 1;
 
@@ -1727,7 +1727,7 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 		nv->host_p[1] = BIT_2;
 		nv->reset_delay = 5;
 		nv->port_down_retry_count = 8;
-		nv->max_luns_per_target = __constant_cpu_to_le16(8);
+		nv->max_luns_per_target = cpu_to_le16(8);
 		nv->link_down_timeout = 60;
 
 		rval = 1;
@@ -1741,7 +1741,7 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 	 * are valid.
 	 */
 	if (ia64_platform_is("sn2")) {
-		nv->frame_payload_size = __constant_cpu_to_le16(2048);
+		nv->frame_payload_size = cpu_to_le16(2048);
 		if (IS_QLA23XX(ha))
 			nv->special_options[1] = BIT_7;
 	}
@@ -1849,7 +1849,7 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 	memcpy(vha->node_name, icb->node_name, WWN_SIZE);
 	memcpy(vha->port_name, icb->port_name, WWN_SIZE);
 
-	icb->execution_throttle = __constant_cpu_to_le16(0xFFFF);
+	icb->execution_throttle = cpu_to_le16(0xFFFF);
 
 	ha->retry_count = nv->retry_count;
 
@@ -1901,10 +1901,10 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 	if (ql2xloginretrycount)
 		ha->login_retry_count = ql2xloginretrycount;
 
-	icb->lun_enables = __constant_cpu_to_le16(0);
+	icb->lun_enables = cpu_to_le16(0);
 	icb->command_resource_count = 0;
 	icb->immediate_notify_resource_count = 0;
-	icb->timeout = __constant_cpu_to_le16(0);
+	icb->timeout = cpu_to_le16(0);
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
 		/* Enable RIO */
@@ -3634,7 +3634,7 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 	/* Bad NVRAM data, set defaults parameters. */
 	if (chksum || nv->id[0] != 'I' || nv->id[1] != 'S' || nv->id[2] != 'P'
 	    || nv->id[3] != ' ' ||
-	    nv->nvram_version < __constant_cpu_to_le16(ICB_VERSION)) {
+	    nv->nvram_version < cpu_to_le16(ICB_VERSION)) {
 		/* Reset NVRAM data. */
 		qla_printk(KERN_WARNING, ha, "Inconsistent NVRAM detected: "
 		    "checksum=0x%x id=%c version=0x%x.\n", chksum, nv->id[0],
@@ -3646,12 +3646,12 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 		 * Set default initialization control block.
 		 */
 		memset(nv, 0, ha->nvram_size);
-		nv->nvram_version = __constant_cpu_to_le16(ICB_VERSION);
-		nv->version = __constant_cpu_to_le16(ICB_VERSION);
-		nv->frame_payload_size = __constant_cpu_to_le16(2048);
-		nv->execution_throttle = __constant_cpu_to_le16(0xFFFF);
-		nv->exchange_count = __constant_cpu_to_le16(0);
-		nv->hard_address = __constant_cpu_to_le16(124);
+		nv->nvram_version = cpu_to_le16(ICB_VERSION);
+		nv->version = cpu_to_le16(ICB_VERSION);
+		nv->frame_payload_size = cpu_to_le16(2048);
+		nv->execution_throttle = cpu_to_le16(0xFFFF);
+		nv->exchange_count = cpu_to_le16(0);
+		nv->hard_address = cpu_to_le16(124);
 		nv->port_name[0] = 0x21;
 		nv->port_name[1] = 0x00 + PCI_FUNC(ha->pdev->devfn);
 		nv->port_name[2] = 0x00;
@@ -3669,20 +3669,20 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 		nv->node_name[6] = 0x55;
 		nv->node_name[7] = 0x86;
 		qla24xx_nvram_wwn_from_ofw(vha, nv);
-		nv->login_retry_count = __constant_cpu_to_le16(8);
-		nv->interrupt_delay_timer = __constant_cpu_to_le16(0);
-		nv->login_timeout = __constant_cpu_to_le16(0);
+		nv->login_retry_count = cpu_to_le16(8);
+		nv->interrupt_delay_timer = cpu_to_le16(0);
+		nv->login_timeout = cpu_to_le16(0);
 		nv->firmware_options_1 =
-		    __constant_cpu_to_le32(BIT_14|BIT_13|BIT_2|BIT_1);
-		nv->firmware_options_2 = __constant_cpu_to_le32(2 << 4);
-		nv->firmware_options_2 |= __constant_cpu_to_le32(BIT_12);
-		nv->firmware_options_3 = __constant_cpu_to_le32(2 << 13);
-		nv->host_p = __constant_cpu_to_le32(BIT_11|BIT_10);
-		nv->efi_parameters = __constant_cpu_to_le32(0);
+		    cpu_to_le32(BIT_14|BIT_13|BIT_2|BIT_1);
+		nv->firmware_options_2 = cpu_to_le32(2 << 4);
+		nv->firmware_options_2 |= cpu_to_le32(BIT_12);
+		nv->firmware_options_3 = cpu_to_le32(2 << 13);
+		nv->host_p = cpu_to_le32(BIT_11|BIT_10);
+		nv->efi_parameters = cpu_to_le32(0);
 		nv->reset_delay = 5;
-		nv->max_luns_per_target = __constant_cpu_to_le16(128);
-		nv->port_down_retry_count = __constant_cpu_to_le16(30);
-		nv->link_down_timeout = __constant_cpu_to_le16(30);
+		nv->max_luns_per_target = cpu_to_le16(128);
+		nv->port_down_retry_count = cpu_to_le16(30);
+		nv->link_down_timeout = cpu_to_le16(30);
 
 		rval = 1;
 	}
@@ -3715,13 +3715,13 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 	    "QLA2462");
 
 	/* Use alternate WWN? */
-	if (nv->host_p & __constant_cpu_to_le32(BIT_15)) {
+	if (nv->host_p & cpu_to_le32(BIT_15)) {
 		memcpy(icb->node_name, nv->alternate_node_name, WWN_SIZE);
 		memcpy(icb->port_name, nv->alternate_port_name, WWN_SIZE);
 	}
 
 	/* Prepare nodename */
-	if ((icb->firmware_options_1 & __constant_cpu_to_le32(BIT_14)) == 0) {
+	if ((icb->firmware_options_1 & cpu_to_le32(BIT_14)) == 0) {
 		/*
 		 * Firmware will apply the following mask if the nodename was
 		 * not provided.
@@ -3753,7 +3753,7 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 	memcpy(vha->node_name, icb->node_name, WWN_SIZE);
 	memcpy(vha->port_name, icb->port_name, WWN_SIZE);
 
-	icb->execution_throttle = __constant_cpu_to_le16(0xFFFF);
+	icb->execution_throttle = cpu_to_le16(0xFFFF);
 
 	ha->retry_count = le16_to_cpu(nv->login_retry_count);
 
@@ -3761,7 +3761,7 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 	if (le16_to_cpu(nv->login_timeout) < ql2xlogintimeout)
 		nv->login_timeout = cpu_to_le16(ql2xlogintimeout);
 	if (le16_to_cpu(nv->login_timeout) < 4)
-		nv->login_timeout = __constant_cpu_to_le16(4);
+		nv->login_timeout = cpu_to_le16(4);
 	ha->login_timeout = le16_to_cpu(nv->login_timeout);
 	icb->login_timeout = nv->login_timeout;
 
@@ -3812,7 +3812,7 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 		ha->zio_timer = le16_to_cpu(icb->interrupt_delay_timer) ?
 		    le16_to_cpu(icb->interrupt_delay_timer): 2;
 	}
-	icb->firmware_options_2 &= __constant_cpu_to_le32(
+	icb->firmware_options_2 &= cpu_to_le32(
 	    ~(BIT_3 | BIT_2 | BIT_1 | BIT_0));
 	vha->flags.process_response_queue = 0;
 	if (ha->zio_mode != QLA_ZIO_DISABLED) {
@@ -4358,7 +4358,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	/* Bad NVRAM data, set defaults parameters. */
 	if (chksum || nv->id[0] != 'I' || nv->id[1] != 'S' || nv->id[2] != 'P'
 	    || nv->id[3] != ' ' ||
-	    nv->nvram_version < __constant_cpu_to_le16(ICB_VERSION)) {
+	    nv->nvram_version < cpu_to_le16(ICB_VERSION)) {
 		/* Reset NVRAM data. */
 		qla_printk(KERN_WARNING, ha, "Inconsistent NVRAM detected: "
 		    "checksum=0x%x id=%c version=0x%x.\n", chksum, nv->id[0],
@@ -4370,11 +4370,11 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 		 * Set default initialization control block.
 		 */
 		memset(nv, 0, ha->nvram_size);
-		nv->nvram_version = __constant_cpu_to_le16(ICB_VERSION);
-		nv->version = __constant_cpu_to_le16(ICB_VERSION);
-		nv->frame_payload_size = __constant_cpu_to_le16(2048);
-		nv->execution_throttle = __constant_cpu_to_le16(0xFFFF);
-		nv->exchange_count = __constant_cpu_to_le16(0);
+		nv->nvram_version = cpu_to_le16(ICB_VERSION);
+		nv->version = cpu_to_le16(ICB_VERSION);
+		nv->frame_payload_size = cpu_to_le16(2048);
+		nv->execution_throttle = cpu_to_le16(0xFFFF);
+		nv->exchange_count = cpu_to_le16(0);
 		nv->port_name[0] = 0x21;
 		nv->port_name[1] = 0x00 + PCI_FUNC(ha->pdev->devfn);
 		nv->port_name[2] = 0x00;
@@ -4391,20 +4391,20 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 		nv->node_name[5] = 0x1c;
 		nv->node_name[6] = 0x55;
 		nv->node_name[7] = 0x86;
-		nv->login_retry_count = __constant_cpu_to_le16(8);
-		nv->interrupt_delay_timer = __constant_cpu_to_le16(0);
-		nv->login_timeout = __constant_cpu_to_le16(0);
+		nv->login_retry_count = cpu_to_le16(8);
+		nv->interrupt_delay_timer = cpu_to_le16(0);
+		nv->login_timeout = cpu_to_le16(0);
 		nv->firmware_options_1 =
-		    __constant_cpu_to_le32(BIT_14|BIT_13|BIT_2|BIT_1);
-		nv->firmware_options_2 = __constant_cpu_to_le32(2 << 4);
-		nv->firmware_options_2 |= __constant_cpu_to_le32(BIT_12);
-		nv->firmware_options_3 = __constant_cpu_to_le32(2 << 13);
-		nv->host_p = __constant_cpu_to_le32(BIT_11|BIT_10);
-		nv->efi_parameters = __constant_cpu_to_le32(0);
+		    cpu_to_le32(BIT_14|BIT_13|BIT_2|BIT_1);
+		nv->firmware_options_2 = cpu_to_le32(2 << 4);
+		nv->firmware_options_2 |= cpu_to_le32(BIT_12);
+		nv->firmware_options_3 = cpu_to_le32(2 << 13);
+		nv->host_p = cpu_to_le32(BIT_11|BIT_10);
+		nv->efi_parameters = cpu_to_le32(0);
 		nv->reset_delay = 5;
-		nv->max_luns_per_target = __constant_cpu_to_le16(128);
-		nv->port_down_retry_count = __constant_cpu_to_le16(30);
-		nv->link_down_timeout = __constant_cpu_to_le16(30);
+		nv->max_luns_per_target = cpu_to_le16(128);
+		nv->port_down_retry_count = cpu_to_le16(30);
+		nv->link_down_timeout = cpu_to_le16(30);
 		nv->enode_mac[0] = 0x01;
 		nv->enode_mac[1] = 0x02;
 		nv->enode_mac[2] = 0x03;
@@ -4453,13 +4453,13 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	    "QLE81XX");
 
 	/* Use alternate WWN? */
-	if (nv->host_p & __constant_cpu_to_le32(BIT_15)) {
+	if (nv->host_p & cpu_to_le32(BIT_15)) {
 		memcpy(icb->node_name, nv->alternate_node_name, WWN_SIZE);
 		memcpy(icb->port_name, nv->alternate_port_name, WWN_SIZE);
 	}
 
 	/* Prepare nodename */
-	if ((icb->firmware_options_1 & __constant_cpu_to_le32(BIT_14)) == 0) {
+	if ((icb->firmware_options_1 & cpu_to_le32(BIT_14)) == 0) {
 		/*
 		 * Firmware will apply the following mask if the nodename was
 		 * not provided.
@@ -4488,7 +4488,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	memcpy(vha->node_name, icb->node_name, WWN_SIZE);
 	memcpy(vha->port_name, icb->port_name, WWN_SIZE);
 
-	icb->execution_throttle = __constant_cpu_to_le16(0xFFFF);
+	icb->execution_throttle = cpu_to_le16(0xFFFF);
 
 	ha->retry_count = le16_to_cpu(nv->login_retry_count);
 
@@ -4496,7 +4496,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	if (le16_to_cpu(nv->login_timeout) < ql2xlogintimeout)
 		nv->login_timeout = cpu_to_le16(ql2xlogintimeout);
 	if (le16_to_cpu(nv->login_timeout) < 4)
-		nv->login_timeout = __constant_cpu_to_le16(4);
+		nv->login_timeout = cpu_to_le16(4);
 	ha->login_timeout = le16_to_cpu(nv->login_timeout);
 	icb->login_timeout = nv->login_timeout;
 
@@ -4547,7 +4547,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 		ha->zio_timer = le16_to_cpu(icb->interrupt_delay_timer) ?
 		    le16_to_cpu(icb->interrupt_delay_timer): 2;
 	}
-	icb->firmware_options_2 &= __constant_cpu_to_le32(
+	icb->firmware_options_2 &= cpu_to_le32(
 	    ~(BIT_3 | BIT_2 | BIT_1 | BIT_0));
 	vha->flags.process_response_queue = 0;
 	if (ha->zio_mode != QLA_ZIO_DISABLED) {
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 2258152..8df3d04 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -108,7 +108,7 @@ qla2x00_prep_cont_type0_iocb(struct req_que *req, struct scsi_qla_host *vha)
 
 	/* Load packet defaults. */
 	*((uint32_t *)(&cont_pkt->entry_type)) =
-	    __constant_cpu_to_le32(CONTINUE_TYPE);
+	    cpu_to_le32(CONTINUE_TYPE);
 
 	return (cont_pkt);
 }
@@ -137,7 +137,7 @@ qla2x00_prep_cont_type1_iocb(struct req_que *req, scsi_qla_host_t *vha)
 
 	/* Load packet defaults. */
 	*((uint32_t *)(&cont_pkt->entry_type)) =
-	    __constant_cpu_to_le32(CONTINUE_A64_TYPE);
+	    cpu_to_le32(CONTINUE_A64_TYPE);
 
 	return (cont_pkt);
 }
@@ -165,11 +165,11 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp, cmd_entry_t *cmd_pkt,
 
 	/* Update entry type to indicate Command Type 2 IOCB */
 	*((uint32_t *)(&cmd_pkt->entry_type)) =
-	    __constant_cpu_to_le32(COMMAND_TYPE);
+	    cpu_to_le32(COMMAND_TYPE);
 
 	/* No data transfer */
 	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE) {
-		cmd_pkt->byte_count = __constant_cpu_to_le32(0);
+		cmd_pkt->byte_count = cpu_to_le32(0);
 		return;
 	}
 
@@ -226,11 +226,11 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 
 	/* Update entry type to indicate Command Type 3 IOCB */
 	*((uint32_t *)(&cmd_pkt->entry_type)) =
-	    __constant_cpu_to_le32(COMMAND_A64_TYPE);
+	    cpu_to_le32(COMMAND_A64_TYPE);
 
 	/* No data transfer */
 	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE) {
-		cmd_pkt->byte_count = __constant_cpu_to_le32(0);
+		cmd_pkt->byte_count = cpu_to_le32(0);
 		return;
 	}
 
@@ -369,7 +369,7 @@ qla2x00_start_scsi(srb_t *sp)
 	cmd_pkt->lun = cpu_to_le16(sp->cmd->device->lun);
 
 	/* Update tagged queuing modifier */
-	cmd_pkt->control_flags = __constant_cpu_to_le16(CF_SIMPLE_TAG);
+	cmd_pkt->control_flags = cpu_to_le16(CF_SIMPLE_TAG);
 
 	/* Load SCSI command packet. */
 	memcpy(cmd_pkt->scsi_cdb, cmd->cmnd, cmd->cmd_len);
@@ -647,11 +647,11 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 
 	/* Update entry type to indicate Command Type 3 IOCB */
 	*((uint32_t *)(&cmd_pkt->entry_type)) =
-	    __constant_cpu_to_le32(COMMAND_TYPE_7);
+	    cpu_to_le32(COMMAND_TYPE_7);
 
 	/* No data transfer */
 	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE) {
-		cmd_pkt->byte_count = __constant_cpu_to_le32(0);
+		cmd_pkt->byte_count = cpu_to_le32(0);
 		return;
 	}
 
@@ -661,12 +661,12 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 	/* Set transfer direction */
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
 		cmd_pkt->task_mgmt_flags =
-		    __constant_cpu_to_le16(TMF_WRITE_DATA);
+		    cpu_to_le16(TMF_WRITE_DATA);
 		sp->fcport->vha->hw->qla_stats.output_bytes +=
 		    scsi_bufflen(sp->cmd);
 	} else if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
 		cmd_pkt->task_mgmt_flags =
-		    __constant_cpu_to_le16(TMF_READ_DATA);
+		    cpu_to_le16(TMF_READ_DATA);
 		sp->fcport->vha->hw->qla_stats.input_bytes +=
 		    scsi_bufflen(sp->cmd);
 	}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e28ad81..d0d5f12 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1722,9 +1722,9 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
 
 	msix_disabled_hccr = rsp->options;
 	if (!rsp->id)
-		msix_disabled_hccr &= __constant_cpu_to_le32(BIT_22);
+		msix_disabled_hccr &= cpu_to_le32(BIT_22);
 	else
-		msix_disabled_hccr &= __constant_cpu_to_le32(BIT_6);
+		msix_disabled_hccr &= cpu_to_le32(BIT_6);
 
 	qla24xx_process_response_queue(rsp);
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index f94ffbb..60175ca 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1485,11 +1485,11 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	lg->entry_type = LOGINOUT_PORT_IOCB_TYPE;
 	lg->entry_count = 1;
 	lg->nport_handle = cpu_to_le16(loop_id);
-	lg->control_flags = __constant_cpu_to_le16(LCF_COMMAND_PLOGI);
+	lg->control_flags = cpu_to_le16(LCF_COMMAND_PLOGI);
 	if (opt & BIT_0)
-		lg->control_flags |= __constant_cpu_to_le16(LCF_COND_PLOGI);
+		lg->control_flags |= cpu_to_le16(LCF_COND_PLOGI);
 	if (opt & BIT_1)
-		lg->control_flags |= __constant_cpu_to_le16(LCF_SKIP_PRLI);
+		lg->control_flags |= cpu_to_le16(LCF_SKIP_PRLI);
 	lg->port_id[0] = al_pa;
 	lg->port_id[1] = area;
 	lg->port_id[2] = domain;
@@ -1503,7 +1503,7 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 		    "-- error status (%x).\n", __func__, vha->host_no,
 		    lg->entry_status));
 		rval = QLA_FUNCTION_FAILED;
-	} else if (lg->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
+	} else if (lg->comp_status != cpu_to_le16(CS_COMPLETE)) {
 		iop[0] = le32_to_cpu(lg->io_parameter[0]);
 		iop[1] = le32_to_cpu(lg->io_parameter[1]);
 
@@ -1747,7 +1747,7 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	lg->entry_count = 1;
 	lg->nport_handle = cpu_to_le16(loop_id);
 	lg->control_flags =
-	    __constant_cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO);
+	    cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO);
 	lg->port_id[0] = al_pa;
 	lg->port_id[1] = area;
 	lg->port_id[2] = domain;
@@ -1762,7 +1762,7 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 		    "-- error status (%x).\n", __func__, vha->host_no,
 		    lg->entry_status));
 		rval = QLA_FUNCTION_FAILED;
-	} else if (lg->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
+	} else if (lg->comp_status != cpu_to_le16(CS_COMPLETE)) {
 		DEBUG2_3_11(printk("%s(%ld %d): failed to complete IOCB "
 		    "-- completion status (%x)  ioparam=%x/%x.\n", __func__,
 		    vha->host_no, vha->vp_idx, le16_to_cpu(lg->comp_status),
@@ -2240,7 +2240,7 @@ qla24xx_abort_command(scsi_qla_host_t *vha, srb_t *sp, struct req_que *req)
 		    "-- error status (%x).\n", __func__, vha->host_no,
 		    abt->entry_status));
 		rval = QLA_FUNCTION_FAILED;
-	} else if (abt->nport_handle != __constant_cpu_to_le16(0)) {
+	} else if (abt->nport_handle != cpu_to_le16(0)) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
 		    "-- completion status (%x).\n", __func__, vha->host_no,
 		    le16_to_cpu(abt->nport_handle)));
@@ -2312,7 +2312,7 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 		    tsk->p.sts.entry_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else if (tsk->p.sts.comp_status !=
-	    __constant_cpu_to_le16(CS_COMPLETE)) {
+	    cpu_to_le16(CS_COMPLETE)) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
 		    "-- completion status (%x).\n", __func__,
 		    vha->host_no, le16_to_cpu(tsk->p.sts.comp_status)));
@@ -2782,7 +2782,7 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 			"-- error status (%x).\n", __func__, base_vha->host_no,
 			vpmod->comp_status));
 		rval = QLA_FUNCTION_FAILED;
-	} else if (vpmod->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
+	} else if (vpmod->comp_status != cpu_to_le16(CS_COMPLETE)) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
 		    "-- completion status (%x).\n", __func__, base_vha->host_no,
 		    le16_to_cpu(vpmod->comp_status)));
@@ -2842,7 +2842,7 @@ qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	vce->entry_type = VP_CTRL_IOCB_TYPE;
 	vce->entry_count = 1;
 	vce->command = cpu_to_le16(cmd);
-	vce->vp_count = __constant_cpu_to_le16(1);
+	vce->vp_count = cpu_to_le16(1);
 
 	/* index map in firmware starts with 1; decrement index
 	 * this is ok as we never use index 0
@@ -2867,7 +2867,7 @@ qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 		    "-- error status (%x).\n", __func__, base_vha->host_no,
 		    vce->entry_status);
 		rval = QLA_FUNCTION_FAILED;
-	} else if (vce->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
+	} else if (vce->comp_status != cpu_to_le16(CS_COMPLETE)) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
 		    "-- completion status (%x).\n", __func__, base_vha->host_no,
 		    le16_to_cpu(vce->comp_status)));
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 9c3b694..1dc9956 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -313,7 +313,7 @@ qla2x00_clear_nvram_protection(struct qla_hw_data *ha)
 
 	wprot_old = cpu_to_le16(qla2x00_get_nvram_word(ha, ha->nvram_base));
 	stat = qla2x00_write_nvram_word_tmo(ha, ha->nvram_base,
-	    __constant_cpu_to_le16(0x1234), 100000);
+	    cpu_to_le16(0x1234), 100000);
 	wprot = cpu_to_le16(qla2x00_get_nvram_word(ha, ha->nvram_base));
 	if (stat != QLA_SUCCESS || wprot != 0x1234) {
 		/* Write enable. */
@@ -653,9 +653,9 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 	region = (struct qla_flt_region *)&flt[1];
 	ha->isp_ops->read_optrom(vha, (uint8_t *)req->ring,
 	    flt_addr << 2, OPTROM_BURST_SIZE);
-	if (*wptr == __constant_cpu_to_le16(0xffff))
+	if (*wptr == cpu_to_le16(0xffff))
 		goto no_flash_data;
-	if (flt->version != __constant_cpu_to_le16(1)) {
+	if (flt->version != cpu_to_le16(1)) {
 		DEBUG2(qla_printk(KERN_INFO, ha, "Unsupported FLT detected: "
 		    "version=0x%x length=0x%x checksum=0x%x.\n",
 		    le16_to_cpu(flt->version), le16_to_cpu(flt->length),
@@ -751,7 +751,7 @@ qla2xxx_get_fdt_info(scsi_qla_host_t *vha)
 	fdt = (struct qla_fdt_layout *)req->ring;
 	ha->isp_ops->read_optrom(vha, (uint8_t *)req->ring,
 	    ha->flt_region_fdt << 2, OPTROM_BURST_SIZE);
-	if (*wptr == __constant_cpu_to_le16(0xffff))
+	if (*wptr == cpu_to_le16(0xffff))
 		goto no_flash_data;
 	if (fdt->sig[0] != 'Q' || fdt->sig[1] != 'L' || fdt->sig[2] != 'I' ||
 	    fdt->sig[3] != 'D')
@@ -858,9 +858,9 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *vha)
 
 	ha->isp_ops->read_optrom(vha, (uint8_t *)&hdr,
 	    ha->flt_region_npiv_conf << 2, sizeof(struct qla_npiv_header));
-	if (hdr.version == __constant_cpu_to_le16(0xffff))
+	if (hdr.version == cpu_to_le16(0xffff))
 		return;
-	if (hdr.version != __constant_cpu_to_le16(1)) {
+	if (hdr.version != cpu_to_le16(1)) {
 		DEBUG2(qla_printk(KERN_INFO, ha, "Unsupported NPIV-Config "
 		    "detected: version=0x%x entries=0x%x checksum=0x%x.\n",
 		    le16_to_cpu(hdr.version), le16_to_cpu(hdr.entries),
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index af8c323..5755588 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -115,8 +115,8 @@ int qla4xxx_init_rings(struct scsi_qla_host *ha)
 	 * registers aren't cleared-- causing the interrupt_handler to think
 	 * there are responses to be processed when there aren't.
 	 */
-	ha->shadow_regs->req_q_out = __constant_cpu_to_le32(0);
-	ha->shadow_regs->rsp_q_in = __constant_cpu_to_le32(0);
+	ha->shadow_regs->req_q_out = cpu_to_le32(0);
+	ha->shadow_regs->rsp_q_in = cpu_to_le32(0);
 	wmb();
 
 	writel(0, &ha->reg->req_q_in);
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index 912a674..41bf1b4 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -153,7 +153,7 @@ static void qla4xxx_build_scsi_iocbs(struct srb *srb,
 
 	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE) {
 		/* No data being transferred */
-		cmd_entry->ttlByteCnt = __constant_cpu_to_le32(0);
+		cmd_entry->ttlByteCnt = cpu_to_le32(0);
 		return;
 	}
 
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 051b0f5..9209ab4 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -217,8 +217,8 @@ int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha)
 	/* Fill in the request and response queue information. */
 	init_fw_cb->pri.rqq_consumer_idx = cpu_to_le16(ha->request_out);
 	init_fw_cb->pri.compq_producer_idx = cpu_to_le16(ha->response_in);
-	init_fw_cb->pri.rqq_len = __constant_cpu_to_le16(REQUEST_QUEUE_DEPTH);
-	init_fw_cb->pri.compq_len = __constant_cpu_to_le16(RESPONSE_QUEUE_DEPTH);
+	init_fw_cb->pri.rqq_len = cpu_to_le16(REQUEST_QUEUE_DEPTH);
+	init_fw_cb->pri.compq_len = cpu_to_le16(RESPONSE_QUEUE_DEPTH);
 	init_fw_cb->pri.rqq_addr_lo = cpu_to_le32(LSDW(ha->request_dma));
 	init_fw_cb->pri.rqq_addr_hi = cpu_to_le32(MSDW(ha->request_dma));
 	init_fw_cb->pri.compq_addr_lo = cpu_to_le32(LSDW(ha->response_dma));
@@ -230,9 +230,9 @@ int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha)
 
 	/* Set up required options. */
 	init_fw_cb->pri.fw_options |=
-		__constant_cpu_to_le16(FWOPT_SESSION_MODE |
+		cpu_to_le16(FWOPT_SESSION_MODE |
 				       FWOPT_INITIATOR_MODE);
-	init_fw_cb->pri.fw_options &= __constant_cpu_to_le16(~FWOPT_TARGET_MODE);
+	init_fw_cb->pri.fw_options &= cpu_to_le16(~FWOPT_TARGET_MODE);
 
 	/* Save some info in adapter structure. */
 	ha->firmware_options = le16_to_cpu(init_fw_cb->pri.fw_options);
-- 
1.6.1.401.gf39d5



