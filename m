From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 7/9] qla2xxx: Perform a fw-dump when an ISP23xx RISC-paused state is detected.
Date: Wed, 13 Dec 2006 19:20:31 -0800
Message-ID: <11660664333401-git-send-email-andrew.vasquez@qlogic.com>
References: <20061214031935.GB538@andrew-vasquezs-powerbook-g4-15.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:39867 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbWLNDdr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Dec 2006 22:33:47 -0500
In-Reply-To: <20061214031935.GB538@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 79115c1..6a741e3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -134,11 +134,11 @@ qla2300_intr_handler(int irq, void *dev_id)
 		if (stat & HSR_RISC_PAUSED) {
 			hccr = RD_REG_WORD(&reg->hccr);
 			if (hccr & (BIT_15 | BIT_13 | BIT_11 | BIT_8))
-				qla_printk(KERN_INFO, ha,
-				    "Parity error -- HCCR=%x.\n", hccr);
+				qla_printk(KERN_INFO, ha, "Parity error -- "
+				    "HCCR=%x, Dumping firmware!\n", hccr);
 			else
-				qla_printk(KERN_INFO, ha,
-				    "RISC paused -- HCCR=%x.\n", hccr);
+				qla_printk(KERN_INFO, ha, "RISC paused -- "
+				    "HCCR=%x, Dumping firmware!\n", hccr);
 
 			/*
 			 * Issue a "HARD" reset in order for the RISC
@@ -147,6 +147,8 @@ qla2300_intr_handler(int irq, void *dev_id)
 			 */
 			WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
 			RD_REG_WORD(&reg->hccr);
+
+			ha->isp_ops.fw_dump(ha, 1);
 			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 			break;
 		} else if ((stat & HSR_RISC_INT) == 0)
-- 
1.4.4.2.g4cfec

