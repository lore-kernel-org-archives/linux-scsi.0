From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 32/42] qla2xxx: ISP27xx queue index shadow registers.
Date: Fri, 11 Apr 2014 16:54:37 -0400
Message-ID: <1397249687-32666-33-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:16992 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754881AbaDKVcD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:03 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

For ISP27xx use the request/response queue index shadow registers
to avoid directly access them on the PCI bus.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    3 +++
 drivers/scsi/qla2xxx/qla_fw.h   |    5 ++++-
 drivers/scsi/qla2xxx/qla_init.c |    8 ++++++++
 drivers/scsi/qla2xxx/qla_iocb.c |   12 ++++++------
 drivers/scsi/qla2xxx/qla_mbx.c  |   10 ++++++++--
 drivers/scsi/qla2xxx/qla_tmpl.c |    6 ++++--
 6 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6c9724c..5c590d4 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2685,6 +2685,7 @@ struct rsp_que {
 	uint32_t __iomem *rsp_q_out;
 	uint16_t  ring_index;
 	uint16_t  out_ptr;
+	uint16_t  *in_ptr;		/* queue shadow in index */
 	uint16_t  length;
 	uint16_t  options;
 	uint16_t  rid;
@@ -2711,6 +2712,7 @@ struct req_que {
 	uint32_t __iomem *req_q_out;
 	uint16_t  ring_index;
 	uint16_t  in_ptr;
+	uint16_t  *out_ptr;		/* queue shadow out index */
 	uint16_t  cnt;
 	uint16_t  length;
 	uint16_t  options;
@@ -3019,6 +3021,7 @@ struct qla_hw_data {
     (((ha)->fw_attributes_h << 16 | (ha)->fw_attributes) & BIT_22))
 #define IS_ATIO_MSIX_CAPABLE(ha) (IS_QLA83XX(ha))
 #define IS_TGT_MODE_CAPABLE(ha)	(ha->tgt.atio_q_length)
+#define IS_SHADOW_REG_CAPABLE(ha)  (IS_QLA27XX(ha))
 
 	/* HBA serial number */
 	uint8_t		serial0;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index a9f86e7..2cdedd9 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -371,7 +371,10 @@ struct init_cb_24xx {
 	 * BIT 14 = Data Rate bit 1
 	 * BIT 15 = Data Rate bit 2
 	 * BIT 16 = Enable 75 ohm Termination Select
-	 * BIT 17-31 = Reserved
+	 * BIT 17-28 = Reserved
+	 * BIT 29 = Enable response queue 0 in index shadowing
+	 * BIT 30 = Enable request queue 0 out index shadowing
+	 * BIT 31 = Reserved
 	 */
 	uint32_t firmware_options_3;
 	uint16_t qos;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2d97d7c..20b569e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2062,6 +2062,10 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 	icb->atio_q_address[0] = cpu_to_le32(LSD(ha->tgt.atio_dma));
 	icb->atio_q_address[1] = cpu_to_le32(MSD(ha->tgt.atio_dma));
 
+	if (IS_SHADOW_REG_CAPABLE(ha))
+		icb->firmware_options_2 |=
+		    __constant_cpu_to_le32(BIT_30|BIT_29);
+
 	if (ha->mqenable || IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
 		icb->qos = __constant_cpu_to_le16(QLA_DEFAULT_QUE_QOS);
 		icb->rid = __constant_cpu_to_le16(rid);
@@ -2139,6 +2143,8 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 		req = ha->req_q_map[que];
 		if (!req)
 			continue;
+		req->out_ptr = (void *)(req->ring + req->length);
+		*req->out_ptr = 0;
 		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++)
 			req->outstanding_cmds[cnt] = NULL;
 
@@ -2154,6 +2160,8 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 		rsp = ha->rsp_q_map[que];
 		if (!rsp)
 			continue;
+		rsp->in_ptr = (void *)(rsp->ring + rsp->length);
+		*rsp->in_ptr = 0;
 		/* Initialize response queue entries */
 		if (IS_QLAFX00(ha))
 			qlafx00_init_response_q_entries(rsp);
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 8707a64..af83132 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1478,8 +1478,8 @@ qla24xx_start_scsi(srb_t *sp)
 	tot_dsds = nseg;
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 	if (req->cnt < (req_cnt + 2)) {
-		cnt = RD_REG_DWORD_RELAXED(req->req_q_out);
-
+		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
+		    RD_REG_DWORD_RELAXED(req->req_q_out);
 		if (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
 		else
@@ -1697,8 +1697,8 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	tot_prot_dsds = nseg;
 	tot_dsds += nseg;
 	if (req->cnt < (req_cnt + 2)) {
-		cnt = RD_REG_DWORD_RELAXED(req->req_q_out);
-
+		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
+		    RD_REG_DWORD_RELAXED(req->req_q_out);
 		if (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
 		else
@@ -2825,8 +2825,8 @@ qla2x00_start_bidir(srb_t *sp, struct scsi_qla_host *vha, uint32_t tot_dsds)
 
 	/* Check for room on request queue. */
 	if (req->cnt < req_cnt + 2) {
-		cnt = RD_REG_DWORD_RELAXED(req->req_q_out);
-
+		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
+		    RD_REG_DWORD_RELAXED(req->req_q_out);
 		if  (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
 		else
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 01d9f54..7f39e36 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3735,6 +3735,9 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req)
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10d3,
 	    "Entered %s.\n", __func__);
 
+	if (IS_SHADOW_REG_CAPABLE(ha))
+		req->options |= BIT_13;
+
 	mcp->mb[0] = MBC_INITIALIZE_MULTIQ;
 	mcp->mb[1] = req->options;
 	mcp->mb[2] = MSW(LSD(req->dma));
@@ -3754,7 +3757,7 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req)
 	/* que in ptr index */
 	mcp->mb[8] = 0;
 	/* que out ptr index */
-	mcp->mb[9] = 0;
+	mcp->mb[9] = *req->out_ptr = 0;
 	mcp->out_mb = MBX_14|MBX_13|MBX_12|MBX_11|MBX_10|MBX_9|MBX_8|MBX_7|
 			MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
@@ -3801,6 +3804,9 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10d6,
 	    "Entered %s.\n", __func__);
 
+	if (IS_SHADOW_REG_CAPABLE(ha))
+		rsp->options |= BIT_13;
+
 	mcp->mb[0] = MBC_INITIALIZE_MULTIQ;
 	mcp->mb[1] = rsp->options;
 	mcp->mb[2] = MSW(LSD(rsp->dma));
@@ -3815,7 +3821,7 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 
 	mcp->mb[4] = rsp->id;
 	/* que in ptr index */
-	mcp->mb[8] = 0;
+	mcp->mb[8] = *rsp->in_ptr = 0;
 	/* que out ptr index */
 	mcp->mb[9] = 0;
 	mcp->out_mb = MBX_14|MBX_13|MBX_9|MBX_8|MBX_7
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index a9fa9b7..cb9a0c4 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -679,7 +679,8 @@ qla27xx_fwdt_entry_t274(struct scsi_qla_host *vha,
 			if (req || !buf) {
 				qla27xx_insert16(i, buf, len);
 				qla27xx_insert16(1, buf, len);
-				qla27xx_insert32(0, buf, len);
+				qla27xx_insert32(req && req->out_ptr ?
+				    *req->out_ptr : 0, buf, len);
 				count++;
 			}
 		}
@@ -689,7 +690,8 @@ qla27xx_fwdt_entry_t274(struct scsi_qla_host *vha,
 			if (rsp || !buf) {
 				qla27xx_insert16(i, buf, len);
 				qla27xx_insert16(1, buf, len);
-				qla27xx_insert32(0, buf, len);
+				qla27xx_insert32(rsp && rsp->in_ptr ?
+				    *rsp->in_ptr : 0, buf, len);
 				count++;
 			}
 		}
-- 
1.7.7

