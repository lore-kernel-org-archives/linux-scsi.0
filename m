From: Xiangliang Yu <yxlraid@gmail.com>
Subject: [PATCH 3/3] mvsas: implement port mulitplier functional interface
Date: Thu, 24 Apr 2014 21:28:57 +0800
Message-ID: <1398346137-10402-1-git-send-email-yxlraid@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tj@kernel.org, JBottomley@parallels.com
Cc: dan.j.williams@intel.com, todd.e.brandt@intel.com, lukasz.dorau@intel.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiangliang Yu <yxlraid@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Implement PM interface of libsas to prepare for SATA PM support.

Signed-off-by: Xiangliang Yu <yxlraid@gmail.com>
---
 drivers/scsi/mvsas/mv_64xx.c |    2 +
 drivers/scsi/mvsas/mv_94xx.c |   19 ++++
 drivers/scsi/mvsas/mv_defs.h |    1 +
 drivers/scsi/mvsas/mv_init.c |    7 ++
 drivers/scsi/mvsas/mv_sas.c  |  246 +++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/mvsas/mv_sas.h  |    9 ++
 6 files changed, 281 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.c
index 8bb0699..bb257cb 100644
--- a/drivers/scsi/mvsas/mv_64xx.c
+++ b/drivers/scsi/mvsas/mv_64xx.c
@@ -780,6 +780,8 @@ const struct mvs_dispatch mvs_64xx_dispatch = {
 	mvs_64xx_iounmap,
 	mvs_64xx_isr,
 	mvs_64xx_isr_status,
+	NULL,
+	NULL,
 	mvs_64xx_interrupt_enable,
 	mvs_64xx_interrupt_disable,
 	mvs_read_phy_ctl,
diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index 1e4479f..9d547a7 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -602,6 +602,23 @@ static u32 mvs_94xx_isr_status(struct mvs_info *mvi, int irq)
 	return stat;
 }
 
