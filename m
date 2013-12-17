From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH V2 08/20] qla2xxx: Properly handle 32 bit mailbox register for ISPFX00.
Date: Mon, 16 Dec 2013 22:28:31 -0500
Message-ID: <1387250923-1041-9-git-send-email-saurav.kashyap@qlogic.com>
References: <1387250923-1041-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:47330 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197Ab3LQEBe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 23:01:34 -0500
In-Reply-To: <1387250923-1041-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 9839da8..ed44ec6 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2916,9 +2916,9 @@ qlafx00_async_event(scsi_qla_host_t *vha)
 		break;
 
 	case QLAFX00_MBA_PORT_UPDATE:		/* Port database update */
-		ha->aenmb[1] = RD_REG_WORD(&reg->aenmailbox1);
-		ha->aenmb[2] = RD_REG_WORD(&reg->aenmailbox2);
-		ha->aenmb[3] = RD_REG_WORD(&reg->aenmailbox3);
+		ha->aenmb[1] = RD_REG_DWORD(&reg->aenmailbox1);
+		ha->aenmb[2] = RD_REG_DWORD(&reg->aenmailbox2);
+		ha->aenmb[3] = RD_REG_DWORD(&reg->aenmailbox3);
 		ql_dbg(ql_dbg_async, vha, 0x5077,
 		    "Asynchronous port Update received "
 		    "aenmb[0]: %x, aenmb[1]: %x, aenmb[2]: %x, aenmb[3]: %x\n",
@@ -2975,7 +2975,7 @@ static void
 qlafx00_mbx_completion(scsi_qla_host_t *vha, uint32_t mb0)
 {
 	uint16_t	cnt;
-	uint16_t __iomem *wptr;
+	uint32_t __iomem *wptr;
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_fx00 __iomem *reg = &ha->iobase->ispfx00;
 
@@ -2985,10 +2985,10 @@ qlafx00_mbx_completion(scsi_qla_host_t *vha, uint32_t mb0)
 	/* Load return mailbox registers. */
 	ha->flags.mbox_int = 1;
 	ha->mailbox_out32[0] = mb0;
-	wptr = (uint16_t __iomem *)&reg->mailbox17;
+	wptr = (uint32_t __iomem *)&reg->mailbox17;
 
 	for (cnt = 1; cnt < ha->mbx_count; cnt++) {
-		ha->mailbox_out32[cnt] = RD_REG_WORD(wptr);
+		ha->mailbox_out32[cnt] = RD_REG_DWORD(wptr);
 		wptr++;
 	}
 }
-- 
1.7.7

