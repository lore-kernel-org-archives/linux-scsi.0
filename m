From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 01/21] lpfc: Fix Transgression Flag of Optical Element
 descriptor for RDP on Linux
Date: Wed, 06 Jul 2016 12:35:54 -0700
Message-ID: <577d5d9a.tm/ZDaxY8ldAXu0i%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38500 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbcGFTgC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:36:02 -0400
Received: by mail-wm0-f45.google.com with SMTP id r201so5681054wme.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:36:00 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id e16sm2427678wma.12.2016.07.06.12.35.56
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:35:57 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix Transgression Flag of Optical Element descriptor for RDP on Linux

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h      |  12 +++++
 drivers/scsi/lpfc/lpfc_els.c  | 101 +++++++++++++++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_hw.h   |   6 +++
 drivers/scsi/lpfc/lpfc_hw4.h  |   6 +--
 drivers/scsi/lpfc/lpfc_init.c |   2 +
 5 files changed, 101 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index d5bd420..c6ade9b 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -999,6 +999,18 @@ struct lpfc_hba {
 	spinlock_t devicelock;	/* lock for luns list */
 	mempool_t *device_data_mem_pool;
 	struct list_head luns;
+#define LPFC_TRANSGRESSION_HIGH_TEMPERATURE	0x0080
+#define LPFC_TRANSGRESSION_LOW_TEMPERATURE	0x0040
+#define LPFC_TRANSGRESSION_HIGH_VOLTAGE		0x0020
+#define LPFC_TRANSGRESSION_LOW_VOLTAGE		0x0010
+#define LPFC_TRANSGRESSION_HIGH_TXBIAS		0x0008
+#define LPFC_TRANSGRESSION_LOW_TXBIAS		0x0004
+#define LPFC_TRANSGRESSION_HIGH_TXPOWER		0x0002
+#define LPFC_TRANSGRESSION_LOW_TXPOWER		0x0001
+#define LPFC_TRANSGRESSION_HIGH_RXPOWER		0x8000
+#define LPFC_TRANSGRESSION_LOW_RXPOWER		0x4000
+	uint16_t sfp_alarm;
+	uint16_t sfp_warning;
 };
 
 static inline struct Scsi_Host *
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 0498f57..300131a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4730,9 +4730,10 @@ lpfc_rdp_res_bbc_desc(struct fc_rdp_bbc_desc *desc, READ_LNK_VAR *stat,
 }
 
 void
-lpfc_rdp_res_oed_temp_desc(struct fc_rdp_oed_sfp_desc *desc, uint8_t *page_a2)
+lpfc_rdp_res_oed_temp_desc(struct lpfc_hba *phba,
+			   struct fc_rdp_oed_sfp_desc *desc, uint8_t *page_a2)
 {
-	uint32_t flags;
+	uint32_t flags = 0;
 
 	desc->tag = cpu_to_be32(RDP_OED_DESC_TAG);
 
@@ -4743,17 +4744,27 @@ lpfc_rdp_res_oed_temp_desc(struct fc_rdp_oed_sfp_desc *desc, uint8_t *page_a2)
 			cpu_to_be16(page_a2[SSF_TEMP_HIGH_WARNING]);
 	desc->oed_info.lo_warning =
 			cpu_to_be16(page_a2[SSF_TEMP_LOW_WARNING]);
-	flags = 0xf; /* All four are valid */
+
+	if (phba->sfp_alarm & LPFC_TRANSGRESSION_HIGH_TEMPERATURE)
+		flags |= RDP_OET_HIGH_ALARM;
+	if (phba->sfp_alarm & LPFC_TRANSGRESSION_LOW_TEMPERATURE)
+		flags |= RDP_OET_LOW_ALARM;
+	if (phba->sfp_warning & LPFC_TRANSGRESSION_HIGH_TEMPERATURE)
+		flags |= RDP_OET_HIGH_WARNING;
+	if (phba->sfp_warning & LPFC_TRANSGRESSION_LOW_TEMPERATURE)
+		flags |= RDP_OET_LOW_WARNING;
+
 	flags |= ((0xf & RDP_OED_TEMPERATURE) << RDP_OED_TYPE_SHIFT);
 	desc->oed_info.function_flags = cpu_to_be32(flags);
 	desc->length = cpu_to_be32(sizeof(desc->oed_info));
 }
 
 void
