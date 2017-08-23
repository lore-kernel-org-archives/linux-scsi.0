From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 21/31] qla2xxx: Remove potential macro parameter side-effect in ql_dump_regs()
Date: Wed, 23 Aug 2017 15:05:15 -0700
Message-ID: <20170823220525.3115-22-himanshu.madhani@cavium.com>
References: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0050.outbound.protection.outlook.com ([104.47.33.50]:49856
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751076AbdHWWkd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:40:33 -0400
In-Reply-To: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 065449e0f347..3e9dc54b89a3 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -2736,9 +2736,9 @@ ql_dump_regs(uint32_t level, scsi_qla_host_t *vha, int32_t id)
 		mbx_reg = MAILBOX_REG(ha, reg, 0);
 
 	ql_dbg(level, vha, id, "Mailbox registers:\n");
-	for (i = 0; i < 6; i++)
+	for (i = 0; i < 6; i++, mbx_reg++)
 		ql_dbg(level, vha, id,
-		    "mbox[%d] 0x%04x\n", i, RD_REG_WORD(mbx_reg++));
+		    "mbox[%d] 0x%04x\n", i, RD_REG_WORD(mbx_reg));
 }
 
 
-- 
2.12.0
