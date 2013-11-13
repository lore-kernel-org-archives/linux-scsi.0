From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH V2 4/4] pm80xx: Tasklets synchronization fix.
Date: Wed, 13 Nov 2013 05:36:49 -0800
Message-ID: <52838071.8010002@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:50095 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757429Ab3KMNd7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Nov 2013 08:33:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Sangeetha.Gnanasekaran@pmcs.com, Viswas.G@pmcs.com, Nikith.Ganigarakoppal@pmcs.com

>From 9dda7700201be93d4d2b83c2733be3d582859bc7 Mon Sep 17 00:00:00 2001
From: Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>
Date: Mon, 11 Nov 2013 15:28:14 +0530
Subject: [PATCH V2 4/4] pm80xx: Tasklets synchronization fix.

When multiple vectors are used, the vector variable is over written,
resulting in unhandled operation for those vectors.
This fix prevents the problem by maitaining HBA instance and
vector values for each irq.

Signed-off-by: Nikith.Ganigarakoppal@pmcs.com
Signed-off-by: Anandkumar.Santhanam@pmcs.com
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>

---
 drivers/scsi/pm8001/pm8001_init.c |   90 +++++++++++++++++++++---------------
 drivers/scsi/pm8001/pm8001_sas.h  |    9 +++-
 2 files changed, 58 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 17daaa4..83feae8 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -175,20 +175,16 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
 static void pm8001_tasklet(unsigned long opaque)
 {
 	struct pm8001_hba_info *pm8001_ha;
-	u32 vec;
-	pm8001_ha = (struct pm8001_hba_info *)opaque;
+	struct isr_param *irq_vector;
+
+	irq_vector = (struct isr_param *)opaque;
+	pm8001_ha = irq_vector->drv_inst;
 	if (unlikely(!pm8001_ha))
 		BUG_ON(1);
-	vec = pm8001_ha->int_vector;
-	PM8001_CHIP_DISP->isr(pm8001_ha, vec);
+	PM8001_CHIP_DISP->isr(pm8001_ha, irq_vector->irq_id);
 }
 #endif
 
-static struct  pm8001_hba_info *outq_to_hba(u8 *outq)
-{
-	return container_of((outq - *outq), struct pm8001_hba_info, outq[0]);
-}
-
 /**
  * pm8001_interrupt_handler_msix - main MSIX interrupt handler.
  * It obtains the vector number and calls the equivalent bottom
@@ -198,18 +194,20 @@ static struct  pm8001_hba_info *outq_to_hba(u8 *outq)
  */
 static irqreturn_t pm8001_interrupt_handler_msix(int irq, void *opaque)
 {
-	struct pm8001_hba_info *pm8001_ha = outq_to_hba(opaque);
-	u8 outq = *(u8 *)opaque;
+	struct isr_param *irq_vector;
+	struct pm8001_hba_info *pm8001_ha;
 	irqreturn_t ret = IRQ_HANDLED;
+	irq_vector = (struct isr_param *)opaque;
+	pm8001_ha = irq_vector->drv_inst;
+
 	if (unlikely(!pm8001_ha))
 		return IRQ_NONE;
 	if (!PM8001_CHIP_DISP->is_our_interupt(pm8001_ha))
 		return IRQ_NONE;
-	pm8001_ha->int_vector = outq;
 #ifdef PM8001_USE_TASKLET
-	tasklet_schedule(&pm8001_ha->tasklet);
+	tasklet_schedule(&pm8001_ha->tasklet[irq_vector->irq_id]);
 #else
-	ret = PM8001_CHIP_DISP->isr(pm8001_ha, outq);
+	ret = PM8001_CHIP_DISP->isr(pm8001_ha, irq_vector->irq_id);
 #endif
 	return ret;
 }
@@ -230,9 +228,8 @@ static irqreturn_t pm8001_interrupt_handler_intx(int irq, void *dev_id)
 	if (!PM8001_CHIP_DISP->is_our_interupt(pm8001_ha))
 		return IRQ_NONE;
 
