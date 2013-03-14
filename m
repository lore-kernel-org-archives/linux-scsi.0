From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH V2 05/12] pm80xx: MSI-X implementation for using 64 interrupts
Date: Thu, 14 Mar 2013 04:04:01 -0700
Message-ID: <5141AEA1.4030501@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020306040400030009060205"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:47079 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756007Ab3CNLCw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Mar 2013 07:02:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Harry.Yang@pmcs.com, Sangeetha.Gnanasekaran@pmcs.com, sakthivel.sk@hcl.com, xjtuwjp@gmail.com, Vishwanath.Maram@pmcs.com, rich.Bono@pmcs.com

This is a multi-part message in MIME format.
--------------020306040400030009060205
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 62b6f575d1978a965339c69158bd10d0529815fb Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Mon, 11 Mar 2013 20:20:19 +0530
Subject: [PATCH V2 05/12] pm80xx: MSI-X implementation for using 64 interrupts

Implementation of interrupt handlers and tasklets to support
upto 64 interrupt for the device.

Signed-off-by: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
Ack-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/pm8001/pm8001_init.c |  456 +++++++++++++++++++++++++++++++++++--
 drivers/scsi/pm8001/pm8001_sas.h  |    1 +
 2 files changed, 432 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index e8a983f..95b6966 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -163,24 +163,33 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
 }
 
 #ifdef PM8001_USE_TASKLET
+
+/**
+ * tasklet for 64 msi-x interrupt handler
+ * @opaque: the passed general host adapter struct
+ * Note: pm8001_tasklet is common for pm8001 & pm80xx
+ */
 static void pm8001_tasklet(unsigned long opaque)
 {
 	struct pm8001_hba_info *pm8001_ha;
+	u32 vec;
 	pm8001_ha = (struct pm8001_hba_info *)opaque;
 	if (unlikely(!pm8001_ha))
 		BUG_ON(1);
-	PM8001_CHIP_DISP->isr(pm8001_ha, 0);
+	vec = pm8001_ha->int_vector;
+	PM8001_CHIP_DISP->isr(pm8001_ha, vec);
 }
 #endif
 
+/**
+ * pm8001_interrupt_handler_x -main interrupt handler invokde for all interrupt.
+ * It obtains the vector number and calls the equivalent bottom half or services
+ * directly.
+ * @vec: vector number; will be 0 for none msi-x operation
+ * @opaque: the passed general host adapter struct
+ */
 
- /**
-  * pm8001_interrupt - when HBA originate a interrupt,we should invoke this
-  * dispatcher to handle each case.
-  * @irq: irq number.
-  * @opaque: the passed general host adapter struct
-  */
-static irqreturn_t pm8001_interrupt(int irq, void *opaque)
+static inline irqreturn_t pm8001_interrupt_handler_x(int vec, void *opaque)
 {
 	struct pm8001_hba_info *pm8001_ha;
 	irqreturn_t ret = IRQ_HANDLED;
@@ -190,6 +199,7 @@ static irqreturn_t pm8001_interrupt(int irq, void *opaque)
 		return IRQ_NONE;
 	if (!PM8001_CHIP_DISP->is_our_interupt(pm8001_ha))
 		return IRQ_NONE;
+	pm8001_ha->int_vector = vec;
 #ifdef PM8001_USE_TASKLET
 	tasklet_schedule(&pm8001_ha->tasklet);
 #else
@@ -198,6 +208,365 @@ static irqreturn_t pm8001_interrupt(int irq, void *opaque)
 	return ret;
 }
 
