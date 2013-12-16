From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 12/24] qla4xxx: Fix processing response queue during probe
Date: Mon, 16 Dec 2013 06:49:42 -0500
Message-ID: <1387194594-29817-13-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:42611 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754323Ab3LPMXl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:41 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>

From: Tej Parkash <tej.parkash@qlogic.com>

Issue:
While booting with kdump kernel, driver receive IOCB interrupts
for which it is not ready which results in processing them
before init_firmware during driver probe

Fix:
Two steps solution
1. Make driver ready to process the interrupt before interupts
   handlers is registered.
2. Stop driver processing iocb interrupts if not generated as per
   firmware protocol i.e R2H bit set

Signed-off-by: Tej Parkash <tej.parkash@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_isr.c | 15 ++++++++++++---
 drivers/scsi/qla4xxx/ql4_mbx.c |  3 ---
 drivers/scsi/qla4xxx/ql4_nx.c  |  4 ++++
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 49032f6..df3fd9b 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -1022,7 +1022,8 @@ void qla4_82xx_interrupt_service_routine(struct scsi_qla_host *ha,
     uint32_t intr_status)
 {
 	/* Process response queue interrupt. */
-	if (intr_status & HSRX_RISC_IOCB_INT)
+	if ((intr_status & HSRX_RISC_IOCB_INT) &&
+	    test_bit(AF_INIT_DONE, &ha->flags))
 		qla4xxx_process_response_queue(ha);
 
 	/* Process mailbox/asynch event interrupt.*/
@@ -1399,6 +1400,7 @@ qla4_8xxx_msix_rsp_q(int irq, void *dev_id)
 {
 	struct scsi_qla_host *ha = dev_id;
 	unsigned long flags;
+	int intr_status;
 	uint32_t ival = 0;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -1412,8 +1414,15 @@ qla4_8xxx_msix_rsp_q(int irq, void *dev_id)
 		qla4xxx_process_response_queue(ha);
 		writel(0, &ha->qla4_83xx_reg->iocb_int_mask);
 	} else {
-		qla4xxx_process_response_queue(ha);
-		writel(0, &ha->qla4_82xx_reg->host_int);
+		intr_status = readl(&ha->qla4_82xx_reg->host_status);
+		if (intr_status & HSRX_RISC_IOCB_INT) {
+			qla4xxx_process_response_queue(ha);
+			writel(0, &ha->qla4_82xx_reg->host_int);
+		} else {
+			ql4_printk(KERN_INFO, ha, "%s: spurious iocb interrupt...\n",
+				   __func__);
+			goto exit_msix_rsp_q;
+		}
 	}
 	ha->isr_count++;
 exit_msix_rsp_q:
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 1d8f485..cc27d7f 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -648,9 +648,6 @@ int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha)
 		goto exit_init_fw_cb;
 	}
 
-	/* Initialize request and response queues. */
-	qla4xxx_init_rings(ha);
-
 	/* Fill in the request and response queue information. */
 	init_fw_cb->rqq_consumer_idx = cpu_to_le16(ha->request_out);
 	init_fw_cb->compq_producer_idx = cpu_to_le16(ha->response_in);
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index cbc68f9..bcf3e43 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -3190,6 +3190,10 @@ int qla4_8xxx_load_risc(struct scsi_qla_host *ha)
 
 	retval = qla4_8xxx_device_state_handler(ha);
 
+	/* Initialize request and response queues. */
+	if (retval == QLA_SUCCESS)
+		qla4xxx_init_rings(ha);
+
 	if (retval == QLA_SUCCESS && !test_bit(AF_IRQ_ATTACHED, &ha->flags))
 		retval = qla4xxx_request_irqs(ha);
 
-- 
1.8.2.GIT

