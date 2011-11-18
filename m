From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 05/18] qla2xxx: Only read requested mailbox registers.
Date: Fri, 18 Nov 2011 09:03:09 -0800
Message-ID: <1321635802-16491-6-git-send-email-chad.dupuis@qlogic.com>
References: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-va3.bigfish.com ([216.32.180.10]:7313 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758260Ab1KRRQa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:16:30 -0500
In-Reply-To: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

When reading the incoming mailbox registers, read only the specified ones.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c5d6cd1..8a1e9b2 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -242,28 +242,35 @@ static void
 qla2x00_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 {
 	uint16_t	cnt;
+	uint32_t	mboxes;
 	uint16_t __iomem *wptr;
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
+	/* Read all mbox registers? */
+	mboxes = (1 << ha->mbx_count) - 1;
+	if (!ha->mcp)
+		ql_dbg(ql_dbg_async, vha, 0x5001, "MBX pointer ERRROR.\n");
+	else
+		mboxes = ha->mcp->in_mb;
+
 	/* Load return mailbox registers. */
 	ha->flags.mbox_int = 1;
 	ha->mailbox_out[0] = mb0;
+	mboxes >>= 1;
 	wptr = (uint16_t __iomem *)MAILBOX_REG(ha, reg, 1);
 
 	for (cnt = 1; cnt < ha->mbx_count; cnt++) {
 		if (IS_QLA2200(ha) && cnt == 8)
 			wptr = (uint16_t __iomem *)MAILBOX_REG(ha, reg, 8);
-		if (cnt == 4 || cnt == 5)
+		if ((cnt == 4 || cnt == 5) && (mboxes & BIT_0))
 			ha->mailbox_out[cnt] = qla2x00_debounce_register(wptr);
-		else
+		else if (mboxes & BIT_0)
 			ha->mailbox_out[cnt] = RD_REG_WORD(wptr);
 
 		wptr++;
+		mboxes >>= 1;
 	}
-
-	if (!ha->mcp)
-		ql_dbg(ql_dbg_async, vha, 0x5001, "MBX pointer ERROR.\n");
 }
 
 static void
@@ -2004,22 +2011,31 @@ static void
 qla24xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 {
 	uint16_t	cnt;
+	uint32_t	mboxes;
 	uint16_t __iomem *wptr;
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
+	/* Read all mbox registers? */
+	mboxes = (1 << ha->mbx_count) - 1;
+	if (!ha->mcp)
+		ql_dbg(ql_dbg_async, vha, 0x504e, "MBX pointer ERRROR.\n");
+	else
+		mboxes = ha->mcp->in_mb;
+
 	/* Load return mailbox registers. */
 	ha->flags.mbox_int = 1;
 	ha->mailbox_out[0] = mb0;
+	mboxes >>= 1;
 	wptr = (uint16_t __iomem *)&reg->mailbox1;
 
 	for (cnt = 1; cnt < ha->mbx_count; cnt++) {
-		ha->mailbox_out[cnt] = RD_REG_WORD(wptr);
+		if (mboxes & BIT_0)
+			ha->mailbox_out[cnt] = RD_REG_WORD(wptr);
+
+		mboxes >>= 1;
 		wptr++;
 	}
-
-	if (!ha->mcp)
-		ql_dbg(ql_dbg_async, vha, 0x504e, "MBX pointer ERRROR.\n");
 }
 
 /**
-- 
1.6.0.2


