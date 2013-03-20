From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH V3 05/12] pm80xx: MSI-X implementation for using 64 interrupts
Date: Wed, 20 Mar 2013 10:23:29 -0700
Message-ID: <5149F091.2060009@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010207020704070502060507"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:59494 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751222Ab3CTRV4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Mar 2013 13:21:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Harry.Yang@pmcs.com, Sangeetha.Gnanasekaran@pmcs.com, sakthivel.sk@hcl.com, xjtuwjp@gmail.com, rich.Bono@pmcs.com, Vishwanath.Maram@pmcs.com

This is a multi-part message in MIME format.
--------------010207020704070502060507
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From b7704915fe98519155cb1c86d79afcc976b574b8 Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Tue, 19 Mar 2013 17:56:17 +0530
Subject: [PATCH V3 05/12] pm80xx: MSI-X implementation for using 64 interrupts

Implementation of interrupt handlers and tasklets to support
upto 64 interrupt for the device.

Signed-off-by: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
Ack-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/pm8001/pm8001_init.c |  141 +++++++++++++++++++++++++++++--------
 drivers/scsi/pm8001/pm8001_sas.h  |    2 +
 2 files changed, 113 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index e8a983f..a366e50 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -163,33 +163,71 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
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
+}
+#endif
+
+static struct  pm8001_hba_info *outq_to_hba(u8 *outq)
+{
+	return container_of((outq - *outq), struct pm8001_hba_info, outq[0]);
 }
+
+/**
+ * pm8001_interrupt_handler_msix - main MSIX interrupt handler.
+ * It obtains the vector number and calls the equivalent bottom
+ * half or services directly.
+ * @opaque: the passed outbound queue/vector. Host structure is
+ * retrieved from the same.
+ */
+static irqreturn_t pm8001_interrupt_handler_msix(int irq, void *opaque)
+{
+	struct pm8001_hba_info *pm8001_ha = outq_to_hba(opaque);
+	u8 outq = *(u8 *)opaque;
+	irqreturn_t ret = IRQ_HANDLED;
+	if (unlikely(!pm8001_ha))
+		return IRQ_NONE;
+	if (!PM8001_CHIP_DISP->is_our_interupt(pm8001_ha))
+		return IRQ_NONE;
+	pm8001_ha->int_vector = outq;
+#ifdef PM8001_USE_TASKLET
+	tasklet_schedule(&pm8001_ha->tasklet);
+#else
+	ret = PM8001_CHIP_DISP->isr(pm8001_ha, outq);
 #endif
+	return ret;
+}
 
+/**
+ * pm8001_interrupt_handler_intx - main INTx interrupt handler.
+ * @dev_id: sas_ha structure. The HBA is retrieved from sas_has structure.
+ */
 
- /**
-  * pm8001_interrupt - when HBA originate a interrupt,we should invoke this
-  * dispatcher to handle each case.
-  * @irq: irq number.
-  * @opaque: the passed general host adapter struct
-  */
-static irqreturn_t pm8001_interrupt(int irq, void *opaque)
+static irqreturn_t pm8001_interrupt_handler_intx(int irq, void *dev_id)
 {
 	struct pm8001_hba_info *pm8001_ha;
 	irqreturn_t ret = IRQ_HANDLED;
-	struct sas_ha_struct *sha = opaque;
+	struct sas_ha_struct *sha = dev_id;
 	pm8001_ha = sha->lldd_ha;
 	if (unlikely(!pm8001_ha))
 		return IRQ_NONE;
 	if (!PM8001_CHIP_DISP->is_our_interupt(pm8001_ha))
 		return IRQ_NONE;
+
+	pm8001_ha->int_vector = 0;
 #ifdef PM8001_USE_TASKLET
 	tasklet_schedule(&pm8001_ha->tasklet);
 #else
@@ -431,8 +469,12 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
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
@@ -595,31 +637,50 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
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
+
+		for (i = 0; i < number_of_intr; i++)
+			pm8001_ha->outq[i] = i;
+
 		for (i = 0; i < number_of_intr; i++) {
+			snprintf(intr_drvname[i], sizeof(intr_drvname[0]),
+					DRV_NAME"%d", i);
 			if (request_irq(pm8001_ha->msix_entries[i].vector,
-				irq_handler, flag, DRV_NAME,
-				SHOST_TO_SAS_HA(pm8001_ha->shost))) {
+				pm8001_interrupt_handler_msix, flag,
+				intr_drvname[i], &pm8001_ha->outq[i])) {
 				for (j = 0; j < i; j++)
 					free_irq(
 					pm8001_ha->msix_entries[j].vector,
-					SHOST_TO_SAS_HA(pm8001_ha->shost));
+					&pm8001_ha->outq[j]);
 				pci_disable_msix(pm8001_ha->pdev);
 				break;
 			}
