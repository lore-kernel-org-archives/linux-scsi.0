From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/9] qla2xxx: Generalize FW-Interface-2 support.
Date: Thu, 19 Jul 2007 15:05:56 -0700
Message-ID: <11848827643294-git-send-email-andrew.vasquez@qlogic.com>
References: <20070719220456.GK4015@plap.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:26966 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932807AbXGSWGI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 18:06:08 -0400
In-Reply-To: <20070719220456.GK4015@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

In preparation for new ISP types.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c   |    8 +++---
 drivers/scsi/qla2xxx/qla_def.h    |    2 +
 drivers/scsi/qla2xxx/qla_gs.c     |   10 +++---
 drivers/scsi/qla2xxx/qla_init.c   |    8 +++---
 drivers/scsi/qla2xxx/qla_inline.h |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c   |    6 ++--
 drivers/scsi/qla2xxx/qla_isr.c    |   16 +++++-----
 drivers/scsi/qla2xxx/qla_mbx.c    |   54 ++++++++++++++++++------------------
 drivers/scsi/qla2xxx/qla_os.c     |    8 ++++-
 9 files changed, 60 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 3eb2208..e406eae 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -119,7 +119,7 @@ qla2x00_sysfs_write_nvram(struct kobject *kobj,
 		return 0;
 
 	/* Checksum NVRAM. */
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+	if (IS_FWI2_CAPABLE(ha)) {
 		uint32_t *iter;
 		uint32_t chksum;
 
@@ -410,7 +410,7 @@ qla2x00_alloc_sysfs_attr(scsi_qla_host_t *ha)
 	int ret;
 
 	for (iter = bin_file_entries; iter->name; iter++) {
-		if (iter->is4GBp_only && (!IS_QLA24XX(ha) && !IS_QLA54XX(ha)))
+		if (iter->is4GBp_only && !IS_FWI2_CAPABLE(ha))
 			continue;
 
 		ret = sysfs_create_bin_file(&host->shost_gendev.kobj,
@@ -429,7 +429,7 @@ qla2x00_free_sysfs_attr(scsi_qla_host_t *ha)
 	struct sysfs_entry *iter;
 
 	for (iter = bin_file_entries; iter->name; iter++) {
-		if (iter->is4GBp_only && (!IS_QLA24XX(ha) && !IS_QLA54XX(ha)))
+		if (iter->is4GBp_only && !IS_FWI2_CAPABLE(ha))
 			continue;
 
 		sysfs_remove_bin_file(&host->shost_gendev.kobj,
@@ -898,7 +898,7 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 	pfc_host_stat = &ha->fc_host_stat;
 	memset(pfc_host_stat, -1, sizeof(struct fc_host_statistics));
 
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+	if (IS_FWI2_CAPABLE(ha)) {
 		rval = qla24xx_get_isp_stats(ha, (uint32_t *)&stat_buf,
 		    sizeof(stat_buf) / 4, mb_stat);
 	} else if (atomic_read(&ha->loop_state) == LOOP_READY &&
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a1ca590..b818c43 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2215,6 +2215,7 @@ typedef struct scsi_qla_host {
 #define DT_ISP5432			BIT_10
 #define DT_ISP_LAST			(DT_ISP5432 << 1)
 
+#define DT_FWI2				BIT_27
 #define DT_ZIO_SUPPORTED		BIT_28
 #define DT_OEM_001			BIT_29
 #define DT_ISP2200A			BIT_30
@@ -2238,6 +2239,7 @@ typedef struct scsi_qla_host {
 #define IS_QLA24XX(ha)	(IS_QLA2422(ha) || IS_QLA2432(ha))
 #define IS_QLA54XX(ha)	(IS_QLA5422(ha) || IS_QLA5432(ha))
 
+#define IS_FWI2_CAPABLE(ha)	((ha)->device_type & DT_FWI2)
 #define IS_ZIO_SUPPORTED(ha)	((ha)->device_type & DT_ZIO_SUPPORTED)
 #define IS_OEM_001(ha)		((ha)->device_type & DT_OEM_001)
 #define HAS_EXTENDED_IDS(ha)	((ha)->device_type & DT_EXTENDED_IDS)
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index a086b3f..16de917 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -127,7 +127,7 @@ qla2x00_chk_ms_status(scsi_qla_host_t *ha, ms_iocb_entry_t *ms_pkt,
 		DEBUG2_3(printk("scsi(%ld): %s failed, error status (%x).\n",
 		    ha->host_no, routine, ms_pkt->entry_status));
 	} else {
-		if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+		if (IS_FWI2_CAPABLE(ha))
 			comp_status = le16_to_cpu(
 			    ((struct ct_entry_24xx *)ms_pkt)->comp_status);
 		else
@@ -1198,7 +1198,7 @@ qla2x00_update_ms_fdmi_iocb(scsi_qla_host_t *ha, uint32_t req_size)
 	ms_iocb_entry_t *ms_pkt = ha->ms_iocb;
 	struct ct_entry_24xx *ct_pkt = (struct ct_entry_24xx *)ha->ms_iocb;
 
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+	if (IS_FWI2_CAPABLE(ha)) {
 		ct_pkt->cmd_byte_count = cpu_to_le32(req_size);
 		ct_pkt->dseg_0_len = ct_pkt->cmd_byte_count;
 	} else {
@@ -1562,7 +1562,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_PORT_MAX_FRAME_SIZE);
 	eiter->len = __constant_cpu_to_be16(4 + 4);
-	max_frame_size = IS_QLA24XX(ha) || IS_QLA54XX(ha) ?
+	max_frame_size = IS_FWI2_CAPABLE(ha) ?
 		(uint32_t) icb24->frame_payload_size:
 		(uint32_t) ha->init_cb->frame_payload_size;
 	eiter->a.max_frame_size = cpu_to_be32(max_frame_size);
@@ -1678,7 +1678,7 @@ qla2x00_gfpn_id(scsi_qla_host_t *ha, sw_info_t *list)
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
 
-	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
+	if (!IS_FWI2_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
 	for (i = 0; i < MAX_FIBRE_DEVICES; i++) {
@@ -1786,7 +1786,7 @@ qla2x00_gpsc(scsi_qla_host_t *ha, sw_info_t *list)
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
 
-	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
+	if (!IS_FWI2_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 	if (!ha->flags.gpsc_supported)
 		return QLA_FUNCTION_FAILED;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index cc6ebb6..7e53814 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -736,7 +736,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
 		fixed_size = offsetof(struct qla2300_fw_dump, data_ram);
 		mem_size = (ha->fw_memory_size - 0x11000 + 1) *
 		    sizeof(uint16_t);
-	} else if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+	} else if (IS_FWI2_CAPABLE(ha)) {
 		fixed_size = offsetof(struct qla24xx_fw_dump, ext_mem);
 		mem_size = (ha->fw_memory_size - 0x100000 + 1) *
 		    sizeof(uint32_t);
@@ -2267,7 +2267,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
 	scsi_qla_host_t *pha = to_qla_parent(ha);
 
 	/* If FL port exists, then SNS is present */
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+	if (IS_FWI2_CAPABLE(ha))
 		loop_id = NPH_F_PORT;
 	else
 		loop_id = SNS_FL_PORT;
@@ -2294,7 +2294,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *ha)
 			qla2x00_fdmi_register(ha);
 
 		/* Ensure we are logged into the SNS. */
-		if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+		if (IS_FWI2_CAPABLE(ha))
 			loop_id = NPH_SNS;
 		else
 			loop_id = SIMPLE_NAME_SERVER;
@@ -4012,7 +4012,7 @@ qla2x00_try_to_stop_firmware(scsi_qla_host_t *ha)
 {
 	int ret, retries;
 
-	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
+	if (!IS_FWI2_CAPABLE(ha))
 		return;
 	if (!ha->fw_major_version)
 		return;
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index d302333..91706db 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -163,7 +163,7 @@ static inline int qla2x00_is_reserved_id(scsi_qla_host_t *, uint16_t);
 static inline int
 qla2x00_is_reserved_id(scsi_qla_host_t *ha, uint16_t loop_id)
 {
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+	if (IS_FWI2_CAPABLE(ha))
 		return (loop_id > NPH_LAST_HANDLE);
 
 	return ((loop_id > ha->last_loop_id && loop_id < SNS_FIRST_LOOP_ID) ||
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index c71863f..49208c6 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -432,7 +432,7 @@ __qla2x00_marker(scsi_qla_host_t *ha, uint16_t loop_id, uint16_t lun,
 	mrk->entry_type = MARKER_TYPE;
 	mrk->modifier = type;
 	if (type != MK_SYNC_ALL) {
-		if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+		if (IS_FWI2_CAPABLE(ha)) {
 			mrk24 = (struct mrk_entry_24xx *) mrk;
 			mrk24->nport_handle = cpu_to_le16(loop_id);
 			mrk24->lun[1] = LSB(lun);
@@ -487,7 +487,7 @@ qla2x00_req_pkt(scsi_qla_host_t *ha)
 	for (timer = HZ; timer; timer--) {
 		if ((req_cnt + 2) >= ha->req_q_cnt) {
 			/* Calculate number of free request entries. */
-			if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+			if (IS_FWI2_CAPABLE(ha))
 				cnt = (uint16_t)RD_REG_DWORD(
 				    &reg->isp24.req_q_out);
 			else
@@ -561,7 +561,7 @@ qla2x00_isp_cmd(scsi_qla_host_t *ha)
 		ha->request_ring_ptr++;
 
 	/* Set chip new ring index. */
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+	if (IS_FWI2_CAPABLE(ha)) {
 		WRT_REG_DWORD(&reg->isp24.req_q_in, ha->req_ring_index);
 		RD_REG_DWORD_RELAXED(&reg->isp24.req_q_in);
 	} else {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 0ba4c8d..fa21cd8 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -336,7 +336,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 
 		ha->isp_ops.fw_dump(ha, 1);
 
-		if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+		if (IS_FWI2_CAPABLE(ha)) {
 			if (mb[1] == 0 && mb[2] == 0) {
 				qla_printk(KERN_ERR, ha,
 				    "Unrecoverable Hardware Error: adapter "
@@ -601,7 +601,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		    "scsi(%ld): [R|Z]IO update completion.\n",
 		    ha->host_no));
 
-		if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+		if (IS_FWI2_CAPABLE(ha))
 			qla24xx_process_response_queue(ha);
 		else
 			qla2x00_process_response_queue(ha);
@@ -823,7 +823,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 
 	sts = (sts_entry_t *) pkt;
 	sts24 = (struct sts_entry_24xx *) pkt;
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+	if (IS_FWI2_CAPABLE(ha)) {
 		comp_status = le16_to_cpu(sts24->comp_status);
 		scsi_status = le16_to_cpu(sts24->scsi_status) & SS_MASK;
 	} else {
@@ -872,7 +872,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 	fcport = sp->fcport;
 
 	sense_len = rsp_info_len = resid_len = fw_resid_len = 0;
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+	if (IS_FWI2_CAPABLE(ha)) {
 		sense_len = le32_to_cpu(sts24->sense_len);
 		rsp_info_len = le32_to_cpu(sts24->rsp_data_len);
 		resid_len = le32_to_cpu(sts24->rsp_residual_count);
@@ -891,7 +891,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 	/* Check for any FCP transport errors. */
 	if (scsi_status & SS_RESPONSE_INFO_LEN_VALID) {
 		/* Sense data lies beyond any FCP RESPONSE data. */
-		if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+		if (IS_FWI2_CAPABLE(ha))
 			sense_data += rsp_info_len;
 		if (rsp_info_len > 3 && rsp_info[3]) {
 			DEBUG2(printk("scsi(%ld:%d:%d:%d) FCP I/O protocol "
@@ -990,7 +990,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 	case CS_DATA_UNDERRUN:
 		resid = resid_len;
 		/* Use F/W calculated residual length. */
-		if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+		if (IS_FWI2_CAPABLE(ha))
 			resid = fw_resid_len;
 
 		if (scsi_status & SS_RESIDUAL_UNDER) {
@@ -1166,7 +1166,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 	case CS_TIMEOUT:
 		cp->result = DID_BUS_BUSY << 16;
 
-		if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+		if (IS_FWI2_CAPABLE(ha)) {
 			DEBUG2(printk(KERN_INFO
 			    "scsi(%ld:%d:%d:%d): TIMEOUT status detected "
 			    "0x%x-0x%x\n", ha->host_no, cp->device->channel,
@@ -1235,7 +1235,7 @@ qla2x00_status_cont_entry(scsi_qla_host_t *ha, sts_cont_entry_t *pkt)
 		}
 
 		/* Move sense data. */
-		if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+		if (IS_FWI2_CAPABLE(ha))
 			host_to_fcp_swap(pkt->data, sizeof(pkt->data));
 		memcpy(sp->request_sense_ptr, pkt->data, sense_sz);
 		DEBUG5(qla2x00_dump_buffer(sp->request_sense_ptr, sense_sz));
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 2cd0cff..321acc2 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -90,7 +90,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	/* Load mailbox registers. */
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+	if (IS_FWI2_CAPABLE(ha))
 		optr = (uint16_t __iomem *)&reg->isp24.mailbox0;
 	else
 		optr = (uint16_t __iomem *)MAILBOX_REG(ha, &reg->isp, 0);
@@ -154,7 +154,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 
 		set_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
 
-		if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+		if (IS_FWI2_CAPABLE(ha))
 			WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_SET_HOST_INT);
 		else
 			WRT_REG_WORD(&reg->isp.hccr, HCCR_SET_HOST_INT);
@@ -175,7 +175,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 		DEBUG3_11(printk("%s(%ld): cmd=%x POLLING MODE.\n", __func__,
 		    ha->host_no, command));
 
-		if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+		if (IS_FWI2_CAPABLE(ha))
 			WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_SET_HOST_INT);
 		else
 			WRT_REG_WORD(&reg->isp.hccr, HCCR_SET_HOST_INT);
@@ -228,7 +228,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 		uint16_t mb0;
 		uint32_t ictrl;
 
-		if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+		if (IS_FWI2_CAPABLE(ha)) {
 			mb0 = RD_REG_WORD(&reg->isp24.mailbox0);
 			ictrl = RD_REG_DWORD(&reg->isp24.ictrl);
 		} else {
@@ -322,7 +322,7 @@ qla2x00_load_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t risc_addr,
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
-	if (MSW(risc_addr) || IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+	if (MSW(risc_addr) || IS_FWI2_CAPABLE(ha)) {
 		mcp->mb[0] = MBC_LOAD_RISC_RAM_EXTENDED;
 		mcp->mb[8] = MSW(risc_addr);
 		mcp->out_mb = MBX_8|MBX_0;
@@ -336,7 +336,7 @@ qla2x00_load_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t risc_addr,
 	mcp->mb[6] = MSW(MSD(req_dma));
 	mcp->mb[7] = LSW(MSD(req_dma));
 	mcp->out_mb |= MBX_7|MBX_6|MBX_3|MBX_2|MBX_1;
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+	if (IS_FWI2_CAPABLE(ha)) {
 		mcp->mb[4] = MSW(risc_code_size);
 		mcp->mb[5] = LSW(risc_code_size);
 		mcp->out_mb |= MBX_5|MBX_4;
@@ -387,7 +387,7 @@ qla2x00_execute_fw(scsi_qla_host_t *ha, uint32_t risc_addr)
 	mcp->mb[0] = MBC_EXECUTE_FIRMWARE;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_0;
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+	if (IS_FWI2_CAPABLE(ha)) {
 		mcp->mb[1] = MSW(risc_addr);
 		mcp->mb[2] = LSW(risc_addr);
 		mcp->mb[3] = 0;
@@ -410,7 +410,7 @@ qla2x00_execute_fw(scsi_qla_host_t *ha, uint32_t risc_addr)
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x.\n", __func__,
 		    ha->host_no, rval, mcp->mb[0]));
 	} else {
-		if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+		if (IS_FWI2_CAPABLE(ha)) {
 			DEBUG11(printk("%s(%ld): done exchanges=%x.\n",
 			    __func__, ha->host_no, mcp->mb[1]));
 		} else {
@@ -551,7 +551,7 @@ qla2x00_set_fw_options(scsi_qla_host_t *ha, uint16_t *fwopts)
 	mcp->mb[3] = fwopts[3];
 	mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+	if (IS_FWI2_CAPABLE(ha)) {
 		mcp->in_mb |= MBX_1;
 	} else {
 		mcp->mb[10] = fwopts[10];
@@ -664,7 +664,7 @@ qla2x00_verify_checksum(scsi_qla_host_t *ha, uint32_t risc_addr)
 	mcp->mb[0] = MBC_VERIFY_CHECKSUM;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_0;
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+	if (IS_FWI2_CAPABLE(ha)) {
 		mcp->mb[1] = MSW(risc_addr);
 		mcp->mb[2] = LSW(risc_addr);
 		mcp->out_mb |= MBX_2|MBX_1;
@@ -681,8 +681,8 @@ qla2x00_verify_checksum(scsi_qla_host_t *ha, uint32_t risc_addr)
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x chk sum=%x.\n", __func__,
-		    ha->host_no, rval, (IS_QLA24XX(ha) || IS_QLA54XX(ha) ?
-		    (mcp->mb[2] << 16) | mcp->mb[1]: mcp->mb[1])));
+		    ha->host_no, rval, IS_FWI2_CAPABLE(ha) ?
+		    (mcp->mb[2] << 16) | mcp->mb[1]: mcp->mb[1]));
 	} else {
 		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
 	}
@@ -739,7 +739,7 @@ qla2x00_issue_iocb(scsi_qla_host_t *ha, void*  buffer, dma_addr_t phys_addr,
 
 		/* Mask reserved bits. */
 		sts_entry->entry_status &=
-		    IS_QLA24XX(ha) || IS_QLA54XX(ha) ? RF_MASK_24XX :RF_MASK;
+		    IS_FWI2_CAPABLE(ha) ? RF_MASK_24XX :RF_MASK;
 	}
 
 	return rval;
@@ -1085,7 +1085,7 @@ qla2x00_get_port_database(scsi_qla_host_t *ha, fc_port_t *fcport, uint8_t opt)
 	memset(pd, 0, max(PORT_DATABASE_SIZE, PORT_DATABASE_24XX_SIZE));
 
 	mcp->mb[0] = MBC_GET_PORT_DATABASE;
-	if (opt != 0 && !IS_QLA24XX(ha) && !IS_QLA54XX(ha))
+	if (opt != 0 && !IS_FWI2_CAPABLE(ha))
 		mcp->mb[0] = MBC_ENHANCED_GET_PORT_DATABASE;
 	mcp->mb[2] = MSW(pd_dma);
 	mcp->mb[3] = LSW(pd_dma);
@@ -1094,7 +1094,7 @@ qla2x00_get_port_database(scsi_qla_host_t *ha, fc_port_t *fcport, uint8_t opt)
 	mcp->mb[9] = ha->vp_idx;
 	mcp->out_mb = MBX_9|MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
 	mcp->in_mb = MBX_0;
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+	if (IS_FWI2_CAPABLE(ha)) {
 		mcp->mb[1] = fcport->loop_id;
 		mcp->mb[10] = opt;
 		mcp->out_mb |= MBX_10|MBX_1;
@@ -1107,15 +1107,15 @@ qla2x00_get_port_database(scsi_qla_host_t *ha, fc_port_t *fcport, uint8_t opt)
 		mcp->mb[1] = fcport->loop_id << 8 | opt;
 		mcp->out_mb |= MBX_1;
 	}
-	mcp->buf_size = (IS_QLA24XX(ha) || IS_QLA54XX(ha) ?
-	    PORT_DATABASE_24XX_SIZE : PORT_DATABASE_SIZE);
+	mcp->buf_size = IS_FWI2_CAPABLE(ha) ?
+	    PORT_DATABASE_24XX_SIZE : PORT_DATABASE_SIZE;
 	mcp->flags = MBX_DMA_IN;
 	mcp->tov = (ha->login_timeout * 2) + (ha->login_timeout / 2);
 	rval = qla2x00_mailbox_command(ha, mcp);
 	if (rval != QLA_SUCCESS)
 		goto gpd_error_out;
 
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+	if (IS_FWI2_CAPABLE(ha)) {
 		pd24 = (struct port_database_24xx *) pd;
 
 		/* Check for logged in state. */
@@ -1333,7 +1333,7 @@ qla2x00_lip_reset(scsi_qla_host_t *ha)
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+	if (IS_FWI2_CAPABLE(ha)) {
 		mcp->mb[0] = MBC_LIP_FULL_LOGIN;
 		mcp->mb[1] = BIT_6;
 		mcp->mb[2] = 0;
@@ -1637,7 +1637,7 @@ qla2x00_login_local_device(scsi_qla_host_t *ha, fc_port_t *fcport,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+	if (IS_FWI2_CAPABLE(ha))
 		return qla24xx_login_fabric(ha, fcport->loop_id,
 		    fcport->d_id.b.domain, fcport->d_id.b.area,
 		    fcport->d_id.b.al_pa, mb_ret, opt);
@@ -1821,7 +1821,7 @@ qla2x00_full_login_lip(scsi_qla_host_t *ha)
 	    ha->host_no));
 
 	mcp->mb[0] = MBC_LIP_FULL_LOGIN;
-	mcp->mb[1] = IS_QLA24XX(ha) || IS_QLA54XX(ha) ? BIT_3: 0;
+	mcp->mb[1] = IS_FWI2_CAPABLE(ha) ? BIT_3: 0;
 	mcp->mb[2] = 0;
 	mcp->mb[3] = 0;
 	mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
@@ -1871,7 +1871,7 @@ qla2x00_get_id_list(scsi_qla_host_t *ha, void *id_list, dma_addr_t id_list_dma,
 
 	mcp->mb[0] = MBC_GET_ID_LIST;
 	mcp->out_mb = MBX_0;
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+	if (IS_FWI2_CAPABLE(ha)) {
 		mcp->mb[2] = MSW(id_list_dma);
 		mcp->mb[3] = LSW(id_list_dma);
 		mcp->mb[6] = MSW(MSD(id_list_dma));
@@ -2063,7 +2063,7 @@ qla2x00_get_link_status(scsi_qla_host_t *ha, uint16_t loop_id,
 	mcp->mb[7] = LSW(MSD(stat_buf_dma));
 	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
 	mcp->in_mb = MBX_0;
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+	if (IS_FWI2_CAPABLE(ha)) {
 		mcp->mb[1] = loop_id;
 		mcp->mb[4] = 0;
 		mcp->mb[10] = 0;
@@ -2334,7 +2334,7 @@ qla2x00_system_error(scsi_qla_host_t *ha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
+	if (!IS_FWI2_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
@@ -2444,7 +2444,7 @@ qla2x00_stop_firmware(scsi_qla_host_t *ha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
+	if (!IS_FWI2_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
@@ -2474,7 +2474,7 @@ qla2x00_trace_control(scsi_qla_host_t *ha, uint16_t ctrl, dma_addr_t eft_dma,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
+	if (!IS_FWI2_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
@@ -2514,7 +2514,7 @@ qla2x00_read_sfp(scsi_qla_host_t *ha, dma_addr_t sfp_dma, uint16_t addr,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
+	if (!IS_FWI2_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b5a77b0..e246f94 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1238,19 +1238,23 @@ qla2x00_set_isp_flags(scsi_qla_host_t *ha)
 	case PCI_DEVICE_ID_QLOGIC_ISP2422:
 		ha->device_type |= DT_ISP2422;
 		ha->device_type |= DT_ZIO_SUPPORTED;
+		ha->device_type |= DT_FWI2;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP2432:
 		ha->device_type |= DT_ISP2432;
 		ha->device_type |= DT_ZIO_SUPPORTED;
+		ha->device_type |= DT_FWI2;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP5422:
 		ha->device_type |= DT_ISP5422;
+		ha->device_type |= DT_FWI2;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	case PCI_DEVICE_ID_QLOGIC_ISP5432:
 		ha->device_type |= DT_ISP5432;
+		ha->device_type |= DT_FWI2;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
 	}
@@ -1632,7 +1636,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	reg = ha->iobase;
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+	if (IS_FWI2_CAPABLE(ha)) {
 		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_HOST_INT);
 		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_RISC_INT);
 	} else {
@@ -2025,7 +2029,7 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 			}
 			memset(ha->ct_sns, 0, sizeof(struct ct_sns_pkt));
 
-			if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
+			if (IS_FWI2_CAPABLE(ha)) {
 				/*
 				 * Get consistent memory allocated for SFP
 				 * block.
-- 
1.5.3.rc2.4.g726f9

