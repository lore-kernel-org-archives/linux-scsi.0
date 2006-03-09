From: andrew.vasquez@qlogic.com
Subject: [PATCH 02/10] qla2xxx: Add ISP54xx support.
Date: Thu, 9 Mar 2006 14:27:13 -0800
Message-ID: <11419432283039-git-send-email-andrew.vasquez@qlogic.com>
References: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:32324 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1751950AbWCIW1O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2006 17:27:14 -0500
In-Reply-To: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Chip is similar in form to our ISP24xx offering.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/ql2400.c     |   27 ++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_attr.c   |    8 ++++---
 drivers/scsi/qla2xxx/qla_def.h    |   12 +++++------
 drivers/scsi/qla2xxx/qla_gs.c     |   10 ++++-----
 drivers/scsi/qla2xxx/qla_init.c   |   14 ++++++------
 drivers/scsi/qla2xxx/qla_inline.h |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c   |    6 +++--
 drivers/scsi/qla2xxx/qla_isr.c    |   16 +++++++-------
 drivers/scsi/qla2xxx/qla_mbx.c    |   42 +++++++++++++++++++------------------
 drivers/scsi/qla2xxx/qla_os.c     |   18 ++++++++++------
 include/linux/pci_ids.h           |    2 ++
 11 files changed, 94 insertions(+), 63 deletions(-)

d61aa074063826e5737f9c16f7516821ed55f564
diff --git a/drivers/scsi/qla2xxx/ql2400.c b/drivers/scsi/qla2xxx/ql2400.c
index 6c7165f..77914fc 100644
--- a/drivers/scsi/qla2xxx/ql2400.c
+++ b/drivers/scsi/qla2xxx/ql2400.c
@@ -49,6 +49,18 @@ static struct qla_board_info qla_board_t
 		.fw_info	= qla_fw_tbl,
 		.fw_fname	= "ql2400_fw.bin",
 	},
+	{
+		.drv_name	= qla_driver_name,
+		.isp_name	= "ISP5422",
+		.fw_info	= qla_fw_tbl,
+		.fw_fname	= "ql2400_fw.bin",
+	},
+	{
+		.drv_name	= qla_driver_name,
+		.isp_name	= "ISP5432",
+		.fw_info	= qla_fw_tbl,
+		.fw_fname	= "ql2400_fw.bin",
+	},
 };
 
 static struct pci_device_id qla24xx_pci_tbl[] = {
@@ -66,6 +78,21 @@ static struct pci_device_id qla24xx_pci_
 		.subdevice	= PCI_ANY_ID,
 		.driver_data	= (unsigned long)&qla_board_tbl[1],
 	},
+	{
+		.vendor		= PCI_VENDOR_ID_QLOGIC,
+		.device		= PCI_DEVICE_ID_QLOGIC_ISP5422,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (unsigned long)&qla_board_tbl[2],
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_QLOGIC,
+		.device		= PCI_DEVICE_ID_QLOGIC_ISP5432,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (unsigned long)&qla_board_tbl[3],
+	},
+
 	{0, 0},
 };
 MODULE_DEVICE_TABLE(pci, qla24xx_pci_tbl);
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 92b3e13..2b9e329 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -50,7 +50,7 @@ qla2x00_sysfs_write_fw_dump(struct kobje
 			    ha->host_no);
 
 			vfree(ha->fw_dump_buffer);
-			if (!IS_QLA24XX(ha) && !IS_QLA25XX(ha))
+			if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
 				free_pages((unsigned long)ha->fw_dump,
 				    ha->fw_dump_order);
 