@@ -636,22 +697,24 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha,
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
+	rc = request_irq(pdev->irq, pm8001_interrupt_handler_intx, IRQF_SHARED,
+		DRV_NAME, SHOST_TO_SAS_HA(pm8001_ha->shost));
 	return rc;
 }
 
@@ -669,6 +732,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 {
 	unsigned int rc;
 	u32	pci_reg;
+	u8	i = 0;
 	struct pm8001_hba_info *pm8001_ha;
 	struct Scsi_Host *shost = NULL;
 	const struct pm8001_chip_info *chip;
@@ -733,6 +797,11 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
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
@@ -768,14 +837,15 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 	sas_remove_host(pm8001_ha->shost);
 	list_del(&pm8001_ha->list);
 	scsi_remove_host(pm8001_ha->shost);
-	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0);
+	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
 
 #ifdef PM8001_USE_MSIX
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
 		synchronize_irq(pm8001_ha->msix_entries[i].vector);
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
-		free_irq(pm8001_ha->msix_entries[i].vector, sha);
+		free_irq(pm8001_ha->msix_entries[i].vector,
+				&pm8001_ha->outq[i]);
 	pci_disable_msix(pdev);
 #else
 	free_irq(pm8001_ha->irq, sha);
@@ -812,13 +882,14 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		printk(KERN_ERR " PCI PM not supported\n");
 		return -ENODEV;
 	}
-	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0);
+	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
 #ifdef PM8001_USE_MSIX
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
 		synchronize_irq(pm8001_ha->msix_entries[i].vector);
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
-		free_irq(pm8001_ha->msix_entries[i].vector, sha);
+		free_irq(pm8001_ha->msix_entries[i].vector,
+				&pm8001_ha->outq[i]);
 	pci_disable_msix(pdev);
 #else
 	free_irq(pm8001_ha->irq, sha);
@@ -847,6 +918,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha;
 	int rc;
+	u8 i = 0;
 	u32 device_state;
 	pm8001_ha = sha->lldd_ha;
 	device_state = pdev->current_state;
@@ -873,15 +945,24 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
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
index cf56580..b895e2b 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -454,7 +454,9 @@ struct pm8001_hba_info {
 #endif
 	u32			logging_level;
 	u32			fw_status;
+	u32			int_vector;
 	const struct firmware 	*fw_image;
+	u8			outq[PM8001_MAX_MSIX_VEC];
 };
 
 struct pm8001_work {
-- 
1.7.1


--------------010207020704070502060507
Content-Type: text/plain; charset=windows-1252;
 name="0005-pm80xx-MSI-X-implementation-for-using-64-interrupts.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0005-pm80xx-MSI-X-implementation-for-using-64-interrupts.pat";
 filename*1="ch"

>From b7704915fe98519155cb1c86d79afcc976b574b8 Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Tue, 19 Mar 2013 17:56:17 +0530
Subject: [PATCH V3 05/12] pm80xx: MSI-X implementation for using 64 interrupts

Implementation of interrupt handlers and tasklets to support
upto 64 interrupt for the device.

Signed-off-by: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
Ack-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/pm8001/pm8001_init.c |  141 +++++++++++++++++++++++++++++--------
 drivers/scsi/pm8001/pm8001_sas.h  |    2 +
 2 files changed, 113 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index e8a983f..a366e50 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -163,33 +163,71 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
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
+}
+#endif
+
+static struct  pm8001_hba_info *outq_to_hba(u8 *outq)
+{
+	return container_of((outq - *outq), struct pm8001_hba_info, outq[0]);
 }
+
+/**
+ * pm8001_interrupt_handler_msix - main MSIX interrupt handler.
+ * It obtains the vector number and calls the equivalent bottom
+ * half or services directly.
+ * @opaque: the passed outbound queue/vector. Host structure is
+ * retrieved from the same.
+ */
+static irqreturn_t pm8001_interrupt_handler_msix(int irq, void *opaque)
+{
+	struct pm8001_hba_info *pm8001_ha = outq_to_hba(opaque);
+	u8 outq = *(u8 *)opaque;
+	irqreturn_t ret = IRQ_HANDLED;
+	if (unlikely(!pm8001_ha))
+		return IRQ_NONE;
+	if (!PM8001_CHIP_DISP->is_our_interupt(pm8001_ha))
+		return IRQ_NONE;
+	pm8001_ha->int_vector = outq;
+#ifdef PM8001_USE_TASKLET
+	tasklet_schedule(&pm8001_ha->tasklet);
+#else
+	ret = PM8001_CHIP_DISP->isr(pm8001_ha, outq);
 #endif
+	return ret;
+}
 
