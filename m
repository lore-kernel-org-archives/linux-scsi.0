From: Li Jianyun <jianyunff@gmail.com>
Subject: [PATCH] Add Marvell UMI driver
Date: Wed, 20 Apr 2011 22:02:19 +0800
Message-ID: <4daee9cb.04558f0a.76dc.4776@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-pci-owner@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


	The Marvell Universal Message Interface (UMI) defines a messaging
interface between host and Marvell products. It considers situations of
limited system resource and optimized system performance.
	UMI driver translates host request to message and sends message to
FW via UMI, FW receives message and processes it, then sends response to
UMI driver.
	FW generates an interrupt when it needs to send information or
responseto UMI driver.

Signed-off-by: Jianyun Li <jianyunff@gmail.com>
---
 drivers/scsi/Kconfig    |    9 +
 drivers/scsi/Makefile   |    1 +
 drivers/scsi/mvumi.c    | 2245 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/mvumi.h    |  610 +++++++++++++
 include/linux/pci_ids.h |    2 +
 5 files changed, 2867 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/mvumi.c
 create mode 100644 drivers/scsi/mvumi.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4a1f029..181ea6c 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -559,6 +559,15 @@ source "drivers/scsi/aic7xxx/Kconfig.aic79xx"
 source "drivers/scsi/aic94xx/Kconfig"
 source "drivers/scsi/mvsas/Kconfig"

+config SCSI_MVUMI
+	tristate "Marvell UMI driver"
+	depends on SCSI && PCI
+	help
+	  Module for Marvell Universal Message Interface(UMI) driver
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mvumi.
+
 config SCSI_DPT_I2O
 	tristate "Adaptec I2O RAID support "
 	depends on SCSI && PCI && VIRT_TO_BUS
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 7ad0b8a..bce1609 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -133,6 +133,7 @@ obj-$(CONFIG_SCSI_IBMVFC)	+= ibmvscsi/
 obj-$(CONFIG_SCSI_HPTIOP)	+= hptiop.o
 obj-$(CONFIG_SCSI_STEX)		+= stex.o
 obj-$(CONFIG_SCSI_MVSAS)	+= mvsas/
