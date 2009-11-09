From: Andy Yan <ayan@marvell.com>
Subject: [PATCH 2/7]MVSAS:add supporting MSI feature
Date: Mon, 9 Nov 2009 20:08:18 +0800
Message-ID: <20091109120818.GA32336@Andy.marvell.com>
Reply-To: ayan@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:55549 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbZKIDMF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Nov 2009 22:12:05 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, jeff@garzik.org, linux-scsi@vger.kernel.org
Cc: jfeng@marvell.com, qswang@marvell.com


>From 8b51aa63e8b123046a334d630ae045f479acbf6c Mon Sep 17 00:00:00 2001
From: andy <ayan@marvell.com>
Date: Fri, 6 Nov 2009 17:03:21 +0800
Subject: [PATCH 2/7] Add supporting MSI feature

MSI feature is implemented with mvsas driver.

Signed-off-by: Andy <ayan@marvell.com>
Signed-off-by: Jacky <jfeng@marvell.com>
Signed-off-by: Ke <kewei@marvell.com>

---
 drivers/scsi/mvsas/mv_init.c |  113 ++++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/mvsas/mv_sas.c  |   28 ++++++-----
 drivers/scsi/mvsas/mv_sas.h  |    2 +
 3 files changed, 126 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index c790d45..d030959 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -25,6 +25,10 @@
 
 #include "mv_sas.h"
 
