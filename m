From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 11/42] qla2xxx: Add bit to identify adapters for thermal temp.
Date: Wed, 22 Aug 2012 14:21:05 -0400
Message-ID: <1345659696-3670-12-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:51518 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964974Ab2HVSiO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:14 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 691be37..1b7bea1 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4425,7 +4425,8 @@ qla2x00_get_thermal_temp(scsi_qla_host_t *vha, uint16_t *temp, uint16_t *frac)
 	    "Entered %s.\n", __func__);
 
 	/* Integer part */
-	rval = qla2x00_read_sfp(vha, 0, &byte, 0x98, 0x01, 1, BIT_13|BIT_0);
+	rval = qla2x00_read_sfp(vha, 0, &byte, 0x98, 0x01, 1,
+		BIT_13|BIT_12|BIT_0);
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_mbx, vha, 0x10c9, "Failed=%x.\n", rval);
 		ha->flags.thermal_supported = 0;
@@ -4434,7 +4435,8 @@ qla2x00_get_thermal_temp(scsi_qla_host_t *vha, uint16_t *temp, uint16_t *frac)
 	*temp = byte;
 
 	/* Fraction part */
-	rval = qla2x00_read_sfp(vha, 0, &byte, 0x98, 0x10, 1, BIT_13|BIT_0);
+	rval = qla2x00_read_sfp(vha, 0, &byte, 0x98, 0x10, 1,
+		BIT_13|BIT_12|BIT_0);
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_mbx, vha, 0x1019, "Failed=%x.\n", rval);
 		ha->flags.thermal_supported = 0;
-- 
1.7.7