-lpfc_rdp_res_oed_voltage_desc(struct fc_rdp_oed_sfp_desc *desc,
+lpfc_rdp_res_oed_voltage_desc(struct lpfc_hba *phba,
+			      struct fc_rdp_oed_sfp_desc *desc,
 			      uint8_t *page_a2)
 {
-	uint32_t flags;
+	uint32_t flags = 0;
 
 	desc->tag = cpu_to_be32(RDP_OED_DESC_TAG);
 
@@ -4764,17 +4775,27 @@ lpfc_rdp_res_oed_voltage_desc(struct fc_rdp_oed_sfp_desc *desc,
 			cpu_to_be16(page_a2[SSF_VOLTAGE_HIGH_WARNING]);
 	desc->oed_info.lo_warning =
 			cpu_to_be16(page_a2[SSF_VOLTAGE_LOW_WARNING]);
-	flags = 0xf; /* All four are valid */
+
+	if (phba->sfp_alarm & LPFC_TRANSGRESSION_HIGH_VOLTAGE)
+		flags |= RDP_OET_HIGH_ALARM;
+	if (phba->sfp_alarm & LPFC_TRANSGRESSION_LOW_VOLTAGE)
+		flags |= RDP_OET_LOW_ALARM;
+	if (phba->sfp_warning & LPFC_TRANSGRESSION_HIGH_VOLTAGE)
+		flags |= RDP_OET_HIGH_WARNING;
+	if (phba->sfp_warning & LPFC_TRANSGRESSION_LOW_VOLTAGE)
+		flags |= RDP_OET_LOW_WARNING;
+
 	flags |= ((0xf & RDP_OED_VOLTAGE) << RDP_OED_TYPE_SHIFT);
 	desc->oed_info.function_flags = cpu_to_be32(flags);
 	desc->length = cpu_to_be32(sizeof(desc->oed_info));
 }
 
 void
-lpfc_rdp_res_oed_txbias_desc(struct fc_rdp_oed_sfp_desc *desc,
+lpfc_rdp_res_oed_txbias_desc(struct lpfc_hba *phba,
+			     struct fc_rdp_oed_sfp_desc *desc,
 			     uint8_t *page_a2)
 {
-	uint32_t flags;
+	uint32_t flags = 0;
 
 	desc->tag = cpu_to_be32(RDP_OED_DESC_TAG);
 
@@ -4785,17 +4806,27 @@ lpfc_rdp_res_oed_txbias_desc(struct fc_rdp_oed_sfp_desc *desc,
 			cpu_to_be16(page_a2[SSF_BIAS_HIGH_WARNING]);
 	desc->oed_info.lo_warning =
 			cpu_to_be16(page_a2[SSF_BIAS_LOW_WARNING]);
-	flags = 0xf; /* All four are valid */
+
+	if (phba->sfp_alarm & LPFC_TRANSGRESSION_HIGH_TXBIAS)
+		flags |= RDP_OET_HIGH_ALARM;
+	if (phba->sfp_alarm & LPFC_TRANSGRESSION_LOW_TXBIAS)
+		flags |= RDP_OET_LOW_ALARM;
+	if (phba->sfp_warning & LPFC_TRANSGRESSION_HIGH_TXBIAS)
+		flags |= RDP_OET_HIGH_WARNING;
+	if (phba->sfp_warning & LPFC_TRANSGRESSION_LOW_TXBIAS)
+		flags |= RDP_OET_LOW_WARNING;
+
 	flags |= ((0xf & RDP_OED_TXBIAS) << RDP_OED_TYPE_SHIFT);
 	desc->oed_info.function_flags = cpu_to_be32(flags);
 	desc->length = cpu_to_be32(sizeof(desc->oed_info));
 }
 
 void
-lpfc_rdp_res_oed_txpower_desc(struct fc_rdp_oed_sfp_desc *desc,
+lpfc_rdp_res_oed_txpower_desc(struct lpfc_hba *phba,
+			      struct fc_rdp_oed_sfp_desc *desc,
 			      uint8_t *page_a2)
 {
-	uint32_t flags;
+	uint32_t flags = 0;
 
 	desc->tag = cpu_to_be32(RDP_OED_DESC_TAG);
 
@@ -4806,7 +4837,16 @@ lpfc_rdp_res_oed_txpower_desc(struct fc_rdp_oed_sfp_desc *desc,
 			cpu_to_be16(page_a2[SSF_TXPOWER_HIGH_WARNING]);
 	desc->oed_info.lo_warning =
 			cpu_to_be16(page_a2[SSF_TXPOWER_LOW_WARNING]);
-	flags = 0xf; /* All four are valid */
+
+	if (phba->sfp_alarm & LPFC_TRANSGRESSION_HIGH_TXPOWER)
+		flags |= RDP_OET_HIGH_ALARM;
+	if (phba->sfp_alarm & LPFC_TRANSGRESSION_LOW_TXPOWER)
+		flags |= RDP_OET_LOW_ALARM;
+	if (phba->sfp_warning & LPFC_TRANSGRESSION_HIGH_TXPOWER)
+		flags |= RDP_OET_HIGH_WARNING;
+	if (phba->sfp_warning & LPFC_TRANSGRESSION_LOW_TXPOWER)
+		flags |= RDP_OET_LOW_WARNING;
+
 	flags |= ((0xf & RDP_OED_TXPOWER) << RDP_OED_TYPE_SHIFT);
 	desc->oed_info.function_flags = cpu_to_be32(flags);
 	desc->length = cpu_to_be32(sizeof(desc->oed_info));
@@ -4814,10 +4854,11 @@ lpfc_rdp_res_oed_txpower_desc(struct fc_rdp_oed_sfp_desc *desc,
 
 
 void
-lpfc_rdp_res_oed_rxpower_desc(struct fc_rdp_oed_sfp_desc *desc,
+lpfc_rdp_res_oed_rxpower_desc(struct lpfc_hba *phba,
+			      struct fc_rdp_oed_sfp_desc *desc,
 			      uint8_t *page_a2)
 {
-	uint32_t flags;
+	uint32_t flags = 0;
 
 	desc->tag = cpu_to_be32(RDP_OED_DESC_TAG);
 
@@ -4828,7 +4869,16 @@ lpfc_rdp_res_oed_rxpower_desc(struct fc_rdp_oed_sfp_desc *desc,
 			cpu_to_be16(page_a2[SSF_RXPOWER_HIGH_WARNING]);
 	desc->oed_info.lo_warning =
 			cpu_to_be16(page_a2[SSF_RXPOWER_LOW_WARNING]);
-	flags = 0xf; /* All four are valid */
+
+	if (phba->sfp_alarm & LPFC_TRANSGRESSION_HIGH_RXPOWER)
+		flags |= RDP_OET_HIGH_ALARM;
+	if (phba->sfp_alarm & LPFC_TRANSGRESSION_LOW_RXPOWER)
+		flags |= RDP_OET_LOW_ALARM;
+	if (phba->sfp_warning & LPFC_TRANSGRESSION_HIGH_RXPOWER)
+		flags |= RDP_OET_HIGH_WARNING;
+	if (phba->sfp_warning & LPFC_TRANSGRESSION_LOW_RXPOWER)
+		flags |= RDP_OET_LOW_WARNING;
+
 	flags |= ((0xf & RDP_OED_RXPOWER) << RDP_OED_TYPE_SHIFT);
 	desc->oed_info.function_flags = cpu_to_be32(flags);
 	desc->length = cpu_to_be32(sizeof(desc->oed_info));
@@ -4977,6 +5027,7 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 	struct ls_rjt *stat;
 	struct fc_rdp_res_frame *rdp_res;
 	uint32_t cmdsize;
+	uint16_t *flag_ptr;
 	int rc, fec_size;
 
 	if (status != SUCCESS)
@@ -5008,6 +5059,12 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 	memset(pcmd, 0, sizeof(struct fc_rdp_res_frame));
 	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
 
+	/* Update Alarm and Warning */
+	flag_ptr = (uint16_t *)(rdp_context->page_a2 + SSF_ALARM_FLAGS);
+	phba->sfp_alarm |= *flag_ptr;
+	flag_ptr = (uint16_t *)(rdp_context->page_a2 + SSF_WARNING_FLAGS);
+	phba->sfp_warning |= *flag_ptr;
+
 	/* For RDP payload */
 	lpfc_rdp_res_link_service(&rdp_res->link_service_desc, ELS_CMD_RDP);
 
@@ -5015,21 +5072,21 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 			rdp_context->page_a0, rdp_context->page_a2);
 	lpfc_rdp_res_speed(&rdp_res->portspeed_desc, phba);
 	lpfc_rdp_res_link_error(&rdp_res->link_error_desc,
-			&rdp_context->link_stat);
+				&rdp_context->link_stat);
 	lpfc_rdp_res_diag_port_names(&rdp_res->diag_port_names_desc, phba);
 	lpfc_rdp_res_attach_port_names(&rdp_res->attached_port_names_desc,
-			vport, ndlp);
+				       vport, ndlp);
 	lpfc_rdp_res_bbc_desc(&rdp_res->bbc_desc, &rdp_context->link_stat,
 			      vport);
-	lpfc_rdp_res_oed_temp_desc(&rdp_res->oed_temp_desc,
+	lpfc_rdp_res_oed_temp_desc(phba, &rdp_res->oed_temp_desc,
 				   rdp_context->page_a2);
-	lpfc_rdp_res_oed_voltage_desc(&rdp_res->oed_voltage_desc,
+	lpfc_rdp_res_oed_voltage_desc(phba, &rdp_res->oed_voltage_desc,
 				      rdp_context->page_a2);
-	lpfc_rdp_res_oed_txbias_desc(&rdp_res->oed_txbias_desc,
+	lpfc_rdp_res_oed_txbias_desc(phba, &rdp_res->oed_txbias_desc,
 				     rdp_context->page_a2);
-	lpfc_rdp_res_oed_txpower_desc(&rdp_res->oed_txpower_desc,
+	lpfc_rdp_res_oed_txpower_desc(phba, &rdp_res->oed_txpower_desc,
 				      rdp_context->page_a2);
-	lpfc_rdp_res_oed_rxpower_desc(&rdp_res->oed_rxpower_desc,
+	lpfc_rdp_res_oed_rxpower_desc(phba, &rdp_res->oed_rxpower_desc,
 				      rdp_context->page_a2);
 	lpfc_rdp_res_opd_desc(&rdp_res->opd_desc, rdp_context->page_a0, vport);
 	fec_size = lpfc_rdp_res_fec_desc(&rdp_res->fec_desc,
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 39f0fd0..5385faf 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1206,6 +1206,12 @@ struct fc_rdp_bbc_desc {
 	struct fc_rdp_bbc_info  bbc_info;
 };
 
+/* Optical Element Type Transgression Flags */
+#define RDP_OET_LOW_WARNING  0x1
+#define RDP_OET_HIGH_WARNING 0x2
+#define RDP_OET_LOW_ALARM    0x4
+#define RDP_OET_HIGH_ALARM   0x8
+
 #define RDP_OED_TEMPERATURE  0x1
 #define RDP_OED_VOLTAGE      0x2
 #define RDP_OED_TXBIAS       0x3
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 0c7070b..8a5e08d 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -2590,10 +2590,8 @@ struct lpfc_mbx_memory_dump_type3 {
 #define SFF_RXPOWER_B1			104
 #define SFF_RXPOWER_B0			105
 #define SSF_STATUS_CONTROL		110
-#define SSF_ALARM_FLAGS_B1		112
-#define SSF_ALARM_FLAGS_B0		113
-#define SSF_WARNING_FLAGS_B1		116
-#define SSF_WARNING_FLAGS_B0		117
+#define SSF_ALARM_FLAGS			112
+#define SSF_WARNING_FLAGS		116
 #define SSF_EXT_TATUS_CONTROL_B1	118
 #define SSF_EXT_TATUS_CONTROL_B0	119
 #define SSF_A2_VENDOR_SPECIFIC		120
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index b43f7ac..bce73b4 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1681,6 +1681,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
 				"taking port offline Data: x%x x%x\n",
 				reg_err1, reg_err2);
 
+			phba->sfp_alarm |= LPFC_TRANSGRESSION_HIGH_TEMPERATURE;
 			temp_event_data.event_type = FC_REG_TEMPERATURE_EVENT;
 			temp_event_data.event_code = LPFC_CRIT_TEMP;
 			temp_event_data.data = 0xFFFFFFFF;
@@ -4107,6 +4108,7 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
 				"3190 Over Temperature:%d Celsius- Port Name %c\n",
 				acqe_sli->event_data1, port_name);
 
+		phba->sfp_warning |= LPFC_TRANSGRESSION_HIGH_TEMPERATURE;
 		shost = lpfc_shost_from_vport(phba->pport);
 		fc_host_post_vendor_event(shost, fc_get_event_number(),
 					  sizeof(temp_event_data),
-- 
2.5.0

