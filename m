From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] qla2xxx: Restrict MSI/MSI-X enablement on select ISP2432-type HBAs.
Date: Thu, 17 Jan 2008 09:02:11 -0800
Message-ID: <1200589340-19499-5-git-send-email-andrew.vasquez@qlogic.com>
References: <20080117165940.GA19033@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20849 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYAQRCd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 12:02:33 -0500
In-Reply-To: <20080117165940.GA19033@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5d2dc92..22216fe 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1829,6 +1829,18 @@ qla2x00_request_irqs(scsi_qla_host_t *ha)
 		goto skip_msix;
 	}
 
+	if (ha->pdev->subsystem_vendor == PCI_VENDOR_ID_HP &&
+	    (ha->pdev->subsystem_device == 0x7040 ||
+		ha->pdev->subsystem_device == 0x7041 ||
+		ha->pdev->subsystem_device == 0x1705)) {
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+		    "MSI-X: Unsupported ISP2432 SSVID/SSDID (0x%X, 0x%X).\n",
+		    ha->pdev->subsystem_vendor,
+		    ha->pdev->subsystem_device));
+
+		goto skip_msi;
+	}
+
 	ret = qla24xx_enable_msix(ha);
 	if (!ret) {
 		DEBUG2(qla_printk(KERN_INFO, ha,
-- 
1.5.4.rc3.14.g44397

