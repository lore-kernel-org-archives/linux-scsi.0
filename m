From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 4/8] be2iscsi: handles core routines
Date: Sat, 5 Sep 2009 07:37:46 +0530
Message-ID: <20090905020735.GA11865@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:51468 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S934500AbZIECHr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2009 22:07:47 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

  This file handles initiallization/teardown, allocation/free as well
  as IO/Management flows.

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c | 3393 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_main.h |  832 ++++++++++
 2 files changed, 4225 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/be2iscsi/be_main.c
 create mode 100644 drivers/scsi/be2iscsi/be_main.h

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
new file mode 100644
index 0000000..ef82e22
--- /dev/null
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -0,0 +1,3393 @@
+/**
+ * Copyright (C) 2005 - 2009 ServerEngines
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.  The full GNU General
+ * Public License is included in this distribution in the file called COPYING.
+ *
+ * Written by: Jayamohan Kallickal (jayamohank@serverengines.com)
+ *
+ * Contact Information:
+ * linux-drivers@serverengines.com
+ *
+ *  ServerEngines
+ * 209 N. Fair Oaks Ave
+ * Sunnyvale, CA 94085
+ *
+ */
+#include <linux/reboot.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/blkdev.h>
+#include <linux/pci.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/semaphore.h>
+
+#include <scsi/libiscsi.h>
+#include <scsi/scsi_transport_iscsi.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi.h>
+#include "be_main.h"
+#include "be_iscsi.h"
+#include "be_mgmt.h"
+
+static unsigned int be_iopoll_budget = 10;
+static unsigned int be_max_phys_size = 64;
+static unsigned int enable_msix;
+
+MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
+MODULE_DESCRIPTION(DRV_DESC " " BUILD_STR);
+MODULE_AUTHOR("ServerEngines Corporation");
+MODULE_LICENSE("GPL");
+module_param(be_iopoll_budget, int, 0);
+module_param(enable_msix, int, 0);
+module_param(be_max_phys_size, uint, S_IRUGO);
+MODULE_PARM_DESC(be_max_phys_size, "Maximum Size (In Kilobytes) of physically"
+				   "contiguous memory that can be allocated."
+				   "Range is 16 - 128");
+
+static int beiscsi_slave_configure(struct scsi_device *sdev)
+{
+	blk_queue_max_segment_size(sdev->request_queue, 65536);
+	return 0;
+}
+
+static struct scsi_host_template beiscsi_sht = {
+	.module = THIS_MODULE,
+	.name = "ServerEngines 10Gbe open-iscsi Initiator Driver",
+	.proc_name = DRV_NAME,
+	.queuecommand = iscsi_queuecommand,
+	.eh_abort_handler = iscsi_eh_abort,
+	.change_queue_depth = iscsi_change_queue_depth,
+	.slave_configure = beiscsi_slave_configure,
+	.target_alloc = iscsi_target_alloc,
+	.eh_device_reset_handler = iscsi_eh_device_reset,
+	.eh_target_reset_handler = iscsi_eh_target_reset,
+	.sg_tablesize = BEISCSI_SGLIST_ELEMENTS,
+	.can_queue = BE2_IO_DEPTH,
+	.this_id = -1,
+	.max_sectors = BEISCSI_MAX_SECTORS,
+	.cmd_per_lun = BEISCSI_CMD_PER_LUN,
+	.use_clustering = ENABLE_CLUSTERING,
+};
+static struct scsi_transport_template *beiscsi_scsi_transport;
+
+/*------------------- PCI Driver operations and data ----------------- */
+static DEFINE_PCI_DEVICE_TABLE(beiscsi_pci_id_table) = {
+	{ PCI_DEVICE(BE_VENDOR_ID, BE_DEVICE_ID1) },
+	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID1) },
+	{ PCI_DEVICE(BE_VENDOR_ID, OC_DEVICE_ID2) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
+
+static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
+{
+	struct beiscsi_hba *phba;
+	struct Scsi_Host *shost;
+
+	shost = iscsi_host_alloc(&beiscsi_sht, sizeof(*phba), 0);
+	if (!shost) {
+		dev_err(&pcidev->dev, "beiscsi_hba_alloc -"
+			"iscsi_host_alloc failed \n");
+		return NULL;
+	}
+	shost->dma_boundary = pcidev->dma_mask;
+	shost->max_id = BE2_MAX_SESSIONS;
+	shost->max_channel = 0;
+	shost->max_cmd_len = BEISCSI_MAX_CMD_LEN;
+	shost->max_lun = BEISCSI_NUM_MAX_LUN;
+	shost->transportt = beiscsi_scsi_transport;
+
+	phba = iscsi_host_priv(shost);
+	memset(phba, 0, sizeof(*phba));
+	phba->shost = shost;
+	phba->pcidev = pci_dev_get(pcidev);
+
+	if (iscsi_host_add(shost, &phba->pcidev->dev))
+		goto free_devices;
+	return phba;
+
+free_devices:
+	pci_dev_put(phba->pcidev);
+	iscsi_host_free(phba->shost);
+	return NULL;
+}
+
+static void beiscsi_unmap_pci_function(struct beiscsi_hba *phba)
+{
+	if (phba->csr_va) {
+		iounmap(phba->csr_va);
+		phba->csr_va = NULL;
+	}
+	if (phba->db_va) {
+		iounmap(phba->db_va);
+		phba->db_va = NULL;
+	}
+	if (phba->pci_va) {
+		iounmap(phba->pci_va);
+		phba->pci_va = NULL;
+	}
+}
+
+static int beiscsi_map_pci_bars(struct beiscsi_hba *phba,
+				struct pci_dev *pcidev)
+{
+	u8 __iomem *addr;
+
+	addr = ioremap_nocache(pci_resource_start(pcidev, 2),
+			       pci_resource_len(pcidev, 2));
+	if (addr == NULL)
+		return -ENOMEM;
+	phba->ctrl.csr = addr;
+	phba->csr_va = addr;
+	phba->csr_pa.u.a64.address = pci_resource_start(pcidev, 2);
+
+	addr = ioremap_nocache(pci_resource_start(pcidev, 4), 128 * 1024);
+	if (addr == NULL)
+		goto pci_map_err;
+	phba->ctrl.db = addr;
+	phba->db_va = addr;
+	phba->db_pa.u.a64.address =  pci_resource_start(pcidev, 4);
+
+	addr = ioremap_nocache(pci_resource_start(pcidev, 1),
+			       pci_resource_len(pcidev, 1));
+	if (addr == NULL)
+		goto pci_map_err;
+	phba->ctrl.pcicfg = addr;
+	phba->pci_va = addr;
+	phba->pci_pa.u.a64.address = pci_resource_start(pcidev, 1);
+	return 0;
+
+pci_map_err:
+	beiscsi_unmap_pci_function(phba);
+	return -ENOMEM;
+}
+
+static int beiscsi_enable_pci(struct pci_dev *pcidev)
+{
+	int ret;
+
+	ret = pci_enable_device(pcidev);
+	if (ret) {
+		dev_err(&pcidev->dev, "beiscsi_enable_pci - enable device "
+			"failed. Returning -ENODEV\n");
+		return ret;
+	}
+
+	if (pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(64))) {
+		ret = pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(32));
+		if (ret) {
+			dev_err(&pcidev->dev, "Could not set PCI DMA Mask\n");
+			pci_disable_device(pcidev);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static int be_ctrl_init(struct beiscsi_hba *phba, struct pci_dev *pdev)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_dma_mem *mbox_mem_alloc = &ctrl->mbox_mem_alloced;
+	struct be_dma_mem *mbox_mem_align = &ctrl->mbox_mem;
+	int status = 0;
+
+	ctrl->pdev = pdev;
+	status = beiscsi_map_pci_bars(phba, pdev);
+	if (status)
+		return status;
+
+	mbox_mem_alloc->size = sizeof(struct be_mcc_mailbox) + 16;
+	mbox_mem_alloc->va = pci_alloc_consistent(pdev,
+						  mbox_mem_alloc->size,
+						  &mbox_mem_alloc->dma);
+	if (!mbox_mem_alloc->va) {
+		beiscsi_unmap_pci_function(phba);
+		status = -ENOMEM;
+		return status;
+	}
+
+	mbox_mem_align->size = sizeof(struct be_mcc_mailbox);
+	mbox_mem_align->va = PTR_ALIGN(mbox_mem_alloc->va, 16);
+	mbox_mem_align->dma = PTR_ALIGN(mbox_mem_alloc->dma, 16);
+	memset(mbox_mem_align->va, 0, sizeof(struct be_mcc_mailbox));
+	spin_lock_init(&ctrl->mbox_lock);
+	return status;
+}
+
+static void beiscsi_get_params(struct beiscsi_hba *phba)
+{
+	phba->params.ios_per_ctrl = BE2_IO_DEPTH;
+	phba->params.cxns_per_ctrl = BE2_MAX_SESSIONS;
+	phba->params.asyncpdus_per_ctrl = BE2_ASYNCPDUS;
+	phba->params.icds_per_ctrl = BE2_MAX_ICDS / 2;
+	phba->params.num_sge_per_io = BE2_SGE;
+	phba->params.defpdu_hdr_sz = BE2_DEFPDU_HDR_SZ;
+	phba->params.defpdu_data_sz = BE2_DEFPDU_DATA_SZ;
+	phba->params.eq_timer = 64;
+	phba->params.num_eq_entries =
+	    (((BE2_CMDS_PER_CXN * 2 + BE2_LOGOUTS + BE2_TMFS + BE2_ASYNCPDUS) /
+								512) + 1) * 512;
+	phba->params.num_eq_entries = (phba->params.num_eq_entries < 1024)
+				? 1024 : phba->params.num_eq_entries;
+	SE_DEBUG(DBG_LVL_8, "phba->params.num_eq_entries=%d \n",
+		 phba->params.num_eq_entries);
+	phba->params.num_cq_entries =
+	    (((BE2_CMDS_PER_CXN * 2 + BE2_LOGOUTS + BE2_TMFS + BE2_ASYNCPDUS) /
+								512) + 1) * 512;
+	SE_DEBUG(DBG_LVL_8,
+		"phba->params.num_cq_entries=%d BE2_CMDS_PER_CXN=%d"
+		"BE2_LOGOUTS=%d BE2_TMFS=%d BE2_ASYNCPDUS=%d \n",
+		phba->params.num_cq_entries, BE2_CMDS_PER_CXN,
+		BE2_LOGOUTS, BE2_TMFS, BE2_ASYNCPDUS);
+	phba->params.wrbs_per_cxn = 256;
+}
+
+static void hwi_ring_eq_db(struct beiscsi_hba *phba,
+			   unsigned int id, unsigned int clr_interrupt,
+			   unsigned int num_processed,
+			   unsigned char rearm, unsigned char event)
+{
+	u32 val = 0;
+	val |= id & DB_EQ_RING_ID_MASK;
+	if (rearm)
+		val |= 1 << DB_EQ_REARM_SHIFT;
+	if (clr_interrupt)
+		val |= 1 << DB_EQ_CLR_SHIFT;
+	if (event)
+		val |= 1 << DB_EQ_EVNT_SHIFT;
+	val |= num_processed << DB_EQ_NUM_POPPED_SHIFT;
+	iowrite32(val, phba->db_va + DB_EQ_OFFSET);
+}
+
+/**
+ * be_isr - The isr routine of the driver.
+ * @irq: Not used
+ * @dev_id: Pointer to host adapter structure
+ */
+static irqreturn_t be_isr(int irq, void *dev_id)
+{
+	struct beiscsi_hba *phba;
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_context_memory *phwi_context;
+	struct be_eq_entry *eqe = NULL;
+	struct be_queue_info *eq;
+	struct be_queue_info *cq;
+	unsigned long flags, index;
+	unsigned int num_eq_processed;
+	struct be_ctrl_info *ctrl;
+	int isr;
+
+	phba = dev_id;
+	if (!enable_msix) {
+		ctrl = &phba->ctrl;;
+		isr = ioread32(ctrl->csr + CEV_ISR0_OFFSET +
+			       (PCI_FUNC(ctrl->pdev->devfn) * CEV_ISR_SIZE));
+		if (!isr)
+			return IRQ_NONE;
+	}
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	phwi_context = phwi_ctrlr->phwi_ctxt;
+	eq = &phwi_context->be_eq.q;
+	cq = &phwi_context->be_cq;
+	index = 0;
+	eqe = queue_tail_node(eq);
+	if (!eqe)
+		SE_DEBUG(DBG_LVL_1, "eqe is NULL\n");
+
+	num_eq_processed = 0;
+	if (blk_iopoll_enabled) {
+		while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
+					& EQE_VALID_MASK) {
+			if (!blk_iopoll_sched_prep(&phba->iopoll))
+				blk_iopoll_sched(&phba->iopoll);
+
+			AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
+			queue_tail_inc(eq);
+			eqe = queue_tail_node(eq);
+			num_eq_processed++;
+			SE_DEBUG(DBG_LVL_8, "Valid EQE\n");
+		}
+		if (num_eq_processed) {
+			hwi_ring_eq_db(phba, eq->id, 0,	num_eq_processed, 0, 1);
+			return IRQ_HANDLED;
+		} else
+			return IRQ_NONE;
+	} else {
+		while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
+						& EQE_VALID_MASK) {
+
+			if (((eqe->dw[offsetof(struct amap_eq_entry,
+			     resource_id) / 32] &
+			     EQE_RESID_MASK) >> 16) != cq->id) {
+				spin_lock_irqsave(&phba->isr_lock, flags);
+				phba->todo_mcc_cq = 1;
+				spin_unlock_irqrestore(&phba->isr_lock, flags);
+			} else {
+				spin_lock_irqsave(&phba->isr_lock, flags);
+				phba->todo_cq = 1;
+				spin_unlock_irqrestore(&phba->isr_lock, flags);
+			}
+			AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
+			queue_tail_inc(eq);
+			eqe = queue_tail_node(eq);
+			num_eq_processed++;
+		}
+		if (phba->todo_cq || phba->todo_mcc_cq)
+			queue_work(phba->wq, &phba->work_cqs);
+
+		if (num_eq_processed) {
+			hwi_ring_eq_db(phba, eq->id, 0, num_eq_processed, 1, 1);
+			return IRQ_HANDLED;
+		} else
+			return IRQ_NONE;
+	}
+}
+
+static int beiscsi_init_irqs(struct beiscsi_hba *phba)
+{
+	struct pci_dev *pcidev = phba->pcidev;
+	int ret;
+
+	ret = request_irq(pcidev->irq, be_isr, IRQF_SHARED, "beiscsi", phba);
+	if (ret) {
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_init_irqs-"
+			     "Failed to register irq\\n");
+		return ret;
+	}
+	return 0;
+}
+
+static void hwi_ring_cq_db(struct beiscsi_hba *phba,
+			   unsigned int id, unsigned int num_processed,
+			   unsigned char rearm, unsigned char event)
+{
+	u32 val = 0;
+	val |= id & DB_CQ_RING_ID_MASK;
+	if (rearm)
+		val |= 1 << DB_CQ_REARM_SHIFT;
+	val |= num_processed << DB_CQ_NUM_POPPED_SHIFT;
+	iowrite32(val, phba->db_va + DB_CQ_OFFSET);
+}
+
+/*
+ * async pdus include
+ * a. unsolicited NOP-In (target initiated NOP-In)
+ * b. Async Messages
+ * c. Reject PDU
+ * d. Login response
+ * These headers arrive unprocessed by the EP firmware and iSCSI layer
+ * process them
+ */
+static unsigned int
+beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
+			  struct beiscsi_hba *phba,
+			  unsigned short cid,
+			  struct pdu_base *ppdu,
+			  unsigned long pdu_len,
+			  void *pbuffer, unsigned long buf_len)
+{
+	struct iscsi_conn *conn = beiscsi_conn->conn;
+	struct iscsi_session *session = conn->session;
+
+	switch (ppdu->dw[offsetof(struct amap_pdu_base, opcode) / 32] &
+						PDUBASE_OPCODE_MASK) {
+	case ISCSI_OP_NOOP_IN:
+		pbuffer = NULL;
+		buf_len = 0;
+		break;
+	case ISCSI_OP_ASYNC_EVENT:
+		break;
+	case ISCSI_OP_REJECT:
+		WARN_ON(!pbuffer);
+		WARN_ON(!(buf_len == 48));
+		SE_DEBUG(DBG_LVL_1, "In ISCSI_OP_REJECT\n");
+		break;
+	case ISCSI_OP_LOGIN_RSP:
+		break;
+	default:
+		shost_printk(KERN_WARNING, phba->shost,
+			     "Unrecognized opcode 0x%x in async msg \n",
+			     (ppdu->
+			     dw[offsetof(struct amap_pdu_base, opcode) / 32]
+						& PDUBASE_OPCODE_MASK));
+		return 1;
+	}
+
+	spin_lock_bh(&session->lock);
+	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)ppdu, pbuffer, buf_len);
+	spin_unlock_bh(&session->lock);
+	return 0;
+}
+
+static struct sgl_handle *alloc_io_sgl_handle(struct beiscsi_hba *phba)
+{
+	struct sgl_handle *psgl_handle;
+
+	if (phba->io_sgl_hndl_avbl) {
+		SE_DEBUG(DBG_LVL_8,
+			 "In alloc_io_sgl_handle,io_sgl_alloc_index=%d \n",
+			 phba->io_sgl_alloc_index);
+		psgl_handle = phba->io_sgl_hndl_base[phba->
+						io_sgl_alloc_index];
+		phba->io_sgl_hndl_base[phba->io_sgl_alloc_index] = NULL;
+		phba->io_sgl_hndl_avbl--;
+		if (phba->io_sgl_alloc_index == (phba->params.ios_per_ctrl - 1))
+			phba->io_sgl_alloc_index = 0;
+		else
+			phba->io_sgl_alloc_index++;
+	} else
+		psgl_handle = NULL;
+	return psgl_handle;
+}
+
+static void
+free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
+{
+	SE_DEBUG(DBG_LVL_8, "In free_,io_sgl_free_index=%d \n",
+		 phba->io_sgl_free_index);
+	if (phba->io_sgl_hndl_base[phba->io_sgl_free_index]) {
+		/*
+		 * this can happen if clean_task is called on a task that
+		 * failed in xmit_task or alloc_pdu.
+		 */
+		 SE_DEBUG(DBG_LVL_8,
+			 "Double Free in IO SGL io_sgl_free_index=%d,"
+			 "value there=%p \n", phba->io_sgl_free_index,
+			 phba->io_sgl_hndl_base[phba->io_sgl_free_index]);
+		return;
+	}
+	phba->io_sgl_hndl_base[phba->io_sgl_free_index] = psgl_handle;
+	phba->io_sgl_hndl_avbl++;
+	if (phba->io_sgl_free_index == (phba->params.ios_per_ctrl - 1))
+		phba->io_sgl_free_index = 0;
+	else
+		phba->io_sgl_free_index++;
+}
+
+/**
+ * alloc_wrb_handle - To allocate a wrb handle
+ * @phba: The hba pointer
+ * @cid: The cid to use for allocation
+ * @index: index allocation and wrb index
+ *
+ * This happens under session_lock until submission to chip
+ */
+struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid,
+				    int index)
+{
+	struct hwi_wrb_context *pwrb_context;
+	struct hwi_controller *phwi_ctrlr;
+	struct wrb_handle *pwrb_handle;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	pwrb_context = &phwi_ctrlr->wrb_context[cid];
+	pwrb_handle = pwrb_context->pwrb_handle_base[index];
+	pwrb_handle->wrb_index = index;
+	pwrb_handle->nxt_wrb_index = index;
+	return pwrb_handle;
+}
+
+/**
+ * free_wrb_handle - To free the wrb handle back to pool
+ * @phba: The hba pointer
+ * @pwrb_context: The context to free from
+ * @pwrb_handle: The wrb_handle to free
+ *
+ * This happens under session_lock until submission to chip
+ */
+static void
+free_wrb_handle(struct beiscsi_hba *phba, struct hwi_wrb_context *pwrb_context,
+		struct wrb_handle *pwrb_handle)
+{
+	SE_DEBUG(DBG_LVL_8,
+		 "FREE WRB: pwrb_handle=%p free_index=%d=0x%x"
+		 "wrb_handles_available=%d \n",
+		 pwrb_handle, pwrb_context->free_index,
+		 pwrb_context->free_index, pwrb_context->wrb_handles_available);
+}
+
+static struct sgl_handle *alloc_mgmt_sgl_handle(struct beiscsi_hba *phba)
+{
+	struct sgl_handle *psgl_handle;
+
+	if (phba->eh_sgl_hndl_avbl) {
+		psgl_handle = phba->eh_sgl_hndl_base[phba->eh_sgl_alloc_index];
+		phba->eh_sgl_hndl_base[phba->eh_sgl_alloc_index] = NULL;
+		SE_DEBUG(DBG_LVL_8, "mgmt_sgl_alloc_index=%d=0x%x \n",
+			 phba->eh_sgl_alloc_index, phba->eh_sgl_alloc_index);
+		phba->eh_sgl_hndl_avbl--;
+		if (phba->eh_sgl_alloc_index ==
+		    (phba->params.icds_per_ctrl - phba->params.ios_per_ctrl -
+		     1))
+			phba->eh_sgl_alloc_index = 0;
+		else
+			phba->eh_sgl_alloc_index++;
+	} else
+		psgl_handle = NULL;
+	return psgl_handle;
+}
+
+void
+free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
+{
+
+	if (phba->eh_sgl_hndl_base[phba->eh_sgl_free_index]) {
+		/*
+		 * this can happen if clean_task is called on a task that
+		 * failed in xmit_task or alloc_pdu.
+		 */
+		SE_DEBUG(DBG_LVL_8,
+			 "Double Free in eh SGL ,eh_sgl_free_index=%d \n",
+			 phba->eh_sgl_free_index);
+		return;
+	}
+	phba->eh_sgl_hndl_base[phba->eh_sgl_free_index] = psgl_handle;
+	phba->eh_sgl_hndl_avbl++;
+	if (phba->eh_sgl_free_index ==
+	    (phba->params.icds_per_ctrl - phba->params.ios_per_ctrl - 1))
+		phba->eh_sgl_free_index = 0;
+	else
+		phba->eh_sgl_free_index++;
+}
+
+static void
+be_complete_io(struct beiscsi_conn *beiscsi_conn,
+	       struct iscsi_task *task, struct sol_cqe *psol)
+{
+	struct beiscsi_io_task *io_task = task->dd_data;
+	struct be_status_bhs *sts_bhs =
+				(struct be_status_bhs *)&io_task->cmd_bhs;
+	struct iscsi_conn *conn = beiscsi_conn->conn;
+	unsigned int sense_len;
+	unsigned char *sense;
+	u32 resid = 0, exp_cmdsn, max_cmdsn;
+	u8 rsp, status, flags;
+
+	exp_cmdsn = be32_to_cpu(psol->
+			dw[offsetof(struct amap_sol_cqe, i_exp_cmd_sn) / 32]
+			& SOL_EXP_CMD_SN_MASK);
+	max_cmdsn = be32_to_cpu((psol->
+			dw[offsetof(struct amap_sol_cqe, i_exp_cmd_sn) / 32]
+			& SOL_EXP_CMD_SN_MASK) +
+			((psol->dw[offsetof(struct amap_sol_cqe, i_cmd_wnd)
+				/ 32] & SOL_CMD_WND_MASK) >> 24) - 1);
+	rsp = ((psol->dw[offsetof(struct amap_sol_cqe, i_resp) / 32]
+						& SOL_RESP_MASK) >> 16);
+	status = ((psol->dw[offsetof(struct amap_sol_cqe, i_sts) / 32]
+						& SOL_STS_MASK) >> 8);
+	flags = ((psol->dw[offsetof(struct amap_sol_cqe, i_flags) / 32]
+					& SOL_FLAGS_MASK) >> 24) | 0x80;
+
+	task->sc->result = (DID_OK << 16) | status;
+	if (rsp != ISCSI_STATUS_CMD_COMPLETED) {
+		task->sc->result = DID_ERROR << 16;
+		goto unmap;
+	}
+
+	/* bidi not initially supported */
+	if (flags & (ISCSI_FLAG_CMD_UNDERFLOW | ISCSI_FLAG_CMD_OVERFLOW)) {
+		resid = (psol->dw[offsetof(struct amap_sol_cqe, i_res_cnt) /
+				32] & SOL_RES_CNT_MASK);
+
+		if (!status && (flags & ISCSI_FLAG_CMD_OVERFLOW))
+			task->sc->result = DID_ERROR << 16;
+
+		if (flags & ISCSI_FLAG_CMD_UNDERFLOW) {
+			scsi_set_resid(task->sc, resid);
+			if (!status && (scsi_bufflen(task->sc) - resid <
+			    task->sc->underflow))
+				task->sc->result = DID_ERROR << 16;
+		}
+	}
+
+	if (status == SAM_STAT_CHECK_CONDITION) {
+		sense = sts_bhs->sense_info + sizeof(unsigned short);
+		sense_len =
+		    cpu_to_be16((unsigned short)(sts_bhs->sense_info[0]));
+		memcpy(task->sc->sense_buffer, sense,
+		       min_t(u16, sense_len, SCSI_SENSE_BUFFERSIZE));
+	}
+	if (io_task->cmd_bhs.iscsi_hdr.flags & ISCSI_FLAG_CMD_READ) {
+		if (psol->dw[offsetof(struct amap_sol_cqe, i_res_cnt) / 32]
+							& SOL_RES_CNT_MASK)
+			 conn->rxdata_octets += (psol->
+			      dw[offsetof(struct amap_sol_cqe, i_res_cnt) / 32]
+							& SOL_RES_CNT_MASK);
+	}
+unmap:
+	scsi_dma_unmap(io_task->scsi_cmnd);
+	iscsi_complete_scsi_task(task, exp_cmdsn, max_cmdsn);
+}
+
+static void
+be_complete_logout(struct beiscsi_conn *beiscsi_conn,
+		   struct iscsi_task *task, struct sol_cqe *psol)
+{
+	struct iscsi_logout_rsp *hdr;
+	struct iscsi_conn *conn = beiscsi_conn->conn;
+
+	hdr = (struct iscsi_logout_rsp *)task->hdr;
+	hdr->t2wait = 5;
+	hdr->t2retain = 0;
+	hdr->flags = ((psol->dw[offsetof(struct amap_sol_cqe, i_flags) / 32]
+					& SOL_FLAGS_MASK) >> 24) | 0x80;
+	hdr->response = (psol->dw[offsetof(struct amap_sol_cqe, i_resp) /
+					32] & SOL_RESP_MASK);
+	hdr->exp_cmdsn = cpu_to_be32(psol->
+			dw[offsetof(struct amap_sol_cqe, i_exp_cmd_sn) / 32]
+					& SOL_EXP_CMD_SN_MASK);
+	hdr->max_cmdsn = be32_to_cpu((psol->
+			 dw[offsetof(struct amap_sol_cqe, i_exp_cmd_sn) / 32]
+					& SOL_EXP_CMD_SN_MASK) +
+			((psol->dw[offsetof(struct amap_sol_cqe, i_cmd_wnd)
+					/ 32] & SOL_CMD_WND_MASK) >> 24) - 1);
+	hdr->hlength = 0;
+
+	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
+}
+
+static void
+be_complete_tmf(struct beiscsi_conn *beiscsi_conn,
+		struct iscsi_task *task, struct sol_cqe *psol)
+{
+	struct iscsi_tm_rsp *hdr;
+	struct iscsi_conn *conn = beiscsi_conn->conn;
+
+	hdr = (struct iscsi_tm_rsp *)task->hdr;
+	hdr->flags = ((psol->dw[offsetof(struct amap_sol_cqe, i_flags) / 32]
+					& SOL_FLAGS_MASK) >> 24) | 0x80;
+	hdr->response = (psol->dw[offsetof(struct amap_sol_cqe, i_resp) /
+					32] & SOL_RESP_MASK);
+	hdr->exp_cmdsn = cpu_to_be32(psol->dw[offsetof(struct amap_sol_cqe,
+				     i_exp_cmd_sn) / 32] & SOL_EXP_CMD_SN_MASK);
+	hdr->max_cmdsn = be32_to_cpu((psol->dw[offsetof(struct amap_sol_cqe,
+			i_exp_cmd_sn) / 32] & SOL_EXP_CMD_SN_MASK) +
+			((psol->dw[offsetof(struct amap_sol_cqe, i_cmd_wnd)
+			/ 32] & SOL_CMD_WND_MASK) >> 24) - 1);
+	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
+}
+
+static void
+hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
+		       struct beiscsi_hba *phba, struct sol_cqe *psol)
+{
+	struct hwi_wrb_context *pwrb_context;
+	struct wrb_handle *pwrb_handle;
+	struct hwi_controller *phwi_ctrlr;
+	struct iscsi_conn *conn = beiscsi_conn->conn;
+	struct iscsi_session *session = conn->session;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	pwrb_context = &phwi_ctrlr->wrb_context[((psol->
+				dw[offsetof(struct amap_sol_cqe, cid) / 32] &
+				SOL_CID_MASK) >> 6)];
+	pwrb_handle = pwrb_context->pwrb_handle_basestd[((psol->
+				dw[offsetof(struct amap_sol_cqe, wrb_index) /
+				32] & SOL_WRB_INDEX_MASK) >> 16)];
+	spin_lock_bh(&session->lock);
+	free_wrb_handle(phba, pwrb_context, pwrb_handle);
+	spin_unlock_bh(&session->lock);
+}
+
+static void
+be_complete_nopin_resp(struct beiscsi_conn *beiscsi_conn,
+		       struct iscsi_task *task, struct sol_cqe *psol)
+{
+	struct iscsi_nopin *hdr;
+	struct iscsi_conn *conn = beiscsi_conn->conn;
+
+	hdr = (struct iscsi_nopin *)task->hdr;
+	hdr->flags = ((psol->dw[offsetof(struct amap_sol_cqe, i_flags) / 32]
+			& SOL_FLAGS_MASK) >> 24) | 0x80;
+	hdr->exp_cmdsn = cpu_to_be32(psol->dw[offsetof(struct amap_sol_cqe,
+				     i_exp_cmd_sn) / 32] & SOL_EXP_CMD_SN_MASK);
+	hdr->max_cmdsn = be32_to_cpu((psol->dw[offsetof(struct amap_sol_cqe,
+			i_exp_cmd_sn) / 32] & SOL_EXP_CMD_SN_MASK) +
+			((psol->dw[offsetof(struct amap_sol_cqe, i_cmd_wnd)
+			/ 32] & SOL_CMD_WND_MASK) >> 24) - 1);
+	hdr->opcode = ISCSI_OP_NOOP_IN;
+	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
+}
+
+static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
+			     struct beiscsi_hba *phba, struct sol_cqe *psol)
+{
+	struct hwi_wrb_context *pwrb_context;
+	struct wrb_handle *pwrb_handle;
+	struct iscsi_wrb *pwrb = NULL;
+	struct hwi_controller *phwi_ctrlr;
+	struct iscsi_task *task;
+	struct beiscsi_io_task *io_task;
+	struct iscsi_conn *conn = beiscsi_conn->conn;
+	struct iscsi_session *session = conn->session;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+
+	pwrb_context = &phwi_ctrlr->
+		wrb_context[((psol->dw[offsetof(struct amap_sol_cqe, cid) / 32]
+		& SOL_CID_MASK) >> 6)];
+	pwrb_handle = pwrb_context->pwrb_handle_basestd[((psol->
+				dw[offsetof(struct amap_sol_cqe, wrb_index) /
+				32] & SOL_WRB_INDEX_MASK) >> 16)];
+
+	task = pwrb_handle->pio_handle;
+	io_task = task->dd_data;
+	spin_lock_bh(&session->lock);
+	pwrb = pwrb_handle->pwrb;
+	switch ((pwrb->dw[offsetof(struct amap_iscsi_wrb, type) / 32] &
+		 WRB_TYPE_MASK) >> 28) {
+	case HWH_TYPE_IO:
+	case HWH_TYPE_IO_RD:
+		if ((task->hdr->opcode & ISCSI_OPCODE_MASK) ==
+		    ISCSI_OP_NOOP_OUT) {
+			be_complete_nopin_resp(beiscsi_conn, task, psol);
+		} else
+			be_complete_io(beiscsi_conn, task, psol);
+		break;
+
+	case HWH_TYPE_LOGOUT:
+		be_complete_logout(beiscsi_conn, task, psol);
+		break;
+
+	case HWH_TYPE_LOGIN:
+		SE_DEBUG(DBG_LVL_1,
+			 "\t\t No HWH_TYPE_LOGIN Expected in hwi_complete_cmd"
+			 "- Solicited path \n");
+		break;
+
+	case HWH_TYPE_TMF:
+		be_complete_tmf(beiscsi_conn, task, psol);
+		break;
+
+	case HWH_TYPE_NOP:
+		be_complete_nopin_resp(beiscsi_conn, task, psol);
+		break;
+
+	default:
+		shost_printk(KERN_WARNING, phba->shost,
+			    "wrb_index 0x%x CID 0x%x\n",
+			    ((psol->dw[offsetof(struct amap_iscsi_wrb, type) /
+					32] & SOL_WRB_INDEX_MASK) >> 16),
+			    ((psol->dw[offsetof(struct amap_sol_cqe, cid) / 32]
+					& SOL_CID_MASK) >> 6));
+		break;
+	}
+
+	spin_unlock_bh(&session->lock);
+}
+
+static struct list_head *hwi_get_async_busy_list(struct hwi_async_pdu_context
+					  *pasync_ctx, unsigned int is_header,
+					  unsigned int host_write_ptr)
+{
+	if (is_header)
+		return &pasync_ctx->async_entry[host_write_ptr].
+		    header_busy_list;
+	else
+		return &pasync_ctx->async_entry[host_write_ptr].data_busy_list;
+}
+
+static struct async_pdu_handle *
+hwi_get_async_handle(struct beiscsi_hba *phba,
+		     struct beiscsi_conn *beiscsi_conn,
+		     struct hwi_async_pdu_context *pasync_ctx,
+		     struct i_t_dpdu_cqe *pdpdu_cqe, unsigned int *pcq_index)
+{
+	struct be_bus_address phys_addr;
+	struct list_head *pbusy_list;
+	struct async_pdu_handle *pasync_handle = NULL;
+	int buffer_len = 0;
+	unsigned char buffer_index = -1;
+	unsigned char is_header = 0;
+
+	phys_addr.u.a32.address_lo =
+	    pdpdu_cqe->dw[offsetof(struct amap_i_t_dpdu_cqe, db_addr_lo) / 32] -
+	    ((pdpdu_cqe->dw[offsetof(struct amap_i_t_dpdu_cqe, dpl) / 32]
+						& PDUCQE_DPL_MASK) >> 16);
+	phys_addr.u.a32.address_hi =
+	    pdpdu_cqe->dw[offsetof(struct amap_i_t_dpdu_cqe, db_addr_hi) / 32];
+
+	phys_addr.u.a64.address =
+			*((unsigned long long *)(&phys_addr.u.a64.address));
+
+	switch (pdpdu_cqe->dw[offsetof(struct amap_i_t_dpdu_cqe, code) / 32]
+			& PDUCQE_CODE_MASK) {
+	case UNSOL_HDR_NOTIFY:
+		is_header = 1;
+
+		pbusy_list = hwi_get_async_busy_list(pasync_ctx, 1,
+			(pdpdu_cqe->dw[offsetof(struct amap_i_t_dpdu_cqe,
+			index) / 32] & PDUCQE_INDEX_MASK));
+
+		buffer_len = (unsigned int)(phys_addr.u.a64.address -
+				pasync_ctx->async_header.pa_base.u.a64.address);
+
+		buffer_index = buffer_len /
+				pasync_ctx->async_header.buffer_size;
+
+		break;
+	case UNSOL_DATA_NOTIFY:
+		pbusy_list = hwi_get_async_busy_list(pasync_ctx, 0, (pdpdu_cqe->
+					dw[offsetof(struct amap_i_t_dpdu_cqe,
+					index) / 32] & PDUCQE_INDEX_MASK));
+		buffer_len = (unsigned long)(phys_addr.u.a64.address -
+					pasync_ctx->async_data.pa_base.u.
+					a64.address);
+		buffer_index = buffer_len / pasync_ctx->async_data.buffer_size;
+		break;
+	default:
+		pbusy_list = NULL;
+		shost_printk(KERN_WARNING, phba->shost,
+			"Unexpected code=%d \n",
+			 pdpdu_cqe->dw[offsetof(struct amap_i_t_dpdu_cqe,
+					code) / 32] & PDUCQE_CODE_MASK);
+		return NULL;
+	}
+
+	WARN_ON(!(buffer_index <= pasync_ctx->async_data.num_entries));
+	WARN_ON(list_empty(pbusy_list));
+	list_for_each_entry(pasync_handle, pbusy_list, link) {
+		WARN_ON(pasync_handle->consumed);
+		if (pasync_handle->index == buffer_index)
+			break;
+	}
+
+	WARN_ON(!pasync_handle);
+
+	pasync_handle->cri = (unsigned short)beiscsi_conn->beiscsi_conn_cid;
+	pasync_handle->is_header = is_header;
+	pasync_handle->buffer_len = ((pdpdu_cqe->
+			dw[offsetof(struct amap_i_t_dpdu_cqe, dpl) / 32]
+			& PDUCQE_DPL_MASK) >> 16);
+
+	*pcq_index = (pdpdu_cqe->dw[offsetof(struct amap_i_t_dpdu_cqe,
+			index) / 32] & PDUCQE_INDEX_MASK);
+	return pasync_handle;
+}
+
+static unsigned int
+hwi_update_async_writables(struct hwi_async_pdu_context *pasync_ctx,
+			   unsigned int is_header, unsigned int cq_index)
+{
+	struct list_head *pbusy_list;
+	struct async_pdu_handle *pasync_handle;
+	unsigned int num_entries, writables = 0;
+	unsigned int *pep_read_ptr, *pwritables;
+
+
+	if (is_header) {
+		pep_read_ptr = &pasync_ctx->async_header.ep_read_ptr;
+		pwritables = &pasync_ctx->async_header.writables;
+		num_entries = pasync_ctx->async_header.num_entries;
+	} else {
+		pep_read_ptr = &pasync_ctx->async_data.ep_read_ptr;
+		pwritables = &pasync_ctx->async_data.writables;
+		num_entries = pasync_ctx->async_data.num_entries;
+	}
+
+	while ((*pep_read_ptr) != cq_index) {
+		(*pep_read_ptr)++;
+		*pep_read_ptr = (*pep_read_ptr) % num_entries;
+
+		pbusy_list = hwi_get_async_busy_list(pasync_ctx, is_header,
+						     *pep_read_ptr);
+		if (writables == 0)
+			WARN_ON(list_empty(pbusy_list));
+
+		if (!list_empty(pbusy_list)) {
+			pasync_handle = list_entry(pbusy_list->next,
+						   struct async_pdu_handle,
+						   link);
+			WARN_ON(!pasync_handle);
+			pasync_handle->consumed = 1;
+		}
+
+		writables++;
+	}
+
+	if (!writables) {
+		SE_DEBUG(DBG_LVL_1,
+			 "Duplicate notification received - index 0x%x!!\n",
+			 cq_index);
+		WARN_ON(1);
+	}
+
+	*pwritables = *pwritables + writables;
+	return 0;
+}
+
+static unsigned int hwi_free_async_msg(struct beiscsi_hba *phba,
+				       unsigned int cri)
+{
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_async_pdu_context *pasync_ctx;
+	struct async_pdu_handle *pasync_handle, *tmp_handle;
+	struct list_head *plist;
+	unsigned int i = 0;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi_ctrlr);
+
+	plist  = &pasync_ctx->async_entry[cri].wait_queue.list;
+
+	list_for_each_entry_safe(pasync_handle, tmp_handle, plist, link) {
+		list_del(&pasync_handle->link);
+
+		if (i == 0) {
+			list_add_tail(&pasync_handle->link,
+				      &pasync_ctx->async_header.free_list);
+			pasync_ctx->async_header.free_entries++;
+			i++;
+		} else {
+			list_add_tail(&pasync_handle->link,
+				      &pasync_ctx->async_data.free_list);
+			pasync_ctx->async_data.free_entries++;
+			i++;
+		}
+	}
+
+	INIT_LIST_HEAD(&pasync_ctx->async_entry[cri].wait_queue.list);
+	pasync_ctx->async_entry[cri].wait_queue.hdr_received = 0;
+	pasync_ctx->async_entry[cri].wait_queue.bytes_received = 0;
+	return 0;
+}
+
+static struct phys_addr *
+hwi_get_ring_address(struct hwi_async_pdu_context *pasync_ctx,
+		     unsigned int is_header, unsigned int host_write_ptr)
+{
+	struct phys_addr *pasync_sge = NULL;
+
+	if (is_header)
+		pasync_sge = pasync_ctx->async_header.ring_base;
+	else
+		pasync_sge = pasync_ctx->async_data.ring_base;
+
+	return pasync_sge + host_write_ptr;
+}
+
+static void hwi_post_async_buffers(struct beiscsi_hba *phba,
+				   unsigned int is_header)
+{
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_async_pdu_context *pasync_ctx;
+	struct async_pdu_handle *pasync_handle;
+	struct list_head *pfree_link, *pbusy_list;
+	struct phys_addr *pasync_sge;
+	unsigned int ring_id, num_entries;
+	unsigned int host_write_num;
+	unsigned int writables;
+	unsigned int i = 0;
+	u32 doorbell = 0;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi_ctrlr);
+
+	if (is_header) {
+		num_entries = pasync_ctx->async_header.num_entries;
+		writables = min(pasync_ctx->async_header.writables,
+				pasync_ctx->async_header.free_entries);
+		pfree_link = pasync_ctx->async_header.free_list.next;
+		host_write_num = pasync_ctx->async_header.host_write_ptr;
+		ring_id = phwi_ctrlr->default_pdu_hdr.id;
+	} else {
+		num_entries = pasync_ctx->async_data.num_entries;
+		writables = min(pasync_ctx->async_data.writables,
+				pasync_ctx->async_data.free_entries);
+		pfree_link = pasync_ctx->async_data.free_list.next;
+		host_write_num = pasync_ctx->async_data.host_write_ptr;
+		ring_id = phwi_ctrlr->default_pdu_data.id;
+	}
+
+	writables = (writables / 8) * 8;
+	if (writables) {
+		for (i = 0; i < writables; i++) {
+			pbusy_list =
+			    hwi_get_async_busy_list(pasync_ctx, is_header,
+						    host_write_num);
+			pasync_handle =
+			    list_entry(pfree_link, struct async_pdu_handle,
+								link);
+			WARN_ON(!pasync_handle);
+			pasync_handle->consumed = 0;
+
+			pfree_link = pfree_link->next;
+
+			pasync_sge = hwi_get_ring_address(pasync_ctx,
+						is_header, host_write_num);
+
+			pasync_sge->hi = pasync_handle->pa.u.a32.address_lo;
+			pasync_sge->lo = pasync_handle->pa.u.a32.address_hi;
+
+			list_move(&pasync_handle->link, pbusy_list);
+
+			host_write_num++;
+			host_write_num = host_write_num % num_entries;
+		}
+
+		if (is_header) {
+			pasync_ctx->async_header.host_write_ptr =
+							host_write_num;
+			pasync_ctx->async_header.free_entries -= writables;
+			pasync_ctx->async_header.writables -= writables;
+			pasync_ctx->async_header.busy_entries += writables;
+		} else {
+			pasync_ctx->async_data.host_write_ptr = host_write_num;
+			pasync_ctx->async_data.free_entries -= writables;
+			pasync_ctx->async_data.writables -= writables;
+			pasync_ctx->async_data.busy_entries += writables;
+		}
+
+		doorbell |= ring_id & DB_DEF_PDU_RING_ID_MASK;
+		doorbell |= 1 << DB_DEF_PDU_REARM_SHIFT;
+		doorbell |= 0 << DB_DEF_PDU_EVENT_SHIFT;
+		doorbell |= (writables & DB_DEF_PDU_CQPROC_MASK)
+					<< DB_DEF_PDU_CQPROC_SHIFT;
+
+		iowrite32(doorbell, phba->db_va + DB_RXULP0_OFFSET);
+	}
+}
+
+static void hwi_flush_default_pdu_buffer(struct beiscsi_hba *phba,
+					 struct beiscsi_conn *beiscsi_conn,
+					 struct i_t_dpdu_cqe *pdpdu_cqe)
+{
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_async_pdu_context *pasync_ctx;
+	struct async_pdu_handle *pasync_handle = NULL;
+	unsigned int cq_index = -1;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi_ctrlr);
+
+	pasync_handle = hwi_get_async_handle(phba, beiscsi_conn, pasync_ctx,
+					     pdpdu_cqe, &cq_index);
+	BUG_ON(pasync_handle->is_header != 0);
+	if (pasync_handle->consumed == 0)
+		hwi_update_async_writables(pasync_ctx, pasync_handle->is_header,
+					   cq_index);
+
+	hwi_free_async_msg(phba, pasync_handle->cri);
+	hwi_post_async_buffers(phba, pasync_handle->is_header);
+}
+
+static unsigned int
+hwi_fwd_async_msg(struct beiscsi_conn *beiscsi_conn,
+		  struct beiscsi_hba *phba,
+		  struct hwi_async_pdu_context *pasync_ctx, unsigned short cri)
+{
+	struct list_head *plist;
+	struct async_pdu_handle *pasync_handle;
+	void *phdr = NULL;
+	unsigned int hdr_len = 0, buf_len = 0;
+	unsigned int status, index = 0, offset = 0;
+	void *pfirst_buffer = NULL;
+	unsigned int num_buf = 0;
+
+	plist = &pasync_ctx->async_entry[cri].wait_queue.list;
+
+	list_for_each_entry(pasync_handle, plist, link) {
+		if (index == 0) {
+			phdr = pasync_handle->pbuffer;
+			hdr_len = pasync_handle->buffer_len;
+		} else {
+			buf_len = pasync_handle->buffer_len;
+			if (!num_buf) {
+				pfirst_buffer = pasync_handle->pbuffer;
+				num_buf++;
+			}
+			memcpy(pfirst_buffer + offset,
+			       pasync_handle->pbuffer, buf_len);
+			offset = buf_len;
+		}
+		index++;
+	}
+
+	status = beiscsi_process_async_pdu(beiscsi_conn, phba,
+					   beiscsi_conn->beiscsi_conn_cid,
+					   phdr, hdr_len, pfirst_buffer,
+					   buf_len);
+
+	if (status == 0)
+		hwi_free_async_msg(phba, cri);
+	return 0;
+}
+
+static unsigned int
+hwi_gather_async_pdu(struct beiscsi_conn *beiscsi_conn,
+		     struct beiscsi_hba *phba,
+		     struct async_pdu_handle *pasync_handle)
+{
+	struct hwi_async_pdu_context *pasync_ctx;
+	struct hwi_controller *phwi_ctrlr;
+	unsigned int bytes_needed = 0, status = 0;
+	unsigned short cri = pasync_handle->cri;
+	struct pdu_base *ppdu;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi_ctrlr);
+
+	list_del(&pasync_handle->link);
+	if (pasync_handle->is_header) {
+		pasync_ctx->async_header.busy_entries--;
+		if (pasync_ctx->async_entry[cri].wait_queue.hdr_received) {
+			hwi_free_async_msg(phba, cri);
+			BUG();
+		}
+
+		pasync_ctx->async_entry[cri].wait_queue.bytes_received = 0;
+		pasync_ctx->async_entry[cri].wait_queue.hdr_received = 1;
+		pasync_ctx->async_entry[cri].wait_queue.hdr_len =
+				(unsigned short)pasync_handle->buffer_len;
+		list_add_tail(&pasync_handle->link,
+			      &pasync_ctx->async_entry[cri].wait_queue.list);
+
+		ppdu = pasync_handle->pbuffer;
+		bytes_needed = ((((ppdu->dw[offsetof(struct amap_pdu_base,
+			data_len_hi) / 32] & PDUBASE_DATALENHI_MASK) << 8) &
+			0xFFFF0000) | ((be16_to_cpu((ppdu->
+			dw[offsetof(struct amap_pdu_base, data_len_lo) / 32]
+			& PDUBASE_DATALENLO_MASK) >> 16)) & 0x0000FFFF));
+
+		if (status == 0) {
+			pasync_ctx->async_entry[cri].wait_queue.bytes_needed =
+			    bytes_needed;
+
+			if (bytes_needed == 0)
+				status = hwi_fwd_async_msg(beiscsi_conn, phba,
+							   pasync_ctx, cri);
+		}
+	} else {
+		pasync_ctx->async_data.busy_entries--;
+		if (pasync_ctx->async_entry[cri].wait_queue.hdr_received) {
+			list_add_tail(&pasync_handle->link,
+				      &pasync_ctx->async_entry[cri].wait_queue.
+				      list);
+			pasync_ctx->async_entry[cri].wait_queue.
+				bytes_received +=
+				(unsigned short)pasync_handle->buffer_len;
+
+			if (pasync_ctx->async_entry[cri].wait_queue.
+			    bytes_received >=
+			    pasync_ctx->async_entry[cri].wait_queue.
+			    bytes_needed)
+				status = hwi_fwd_async_msg(beiscsi_conn, phba,
+							   pasync_ctx, cri);
+		}
+	}
+	return status;
+}
+
+static void hwi_process_default_pdu_ring(struct beiscsi_conn *beiscsi_conn,
+					 struct beiscsi_hba *phba,
+					 struct i_t_dpdu_cqe *pdpdu_cqe)
+{
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_async_pdu_context *pasync_ctx;
+	struct async_pdu_handle *pasync_handle = NULL;
+	unsigned int cq_index = -1;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi_ctrlr);
+	pasync_handle = hwi_get_async_handle(phba, beiscsi_conn, pasync_ctx,
+					     pdpdu_cqe, &cq_index);
+
+	if (pasync_handle->consumed == 0)
+		hwi_update_async_writables(pasync_ctx, pasync_handle->is_header,
+					   cq_index);
+	hwi_gather_async_pdu(beiscsi_conn, phba, pasync_handle);
+	hwi_post_async_buffers(phba, pasync_handle->is_header);
+}
+
+static unsigned int beiscsi_process_cq(struct beiscsi_hba *phba)
+{
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_context_memory *phwi_context;
+	struct be_queue_info *cq;
+	struct sol_cqe *sol;
+	struct dmsg_cqe *dmsg;
+	unsigned int num_processed = 0;
+	unsigned int tot_nump = 0;
+	struct beiscsi_conn *beiscsi_conn;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	phwi_context = phwi_ctrlr->phwi_ctxt;
+	cq = &phwi_context->be_cq;
+	sol = queue_tail_node(cq);
+
+	while (sol->dw[offsetof(struct amap_sol_cqe, valid) / 32] &
+	       CQE_VALID_MASK) {
+		be_dws_le_to_cpu(sol, sizeof(struct sol_cqe));
+
+		beiscsi_conn = phba->conn_table[(u32) (sol->
+				 dw[offsetof(struct amap_sol_cqe, cid) / 32] &
+				 SOL_CID_MASK) >> 6];
+
+		if (!beiscsi_conn || !beiscsi_conn->ep) {
+			shost_printk(KERN_WARNING, phba->shost,
+				     "Connection table empty for cid = %d\n",
+				     (u32)(sol->dw[offsetof(struct amap_sol_cqe,
+				     cid) / 32] & SOL_CID_MASK) >> 6);
+			return 0;
+		}
+
+		if (num_processed >= 32) {
+			hwi_ring_cq_db(phba, phwi_context->be_cq.id,
+					num_processed, 0, 0);
+			tot_nump += num_processed;
+			num_processed = 0;
+		}
+
+		switch ((u32) sol->dw[offsetof(struct amap_sol_cqe, code) /
+			32] & CQE_CODE_MASK) {
+		case SOL_CMD_COMPLETE:
+			hwi_complete_cmd(beiscsi_conn, phba, sol);
+			break;
+		case DRIVERMSG_NOTIFY:
+			SE_DEBUG(DBG_LVL_8, "Received DRIVERMSG_NOTIFY \n");
+			dmsg = (struct dmsg_cqe *)sol;
+			hwi_complete_drvr_msgs(beiscsi_conn, phba, sol);
+			break;
+		case UNSOL_HDR_NOTIFY:
+		case UNSOL_DATA_NOTIFY:
+			SE_DEBUG(DBG_LVL_8, "Received UNSOL_HDR/DATA_NOTIFY\n");
+			hwi_process_default_pdu_ring(beiscsi_conn, phba,
+					     (struct i_t_dpdu_cqe *)sol);
+			break;
+		case CXN_INVALIDATE_INDEX_NOTIFY:
+		case CMD_INVALIDATED_NOTIFY:
+		case CXN_INVALIDATE_NOTIFY:
+			SE_DEBUG(DBG_LVL_1,
+				 "Ignoring CQ Error notification for cmd/cxn"
+				 "invalidate\n");
+			break;
+		case SOL_CMD_KILLED_DATA_DIGEST_ERR:
+		case CMD_KILLED_INVALID_STATSN_RCVD:
+		case CMD_KILLED_INVALID_R2T_RCVD:
+		case CMD_CXN_KILLED_LUN_INVALID:
+		case CMD_CXN_KILLED_ICD_INVALID:
+		case CMD_CXN_KILLED_ITT_INVALID:
+		case CMD_CXN_KILLED_SEQ_OUTOFORDER:
+		case CMD_CXN_KILLED_INVALID_DATASN_RCVD:
+			SE_DEBUG(DBG_LVL_1,
+				 "CQ Error notification for cmd.. "
+				 "code %d cid 0x%x\n",
+				 sol->dw[offsetof(struct amap_sol_cqe, code) /
+				 32] & CQE_CODE_MASK,
+				 (sol->dw[offsetof(struct amap_sol_cqe, cid) /
+				 32] & SOL_CID_MASK));
+			break;
+		case UNSOL_DATA_DIGEST_ERROR_NOTIFY:
+			SE_DEBUG(DBG_LVL_1,
+				 "Digest error on def pdu ring, dropping..\n");
+			hwi_flush_default_pdu_buffer(phba, beiscsi_conn,
+					     (struct i_t_dpdu_cqe *) sol);
+			break;
+		case CXN_KILLED_PDU_SIZE_EXCEEDS_DSL:
+		case CXN_KILLED_BURST_LEN_MISMATCH:
+		case CXN_KILLED_AHS_RCVD:
+		case CXN_KILLED_HDR_DIGEST_ERR:
+		case CXN_KILLED_UNKNOWN_HDR:
+		case CXN_KILLED_STALE_ITT_TTT_RCVD:
+		case CXN_KILLED_INVALID_ITT_TTT_RCVD:
+		case CXN_KILLED_TIMED_OUT:
+		case CXN_KILLED_FIN_RCVD:
+		case CXN_KILLED_BAD_UNSOL_PDU_RCVD:
+		case CXN_KILLED_BAD_WRB_INDEX_ERROR:
+		case CXN_KILLED_OVER_RUN_RESIDUAL:
+		case CXN_KILLED_UNDER_RUN_RESIDUAL:
+		case CXN_KILLED_CMND_DATA_NOT_ON_SAME_CONN:
+			SE_DEBUG(DBG_LVL_1, "CQ Error %d, resetting CID "
+				 "0x%x...\n",
+				 sol->dw[offsetof(struct amap_sol_cqe, code) /
+				 32] & CQE_CODE_MASK,
+				 sol->dw[offsetof(struct amap_sol_cqe, cid) /
+				 32] & CQE_CID_MASK);
+			iscsi_conn_failure(beiscsi_conn->conn,
+					   ISCSI_ERR_CONN_FAILED);
+			break;
+		case CXN_KILLED_RST_SENT:
+		case CXN_KILLED_RST_RCVD:
+			SE_DEBUG(DBG_LVL_1, "CQ Error %d, reset received/sent "
+				 "on CID 0x%x...\n",
+				 sol->dw[offsetof(struct amap_sol_cqe, code) /
+				 32] & CQE_CODE_MASK,
+				 sol->dw[offsetof(struct amap_sol_cqe, cid) /
+				 32] & CQE_CID_MASK);
+			iscsi_conn_failure(beiscsi_conn->conn,
+					   ISCSI_ERR_CONN_FAILED);
+			break;
+		default:
+			SE_DEBUG(DBG_LVL_1, "CQ Error Invalid code= %d "
+				 "received on CID 0x%x...\n",
+				 sol->dw[offsetof(struct amap_sol_cqe, code) /
+				 32] & CQE_CODE_MASK,
+				 sol->dw[offsetof(struct amap_sol_cqe, cid) /
+				 32] & CQE_CID_MASK);
+			break;
+		}
+
+		AMAP_SET_BITS(struct amap_sol_cqe, valid, sol, 0);
+		queue_tail_inc(cq);
+		sol = queue_tail_node(cq);
+		num_processed++;
+	}
+
+	if (num_processed > 0) {
+		tot_nump += num_processed;
+		hwi_ring_cq_db(phba, phwi_context->be_cq.id, num_processed,
+			       1, 0);
+	}
+	return tot_nump;
+}
+
+static void beiscsi_process_all_cqs(struct work_struct *work)
+{
+	unsigned long flags;
+	struct beiscsi_hba *phba =
+	    container_of(work, struct beiscsi_hba, work_cqs);
+
+	if (phba->todo_mcc_cq) {
+		spin_lock_irqsave(&phba->isr_lock, flags);
+		phba->todo_mcc_cq = 0;
+		spin_unlock_irqrestore(&phba->isr_lock, flags);
+		SE_DEBUG(DBG_LVL_1, "MCC Interrupt Not expected \n");
+	}
+
+	if (phba->todo_cq) {
+		spin_lock_irqsave(&phba->isr_lock, flags);
+		phba->todo_cq = 0;
+		spin_unlock_irqrestore(&phba->isr_lock, flags);
+		beiscsi_process_cq(phba);
+	}
+}
+
+static int be_iopoll(struct blk_iopoll *iop, int budget)
+{
+	static unsigned int ret;
+	struct beiscsi_hba *phba;
+
+	phba = container_of(iop, struct beiscsi_hba, iopoll);
+
+	ret = beiscsi_process_cq(phba);
+	if (ret < budget) {
+		struct hwi_controller *phwi_ctrlr;
+		struct hwi_context_memory *phwi_context;
+
+		phwi_ctrlr = phba->phwi_ctrlr;
+		phwi_context = phwi_ctrlr->phwi_ctxt;
+		blk_iopoll_complete(iop);
+		hwi_ring_eq_db(phba, phwi_context->be_eq.q.id, 0,
+							0, 1, 1);
+	}
+	return ret;
+}
+
+static void
+hwi_write_sgl(struct iscsi_wrb *pwrb, struct scatterlist *sg,
+	      unsigned int num_sg, struct beiscsi_io_task *io_task)
+{
+	struct iscsi_sge *psgl;
+	unsigned short sg_len, index;
+	unsigned int sge_len = 0;
+	unsigned long long addr;
+	struct scatterlist *l_sg;
+	unsigned int offset;
+
+	AMAP_SET_BITS(struct amap_iscsi_wrb, iscsi_bhs_addr_lo, pwrb,
+				      io_task->bhs_pa.u.a32.address_lo);
+	AMAP_SET_BITS(struct amap_iscsi_wrb, iscsi_bhs_addr_hi, pwrb,
+				      io_task->bhs_pa.u.a32.address_hi);
+
+	l_sg = sg;
+	for (index = 0; (index < num_sg) && (index < 2); index++, sg_next(sg)) {
+		if (index == 0) {
+			sg_len = sg_dma_len(sg);
+			addr = (u64) sg_dma_address(sg);
+			AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_addr_lo, pwrb,
+							(addr & 0xFFFFFFFF));
+			AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_addr_hi, pwrb,
+							(addr >> 32));
+			AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_len, pwrb,
+							sg_len);
+			sge_len = sg_len;
+			AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_last, pwrb,
+							1);
+		} else {
+			AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_last, pwrb,
+							0);
+			AMAP_SET_BITS(struct amap_iscsi_wrb, sge1_r2t_offset,
+							pwrb, sge_len);
+			sg_len = sg_dma_len(sg);
+			addr = (u64) sg_dma_address(sg);
+			AMAP_SET_BITS(struct amap_iscsi_wrb, sge1_addr_lo, pwrb,
+							(addr & 0xFFFFFFFF));
+			AMAP_SET_BITS(struct amap_iscsi_wrb, sge1_addr_hi, pwrb,
+							(addr >> 32));
+			AMAP_SET_BITS(struct amap_iscsi_wrb, sge1_len, pwrb,
+							sg_len);
+		}
+	}
+	psgl = (struct iscsi_sge *)io_task->psgl_handle->pfrag;
+	memset(psgl, 0, sizeof(*psgl) * BE2_SGE);
+
+	AMAP_SET_BITS(struct amap_iscsi_sge, len, psgl, io_task->bhs_len - 2);
+
+	AMAP_SET_BITS(struct amap_iscsi_sge, addr_hi, psgl,
+			io_task->bhs_pa.u.a32.address_hi);
+	AMAP_SET_BITS(struct amap_iscsi_sge, addr_lo, psgl,
+			io_task->bhs_pa.u.a32.address_lo);
+
+	if (num_sg == 2)
+		AMAP_SET_BITS(struct amap_iscsi_wrb, sge1_last, pwrb, 1);
+	sg = l_sg;
+	psgl++;
+	psgl++;
+	offset = 0;
+	for (index = 0; index < num_sg; index++, sg_next(sg), psgl++) {
+		sg_len = sg_dma_len(sg);
+		addr = (u64) sg_dma_address(sg);
+		AMAP_SET_BITS(struct amap_iscsi_sge, addr_lo, psgl,
+						(addr & 0xFFFFFFFF));
+		AMAP_SET_BITS(struct amap_iscsi_sge, addr_hi, psgl,
+						(addr >> 32));
+		AMAP_SET_BITS(struct amap_iscsi_sge, len, psgl, sg_len);
+		AMAP_SET_BITS(struct amap_iscsi_sge, sge_offset, psgl, offset);
+		AMAP_SET_BITS(struct amap_iscsi_sge, last_sge, psgl, 0);
+		offset += sg_len;
+	}
+	psgl--;
+	AMAP_SET_BITS(struct amap_iscsi_sge, last_sge, psgl, 1);
+}
+
+static void hwi_write_buffer(struct iscsi_wrb *pwrb, struct iscsi_task *task)
+{
+	struct iscsi_sge *psgl;
+	unsigned long long addr;
+	struct beiscsi_io_task *io_task = task->dd_data;
+	struct beiscsi_conn *beiscsi_conn = io_task->conn;
+	struct beiscsi_hba *phba = beiscsi_conn->phba;
+
+	io_task->bhs_len = sizeof(struct be_nonio_bhs) - 2;
+	io_task->bhs_pa.u.a64.address = virt_to_bus(&io_task->cmd_bhs);
+	AMAP_SET_BITS(struct amap_iscsi_wrb, iscsi_bhs_addr_lo, pwrb,
+				io_task->bhs_pa.u.a32.address_lo);
+	AMAP_SET_BITS(struct amap_iscsi_wrb, iscsi_bhs_addr_hi, pwrb,
+				io_task->bhs_pa.u.a32.address_hi);
+
+	if (task->data) {
+		if (task->data_count) {
+			AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
+			addr = (u64) pci_map_single(phba->pcidev,
+						    task->data,
+						    task->data_count, 1);
+		} else {
+			AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 0);
+			addr = 0;
+		}
+		AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_addr_lo, pwrb,
+						(addr & 0xFFFFFFFF));
+		AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_addr_hi, pwrb,
+						(addr >> 32));
+		AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_len, pwrb,
+						task->data_count);
+
+		AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_last, pwrb, 1);
+	} else {
+		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 0);
+		addr = 0;
+	}
+
+	psgl = (struct iscsi_sge *)io_task->psgl_handle->pfrag;
+
+	AMAP_SET_BITS(struct amap_iscsi_sge, len, psgl, io_task->bhs_len);
+
+	AMAP_SET_BITS(struct amap_iscsi_sge, addr_hi, psgl,
+		      io_task->bhs_pa.u.a32.address_hi);
+	AMAP_SET_BITS(struct amap_iscsi_sge, addr_lo, psgl,
+		      io_task->bhs_pa.u.a32.address_lo);
+	if (task->data) {
+		psgl++;
+		AMAP_SET_BITS(struct amap_iscsi_sge, addr_hi, psgl, 0);
+		AMAP_SET_BITS(struct amap_iscsi_sge, addr_lo, psgl, 0);
+		AMAP_SET_BITS(struct amap_iscsi_sge, len, psgl, 0);
+		AMAP_SET_BITS(struct amap_iscsi_sge, sge_offset, psgl, 0);
+		AMAP_SET_BITS(struct amap_iscsi_sge, rsvd0, psgl, 0);
+		AMAP_SET_BITS(struct amap_iscsi_sge, last_sge, psgl, 0);
+
+		psgl++;
+		if (task->data) {
+			AMAP_SET_BITS(struct amap_iscsi_sge, addr_lo, psgl,
+						(addr & 0xFFFFFFFF));
+			AMAP_SET_BITS(struct amap_iscsi_sge, addr_hi, psgl,
+						(addr >> 32));
+		}
+		AMAP_SET_BITS(struct amap_iscsi_sge, len, psgl, 0x106);
+	}
+	AMAP_SET_BITS(struct amap_iscsi_sge, last_sge, psgl, 1);
+}
+
+static void beiscsi_find_mem_req(struct beiscsi_hba *phba)
+{
+	unsigned int num_cq_pages, num_eq_pages, num_async_pdu_buf_pages;
+	unsigned int num_async_pdu_data_pages, wrb_sz_per_cxn;
+	unsigned int num_async_pdu_buf_sgl_pages, num_async_pdu_data_sgl_pages;
+
+	num_cq_pages = PAGES_REQUIRED(phba->params.num_cq_entries * \
+				      sizeof(struct sol_cqe));
+	num_eq_pages = PAGES_REQUIRED(phba->params.num_eq_entries * \
+				      sizeof(struct be_eq_entry));
+	num_async_pdu_buf_pages =
+			PAGES_REQUIRED(phba->params.asyncpdus_per_ctrl * \
+				       phba->params.defpdu_hdr_sz);
+	num_async_pdu_buf_sgl_pages =
+			PAGES_REQUIRED(phba->params.asyncpdus_per_ctrl * \
+				       sizeof(struct phys_addr));
+	num_async_pdu_data_pages =
+			PAGES_REQUIRED(phba->params.asyncpdus_per_ctrl * \
+				       phba->params.defpdu_data_sz);
+	num_async_pdu_data_sgl_pages =
+			PAGES_REQUIRED(phba->params.asyncpdus_per_ctrl * \
+				       sizeof(struct phys_addr));
+
+	phba->params.hwi_ws_sz = sizeof(struct hwi_controller);
+
+	phba->mem_req[ISCSI_MEM_GLOBAL_HEADER] = 2 *
+						 BE_ISCSI_PDU_HEADER_SIZE;
+	phba->mem_req[HWI_MEM_ADDN_CONTEXT] =
+					    sizeof(struct hwi_context_memory);
+
+	phba->mem_req[HWI_MEM_CQ] = num_cq_pages * PAGE_SIZE;
+	phba->mem_req[HWI_MEM_EQ] = num_eq_pages * PAGE_SIZE;
+
+	phba->mem_req[HWI_MEM_WRB] = sizeof(struct iscsi_wrb)
+	    * (phba->params.wrbs_per_cxn)
+	    * phba->params.cxns_per_ctrl;
+	wrb_sz_per_cxn =  sizeof(struct wrb_handle) *
+				 (phba->params.wrbs_per_cxn);
+	phba->mem_req[HWI_MEM_WRBH] = roundup_pow_of_two((wrb_sz_per_cxn) *
+				phba->params.cxns_per_ctrl);
+
+	phba->mem_req[HWI_MEM_SGLH] = sizeof(struct sgl_handle) *
+		phba->params.icds_per_ctrl;
+	phba->mem_req[HWI_MEM_SGE] = sizeof(struct iscsi_sge) *
+		phba->params.num_sge_per_io * phba->params.icds_per_ctrl;
+
+	phba->mem_req[HWI_MEM_ASYNC_HEADER_BUF] =
+		num_async_pdu_buf_pages * PAGE_SIZE;
+	phba->mem_req[HWI_MEM_ASYNC_DATA_BUF] =
+		num_async_pdu_data_pages * PAGE_SIZE;
+	phba->mem_req[HWI_MEM_ASYNC_HEADER_RING] =
+		num_async_pdu_buf_sgl_pages * PAGE_SIZE;
+	phba->mem_req[HWI_MEM_ASYNC_DATA_RING] =
+		num_async_pdu_data_sgl_pages * PAGE_SIZE;
+	phba->mem_req[HWI_MEM_ASYNC_HEADER_HANDLE] =
+		phba->params.asyncpdus_per_ctrl *
+		sizeof(struct async_pdu_handle);
+	phba->mem_req[HWI_MEM_ASYNC_DATA_HANDLE] =
+		phba->params.asyncpdus_per_ctrl *
+		sizeof(struct async_pdu_handle);
+	phba->mem_req[HWI_MEM_ASYNC_PDU_CONTEXT] =
+		sizeof(struct hwi_async_pdu_context) +
+		(phba->params.cxns_per_ctrl * sizeof(struct hwi_async_entry));
+}
+
+static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
+{
+	struct be_mem_descriptor *mem_descr;
+	dma_addr_t bus_add;
+	struct mem_array *mem_arr, *mem_arr_orig;
+	unsigned int i, j, alloc_size, curr_alloc_size;
+
+	phba->phwi_ctrlr = kmalloc(phba->params.hwi_ws_sz, GFP_KERNEL);
+	if (!phba->phwi_ctrlr)
+		return -ENOMEM;
+
+	phba->init_mem = kcalloc(SE_MEM_MAX, sizeof(*mem_descr),
+				 GFP_KERNEL);
+	if (!phba->init_mem) {
+		kfree(phba->phwi_ctrlr);
+		return -ENOMEM;
+	}
+
+	mem_arr_orig = kmalloc(sizeof(*mem_arr_orig) * BEISCSI_MAX_FRAGS_INIT,
+			       GFP_KERNEL);
+	if (!mem_arr_orig) {
+		kfree(phba->init_mem);
+		kfree(phba->phwi_ctrlr);
+		return -ENOMEM;
+	}
+
+	mem_descr = phba->init_mem;
+	for (i = 0; i < SE_MEM_MAX; i++) {
+		j = 0;
+		mem_arr = mem_arr_orig;
+		alloc_size = phba->mem_req[i];
+		memset(mem_arr, 0, sizeof(struct mem_array) *
+		       BEISCSI_MAX_FRAGS_INIT);
+		curr_alloc_size = min(be_max_phys_size * 1024, alloc_size);
+		do {
+			mem_arr->virtual_address = pci_alloc_consistent(
+							phba->pcidev,
+							curr_alloc_size,
+							&bus_add);
+			if (!mem_arr->virtual_address) {
+				if (curr_alloc_size <= BE_MIN_MEM_SIZE)
+					goto free_mem;
+				if (curr_alloc_size -
+					rounddown_pow_of_two(curr_alloc_size))
+					curr_alloc_size = rounddown_pow_of_two
+							     (curr_alloc_size);
+				else
+					curr_alloc_size = curr_alloc_size / 2;
+			} else {
+				mem_arr->bus_address.u.
+				    a64.address = (__u64) bus_add;
+				mem_arr->size = curr_alloc_size;
+				alloc_size -= curr_alloc_size;
+				curr_alloc_size = min(be_max_phys_size *
+						      1024, alloc_size);
+				j++;
+				mem_arr++;
+			}
+		} while (alloc_size);
+		mem_descr->num_elements = j;
+		mem_descr->size_in_bytes = phba->mem_req[i];
+		mem_descr->mem_array = kmalloc(sizeof(*mem_arr) * j,
+					       GFP_KERNEL);
+		if (!mem_descr->mem_array)
+			goto free_mem;
+
+		memcpy(mem_descr->mem_array, mem_arr_orig,
+		       sizeof(struct mem_array) * j);
+		mem_descr++;
+	}
+	kfree(mem_arr_orig);
+	return 0;
+free_mem:
+	mem_descr->num_elements = j;
+	while ((i) || (j)) {
+		for (j = mem_descr->num_elements; j > 0; j--) {
+			pci_free_consistent(phba->pcidev,
+					    mem_descr->mem_array[j - 1].size,
+					    mem_descr->mem_array[j - 1].
+					    virtual_address,
+					    mem_descr->mem_array[j - 1].
+					    bus_address.u.a64.address);
+		}
+		if (i) {
+			i--;
+			kfree(mem_descr->mem_array);
+			mem_descr--;
+		}
+	}
+	kfree(mem_arr_orig);
+	kfree(phba->init_mem);
+	kfree(phba->phwi_ctrlr);
+	return -ENOMEM;
+}
+
+static int beiscsi_get_memory(struct beiscsi_hba *phba)
+{
+	beiscsi_find_mem_req(phba);
+	return beiscsi_alloc_mem(phba);
+}
+
+static void iscsi_init_global_templates(struct beiscsi_hba *phba)
+{
+	struct pdu_data_out *pdata_out;
+	struct pdu_nop_out *pnop_out;
+	struct be_mem_descriptor *mem_descr;
+
+	mem_descr = phba->init_mem;
+	mem_descr += ISCSI_MEM_GLOBAL_HEADER;
+	pdata_out =
+	    (struct pdu_data_out *)mem_descr->mem_array[0].virtual_address;
+	memset(pdata_out, 0, BE_ISCSI_PDU_HEADER_SIZE);
+
+	AMAP_SET_BITS(struct amap_pdu_data_out, opcode, pdata_out,
+		      IIOC_SCSI_DATA);
+
+	pnop_out =
+	    (struct pdu_nop_out *)((unsigned char *)mem_descr->mem_array[0].
+				   virtual_address + BE_ISCSI_PDU_HEADER_SIZE);
+
+	memset(pnop_out, 0, BE_ISCSI_PDU_HEADER_SIZE);
+	AMAP_SET_BITS(struct amap_pdu_nop_out, ttt, pnop_out, 0xFFFFFFFF);
+	AMAP_SET_BITS(struct amap_pdu_nop_out, f_bit, pnop_out, 1);
+	AMAP_SET_BITS(struct amap_pdu_nop_out, i_bit, pnop_out, 0);
+}
+
+static void beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
+{
+	struct be_mem_descriptor *mem_descr_wrbh, *mem_descr_wrb;
+	struct wrb_handle *pwrb_handle;
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_wrb_context *pwrb_context;
+	struct iscsi_wrb *pwrb;
+	unsigned int num_cxn_wrbh;
+	unsigned int num_cxn_wrb, j, idx, index;
+
+	mem_descr_wrbh = phba->init_mem;
+	mem_descr_wrbh += HWI_MEM_WRBH;
+
+	mem_descr_wrb = phba->init_mem;
+	mem_descr_wrb += HWI_MEM_WRB;
+
+	idx = 0;
+	pwrb_handle = mem_descr_wrbh->mem_array[idx].virtual_address;
+	num_cxn_wrbh = ((mem_descr_wrbh->mem_array[idx].size) /
+			((sizeof(struct wrb_handle)) *
+			 phba->params.wrbs_per_cxn));
+	phwi_ctrlr = phba->phwi_ctrlr;
+
+	for (index = 0; index < phba->params.cxns_per_ctrl * 2; index += 2) {
+		pwrb_context = &phwi_ctrlr->wrb_context[index];
+		SE_DEBUG(DBG_LVL_8, "cid=%d pwrb_context=%p \n", index,
+						pwrb_context);
+		pwrb_context->pwrb_handle_base =
+				kzalloc(sizeof(struct wrb_handle *) *
+					phba->params.wrbs_per_cxn, GFP_KERNEL);
+		pwrb_context->pwrb_handle_basestd =
+				kzalloc(sizeof(struct wrb_handle *) *
+					phba->params.wrbs_per_cxn, GFP_KERNEL);
+		if (num_cxn_wrbh) {
+			pwrb_context->alloc_index = 0;
+			pwrb_context->wrb_handles_available = 0;
+			for (j = 0; j < phba->params.wrbs_per_cxn; j++) {
+				pwrb_context->pwrb_handle_base[j] = pwrb_handle;
+				pwrb_context->pwrb_handle_basestd[j] =
+								pwrb_handle;
+				pwrb_context->wrb_handles_available++;
+				pwrb_handle++;
+			}
+			pwrb_context->free_index = 0;
+			num_cxn_wrbh--;
+		} else {
+			idx++;
+			pwrb_handle =
+			    mem_descr_wrbh->mem_array[idx].virtual_address;
+			num_cxn_wrbh =
+			    ((mem_descr_wrbh->mem_array[idx].size) /
+			     ((sizeof(struct wrb_handle)) *
+			      phba->params.wrbs_per_cxn));
+			pwrb_context->alloc_index = 0;
+			for (j = 0; j < phba->params.wrbs_per_cxn; j++) {
+				pwrb_context->pwrb_handle_base[j] = pwrb_handle;
+				pwrb_context->pwrb_handle_basestd[j] =
+				    pwrb_handle;
+				pwrb_context->wrb_handles_available++;
+				pwrb_handle++;
+			}
+			pwrb_context->free_index = 0;
+			num_cxn_wrbh--;
+		}
+	}
+	idx = 0;
+	pwrb = mem_descr_wrb->mem_array[idx].virtual_address;
+	num_cxn_wrb =
+	    ((mem_descr_wrb->mem_array[idx].size) / (sizeof(struct iscsi_wrb)) *
+	     phba->params.wrbs_per_cxn);
+
+	for (index = 0; index < phba->params.cxns_per_ctrl; index += 2) {
+		pwrb_context = &phwi_ctrlr->wrb_context[index];
+		if (num_cxn_wrb) {
+			for (j = 0; j < phba->params.wrbs_per_cxn; j++) {
+				pwrb_handle = pwrb_context->pwrb_handle_base[j];
+				pwrb_handle->pwrb = pwrb;
+				pwrb++;
+			}
+			num_cxn_wrb--;
+		} else {
+			idx++;
+			pwrb = mem_descr_wrb->mem_array[idx].virtual_address;
+			num_cxn_wrb = ((mem_descr_wrb->mem_array[idx].size) /
+					(sizeof(struct iscsi_wrb)) *
+					phba->params.wrbs_per_cxn);
+			for (j = 0; j < phba->params.wrbs_per_cxn; j++) {
+				pwrb_handle = pwrb_context->pwrb_handle_base[j];
+				pwrb_handle->pwrb = pwrb;
+				pwrb++;
+			}
+			num_cxn_wrb--;
+		}
+	}
+}
+
+static void hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
+{
+	struct hwi_controller *phwi_ctrlr;
+	struct hba_parameters *p = &phba->params;
+	struct hwi_async_pdu_context *pasync_ctx;
+	struct async_pdu_handle *pasync_header_h, *pasync_data_h;
+	unsigned int index;
+	struct be_mem_descriptor *mem_descr;
+
+	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+	mem_descr += HWI_MEM_ASYNC_PDU_CONTEXT;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	phwi_ctrlr->phwi_ctxt->pasync_ctx = (struct hwi_async_pdu_context *)
+				mem_descr->mem_array[0].virtual_address;
+	pasync_ctx = phwi_ctrlr->phwi_ctxt->pasync_ctx;
+	memset(pasync_ctx, 0, sizeof(*pasync_ctx));
+
+	pasync_ctx->async_header.num_entries = p->asyncpdus_per_ctrl;
+	pasync_ctx->async_header.buffer_size = p->defpdu_hdr_sz;
+	pasync_ctx->async_data.buffer_size = p->defpdu_data_sz;
+	pasync_ctx->async_data.num_entries = p->asyncpdus_per_ctrl;
+
+	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+	mem_descr += HWI_MEM_ASYNC_HEADER_BUF;
+	if (mem_descr->mem_array[0].virtual_address) {
+		SE_DEBUG(DBG_LVL_8,
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_BUF"
+			 "va=%p \n", mem_descr->mem_array[0].virtual_address);
+	} else
+		shost_printk(KERN_WARNING, phba->shost,
+			     "No Virtual address \n");
+
+	pasync_ctx->async_header.va_base =
+			mem_descr->mem_array[0].virtual_address;
+
+	pasync_ctx->async_header.pa_base.u.a64.address =
+			mem_descr->mem_array[0].bus_address.u.a64.address;
+
+	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+	mem_descr += HWI_MEM_ASYNC_HEADER_RING;
+	if (mem_descr->mem_array[0].virtual_address) {
+		SE_DEBUG(DBG_LVL_8,
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_RING"
+			 "va=%p \n", mem_descr->mem_array[0].virtual_address);
+	} else
+		shost_printk(KERN_WARNING, phba->shost,
+			    "No Virtual address \n");
+	pasync_ctx->async_header.ring_base =
+			mem_descr->mem_array[0].virtual_address;
+
+	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+	mem_descr += HWI_MEM_ASYNC_HEADER_HANDLE;
+	if (mem_descr->mem_array[0].virtual_address) {
+		SE_DEBUG(DBG_LVL_8,
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_HANDLE"
+			 "va=%p \n", mem_descr->mem_array[0].virtual_address);
+	} else
+		shost_printk(KERN_WARNING, phba->shost,
+			    "No Virtual address \n");
+
+	pasync_ctx->async_header.handle_base =
+			mem_descr->mem_array[0].virtual_address;
+	pasync_ctx->async_header.writables = 0;
+	INIT_LIST_HEAD(&pasync_ctx->async_header.free_list);
+
+	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+	mem_descr += HWI_MEM_ASYNC_DATA_BUF;
+	if (mem_descr->mem_array[0].virtual_address) {
+		SE_DEBUG(DBG_LVL_8,
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_BUF"
+			 "va=%p \n", mem_descr->mem_array[0].virtual_address);
+	} else
+		shost_printk(KERN_WARNING, phba->shost,
+			    "No Virtual address \n");
+	pasync_ctx->async_data.va_base =
+			mem_descr->mem_array[0].virtual_address;
+	pasync_ctx->async_data.pa_base.u.a64.address =
+			mem_descr->mem_array[0].bus_address.u.a64.address;
+
+	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+	mem_descr += HWI_MEM_ASYNC_DATA_RING;
+	if (mem_descr->mem_array[0].virtual_address) {
+		SE_DEBUG(DBG_LVL_8,
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_RING"
+			 "va=%p \n", mem_descr->mem_array[0].virtual_address);
+	} else
+		shost_printk(KERN_WARNING, phba->shost,
+			     "No Virtual address \n");
+
+	pasync_ctx->async_data.ring_base =
+			mem_descr->mem_array[0].virtual_address;
+
+	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+	mem_descr += HWI_MEM_ASYNC_DATA_HANDLE;
+	if (!mem_descr->mem_array[0].virtual_address)
+		shost_printk(KERN_WARNING, phba->shost,
+			    "No Virtual address \n");
+
+	pasync_ctx->async_data.handle_base =
+			mem_descr->mem_array[0].virtual_address;
+	pasync_ctx->async_data.writables = 0;
+	INIT_LIST_HEAD(&pasync_ctx->async_data.free_list);
+
+	pasync_header_h =
+		(struct async_pdu_handle *)pasync_ctx->async_header.handle_base;
+	pasync_data_h =
+		(struct async_pdu_handle *)pasync_ctx->async_data.handle_base;
+
+	for (index = 0; index < p->asyncpdus_per_ctrl; index++) {
+		pasync_header_h->cri = -1;
+		pasync_header_h->index = (char)index;
+		INIT_LIST_HEAD(&pasync_header_h->link);
+		pasync_header_h->pbuffer =
+			(void *)((unsigned long)
+			(pasync_ctx->async_header.va_base) +
+			(p->defpdu_hdr_sz * index));
+
+		pasync_header_h->pa.u.a64.address =
+			pasync_ctx->async_header.pa_base.u.a64.address +
+			(p->defpdu_hdr_sz * index);
+
+		list_add_tail(&pasync_header_h->link,
+				&pasync_ctx->async_header.free_list);
+		pasync_header_h++;
+		pasync_ctx->async_header.free_entries++;
+		pasync_ctx->async_header.writables++;
+
+		INIT_LIST_HEAD(&pasync_ctx->async_entry[index].wait_queue.list);
+		INIT_LIST_HEAD(&pasync_ctx->async_entry[index].
+			       header_busy_list);
+		pasync_data_h->cri = -1;
+		pasync_data_h->index = (char)index;
+		INIT_LIST_HEAD(&pasync_data_h->link);
+		pasync_data_h->pbuffer =
+			(void *)((unsigned long)
+			(pasync_ctx->async_data.va_base) +
+			(p->defpdu_data_sz * index));
+
+		pasync_data_h->pa.u.a64.address =
+		    pasync_ctx->async_data.pa_base.u.a64.address +
+		    (p->defpdu_data_sz * index);
+
+		list_add_tail(&pasync_data_h->link,
+			      &pasync_ctx->async_data.free_list);
+		pasync_data_h++;
+		pasync_ctx->async_data.free_entries++;
+		pasync_ctx->async_data.writables++;
+
+		INIT_LIST_HEAD(&pasync_ctx->async_entry[index].data_busy_list);
+	}
+
+	pasync_ctx->async_header.host_write_ptr = 0;
+	pasync_ctx->async_header.ep_read_ptr = -1;
+	pasync_ctx->async_data.host_write_ptr = 0;
+	pasync_ctx->async_data.ep_read_ptr = -1;
+}
+
+static int
+be_sgl_create_contiguous(void *virtual_address,
+			 u64 physical_address, u32 length,
+			 struct be_dma_mem *sgl)
+{
+	WARN_ON(!virtual_address);
+	WARN_ON(!physical_address);
+	WARN_ON(!length > 0);
+	WARN_ON(!sgl);
+
+	sgl->va = virtual_address;
+	sgl->dma = physical_address;
+	sgl->size = length;
+
+	return 0;
+}
+
+static void be_sgl_destroy_contiguous(struct be_dma_mem *sgl)
+{
+	memset(sgl, 0, sizeof(*sgl));
+}
+
+static void
+hwi_build_be_sgl_arr(struct beiscsi_hba *phba,
+		     struct mem_array *pmem, struct be_dma_mem *sgl)
+{
+	if (sgl->va)
+		be_sgl_destroy_contiguous(sgl);
+
+	be_sgl_create_contiguous(pmem->virtual_address,
+				 pmem->bus_address.u.a64.address,
+				 pmem->size, sgl);
+}
+
+static void
+hwi_build_be_sgl_by_offset(struct beiscsi_hba *phba,
+			   struct mem_array *pmem, struct be_dma_mem *sgl)
+{
+	if (sgl->va)
+		be_sgl_destroy_contiguous(sgl);
+
+	be_sgl_create_contiguous((unsigned char *)pmem->virtual_address,
+				 pmem->bus_address.u.a64.address,
+				 pmem->size, sgl);
+}
+
+static int be_fill_queue(struct be_queue_info *q,
+		u16 len, u16 entry_size, void *vaddress)
+{
+	struct be_dma_mem *mem = &q->dma_mem;
+
+	memset(q, 0, sizeof(*q));
+	q->len = len;
+	q->entry_size = entry_size;
+	mem->size = len * entry_size;
+	mem->va = vaddress;
+	if (!mem->va)
+		return -ENOMEM;
+	memset(mem->va, 0, mem->size);
+	return 0;
+}
+
+static int beiscsi_create_eq(struct beiscsi_hba *phba,
+			     struct hwi_context_memory *phwi_context)
+{
+	unsigned int idx;
+	int ret;
+	struct be_queue_info *eq;
+	struct be_dma_mem *mem;
+	struct be_mem_descriptor *mem_descr;
+	void *eq_vaddress;
+
+	idx = 0;
+	eq = &phwi_context->be_eq.q;
+	mem = &eq->dma_mem;
+	mem_descr = phba->init_mem;
+	mem_descr += HWI_MEM_EQ;
+	eq_vaddress = mem_descr->mem_array[idx].virtual_address;
+
+	ret = be_fill_queue(eq, phba->params.num_eq_entries,
+			    sizeof(struct be_eq_entry), eq_vaddress);
+	if (ret) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "be_fill_queue Failed for EQ \n");
+		return ret;
+	}
+
+	mem->dma = mem_descr->mem_array[idx].bus_address.u.a64.address;
+
+	ret = be_cmd_eq_create(&phba->ctrl, eq, phwi_context->be_eq.cur_eqd);
+	if (ret) {
+		shost_printk(KERN_ERR, phba->shost, "be_cmd_eq_creat Failed"
+			     " for EQ \n");
+		return ret;
+	}
+	SE_DEBUG(DBG_LVL_8, "eq id is %d\n", phwi_context->be_eq.q.id);
+	return 0;
+}
+
+static int beiscsi_create_cq(struct beiscsi_hba *phba,
+			     struct hwi_context_memory *phwi_context)
+{
+	unsigned int idx;
+	int ret;
+	struct be_queue_info *cq, *eq;
+	struct be_dma_mem *mem;
+	struct be_mem_descriptor *mem_descr;
+	void *cq_vaddress;
+
+	idx = 0;
+	cq = &phwi_context->be_cq;
+	eq = &phwi_context->be_eq.q;
+	mem = &cq->dma_mem;
+	mem_descr = phba->init_mem;
+	mem_descr += HWI_MEM_CQ;
+	cq_vaddress = mem_descr->mem_array[idx].virtual_address;
+	ret = be_fill_queue(cq, phba->params.icds_per_ctrl / 2,
+			    sizeof(struct sol_cqe), cq_vaddress);
+	if (ret) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "be_fill_queue Failed for ISCSI CQ \n");
+		return ret;
+	}
+
+	mem->dma = mem_descr->mem_array[idx].bus_address.u.a64.address;
+	ret = be_cmd_cq_create(&phba->ctrl, cq, eq, false, false, 0);
+	if (ret) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "be_cmd_eq_creat Failed for ISCSI CQ \n");
+		return ret;
+	}
+	SE_DEBUG(DBG_LVL_8, "iscsi cq id is %d\n", phwi_context->be_cq.id);
+	SE_DEBUG(DBG_LVL_8, "ISCSI CQ CREATED\n");
+	return 0;
+}
+
+static int
+beiscsi_create_def_hdr(struct beiscsi_hba *phba,
+		       struct hwi_context_memory *phwi_context,
+		       struct hwi_controller *phwi_ctrlr,
+		       unsigned int def_pdu_ring_sz)
+{
+	unsigned int idx;
+	int ret;
+	struct be_queue_info *dq, *cq;
+	struct be_dma_mem *mem;
+	struct be_mem_descriptor *mem_descr;
+	void *dq_vaddress;
+
+	idx = 0;
+	dq = &phwi_context->be_def_hdrq;
+	cq = &phwi_context->be_cq;
+	mem = &dq->dma_mem;
+	mem_descr = phba->init_mem;
+	mem_descr += HWI_MEM_ASYNC_HEADER_RING;
+	dq_vaddress = mem_descr->mem_array[idx].virtual_address;
+	ret = be_fill_queue(dq, mem_descr->mem_array[0].size /
+			    sizeof(struct phys_addr),
+			    sizeof(struct phys_addr), dq_vaddress);
+	if (ret) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "be_fill_queue Failed for DEF PDU HDR\n");
+		return ret;
+	}
+	mem->dma = mem_descr->mem_array[idx].bus_address.u.a64.address;
+	ret = be_cmd_create_default_pdu_queue(&phba->ctrl, cq, dq,
+					      def_pdu_ring_sz,
+					      phba->params.defpdu_hdr_sz);
+	if (ret) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "be_cmd_eq_creat Failed for DEF PDU HDR\n");
+		return ret;
+	}
+	phwi_ctrlr->default_pdu_hdr.id = phwi_context->be_def_hdrq.id;
+	SE_DEBUG(DBG_LVL_8, "iscsi def pdu id is %d\n",
+		 phwi_context->be_def_hdrq.id);
+	hwi_post_async_buffers(phba, 1);
+	return 0;
+}
+
+static int
+beiscsi_create_def_data(struct beiscsi_hba *phba,
+			struct hwi_context_memory *phwi_context,
+			struct hwi_controller *phwi_ctrlr,
+			unsigned int def_pdu_ring_sz)
+{
+	unsigned int idx;
+	int ret;
+	struct be_queue_info *dataq, *cq;
+	struct be_dma_mem *mem;
+	struct be_mem_descriptor *mem_descr;
+	void *dq_vaddress;
+
+	idx = 0;
+	dataq = &phwi_context->be_def_dataq;
+	cq = &phwi_context->be_cq;
+	mem = &dataq->dma_mem;
+	mem_descr = phba->init_mem;
+	mem_descr += HWI_MEM_ASYNC_DATA_RING;
+	dq_vaddress = mem_descr->mem_array[idx].virtual_address;
+	ret = be_fill_queue(dataq, mem_descr->mem_array[0].size /
+			    sizeof(struct phys_addr),
+			    sizeof(struct phys_addr), dq_vaddress);
+	if (ret) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "be_fill_queue Failed for DEF PDU DATA\n");
+		return ret;
+	}
+	mem->dma = mem_descr->mem_array[idx].bus_address.u.a64.address;
+	ret = be_cmd_create_default_pdu_queue(&phba->ctrl, cq, dataq,
+					      def_pdu_ring_sz,
+					      phba->params.defpdu_data_sz);
+	if (ret) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "be_cmd_eq_creat Failed for DEF PDU DATA\n");
+		return ret;
+	}
+	phwi_ctrlr->default_pdu_data.id = phwi_context->be_def_dataq.id;
+	SE_DEBUG(DBG_LVL_8, "iscsi def data id is %d\n",
+		 phwi_context->be_def_dataq.id);
+	hwi_post_async_buffers(phba, 0);
+	SE_DEBUG(DBG_LVL_8, "DEFAULT PDU DATA RING CREATED \n");
+	return 0;
+}
+
+static int
+beiscsi_post_pages(struct beiscsi_hba *phba)
+{
+	struct be_mem_descriptor *mem_descr;
+	struct mem_array *pm_arr;
+	unsigned int page_offset, i;
+	struct be_dma_mem sgl;
+	int status;
+
+	mem_descr = phba->init_mem;
+	mem_descr += HWI_MEM_SGE;
+	pm_arr = mem_descr->mem_array;
+
+	page_offset = (sizeof(struct iscsi_sge) * phba->params.num_sge_per_io *
+			phba->fw_config.iscsi_icd_start) / PAGE_SIZE;
+	for (i = 0; i < mem_descr->num_elements; i++) {
+		hwi_build_be_sgl_arr(phba, pm_arr, &sgl);
+		status = be_cmd_iscsi_post_sgl_pages(&phba->ctrl, &sgl,
+						page_offset,
+						(pm_arr->size / PAGE_SIZE));
+		page_offset += pm_arr->size / PAGE_SIZE;
+		if (status != 0) {
+			shost_printk(KERN_ERR, phba->shost,
+				     "post sgl failed.\n");
+			return status;
+		}
+		pm_arr++;
+	}
+	SE_DEBUG(DBG_LVL_8, "POSTED PAGES \n");
+	return 0;
+}
+
+static int
+beiscsi_create_wrb_rings(struct beiscsi_hba *phba,
+			 struct hwi_context_memory *phwi_context,
+			 struct hwi_controller *phwi_ctrlr)
+{
+	unsigned int wrb_mem_index, offset, size, num_wrb_rings;
+	u64 pa_addr_lo;
+	unsigned int idx, num, i;
+	struct mem_array *pwrb_arr;
+	void *wrb_vaddr;
+	struct be_dma_mem sgl;
+	struct be_mem_descriptor *mem_descr;
+	int status;
+
+	idx = 0;
+	mem_descr = phba->init_mem;
+	mem_descr += HWI_MEM_WRB;
+	pwrb_arr = kmalloc(sizeof(*pwrb_arr) * phba->params.cxns_per_ctrl,
+			   GFP_KERNEL);
+	if (!pwrb_arr) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "Memory alloc failed in create wrb ring.\n");
+		return -ENOMEM;
+	}
+	wrb_vaddr = mem_descr->mem_array[idx].virtual_address;
+	pa_addr_lo = mem_descr->mem_array[idx].bus_address.u.a64.address;
+	num_wrb_rings = mem_descr->mem_array[idx].size /
+		(phba->params.wrbs_per_cxn * sizeof(struct iscsi_wrb));
+
+	for (num = 0; num < phba->params.cxns_per_ctrl; num++) {
+		if (num_wrb_rings) {
+			pwrb_arr[num].virtual_address = wrb_vaddr;
+			pwrb_arr[num].bus_address.u.a64.address	= pa_addr_lo;
+			pwrb_arr[num].size = phba->params.wrbs_per_cxn *
+					    sizeof(struct iscsi_wrb);
+			wrb_vaddr += pwrb_arr[num].size;
+			pa_addr_lo += pwrb_arr[num].size;
+			num_wrb_rings--;
+		} else {
+			idx++;
+			wrb_vaddr = mem_descr->mem_array[idx].virtual_address;
+			pa_addr_lo = mem_descr->mem_array[idx].\
+					bus_address.u.a64.address;
+			num_wrb_rings = mem_descr->mem_array[idx].size /
+					(phba->params.wrbs_per_cxn *
+					sizeof(struct iscsi_wrb));
+			pwrb_arr[num].virtual_address = wrb_vaddr;
+			pwrb_arr[num].bus_address.u.a64.address\
+						= pa_addr_lo;
+			pwrb_arr[num].size = phba->params.wrbs_per_cxn *
+						 sizeof(struct iscsi_wrb);
+			wrb_vaddr += pwrb_arr[num].size;
+			pa_addr_lo   += pwrb_arr[num].size;
+			num_wrb_rings--;
+		}
+	}
+	for (i = 0; i < phba->params.cxns_per_ctrl; i++) {
+		wrb_mem_index = 0;
+		offset = 0;
+		size = 0;
+
+		hwi_build_be_sgl_by_offset(phba, &pwrb_arr[i], &sgl);
+		status = be_cmd_wrbq_create(&phba->ctrl, &sgl,
+					    &phwi_context->be_wrbq[i]);
+		if (status != 0) {
+			shost_printk(KERN_ERR, phba->shost,
+				     "wrbq create failed.");
+			return status;
+		}
+		phwi_ctrlr->wrb_context[i].cid = phwi_context->be_wrbq[i].id;
+	}
+	kfree(pwrb_arr);
+	return 0;
+}
+
+static void free_wrb_handles(struct beiscsi_hba *phba)
+{
+	unsigned int index;
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_wrb_context *pwrb_context;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	for (index = 0; index < phba->params.cxns_per_ctrl * 2; index += 2) {
+		pwrb_context = &phwi_ctrlr->wrb_context[index];
+		kfree(pwrb_context->pwrb_handle_base);
+		kfree(pwrb_context->pwrb_handle_basestd);
+	}
+}
+
+static void hwi_cleanup(struct beiscsi_hba *phba)
+{
+	struct be_queue_info *q;
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_context_memory *phwi_context;
+	int i;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	phwi_context = phwi_ctrlr->phwi_ctxt;
+	for (i = 0; i < phba->params.cxns_per_ctrl; i++) {
+		q = &phwi_context->be_wrbq[i];
+		if (q->created)
+			be_cmd_q_destroy(ctrl, q, QTYPE_WRBQ);
+	}
+
+	free_wrb_handles(phba);
+
+	q = &phwi_context->be_def_hdrq;
+	if (q->created)
+		be_cmd_q_destroy(ctrl, q, QTYPE_DPDUQ);
+
+	q = &phwi_context->be_def_dataq;
+	if (q->created)
+		be_cmd_q_destroy(ctrl, q, QTYPE_DPDUQ);
+
+	be_cmd_q_destroy(ctrl, NULL, QTYPE_SGL);
+
+	q = &phwi_context->be_cq;
+	if (q->created)
+		be_cmd_q_destroy(ctrl, q, QTYPE_CQ);
+
+	q = &phwi_context->be_eq.q;
+	if (q->created)
+		be_cmd_q_destroy(ctrl, q, QTYPE_EQ);
+}
+
+static int hwi_init_port(struct beiscsi_hba *phba)
+{
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_context_memory *phwi_context;
+	unsigned int def_pdu_ring_sz;
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	int status;
+
+	def_pdu_ring_sz =
+		phba->params.asyncpdus_per_ctrl * sizeof(struct phys_addr);
+	phwi_ctrlr = phba->phwi_ctrlr;
+
+	phwi_context = phwi_ctrlr->phwi_ctxt;
+	phwi_context->be_eq.max_eqd = 0;
+	phwi_context->be_eq.min_eqd = 0;
+	phwi_context->be_eq.cur_eqd = 64;
+	phwi_context->be_eq.enable_aic = false;
+	be_cmd_fw_initialize(&phba->ctrl);
+	status = beiscsi_create_eq(phba, phwi_context);
+	if (status != 0) {
+		shost_printk(KERN_ERR, phba->shost, "EQ not created \n");
+		goto error;
+	}
+
+	status = mgmt_check_supported_fw(ctrl);
+	if (status != 0) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "Unsupported fw version \n");
+		goto error;
+	}
+
+	status = mgmt_get_fw_config(ctrl, phba);
+	if (status != 0) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "Error getting fw config\n");
+		goto error;
+	}
+
+	status = beiscsi_create_cq(phba, phwi_context);
+	if (status != 0) {
+		shost_printk(KERN_ERR, phba->shost, "CQ not created\n");
+		goto error;
+	}
+
+	status = beiscsi_create_def_hdr(phba, phwi_context, phwi_ctrlr,
+					def_pdu_ring_sz);
+	if (status != 0) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "Default Header not created\n");
+		goto error;
+	}
+
+	status = beiscsi_create_def_data(phba, phwi_context,
+					 phwi_ctrlr, def_pdu_ring_sz);
+	if (status != 0) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "Default Data not created\n");
+		goto error;
+	}
+
+	status = beiscsi_post_pages(phba);
+	if (status != 0) {
+		shost_printk(KERN_ERR, phba->shost, "Post SGL Pages Failed\n");
+		goto error;
+	}
+
+	status = beiscsi_create_wrb_rings(phba,	phwi_context, phwi_ctrlr);
+	if (status != 0) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "WRB Rings not created\n");
+		goto error;
+	}
+
+	SE_DEBUG(DBG_LVL_8, "hwi_init_port success\n");
+	return 0;
+
+error:
+	shost_printk(KERN_ERR, phba->shost, "hwi_init_port failed");
+	hwi_cleanup(phba);
+	return -ENOMEM;
+}
+
+
+static int hwi_init_controller(struct beiscsi_hba *phba)
+{
+	struct hwi_controller *phwi_ctrlr;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	if (1 == phba->init_mem[HWI_MEM_ADDN_CONTEXT].num_elements) {
+		phwi_ctrlr->phwi_ctxt = (struct hwi_context_memory *)phba->
+		    init_mem[HWI_MEM_ADDN_CONTEXT].mem_array[0].virtual_address;
+		SE_DEBUG(DBG_LVL_8, " phwi_ctrlr->phwi_ctxt=%p \n",
+			 phwi_ctrlr->phwi_ctxt);
+	} else {
+		shost_printk(KERN_ERR, phba->shost,
+			     "HWI_MEM_ADDN_CONTEXT is more than one element."
+			     "Failing to load\n");
+		return -ENOMEM;
+	}
+
+	iscsi_init_global_templates(phba);
+	beiscsi_init_wrb_handle(phba);
+	hwi_init_async_pdu_ctx(phba);
+	if (hwi_init_port(phba) != 0) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "hwi_init_controller failed\n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void beiscsi_free_mem(struct beiscsi_hba *phba)
+{
+	struct be_mem_descriptor *mem_descr;
+	int i, j;
+
+	mem_descr = phba->init_mem;
+	i = 0;
+	j = 0;
+	for (i = 0; i < SE_MEM_MAX; i++) {
+		for (j = mem_descr->num_elements; j > 0; j--) {
+			pci_free_consistent(phba->pcidev,
+			  mem_descr->mem_array[j - 1].size,
+			  mem_descr->mem_array[j - 1].virtual_address,
+			  mem_descr->mem_array[j - 1].bus_address.
+				u.a64.address);
+		}
+		kfree(mem_descr->mem_array);
+		mem_descr++;
+	}
+	kfree(phba->init_mem);
+	kfree(phba->phwi_ctrlr);
+}
+
+static int beiscsi_init_controller(struct beiscsi_hba *phba)
+{
+	int ret = -ENOMEM;
+
+	ret = beiscsi_get_memory(phba);
+	if (ret < 0) {
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe -"
+			     "Failed in beiscsi_alloc_memory \n");
+		return ret;
+	}
+
+	ret = hwi_init_controller(phba);
+	if (ret)
+		goto free_init;
+	SE_DEBUG(DBG_LVL_8, "Return success from beiscsi_init_controller");
+	return 0;
+
+free_init:
+	beiscsi_free_mem(phba);
+	return -ENOMEM;
+}
+
+static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
+{
+	struct be_mem_descriptor *mem_descr_sglh, *mem_descr_sg;
+	struct sgl_handle *psgl_handle;
+	struct iscsi_sge *pfrag;
+	unsigned int arr_index, i, idx;
+
+	phba->io_sgl_hndl_avbl = 0;
+	phba->eh_sgl_hndl_avbl = 0;
+	mem_descr_sglh = phba->init_mem;
+	mem_descr_sglh += HWI_MEM_SGLH;
+	if (1 == mem_descr_sglh->num_elements) {
+		phba->io_sgl_hndl_base = kzalloc(sizeof(struct sgl_handle *) *
+						 phba->params.ios_per_ctrl,
+						 GFP_KERNEL);
+		if (!phba->io_sgl_hndl_base) {
+			shost_printk(KERN_ERR, phba->shost,
+				     "Mem Alloc Failed. Failing to load\n");
+			return -ENOMEM;
+		}
+		phba->eh_sgl_hndl_base = kzalloc(sizeof(struct sgl_handle *) *
+						 (phba->params.icds_per_ctrl -
+						 phba->params.ios_per_ctrl),
+						 GFP_KERNEL);
+		if (!phba->eh_sgl_hndl_base) {
+			kfree(phba->io_sgl_hndl_base);
+			shost_printk(KERN_ERR, phba->shost,
+				     "Mem Alloc Failed. Failing to load\n");
+			return -ENOMEM;
+		}
+	} else {
+		shost_printk(KERN_ERR, phba->shost,
+			     "HWI_MEM_SGLH is more than one element."
+			     "Failing to load\n");
+		return -ENOMEM;
+	}
+
+	arr_index = 0;
+	idx = 0;
+	while (idx < mem_descr_sglh->num_elements) {
+		psgl_handle = mem_descr_sglh->mem_array[idx].virtual_address;
+
+		for (i = 0; i < (mem_descr_sglh->mem_array[idx].size /
+		      sizeof(struct sgl_handle)); i++) {
+			if (arr_index < phba->params.ios_per_ctrl) {
+				phba->io_sgl_hndl_base[arr_index] = psgl_handle;
+				phba->io_sgl_hndl_avbl++;
+				arr_index++;
+			} else {
+				phba->eh_sgl_hndl_base[arr_index -
+					phba->params.ios_per_ctrl] =
+								psgl_handle;
+				arr_index++;
+				phba->eh_sgl_hndl_avbl++;
+			}
+			psgl_handle++;
+		}
+		idx++;
+	}
+	SE_DEBUG(DBG_LVL_8,
+		 "phba->io_sgl_hndl_avbl=%d"
+		 "phba->eh_sgl_hndl_avbl=%d \n",
+		 phba->io_sgl_hndl_avbl,
+		 phba->eh_sgl_hndl_avbl);
+	mem_descr_sg = phba->init_mem;
+	mem_descr_sg += HWI_MEM_SGE;
+	SE_DEBUG(DBG_LVL_8, "\n mem_descr_sg->num_elements=%d \n",
+		 mem_descr_sg->num_elements);
+	arr_index = 0;
+	idx = 0;
+	while (idx < mem_descr_sg->num_elements) {
+		pfrag = mem_descr_sg->mem_array[idx].virtual_address;
+
+		for (i = 0;
+		     i < (mem_descr_sg->mem_array[idx].size) /
+		     (sizeof(struct iscsi_sge) * phba->params.num_sge_per_io);
+		     i++) {
+			if (arr_index < phba->params.ios_per_ctrl)
+				psgl_handle = phba->io_sgl_hndl_base[arr_index];
+			else
+				psgl_handle = phba->eh_sgl_hndl_base[arr_index -
+						phba->params.ios_per_ctrl];
+			psgl_handle->pfrag = pfrag;
+			AMAP_SET_BITS(struct amap_iscsi_sge, addr_hi, pfrag, 0);
+			AMAP_SET_BITS(struct amap_iscsi_sge, addr_lo, pfrag, 0);
+			pfrag += phba->params.num_sge_per_io;
+			psgl_handle->sgl_index =
+				phba->fw_config.iscsi_cid_start + arr_index++;
+		}
+		idx++;
+	}
+	phba->io_sgl_free_index = 0;
+	phba->io_sgl_alloc_index = 0;
+	phba->eh_sgl_free_index = 0;
+	phba->eh_sgl_alloc_index = 0;
+	return 0;
+}
+
+static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
+{
+	int i, new_cid;
+
+	phba->cid_array = kmalloc(sizeof(void *) * phba->params.cxns_per_ctrl,
+				  GFP_KERNEL);
+	if (!phba->cid_array) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "Failed to allocate memory in "
+			     "hba_setup_cid_tbls\n");
+		return -ENOMEM;
+	}
+	phba->ep_array = kmalloc(sizeof(struct iscsi_endpoint *) *
+				 phba->params.cxns_per_ctrl * 2, GFP_KERNEL);
+	if (!phba->ep_array) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "Failed to allocate memory in "
+			     "hba_setup_cid_tbls \n");
+		kfree(phba->cid_array);
+		return -ENOMEM;
+	}
+	new_cid = phba->fw_config.iscsi_icd_start;
+	for (i = 0; i < phba->params.cxns_per_ctrl; i++) {
+		phba->cid_array[i] = new_cid;
+		new_cid += 2;
+	}
+	phba->avlbl_cids = phba->params.cxns_per_ctrl;
+	return 0;
+}
+
+static unsigned char hwi_enable_intr(struct beiscsi_hba *phba)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_context_memory *phwi_context;
+	struct be_queue_info *eq;
+	u8 __iomem *addr;
+	u32 reg;
+	u32 enabled;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	phwi_context = phwi_ctrlr->phwi_ctxt;
+
+	eq = &phwi_context->be_eq.q;
+	addr = (u8 __iomem *) ((u8 __iomem *) ctrl->pcicfg +
+			PCICFG_MEMBAR_CTRL_INT_CTRL_OFFSET);
+	reg = ioread32(addr);
+	SE_DEBUG(DBG_LVL_8, "reg =x%08x \n", reg);
+
+	enabled = reg & MEMBAR_CTRL_INT_CTRL_HOSTINTR_MASK;
+	if (!enabled) {
+		reg |= MEMBAR_CTRL_INT_CTRL_HOSTINTR_MASK;
+		SE_DEBUG(DBG_LVL_8, "reg =x%08x addr=%p \n", reg, addr);
+		iowrite32(reg, addr);
+		SE_DEBUG(DBG_LVL_8, "eq->id=%d \n", eq->id);
+
+		hwi_ring_eq_db(phba, eq->id, 0, 0, 1, 1);
+	} else
+		shost_printk(KERN_WARNING, phba->shost,
+			     "In hwi_enable_intr, Not Enabled \n");
+	return true;
+}
+
+static void hwi_disable_intr(struct beiscsi_hba *phba)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+
+	u8 __iomem *addr = ctrl->pcicfg + PCICFG_MEMBAR_CTRL_INT_CTRL_OFFSET;
+	u32 reg = ioread32(addr);
+
+	u32 enabled = reg & MEMBAR_CTRL_INT_CTRL_HOSTINTR_MASK;
+	if (enabled) {
+		reg &= ~MEMBAR_CTRL_INT_CTRL_HOSTINTR_MASK;
+		iowrite32(reg, addr);
+	} else
+		shost_printk(KERN_WARNING, phba->shost,
+			     "In hwi_disable_intr, Already Disabled \n");
+}
+
+static int beiscsi_init_port(struct beiscsi_hba *phba)
+{
+	int ret;
+
+	ret = beiscsi_init_controller(phba);
+	if (ret < 0) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "beiscsi_dev_probe - Failed in"
+			     "beiscsi_init_controller \n");
+		return ret;
+	}
+	ret = beiscsi_init_sgl_handle(phba);
+	if (ret < 0) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "beiscsi_dev_probe - Failed in"
+			     "beiscsi_init_sgl_handle \n");
+		goto do_cleanup_ctrlr;
+	}
+
+	if (hba_setup_cid_tbls(phba)) {
+		shost_printk(KERN_ERR, phba->shost,
+			     "Failed in hba_setup_cid_tbls\n");
+		kfree(phba->io_sgl_hndl_base);
+		kfree(phba->eh_sgl_hndl_base);
+		goto do_cleanup_ctrlr;
+	}
+
+	return ret;
+
+do_cleanup_ctrlr:
+	hwi_cleanup(phba);
+	return ret;
+}
+
+static void hwi_purge_eq(struct beiscsi_hba *phba)
+{
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_context_memory *phwi_context;
+	struct be_queue_info *eq;
+	struct be_eq_entry *eqe = NULL;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	phwi_context = phwi_ctrlr->phwi_ctxt;
+	eq = &phwi_context->be_eq.q;
+	eqe = queue_tail_node(eq);
+
+	while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32]
+						& EQE_VALID_MASK) {
+		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
+		queue_tail_inc(eq);
+		eqe = queue_tail_node(eq);
+	}
+}
+
+static void beiscsi_clean_port(struct beiscsi_hba *phba)
+{
+	unsigned char mgmt_status;
+
+	mgmt_status = mgmt_epfw_cleanup(phba, CMD_CONNECTION_CHUTE_0);
+	if (mgmt_status)
+		shost_printk(KERN_WARNING, phba->shost,
+			     "mgmt_epfw_cleanup FAILED \n");
+	hwi_cleanup(phba);
+	hwi_purge_eq(phba);
+	kfree(phba->io_sgl_hndl_base);
+	kfree(phba->eh_sgl_hndl_base);
+	kfree(phba->cid_array);
+	kfree(phba->ep_array);
+}
+
+void
+beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
+			   struct beiscsi_offload_params *params)
+{
+	struct wrb_handle *pwrb_handle;
+	struct iscsi_target_context_update_wrb *pwrb = NULL;
+	struct be_mem_descriptor *mem_descr;
+	struct beiscsi_hba *phba = beiscsi_conn->phba;
+	u32 doorbell = 0;
+
+	/*
+	 * We can always use 0 here because it is reserved by libiscsi for
+	 * login/startup related tasks.
+	 */
+	pwrb_handle = alloc_wrb_handle(phba, beiscsi_conn->beiscsi_conn_cid, 0);
+	pwrb = (struct iscsi_target_context_update_wrb *)pwrb_handle->pwrb;
+	memset(pwrb, 0, sizeof(*pwrb));
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb,
+		      max_burst_length, pwrb, params->dw[offsetof
+		      (struct amap_beiscsi_offload_params,
+		      max_burst_length) / 32]);
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb,
+		      max_send_data_segment_length, pwrb,
+		      params->dw[offsetof(struct amap_beiscsi_offload_params,
+		      max_send_data_segment_length) / 32]);
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb,
+		      first_burst_length,
+		      pwrb,
+		      params->dw[offsetof(struct amap_beiscsi_offload_params,
+		      first_burst_length) / 32]);
+
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, erl, pwrb,
+		      (params->dw[offsetof(struct amap_beiscsi_offload_params,
+		      erl) / 32] & OFFLD_PARAMS_ERL));
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, dde, pwrb,
+		      (params->dw[offsetof(struct amap_beiscsi_offload_params,
+		      dde) / 32] & OFFLD_PARAMS_DDE) >> 2);
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, hde, pwrb,
+		      (params->dw[offsetof(struct amap_beiscsi_offload_params,
+		      hde) / 32] & OFFLD_PARAMS_HDE) >> 3);
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, ir2t, pwrb,
+		      (params->dw[offsetof(struct amap_beiscsi_offload_params,
+		      ir2t) / 32] & OFFLD_PARAMS_IR2T) >> 4);
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, imd, pwrb,
+		      (params->dw[offsetof(struct amap_beiscsi_offload_params,
+		       imd) / 32] & OFFLD_PARAMS_IMD) >> 5);
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, stat_sn,
+		      pwrb,
+		      (params->dw[offsetof(struct amap_beiscsi_offload_params,
+		      exp_statsn) / 32] + 1));
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, type, pwrb,
+		      0x7);
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, wrb_idx,
+		      pwrb, pwrb_handle->wrb_index);
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, ptr2nextwrb,
+		      pwrb, pwrb_handle->nxt_wrb_index);
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb,
+			session_state, pwrb, 0);
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, compltonack,
+		      pwrb, 1);
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, notpredblq,
+		      pwrb, 0);
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, mode, pwrb,
+		      0);
+
+	mem_descr = phba->init_mem;
+	mem_descr += ISCSI_MEM_GLOBAL_HEADER;
+
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb,
+			pad_buffer_addr_hi, pwrb,
+		      mem_descr->mem_array[0].bus_address.u.a32.address_hi);
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb,
+			pad_buffer_addr_lo, pwrb,
+		      mem_descr->mem_array[0].bus_address.u.a32.address_lo);
+
+	be_dws_le_to_cpu(pwrb, sizeof(struct iscsi_target_context_update_wrb));
+
+	doorbell |= beiscsi_conn->beiscsi_conn_cid & DB_WRB_POST_CID_MASK;
+	doorbell |= (pwrb_handle->wrb_index & DB_DEF_PDU_WRB_INDEX_MASK) <<
+					DB_DEF_PDU_WRB_INDEX_SHIFT;
+	doorbell |= 1 << DB_DEF_PDU_NUM_POSTED_SHIFT;
+
+	iowrite32(doorbell, phba->db_va + DB_TXULP0_OFFSET);
+}
+
+static void beiscsi_parse_pdu(struct iscsi_conn *conn, itt_t itt,
+			      int *index, int *age)
+{
+	*index = be32_to_cpu(itt) >> 16;
+	if (age)
+		*age = conn->session->age;
+}
+
+/**
+ * beiscsi_alloc_pdu - allocates pdu and related resources
+ * @task: libiscsi task
+ * @opcode: opcode of pdu for task
+ *
+ * This is called with the session lock held. It will allocate
+ * the wrb and sgl if needed for the command. And it will prep
+ * the pdu's itt. beiscsi_parse_pdu will later translate
+ * the pdu itt to the libiscsi task itt.
+ */
+static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
+{
+	struct beiscsi_io_task *io_task = task->dd_data;
+	struct iscsi_conn *conn = task->conn;
+	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
+	struct beiscsi_hba *phba = beiscsi_conn->phba;
+	struct hwi_wrb_context *pwrb_context;
+	struct hwi_controller *phwi_ctrlr;
+	itt_t itt;
+
+	io_task->pwrb_handle = alloc_wrb_handle(phba,
+						beiscsi_conn->beiscsi_conn_cid,
+						task->itt);
+	io_task->pwrb_handle->pio_handle = task;
+	io_task->conn = beiscsi_conn;
+
+	task->hdr = (struct iscsi_hdr *)&io_task->cmd_bhs.iscsi_hdr;
+	task->hdr_max = sizeof(struct be_cmd_bhs);
+
+	if (task->sc) {
+		spin_lock(&phba->io_sgl_lock);
+		io_task->psgl_handle = alloc_io_sgl_handle(phba);
+		spin_unlock(&phba->io_sgl_lock);
+		if (!io_task->psgl_handle) {
+			phwi_ctrlr = phba->phwi_ctrlr;
+			pwrb_context = &phwi_ctrlr->wrb_context
+					[beiscsi_conn->beiscsi_conn_cid];
+			free_wrb_handle(phba, pwrb_context,
+						io_task->pwrb_handle);
+			io_task->pwrb_handle = NULL;
+			SE_DEBUG(DBG_LVL_1,
+				 "Alloc of SGL_ICD Failed \n");
+			return -ENOMEM;
+		}
+	} else {
+		io_task->scsi_cmnd = NULL;
+		if ((task->hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN) {
+			if (!beiscsi_conn->login_in_progress) {
+				spin_lock(&phba->mgmt_sgl_lock);
+				io_task->psgl_handle = (struct sgl_handle *)
+						alloc_mgmt_sgl_handle(phba);
+				spin_unlock(&phba->mgmt_sgl_lock);
+				if (!io_task->psgl_handle) {
+					phwi_ctrlr = phba->phwi_ctrlr;
+					pwrb_context =
+					&phwi_ctrlr->wrb_context
+					[beiscsi_conn->beiscsi_conn_cid];
+					free_wrb_handle(phba, pwrb_context,
+							io_task->pwrb_handle);
+					io_task->pwrb_handle = NULL;
+					SE_DEBUG(DBG_LVL_1, "Alloc of "
+						"MGMT_SGL_ICD Failed \n");
+					return -ENOMEM;
+				}
+				beiscsi_conn->login_in_progress = 1;
+				beiscsi_conn->plogin_sgl_handle =
+							io_task->psgl_handle;
+			} else {
+				io_task->psgl_handle =
+						beiscsi_conn->plogin_sgl_handle;
+			}
+		} else {
+			spin_lock(&phba->mgmt_sgl_lock);
+			io_task->psgl_handle = alloc_mgmt_sgl_handle(phba);
+			spin_unlock(&phba->mgmt_sgl_lock);
+			if (!io_task->psgl_handle) {
+				phwi_ctrlr = phba->phwi_ctrlr;
+				pwrb_context = &phwi_ctrlr->wrb_context
+					[beiscsi_conn->beiscsi_conn_cid];
+				free_wrb_handle(phba, pwrb_context,
+							io_task->pwrb_handle);
+				io_task->pwrb_handle = NULL;
+				SE_DEBUG(DBG_LVL_1, "Alloc of "
+					 "MGMT_SGL_ICD Failed \n");
+				return -ENOMEM;
+			}
+		}
+	}
+	itt = (itt_t) cpu_to_be32(((unsigned int)task->itt << 16) |
+			(unsigned int)(io_task->psgl_handle->sgl_index));
+	io_task->cmd_bhs.iscsi_hdr.itt = itt;
+	return 0;
+}
+
+static void beiscsi_cleanup_task(struct iscsi_task *task)
+{
+	struct beiscsi_io_task *io_task = task->dd_data;
+	struct iscsi_conn *conn = task->conn;
+	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
+	struct beiscsi_hba *phba = beiscsi_conn->phba;
+	struct hwi_wrb_context *pwrb_context;
+	struct hwi_controller *phwi_ctrlr;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	pwrb_context = &phwi_ctrlr->wrb_context[beiscsi_conn->beiscsi_conn_cid];
+	if (io_task->pwrb_handle) {
+		free_wrb_handle(phba, pwrb_context, io_task->pwrb_handle);
+		io_task->pwrb_handle = NULL;
+	}
+
+	if (task->sc) {
+		if (io_task->psgl_handle) {
+			spin_lock(&phba->io_sgl_lock);
+			free_io_sgl_handle(phba, io_task->psgl_handle);
+			spin_unlock(&phba->io_sgl_lock);
+			io_task->psgl_handle = NULL;
+		}
+	} else {
+		if ((task->hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN)
+			return;
+		if (io_task->psgl_handle) {
+			spin_lock(&phba->mgmt_sgl_lock);
+			free_mgmt_sgl_handle(phba, io_task->psgl_handle);
+			spin_unlock(&phba->mgmt_sgl_lock);
+			io_task->psgl_handle = NULL;
+		}
+	}
+}
+
+static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
+			  unsigned int num_sg, unsigned int xferlen,
+			  unsigned int writedir)
+{
+
+	struct beiscsi_io_task *io_task = task->dd_data;
+	struct iscsi_conn *conn = task->conn;
+	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
+	struct beiscsi_hba *phba = beiscsi_conn->phba;
+	struct iscsi_wrb *pwrb = NULL;
+	unsigned int doorbell = 0;
+
+	pwrb = io_task->pwrb_handle->pwrb;
+
+	io_task->cmd_bhs.iscsi_hdr.exp_statsn = 0;
+	io_task->bhs_len = sizeof(struct be_cmd_bhs);
+	io_task->bhs_pa.u.a64.address = virt_to_bus(&io_task->cmd_bhs);
+
+	if (writedir) {
+		SE_DEBUG(DBG_LVL_4, " WRITE Command \t");
+		memset(&io_task->cmd_bhs.iscsi_data_pdu, 0, 48);
+		AMAP_SET_BITS(struct amap_pdu_data_out, itt,
+			      &io_task->cmd_bhs.iscsi_data_pdu,
+			      (unsigned int)io_task->cmd_bhs.iscsi_hdr.itt);
+		AMAP_SET_BITS(struct amap_pdu_data_out, opcode,
+			      &io_task->cmd_bhs.iscsi_data_pdu,
+			      ISCSI_OPCODE_SCSI_DATA_OUT);
+		AMAP_SET_BITS(struct amap_pdu_data_out, final_bit,
+			      &io_task->cmd_bhs.iscsi_data_pdu, 1);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, INI_WR_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
+
+	} else {
+		SE_DEBUG(DBG_LVL_4, "READ Command \t");
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, INI_RD_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 0);
+	}
+	memcpy(&io_task->cmd_bhs.iscsi_data_pdu.
+	       dw[offsetof(struct amap_pdu_data_out, lun) / 32],
+	       io_task->cmd_bhs.iscsi_hdr.lun, sizeof(struct scsi_lun));
+
+	AMAP_SET_BITS(struct amap_iscsi_wrb, lun, pwrb,
+		      cpu_to_be16((unsigned short)io_task->cmd_bhs.iscsi_hdr.
+				  lun[0]));
+	AMAP_SET_BITS(struct amap_iscsi_wrb, r2t_exp_dtl, pwrb, xferlen);
+	AMAP_SET_BITS(struct amap_iscsi_wrb, wrb_idx, pwrb,
+		      io_task->pwrb_handle->wrb_index);
+	AMAP_SET_BITS(struct amap_iscsi_wrb, cmdsn_itt, pwrb,
+		      be32_to_cpu(task->cmdsn));
+	AMAP_SET_BITS(struct amap_iscsi_wrb, sgl_icd_idx, pwrb,
+		      io_task->psgl_handle->sgl_index);
+
+	hwi_write_sgl(pwrb, sg, num_sg, io_task);
+
+	AMAP_SET_BITS(struct amap_iscsi_wrb, ptr2nextwrb, pwrb,
+		      io_task->pwrb_handle->nxt_wrb_index);
+	be_dws_le_to_cpu(pwrb, sizeof(struct iscsi_wrb));
+
+	doorbell |= beiscsi_conn->beiscsi_conn_cid & DB_WRB_POST_CID_MASK;
+	doorbell |= (io_task->pwrb_handle->wrb_index &
+		     DB_DEF_PDU_WRB_INDEX_MASK) << DB_DEF_PDU_WRB_INDEX_SHIFT;
+	doorbell |= 1 << DB_DEF_PDU_NUM_POSTED_SHIFT;
+
+	iowrite32(doorbell, phba->db_va + DB_TXULP0_OFFSET);
+	return 0;
+}
+
+static int beiscsi_mtask(struct iscsi_task *task)
+{
+	struct beiscsi_io_task *aborted_io_task, *io_task = task->dd_data;
+	struct iscsi_conn *conn = task->conn;
+	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
+	struct beiscsi_hba *phba = beiscsi_conn->phba;
+	struct iscsi_wrb *pwrb = NULL;
+	unsigned int doorbell = 0;
+	struct iscsi_task *aborted_task;
+
+	pwrb = io_task->pwrb_handle->pwrb;
+	AMAP_SET_BITS(struct amap_iscsi_wrb, cmdsn_itt, pwrb,
+		      be32_to_cpu(task->cmdsn));
+	AMAP_SET_BITS(struct amap_iscsi_wrb, wrb_idx, pwrb,
+		      io_task->pwrb_handle->wrb_index);
+	AMAP_SET_BITS(struct amap_iscsi_wrb, sgl_icd_idx, pwrb,
+		      io_task->psgl_handle->sgl_index);
+
+	switch (task->hdr->opcode & ISCSI_OPCODE_MASK) {
+	case ISCSI_OP_LOGIN:
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, TGT_DM_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, cmdsn_itt, pwrb, 1);
+		hwi_write_buffer(pwrb, task);
+		break;
+	case ISCSI_OP_NOOP_OUT:
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, INI_RD_CMD);
+		hwi_write_buffer(pwrb, task);
+		break;
+	case ISCSI_OP_TEXT:
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, INI_WR_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
+		hwi_write_buffer(pwrb, task);
+		break;
+	case ISCSI_OP_SCSI_TMFUNC:
+		aborted_task = iscsi_itt_to_task(conn,
+					((struct iscsi_tm *)task->hdr)->rtt);
+		 if (!aborted_task)
+			return 0;
+		aborted_io_task = aborted_task->dd_data;
+		if (!aborted_io_task->scsi_cmnd)
+			return 0;
+
+		mgmt_invalidate_icds(phba,
+				     aborted_io_task->psgl_handle->sgl_index,
+				     beiscsi_conn->beiscsi_conn_cid);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, INI_TMF_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
+		hwi_write_buffer(pwrb, task);
+		break;
+	case ISCSI_OP_LOGOUT:
+		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+				HWH_TYPE_LOGOUT);
+		hwi_write_buffer(pwrb, task);
+		break;
+
+	default:
+		SE_DEBUG(DBG_LVL_1, "opcode =%d Not supported \n",
+			 task->hdr->opcode & ISCSI_OPCODE_MASK);
+		return -EINVAL;
+	}
+
+	AMAP_SET_BITS(struct amap_iscsi_wrb, r2t_exp_dtl, pwrb,
+		      be32_to_cpu(task->data_count));
+	AMAP_SET_BITS(struct amap_iscsi_wrb, ptr2nextwrb, pwrb,
+		      io_task->pwrb_handle->nxt_wrb_index);
+	be_dws_le_to_cpu(pwrb, sizeof(struct iscsi_wrb));
+
+	doorbell |= beiscsi_conn->beiscsi_conn_cid & DB_WRB_POST_CID_MASK;
+	doorbell |= (io_task->pwrb_handle->wrb_index &
+		     DB_DEF_PDU_WRB_INDEX_MASK) << DB_DEF_PDU_WRB_INDEX_SHIFT;
+	doorbell |= 1 << DB_DEF_PDU_NUM_POSTED_SHIFT;
+	iowrite32(doorbell, phba->db_va + DB_TXULP0_OFFSET);
+	return 0;
+}
+
+static int beiscsi_task_xmit(struct iscsi_task *task)
+{
+	struct iscsi_conn *conn = task->conn;
+	struct beiscsi_io_task *io_task = task->dd_data;
+	struct scsi_cmnd *sc = task->sc;
+	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
+	struct scatterlist *sg;
+	int num_sg;
+	unsigned int  writedir = 0, xferlen = 0;
+
+	SE_DEBUG(DBG_LVL_4, "\n cid=%d In beiscsi_task_xmit task=%p conn=%p \t"
+		 "beiscsi_conn=%p \n", beiscsi_conn->beiscsi_conn_cid,
+		 task, conn, beiscsi_conn);
+	if (!sc)
+		return beiscsi_mtask(task);
+
+	io_task->scsi_cmnd = sc;
+	num_sg = scsi_dma_map(sc);
+	if (num_sg < 0) {
+		SE_DEBUG(DBG_LVL_1, " scsi_dma_map Failed\n")
+		return num_sg;
+	}
+	SE_DEBUG(DBG_LVL_4, "xferlen=0x%08x scmd=%p num_sg=%d sernum=%lu\n",
+		  (scsi_bufflen(sc)), sc, num_sg, sc->serial_number);
+	xferlen = scsi_bufflen(sc);
+	sg = scsi_sglist(sc);
+	if (sc->sc_data_direction == DMA_TO_DEVICE) {
+		writedir = 1;
+		SE_DEBUG(DBG_LVL_4, "task->imm_count=0x%08x \n",
+			 task->imm_count);
+	} else
+		writedir = 0;
+	return beiscsi_iotask(task, sg, num_sg, xferlen, writedir);
+}
+
+static void beiscsi_remove(struct pci_dev *pcidev)
+{
+	struct beiscsi_hba *phba = NULL;
+
+	phba = (struct beiscsi_hba *)pci_get_drvdata(pcidev);
+	if (!phba) {
+		dev_err(&pcidev->dev, "beiscsi_remove called with no phba \n");
+		return;
+	}
+
+	hwi_disable_intr(phba);
+	if (phba->pcidev->irq)
+		free_irq(phba->pcidev->irq, phba);
+	destroy_workqueue(phba->wq);
+	if (blk_iopoll_enabled)
+		blk_iopoll_disable(&phba->iopoll);
+
+	beiscsi_clean_port(phba);
+	beiscsi_free_mem(phba);
+	beiscsi_unmap_pci_function(phba);
+	pci_free_consistent(phba->pcidev,
+			    phba->ctrl.mbox_mem_alloced.size,
+			    phba->ctrl.mbox_mem_alloced.va,
+			    phba->ctrl.mbox_mem_alloced.dma);
+	iscsi_host_remove(phba->shost);
+	pci_dev_put(phba->pcidev);
+	iscsi_host_free(phba->shost);
+}
+
+static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
+				const struct pci_device_id *id)
+{
+	struct beiscsi_hba *phba = NULL;
+	int ret;
+
+	ret = beiscsi_enable_pci(pcidev);
+	if (ret < 0) {
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
+			     "Failed to enable pci device \n");
+		return ret;
+	}
+
+	phba = beiscsi_hba_alloc(pcidev);
+	if (!phba) {
+		dev_err(&pcidev->dev, "beiscsi_dev_probe-"
+			" Failed in beiscsi_hba_alloc \n");
+		goto disable_pci;
+	}
+
+	pci_set_drvdata(pcidev, phba);
+	ret = be_ctrl_init(phba, pcidev);
+	if (ret) {
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
+				"Failed in be_ctrl_init\n");
+		goto hba_free;
+	}
+
+	spin_lock_init(&phba->io_sgl_lock);
+	spin_lock_init(&phba->mgmt_sgl_lock);
+	spin_lock_init(&phba->isr_lock);
+	beiscsi_get_params(phba);
+	ret = beiscsi_init_port(phba);
+	if (ret < 0) {
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
+			     "Failed in beiscsi_init_port\n");
+		goto free_port;
+	}
+
+	snprintf(phba->wq_name, sizeof(phba->wq_name), "beiscsi_q_irq%u",
+		 phba->shost->host_no);
+	phba->wq = create_singlethread_workqueue(phba->wq_name);
+	if (!phba->wq) {
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
+				"Failed to allocate work queue\n");
+		goto free_twq;
+	}
+
+	INIT_WORK(&phba->work_cqs, beiscsi_process_all_cqs);
+
+	if (blk_iopoll_enabled) {
+		blk_iopoll_init(&phba->iopoll, be_iopoll_budget, be_iopoll);
+		blk_iopoll_enable(&phba->iopoll);
+	}
+
+	ret = beiscsi_init_irqs(phba);
+	if (ret < 0) {
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
+			     "Failed to beiscsi_init_irqs\n");
+		goto free_blkenbld;
+	}
+	ret = hwi_enable_intr(phba);
+	if (ret < 0) {
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
+			     "Failed to hwi_enable_intr\n");
+		goto free_ctrlr;
+	}
+
+	SE_DEBUG(DBG_LVL_8, "\n\n\n SUCCESS - DRIVER LOADED \n\n\n");
+	return 0;
+
+free_ctrlr:
+	if (phba->pcidev->irq)
+		free_irq(phba->pcidev->irq, phba);
+free_blkenbld:
+	destroy_workqueue(phba->wq);
+	if (blk_iopoll_enabled)
+		blk_iopoll_disable(&phba->iopoll);
+free_twq:
+	beiscsi_clean_port(phba);
+	beiscsi_free_mem(phba);
+free_port:
+	pci_free_consistent(phba->pcidev,
+			    phba->ctrl.mbox_mem_alloced.size,
+			    phba->ctrl.mbox_mem_alloced.va,
+			   phba->ctrl.mbox_mem_alloced.dma);
+	beiscsi_unmap_pci_function(phba);
+hba_free:
+	iscsi_host_remove(phba->shost);
+	pci_dev_put(phba->pcidev);
+	iscsi_host_free(phba->shost);
+disable_pci:
+	pci_disable_device(pcidev);
+	return ret;
+}
+
+struct iscsi_transport beiscsi_iscsi_transport = {
+	.owner = THIS_MODULE,
+	.name = DRV_NAME,
+	.caps = CAP_RECOVERY_L0 | CAP_HDRDGST |
+		CAP_MULTI_R2T | CAP_DATADGST | CAP_DATA_PATH_OFFLOAD,
+	.param_mask = ISCSI_MAX_RECV_DLENGTH |
+		ISCSI_MAX_XMIT_DLENGTH |
+		ISCSI_HDRDGST_EN |
+		ISCSI_DATADGST_EN |
+		ISCSI_INITIAL_R2T_EN |
+		ISCSI_MAX_R2T |
+		ISCSI_IMM_DATA_EN |
+		ISCSI_FIRST_BURST |
+		ISCSI_MAX_BURST |
+		ISCSI_PDU_INORDER_EN |
+		ISCSI_DATASEQ_INORDER_EN |
+		ISCSI_ERL |
+		ISCSI_CONN_PORT |
+		ISCSI_CONN_ADDRESS |
+		ISCSI_EXP_STATSN |
+		ISCSI_PERSISTENT_PORT |
+		ISCSI_PERSISTENT_ADDRESS |
+		ISCSI_TARGET_NAME | ISCSI_TPGT |
+		ISCSI_USERNAME | ISCSI_PASSWORD |
+		ISCSI_USERNAME_IN | ISCSI_PASSWORD_IN |
+		ISCSI_FAST_ABORT | ISCSI_ABORT_TMO |
+		ISCSI_LU_RESET_TMO |
+		ISCSI_PING_TMO | ISCSI_RECV_TMO |
+		ISCSI_IFACE_NAME | ISCSI_INITIATOR_NAME,
+	.host_param_mask = ISCSI_HOST_HWADDRESS | ISCSI_HOST_IPADDRESS |
+				ISCSI_HOST_INITIATOR_NAME,
+	.create_session = beiscsi_session_create,
+	.destroy_session = iscsi_session_teardown,
+	.create_conn = beiscsi_conn_create,
+	.bind_conn = beiscsi_conn_bind,
+	.destroy_conn = iscsi_conn_teardown,
+	.set_param = beiscsi_set_param,
+	.get_conn_param = beiscsi_conn_get_param,
+	.get_session_param = iscsi_session_get_param,
+	.get_host_param = beiscsi_get_host_param,
+	.start_conn = beiscsi_conn_start,
+	.stop_conn = beiscsi_conn_stop,
+	.send_pdu = iscsi_conn_send_pdu,
+	.xmit_task = beiscsi_task_xmit,
+	.cleanup_task = beiscsi_cleanup_task,
+	.alloc_pdu = beiscsi_alloc_pdu,
+	.parse_pdu_itt = beiscsi_parse_pdu,
+	.get_stats = beiscsi_conn_get_stats,
+	.ep_connect = beiscsi_ep_connect,
+	.ep_poll = beiscsi_ep_poll,
+	.ep_disconnect = beiscsi_ep_disconnect,
+	.session_recovery_timedout = iscsi_session_recovery_timedout,
+};
+
+static struct pci_driver beiscsi_pci_driver = {
+	.name = DRV_NAME,
+	.probe = beiscsi_dev_probe,
+	.remove = beiscsi_remove,
+	.id_table = beiscsi_pci_id_table
+};
+
+static int __init beiscsi_module_init(void)
+{
+	int ret;
+
+	beiscsi_scsi_transport =
+			iscsi_register_transport(&beiscsi_iscsi_transport);
+	if (!beiscsi_scsi_transport) {
+		SE_DEBUG(DBG_LVL_1,
+			 "beiscsi_module_init - Unable to  register beiscsi"
+			 "transport.\n");
+		ret = -ENOMEM;
+	}
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_module_init, tt=%p \n",
+		 &beiscsi_iscsi_transport);
+
+	ret = pci_register_driver(&beiscsi_pci_driver);
+	if (ret) {
+		SE_DEBUG(DBG_LVL_1,
+			 "beiscsi_module_init - Unable to  register"
+			 "beiscsi pci driver.\n");
+		goto unregister_iscsi_transport;
+	}
+	return 0;
+
+unregister_iscsi_transport:
+	iscsi_unregister_transport(&beiscsi_iscsi_transport);
+	return ret;
+}
+
+static void __exit beiscsi_module_exit(void)
+{
+	pci_unregister_driver(&beiscsi_pci_driver);
+	iscsi_unregister_transport(&beiscsi_iscsi_transport);
+}
+
+module_init(beiscsi_module_init);
+module_exit(beiscsi_module_exit);
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
new file mode 100644
index 0000000..2c5022e
--- /dev/null
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -0,0 +1,832 @@
+/**
+ * Copyright (C) 2005 - 2009 ServerEngines
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.  The full GNU General
+ * Public License is included in this distribution in the file called COPYING.
+ *
+ * Written by: Jayamohan Kallickal (jayamohank@serverengines.com)
+ *
+ * Contact Information:
+ * linux-drivers@serverengines.com
+ *
+ * ServerEngines
+ * 209 N. Fair Oaks Ave
+ * Sunnyvale, CA 94085
+ *
+ */
+
+#ifndef _BEISCSI_MAIN_
+#define _BEISCSI_MAIN_
+
+
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/in.h>
+#include <linux/blk-iopoll.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/iscsi_proto.h>
+#include <scsi/libiscsi.h>
+#include <scsi/scsi_transport_iscsi.h>
+
+#include "be.h"
+
+
+
+#define DRV_NAME		"be2iscsi"
+#define BUILD_STR		"2.0.527.0"
+
+#define BE_NAME			"ServerEngines BladeEngine2" \
+				"Linux iSCSI Driver version" BUILD_STR
+#define DRV_DESC		BE_NAME " " "Driver"
+
+#define BE_VENDOR_ID 		0x19A2
+#define BE_DEVICE_ID1		0x212
+#define OC_DEVICE_ID1		0x702
+#define OC_DEVICE_ID2		0x703
+
+#define BE2_MAX_SESSIONS	64
+#define BE2_CMDS_PER_CXN	128
+#define BE2_LOGOUTS		BE2_MAX_SESSIONS
+#define BE2_TMFS		16
+#define BE2_NOPOUT_REQ		16
+#define BE2_ASYNCPDUS		BE2_MAX_SESSIONS
+#define BE2_MAX_ICDS		2048
+#define BE2_SGE			32
+#define BE2_DEFPDU_HDR_SZ	64
+#define BE2_DEFPDU_DATA_SZ	8192
+#define BE2_IO_DEPTH \
+	(BE2_MAX_ICDS / 2 - (BE2_LOGOUTS + BE2_TMFS + BE2_NOPOUT_REQ))
+
+#define BEISCSI_SGLIST_ELEMENTS	BE2_SGE
+
+#define BEISCSI_MAX_CMNDS	1024	/* Max IO's per Ctrlr sht->can_queue */
+#define BEISCSI_CMD_PER_LUN	128	/* scsi_host->cmd_per_lun */
+#define BEISCSI_MAX_SECTORS	2048	/* scsi_host->max_sectors */
+
+#define BEISCSI_MAX_CMD_LEN	16	/* scsi_host->max_cmd_len */
+#define BEISCSI_NUM_MAX_LUN	256	/* scsi_host->max_lun */
+#define BEISCSI_NUM_DEVICES_SUPPORTED	0x01
+#define BEISCSI_MAX_FRAGS_INIT	192
+#define BE_NUM_MSIX_ENTRIES 	1
+#define MPU_EP_SEMAPHORE 	0xac
+
+#define BE_SENSE_INFO_SIZE		258
+#define BE_ISCSI_PDU_HEADER_SIZE	64
+#define BE_MIN_MEM_SIZE			16384
+
+#define IIOC_SCSI_DATA                  0x05	/* Write Operation */
+
+#define DBG_LVL				0x00000001
+#define DBG_LVL_1			0x00000001
+#define DBG_LVL_2			0x00000002
+#define DBG_LVL_3			0x00000004
+#define DBG_LVL_4			0x00000008
+#define DBG_LVL_5			0x00000010
+#define DBG_LVL_6			0x00000020
+#define DBG_LVL_7			0x00000040
+#define DBG_LVL_8			0x00000080
+
+#define SE_DEBUG(debug_mask, fmt, args...)		\
+do {							\
+	if (debug_mask & DBG_LVL) {			\
+		printk(KERN_ERR "(%s():%d):", __func__, __LINE__);\
+		printk(fmt, ##args);			\
+	}						\
+} while (0);
+
+/**
+ * hardware needs the async PDU buffers to be posted in multiples of 8
+ * So have atleast 8 of them by default
+ */
+
+#define HWI_GET_ASYNC_PDU_CTX(phwi)	(phwi->phwi_ctxt->pasync_ctx)
+
+/********* Memory BAR register ************/
+#define PCICFG_MEMBAR_CTRL_INT_CTRL_OFFSET 	0xfc
+/**
+ * Host Interrupt Enable, if set interrupts are enabled although "PCI Interrupt
+ * Disable" may still globally block interrupts in addition to individual
+ * interrupt masks; a mechanism for the device driver to block all interrupts
+ * atomically without having to arbitrate for the PCI Interrupt Disable bit
+ * with the OS.
+ */
+#define MEMBAR_CTRL_INT_CTRL_HOSTINTR_MASK	(1 << 29)	/* bit 29 */
+
+/********* ISR0 Register offset **********/
+#define CEV_ISR0_OFFSET 			0xC18
+#define CEV_ISR_SIZE				4
+
+/**
+ * Macros for reading/writing a protection domain or CSR registers
+ * in BladeEngine.
+ */
+
+#define DB_TXULP0_OFFSET 0x40
+#define DB_RXULP0_OFFSET 0xA0
+/********* Event Q door bell *************/
+#define DB_EQ_OFFSET			DB_CQ_OFFSET
+#define DB_EQ_RING_ID_MASK		0x1FF	/* bits 0 - 8 */
+/* Clear the interrupt for this eq */
+#define DB_EQ_CLR_SHIFT			(9)	/* bit 9 */
+/* Must be 1 */
+#define DB_EQ_EVNT_SHIFT		(10)	/* bit 10 */
+/* Number of event entries processed */
+#define DB_EQ_NUM_POPPED_SHIFT		(16)	/* bits 16 - 28 */
+/* Rearm bit */
+#define DB_EQ_REARM_SHIFT		(29)	/* bit 29 */
+
+/********* Compl Q door bell *************/
+#define DB_CQ_OFFSET 			0x120
+#define DB_CQ_RING_ID_MASK		0x3FF	/* bits 0 - 9 */
+/* Number of event entries processed */
+#define DB_CQ_NUM_POPPED_SHIFT		(16) 	/* bits 16 - 28 */
+/* Rearm bit */
+#define DB_CQ_REARM_SHIFT		(29) 	/* bit 29 */
+
+#define GET_HWI_CONTROLLER_WS(pc)	(pc->phwi_ctrlr)
+#define HWI_GET_DEF_BUFQ_ID(pc) (((struct hwi_controller *)\
+		(GET_HWI_CONTROLLER_WS(pc)))->default_pdu_data.id)
+#define HWI_GET_DEF_HDRQ_ID(pc) (((struct hwi_controller *)\
+		(GET_HWI_CONTROLLER_WS(pc)))->default_pdu_hdr.id)
+
+#define PAGES_REQUIRED(x) \
+	((x < PAGE_SIZE) ? 1 :  ((x + PAGE_SIZE - 1) / PAGE_SIZE))
+
+enum be_mem_enum {
+	HWI_MEM_ADDN_CONTEXT,
+	HWI_MEM_CQ,
+	HWI_MEM_EQ,
+	HWI_MEM_WRB,
+	HWI_MEM_WRBH,
+	HWI_MEM_SGLH,	/* 5 */
+	HWI_MEM_SGE,
+	HWI_MEM_ASYNC_HEADER_BUF,
+	HWI_MEM_ASYNC_DATA_BUF,
+	HWI_MEM_ASYNC_HEADER_RING,
+	HWI_MEM_ASYNC_DATA_RING,	/* 10 */
+	HWI_MEM_ASYNC_HEADER_HANDLE,
+	HWI_MEM_ASYNC_DATA_HANDLE,
+	HWI_MEM_ASYNC_PDU_CONTEXT,
+	ISCSI_MEM_GLOBAL_HEADER,
+	SE_MEM_MAX  	/* 15 */
+};
+
+struct be_bus_address32 {
+	unsigned int address_lo;
+	unsigned int address_hi;
+};
+
+struct be_bus_address64 {
+	unsigned long long address;
+};
+
+struct be_bus_address {
+	union {
+		struct be_bus_address32 a32;
+		struct be_bus_address64 a64;
+	} u;
+};
+
+struct mem_array {
+	struct be_bus_address bus_address;	/* Bus address of location */
+	void *virtual_address;		/* virtual address to the location */
+	unsigned int size;		/* Size required by memory block */
+};
+
+struct be_mem_descriptor {
+	unsigned int index;	/* Index of this memory parameter */
+	unsigned int category;	/* type indicates cached/non-cached */
+	unsigned int num_elements;	/* number of elements in this
+					 * descriptor
+					 */
+	unsigned int alignment_mask;	/* Alignment mask for this block */
+	unsigned int size_in_bytes;	/* Size required by memory block */
+	struct mem_array *mem_array;
+};
+
+struct sgl_handle {
+	unsigned int sgl_index;
+	struct iscsi_sge *pfrag;
+};
+
+struct hba_parameters {
+	unsigned int ios_per_ctrl;
+	unsigned int cxns_per_ctrl;
+	unsigned int asyncpdus_per_ctrl;
+	unsigned int icds_per_ctrl;
+	unsigned int num_sge_per_io;
+	unsigned int defpdu_hdr_sz;
+	unsigned int defpdu_data_sz;
+	unsigned int num_cq_entries;
+	unsigned int num_eq_entries;
+	unsigned int wrbs_per_cxn;
+	unsigned int crashmode;
+	unsigned int hba_num;
+
+	unsigned int mgmt_ws_sz;
+	unsigned int hwi_ws_sz;
+
+	unsigned int eto;
+	unsigned int ldto;
+
+	unsigned int dbg_flags;
+	unsigned int num_cxn;
+
+	unsigned int eq_timer;
+	/**
+	 * These are calculated from other params. They're here
+	 * for debug purposes
+	 */
+	unsigned int num_mcc_pages;
+	unsigned int num_mcc_cq_pages;
+	unsigned int num_cq_pages;
+	unsigned int num_eq_pages;
+
+	unsigned int num_async_pdu_buf_pages;
+	unsigned int num_async_pdu_buf_sgl_pages;
+	unsigned int num_async_pdu_buf_cq_pages;
+
+	unsigned int num_async_pdu_hdr_pages;
+	unsigned int num_async_pdu_hdr_sgl_pages;
+	unsigned int num_async_pdu_hdr_cq_pages;
+
+	unsigned int num_sge;
+};
+
+struct beiscsi_hba {
+	struct hba_parameters params;
+	struct hwi_controller *phwi_ctrlr;
+	unsigned int mem_req[SE_MEM_MAX];
+	/* PCI BAR mapped addresses */
+	u8 __iomem *csr_va;	/* CSR */
+	u8 __iomem *db_va;	/* Door  Bell  */
+	u8 __iomem *pci_va;	/* PCI Config */
+	struct be_bus_address csr_pa;	/* CSR */
+	struct be_bus_address db_pa;	/* CSR */
+	struct be_bus_address pci_pa;	/* CSR */
+	/* PCI representation of our HBA */
+	struct pci_dev *pcidev;
+	unsigned int state;
+	unsigned short asic_revision;
+	struct blk_iopoll	iopoll;
+	struct be_mem_descriptor *init_mem;
+
+	unsigned short io_sgl_alloc_index;
+	unsigned short io_sgl_free_index;
+	unsigned short io_sgl_hndl_avbl;
+	struct sgl_handle **io_sgl_hndl_base;
+
+	unsigned short eh_sgl_alloc_index;
+	unsigned short eh_sgl_free_index;
+	unsigned short eh_sgl_hndl_avbl;
+	struct sgl_handle **eh_sgl_hndl_base;
+	spinlock_t io_sgl_lock;
+	spinlock_t mgmt_sgl_lock;
+	spinlock_t isr_lock;
+	unsigned int age;
+	unsigned short avlbl_cids;
+	unsigned short cid_alloc;
+	unsigned short cid_free;
+	struct beiscsi_conn *conn_table[BE2_MAX_SESSIONS * 2];
+	struct list_head hba_queue;
+	unsigned short *cid_array;
+	struct iscsi_endpoint **ep_array;
+	struct Scsi_Host *shost;
+	struct {
+		/**
+		 * group together since they are used most frequently
+		 * for cid to cri conversion
+		 */
+		unsigned int iscsi_cid_start;
+		unsigned int phys_port;
+
+		unsigned int isr_offset;
+		unsigned int iscsi_icd_start;
+		unsigned int iscsi_cid_count;
+		unsigned int iscsi_icd_count;
+		unsigned int pci_function;
+
+		unsigned short cid_alloc;
+		unsigned short cid_free;
+		unsigned short avlbl_cids;
+		spinlock_t cid_lock;
+	} fw_config;
+
+	u8 mac_address[ETH_ALEN];
+	unsigned short todo_cq;
+	unsigned short todo_mcc_cq;
+	char wq_name[20];
+	struct workqueue_struct *wq;	/* The actuak work queue */
+	struct work_struct work_cqs;	/* The work being queued */
+	struct be_ctrl_info ctrl;
+};
+
+/**
+ * struct beiscsi_conn - iscsi connection structure
+ */
+struct beiscsi_conn {
+	struct iscsi_conn *conn;
+	struct beiscsi_hba *phba;
+	u32 exp_statsn;
+	u32 beiscsi_conn_cid;
+	struct beiscsi_endpoint *ep;
+	unsigned short login_in_progress;
+	struct sgl_handle *plogin_sgl_handle;
+};
+
+/* This structure is used by the chip */
+struct pdu_data_out {
+	u32 dw[12];
+};
+/**
+ * Pseudo amap definition in which each bit of the actual structure is defined
+ * as a byte: used to calculate offset/shift/mask of each field
+ */
+struct amap_pdu_data_out {
+	u8 opcode[6];		/* opcode */
+	u8 rsvd0[2];		/* should be 0 */
+	u8 rsvd1[7];
+	u8 final_bit;		/* F bit */
+	u8 rsvd2[16];
+	u8 ahs_length[8];	/* no AHS */
+	u8 data_len_hi[8];
+	u8 data_len_lo[16];	/* DataSegmentLength */
+	u8 lun[64];
+	u8 itt[32];		/* ITT; initiator task tag */
+	u8 ttt[32];		/* TTT; valid for R2T or 0xffffffff */
+	u8 rsvd3[32];
+	u8 exp_stat_sn[32];
+	u8 rsvd4[32];
+	u8 data_sn[32];
+	u8 buffer_offset[32];
+	u8 rsvd5[32];
+};
+
+struct be_cmd_bhs {
+	struct iscsi_cmd iscsi_hdr;
+	unsigned char pad1[16];
+	struct pdu_data_out iscsi_data_pdu;
+	unsigned char pad2[BE_SENSE_INFO_SIZE -
+			sizeof(struct pdu_data_out)];
+};
+
+struct beiscsi_io_task {
+	struct wrb_handle *pwrb_handle;
+	struct sgl_handle *psgl_handle;
+	struct beiscsi_conn *conn;
+	struct scsi_cmnd *scsi_cmnd;
+	unsigned int cmd_sn;
+	unsigned int flags;
+	unsigned short cid;
+	unsigned short header_len;
+
+	struct be_cmd_bhs cmd_bhs;
+	struct be_bus_address bhs_pa;
+	unsigned short bhs_len;
+};
+
+struct be_nonio_bhs {
+	struct iscsi_hdr iscsi_hdr;
+	unsigned char pad1[16];
+	struct pdu_data_out iscsi_data_pdu;
+	unsigned char pad2[BE_SENSE_INFO_SIZE -
+			sizeof(struct pdu_data_out)];
+};
+
+struct be_status_bhs {
+	struct iscsi_cmd iscsi_hdr;
+	unsigned char pad1[16];
+	/**
+	 * The plus 2 below is to hold the sense info length that gets
+	 * DMA'ed by RxULP
+	 */
+	unsigned char sense_info[BE_SENSE_INFO_SIZE];
+};
+
+struct iscsi_sge {
+	u32 dw[4];
+};
+
+/**
+ * Pseudo amap definition in which each bit of the actual structure is defined
+ * as a byte: used to calculate offset/shift/mask of each field
+ */
+struct amap_iscsi_sge {
+	u8 addr_hi[32];
+	u8 addr_lo[32];
+	u8 sge_offset[22];	/* DWORD 2 */
+	u8 rsvd0[9];		/* DWORD 2 */
+	u8 last_sge;		/* DWORD 2 */
+	u8 len[17];		/* DWORD 3 */
+	u8 rsvd1[15];		/* DWORD 3 */
+};
+
+struct beiscsi_offload_params {
+	u32 dw[5];
+};
+
+#define OFFLD_PARAMS_ERL	0x00000003
+#define OFFLD_PARAMS_DDE	0x00000004
+#define OFFLD_PARAMS_HDE	0x00000008
+#define OFFLD_PARAMS_IR2T	0x00000010
+#define OFFLD_PARAMS_IMD	0x00000020
+
+/**
+ * Pseudo amap definition in which each bit of the actual structure is defined
+ * as a byte: used to calculate offset/shift/mask of each field
+ */
+struct amap_beiscsi_offload_params {
+	u8 max_burst_length[32];
+	u8 max_send_data_segment_length[32];
+	u8 first_burst_length[32];
+	u8 erl[2];
+	u8 dde[1];
+	u8 hde[1];
+	u8 ir2t[1];
+	u8 imd[1];
+	u8 pad[26];
+	u8 exp_statsn[32];
+};
+
+/* void hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
+		struct beiscsi_hba *phba, struct sol_cqe *psol);*/
+
+struct async_pdu_handle {
+	struct list_head link;
+	struct be_bus_address pa;
+	void *pbuffer;
+	unsigned int consumed;
+	unsigned char index;
+	unsigned char is_header;
+	unsigned short cri;
+	unsigned long buffer_len;
+};
+
+struct hwi_async_entry {
+	struct {
+		unsigned char hdr_received;
+		unsigned char hdr_len;
+		unsigned short bytes_received;
+		unsigned int bytes_needed;
+		struct list_head list;
+	} wait_queue;
+
+	struct list_head header_busy_list;
+	struct list_head data_busy_list;
+};
+
+#define BE_MIN_ASYNC_ENTRIES 128
+
+struct hwi_async_pdu_context {
+	struct {
+		struct be_bus_address pa_base;
+		void *va_base;
+		void *ring_base;
+		struct async_pdu_handle *handle_base;
+
+		unsigned int host_write_ptr;
+		unsigned int ep_read_ptr;
+		unsigned int writables;
+
+		unsigned int free_entries;
+		unsigned int busy_entries;
+		unsigned int buffer_size;
+		unsigned int num_entries;
+
+		struct list_head free_list;
+	} async_header;
+
+	struct {
+		struct be_bus_address pa_base;
+		void *va_base;
+		void *ring_base;
+		struct async_pdu_handle *handle_base;
+
+		unsigned int host_write_ptr;
+		unsigned int ep_read_ptr;
+		unsigned int writables;
+
+		unsigned int free_entries;
+		unsigned int busy_entries;
+		unsigned int buffer_size;
+		struct list_head free_list;
+		unsigned int num_entries;
+	} async_data;
+
+	/**
+	 * This is a varying size list! Do not add anything
+	 * after this entry!!
+	 */
+	struct hwi_async_entry async_entry[BE_MIN_ASYNC_ENTRIES];
+};
+
+#define PDUCQE_CODE_MASK	0x0000003F
+#define PDUCQE_DPL_MASK		0xFFFF0000
+#define PDUCQE_INDEX_MASK	0x0000FFFF
+
+struct i_t_dpdu_cqe {
+	u32 dw[4];
+} __packed;
+
+/**
+ * Pseudo amap definition in which each bit of the actual structure is defined
+ * as a byte: used to calculate offset/shift/mask of each field
+ */
+struct amap_i_t_dpdu_cqe {
+	u8 db_addr_hi[32];
+	u8 db_addr_lo[32];
+	u8 code[6];
+	u8 cid[10];
+	u8 dpl[16];
+	u8 index[16];
+	u8 num_cons[10];
+	u8 rsvd0[4];
+	u8 final;
+	u8 valid;
+} __packed;
+
+#define CQE_VALID_MASK	0x80000000
+#define CQE_CODE_MASK	0x0000003F
+#define CQE_CID_MASK	0x0000FFC0
+
+#define EQE_VALID_MASK		0x00000001
+#define EQE_MAJORCODE_MASK	0x0000000E
+#define EQE_RESID_MASK		0xFFFF0000
+
+struct be_eq_entry {
+	u32 dw[1];
+} __packed;
+
+/**
+ * Pseudo amap definition in which each bit of the actual structure is defined
+ * as a byte: used to calculate offset/shift/mask of each field
+ */
+struct amap_eq_entry {
+	u8 valid;		/* DWORD 0 */
+	u8 major_code[3];	/* DWORD 0 */
+	u8 minor_code[12];	/* DWORD 0 */
+	u8 resource_id[16];	/* DWORD 0 */
+
+} __packed;
+
+struct cq_db {
+	u32 dw[1];
+} __packed;
+
+/**
+ * Pseudo amap definition in which each bit of the actual structure is defined
+ * as a byte: used to calculate offset/shift/mask of each field
+ */
+struct amap_cq_db {
+	u8 qid[10];
+	u8 event[1];
+	u8 rsvd0[5];
+	u8 num_popped[13];
+	u8 rearm[1];
+	u8 rsvd1[2];
+} __packed;
+
+void beiscsi_process_eq(struct beiscsi_hba *phba);
+
+
+struct iscsi_wrb {
+	u32 dw[16];
+} __packed;
+
+#define WRB_TYPE_MASK 0xF0000000
+
+/**
+ * Pseudo amap definition in which each bit of the actual structure is defined
+ * as a byte: used to calculate offset/shift/mask of each field
+ */
+struct amap_iscsi_wrb {
+	u8 lun[14];		/* DWORD 0 */
+	u8 lt;			/* DWORD 0 */
+	u8 invld;		/* DWORD 0 */
+	u8 wrb_idx[8];		/* DWORD 0 */
+	u8 dsp;			/* DWORD 0 */
+	u8 dmsg;		/* DWORD 0 */
+	u8 undr_run;		/* DWORD 0 */
+	u8 over_run;		/* DWORD 0 */
+	u8 type[4];		/* DWORD 0 */
+	u8 ptr2nextwrb[8];	/* DWORD 1 */
+	u8 r2t_exp_dtl[24];	/* DWORD 1 */
+	u8 sgl_icd_idx[12];	/* DWORD 2 */
+	u8 rsvd0[20];		/* DWORD 2 */
+	u8 exp_data_sn[32];	/* DWORD 3 */
+	u8 iscsi_bhs_addr_hi[32];	/* DWORD 4 */
+	u8 iscsi_bhs_addr_lo[32];	/* DWORD 5 */
+	u8 cmdsn_itt[32];	/* DWORD 6 */
+	u8 dif_ref_tag[32];	/* DWORD 7 */
+	u8 sge0_addr_hi[32];	/* DWORD 8 */
+	u8 sge0_addr_lo[32];	/* DWORD 9  */
+	u8 sge0_offset[22];	/* DWORD 10 */
+	u8 pbs;			/* DWORD 10 */
+	u8 dif_mode[2];		/* DWORD 10 */
+	u8 rsvd1[6];		/* DWORD 10 */
+	u8 sge0_last;		/* DWORD 10 */
+	u8 sge0_len[17];	/* DWORD 11 */
+	u8 dif_meta_tag[14];	/* DWORD 11 */
+	u8 sge0_in_ddr;		/* DWORD 11 */
+	u8 sge1_addr_hi[32];	/* DWORD 12 */
+	u8 sge1_addr_lo[32];	/* DWORD 13 */
+	u8 sge1_r2t_offset[22];	/* DWORD 14 */
+	u8 rsvd2[9];		/* DWORD 14 */
+	u8 sge1_last;		/* DWORD 14 */
+	u8 sge1_len[17];	/* DWORD 15 */
+	u8 ref_sgl_icd_idx[12];	/* DWORD 15 */
+	u8 rsvd3[2];		/* DWORD 15 */
+	u8 sge1_in_ddr;		/* DWORD 15 */
+
+} __packed;
+
+struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid,
+				    int index);
+void
+free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle);
+
+struct pdu_nop_out {
+	u32 dw[12];
+};
+
+/**
+ * Pseudo amap definition in which each bit of the actual structure is defined
+ * as a byte: used to calculate offset/shift/mask of each field
+ */
+struct amap_pdu_nop_out {
+	u8 opcode[6];		/* opcode 0x00 */
+	u8 i_bit;		/* I Bit */
+	u8 x_bit;		/* reserved; should be 0 */
+	u8 fp_bit_filler1[7];
+	u8 f_bit;		/* always 1 */
+	u8 reserved1[16];
+	u8 ahs_length[8];	/* no AHS */
+	u8 data_len_hi[8];
+	u8 data_len_lo[16];	/* DataSegmentLength */
+	u8 lun[64];
+	u8 itt[32];		/* initiator id for ping or 0xffffffff */
+	u8 ttt[32];		/* target id for ping or 0xffffffff */
+	u8 cmd_sn[32];
+	u8 exp_stat_sn[32];
+	u8 reserved5[128];
+};
+
+#define PDUBASE_OPCODE_MASK	0x0000003F
+#define PDUBASE_DATALENHI_MASK	0x0000FF00
+#define PDUBASE_DATALENLO_MASK	0xFFFF0000
+
+struct pdu_base {
+	u32 dw[16];
+} __packed;
+
+/**
+ * Pseudo amap definition in which each bit of the actual structure is defined
+ * as a byte: used to calculate offset/shift/mask of each field
+ */
+struct amap_pdu_base {
+	u8 opcode[6];
+	u8 i_bit;		/* immediate bit */
+	u8 x_bit;		/* reserved, always 0 */
+	u8 reserved1[24];	/* opcode-specific fields */
+	u8 ahs_length[8];	/* length units is 4 byte words */
+	u8 data_len_hi[8];
+	u8 data_len_lo[16];	/* DatasegmentLength */
+	u8 lun[64];		/* lun or opcode-specific fields */
+	u8 itt[32];		/* initiator task tag */
+	u8 reserved4[224];
+};
+
+struct iscsi_target_context_update_wrb {
+	u32 dw[16];
+} __packed;
+
+/**
+ * Pseudo amap definition in which each bit of the actual structure is defined
+ * as a byte: used to calculate offset/shift/mask of each field
+ */
+struct amap_iscsi_target_context_update_wrb {
+	u8 lun[14];		/* DWORD 0 */
+	u8 lt;			/* DWORD 0 */
+	u8 invld;		/* DWORD 0 */
+	u8 wrb_idx[8];		/* DWORD 0 */
+	u8 dsp;			/* DWORD 0 */
+	u8 dmsg;		/* DWORD 0 */
+	u8 undr_run;		/* DWORD 0 */
+	u8 over_run;		/* DWORD 0 */
+	u8 type[4];		/* DWORD 0 */
+	u8 ptr2nextwrb[8];	/* DWORD 1 */
+	u8 max_burst_length[19];	/* DWORD 1 */
+	u8 rsvd0[5];		/* DWORD 1 */
+	u8 rsvd1[15];		/* DWORD 2 */
+	u8 max_send_data_segment_length[17];	/* DWORD 2 */
+	u8 first_burst_length[14];	/* DWORD 3 */
+	u8 rsvd2[2];		/* DWORD 3 */
+	u8 tx_wrbindex_drv_msg[8];	/* DWORD 3 */
+	u8 rsvd3[5];		/* DWORD 3 */
+	u8 session_state[3];	/* DWORD 3 */
+	u8 rsvd4[16];		/* DWORD 4 */
+	u8 tx_jumbo;		/* DWORD 4 */
+	u8 hde;			/* DWORD 4 */
+	u8 dde;			/* DWORD 4 */
+	u8 erl[2];		/* DWORD 4 */
+	u8 domain_id[5];		/* DWORD 4 */
+	u8 mode;		/* DWORD 4 */
+	u8 imd;			/* DWORD 4 */
+	u8 ir2t;		/* DWORD 4 */
+	u8 notpredblq[2];	/* DWORD 4 */
+	u8 compltonack;		/* DWORD 4 */
+	u8 stat_sn[32];		/* DWORD 5 */
+	u8 pad_buffer_addr_hi[32];	/* DWORD 6 */
+	u8 pad_buffer_addr_lo[32];	/* DWORD 7 */
+	u8 pad_addr_hi[32];	/* DWORD 8 */
+	u8 pad_addr_lo[32];	/* DWORD 9 */
+	u8 rsvd5[32];		/* DWORD 10 */
+	u8 rsvd6[32];		/* DWORD 11 */
+	u8 rsvd7[32];		/* DWORD 12 */
+	u8 rsvd8[32];		/* DWORD 13 */
+	u8 rsvd9[32];		/* DWORD 14 */
+	u8 rsvd10[32];		/* DWORD 15 */
+
+} __packed;
+
+struct be_ring {
+	u32 pages;		/* queue size in pages */
+	u32 id;			/* queue id assigned by beklib */
+	u32 num;		/* number of elements in queue */
+	u32 cidx;		/* consumer index */
+	u32 pidx;		/* producer index -- not used by most rings */
+	u32 item_size;		/* size in bytes of one object */
+
+	void *va;		/* The virtual address of the ring.  This
+				 * should be last to allow 32 & 64 bit debugger
+				 * extensions to work.
+				 */
+};
+
+struct hwi_wrb_context {
+	struct list_head wrb_handle_list;
+	struct list_head wrb_handle_drvr_list;
+	struct wrb_handle **pwrb_handle_base;
+	struct wrb_handle **pwrb_handle_basestd;
+	struct iscsi_wrb *plast_wrb;
+	unsigned short alloc_index;
+	unsigned short free_index;
+	unsigned short wrb_handles_available;
+	unsigned short cid;
+};
+
+struct hwi_controller {
+	struct list_head io_sgl_list;
+	struct list_head eh_sgl_list;
+	struct sgl_handle *psgl_handle_base;
+	unsigned int wrb_mem_index;
+
+	struct hwi_wrb_context wrb_context[BE2_MAX_SESSIONS * 2];
+	struct mcc_wrb *pmcc_wrb_base;
+	struct be_ring default_pdu_hdr;
+	struct be_ring default_pdu_data;
+	struct hwi_context_memory *phwi_ctxt;
+	unsigned short cq_errors[CXN_KILLED_CMND_DATA_NOT_ON_SAME_CONN];
+};
+
+enum hwh_type_enum {
+	HWH_TYPE_IO = 1,
+	HWH_TYPE_LOGOUT = 2,
+	HWH_TYPE_TMF = 3,
+	HWH_TYPE_NOP = 4,
+	HWH_TYPE_IO_RD = 5,
+	HWH_TYPE_LOGIN = 11,
+	HWH_TYPE_INVALID = 0xFFFFFFFF
+};
+
+struct wrb_handle {
+	enum hwh_type_enum type;
+	unsigned short wrb_index;
+	unsigned short nxt_wrb_index;
+
+	struct iscsi_task *pio_handle;
+	struct iscsi_wrb *pwrb;
+};
+
+struct hwi_context_memory {
+	struct be_eq_obj be_eq;
+	struct be_queue_info be_cq;
+	struct be_queue_info be_mcc_cq;
+	struct be_queue_info be_mcc;
+
+	struct be_queue_info be_def_hdrq;
+	struct be_queue_info be_def_dataq;
+
+	struct be_queue_info be_wrbq[BE2_MAX_SESSIONS];
+	struct be_mcc_wrb_context *pbe_mcc_context;
+
+	struct hwi_async_pdu_context *pasync_ctx;
+};
+
+#endif
-- 
1.6.4