-	pm8001_ha->int_vector = 0;
 #ifdef PM8001_USE_TASKLET
-	tasklet_schedule(&pm8001_ha->tasklet);
+	tasklet_schedule(&pm8001_ha->tasklet[0]);
 #else
 	ret = PM8001_CHIP_DISP->isr(pm8001_ha, 0);
 #endif
@@ -457,7 +454,7 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 {
 	struct pm8001_hba_info *pm8001_ha;
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
-
+	int j;
 
 	pm8001_ha = sha->lldd_ha;
 	if (!pm8001_ha)
@@ -480,12 +477,14 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 		pm8001_ha->iomb_size = IOMB_SIZE_SPC;
 
 #ifdef PM8001_USE_TASKLET
-	/**
-	* default tasklet for non msi-x interrupt handler/first msi-x
-	* interrupt handler
-	**/
-	tasklet_init(&pm8001_ha->tasklet, pm8001_tasklet,
-			(unsigned long)pm8001_ha);
+	/* Tasklet for non msi-x interrupt handler */
+	if ((!pdev->msix_cap) || (pm8001_ha->chip_id == chip_8001))
+		tasklet_init(&pm8001_ha->tasklet[0], pm8001_tasklet,
+			(unsigned long)&(pm8001_ha->irq_vector[0]));
+	else
+		for (j = 0; j < PM8001_MAX_MSIX_VEC ; j++)
+			tasklet_init(&pm8001_ha->tasklet[j], pm8001_tasklet,
+				(unsigned long)&(pm8001_ha->irq_vector[j]));
 #endif
 	pm8001_ioremap(pm8001_ha);
 	if (!pm8001_alloc(pm8001_ha, ent))
@@ -733,19 +732,20 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 			"pci_enable_msix request ret:%d no of intr %d\n",
 					rc, pm8001_ha->number_of_intr));
 
-		for (i = 0; i < number_of_intr; i++)
-			pm8001_ha->outq[i] = i;
 
 		for (i = 0; i < number_of_intr; i++) {
 			snprintf(intr_drvname[i], sizeof(intr_drvname[0]),
 					DRV_NAME"%d", i);
+			pm8001_ha->irq_vector[i].irq_id = i;
+			pm8001_ha->irq_vector[i].drv_inst = pm8001_ha;
+
 			if (request_irq(pm8001_ha->msix_entries[i].vector,
 				pm8001_interrupt_handler_msix, flag,
-				intr_drvname[i], &pm8001_ha->outq[i])) {
+				intr_drvname[i], &(pm8001_ha->irq_vector[i]))) {
 				for (j = 0; j < i; j++)
 					free_irq(
 					pm8001_ha->msix_entries[j].vector,
-					&pm8001_ha->outq[j]);
+					&(pm8001_ha->irq_vector[i]));
 				pci_disable_msix(pm8001_ha->pdev);
 				break;
 			}
@@ -907,7 +907,7 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 {
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha;
-	int i;
+	int i, j;
 	pm8001_ha = sha->lldd_ha;
 	pci_set_drvdata(pdev, NULL);
 	sas_unregister_ha(sha);
@@ -922,13 +922,18 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 		synchronize_irq(pm8001_ha->msix_entries[i].vector);
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
 		free_irq(pm8001_ha->msix_entries[i].vector,
-				&pm8001_ha->outq[i]);
+				&(pm8001_ha->irq_vector[i]));
 	pci_disable_msix(pdev);
 #else
 	free_irq(pm8001_ha->irq, sha);
 #endif
 #ifdef PM8001_USE_TASKLET
