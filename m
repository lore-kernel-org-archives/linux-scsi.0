From: Andy Yan <ayan@marvell.com>
Subject: [PATCH 4/7]MVSAS:Make code more flexibe for different chip model.
Date: Mon, 9 Nov 2009 20:16:51 +0800
Message-ID: <20091109121651.GC32336@Andy.marvell.com>
Reply-To: ayan@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:55873 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbZKIDUP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Nov 2009 22:20:15 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, jeff@garzik.org, linux-scsi@vger.kernel.org
Cc: qswang@marvell.com, jfeng@marvell.com


>From a30912dceec92cd8db65a92186798eac525b7723 Mon Sep 17 00:00:00 2001
From: Andy <ayan@marvell.com>
Date: Fri, 6 Nov 2009 17:19:37 +0800
Subject: [PATCH 4/6] Make code flexibe for different ASIC
  changed to more flexible for setting sg table length according chip's
  capability, Add queue depth configuration for SATA disk, and fix issue
  with big endian on SATA.

Signed-off-by: Andy <ayan@marvell.com>
Signed-off-by: Jacky <jfeng@marvell.com>
Signed-off-by: Ke <kewei@marvell.com>

---
 drivers/scsi/mvsas/mv_init.c |   41 +++++++++++++++++++++++++++--------------
 drivers/scsi/mvsas/mv_sas.c  |   24 +++++++++++-------------
 drivers/scsi/mvsas/mv_sas.h  |    5 ++++-
 3 files changed, 42 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index bbbc20e..eca335b 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -29,18 +29,20 @@ static int msi;
 module_param(msi, int, 0);
 MODULE_PARM_DESC(msi, "Enable Message Signaled Interrupts(0=off, 1=on)");
 int io_delay;
+
 static struct scsi_transport_template *mvs_stt;
 static const struct mvs_chip_info mvs_chips[] = {
-	[chip_6320] =	{ 1, 2, 0x400, 17, 16,  9, &mvs_64xx_dispatch, },
-	[chip_6440] =	{ 1, 4, 0x400, 17, 16,  9, &mvs_64xx_dispatch, },
-	[chip_6485] =	{ 1, 8, 0x800, 33, 32, 10, &mvs_64xx_dispatch, },
-	[chip_9180] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
-	[chip_9480] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
-	[chip_1300] =	{ 1, 4, 0x400, 17, 16,  9, &mvs_64xx_dispatch, },
-	[chip_1320] =	{ 2, 4, 0x800, 17, 64,  9, &mvs_94xx_dispatch, },
+	[chip_6320] =	{ 1, 2, 0x400, 17, 16, 6, 9, &mvs_64xx_dispatch, },
+	[chip_6440] =	{ 1, 4, 0x400, 17, 16, 6, 9, &mvs_64xx_dispatch, },
+	[chip_6485] =	{ 1, 8, 0x800, 33, 32, 6, 10, &mvs_64xx_dispatch, },
+	[chip_9180] =	{ 2, 4, 0x800, 17, 64, 8, 11, &mvs_94xx_dispatch, },
+	[chip_9480] =	{ 2, 4, 0x800, 17, 64, 8, 11, &mvs_94xx_dispatch, },
+	[chip_1300] =	{ 1, 4, 0x400, 17, 16,  6, 9, &mvs_64xx_dispatch, },
+	[chip_1320] =	{ 2, 4, 0x800, 17, 64,  6, 9, &mvs_94xx_dispatch, },
 };
 
 struct device_attribute *mvst_host_attrs[];
+
 #define SOC_SAS_NUM 2
 
 static struct scsi_host_template mvs_sht = {
@@ -161,6 +163,7 @@ static void mvs_free(struct mvs_info *mvi)
 		scsi_host_put(mvi->shost);
 	list_for_each_entry(mwq, &mvi->wq_list, entry)
 		cancel_delayed_work(&mwq->work_q);
+	kfree(mvi->tags);
 	kfree(mvi);
 }
 
@@ -250,7 +253,7 @@ static int __devinit mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 	if (mvi->flags & MVF_FLAG_SOC)
 		slot_nr = MVS_SOC_SLOTS;
 	else
-		slot_nr = MVS_SLOTS;
+		slot_nr = MVS_CHIP_SLOT_SZ;
 
 	spin_lock_init(&mvi->lock);
 	for (i = 0; i < mvi->chip->n_phy; i++) {
@@ -403,9 +406,10 @@ static struct mvs_info *__devinit mvs_pci_alloc(struct pci_dev *pdev,
 	mvi->id = id;
 	mvi->sas = sha;
 	mvi->shost = shost;
-#ifdef MVS_USE_TASKLET
-	tasklet_init(&mv_tasklet, mvs_tasklet, (unsigned long)sha);
-#endif
+	mvi->tags = kzalloc(MVS_CHIP_SLOT_SZ>>3, GFP_KERNEL);
+	if (!mvi->tags)
+		goto err_out;
+
 
 	if (MVS_CHIP_DISP->chip_ioremap(mvi))
 		goto err_out;
@@ -520,11 +524,12 @@ static void  __devinit mvs_post_sas_ha_init(struct Scsi_Host *shost,
 	if (mvi->flags & MVF_FLAG_SOC)
 		can_queue = MVS_SOC_CAN_QUEUE;
 	else
-		can_queue = MVS_CAN_QUEUE;
+		can_queue = MVS_CHIP_SLOT_SZ;
 
 	sha->lldd_queue_size = can_queue;
+	shost->sg_tablesize = MVS_MAX_SG;
 	shost->can_queue = can_queue;
-	mvi->shost->cmd_per_lun = MVS_SLOTS/sha->num_phys;
+	mvi->shost->cmd_per_lun = MVS_QUEUE_SIZE;
 	sha->core.shost = mvi->shost;
 }
 
@@ -707,7 +712,15 @@ static struct pci_device_id __devinitdata mvs_pci_table[] = {
 	{ PCI_VDEVICE(MARVELL, 0x9180), chip_9180 },
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1300), chip_1300 },
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1320), chip_1320 },
-
+	{
+		.vendor 	= 0x1b4b,
+		.device 	= 0x9480,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= 0x9480,
+		.class		= 0,
+		.class_mask	= 0,
+		.driver_data	= chip_9480,
+	},
 	{ }	/* terminate list */
 };
 
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 4fe365a..7423fc9 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -37,7 +37,7 @@ static int mvs_find_tag(struct mvs_info *mvi, struct sas_task *task, u32 *tag)
 
 void mvs_tag_clear(struct mvs_info *mvi, u32 tag)
 {
-	void *bitmap = &mvi->tags;
+	void *bitmap = mvi->tags;
 	clear_bit(tag, bitmap);
 }
 
