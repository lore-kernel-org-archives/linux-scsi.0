From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 02/21] lpfc: Correct RDP response sizing issue
Date: Wed, 06 Jul 2016 12:35:55 -0700
Message-ID: <577d5d9b.HMNnhIbUwXmez4gj%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36054 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466AbcGFTgD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:36:03 -0400
Received: by mail-wm0-f48.google.com with SMTP id f126so185559096wma.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:36:00 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id p191sm4156369wme.7.2016.07.06.12.35.57
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:35:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct RDP response sizing issue

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 113 ++++++++++++++++++++++++++++---------------
 drivers/scsi/lpfc/lpfc_hw.h  |  26 +++-------
 2 files changed, 81 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 300131a..0d05e1a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4609,7 +4609,7 @@ lpfc_els_disc_plogi(struct lpfc_vport *vport)
 	return sentplogi;
 }
 
-void
+uint32_t
 lpfc_rdp_res_link_service(struct fc_rdp_link_service_desc *desc,
 		uint32_t word0)
 {
@@ -4617,9 +4617,11 @@ lpfc_rdp_res_link_service(struct fc_rdp_link_service_desc *desc,
 	desc->tag = cpu_to_be32(RDP_LINK_SERVICE_DESC_TAG);
 	desc->payload.els_req = word0;
 	desc->length = cpu_to_be32(sizeof(desc->payload));
+
+	return sizeof(struct fc_rdp_link_service_desc);
 }
 
-void
+uint32_t
 lpfc_rdp_res_sfp_desc(struct fc_rdp_sfp_desc *desc,
 		uint8_t *page_a0, uint8_t *page_a2)
 {
@@ -4680,9 +4682,11 @@ lpfc_rdp_res_sfp_desc(struct fc_rdp_sfp_desc *desc,
 
 	desc->sfp_info.flags = cpu_to_be16(flag);
 	desc->length = cpu_to_be32(sizeof(desc->sfp_info));
+
+	return sizeof(struct fc_rdp_sfp_desc);
 }
 
-void
+uint32_t
 lpfc_rdp_res_link_error(struct fc_rdp_link_error_status_desc *desc,
 		READ_LNK_VAR *stat)
 {
@@ -4707,9 +4711,11 @@ lpfc_rdp_res_link_error(struct fc_rdp_link_error_status_desc *desc,
 	desc->info.link_status.invalid_crc_cnt = cpu_to_be32(stat->crcCnt);
 
 	desc->length = cpu_to_be32(sizeof(desc->info));
+
+	return sizeof(struct fc_rdp_link_error_status_desc);
 }
 
-void
+uint32_t
 lpfc_rdp_res_bbc_desc(struct fc_rdp_bbc_desc *desc, READ_LNK_VAR *stat,
 		      struct lpfc_vport *vport)
 {
@@ -4727,9 +4733,11 @@ lpfc_rdp_res_bbc_desc(struct fc_rdp_bbc_desc *desc, READ_LNK_VAR *stat,
 
 	desc->bbc_info.rtt = 0;
 	desc->length = cpu_to_be32(sizeof(desc->bbc_info));
+
+	return sizeof(struct fc_rdp_bbc_desc);
 }
 
-void
+uint32_t
 lpfc_rdp_res_oed_temp_desc(struct lpfc_hba *phba,
 			   struct fc_rdp_oed_sfp_desc *desc, uint8_t *page_a2)
 {
@@ -4757,9 +4765,10 @@ lpfc_rdp_res_oed_temp_desc(struct lpfc_hba *phba,
 	flags |= ((0xf & RDP_OED_TEMPERATURE) << RDP_OED_TYPE_SHIFT);
 	desc->oed_info.function_flags = cpu_to_be32(flags);
 	desc->length = cpu_to_be32(sizeof(desc->oed_info));
+	return sizeof(struct fc_rdp_oed_sfp_desc);
 }
 
-void
+uint32_t
 lpfc_rdp_res_oed_voltage_desc(struct lpfc_hba *phba,
 			      struct fc_rdp_oed_sfp_desc *desc,
 			      uint8_t *page_a2)
@@ -4788,9 +4797,10 @@ lpfc_rdp_res_oed_voltage_desc(struct lpfc_hba *phba,
 	flags |= ((0xf & RDP_OED_VOLTAGE) << RDP_OED_TYPE_SHIFT);
 	desc->oed_info.function_flags = cpu_to_be32(flags);
 	desc->length = cpu_to_be32(sizeof(desc->oed_info));
+	return sizeof(struct fc_rdp_oed_sfp_desc);
 }
 
-void
+uint32_t
 lpfc_rdp_res_oed_txbias_desc(struct lpfc_hba *phba,
 			     struct fc_rdp_oed_sfp_desc *desc,
 			     uint8_t *page_a2)
@@ -4819,9 +4829,10 @@ lpfc_rdp_res_oed_txbias_desc(struct lpfc_hba *phba,
 	flags |= ((0xf & RDP_OED_TXBIAS) << RDP_OED_TYPE_SHIFT);
 	desc->oed_info.function_flags = cpu_to_be32(flags);
 	desc->length = cpu_to_be32(sizeof(desc->oed_info));
+	return sizeof(struct fc_rdp_oed_sfp_desc);
 }
 
-void
+uint32_t
 lpfc_rdp_res_oed_txpower_desc(struct lpfc_hba *phba,
 			      struct fc_rdp_oed_sfp_desc *desc,
 			      uint8_t *page_a2)
@@ -4850,10 +4861,11 @@ lpfc_rdp_res_oed_txpower_desc(struct lpfc_hba *phba,
 	flags |= ((0xf & RDP_OED_TXPOWER) << RDP_OED_TYPE_SHIFT);
 	desc->oed_info.function_flags = cpu_to_be32(flags);
 	desc->length = cpu_to_be32(sizeof(desc->oed_info));
+	return sizeof(struct fc_rdp_oed_sfp_desc);
 }
 
 
-void
+uint32_t
 lpfc_rdp_res_oed_rxpower_desc(struct lpfc_hba *phba,
 			      struct fc_rdp_oed_sfp_desc *desc,
 			      uint8_t *page_a2)
@@ -4882,9 +4894,10 @@ lpfc_rdp_res_oed_rxpower_desc(struct lpfc_hba *phba,
 	flags |= ((0xf & RDP_OED_RXPOWER) << RDP_OED_TYPE_SHIFT);
 	desc->oed_info.function_flags = cpu_to_be32(flags);
 	desc->length = cpu_to_be32(sizeof(desc->oed_info));
+	return sizeof(struct fc_rdp_oed_sfp_desc);
 }
 
-void
+uint32_t
 lpfc_rdp_res_opd_desc(struct fc_rdp_opd_sfp_desc *desc,
 		      uint8_t *page_a0, struct lpfc_vport *vport)
 {
@@ -4895,9 +4908,10 @@ lpfc_rdp_res_opd_desc(struct fc_rdp_opd_sfp_desc *desc,
 	memcpy(desc->opd_info.revision, &page_a0[SSF_VENDOR_REV], 2);
 	memcpy(desc->opd_info.date, &page_a0[SSF_DATE_CODE], 8);
 	desc->length = cpu_to_be32(sizeof(desc->opd_info));
+	return sizeof(struct fc_rdp_opd_sfp_desc);
 }
 
-int
+uint32_t
 lpfc_rdp_res_fec_desc(struct fc_fec_rdp_desc *desc, READ_LNK_VAR *stat)
 {
 	if (bf_get(lpfc_read_link_stat_gec2, stat) == 0)
@@ -4914,7 +4928,7 @@ lpfc_rdp_res_fec_desc(struct fc_fec_rdp_desc *desc, READ_LNK_VAR *stat)
 	return sizeof(struct fc_fec_rdp_desc);
 }
 
-void
+uint32_t
 lpfc_rdp_res_speed(struct fc_rdp_port_speed_desc *desc, struct lpfc_hba *phba)
 {
 	uint16_t rdp_cap = 0;
@@ -4973,9 +4987,10 @@ lpfc_rdp_res_speed(struct fc_rdp_port_speed_desc *desc, struct lpfc_hba *phba)
 
 	desc->info.port_speed.capabilities = cpu_to_be16(rdp_cap);
 	desc->length = cpu_to_be32(sizeof(desc->info));
+	return sizeof(struct fc_rdp_port_speed_desc);
 }
 
-void
+uint32_t
 lpfc_rdp_res_diag_port_names(struct fc_rdp_port_name_desc *desc,
 		struct lpfc_hba *phba)
 {
@@ -4989,9 +5004,10 @@ lpfc_rdp_res_diag_port_names(struct fc_rdp_port_name_desc *desc,
 			sizeof(desc->port_names.wwpn));
 
 	desc->length = cpu_to_be32(sizeof(desc->port_names));
+	return sizeof(struct fc_rdp_port_name_desc);
 }
 
-void
+uint32_t
 lpfc_rdp_res_attach_port_names(struct fc_rdp_port_name_desc *desc,
 		struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
@@ -5012,6 +5028,7 @@ lpfc_rdp_res_attach_port_names(struct fc_rdp_port_name_desc *desc,
 	}
 
 	desc->length = cpu_to_be32(sizeof(desc->port_names));
+	return sizeof(struct fc_rdp_port_name_desc);
 }
 
 void
@@ -5026,9 +5043,9 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 	uint8_t *pcmd;
 	struct ls_rjt *stat;
 	struct fc_rdp_res_frame *rdp_res;
-	uint32_t cmdsize;
+	uint32_t cmdsize, len;
 	uint16_t *flag_ptr;
-	int rc, fec_size;
+	int rc;
 
 	if (status != SUCCESS)
 		goto error;
@@ -5066,38 +5083,54 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 	phba->sfp_warning |= *flag_ptr;
 
 	/* For RDP payload */
-	lpfc_rdp_res_link_service(&rdp_res->link_service_desc, ELS_CMD_RDP);
+	len = 8;
+	len += lpfc_rdp_res_link_service((struct fc_rdp_link_service_desc *)
+					 (len + pcmd), ELS_CMD_RDP);
 
-	lpfc_rdp_res_sfp_desc(&rdp_res->sfp_desc,
+	len += lpfc_rdp_res_sfp_desc((struct fc_rdp_sfp_desc *)(len + pcmd),
 			rdp_context->page_a0, rdp_context->page_a2);
-	lpfc_rdp_res_speed(&rdp_res->portspeed_desc, phba);
-	lpfc_rdp_res_link_error(&rdp_res->link_error_desc,
-				&rdp_context->link_stat);
-	lpfc_rdp_res_diag_port_names(&rdp_res->diag_port_names_desc, phba);
-	lpfc_rdp_res_attach_port_names(&rdp_res->attached_port_names_desc,
-				       vport, ndlp);
-	lpfc_rdp_res_bbc_desc(&rdp_res->bbc_desc, &rdp_context->link_stat,
-			      vport);
-	lpfc_rdp_res_oed_temp_desc(phba, &rdp_res->oed_temp_desc,
-				   rdp_context->page_a2);
-	lpfc_rdp_res_oed_voltage_desc(phba, &rdp_res->oed_voltage_desc,
-				      rdp_context->page_a2);
-	lpfc_rdp_res_oed_txbias_desc(phba, &rdp_res->oed_txbias_desc,
-				     rdp_context->page_a2);
-	lpfc_rdp_res_oed_txpower_desc(phba, &rdp_res->oed_txpower_desc,
-				      rdp_context->page_a2);
-	lpfc_rdp_res_oed_rxpower_desc(phba, &rdp_res->oed_rxpower_desc,
-				      rdp_context->page_a2);
-	lpfc_rdp_res_opd_desc(&rdp_res->opd_desc, rdp_context->page_a0, vport);
-	fec_size = lpfc_rdp_res_fec_desc(&rdp_res->fec_desc,
+	len += lpfc_rdp_res_speed((struct fc_rdp_port_speed_desc *)(len + pcmd),
+				  phba);
+	len += lpfc_rdp_res_link_error((struct fc_rdp_link_error_status_desc *)
+				       (len + pcmd), &rdp_context->link_stat);
+	len += lpfc_rdp_res_diag_port_names((struct fc_rdp_port_name_desc *)
+					     (len + pcmd), phba);
+	len += lpfc_rdp_res_attach_port_names((struct fc_rdp_port_name_desc *)
+					(len + pcmd), vport, ndlp);
+	len += lpfc_rdp_res_fec_desc((struct fc_fec_rdp_desc *)(len + pcmd),
 			&rdp_context->link_stat);
-	rdp_res->length = cpu_to_be32(fec_size + RDP_DESC_PAYLOAD_SIZE);
+	/* Check if nport is logged, BZ190632 */
+	if (!(ndlp->nlp_flag & NLP_RPI_REGISTERED))
+		goto lpfc_skip_descriptor;
+
+	len += lpfc_rdp_res_bbc_desc((struct fc_rdp_bbc_desc *)(len + pcmd),
+				     &rdp_context->link_stat, vport);
+	len += lpfc_rdp_res_oed_temp_desc(phba,
+				(struct fc_rdp_oed_sfp_desc *)(len + pcmd),
+				rdp_context->page_a2);
+	len += lpfc_rdp_res_oed_voltage_desc(phba,
+				(struct fc_rdp_oed_sfp_desc *)(len + pcmd),
+				rdp_context->page_a2);
+	len += lpfc_rdp_res_oed_txbias_desc(phba,
+				(struct fc_rdp_oed_sfp_desc *)(len + pcmd),
+				rdp_context->page_a2);
+	len += lpfc_rdp_res_oed_txpower_desc(phba,
+				(struct fc_rdp_oed_sfp_desc *)(len + pcmd),
+				rdp_context->page_a2);
+	len += lpfc_rdp_res_oed_rxpower_desc(phba,
+				(struct fc_rdp_oed_sfp_desc *)(len + pcmd),
+				rdp_context->page_a2);
+	len += lpfc_rdp_res_opd_desc((struct fc_rdp_opd_sfp_desc *)(len + pcmd),
+				     rdp_context->page_a0, vport);
+
+lpfc_skip_descriptor:
+	rdp_res->length = cpu_to_be32(len - 8);
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 
 	/* Now that we know the true size of the payload, update the BPL */
 	bpl = (struct ulp_bde64 *)
 		(((struct lpfc_dmabuf *)(elsiocb->context3))->virt);
-	bpl->tus.f.bdeSize = (fec_size + RDP_DESC_PAYLOAD_SIZE + 8);
+	bpl->tus.f.bdeSize = len;
 	bpl->tus.f.bdeFlags = 0;
 	bpl->tus.w = le32_to_cpu(bpl->tus.w);
 
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 5385faf..829a114 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1267,27 +1267,17 @@ struct fc_rdp_res_frame {
 	struct fc_rdp_link_error_status_desc link_error_desc; /* Word 13-21 */
 	struct fc_rdp_port_name_desc diag_port_names_desc;    /* Word 22-27 */
 	struct fc_rdp_port_name_desc attached_port_names_desc;/* Word 28-33 */
-	struct fc_rdp_bbc_desc bbc_desc;                      /* FC Word 34-38*/
-	struct fc_rdp_oed_sfp_desc oed_temp_desc;             /* FC Word 39-43*/
-	struct fc_rdp_oed_sfp_desc oed_voltage_desc;          /* FC word 44-48*/
-	struct fc_rdp_oed_sfp_desc oed_txbias_desc;           /* FC word 49-53*/
-	struct fc_rdp_oed_sfp_desc oed_txpower_desc;          /* FC word 54-58*/
-	struct fc_rdp_oed_sfp_desc oed_rxpower_desc;          /* FC word 59-63*/
-	struct fc_rdp_opd_sfp_desc opd_desc;                  /* FC word 64-80*/
-	struct fc_fec_rdp_desc fec_desc;                      /* FC word 81-84*/
+	struct fc_fec_rdp_desc fec_desc;                      /* FC word 34-37*/
+	struct fc_rdp_bbc_desc bbc_desc;                      /* FC Word 38-42*/
+	struct fc_rdp_oed_sfp_desc oed_temp_desc;             /* FC Word 43-47*/
+	struct fc_rdp_oed_sfp_desc oed_voltage_desc;          /* FC word 48-52*/
+	struct fc_rdp_oed_sfp_desc oed_txbias_desc;           /* FC word 53-57*/
+	struct fc_rdp_oed_sfp_desc oed_txpower_desc;          /* FC word 58-62*/
+	struct fc_rdp_oed_sfp_desc oed_rxpower_desc;          /* FC word 63-67*/
+	struct fc_rdp_opd_sfp_desc opd_desc;                  /* FC word 68-84*/
 };
 
 
-#define RDP_DESC_PAYLOAD_SIZE (sizeof(struct fc_rdp_link_service_desc) \
-				+ sizeof(struct fc_rdp_sfp_desc) \
-				+ sizeof(struct fc_rdp_port_speed_desc) \
-				+ sizeof(struct fc_rdp_link_error_status_desc) \
-				+ (sizeof(struct fc_rdp_port_name_desc) * 2) \
-				+ sizeof(struct fc_rdp_bbc_desc) \
-				+ (sizeof(struct fc_rdp_oed_sfp_desc) * 5) \
-				+ sizeof(struct fc_rdp_opd_sfp_desc))
-
-
 /******** FDMI ********/
 
 /* lpfc_sli_ct_request defines the CT_IU preamble for FDMI commands */
-- 
2.5.0

