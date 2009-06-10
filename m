From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Resolved a performance issue in interrupt
Date: Wed, 10 Jun 2009 13:55:11 -0700 (PDT)
Message-ID: <alpine.OSX.1.00.0906101349480.5521@ac-mac.local>
References: <B8134F80-B547-4E04-890A-6B646D2BA3E8@qlogic.com>  <20080911201140.GM2772@parisc-linux.org>  <20090610183259.GI89096@n6013ncj7y1lh1.qlogic.org> <1244661018.17432.21.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:44734 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbZFJUzJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2009 16:55:09 -0400
In-Reply-To: <1244661018.17432.21.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>, David Wagner <david.wagner@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, "douglas.w.styner@intel.com" <douglas.w.styner@intel.com>, "sharad.c.tripathi@intel.com" <sharad.c.tripathi@intel.com>, "chinang.ma@intel.com" <chinang.ma@intel.com>, "terry.o.prickett@intel.com" <terry.o.prickett@intel.com>

This is the updated patch. Please apply.
Thanks,
Anirban

Reverted back a change in qla*_intr_handler code that caused
an increase in cpu cycles.

Reported-and-tested-by: Douglas W. Styner <douglas.w.styner@intel.com>
Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c8d0a17..245e7af 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -37,6 +37,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 	uint16_t	hccr;
 	uint16_t	mb[4];
 	struct rsp_que *rsp;
+	unsigned long	flags;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -49,7 +50,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 	reg = &ha->iobase->isp;
 	status = 0;
 
-	spin_lock(&ha->hardware_lock);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		hccr = RD_REG_WORD(&reg->hccr);
@@ -101,7 +102,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 			RD_REG_WORD(&reg->hccr);
 		}
 	}
-	spin_unlock(&ha->hardware_lock);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
@@ -133,6 +134,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 	uint16_t	mb[4];
 	struct rsp_que *rsp;
 	struct qla_hw_data *ha;
+	unsigned long	flags;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -145,7 +147,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 	reg = &ha->iobase->isp;
 	status = 0;
 
-	spin_lock(&ha->hardware_lock);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
@@ -216,7 +218,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 		WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
 		RD_REG_WORD_RELAXED(&reg->hccr);
 	}
-	spin_unlock(&ha->hardware_lock);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
@@ -1626,6 +1628,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	uint32_t	hccr;
 	uint16_t	mb[4];
 	struct rsp_que *rsp;
+	unsigned long	flags;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -1638,7 +1641,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	reg = &ha->iobase->isp24;
 	status = 0;
 
-	spin_lock(&ha->hardware_lock);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 	for (iter = 50; iter--; ) {
 		stat = RD_REG_DWORD(&reg->host_status);
@@ -1688,7 +1691,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 		RD_REG_DWORD_RELAXED(&reg->hccr);
 	}
-	spin_unlock(&ha->hardware_lock);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
-- 
1.5.5