+/**
+ * pm8001_interrupt_handler_intx - main INTx interrupt handler.
+ * @dev_id: sas_ha structure. The HBA is retrieved from sas_has structure.
+ */
 
- /**
-  * pm8001_interrupt - when HBA originate a interrupt,we should invoke this
-  * dispatcher to handle each case.
-  * @irq: irq number.
-  * @opaque: the passed general host adapter struct
-  */
-static irqreturn_t pm8001_interrupt(int irq, void *opaque)
+static irqreturn_t pm8001_interrupt_handler_intx(int irq, void *dev_id)
 {
 	struct pm8001_hba_info *pm8001_ha;
 	irqreturn_t ret = IRQ_HANDLED;
-	struct sas_ha_struct *sha = opaque;
+	struct sas_ha_struct *sha = dev_id;
 	pm8001_ha = sha->lldd_ha;
 	if (unlikely(!pm8001_ha))
 		return IRQ_NONE;
 	if (!PM8001_CHIP_DISP->is_our_interupt(pm8001_ha))
 		return IRQ_NONE;
+
+	pm8001_ha->int_vector = 0;
 #ifdef PM8001_USE_TASKLET
 	tasklet_schedule(&pm8001_ha->tasklet);
 #else
@@ -431,8 +469,12 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
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
@@ -595,31 +637,50 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
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
+
+		for (i = 0; i < number_of_intr; i++)
+			pm8001_ha->outq[i] = i;
+
 		for (i = 0; i < number_of_intr; i++) {
+			snprintf(intr_drvname[i], sizeof(intr_drvname[0]),
+					DRV_NAME"%d", i);
 			if (request_irq(pm8001_ha->msix_entries[i].vector,
-				irq_handler, flag, DRV_NAME,
-				SHOST_TO_SAS_HA(pm8001_ha->shost))) {
+				pm8001_interrupt_handler_msix, flag,
+				intr_drvname[i], &pm8001_ha->outq[i])) {
 				for (j = 0; j < i; j++)
 					free_irq(
 					pm8001_ha->msix_entries[j].vector,
-					SHOST_TO_SAS_HA(pm8001_ha->shost));
+					&pm8001_ha->outq[j]);
 				pci_disable_msix(pm8001_ha->pdev);
 				break;
 			}
@@ -636,22 +697,24 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha,
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
+	rc = request_irq(pdev->irq, pm8001_interrupt_handler_intx, IRQF_SHARED,
+		DRV_NAME, SHOST_TO_SAS_HA(pm8001_ha->shost));
 	return rc;
 }
 
@@ -669,6 +732,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 {
 	unsigned int rc;
 	u32	pci_reg;
+	u8	i = 0;
 	struct pm8001_hba_info *pm8001_ha;
 	struct Scsi_Host *shost = NULL;
 	const struct pm8001_chip_info *chip;
@@ -733,6 +797,11 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
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
@@ -768,14 +837,15 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 	sas_remove_host(pm8001_ha->shost);
 	list_del(&pm8001_ha->list);
 	scsi_remove_host(pm8001_ha->shost);
-	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0);
+	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
 
 #ifdef PM8001_USE_MSIX
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
 		synchronize_irq(pm8001_ha->msix_entries[i].vector);
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
-		free_irq(pm8001_ha->msix_entries[i].vector, sha);
+		free_irq(pm8001_ha->msix_entries[i].vector,
+				&pm8001_ha->outq[i]);
 	pci_disable_msix(pdev);
 #else
 	free_irq(pm8001_ha->irq, sha);
@@ -812,13 +882,14 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		printk(KERN_ERR " PCI PM not supported\n");
 		return -ENODEV;
 	}
-	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0);
+	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
 #ifdef PM8001_USE_MSIX
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
 		synchronize_irq(pm8001_ha->msix_entries[i].vector);
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
-		free_irq(pm8001_ha->msix_entries[i].vector, sha);
+		free_irq(pm8001_ha->msix_entries[i].vector,
+				&pm8001_ha->outq[i]);
 	pci_disable_msix(pdev);
 #else
 	free_irq(pm8001_ha->irq, sha);
@@ -847,6 +918,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha;
 	int rc;
+	u8 i = 0;
 	u32 device_state;
 	pm8001_ha = sha->lldd_ha;
 	device_state = pdev->current_state;
@@ -873,15 +945,24 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
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
index cf56580..b895e2b 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -454,7 +454,9 @@ struct pm8001_hba_info {
 #endif
 	u32			logging_level;
 	u32			fw_status;
+	u32			int_vector;
 	const struct firmware 	*fw_image;
+	u8			outq[PM8001_MAX_MSIX_VEC];
 };
 
 struct pm8001_work {
-- 
1.7.1


--------------010207020704070502060507--