+/* 64 interrupt handlers for 64 msi-x vectors */
+static irqreturn_t pm8001_interrupt_handler0(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(0, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler1(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(1, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler2(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(2, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler3(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(3, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler4(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(4, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler5(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(5, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler6(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(6, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler7(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(7, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler8(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(8, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler9(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(9, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler10(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(10, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler11(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(11, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler12(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(12, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler13(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(13, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler14(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(14, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler15(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(15, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler16(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(16, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler17(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(17, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler18(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(18, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler19(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(19, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler20(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(20, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler21(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(21, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler22(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(22, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler23(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(23, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler24(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(24, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler25(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(25, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler26(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(26, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler27(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(27, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler28(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(28, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler29(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(29, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler30(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(30, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler31(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(31, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler32(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(32, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler33(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(33, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler34(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(34, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler35(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(35, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler36(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(36, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler37(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(37, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler38(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(38, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler39(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(39, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler40(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(40, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler41(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(41, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler42(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(42, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler43(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(43, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler44(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(44, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler45(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(45, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler46(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(46, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler47(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(47, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler48(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(48, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler49(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(49, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler50(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(50, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler51(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(51, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler52(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(52, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler53(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(53, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler54(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(54, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler55(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(55, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler56(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(56, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler57(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(57, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler58(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(58, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler59(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(59, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler60(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(60, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler61(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(61, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler62(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(62, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler63(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(63, dev_id);
+}
+
+/* array of 64 interrupt handlers used during request_irq for msi-x int */
+/* pm8001_interrupt_handler0 routine is common for pm8001 & pm80xx */
+static irqreturn_t (*pm8001_interrupt[PM8001_MAX_MSIX_VEC])
+		(int vec, void *dev_id) = {
+	pm8001_interrupt_handler0, pm8001_interrupt_handler1,
+	pm8001_interrupt_handler2, pm8001_interrupt_handler3,
+	pm8001_interrupt_handler4, pm8001_interrupt_handler5,
+	pm8001_interrupt_handler6, pm8001_interrupt_handler7,
+	pm8001_interrupt_handler8, pm8001_interrupt_handler9,
+	pm8001_interrupt_handler10, pm8001_interrupt_handler11,
+	pm8001_interrupt_handler12, pm8001_interrupt_handler13,
+	pm8001_interrupt_handler14, pm8001_interrupt_handler15,
+	pm8001_interrupt_handler16, pm8001_interrupt_handler17,
+	pm8001_interrupt_handler18, pm8001_interrupt_handler19,
+	pm8001_interrupt_handler20, pm8001_interrupt_handler21,
+	pm8001_interrupt_handler22, pm8001_interrupt_handler23,
+	pm8001_interrupt_handler24, pm8001_interrupt_handler25,
+	pm8001_interrupt_handler26, pm8001_interrupt_handler27,
+	pm8001_interrupt_handler28, pm8001_interrupt_handler29,
+	pm8001_interrupt_handler30, pm8001_interrupt_handler31,
+	pm8001_interrupt_handler32, pm8001_interrupt_handler33,
+	pm8001_interrupt_handler34, pm8001_interrupt_handler35,
+	pm8001_interrupt_handler36, pm8001_interrupt_handler37,
+	pm8001_interrupt_handler38, pm8001_interrupt_handler39,
+	pm8001_interrupt_handler40, pm8001_interrupt_handler41,
+	pm8001_interrupt_handler42, pm8001_interrupt_handler43,
+	pm8001_interrupt_handler44, pm8001_interrupt_handler45,
+	pm8001_interrupt_handler46, pm8001_interrupt_handler47,
+	pm8001_interrupt_handler48, pm8001_interrupt_handler49,
+	pm8001_interrupt_handler50, pm8001_interrupt_handler51,
+	pm8001_interrupt_handler52, pm8001_interrupt_handler53,
+	pm8001_interrupt_handler54, pm8001_interrupt_handler55,
+	pm8001_interrupt_handler56, pm8001_interrupt_handler57,
+	pm8001_interrupt_handler58, pm8001_interrupt_handler59,
+	pm8001_interrupt_handler60, pm8001_interrupt_handler61,
+	pm8001_interrupt_handler62, pm8001_interrupt_handler63
+};
+
 /**
  * pm8001_alloc - initiate our hba structure and 6 DMAs area.
  * @pm8001_ha:our hba structure.
@@ -431,8 +800,12 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 		pm8001_ha->iomb_size = IOMB_SIZE_SPC;
 
 #ifdef PM8001_USE_TASKLET
+	/**
+	* default tasklet for non msi-x interrupt handler/first msi-x
+	* interrupt handler
+	**/
 	tasklet_init(&pm8001_ha->tasklet, pm8001_tasklet,
-		(unsigned long)pm8001_ha);
+			(unsigned long)pm8001_ha);
 #endif
 	pm8001_ioremap(pm8001_ha);
 	if (!pm8001_alloc(pm8001_ha, ent))
@@ -595,26 +968,41 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
  * @chip_info: our ha struct.
  * @irq_handler: irq_handler
  */
-static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha,
-	irq_handler_t irq_handler)
+static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 {
 	u32 i = 0, j = 0;
-	u32 number_of_intr = 1;
+	u32 number_of_intr;
 	int flag = 0;
 	u32 max_entry;
 	int rc;
+	static char intr_drvname[PM8001_MAX_MSIX_VEC][sizeof(DRV_NAME)+3];
+
+	/* SPCv controllers supports 64 msi-x */
+	if (pm8001_ha->chip_id == chip_8001) {
+		number_of_intr = 1;
+		flag |= IRQF_DISABLED;
+	} else {
+		number_of_intr = PM8001_MAX_MSIX_VEC;
+		flag &= ~IRQF_SHARED;
+		flag |= IRQF_DISABLED;
+	}
+
 	max_entry = sizeof(pm8001_ha->msix_entries) /
 		sizeof(pm8001_ha->msix_entries[0]);
-	flag |= IRQF_DISABLED;
 	for (i = 0; i < max_entry ; i++)
 		pm8001_ha->msix_entries[i].entry = i;
 	rc = pci_enable_msix(pm8001_ha->pdev, pm8001_ha->msix_entries,
 		number_of_intr);
 	pm8001_ha->number_of_intr = number_of_intr;
 	if (!rc) {
+		PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
+			"pci_enable_msix request ret:%d no of intr %d\n",
+					rc, pm8001_ha->number_of_intr));
 		for (i = 0; i < number_of_intr; i++) {
+			snprintf(intr_drvname[i], sizeof(intr_drvname[0]),
+					DRV_NAME"%d", i);
 			if (request_irq(pm8001_ha->msix_entries[i].vector,
-				irq_handler, flag, DRV_NAME,
+				pm8001_interrupt[i], flag, intr_drvname[i],
 				SHOST_TO_SAS_HA(pm8001_ha->shost))) {
 				for (j = 0; j < i; j++)
 					free_irq(
@@ -636,22 +1024,24 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha,
 static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
 {
 	struct pci_dev *pdev;
-	irq_handler_t irq_handler = pm8001_interrupt;
 	int rc;
 
 	pdev = pm8001_ha->pdev;
 
 #ifdef PM8001_USE_MSIX
 	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX))
-		return pm8001_setup_msix(pm8001_ha, irq_handler);
-	else
+		return pm8001_setup_msix(pm8001_ha);
+	else {
+		PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("MSIX not supported!!!\n"));
 		goto intx;
+	}
 #endif
 
 intx:
 	/* initialize the INT-X interrupt */
-	rc = request_irq(pdev->irq, irq_handler, IRQF_SHARED, DRV_NAME,
-		SHOST_TO_SAS_HA(pm8001_ha->shost));
+	rc = request_irq(pdev->irq, pm8001_interrupt_handler0, IRQF_SHARED,
+		DRV_NAME, SHOST_TO_SAS_HA(pm8001_ha->shost));
 	return rc;
 }
 
@@ -669,6 +1059,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 {
 	unsigned int rc;
 	u32	pci_reg;
+	u8	i = 0;
 	struct pm8001_hba_info *pm8001_ha;
 	struct Scsi_Host *shost = NULL;
 	const struct pm8001_chip_info *chip;
@@ -733,6 +1124,11 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 		goto err_out_shost;
 
 	PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, 0);
+	if (pm8001_ha->chip_id != chip_8001) {
+		for (i = 1; i < pm8001_ha->number_of_intr; i++)
+			PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, i);
+	}
+
 	pm8001_init_sas_add(pm8001_ha);
 	pm8001_post_sas_ha_init(shost, chip);
 	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
@@ -768,7 +1164,7 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 	sas_remove_host(pm8001_ha->shost);
 	list_del(&pm8001_ha->list);
 	scsi_remove_host(pm8001_ha->shost);
-	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0);
+	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
 
 #ifdef PM8001_USE_MSIX
@@ -812,7 +1208,7 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		printk(KERN_ERR " PCI PM not supported\n");
 		return -ENODEV;
 	}
-	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0);
+	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
 #ifdef PM8001_USE_MSIX
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
@@ -847,6 +1243,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha;
 	int rc;
+	u8 i = 0;
 	u32 device_state;
 	pm8001_ha = sha->lldd_ha;
 	device_state = pdev->current_state;
@@ -873,15 +1270,24 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	rc = PM8001_CHIP_DISP->chip_init(pm8001_ha);
 	if (rc)
 		goto err_out_disable;
-	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0);
+
+	/* disable all the interrupt bits */
+	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
+
 	rc = pm8001_request_irq(pm8001_ha);
 	if (rc)
 		goto err_out_disable;
-	#ifdef PM8001_USE_TASKLET
+#ifdef PM8001_USE_TASKLET
+	/* default tasklet for non msi-x interrupt handler/first msi-x
+	* interrupt handler */
 	tasklet_init(&pm8001_ha->tasklet, pm8001_tasklet,
-		    (unsigned long)pm8001_ha);
-	#endif
+			(unsigned long)pm8001_ha);
+#endif
 	PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, 0);
+	if (pm8001_ha->chip_id != chip_8001) {
+		for (i = 1; i < pm8001_ha->number_of_intr; i++)
+			PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, i);
+	}
 	scsi_unblock_requests(pm8001_ha->shost);
 	return 0;
 
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index cf56580..58c4b3f 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -454,6 +454,7 @@ struct pm8001_hba_info {
 #endif
 	u32			logging_level;
 	u32			fw_status;
+	u32			int_vector;
 	const struct firmware 	*fw_image;
 };
 
-- 
1.7.1


--------------020306040400030009060205
Content-Type: text/plain; charset=windows-1252;
 name="0005-pm80xx-MSI-X-implementation-for-using-64-interrupts.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0005-pm80xx-MSI-X-implementation-for-using-64-interrupts.pat";
 filename*1="ch"

>From 62b6f575d1978a965339c69158bd10d0529815fb Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Mon, 11 Mar 2013 20:20:19 +0530
Subject: [PATCH V2 05/12] pm80xx: MSI-X implementation for using 64 interrupts

Implementation of interrupt handlers and tasklets to support
upto 64 interrupt for the device.

Signed-off-by: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
Ack-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/pm8001/pm8001_init.c |  456 +++++++++++++++++++++++++++++++++++--
 drivers/scsi/pm8001/pm8001_sas.h  |    1 +
 2 files changed, 432 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index e8a983f..95b6966 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -163,24 +163,33 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
 }
 
 #ifdef PM8001_USE_TASKLET
+
+/**
+ * tasklet for 64 msi-x interrupt handler
+ * @opaque: the passed general host adapter struct
+ * Note: pm8001_tasklet is common for pm8001 & pm80xx
+ */
 static void pm8001_tasklet(unsigned long opaque)
 {
 	struct pm8001_hba_info *pm8001_ha;
+	u32 vec;
 	pm8001_ha = (struct pm8001_hba_info *)opaque;
 	if (unlikely(!pm8001_ha))
 		BUG_ON(1);
-	PM8001_CHIP_DISP->isr(pm8001_ha, 0);
+	vec = pm8001_ha->int_vector;
+	PM8001_CHIP_DISP->isr(pm8001_ha, vec);
 }
 #endif
 
+/**
+ * pm8001_interrupt_handler_x -main interrupt handler invokde for all interrupt.
+ * It obtains the vector number and calls the equivalent bottom half or services
+ * directly.
+ * @vec: vector number; will be 0 for none msi-x operation
+ * @opaque: the passed general host adapter struct
+ */
 
- /**
-  * pm8001_interrupt - when HBA originate a interrupt,we should invoke this
-  * dispatcher to handle each case.
-  * @irq: irq number.
-  * @opaque: the passed general host adapter struct
-  */
-static irqreturn_t pm8001_interrupt(int irq, void *opaque)
+static inline irqreturn_t pm8001_interrupt_handler_x(int vec, void *opaque)
 {
 	struct pm8001_hba_info *pm8001_ha;
 	irqreturn_t ret = IRQ_HANDLED;
@@ -190,6 +199,7 @@ static irqreturn_t pm8001_interrupt(int irq, void *opaque)
 		return IRQ_NONE;
 	if (!PM8001_CHIP_DISP->is_our_interupt(pm8001_ha))
 		return IRQ_NONE;
+	pm8001_ha->int_vector = vec;
 #ifdef PM8001_USE_TASKLET
 	tasklet_schedule(&pm8001_ha->tasklet);
 #else
@@ -198,6 +208,365 @@ static irqreturn_t pm8001_interrupt(int irq, void *opaque)
 	return ret;
 }
 
+/* 64 interrupt handlers for 64 msi-x vectors */
+static irqreturn_t pm8001_interrupt_handler0(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(0, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler1(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(1, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler2(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(2, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler3(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(3, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler4(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(4, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler5(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(5, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler6(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(6, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler7(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(7, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler8(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(8, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler9(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(9, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler10(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(10, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler11(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(11, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler12(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(12, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler13(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(13, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler14(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(14, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler15(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(15, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler16(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(16, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler17(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(17, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler18(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(18, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler19(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(19, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler20(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(20, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler21(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(21, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler22(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(22, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler23(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(23, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler24(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(24, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler25(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(25, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler26(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(26, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler27(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(27, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler28(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(28, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler29(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(29, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler30(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(30, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler31(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(31, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler32(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(32, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler33(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(33, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler34(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(34, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler35(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(35, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler36(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(36, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler37(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(37, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler38(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(38, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler39(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(39, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler40(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(40, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler41(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(41, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler42(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(42, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler43(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(43, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler44(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(44, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler45(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(45, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler46(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(46, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler47(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(47, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler48(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(48, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler49(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(49, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler50(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(50, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler51(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(51, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler52(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(52, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler53(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(53, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler54(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(54, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler55(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(55, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler56(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(56, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler57(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(57, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler58(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(58, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler59(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(59, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler60(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(60, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler61(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(61, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler62(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(62, dev_id);
+}
+
+static irqreturn_t pm8001_interrupt_handler63(int irq, void *dev_id)
+{
+	return pm8001_interrupt_handler_x(63, dev_id);
+}
+
+/* array of 64 interrupt handlers used during request_irq for msi-x int */
+/* pm8001_interrupt_handler0 routine is common for pm8001 & pm80xx */
+static irqreturn_t (*pm8001_interrupt[PM8001_MAX_MSIX_VEC])
+		(int vec, void *dev_id) = {
+	pm8001_interrupt_handler0, pm8001_interrupt_handler1,
+	pm8001_interrupt_handler2, pm8001_interrupt_handler3,
+	pm8001_interrupt_handler4, pm8001_interrupt_handler5,
+	pm8001_interrupt_handler6, pm8001_interrupt_handler7,
+	pm8001_interrupt_handler8, pm8001_interrupt_handler9,
+	pm8001_interrupt_handler10, pm8001_interrupt_handler11,
+	pm8001_interrupt_handler12, pm8001_interrupt_handler13,
+	pm8001_interrupt_handler14, pm8001_interrupt_handler15,
+	pm8001_interrupt_handler16, pm8001_interrupt_handler17,
+	pm8001_interrupt_handler18, pm8001_interrupt_handler19,
+	pm8001_interrupt_handler20, pm8001_interrupt_handler21,
+	pm8001_interrupt_handler22, pm8001_interrupt_handler23,
+	pm8001_interrupt_handler24, pm8001_interrupt_handler25,
+	pm8001_interrupt_handler26, pm8001_interrupt_handler27,
+	pm8001_interrupt_handler28, pm8001_interrupt_handler29,
+	pm8001_interrupt_handler30, pm8001_interrupt_handler31,
+	pm8001_interrupt_handler32, pm8001_interrupt_handler33,
+	pm8001_interrupt_handler34, pm8001_interrupt_handler35,
+	pm8001_interrupt_handler36, pm8001_interrupt_handler37,
+	pm8001_interrupt_handler38, pm8001_interrupt_handler39,
+	pm8001_interrupt_handler40, pm8001_interrupt_handler41,
+	pm8001_interrupt_handler42, pm8001_interrupt_handler43,
+	pm8001_interrupt_handler44, pm8001_interrupt_handler45,
+	pm8001_interrupt_handler46, pm8001_interrupt_handler47,
+	pm8001_interrupt_handler48, pm8001_interrupt_handler49,
+	pm8001_interrupt_handler50, pm8001_interrupt_handler51,
+	pm8001_interrupt_handler52, pm8001_interrupt_handler53,
+	pm8001_interrupt_handler54, pm8001_interrupt_handler55,
+	pm8001_interrupt_handler56, pm8001_interrupt_handler57,
+	pm8001_interrupt_handler58, pm8001_interrupt_handler59,
+	pm8001_interrupt_handler60, pm8001_interrupt_handler61,
+	pm8001_interrupt_handler62, pm8001_interrupt_handler63
+};
+
 /**
  * pm8001_alloc - initiate our hba structure and 6 DMAs area.
  * @pm8001_ha:our hba structure.
@@ -431,8 +800,12 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 		pm8001_ha->iomb_size = IOMB_SIZE_SPC;
 
 #ifdef PM8001_USE_TASKLET
+	/**
+	* default tasklet for non msi-x interrupt handler/first msi-x
+	* interrupt handler
+	**/
 	tasklet_init(&pm8001_ha->tasklet, pm8001_tasklet,
-		(unsigned long)pm8001_ha);
+			(unsigned long)pm8001_ha);
 #endif
 	pm8001_ioremap(pm8001_ha);
 	if (!pm8001_alloc(pm8001_ha, ent))
@@ -595,26 +968,41 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
  * @chip_info: our ha struct.
  * @irq_handler: irq_handler
  */
-static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha,
-	irq_handler_t irq_handler)
+static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 {
 	u32 i = 0, j = 0;
-	u32 number_of_intr = 1;
+	u32 number_of_intr;
 	int flag = 0;
 	u32 max_entry;
 	int rc;
+	static char intr_drvname[PM8001_MAX_MSIX_VEC][sizeof(DRV_NAME)+3];
+
+	/* SPCv controllers supports 64 msi-x */
+	if (pm8001_ha->chip_id == chip_8001) {
+		number_of_intr = 1;
+		flag |= IRQF_DISABLED;
+	} else {
+		number_of_intr = PM8001_MAX_MSIX_VEC;
+		flag &= ~IRQF_SHARED;
+		flag |= IRQF_DISABLED;
+	}
+
 	max_entry = sizeof(pm8001_ha->msix_entries) /
 		sizeof(pm8001_ha->msix_entries[0]);
-	flag |= IRQF_DISABLED;
 	for (i = 0; i < max_entry ; i++)
 		pm8001_ha->msix_entries[i].entry = i;
 	rc = pci_enable_msix(pm8001_ha->pdev, pm8001_ha->msix_entries,
 		number_of_intr);
 	pm8001_ha->number_of_intr = number_of_intr;
 	if (!rc) {
+		PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
+			"pci_enable_msix request ret:%d no of intr %d\n",
+					rc, pm8001_ha->number_of_intr));
 		for (i = 0; i < number_of_intr; i++) {
+			snprintf(intr_drvname[i], sizeof(intr_drvname[0]),
+					DRV_NAME"%d", i);
 			if (request_irq(pm8001_ha->msix_entries[i].vector,
-				irq_handler, flag, DRV_NAME,
+				pm8001_interrupt[i], flag, intr_drvname[i],
 				SHOST_TO_SAS_HA(pm8001_ha->shost))) {
 				for (j = 0; j < i; j++)
 					free_irq(
@@ -636,22 +1024,24 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha,
 static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
 {
 	struct pci_dev *pdev;
-	irq_handler_t irq_handler = pm8001_interrupt;
 	int rc;
 
 	pdev = pm8001_ha->pdev;
 
 #ifdef PM8001_USE_MSIX
 	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX))
-		return pm8001_setup_msix(pm8001_ha, irq_handler);
-	else
+		return pm8001_setup_msix(pm8001_ha);
+	else {
+		PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("MSIX not supported!!!\n"));
 		goto intx;
+	}
 #endif
 
 intx:
 	/* initialize the INT-X interrupt */
-	rc = request_irq(pdev->irq, irq_handler, IRQF_SHARED, DRV_NAME,
-		SHOST_TO_SAS_HA(pm8001_ha->shost));
+	rc = request_irq(pdev->irq, pm8001_interrupt_handler0, IRQF_SHARED,
+		DRV_NAME, SHOST_TO_SAS_HA(pm8001_ha->shost));
 	return rc;
 }
 
@@ -669,6 +1059,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 {
 	unsigned int rc;
 	u32	pci_reg;
+	u8	i = 0;
 	struct pm8001_hba_info *pm8001_ha;
 	struct Scsi_Host *shost = NULL;
 	const struct pm8001_chip_info *chip;
@@ -733,6 +1124,11 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 		goto err_out_shost;
 
 	PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, 0);
+	if (pm8001_ha->chip_id != chip_8001) {
+		for (i = 1; i < pm8001_ha->number_of_intr; i++)
+			PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, i);
+	}
+
 	pm8001_init_sas_add(pm8001_ha);
 	pm8001_post_sas_ha_init(shost, chip);
 	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
@@ -768,7 +1164,7 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 	sas_remove_host(pm8001_ha->shost);
 	list_del(&pm8001_ha->list);
 	scsi_remove_host(pm8001_ha->shost);
-	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0);
+	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
 
 #ifdef PM8001_USE_MSIX
@@ -812,7 +1208,7 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		printk(KERN_ERR " PCI PM not supported\n");
 		return -ENODEV;
 	}
-	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0);
+	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
 #ifdef PM8001_USE_MSIX
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
@@ -847,6 +1243,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha;
 	int rc;
+	u8 i = 0;
 	u32 device_state;
 	pm8001_ha = sha->lldd_ha;
 	device_state = pdev->current_state;
@@ -873,15 +1270,24 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	rc = PM8001_CHIP_DISP->chip_init(pm8001_ha);
 	if (rc)
 		goto err_out_disable;
-	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0);
+
+	/* disable all the interrupt bits */
+	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
+
 	rc = pm8001_request_irq(pm8001_ha);
 	if (rc)
 		goto err_out_disable;
-	#ifdef PM8001_USE_TASKLET
+#ifdef PM8001_USE_TASKLET
+	/* default tasklet for non msi-x interrupt handler/first msi-x
+	* interrupt handler */
 	tasklet_init(&pm8001_ha->tasklet, pm8001_tasklet,
-		    (unsigned long)pm8001_ha);
-	#endif
+			(unsigned long)pm8001_ha);
+#endif
 	PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, 0);
+	if (pm8001_ha->chip_id != chip_8001) {
+		for (i = 1; i < pm8001_ha->number_of_intr; i++)
+			PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, i);
+	}
 	scsi_unblock_requests(pm8001_ha->shost);
 	return 0;
 
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index cf56580..58c4b3f 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -454,6 +454,7 @@ struct pm8001_hba_info {
 #endif
 	u32			logging_level;
 	u32			fw_status;
+	u32			int_vector;
 	const struct firmware 	*fw_image;
 };
 
-- 
1.7.1


--------------020306040400030009060205--
