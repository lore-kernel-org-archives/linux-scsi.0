From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 1/6] qla4xxx: Disable INTx interrupt for ISP82XX
Date: Wed, 9 Apr 2014 21:12:24 -0400
Message-ID: <1397092349-25332-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1397092349-25332-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:2323 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934451AbaDJBwQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2014 21:52:16 -0400
In-Reply-To: <1397092349-25332-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, giridhar.malavali@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>

From: Tej Parkash <tej.parkash@qlogic.com>

Signed-off-by: Tej Parkash <tej.parkash@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_isr.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index b1925d1..081b6b7 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -1526,7 +1526,7 @@ void qla4xxx_process_aen(struct scsi_qla_host * ha, uint8_t process_aen)
 
 int qla4xxx_request_irqs(struct scsi_qla_host *ha)
 {
-	int ret;
+	int ret = 0;
 	int rval = QLA_ERROR;
 
 	if (is_qla40XX(ha))
@@ -1580,15 +1580,13 @@ try_msi:
 		}
 	}
 
-	/*
-	 * Prevent interrupts from falling back to INTx mode in cases where
-	 * interrupts cannot get acquired through MSI-X or MSI mode.
-	 */
+try_intx:
 	if (is_qla8022(ha)) {
-		ql4_printk(KERN_WARNING, ha, "IRQ not attached -- %d.\n", ret);
+		ql4_printk(KERN_WARNING, ha, "%s: ISP82xx Legacy interrupt not supported\n",
+			   __func__);
 		goto irq_not_attached;
 	}
-try_intx:
+
 	/* Trying INTx */
 	ret = request_irq(ha->pdev->irq, ha->isp_ops->intr_handler,
 	    IRQF_SHARED, DRIVER_NAME, ha);
-- 
1.8.2.GIT

