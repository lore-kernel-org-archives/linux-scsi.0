From: madhu.iyengar@qlogic.com
Subject: [PATCH 11/11] qla2xxx: Refactor call to qla2xxx_read_sfp for thermal temperature.
Date: Tue, 10 May 2011 11:30:16 -0700
Message-ID: <1305052216-17347-12-git-send-email-madhu.iyengar@qlogic.com>
References: <1305052216-17347-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39940 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751755Ab1EJSgf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2011 14:36:35 -0400
In-Reply-To: <1305052216-17347-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Joe Carnuccio <joe.carnuccio@qlogic.com>

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Eliminate duplicate code by refactoring the calls to qla2xxx_read_sfp()
in qla2x00_get_thermal_temp(). This keeps the parameter values separate
from the mailbox register mechanics. This also allows qla2xxx_read_sfp()
to be the sole "spec" for READ SFP semantics.

Signed-off_by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |   53 ++++++++-------------------------------
 1 files changed, 11 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7184b87..c26f0ac 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4142,63 +4142,32 @@ int
 qla2x00_get_thermal_temp(scsi_qla_host_t *vha, uint16_t *temp, uint16_t *frac)
 {
 	int rval;
-	mbx_cmd_t mc;
-	mbx_cmd_t *mcp = &mc;
+	uint8_t byte;
 	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG11(printk(KERN_INFO "%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk(KERN_INFO "%s(%ld): entered.\n", __func__, vha->host_no));
 
-	/* High bits. */
-	mcp->mb[0] = MBC_READ_SFP;
-	mcp->mb[1] = 0x98;
-	mcp->mb[2] = 0;
-	mcp->mb[3] = 0;
-	mcp->mb[6] = 0;
-	mcp->mb[7] = 0;
-	mcp->mb[8] = 1;
-	mcp->mb[9] = 0x01;
-	mcp->mb[10] = BIT_13|BIT_0;
-	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_1|MBX_0;
-	mcp->tov = MBX_TOV_SECONDS;
-	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(vha, mcp);
+	/* Integer part */
+	rval = qla2x00_read_sfp(vha, 0, &byte, 0x98, 0x01, 1, BIT_13|BIT_0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk(KERN_WARNING
-		    "%s(%ld): failed=%x (%x).\n", __func__,
-		    vha->host_no, rval, mcp->mb[0]));
+		    "%s(%ld): failed=%x.\n", __func__, vha->host_no, rval));
 		ha->flags.thermal_supported = 0;
 		goto fail;
 	}
-	*temp = mcp->mb[1] & 0xFF;
+	*temp = byte;
 
-	/* Low bits. */
-	mcp->mb[0] = MBC_READ_SFP;
-	mcp->mb[1] = 0x98;
-	mcp->mb[2] = 0;
-	mcp->mb[3] = 0;
-	mcp->mb[6] = 0;
-	mcp->mb[7] = 0;
-	mcp->mb[8] = 1;
-	mcp->mb[9] = 0x10;
-	mcp->mb[10] = BIT_13|BIT_0;
-	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_1|MBX_0;
-	mcp->tov = MBX_TOV_SECONDS;
-	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(vha, mcp);
+	/* Fraction part */
+	rval = qla2x00_read_sfp(vha, 0, &byte, 0x98, 0x10, 1, BIT_13|BIT_0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk(KERN_WARNING
-		    "%s(%ld): failed=%x (%x).\n", __func__,
-		    vha->host_no, rval, mcp->mb[0]));
+		    "%s(%ld): failed=%x.\n", __func__, vha->host_no, rval));
 		ha->flags.thermal_supported = 0;
 		goto fail;
 	}
-	*frac = ((mcp->mb[1] & 0xFF) >> 6) * 25;
+	*frac = (byte >> 6) * 25;
 
-	if (rval == QLA_SUCCESS)
-		DEBUG11(printk(KERN_INFO
-		    "%s(%ld): done.\n", __func__, ha->host_no));
+	DEBUG11(printk(KERN_INFO "%s(%ld): done.\n", __func__, vha->host_no));
 fail:
 	return rval;
 }
-- 
1.6.0.2

