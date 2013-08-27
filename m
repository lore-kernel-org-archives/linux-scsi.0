From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 26/29] qla2xxx: Correctly print out/in mailbox registers.
Date: Tue, 27 Aug 2013 01:37:52 -0400
Message-ID: <1377581875-8574-27-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:35922 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209Ab3H1TZl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Aug 2013 15:25:41 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7SJKwVG007445
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2013 12:25:41 -0700
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1e5gq16nur-1
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2013 12:25:41 -0700
Received: from pps.reinject (m0000643.ppops.net [127.0.0.1])
	by pps.reinject (8.14.5/8.14.5) with SMTP id r7SJPeYJ013294
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2013 12:25:40 -0700
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1eg8v690x3-6
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:53 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

At mailbox/buffer debug level, print the correct values of the
outgoing and incoming mailbox registers.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index c825d1d..a9aae50 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -117,33 +117,25 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	command = mcp->mb[0];
 	mboxes = mcp->out_mb;
 
+	ql_dbg(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1111,
+	    "Mailbox registers (OUT):\n");
 	for (cnt = 0; cnt < ha->mbx_count; cnt++) {
 		if (IS_QLA2200(ha) && cnt == 8)
 			optr =
 			    (uint16_t __iomem *)MAILBOX_REG(ha, &reg->isp, 8);
-		if (mboxes & BIT_0)
+		if (mboxes & BIT_0) {
+			ql_dbg(ql_dbg_mbx, vha, 0x1112,
+			    "mbox[%d]<-0x%04x\n", cnt, *iptr);
 			WRT_REG_WORD(optr, *iptr);
+		}
 
 		mboxes >>= 1;
 		optr++;
 		iptr++;
 	}
 
-	ql_dbg(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1111,
-	    "Loaded MBX registers (displayed in bytes) =.\n");
-	ql_dump_buffer(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1112,
-	    (uint8_t *)mcp->mb, 16);
-	ql_dbg(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1113,
-	    ".\n");
-	ql_dump_buffer(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1114,
-	    ((uint8_t *)mcp->mb + 0x10), 16);
-	ql_dbg(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1115,
-	    ".\n");
-	ql_dump_buffer(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1116,
-	    ((uint8_t *)mcp->mb + 0x20), 8);
 	ql_dbg(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1117,
 	    "I/O Address = %p.\n", optr);
-	ql_dump_regs(ql_dbg_mbx + ql_dbg_buffer, vha, 0x100e);
 
 	/* Issue set host interrupt command to send cmd out. */
 	ha->flags.mbox_int = 0;
@@ -254,9 +246,15 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		iptr2 = mcp->mb;
 		iptr = (uint16_t *)&ha->mailbox_out[0];
 		mboxes = mcp->in_mb;
+
+		ql_dbg(ql_dbg_mbx, vha, 0x1113,
+		    "Mailbox registers (IN):\n");
 		for (cnt = 0; cnt < ha->mbx_count; cnt++) {
-			if (mboxes & BIT_0)
+			if (mboxes & BIT_0) {
 				*iptr2 = *iptr;
+				ql_dbg(ql_dbg_mbx, vha, 0x1114,
+				    "mbox[%d]->0x%04x\n", cnt, *iptr2);
+			}
 
 			mboxes >>= 1;
 			iptr2++;
-- 
1.7.7

