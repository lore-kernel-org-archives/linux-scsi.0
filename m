From: yxlraid@gmail.com
Subject: [PATCH 2/2] mvsas: add support for Task collector mode and fixed relative bugs
Date: Tue, 26 Apr 2011 06:36:51 -0700
Message-ID: <1303825011-6345-1-git-send-email-yxlraid@gmail.com>
References: <mvsas-support-task-collector-mode>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <mvsas-support-task-collector-mode>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, yuxiangl@marvell.com, jfeng@marvell.com
List-Id: linux-scsi@vger.kernel.org

From: Xiangliang Yu <yuxiangl@marvell.com>

1.Add support for Task collector mode.
2.Fixed relative collector mode bug:
- I/O failed when disks is on two ports
- system hang when hotplug disk
- system hang when unplug disk during run IO
3.Unlock ap->lock within .lldd_execute_task for direct mode to improve performance

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
---
 drivers/scsi/mvsas/Kconfig    |    1 +
 drivers/scsi/mvsas/Makefile   |    1 +
 drivers/scsi/mvsas/mv_64xx.c  |    1 +
 drivers/scsi/mvsas/mv_64xx.h  |    1 +
 drivers/scsi/mvsas/mv_94xx.c  |    1 +
 drivers/scsi/mvsas/mv_94xx.h  |    1 +
 drivers/scsi/mvsas/mv_chips.h |    1 +
 drivers/scsi/mvsas/mv_defs.h  |    1 +
 drivers/scsi/mvsas/mv_init.c  |   47 +++--
 drivers/scsi/mvsas/mv_sas.c   |  385 ++++++++++++++++++++++++++--------------
 drivers/scsi/mvsas/mv_sas.h   |    8 +
 11 files changed, 295 insertions(+), 153 deletions(-)

diff --git a/drivers/scsi/mvsas/Kconfig b/drivers/scsi/mvsas/Kconfig
index 6de7af2..c82b012 100644
--- a/drivers/scsi/mvsas/Kconfig
+++ b/drivers/scsi/mvsas/Kconfig
@@ -3,6 +3,7 @@
 #
 # Copyright 2007 Red Hat, Inc.
 # Copyright 2008 Marvell. <kewei@marvell.com>
+# Copyright 2009-20011 Marvell. <yuxiangl@marvell.com>
 #
 # This file is licensed under GPLv2.
 #
diff --git a/drivers/scsi/mvsas/Makefile b/drivers/scsi/mvsas/Makefile
index ffbf759..87b231a 100644
--- a/drivers/scsi/mvsas/Makefile
+++ b/drivers/scsi/mvsas/Makefile
@@ -3,6 +3,7 @@
 #
 # Copyright 2007 Red Hat, Inc.
 # Copyright 2008 Marvell. <kewei@marvell.com>
+# Copyright 2009-2011 Marvell. <yuxiangl@marvell.com>
 #
 # This file is licensed under GPLv2.
 #
diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.c
index afc7f6f..13c9604 100644
--- a/drivers/scsi/mvsas/mv_64xx.c
+++ b/drivers/scsi/mvsas/mv_64xx.c
@@ -3,6 +3,7 @@
  *
  * Copyright 2007 Red Hat, Inc.
  * Copyright 2008 Marvell. <kewei@marvell.com>
+ * Copyright 2009-2011 Marvell. <yuxiangl@marvell.com>
  *
  * This file is licensed under GPLv2.
  *
diff --git a/drivers/scsi/mvsas/mv_64xx.h b/drivers/scsi/mvsas/mv_64xx.h
index 42e947d..545889b 100644
--- a/drivers/scsi/mvsas/mv_64xx.h
+++ b/drivers/scsi/mvsas/mv_64xx.h
@@ -3,6 +3,7 @@
  *
  * Copyright 2007 Red Hat, Inc.
  * Copyright 2008 Marvell. <kewei@marvell.com>
+ * Copyright 2009-2011 Marvell. <yuxiangl@marvell.com>
  *
  * This file is licensed under GPLv2.
  *
diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index eed4c5c..78162c3 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -3,6 +3,7 @@
  *
  * Copyright 2007 Red Hat, Inc.
  * Copyright 2008 Marvell. <kewei@marvell.com>