+static u32 mvs_94xx_read_isr_stat(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs;
+	u32 stat = 0;
+
+	stat = mr32(MVS_INT_STAT);
+
+	return stat;
+}
+
+static void mvs_94xx_write_isr_stat(struct mvs_info *mvi, u32 stat)
+{
+	void __iomem *regs = mvi->regs;
+
+	mw32(MVS_INT_STAT, stat);
+}
+
 static irqreturn_t mvs_94xx_isr(struct mvs_info *mvi, int irq, u32 stat)
 {
 	void __iomem *regs = mvi->regs;
@@ -1013,6 +1030,8 @@ const struct mvs_dispatch mvs_94xx_dispatch = {
 	mvs_94xx_iounmap,
 	mvs_94xx_isr,
 	mvs_94xx_isr_status,
+	mvs_94xx_read_isr_stat,
+	mvs_94xx_write_isr_stat,
 	mvs_94xx_interrupt_enable,
 	mvs_94xx_interrupt_disable,
 	mvs_read_phy_ctl,
diff --git a/drivers/scsi/mvsas/mv_defs.h b/drivers/scsi/mvsas/mv_defs.h
index f545194..4a25bb6 100644
--- a/drivers/scsi/mvsas/mv_defs.h
+++ b/drivers/scsi/mvsas/mv_defs.h
@@ -401,6 +401,7 @@ enum mvs_event_flags {
 	PHY_PLUG_IN		= (1U << 0),	/* phy plug in */
 	PHY_PLUG_OUT		= (1U << 1),	/* phy plug out */
 	EXP_BRCT_CHG		= (1U << 2),	/* broadcast change */
+	PHY_SNTF_RCVD		= (1U << 3),	/* pm sntf received */
 };
 
 enum mvs_port_type {
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 5ff978b..779f853 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -94,6 +94,12 @@ static struct sas_domain_function_template mvs_transport_ops = {
 	.lldd_port_formed	= mvs_port_formed,
 	.lldd_port_deformed     = mvs_port_deformed,
 
+	.lldd_dev_freeze        = mvs_dev_freeze,
+	.lldd_dev_thaw          = mvs_dev_thaw,
+	.lldd_wait_task_done    = mvs_wait_task_done,
+	.lldd_ata_check_ready   = mvs_check_ready,
+	.lldd_dev_classify      = mvs_dev_classify,
+	.lldd_dev_set           = mvs_dev_set,
 };
 
 static void mvs_phy_init(struct mvs_info *mvi, int phy_id)
@@ -251,6 +257,7 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 		mvi->port[i].wide_port_phymap = 0;
 		mvi->port[i].port_attached = 0;
 		INIT_LIST_HEAD(&mvi->port[i].list);
+		mvi->port[i].sig = 0xFFFFFFFF;
 	}
 	for (i = 0; i < MVS_MAX_DEVICES; i++) {
 		mvi->devices[i].taskfileset = MVS_ID_NOT_MAPPED;
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 6c1f223..537c7d6 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -443,13 +443,15 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 {
 	struct sas_ha_struct *sha = mvi->sas;
 	struct sas_task *task = tei->task;
-	struct domain_device *dev = task->dev;
+	struct domain_device *dev = task->dev, *parent = NULL;
 	struct mvs_device *mvi_dev = dev->lldd_dev;
 	struct mvs_cmd_hdr *hdr = tei->hdr;
 	struct asd_sas_port *sas_port = dev->port;
-	struct sas_phy *sphy = dev->phy;
-	struct asd_sas_phy *sas_phy = sha->sas_phy[sphy->number];
+	struct sas_phy *sphy = NULL;
+	struct asd_sas_phy *sas_phy = NULL;
 	struct mvs_slot_info *slot;
+	struct host_to_dev_fis *fis;
+	struct ata_queued_cmd *qc = NULL;
 	void *buf_prd;
 	u32 tag = tei->tag, hdr_tag;
 	u32 flags, del_q;
@@ -464,6 +466,13 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 			mvi_dev->device_id);
 		return -EBUSY;
 	}
+	if (dev->parent) {
+		parent = dev->parent;
+		sphy = parent->phy;
+	} else
+		sphy = dev->phy;
+	sas_phy = sha->sas_phy[sphy->number];
+
 	slot = &mvi->slot_info[tag];
 	slot->tx = mvi->tx_prod;
 	del_q = TXQ_MODE_I | tag |
@@ -484,6 +493,19 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 			flags |= MCH_ATAPI;
 	}
 
+	if (task->task_state_flags & SAS_TASK_NEED_DEV_RESET)
+		flags |= MCH_RESET;
+
+	if (!(task->task_state_flags & SAS_TASK_NEED_DEV_RESET)) {
+		qc = task->uldd_task;
+		fis = &task->ata_task.fis;
+		if ((qc->tf.command == ATA_CMD_PMP_READ) ||
+		       (qc->tf.command == ATA_CMD_PMP_WRITE))
+			flags |= 0xF;    /* pm control port */
+		else
+			flags |= fis->flags & 0xF;
+	}
+
 	hdr->flags = cpu_to_le32(flags);
 
 	if (task->ata_task.use_ncq && mvs_get_ncq_tag(task, &hdr_tag))
@@ -491,6 +513,13 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 	else
 		hdr_tag = tag;
 
+	if (!(task->task_state_flags & SAS_TASK_NEED_DEV_RESET)) {
+		qc = task->uldd_task;
+		if ((qc->tf.command == ATA_CMD_PMP_READ) ||
+		       (qc->tf.command == ATA_CMD_PMP_WRITE))
+			hdr_tag = 0;
+	}
+
 	hdr->tags = cpu_to_le32(hdr_tag);
 
 	hdr->data_len = cpu_to_le32(task->total_xfer_len);
@@ -1369,6 +1398,215 @@ void mvs_dev_gone(struct domain_device *dev)
 	mvs_dev_gone_notify(dev);
 }
 
