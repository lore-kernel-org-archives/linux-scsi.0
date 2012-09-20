From: vikas.chaudhary@qlogic.com
Subject: [PATCH 06/13] qla4xxx: Prevent MSI/MSI-X falling back to INTx for ISP82XX
Date: Thu, 20 Sep 2012 07:35:06 -0400
Message-ID: <1348140913-11828-7-git-send-email-vikas.chaudhary@qlogic.com>
References: <1348140913-11828-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:39004 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754178Ab2ITLxF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2012 07:53:05 -0400
In-Reply-To: <1348140913-11828-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

For ISP82xx mixed interrupt mode is not supported.
Hence prevent MSI/MSI-x from falling back to INTx mode.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_isr.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 68bdb8c..5050321 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -1364,9 +1364,15 @@ try_msi:
 			pci_disable_msi(ha->pdev);
 		}
 	}
-	ql4_printk(KERN_WARNING, ha,
-	    "MSI: Falling back-to INTx mode -- %d.\n", ret);
 
+	/*
+	 * Prevent interrupts from falling back to INTx mode in cases where
+	 * interrupts cannot get acquired through MSI-X or MSI mode.
+	 */
+	if (is_qla8022(ha)) {
+		ql4_printk(KERN_WARNING, ha, "IRQ not attached -- %d.\n", ret);
+		goto irq_not_attached;
+	}
 try_intx:
 	/* Trying INTx */
 	ret = request_irq(ha->pdev->irq, ha->isp_ops->intr_handler,
@@ -1380,7 +1386,7 @@ try_intx:
 		ql4_printk(KERN_WARNING, ha,
 		    "INTx: Failed to reserve interrupt %d already in"
 		    " use.\n", ha->pdev->irq);
-		return ret;
+		goto irq_not_attached;
 	}
 
 irq_attached:
@@ -1388,6 +1394,7 @@ irq_attached:
 	ha->host->irq = ha->pdev->irq;
 	ql4_printk(KERN_INFO, ha, "%s: irq %d attached\n",
 	    __func__, ha->pdev->irq);
+irq_not_attached:
 	return ret;
 }
 
-- 
1.7.1

