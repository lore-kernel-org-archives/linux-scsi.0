From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 6/8] qla2xxx: Correct residual-count handling discrepancies during UNDERRUN handling.
Date: Fri, 19 Oct 2007 15:59:18 -0700
Message-ID: <1192834760-573-6-git-send-email-andrew.vasquez@qlogic.com>
References: <20071019225824.GG24197@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29152 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966596AbXJSW7i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2007 18:59:38 -0400
In-Reply-To: <20071019225824.GG24197@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

For recent ISPs, software during CS_UNDERRUN handling must
determine if the two residuals, firmware-calculated and FCP_RSP,
are different to recognize if a frame has been dropped.  Update
the driver to catch this condition, and clear the
SS_RESIDUAL_UNDER and lscsi_status bits.  This logic is
consistent with what earlier firmwares did by explicitly
cracking open the FCP_RSP statuses and clearing
SS_RESIDUAL_UNDER.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c4768c4..1104bd2 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1012,8 +1012,14 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 	case CS_DATA_UNDERRUN:
 		resid = resid_len;
 		/* Use F/W calculated residual length. */
-		if (IS_FWI2_CAPABLE(ha))
+		if (IS_FWI2_CAPABLE(ha)) {
+			if (scsi_status & SS_RESIDUAL_UNDER &&
+			    resid != fw_resid_len) {
+				scsi_status &= ~SS_RESIDUAL_UNDER;
+				lscsi_status = 0;
+			}
 			resid = fw_resid_len;
+		}
 
 		if (scsi_status & SS_RESIDUAL_UNDER) {
 			scsi_set_resid(cp, resid);
-- 
1.5.3.4.206.g58ba4