@@ -48,14 +48,14 @@ void mvs_tag_free(struct mvs_info *mvi, u32 tag)
 
 void mvs_tag_set(struct mvs_info *mvi, unsigned int tag)
 {
-	void *bitmap = &mvi->tags;
+	void *bitmap = mvi->tags;
 	set_bit(tag, bitmap);
 }
 
 inline int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out)
 {
 	unsigned int index, tag;
-	void *bitmap = &mvi->tags;
+	void *bitmap = mvi->tags;
 
 	index = find_first_zero_bit(bitmap, mvi->tags_num);
 	tag = index;
@@ -225,7 +225,7 @@ struct mvs_info *mvs_find_dev_mvi(struct domain_device *dev)
 int mvs_find_dev_phyno(struct domain_device *dev, int *phyno)
 {
 	unsigned long i = 0, j = 0, n = 0, num = 0;
-	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
+	struct mvs_device *mvi_dev = dev->lldd_dev;
 	struct mvs_info *mvi = mvi_dev->mvi_info;
 	struct sas_ha_struct *sha = dev->port->ha;
 
@@ -415,7 +415,9 @@ int mvs_slave_configure(struct scsi_device *sdev)
 		adev->flags |= ATA_DFLAG_NCQ_OFF;
 		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, 1);
 	#endif
-	}
+	} else
+		sas_change_queue_depth(sdev, MVS_QUEUE_SIZE);
+
 	return 0;
 }
 
@@ -1122,16 +1124,16 @@ static void *mvs_get_d2h_reg(struct mvs_info *mvi, int i, void *buf)
 		return NULL;
 
 	MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_SATA_SIG3);
-	s[3] = MVS_CHIP_DISP->read_port_cfg_data(mvi, i);
+	s[3] = cpu_to_le32(MVS_CHIP_DISP->read_port_cfg_data(mvi, i));
 
 	MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_SATA_SIG2);
-	s[2] = MVS_CHIP_DISP->read_port_cfg_data(mvi, i);
+	s[2] = cpu_to_le32(MVS_CHIP_DISP->read_port_cfg_data(mvi, i));
 
 	MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_SATA_SIG1);
-	s[1] = MVS_CHIP_DISP->read_port_cfg_data(mvi, i);
+	s[1] = cpu_to_le32(MVS_CHIP_DISP->read_port_cfg_data(mvi, i));
 
 	MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_SATA_SIG0);
-	s[0] = MVS_CHIP_DISP->read_port_cfg_data(mvi, i);
+	s[0] = cpu_to_le32(MVS_CHIP_DISP->read_port_cfg_data(mvi, i));
 
 	/* Workaround: take some ATAPI devices for ATA */
 	if (((s[1] & 0x00FFFFFF) == 0x00EB1401) && (*(u8 *)&s[3] == 0x01))
@@ -1210,10 +1212,6 @@ void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st)
 		if (MVS_CHIP_DISP->phy_work_around)
 			MVS_CHIP_DISP->phy_work_around(mvi, i);
 	}
-	mv_dprintk("port %d attach dev info is %x\n",
-		i + mvi->id * mvi->chip->n_phy, phy->att_dev_info);
-	mv_dprintk("port %d attach sas addr is %llx\n",
-		i + mvi->id * mvi->chip->n_phy, phy->att_dev_sas_addr);
 out_done:
 	if (get_st)
 		MVS_CHIP_DISP->write_port_irq_stat(mvi, i, phy->irq_status);
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 7d3e5f6..ffddace 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -176,9 +176,12 @@ struct mvs_chip_info {
 	u32 		fis_offs;
 	u32 		fis_count;
 	u32 		srs_sz;
+	u32 		sg_width;
 	u32 		slot_width;
 	const struct mvs_dispatch *dispatch;
 };
+
+#define MVS_MAX_SG		(1U << mvi->chip->sg_width)
 #define MVS_CHIP_SLOT_SZ	(1U << mvi->chip->slot_width)
 #define MVS_RX_FISL_SZ		\
 	(mvi->chip->fis_offs + (mvi->chip->fis_count * 0x100))
@@ -316,7 +319,7 @@ struct mvs_info {
 	const struct mvs_chip_info *chip;
 
 	int tags_num;
-	DECLARE_BITMAP(tags, MVS_SLOTS);
+	unsigned long *tags;
 	/* further per-slot information */
 	struct mvs_phy phy[MVS_MAX_PHYS];
 	struct mvs_port port[MVS_MAX_PHYS];
-- 
1.6.2.2

