From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 08/14] qla2xxx: Add serdes read/write support for ISP27XX
Date: Thu, 9 Apr 2015 15:00:02 -0400
Message-ID: <1428606008-14976-9-git-send-email-himanshu.madhani@qlogic.com>
References: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:30720 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933203AbbDITl3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2015 15:41:29 -0400
In-Reply-To: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 72971da..fe7b87d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2838,7 +2838,7 @@ qla2x00_write_serdes_word(scsi_qla_host_t *vha, uint16_t addr, uint16_t data)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_QLA2031(vha->hw))
+	if (!IS_QLA2031(vha->hw) && !IS_QLA27XX(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1182,
@@ -2846,7 +2846,11 @@ qla2x00_write_serdes_word(scsi_qla_host_t *vha, uint16_t addr, uint16_t data)
 
 	mcp->mb[0] = MBC_WRITE_SERDES;
 	mcp->mb[1] = addr;
-	mcp->mb[2] = data & 0xff;
+	if (IS_QLA2031(vha->hw))
+		mcp->mb[2] = data & 0xff;
+	else
+		mcp->mb[2] = data;
+
 	mcp->mb[3] = 0;
 	mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
@@ -2872,7 +2876,7 @@ qla2x00_read_serdes_word(scsi_qla_host_t *vha, uint16_t addr, uint16_t *data)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_QLA2031(vha->hw))
+	if (!IS_QLA2031(vha->hw) && !IS_QLA27XX(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1185,
@@ -2887,7 +2891,10 @@ qla2x00_read_serdes_word(scsi_qla_host_t *vha, uint16_t addr, uint16_t *data)
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
 
-	*data = mcp->mb[1] & 0xff;
+	if (IS_QLA2031(vha->hw))
+		*data = mcp->mb[1] & 0xff;
+	else
+		*data = mcp->mb[1];
 
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_mbx, vha, 0x1186,
-- 
1.7.7

