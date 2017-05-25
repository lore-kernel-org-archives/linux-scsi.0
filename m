From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 6/7] qla2xxx: Fix mailbox pointer error in fwdump capture.
Date: Wed, 24 May 2017 18:06:23 -0700
Message-ID: <20170525010624.8886-7-himanshu.madhani@cavium.com>
References: <20170525010624.8886-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0072.outbound.protection.outlook.com ([104.47.41.72]:11776
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1162190AbdEYBGn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 May 2017 21:06:43 -0400
In-Reply-To: <20170525010624.8886-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Cc: <stable@vger.kernel.org> # 4.10
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
