From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 05/10] qla2xxx: Remove __constant_ prefix
Date: Tue, 27 Jan 2015 10:33:42 +0100
Message-ID: <54C75B76.30105@sandisk.com>
References: <54C75AF8.90102@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0079.outbound.protection.outlook.com ([65.55.169.79]:20538
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757971AbbA0Jdv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2015 04:33:51 -0500
In-Reply-To: <54C75AF8.90102@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Whether htonl() or __constant_htonl() is used, if the argument
is a constant the conversion happens at compile time. Hence leave
out the __constant_ prefix for this and other endianness
conversion functions. This improves source code readability.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c    |  36 +++++-----
 drivers/scsi/qla2xxx/qla_gs.c     |  52 +++++++-------
 drivers/scsi/qla2xxx/qla_init.c   | 143 ++++++++++++++++++--------------------
 drivers/scsi/qla2xxx/qla_iocb.c   |  88 ++++++++++-------------
 drivers/scsi/qla2xxx/qla_isr.c    |   2 +-
 drivers/scsi/qla2xxx/qla_mbx.c    |  25 ++++---
 drivers/scsi/qla2xxx/qla_mr.c     |   2 +-
 drivers/scsi/qla2xxx/qla_nx.c     |   6 +-
 drivers/scsi/qla2xxx/qla_sup.c    |  14 ++--
 drivers/scsi/qla2xxx/qla_target.c | 116 +++++++++++++++----------------
 10 files changed, 231 insertions(+), 253 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index ab2d5f4..cdfa3c2 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -486,7 +486,7 @@ qla25xx_copy_fce(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 		return ptr;
 
 	*last_chain = &fcec->type;
-	fcec->type = __constant_htonl(DUMP_CHAIN_FCE);
+	fcec->type = htonl(DUMP_CHAIN_FCE);
 	fcec->chain_size = htonl(sizeof(struct qla2xxx_fce_chain) +
 	    fce_calc_size(ha->fce_bufs));
 	fcec->size = htonl(fce_calc_size(ha->fce_bufs));
@@ -527,7 +527,7 @@ qla2xxx_copy_atioqueues(struct qla_hw_data *ha, void *ptr,
 		/* aqp = ha->atio_q_map[que]; */
 		q = ptr;
 		*last_chain = &q->type;
-		q->type = __constant_htonl(DUMP_CHAIN_QUEUE);
+		q->type = htonl(DUMP_CHAIN_QUEUE);
 		q->chain_size = htonl(
 		    sizeof(struct qla2xxx_mqueue_chain) +
 		    sizeof(struct qla2xxx_mqueue_header) +
@@ -536,7 +536,7 @@ qla2xxx_copy_atioqueues(struct qla_hw_data *ha, void *ptr,
 
 		/* Add header. */
 		qh = ptr;
-		qh->queue = __constant_htonl(TYPE_ATIO_QUEUE);
+		qh->queue = htonl(TYPE_ATIO_QUEUE);
 		qh->number = htonl(que);
 		qh->size = htonl(aqp->length * sizeof(request_t));
 		ptr += sizeof(struct qla2xxx_mqueue_header);
@@ -571,7 +571,7 @@ qla25xx_copy_mqueues(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 		/* Add chain. */
 		q = ptr;
 		*last_chain = &q->type;
-		q->type = __constant_htonl(DUMP_CHAIN_QUEUE);
+		q->type = htonl(DUMP_CHAIN_QUEUE);
 		q->chain_size = htonl(
 		    sizeof(struct qla2xxx_mqueue_chain) +
 		    sizeof(struct qla2xxx_mqueue_header) +
@@ -580,7 +580,7 @@ qla25xx_copy_mqueues(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 
 		/* Add header. */
 		qh = ptr;
-		qh->queue = __constant_htonl(TYPE_REQUEST_QUEUE);
+		qh->queue = htonl(TYPE_REQUEST_QUEUE);
 		qh->number = htonl(que);
 		qh->size = htonl(req->length * sizeof(request_t));
 		ptr += sizeof(struct qla2xxx_mqueue_header);
@@ -599,7 +599,7 @@ qla25xx_copy_mqueues(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 		/* Add chain. */
 		q = ptr;
 		*last_chain = &q->type;
-		q->type = __constant_htonl(DUMP_CHAIN_QUEUE);
+		q->type = htonl(DUMP_CHAIN_QUEUE);
 		q->chain_size = htonl(
 		    sizeof(struct qla2xxx_mqueue_chain) +
 		    sizeof(struct qla2xxx_mqueue_header) +
@@ -608,7 +608,7 @@ qla25xx_copy_mqueues(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 
 		/* Add header. */
 		qh = ptr;
-		qh->queue = __constant_htonl(TYPE_RESPONSE_QUEUE);
+		qh->queue = htonl(TYPE_RESPONSE_QUEUE);
 		qh->number = htonl(que);
 		qh->size = htonl(rsp->length * sizeof(response_t));
 		ptr += sizeof(struct qla2xxx_mqueue_header);
@@ -634,8 +634,8 @@ qla25xx_copy_mq(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 
 	mq = ptr;
 	*last_chain = &mq->type;
-	mq->type = __constant_htonl(DUMP_CHAIN_MQ);
-	mq->chain_size = __constant_htonl(sizeof(struct qla2xxx_mq_chain));
+	mq->type = htonl(DUMP_CHAIN_MQ);
+	mq->chain_size = htonl(sizeof(struct qla2xxx_mq_chain));
 
 	que_cnt = ha->max_req_queues > ha->max_rsp_queues ?
 		ha->max_req_queues : ha->max_rsp_queues;
@@ -1271,8 +1271,8 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	nxt_chain = (void *)ha->fw_dump + ha->chain_offset;
 	nxt_chain = qla2xxx_copy_atioqueues(ha, nxt_chain, &last_chain);
 	if (last_chain) {
-		ha->fw_dump->version |= __constant_htonl(DUMP_CHAIN_VARIANT);
-		*last_chain |= __constant_htonl(DUMP_CHAIN_LAST);
+		ha->fw_dump->version |= htonl(DUMP_CHAIN_VARIANT);
+		*last_chain |= htonl(DUMP_CHAIN_LAST);
 	}
 
 	/* Adjust valid length. */
@@ -1323,7 +1323,7 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	}
 	fw = &ha->fw_dump->isp.isp25;
 	qla2xxx_prep_dump(ha, ha->fw_dump);
-	ha->fw_dump->version = __constant_htonl(2);
+	ha->fw_dump->version = htonl(2);
 
 	fw->host_status = htonl(RD_REG_DWORD(&reg->host_status));
 
@@ -1587,8 +1587,8 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	nxt_chain = qla25xx_copy_mqueues(ha, nxt_chain, &last_chain);
 	nxt_chain = qla2xxx_copy_atioqueues(ha, nxt_chain, &last_chain);
 	if (last_chain) {
-		ha->fw_dump->version |= __constant_htonl(DUMP_CHAIN_VARIANT);
-		*last_chain |= __constant_htonl(DUMP_CHAIN_LAST);
+		ha->fw_dump->version |= htonl(DUMP_CHAIN_VARIANT);
+		*last_chain |= htonl(DUMP_CHAIN_LAST);
 	}
 
 	/* Adjust valid length. */
@@ -1905,8 +1905,8 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	nxt_chain = qla25xx_copy_mqueues(ha, nxt_chain, &last_chain);
 	nxt_chain = qla2xxx_copy_atioqueues(ha, nxt_chain, &last_chain);
 	if (last_chain) {
-		ha->fw_dump->version |= __constant_htonl(DUMP_CHAIN_VARIANT);
-		*last_chain |= __constant_htonl(DUMP_CHAIN_LAST);
+		ha->fw_dump->version |= htonl(DUMP_CHAIN_VARIANT);
+		*last_chain |= htonl(DUMP_CHAIN_LAST);
 	}
 
 	/* Adjust valid length. */
@@ -2408,8 +2408,8 @@ copy_queue:
 	nxt_chain = qla25xx_copy_mqueues(ha, nxt_chain, &last_chain);
 	nxt_chain = qla2xxx_copy_atioqueues(ha, nxt_chain, &last_chain);
 	if (last_chain) {
-		ha->fw_dump->version |= __constant_htonl(DUMP_CHAIN_VARIANT);
-		*last_chain |= __constant_htonl(DUMP_CHAIN_LAST);
+		ha->fw_dump->version |= htonl(DUMP_CHAIN_VARIANT);
+		*last_chain |= htonl(DUMP_CHAIN_LAST);
 	}
 
 	/* Adjust valid length. */
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index dccc4dc..94e8a85 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -35,10 +35,10 @@ qla2x00_prep_ms_iocb(scsi_qla_host_t *vha, uint32_t req_size, uint32_t rsp_size)
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
 
@@ -74,10 +74,10 @@ qla24xx_prep_ms_iocb(scsi_qla_host_t *vha, uint32_t req_size, uint32_t rsp_size)
 
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
 
@@ -142,7 +142,7 @@ qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
 		case CS_DATA_UNDERRUN:
 		case CS_DATA_OVERRUN:		/* Overrun? */
 			if (ct_rsp->header.response !=
-			    __constant_cpu_to_be16(CT_ACCEPT_RESPONSE)) {
+			    cpu_to_be16(CT_ACCEPT_RESPONSE)) {
 				ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0x2077,
 				    "%s failed rejected request on port_id: %02x%02x%02x Compeltion status 0x%x, response 0x%x\n",
 				    routine, vha->d_id.b.domain,
@@ -1153,10 +1153,10 @@ qla2x00_prep_ms_fdmi_iocb(scsi_qla_host_t *vha, uint32_t req_size,
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
 
@@ -1193,8 +1193,8 @@ qla24xx_prep_ms_fdmi_iocb(scsi_qla_host_t *vha, uint32_t req_size,
 	ct_pkt->entry_count = 1;
 	ct_pkt->nport_handle = cpu_to_le16(vha->mgmt_svr_loop_id);
 	ct_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
-	ct_pkt->cmd_dsd_count = __constant_cpu_to_le16(1);
-	ct_pkt->rsp_dsd_count = __constant_cpu_to_le16(1);
+	ct_pkt->cmd_dsd_count = cpu_to_le16(1);
+	ct_pkt->rsp_dsd_count = cpu_to_le16(1);
 	ct_pkt->rsp_byte_count = cpu_to_le32(rsp_size);
 	ct_pkt->cmd_byte_count = cpu_to_le32(req_size);
 
@@ -1281,19 +1281,19 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 
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
 	eiter = entries + size;
-	eiter->type = __constant_cpu_to_be16(FDMI_HBA_NODE_NAME);
-	eiter->len = __constant_cpu_to_be16(4 + WWN_SIZE);
+	eiter->type = cpu_to_be16(FDMI_HBA_NODE_NAME);
+	eiter->len = cpu_to_be16(4 + WWN_SIZE);
 	memcpy(eiter->a.node_name, vha->node_name, WWN_SIZE);
 	size += 4 + WWN_SIZE;
 
@@ -1302,7 +1302,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 
 	/* Manufacturer. */
 	eiter = entries + size;
-	eiter->type = __constant_cpu_to_be16(FDMI_HBA_MANUFACTURER);
+	eiter->type = cpu_to_be16(FDMI_HBA_MANUFACTURER);
 	alen = strlen(QLA2XXX_MANUFACTURER);
 	snprintf(eiter->a.manufacturer, sizeof(eiter->a.manufacturer),
 	    "%s", "QLogic Corporation");
@@ -1315,7 +1315,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 
 	/* Serial number. */
 	eiter = entries + size;
-	eiter->type = __constant_cpu_to_be16(FDMI_HBA_SERIAL_NUMBER);
+	eiter->type = cpu_to_be16(FDMI_HBA_SERIAL_NUMBER);
 	if (IS_FWI2_CAPABLE(ha))
 		qla2xxx_get_vpd_field(vha, "SN", eiter->a.serial_num,
 		    sizeof(eiter->a.serial_num));
@@ -1335,7 +1335,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 
 	/* Model name. */
 	eiter = entries + size;
-	eiter->type = __constant_cpu_to_be16(FDMI_HBA_MODEL);
+	eiter->type = cpu_to_be16(FDMI_HBA_MODEL);
 	snprintf(eiter->a.model, sizeof(eiter->a.model),
 	    "%s", ha->model_number);
 	alen = strlen(eiter->a.model);
@@ -1348,7 +1348,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 
 	/* Model description. */
 	eiter = entries + size;
-	eiter->type = __constant_cpu_to_be16(FDMI_HBA_MODEL_DESCRIPTION);
+	eiter->type = cpu_to_be16(FDMI_HBA_MODEL_DESCRIPTION);
 	snprintf(eiter->a.model_desc, sizeof(eiter->a.model_desc),
 	    "%s", ha->model_desc);
 	alen = strlen(eiter->a.model_desc);
@@ -1361,7 +1361,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 
 	/* Hardware version. */
 	eiter = entries + size;
-	eiter->type = __constant_cpu_to_be16(FDMI_HBA_HARDWARE_VERSION);
+	eiter->type = cpu_to_be16(FDMI_HBA_HARDWARE_VERSION);
 	if (!IS_FWI2_CAPABLE(ha)) {
 		snprintf(eiter->a.hw_version, sizeof(eiter->a.hw_version),
 		    "HW:%s", ha->adapter_id);
@@ -1385,7 +1385,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 
 	/* Driver version. */
 	eiter = entries + size;
-	eiter->type = __constant_cpu_to_be16(FDMI_HBA_DRIVER_VERSION);
+	eiter->type = cpu_to_be16(FDMI_HBA_DRIVER_VERSION);
 	snprintf(eiter->a.driver_version, sizeof(eiter->a.driver_version),
 	    "%s", qla2x00_version_str);
 	alen = strlen(eiter->a.driver_version);
@@ -1398,7 +1398,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 
 	/* Option ROM version. */
 	eiter = entries + size;
-	eiter->type = __constant_cpu_to_be16(FDMI_HBA_OPTION_ROM_VERSION);
+	eiter->type = cpu_to_be16(FDMI_HBA_OPTION_ROM_VERSION);
 	snprintf(eiter->a.orom_version, sizeof(eiter->a.orom_version),
 	    "%d.%02d", ha->bios_revision[1], ha->bios_revision[0]);
 	alen = strlen(eiter->a.orom_version);
@@ -1411,7 +1411,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 
 	/* Firmware version */
 	eiter = entries + size;
-	eiter->type = __constant_cpu_to_be16(FDMI_HBA_FIRMWARE_VERSION);
+	eiter->type = cpu_to_be16(FDMI_HBA_FIRMWARE_VERSION);
 	ha->isp_ops->fw_version_str(vha, eiter->a.fw_version,
 	    sizeof(eiter->a.fw_version));
 	alen = strlen(eiter->a.fw_version);
@@ -2484,8 +2484,8 @@ qla24xx_prep_ms_fm_iocb(scsi_qla_host_t *vha, uint32_t req_size,
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
index bf8119e..f2d1a9f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1637,7 +1637,7 @@ allocate:
 	ha->fw_dump->signature[1] = 'L';
 	ha->fw_dump->signature[2] = 'G';
 	ha->fw_dump->signature[3] = 'C';
-	ha->fw_dump->version = __constant_htonl(1);
+	ha->fw_dump->version = htonl(1);
 
 	ha->fw_dump->fixed_size = htonl(fixed_size);
 	ha->fw_dump->mem_size = htonl(mem_size);
@@ -2017,8 +2017,8 @@ qla2x00_config_rings(struct scsi_qla_host *vha)
 	struct rsp_que *rsp = ha->rsp_q_map[0];
 
 	/* Setup ring parameters in initialization control block. */
-	ha->init_cb->request_q_outpointer = __constant_cpu_to_le16(0);
-	ha->init_cb->response_q_inpointer = __constant_cpu_to_le16(0);
+	ha->init_cb->request_q_outpointer = cpu_to_le16(0);
+	ha->init_cb->response_q_inpointer = cpu_to_le16(0);
 	ha->init_cb->request_q_length = cpu_to_le16(req->length);
 	ha->init_cb->response_q_length = cpu_to_le16(rsp->length);
 	ha->init_cb->request_q_address[0] = cpu_to_le32(LSD(req->dma));
@@ -2047,8 +2047,8 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 
 	/* Setup ring parameters in initialization control block. */
 	icb = (struct init_cb_24xx *)ha->init_cb;
-	icb->request_q_outpointer = __constant_cpu_to_le16(0);
-	icb->response_q_inpointer = __constant_cpu_to_le16(0);
+	icb->request_q_outpointer = cpu_to_le16(0);
+	icb->response_q_inpointer = cpu_to_le16(0);
 	icb->request_q_length = cpu_to_le16(req->length);
 	icb->response_q_length = cpu_to_le16(rsp->length);
 	icb->request_q_address[0] = cpu_to_le32(LSD(req->dma));
@@ -2057,18 +2057,17 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 	icb->response_q_address[1] = cpu_to_le32(MSD(rsp->dma));
 
 	/* Setup ATIO queue dma pointers for target mode */
-	icb->atio_q_inpointer = __constant_cpu_to_le16(0);
+	icb->atio_q_inpointer = cpu_to_le16(0);
 	icb->atio_q_length = cpu_to_le16(ha->tgt.atio_q_length);
 	icb->atio_q_address[0] = cpu_to_le32(LSD(ha->tgt.atio_dma));
 	icb->atio_q_address[1] = cpu_to_le32(MSD(ha->tgt.atio_dma));
 
 	if (IS_SHADOW_REG_CAPABLE(ha))
-		icb->firmware_options_2 |=
-		    __constant_cpu_to_le32(BIT_30|BIT_29);
+		icb->firmware_options_2 |= cpu_to_le32(BIT_30|BIT_29);
 
 	if (ha->mqenable || IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
-		icb->qos = __constant_cpu_to_le16(QLA_DEFAULT_QUE_QOS);
-		icb->rid = __constant_cpu_to_le16(rid);
+		icb->qos = cpu_to_le16(QLA_DEFAULT_QUE_QOS);
+		icb->rid = cpu_to_le16(rid);
 		if (ha->flags.msix_enabled) {
 			msix = &ha->msix_entries[1];
 			ql_dbg(ql_dbg_init, vha, 0x00fd,
@@ -2078,26 +2077,22 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 		}
 		/* Use alternate PCI bus number */
 		if (MSB(rid))
-			icb->firmware_options_2 |=
-				__constant_cpu_to_le32(BIT_19);
+			icb->firmware_options_2 |= cpu_to_le32(BIT_19);
 		/* Use alternate PCI devfn */
 		if (LSB(rid))
-			icb->firmware_options_2 |=
-				__constant_cpu_to_le32(BIT_18);
+			icb->firmware_options_2 |= cpu_to_le32(BIT_18);
 
 		/* Use Disable MSIX Handshake mode for capable adapters */
 		if ((ha->fw_attributes & BIT_6) && (IS_MSIX_NACK_CAPABLE(ha)) &&
 		    (ha->flags.msix_enabled)) {
-			icb->firmware_options_2 &=
-				__constant_cpu_to_le32(~BIT_22);
+			icb->firmware_options_2 &= cpu_to_le32(~BIT_22);
 			ha->flags.disable_msix_handshake = 1;
 			ql_dbg(ql_dbg_init, vha, 0x00fe,
 			    "MSIX Handshake Disable Mode turned on.\n");
 		} else {
-			icb->firmware_options_2 |=
-				__constant_cpu_to_le32(BIT_22);
+			icb->firmware_options_2 |= cpu_to_le32(BIT_22);
 		}
-		icb->firmware_options_2 |= __constant_cpu_to_le32(BIT_23);
+		icb->firmware_options_2 |= cpu_to_le32(BIT_23);
 
 		WRT_REG_DWORD(&reg->isp25mq.req_q_in, 0);
 		WRT_REG_DWORD(&reg->isp25mq.req_q_out, 0);
@@ -2195,7 +2190,7 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 	}
 
 	if (IS_FWI2_CAPABLE(ha)) {
-		mid_init_cb->options = __constant_cpu_to_le16(BIT_1);
+		mid_init_cb->options = cpu_to_le16(BIT_1);
 		mid_init_cb->init_cb.execution_throttle =
 		    cpu_to_le16(ha->fw_xcb_count);
 		/* D-Port Status */
@@ -2621,8 +2616,8 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 			nv->frame_payload_size = 1024;
 		}
 
-		nv->max_iocb_allocation = __constant_cpu_to_le16(256);
-		nv->execution_throttle = __constant_cpu_to_le16(16);
+		nv->max_iocb_allocation = cpu_to_le16(256);
+		nv->execution_throttle = cpu_to_le16(16);
 		nv->retry_count = 8;
 		nv->retry_delay = 1;
 
@@ -2640,7 +2635,7 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 		nv->host_p[1] = BIT_2;
 		nv->reset_delay = 5;
 		nv->port_down_retry_count = 8;
-		nv->max_luns_per_target = __constant_cpu_to_le16(8);
+		nv->max_luns_per_target = cpu_to_le16(8);
 		nv->link_down_timeout = 60;
 
 		rval = 1;
@@ -2768,7 +2763,7 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 	memcpy(vha->node_name, icb->node_name, WWN_SIZE);
 	memcpy(vha->port_name, icb->port_name, WWN_SIZE);
 
-	icb->execution_throttle = __constant_cpu_to_le16(0xFFFF);
+	icb->execution_throttle = cpu_to_le16(0xFFFF);
 
 	ha->retry_count = nv->retry_count;
 
@@ -2820,10 +2815,10 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
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
@@ -4954,7 +4949,7 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 	/* Bad NVRAM data, set defaults parameters. */
 	if (chksum || nv->id[0] != 'I' || nv->id[1] != 'S' || nv->id[2] != 'P'
 	    || nv->id[3] != ' ' ||
-	    nv->nvram_version < __constant_cpu_to_le16(ICB_VERSION)) {
+	    nv->nvram_version < cpu_to_le16(ICB_VERSION)) {
 		/* Reset NVRAM data. */
 		ql_log(ql_log_warn, vha, 0x006b,
 		    "Inconsistent NVRAM detected: checksum=0x%x id=%c "
@@ -4967,12 +4962,12 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 		 * Set default initialization control block.
 		 */
 		memset(nv, 0, ha->nvram_size);
-		nv->nvram_version = __constant_cpu_to_le16(ICB_VERSION);
-		nv->version = __constant_cpu_to_le16(ICB_VERSION);
+		nv->nvram_version = cpu_to_le16(ICB_VERSION);
+		nv->version = cpu_to_le16(ICB_VERSION);
 		nv->frame_payload_size = 2048;
-		nv->execution_throttle = __constant_cpu_to_le16(0xFFFF);
-		nv->exchange_count = __constant_cpu_to_le16(0);
-		nv->hard_address = __constant_cpu_to_le16(124);
+		nv->execution_throttle = cpu_to_le16(0xFFFF);
+		nv->exchange_count = cpu_to_le16(0);
+		nv->hard_address = cpu_to_le16(124);
 		nv->port_name[0] = 0x21;
 		nv->port_name[1] = 0x00 + ha->port_no + 1;
 		nv->port_name[2] = 0x00;
@@ -4990,29 +4985,29 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
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
 
 	if (!qla_ini_mode_enabled(vha)) {
 		/* Don't enable full login after initial LIP */
-		nv->firmware_options_1 &= __constant_cpu_to_le32(~BIT_13);
+		nv->firmware_options_1 &= cpu_to_le32(~BIT_13);
 		/* Don't enable LIP full login for initiator */
-		nv->host_p &= __constant_cpu_to_le32(~BIT_10);
+		nv->host_p &= cpu_to_le32(~BIT_10);
 	}
 
 	qlt_24xx_config_nvram_stage1(vha, nv);
@@ -5046,14 +5041,14 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 
 	qlt_24xx_config_nvram_stage2(vha, icb);
 
-	if (nv->host_p & __constant_cpu_to_le32(BIT_15)) {
+	if (nv->host_p & cpu_to_le32(BIT_15)) {
 		/* Use alternate WWN? */
 		memcpy(icb->node_name, nv->alternate_node_name, WWN_SIZE);
 		memcpy(icb->port_name, nv->alternate_port_name, WWN_SIZE);
 	}
 
 	/* Prepare nodename */
-	if ((icb->firmware_options_1 & __constant_cpu_to_le32(BIT_14)) == 0) {
+	if ((icb->firmware_options_1 & cpu_to_le32(BIT_14)) == 0) {
 		/*
 		 * Firmware will apply the following mask if the nodename was
 		 * not provided.
@@ -5085,7 +5080,7 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 	memcpy(vha->node_name, icb->node_name, WWN_SIZE);
 	memcpy(vha->port_name, icb->port_name, WWN_SIZE);
 
-	icb->execution_throttle = __constant_cpu_to_le16(0xFFFF);
+	icb->execution_throttle = cpu_to_le16(0xFFFF);
 
 	ha->retry_count = le16_to_cpu(nv->login_retry_count);
 
@@ -5093,7 +5088,7 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 	if (le16_to_cpu(nv->login_timeout) < ql2xlogintimeout)
 		nv->login_timeout = cpu_to_le16(ql2xlogintimeout);
 	if (le16_to_cpu(nv->login_timeout) < 4)
-		nv->login_timeout = __constant_cpu_to_le16(4);
+		nv->login_timeout = cpu_to_le16(4);
 	ha->login_timeout = le16_to_cpu(nv->login_timeout);
 	icb->login_timeout = nv->login_timeout;
 
@@ -5144,7 +5139,7 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 		ha->zio_timer = le16_to_cpu(icb->interrupt_delay_timer) ?
 		    le16_to_cpu(icb->interrupt_delay_timer): 2;
 	}
-	icb->firmware_options_2 &= __constant_cpu_to_le32(
+	icb->firmware_options_2 &= cpu_to_le32(
 	    ~(BIT_3 | BIT_2 | BIT_1 | BIT_0));
 	vha->flags.process_response_queue = 0;
 	if (ha->zio_mode != QLA_ZIO_DISABLED) {
@@ -5900,7 +5895,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	/* Bad NVRAM data, set defaults parameters. */
 	if (chksum || nv->id[0] != 'I' || nv->id[1] != 'S' || nv->id[2] != 'P'
 	    || nv->id[3] != ' ' ||
-	    nv->nvram_version < __constant_cpu_to_le16(ICB_VERSION)) {
+	    nv->nvram_version < cpu_to_le16(ICB_VERSION)) {
 		/* Reset NVRAM data. */
 		ql_log(ql_log_info, vha, 0x0073,
 		    "Inconsistent NVRAM detected: checksum=0x%x id=%c "
@@ -5914,11 +5909,11 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 		 * Set default initialization control block.
 		 */
 		memset(nv, 0, ha->nvram_size);
-		nv->nvram_version = __constant_cpu_to_le16(ICB_VERSION);
-		nv->version = __constant_cpu_to_le16(ICB_VERSION);
+		nv->nvram_version = cpu_to_le16(ICB_VERSION);
+		nv->version = cpu_to_le16(ICB_VERSION);
 		nv->frame_payload_size = 2048;
-		nv->execution_throttle = __constant_cpu_to_le16(0xFFFF);
-		nv->exchange_count = __constant_cpu_to_le16(0);
+		nv->execution_throttle = cpu_to_le16(0xFFFF);
+		nv->exchange_count = cpu_to_le16(0);
 		nv->port_name[0] = 0x21;
 		nv->port_name[1] = 0x00 + ha->port_no + 1;
 		nv->port_name[2] = 0x00;
@@ -5935,20 +5930,20 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
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
-		nv->link_down_timeout = __constant_cpu_to_le16(180);
+		nv->max_luns_per_target = cpu_to_le16(128);
+		nv->port_down_retry_count = cpu_to_le16(30);
+		nv->link_down_timeout = cpu_to_le16(180);
 		nv->enode_mac[0] = 0x00;
 		nv->enode_mac[1] = 0xC0;
 		nv->enode_mac[2] = 0xDD;
@@ -6007,13 +6002,13 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	qlt_81xx_config_nvram_stage2(vha, icb);
 
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
@@ -6042,7 +6037,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	memcpy(vha->node_name, icb->node_name, WWN_SIZE);
 	memcpy(vha->port_name, icb->port_name, WWN_SIZE);
 
-	icb->execution_throttle = __constant_cpu_to_le16(0xFFFF);
+	icb->execution_throttle = cpu_to_le16(0xFFFF);
 
 	ha->retry_count = le16_to_cpu(nv->login_retry_count);
 
@@ -6050,7 +6045,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	if (le16_to_cpu(nv->login_timeout) < ql2xlogintimeout)
 		nv->login_timeout = cpu_to_le16(ql2xlogintimeout);
 	if (le16_to_cpu(nv->login_timeout) < 4)
-		nv->login_timeout = __constant_cpu_to_le16(4);
+		nv->login_timeout = cpu_to_le16(4);
 	ha->login_timeout = le16_to_cpu(nv->login_timeout);
 	icb->login_timeout = nv->login_timeout;
 
@@ -6096,7 +6091,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 
 	/* if not running MSI-X we need handshaking on interrupts */
 	if (!vha->hw->flags.msix_enabled && (IS_QLA83XX(ha) || IS_QLA27XX(ha)))
-		icb->firmware_options_2 |= __constant_cpu_to_le32(BIT_22);
+		icb->firmware_options_2 |= cpu_to_le32(BIT_22);
 
 	/* Enable ZIO. */
 	if (!vha->flags.init_done) {
@@ -6105,7 +6100,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 		ha->zio_timer = le16_to_cpu(icb->interrupt_delay_timer) ?
 		    le16_to_cpu(icb->interrupt_delay_timer): 2;
 	}
-	icb->firmware_options_2 &= __constant_cpu_to_le32(
+	icb->firmware_options_2 &= cpu_to_le32(
 	    ~(BIT_3 | BIT_2 | BIT_1 | BIT_0));
 	vha->flags.process_response_queue = 0;
 	if (ha->zio_mode != QLA_ZIO_DISABLED) {
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 165ab5b..3ac0e41 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -108,8 +108,7 @@ qla2x00_prep_cont_type0_iocb(struct scsi_qla_host *vha)
 	cont_pkt = (cont_entry_t *)req->ring_ptr;
 
 	/* Load packet defaults. */
-	*((uint32_t *)(&cont_pkt->entry_type)) =
-	    __constant_cpu_to_le32(CONTINUE_TYPE);
+	*((uint32_t *)(&cont_pkt->entry_type)) = cpu_to_le32(CONTINUE_TYPE);
 
 	return (cont_pkt);
 }
@@ -138,8 +137,8 @@ qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *vha, struct req_que *req)
 
 	/* Load packet defaults. */
 	*((uint32_t *)(&cont_pkt->entry_type)) = IS_QLAFX00(vha->hw) ?
-	    __constant_cpu_to_le32(CONTINUE_A64_TYPE_FX00) :
-	    __constant_cpu_to_le32(CONTINUE_A64_TYPE);
+	    cpu_to_le32(CONTINUE_A64_TYPE_FX00) :
+	    cpu_to_le32(CONTINUE_A64_TYPE);
 
 	return (cont_pkt);
 }
@@ -204,11 +203,11 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp, cmd_entry_t *cmd_pkt,
 
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
 
@@ -261,12 +260,11 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 	cmd = GET_CMD_SP(sp);
 
 	/* Update entry type to indicate Command Type 3 IOCB */
-	*((uint32_t *)(&cmd_pkt->entry_type)) =
-	    __constant_cpu_to_le32(COMMAND_A64_TYPE);
+	*((uint32_t *)(&cmd_pkt->entry_type)) = cpu_to_le32(COMMAND_A64_TYPE);
 
 	/* No data transfer */
 	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE) {
-		cmd_pkt->byte_count = __constant_cpu_to_le32(0);
+		cmd_pkt->byte_count = cpu_to_le32(0);
 		return;
 	}
 
@@ -402,7 +400,7 @@ qla2x00_start_scsi(srb_t *sp)
 	/* Set target ID and LUN number*/
 	SET_TARGET_ID(ha, cmd_pkt->target, sp->fcport->loop_id);
 	cmd_pkt->lun = cpu_to_le16(cmd->device->lun);
-	cmd_pkt->control_flags = __constant_cpu_to_le16(CF_SIMPLE_TAG);
+	cmd_pkt->control_flags = cpu_to_le16(CF_SIMPLE_TAG);
 
 	/* Load SCSI command packet. */
 	memcpy(cmd_pkt->scsi_cdb, cmd->cmnd, cmd->cmd_len);
@@ -596,12 +594,11 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd_type_6 *cmd_pkt,
 	cmd = GET_CMD_SP(sp);
 
 	/* Update entry type to indicate Command Type 3 IOCB */
-	*((uint32_t *)(&cmd_pkt->entry_type)) =
-		__constant_cpu_to_le32(COMMAND_TYPE_6);
+	*((uint32_t *)(&cmd_pkt->entry_type)) = cpu_to_le32(COMMAND_TYPE_6);
 
 	/* No data transfer */
 	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE) {
-		cmd_pkt->byte_count = __constant_cpu_to_le32(0);
+		cmd_pkt->byte_count = cpu_to_le32(0);
 		return 0;
 	}
 
@@ -610,13 +607,11 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd_type_6 *cmd_pkt,
 
 	/* Set transfer direction */
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
-		cmd_pkt->control_flags =
-		    __constant_cpu_to_le16(CF_WRITE_DATA);
+		cmd_pkt->control_flags = cpu_to_le16(CF_WRITE_DATA);
 		vha->qla_stats.output_bytes += scsi_bufflen(cmd);
 		vha->qla_stats.output_requests++;
 	} else if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
-		cmd_pkt->control_flags =
-		    __constant_cpu_to_le16(CF_READ_DATA);
+		cmd_pkt->control_flags = cpu_to_le16(CF_READ_DATA);
 		vha->qla_stats.input_bytes += scsi_bufflen(cmd);
 		vha->qla_stats.input_requests++;
 	}
@@ -713,12 +708,11 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 	cmd = GET_CMD_SP(sp);
 
 	/* Update entry type to indicate Command Type 3 IOCB */
-	*((uint32_t *)(&cmd_pkt->entry_type)) =
-	    __constant_cpu_to_le32(COMMAND_TYPE_7);
+	*((uint32_t *)(&cmd_pkt->entry_type)) = cpu_to_le32(COMMAND_TYPE_7);
 
 	/* No data transfer */
 	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE) {
-		cmd_pkt->byte_count = __constant_cpu_to_le32(0);
+		cmd_pkt->byte_count = cpu_to_le32(0);
 		return;
 	}
 
@@ -726,13 +720,11 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 
 	/* Set transfer direction */
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
-		cmd_pkt->task_mgmt_flags =
-		    __constant_cpu_to_le16(TMF_WRITE_DATA);
+		cmd_pkt->task_mgmt_flags = cpu_to_le16(TMF_WRITE_DATA);
 		vha->qla_stats.output_bytes += scsi_bufflen(cmd);
 		vha->qla_stats.output_requests++;
 	} else if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
-		cmd_pkt->task_mgmt_flags =
-		    __constant_cpu_to_le16(TMF_READ_DATA);
+		cmd_pkt->task_mgmt_flags = cpu_to_le16(TMF_READ_DATA);
 		vha->qla_stats.input_bytes += scsi_bufflen(cmd);
 		vha->qla_stats.input_requests++;
 	}
@@ -806,7 +798,7 @@ qla24xx_set_t10dif_tags(srb_t *sp, struct fw_dif_context *pkt,
 	 * match LBA in CDB + N
 	 */
 	case SCSI_PROT_DIF_TYPE2:
-		pkt->app_tag = __constant_cpu_to_le16(0);
+		pkt->app_tag = cpu_to_le16(0);
 		pkt->app_tag_mask[0] = 0x0;
 		pkt->app_tag_mask[1] = 0x0;
 
@@ -837,7 +829,7 @@ qla24xx_set_t10dif_tags(srb_t *sp, struct fw_dif_context *pkt,
 	case SCSI_PROT_DIF_TYPE1:
 		pkt->ref_tag = cpu_to_le32((uint32_t)
 		    (0xffffffff & scsi_get_lba(cmd)));
-		pkt->app_tag = __constant_cpu_to_le16(0);
+		pkt->app_tag = cpu_to_le16(0);
 		pkt->app_tag_mask[0] = 0x0;
 		pkt->app_tag_mask[1] = 0x0;
 
@@ -1238,8 +1230,7 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	cmd = GET_CMD_SP(sp);
 
 	/* Update entry type to indicate Command Type CRC_2 IOCB */
-	*((uint32_t *)(&cmd_pkt->entry_type)) =
-	    __constant_cpu_to_le32(COMMAND_TYPE_CRC_2);
+	*((uint32_t *)(&cmd_pkt->entry_type)) = cpu_to_le32(COMMAND_TYPE_CRC_2);
 
 	vha = sp->fcport->vha;
 	ha = vha->hw;
@@ -1247,7 +1238,7 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	/* No data transfer */
 	data_bytes = scsi_bufflen(cmd);
 	if (!data_bytes || cmd->sc_data_direction == DMA_NONE) {
-		cmd_pkt->byte_count = __constant_cpu_to_le32(0);
+		cmd_pkt->byte_count = cpu_to_le32(0);
 		return QLA_SUCCESS;
 	}
 
@@ -1256,10 +1247,10 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	/* Set transfer direction */
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
 		cmd_pkt->control_flags =
-		    __constant_cpu_to_le16(CF_WRITE_DATA);
+		    cpu_to_le16(CF_WRITE_DATA);
 	} else if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
 		cmd_pkt->control_flags =
-		    __constant_cpu_to_le16(CF_READ_DATA);
+		    cpu_to_le16(CF_READ_DATA);
 	}
 
 	if ((scsi_get_prot_op(cmd) == SCSI_PROT_READ_INSERT) ||
@@ -1381,7 +1372,7 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	crc_ctx_pkt->blk_size = cpu_to_le16(blk_size);
 	crc_ctx_pkt->prot_opts = cpu_to_le16(fw_prot_opts);
 	crc_ctx_pkt->byte_count = cpu_to_le32(data_bytes);
-	crc_ctx_pkt->guard_seed = __constant_cpu_to_le16(0);
+	crc_ctx_pkt->guard_seed = cpu_to_le16(0);
 	/* Fibre channel byte count */
 	cmd_pkt->byte_count = cpu_to_le32(total_bytes);
 	fcp_dl = (uint32_t *)(crc_ctx_pkt->fcp_cmnd.cdb + 16 +
@@ -1389,13 +1380,12 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	*fcp_dl = htonl(total_bytes);
 
 	if (!data_bytes || cmd->sc_data_direction == DMA_NONE) {
-		cmd_pkt->byte_count = __constant_cpu_to_le32(0);
+		cmd_pkt->byte_count = cpu_to_le32(0);
 		return QLA_SUCCESS;
 	}
 	/* Walks data segments */
 
-	cmd_pkt->control_flags |=
-	    __constant_cpu_to_le16(CF_DATA_SEG_DESCR_ENABLE);
+	cmd_pkt->control_flags |= cpu_to_le16(CF_DATA_SEG_DESCR_ENABLE);
 
 	if (!bundling && tot_prot_dsds) {
 		if (qla24xx_walk_and_build_sglist_no_difb(ha, sp,
@@ -1407,8 +1397,7 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 
 	if (bundling && tot_prot_dsds) {
 		/* Walks dif segments */
-		cmd_pkt->control_flags |=
-			__constant_cpu_to_le16(CF_DIF_SEG_DESCR_ENABLE);
+		cmd_pkt->control_flags |= cpu_to_le16(CF_DIF_SEG_DESCR_ENABLE);
 		cur_dsd = (uint32_t *) &crc_ctx_pkt->u.bundling.dif_address;
 		if (qla24xx_walk_and_build_prot_sglist(ha, sp, cur_dsd,
 				tot_prot_dsds, NULL))
@@ -1740,7 +1729,7 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	cmd_pkt->entry_count = (uint8_t)req_cnt;
 	/* Specify response queue number where completion should happen */
 	cmd_pkt->entry_status = (uint8_t) rsp->id;
-	cmd_pkt->timeout = __constant_cpu_to_le16(0);
+	cmd_pkt->timeout = cpu_to_le16(0);
 	wmb();
 
 	/* Adjust ring index. */
@@ -2028,10 +2017,10 @@ qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
         els_iocb->entry_status = 0;
         els_iocb->handle = sp->handle;
         els_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
-        els_iocb->tx_dsd_count = __constant_cpu_to_le16(bsg_job->request_payload.sg_cnt);
+        els_iocb->tx_dsd_count = cpu_to_le16(bsg_job->request_payload.sg_cnt);
 	els_iocb->vp_index = sp->fcport->vha->vp_idx;
         els_iocb->sof_type = EST_SOFI3;
-        els_iocb->rx_dsd_count = __constant_cpu_to_le16(bsg_job->reply_payload.sg_cnt);
+        els_iocb->rx_dsd_count = cpu_to_le16(bsg_job->reply_payload.sg_cnt);
 
 	els_iocb->opcode =
 	    sp->type == SRB_ELS_CMD_RPT ?
@@ -2082,13 +2071,13 @@ qla2x00_ct_iocb(srb_t *sp, ms_iocb_entry_t *ct_iocb)
 	ct_iocb->entry_status = 0;
 	ct_iocb->handle1 = sp->handle;
 	SET_TARGET_ID(ha, ct_iocb->loop_id, sp->fcport->loop_id);
-	ct_iocb->status = __constant_cpu_to_le16(0);
-	ct_iocb->control_flags = __constant_cpu_to_le16(0);
+	ct_iocb->status = cpu_to_le16(0);
+	ct_iocb->control_flags = cpu_to_le16(0);
 	ct_iocb->timeout = 0;
 	ct_iocb->cmd_dsd_count =
-	    __constant_cpu_to_le16(bsg_job->request_payload.sg_cnt);
+	    cpu_to_le16(bsg_job->request_payload.sg_cnt);
 	ct_iocb->total_dsd_count =
-	    __constant_cpu_to_le16(bsg_job->request_payload.sg_cnt + 1);
+	    cpu_to_le16(bsg_job->request_payload.sg_cnt + 1);
 	ct_iocb->req_bytecount =
 	    cpu_to_le32(bsg_job->request_payload.payload_len);
 	ct_iocb->rsp_bytecount =
@@ -2161,13 +2150,13 @@ qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
 
 	ct_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
 	ct_iocb->vp_index = sp->fcport->vha->vp_idx;
-        ct_iocb->comp_status = __constant_cpu_to_le16(0);
+        ct_iocb->comp_status = cpu_to_le16(0);
 
 	ct_iocb->cmd_dsd_count =
-            __constant_cpu_to_le16(bsg_job->request_payload.sg_cnt);
+            cpu_to_le16(bsg_job->request_payload.sg_cnt);
         ct_iocb->timeout = 0;
         ct_iocb->rsp_dsd_count =
-            __constant_cpu_to_le16(bsg_job->reply_payload.sg_cnt);
+            cpu_to_le16(bsg_job->reply_payload.sg_cnt);
         ct_iocb->rsp_byte_count =
             cpu_to_le32(bsg_job->reply_payload.payload_len);
         ct_iocb->cmd_byte_count =
@@ -2661,7 +2650,7 @@ qla25xx_build_bidir_iocb(srb_t *sp, struct scsi_qla_host *vha,
 
 	/*Update entry type to indicate bidir command */
 	*((uint32_t *)(&cmd_pkt->entry_type)) =
-		__constant_cpu_to_le32(COMMAND_BIDIRECTIONAL);
+		cpu_to_le32(COMMAND_BIDIRECTIONAL);
 
 	/* Set the transfer direction, in this set both flags
 	 * Also set the BD_WRAP_BACK flag, firmware will take care
@@ -2669,8 +2658,7 @@ qla25xx_build_bidir_iocb(srb_t *sp, struct scsi_qla_host *vha,
 	 */
 	cmd_pkt->wr_dseg_count = cpu_to_le16(bsg_job->request_payload.sg_cnt);
 	cmd_pkt->rd_dseg_count = cpu_to_le16(bsg_job->reply_payload.sg_cnt);
-	cmd_pkt->control_flags =
-			__constant_cpu_to_le16(BD_WRITE_DATA | BD_READ_DATA |
+	cmd_pkt->control_flags = cpu_to_le16(BD_WRITE_DATA | BD_READ_DATA |
 							BD_WRAP_BACK);
 
 	req_data_len = rsp_data_len = bsg_job->request_payload.payload_len;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d9f6a3d..6ed7847 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1553,7 +1553,7 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req, void *tsk)
 		    "Async-%s error - hdl=%x entry-status(%x).\n",
 		    type, sp->handle, sts->entry_status);
 		iocb->u.tmf.data = QLA_FUNCTION_FAILED;
-	} else if (sts->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
+	} else if (sts->comp_status != cpu_to_le16(CS_COMPLETE)) {
 		ql_log(ql_log_warn, fcport->vha, 0x5039,
 		    "Async-%s error - hdl=%x completion status(%x).\n",
 		    type, sp->handle, sts->comp_status);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index e0099e6..03e92d0 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1872,11 +1872,11 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	lg->entry_count = 1;
 	lg->handle = MAKE_HANDLE(req->id, lg->handle);
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
@@ -1891,7 +1891,7 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 		    "Failed to complete IOCB -- error status (%x).\n",
 		    lg->entry_status);
 		rval = QLA_FUNCTION_FAILED;
-	} else if (lg->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
+	} else if (lg->comp_status != cpu_to_le16(CS_COMPLETE)) {
 		iop[0] = le32_to_cpu(lg->io_parameter[0]);
 		iop[1] = le32_to_cpu(lg->io_parameter[1]);
 
@@ -1945,7 +1945,7 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 			mb[10] |= BIT_0;	/* Class 2. */
 		if (lg->io_parameter[9] || lg->io_parameter[10])
 			mb[10] |= BIT_1;	/* Class 3. */
-		if (lg->io_parameter[0] & __constant_cpu_to_le32(BIT_7))
+		if (lg->io_parameter[0] & cpu_to_le32(BIT_7))
 			mb[10] |= BIT_7;	/* Confirmed Completion
 						 * Allowed
 						 */
@@ -2147,7 +2147,7 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	lg->handle = MAKE_HANDLE(req->id, lg->handle);
 	lg->nport_handle = cpu_to_le16(loop_id);
 	lg->control_flags =
-	    __constant_cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO|
+	    cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO|
 		LCF_FREE_NPORT);
 	lg->port_id[0] = al_pa;
 	lg->port_id[1] = area;
@@ -2163,7 +2163,7 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 		    "Failed to complete IOCB -- error status (%x).\n",
 		    lg->entry_status);
 		rval = QLA_FUNCTION_FAILED;
-	} else if (lg->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
+	} else if (lg->comp_status != cpu_to_le16(CS_COMPLETE)) {
 		ql_dbg(ql_dbg_mbx, vha, 0x1071,
 		    "Failed to complete IOCB -- completion status (%x) "
 		    "ioparam=%x/%x.\n", le16_to_cpu(lg->comp_status),
@@ -2654,7 +2654,7 @@ qla24xx_abort_command(srb_t *sp)
 		    "Failed to complete IOCB -- error status (%x).\n",
 		    abt->entry_status);
 		rval = QLA_FUNCTION_FAILED;
-	} else if (abt->nport_handle != __constant_cpu_to_le16(0)) {
+	} else if (abt->nport_handle != cpu_to_le16(0)) {
 		ql_dbg(ql_dbg_mbx, vha, 0x1090,
 		    "Failed to complete IOCB -- completion status (%x).\n",
 		    le16_to_cpu(abt->nport_handle));
@@ -2737,8 +2737,7 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 		    "Failed to complete IOCB -- error status (%x).\n",
 		    sts->entry_status);
 		rval = QLA_FUNCTION_FAILED;
-	} else if (sts->comp_status !=
-	    __constant_cpu_to_le16(CS_COMPLETE)) {
+	} else if (sts->comp_status != cpu_to_le16(CS_COMPLETE)) {
 		ql_dbg(ql_dbg_mbx, vha, 0x1096,
 		    "Failed to complete IOCB -- completion status (%x).\n",
 		    le16_to_cpu(sts->comp_status));
@@ -3457,7 +3456,7 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 		    "Failed to complete IOCB -- error status (%x).\n",
 		    vpmod->comp_status);
 		rval = QLA_FUNCTION_FAILED;
-	} else if (vpmod->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
+	} else if (vpmod->comp_status != cpu_to_le16(CS_COMPLETE)) {
 		ql_dbg(ql_dbg_mbx, vha, 0x10bf,
 		    "Failed to complete IOCB -- completion status (%x).\n",
 		    le16_to_cpu(vpmod->comp_status));
@@ -3516,7 +3515,7 @@ qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	vce->entry_type = VP_CTRL_IOCB_TYPE;
 	vce->entry_count = 1;
 	vce->command = cpu_to_le16(cmd);
-	vce->vp_count = __constant_cpu_to_le16(1);
+	vce->vp_count = cpu_to_le16(1);
 
 	/* index map in firmware starts with 1; decrement index
 	 * this is ok as we never use index 0
@@ -3536,7 +3535,7 @@ qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 		    "Failed to complete IOCB -- error status (%x).\n",
 		    vce->entry_status);
 		rval = QLA_FUNCTION_FAILED;
-	} else if (vce->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
+	} else if (vce->comp_status != cpu_to_le16(CS_COMPLETE)) {
 		ql_dbg(ql_dbg_mbx, vha, 0x10c5,
 		    "Failed to complet IOCB -- completion status (%x).\n",
 		    le16_to_cpu(vce->comp_status));
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 1843ba9..2d798e6 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -3007,7 +3007,7 @@ qlafx00_build_scsi_iocbs(srb_t *sp, struct cmd_type_7_fx00 *cmd_pkt,
 
 	/* No data transfer */
 	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE) {
-		lcmd_pkt->byte_count = __constant_cpu_to_le32(0);
+		lcmd_pkt->byte_count = cpu_to_le32(0);
 		return;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 25c8bbb..0af9d5a 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1765,8 +1765,8 @@ void qla82xx_config_rings(struct scsi_qla_host *vha)
 
 	/* Setup ring parameters in initialization control block. */
 	icb = (struct init_cb_81xx *)ha->init_cb;
-	icb->request_q_outpointer = __constant_cpu_to_le16(0);
-	icb->response_q_inpointer = __constant_cpu_to_le16(0);
+	icb->request_q_outpointer = cpu_to_le16(0);
+	icb->response_q_inpointer = cpu_to_le16(0);
 	icb->request_q_length = cpu_to_le16(req->length);
 	icb->response_q_length = cpu_to_le16(rsp->length);
 	icb->request_q_address[0] = cpu_to_le32(LSD(req->dma));
@@ -2546,7 +2546,7 @@ qla82xx_read_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 			    "Do ROM fast read failed.\n");
 			goto done_read;
 		}
-		dwptr[i] = __constant_cpu_to_le32(val);
+		dwptr[i] = cpu_to_le32(val);
 	}
 done_read:
 	return dwptr;
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index b656a05..eb656c2 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -316,7 +316,7 @@ qla2x00_clear_nvram_protection(struct qla_hw_data *ha)
 
 	wprot_old = cpu_to_le16(qla2x00_get_nvram_word(ha, ha->nvram_base));
 	stat = qla2x00_write_nvram_word_tmo(ha, ha->nvram_base,
-	    __constant_cpu_to_le16(0x1234), 100000);
+					    cpu_to_le16(0x1234), 100000);
 	wprot = cpu_to_le16(qla2x00_get_nvram_word(ha, ha->nvram_base));
 	if (stat != QLA_SUCCESS || wprot != 0x1234) {
 		/* Write enable. */
@@ -691,9 +691,9 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 	region = (struct qla_flt_region *)&flt[1];
 	ha->isp_ops->read_optrom(vha, (uint8_t *)req->ring,
 	    flt_addr << 2, OPTROM_BURST_SIZE);
-	if (*wptr == __constant_cpu_to_le16(0xffff))
+	if (*wptr == cpu_to_le16(0xffff))
 		goto no_flash_data;
-	if (flt->version != __constant_cpu_to_le16(1)) {
+	if (flt->version != cpu_to_le16(1)) {
 		ql_log(ql_log_warn, vha, 0x0047,
 		    "Unsupported FLT detected: version=0x%x length=0x%x checksum=0x%x.\n",
 		    le16_to_cpu(flt->version), le16_to_cpu(flt->length),
@@ -892,7 +892,7 @@ qla2xxx_get_fdt_info(scsi_qla_host_t *vha)
 	fdt = (struct qla_fdt_layout *)req->ring;
 	ha->isp_ops->read_optrom(vha, (uint8_t *)req->ring,
 	    ha->flt_region_fdt << 2, OPTROM_BURST_SIZE);
-	if (*wptr == __constant_cpu_to_le16(0xffff))
+	if (*wptr == cpu_to_le16(0xffff))
 		goto no_flash_data;
 	if (fdt->sig[0] != 'Q' || fdt->sig[1] != 'L' || fdt->sig[2] != 'I' ||
 	    fdt->sig[3] != 'D')
@@ -991,7 +991,7 @@ qla2xxx_get_idc_param(scsi_qla_host_t *vha)
 	ha->isp_ops->read_optrom(vha, (uint8_t *)req->ring,
 		QLA82XX_IDC_PARAM_ADDR , 8);
 
-	if (*wptr == __constant_cpu_to_le32(0xffffffff)) {
+	if (*wptr == cpu_to_le32(0xffffffff)) {
 		ha->fcoe_dev_init_timeout = QLA82XX_ROM_DEV_INIT_TIMEOUT;
 		ha->fcoe_reset_timeout = QLA82XX_ROM_DRV_RESET_ACK_TIMEOUT;
 	} else {
@@ -1051,9 +1051,9 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *vha)
 
 	ha->isp_ops->read_optrom(vha, (uint8_t *)&hdr,
 	    ha->flt_region_npiv_conf << 2, sizeof(struct qla_npiv_header));
-	if (hdr.version == __constant_cpu_to_le16(0xffff))
+	if (hdr.version == cpu_to_le16(0xffff))
 		return;
-	if (hdr.version != __constant_cpu_to_le16(1)) {
+	if (hdr.version != cpu_to_le16(1)) {
 		ql_dbg(ql_dbg_user, vha, 0x7090,
 		    "Unsupported NPIV-Config "
 		    "detected: version=0x%x entries=0x%x checksum=0x%x.\n",
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 317783f..59a0897 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1023,7 +1023,7 @@ static void qlt_send_notify_ack(struct scsi_qla_host *vha,
 	nack->u.isp24.nport_handle = ntfy->u.isp24.nport_handle;
 	if (le16_to_cpu(ntfy->u.isp24.status) == IMM_NTFY_ELS) {
 		nack->u.isp24.flags = ntfy->u.isp24.flags &
-			__constant_cpu_to_le32(NOTIFY24XX_FLAGS_PUREX_IOCB);
+			cpu_to_le32(NOTIFY24XX_FLAGS_PUREX_IOCB);
 	}
 	nack->u.isp24.srr_rx_id = ntfy->u.isp24.srr_rx_id;
 	nack->u.isp24.status = ntfy->u.isp24.status;
@@ -1081,7 +1081,7 @@ static void qlt_24xx_send_abts_resp(struct scsi_qla_host *vha,
 	resp->sof_type = abts->sof_type;
 	resp->exchange_address = abts->exchange_address;
 	resp->fcp_hdr_le = abts->fcp_hdr_le;
-	f_ctl = __constant_cpu_to_le32(F_CTL_EXCH_CONTEXT_RESP |
+	f_ctl = cpu_to_le32(F_CTL_EXCH_CONTEXT_RESP |
 	    F_CTL_LAST_SEQ | F_CTL_END_SEQ |
 	    F_CTL_SEQ_INITIATIVE);
 	p = (uint8_t *)&f_ctl;
@@ -1156,15 +1156,14 @@ static void qlt_24xx_retry_term_exchange(struct scsi_qla_host *vha,
 	ctio->entry_count = 1;
 	ctio->nport_handle = entry->nport_handle;
 	ctio->handle = QLA_TGT_SKIP_HANDLE |	CTIO_COMPLETION_HANDLE_MARK;
-	ctio->timeout = __constant_cpu_to_le16(QLA_TGT_TIMEOUT);
+	ctio->timeout = cpu_to_le16(QLA_TGT_TIMEOUT);
 	ctio->vp_index = vha->vp_idx;
 	ctio->initiator_id[0] = entry->fcp_hdr_le.d_id[0];
 	ctio->initiator_id[1] = entry->fcp_hdr_le.d_id[1];
 	ctio->initiator_id[2] = entry->fcp_hdr_le.d_id[2];
 	ctio->exchange_addr = entry->exchange_addr_to_abort;
-	ctio->u.status1.flags =
-	    __constant_cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1 |
-		CTIO7_FLAGS_TERMINATE);
+	ctio->u.status1.flags = cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1 |
+					    CTIO7_FLAGS_TERMINATE);
 	ctio->u.status1.ox_id = cpu_to_le16(entry->fcp_hdr_le.ox_id);
 
 	/* Memory Barrier */
@@ -1324,20 +1323,19 @@ static void qlt_24xx_send_task_mgmt_ctio(struct scsi_qla_host *ha,
 	ctio->entry_count = 1;
 	ctio->handle = QLA_TGT_SKIP_HANDLE | CTIO_COMPLETION_HANDLE_MARK;
 	ctio->nport_handle = mcmd->sess->loop_id;
-	ctio->timeout = __constant_cpu_to_le16(QLA_TGT_TIMEOUT);
+	ctio->timeout = cpu_to_le16(QLA_TGT_TIMEOUT);
 	ctio->vp_index = ha->vp_idx;
 	ctio->initiator_id[0] = atio->u.isp24.fcp_hdr.s_id[2];
 	ctio->initiator_id[1] = atio->u.isp24.fcp_hdr.s_id[1];
 	ctio->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
 	ctio->exchange_addr = atio->u.isp24.exchange_addr;
 	ctio->u.status1.flags = (atio->u.isp24.attr << 9) |
-	    __constant_cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1 |
-		CTIO7_FLAGS_SEND_STATUS);
+	    cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1 | CTIO7_FLAGS_SEND_STATUS);
 	temp = be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id);
 	ctio->u.status1.ox_id = cpu_to_le16(temp);
 	ctio->u.status1.scsi_status =
-	    __constant_cpu_to_le16(SS_RESPONSE_INFO_LEN_VALID);
-	ctio->u.status1.response_len = __constant_cpu_to_le16(8);
+	    cpu_to_le16(SS_RESPONSE_INFO_LEN_VALID);
+	ctio->u.status1.response_len = cpu_to_le16(8);
 	ctio->u.status1.sense_data[0] = resp_code;
 
 	/* Memory Barrier */
@@ -1588,7 +1586,7 @@ static int qlt_24xx_build_ctio_pkt(struct qla_tgt_prm *prm,
 
 	pkt->handle = h | CTIO_COMPLETION_HANDLE_MARK;
 	pkt->nport_handle = prm->cmd->loop_id;
-	pkt->timeout = __constant_cpu_to_le16(QLA_TGT_TIMEOUT);
+	pkt->timeout = cpu_to_le16(QLA_TGT_TIMEOUT);
 	pkt->initiator_id[0] = atio->u.isp24.fcp_hdr.s_id[2];
 	pkt->initiator_id[1] = atio->u.isp24.fcp_hdr.s_id[1];
 	pkt->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
@@ -1905,10 +1903,9 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 {
 	prm->sense_buffer_len = min_t(uint32_t, prm->sense_buffer_len,
 	    (uint32_t)sizeof(ctio->u.status1.sense_data));
-	ctio->u.status0.flags |=
-	    __constant_cpu_to_le16(CTIO7_FLAGS_SEND_STATUS);
+	ctio->u.status0.flags |= cpu_to_le16(CTIO7_FLAGS_SEND_STATUS);
 	if (qlt_need_explicit_conf(prm->tgt->ha, prm->cmd, 0)) {
-		ctio->u.status0.flags |= __constant_cpu_to_le16(
+		ctio->u.status0.flags |= cpu_to_le16(
 		    CTIO7_FLAGS_EXPLICIT_CONFORM |
 		    CTIO7_FLAGS_CONFORM_REQ);
 	}
@@ -1925,17 +1922,17 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 				    "non GOOD status\n");
 				goto skip_explict_conf;
 			}
-			ctio->u.status1.flags |= __constant_cpu_to_le16(
+			ctio->u.status1.flags |= cpu_to_le16(
 			    CTIO7_FLAGS_EXPLICIT_CONFORM |
 			    CTIO7_FLAGS_CONFORM_REQ);
 		}
 skip_explict_conf:
 		ctio->u.status1.flags &=
-		    ~__constant_cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_0);
+		    ~cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_0);
 		ctio->u.status1.flags |=
-		    __constant_cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1);
+		    cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1);
 		ctio->u.status1.scsi_status |=
-		    __constant_cpu_to_le16(SS_SENSE_LEN_VALID);
+		    cpu_to_le16(SS_SENSE_LEN_VALID);
 		ctio->u.status1.sense_length =
 		    cpu_to_le16(prm->sense_buffer_len);
 		for (i = 0; i < prm->sense_buffer_len/4; i++)
@@ -1955,9 +1952,9 @@ skip_explict_conf:
 #endif
 	} else {
 		ctio->u.status1.flags &=
-		    ~__constant_cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_0);
+		    ~cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_0);
 		ctio->u.status1.flags |=
-		    __constant_cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1);
+		    cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1);
 		ctio->u.status1.sense_length = 0;
 		memset(ctio->u.status1.sense_data, 0,
 		    sizeof(ctio->u.status1.sense_data));
@@ -2184,7 +2181,7 @@ qlt_build_ctio_crc2_pkt(struct qla_tgt_prm *prm, scsi_qla_host_t *vha)
 
 	pkt->handle  = h | CTIO_COMPLETION_HANDLE_MARK;
 	pkt->nport_handle = prm->cmd->loop_id;
-	pkt->timeout = __constant_cpu_to_le16(QLA_TGT_TIMEOUT);
+	pkt->timeout = cpu_to_le16(QLA_TGT_TIMEOUT);
 	pkt->initiator_id[0] = atio->u.isp24.fcp_hdr.s_id[2];
 	pkt->initiator_id[1] = atio->u.isp24.fcp_hdr.s_id[1];
 	pkt->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
@@ -2200,9 +2197,9 @@ qlt_build_ctio_crc2_pkt(struct qla_tgt_prm *prm, scsi_qla_host_t *vha)
 
 	/* Set transfer direction */
 	if (cmd->dma_data_direction == DMA_TO_DEVICE)
-		pkt->flags = __constant_cpu_to_le16(CTIO7_FLAGS_DATA_IN);
+		pkt->flags = cpu_to_le16(CTIO7_FLAGS_DATA_IN);
 	else if (cmd->dma_data_direction == DMA_FROM_DEVICE)
-		pkt->flags = __constant_cpu_to_le16(CTIO7_FLAGS_DATA_OUT);
+		pkt->flags = cpu_to_le16(CTIO7_FLAGS_DATA_OUT);
 
 
 	pkt->dseg_count = prm->tot_dsds;
@@ -2254,11 +2251,11 @@ qlt_build_ctio_crc2_pkt(struct qla_tgt_prm *prm, scsi_qla_host_t *vha)
 	crc_ctx_pkt->blk_size   = cpu_to_le16(cmd->blk_sz);
 	crc_ctx_pkt->prot_opts  = cpu_to_le16(fw_prot_opts);
 	crc_ctx_pkt->byte_count = cpu_to_le32(data_bytes);
-	crc_ctx_pkt->guard_seed = __constant_cpu_to_le16(0);
+	crc_ctx_pkt->guard_seed = cpu_to_le16(0);
 
 
 	/* Walks data segments */
-	pkt->flags |= __constant_cpu_to_le16(CTIO7_FLAGS_DSD_PTR);
+	pkt->flags |= cpu_to_le16(CTIO7_FLAGS_DSD_PTR);
 
 	if (!bundling && prm->prot_seg_cnt) {
 		if (qla24xx_walk_and_build_sglist_no_difb(ha, NULL, cur_dsd,
@@ -2353,7 +2350,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 
 	if (qlt_has_data(cmd) && (xmit_type & QLA_TGT_XMIT_DATA)) {
 		pkt->u.status0.flags |=
-		    __constant_cpu_to_le16(CTIO7_FLAGS_DATA_IN |
+		    cpu_to_le16(CTIO7_FLAGS_DATA_IN |
 			CTIO7_FLAGS_STATUS_MODE_0);
 
 		if (cmd->se_cmd.prot_op == TARGET_PROT_NORMAL)
@@ -2365,11 +2362,11 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 				    cpu_to_le16(prm.rq_result);
 				pkt->u.status0.residual =
 				    cpu_to_le32(prm.residual);
-				pkt->u.status0.flags |= __constant_cpu_to_le16(
+				pkt->u.status0.flags |= cpu_to_le16(
 				    CTIO7_FLAGS_SEND_STATUS);
 				if (qlt_need_explicit_conf(ha, cmd, 0)) {
 					pkt->u.status0.flags |=
-					    __constant_cpu_to_le16(
+					    cpu_to_le16(
 						CTIO7_FLAGS_EXPLICIT_CONFORM |
 						CTIO7_FLAGS_CONFORM_REQ);
 				}
@@ -2397,12 +2394,12 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 			ctio->entry_count = 1;
 			ctio->entry_type = CTIO_TYPE7;
 			ctio->dseg_count = 0;
-			ctio->u.status1.flags &= ~__constant_cpu_to_le16(
+			ctio->u.status1.flags &= ~cpu_to_le16(
 			    CTIO7_FLAGS_DATA_IN);
 
 			/* Real finish is ctio_m1's finish */
 			pkt->handle |= CTIO_INTERMEDIATE_HANDLE_MARK;
-			pkt->u.status0.flags |= __constant_cpu_to_le16(
+			pkt->u.status0.flags |= cpu_to_le16(
 			    CTIO7_FLAGS_DONT_RET_CTIO);
 
 			/* qlt_24xx_init_ctio_to_isp will correct
@@ -2488,7 +2485,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	if (unlikely(res != 0))
 		goto out_unlock_free_unmap;
 	pkt = (struct ctio7_to_24xx *)prm.pkt;
-	pkt->u.status0.flags |= __constant_cpu_to_le16(CTIO7_FLAGS_DATA_OUT |
+	pkt->u.status0.flags |= cpu_to_le16(CTIO7_FLAGS_DATA_OUT |
 	    CTIO7_FLAGS_STATUS_MODE_0);
 
 	if (cmd->se_cmd.prot_op == TARGET_PROT_NORMAL)
@@ -2686,14 +2683,14 @@ static int __qlt_send_term_exchange(struct scsi_qla_host *vha,
 	ctio24 = (struct ctio7_to_24xx *)pkt;
 	ctio24->entry_type = CTIO_TYPE7;
 	ctio24->nport_handle = cmd ? cmd->loop_id : CTIO7_NHANDLE_UNRECOGNIZED;
-	ctio24->timeout = __constant_cpu_to_le16(QLA_TGT_TIMEOUT);
+	ctio24->timeout = cpu_to_le16(QLA_TGT_TIMEOUT);
 	ctio24->vp_index = vha->vp_idx;
 	ctio24->initiator_id[0] = atio->u.isp24.fcp_hdr.s_id[2];
 	ctio24->initiator_id[1] = atio->u.isp24.fcp_hdr.s_id[1];
 	ctio24->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
 	ctio24->exchange_addr = atio->u.isp24.exchange_addr;
 	ctio24->u.status1.flags = (atio->u.isp24.attr << 9) |
-	    __constant_cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1 |
+	    cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1 |
 		CTIO7_FLAGS_TERMINATE);
 	temp = be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id);
 	ctio24->u.status1.ox_id = cpu_to_le16(temp);
@@ -2914,7 +2911,7 @@ static int qlt_term_ctio_exchange(struct scsi_qla_host *vha, void *ctio,
 	if (ctio != NULL) {
 		struct ctio7_from_24xx *c = (struct ctio7_from_24xx *)ctio;
 		term = !(c->flags &
-		    __constant_cpu_to_le16(OF_TERM_EXCH));
+		    cpu_to_le16(OF_TERM_EXCH));
 	} else
 		term = 1;
 
@@ -4315,14 +4312,14 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
 	ctio24 = (struct ctio7_to_24xx *)pkt;
 	ctio24->entry_type = CTIO_TYPE7;
 	ctio24->nport_handle = sess->loop_id;
-	ctio24->timeout = __constant_cpu_to_le16(QLA_TGT_TIMEOUT);
+	ctio24->timeout = cpu_to_le16(QLA_TGT_TIMEOUT);
 	ctio24->vp_index = vha->vp_idx;
 	ctio24->initiator_id[0] = atio->u.isp24.fcp_hdr.s_id[2];
 	ctio24->initiator_id[1] = atio->u.isp24.fcp_hdr.s_id[1];
 	ctio24->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
 	ctio24->exchange_addr = atio->u.isp24.exchange_addr;
 	ctio24->u.status1.flags = (atio->u.isp24.attr << 9) |
-	    __constant_cpu_to_le16(
+	    cpu_to_le16(
 		CTIO7_FLAGS_STATUS_MODE_1 | CTIO7_FLAGS_SEND_STATUS |
 		CTIO7_FLAGS_DONT_RET_CTIO);
 	/*
@@ -4650,7 +4647,7 @@ static void qlt_response_pkt(struct scsi_qla_host *vha, response_t *pkt)
 		struct atio_from_isp *atio = (struct atio_from_isp *)pkt;
 		int rc;
 		if (atio->u.isp2x.status !=
-		    __constant_cpu_to_le16(ATIO_CDB_VALID)) {
+		    cpu_to_le16(ATIO_CDB_VALID)) {
 			ql_dbg(ql_dbg_tgt, vha, 0xe05e,
 			    "qla_target(%d): ATIO with error "
 			    "status %x received\n", vha->vp_idx,
@@ -4724,7 +4721,7 @@ static void qlt_response_pkt(struct scsi_qla_host *vha, response_t *pkt)
 			    le16_to_cpu(entry->u.isp2x.status));
 			tgt->notify_ack_expected--;
 			if (entry->u.isp2x.status !=
-			    __constant_cpu_to_le16(NOTIFY_ACK_SUCCESS)) {
+			    cpu_to_le16(NOTIFY_ACK_SUCCESS)) {
 				ql_dbg(ql_dbg_tgt, vha, 0xe061,
 				    "qla_target(%d): NOTIFY_ACK "
 				    "failed %x\n", vha->vp_idx,
@@ -5587,19 +5584,19 @@ qlt_24xx_config_nvram_stage1(struct scsi_qla_host *vha, struct nvram_24xx *nv)
 			ha->tgt.saved_set = 1;
 		}
 
-		nv->exchange_count = __constant_cpu_to_le16(0xFFFF);
+		nv->exchange_count = cpu_to_le16(0xFFFF);
 
 		/* Enable target mode */
-		nv->firmware_options_1 |= __constant_cpu_to_le32(BIT_4);
+		nv->firmware_options_1 |= cpu_to_le32(BIT_4);
 
 		/* Disable ini mode, if requested */
 		if (!qla_ini_mode_enabled(vha))
-			nv->firmware_options_1 |= __constant_cpu_to_le32(BIT_5);
+			nv->firmware_options_1 |= cpu_to_le32(BIT_5);
 
 		/* Disable Full Login after LIP */
-		nv->firmware_options_1 &= __constant_cpu_to_le32(~BIT_13);
+		nv->firmware_options_1 &= cpu_to_le32(~BIT_13);
 		/* Enable initial LIP */
-		nv->firmware_options_1 &= __constant_cpu_to_le32(~BIT_9);
+		nv->firmware_options_1 &= cpu_to_le32(~BIT_9);
 		if (ql2xtgt_tape_enable)
 			/* Enable FC Tape support */
 			nv->firmware_options_2 |= cpu_to_le32(BIT_12);
@@ -5608,9 +5605,9 @@ qlt_24xx_config_nvram_stage1(struct scsi_qla_host *vha, struct nvram_24xx *nv)
 			nv->firmware_options_2 &= cpu_to_le32(~BIT_12);
 
 		/* Disable Full Login after LIP */
-		nv->host_p &= __constant_cpu_to_le32(~BIT_10);
+		nv->host_p &= cpu_to_le32(~BIT_10);
 		/* Enable target PRLI control */
-		nv->firmware_options_2 |= __constant_cpu_to_le32(BIT_14);
+		nv->firmware_options_2 |= cpu_to_le32(BIT_14);
 	} else {
 		if (ha->tgt.saved_set) {
 			nv->exchange_count = ha->tgt.saved_exchange_count;
@@ -5632,12 +5629,12 @@ qlt_24xx_config_nvram_stage1(struct scsi_qla_host *vha, struct nvram_24xx *nv)
 			fc_host_supported_classes(vha->host) =
 				FC_COS_CLASS2 | FC_COS_CLASS3;
 
-		nv->firmware_options_2 |= __constant_cpu_to_le32(BIT_8);
+		nv->firmware_options_2 |= cpu_to_le32(BIT_8);
 	} else {
 		if (vha->flags.init_done)
 			fc_host_supported_classes(vha->host) = FC_COS_CLASS3;
 
-		nv->firmware_options_2 &= ~__constant_cpu_to_le32(BIT_8);
+		nv->firmware_options_2 &= ~cpu_to_le32(BIT_8);
 	}
 }
 
@@ -5649,7 +5646,7 @@ qlt_24xx_config_nvram_stage2(struct scsi_qla_host *vha,
 
 	if (ha->tgt.node_name_set) {
 		memcpy(icb->node_name, ha->tgt.tgt_node_name, WWN_SIZE);
-		icb->firmware_options_1 |= __constant_cpu_to_le32(BIT_14);
+		icb->firmware_options_1 |= cpu_to_le32(BIT_14);
 	}
 }
 
@@ -5674,20 +5671,19 @@ qlt_81xx_config_nvram_stage1(struct scsi_qla_host *vha, struct nvram_81xx *nv)
 			ha->tgt.saved_set = 1;
 		}
 
-		nv->exchange_count = __constant_cpu_to_le16(0xFFFF);
+		nv->exchange_count = cpu_to_le16(0xFFFF);
 
 		/* Enable target mode */
-		nv->firmware_options_1 |= __constant_cpu_to_le32(BIT_4);
+		nv->firmware_options_1 |= cpu_to_le32(BIT_4);
 
 		/* Disable ini mode, if requested */
 		if (!qla_ini_mode_enabled(vha))
-			nv->firmware_options_1 |=
-			    __constant_cpu_to_le32(BIT_5);
+			nv->firmware_options_1 |= cpu_to_le32(BIT_5);
 
 		/* Disable Full Login after LIP */
-		nv->firmware_options_1 &= __constant_cpu_to_le32(~BIT_13);
+		nv->firmware_options_1 &= cpu_to_le32(~BIT_13);
 		/* Enable initial LIP */
-		nv->firmware_options_1 &= __constant_cpu_to_le32(~BIT_9);
+		nv->firmware_options_1 &= cpu_to_le32(~BIT_9);
 		if (ql2xtgt_tape_enable)
 			/* Enable FC tape support */
 			nv->firmware_options_2 |= cpu_to_le32(BIT_12);
@@ -5696,9 +5692,9 @@ qlt_81xx_config_nvram_stage1(struct scsi_qla_host *vha, struct nvram_81xx *nv)
 			nv->firmware_options_2 &= cpu_to_le32(~BIT_12);
 
 		/* Disable Full Login after LIP */
-		nv->host_p &= __constant_cpu_to_le32(~BIT_10);
+		nv->host_p &= cpu_to_le32(~BIT_10);
 		/* Enable target PRLI control */
-		nv->firmware_options_2 |= __constant_cpu_to_le32(BIT_14);
+		nv->firmware_options_2 |= cpu_to_le32(BIT_14);
 	} else {
 		if (ha->tgt.saved_set) {
 			nv->exchange_count = ha->tgt.saved_exchange_count;
@@ -5720,12 +5716,12 @@ qlt_81xx_config_nvram_stage1(struct scsi_qla_host *vha, struct nvram_81xx *nv)
 			fc_host_supported_classes(vha->host) =
 				FC_COS_CLASS2 | FC_COS_CLASS3;
 
-		nv->firmware_options_2 |= __constant_cpu_to_le32(BIT_8);
+		nv->firmware_options_2 |= cpu_to_le32(BIT_8);
 	} else {
 		if (vha->flags.init_done)
 			fc_host_supported_classes(vha->host) = FC_COS_CLASS3;
 
-		nv->firmware_options_2 &= ~__constant_cpu_to_le32(BIT_8);
+		nv->firmware_options_2 &= ~cpu_to_le32(BIT_8);
 	}
 }
 
@@ -5740,7 +5736,7 @@ qlt_81xx_config_nvram_stage2(struct scsi_qla_host *vha,
 
 	if (ha->tgt.node_name_set) {
 		memcpy(icb->node_name, ha->tgt.tgt_node_name, WWN_SIZE);
-		icb->firmware_options_1 |= __constant_cpu_to_le32(BIT_14);
+		icb->firmware_options_1 |= cpu_to_le32(BIT_14);
 	}
 }
 
-- 
2.1.2

