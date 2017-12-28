From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 09/37] qla2xxx: Enable ATIO interrupt handshake for ISP27XX
Date: Thu, 28 Dec 2017 12:33:17 -0800
Message-ID: <20171228203345.2702-10-himanshu.madhani@cavium.com>
References: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0043.outbound.protection.outlook.com ([104.47.37.43]:37924
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754413AbdL1UeA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Dec 2017 15:34:00 -0500
In-Reply-To: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Enable ATIO Q interrupt handshake for ISP27XX. This patch
coalesce ATIO's interrupts for Quad port ISP27XX adapter.
Interrupt coalesce allows performance to scale for this
specific case.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 067bcc57a9ad..db6fd3b747ed 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6574,7 +6574,9 @@ void
 qlt_24xx_config_rings(struct scsi_qla_host *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct init_cb_24xx *icb;
+	struct qla_msix_entry *msix = &ha->msix_entries[2];
+	struct init_cb_24xx *icb = (struct init_cb_24xx *)ha->init_cb;
+
 	if (!QLA_TGT_MODE_ENABLED())
 		return;
 
@@ -6582,19 +6584,28 @@ qlt_24xx_config_rings(struct scsi_qla_host *vha)
 	WRT_REG_DWORD(ISP_ATIO_Q_OUT(vha), 0);
 	RD_REG_DWORD(ISP_ATIO_Q_OUT(vha));
 
-	icb = (struct init_cb_24xx *)ha->init_cb;
-
-	if ((ql2xenablemsix != 0) && IS_ATIO_MSIX_CAPABLE(ha)) {
-		struct qla_msix_entry *msix = &ha->msix_entries[2];
-
-		icb->msix_atio = cpu_to_le16(msix->entry);
-		ql_dbg(ql_dbg_init, vha, 0xf072,
-		    "Registering ICB vector 0x%x for atio que.\n",
-		    msix->entry);
-	} else if (ql2xenablemsix == 0) {
-		icb->firmware_options_2 |= cpu_to_le32(BIT_26);
-		ql_dbg(ql_dbg_init, vha, 0xf07f,
-		    "Registering INTx vector for ATIO.\n");
+	if (ha->flags.msix_enabled) {
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
+			if (IS_QLA2071(ha)) {
+				/* 4 ports Baker: Enable Interrupt Handshake */
+				icb->msix_atio = 0;
+				icb->firmware_options_2 |= BIT_26;
+			} else {
+				icb->msix_atio = cpu_to_le16(msix->entry);
+				icb->firmware_options_2 &= ~BIT_26;
+			}
+			ql_dbg(ql_dbg_init, vha, 0xf072,
+			    "Registering ICB vector 0x%x for atio que.\n",
+			    msix->entry);
+		}
+	} else {
+		/* INTx|MSI */
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
+			icb->msix_atio = 0;
+			icb->firmware_options_2 |= BIT_26;
+			ql_dbg(ql_dbg_init, vha, 0xf072,
+			    "%s: Use INTx for ATIOQ.\n", __func__);
+		}
 	}
 }
 
-- 
2.12.0