+static int msi;
+module_param(msi, int, 0);
+MODULE_PARM_DESC(msi, "Enable Message Signaled Interrupts(0=off, 1=on)");
+int io_delay;
 static struct scsi_transport_template *mvs_stt;
 static const struct mvs_chip_info mvs_chips[] = {
 	[chip_6320] =	{ 1, 2, 0x400, 17, 16,  9, &mvs_64xx_dispatch, },
@@ -36,11 +40,13 @@ static const struct mvs_chip_info mvs_chips[] = {
 	[chip_1320] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
 };
 
+struct device_attribute *mvst_host_attrs[];
 #define SOC_SAS_NUM 2
 
 static struct scsi_host_template mvs_sht = {
 	.module			= THIS_MODULE,
-	.name			= DRV_NAME,
+	.name			= "Marvell Storage Controller",
+	.proc_name		= DRV_NAME,
 	.queuecommand		= sas_queuecommand,
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= mvs_slave_configure,
@@ -61,6 +67,7 @@ static struct scsi_host_template mvs_sht = {
 	.slave_alloc		= mvs_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
+	.shost_attrs		= mvst_host_attrs,
 };
 
 static struct sas_domain_function_template mvs_transport_ops = {
@@ -89,6 +96,7 @@ static void __devinit mvs_phy_init(struct mvs_info *mvi, int phy_id)
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 
 	phy->mvi = mvi;
+	phy->port = NULL;
 	init_timer(&phy->timer);
 	sas_phy->enabled = (phy_id < mvi->chip->n_phy) ? 1 : 0;
 	sas_phy->class = SAS;
@@ -118,7 +126,7 @@ static void mvs_free(struct mvs_info *mvi)
 	if (mvi->flags & MVF_FLAG_SOC)
 		slot_nr = MVS_SOC_SLOTS;
 	else
-		slot_nr = MVS_SLOTS;
+		slot_nr = MVS_CHIP_SLOT_SZ;
 
 	for (i = 0; i < mvi->tags_num; i++) {
 		struct mvs_slot_info *slot = &mvi->slot_info[i];
@@ -183,6 +191,30 @@ static void mvs_tasklet(unsigned long opaque)
 }
 #endif
 
+void mvs_enable_msi(struct mvs_info *mvi)
+{
+	u32 tmp;
+	pci_read_config_dword(mvi->pdev, PCR_CMD, &tmp);
+	tmp |= 1 << 10;    	/* disable interrupt */
+	pci_write_config_dword(mvi->pdev, PCR_CMD, tmp);
+
+	pci_read_config_dword(mvi->pdev, PCR_MSI_CTRL, &tmp);
+	tmp |= 1 << 16; 		/* enable MSI */
+	pci_write_config_dword(mvi->pdev, PCR_MSI_CTRL, tmp);
+}
+void mvs_disable_msi(struct mvs_info *mvi)
+{
+	u32 tmp;
+	pci_read_config_dword(mvi->pdev, PCR_CMD, &tmp);
+	tmp &= ~(1 << 10);    	/* enable interrupt */
+	pci_write_config_dword(mvi->pdev, PCR_CMD, tmp);
+
+	pci_read_config_dword(mvi->pdev, PCR_MSI_CTRL, &tmp);
+	tmp &= ~(1 << 16); 	/* disable MSI */
+	pci_write_config_dword(mvi->pdev, PCR_MSI_CTRL, tmp);
+}
+
+
 static irqreturn_t mvs_interrupt(int irq, void *opaque)
 {
 	u32 core_nr, i = 0;
@@ -519,6 +551,7 @@ static int __devinit mvs_pci_init(struct pci_dev *pdev,
 
 	dev_printk(KERN_INFO, &pdev->dev,
 		"mvsas: driver version %s\n", DRV_VERSION);
+	io_delay = 0;
 	rc = pci_enable_device(pdev);
 	if (rc)
 		goto err_out_enable;
@@ -563,6 +596,8 @@ static int __devinit mvs_pci_init(struct pci_dev *pdev,
 			rc = -ENOMEM;
 			goto err_out_regions;
 		}
+		if (msi)
+			mvi->flags |= MVF_MSI;
 
 		mvs_init_sas_add(mvi);
 
@@ -581,13 +616,22 @@ static int __devinit mvs_pci_init(struct pci_dev *pdev,
 	if (rc)
 		goto err_out_shost;
 
+	if (mvi->flags & MVF_MSI) {
+		pci_enable_msi(pdev);
+		mvs_enable_msi(mvi);
+	}
 	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
 	if (rc)
 		goto err_out_shost;
 	rc = request_irq(pdev->irq, irq_handler, IRQF_SHARED,
 		DRV_NAME, SHOST_TO_SAS_HA(shost));
-	if (rc)
+	if (rc) {
+		if (mvi->flags & MVF_MSI) {
+			mvs_disable_msi(mvi);
+			pci_disable_msi(pdev);
+		}
 		goto err_not_sas;
+	}
 
 	MVS_CHIP_DISP->interrupt_enable(mvi);
 
@@ -620,13 +664,16 @@ static void __devexit mvs_pci_remove(struct pci_dev *pdev)
 	tasklet_kill(&mv_tasklet);
 #endif
 
-	pci_set_drvdata(pdev, NULL);
 	sas_unregister_ha(sha);
 	sas_remove_host(mvi->shost);
 	scsi_remove_host(mvi->shost);
 
 	MVS_CHIP_DISP->interrupt_disable(mvi);
 	free_irq(mvi->irq, sha);
+	if (mvi->flags & MVF_MSI) {
+		mvs_disable_msi(mvi);
+		pci_disable_msi(pdev);
+	}
 	for (i = 0; i < core_nr; i++) {
 		mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[i];
 		mvs_free(mvi);
@@ -634,6 +681,7 @@ static void __devexit mvs_pci_remove(struct pci_dev *pdev)
 	kfree(sha->sas_phy);
 	kfree(sha->sas_port);
 	kfree(sha);
+	pci_set_drvdata(pdev, NULL);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	return;
@@ -668,6 +716,57 @@ static struct pci_driver mvs_pci_driver = {
 	.remove		= __devexit_p(mvs_pci_remove),
 };
 
+static ssize_t
+mvs_show_driver_version(struct device *cdev,
+			struct device_attribute *attr,
+			char *buffer)
+{
+	return snprintf(buffer, PAGE_SIZE, "%s\n", DRV_VERSION);
+}
+
+static DEVICE_ATTR(driver_version,
+			 S_IRUGO,
+			 mvs_show_driver_version,
+			 NULL);
+
+static ssize_t
+mvs_store_io_delay(struct device *cdev,
+			struct device_attribute *attr,
+			const char *buffer, size_t size)
+{
+
+	int val = 0;
+
+	if (buffer == NULL)
+		return size;
+
+	if (sscanf(buffer, "%d", &val) != 1)
+		return -EINVAL;
+
+	io_delay = val;
+	if (io_delay > 10) {
+		printk(KERN_NOTICE "io delay time %d seconds is too long, \
+			max is 10s\n",  io_delay);
+		io_delay = 10;
+		return strlen(buffer);
+	}
+	printk(KERN_NOTICE "set io delay time to %d seconds\n",  io_delay);
+	return strlen(buffer);
+}
+
+static ssize_t mvs_show_io_delay(struct device *cdev,
+				struct device_attribute *attr,
+				char *buffer)
+{
+	return snprintf(buffer, PAGE_SIZE, "%d\n", io_delay);
+}
+
+
+static DEVICE_ATTR(io_delay,
+			 S_IRUGO|S_IWUSR,
+			 mvs_show_io_delay,
+			 mvs_store_io_delay);
+
 /* task handler */
 struct task_struct *mvs_th;
 static int __init mvs_init(void)
@@ -695,6 +794,12 @@ static void __exit mvs_exit(void)
 	sas_release_transport(mvs_stt);
 }
 
+struct device_attribute *mvst_host_attrs[] = {
+	&dev_attr_driver_version,
+	&dev_attr_io_delay,
+	NULL,
+};
+
 module_init(mvs_init);
 module_exit(mvs_exit);
 
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 0d21386..4fe365a 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1935,15 +1935,15 @@ static void mvs_work_queue(struct work_struct *work)
 	struct delayed_work *dw = container_of(work, struct delayed_work, work);
 	struct mvs_wq *mwq = container_of(dw, struct mvs_wq, work_q);
 	struct mvs_info *mvi = mwq->mvi;
-	unsigned long flags;
 
-	spin_lock_irqsave(&mvi->lock, flags);
-	if (mwq->handler & PHY_PLUG_EVENT) {
 		u32 phy_no = (unsigned long) mwq->data;
 		struct sas_ha_struct *sas_ha = mvi->sas;
 		struct mvs_phy *phy = &mvi->phy[phy_no];
 		struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	unsigned long flags;
 
+	spin_lock_irqsave(&mvi->lock, flags);
+	if (mwq->handler & PHY_PLUG_EVENT) {
 		if (phy->phy_event & PHY_PLUG_OUT) {
 			u32 tmp;
 			struct sas_identify_frame *id;
@@ -1964,6 +1964,10 @@ static void mvs_work_queue(struct work_struct *work)
 				mv_dprintk("phy%d Attached Device\n", phy_no);
 			}
 		}
+	} else if (mwq->handler & EXP_BRCT_CHG) {
+			phy->phy_event &= ~EXP_BRCT_CHG;
+			sas_ha->notify_port_event(sas_phy,
+					PORTE_BROADCAST_RCVD);
 	}
 	list_del(&mwq->entry);
 	spin_unlock_irqrestore(&mvi->lock, flags);
@@ -1982,7 +1986,7 @@ static int mvs_handle_event(struct mvs_info *mvi, void *data, int handler)
 		mwq->handler = handler;
 		MV_INIT_DELAYED_WORK(&mwq->work_q, mvs_work_queue, mwq);
 		list_add_tail(&mwq->entry, &mvi->wq_list);
-		schedule_delayed_work(&mwq->work_q, HZ * 2);
+		schedule_delayed_work(&mwq->work_q, HZ * io_delay);
 	} else
 		ret = -ENOMEM;
 
@@ -2014,14 +2018,14 @@ static void mvs_sig_remove_timer(struct mvs_phy *phy)
 void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events)
 {
 	u32 tmp;
-	struct sas_ha_struct *sas_ha = mvi->sas;
 	struct mvs_phy *phy = &mvi->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 
 	phy->irq_status = MVS_CHIP_DISP->read_port_irq_stat(mvi, phy_no);
-	mv_dprintk("port %d ctrl sts=0x%X.\n", phy_no+mvi->id*mvi->chip->n_phy,
+	MVS_CHIP_DISP->write_port_irq_stat(mvi, phy_no, phy->irq_status);
+	mv_dprintk("phy %d ctrl sts=%08X.\n", phy_no+mvi->id*mvi->chip->n_phy,
 		MVS_CHIP_DISP->read_phy_ctl(mvi, phy_no));
-	mv_dprintk("Port %d irq sts = 0x%X\n", phy_no+mvi->id*mvi->chip->n_phy,
+	mv_dprintk("phy %d irq sts = %08X\n", phy_no+mvi->id*mvi->chip->n_phy,
 		phy->irq_status);
 
 	/*
@@ -2096,13 +2100,11 @@ void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events)
 				phy_no + mvi->id*mvi->chip->n_phy);
 		}
 	} else if (phy->irq_status & PHYEV_BROAD_CH) {
-		mv_dprintk("port %d broadcast change.\n",
-			phy_no + mvi->id*mvi->chip->n_phy);
-		/* exception for Samsung disk drive*/
-		mdelay(1000);
-		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+			mv_dprintk("phy %d broadcast change.\n",
+				phy_no + mvi->id*mvi->chip->n_phy);
+			mvs_handle_event(mvi, (void *)(unsigned long)phy_no,
+					EXP_BRCT_CHG);
 	}
-	MVS_CHIP_DISP->write_port_irq_stat(mvi, phy_no, phy->irq_status);
 }
 
 int mvs_int_rx(struct mvs_info *mvi, bool self_clear)
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index aa2270a..7d3e5f6 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -61,6 +61,7 @@
 #endif
 #define MV_MAX_U32			0xffffffff
 
+extern int io_delay;
 extern struct mvs_tgt_initiator mvs_tgt;
 extern struct mvs_info *tgt_mvi;
 extern const struct mvs_dispatch mvs_64xx_dispatch;
@@ -93,6 +94,7 @@ extern const struct mvs_dispatch mvs_94xx_dispatch;
 enum dev_status {
 	MVS_DEV_NORMAL = 0x0,
 	MVS_DEV_EH	= 0x1,
+	MVS_DEV_OFF 	= 0x2,
 };
 
 
-- 
1.6.2.2

