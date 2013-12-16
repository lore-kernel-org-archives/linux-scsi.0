From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 09/24] qla4xxx: Return correct error status from func qla4xxx_request_irqs()
Date: Mon, 16 Dec 2013 06:49:39 -0500
Message-ID: <1387194594-29817-10-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:39166 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754300Ab3LPMXZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:25 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_isr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index e56c6b4..49032f6 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -1488,6 +1488,7 @@ void qla4xxx_process_aen(struct scsi_qla_host * ha, uint8_t process_aen)
 int qla4xxx_request_irqs(struct scsi_qla_host *ha)
 {
 	int ret;
+	int rval = QLA_ERROR;
 
 	if (is_qla40XX(ha))
 		goto try_intx;
@@ -1568,9 +1569,10 @@ irq_attached:
 	set_bit(AF_IRQ_ATTACHED, &ha->flags);
 	ha->host->irq = ha->pdev->irq;
 	ql4_printk(KERN_INFO, ha, "%s: irq %d attached\n",
-	    __func__, ha->pdev->irq);
+		   __func__, ha->pdev->irq);
+	rval = QLA_SUCCESS;
 irq_not_attached:
-	return ret;
+	return rval;
 }
 
 void qla4xxx_free_irqs(struct scsi_qla_host *ha)
-- 
1.8.2.GIT

