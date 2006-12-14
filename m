From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 8/9] qla2xxx: Use generic isp_ops.fw_dump() function.
Date: Wed, 13 Dec 2006 19:20:32 -0800
Message-ID: <11660664332780-git-send-email-andrew.vasquez@qlogic.com>
References: <20061214031935.GB538@andrew-vasquezs-powerbook-g4-15.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:39867 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbWLNDds (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Dec 2006 22:33:48 -0500
In-Reply-To: <20061214031935.GB538@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Rather than a direct call, as was done in the case of a
RISC-paused state within the ISP24xx interrupt handler.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6a741e3..39fd17b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1444,8 +1444,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 
 			qla_printk(KERN_INFO, ha, "RISC paused -- HCCR=%x, "
 			    "Dumping firmware!\n", hccr);
-			qla24xx_fw_dump(ha, 1);
-
+			ha->isp_ops.fw_dump(ha, 1);
 			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 			break;
 		} else if ((stat & HSRX_RISC_INT) == 0)
-- 
1.4.4.2.g4cfec