+ * Copyright 2009-2011 Marvell. <yuxiangl@marvell.com>
  *
  * This file is licensed under GPLv2.
  *
diff --git a/drivers/scsi/mvsas/mv_94xx.h b/drivers/scsi/mvsas/mv_94xx.h
index 23ed9b1..8835bef 100644
--- a/drivers/scsi/mvsas/mv_94xx.h
+++ b/drivers/scsi/mvsas/mv_94xx.h
@@ -3,6 +3,7 @@
  *
  * Copyright 2007 Red Hat, Inc.
  * Copyright 2008 Marvell. <kewei@marvell.com>
+ * Copyright 2009-2011 Marvell. <yuxiangl@marvell.com>
  *
  * This file is licensed under GPLv2.
  *
diff --git a/drivers/scsi/mvsas/mv_chips.h b/drivers/scsi/mvsas/mv_chips.h
index a67e1c4..1753a6f 100644
--- a/drivers/scsi/mvsas/mv_chips.h
+++ b/drivers/scsi/mvsas/mv_chips.h
@@ -3,6 +3,7 @@
  *
  * Copyright 2007 Red Hat, Inc.
  * Copyright 2008 Marvell. <kewei@marvell.com>
+ * Copyright 2009-2011 Marvell. <yuxiangl@marvell.com>
  *
  * This file is licensed under GPLv2.
  *
diff --git a/drivers/scsi/mvsas/mv_defs.h b/drivers/scsi/mvsas/mv_defs.h
index 880613f..bc00c94 100644
--- a/drivers/scsi/mvsas/mv_defs.h
+++ b/drivers/scsi/mvsas/mv_defs.h
@@ -3,6 +3,7 @@
  *
  * Copyright 2007 Red Hat, Inc.
  * Copyright 2008 Marvell. <kewei@marvell.com>
+ * Copyright 2009-2011 Marvell. <yuxiangl@marvell.com>
  *
  * This file is licensed under GPLv2.
  *
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 0123c6b..90b6366 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -3,6 +3,7 @@
  *
  * Copyright 2007 Red Hat, Inc.
  * Copyright 2008 Marvell. <kewei@marvell.com>
+ * Copyright 2009-2011 Marvell. <yuxiangl@marvell.com>
  *
  * This file is licensed under GPLv2.
  *
@@ -25,7 +26,16 @@
 
 #include "mv_sas.h"
 
+static int lldd_max_execute_num = 1;
+module_param_named(collector, lldd_max_execute_num, int, S_IRUGO);
+MODULE_PARM_DESC(collector, "\n"
+	"\tIf greater than one, tells the SAS Layer to run in Task Collector\n"
+	"\tMode.  If 1 or 0, tells the SAS Layer to run in Direct Mode.\n"
+	"\tThe mvsas SAS LLDD supports both modes.\n"
+	"\tDefault: 1 (Direct Mode).\n");
+
 static struct scsi_transport_template *mvs_stt;
