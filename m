From: madhu.iyengar@qlogic.com
Subject: [PATCH 06/12] qla2xxx: Correctly read sfp single byte mailbox register.
Date: Fri,  6 May 2011 17:30:17 -0700
Message-ID: <1304728223-30817-12-git-send-email-madhu.iyengar@qlogic.com>
References: <1304728223-30817-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:32835 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753894Ab1EGAnO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2011 20:43:14 -0400
In-Reply-To: <1304728223-30817-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Joe Carnuccio <joe.carnuccio@qlogic.com>

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

When reading a single byte using the READ SFP mailbox command, the
single byte of data is returned in MB[1] and not MB[8].

The reason that MB[8] was being used is that the spec was unclear
as it evolved over time; and we have not needed to read a single
byte until recently.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 975aeaa..aab628b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3608,14 +3608,14 @@ qla2x00_read_edc(scsi_qla_host_t *vha, uint16_t dev, uint16_t adr,
 	mcp->mb[9] = adr;
 	mcp->mb[10] = opt;
 	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_0;
+	mcp->in_mb = MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (opt & BIT_0)
 		if (sfp)
-			*sfp = mcp->mb[8];
+			*sfp = mcp->mb[1];
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
-- 
1.6.0.2