+void mvs_dev_freeze(struct domain_device *dev)
+{
+	struct mvs_device *mvi_dev = dev->lldd_dev;
+	struct mvs_info *mvi = mvi_dev->mvi_info;
+
+	if (!mvi) {
+		mv_dprintk("mvi is null.\n");
+		return;
+	}
+
+	MVS_CHIP_DISP->interrupt_disable(mvi);
+}
+
+void mvs_dev_thaw(struct domain_device *dev)
+{
+	struct mvs_device *mvi_dev = dev->lldd_dev;
+	struct mvs_info *mvi = mvi_dev->mvi_info;
+
+	if (!mvi) {
+		mv_dprintk("mvi is null.\n");
+		return;
+	}
+
+	MVS_CHIP_DISP->interrupt_enable(mvi);
+}
+
+int mvs_wait_task_done(struct sas_task *task)
+{
+	struct domain_device *dev = task->dev;
+	struct mvs_device *mdev = dev->lldd_dev;
+	struct mvs_slot_info *slot = (struct mvs_slot_info *)task->lldd_task;
+	u32 slot_idx = slot->slot_tag;
+	struct mvs_info *mvi = mdev->mvi_info;
+	unsigned int rx_prod_idx, rx_desc;
+	int ret = -1;
+	u32 reg;
+
+	reg = MVS_CHIP_DISP->read_isr_status(mvi);
+
+	rx_prod_idx = mvi->rx_cons;
+
+	mvi->rx_cons = le32_to_cpu(mvi->rx[0]);
+	if (mvi->rx_cons == 0xFFF)
+		return ret;
+
+	if (unlikely(mvi->rx_cons == rx_prod_idx))
+		mvi->rx_cons = MVS_CHIP_DISP->rx_update(mvi) & RX_RING_SZ_MASK;
+
+	if (reg & 0x1) {
+		/* free slot resource */
+
+		task->task_state_flags = SAS_TASK_STATE_DONE;
+		if (mdev && mdev->running_req)
+			mdev->running_req--;
+		if (sas_protocol_ata(task->task_proto))
+			mvs_free_reg_set(mvi, mdev);
+
+		mvs_slot_task_free(mvi, task, slot, slot_idx);
+
+		/* clear int register */
+		MVS_CHIP_DISP->write_isr_status(mvi, reg & 0x1);
+		reg = MVS_CHIP_DISP->read_isr_status(mvi);
+
+		rx_desc = le32_to_cpu(mvi->rx[mvi->rx_cons + 1]);
+
+		return 0;
+	}
+
+	if (mvi->rx_cons == rx_prod_idx)
+		return ret;
+
+	rx_desc = le32_to_cpu(mvi->rx[mvi->rx_cons + 1]);
+	if (rx_desc & RXQ_DONE)
+		ret = 0;
+
+	ret = MVS_CHIP_DISP->read_isr_status(mvi);
+	if (reg & 0x1)
+		MVS_CHIP_DISP->write_isr_status(mvi, reg & 0x1);
+
+	return ret;
+}
+
+int mvs_check_ready(struct domain_device *dev)
+{
+	struct mvs_device *mdev = dev->lldd_dev;
+	struct mvs_info *mvi = mdev->mvi_info;
+	struct asd_sas_port *sas_port = dev->port;
+	struct mvs_port *port = sas_port->lldd_port;
+	int i = 0;
+	u32 reg, status = 0;
+
+	while (&(mvi->port[i]) != port)
+		i++;
+
+	BUG_ON(!mvi);
+
+	reg = MVS_CHIP_DISP->read_port_irq_stat(mvi, i);
+	if (reg == 0 && test_bit(SAS_DEV_RESET, &dev->state)) {
+		clear_bit(SAS_DEV_RESET, &dev->state);
+		return 1;
+	}
+	status = mvs_is_phy_ready(mvi, i);
+	if (!status) {
+		mv_dprintk("phy is not ready.\n");
+		return 1;
+	}
+
+	if (reg & PHYEV_UNASSOC_FIS) {
+		reg = readl(UNASSOC_D2H_FIS(i));
+
+	} else if (reg & PHYEV_SIG_FIS) {
+		MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_SATA_SIG0);
+		reg = cpu_to_le32(MVS_CHIP_DISP->read_port_cfg_data(mvi, i));
+	}
+
+	status = (reg >> 16) & 0xFF;
+
+	if (status & 0x80)
+		return 0;
+
+	return 1;
+}
+
+static u32 mvs_get_dev_sig(struct mvs_info *mvi, int phy, u32 reg)
+{
+	u32 sig = 0, val;
+
+	if (reg & PHYEV_UNASSOC_FIS) {
+
+		val = readl(UNASSOC_D2H_FIS(phy) + 0xC);
+		val = val & 0xFF;
+		sig |= val;
+		val = readl(UNASSOC_D2H_FIS(phy) + 0x4);
+		val = val & 0xFFFFFF;
+		sig |= (val << 8);
+
+		memset(UNASSOC_D2H_FIS(phy), 0, 4);
+		memset(UNASSOC_D2H_FIS(phy) + 0x4, 0, 4);
+		memset(UNASSOC_D2H_FIS(phy) + 0x8, 0, 4);
+		memset(UNASSOC_D2H_FIS(phy) + 0xC, 0, 4);
+
+	} else if (reg & PHYEV_SIG_FIS) {
+		MVS_CHIP_DISP->write_port_cfg_addr(mvi, phy, PHYR_SATA_SIG3);
+		val = cpu_to_le32(MVS_CHIP_DISP->read_port_cfg_data(mvi, phy));
+		val = val & 0xFF;
+		sig |= val;
+		MVS_CHIP_DISP->write_port_cfg_addr(mvi, phy, PHYR_SATA_SIG1);
+		val = cpu_to_le32(MVS_CHIP_DISP->read_port_cfg_data(mvi, phy));
+		val = val & 0xFFFFFF;
+		sig |= (val << 8);
+	}
+
+	return sig;
+}
+
+int mvs_dev_classify(struct domain_device *dev)
+{
+	struct mvs_device *mdev = dev->lldd_dev;
+	struct mvs_info *mvi = mdev->mvi_info;
+	struct asd_sas_port *sas_port = dev->port;
+	struct mvs_port *port = sas_port->lldd_port;
+	int i = 0;
+	u32 reg, sig;
+
+	if (test_and_clear_bit(SAS_DEV_RESET, &dev->state)) {
+		sig = port->sig;
+		port->sig = 0xFFFFFFFF;
+
+		goto out;
+	}
+
+	while (&mvi->port[i] != port)
+		i++;
+
+	reg = MVS_CHIP_DISP->read_port_irq_stat(mvi, i);
+
+	port->sig = mvs_get_dev_sig(mvi, i, reg);
+	sig = port->sig;
+	port->sig = 0xFFFFFFFF;
+
+	reg = MVS_CHIP_DISP->read_port_irq_stat(mvi, i);
+	MVS_CHIP_DISP->write_port_irq_stat(mvi, i, reg);
+	reg = MVS_CHIP_DISP->read_port_irq_stat(mvi, i);
+out:
+
+	if (sig == 0x96690101)
+		return ATA_DEV_PMP;
+	else if (sig == 0x101)
+		return ATA_DEV_ATA;
+	else
+		return ATA_DEV_UNKNOWN;
+}
+
+void mvs_dev_set(struct domain_device *dev)
+{
+	struct ata_port *ap;
+
+	if (dev->parent &&
+		(dev->parent->dev_type == SAS_SATA_PM))
+		return;
+
+	ap = dev->sata_dev.ap;
+
+	/* add support PM and AN */
+	ap->flags |= (ATA_FLAG_PMP | ATA_FLAG_AN);
+
+	return;
+}
+
 static void mvs_task_done(struct sas_task *task)
 {
 	if (!del_timer(&task->slow_task->timer))
@@ -1519,6 +1757,8 @@ int mvs_I_T_nexus_reset(struct domain_device *dev)
     struct mvs_device * mvi_dev = (struct mvs_device *)dev->lldd_dev;
 	struct mvs_info *mvi = mvi_dev->mvi_info;
 
+	set_bit(SAS_DEV_RESET, &dev->state);
+
 	if (mvi_dev->dev_status != MVS_DEV_EH)
 		return TMF_RESP_FUNC_COMPLETE;
 	else
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index d6b19dc..090c074 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -113,6 +113,8 @@ struct mvs_dispatch {
 	void (*chip_iounmap)(struct mvs_info *mvi);
 	irqreturn_t (*isr)(struct mvs_info *mvi, int irq, u32 stat);
 	u32 (*isr_status)(struct mvs_info *mvi, int irq);
+	u32 (*read_isr_status)(struct mvs_info *mvi);
+	void (*write_isr_status)(struct mvs_info *mvi, u32 stat);
 	void (*interrupt_enable)(struct mvs_info *mvi);
 	void (*interrupt_disable)(struct mvs_info *mvi);
 
@@ -214,6 +216,7 @@ struct mvs_port {
 	u8			port_attached;
 	u8			wide_port_phymap;
 	struct list_head	list;
+	u32			sig;
 };
 
 struct mvs_phy {
@@ -484,5 +487,11 @@ void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events);
 void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st);
 int mvs_int_rx(struct mvs_info *mvi, bool self_clear);
 struct mvs_device *mvs_find_dev_by_reg_set(struct mvs_info *mvi, u8 reg_set);
+void mvs_dev_freeze(struct domain_device *dev);
+void mvs_dev_thaw(struct domain_device *dev);
+int mvs_wait_task_done(struct sas_task *task);
+int mvs_check_ready(struct domain_device *dev);
+int mvs_dev_classify(struct domain_device *dev);
+void mvs_dev_set(struct domain_device *dev);
 #endif
 
-- 
1.7.1
