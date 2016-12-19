From: james.smart@broadcom.com (James Smart)
Subject: [PATCH v2 01/11] lpfc: Clear the VendorVersion in the PLOGI/PLOGI ACC payload
Date: Mon, 19 Dec 2016 15:07:20 -0800
Message-ID: <58586828.M1b42wtxZQTqdEkh%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvsmtp02.broadcom.com ([192.19.219.146]:42868 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754767AbcLSXHZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2016 18:07:25 -0500
Received: from flash (fx9xs32.lab.emulex.com [138.239.87.14])
        by relay.smtp.broadcom.com (Postfix) with SMTP id 1CEB3260002
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2016 15:07:22 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Clear the VendorVersion in the PLOGI/PLOGI ACC payload

Vendor version info may have been set on fabric login. Before sending
PLOGI payloads, ensure that it's cleared.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 6 ++++++
 drivers/scsi/lpfc/lpfc_hw.h  | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 236e4e5..27f0cbb 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1999,6 +1999,9 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 	if (sp->cmn.fcphHigh < FC_PH3)
 		sp->cmn.fcphHigh = FC_PH3;
 
+	sp->cmn.valid_vendor_ver_level = 0;
+	memset(sp->vendorVersion, 0, sizeof(sp->vendorVersion));
+
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"Issue PLOGI:     did:x%x",
 		did, 0, 0);
@@ -3988,6 +3991,9 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 		} else {
 			memcpy(pcmd, &vport->fc_sparam,
 			       sizeof(struct serv_parm));
+
+			sp->cmn.valid_vendor_ver_level = 0;
+			memset(sp->vendorVersion, 0, sizeof(sp->vendorVersion));
 		}
 
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 8226543..3b970d37 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -360,6 +360,12 @@ struct csp {
  * Word 1 Bit 30 in PLOGI request is random offset
  */
 #define virtual_fabric_support randomOffset /* Word 1, bit 30 */
+/*
+ * Word 1 Bit 29 in common service parameter is overloaded.
+ * Word 1 Bit 29 in FLOGI response is multiple NPort assignment
+ * Word 1 Bit 29 in FLOGI/PLOGI request is Valid Vendor Version Level
+ */
+#define valid_vendor_ver_level response_multiple_NPort /* Word 1, bit 29 */
 #ifdef __BIG_ENDIAN_BITFIELD
 	uint16_t request_multiple_Nport:1;	/* FC Word 1, bit 31 */
 	uint16_t randomOffset:1;	/* FC Word 1, bit 30 */
-- 
2.5.0


