From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 09/25] qla2xxx: Fix mailbox pointer error in classic fwdump.
Date: Fri, 19 May 2017 14:53:28 -0700
Message-ID: <20170519215344.2168-10-himanshu.madhani@cavium.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0072.outbound.protection.outlook.com ([104.47.42.72]:2990
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756809AbdESVyH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 17:54:07 -0400
In-Reply-To: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Cc: <stable@vger.kernel.org>
Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 51b4179469d1..88748a6ab73f 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1131,7 +1131,7 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	/* Mailbox registers. */
 	mbx_reg = &reg->mailbox0;
-	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, dmp_reg++)
+	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, mbx_reg++)
 		fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg));
 
 	/* Transfer sequence registers. */
@@ -2090,7 +2090,7 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	/* Mailbox registers. */
 	mbx_reg = &reg->mailbox0;
-	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, dmp_reg++)
+	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, mbx_reg++)
 		fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg));
 
 	/* Transfer sequence registers. */
-- 
2.12.0
