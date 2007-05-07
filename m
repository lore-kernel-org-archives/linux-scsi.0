From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/6] qla2xxx: Add MSI support.
Date: Mon,  7 May 2007 07:43:02 -0700
Message-ID: <11785489833889-git-send-email-andrew.vasquez@qlogic.com>
References: <20070507144216.GC7207@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47147 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934233AbXEGOnd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 10:43:33 -0400
In-Reply-To: <20070507144216.GC7207@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Supported ISP types include ISP2422 and revision-2 type
ISP2432 chips.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d488561..ca46346 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1726,6 +1726,17 @@ qla2x00_request_irqs(scsi_qla_host_t *ha)
 	qla_printk(KERN_WARNING, ha,
 	    "MSI-X: Falling back-to INTa mode -- %d.\n", ret);
 skip_msix:
+
+	if (!IS_QLA24XX(ha))
+		goto skip_msi;
+
+	ret = pci_enable_msi(ha->pdev);
+	if (!ret) {
+		DEBUG2(qla_printk(KERN_INFO, ha, "MSI: Enabled.\n"));
+		ha->flags.msi_enabled = 1;
+	}
+skip_msi:
+
 	ret = request_irq(ha->pdev->irq, ha->isp_ops.intr_handler,
 	    IRQF_DISABLED|IRQF_SHARED, QLA2XXX_DRIVER_NAME, ha);
 	if (!ret) {
@@ -1746,6 +1757,8 @@ qla2x00_free_irqs(scsi_qla_host_t *ha)
 
 	if (ha->flags.msix_enabled)
 		qla24xx_disable_msix(ha);
-	else if (ha->flags.inta_enabled)
+	else if (ha->flags.inta_enabled) {
 		free_irq(ha->host->irq, ha);
+		pci_disable_msi(ha->pdev);
+	}
 }
-- 
1.5.2.rc1.9.g6644

