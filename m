From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 02/12] qla4xxx: initialize MSI in correct way
Date: Thu, 2 Dec 2010 22:12:08 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872243F4119@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:3222 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab0LCGMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2010 01:12:10 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Shyam Sundar <shyam.sundar@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Shyam Sundar <shyam.sundar@qlogic.com>

IRQF_SHARED flag should not be set when calling request_irq for MSI since
this interrupt mechanism cannot be shared like standard INTx

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Shyam Sundar <shyam.sundar@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_isr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 5d9575c..ca862b1 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -1077,7 +1077,7 @@ try_msi:
 	ret = pci_enable_msi(ha->pdev);
 	if (!ret) {
 		ret = request_irq(ha->pdev->irq, qla4_8xxx_msi_handler,
-			IRQF_SHARED, DRIVER_NAME, ha);
+			0, DRIVER_NAME, ha);
 		if (!ret) {
 			DEBUG2(ql4_printk(KERN_INFO, ha, "MSI: Enabled.\n"));
 			set_bit(AF_MSI_ENABLED, &ha->flags);
-- 
1.7.3.2

