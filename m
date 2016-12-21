From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 05/10] qla2xxx: Collect additional information to debug fw dump.
Date: Wed, 21 Dec 2016 13:57:34 -0800
Message-ID: <1482357459-31079-6-git-send-email-himanshu.madhani@cavium.com>
References: <1482357459-31079-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0051.outbound.protection.outlook.com ([104.47.36.51]:3236
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1759739AbcLUV6X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Dec 2016 16:58:23 -0500
In-Reply-To: <1482357459-31079-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 2819ceb..b4386fc 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -323,20 +323,33 @@ static int is_rom_cmd(uint16_t cmd)
 		}
 	} else {
 
-		uint16_t mb0;
-		uint32_t ictrl;
+		uint16_t mb[8];
+		uint32_t ictrl, host_status, hccr;
 		uint16_t        w;
 
 		if (IS_FWI2_CAPABLE(ha)) {
-			mb0 = RD_REG_WORD(&reg->isp24.mailbox0);
+			mb[0] = RD_REG_WORD(&reg->isp24.mailbox0);
+			mb[1] = RD_REG_WORD(&reg->isp24.mailbox1);
+			mb[2] = RD_REG_WORD(&reg->isp24.mailbox2);
+			mb[3] = RD_REG_WORD(&reg->isp24.mailbox3);
+			mb[7] = RD_REG_WORD(&reg->isp24.mailbox7);
 			ictrl = RD_REG_DWORD(&reg->isp24.ictrl);
+			host_status = RD_REG_DWORD(&reg->isp24.host_status);
+			hccr = RD_REG_DWORD(&reg->isp24.hccr);
+
+			ql_log(ql_log_warn, vha, 0x1119,
+			    "MBX Command timeout for cmd %x, iocontrol=%x jiffies=%lx "
+			    "mb[0-3]=[0x%x 0x%x 0x%x 0x%x] mb7 0x%x host_status 0x%x hccr 0x%x\n",
+			    command, ictrl, jiffies, mb[0], mb[1], mb[2], mb[3],
+			    mb[7], host_status, hccr);
+
 		} else {
-			mb0 = RD_MAILBOX_REG(ha, &reg->isp, 0);
+			mb[0] = RD_MAILBOX_REG(ha, &reg->isp, 0);
 			ictrl = RD_REG_WORD(&reg->isp.ictrl);
+			ql_dbg(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1119,
+			    "MBX Command timeout for cmd %x, iocontrol=%x jiffies=%lx "
+			    "mb[0]=0x%x\n", command, ictrl, jiffies, mb[0]);
 		}
-		ql_dbg(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1119,
-		    "MBX Command timeout for cmd %x, iocontrol=%x jiffies=%lx "
-		    "mb[0]=0x%x\n", command, ictrl, jiffies, mb0);
 		ql_dump_regs(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1019);
 
 		/* Capture FW dump only, if PCI device active */
-- 
1.8.3.1

