From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/5] qla2xxx: Limit querying to supported mailbox-registers while reading FW state.
Date: Wed, 17 Jun 2009 10:30:30 -0700
Message-ID: <1245259832-8595-4-git-send-email-andrew.vasquez@qlogic.com>
References: <1245259832-8595-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:16588 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758616AbZFQRad (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2009 13:30:33 -0400
In-Reply-To: <1245259832-8595-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Pre-ISP24xx chips have dedicated uses for mailbox 4 and 5 which
software should typically not query nor update.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 779ce14..fe69f30 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1267,17 +1267,22 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 
 	mcp->mb[0] = MBC_GET_FIRMWARE_STATE;
 	mcp->out_mb = MBX_0;
-	mcp->in_mb = MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
+	if (IS_FWI2_CAPABLE(vha->hw))
+		mcp->in_mb = MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
+	else
+		mcp->in_mb = MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	/* Return firmware states. */
 	states[0] = mcp->mb[1];
-	states[1] = mcp->mb[2];
-	states[2] = mcp->mb[3];
-	states[3] = mcp->mb[4];
-	states[4] = mcp->mb[5];
+	if (IS_FWI2_CAPABLE(vha->hw)) {
+		states[1] = mcp->mb[2];
+		states[2] = mcp->mb[3];
+		states[3] = mcp->mb[4];
+		states[4] = mcp->mb[5];
+	}
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-- 
1.6.3.2.306.g4f4fa

