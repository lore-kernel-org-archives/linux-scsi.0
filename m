From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: [PATCH] qla2xxx: Fix a bug that clears the interrupt status register
 for the base queue
Date: Tue, 4 Aug 2009 16:12:13 -0700 (PDT)
Message-ID: <alpine.OSX.1.00.0908041526530.4279@n6014avbhkh7b1.qlogic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:35368 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933093AbZHDX1c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2009 19:27:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com

The interrupt handler clears the interrupt status register for response updates in the
base queue while working in the multique mode. This could lead to missing interrupt for
async events, mail box completions etc. as these are also handled in the base queue.
The fix ensures that the interrupt bit is not cleared for response updates in the ISR
when the driver is working in multiqueue mode.

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 41f3a26..2ff01d7 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1837,8 +1837,10 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 
 	vha = qla25xx_get_host(rsp);
 	qla24xx_process_response_queue(vha, rsp);
-	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
-
+	if (!ha->mqenable) {
+		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
+		RD_REG_DWORD_RELAXED(&reg->hccr);
+	}
 	spin_unlock_irq(&ha->hardware_lock);
 
 	return IRQ_HANDLED;
-- 
1.6.3.3

