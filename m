From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 39/42] qla2xxx: Don't toggle RISC interrupt bits after IRQ lines are attached.
Date: Wed, 22 Aug 2012 14:21:33 -0400
Message-ID: <1345659696-3670-40-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:9483 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S965019Ab2HVSii (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:38 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c93cd65..2349d2e 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2948,21 +2948,9 @@ skip_msi:
 
 clear_risc_ints:
 
-	/*
-	 * FIXME: Noted that 8014s were being dropped during NK testing.
-	 * Timing deltas during MSI-X/INTa transitions?
-	 */
-	if (IS_QLA81XX(ha) || IS_QLA82XX(ha) || IS_QLA83XX(ha))
-		goto fail;
 	spin_lock_irq(&ha->hardware_lock);
-	if (IS_FWI2_CAPABLE(ha)) {
-		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_HOST_INT);
-		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_RISC_INT);
-	} else {
+	if (!IS_FWI2_CAPABLE(ha))
 		WRT_REG_WORD(&reg->isp.semaphore, 0);
-		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_RISC_INT);
-		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_HOST_INT);
-	}
 	spin_unlock_irq(&ha->hardware_lock);
 
 fail:
-- 
1.7.7

