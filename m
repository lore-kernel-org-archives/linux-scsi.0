From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 01/12] qla4xxx: Drop use of IRQF_DISABLE
Date: Thu, 2 Dec 2010 22:12:03 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872243F4118@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:3215 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab0LCGMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2010 01:12:06 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

IRQF_DISABLE flag is deprecated and this flag is a NOOP in kernel.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_isr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 7c33fd5..5d9575c 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -1077,7 +1077,7 @@ try_msi:
 	ret = pci_enable_msi(ha->pdev);
 	if (!ret) {
 		ret = request_irq(ha->pdev->irq, qla4_8xxx_msi_handler,
-			IRQF_DISABLED|IRQF_SHARED, DRIVER_NAME, ha);
+			IRQF_SHARED, DRIVER_NAME, ha);
 		if (!ret) {
 			DEBUG2(ql4_printk(KERN_INFO, ha, "MSI: Enabled.\n"));
 			set_bit(AF_MSI_ENABLED, &ha->flags);
@@ -1095,7 +1095,7 @@ try_msi:
 try_intx:
 	/* Trying INTx */
 	ret = request_irq(ha->pdev->irq, ha->isp_ops->intr_handler,
-	    IRQF_DISABLED|IRQF_SHARED, DRIVER_NAME, ha);
+	    IRQF_SHARED, DRIVER_NAME, ha);
 	if (!ret) {
 		DEBUG2(ql4_printk(KERN_INFO, ha, "INTx: Enabled.\n"));
 		set_bit(AF_INTx_ENABLED, &ha->flags);
-- 
1.7.3.2