@@ -64,7 +64,7 @@ qla2x00_sysfs_write_fw_dump(struct kobje
 		if ((ha->fw_dump || ha->fw_dumped) && !ha->fw_dump_reading) {
 			ha->fw_dump_reading = 1;
 
-			if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+			if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
 				dump_size = FW_DUMP_SIZE_24XX;
 			else {
 				dump_size = FW_DUMP_SIZE_1M;
@@ -138,7 +138,7 @@ qla2x00_sysfs_write_nvram(struct kobject
 		return 0;
 
 	/* Checksum NVRAM. */
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		uint32_t *iter;
 		uint32_t chksum;
 
@@ -750,7 +750,7 @@ qla2x00_get_fc_host_stats(struct Scsi_Ho
 	pfc_host_stat = &ha->fc_host_stat;
 	memset(pfc_host_stat, -1, sizeof(struct fc_host_statistics));
 
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		rval = qla24xx_get_isp_stats(ha, (uint32_t *)&stat_buf,
 		    sizeof(stat_buf) / 4, mb_stat);
 	} else {
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 00b7e82..e1a7769 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2234,9 +2234,9 @@ typedef struct scsi_qla_host {
 #define DT_ISP6322			BIT_6
 #define DT_ISP2422			BIT_7
 #define DT_ISP2432			BIT_8
-#define DT_ISP2512			BIT_9
-#define DT_ISP2522			BIT_10
-#define DT_ISP_LAST			(DT_ISP2522 << 1)
+#define DT_ISP5422			BIT_9
+#define DT_ISP5432			BIT_10
+#define DT_ISP_LAST			(DT_ISP5432 << 1)
 
 #define DT_OEM_001			BIT_29
 #define DT_ISP2200A			BIT_30
@@ -2252,13 +2252,13 @@ typedef struct scsi_qla_host {
 #define IS_QLA6322(ha)	(DT_MASK(ha) & DT_ISP6322)
 #define IS_QLA2422(ha)	(DT_MASK(ha) & DT_ISP2422)
 #define IS_QLA2432(ha)	(DT_MASK(ha) & DT_ISP2432)
-#define IS_QLA2512(ha)	(DT_MASK(ha) & DT_ISP2512)
-#define IS_QLA2522(ha)	(DT_MASK(ha) & DT_ISP2522)
+#define IS_QLA5422(ha)	(DT_MASK(ha) & DT_ISP5422)
+#define IS_QLA5432(ha)	(DT_MASK(ha) & DT_ISP5432)
 
 #define IS_QLA23XX(ha)	(IS_QLA2300(ha) || IS_QLA2312(ha) || IS_QLA2322(ha) || \
     			 IS_QLA6312(ha) || IS_QLA6322(ha))
 #define IS_QLA24XX(ha)	(IS_QLA2422(ha) || IS_QLA2432(ha))
-#define IS_QLA25XX(ha)	(IS_QLA2512(ha) || IS_QLA2522(ha))
+#define IS_QLA54XX(ha)	(IS_QLA5422(ha) || IS_QLA5432(ha))
 
 #define IS_OEM_001(ha)		((ha)->device_type & DT_OEM_001)
 #define HAS_EXTENDED_IDS(ha)	((ha)->device_type & DT_EXTENDED_IDS)
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index d620a8e..2ebf259 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -126,7 +126,7 @@ qla2x00_chk_ms_status(scsi_qla_host_t *h
 		DEBUG2_3(printk("scsi(%ld): %s failed, error status (%x).\n",
 		    ha->host_no, routine, ms_pkt->entry_status));
 	} else {
-		if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+		if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
 			comp_status =
 			    ((struct ct_entry_24xx *)ms_pkt)->comp_status;
 		else
@@ -1200,7 +1200,7 @@ qla2x00_update_ms_fdmi_iocb(scsi_qla_hos
 	ms_iocb_entry_t *ms_pkt = ha->ms_iocb;
 	struct ct_entry_24xx *ct_pkt = (struct ct_entry_24xx *)ha->ms_iocb;
 
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		ct_pkt->cmd_byte_count = cpu_to_le32(req_size);
 		ct_pkt->dseg_0_len = ct_pkt->cmd_byte_count;
 	} else {
@@ -1529,9 +1529,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_PORT_SUPPORT_SPEED);
 	eiter->len = __constant_cpu_to_be16(4 + 4);
-	if (IS_QLA25XX(ha))
-		eiter->a.sup_speed = __constant_cpu_to_be32(8);
-	else if (IS_QLA24XX(ha))
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
 		eiter->a.sup_speed = __constant_cpu_to_be32(4);
 	else if (IS_QLA23XX(ha))
 		eiter->a.sup_speed = __constant_cpu_to_be32(2);
@@ -1566,7 +1564,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_PORT_MAX_FRAME_SIZE);
 	eiter->len = __constant_cpu_to_be16(4 + 4);
-	max_frame_size = IS_QLA24XX(ha) || IS_QLA25XX(ha) ?
+	max_frame_size = IS_QLA24XX(ha) || IS_QLA54XX(ha) ?
 		(uint32_t) icb24->frame_payload_size:
 		(uint32_t) ha->init_cb->frame_payload_size;
 	eiter->a.max_frame_size = cpu_to_be32(max_frame_size);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f49eb06..e6a2292 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -387,7 +387,7 @@ qla2x00_isp_firmware(scsi_qla_host_t *ha
 
 		/* Verify checksum of loaded RISC code. */
 		rval = qla2x00_verify_checksum(ha,
-		    IS_QLA24XX(ha) || IS_QLA25XX(ha) ? RISC_SADDRESS :
+		    IS_QLA24XX(ha) || IS_QLA54XX(ha) ? RISC_SADDRESS :
 		    *ha->brd_info->fw_info[0].fwstart);
 	}
 
@@ -822,7 +822,7 @@ qla2x00_resize_request_q(scsi_qla_host_t
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
 		return;
 
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
 		qla2x00_alloc_fw_dump(ha);
 
 	/* Retrieve IOCB counts available to the firmware. */
@@ -2123,7 +2123,7 @@ qla2x00_configure_fabric(scsi_qla_host_t
 	LIST_HEAD(new_fcports);
 
 	/* If FL port exists, then SNS is present */
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
 		loop_id = NPH_F_PORT;
 	else
 		loop_id = SNS_FL_PORT;
@@ -2149,7 +2149,7 @@ qla2x00_configure_fabric(scsi_qla_host_t
 			qla2x00_fdmi_register(ha);
 
 		/* Ensure we are logged into the SNS. */
-		if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+		if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
 			loop_id = NPH_SNS;
 		else
 			loop_id = SIMPLE_NAME_SERVER;
@@ -2640,7 +2640,7 @@ qla2x00_device_resync(scsi_qla_host_t *h
 			if (ql2xprocessrscn &&
 			    !IS_QLA2100(ha) && !IS_QLA2200(ha) &&
 			    !IS_QLA6312(ha) && !IS_QLA6322(ha) &&
-			    !IS_QLA24XX(ha) && !IS_QLA25XX(ha) &&
+			    !IS_QLA24XX(ha) && !IS_QLA54XX(ha) &&
 			    ha->flags.init_done) {
 				/* Handle port RSCN via asyncronous IOCBs */
 				rval2 = qla2x00_handle_port_rscn(ha, rscn_entry,
@@ -3130,7 +3130,7 @@ qla2x00_restart_isp(scsi_qla_host_t *ha)
 
 			spin_lock_irqsave(&ha->hardware_lock, flags);
 
-			if (!IS_QLA24XX(ha) && !IS_QLA25XX(ha)) {
+			if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha)) {
 				/*
 				 * Disable SRAM, Instruction RAM and GP RAM
 				 * parity.
@@ -3146,7 +3146,7 @@ qla2x00_restart_isp(scsi_qla_host_t *ha)
 
 			spin_lock_irqsave(&ha->hardware_lock, flags);
 
-			if (!IS_QLA24XX(ha) && !IS_QLA25XX(ha)) {
+			if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha)) {
 				/* Enable proper parity */
 				if (IS_QLA2300(ha))
 					/* SRAM parity */
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index ecc3741..45007ee 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -163,7 +163,7 @@ static inline int qla2x00_is_reserved_id
 static inline int
 qla2x00_is_reserved_id(scsi_qla_host_t *ha, uint16_t loop_id)
 {
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
 		return (loop_id > NPH_LAST_HANDLE);
 
 	return ((loop_id > ha->last_loop_id && loop_id < SNS_FIRST_LOOP_ID) ||
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 6544b6d..8f0f4a2 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -466,7 +466,7 @@ __qla2x00_marker(scsi_qla_host_t *ha, ui
 	mrk->entry_type = MARKER_TYPE;
 	mrk->modifier = type;
 	if (type != MK_SYNC_ALL) {
-		if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 			mrk24 = (struct mrk_entry_24xx *) mrk;
 			mrk24->nport_handle = cpu_to_le16(loop_id);
 			mrk24->lun[1] = LSB(lun);
@@ -519,7 +519,7 @@ qla2x00_req_pkt(scsi_qla_host_t *ha)
 	for (timer = HZ; timer; timer--) {
 		if ((req_cnt + 2) >= ha->req_q_cnt) {
 			/* Calculate number of free request entries. */
-			if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+			if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
 				cnt = (uint16_t)RD_REG_DWORD(
 				    &reg->isp24.req_q_out);
 			else
@@ -593,7 +593,7 @@ qla2x00_isp_cmd(scsi_qla_host_t *ha)
 		ha->request_ring_ptr++;
 
 	/* Set chip new ring index. */
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		WRT_REG_DWORD(&reg->isp24.req_q_in, ha->req_ring_index);
 		RD_REG_DWORD_RELAXED(&reg->isp24.req_q_in);
 	} else {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c15458c..2003dbb 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -343,7 +343,7 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 
 		ha->isp_ops.fw_dump(ha, 1);
 
-		if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 			if (mb[1] == 0 && mb[2] == 0) {
 				qla_printk(KERN_ERR, ha,
 				    "Unrecoverable Hardware Error: adapter "
@@ -521,7 +521,7 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		 */
 		if (ql2xprocessrscn &&
 		    !IS_QLA2100(ha) && !IS_QLA2200(ha) && !IS_QLA6312(ha) &&
-		    !IS_QLA6322(ha) && !IS_QLA24XX(ha) && !IS_QLA25XX(ha) &&
+		    !IS_QLA6322(ha) && !IS_QLA24XX(ha) && !IS_QLA54XX(ha) &&
 		    ha->flags.init_done && mb[1] != 0xffff &&
 		    ((ha->operating_mode == P2P && mb[1] != 0) ||
 		    (ha->operating_mode != P2P && mb[1] !=
@@ -638,7 +638,7 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		    "scsi(%ld): [R|Z]IO update completion.\n",
 		    ha->host_no));
 
-		if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+		if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
 			qla24xx_process_response_queue(ha);
 		else
 			qla2x00_process_response_queue(ha);
@@ -810,7 +810,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 
 	sts = (sts_entry_t *) pkt;
 	sts24 = (struct sts_entry_24xx *) pkt;
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		comp_status = le16_to_cpu(sts24->comp_status);
 		scsi_status = le16_to_cpu(sts24->scsi_status) & SS_MASK;
 	} else {
@@ -860,7 +860,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 	fcport = sp->fcport;
 
 	sense_len = rsp_info_len = resid_len = 0;
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		sense_len = le32_to_cpu(sts24->sense_len);
 		rsp_info_len = le32_to_cpu(sts24->rsp_data_len);
 		resid_len = le32_to_cpu(sts24->rsp_residual_count);
@@ -878,7 +878,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 	/* Check for any FCP transport errors. */
 	if (scsi_status & SS_RESPONSE_INFO_LEN_VALID) {
 		/* Sense data lies beyond any FCP RESPONSE data. */
-		if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+		if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
 			sense_data += rsp_info_len;
 		if (rsp_info_len > 3 && rsp_info[3]) {
 			DEBUG2(printk("scsi(%ld:%d:%d:%d) FCP I/O protocol "
@@ -1117,7 +1117,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 	case CS_TIMEOUT:
 		cp->result = DID_BUS_BUSY << 16;
 
-		if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 			DEBUG2(printk(KERN_INFO
 			    "scsi(%ld:%d:%d:%d): TIMEOUT status detected "
 			    "0x%x-0x%x\n", ha->host_no, cp->device->channel,
@@ -1197,7 +1197,7 @@ qla2x00_status_cont_entry(scsi_qla_host_
 		}
 
 		/* Move sense data. */
-		if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+		if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
 			host_to_fcp_swap(pkt->data, sizeof(pkt->data));
 		memcpy(sp->request_sense_ptr, pkt->data, sense_sz);
 		DEBUG5(qla2x00_dump_buffer(sp->request_sense_ptr, sense_sz));
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 584cc2f..267435f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -91,7 +91,7 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	/* Load mailbox registers. */
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
 		optr = (uint16_t __iomem *)&reg->isp24.mailbox0;
 	else
 		optr = (uint16_t __iomem *)MAILBOX_REG(ha, &reg->isp, 0);
@@ -155,7 +155,7 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 
 		set_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
 
-		if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+		if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
 			WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_SET_HOST_INT);
 		else
 			WRT_REG_WORD(&reg->isp.hccr, HCCR_SET_HOST_INT);
@@ -179,7 +179,7 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 		DEBUG3_11(printk("%s(%ld): cmd=%x POLLING MODE.\n", __func__,
 		    ha->host_no, command);)
 
-		if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+		if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
 			WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_SET_HOST_INT);
 		else
 			WRT_REG_WORD(&reg->isp.hccr, HCCR_SET_HOST_INT);
@@ -237,7 +237,7 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 		uint16_t mb0;
 		uint32_t ictrl;
 
-		if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 			mb0 = RD_REG_WORD(&reg->isp24.mailbox0);
 			ictrl = RD_REG_DWORD(&reg->isp24.ictrl);
 		} else {
@@ -334,7 +334,7 @@ qla2x00_load_ram(scsi_qla_host_t *ha, dm
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
-	if (MSW(risc_addr) || IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+	if (MSW(risc_addr) || IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		mcp->mb[0] = MBC_LOAD_RISC_RAM_EXTENDED;
 		mcp->mb[8] = MSW(risc_addr);
 		mcp->out_mb = MBX_8|MBX_0;
@@ -348,7 +348,7 @@ qla2x00_load_ram(scsi_qla_host_t *ha, dm
 	mcp->mb[6] = MSW(MSD(req_dma));
 	mcp->mb[7] = LSW(MSD(req_dma));
 	mcp->out_mb |= MBX_7|MBX_6|MBX_3|MBX_2|MBX_1;
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		mcp->mb[4] = MSW(risc_code_size);
 		mcp->mb[5] = LSW(risc_code_size);
 		mcp->out_mb |= MBX_5|MBX_4;
@@ -399,7 +399,7 @@ qla2x00_execute_fw(scsi_qla_host_t *ha, 
 	mcp->mb[0] = MBC_EXECUTE_FIRMWARE;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_0;
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		mcp->mb[1] = MSW(risc_addr);
 		mcp->mb[2] = LSW(risc_addr);
 		mcp->mb[3] = 0;
@@ -422,7 +422,7 @@ qla2x00_execute_fw(scsi_qla_host_t *ha, 
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x.\n", __func__,
 		    ha->host_no, rval, mcp->mb[0]));
 	} else {
-		if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 			DEBUG11(printk("%s(%ld): done exchanges=%x.\n",
 			    __func__, ha->host_no, mcp->mb[1]);)
 		} else {
@@ -563,7 +563,7 @@ qla2x00_set_fw_options(scsi_qla_host_t *
 	mcp->mb[3] = fwopts[3];
 	mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		mcp->in_mb |= MBX_1;
 	} else {
 		mcp->mb[10] = fwopts[10];
@@ -676,7 +676,7 @@ qla2x00_verify_checksum(scsi_qla_host_t 
 	mcp->mb[0] = MBC_VERIFY_CHECKSUM;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_0;
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		mcp->mb[1] = MSW(risc_addr);
 		mcp->mb[2] = LSW(risc_addr);
 		mcp->out_mb |= MBX_2|MBX_1;
@@ -693,7 +693,7 @@ qla2x00_verify_checksum(scsi_qla_host_t 
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x chk sum=%x.\n", __func__,
-		    ha->host_no, rval, (IS_QLA24XX(ha) || IS_QLA25XX(ha) ?
+		    ha->host_no, rval, (IS_QLA24XX(ha) || IS_QLA54XX(ha) ?
 		    (mcp->mb[2] << 16) | mcp->mb[1]: mcp->mb[1]));)
 	} else {
 		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no);)
@@ -751,7 +751,7 @@ qla2x00_issue_iocb(scsi_qla_host_t *ha, 
 
 		/* Mask reserved bits. */
 		sts_entry->entry_status &=
-		    IS_QLA24XX(ha) || IS_QLA25XX(ha) ? RF_MASK_24XX :RF_MASK;
+		    IS_QLA24XX(ha) || IS_QLA54XX(ha) ? RF_MASK_24XX :RF_MASK;
 	}
 
 	return rval;
@@ -1091,7 +1091,7 @@ qla2x00_get_port_database(scsi_qla_host_
 	memset(pd, 0, max(PORT_DATABASE_SIZE, PORT_DATABASE_24XX_SIZE));
 
 	mcp->mb[0] = MBC_GET_PORT_DATABASE;
-	if (opt != 0 && !IS_QLA24XX(ha) && !IS_QLA25XX(ha))
+	if (opt != 0 && !IS_QLA24XX(ha) && !IS_QLA54XX(ha))
 		mcp->mb[0] = MBC_ENHANCED_GET_PORT_DATABASE;
 	mcp->mb[2] = MSW(pd_dma);
 	mcp->mb[3] = LSW(pd_dma);
@@ -1099,7 +1099,7 @@ qla2x00_get_port_database(scsi_qla_host_
 	mcp->mb[7] = LSW(MSD(pd_dma));
 	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
 	mcp->in_mb = MBX_0;
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		mcp->mb[1] = fcport->loop_id;
 		mcp->mb[10] = opt;
 		mcp->out_mb |= MBX_10|MBX_1;
@@ -1112,7 +1112,7 @@ qla2x00_get_port_database(scsi_qla_host_
 		mcp->mb[1] = fcport->loop_id << 8 | opt;
 		mcp->out_mb |= MBX_1;
 	}
-	mcp->buf_size = (IS_QLA24XX(ha) || IS_QLA25XX(ha) ?
+	mcp->buf_size = (IS_QLA24XX(ha) || IS_QLA54XX(ha) ?
 	    PORT_DATABASE_24XX_SIZE : PORT_DATABASE_SIZE);
 	mcp->flags = MBX_DMA_IN;
 	mcp->tov = (ha->login_timeout * 2) + (ha->login_timeout / 2);
@@ -1120,7 +1120,7 @@ qla2x00_get_port_database(scsi_qla_host_
 	if (rval != QLA_SUCCESS)
 		goto gpd_error_out;
 
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		pd24 = (struct port_database_24xx *) pd;
 
 		/* Check for logged in state. */
@@ -1337,7 +1337,7 @@ qla2x00_lip_reset(scsi_qla_host_t *ha)
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
 
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		mcp->mb[0] = MBC_LIP_FULL_LOGIN;
 		mcp->mb[1] = BIT_0;
 		mcp->mb[2] = 0xff;
@@ -1866,7 +1866,7 @@ qla2x00_get_id_list(scsi_qla_host_t *ha,
 
 	mcp->mb[0] = MBC_GET_ID_LIST;
 	mcp->out_mb = MBX_0;
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		mcp->mb[2] = MSW(id_list_dma);
 		mcp->mb[3] = LSW(id_list_dma);
 		mcp->mb[6] = MSW(MSD(id_list_dma));
@@ -2057,7 +2057,7 @@ qla2x00_get_link_status(scsi_qla_host_t 
 	mcp->mb[7] = LSW(MSD(stat_buf_dma));
 	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
 	mcp->in_mb = MBX_0;
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		mcp->mb[1] = loop_id;
 		mcp->mb[4] = 0;
 		mcp->mb[10] = 0;
@@ -2324,7 +2324,7 @@ qla2x00_system_error(scsi_qla_host_t *ha
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_QLA24XX(ha) && !IS_QLA25XX(ha))
+	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
 		return QLA_FUNCTION_FAILED;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
@@ -2434,7 +2434,7 @@ qla2x00_stop_firmware(scsi_qla_host_t *h
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_QLA24XX(ha) && !IS_QLA25XX(ha))
+	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
 		return QLA_FUNCTION_FAILED;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 757c4c4..1316147 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1183,11 +1183,11 @@ qla2x00_set_isp_flags(scsi_qla_host_t *h
 	case PCI_DEVICE_ID_QLOGIC_ISP2432:
 		ha->device_type |= DT_ISP2432;
 		break;
-	case PCI_DEVICE_ID_QLOGIC_ISP2512:
-		ha->device_type |= DT_ISP2512;
+	case PCI_DEVICE_ID_QLOGIC_ISP5422:
+		ha->device_type |= DT_ISP5422;
 		break;
-	case PCI_DEVICE_ID_QLOGIC_ISP2522:
-		ha->device_type |= DT_ISP2522;
+	case PCI_DEVICE_ID_QLOGIC_ISP5432:
+		ha->device_type |= DT_ISP5432;
 		break;
 	}
 }
@@ -1433,7 +1433,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 		ha->gid_list_info_size = 6;
 		if (IS_QLA2322(ha) || IS_QLA6322(ha))
 			ha->optrom_size = OPTROM_SIZE_2322;
-	} else if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+	} else if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		host->max_id = MAX_TARGETS_2200;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
 		ha->request_q_length = REQUEST_ENTRY_CNT_24XX;
@@ -1559,7 +1559,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	reg = ha->iobase;
-	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_HOST_INT);
 		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_RISC_INT);
 	} else {
@@ -2631,7 +2631,7 @@ qla2x00_request_firmware(scsi_qla_host_t
 		blob = &qla_fw_blobs[FW_ISP2322];
 	} else if (IS_QLA6312(ha) || IS_QLA6322(ha)) {
 		blob = &qla_fw_blobs[FW_ISP63XX];
-	} else if (IS_QLA24XX(ha)) {
+	} else if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		blob = &qla_fw_blobs[FW_ISP24XX];
 	}
 
@@ -2687,6 +2687,10 @@ static struct pci_device_id qla2xxx_pci_
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2432,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP5422,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP5432,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0 },
 };
 MODULE_DEVICE_TABLE(pci, qla2xxx_pci_tbl);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 1709b50..a6fdbe1 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -852,6 +852,8 @@
 #define PCI_DEVICE_ID_QLOGIC_ISP2432	0x2432
 #define PCI_DEVICE_ID_QLOGIC_ISP2512	0x2512
 #define PCI_DEVICE_ID_QLOGIC_ISP2522	0x2522
+#define PCI_DEVICE_ID_QLOGIC_ISP5422	0x5422
+#define PCI_DEVICE_ID_QLOGIC_ISP5432	0x5432
 
 #define PCI_VENDOR_ID_CYRIX		0x1078
 #define PCI_DEVICE_ID_CYRIX_5510	0x0000
-- 
1.2.4.gf067