+obj-$(CONFIG_SCSI_MVUMI)	+= mvumi.o
 obj-$(CONFIG_PS3_ROM)		+= ps3rom.o
 obj-$(CONFIG_SCSI_CXGB3_ISCSI)	+= libiscsi.o libiscsi_tcp.o cxgbi/
 obj-$(CONFIG_SCSI_CXGB4_ISCSI)	+= libiscsi.o libiscsi_tcp.o cxgbi/
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
new file mode 100644
index 0000000..a29c054
--- /dev/null
+++ b/drivers/scsi/mvumi.c
@@ -0,0 +1,2245 @@
+/*
+ * Marvell UMI driver
+ *
+ * Copyright 2011 Marvell. <jyli@marvell.com>
+ *
+ * This file is licensed under GPLv2.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; version 2 of the
+ * License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA
+*/
+
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/pci.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/blkdev.h>
+#include <linux/io.h>
+#include <linux/vmalloc.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
+#include <asm/uaccess.h>
+
+#include "mvumi.h"
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("jyli@marvell.com");
+
+
+MODULE_DESCRIPTION("Marvell UMI Driver");
+
+
+static DEFINE_PCI_DEVICE_TABLE(mvumi_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_2, PCI_DEVICE_ID_MARVELL_MV9143) },
+	{ 0 }
+};
+
+MODULE_DEVICE_TABLE(pci, mvumi_pci_table);
+
+
+/* if tag_stack_type!=FIFO_TAG, use FILO,
+*  if tag_stack_type==FIFO_TAG, use FIFO, ptr_out is the next
+*  tag to get and top is the number of available tags in the
+*  stack when use FIFO, get tag from ptr_out and free tag to
+* (ptr_out+top)%size
+*/
+
+#define FILO_TAG 0x00
+#define FIFO_TAG 0x01
+
+static void tag_init(struct tag_stack *st, unsigned short size)
+{
+	unsigned short i;
+	BUG_ON(size != st->size);
+	st->top = size;
+	st->tag_stack_type = FILO_TAG;
+	st->ptr_out = 0;
+	for (i = 0; i < size; i++)
+		st->stack[i] = size - 1 - i;
+}
+
+static unsigned short tag_get_one(struct mvumi_hba *mhba, struct tag_stack *st)
+{
+	unsigned short n_tag, tag;
+
+	BUG_ON(st->top <= 0);
+	if (st->tag_stack_type == FIFO_TAG) {
+		n_tag = st->stack[st->ptr_out++];
+		if (st->ptr_out >= st->size)
+			st->ptr_out = 0;
+		st->top--;
+		tag = n_tag;
+	} else
+		tag = st->stack[--st->top];
+	return tag;
+}
+
+static void tag_release_one(struct mvumi_hba *mhba, struct tag_stack *st,
+							unsigned short tag)
+{
+	BUG_ON(st->top >= st->size);
+	if (st->tag_stack_type == FIFO_TAG) {
+		st->stack[(st->ptr_out + st->top) % st->size] = tag;
+		st->top++;
+	} else
+		st->stack[st->top++] = tag;
+}
+
+static unsigned char tag_is_empty(struct tag_stack *st)
+{
+	if (st->top == 0)
+		return 1;
+	return 0;
+}
+
+static int mvumi_map_pci_addr(struct pci_dev *dev, void **addr_array)
+{
+	int i;
+	unsigned long addr, range;
+
+	for (i = 0; i < MAX_BASE_ADDRESS; i++) {
+		addr = pci_resource_start(dev, i);
+		range = pci_resource_len(dev, i);
+
+		if (pci_resource_flags(dev, i) & IORESOURCE_MEM) {
+			addr_array[i] = (void *) ioremap_nocache(addr, range);
+			if (!addr_array[i]) {
+				dev_printk(KERN_ERR, &dev->dev,
+					"Failed to map IO mem\n");
+				return -1;
+			}
+		} else
+			addr_array[i] = (void *) addr;
+
+		dev_printk(KERN_INFO, &dev->dev,
+			"BAR %d : %p.\n", i, addr_array[i]);
+	}
+	return 0;
+}
+
+static void mvumi_unmap_pci_addr(struct pci_dev *dev, void **addr_array)
+{
+	int i;
+
+	for (i = 0; i < MAX_BASE_ADDRESS; i++)
+		if (pci_resource_flags(dev, i) & IORESOURCE_MEM)
+			iounmap(addr_array[i]);
+}
+
+static struct mvumi_res_mgnt *mvumi_alloc_mem_resource(struct mvumi_hba *mhba,
+				enum resource_type type, unsigned int size)
+{
+	struct mvumi_res_mgnt *res_mgnt =
+			vmalloc(sizeof(struct mvumi_res_mgnt));
+	if (NULL == res_mgnt) {
+		dev_printk(KERN_ERR, &mhba->pdev->dev,
+			"Failed to allocate memory for mod_res.\n");
+		return NULL;
+	}
+	memset(res_mgnt, 0, sizeof(sizeof(struct mvumi_res_mgnt)));
+
+	switch (type) {
+	case RESOURCE_CACHED_MEMORY:
+		res_mgnt->virt_addr = vmalloc(size);
+		if (NULL == res_mgnt->virt_addr) {
+			dev_printk(KERN_ERR, &mhba->pdev->dev,
+				"unable to allocate memory,size = %d.\n", size);
+			vfree(res_mgnt);
+			return NULL;
+		}
+		break;
+
+	case RESOURCE_UNCACHED_MEMORY:
+		size = round_up(size, 8);
+		res_mgnt->virt_addr = (void *) pci_alloc_consistent(mhba->pdev,
+							size,
+							&res_mgnt->bus_addr);
+		if (NULL == res_mgnt->virt_addr) {
+			dev_printk(KERN_ERR, &mhba->pdev->dev,
+					"unable to allocate consistent mem,"
+							"size = %d.\n", size);
+			vfree(res_mgnt);
+			return NULL;
+		}
+		break;
+
+	default:
+		dev_printk(KERN_ERR, &mhba->pdev->dev,
+					"resource type %d is unknown.\n", type);
+		vfree(res_mgnt);
+		return NULL;
+	}
+
+	memset(res_mgnt->virt_addr, 0, size);
+	res_mgnt->type = type;
+	res_mgnt->size = size;
+	list_add_tail(&res_mgnt->res_entry, &mhba->res_list);
+
+	return res_mgnt;
+}
+
+static void mvumi_release_mem_resource(struct mvumi_hba *mhba)
+{
+	struct mvumi_res_mgnt *res_mgnt, *tmp;
+
+	list_for_each_entry_safe(res_mgnt, tmp, &mhba->res_list, res_entry) {
+		switch (res_mgnt->type) {
+		case RESOURCE_UNCACHED_MEMORY:
+			pci_free_consistent(mhba->pdev,
+						res_mgnt->size,
+						res_mgnt->virt_addr,
+						res_mgnt->bus_addr);
+			break;
+		case RESOURCE_CACHED_MEMORY:
+			vfree(res_mgnt->virt_addr);
+			break;
+		default:
+			dev_printk(KERN_WARNING, &mhba->pdev->dev,
+				"resource type %d is unknown.\n",
+					res_mgnt->type);
+			break;
+		}
+		list_del_init(&res_mgnt->res_entry);
+		vfree(res_mgnt);
+	}
+	mhba->fw_flag &= ~MVUMI_FW_ALLOC;
+}
+
+/**
+ * mvumi_make_sgl -	Prepares  SGL
+ * @mhba:		Adapter soft state
+ * @scmd:		SCSI command from the mid-layer
+ * @sgl_p:		SGL to be filled in
+ *
+ * If successful, this function returns the number of SG elements. Otherwise,
+ * it returnes -1.
+ */
+static int mvumi_make_sgl(struct mvumi_hba *mhba, struct scsi_cmnd *scmd,
+					void *sgl_p)
+{
+	struct scatterlist *sg;
+	struct mv_sgl *m_sg;
+	int sg_count = 0, i;
+	unsigned int len;
+	dma_addr_t busaddr = 0;
+
+	if (scsi_bufflen(scmd) > (scmd->device->host->max_sectors << 9))
+		dev_printk(KERN_WARNING, &mhba->pdev->dev,
+		"request length exceeds the maximum alowed value.\n");
+
+	if (0 == scsi_bufflen(scmd))
+		return 0;
+
+	m_sg = (struct mv_sgl *) sgl_p;
+	if (scsi_sg_count(scmd)) {
+		sg = (struct scatterlist *) scsi_sglist(scmd);
+		sg_count = pci_map_sg(mhba->pdev,
+				sg,
+				scsi_sg_count(scmd),
+				(int) scmd->sc_data_direction);
+
+		if (sg_count != scsi_sg_count(scmd)) {
+			dev_printk(KERN_WARNING, &mhba->pdev->dev,
+				"sg_count(%d) != scmd->use_sg(%d)\n",
+				(unsigned int) sg_count, scsi_sg_count(scmd));
+		}
+		for (i = 0; i < sg_count; i++) {
+			busaddr = sg_dma_address(&sg[i]);
+			len = sg_dma_len(&sg[i]);
+			m_sg->baseaddr_l = cpu_to_le32((unsigned int) busaddr);
+			m_sg->baseaddr_h = cpu_to_le32((unsigned int)
+						((busaddr >> 16) >> 16));
+			m_sg->flags = 0;
+			if ((i + 1) == sg_count)
+				m_sg->flags |= SGD_EOT;
+			sgd_setsz(m_sg, cpu_to_le32(len));
+			sgd_inc(m_sg);
+		}
+	} else {
+		scmd->SCp.dma_handle = scsi_bufflen(scmd) ?
+			pci_map_single(mhba->pdev, scsi_sglist(scmd),
+				scsi_bufflen(scmd),
+				(int) scmd->sc_data_direction)
+			: 0;
+		busaddr = scmd->SCp.dma_handle;
+		m_sg->baseaddr_l = cpu_to_le32((unsigned int) busaddr);
+		m_sg->baseaddr_h =
+			cpu_to_le32((unsigned int) ((busaddr >> 16) >> 16));
+		m_sg->flags = SGD_EOT;
+		sgd_setsz(m_sg, cpu_to_le32(scsi_bufflen(scmd)));
+		sg_count = 1;
+	}
+	BUG_ON((unsigned)sg_count > 0xFF);
+	return sg_count;
+}
+
+static int mvumi_internal_cmd_sgl(struct mvumi_hba *mhba, struct mvumi_cmd *cmd,
+							unsigned int size)
+{
+	struct mv_sgl *m_sg;
+	void *virt_addr;
+	dma_addr_t phy_addr;
+
+	if (size) {
+		virt_addr = (void *) pci_alloc_consistent(mhba->pdev, size,
+								&phy_addr);
+		if (virt_addr == NULL)
+			return -1;
+
+		memset(virt_addr, 0, size);
+
+		m_sg = (struct mv_sgl *) &cmd->frame->payload[0];
+		cmd->frame->sg_counts = 1;
+		cmd->data_buf = virt_addr;
+
+		m_sg->baseaddr_l = cpu_to_le32(phy_addr);
+		m_sg->baseaddr_h = cpu_to_le32((phy_addr >> 16) >> 16);
+		m_sg->flags = SGD_EOT;
+		sgd_setsz(m_sg, cpu_to_le32(size));
+	}
+	return 0;
+}
+static struct mvumi_cmd *mvumi_create_internal_cmd(struct mvumi_hba *mhba,
+				unsigned int buf_size)
+{
+	struct mvumi_cmd *cmd;
+
+	cmd = kmalloc(sizeof(struct mvumi_cmd), GFP_KERNEL);
+	if (cmd == NULL) {
+		dev_printk(KERN_ERR, &mhba->pdev->dev,
+			"failed to create a internal cmd\n");
+		return NULL;
+	}
+	memset(cmd, 0, sizeof(struct mvumi_cmd));
+	INIT_LIST_HEAD(&cmd->queue_pointer);
+
+	cmd->frame = kmalloc(mhba->ib_max_entry_size_bytes, GFP_KERNEL);
+	if (!cmd->frame) {
+		dev_printk(KERN_ERR, &mhba->pdev->dev,
+			"failed to allocate memory for FW frame,size = %d.\n",
+				mhba->ib_max_entry_size_bytes);
+		kfree(cmd);
+		return NULL;
+	}
+	memset(cmd->frame, 0, mhba->ib_max_entry_size_bytes);
+
+	if (buf_size) {
+		if (mvumi_internal_cmd_sgl(mhba, cmd, buf_size)) {
+			dev_printk(KERN_ERR, &mhba->pdev->dev,
+					"failed to allocate memory"
+					" for internal frame\n");
+			kfree(cmd->frame);
+			kfree(cmd);
+			return NULL;
+		}
+	} else
+		cmd->frame->sg_counts = 0;
+	cmd->mhba = mhba;
+	return cmd;
+}
+static void mvumi_delete_internal_cmd(struct mvumi_hba *mhba,
+						struct mvumi_cmd *cmd)
+{
+	struct mv_sgl *m_sg;
+	unsigned int size;
+	dma_addr_t phy_addr;
+
+	if (cmd && cmd->frame) {
+		if (cmd->frame->sg_counts) {
+			m_sg = (struct mv_sgl *) &cmd->frame->payload[0];
+			sgd_getsz(m_sg, size);
+
+			phy_addr = (dma_addr_t) m_sg->baseaddr_l |
+				(dma_addr_t) ((m_sg->baseaddr_h << 16) << 16);
+
+			pci_free_consistent(mhba->pdev, size, cmd->data_buf,
+								phy_addr);
+		}
+		kfree(cmd->frame);
+		kfree(cmd);
+	}
+
+}
+/**
+ * mvumi_get_cmd -	Get a command from the free pool
+ * @mhba:		Adapter soft state
+ *
+ * Returns a free command from the pool
+ */
+static struct mvumi_cmd *mvumi_get_cmd(struct mvumi_hba *mhba)
+{
+	struct mvumi_cmd *cmd = NULL;
+
+
+	if (likely(!list_empty(&mhba->cmd_pool))) {
+		cmd = list_entry((&mhba->cmd_pool)->next,
+				struct mvumi_cmd, queue_pointer);
+		list_del_init(&cmd->queue_pointer);
+	} else
+		dev_printk(KERN_WARNING, &mhba->pdev->dev,
+					"command pool is empty!\n");
+
+	return cmd;
+}
+
+/**
+ * mvumi_return_cmd -	Return a cmd to free command pool
+ * @mhba:		Adapter soft state
+ * @cmd:		Command packet to be returned to free command pool
+ */
+static inline void mvumi_return_cmd(struct mvumi_hba *mhba,
+						struct mvumi_cmd *cmd)
+{
+	cmd->scmd = NULL;
+	list_add_tail(&cmd->queue_pointer, &mhba->cmd_pool);
+}
+
+static void mvumi_free_frame_pool(struct mvumi_hba *mhba)
+{
+	int i;
+	struct mvumi_cmd *cmd;
+
+	for (i = 0; i < mhba->max_io; i++) {
+		cmd = mhba->cmd_list[i];
+		kfree(cmd->frame);
+	}
+}
+
+static int mvumi_create_frame_pool(struct mvumi_hba *mhba)
+{
+	int i;
+	struct mvumi_cmd *cmd;
+
+	for (i = 0; i < mhba->max_io; i++) {
+		cmd = mhba->cmd_list[i];
+		cmd->index = i;
+		cmd->frame = kmalloc(mhba->ib_max_entry_size_bytes,
+					GFP_KERNEL);
+
+		if (!cmd->frame) {
+			dev_printk(KERN_ERR, &mhba->pdev->dev,
+				"failed to allocate frame for cmd[0x%x].\n", i);
+			mvumi_free_frame_pool(mhba);
+			return -ENOMEM;
+		}
+		memset(cmd->frame, 0, mhba->ib_max_entry_size_bytes);
+	}
+
+	return 0;
+}
+
+/**
+ * mvumi_free_cmds -	Free all the cmds in the free cmd pool
+ * @mhba:		Adapter soft state
+ */
+static void mvumi_free_cmds(struct mvumi_hba *mhba)
+{
+	int i;
+
+	mvumi_free_frame_pool(mhba);
+	for (i = 0; i < mhba->max_io; i++)
+		kfree(mhba->cmd_list[i]);
+	kfree(mhba->cmd_list);
+	mhba->cmd_list = NULL;
+	INIT_LIST_HEAD(&mhba->cmd_pool);
+}
+
+/**
+ * mvumi_alloc_cmds -	Allocates the command packets
+ * @mhba:		Adapter soft state
+ *
+ */
+static int mvumi_alloc_cmds(struct mvumi_hba *mhba)
+{
+	int i, j;
+	unsigned int max_cmd;
+	struct mvumi_cmd *cmd;
+
+	max_cmd = mhba->max_io;
+	mhba->cmd_list =
+	    kcalloc(max_cmd, sizeof(struct mvumi_cmd *), GFP_KERNEL);
+
+	if (!mhba->cmd_list) {
+		dev_printk(KERN_ERR, &mhba->pdev->dev,
+				"failed to allocate memory for cmd list\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < max_cmd; i++) {
+		mhba->cmd_list[i] =
+			kmalloc(sizeof(struct mvumi_cmd), GFP_KERNEL);
+
+		if (!mhba->cmd_list[i]) {
+
+			for (j = 0; j < i; j++)
+				kfree(mhba->cmd_list[j]);
+			kfree(mhba->cmd_list);
+			mhba->cmd_list = NULL;
+			dev_printk(KERN_ERR, &mhba->pdev->dev,
+				"failed to allocate memory for cmd\n");
+			return -ENOMEM;
+		}
+	}
+
+	for (i = 0; i < max_cmd; i++) {
+		cmd = mhba->cmd_list[i];
+		memset(cmd, 0, sizeof(struct mvumi_cmd));
+		cmd->index = i;
+		cmd->mhba = mhba;
+		list_add_tail(&cmd->queue_pointer, &mhba->cmd_pool);
+	}
+
+	if (mvumi_create_frame_pool(mhba)) {
+		mvumi_free_cmds(mhba);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int mvumi_get_ib_list_entry(struct mvumi_hba *mhba, void **ib_entry)
+{
+	void *regs = mhba->mmio;
+	unsigned int ib_rp_reg, cur_tag;
+
+	if (atomic_read(&mhba->fw_outstanding) >= mhba->max_io) {
+		dev_printk(KERN_WARNING, &mhba->pdev->dev,
+				"firmware io overflow.\n");
+		return -1;
+	}
+	ib_rp_reg = mvumi_mr32(CLA_INB_READ_POINTER);
+
+	if (unlikely(((ib_rp_reg & CL_SLOT_NUM_MASK) ==
+			(mhba->ib_cur_slot & CL_SLOT_NUM_MASK)) &&
+			((ib_rp_reg & CL_POINTER_TOGGLE) !=
+			(mhba->ib_cur_slot & CL_POINTER_TOGGLE)))) {
+		dev_printk(KERN_WARNING, &mhba->pdev->dev,
+				"no free slot to use.\n");
+		return -1;
+	}
+
+	cur_tag = mhba->ib_cur_slot & CL_SLOT_NUM_MASK;
+	cur_tag++;
+	if (cur_tag >= mhba->list_num_io) {
+		cur_tag -= mhba->list_num_io;
+		mhba->ib_cur_slot ^= CL_POINTER_TOGGLE;
+	}
+	mhba->ib_cur_slot &= ~CL_SLOT_NUM_MASK;
+	mhba->ib_cur_slot |= (cur_tag & CL_SLOT_NUM_MASK);
+	*ib_entry = ((unsigned char *) mhba->ib_list +
+			cur_tag * mhba->ib_max_entry_size_bytes);
+	atomic_inc(&mhba->fw_outstanding);
+
+	return 0;
+}
+
+static unsigned char mvumi_send_ib_list_entry(struct mvumi_hba *mhba)
+{
+	void *regs = mhba->mmio;
+	writel((unsigned int) 0xfff, mhba->ib_shadow);
+	mhba->ib_cur_count = 0;
+	mvumi_mw32(CLA_INB_WRITE_POINTER, mhba->ib_cur_slot);
+
+	return 0;
+}
+
+static unsigned char mvumi_receive_ob_list_entry(struct mvumi_hba *mhba)
+{
+	unsigned int ob_write_reg, ob_write_shadow_reg;
+	unsigned int cur_tag, assign_tag_end, i;
+	unsigned short tag, request_id;
+	struct mv_ob_data_pool *free_ob_pool;
+	struct mvumi_rsp_frame *ob_frame;
+	void *p_outb_frame, *regs;
+
+	regs = mhba->mmio;
+
+	do {
+		ob_write_reg = mvumi_mr32(CLA_OUTB_COPY_POINTER);
+		ob_write_shadow_reg = readl(mhba->ob_shadow);
+	} while ((ob_write_reg & CL_SLOT_NUM_MASK) !=
+					ob_write_shadow_reg);
+
+	cur_tag = mhba->ob_cur_slot & CL_SLOT_NUM_MASK;
+	assign_tag_end = ob_write_reg & CL_SLOT_NUM_MASK;
+
+	if ((ob_write_reg & CL_POINTER_TOGGLE) !=
+			(mhba->ob_cur_slot & CL_POINTER_TOGGLE)) {
+		assign_tag_end += mhba->list_num_io;
+
+	}
+	for (i = (assign_tag_end - cur_tag); i != 0; i--) {
+		cur_tag++;
+		if (cur_tag >= mhba->list_num_io) {
+			cur_tag -= mhba->list_num_io;
+			mhba->ob_cur_slot ^= CL_POINTER_TOGGLE;
+		}
+
+		free_ob_pool = (struct mv_ob_data_pool *) list_get_first_entry(
+				&mhba->ob_data_pool_list,
+				struct mv_ob_data_pool,
+				queue_pointer);
+		if (!free_ob_pool) {
+			if (cur_tag == 0) {
+				cur_tag = mhba->list_num_io - 1;
+				mhba->ob_cur_slot ^= CL_POINTER_TOGGLE;
+			} else
+				cur_tag -= 1;
+
+
+			break;
+		}
+
+		p_outb_frame = (void *)((unsigned char *) mhba->ob_list +
+				cur_tag * mhba->ob_max_entry_size_bytes);
+		if (mhba->pdev->device ==  PCI_DEVICE_ID_MARVELL_MV9143 &&
+			mhba->request_id_enabled) {
+			request_id =
+			((struct mvumi_rsp_frame *) p_outb_frame)->request_id;
+			tag = ((struct mvumi_rsp_frame *) p_outb_frame)->tag;
+
+			if ((mhba->tag_cmd[tag] == NULL) ||
+			(request_id != mhba->tag_cmd[tag]->request_id)) {
+				udelay(1);
+				p_outb_frame = (void *) ((unsigned char *)
+					mhba->ob_list + cur_tag *
+						mhba->ob_max_entry_size_bytes);
+
+				request_id = ((struct mvumi_rsp_frame *)
+						p_outb_frame)->request_id;
+				tag = ((struct mvumi_rsp_frame *)
+						p_outb_frame)->tag;
+				BUG_ON(request_id !=
+					mhba->tag_cmd[tag]->request_id);
+			}
+
+		}
+
+		memcpy(free_ob_pool->ob_data, p_outb_frame,
+				mhba->ob_max_entry_size_bytes);
+		ob_frame = (struct mvumi_rsp_frame *) p_outb_frame;
+		list_add_tail(&free_ob_pool->queue_pointer,
+				&mhba->free_ob_list);
+	}
+	mhba->ob_cur_slot &= ~CL_SLOT_NUM_MASK;
+	mhba->ob_cur_slot |= (cur_tag & CL_SLOT_NUM_MASK);
+	mvumi_mw32(CLA_OUTB_READ_POINTER, mhba->ob_cur_slot);
+
+	return 1;
+}
+
+static void mvumi_reset(void *regs)
+{
+	mvumi_mw32(CPU_ENPOINTA_MASK_REG, 0);
+	if (mvumi_mr32(CPU_ARM_TO_PCIEA_MSG1) != HANDSHAKE_DONESTATE)
+		return;
+
+	mvumi_mw32(CPU_PCIEA_TO_ARM_DRBL_REG, DRBL_SOFT_RESET);
+}
+
+static unsigned char mvumi_start(struct mvumi_hba *mhba);
+
+static int mvumi_wait_for_outstanding(struct mvumi_hba *mhba)
+{
+	mhba->fw_state = FW_STATE_ABORT;
+	mvumi_reset(mhba->mmio);
+
+	if (mvumi_start(mhba))
+		return FAILED;
+	else
+		return SUCCESS;
+}
+
+static int mvumi_generic_reset(struct scsi_cmnd *scmd)
+{
+	int ret_val;
+	struct mvumi_hba *mhba;
+
+	mhba = (struct mvumi_hba *) scmd->device->host->hostdata;
+
+	scmd_printk(KERN_NOTICE, scmd, "RESET -%ld cmd=%x retries=%x\n",
+			scmd->serial_number, scmd->cmnd[0], scmd->retries);
+
+	ret_val = mvumi_wait_for_outstanding(mhba);
+	if (ret_val == SUCCESS)
+		dev_printk(KERN_NOTICE, &mhba->pdev->dev, "reset successful\n");
+	else
+		dev_printk(KERN_NOTICE, &mhba->pdev->dev, "reset failed\n");
+
+	return ret_val;
+}
+
+static int mvumi_issue_blocked_cmd(struct mvumi_hba *mhba,
+						struct mvumi_cmd *cmd)
+{
+	unsigned char ret = 0;
+	unsigned long flags;
+
+	cmd->cmd_status = REQ_STATUS_PENDING;
+
+	if (atomic_read(&cmd->sync_cmd)) {
+		dev_printk(KERN_ERR, &mhba->pdev->dev,
+			"last blocked cmd not finished, sync_cmd = %d\n",
+						atomic_read(&cmd->sync_cmd));
+		BUG_ON(1);
+		return 0;
+	}
+	atomic_inc(&cmd->sync_cmd);
+	spin_lock_irqsave(mhba->shost->host_lock, flags);
+	mhba->instancet->fire_cmd(mhba, cmd);
+	spin_unlock_irqrestore(mhba->shost->host_lock, flags);
+
+	ret = wait_event_timeout(mhba->int_cmd_wait_q,
+		(cmd->cmd_status != REQ_STATUS_PENDING),
+		MVUMI_INTERNAL_CMD_WAIT_TIME * HZ);
+
+	/* command timeout */
+	if (atomic_read(&cmd->sync_cmd)) {
+		atomic_dec(&cmd->sync_cmd);
+		spin_lock_irqsave(mhba->shost->host_lock, flags);
+		if (mhba->tag_cmd[cmd->frame->tag]) {
+			mhba->tag_cmd[cmd->frame->tag] = 0;
+			dev_printk(KERN_WARNING, &mhba->pdev->dev,
+				"TIMEOUT:release tag [%d]\n", cmd->frame->tag);
+			tag_release_one(mhba, &mhba->tag_pool, cmd->frame->tag);
+		}
+		dev_printk(KERN_WARNING, &mhba->pdev->dev,
+			"TIMEOUT:release a internal command\n");
+		if (!list_empty(&cmd->queue_pointer)) {
+			dev_printk(KERN_WARNING, &mhba->pdev->dev,
+				"TIMEOUT:A internal command doesn't send!\n");
+			list_del_init(&cmd->queue_pointer);
+		} else
+			atomic_dec(&mhba->fw_outstanding);
+
+		spin_unlock_irqrestore(mhba->shost->host_lock, flags);
+
+	}
+
+	return ret;
+}
+static void mvumi_release_fw(struct mvumi_hba *mhba)
+{
+	mvumi_free_cmds(mhba);
+	mvumi_release_mem_resource(mhba);
+	mvumi_unmap_pci_addr(mhba->pdev, mhba->base_addr);
+	pci_release_regions(mhba->pdev);
+}
+
+static unsigned char mvumi_flush_cache(struct mvumi_hba *mhba)
+{
+	struct mvumi_cmd *cmd;
+	struct mvumi_msg_frame *frame;
+	unsigned char device_id;
+	unsigned char bitcount = sizeof(unsigned char) * 8;
+
+	for (device_id = 0; device_id < mhba->max_target_id; device_id++) {
+
+		if (!(mhba->target_map[device_id / bitcount] &
+				(1 << (device_id % bitcount))))
+			continue;
+		cmd = mvumi_create_internal_cmd(mhba, 0);
+		if (!cmd)
+			return -1;
+		cmd->scmd = 0;
+		cmd->mhba = mhba;
+		cmd->cmd_status = REQ_STATUS_PENDING;
+		atomic_set(&cmd->sync_cmd, 0);
+		frame = cmd->frame;
+		frame->req_function = CL_FUN_SCSI_CMD;
+		frame->device_id = device_id;
+		frame->cmd_flag = CMD_FLAG_NON_DATA;
+		frame->data_transfer_length = 0;
+		frame->cdb_length = MAX_COMMAND_SIZE;
+		memset(frame->cdb, 0, MAX_COMMAND_SIZE);
+		frame->cdb[0] = SCSI_CMD_MARVELL_SPECIFIC;
+		frame->cdb[2] = CDB_CORE_SHUTDOWN;
+
+		mvumi_issue_blocked_cmd(mhba, cmd);
+		if (cmd->cmd_status != SAM_STAT_GOOD) {
+			dev_printk(KERN_ERR, &mhba->pdev->dev,
+				"device %d flush cache failed, status=0x%x.\n",
+				device_id, cmd->cmd_status);
+		}
+
+		mvumi_delete_internal_cmd(mhba, cmd);
+	}
+	return 0;
+}
+
+static unsigned char
+mvumi_calculate_checksum(struct mv_handshake_header *p_header,
+							unsigned short len)
+{
+	unsigned char *ptr;
+	unsigned char ret = 0, i;
+
+	ptr = (unsigned char *) p_header->frame_content;
+	for (i = 0; i < len; i++) {
+		ret ^= *ptr;
+		ptr++;
+	}
+
+	return ret;
+}
+
+void mvumi_hs_build_page(struct mvumi_hba *mhba,
+			 struct mv_handshake_header *hs_header)
+{
+	struct mv_handshake_page2 *hs_page2;
+	struct mv_handshake_page4 *hs_page4;
+	struct mv_handshake_page3 *hs_page3;
+	struct timeval time;
+	unsigned int local_time;
+
+	switch (hs_header->page_code) {
+	case HS_PAGE_HOST_INFO:
+		hs_page2 = (struct mv_handshake_page2 *) hs_header;
+		hs_header->frame_length = sizeof(struct mv_handshake_page2) - 4;
+		memset(hs_header->frame_content, 0, hs_header->frame_length);
+		hs_page2->host_type = 3; /* 3 mean linux*/
+		hs_page2->host_ver.ver_major = VER_MAJOR;
+		hs_page2->host_ver.ver_minor = VER_MINOR;
+		hs_page2->host_ver.ver_oem = VER_OEM;
+		hs_page2->host_ver.ver_build = VER_BUILD;
+		hs_page2->system_io_bus = 0;
+		hs_page2->slot_number = 0;
+		hs_page2->intr_level = 0;
+		hs_page2->intr_vector = 0;
+		do_gettimeofday(&time);
+		local_time = (unsigned int) (time.tv_sec -
+						(sys_tz.tz_minuteswest * 60));
+		hs_page2->seconds_since1970 = local_time;
+		hs_header->checksum =
+			HS_SET_CHECKSUM(hs_header, hs_header->frame_length);
+		break;
+
+	case HS_PAGE_FIRM_CTL:
+		hs_page3 = (struct mv_handshake_page3 *) hs_header;
+		hs_header->frame_length = sizeof(struct mv_handshake_page3) - 4;
+		memset(hs_header->frame_content, 0, hs_header->frame_length);
+		hs_header->checksum =
+			HS_SET_CHECKSUM(hs_header, hs_header->frame_length);
+		break;
+
+	case HS_PAGE_CL_INFO:
+		hs_page4 = (struct mv_handshake_page4 *) hs_header;
+		hs_header->frame_length = sizeof(struct mv_handshake_page4) - 4;
+		memset(hs_header->frame_content, 0, hs_header->frame_length);
+		hs_page4->ib_baseaddr_l = mhba->ib_list_phys;
+
+		hs_page4->ob_baseaddr_l = mhba->ob_list_phys;
+
+		hs_page4->ib_baseaddr_h = (mhba->ib_list_phys >> 16) >> 16;
+		hs_page4->ob_baseaddr_h = (mhba->ob_list_phys >> 16) >> 16;
+		hs_page4->ib_entry_size = mhba->ib_max_entry_size_setting;
+		hs_page4->ob_entry_size = mhba->ob_max_entry_size_setting;
+		hs_page4->ob_depth = mhba->list_num_io;
+		hs_page4->ib_depth = mhba->list_num_io;
+		hs_header->checksum =
+			HS_SET_CHECKSUM(hs_header, hs_header->frame_length);
+		break;
+
+	default:
+		break;
+	}
+
+}
+
+static int mvumi_init_data(struct mvumi_hba *mhba);
+
+static int mvumi_hs_process_page(struct mvumi_hba *mhba,
+				struct mv_handshake_header *hs_header)
+{
+	struct mv_handshake_page1 *hs_page1;
+	unsigned char page_checksum;
+	int ret = 0;
+
+	page_checksum =
+		HS_SET_CHECKSUM(hs_header, hs_header->frame_length);
+	if (page_checksum != hs_header->checksum)
+		return -1;
+
+	switch (hs_header->page_code) {
+	case HS_PAGE_FIRM_CAP:
+		hs_page1 = (struct mv_handshake_page1 *) hs_header;
+
+		mhba->max_io = hs_page1->max_io_support;
+		mhba->list_num_io = hs_page1->cl_inout_list_depth;
+		mhba->max_transfer_size = hs_page1->max_transfer_size;
+		mhba->max_target_id = hs_page1->max_devices_support;
+		mhba->hba_capability = hs_page1->capability;
+		mhba->ib_max_entry_size_setting =
+						hs_page1->cl_in_max_entry_size;
+		mhba->ib_max_entry_size_bytes =
+				(1 << hs_page1->cl_in_max_entry_size) << 2;
+		BUG_ON(mhba->ib_max_entry_size_bytes & 0x3);
+		mhba->ob_max_entry_size_setting =
+						hs_page1->cl_out_max_entry_size;
+		mhba->ob_max_entry_size_bytes =
+				(1 << hs_page1->cl_out_max_entry_size) << 2;
+
+
+		mhba->max_num_sge = mhba->list_num_io;
+		dev_printk(KERN_INFO, &mhba->pdev->dev,
+				"FW version:%d\n", hs_page1->fw_ver.ver_build);
+		if (mhba->pdev->device == PCI_DEVICE_ID_MARVELL_MV9143) {
+			if (hs_page1->fw_ver.ver_build >= 2018)
+				mhba->request_id_enabled = 1;
+		}
+
+		break;
+	default:
+		break;
+	}
+	return ret;
+}
+
+/**
+ * mvumi_handshake -	Move the FW to READY state
+ * @mhba:				Adapter soft state
+ *
+ * During the initialization, FW passes can potentially be in any one of
+ * several possible states. If the FW in operational, waiting-for-handshake
+ * states, driver must take steps to bring it to ready state. Otherwise, it
+ * has to wait for the ready state.
+ */
+static int mvumi_handshake(struct mvumi_hba *mhba)
+{
+	unsigned int hs_state, tmp, hs_fun;
+	struct mv_handshake_header *hs_header;
+	void *regs = mhba->mmio;
+
+	if (mhba->fw_state == FW_STATE_STARTING)
+		hs_state = HS_S_START;
+	else {
+		tmp = mvumi_mr32(CPU_ARM_TO_PCIEA_MSG0);
+		hs_state = HS_GET_STATE(tmp);
+		dev_printk(KERN_INFO, &mhba->pdev->dev,
+			"handshake host state = 0x%x.\n", hs_state);
+		if (HS_GET_STATUS(tmp) != HS_STATUS_OK) {
+			mhba->fw_state = FW_STATE_STARTING;
+			return -1;
+		}
+	}
+
+	hs_fun = 0;
+	switch (hs_state) {
+	case HS_S_START:
+		mhba->fw_state = FW_STATE_HANDSHAKING;
+		HS_SET_STATUS(hs_fun, HS_STATUS_OK);
+		HS_SET_STATE(hs_fun, HS_S_RESET);
+		mvumi_mw32(CPU_PCIEA_TO_ARM_MSG1, HANDSHAKE_SIGNATURE);
+		mvumi_mw32(CPU_PCIEA_TO_ARM_MSG0, hs_fun);
+		mvumi_mw32(CPU_PCIEA_TO_ARM_DRBL_REG, DRBL_HANDSHAKE);
+		break;
+
+	case HS_S_RESET:
+		mhba->handshake_page = mhba->handshake_page_base;
+		mhba->handshake_page_phys = mhba->handshake_page_phys_base;
+		mvumi_mw32(CPU_PCIEA_TO_ARM_MSG1,
+				(unsigned int) mhba->handshake_page_phys);
+		mvumi_mw32(CPU_ARM_TO_PCIEA_MSG1,
+				(mhba->handshake_page_phys >> 16) >> 16);
+		HS_SET_STATUS(hs_fun, HS_STATUS_OK);
+		HS_SET_STATE(hs_fun, HS_S_PAGE_ADDR);
+		mvumi_mw32(CPU_PCIEA_TO_ARM_MSG0, hs_fun);
+		mvumi_mw32(CPU_PCIEA_TO_ARM_DRBL_REG, DRBL_HANDSHAKE);
+
+		break;
+
+	case HS_S_PAGE_ADDR:
+	case HS_S_QUERY_PAGE:
+	case HS_S_SEND_PAGE:
+		hs_header = (struct mv_handshake_header *) mhba->handshake_page;
+		if (hs_header->page_code == HS_PAGE_FIRM_CAP) {
+			mhba->hba_total_pages =
+			((struct mv_handshake_page1 *) hs_header)->total_pages;
+
+			if (mhba->hba_total_pages == 0)
+				mhba->hba_total_pages = HS_PAGE_TOTAL-1;
+
+		}
+
+		if (hs_state == HS_S_QUERY_PAGE) {
+			if (mvumi_hs_process_page(mhba, hs_header)) {
+				HS_SET_STATE(hs_fun, HS_S_ABORT);
+				return -1;
+			}
+			if (mvumi_init_data(mhba)) {
+				HS_SET_STATE(hs_fun, HS_S_ABORT);
+				return -1;
+			}
+		} else if (hs_state == HS_S_PAGE_ADDR) {
+			hs_header->page_code = 0;
+			mhba->hba_total_pages = HS_PAGE_TOTAL-1;
+
+		}
+
+		if ((hs_header->page_code + 1) <= mhba->hba_total_pages) {
+			hs_header->page_code++;
+			if (hs_header->page_code != HS_PAGE_FIRM_CAP) {
+				mvumi_hs_build_page(mhba, hs_header);
+				HS_SET_STATE(hs_fun, HS_S_SEND_PAGE);
+			} else
+				HS_SET_STATE(hs_fun, HS_S_QUERY_PAGE);
+
+		} else
+			HS_SET_STATE(hs_fun, HS_S_END);
+
+		HS_SET_STATUS(hs_fun, HS_STATUS_OK);
+		mvumi_mw32(CPU_PCIEA_TO_ARM_MSG0, hs_fun);
+		mvumi_mw32(CPU_PCIEA_TO_ARM_DRBL_REG, DRBL_HANDSHAKE);
+		break;
+
+	case HS_S_END:
+		/* Set communication list ISR */
+		tmp = mvumi_mr32(CPU_ENPOINTA_MASK_REG);
+		tmp |= INT_MAP_COMAOUT | INT_MAP_COMAERR;
+		mvumi_mw32(CPU_ENPOINTA_MASK_REG, tmp);
+		writel(mhba->list_num_io, mhba->ib_shadow);
+		/* Set InBound List Avaliable count shadow */
+		mvumi_mw32(CLA_INB_AVAL_COUNT_BASEL, mhba->ib_shadow_phys);
+		mvumi_mw32(CLA_INB_AVAL_COUNT_BASEH,
+			(mhba->ib_shadow_phys >> 16) >> 16);
+
+
+		/* Set OutBound List Avaliable count shadow */
+		writel((unsigned int) ((mhba->list_num_io-1) |
+				CL_POINTER_TOGGLE), mhba->ob_shadow);
+		mvumi_mw32(0x5B0, mhba->ob_shadow_phys);
+		mvumi_mw32(0x5B4, (mhba->ob_shadow_phys >> 16) >> 16);
+
+		mhba->ib_cur_slot = (mhba->list_num_io - 1) | CL_POINTER_TOGGLE;
+		mhba->ob_cur_slot = (mhba->list_num_io - 1) | CL_POINTER_TOGGLE;
+		mhba->fw_state = FW_STATE_STARTED;
+
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static unsigned char mvumi_handshake_event(struct mvumi_hba *mhba)
+{
+	unsigned int isr_status;
+	unsigned long before;
+
+	before = jiffies;
+	mvumi_handshake(mhba);
+	do {
+		isr_status = mhba->instancet->read_fw_status_reg(mhba->mmio);
+
+		if (mhba->fw_state == FW_STATE_STARTED)
+			return 0;
+		if (time_after(jiffies, before + FW_MAX_DELAY * HZ)) {
+			dev_printk(KERN_ERR, &mhba->pdev->dev,
+				"no handshake response at state 0x%x.\n",
+				  mhba->fw_state);
+			dev_printk(KERN_ERR, &mhba->pdev->dev,
+				"isr : global=0x%x,status=0x%x.\n",
+					mhba->global_isr, isr_status);
+			return -1;
+		}
+		rmb();
+		usleep_range(1000, 2000);
+	} while (!(isr_status & DRBL_HANDSHAKE_ISR));
+
+	return 0;
+}
+
+static unsigned char mvumi_check_handshake(struct mvumi_hba *mhba)
+{
+	void *regs = mhba->mmio;
+	unsigned int tmp;
+	unsigned long before;
+
+	dev_printk(KERN_INFO, &mhba->pdev->dev,
+				"Waiting for firmware ready...\n");
+
+	before = jiffies;
+	tmp = mvumi_mr32(CPU_ARM_TO_PCIEA_MSG1);
+	while ((tmp != HANDSHAKE_READYSTATE) && (tmp != HANDSHAKE_DONESTATE)) {
+		if (tmp != HANDSHAKE_READYSTATE)
+			mvumi_mw32(CPU_PCIEA_TO_ARM_DRBL_REG, DRBL_MU_RESET);
+		if (time_after(jiffies, before + FW_MAX_DELAY * HZ)) {
+			dev_printk(KERN_ERR, &mhba->pdev->dev,
+				"invalid handshake signature 0x%x\n", tmp);
+			return -1;
+		}
+		usleep_range(1000, 2000);
+		rmb();
+		tmp = mvumi_mr32(CPU_ARM_TO_PCIEA_MSG1);
+	}
+	dev_printk(KERN_INFO, &mhba->pdev->dev, "Handshake signature = 0x%x.\n",
+					mvumi_mr32(CPU_ARM_TO_PCIEA_MSG1));
+
+	mhba->fw_state = FW_STATE_STARTING;
+	dev_printk(KERN_INFO, &mhba->pdev->dev, "start firmware handshake.\n");
+	while (1) {
+		if (mvumi_handshake_event(mhba)) {
+			dev_printk(KERN_ERR, &mhba->pdev->dev,
+				"start firmware failed at state 0x%x.\n",
+				  mhba->fw_state);
+			return -1;
+		}
+
+		if (mhba->fw_state == FW_STATE_STARTED)
+			break;
+	}
+	dev_printk(KERN_INFO, &mhba->pdev->dev,
+				"FW state at  0x%x.\n", mhba->fw_state);
+	return 0;
+}
+
+static unsigned char mvumi_start(struct mvumi_hba *mhba)
+{
+	void *regs = mhba->mmio;
+	unsigned int tmp;
+	/* clear Door bell */
+	tmp = mvumi_mr32(CPU_ARM_TO_PCIEA_DRBL_REG);
+	mvumi_mw32(CPU_ARM_TO_PCIEA_DRBL_REG, tmp);
+
+	mvumi_mw32(CPU_ARM_TO_PCIEA_MASK_REG, 0x3FFFFFFF);
+	tmp = mvumi_mr32(CPU_ENPOINTA_MASK_REG) | INT_MAP_DL_CPU2PCIEA;
+	mvumi_mw32(CPU_ENPOINTA_MASK_REG, tmp);
+	if (mvumi_check_handshake(mhba))
+		goto error;
+
+	dev_printk(KERN_INFO, &mhba->pdev->dev, "CLA_INB_LIST_BASEL=0x%x.\n",
+					mvumi_mr32(CLA_INB_LIST_BASEL));
+	dev_printk(KERN_INFO, &mhba->pdev->dev, "CLA_INB_LIST_BASEH=0x%x.\n",
+					mvumi_mr32(CLA_INB_LIST_BASEH));
+	dev_printk(KERN_INFO, &mhba->pdev->dev, "CLA_OUTB_LIST_BASEL=0x%x.\n",
+					mvumi_mr32(CLA_OUTB_LIST_BASEL));
+	dev_printk(KERN_INFO, &mhba->pdev->dev, "CLA_OUTB_LIST_BASEH=0x%x.\n",
+					mvumi_mr32(CLA_OUTB_LIST_BASEH));
+	dev_printk(KERN_INFO, &mhba->pdev->dev, "firmware handshake ok.\n");
+	return 0;
+
+error:
+	dev_printk(KERN_ERR, &mhba->pdev->dev, "firmware handshake failed.\n");
+	return -1;
+}
+
+/**
+ * mvumi_complete_cmd -	Completes a command
+ * @mhba:			Adapter soft state
+ * @cmd:			Command to be completed
+ */
+static void mvumi_complete_cmd(struct mvumi_hba *mhba, struct mvumi_cmd *cmd,
+					struct mvumi_rsp_frame *ob_frame)
+{
+	struct scsi_cmnd *scmd = cmd->scmd;
+
+	cmd->scmd->SCp.ptr = NULL;
+	scmd->result = ob_frame->req_status;
+
+	switch (ob_frame->req_status) {
+	case SAM_STAT_GOOD:
+		scmd->result |= DID_OK << 16;
+		break;
+	case SAM_STAT_BUSY:
+		scmd->result |= DID_BUS_BUSY << 16;
+		break;
+	case SAM_STAT_CHECK_CONDITION:
+		scmd->result |= (DID_OK << 16);
+		if (ob_frame->rsp_flag & CL_RSP_FLAG_SENSEDATA) {
+			memcpy(cmd->scmd->sense_buffer, ob_frame->payload,
+				sizeof(struct mvumi_sense_data));
+			scmd->result |=  (DRIVER_SENSE << 24);
+		}
+		break;
+	default:
+		scmd->result |= (DRIVER_INVALID << 24) | (DID_ABORT << 16);
+		break;
+	}
+
+	if (scsi_bufflen(scmd)) {
+		if (scsi_sg_count(scmd)) {
+			pci_unmap_sg(mhba->pdev,
+				scsi_sglist(scmd),
+				scsi_sg_count(scmd),
+				(int) scmd->sc_data_direction);
+		} else {
+			pci_unmap_single(mhba->pdev,
+				scmd->SCp.dma_handle,
+				scsi_bufflen(scmd),
+				(int) scmd->sc_data_direction);
+
+			scmd->SCp.dma_handle = 0;
+		}
+	}
+
+	cmd->scmd->scsi_done(scmd);
+	mvumi_return_cmd(mhba, cmd);
+}
+static void mvumi_complete_internal_cmd(struct mvumi_hba *mhba,
+						struct mvumi_cmd *cmd,
+					struct mvumi_rsp_frame *ob_frame)
+{
+	if (atomic_read(&cmd->sync_cmd)) {
+		cmd->cmd_status = ob_frame->req_status;
+
+		if ((ob_frame->req_status == SAM_STAT_CHECK_CONDITION) &&
+				(ob_frame->rsp_flag & CL_RSP_FLAG_SENSEDATA) &&
+				cmd->data_buf) {
+			memcpy(cmd->data_buf, ob_frame->payload,
+					sizeof(struct mvumi_sense_data));
+		}
+		atomic_dec(&cmd->sync_cmd);
+		wake_up(&mhba->int_cmd_wait_q);
+	}
+}
+
+static void mvumi_show_event(struct mvumi_hba *mhba,
+			struct mvumi_driver_event_v2 *param)
+{
+	struct	mvumi_driver_event *ptr = &param->event_v1;
+	unsigned int i;
+
+	dev_printk(KERN_WARNING, &mhba->pdev->dev,
+		"Event[0x%x] id[0x%x] severity[0x%x] device id[0x%x]\n",
+		ptr->sequence_no, ptr->event_id, ptr->severity, ptr->device_id);
+	if (ptr->param_count) {
+		printk(KERN_WARNING "Event param(len 0x%x): ",
+						ptr->param_count);
+		for (i = 0; i < ptr->param_count; i++)
+			printk(KERN_WARNING "0x%x ", ptr->params[i]);
+
+		printk(KERN_WARNING "\n");
+	}
+
+	if (param->sense_data_length) {
+		printk(KERN_WARNING "Event sense data(len 0x%x): ",
+						param->sense_data_length);
+		for (i = 0; i < param->sense_data_length; i++)
+			printk(KERN_WARNING "0x%x ", param->sense_data[i]);
+		printk(KERN_WARNING "\n");
+	}
+}
+static void mvumi_notification(struct mvumi_hba *mhba, u8 msg, void *buffer)
+{
+	if (msg == APICDB1_EVENT_GETEVENT) {
+		int i, count;
+		struct mvumi_driver_event_v2 *param = NULL;
+		struct mvumi_event_req *er = buffer;
+		count = er->count;
+		for (i = 0; (i < count) && (i < MAX_EVENTS_RETURNED); i++) {
+			param = &er->events[i];
+			mvumi_show_event(mhba, param);
+		}
+	}
+}
+static int mvumi_get_event(struct mvumi_hba *mhba, unsigned char msg)
+{
+	struct mvumi_cmd *cmd;
+	struct mvumi_msg_frame *frame;
+	cmd = mvumi_create_internal_cmd(mhba, 512);
+	if (!cmd)
+		return -1;
+
+	cmd->scmd = NULL;
+	cmd->mhba = mhba;
+	cmd->cmd_status = REQ_STATUS_PENDING;
+	atomic_set(&cmd->sync_cmd, 0);
+	frame = cmd->frame;
+	frame->device_id = 0;
+	frame->cmd_flag = CMD_FLAG_DATA_IN;
+	frame->req_function = CL_FUN_SCSI_CMD;
+	frame->cdb_length = MAX_COMMAND_SIZE;
+	frame->data_transfer_length = sizeof(struct mvumi_event_req);
+	memset(frame->cdb, 0, MAX_COMMAND_SIZE);
+	frame->cdb[0] = APICDB0_EVENT;
+	frame->cdb[1] = msg;
+	mvumi_issue_blocked_cmd(mhba, cmd);
+
+
+	if (cmd->cmd_status != SAM_STAT_GOOD)
+		dev_printk(KERN_ERR, &mhba->pdev->dev,
+			"get event failed, status=0x%x.\n", cmd->cmd_status);
+	else
+		mvumi_notification(mhba, cmd->frame->cdb[1], cmd->data_buf);
+
+	mvumi_delete_internal_cmd(mhba, cmd);
+
+	return 0;
+
+}
+
+static void mvumi_scan_events(struct work_struct *work)
+{
+	struct mvumi_events_wq *mu_ev =
+		container_of(work, struct mvumi_events_wq, work_q);
+
+	struct mvumi_hba *mhba = mu_ev->mhba;
+	unsigned char msg = mu_ev->event;
+
+	mvumi_get_event(mhba, msg);
+	kfree(mu_ev);
+}
+
+static void mvumi_launch_events(struct mvumi_hba *mhba, u8 msg)
+{
+	struct mvumi_events_wq *mu_ev;
+
+	mu_ev = kzalloc(sizeof(*mu_ev), GFP_ATOMIC);
+	if (mu_ev) {
+		INIT_WORK(&mu_ev->work_q, mvumi_scan_events);
+
+		mu_ev->mhba = mhba;
+		mu_ev->event = msg;
+		mu_ev->param = NULL;
+
+		schedule_work(&mu_ev->work_q);
+	} else
+		dev_printk(KERN_WARNING, &mhba->pdev->dev,
+					"can't get events.\n");
+}
+
+static unsigned char mvumi_handle_clob(struct mvumi_hba *mhba)
+{
+	struct mvumi_rsp_frame *ob_frame;
+	struct mvumi_cmd *cmd;
+	struct mv_ob_data_pool *pool;
+
+	while (!list_empty(&mhba->free_ob_list)) {
+		pool = list_get_first_entry(&mhba->free_ob_list,
+						struct mv_ob_data_pool,
+						queue_pointer);
+
+		list_add_tail(&pool->queue_pointer, &mhba->ob_data_pool_list);
+
+		ob_frame = (struct mvumi_rsp_frame *) &pool->ob_data[0];
+		cmd = mhba->tag_cmd[ob_frame->tag];
+
+		if (cmd == NULL) {
+			dev_printk(KERN_WARNING, &mhba->pdev->dev,
+				"TAG [%x] with NO command\n", ob_frame->tag);
+			return -1;
+		}
+		atomic_dec(&mhba->fw_outstanding);
+		mhba->tag_cmd[ob_frame->tag] = 0;
+		tag_release_one(mhba, &mhba->tag_pool, ob_frame->tag);
+
+		BUG_ON(!(!mhba->request_id_enabled ||
+			(ob_frame->request_id == cmd->request_id)));
+		if (cmd->scmd)
+			mvumi_complete_cmd(mhba, cmd, ob_frame);
+		else
+			mvumi_complete_internal_cmd(mhba, cmd, ob_frame);
+	}
+	mhba->instancet->fire_cmd(mhba, NULL);
+	return 0;
+}
+static irqreturn_t mvumi_isr_handler(int irq, void *devp)
+{
+	struct mvumi_hba *mhba = (struct mvumi_hba *) devp;
+	unsigned int isr_bit, isr_status;
+	unsigned long flags;
+
+	spin_lock_irqsave(mhba->shost->host_lock, flags);
+	if (mhba->instancet->clear_intr(mhba)) {
+		spin_unlock_irqrestore(mhba->shost->host_lock, flags);
+		return IRQ_NONE;
+	}
+
+	isr_bit = mhba->global_isr;
+	isr_status = mhba->mv_isr_status;
+	mhba->global_isr = 0;
+	mhba->mv_isr_status = 0;
+
+	if (!isr_bit) {
+		spin_unlock_irqrestore(mhba->shost->host_lock, flags);
+		return IRQ_NONE;
+	}
+	if (isr_bit & INT_MAP_DL_CPU2PCIEA) {
+		if (isr_status & DRBL_HANDSHAKE_ISR) {
+			dev_printk(KERN_WARNING, &mhba->pdev->dev,
+				"enter handler shake again!\n");
+			mvumi_handshake(mhba);
+		}
+		if (isr_status & DRBL_EVENT_NOTIFY)
+			mvumi_launch_events(mhba, APICDB1_EVENT_GETEVENT);
+	}
+
+	if (isr_bit & INT_MAP_COMAERR)
+		dev_printk(KERN_WARNING, &mhba->pdev->dev, "firmware error.\n");
+
+
+	if (isr_bit & INT_MAP_COMAOUT)
+		mvumi_receive_ob_list_entry(mhba);
+
+	if (mhba->fw_state == FW_STATE_STARTED)
+		mvumi_handle_clob(mhba);
+
+	spin_unlock_irqrestore(mhba->shost->host_lock, flags);
+
+	return IRQ_HANDLED;
+
+}
+
+static int mvumi_pre_init(struct mvumi_hba *mhba)
+{
+	mhba->handshake_page_base =
+			(void *) pci_alloc_consistent(mhba->pdev,
+				HSP_MAX_SIZE,
+				&mhba->handshake_page_phys_base);
+	if (!mhba->handshake_page_base) {
+		dev_printk(KERN_ERR, &mhba->pdev->dev,
+			"failed to allocate memory for handshake\n");
+		return -1;
+	}
+	return 0;
+}
+
+static int mvumi_set_hs_page(struct mvumi_hba *mhba)
+{
+	if (mhba->handshake_page_base)
+		pci_free_consistent(mhba->pdev,
+					HSP_MAX_SIZE,
+					mhba->handshake_page_base,
+					mhba->handshake_page_phys_base);
+	mhba->handshake_page_base = mhba->ib_list;
+	mhba->handshake_page_phys_base = mhba->ib_list_phys;
+	return 0;
+}
+
+/**
+ * mvumi_init_data -	Initialize requested date for FW
+ * @mhba:			Adapter soft state
+ */
+static int mvumi_init_data(struct mvumi_hba *mhba)
+{
+	struct mv_ob_data_pool *ob_pool;
+	struct mvumi_res_mgnt *res_mgnt;
+	unsigned int tmp_size, offset, i;
+	void *virmem, *v;
+	dma_addr_t p;
+
+	if (mhba->fw_flag & MVUMI_FW_ALLOC)
+		return 0;
+	tmp_size = 128 + mhba->ib_max_entry_size_bytes * mhba->max_io + 16
+							+ sizeof(unsigned int);
+	tmp_size += 8 + mhba->ob_max_entry_size_bytes * mhba->max_io + 4;
+	res_mgnt = mvumi_alloc_mem_resource(mhba,
+			RESOURCE_UNCACHED_MEMORY, tmp_size);
+	if (!res_mgnt) {
+		dev_printk(KERN_ERR, &mhba->pdev->dev,
+			"failed to allocate memory for inbound list\n");
+		goto fail_alloc_dma_buf;
+	}
+
+	p = res_mgnt->bus_addr;
+	v = res_mgnt->virt_addr;
+	offset = (unsigned int)(round_up(res_mgnt->bus_addr, 128) -
+							res_mgnt->bus_addr);
+	p += offset;
+	v = (unsigned char *) v + offset;
+	mhba->ib_list = v;
+	mhba->ib_list_phys = p;
+
+	v = (unsigned char *) v + mhba->ib_max_entry_size_bytes * mhba->max_io;
+	p += mhba->ib_max_entry_size_bytes * mhba->max_io;
+
+	offset = (unsigned int)(round_up(p, 8) - p);
+	p += offset;
+	v = (unsigned char *) v + offset;
+	mhba->ib_shadow = v;
+	mhba->ib_shadow_phys = p;
+
+	p += sizeof(unsigned int);
+	v = (unsigned char *) v + sizeof(unsigned int);
+
+	offset = round_up(p, 8) - p;
+	p += offset;
+	v = (unsigned char *) v + offset;
+	mhba->ob_shadow = v;
+	mhba->ob_shadow_phys = p;
+	p += 8;
+	v = (unsigned char *) v + 8;
+	offset = (unsigned int) (round_up(p, 128) - p);
+	p += offset;
+	v = (unsigned char *) v + offset;
+
+	mhba->ob_list = v;
+	mhba->ob_list_phys = p;
+	tmp_size = (mhba->ob_max_entry_size_bytes +
+		sizeof(struct mv_ob_data_pool)) * mhba->max_io + 8;
+	res_mgnt = mvumi_alloc_mem_resource(mhba,
+				RESOURCE_CACHED_MEMORY, tmp_size);
+	if (!res_mgnt) {
+		dev_printk(KERN_ERR, &mhba->pdev->dev,
+			"failed to allocate memory for outbound data buffer\n");
+		goto fail_alloc_dma_buf;
+	}
+	virmem = res_mgnt->virt_addr;
+	for (i = mhba->max_io; i != 0; i--) {
+		ob_pool = (struct mv_ob_data_pool *) virmem;
+		list_add_tail(&ob_pool->queue_pointer,
+				&mhba->ob_data_pool_list);
+		virmem = (unsigned char *) virmem +
+					mhba->ob_max_entry_size_bytes +
+					sizeof(struct mv_ob_data_pool);
+	}
+
+	tmp_size = 8 + sizeof(unsigned short) * mhba->max_io +
+				sizeof(struct mvumi_cmd *) * mhba->max_io;
+	tmp_size += round_up(mhba->max_target_id, sizeof(unsigned char) * 8) /
+						(sizeof(unsigned char) * 8);
+	res_mgnt = mvumi_alloc_mem_resource(mhba,
+				RESOURCE_CACHED_MEMORY, tmp_size);
+	if (!res_mgnt) {
+		dev_printk(KERN_ERR, &mhba->pdev->dev,
+			"failed to allocate memory for misc buffer\n");
+		goto fail_alloc_dma_buf;
+	}
+	virmem = res_mgnt->virt_addr;
+	mhba->tag_num = virmem;
+	mhba->tag_pool.stack = (unsigned short *) mhba->tag_num;
+
+	mhba->tag_pool.size = mhba->max_io;
+	tag_init(&mhba->tag_pool, mhba->max_io);
+
+	virmem = (unsigned char *) virmem +
+		sizeof(unsigned short) * mhba->max_io;
+
+	mhba->tag_cmd = virmem;
+
+	virmem = (unsigned char *) virmem +
+		sizeof(struct mvumi_cmd **) * mhba->max_io;
+	mhba->target_map = virmem;
+
+	mhba->fw_flag |= MVUMI_FW_ALLOC;
+	return 0;
+
+fail_alloc_dma_buf:
+	mvumi_release_mem_resource(mhba);
+	return -1;
+
+}
+static void dwordcpy(void *to, const void *from, size_t n)
+{
+	unsigned int *p_dst = (unsigned int *) to;
+	unsigned int *p_src = (unsigned int *) from;
+
+	WARN_ON(n & 0x3);
+	n >>= 2;
+	while (n--)
+		*p_dst++ = *p_src++;
+}
+static enum MV_QUEUE_COMMAND_RESULT mvumi_send_command(struct mvumi_hba *mhba,
+						struct mvumi_cmd *cmd)
+{
+	void *ib_entry;
+	struct mvumi_msg_frame *ib_frame, *tmp;
+
+	ib_frame = cmd->frame;
+	if (unlikely(mhba->fw_state != FW_STATE_STARTED)) {
+		dev_printk(KERN_INFO, &mhba->pdev->dev,
+			"firmware not ready.\n");
+		return MV_QUEUE_COMMAND_RESULT_NO_RESOURCE;
+	}
+	if (tag_is_empty(&mhba->tag_pool)) {
+		dev_printk(KERN_INFO, &mhba->pdev->dev, "no free tag.\n");
+		return MV_QUEUE_COMMAND_RESULT_NO_RESOURCE;
+	}
+	if (mvumi_get_ib_list_entry(mhba, &ib_entry))
+		return MV_QUEUE_COMMAND_RESULT_NO_RESOURCE;
+
+	cmd->frame->tag = tag_get_one(mhba, &mhba->tag_pool);
+	cmd->frame->request_id = mhba->io_seq;
+	cmd->request_id = cmd->frame->request_id;
+
+	mhba->tag_cmd[cmd->frame->tag] = cmd;
+	mhba->io_seq++;
+	dwordcpy(ib_entry, ib_frame, mhba->ib_max_entry_size_bytes);
+	tmp = (struct mvumi_msg_frame *) ib_entry;
+	tmp->tag = ib_frame->tag;
+	return MV_QUEUE_COMMAND_RESULT_SENT;
+
+}
+
+static void mvumi_fire_cmd(struct mvumi_hba *mhba, struct mvumi_cmd *cmd)
+{
+	unsigned short num_of_cl_sent = 0;
+	enum MV_QUEUE_COMMAND_RESULT result;
+
+	if (cmd)
+		list_add_tail(&cmd->queue_pointer, &mhba->waiting_req_list);
+
+	while (!list_empty(&mhba->waiting_req_list)) {
+		cmd = list_get_first_entry(&mhba->waiting_req_list,
+					 struct mvumi_cmd, queue_pointer);
+		result = mvumi_send_command(mhba, cmd);
+		switch (result) {
+		case MV_QUEUE_COMMAND_RESULT_SENT:
+			num_of_cl_sent++;
+			break;
+		case MV_QUEUE_COMMAND_RESULT_NO_RESOURCE:
+			list_add(&cmd->queue_pointer, &mhba->waiting_req_list);
+			if (num_of_cl_sent > 0)
+				mvumi_send_ib_list_entry(mhba);
+
+			return;
+		}
+	}
+	if (num_of_cl_sent > 0)
+		mvumi_send_ib_list_entry(mhba);
+
+}
+
+/**
+ * mvumi_enable_intr -	Enables interrupts
+ * @regs:			FW register set
+ */
+static void mvumi_enable_intr(void *regs)
+{
+	unsigned int mask;
+
+	mvumi_mw32(CPU_ARM_TO_PCIEA_MASK_REG, 0x3FFFFFFF);
+	mask = mvumi_mr32(CPU_ENPOINTA_MASK_REG);
+	mask |= INT_MAP_DL_CPU2PCIEA | INT_MAP_COMAOUT | INT_MAP_COMAERR;
+	mvumi_mw32(CPU_ENPOINTA_MASK_REG, mask);
+}
+
+/**
+ * mvumi_disable_intr -Disables interrupt
+ * @regs:			FW register set
+ */
+static void mvumi_disable_intr(void *regs)
+{
+	unsigned int mask;
+
+	mvumi_mw32(CPU_ARM_TO_PCIEA_MASK_REG, 0);
+	mask = mvumi_mr32(CPU_ENPOINTA_MASK_REG);
+	mask &= ~(INT_MAP_DL_CPU2PCIEA | INT_MAP_COMAOUT | INT_MAP_COMAERR);
+	mvumi_mw32(CPU_ENPOINTA_MASK_REG, mask);
+}
+
+static int mvumi_clear_intr(void *extend)
+{
+	struct mvumi_hba *mhba = (struct mvumi_hba *) extend;
+	unsigned int status, isr_status = 0, tmp = 0;
+	void *regs = mhba->mmio;
+
+	status = mvumi_mr32(CPU_MAIN_INT_CAUSE_REG);
+	if (!(status & INT_MAP_MU) || status == 0xFFFFFFFF)
+		return 1;
+	if (status & INT_MAP_COMAERR) {
+		tmp = mvumi_mr32(CLA_ISR_CAUSE);
+		if (tmp & (CLIC_IN_ERR_IRQ | CLIC_OUT_ERR_IRQ))
+			mvumi_mw32(CLA_ISR_CAUSE,
+				(tmp & (CLIC_IN_ERR_IRQ | CLIC_OUT_ERR_IRQ)));
+	}
+	if (status & INT_MAP_COMAOUT) {
+		tmp = mvumi_mr32(CLA_ISR_CAUSE);
+		if (tmp & CLIC_OUT_IRQ)
+			mvumi_mw32(CLA_ISR_CAUSE, (tmp & CLIC_OUT_IRQ));
+	}
+	if (status & INT_MAP_DL_CPU2PCIEA) {
+		isr_status = mvumi_mr32(CPU_ARM_TO_PCIEA_DRBL_REG);
+		if (isr_status)
+			mvumi_mw32(CPU_ARM_TO_PCIEA_DRBL_REG, isr_status);
+	}
+
+	mhba->global_isr = status;
+	mhba->mv_isr_status = isr_status;
+
+	return 0;
+}
+
+/**
+ * mvumi_read_fw_status_reg - returns the current FW status value
+ * @regs:			FW register set
+ */
+static unsigned int mvumi_read_fw_status_reg(void *regs)
+{
+	unsigned int status;
+
+	status = mvumi_mr32(CPU_ARM_TO_PCIEA_DRBL_REG);
+	if (status)
+		mvumi_mw32(CPU_ARM_TO_PCIEA_DRBL_REG, status);
+
+	return status;
+}
+
+static struct mvumi_instance_template mvumi_instance_template = {
+	.fire_cmd = mvumi_fire_cmd,
+	.enable_intr = mvumi_enable_intr,
+	.disable_intr = mvumi_disable_intr,
+	.clear_intr = mvumi_clear_intr,
+	.read_fw_status_reg = mvumi_read_fw_status_reg,
+};
+static int mvumi_slave_configure(struct scsi_device *sdev)
+{
+	struct mvumi_hba *mhba;
+	unsigned char bitcount = sizeof(unsigned char) * 8;
+
+	if (!sdev)
+		return -1;
+	mhba = (struct mvumi_hba *) sdev->host->hostdata;
+	if (sdev->id >= mhba->max_target_id)
+		return -1;
+
+	mhba->target_map[sdev->id / bitcount] |= (1 << (sdev->id % bitcount));
+	return 0;
+}
+
+/**
+ * mvumi_build_frame -	Prepares a direct cdb (DCDB) command
+ * @mhba:		Adapter soft state
+ * @scmd:		SCSI command
+ * @cmd:		Command to be prepared in
+ *
+ * This function prepares CDB commands. These are typcially pass-through
+ * commands to the devices.
+ */
+static unsigned char mvumi_build_frame(struct mvumi_hba *mhba,
+				struct scsi_cmnd *scmd, struct mvumi_cmd *cmd)
+{
+	struct mvumi_msg_frame *pframe;
+	unsigned int max_sg_len = mhba->ib_max_entry_size_bytes -
+				sizeof(struct mvumi_msg_frame) + 4;
+	cmd->scmd = scmd;
+	cmd->mhba = mhba;
+	cmd->cmd_status = REQ_STATUS_PENDING;
+	pframe = cmd->frame;
+	pframe->device_id = ((unsigned short) scmd->device->id) |
+				(((unsigned short) scmd->device->lun) << 8);
+	pframe->cmd_flag = 0;
+	switch (scmd->sc_data_direction) {
+	case DMA_NONE:
+		pframe->cmd_flag |= CMD_FLAG_NON_DATA;
+		break;
+	case DMA_FROM_DEVICE:
+		pframe->cmd_flag |= CMD_FLAG_DATA_IN;
+		break;
+	case DMA_TO_DEVICE:
+		pframe->cmd_flag |= CMD_FLAG_DATA_OUT;
+		break;
+	case DMA_BIDIRECTIONAL:
+		dev_printk(KERN_WARNING, &mhba->pdev->dev,
+			"unexpected DMA_BIDIRECTIONAL.\n");
+		break;
+	default:
+		break;
+	}
+	pframe->cdb_length = scmd->cmd_len;
+	memcpy(pframe->cdb, scmd->cmnd, pframe->cdb_length);
+
+	pframe->req_function = CL_FUN_SCSI_CMD;
+	pframe->sg_counts = (unsigned char)
+				mvumi_make_sgl(mhba, scmd, &pframe->payload[0]);
+	pframe->data_transfer_length = scsi_bufflen(scmd);
+	if ((unsigned int) pframe->sg_counts *
+				sizeof(struct mv_sgl) > max_sg_len) {
+		dev_printk(KERN_ERR, &mhba->pdev->dev,
+			"SG counts %d is too large, max_sg_len is %d.\n",
+			pframe->sg_counts, max_sg_len);
+		return -1;
+	}
+	return 0;
+}
+
+/**
+ * mvumi_queue_command -	Queue entry point
+ * @scmd:			SCSI command to be queued
+ * @done:			Callback entry point
+ */
+static int mvumi_queue_command(struct Scsi_Host *shost,
+					struct scsi_cmnd *scmd)
+{
+	struct mvumi_cmd *cmd;
+	struct mvumi_hba *mhba;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(shost->host_lock, irq_flags);
+	scsi_cmd_get_serial(shost, scmd);
+
+	mhba = (struct mvumi_hba *) shost->hostdata;
+	scmd->result = 0;
+
+	cmd = mvumi_get_cmd(mhba);
+	if (unlikely(!cmd)) {
+		spin_unlock_irqrestore(shost->host_lock, irq_flags);
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
+	if (unlikely(mvumi_build_frame(mhba, scmd, cmd)))
+		goto out_return_cmd;
+
+	cmd->scmd = scmd;
+	scmd->SCp.ptr = (char *) cmd;
+
+	mhba->instancet->fire_cmd(mhba, cmd);
+	spin_unlock_irqrestore(shost->host_lock, irq_flags);
+
+	return 0;
+
+out_return_cmd:
+	mvumi_return_cmd(mhba, cmd);
+	scmd->scsi_done(scmd);
+	spin_unlock_irqrestore(shost->host_lock, irq_flags);
+	return 0;
+}
+
+static int mvumi_reset_device(struct scsi_cmnd *scmd)
+{
+	int ret;
+
+	ret = mvumi_generic_reset(scmd);
+	return ret;
+}
+
+static int mvumi_reset_bus_host(struct scsi_cmnd *scmd)
+{
+	int ret;
+
+	ret = mvumi_generic_reset(scmd);
+
+	return ret;
+}
+
+static enum blk_eh_timer_return mvumi_timed_out(struct scsi_cmnd *scmd)
+{
+	struct mvumi_cmd *cmd = (struct mvumi_cmd *) scmd->SCp.ptr;
+	struct mvumi_hba *mhba = cmd->mhba;
+	unsigned long flags;
+
+	spin_lock_irqsave(mhba->shost->host_lock, flags);
+
+	if (cmd->cmd_status == REQ_STATUS_PENDING) {
+
+		if (mhba->tag_cmd[cmd->frame->tag]) {
+			mhba->tag_cmd[cmd->frame->tag] = 0;
+			tag_release_one(mhba, &mhba->tag_pool, cmd->frame->tag);
+		}
+		if (!list_empty(&cmd->queue_pointer))
+			list_del_init(&cmd->queue_pointer);
+		else
+			atomic_dec(&mhba->fw_outstanding);
+
+		scmd->result = (DRIVER_INVALID << 24) | (DID_ABORT << 16);
+		scmd->SCp.ptr = NULL;
+		if (scsi_bufflen(scmd)) {
+			if (scsi_sg_count(scmd)) {
+				pci_unmap_sg(mhba->pdev,
+					scsi_sglist(scmd),
+					scsi_sg_count(scmd),
+					(int)scmd->sc_data_direction);
+			} else {
+				pci_unmap_single(mhba->pdev,
+					scmd->SCp.dma_handle,
+					scsi_bufflen(scmd),
+					(int)scmd->sc_data_direction);
+
+				scmd->SCp.dma_handle = 0;
+			}
+		}
+		mvumi_return_cmd(mhba, cmd);
+	}
+	spin_unlock_irqrestore(mhba->shost->host_lock, flags);
+
+	return BLK_EH_NOT_HANDLED;
+
+}
+
+static int
+mvumi_bios_param(struct scsi_device *sdev, struct block_device *bdev,
+			sector_t capacity, int geom[])
+{
+	int heads, sectors;
+	sector_t cylinders;
+	unsigned long tmp;
+
+	heads = 64;
+	sectors = 32;
+	tmp = heads * sectors;
+	cylinders = capacity;
+	sector_div(cylinders, tmp);
+
+	if (capacity >= 0x200000) {
+		heads = 255;
+		sectors = 63;
+		tmp = heads * sectors;
+		cylinders = capacity;
+		sector_div(cylinders, tmp);
+	}
+	geom[0] = heads;
+	geom[1] = sectors;
+	geom[2] = cylinders;
+
+	return 0;
+}
+
+static struct scsi_host_template mvumi_template = {
+
+	.module = THIS_MODULE,
+	.name = "Marvell Storage Controller",
+	.slave_configure = mvumi_slave_configure,
+	.queuecommand = mvumi_queue_command,
+	.eh_device_reset_handler = mvumi_reset_device,
+	.eh_bus_reset_handler = mvumi_reset_bus_host,
+	.eh_host_reset_handler = mvumi_reset_bus_host,
+	.bios_param = mvumi_bios_param,
+	.this_id = -1,
+};
+static struct scsi_transport_template mvumi_transport_template = {
+	.eh_timed_out = mvumi_timed_out,
+};
+/**
+ * mvumi_init_fw -	Initializes the FW
+ * @mhba:		Adapter soft state
+ *
+ * This is the main function for initializing firmware.
+ */
+static int mvumi_init_fw(struct mvumi_hba *mhba)
+{
+	if (pci_request_regions(mhba->pdev, MV_DRIVER_NAME)) {
+		dev_printk(KERN_ERR, &mhba->pdev->dev,
+			"IO memory region busy!\n");
+		return -EBUSY;
+	}
+	if (mvumi_map_pci_addr(mhba->pdev, mhba->base_addr))
+		goto fail_ioremap;
+
+	mhba->mmio = mhba->base_addr[0];
+
+	switch (mhba->pdev->device) {
+	case PCI_DEVICE_ID_MARVELL_MV9143:
+		mhba->instancet = &mvumi_instance_template;
+		mhba->io_seq = 0;
+
+		break;
+	default:
+		dev_printk(KERN_ERR, &mhba->pdev->dev,
+			"device 0x%x not supported!\n", mhba->pdev->device);
+		mhba->instancet = NULL;
+		goto	fail_device_id;
+	}
+	dev_printk(KERN_INFO, &mhba->pdev->dev,
+		"device id : %04X is found.\n", mhba->pdev->device);
+
+	if (mvumi_pre_init(mhba))
+		goto fail_init_data;
+	if (mvumi_start(mhba)) {
+		if (mhba->handshake_page_base)
+			pci_free_consistent(mhba->pdev, HSP_MAX_SIZE,
+					mhba->handshake_page_base,
+					mhba->handshake_page_phys_base);
+		goto fail_ready_state;
+	}
+
+	mvumi_set_hs_page(mhba);
+	if (mvumi_alloc_cmds(mhba))
+		goto fail_alloc_cmds;
+
+	return 0;
+
+
+fail_alloc_cmds:
+fail_ready_state:
+	mvumi_release_mem_resource(mhba);
+fail_init_data:
+fail_device_id:
+	mvumi_unmap_pci_addr(mhba->pdev, mhba->base_addr);
+fail_ioremap:
+	pci_release_regions(mhba->pdev);
+
+	return -EINVAL;
+}
+
+/**
+ * mvumi_io_attach -	Attaches this driver to SCSI mid-layer
+ * @mhba:		Adapter soft state
+ */
+static int mvumi_io_attach(struct mvumi_hba *mhba)
+{
+	struct Scsi_Host *host = mhba->shost;
+
+	host->irq = mhba->pdev->irq;
+	host->unique_id = mhba->unique_id;
+	host->can_queue = (mhba->max_io - 1) ? (mhba->max_io - 1) : 1;
+	host->sg_tablesize = mhba->max_num_sge;
+	host->max_sectors = mhba->max_transfer_size / 512;
+	host->cmd_per_lun =  (mhba->max_io - 1) ? (mhba->max_io - 1) : 1;
+	host->max_id = mhba->max_target_id;
+	host->max_cmd_len = MAX_COMMAND_SIZE;
+	host->transportt = &mvumi_transport_template;
+	if (scsi_add_host(host, &mhba->pdev->dev)) {
+		dev_printk(KERN_ERR, &mhba->pdev->dev,
+					"scsi_add_host failed\n");
+		return -ENODEV;
+	}
+	mhba->fw_flag |= MVUMI_FW_ATTACH;
+	scsi_scan_host(host);
+
+	return 0;
+}
+/**
+ * mvumi_probe_one -	PCI hotplug entry point
+ * @pdev:		PCI device structure
+ * @id:			PCI ids of supported hotplugged adapter
+ */
+static int __devinit mvumi_probe_one(struct pci_dev *pdev,
+					const struct pci_device_id *id)
+{
+	int ret;
+	struct Scsi_Host *host;
+	struct mvumi_hba *mhba;
+	unsigned short class_code = 0xFFFF;
+
+	pci_read_config_word(pdev, 0x0A,  &class_code);
+	dev_printk(KERN_INFO, &pdev->dev,
+			" %#4.04x:%#4.04x:%#4.04x:%#4.04x: ",
+			pdev->vendor, pdev->device, pdev->subsystem_vendor,
+			pdev->subsystem_device);
+	dev_printk(KERN_INFO, &pdev->dev,
+			"bus %d:slot %d:func %d:class_code:%#4.04x\n",
+			pdev->bus->number, PCI_SLOT(pdev->devfn),
+			PCI_FUNC(pdev->devfn), class_code);
+
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	pci_set_master(pdev);
+
+	if (IS_DMA64) {
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0) {
+			if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)
+				goto fail_set_dma_mask;
+		}
+	} else {
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)
+			goto fail_set_dma_mask;
+	}
+
+	host = scsi_host_alloc(&mvumi_template, sizeof(struct mvumi_hba));
+	if (!host) {
+		dev_printk(KERN_ERR, &pdev->dev, "scsi_host_alloc failed\n");
+		goto fail_alloc_instance;
+	}
+	mhba = (struct mvumi_hba *) host->hostdata;
+	memset(mhba, 0, sizeof(*mhba));
+
+	INIT_LIST_HEAD(&mhba->cmd_pool);
+	INIT_LIST_HEAD(&mhba->ob_data_pool_list);
+	INIT_LIST_HEAD(&mhba->free_ob_list);
+	INIT_LIST_HEAD(&mhba->res_list);
+	INIT_LIST_HEAD(&mhba->waiting_req_list);
+	atomic_set(&mhba->fw_outstanding, 0);
+
+	init_waitqueue_head(&mhba->int_cmd_wait_q);
+
+	spin_lock_init(&mhba->cmd_pool_lock);
+	spin_lock_init(&mhba->tag_lock);
+
+	mhba->pdev = pdev;
+	mhba->shost = host;
+	mhba->unique_id = pdev->bus->number << 8 | pdev->devfn;
+
+	if (mvumi_init_fw(mhba))
+		goto fail_init_fw;
+	ret = request_irq(mhba->pdev->irq, mvumi_isr_handler, IRQF_SHARED,
+				"mvumi", mhba);
+	if (ret) {
+		dev_printk(KERN_ERR, &pdev->dev, "failed to register IRQ\n");
+		goto fail_init_irq;
+	}
+
+	mhba->instancet->enable_intr(mhba->mmio);
+	pci_set_drvdata(pdev, mhba);
+
+	if (mvumi_io_attach(mhba))
+		goto fail_io_attach;
+	dev_printk(KERN_INFO, &pdev->dev, "probe mvumi driver successfully.\n");
+	return 0;
+
+fail_io_attach:
+	pci_set_drvdata(pdev, NULL);
+	mhba->instancet->disable_intr(mhba->mmio);
+	free_irq(mhba->pdev->irq, mhba);
+fail_init_irq:
+	mvumi_release_fw(mhba);
+fail_init_fw:
+	scsi_host_put(host);
+
+fail_alloc_instance:
+fail_set_dma_mask:
+	pci_disable_device(pdev);
+
+	return -ENODEV;
+}
+
+static void mvumi_detach_one(struct pci_dev *pdev)
+{
+	struct Scsi_Host *host;
+	struct mvumi_hba *mhba;
+
+	mhba = pci_get_drvdata(pdev);
+	host = mhba->shost;
+	scsi_remove_host(mhba->shost);
+	mvumi_flush_cache(mhba);
+
+	mhba->instancet->disable_intr(mhba->mmio);
+	free_irq(mhba->pdev->irq, mhba);
+	mvumi_release_fw(mhba);
+	scsi_host_put(host);
+	pci_set_drvdata(pdev, NULL);
+	pci_disable_device(pdev);
+	dev_printk(KERN_INFO, &pdev->dev, "driver is removed!\n");
+}
+
+/**
+ * mvumi_shutdown -	Shutdown entry point
+ * @device:		Generic device structure
+ */
+static void mvumi_shutdown(struct pci_dev *pdev)
+{
+	struct mvumi_hba *mhba = pci_get_drvdata(pdev);
+
+	mvumi_flush_cache(mhba);
+}
+
+static int mvumi_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+
+	struct mvumi_hba *mhba = NULL;
+	dev_printk(KERN_ERR, &pdev->dev, "%s\n", __func__);
+
+	mhba = pci_get_drvdata(pdev);
+	mvumi_flush_cache(mhba);
+
+	pci_set_drvdata(pdev, mhba);
+	mhba->instancet->disable_intr(mhba->mmio);
+	free_irq(mhba->pdev->irq, mhba);
+	mvumi_unmap_pci_addr(pdev, mhba->base_addr);
+	pci_release_regions(pdev);
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
+
+	return 0;
+}
+static int mvumi_resume(struct pci_dev *pdev)
+{
+
+	int ret;
+	struct mvumi_hba *mhba = NULL;
+
+	dev_printk(KERN_ERR, &pdev->dev, "%s\n", __func__);
+	mhba = pci_get_drvdata(pdev);
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_enable_wake(pdev, PCI_D0, 0);
+	pci_restore_state(pdev);
+
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_printk(KERN_ERR, &pdev->dev, "enable device failed\n");
+		return ret;
+	}
+	pci_set_master(pdev);
+	if (IS_DMA64) {
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0) {
+
+			if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)
+				goto fail;
+		}
+	} else {
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)
+			goto fail;
+	}
+	if (pci_request_regions(mhba->pdev, MV_DRIVER_NAME))
+		goto fail;
+
+	if (mvumi_map_pci_addr(mhba->pdev, mhba->base_addr))
+		goto release_regions;
+
+	mhba->mmio = mhba->base_addr[0];
+	mvumi_reset(mhba->mmio);
+
+	if (mvumi_pre_init(mhba))
+		goto unmap_pci_addr;
+
+	if (mvumi_start(mhba)) {
+		mvumi_set_hs_page(mhba);
+		goto unmap_pci_addr;
+	}
+	mvumi_set_hs_page(mhba);
+	ret = request_irq(mhba->pdev->irq, mvumi_isr_handler, IRQF_SHARED,
+				"mvumi", mhba);
+	if (ret) {
+		dev_printk(KERN_ERR, &pdev->dev, "failed to register IRQ\n");
+		goto unmap_pci_addr;
+	}
+	mhba->instancet->enable_intr(mhba->mmio);
+	return 0;
+
+unmap_pci_addr:
+	mvumi_unmap_pci_addr(pdev, mhba->base_addr);
+release_regions:
+	pci_release_regions(pdev);
+fail:
+	pci_disable_device(pdev);
+
+	return -ENODEV;
+}
+
+static struct pci_driver mvumi_pci_driver = {
+
+	.name = MV_DRIVER_NAME,
+	.id_table = mvumi_pci_table,
+	.probe = mvumi_probe_one,
+	.remove = __devexit_p(mvumi_detach_one),
+	.shutdown = mvumi_shutdown,
+#ifdef CONFIG_PM
+	.suspend = mvumi_suspend,
+	.resume = mvumi_resume,
+#endif
+};
+
+/**
+ * mvumi_init - Driver load entry point
+ */
+static int __init mvumi_init(void)
+{
+	return pci_register_driver(&mvumi_pci_driver);
+}
+
+/**
+ * mvumi_exit - Driver unload entry point
+ */
+static void __exit mvumi_exit(void)
+{
+
+	pci_unregister_driver(&mvumi_pci_driver);
+}
+
+module_init(mvumi_init);
+module_exit(mvumi_exit);
diff --git a/drivers/scsi/mvumi.h b/drivers/scsi/mvumi.h
new file mode 100644
index 0000000..fbcc198
--- /dev/null
+++ b/drivers/scsi/mvumi.h
@@ -0,0 +1,610 @@
+/*
+  * Marvell UMI head file
+  *
+  * Copyright 2011 Marvell. <jyli@marvell.com>
+  *
+  * This file is licensed under GPLv2.
+  *
+  * This program is free software; you can redistribute it and/or
+  * modify it under the terms of the GNU General Public License as
+  * published by the Free Software Foundation; version 2 of the
+  * License.
+  *
+  * This program is distributed in the hope that it will be useful,
+  * but WITHOUT ANY WARRANTY; without even the implied warranty of
+  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  * General Public License for more details.
+  *
+  * You should have received a copy of the GNU General Public License
+  * along with this program; if not, write to the Free Software
+  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+  * USA
+ */
+
+#ifndef MVUMI_H
+#define MVUMI_H
+
+/* driver capabilities */
+#define FW_MAX_DELAY		30
+
+#define MAX_BASE_ADDRESS		6
+
+#define VER_MAJOR		1
+#define VER_MINOR		1
+#define VER_OEM			0
+#define VER_BUILD		1500
+
+#define MV_DRIVER_NAME				"mvumi"
+#define PCI_VENDOR_ID_MARVELL_2		0x1b4b
+#define PCI_DEVICE_ID_MARVELL_MV9143	0x9143
+
+
+#define MVUMI_FW_BUSY				(1U << 0)
+#define MVUMI_FW_ATTACH				(1U << 1)
+#define MVUMI_FW_ALLOC				(1U << 2)
+
+#define MVUMI_INTERNAL_CMD_WAIT_TIME		45
+
+#define IS_DMA64			(sizeof(dma_addr_t) == 8)
+
+
+enum MV_QUEUE_COMMAND_RESULT {
+	MV_QUEUE_COMMAND_RESULT_SENT	= 0,
+	MV_QUEUE_COMMAND_RESULT_NO_RESOURCE,
+};
+
+#define mvumi_mr32(offset)	readl(regs + offset)
+#define mvumi_mw32(offset, val)	writel((val), regs + offset)
+
+enum {
+/*******************************************/
+
+/* ARM Mbus Registers Map	*/
+
+/*******************************************/
+CPU_MAIN_INT_CAUSE_REG	= 0x20200,
+CPU_MAIN_IRQ_MASK_REG	= 0x20204,
+CPU_MAIN_FIQ_MASK_REG	= 0x20208,
+CPU_ENPOINTA_MASK_REG	= 0x2020C,
+CPU_ENPOINTB_MASK_REG	= 0x20210,
+
+INT_MAP_COMBOUT			= 1 << 11,
+INT_MAP_COMBIN			= 1 << 10,
+INT_MAP_COMBERR			= 1 << 9,
+INT_MAP_COMAOUT			= 1 << 8,
+INT_MAP_COMAIN			= 1 << 7,
+INT_MAP_COMAERR			= 1 << 6,
+
+INT_MAP_COMAINT			= (INT_MAP_COMAOUT | INT_MAP_COMAERR),
+INT_MAP_COMBINT			= (INT_MAP_COMBOUT | INT_MAP_COMBIN |	\
+							INT_MAP_COMBERR),
+
+INT_MAP_DL_CPU2PCIEA	= 1 << 1,
+INT_MAP_DL_PCIEA2CPU	= 1 << 0,
+
+/*******************************************/
+
+/* ARM Doorbell Registers Map			   */
+
+/*******************************************/
+CPU_PCIEA_TO_ARM_DRBL_REG	= 0x20400,
+CPU_PCIEA_TO_ARM_MASK_REG	= 0x20404,
+CPU_ARM_TO_PCIEA_DRBL_REG	= 0x20408,
+CPU_ARM_TO_PCIEA_MASK_REG	= 0x2040C,
+CPU_PCIEB_TO_ARM_DRBL_REG	= 0x20410,
+CPU_PCIEB_TO_ARM_MASK_REG	= 0x20414,
+CPU_ARM_TO_PCIEB_DRBL_REG	= 0x20418,
+CPU_ARM_TO_PCIEB_MASK_REG	= 0x2041C,
+
+DRBL_HANDSHAKE			= 1 << 0,
+DRBL_SOFT_RESET			= 1 << 1,
+DRBL_BUS_CHANGE			= 1 << 2,
+DRBL_EVENT_NOTIFY		= 1 << 3,
+DRBL_MU_RESET			= 1 << 4,
+DRBL_HANDSHAKE_ISR		= DRBL_HANDSHAKE,
+
+CPU_PCIEA_TO_ARM_MSG0		= 0x20430,
+CPU_PCIEA_TO_ARM_MSG1		= 0x20434,
+CPU_ARM_TO_PCIEA_MSG0		= 0x20438,
+CPU_ARM_TO_PCIEA_MSG1		= 0x2043C,
+
+/*******************************************/
+
+/* ARM Communication List Registers Map    */
+
+/*******************************************/
+CLA_INB_LIST_BASEL		= 0x500,
+CLA_INB_LIST_BASEH		= 0x504,
+CLA_INB_AVAL_COUNT_BASEL	= 0x508,
+CLA_INB_AVAL_COUNT_BASEH	= 0x50C,
+CLA_INB_DESTI_LIST_BASEL	= 0x510,
+CLA_INB_DESTI_LIST_BASEH	= 0x514,
+CLA_INB_WRITE_POINTER		= 0x518,
+CLA_INB_READ_POINTER		= 0x51C,
+CLA_INB_AVAL_COUNT		= 0x520,
+
+CLA_OUTB_LIST_BASEL		= 0x530,
+CLA_OUTB_LIST_BASEH		= 0x534,
+CLA_OUTB_SOURCE_LIST_BASEL	= 0x538,
+CLA_OUTB_SOURCE_LIST_BASEH	= 0x53C,
+CLA_OUTB_COPY_POINTER		= 0x544,
+CLA_OUTB_READ_POINTER		= 0x548,
+
+CLA_ISR_CAUSE			= 0x560,
+CLA_ISR_MASK			= 0x564,
+
+INT_MAP_MU			= (INT_MAP_DL_CPU2PCIEA | INT_MAP_COMAINT),
+
+CL_POINTER_TOGGLE		= 1 << 12,
+
+CLIC_IN_IRQ			= 1 << 0,
+CLIC_OUT_IRQ			= 1 << 1,
+CLIC_IN_ERR_IRQ			= 1 << 8,
+CLIC_OUT_ERR_IRQ		= 1 << 12,
+CLIC_ASSERET_IRQ		= (CLIC_IN_IRQ | CLIC_OUT_IRQ |	\
+					CLIC_IN_ERR_IRQ | CLIC_OUT_ERR_IRQ),
+
+CL_SLOT_NUM_MASK		= 0xFFF,
+
+/*
+* Command flag is the flag for the CDB command itself
+*/
+/* 1-non data; 0-data command */
+CMD_FLAG_NON_DATA			= 1 << 0,
+CMD_FLAG_DMA				= 1 << 1,
+CMD_FLAG_PIO				= 1 << 2,
+/* 1-host read data */
+CMD_FLAG_DATA_IN			= 1 << 3,
+/* 1-host write data */
+CMD_FLAG_DATA_OUT			= 1 << 4,
+
+
+SCSI_CMD_MARVELL_SPECIFIC		= 0xE1,
+CDB_CORE_SHUTDOWN			= 0xB,
+
+};
+
+#define APICDB0_EVENT			0xF4
+
+#define APICDB1_EVENT_GETEVENT		0
+#define APICDB1_EVENT_MAX		(APICDB1_EVENT_GETEVENT + 1)
+
+#define MAX_EVENTS_RETURNED			6
+
+struct mvumi_driver_event {
+	unsigned int	time_stamp;
+	unsigned int	sequence_no;
+	unsigned int	event_id;
+	unsigned char	severity;
+	unsigned char	param_count;
+	unsigned short	device_id;
+	unsigned int	params[4];
+};
+
+struct mvumi_driver_event_v2 {
+	struct	mvumi_driver_event	event_v1;
+	unsigned char		sense_data_length;
+	unsigned char		Reserved1;
+	unsigned char		sense_data[30];
+};
+
+struct mvumi_event_req {
+	unsigned char	count;
+	unsigned char	reserved[3];
+	struct mvumi_driver_event_v2  events[MAX_EVENTS_RETURNED];
+};
+
+struct mvumi_events_wq {
+	struct work_struct work_q;
+	struct mvumi_hba *mhba;
+	unsigned int event;
+	void *param;
+};
+
+#define SGD_EOT				(1L << 27)
+
+/* code for hs_capability */
+#define HS_CAPABILITY_SUPPORT_COMPACT_SG	(1 << 4)
+
+struct mv_sgl {
+	unsigned int	baseaddr_l;
+	unsigned int	baseaddr_h;
+	unsigned int	flags;
+	unsigned int	size;
+};
+
+#define sgd_getsz(sgd, sz)  do {	\
+	(sz) = (sgd)->size;		\
+} while (0)
+
+#define sgd_setsz(sgd, sz) do {			\
+	(sgd)->size = (sz);			\
+} while (0)
+
+
+#define sgd_inc(sgd) do {					\
+	sgd = (struct mv_sgl *) (((unsigned char *) (sgd)) + 16);\
+} while (0)
+
+
+struct mv_sgl_t {
+	unsigned char max_entry;
+	unsigned char valid_entry;
+	unsigned char flag;
+	unsigned char reserved0;
+	unsigned int byte_count;
+	struct mv_sgl *entry_ptr;
+};
+
+
+struct mvumi_res_mgnt {
+	struct list_head res_entry;
+	dma_addr_t bus_addr;
+	void *virt_addr;
+	unsigned int size;
+	unsigned short type;	/* enum Resource_Type */
+	unsigned short align;
+};
+
+/* Resource type */
+enum resource_type {
+	RESOURCE_CACHED_MEMORY = 0,
+	RESOURCE_UNCACHED_MEMORY
+};
+
+struct mvumi_sense_data {
+	unsigned char error_eode:7;
+	unsigned char valid:1;
+	unsigned char segment_number;
+	unsigned char sense_key:4;
+	unsigned char reserved:1;
+	unsigned char incorrect_length:1;
+	unsigned char end_of_media:1;
+	unsigned char file_mark:1;
+	unsigned char information[4];
+	unsigned char additional_sense_length;
+	unsigned char command_specific_information[4];
+	unsigned char additional_sense_code;
+	unsigned char additional_sense_code_qualifier;
+	unsigned char field_replaceable_unit_code;
+	unsigned char sense_key_specific[3];
+};
+
+/* Request initiator must set the status to REQ_STATUS_PENDING. */
+#define REQ_STATUS_PENDING					0x80
+
+
+struct mvumi_cmd {
+	struct list_head queue_pointer;
+	struct mvumi_msg_frame *frame;
+	struct mvumi_hba *mhba;
+	struct scsi_cmnd *scmd;
+	unsigned int index;
+	atomic_t sync_cmd;
+	void *data_buf;
+	unsigned short request_id;
+	unsigned char cmd_status;
+};
+
+/*
+ * the function type of the in bound frame
+ */
+#define CL_FUN_SCSI_CMD			0x1
+
+struct mvumi_msg_frame {
+	unsigned short device_id;
+	unsigned short tag;
+
+	unsigned char cmd_flag;
+	unsigned char req_function;
+	unsigned char cdb_length;
+	unsigned char sg_counts;
+
+	unsigned int data_transfer_length;
+	unsigned short request_id;
+	unsigned short reserved1;
+
+	unsigned char cdb[MAX_COMMAND_SIZE];
+	unsigned int payload[1];
+
+};
+
+/*
+ * the respond flag for data_payload of the out bound frame
+ */
+#define CL_RSP_FLAG_NODATA		0x0
+#define CL_RSP_FLAG_SENSEDATA		0x1
+
+struct mvumi_rsp_frame {
+	unsigned short device_id;
+	unsigned short tag;
+
+	unsigned char req_status;
+	unsigned char rsp_flag;	/* Indicates the type of Data_Payload.*/
+	unsigned short request_id;
+	unsigned int payload[1];
+
+};
+
+/*
+ * State is the state of the MU
+ */
+#define FW_STATE_IDLE			0
+#define FW_STATE_STARTING		1
+#define FW_STATE_HANDSHAKING		2
+#define FW_STATE_STARTED		3
+#define FW_STATE_ABORT			4
+
+struct mv_ob_data_pool {
+	struct list_head queue_pointer;
+	unsigned char ob_data[0];
+};
+
+struct version_info {
+	unsigned int ver_major;
+	unsigned int ver_minor;
+	unsigned int ver_oem;
+	unsigned int ver_build;
+};
+
+
+struct mv_handshake_frame {
+	unsigned short size;
+
+	/* host information */
+	unsigned char host_type;
+	unsigned char reserved_1[1];
+	struct version_info host_ver; /* bios or driver version */
+
+	/* controller information */
+	unsigned int system_io_bus;
+	unsigned int slot_number;
+	unsigned int intr_level;
+	unsigned int intr_vector;
+
+	/* communication list configuration */
+	unsigned int ib_baseaddr_l;
+	unsigned int ib_baseaddr_h;
+	unsigned int ob_baseaddr_l;
+	unsigned int ob_baseaddr_h;
+
+	unsigned char ib_entry_size;
+	unsigned char ob_entry_size;
+	unsigned char ob_depth;
+	unsigned char ib_depth;
+
+	/* system date/time */
+	unsigned long long seconds_since1970;
+};
+
+struct mv_handshake_header {
+	unsigned char page_code;
+	unsigned char checksum;
+	unsigned short	frame_length;
+	unsigned int	frame_content[1];
+};
+
+/*
+ * the page code type of the handshake header
+ */
+#define HS_PAGE_FIRM_CAP	0x1
+#define HS_PAGE_HOST_INFO	0x2
+#define HS_PAGE_FIRM_CTL	0x3
+#define HS_PAGE_CL_INFO		0x4
+#define HS_PAGE_TOTAL		0x5
+
+
+#define HSP_SIZE(i)					\
+		sizeof(struct mv_handshake_page##i)
+
+#define HSP_MAX_SIZE ({					\
+	int size, m1, m2;				\
+	m1 = max(HSP_SIZE(1), HSP_SIZE(3));		\
+	m2 = max(HSP_SIZE(2), HSP_SIZE(4));		\
+	size = max(m1, m2);				\
+	size;						\
+})
+
+/* The format of the page code for Firmware capability */
+struct mv_handshake_page1 {
+	unsigned char pagecode;
+	unsigned char checksum;
+	unsigned short frame_length;
+
+	unsigned short number_of_ports;
+	unsigned short max_devices_support;
+	unsigned short max_io_support;
+	unsigned short umi_ver;
+	unsigned int max_transfer_size;
+	struct version_info fw_ver;
+	unsigned char cl_in_max_entry_size;
+	unsigned char cl_out_max_entry_size;
+	unsigned char cl_inout_list_depth;
+	unsigned char total_pages;
+	unsigned short capability;
+	unsigned short reserved1;
+};
+
+
+/* The format of the page code for Host information */
+struct mv_handshake_page2 {
+	unsigned char pagecode;
+	unsigned char checksum;
+	unsigned short frame_length;
+
+	unsigned char host_type;
+	unsigned char reserved[3];
+	struct version_info host_ver;
+	unsigned int system_io_bus;
+	unsigned int slot_number;
+	unsigned int intr_level;
+	unsigned int intr_vector;
+	unsigned long long seconds_since1970;
+};
+
+/* The format of the page code for firmware control  */
+struct mv_handshake_page3 {
+	unsigned char	pagecode;
+	unsigned char	checksum;
+	unsigned short	frame_length;
+	unsigned short	control;
+	unsigned char	reserved[2];
+	unsigned int	host_bufferaddr_l;
+	unsigned int	host_bufferaddr_h;
+	unsigned int	host_eventaddr_l;
+	unsigned int	host_eventaddr_h;
+};
+
+
+struct mv_handshake_page4 {
+	unsigned char	pagecode;
+	unsigned char	checksum;
+	unsigned short	frame_length;
+	unsigned int	ib_baseaddr_l;
+	unsigned int	ib_baseaddr_h;
+	unsigned int	ob_baseaddr_l;
+	unsigned int	ob_baseaddr_h;
+	unsigned char	ib_entry_size;
+	unsigned char	ob_entry_size;
+	unsigned char	ob_depth;
+	unsigned char	ib_depth;
+};
+
+#define HANDSHAKE_SIGNATURE		0x5A5A5A5AL
+#define HANDSHAKE_READYSTATE		0x55AA5AA5L
+#define HANDSHAKE_DONESTATE		0x55AAA55AL
+
+/* HandShake Status definition */
+#define HS_STATUS_OK		1
+#define HS_STATUS_ERR		2
+#define HS_STATUS_INVALID	3
+
+/* HandShake State/Cmd definition */
+#define HS_S_ABORT			7
+#define HS_S_END			6
+#define HS_S_SEND_PAGE			5
+#define HS_S_QUERY_PAGE			4
+#define HS_S_PAGE_ADDR			3
+#define HS_S_RESET			2
+#define HS_S_START			1
+#define HS_PAGE_VERIFY_SIZE		128
+
+#define HS_GET_STATE(a)			(a & 0xFFFF)
+#define HS_GET_STATUS(a)		((a & 0xFFFF0000) >> 16)
+#define HS_SET_STATE(a, b)		(a |= (b & 0xFFFF))
+#define HS_SET_STATUS(a, b)		(a |= ((b & 0xFFFF) << 16))
+#define HS_SET_CHECKSUM(a, b)	mvumi_calculate_checksum(a, b)
+
+static inline struct list_head *list_get_first(struct list_head *head)
+{
+	struct list_head *tmp = NULL;
+	if (list_empty(head))
+		return NULL;
+
+	tmp = head->next;
+	list_del_init(tmp);
+	return tmp;
+}
+
+static inline struct list_head *list_get_last(struct list_head *head)
+{
+	struct list_head *tmp = NULL;
+	if (list_empty(head))
+		return NULL;
+
+	tmp = head->prev;
+	list_del_init(tmp);
+	return tmp;
+}
+
+#define list_get_first_entry(head, type, member)	\
+	list_entry(list_get_first(head), type, member)
+
+#define list_get_last_entry(head, type, member)	\
+	list_entry(list_get_last(head), type, member)
+
+struct mvumi_hba;
+struct mvumi_instance_template {
+	void (*fire_cmd)(struct mvumi_hba *, struct mvumi_cmd *);
+	void (*enable_intr)(void *) ;
+	void (*disable_intr)(void *);
+	int (*clear_intr)(void *);
+	unsigned int (*read_fw_status_reg)(void *);
+};
+
+struct tag_stack {
+	unsigned short *stack;
+	unsigned short top;
+	unsigned short size;
+	unsigned short ptr_out;
+	unsigned char tag_stack_type;
+	unsigned char reserved[1];
+};
+
+struct mvumi_hba {
+	void *base_addr[MAX_BASE_ADDRESS];
+	void *mmio;
+	struct mvumi_cmd **cmd_list;
+	struct list_head cmd_pool;
+	spinlock_t cmd_pool_lock;
+	struct Scsi_Host *shost;
+	wait_queue_head_t int_cmd_wait_q;
+	struct pci_dev *pdev;
+	unsigned int unique_id;
+	atomic_t fw_outstanding;
+	struct mvumi_instance_template *instancet;
+
+	void *ib_list;
+	dma_addr_t ib_list_phys;
+
+	void *ob_list;
+	dma_addr_t ob_list_phys;
+
+	void *ib_shadow;
+	dma_addr_t ib_shadow_phys;
+
+	void *ob_shadow;
+	dma_addr_t ob_shadow_phys;
+
+	void *handshake_page_base;
+	dma_addr_t handshake_page_phys_base;
+	void *handshake_page;
+	dma_addr_t handshake_page_phys;
+
+	unsigned int global_isr;
+	unsigned int mv_isr_status;
+	unsigned int ib_cur_count;
+
+	unsigned short max_num_sge;
+	unsigned short max_target_id;
+	unsigned char *target_map;
+	unsigned int max_io;
+	unsigned int list_num_io;
+	unsigned int ib_max_entry_size_bytes;
+	unsigned int ob_max_entry_size_bytes;
+	unsigned int ib_max_entry_size_setting;
+	unsigned int ob_max_entry_size_setting;
+	unsigned int max_transfer_size;
+	unsigned char hba_total_pages;
+	unsigned char fw_flag;
+	unsigned char request_id_enabled;
+	unsigned short hba_capability;
+	unsigned short io_seq;
+
+	unsigned int ib_cur_slot;
+	unsigned int ob_cur_slot;
+	unsigned int fw_state;
+
+	struct list_head ob_data_pool_list;
+	struct list_head free_ob_list;
+	struct list_head res_list;
+	struct list_head waiting_req_list;
+
+	struct tag_stack tag_pool;
+	struct mvumi_cmd **tag_cmd;
+	spinlock_t tag_lock;
+	unsigned short *tag_num;
+};
+
+extern struct timezone sys_tz;
+#endif
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 4e2c915..2a72ed8 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1569,10 +1569,12 @@
 #define PCI_SUBDEVICE_ID_KEYSPAN_SX2	0x5334

 #define PCI_VENDOR_ID_MARVELL		0x11ab
+#define PCI_VENDOR_ID_MARVELL_2		0x1b4b
 #define PCI_DEVICE_ID_MARVELL_GT64111	0x4146
 #define PCI_DEVICE_ID_MARVELL_GT64260	0x6430
 #define PCI_DEVICE_ID_MARVELL_MV64360	0x6460
 #define PCI_DEVICE_ID_MARVELL_MV64460	0x6480
+#define PCI_DEVICE_ID_MARVELL_MV9143	0x9143
 #define PCI_DEVICE_ID_MARVELL_88ALP01_NAND	0x4100
 #define PCI_DEVICE_ID_MARVELL_88ALP01_SD	0x4101
 #define PCI_DEVICE_ID_MARVELL_88ALP01_CCIC	0x4102
--
1.7.1