+struct kmem_cache *mvs_task_list_cache;
 static const struct mvs_chip_info mvs_chips[] = {
 	[chip_6320] =	{ 1, 2, 0x400, 17, 16,  9, &mvs_64xx_dispatch, },
 	[chip_6440] =	{ 1, 4, 0x400, 17, 16,  9, &mvs_64xx_dispatch, },
@@ -109,7 +119,6 @@ static void __devinit mvs_phy_init(struct mvs_info *mvi, int phy_id)
 
 static void mvs_free(struct mvs_info *mvi)
 {
-	int i;
 	struct mvs_wq *mwq;
 	int slot_nr;
 
@@ -121,12 +130,8 @@ static void mvs_free(struct mvs_info *mvi)
 	else
 		slot_nr = MVS_SLOTS;
 
-	for (i = 0; i < mvi->tags_num; i++) {
-		struct mvs_slot_info *slot = &mvi->slot_info[i];
-		if (slot->buf)
-			dma_free_coherent(mvi->dev, MVS_SLOT_BUF_SZ,
-					  slot->buf, slot->buf_dma);
-	}
+	if (mvi->dma_pool)
+		pci_pool_destroy(mvi->dma_pool);
 
 	if (mvi->tx)
 		dma_free_coherent(mvi->dev,
@@ -215,6 +220,7 @@ static irqreturn_t mvs_interrupt(int irq, void *opaque)
 static int __devinit mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 {
 	int i = 0, slot_nr;
+	char pool_name[32];
 
 	if (mvi->flags & MVF_FLAG_SOC)
 		slot_nr = MVS_SOC_SLOTS;
@@ -274,18 +280,14 @@ static int __devinit mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 	if (!mvi->bulk_buffer)
 		goto err_out;
 #endif
-	for (i = 0; i < slot_nr; i++) {
-		struct mvs_slot_info *slot = &mvi->slot_info[i];
-
-		slot->buf = dma_alloc_coherent(mvi->dev, MVS_SLOT_BUF_SZ,
-					       &slot->buf_dma, GFP_KERNEL);
-		if (!slot->buf) {
-			printk(KERN_DEBUG"failed to allocate slot->buf.\n");
+	sprintf(pool_name, "%s%d", "mvs_dma_pool", mvi->id);
+	mvi->dma_pool = pci_pool_create(pool_name, mvi->pdev, MVS_SLOT_BUF_SZ, 16, 0);
+	if (!mvi->dma_pool) {
+			printk(KERN_DEBUG "failed to create dma pool %s.\n", pool_name);
 			goto err_out;
-		}
-		memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
-		++mvi->tags_num;
 	}
+	mvi->tags_num = slot_nr;
+
 	/* Initialize tags */
 	mvs_tag_init(mvi);
 	return 0;
@@ -486,7 +488,7 @@ static void  __devinit mvs_post_sas_ha_init(struct Scsi_Host *shost,
 
 	sha->num_phys = nr_core * chip_info->n_phy;
 
-	sha->lldd_max_execute_num = 1;
+	sha->lldd_max_execute_num = lldd_max_execute_num;
 
 	if (mvi->flags & MVF_FLAG_SOC)
 		can_queue = MVS_SOC_CAN_QUEUE;
@@ -710,6 +712,14 @@ static int __init mvs_init(void)
 	if (!mvs_stt)
 		return -ENOMEM;
 
+	mvs_task_list_cache = kmem_cache_create("mvs_task_list", sizeof(struct mvs_task_list),
+							 0, SLAB_HWCACHE_ALIGN, NULL);
+	if (!mvs_task_list_cache) {
+		rc = -ENOMEM;
+		mv_printk("%s: mvs_task_list_cache alloc failed! \n", __func__);
+		goto err_out;
+	}
+
 	rc = pci_register_driver(&mvs_pci_driver);
 
 	if (rc)
@@ -726,6 +736,7 @@ static void __exit mvs_exit(void)
 {
 	pci_unregister_driver(&mvs_pci_driver);
 	sas_release_transport(mvs_stt);
+	kmem_cache_destroy(mvs_task_list_cache);
 }
 
 module_init(mvs_init);
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index adedaa9..0ef2742 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -3,6 +3,7 @@
  *
  * Copyright 2007 Red Hat, Inc.
  * Copyright 2008 Marvell. <kewei@marvell.com>
+ * Copyright 2009-2011 Marvell. <yuxiangl@marvell.com>
  *
  * This file is licensed under GPLv2.
  *
@@ -862,178 +863,286 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
 }
 
 #define	DEV_IS_GONE(mvi_dev)	((!mvi_dev || (mvi_dev->dev_type == NO_DEVICE)))
-static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
-				struct completion *completion,int is_tmf,
-				struct mvs_tmf_task *tmf)
+static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf,
+				struct mvs_tmf_task *tmf, int *pass)
 {
 	struct domain_device *dev = task->dev;
-	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
-	struct mvs_info *mvi = mvi_dev->mvi_info;
+	struct mvs_device *mvi_dev = dev->lldd_dev;
 	struct mvs_task_exec_info tei;
-	struct sas_task *t = task;
 	struct mvs_slot_info *slot;
-	u32 tag = 0xdeadbeef, rc, n_elem = 0;
-	u32 n = num, pass = 0;
-	unsigned long flags = 0,  flags_libsas = 0;
+	u32 tag = 0xdeadbeef, n_elem = 0;
+	int rc = 0;
 
 	if (!dev->port) {
-		struct task_status_struct *tsm = &t->task_status;
+		struct task_status_struct *tsm = &task->task_status;
 
 		tsm->resp = SAS_TASK_UNDELIVERED;
 		tsm->stat = SAS_PHY_DOWN;
+		/*
+		 * libsas will use dev->port, should
+		 * not call task_done for sata
+		 */
 		if (dev->dev_type != SATA_DEV)
-			t->task_done(t);
-		return 0;
+			task->task_done(task);
+		return rc;
 	}
 
-	spin_lock_irqsave(&mvi->lock, flags);
-	do {
-		dev = t->dev;
-		mvi_dev = dev->lldd_dev;
-		if (DEV_IS_GONE(mvi_dev)) {
-			if (mvi_dev)
-				mv_dprintk("device %d not ready.\n",
-					mvi_dev->device_id);
-			else
-				mv_dprintk("device %016llx not ready.\n",
-					SAS_ADDR(dev->sas_addr));
+	if (DEV_IS_GONE(mvi_dev)) {
+		if (mvi_dev)
+			mv_dprintk("device %d not ready.\n",
+				mvi_dev->device_id);
+		else
+			mv_dprintk("device %016llx not ready.\n",
+				SAS_ADDR(dev->sas_addr));
 
 			rc = SAS_PHY_DOWN;
-			goto out_done;
-		}
+			return rc;
+	}
+	tei.port = dev->port->lldd_port;
+	if (tei.port && !tei.port->port_attached && !tmf) {
+		if (sas_protocol_ata(task->task_proto)) {
+			struct task_status_struct *ts = &task->task_status;
+			mv_dprintk("SATA/STP port %d does not attach"
+					"device.\n", dev->port->id);
+			ts->resp = SAS_TASK_COMPLETE;
+			ts->stat = SAS_PHY_DOWN;
 
-		if (dev->port->id >= mvi->chip->n_phy)
-			tei.port = &mvi->port[dev->port->id - mvi->chip->n_phy];
-		else
-			tei.port = &mvi->port[dev->port->id];
-
-		if (tei.port && !tei.port->port_attached) {
-			if (sas_protocol_ata(t->task_proto)) {
-				struct task_status_struct *ts = &t->task_status;
-
-				mv_dprintk("port %d does not"
-					"attached device.\n", dev->port->id);
-				ts->stat = SAS_PROTO_RESPONSE;
-				ts->stat = SAS_PHY_DOWN;
-				spin_unlock_irqrestore(dev->sata_dev.ap->lock,
-						       flags_libsas);
-				spin_unlock_irqrestore(&mvi->lock, flags);
-				t->task_done(t);
-				spin_lock_irqsave(&mvi->lock, flags);
-				spin_lock_irqsave(dev->sata_dev.ap->lock,
-						  flags_libsas);
-				if (n > 1)
-					t = list_entry(t->list.next,
-						       struct sas_task, list);
-				continue;
-			} else {
-				struct task_status_struct *ts = &t->task_status;
-				ts->resp = SAS_TASK_UNDELIVERED;
-				ts->stat = SAS_PHY_DOWN;
-				t->task_done(t);
-				if (n > 1)
-					t = list_entry(t->list.next,
-							struct sas_task, list);
-				continue;
-			}
-		}
+			task->task_done(task);
 
-		if (!sas_protocol_ata(t->task_proto)) {
-			if (t->num_scatter) {
-				n_elem = dma_map_sg(mvi->dev,
-						    t->scatter,
-						    t->num_scatter,
-						    t->data_dir);
-				if (!n_elem) {
-					rc = -ENOMEM;
-					goto err_out;
-				}
-			}
 		} else {
-			n_elem = t->num_scatter;
+			struct task_status_struct *ts = &task->task_status;
+			mv_dprintk("SAS port %d does not attach"
+				"device.\n", dev->port->id);
+			ts->resp = SAS_TASK_UNDELIVERED;
+			ts->stat = SAS_PHY_DOWN;
+			task->task_done(task);
 		}
+		return rc;
+	}
 
-		rc = mvs_tag_alloc(mvi, &tag);
-		if (rc)
-			goto err_out;
+	if (!sas_protocol_ata(task->task_proto)) {
+		if (task->num_scatter) {
+			n_elem = dma_map_sg(mvi->dev,
+					    task->scatter,
+					    task->num_scatter,
+					    task->data_dir);
+			if (!n_elem) {
+				rc = -ENOMEM;
+				goto prep_out;
+			}
+		}
+	} else {
+		n_elem = task->num_scatter;
+	}
 
-		slot = &mvi->slot_info[tag];
+	rc = mvs_tag_alloc(mvi, &tag);
+	if (rc)
+		goto err_out;
 
+	slot = &mvi->slot_info[tag];
 
-		t->lldd_task = NULL;
-		slot->n_elem = n_elem;
-		slot->slot_tag = tag;
-		memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
+	task->lldd_task = NULL;
+	slot->n_elem = n_elem;
+	slot->slot_tag = tag;
+
+	slot->buf = pci_pool_alloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
+	if (!slot->buf)
+		goto err_out_tag;
+	memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
+
+	tei.task = task;
+	tei.hdr = &mvi->slot[tag];
+	tei.tag = tag;
+	tei.n_elem = n_elem;
+	switch (task->task_proto) {
+	case SAS_PROTOCOL_SMP:
+		rc = mvs_task_prep_smp(mvi, &tei);
+		break;
+	case SAS_PROTOCOL_SSP:
+		rc = mvs_task_prep_ssp(mvi, &tei, is_tmf, tmf);
+		break;
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
+	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
+		rc = mvs_task_prep_ata(mvi, &tei);
+		break;
+	default:
+		dev_printk(KERN_ERR, mvi->dev,
+			"unknown sas_task proto: 0x%x\n",
+			task->task_proto);
+		rc = -EINVAL;
+		break;
+	}
 
-		tei.task = t;
-		tei.hdr = &mvi->slot[tag];
-		tei.tag = tag;
-		tei.n_elem = n_elem;
-		switch (t->task_proto) {
-		case SAS_PROTOCOL_SMP:
-			rc = mvs_task_prep_smp(mvi, &tei);
-			break;
-		case SAS_PROTOCOL_SSP:
-			rc = mvs_task_prep_ssp(mvi, &tei, is_tmf, tmf);
-			break;
-		case SAS_PROTOCOL_SATA:
-		case SAS_PROTOCOL_STP:
-		case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
-			rc = mvs_task_prep_ata(mvi, &tei);
-			break;
-		default:
-			dev_printk(KERN_ERR, mvi->dev,
-				   "unknown sas_task proto: 0x%x\n",
-				   t->task_proto);
-			rc = -EINVAL;
-			break;
-		}
+	if (rc) {
+		mv_dprintk("rc is %x\n", rc);
+		goto err_out_slot_buf;
+	}
+	slot->task = task;
+	slot->port = tei.port;
+	task->lldd_task = slot;
+	list_add_tail(&slot->entry, &tei.port->list);
+	spin_lock(&task->task_state_lock);
+	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
+	spin_unlock(&task->task_state_lock);
 
-		if (rc) {
-			mv_dprintk("rc is %x\n", rc);
-			goto err_out_tag;
-		}
-		slot->task = t;
-		slot->port = tei.port;
-		t->lldd_task = slot;
-		list_add_tail(&slot->entry, &tei.port->list);
-		/* TODO: select normal or high priority */
-		spin_lock(&t->task_state_lock);
-		t->task_state_flags |= SAS_TASK_AT_INITIATOR;
-		spin_unlock(&t->task_state_lock);
-
-		mvs_hba_memory_dump(mvi, tag, t->task_proto);
-		mvi_dev->running_req++;
-		++pass;
-		mvi->tx_prod = (mvi->tx_prod + 1) & (MVS_CHIP_SLOT_SZ - 1);
-		if (n > 1)
-			t = list_entry(t->list.next, struct sas_task, list);
-		if (likely(pass))
-			MVS_CHIP_DISP->start_delivery(mvi, (mvi->tx_prod - 1) &
-						      (MVS_CHIP_SLOT_SZ - 1));
+	mvs_hba_memory_dump(mvi, tag, task->task_proto);
+	mvi_dev->running_req++;
+	++(*pass);
+	mvi->tx_prod = (mvi->tx_prod + 1) & (MVS_CHIP_SLOT_SZ - 1);
 
-	} while (--n);
-	rc = 0;
-	goto out_done;
+	return rc;
 
+err_out_slot_buf:
+	pci_pool_free(mvi->dma_pool, slot->buf, slot->buf_dma);
 err_out_tag:
 	mvs_tag_free(mvi, tag);
 err_out:
 
-	dev_printk(KERN_ERR, mvi->dev, "mvsas exec failed[%d]!\n", rc);
-	if (!sas_protocol_ata(t->task_proto))
+	dev_printk(KERN_ERR, mvi->dev, "mvsas prep failed[%d]!\n", rc);
+	if (!sas_protocol_ata(task->task_proto))
 		if (n_elem)
-			dma_unmap_sg(mvi->dev, t->scatter, n_elem,
-				     t->data_dir);
-out_done:
+			dma_unmap_sg(mvi->dev, task->scatter, n_elem,
+				     task->data_dir);
+prep_out:
+	return rc;
+}
+
+static struct mvs_task_list *mvs_task_alloc_list(int *num, gfp_t gfp_flags)
+{
+	struct mvs_task_list *first = NULL;
+
+	for (; *num > 0; --*num) {
+		struct mvs_task_list *mvs_list = kmem_cache_zalloc(mvs_task_list_cache, gfp_flags);
+
+		if (!mvs_list)
+			break;
+
+		INIT_LIST_HEAD(&mvs_list->list);
+		if (!first)
+			first = mvs_list;
+		else
+			list_add_tail(&mvs_list->list, &first->list);
+
+	}
+
+	return first;
+}
+
+static inline void mvs_task_free_list(struct mvs_task_list *mvs_list)
+{
+	LIST_HEAD(list);
+	struct list_head *pos, *a;
+	struct mvs_task_list *mlist = NULL;
+
+	__list_add(&list, mvs_list->list.prev, &mvs_list->list);
+
+	list_for_each_safe(pos, a, &list) {
+		list_del_init(pos);
+		mlist = list_entry(pos, struct mvs_task_list, list);
+		kmem_cache_free(mvs_task_list_cache, mlist);
+	}
+}
+
+static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
+				struct completion *completion, int is_tmf,
+				struct mvs_tmf_task *tmf)
+{
+	struct domain_device *dev = task->dev;
+	struct mvs_info *mvi = NULL;
+	u32 rc = 0;
+	u32 pass = 0;
+	unsigned long flags = 0;
+
+	mvi = ((struct mvs_device *)task->dev->lldd_dev)->mvi_info;
+
+	if ((dev->dev_type == SATA_DEV) && (dev->sata_dev.ap != NULL))
+		spin_unlock_irq(dev->sata_dev.ap->lock);
+
+	spin_lock_irqsave(&mvi->lock, flags);
+	rc = mvs_task_prep(task, mvi, is_tmf, tmf, &pass);
+	if (rc)
+		dev_printk(KERN_ERR, mvi->dev, "mvsas exec failed[%d]!\n", rc);
+
+	if (likely(pass))
+			MVS_CHIP_DISP->start_delivery(mvi, (mvi->tx_prod - 1) &
+				(MVS_CHIP_SLOT_SZ - 1));
 	spin_unlock_irqrestore(&mvi->lock, flags);
+
+	if ((dev->dev_type == SATA_DEV) && (dev->sata_dev.ap != NULL))
+		spin_lock_irq(dev->sata_dev.ap->lock);
+
+	return rc;
+}
+
+static int mvs_collector_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
+				struct completion *completion, int is_tmf,
+				struct mvs_tmf_task *tmf)
+{
+	struct domain_device *dev = task->dev;
+	struct mvs_prv_info *mpi = dev->port->ha->lldd_ha;
+	struct mvs_info *mvi = NULL;
+	struct sas_task *t = task;
+	struct mvs_task_list *mvs_list = NULL, *a;
+	LIST_HEAD(q);
+	int pass[2] = {0};
+	u32 rc = 0;
+	u32 n = num;
+	unsigned long flags = 0;
+
+	mvs_list = mvs_task_alloc_list(&n, gfp_flags);
+	if (n) {
+		printk(KERN_ERR "%s: mvs alloc list failed.\n", __func__);
+		rc = -ENOMEM;
+		goto free_list;
+	}
+
+	__list_add(&q, mvs_list->list.prev, &mvs_list->list);
+
+	list_for_each_entry(a, &q, list) {
+		a->task = t;
+		t = list_entry(t->list.next, struct sas_task, list);
+	}
+
+	list_for_each_entry(a, &q , list) {
+
+		t = a->task;
+		mvi = ((struct mvs_device *)t->dev->lldd_dev)->mvi_info;
+
+		spin_lock_irqsave(&mvi->lock, flags);
+		rc = mvs_task_prep(t, mvi, is_tmf, tmf, &pass[mvi->id]);
+		if (rc)
+			dev_printk(KERN_ERR, mvi->dev, "mvsas exec failed[%d]!\n", rc);
+		spin_unlock_irqrestore(&mvi->lock, flags);
+	}
+
+	if (likely(pass[0]))
+			MVS_CHIP_DISP->start_delivery(mpi->mvi[0],
+				(mpi->mvi[0]->tx_prod - 1) & (MVS_CHIP_SLOT_SZ - 1));
+
+	if (likely(pass[1]))
+			MVS_CHIP_DISP->start_delivery(mpi->mvi[1],
+				(mpi->mvi[1]->tx_prod - 1) & (MVS_CHIP_SLOT_SZ - 1));
+
+	list_del_init(&q);
+
+free_list:
+	if (mvs_list)
+		mvs_task_free_list(mvs_list);
+
 	return rc;
 }
 
 int mvs_queue_command(struct sas_task *task, const int num,
 			gfp_t gfp_flags)
 {
-	return mvs_task_exec(task, num, gfp_flags, NULL, 0, NULL);
+	struct mvs_device *mvi_dev = task->dev->lldd_dev;
+	struct sas_ha_struct *sas = mvi_dev->mvi_info->sas;
+
+	if (sas->lldd_max_execute_num < 2)
+		return mvs_task_exec(task, num, gfp_flags, NULL, 0, NULL);
+	else
+		return mvs_collector_task_exec(task, num, gfp_flags, NULL, 0, NULL);
 }
 
 static void mvs_slot_free(struct mvs_info *mvi, u32 rx_desc)
@@ -1067,6 +1176,11 @@ static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task *task,
 		/* do nothing */
 		break;
 	}
+
+	if (slot->buf) {
+		pci_pool_free(mvi->dma_pool, slot->buf, slot->buf_dma);
+		slot->buf = NULL;
+	}
 	list_del_init(&slot->entry);
 	task->lldd_task = NULL;
 	slot->task = NULL;
@@ -1255,6 +1369,7 @@ static void mvs_port_notify_formed(struct asd_sas_phy *sas_phy, int lock)
 		spin_lock_irqsave(&mvi->lock, flags);
 	port->port_attached = 1;
 	phy->port = port;
+	sas_port->lldd_port = port;
 	if (phy->phy_type & PORT_TYPE_SAS) {
 		port->wide_port_phymap = sas_port->phy_mask;
 		mv_printk("set wide port phy map %x\n", sas_port->phy_mask);
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 77ddc7c..1367d8b 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -3,6 +3,7 @@
  *
  * Copyright 2007 Red Hat, Inc.
  * Copyright 2008 Marvell. <kewei@marvell.com>
+ * Copyright 2009-2011 Marvell. <yuxiangl@marvell.com>
  *
  * This file is licensed under GPLv2.
  *
@@ -67,6 +68,7 @@ extern struct mvs_tgt_initiator mvs_tgt;
 extern struct mvs_info *tgt_mvi;
 extern const struct mvs_dispatch mvs_64xx_dispatch;
 extern const struct mvs_dispatch mvs_94xx_dispatch;
+extern struct kmem_cache *mvs_task_list_cache;
 
 #define DEV_IS_EXPANDER(type)	\
 	((type == EDGE_DEV) || (type == FANOUT_DEV))
@@ -341,6 +343,7 @@ struct mvs_info {
 	dma_addr_t bulk_buffer_dma;
 #define TRASH_BUCKET_SIZE    	0x20000
 #endif
+	void *dma_pool;
 	struct mvs_slot_info slot_info[0];
 };
 
@@ -367,6 +370,11 @@ struct mvs_task_exec_info {
 	int n_elem;
 };
 
+struct mvs_task_list {
+	struct sas_task *task;
+	struct list_head list;
+};
+
 
 /******************** function prototype *********************/
 void mvs_get_sas_addr(void *buf, u32 buflen);
-- 
1.7.4.4
