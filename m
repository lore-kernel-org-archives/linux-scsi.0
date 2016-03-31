From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 6/9] lpfc: Add support for SmartSAN 2.0
Date: Thu, 31 Mar 2016 14:12:32 -0700
Message-ID: <56fd92c0.S3JujEHn3gy/JpLA%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:35582 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932983AbcCaVMh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2016 17:12:37 -0400
Received: by mail-pf0-f178.google.com with SMTP id n5so77733552pfn.2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2016 14:12:37 -0700 (PDT)
Received: from flash (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id to9sm15525637pab.27.2016.03.31.14.12.34
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Mar 2016 14:12:35 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add support for SmartSAN 2.0

Revise versions to reflect SmartSAN 2.0 support

RDP updated to support additional descriptors:
  Credit descriptor
  Optical Element Data descriptors for Temperature, Voltage,
        Bias current, TX power and TX power.
  Optical Product Data descriptor.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_ct.c  |   4 +-
 drivers/scsi/lpfc/lpfc_els.c | 153 +++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_hw.h  |  73 +++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_hw4.h |  21 +++++-
 4 files changed, 243 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 79e261d..982039e 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2322,7 +2322,7 @@ lpfc_fdmi_smart_attr_version(struct lpfc_vport *vport,
 	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
 	memset(ae, 0, 256);
 
-	strncpy(ae->un.AttrString, "Smart SAN Version 1.0",
+	strncpy(ae->un.AttrString, "Smart SAN Version 2.0",
 		sizeof(ae->un.AttrString));
 	len = strnlen(ae->un.AttrString,
 			  sizeof(ae->un.AttrString));
@@ -2397,7 +2397,7 @@ lpfc_fdmi_smart_attr_security(struct lpfc_vport *vport,
 	uint32_t size;
 
 	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	ae->un.AttrInt =  cpu_to_be32(0);
+	ae->un.AttrInt =  cpu_to_be32(1);
 	size = FOURBYTES + sizeof(uint32_t);
 	ad->AttrLen = cpu_to_be16(size);
 	ad->AttrType = cpu_to_be16(RPRT_SMART_SECURITY);
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 27dcde9..9459ac4 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4708,6 +4708,144 @@ lpfc_rdp_res_link_error(struct fc_rdp_link_error_status_desc *desc,
 	desc->length = cpu_to_be32(sizeof(desc->info));
 }
 
+void
+lpfc_rdp_res_bbc_desc(struct fc_rdp_bbc_desc *desc, READ_LNK_VAR *stat,
+		      struct lpfc_vport *vport)
+{
+	desc->tag = cpu_to_be32(RDP_BBC_DESC_TAG);
+
+	desc->bbc_info.port_bbc = cpu_to_be32(
+				vport->fc_sparam.cmn.bbCreditMsb |
+				vport->fc_sparam.cmn.bbCreditlsb << 8);
+	if (vport->phba->fc_topology != LPFC_TOPOLOGY_LOOP)
+		desc->bbc_info.attached_port_bbc = cpu_to_be32(
+				vport->phba->fc_fabparam.cmn.bbCreditMsb |
+				vport->phba->fc_fabparam.cmn.bbCreditlsb << 8);
+	else
+		desc->bbc_info.attached_port_bbc = 0;
+
+	desc->bbc_info.rtt = 0;
+	desc->length = cpu_to_be32(sizeof(desc->bbc_info));
+}
+
+void
+lpfc_rdp_res_oed_temp_desc(struct fc_rdp_oed_sfp_desc *desc, uint8_t *page_a2)
+{
+	uint32_t flags;
+
+	desc->tag = cpu_to_be32(RDP_OED_DESC_TAG);
+
+	desc->oed_info.hi_alarm =
+			cpu_to_be16(page_a2[SSF_TEMP_HIGH_ALARM]);
+	desc->oed_info.lo_alarm = cpu_to_be16(page_a2[SSF_TEMP_LOW_ALARM]);
+	desc->oed_info.hi_warning =
+			cpu_to_be16(page_a2[SSF_TEMP_HIGH_WARNING]);
+	desc->oed_info.lo_warning =
+			cpu_to_be16(page_a2[SSF_TEMP_LOW_WARNING]);
+	flags = 0xf; /* All four are valid */
+	flags |= ((0xf & RDP_OED_TEMPERATURE) << RDP_OED_TYPE_SHIFT);
+	desc->oed_info.function_flags = cpu_to_be32(flags);
+	desc->length = cpu_to_be32(sizeof(desc->oed_info));
+}
+
+void
+lpfc_rdp_res_oed_voltage_desc(struct fc_rdp_oed_sfp_desc *desc,
+			      uint8_t *page_a2)
+{
+	uint32_t flags;
+
+	desc->tag = cpu_to_be32(RDP_OED_DESC_TAG);
+
+	desc->oed_info.hi_alarm =
+			cpu_to_be16(page_a2[SSF_VOLTAGE_HIGH_ALARM]);
+	desc->oed_info.lo_alarm = cpu_to_be16(page_a2[SSF_VOLTAGE_LOW_ALARM]);
+	desc->oed_info.hi_warning =
+			cpu_to_be16(page_a2[SSF_VOLTAGE_HIGH_WARNING]);
+	desc->oed_info.lo_warning =
+			cpu_to_be16(page_a2[SSF_VOLTAGE_LOW_WARNING]);
+	flags = 0xf; /* All four are valid */
+	flags |= ((0xf & RDP_OED_VOLTAGE) << RDP_OED_TYPE_SHIFT);
+	desc->oed_info.function_flags = cpu_to_be32(flags);
+	desc->length = cpu_to_be32(sizeof(desc->oed_info));
+}
+
+void
+lpfc_rdp_res_oed_txbias_desc(struct fc_rdp_oed_sfp_desc *desc,
+			     uint8_t *page_a2)
+{
+	uint32_t flags;
+
+	desc->tag = cpu_to_be32(RDP_OED_DESC_TAG);
+
+	desc->oed_info.hi_alarm =
+			cpu_to_be16(page_a2[SSF_BIAS_HIGH_ALARM]);
+	desc->oed_info.lo_alarm = cpu_to_be16(page_a2[SSF_BIAS_LOW_ALARM]);
+	desc->oed_info.hi_warning =
+			cpu_to_be16(page_a2[SSF_BIAS_HIGH_WARNING]);
+	desc->oed_info.lo_warning =
+			cpu_to_be16(page_a2[SSF_BIAS_LOW_WARNING]);
+	flags = 0xf; /* All four are valid */
+	flags |= ((0xf & RDP_OED_TXBIAS) << RDP_OED_TYPE_SHIFT);
+	desc->oed_info.function_flags = cpu_to_be32(flags);
+	desc->length = cpu_to_be32(sizeof(desc->oed_info));
+}
+
+void
+lpfc_rdp_res_oed_txpower_desc(struct fc_rdp_oed_sfp_desc *desc,
+			      uint8_t *page_a2)
+{
+	uint32_t flags;
+
+	desc->tag = cpu_to_be32(RDP_OED_DESC_TAG);
+
+	desc->oed_info.hi_alarm =
+			cpu_to_be16(page_a2[SSF_TXPOWER_HIGH_ALARM]);
+	desc->oed_info.lo_alarm = cpu_to_be16(page_a2[SSF_TXPOWER_LOW_ALARM]);
+	desc->oed_info.hi_warning =
+			cpu_to_be16(page_a2[SSF_TXPOWER_HIGH_WARNING]);
+	desc->oed_info.lo_warning =
+			cpu_to_be16(page_a2[SSF_TXPOWER_LOW_WARNING]);
+	flags = 0xf; /* All four are valid */
+	flags |= ((0xf & RDP_OED_TXPOWER) << RDP_OED_TYPE_SHIFT);
+	desc->oed_info.function_flags = cpu_to_be32(flags);
+	desc->length = cpu_to_be32(sizeof(desc->oed_info));
+}
+
+
+void
+lpfc_rdp_res_oed_rxpower_desc(struct fc_rdp_oed_sfp_desc *desc,
+			      uint8_t *page_a2)
+{
+	uint32_t flags;
+
+	desc->tag = cpu_to_be32(RDP_OED_DESC_TAG);
+
+	desc->oed_info.hi_alarm =
+			cpu_to_be16(page_a2[SSF_RXPOWER_HIGH_ALARM]);
+	desc->oed_info.lo_alarm = cpu_to_be16(page_a2[SSF_RXPOWER_LOW_ALARM]);
+	desc->oed_info.hi_warning =
+			cpu_to_be16(page_a2[SSF_RXPOWER_HIGH_WARNING]);
+	desc->oed_info.lo_warning =
+			cpu_to_be16(page_a2[SSF_RXPOWER_LOW_WARNING]);
+	flags = 0xf; /* All four are valid */
+	flags |= ((0xf & RDP_OED_RXPOWER) << RDP_OED_TYPE_SHIFT);
+	desc->oed_info.function_flags = cpu_to_be32(flags);
+	desc->length = cpu_to_be32(sizeof(desc->oed_info));
+}
+
+void
+lpfc_rdp_res_opd_desc(struct fc_rdp_opd_sfp_desc *desc,
+		      uint8_t *page_a0, struct lpfc_vport *vport)
+{
+	desc->tag = cpu_to_be32(RDP_OPD_DESC_TAG);
+	memcpy(desc->opd_info.vendor_name, &page_a0[SSF_VENDOR_NAME], 16);
+	memcpy(desc->opd_info.model_number, &page_a0[SSF_VENDOR_PN], 16);
+	memcpy(desc->opd_info.serial_number, &page_a0[SSF_VENDOR_SN], 16);
+	memcpy(desc->opd_info.revision, &page_a0[SSF_VENDOR_REV], 2);
+	memcpy(desc->opd_info.date, &page_a0[SSF_DATE_CODE], 8);
+	desc->length = cpu_to_be32(sizeof(desc->opd_info));
+}
+
 int
 lpfc_rdp_res_fec_desc(struct fc_fec_rdp_desc *desc, READ_LNK_VAR *stat)
 {
@@ -4779,6 +4917,8 @@ lpfc_rdp_res_speed(struct fc_rdp_port_speed_desc *desc, struct lpfc_hba *phba)
 
 	if (rdp_cap == 0)
 		rdp_cap = RDP_CAP_UNKNOWN;
+	if (phba->cfg_link_speed != LPFC_USER_LINK_SPEED_AUTO)
+		rdp_cap |= RDP_CAP_USER_CONFIGURED;
 
 	desc->info.port_speed.capabilities = cpu_to_be16(rdp_cap);
 	desc->length = cpu_to_be32(sizeof(desc->info));
@@ -4878,6 +5018,19 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 	lpfc_rdp_res_diag_port_names(&rdp_res->diag_port_names_desc, phba);
 	lpfc_rdp_res_attach_port_names(&rdp_res->attached_port_names_desc,
 			vport, ndlp);
+	lpfc_rdp_res_bbc_desc(&rdp_res->bbc_desc, &rdp_context->link_stat,
+			      vport);
+	lpfc_rdp_res_oed_temp_desc(&rdp_res->oed_temp_desc,
+				   rdp_context->page_a2);
+	lpfc_rdp_res_oed_voltage_desc(&rdp_res->oed_voltage_desc,
+				      rdp_context->page_a2);
+	lpfc_rdp_res_oed_txbias_desc(&rdp_res->oed_txbias_desc,
+				     rdp_context->page_a2);
+	lpfc_rdp_res_oed_txpower_desc(&rdp_res->oed_txpower_desc,
+				      rdp_context->page_a2);
+	lpfc_rdp_res_oed_rxpower_desc(&rdp_res->oed_rxpower_desc,
+				      rdp_context->page_a2);
+	lpfc_rdp_res_opd_desc(&rdp_res->opd_desc, rdp_context->page_a0, vport);
 	fec_size = lpfc_rdp_res_fec_desc(&rdp_res->fec_desc,
 			&rdp_context->link_stat);
 	rdp_res->length = cpu_to_be32(fec_size + RDP_DESC_PAYLOAD_SIZE);
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index dd20412..41a961e 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1134,9 +1134,10 @@ struct fc_rdp_link_error_status_desc {
 #define RDP_PS_16GB            0x0400
 #define RDP_PS_32GB            0x0200
 
-#define RDP_CAP_UNKNOWN        0x0001
-#define RDP_PS_UNKNOWN         0x0002
-#define RDP_PS_NOT_ESTABLISHED 0x0001
+#define RDP_CAP_USER_CONFIGURED 0x0002
+#define RDP_CAP_UNKNOWN         0x0001
+#define RDP_PS_UNKNOWN          0x0002
+#define RDP_PS_NOT_ESTABLISHED  0x0001
 
 struct fc_rdp_port_speed {
 	uint16_t   capabilities;
@@ -1192,6 +1193,58 @@ struct fc_rdp_sfp_desc {
 	struct fc_rdp_sfp_info sfp_info;
 };
 
+/* Buffer Credit Descriptor */
+struct fc_rdp_bbc_info {
+	uint32_t              port_bbc; /* FC_Port buffer-to-buffer credit */
+	uint32_t              attached_port_bbc;
+	uint32_t              rtt;      /* Round trip time */
+};
+#define RDP_BBC_DESC_TAG  0x00010006
+struct fc_rdp_bbc_desc {
+	uint32_t              tag;
+	uint32_t              length;
+	struct fc_rdp_bbc_info  bbc_info;
+};
+
+#define RDP_OED_TEMPERATURE  0x1
+#define RDP_OED_VOLTAGE      0x2
+#define RDP_OED_TXBIAS       0x3
+#define RDP_OED_TXPOWER      0x4
+#define RDP_OED_RXPOWER      0x5
+
+#define RDP_OED_TYPE_SHIFT   28
+/* Optical Element Data descriptor */
+struct fc_rdp_oed_info {
+	uint16_t            hi_alarm;
+	uint16_t            lo_alarm;
+	uint16_t            hi_warning;
+	uint16_t            lo_warning;
+	uint32_t            function_flags;
+};
+#define RDP_OED_DESC_TAG  0x00010007
+struct fc_rdp_oed_sfp_desc {
+	uint32_t             tag;
+	uint32_t             length;
+	struct fc_rdp_oed_info oed_info;
+};
+
+/* Optical Product Data descriptor */
+struct fc_rdp_opd_sfp_info {
+	uint8_t            vendor_name[16];
+	uint8_t            model_number[16];
+	uint8_t            serial_number[16];
+	uint8_t            reserved[2];
+	uint8_t            revision[2];
+	uint8_t            date[8];
+};
+
+#define RDP_OPD_DESC_TAG  0x00010008
+struct fc_rdp_opd_sfp_desc {
+	uint32_t             tag;
+	uint32_t             length;
+	struct fc_rdp_opd_sfp_info opd_info;
+};
+
 struct fc_rdp_req_frame {
 	uint32_t         rdp_command;           /* ELS command opcode (0x18)*/
 	uint32_t         rdp_des_length;        /* RDP Payload Word 1 */
@@ -1208,7 +1261,14 @@ struct fc_rdp_res_frame {
 	struct fc_rdp_link_error_status_desc link_error_desc; /* Word 13-21 */
 	struct fc_rdp_port_name_desc diag_port_names_desc;    /* Word 22-27 */
 	struct fc_rdp_port_name_desc attached_port_names_desc;/* Word 28-33 */
-	struct fc_fec_rdp_desc fec_desc;	      /* FC Word 34 - 37 */
+	struct fc_rdp_bbc_desc bbc_desc;                      /* FC Word 34-38*/
+	struct fc_rdp_oed_sfp_desc oed_temp_desc;             /* FC Word 39-43*/
+	struct fc_rdp_oed_sfp_desc oed_voltage_desc;          /* FC word 44-48*/
+	struct fc_rdp_oed_sfp_desc oed_txbias_desc;           /* FC word 49-53*/
+	struct fc_rdp_oed_sfp_desc oed_txpower_desc;          /* FC word 54-58*/
+	struct fc_rdp_oed_sfp_desc oed_rxpower_desc;          /* FC word 59-63*/
+	struct fc_rdp_opd_sfp_desc opd_desc;                  /* FC word 64-80*/
+	struct fc_fec_rdp_desc fec_desc;                      /* FC word 81-84*/
 };
 
 
@@ -1216,7 +1276,10 @@ struct fc_rdp_res_frame {
 				+ sizeof(struct fc_rdp_sfp_desc) \
 				+ sizeof(struct fc_rdp_port_speed_desc) \
 				+ sizeof(struct fc_rdp_link_error_status_desc) \
-				+ (sizeof(struct fc_rdp_port_name_desc) * 2))
+				+ (sizeof(struct fc_rdp_port_name_desc) * 2) \
+				+ sizeof(struct fc_rdp_bbc_desc) \
+				+ (sizeof(struct fc_rdp_oed_sfp_desc) * 5) \
+				+ sizeof(struct fc_rdp_opd_sfp_desc))
 
 
 /******** FDMI ********/
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index aea00f8..634c9b1 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -2557,7 +2557,26 @@ struct lpfc_mbx_memory_dump_type3 {
 
 /* SFF-8472 Table 3.1a Diagnostics: Data Fields Address/Page A2 */
 
-#define SSF_AW_THRESHOLDS		0
+#define SSF_TEMP_HIGH_ALARM		0
+#define SSF_TEMP_LOW_ALARM		2
+#define SSF_TEMP_HIGH_WARNING		4
+#define SSF_TEMP_LOW_WARNING		6
+#define SSF_VOLTAGE_HIGH_ALARM		8
+#define SSF_VOLTAGE_LOW_ALARM		10
+#define SSF_VOLTAGE_HIGH_WARNING	12
+#define SSF_VOLTAGE_LOW_WARNING		14
+#define SSF_BIAS_HIGH_ALARM		16
+#define SSF_BIAS_LOW_ALARM		18
+#define SSF_BIAS_HIGH_WARNING		20
+#define SSF_BIAS_LOW_WARNING		22
+#define SSF_TXPOWER_HIGH_ALARM		24
+#define SSF_TXPOWER_LOW_ALARM		26
+#define SSF_TXPOWER_HIGH_WARNING	28
+#define SSF_TXPOWER_LOW_WARNING		30
+#define SSF_RXPOWER_HIGH_ALARM		32
+#define SSF_RXPOWER_LOW_ALARM		34
+#define SSF_RXPOWER_HIGH_WARNING	36
+#define SSF_RXPOWER_LOW_WARNING		38
 #define SSF_EXT_CAL_CONSTANTS		56
 #define SSF_CC_DMI			95
 #define SFF_TEMPERATURE_B1		96
-- 
2.5.0

