From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 05/15] qla2xxx: ABBA lock ordering fix.
Date: Wed, 17 May 2006 15:09:06 -0700
Message-ID: <11479037412717-git-send-email-andrew.vasquez@qlogic.com>
References: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:52152 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751215AbWEQWJH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 18:09:07 -0400
In-Reply-To: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

In qla2x00_reset_chip the driver first takes the hardware lock,
and then later on takes the mbx lock.

In the mailbox_command code.. it goes the other way around.

Discovered with the lock validator.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

9c7f51db273860e0c1ab83176ac903bba7f0d19e
 drivers/scsi/qla2xxx/qla_init.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

9c7f51db273860e0c1ab83176ac903bba7f0d19e
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 1cf27fe..1289a18 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -411,7 +411,6 @@ qla2x00_reset_chip(scsi_qla_host_t *ha)
 	unsigned long   flags = 0;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint32_t	cnt;
-	unsigned long	mbx_flags = 0;
 	uint16_t	cmd;
 
 	ha->isp_ops.disable_intrs(ha);
@@ -519,20 +518,8 @@ qla2x00_reset_chip(scsi_qla_host_t *ha)
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha) || IS_QLA2300(ha)) {
 		for (cnt = 0; cnt < 30000; cnt++) {
-			if (!(test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags)))
-				spin_lock_irqsave(&ha->mbx_reg_lock, mbx_flags);
-
-			if (RD_MAILBOX_REG(ha, reg, 0) != MBS_BUSY) {
-				if (!(test_bit(ABORT_ISP_ACTIVE,
-				    &ha->dpc_flags)))
-					spin_unlock_irqrestore(
-					    &ha->mbx_reg_lock, mbx_flags);
+			if (RD_MAILBOX_REG(ha, reg, 0) != MBS_BUSY)
 				break;
-			}
-
-			if (!(test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags)))
-				spin_unlock_irqrestore(&ha->mbx_reg_lock,
-				    mbx_flags);
 
 			udelay(100);
 		}
-- 
1.3.3.g63df


