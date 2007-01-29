From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/14] qla2xxx: Handle IRQ-0 assignments by the system.
Date: Mon, 29 Jan 2007 10:22:20 -0800
Message-ID: <11700949513719-git-send-email-andrew.vasquez@qlogic.com>
References: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47719 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbXA2SWf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2007 13:22:35 -0500
In-Reply-To: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

No restriction should be placed on the IRQ number assigned
to a given ISP.  Original code incorrectly assumed a
non-zero IRQ number assignment by the system.  In these
circumstances the proper freeing of the IRQ (via free_irq())
would not take place.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    1 +
 drivers/scsi/qla2xxx/qla_isr.c |    8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 9b7bcc0..53dd546 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2098,6 +2098,7 @@ typedef struct scsi_qla_host {
 		uint32_t	enable_lip_full_login	:1;
 		uint32_t	enable_target_reset	:1;
 		uint32_t	enable_led_scheme	:1;
+		uint32_t	inta_enabled		:1;
 		uint32_t	msi_enabled		:1;
 		uint32_t	msix_enabled		:1;
 		uint32_t	disable_serdes		:1;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d6f396d..fe8a264 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1728,12 +1728,14 @@ qla2x00_request_irqs(scsi_qla_host_t *ha)
 skip_msix:
 	ret = request_irq(ha->pdev->irq, ha->isp_ops.intr_handler,
 	    IRQF_DISABLED|IRQF_SHARED, QLA2XXX_DRIVER_NAME, ha);
-	if (ret) {
+	if (!ret) {
+		ha->flags.inta_enabled = 1;
+		ha->host->irq = ha->pdev->irq;
+	} else {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to reserve interrupt %d already in use.\n",
 		    ha->pdev->irq);
 	}
-	ha->host->irq = ha->pdev->irq;
 
 	return ret;
 }
@@ -1744,6 +1746,6 @@ qla2x00_free_irqs(scsi_qla_host_t *ha)
 
 	if (ha->flags.msix_enabled)
 		qla24xx_disable_msix(ha);
-	else if (ha->host->irq)
+	else if (ha->flags.inta_enabled)
 		free_irq(ha->host->irq, ha);
 }
-- 
1.5.0.rc2.gdbaa0

