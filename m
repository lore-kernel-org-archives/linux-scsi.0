From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [PATCH] qla2xxx:use spin_lock_irqsave/spin_unlock_irqrestore
  in irq handler
Date: Mon, 13 Apr 2009 19:40:29 +0900
Message-ID: <6.0.0.20.2.20090413190947.079089b0@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:47751 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZDNJXk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2009 05:23:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, linux-driver@qlogic.com

Hi

I think spin_lock_irqsave/spin_unlock_irqrestore instead of spin_lock_irq/spin_unlock_irq
should be used in IRQ handler.
Following is the patch that fixes this issue.
Thanks.

Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.30-rc1.org/drivers/scsi/qla2xxx/qla_isr.c linux-2.6.30-rc1.qla/drivers/scsi/qla2xxx/qla_isr.c
--- linux-2.6.30-rc1.org/drivers/scsi/qla2xxx/qla_isr.c	2009-04-09 17:18:06.000000000 +0900
+++ linux-2.6.30-rc1.qla/drivers/scsi/qla2xxx/qla_isr.c	2009-04-13 18:21:02.000000000 +0900
@@ -1692,6 +1692,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id
 	struct qla_hw_data *ha;
 	struct rsp_que *rsp;
 	struct device_reg_24xx __iomem *reg;
+	unsigned long flags;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -1702,12 +1703,12 @@ qla24xx_msix_rsp_q(int irq, void *dev_id
 	ha = rsp->hw;
 	reg = &ha->iobase->isp24;
 
-	spin_lock_irq(&ha->hardware_lock);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	qla24xx_process_response_queue(rsp);
 	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 
-	spin_unlock_irq(&ha->hardware_lock);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return IRQ_HANDLED;
 }
@@ -1718,6 +1719,7 @@ qla25xx_msix_rsp_q(int irq, void *dev_id
 	struct qla_hw_data *ha;
 	struct rsp_que *rsp;
 	struct device_reg_24xx __iomem *reg;
+	unsigned long flags;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -1728,11 +1730,11 @@ qla25xx_msix_rsp_q(int irq, void *dev_id
 	ha = rsp->hw;
 	reg = &ha->iobase->isp24;
 
-	spin_lock_irq(&ha->hardware_lock);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	qla24xx_process_response_queue(rsp);
 
-	spin_unlock_irq(&ha->hardware_lock);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return IRQ_HANDLED;
 }
@@ -1748,6 +1750,7 @@ qla24xx_msix_default(int irq, void *dev_
 	uint32_t	stat;
 	uint32_t	hccr;
 	uint16_t	mb[4];
+	unsigned long flags;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -1759,7 +1762,7 @@ qla24xx_msix_default(int irq, void *dev_
 	reg = &ha->iobase->isp24;
 	status = 0;
 
-	spin_lock_irq(&ha->hardware_lock);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = qla2x00_get_rsp_host(rsp);
 	do {
 		stat = RD_REG_DWORD(&reg->host_status);
@@ -1808,7 +1811,7 @@ qla24xx_msix_default(int irq, void *dev_
 		}
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 	} while (0);
-	spin_unlock_irq(&ha->hardware_lock);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {

