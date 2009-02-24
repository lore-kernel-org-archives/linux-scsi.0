From: Ke Wei <kewei@marvell.com>
Subject: [PATCH 3/5] mvsas : redesign the mvsas driver architecture.
Date: Tue, 24 Feb 2009 17:42:39 +0800
Message-ID: <49A3C10F.3060709@marvell.com>
Reply-To: kewei@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:28368 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754157AbZBXJn7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2009 04:43:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jeff@garzik.org, james.bottomley@hansenpartnership.com, qzhao@marvell.com, qswang@marvell.com, jfeng@marvell.com, kewei@marvell.com, jasonchu@marvell.com

Added driver init routine. Added support for SoC platform.

Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas/mv_init.c |  828 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 828 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
new file mode 100644
index 0000000..49d6abe
--- /dev/null
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -0,0 +1,828 @@
+/*
+	mvsas.c - Marvell 88SE6440/88SE9480 SAS/SATA support
+
+	Copyright 2007 Red Hat, Inc.
+	Copyright 2008-2009 Marvell
+
+	This program is free software; you can redistribute it and/or
+	modify it under the terms of the GNU General Public License as
+	published by the Free Software Foundation; either version 2,
+	or (at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty
+	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+	See the GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public
+	License along with this program; see the file COPYING.	If not,
+	write to the Free Software Foundation, 675 Mass Ave, Cambridge,
+	MA 02139, USA.
+
+	---------------------------------------------------------------
+ */
+
+#include "mv_sas.h"
+#include "mv_spi.h"
+
+static struct scsi_transport_template *mvs_stt;
+
+extern const struct mvs_dispatch mvs_64xx_dispatch;
+extern const struct mvs_dispatch mvs_91xx_dispatch;
+
+static const struct mvs_chip_info mvs_chips[] = {
+	[chip_6320] =	{ 1, 2, 0x400, 17, 16,  9, &mvs_64xx_dispatch, },
+	[chip_6440] =	{ 1, 4, 0x400, 17, 16,  9, &mvs_64xx_dispatch, },
+	[chip_6485] =	{ 1, 8, 0x800, 33, 32, 10, &mvs_64xx_dispatch, },
+	[chip_9180] =	{ 2, 4, 0x400, 17, 64,  9, &mvs_91xx_dispatch, },
+	[chip_9480] =	{ 2, 4, 0x400, 17, 64,  9, &mvs_91xx_dispatch, },
+};
+
+#define SOC_SAS_NUM 2
+struct list_head *mvs_soc_mod_list;
+
+static struct scsi_host_template mvs_sht = {
+	.module			= THIS_MODULE,
+	.name			= DRV_NAME,
+	.queuecommand		= sas_queuecommand,
+	.target_alloc		= sas_target_alloc,
+	.slave_configure	= mvs_slave_configure,
+	.slave_destroy		= sas_slave_destroy,
+	.scan_finished		= mvs_scan_finished,
+	.scan_start		= mvs_scan_start,
+	.change_queue_depth	= sas_change_queue_depth,
+	.change_queue_type	= sas_change_queue_type,
+	.bios_param		= sas_bios_param,
+	.can_queue		= 1,
+	.cmd_per_lun		= 1,
+	.this_id		= -1,
+	.sg_tablesize		= SG_ALL,
+	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
+	.use_clustering		= ENABLE_CLUSTERING,
+	.eh_device_reset_handler	= sas_eh_device_reset_handler,
+	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
+	.slave_alloc		= mvs_slave_alloc,
+	.target_destroy		= sas_target_destroy,
+	.ioctl			= sas_ioctl,
+};
+
+static struct sas_domain_function_template mvs_transport_ops = {
+	.lldd_dev_found 	= mvs_dev_found,
+	.lldd_dev_gone		= mvs_dev_gone,
+
+	.lldd_execute_task	= mvs_queue_command,
+	.lldd_control_phy	= mvs_phy_control,
+	.lldd_abort_task	= mvs_task_abort,
+	.lldd_lu_reset 		= mvs_lu_reset,
+
+	.lldd_port_formed	= mvs_port_formed,
+	.lldd_port_deformed	= mvs_port_deformed,
+
+	.lldd_I_T_nexus_reset	= mvs_I_T_nexus_reset,
+	.lldd_query_task	= mvs_query_task,
+};
+
+static void __devinit mvs_phy_init(struct mvs_info *mvi, int phy_id)
+{
+	struct mvs_phy *phy = &mvi->phy[phy_id];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+
+	sas_phy->enabled = (phy_id < mvi->chip->n_phy) ? 1 : 0;
+	sas_phy->class = SAS;
+	sas_phy->iproto = SAS_PROTOCOL_ALL;
+	sas_phy->tproto = 0;
+	sas_phy->type = PHY_TYPE_PHYSICAL;
+	sas_phy->role = PHY_ROLE_INITIATOR;
+	sas_phy->oob_mode = OOB_NOT_CONNECTED;
+	sas_phy->linkrate = SAS_LINK_RATE_UNKNOWN;
+
+	sas_phy->id = phy_id;
+	sas_phy->sas_addr = &mvi->sas_addr[0];
+	sas_phy->frame_rcvd = &phy->frame_rcvd[0];
+	sas_phy->ha = (struct sas_ha_struct *)mvi->shost->hostdata;
+	sas_phy->lldd_phy = phy;
+}
+
+static void mvs_free(struct mvs_info *mvi)
+{
+	int i;
+	struct mvs_wq *mwq;
+	int slot_nr;
+
+	if (!mvi)
+		return;
+
+	if (mvi->flags & MVF_FLAG_SOC)
+		slot_nr = MVS_SOC_SLOTS;
+	else
+		slot_nr = MVS_SLOTS;
+
+	for (i = 0; i < mvi->tags_num; i++) {
+		struct mvs_slot_info *slot = &mvi->slot_info[i];
+
+		if (slot->buf)
+			dma_free_coherent(mvi->dev, MVS_SLOT_BUF_SZ,
+					  slot->buf, slot->buf_dma);
+	}
+
+	if (mvi->tx)
+		dma_free_coherent(mvi->dev,
+				  sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ,
+				  mvi->tx, mvi->tx_dma);
+	if (mvi->rx_fis)
+		dma_free_coherent(mvi->dev, MVS_RX_FISL_SZ,
+				  mvi->rx_fis, mvi->rx_fis_dma);
+	if (mvi->rx)
+		dma_free_coherent(mvi->dev,
+				  sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1),
+				  mvi->rx, mvi->rx_dma);
+	if (mvi->slot)
+		dma_free_coherent(mvi->dev,
+				  sizeof(*mvi->slot) * slot_nr,
+				  mvi->slot, mvi->slot_dma);
+#ifndef DISABLE_HOTPLUG_DMA_FIX
+	if (mvi->bulk_buffer)
+		dma_free_coherent(mvi->dev, TRASH_BUCKET_SIZE,
+				  mvi->bulk_buffer, mvi->bulk_buffer_dma);
+#endif
+
+	MVS_CHIP_DISP->chip_iounmap(mvi);
+	if (mvi->shost)
+		scsi_host_put(mvi->shost);
+	list_for_each_entry(mwq, &mvi->wq_list, entry)
+		cancel_delayed_work(&mwq->work_q);
+	kfree(mvi);
+}
+
+static irqreturn_t mvs_interrupt(int irq, void *opaque)
+{
+	u16 core_nr,i =0;
+	u32 stat;
+	struct mvs_info *mvi;
+	struct sas_ha_struct * sha = opaque;
+
+	core_nr = (((unsigned long *)sha->lldd_ha)[0]) >> 16;
+	mvi = ((struct mvs_info **)sha->lldd_ha)[2];
+
+	if (unlikely(!mvi))
+		return IRQ_NONE;
+
+	stat = MVS_CHIP_DISP->isr_status(mvi, irq);
+	if (!stat)
+		return IRQ_NONE;
+
+	for(i = 0; i < core_nr; i++){
+		mvi = ((struct mvs_info **)sha->lldd_ha)[2+i];
+		MVS_CHIP_DISP->isr(mvi,irq,stat);
+	}
+	return IRQ_HANDLED;
+}
+
+static int __devinit mvs_alloc(struct mvs_info *mvi,struct Scsi_Host *shost)
+{
+	int i,slot_nr;
+
+	if (mvi->flags & MVF_FLAG_SOC)
+		slot_nr = MVS_SOC_SLOTS;
+	else
+		slot_nr = MVS_SLOTS;
+
+	spin_lock_init(&mvi->lock);
+
+	for(i=0; i < mvi->chip->n_phy; i++){
+		mvs_phy_init(mvi, i);
+		mvi->port[i].wide_port_phymap = 0;
+		mvi->port[i].port_attached = 0;
+		INIT_LIST_HEAD(&mvi->port[i].list);
+	}
+	for (i = 0; i < MVS_MAX_DEVICES; i++) {
+		mvi->devices[i].taskfileset = MVS_ID_NOT_MAPPED;
+		mvi->devices[i].dev_type = NO_DEVICE;
+		mvi->devices[i].device_id = i;
+	}
+
+	/*
+	 * alloc and init our DMA areas
+	 */
+	mvi->tx = dma_alloc_coherent(mvi->dev,
+				     sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ,
+				     &mvi->tx_dma, GFP_KERNEL);
+	if (!mvi->tx)
+		goto err_out;
+	memset(mvi->tx, 0, sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ);
+	mvi->rx_fis = dma_alloc_coherent(mvi->dev, MVS_RX_FISL_SZ,
+					 &mvi->rx_fis_dma, GFP_KERNEL);
+	if (!mvi->rx_fis)
+		goto err_out;
+	memset(mvi->rx_fis, 0, MVS_RX_FISL_SZ);
+
+	mvi->rx = dma_alloc_coherent(mvi->dev,
+				     sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1),
+				     &mvi->rx_dma, GFP_KERNEL);
+	if (!mvi->rx)
+		goto err_out;
+	memset(mvi->rx, 0, sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1));
+	mvi->rx[0] = cpu_to_le32(0xfff);
+	mvi->rx_cons = 0xfff;
+
+	mvi->slot = dma_alloc_coherent(mvi->dev,
+				       sizeof(*mvi->slot) * slot_nr,
+				       &mvi->slot_dma, GFP_KERNEL);
+	if (!mvi->slot)
+		goto err_out;
+	memset(mvi->slot, 0, sizeof(*mvi->slot) * slot_nr);
+
+#ifndef DISABLE_HOTPLUG_DMA_FIX
+	mvi->bulk_buffer = dma_alloc_coherent(mvi->dev,
+				       TRASH_BUCKET_SIZE,
+				       &mvi->bulk_buffer_dma, GFP_KERNEL);
+	if (!mvi->bulk_buffer)
+		goto err_out;
+#endif
+	for (i = 0; i < slot_nr; i++) {
+		struct mvs_slot_info *slot = &mvi->slot_info[i];
+
+		slot->buf = dma_alloc_coherent(mvi->dev, MVS_SLOT_BUF_SZ,
+					       &slot->buf_dma, GFP_KERNEL);
+		if (!slot->buf){
+			printk("failed to allocate slot->buf.\n");
+			goto err_out;
+		}
+		memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
+		++mvi->tags_num;
+	}
+	/* Initialize tags */
+	mvs_tag_init(mvi);
+
+	/* finally, read NVRAM to get our SAS address */
+	MVS_CHIP_DISP->get_sas_addr(&mvi->sas_addr, SAS_ADDR_SIZE);
+	return 0;
+err_out:
+	return 1;
+}
+
+#ifndef CONFIG_PCI
+static struct mvs_info *__devinit mvs_platform_alloc(
+				struct platform_device *pdev,
+				struct list_head *hba_list)
+{
+	struct mvs_info *mvi;
+	struct resource *res;
+	int i = 0;
+
+	/*
+	 * alloc and init our per-HBA mvs_info struct
+	 */
+
+	list_for_each_entry(mvi, hba_list, soc_entry)
+		i++;
+
+	mvi = kzalloc(sizeof(*mvi) +
+			MVS_SOC_SLOTS * sizeof(struct mvs_slot_info),
+			GFP_KERNEL);
+	if (!mvi)
+		return NULL;
+
+
+	mvi->pdev = NULL;
+	mvi->dev = &pdev->dev;
+	mvi->chip_id = chip_6440;
+	mvi->chip = &mvs_chips[mvi->chip_id];
+	mvi->id = i;
+	mvi->flags |= MVF_FLAG_SOC;
+	mvi->hba_list = hba_list;
+	INIT_LIST_HEAD(&mvi->wq_list);
+
+	/*
+	 * ioremap main and peripheral registers
+	 */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, mvi->id);
+	if (!res)
+		goto err_out;
+
+	mvi->regs = ioremap(res->start, res->end - res->start + 1);
+	if (mvi->regs == NULL)
+		goto err_out;
+
+	mvi->irq = platform_get_irq(pdev, mvi->id);
+	if (!mvi->irq)
+		goto err_out;
+
+	if (!mvs_alloc(mvi))
+		return mvi;
+err_out:
+	mvs_free(mvi);
+	return NULL;
+}
+
+static int __devinit mvs_platform_probe(struct platform_device *pdev)
+{
+	int rc;
+	int i;
+	struct mvs_info *mvi;
+	struct list_head *hba_list;
+
+	hba_list = vmalloc(sizeof(struct list_head));
+	if (!hba_list)
+		return -ENOMEM;
+	INIT_LIST_HEAD(hba_list);
+
+	for (i = 0; i < SOC_SAS_NUM; i++) {
+		mvi = mvs_platform_alloc(pdev, hba_list);
+		if (!mvi) {
+			rc = -ENOMEM;
+			goto err_out_alloc;
+		}
+
+		rc = MVS_CHIP_DISP->chip_init(mvi);
+		if (rc)
+			goto err_out_init;
+
+		rc = scsi_add_host(mvi->shost, &pdev->dev);
+		if (rc)
+			goto err_out_host;
+
+		rc = sas_register_ha(&mvi->sas);
+		if (rc)
+			goto err_out_ha;
+
+		list_add_tail(&mvi->soc_entry, hba_list);
+		rc = request_irq(mvi->irq, mvs_interrupt, 0, DRV_NAME, mvi);
+		if (rc)
+			goto err_out_irq;
+
+		scsi_scan_host(mvi->shost);
+		dev_printk(KERN_INFO, mvi->dev,
+				"probe %d adapter OK.\n", mvi->id);
+	}
+	mvs_soc_mod_list = hba_list;
+	return 0;
+err_out_irq:
+	if (mvi->soc_entry.next)
+		list_del(&mvi->soc_entry);
+	sas_unregister_ha(&mvi->sas);
+err_out_ha:
+	scsi_remove_host(mvi->shost);
+err_out_host:
+err_out_init:
+	mvs_free(mvi);
+err_out_alloc:
+	list_for_each_entry(mvi, hba_list, soc_entry)
+		goto err_out_irq;
+	vfree(hba_list);
+	return rc;
+}
+
+static int __devexit mvs_platform_remove(struct platform_device *pdev)
+{
+	struct mvs_info *mvi, *mvi2;
+
+	list_for_each_entry(mvi, mvs_soc_mod_list, soc_entry) {
+		sas_unregister_ha(&mvi->sas);
+		sas_remove_host(mvi->shost);
+		scsi_remove_host(mvi->shost);
+		free_irq(mvi->irq, mvi);
+	}
+	list_for_each_entry_safe(mvi, mvi2, mvs_soc_mod_list, soc_entry) {
+		list_del(&mvi->soc_entry);
+		mvs_free(mvi);
+	}
+	vfree(mvs_soc_mod_list);
+	return 0;
+}
+#endif
+
+int mvs_ioremap(struct mvs_info *mvi, int bar, int bar_ex)
+{
+#ifdef CONFIG_PCI
+	unsigned long res_start, res_len, res_flag, res_flag_ex = 0;
+	struct pci_dev *pdev = mvi->pdev;
+	if (bar_ex != -1) {
+		/*
+		 * ioremap main and peripheral registers
+		 */
+		res_start = pci_resource_start(pdev, bar_ex);
+		res_len = pci_resource_len(pdev, bar_ex);
+		if (!res_start || !res_len)
+			goto err_out;
+
+		res_flag_ex = pci_resource_flags(pdev, bar_ex);
+		if(res_flag_ex & IORESOURCE_MEM) {
+			if (res_flag_ex & IORESOURCE_CACHEABLE)
+				mvi->regs_ex = ioremap(res_start, res_len);
+			else
+				mvi->regs_ex = ioremap_nocache(res_start,
+						res_len);
+		} else
+			mvi->regs_ex = (void *)res_start;
+		if (!mvi->regs_ex)
+			goto err_out;
+	}
+
+	res_start = pci_resource_start(pdev, bar);
+	res_len = pci_resource_len(pdev, bar);
+	if (!res_start || !res_len)
+		goto err_out;
+
+	res_flag = pci_resource_flags(pdev, bar);
+	if (res_flag & IORESOURCE_CACHEABLE)
+		mvi->regs = ioremap(res_start, res_len);
+	else
+		mvi->regs = ioremap_nocache(res_start, res_len);
+
+	if (!mvi->regs) {
+		if (mvi->regs_ex && (res_flag_ex & IORESOURCE_MEM))
+			iounmap(mvi->regs_ex);
+		mvi->regs_ex = NULL;
+		goto err_out;
+	}
+
+	return 0;
+err_out:
+#endif
+	return -1;
+}
+
+void mvs_iounmap(void __iomem *regs)
+{
+	iounmap(regs);
+}
+
+#ifdef CONFIG_PCI
+static struct mvs_info *__devinit mvs_pci_alloc(struct pci_dev *pdev,
+					    const struct pci_device_id *ent,
+					    struct Scsi_Host *shost)
+{
+	unsigned short id;
+	struct mvs_info *mvi;
+	struct sas_ha_struct * sha = SHOST_TO_SAS_HA(shost);
+
+	id = (((unsigned long *)sha->lldd_ha)[0])& 0xffff;
+
+	mvi = kzalloc(sizeof(*mvi) + MVS_SLOTS * sizeof(struct mvs_slot_info),
+			GFP_KERNEL);
+	if (!mvi)
+		return NULL;
+
+	mvi->pdev = pdev;
+	mvi->dev = &pdev->dev;
+	mvi->chip_id = ent->driver_data;
+	mvi->chip = &mvs_chips[mvi->chip_id];
+	INIT_LIST_HEAD(&mvi->wq_list);
+	mvi->irq = pdev->irq;
+
+	((struct mvs_info **)sha->lldd_ha)[id+2] = mvi;
+	((unsigned long *)sha->lldd_ha)[0] += 1;
+	((unsigned long *)sha->lldd_ha)[1] = mvi->chip->n_phy;
+
+	mvi->id = id;
+	mvi->sas = sha;
+	mvi->shost = shost;
+
+	if (MVS_CHIP_DISP->chip_ioremap(mvi))
+		goto err_out;
+
+	if (!mvs_alloc(mvi,shost))
+		return mvi;
+err_out:
+	mvs_free(mvi);
+	return NULL;
+}
+
+/* move to PCI layer or libata core? */
+static int pci_go_64(struct pci_dev *pdev)
+{
+	int rc;
+
+	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+		rc = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+		if (rc) {
+			rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+			if (rc) {
+				dev_printk(KERN_ERR, &pdev->dev,
+					   "64-bit DMA enable failed\n");
+				return rc;
+			}
+		}
+	} else {
+		rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		if (rc) {
+			dev_printk(KERN_ERR, &pdev->dev,
+				   "32-bit DMA enable failed\n");
+			return rc;
+		}
+		rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		if (rc) {
+			dev_printk(KERN_ERR, &pdev->dev,
+				   "32-bit consistent DMA enable failed\n");
+			return rc;
+		}
+	}
+
+	return rc;
+}
+
+static void __devinit mvs_print_info(struct mvs_info *mvi)
+{
+	static int printed_version;
+
+	if (!printed_version++)
+		dev_printk(KERN_INFO, mvi->dev, "version " DRV_VERSION "\n");
+}
+
+static int __devinit mvs_prep_sas_ha_init(struct Scsi_Host * shost,const struct
mvs_chip_info * chip_info)
+{
+	int phy_nr, port_nr; unsigned short core_nr;
+	struct asd_sas_phy **arr_phy;
+	struct asd_sas_port **arr_port;
+	struct sas_ha_struct * sha = SHOST_TO_SAS_HA(shost);
+
+	core_nr = chip_info->n_host;
+	phy_nr  = core_nr * chip_info->n_phy;
+	port_nr = phy_nr;
+
+	memset(sha,0x00,sizeof(struct sas_ha_struct));
+	arr_phy  = kcalloc(phy_nr, sizeof(void *), GFP_KERNEL);
+	arr_port = kcalloc(port_nr, sizeof(void *), GFP_KERNEL);
+	if(!arr_phy || !arr_port){
+		goto exit_free;
+	}
+
+	sha->sas_phy = arr_phy;
+	sha->sas_port = arr_port;
+
+	sha->lldd_ha = kcalloc(core_nr+2,sizeof(void *),GFP_KERNEL);
+	if(!sha->lldd_ha){
+		goto exit_free;
+	}
+
+	((unsigned long*)sha->lldd_ha)[0] = (core_nr << 16);
+
+	shost->transportt = mvs_stt;
+	shost->max_id = 128;
+	shost->max_lun = ~0;
+	shost->max_channel = 0;
+	shost->max_cmd_len = 16;
+
+	return 0;
+exit_free:
+	kfree(arr_phy);
+	kfree(arr_port);
+	return -1;
+
+}
+
+static void  __devinit mvs_post_sas_ha_init(struct Scsi_Host * shost,const
struct mvs_chip_info * chip_info)
+{
+	int can_queue,i=0,j=0;
+	struct mvs_info * mvi = NULL;
+	struct sas_ha_struct * sha = SHOST_TO_SAS_HA(shost);
+	unsigned short nr_core = (((unsigned long*) sha->lldd_ha)[0]) >> 16;
+
+	for(j=0; j < nr_core; j++){
+		mvi=((struct mvs_info **) sha->lldd_ha)[2+j];
+		for (i = 0; i < chip_info->n_phy; i++) {
+			sha->sas_phy[j* chip_info->n_phy  + i] = &mvi->phy[i].sas_phy;
+			sha->sas_port[j* chip_info->n_phy + i] = &mvi->port[i].sas_port;
+		}
+	}
+
+	sha->sas_ha_name = DRV_NAME;
+	sha->dev = mvi->dev;
+	sha->lldd_module = THIS_MODULE;
+	sha->sas_addr = &mvi->sas_addr[0];
+
+	sha->num_phys = nr_core * chip_info->n_phy;
+
+	sha->lldd_max_execute_num = 1;
+	sha->lldd_queue_size = MVS_QUEUE_SIZE;
+
+	if (mvi->flags & MVF_FLAG_SOC)
+		can_queue = MVS_SOC_CAN_QUEUE;
+	else
+		can_queue = MVS_CAN_QUEUE;
+
+	shost->can_queue = can_queue;
+	mvi->shost->cmd_per_lun = can_queue;
+	sha->core.shost = mvi->shost; /* for event. */
+
+}
+
+static int __devinit mvs_pci_init(struct pci_dev *pdev,
+				  const struct pci_device_id *ent)
+{
+	int rc,nhost=0;
+	struct mvs_info *mvi;
+	struct hba_info_main hba_info_para;
+	irq_handler_t irq_handler = mvs_interrupt;
+	struct Scsi_Host * shost = NULL;
+	const struct mvs_chip_info * chip;
+
+	rc = pci_enable_device(pdev);
+	if (rc)
+		goto err_out_enable;
+
+	pci_set_master(pdev);
+
+	rc = pci_request_regions(pdev, DRV_NAME);
+	if (rc)
+		goto err_out_disable;
+
+	rc = pci_go_64(pdev);
+	if (rc)
+		goto err_out_regions;
+
+	shost = scsi_host_alloc(&mvs_sht, sizeof(void *));
+	if(!shost){
+		rc = -ENOMEM;
+		goto err_out_regions;
+	}
+
+	chip = &mvs_chips[ent->driver_data];
+	SHOST_TO_SAS_HA(shost) = (struct sas_ha_struct *)kcalloc(1,sizeof(struct
sas_ha_struct),GFP_KERNEL);
+	if(!SHOST_TO_SAS_HA(shost)){
+		kfree(shost);
+		rc = -ENOMEM;
+		goto err_out_regions;
+	}
+
+	rc =mvs_prep_sas_ha_init(shost,chip);
+	if(rc){
+		kfree(shost);
+		rc = -ENOMEM;
+		goto err_out_regions;
+	}
+
+	pci_set_drvdata(pdev, SHOST_TO_SAS_HA(shost));
+	do {
+		mvi = mvs_pci_alloc(pdev, ent, shost);
+		if (!mvi) {
+			rc = -ENOMEM;
+			goto err_out_regions;
+		}
+
+		if (mv_spi_init(mvi, &hba_info_para)) {
+			mvs_free(mvi);
+			rc = -EFAULT;
+			goto err_out_regions;
+		}
+
+		mvi->instance = nhost;
+		rc = MVS_CHIP_DISP->chip_init(mvi);
+		if (rc) {
+			mvs_free(mvi);
+			goto err_out_regions;
+		}
+		mvs_print_info(mvi);
+		nhost++;
+	}while(nhost<chip->n_host);
+
+	mvs_post_sas_ha_init(shost,chip);
+
+	rc = scsi_add_host(shost, &pdev->dev);
+	if (rc)
+		goto err_out_shost;
+
+	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
+	if (rc)
+		goto err_out_shost;
+
+	rc = request_irq(pdev->irq, irq_handler, IRQF_SHARED, DRV_NAME,
SHOST_TO_SAS_HA(shost));
+	if (rc)
+		goto err_not_sas;
+
+	MVS_CHIP_DISP->interrupt_enable(mvi);
+	scsi_scan_host(mvi->shost);
+
+	return 0;
+
+err_not_sas:
+	sas_unregister_ha(SHOST_TO_SAS_HA(shost));
+err_out_shost:
+	scsi_remove_host(mvi->shost);
+err_out_regions:
+	pci_release_regions(pdev);
+err_out_disable:
+	pci_disable_device(pdev);
+err_out_enable:
+	return rc;
+}
+/*TODO*/
+static void __devexit mvs_pci_remove(struct pci_dev *pdev)
+{
+	unsigned short core_nr,i=0;
+	struct sas_ha_struct * sha = pci_get_drvdata(pdev);
+	struct mvs_info * mvi = NULL;
+
+	core_nr = ((unsigned long *)sha->lldd_ha)[0] >> 16;
+	mvi = ((struct mvs_info **)sha->lldd_ha)[2];
+	pci_set_drvdata(pdev, NULL);
+	sas_unregister_ha(sha);
+	sas_remove_host(mvi->shost);
+	scsi_remove_host(mvi->shost);
+
+	MVS_CHIP_DISP->interrupt_disable(mvi);
+	free_irq(mvi->irq, sha);
+	for(i=0; i< core_nr; i++){
+		mvi = ((struct mvs_info **)sha->lldd_ha)[2+i];
+		mvs_free(mvi);
+	}
+	kfree(sha->sas_phy);
+	kfree(sha->sas_port);
+	kfree(sha);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	return;
+}
+
+static struct pci_device_id __devinitdata mvs_pci_table[] = {
+	{ PCI_VDEVICE(MARVELL, 0x6320), chip_6320 },
+	{ PCI_VDEVICE(MARVELL, 0x6340), chip_6440 },
+	{
+		.vendor 	= PCI_VENDOR_ID_MARVELL,
+		.device 	= 0x6440,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= 0x6480,
+		.class		= 0,
+		.class_mask	= 0,
+		.driver_data	= chip_6485,
+	},
+	{ PCI_VDEVICE(MARVELL, 0x6440), chip_6440 },
+	{ PCI_VDEVICE(MARVELL, 0x6485), chip_6485 },
+	{ PCI_VDEVICE(MARVELL, 0x9480), chip_9480 },
+	{ PCI_VDEVICE(MARVELL, 0x9180), chip_9180 },
+	{
+		.vendor 	= 0x1b4b,
+		.device 	= 0x9480,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.class		= 0,
+		.class_mask	= 0,
+		.driver_data	= chip_9480,
+	},
+
+	{ }	/* terminate list */
+};
+
+static struct pci_driver mvs_pci_driver = {
+	.name		= DRV_NAME,
+	.id_table	= mvs_pci_table,
+	.probe		= mvs_pci_init,
+	.remove		= __devexit_p(mvs_pci_remove),
+};
+#endif
+
+#ifndef CONFIG_PCI
+static struct platform_driver mvs_platform_driver = {
+	.probe		= mvs_platform_probe,
+	.remove		= mvs_platform_remove,
+	.driver		= {
+			  .name  = DRV_NAME,
+			  .owner = THIS_MODULE,
+			  },
+};
+#endif
+
+static int __init mvs_init(void)
+{
+	int rc;
+
+	mvs_stt = sas_domain_attach_transport(&mvs_transport_ops);
+	if (!mvs_stt)
+		return -ENOMEM;
+
+#ifdef CONFIG_PCI
+	rc = pci_register_driver(&mvs_pci_driver);
+#else
+	rc = platform_driver_register(&mvs_platform_driver);
+#endif
+	if (rc)
+		goto err_out;
+
+	return 0;
+
+err_out:
+	sas_release_transport(mvs_stt);
+	return rc;
+}
+
+static void __exit mvs_exit(void)
+{
+#ifdef CONFIG_PCI
+	pci_unregister_driver(&mvs_pci_driver);
+#else
+	platform_driver_unregister(&mvs_platform_driver);
+#endif
+	sas_release_transport(mvs_stt);
+}
+
+module_init(mvs_init);
+module_exit(mvs_exit);
+
+MODULE_AUTHOR("Jeff Garzik <jgarzik@pobox.com>");
+MODULE_DESCRIPTION("Marvell 88SE6440 SAS/SATA controller driver");
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL");
+#ifdef CONFIG_PCI
+MODULE_DEVICE_TABLE(pci, mvs_pci_table);
+#endif
-- 
1.5.4.3



