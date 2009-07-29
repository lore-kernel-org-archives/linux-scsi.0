From: giridhar.malavali@qlogic.com
Subject: [PATCH 11/14] qla2xxx: Fix a bug that clears the interrupt status register for the base queue
Date: Wed, 29 Jul 2009 11:04:00 -0700
Message-ID: <1248890643-761-12-git-send-email-giridhar.malavali@qlogic.com>
References: <1248890643-761-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:35945 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751635AbZG2SEG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 14:04:06 -0400
In-Reply-To: <1248890643-761-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

The interrupt handler clears the interrupt status register for response updates in the
base queue while working in the multique mode. This could lead to missing interrupt for
async events, mail box completions etc. as these are also handled in the base queue.
The fix ensures that the interrupt bit is not cleared for response updates in the ISR
when the driver is working in multiqueue mode.

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 40014f3..175b20b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1769,7 +1769,8 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 
 	vha = qla25xx_get_host(rsp);
 	qla24xx_process_response_queue(vha, rsp);
-	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
+	if (!ha->mqenable)
+		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 
 	spin_unlock_irq(&ha->hardware_lock);
 
-- 
1.6.2.rc1.30.gd43c

