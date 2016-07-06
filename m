From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 04/21] lpfc: Correct Buffer credit descriptor values in
 RDP response
Date: Wed, 06 Jul 2016 12:35:57 -0700
Message-ID: <577d5d9d.AH+Xlv92PaXiAzMm%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:34990 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477AbcGFTgD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:36:03 -0400
Received: by mail-wm0-f49.google.com with SMTP id z126so123508681wme.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:36:03 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id s67sm3673240wmf.3.2016.07.06.12.35.59
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:36:00 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct Buffer credit descriptor values in RDP response

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 74 +++++++++++++++++++-------------------------
 drivers/scsi/lpfc/lpfc_hw.h  |  2 +-
 2 files changed, 32 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 0d05e1a..02e3a1f 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4719,17 +4719,20 @@ uint32_t
 lpfc_rdp_res_bbc_desc(struct fc_rdp_bbc_desc *desc, READ_LNK_VAR *stat,
 		      struct lpfc_vport *vport)
 {
+	uint32_t bbCredit;
+
 	desc->tag = cpu_to_be32(RDP_BBC_DESC_TAG);
 
-	desc->bbc_info.port_bbc = cpu_to_be32(
-				vport->fc_sparam.cmn.bbCreditMsb |
-				vport->fc_sparam.cmn.bbCreditlsb << 8);
-	if (vport->phba->fc_topology != LPFC_TOPOLOGY_LOOP)
-		desc->bbc_info.attached_port_bbc = cpu_to_be32(
-				vport->phba->fc_fabparam.cmn.bbCreditMsb |
-				vport->phba->fc_fabparam.cmn.bbCreditlsb << 8);
-	else
+	bbCredit = vport->fc_sparam.cmn.bbCreditLsb |
+			(vport->fc_sparam.cmn.bbCreditMsb << 8);
+	desc->bbc_info.port_bbc = cpu_to_be32(bbCredit);
+	if (vport->phba->fc_topology != LPFC_TOPOLOGY_LOOP) {
+		bbCredit = vport->phba->fc_fabparam.cmn.bbCreditLsb |
+			(vport->phba->fc_fabparam.cmn.bbCreditMsb << 8);
+		desc->bbc_info.attached_port_bbc = cpu_to_be32(bbCredit);
+	} else {
 		desc->bbc_info.attached_port_bbc = 0;
+	}
 
 	desc->bbc_info.rtt = 0;
 	desc->length = cpu_to_be32(sizeof(desc->bbc_info));
@@ -4745,13 +4748,10 @@ lpfc_rdp_res_oed_temp_desc(struct lpfc_hba *phba,
 
 	desc->tag = cpu_to_be32(RDP_OED_DESC_TAG);
 
-	desc->oed_info.hi_alarm =
-			cpu_to_be16(page_a2[SSF_TEMP_HIGH_ALARM]);
-	desc->oed_info.lo_alarm = cpu_to_be16(page_a2[SSF_TEMP_LOW_ALARM]);
-	desc->oed_info.hi_warning =
-			cpu_to_be16(page_a2[SSF_TEMP_HIGH_WARNING]);
-	desc->oed_info.lo_warning =
-			cpu_to_be16(page_a2[SSF_TEMP_LOW_WARNING]);
+	desc->oed_info.hi_alarm = page_a2[SSF_TEMP_HIGH_ALARM];
+	desc->oed_info.lo_alarm = page_a2[SSF_TEMP_LOW_ALARM];
+	desc->oed_info.hi_warning = page_a2[SSF_TEMP_HIGH_WARNING];
+	desc->oed_info.lo_warning = page_a2[SSF_TEMP_LOW_WARNING];
 
 	if (phba->sfp_alarm & LPFC_TRANSGRESSION_HIGH_TEMPERATURE)
 		flags |= RDP_OET_HIGH_ALARM;
@@ -4777,13 +4777,10 @@ lpfc_rdp_res_oed_voltage_desc(struct lpfc_hba *phba,
 
 	desc->tag = cpu_to_be32(RDP_OED_DESC_TAG);
 
-	desc->oed_info.hi_alarm =
-			cpu_to_be16(page_a2[SSF_VOLTAGE_HIGH_ALARM]);
-	desc->oed_info.lo_alarm = cpu_to_be16(page_a2[SSF_VOLTAGE_LOW_ALARM]);
-	desc->oed_info.hi_warning =
-			cpu_to_be16(page_a2[SSF_VOLTAGE_HIGH_WARNING]);
-	desc->oed_info.lo_warning =
-			cpu_to_be16(page_a2[SSF_VOLTAGE_LOW_WARNING]);
+	desc->oed_info.hi_alarm = page_a2[SSF_VOLTAGE_HIGH_ALARM];
+	desc->oed_info.lo_alarm = page_a2[SSF_VOLTAGE_LOW_ALARM];
+	desc->oed_info.hi_warning = page_a2[SSF_VOLTAGE_HIGH_WARNING];
+	desc->oed_info.lo_warning = page_a2[SSF_VOLTAGE_LOW_WARNING];
 
 	if (phba->sfp_alarm & LPFC_TRANSGRESSION_HIGH_VOLTAGE)
 		flags |= RDP_OET_HIGH_ALARM;
@@ -4809,13 +4806,10 @@ lpfc_rdp_res_oed_txbias_desc(struct lpfc_hba *phba,
 
 	desc->tag = cpu_to_be32(RDP_OED_DESC_TAG);
 
-	desc->oed_info.hi_alarm =
-			cpu_to_be16(page_a2[SSF_BIAS_HIGH_ALARM]);
-	desc->oed_info.lo_alarm = cpu_to_be16(page_a2[SSF_BIAS_LOW_ALARM]);
-	desc->oed_info.hi_warning =
-			cpu_to_be16(page_a2[SSF_BIAS_HIGH_WARNING]);
-	desc->oed_info.lo_warning =
-			cpu_to_be16(page_a2[SSF_BIAS_LOW_WARNING]);
+	desc->oed_info.hi_alarm = page_a2[SSF_BIAS_HIGH_ALARM];
+	desc->oed_info.lo_alarm = page_a2[SSF_BIAS_LOW_ALARM];
+	desc->oed_info.hi_warning = page_a2[SSF_BIAS_HIGH_WARNING];
+	desc->oed_info.lo_warning = page_a2[SSF_BIAS_LOW_WARNING];
 
 	if (phba->sfp_alarm & LPFC_TRANSGRESSION_HIGH_TXBIAS)
 		flags |= RDP_OET_HIGH_ALARM;
@@ -4841,13 +4835,10 @@ lpfc_rdp_res_oed_txpower_desc(struct lpfc_hba *phba,
 
 	desc->tag = cpu_to_be32(RDP_OED_DESC_TAG);
 
-	desc->oed_info.hi_alarm =
-			cpu_to_be16(page_a2[SSF_TXPOWER_HIGH_ALARM]);
-	desc->oed_info.lo_alarm = cpu_to_be16(page_a2[SSF_TXPOWER_LOW_ALARM]);
-	desc->oed_info.hi_warning =
-			cpu_to_be16(page_a2[SSF_TXPOWER_HIGH_WARNING]);
-	desc->oed_info.lo_warning =
-			cpu_to_be16(page_a2[SSF_TXPOWER_LOW_WARNING]);
+	desc->oed_info.hi_alarm = page_a2[SSF_TXPOWER_HIGH_ALARM];
+	desc->oed_info.lo_alarm = page_a2[SSF_TXPOWER_LOW_ALARM];
+	desc->oed_info.hi_warning = page_a2[SSF_TXPOWER_HIGH_WARNING];
+	desc->oed_info.lo_warning = page_a2[SSF_TXPOWER_LOW_WARNING];
 
 	if (phba->sfp_alarm & LPFC_TRANSGRESSION_HIGH_TXPOWER)
 		flags |= RDP_OET_HIGH_ALARM;
@@ -4874,13 +4865,10 @@ lpfc_rdp_res_oed_rxpower_desc(struct lpfc_hba *phba,
 
 	desc->tag = cpu_to_be32(RDP_OED_DESC_TAG);
 
-	desc->oed_info.hi_alarm =
-			cpu_to_be16(page_a2[SSF_RXPOWER_HIGH_ALARM]);
-	desc->oed_info.lo_alarm = cpu_to_be16(page_a2[SSF_RXPOWER_LOW_ALARM]);
-	desc->oed_info.hi_warning =
-			cpu_to_be16(page_a2[SSF_RXPOWER_HIGH_WARNING]);
-	desc->oed_info.lo_warning =
-			cpu_to_be16(page_a2[SSF_RXPOWER_LOW_WARNING]);
+	desc->oed_info.hi_alarm = page_a2[SSF_RXPOWER_HIGH_ALARM];
+	desc->oed_info.lo_alarm = page_a2[SSF_RXPOWER_LOW_ALARM];
+	desc->oed_info.hi_warning = page_a2[SSF_RXPOWER_HIGH_WARNING];
+	desc->oed_info.lo_warning = page_a2[SSF_RXPOWER_LOW_WARNING];
 
 	if (phba->sfp_alarm & LPFC_TRANSGRESSION_HIGH_RXPOWER)
 		flags |= RDP_OET_HIGH_ALARM;
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 829a114..c99c2b3 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -346,7 +346,7 @@ struct csp {
 	uint8_t fcphHigh;	/* FC Word 0, byte 0 */
 	uint8_t fcphLow;
 	uint8_t bbCreditMsb;
-	uint8_t bbCreditlsb;	/* FC Word 0, byte 3 */
+	uint8_t bbCreditLsb;	/* FC Word 0, byte 3 */
 
 /*
  * Word 1 Bit 31 in common service parameter is overloaded.
-- 
2.5.0