-	tasklet_kill(&pm8001_ha->tasklet);
+	/* For non-msix and msix interrupts */
+	if ((!pdev->msix_cap) || (pm8001_ha->chip_id == chip_8001))
+		tasklet_kill(&pm8001_ha->tasklet[0]);
+	else
+		for (j = 0; j < PM8001_MAX_MSIX_VEC ; j++)
+			tasklet_kill(&pm8001_ha->tasklet[j]);
 #endif
 	pm8001_free(pm8001_ha);
 	kfree(sha->sas_phy);
@@ -949,7 +954,7 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha;
-	int i;
+	int  i, j;
 	u32 device_state;
 	pm8001_ha = sha->lldd_ha;
 	flush_workqueue(pm8001_wq);
@@ -965,13 +970,18 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		synchronize_irq(pm8001_ha->msix_entries[i].vector);
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
 		free_irq(pm8001_ha->msix_entries[i].vector,
-				&pm8001_ha->outq[i]);
+				&(pm8001_ha->irq_vector[i]));
 	pci_disable_msix(pdev);
 #else
 	free_irq(pm8001_ha->irq, sha);
 #endif
 #ifdef PM8001_USE_TASKLET
-	tasklet_kill(&pm8001_ha->tasklet);
+	/* For non-msix and msix interrupts */
+	if ((!pdev->msix_cap) || (pm8001_ha->chip_id == chip_8001))
+		tasklet_kill(&pm8001_ha->tasklet[0]);
+	else
+		for (j = 0; j < PM8001_MAX_MSIX_VEC ; j++)
+			tasklet_kill(&pm8001_ha->tasklet[j]);
 #endif
 	device_state = pci_choose_state(pdev, state);
 	pm8001_printk("pdev=0x%p, slot=%s, entering "
@@ -994,7 +1004,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha;
 	int rc;
-	u8 i = 0;
+	u8 i = 0, j;
 	u32 device_state;
 	pm8001_ha = sha->lldd_ha;
 	device_state = pdev->current_state;
@@ -1034,10 +1044,14 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	if (rc)
 		goto err_out_disable;
 #ifdef PM8001_USE_TASKLET
-	/* default tasklet for non msi-x interrupt handler/first msi-x
-	* interrupt handler */
-	tasklet_init(&pm8001_ha->tasklet, pm8001_tasklet,
-			(unsigned long)pm8001_ha);
+	/*  Tasklet for non msi-x interrupt handler */
+	if ((!pdev->msix_cap) || (pm8001_ha->chip_id == chip_8001))
+		tasklet_init(&pm8001_ha->tasklet[0], pm8001_tasklet,
+			(unsigned long)&(pm8001_ha->irq_vector[0]));
+	else
+		for (j = 0; j < PM8001_MAX_MSIX_VEC ; j++)
+			tasklet_init(&pm8001_ha->tasklet[j], pm8001_tasklet,
+				(unsigned long)&(pm8001_ha->irq_vector[j]));
 #endif
 	PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, 0);
 	if (pm8001_ha->chip_id != chip_8001) {
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 9241c04..508437b 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -466,6 +466,10 @@ struct pm8001_hba_memspace {
 	u64			membase;
 	u32			memsize;
 };
+struct isr_param {
+	struct pm8001_hba_info *drv_inst;
+	u32 irq_id;
+};
 struct pm8001_hba_info {
 	char			name[PM8001_NAME_LENGTH];
 	struct list_head	list;
@@ -519,14 +523,13 @@ struct pm8001_hba_info {
 	int			number_of_intr;/*will be used in remove()*/
 #endif
 #ifdef PM8001_USE_TASKLET
-	struct tasklet_struct	tasklet;
+	struct tasklet_struct	tasklet[PM8001_MAX_MSIX_VEC];
 #endif
 	u32			logging_level;
 	u32			fw_status;
 	u32			smp_exp_mode;
-	u32			int_vector;
 	const struct firmware 	*fw_image;
-	u8			outq[PM8001_MAX_MSIX_VEC];
+	struct isr_param irq_vector[PM8001_MAX_MSIX_VEC];
 };
 
 struct pm8001_work {
-- 
1.7.1

