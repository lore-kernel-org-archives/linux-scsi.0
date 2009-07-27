From: Jayamohan Kallickal <jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>
Subject: [PATCH 1/6] RFC: beiscsi : handles core routines
Date: Mon, 27 Jul 2009 12:55:18 -0700
Message-ID: <1248724523-10999-2-git-send-email-jayamohank@serverengines.com>
References: <1248724523-10999-1-git-send-email-jayamohank@serverengines.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1248724523-10999-1-git-send-email-jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Jayamohan Kallickal <jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


  Thie file handles initiallization/teardown, allocation/free as well
  as IO/Management flows.

Signed-off-by: Jayamohan Kallickal <jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>
---
 drivers/scsi/beiscsi/be_main.c | 3912 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 3912 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/beiscsi/be_main.c

diff --git a/drivers/scsi/beiscsi/be_main.c b/drivers/scsi/beiscsi/be_main.c
new file mode 100644
index 0000000..cd0d41d
--- /dev/null
+++ b/drivers/scsi/beiscsi/be_main.c
@@ -0,0 +1,3912 @@
+/*
+ * Copyright (C) 2005 - 2009 ServerEngines
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.  The full GNU General
+ * Public License is included in this distribution in the file called COPYING.
+ *
+ * Written by: Jayamohan Kallickal (jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org)
+ *
+ * Contact Information:
+ * linux-drivers-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org
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
+
+#include "be_main.h"
+#include "be_iscsi.h"
+#include "be_mgmt.h"
+
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
+MODULE_DESCRIPTION(DRV_DESC " " BUILD_STR);
+MODULE_AUTHOR("ServerEngines Corporation");
+MODULE_LICENSE("GPL");
+
+struct iscsi_transport beiscsi_iscsi_transport = {
+	.owner = THIS_MODULE,
+	.name = DRV_NAME,
+	.caps = CAP_RECOVERY_L0 | CAP_HDRDGST |
+		CAP_MULTI_R2T | CAP_DATADGST | CAP_DATA_PATH_OFFLOAD,
+	.param_mask = ISCSI_MAX_RECV_DLENGTH |
+	    ISCSI_MAX_XMIT_DLENGTH |
+	    ISCSI_HDRDGST_EN |
+	    ISCSI_DATADGST_EN |
+	    ISCSI_INITIAL_R2T_EN |
+	    ISCSI_MAX_R2T |
+	    ISCSI_IMM_DATA_EN |
+	    ISCSI_FIRST_BURST |
+	    ISCSI_MAX_BURST |
+	    ISCSI_PDU_INORDER_EN |
+	    ISCSI_DATASEQ_INORDER_EN |
+	    ISCSI_ERL |
+	    ISCSI_CONN_PORT |
+	    ISCSI_CONN_ADDRESS |
+	    ISCSI_EXP_STATSN |
+	    ISCSI_PERSISTENT_PORT |
+	    ISCSI_PERSISTENT_ADDRESS |
+	    ISCSI_TARGET_NAME | ISCSI_TPGT |
+	    ISCSI_USERNAME | ISCSI_PASSWORD |
+	    ISCSI_USERNAME_IN | ISCSI_PASSWORD_IN |
+	    ISCSI_FAST_ABORT | ISCSI_ABORT_TMO |
+	    ISCSI_LU_RESET_TMO |
+	    ISCSI_PING_TMO | ISCSI_RECV_TMO |
+	    ISCSI_IFACE_NAME | ISCSI_INITIATOR_NAME,
+	.host_param_mask = ISCSI_HOST_HWADDRESS | ISCSI_HOST_IPADDRESS |
+				ISCSI_HOST_INITIATOR_NAME,
+	.create_session = beiscsi_session_create,
+	.destroy_session = beiscsi_session_destroy,
+	.create_conn = beiscsi_conn_create,
+	.bind_conn = beiscsi_conn_bind,
+	.destroy_conn = beiscsi_conn_destroy,
+	.set_param = iscsi_set_param,
+	.get_conn_param = beiscsi_conn_get_param,
+	.get_session_param = iscsi_session_get_param,
+	.get_host_param = beiscsi_get_host_param,
+	.start_conn = beiscsi_conn_start,
+	.stop_conn = beiscsi_conn_stop,
+	.send_pdu = iscsi_conn_send_pdu,
+	.xmit_task = beiscsi_task_xmit,
+	.get_stats = beiscsi_conn_get_stats,
+	/* TCP connect - disconnect - option-2 interface calls */
+	.ep_connect = beiscsi_ep_connect,
+	.ep_poll = beiscsi_ep_poll,
+	.ep_disconnect = beiscsi_ep_disconnect,
+	/* Error recovery timeout call */
+	/* pdu stuff */
+	.session_recovery_timedout = iscsi_session_recovery_timedout,
+	.cleanup_task = beiscsi_cleanup_task,
+};
+
+static struct scsi_host_template beiscsi_sht = {
+	.module = THIS_MODULE,
+	.name = "ServerEngines 10Gbe open-iscsi Initiator Driver",
+	.proc_name = DRV_NAME,
+	.queuecommand = iscsi_queuecommand,
+	.eh_abort_handler = iscsi_eh_abort,
+	.eh_device_reset_handler = iscsi_eh_device_reset,
+	.eh_target_reset_handler = iscsi_eh_target_reset,
+	.sg_tablesize = BEISCSI_SGLIST_ELEMENTS,
+	.can_queue = BEISCSI_MAX_CMNDS,
+	.this_id = -1,
+	.max_sectors = 127,
+	.cmd_per_lun = BEISCSI_CMD_PER_LUN,
+	.use_clustering = ENABLE_CLUSTERING,
+};
+static struct scsi_transport_template *beiscsi_scsi_transport;
+
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
+static struct pci_driver beiscsi_pci_driver = {
+	.name = "DRV_NAME",
+	.probe = beiscsi_dev_probe,
+	.remove = beiscsi_remove,
+	.id_table = beiscsi_pci_id_table
+};
+
+struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
+{
+	struct beiscsi_hba *phba;
+	struct Scsi_Host *shost;
+
+	shost = iscsi_host_alloc(&beiscsi_sht, sizeof(*phba), 0);
+	if (!shost) {
+		dev_err(&pcidev->dev, "beiscsi_hba_alloc -"
+				"iscsi_host_alloc failed \n");
+		return NULL;
+	}
+	shost->dma_boundary = pcidev->dma_mask;
+	shost->max_id = BE2_MAX_SESSIONS;
+	shost->max_channel = 0;
+	shost->max_cmd_len = BEISCSI_MAX_CMD_LEN;
+	shost->max_lun = BEISCSI_NUM_MAX_LUN;
+	shost->transportt = beiscsi_scsi_transport;
+	shost->can_queue = BEISCSI_MAX_CMNDS;
+
+	phba = iscsi_host_priv(shost);
+	memset(phba, 0x0, sizeof(struct beiscsi_hba *));
+	phba->shost = shost;
+	pci_dev_get(pcidev);
+
+	phba->shost = shost;
+	phba->pcidev = pcidev;
+
+	if (iscsi_host_add(shost, &phba->pcidev->dev))
+		goto free_devices;
+	return phba;
+
+free_devices:
+	pci_dev_put(phba->pcidev);
+	return NULL;
+}
+
+static int be_map_pci_bars(struct beiscsi_hba *phba, struct pci_dev *pdev)
+{
+	u8 __iomem *addr;
+
+	phba->csr_va = NULL;
+	phba->db_va = NULL;
+	phba->pci_va = NULL;
+
+	addr = ioremap_nocache(pci_resource_start(pdev, 2),
+			       pci_resource_len(pdev, 2));
+	if (addr == NULL)
+		return -ENOMEM;
+	phba->ctrl.csr = addr;
+	phba->csr_va = addr;
+
+	addr = ioremap_nocache(pci_resource_start(pdev, 4), 128 * 1024);
+	if (addr == NULL)
+		goto pci_map_err;
+	phba->ctrl.db = addr;
+	phba->db_va = addr;
+
+	addr = ioremap_nocache(pci_resource_start(pdev, 1),
+			       pci_resource_len(pdev, 1));
+	if (addr == NULL)
+		goto pci_map_err;
+	phba->ctrl.pcicfg = addr;
+	phba->pci_va = addr;
+
+	return 0;
+pci_map_err:
+	beiscsi_unmap_pci_function(phba);
+	return -ENOMEM;
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
+
+	status = be_map_pci_bars(phba, pdev);
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
+int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
+				const struct pci_device_id *id)
+{
+	struct beiscsi_hba *phba = NULL;
+	int ret = -1;
+
+	ret = beiscsi_enable_pci(pcidev);
+	if (ret < 0) {
+		dev_err(&pcidev->dev, "beiscsi_dev_probe-"
+				"Failed to enable pci device \n");
+		return ret;
+	}
+
+	phba = beiscsi_hba_alloc(pcidev);
+	if (!phba) {
+		dev_err(&pcidev->dev, "beiscsi_dev_probe-"
+				" Failed in beiscsi_hba_alloc \n");
+		goto disable_pci;
+	}
+
+	pci_set_drvdata(pcidev, (void *)phba);
+
+	ret = beiscsi_init_pci_function(phba, pcidev);
+	if (ret < 0) {
+		dev_err(&pcidev->dev, "beiscsi_dev_probe-"
+				"Failed in beiscsi_init_pci_function \n");
+		goto hba_free;
+	}
+
+	ret = be_ctrl_init(phba, pcidev);
+	if (ret)
+		return -1;
+
+	spin_lock_init(&phba->sgl_lock);
+	spin_lock_init(&phba->isr_lock);
+	beiscsi_get_params(phba);
+
+	ret = beiscsi_init_port(phba);
+	if (ret < 0) {
+		dev_err(&pcidev->dev, "beiscsi_dev_probe-"
+				"Failed in beiscsi_init_port\n");
+		goto free_controller;
+	}
+
+	snprintf(phba->wq_name, sizeof(phba->wq_name), "beiscsi_queue_irqs");
+
+	phba->wq = create_singlethread_workqueue(phba->wq_name);
+	if (!phba->wq) {
+		dev_err(&pcidev->dev, "beiscsi_dev_probe-"
+				"Failed to allocate work queue\n");
+		goto free_controller;
+	}
+
+	INIT_WORK(&phba->work_cqs, beiscsi_process_all_cqs);
+	ret = beiscsi_init_irqs(phba);
+
+/*	the caller is expected to register the ISR routine already.
+ *	only the interrupts are enabled here
+ */
+	ret = hwi_enable_intr(phba);
+	if (ret < 0) {
+		dev_err(&pcidev->dev, "beiscsi_dev_probe-"
+				"Failed to hwi_enable_intr\n");
+		goto free_controller;
+	}
+
+	SE_DEBUG(DBG_LVL_8, "\n\n\n SUCCESS - DRIVER LOADED \n\n\n");
+	return 0;
+
+free_controller:
+	iscsi_host_remove(phba->shost);
+	iscsi_host_free(phba->shost);
+	beiscsi_unmap_pci_function(phba);
+hba_free:
+	pci_dev_put(phba->pcidev);
+disable_pci:
+	pci_disable_device(pcidev);
+	return ret;
+}
+
+
+int beiscsi_init_irqs(struct beiscsi_hba *phba)
+{
+
+	struct pci_dev *pcidev = phba->pcidev;
+
+	if (request_irq(pcidev->irq, be_isr, IRQF_SHARED, "beiscsi",
+				phba) != 0) {
+		dev_err(&pcidev->dev,
+				"beiscsi_init_irqs-"
+					"Failed to register irq\\n");
+		return -1;
+	}
+	return 0;
+}
+
+void beiscsi_get_params(struct beiscsi_hba *phba)
+{
+
+	phba->params.ios_per_ctrl =
+	    MAX_ICDS / 2 - (LOGOUTS + TMFS + NOPOUT_REQ);
+	phba->params.cxns_per_ctrl = BE2_MAX_SESSIONS;
+	phba->params.asyncpdus_per_ctrl = ASYNCPDUS;
+	phba->params.icds_per_ctrl = MAX_ICDS / 2;
+	phba->params.num_sge_per_io = SGE;
+	phba->params.defpdu_hdr_sz = DEFPDU_HDR_SZ;
+	phba->params.defpdu_data_sz = DEFPDU_DATA_SZ;
+	phba->params.eq_timer = 64;
+	phba->params.num_eq_entries =
+	    (((CMDS_PER_CXN * 2 + LOGOUTS + TMFS + ASYNCPDUS) / 512) + 1) * 512;
+	phba->params.num_eq_entries =
+	    (phba->params.num_eq_entries <
+	     1024) ? 1024 : phba->params.num_eq_entries;
+	SE_DEBUG(DBG_LVL_8, "phba->params.num_eq_entries=%d \n",
+		 phba->params.num_eq_entries);
+	phba->params.num_cq_entries =
+	    (((CMDS_PER_CXN * 2 + LOGOUTS + TMFS + ASYNCPDUS) / 512) + 1) * 512;
+	SE_DEBUG(DBG_LVL_8,
+		 "phba->params.num_cq_entries=%d CMDS_PER_CXN=%d LOGOUTS=%d \
+		 TMFS=%d ASYNCPDUS=%d \n", phba->params.num_cq_entries,
+		 CMDS_PER_CXN, LOGOUTS, TMFS, ASYNCPDUS);
+	phba->params.wrbs_per_cxn = 256;	/* Later to increase to 512 */
+}
+
+
+/*
+ * Function:
+ *         be_isr
+ *
+ * Parameter:
+ *         irq:    [in]    irq number
+ *         dev_id: [in]    context information
+ *         regs:   [in]    pointer to structure containing CPU registers
+ *
+ * Return:
+ *         None
+ *
+ * Context:
+ *         Interrupt
+ *
+ * Description:
+ *         This routine is the ISR of the driver. It calls be_process_irq to
+ *         handle the interrupts.
+ *
+ *
+ */
+irqreturn_t be_isr(int irq, void *dev_id)
+{
+	struct beiscsi_hba *phba = NULL;
+	struct hwi_controller_ws *phwi_controller;
+	struct hwi_context_memory *phwi_context;
+	struct be_eq_entry *eqe = NULL;
+	struct be_queue_info *eq;
+	unsigned long flags, index;
+	unsigned int num_eq_processed;
+
+	phba = (struct beiscsi_hba *)dev_id;
+	phwi_controller = GET_HWI_CONTROLLER_WS(phba);
+	phwi_context = phwi_controller->phwic;
+	spin_lock_irqsave(&phba->isr_lock, flags);
+
+	eq = &phwi_context->be_eq.q;
+	index = 0;
+	eqe = queue_tail_node(eq);
+	if (!eqe)
+		SE_DEBUG(DBG_LVL_1, "eqe is NULL\n");
+
+	num_eq_processed = 0;
+	while (eqe->
+	       dw[offsetof(struct amap_eq_entry, valid) /
+		  32] & EQE_VALID_MASK) {
+		switch ((u32)
+			(eqe->
+			 dw[offsetof(struct amap_eq_entry, major_code) /
+			    32] & EQE_MAJORCODE_MASK)) {
+		case EQ_MAJOR_CODE_COMPLETION:
+			/* Determine which CQ to process. */
+			if (((eqe->
+			      dw[offsetof(struct amap_eq_entry, resource_id) /
+				 32] & EQE_RESID_MASK) >> 16) ==
+			    phwi_context->be_cq.id) {
+				SE_DEBUG(DBG_LVL_8, "\t\t todo_cq is set\n");
+				phba->todo_cq = 1;
+			} else {
+				SE_DEBUG(DBG_LVL_1,
+					 "\t\t Invalid CQ to process\n");
+			}
+			break;
+
+		default:
+			SE_DEBUG(DBG_LVL_1,
+			 "Unexpected struct eq_entry major_code: 0x%x\n",
+			  (eqe->dw[offsetof(struct amap_eq_entry, major_code) /
+				     32] & EQE_MAJORCODE_MASK));
+		}
+
+		/* Mark this struct eq_entry as invalid */
+		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
+		queue_tail_inc(eq);
+		eqe = queue_tail_node(eq);
+
+		num_eq_processed++;
+	}
+	spin_unlock_irqrestore(&phba->isr_lock, flags);
+	queue_work(phba->wq, &phba->work_cqs);
+	hwi_ring_eq_db(phba, phwi_context->be_eq.q.id, 0,
+			/* clear interrupt */
+			num_eq_processed, 1, 1);
+	return IRQ_HANDLED;
+}
+
+void beiscsi_process_all_cqs(struct work_struct *work)
+{
+	unsigned long flags;
+	struct hwi_controller_ws *phwi_controller;
+
+	struct beiscsi_hba *phba =
+	    container_of(work, struct beiscsi_hba, work_cqs);
+	phwi_controller = GET_HWI_CONTROLLER_WS(phba);
+
+	if (phba->todo_cq == 1) {
+		spin_lock_irqsave(&phba->isr_lock, flags);
+		phba->todo_cq = 0;
+		spin_unlock_irqrestore(&phba->isr_lock, flags);
+		beiscsi_process_cq(phba);
+	}
+}
+
+
+int beiscsi_init_pci_function(struct beiscsi_hba *phba, struct pci_dev *pcidev)
+{
+	u64 pa;
+
+	/* CSR */
+	pa = pci_resource_start(pcidev, 2);
+	phba->csr_pa.u.a64.address = pa;
+
+	/* Door Bell */
+	pa = pci_resource_start(pcidev, 4);
+	phba->db_pa.u.a64.address = pa;
+
+	/* PCI */
+	pa = pci_resource_start(pcidev, 1);
+	phba->pci_pa.u.a64.address = pa;
+	return 0;
+}
+
+void beiscsi_unmap_pci_function(struct beiscsi_hba *phba)
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
+	return;
+}
+
+
+int beiscsi_enable_pci(struct pci_dev *pcidev)
+{
+
+	if (pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(64))) {
+		if (pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(32))) {
+			dev_err(&pcidev->dev, "Could not set PCI DMA Mask\n");
+			return -ENODEV;
+		}
+	}
+
+	if (pci_enable_device(pcidev)) {
+		dev_err(&pcidev->dev, "beiscsi_enable_pci - enable device "
+			"failed. Returning -ENODEV\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+/* initialization */
+static struct beiscsi_conn *beiscsi_conn_frm_cid(struct beiscsi_hba *phba,
+					  unsigned int cid)
+{
+	if (phba->conn_table[cid]) {
+		return phba->conn_table[cid];
+	} else {
+		dev_err(&phba->pcidev->dev, "Connection table empty\n");
+		return NULL;
+	}
+}
+
+/* Under host lock */
+static struct sgl_handle *alloc_io_sgl_handle(struct beiscsi_hba *phba)
+{
+	struct sgl_handle *psgl_handle;
+
+	if (phba->io_sgl_handles_available) {
+		SE_DEBUG(DBG_LVL_8,
+			 "In alloc_io_sgl_handle,io_sgl_alloc_index=%d \n",
+			 phba->io_sgl_alloc_index);
+		psgl_handle =
+		    (struct sgl_handle *)phba->io_sgl_handle_base[phba->
+						io_sgl_alloc_index];
+		phba->io_sgl_handle_base[phba->io_sgl_alloc_index] = NULL;
+		phba->io_sgl_handles_available--;
+		if (phba->io_sgl_alloc_index == (phba->params.ios_per_ctrl - 1))
+			phba->io_sgl_alloc_index = 0;
+		else
+			phba->io_sgl_alloc_index++;
+	} else
+		psgl_handle = NULL;
+	return psgl_handle;
+}
+
+/*  Under host lock */
+static void
+free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
+{
+	SE_DEBUG(DBG_LVL_8, "In free_io_sgl_handle ,io_sgl_free_index=%d \n",
+		 phba->io_sgl_free_index);
+	if (phba->io_sgl_handle_base[phba->io_sgl_free_index]) {
+		SE_DEBUG(DBG_LVL_8,
+			 "Double Free in IO SGL io_sgl_free_index=%d,"
+			 "value there=%p \n", phba->io_sgl_free_index,
+			 phba->io_sgl_handle_base[phba->io_sgl_free_index]);
+		return;
+	}
+	phba->io_sgl_handle_base[phba->io_sgl_free_index] =
+	    (struct sgl_handle *)psgl_handle;
+	phba->io_sgl_handles_available++;
+	if (phba->io_sgl_free_index == (phba->params.ios_per_ctrl - 1))
+		phba->io_sgl_free_index = 0;
+	else
+		phba->io_sgl_free_index++;
+}
+
+/* This happens under session_lock untill submission to chip */
+struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid)
+{
+	struct hwi_wrb_context *pwrb_context;
+	struct hwi_controller_ws *phwi_controller;
+	struct wrb_handle *pwrb_handle;
+	struct wrb_handle *pwrb_handle_tmp;
+
+	phwi_controller = GET_HWI_CONTROLLER_WS(phba);
+	pwrb_context = &phwi_controller->wrb_context[cid];
+	SE_DEBUG(DBG_LVL_8, "cid=%d pwrb_context=%p \n", cid, pwrb_context);
+
+	if (pwrb_context->wrb_handles_available) {
+		pwrb_handle =
+		    (struct wrb_handle *)pwrb_context->
+		    pwrb_handle_base[pwrb_context->alloc_index];
+		pwrb_context->wrb_handles_available--;
+		if (pwrb_context->alloc_index ==
+		    (phba->params.wrbs_per_cxn - 1)) {
+			pwrb_context->alloc_index = 0;
+		} else
+			pwrb_context->alloc_index++;
+
+		pwrb_handle_tmp =
+		    (struct wrb_handle *)pwrb_context->
+		    pwrb_handle_base[pwrb_context->alloc_index];
+		pwrb_handle_tmp->nxt_wrb_index = pwrb_handle_tmp->wrb_index;
+	} else
+		pwrb_handle = NULL;
+	return pwrb_handle;
+}
+
+/* Happens under session_lock  */
+static void
+free_wrb_handle(struct beiscsi_hba *phba, struct hwi_wrb_context *pwrb_context,
+		struct wrb_handle *pwrb_handle)
+{
+
+	pwrb_context->pwrb_handle_base[pwrb_context->free_index] = pwrb_handle;
+	pwrb_context->wrb_handles_available++;
+	if (pwrb_context->free_index == (phba->params.wrbs_per_cxn - 1))
+		pwrb_context->free_index = 0;
+	else
+		pwrb_context->free_index++;
+	SE_DEBUG(DBG_LVL_8,
+		 "FREE WRB: pwrb_handle=%p free_index=%d=0x%x"
+		 "wrb_handles_available=%d \n",
+		 pwrb_handle, pwrb_context->free_index,
+		 pwrb_context->free_index, pwrb_context->wrb_handles_available);
+
+}
+
+/* Under host lock */
+static struct sgl_handle *alloc_eh_sgl_handle(struct beiscsi_hba *phba)
+{
+	struct sgl_handle *psgl_handle;
+
+	if (phba->eh_sgl_handles_available) {
+		psgl_handle =
+		    (struct sgl_handle *)phba->eh_sgl_handle_base[phba->
+							 eh_sgl_alloc_index];
+		phba->eh_sgl_handle_base[phba->eh_sgl_alloc_index] = NULL;
+		SE_DEBUG(DBG_LVL_8, "eh_sgl_alloc_index=%d=0x%x \n",
+			 phba->eh_sgl_alloc_index, phba->eh_sgl_alloc_index);
+		phba->eh_sgl_handles_available--;
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
+/*  Under host lock */
+void
+free_eh_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
+{
+
+	if (phba->eh_sgl_handle_base[phba->eh_sgl_free_index]) {
+		dev_warn(&phba->pcidev->dev,
+			 "Double Free in eh SGL ,eh_sgl_free_index=%d \n",
+			 phba->eh_sgl_free_index);
+		return;
+	}
+	phba->eh_sgl_handle_base[phba->eh_sgl_free_index] =
+	    (struct sgl_handle *)psgl_handle;
+	phba->eh_sgl_handles_available++;
+	if (phba->eh_sgl_free_index ==
+	    (phba->params.icds_per_ctrl - phba->params.ios_per_ctrl - 1))
+		phba->eh_sgl_free_index = 0;
+	else
+		phba->eh_sgl_free_index++;
+}
+
+static struct list_head *hwi_get_async_busy_list(struct hwi_async_pdu_context
+					  *pasync_ctx, unsigned int is_header,
+					  unsigned int host_write_ptr)
+{
+	if (is_header) {
+		return &pasync_ctx->async_entry[host_write_ptr].
+		    header_busy_list;
+	} else {
+		return &pasync_ctx->async_entry[host_write_ptr].data_busy_list;
+	}
+}
+
+static struct async_pdu_handle *hwi_get_async_handle(struct beiscsi_hba *phba,
+					struct beiscsi_conn *beiscsi_conn,
+				struct hwi_async_pdu_context *pasync_ctx,
+				      struct i_t_dpdu_cqe *pdpdu_cqe,
+						unsigned int *pcq_index)
+{
+	struct be_bus_address phys_addr;
+	struct list_head *pbusy_list, *plink;
+	struct async_pdu_handle *pasync_handle = NULL;
+	int buffer_len = 0;
+	unsigned char buffer_index = -1;
+	unsigned char is_header = 0;
+
+	/* This function is invoked to get the right async_handle structure
+	 * from   a given default PDU CQ entry.
+	 * The CQ entry contains the address offset where the DMA last ended.
+	 * So subtract the dataplacementlength to get to the base
+	 * */
+	phys_addr.u.a32.address_lo =
+	    pdpdu_cqe->dw[offsetof(struct amap_i_t_dpdu_cqe, db_addr_lo) / 32] -
+	    ((pdpdu_cqe->
+	      dw[offsetof(struct amap_i_t_dpdu_cqe, data_placement_length) /
+		 32] & PDUCQE_DPL_MASK) >> 16);
+	phys_addr.u.a32.address_hi =
+	    pdpdu_cqe->dw[offsetof(struct amap_i_t_dpdu_cqe, db_addr_hi) / 32];
+
+	phys_addr.u.a64.address =
+	    *((unsigned long long *)(&phys_addr.u.a64.address));
+
+	switch (pdpdu_cqe->
+		dw[offsetof(struct amap_i_t_dpdu_cqe, code) /
+		   32] & PDUCQE_CODE_MASK) {
+	case UNSOL_HDR_NOTIFY:
+
+		is_header = 1;
+
+		/* the index in the CQ entry gives the vertical index */
+		pbusy_list = hwi_get_async_busy_list(pasync_ctx, 1,
+			    (pdpdu_cqe->dw[offsetof(struct amap_i_t_dpdu_cqe,
+					index) / 32] & PDUCQE_INDEX_MASK));
+
+		/* and the buf_index from the PA will help walk the list
+		 * horizontally
+		 */
+		buffer_len = (uint)((phys_addr.u.a64.address -
+			pasync_ctx->async_header.pa_base.u.a64.address));
+
+		buffer_index =
+		    buffer_len / pasync_ctx->async_header.buffer_size;
+
+		break;
+
+	case UNSOL_DATA_NOTIFY:
+
+		/* the index in the CQ entry gives the vertical index */
+		pbusy_list =
+		    hwi_get_async_busy_list(pasync_ctx, 0, (pdpdu_cqe->
+					  dw[offsetof(struct amap_i_t_dpdu_cqe,
+					  index) / 32] & PDUCQE_INDEX_MASK));
+
+		/* and the buf_index from the PA will help walk the list
+		 * horizontally
+		 */
+		buffer_len = (unsigned long)((phys_addr.u.a64.address -
+					      pasync_ctx->async_data.pa_base.u.
+					      a64.address));
+		buffer_index = buffer_len / pasync_ctx->async_data.buffer_size;
+
+		break;
+	default:
+		pbusy_list = NULL;
+		dev_warn(&phba->pcidev->dev,
+			"Unexpected code=%d \n",
+			 pdpdu_cqe->
+			 dw[offsetof(struct amap_i_t_dpdu_cqe, code) /
+			    32] & PDUCQE_CODE_MASK);
+		return NULL;
+	}
+
+	WARN_ON(!(buffer_index <= pasync_ctx->async_data.num_entries));
+	WARN_ON(list_empty(pbusy_list));
+	/* walk the list and locate the default_handle with index buf_index */
+	plink = pbusy_list->next;
+
+	while (plink != pbusy_list) {
+		pasync_handle = list_entry(plink, struct async_pdu_handle,
+					   link);
+
+		WARN_ON(!pasync_handle);
+		WARN_ON(pasync_handle->consumed);
+
+		if (pasync_handle->index == buffer_index) {
+			/* found a match, exit out of the loop */
+			break;
+		}
+
+		plink = plink->next;
+		pasync_handle = NULL;
+	}
+
+	WARN_ON(!pasync_handle);
+
+	pasync_handle->cri = (unsigned short)beiscsi_conn->beiscsi_conn_cid;
+	pasync_handle->is_header = is_header;
+	pasync_handle->buffer_len =
+	    ((pdpdu_cqe->
+	      dw[offsetof(struct amap_i_t_dpdu_cqe, data_placement_length) /
+		 32] & PDUCQE_DPL_MASK) >> 16);
+
+	*pcq_index = (pdpdu_cqe->dw[offsetof(struct amap_i_t_dpdu_cqe, index) /
+			32] & PDUCQE_INDEX_MASK);
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
+	/* Some buffers have been consumed and the last was cq_index.
+	 * So from the last ep_read_ptr upto cq_index,
+	 * update all default_handles to have a consumed state.
+	 */
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
+		/* Pick only the first entry in the list for modification.
+		 * Though the default_list can grow horizontally, we only
+		 * need to update the element at the head.
+		 */
+		(*pep_read_ptr)++;
+		*pep_read_ptr = (*pep_read_ptr) % num_entries;
+
+		pbusy_list =
+		    hwi_get_async_busy_list(pasync_ctx, is_header,
+					    *pep_read_ptr);
+
+		if (writables == 0) {
+			/* if its the first time we're here inside the loop,
+			 * the busy list  should never be empty
+			 * */
+			WARN_ON(list_empty(pbusy_list));
+		}
+
+		if (!list_empty(pbusy_list)) {
+			/* valid entry found, mark it consumed */
+			pasync_handle =
+			    list_entry(pbusy_list->next,
+				       struct async_pdu_handle, link);
+			WARN_ON(!pasync_handle);
+			pasync_handle->consumed = 1;
+		}
+
+		/* increment the writables since its completed and we
+		 * could re-post
+		 * */
+		writables++;
+	}
+
+	/* no updates were done?? This is a EP fw error! */
+	if (!writables) {
+		SE_DEBUG(DBG_LVL_1,
+			 "Duplicate notification received - index 0x%x!!\n",
+			 cq_index);
+		WARN_ON(1);
+	}
+
+	/* update the writables in the corresponding structures */
+	*pwritables = *pwritables + writables;
+
+	SE_DEBUG(DBG_LVL_8,
+		 "After - is_hdr %d ep_read_ptr 0x%x writables 0x%x\n",
+		 is_header, *pep_read_ptr, *pwritables);
+
+	return 0;
+}
+
+static unsigned int hwi_free_async_msg(struct beiscsi_hba *phba,
+					unsigned int cri)
+{
+	struct hwi_controller_ws *phwi;
+	struct hwi_async_pdu_context *pasync_ctx;
+	struct async_pdu_handle *pasync_handle;
+	struct list_head *plink;
+	unsigned int i = 0;
+
+	phwi = GET_HWI_CONTROLLER_WS(phba);
+	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi);
+
+	plink = pasync_ctx->async_entry[cri].wait_queue.list.next;
+
+	while (plink != &pasync_ctx->async_entry[cri].wait_queue.list) {
+		pasync_handle =
+		    list_entry(plink, struct async_pdu_handle, link);
+		WARN_ON(!pasync_handle);
+
+		plink = plink->next;
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
+	/* reset the list header */
+	INIT_LIST_HEAD(&pasync_ctx->async_entry[cri].wait_queue.list);
+	pasync_ctx->async_entry[cri].wait_queue.hdr_received = 0;
+	pasync_ctx->async_entry[cri].wait_queue.bytes_received = 0;
+
+	return 0;
+}
+
+static struct phys_addr *hwi_get_ring_address(struct hwi_async_pdu_context
+					*pasync_ctx, unsigned int is_header,
+					unsigned int host_write_ptr)
+{
+	struct phys_addr *pasync_sge = NULL;
+
+	if (is_header)
+		pasync_sge = pasync_ctx->async_header.ring_base;
+	else
+		pasync_sge = pasync_ctx->async_data.ring_base;
+	return pasync_sge + host_write_ptr;
+}
+
+static void hwi_post_async_buffers(struct beiscsi_hba *phba,
+					unsigned int is_header)
+{
+	struct hwi_controller_ws *phwi;
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
+	phwi = GET_HWI_CONTROLLER_WS(phba);
+	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi);
+
+	/* The rule during posting buffers into the default PDU ring
+	 * is that the number of entries posted must be in multiples of 8.
+	 * There are 2 resources that matter, the free_entries and the
+	 * writables. free_entries is the count of number of buffers
+	 * iSCSI has finished
+	 * processing and have posted them back. writables is the count
+	 * of numberof buffers we know the EP firmware has consumed
+	 * */
+
+	if (is_header) {
+		num_entries = pasync_ctx->async_header.num_entries;
+		writables = min(pasync_ctx->async_header.writables,
+				pasync_ctx->async_header.free_entries);
+		pfree_link = pasync_ctx->async_header.free_list.next;
+		host_write_num = pasync_ctx->async_header.host_write_ptr;
+		ring_id = phwi->default_pdu_hdr.id;
+	} else {
+		num_entries = pasync_ctx->async_data.num_entries;
+		writables = min(pasync_ctx->async_data.writables,
+				pasync_ctx->async_data.free_entries);
+		pfree_link = pasync_ctx->async_data.free_list.next;
+		host_write_num = pasync_ctx->async_data.host_write_ptr;
+		ring_id = phwi->default_pdu_data.id;
+	}
+
+	writables = (writables / 8) * 8;
+
+	if (writables) {
+		for (i = 0; i < writables; i++) {
+
+			pbusy_list =
+			    hwi_get_async_busy_list(pasync_ctx, is_header,
+						    host_write_num);
+			pasync_handle =
+			    list_entry(pfree_link, struct async_pdu_handle,
+				       link);
+			WARN_ON(!pasync_handle);
+			pasync_handle->consumed = 0;
+
+			pfree_link = pfree_link->next;
+
+			pasync_sge = hwi_get_ring_address(pasync_ctx,
+							  is_header,
+							  host_write_num);
+
+			pasync_sge->hi = pasync_handle->pa.u.a32.address_lo;
+			pasync_sge->lo = pasync_handle->pa.u.a32.address_hi;
+
+			/* remove from free list and add to busy list */
+			list_del(&pasync_handle->link);
+			list_add(&pasync_handle->link, pbusy_list);
+
+			host_write_num++;
+			host_write_num = host_write_num % num_entries;
+		}
+
+		if (is_header) {
+			pasync_ctx->async_header.host_write_ptr =
+			    host_write_num;
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
+
+}
+
+static unsigned int
+hwi_flush_default_pdu_buffer(struct beiscsi_hba *phba,
+			     struct beiscsi_conn *beiscsi_conn,
+			     struct i_t_dpdu_cqe *pdpdu_cqe)
+{
+	struct hwi_controller_ws *phwi;
+	struct hwi_async_pdu_context *pasync_ctx;
+	struct async_pdu_handle *pasync_handle = NULL;
+	unsigned int cq_index = -1;
+
+	phwi = GET_HWI_CONTROLLER_WS(phba);
+	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi);
+
+	/* This function is called when there is a default PDU buffer digest
+	 * (data digest error). The driver consumes the entry and drops
+	 * the contents. The EP fw gives a CQ entry indicating completion
+	 * on either the default PDU header ring the default PDU buffer ring.
+	 * The CQ entry will contain the index and the physical address of
+	 * the entry. Get our reference from the CQ entry
+	 */
+	pasync_handle =
+	    hwi_get_async_handle(phba, beiscsi_conn, pasync_ctx, pdpdu_cqe,
+				 &cq_index);
+	WARN_ON(!pasync_handle);
+
+	if (pasync_handle->is_header == 0) {
+
+		/* If this entry is not yet consumed, then in addition to a
+		 * completion, it also means that buffers upto the cq_index
+		 * have been consumed.
+		 * We can post fresh buffers back if there are atleast 8 free.
+		 * If this entry is already consumed, then this is only a
+		 * completion. It doesn't give us a chance to re-post any
+		 * buffers
+		 */
+		if (pasync_handle->consumed == 0) {
+			hwi_update_async_writables(pasync_ctx,
+						   pasync_handle->is_header,
+						   cq_index);
+		}
+
+		/* there will not be a consumer for this CQE. The connection's
+		 * default PDU header and buffer should be simply dropped.
+		 * So release the buffers
+		 */
+		hwi_free_async_msg(phba, pasync_handle->cri);
+
+		/* Attempt to post new entries back to the ring. Note that we
+		 * call the routine to post irrespective of the consumed or
+		 * completed-only status. This is because though a
+		 * completed-only status does not update the writables, it does
+		 * free up some buffers which could  mean that we can post.
+		 * (Look in hwi_post_async_buffers for more info on posting
+		 * rules!)
+		 */
+		hwi_post_async_buffers(phba, pasync_handle->is_header);
+	} else {
+		BUG();
+	}
+
+	return 0;
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
+		      io_task->bhs_pa.u.a32.address_lo);
+	AMAP_SET_BITS(struct amap_iscsi_wrb, iscsi_bhs_addr_hi, pwrb,
+		      io_task->bhs_pa.u.a32.address_hi);
+
+	l_sg = sg;
+	for (index = 0; (index < num_sg) && (index < 2); index++, sg++) {
+		if (index == 0) {
+			sg_len = sg_dma_len(sg);
+			addr = (u64) sg_dma_address(sg);
+			AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_addr_lo, pwrb,
+				      (addr & 0xFFFFFFFF));
+			AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_addr_hi, pwrb,
+				      (addr >> 32));
+			AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_len, pwrb,
+				      sg_len);
+			sge_len = sg_len;
+			AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_last, pwrb,
+				      1);
+		} else {
+			AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_last, pwrb,
+				      0);
+			AMAP_SET_BITS(struct amap_iscsi_wrb, sge1_r2t_offset,
+				      pwrb, sge_len);
+			sg_len = sg_dma_len(sg);
+			addr = (u64) sg_dma_address(sg);
+			AMAP_SET_BITS(struct amap_iscsi_wrb, sge1_addr_lo, pwrb,
+				      (addr & 0xFFFFFFFF));
+			AMAP_SET_BITS(struct amap_iscsi_wrb, sge1_addr_hi, pwrb,
+				      (addr >> 32));
+			AMAP_SET_BITS(struct amap_iscsi_wrb, sge1_len, pwrb,
+				      sg_len);
+		}
+	}
+
+	psgl = (struct iscsi_sge *)io_task->psgl_handle->pfrag;
+	memset(psgl, 0x0, sizeof(struct iscsi_sge) * 10);
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
+	for (index = 0; index < num_sg; index++, sg++, psgl++) {
+		sg_len = sg_dma_len(sg);
+		addr = (u64) sg_dma_address(sg);
+		AMAP_SET_BITS(struct amap_iscsi_sge, addr_lo, psgl,
+			      (addr & 0xFFFFFFFF));
+		AMAP_SET_BITS(struct amap_iscsi_sge, addr_hi, psgl,
+			      (addr >> 32));
+		AMAP_SET_BITS(struct amap_iscsi_sge, len, psgl, sg_len);
+		AMAP_SET_BITS(struct amap_iscsi_sge, sge_offset, psgl, offset);
+		AMAP_SET_BITS(struct amap_iscsi_sge, last_sge, psgl, 0);
+		offset += sg_len;
+
+	}
+	psgl--;
+	AMAP_SET_BITS(struct amap_iscsi_sge, last_sge, psgl, 1);
+
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
+		      io_task->bhs_pa.u.a32.address_lo);
+	AMAP_SET_BITS(struct amap_iscsi_wrb, iscsi_bhs_addr_hi, pwrb,
+		      io_task->bhs_pa.u.a32.address_hi);
+
+	if (task->data) {
+		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
+		/* Should set this if sge is present.
+		 * Verify in all cases
+		 * */
+
+		if (task->data_count) {
+			addr = (u64) pci_map_single(phba->pcidev,
+						    task->data,
+						    task->data_count, 1);
+
+		} else {
+			addr = 0;
+		}
+		AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_addr_lo, pwrb,
+			      (addr & 0xFFFFFFFF));
+		AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_addr_hi, pwrb,
+			      (addr >> 32));
+		AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_len, pwrb,
+			      task->data_count);
+
+		AMAP_SET_BITS(struct amap_iscsi_wrb, sge0_last, pwrb, 1);
+	} else {
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
+				      (addr & 0xFFFFFFFF));
+			AMAP_SET_BITS(struct amap_iscsi_sge, addr_hi, psgl,
+				      (addr >> 32));
+		}
+		AMAP_SET_BITS(struct amap_iscsi_sge, len, psgl, 0x106);
+	}
+	AMAP_SET_BITS(struct amap_iscsi_sge, last_sge, psgl, 1);
+}
+
+static unsigned int
+hwi_fwd_async_msg(struct beiscsi_conn *beiscsi_conn,
+		  struct beiscsi_hba *phba,
+		  struct hwi_async_pdu_context *pasync_ctx, unsigned short cri)
+{
+	struct list_head *plink;
+	struct async_pdu_handle *pasync_handle;
+	void *phdr = NULL;
+	unsigned int hdr_len = 0, buf_len = 0;
+	unsigned int status, index = 0, offset = 0;
+
+	void *pfirst_buffer = NULL;
+	unsigned int num_buf = 0;
+
+	plink = pasync_ctx->async_entry[cri].wait_queue.list.next;
+
+	while ((plink != &pasync_ctx->async_entry[cri].wait_queue.list)) {
+		pasync_handle = list_entry(plink, struct async_pdu_handle,
+					   link);
+
+		WARN_ON(!pasync_handle);
+
+		if (index == 0) {
+			/* first element is the header, get its reference */
+			phdr = pasync_handle->pbuffer;
+			hdr_len = pasync_handle->buffer_len;
+		} else {
+			buf_len = pasync_handle->buffer_len;
+
+			if (!num_buf) {
+				pfirst_buffer = pasync_handle->pbuffer;
+				num_buf++;
+			}
+
+			memcpy(pfirst_buffer + offset,
+			       pasync_handle->pbuffer, buf_len);
+
+			offset = buf_len;
+		}
+
+		index++;
+		plink = plink->next;
+	}
+
+	status = beiscsi_process_async_pdu(beiscsi_conn, phba,
+				   beiscsi_conn->beiscsi_conn_cid,
+				   phdr, hdr_len, pfirst_buffer, buf_len);
+
+	if (status == 0) {
+		/* iscsi has finished processing the buffers, add it
+		 * to the free pool. This will remove the element
+		 * from wait list and add it to free list
+		 * */
+		hwi_free_async_msg(phba, cri);
+	}
+
+	return 0;
+}
+
+static unsigned int
+hwi_gather_async_pdu(struct beiscsi_conn *beiscsi_conn,
+		     struct beiscsi_hba *phba,
+		     struct async_pdu_handle *pasync_handle)
+{
+
+	struct hwi_async_pdu_context *pasync_ctx;
+	struct hwi_controller_ws *phwi;
+	unsigned int bytes_needed = 0, status = 0;
+	unsigned short cri = pasync_handle->cri;
+	struct pdu_base *ppdu;
+
+	phwi = GET_HWI_CONTROLLER_WS(phba);
+
+	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi);
+
+	/* remove the element from the busylist and insert into the waitlist */
+	list_del(&pasync_handle->link);
+	if (pasync_handle->is_header) {
+		pasync_ctx->async_header.busy_entries--;
+
+		/* if there is an already stored header, then evict that header
+		 * and store this one. Only 1 header can be queued currently.
+		 * It should be ok since the only non-erroroneous case where we
+		 * could see 2 headers is when an offload is in progress.
+		 * */
+		if (pasync_ctx->async_entry[cri].wait_queue.hdr_received) {
+			BUG();
+			hwi_free_async_msg(phba, cri);
+		}
+
+		pasync_ctx->async_entry[cri].wait_queue.bytes_received = 0;
+		pasync_ctx->async_entry[cri].wait_queue.hdr_received = 1;
+		pasync_ctx->async_entry[cri].wait_queue.hdr_len =
+		    (unsigned char)pasync_handle->buffer_len;
+		list_add_tail(&pasync_handle->link,
+			      &pasync_ctx->async_entry[cri].wait_queue.list);
+
+		ppdu = pasync_handle->pbuffer;
+		bytes_needed = ((((ppdu->dw[offsetof(struct amap_pdu_base,
+			data_len_hi) / 32] & PDUBASE_DATALENHI_MASK) << 8) &
+			0xFFFF0000) | ((be16_to_cpu((ppdu->
+			dw[offsetof(struct amap_pdu_base, data_len_lo) /
+			32] & PDUBASE_DATALENLO_MASK) >> 16)) & 0x0000FFFF));
+
+		if (status == 0) {
+			pasync_ctx->async_entry[cri].wait_queue.bytes_needed =
+			    bytes_needed;
+
+			if (bytes_needed == 0) {
+				/* all data has been received,
+				 * forward it to iscsi
+				 * */
+				status =
+				    hwi_fwd_async_msg(beiscsi_conn, phba,
+						      pasync_ctx, cri);
+			}
+		}
+	} else {
+		pasync_ctx->async_data.busy_entries--;
+
+		if (pasync_ctx->async_entry[cri].wait_queue.hdr_received) {
+			list_add_tail(&pasync_handle->link,
+				      &pasync_ctx->async_entry[cri].wait_queue.
+				      list);
+			pasync_ctx->async_entry[cri].wait_queue.
+			    bytes_received +=
+			    (unsigned short)pasync_handle->buffer_len;
+
+			if (pasync_ctx->async_entry[cri].wait_queue.
+			    bytes_received >=
+			    pasync_ctx->async_entry[cri].wait_queue.
+			    bytes_needed) {
+				/* all data has been received, forward it to
+				 * iscsi
+				 * */
+				status =
+				    hwi_fwd_async_msg(beiscsi_conn, phba,
+						      pasync_ctx, cri);
+			}
+		}
+	}
+
+	return status;
+}
+
+static unsigned int
+hwi_process_default_pdu_ring(struct beiscsi_conn *beiscsi_conn,
+			     struct beiscsi_hba *phba,
+			     struct i_t_dpdu_cqe *pdpdu_cqe)
+{
+	struct hwi_controller_ws *phwi;
+	struct hwi_async_pdu_context *pasync_ctx;
+	struct async_pdu_handle *pasync_handle = NULL;
+	unsigned int cq_index = -1;
+
+	phwi = GET_HWI_CONTROLLER_WS(phba);
+	pasync_ctx = HWI_GET_ASYNC_PDU_CTX(phwi);
+
+	/* The EP fw gives a CQ entry indicating completion on either the
+	 * default PDU header ring or the default PDU data ring. The CQ entry
+	 * will containthe index and the physical address of the entry.
+	 * Get our reference from the CQ entry
+	 * */
+	pasync_handle =
+	    hwi_get_async_handle(phba, beiscsi_conn, pasync_ctx, pdpdu_cqe,
+				 &cq_index);
+	WARN_ON(!pasync_handle);
+
+	/* If this entry is not yet consumed, then in addition to a completion,
+	 * it also means that buffers upto the cq_index have been consumed.
+	 * We can post fresh buffers back if there are atleast 8 free
+	 * If this entry is already consumed, then this is only a completion.
+	 * It doesn't give us a chance to re-post any buffers
+	 */
+	if (pasync_handle->consumed == 0) {
+		hwi_update_async_writables(pasync_ctx,
+					   pasync_handle->is_header, cq_index);
+	}
+
+	/* gather the default entry for the connection and forward it to iSCSI
+	 * for processing. This function is where the element is removed from
+	 * busy list and added to the wait list
+	 */
+	hwi_gather_async_pdu(beiscsi_conn, phba, pasync_handle);
+
+	/* Attempt to post new entries back to the ring. Note that we call
+	 * the routine to post irrespective of the consumed or completed-only
+	 * status. This is because though a completed-only status does not
+	 * update the writables, it does free up some buffers which could
+	 * mean that we can post.
+	 * (Look in hwi_post_async_buffers for more info on posting rules!)
+	 */
+	hwi_post_async_buffers(phba, pasync_handle->is_header);
+
+	return 0;
+}
+
+void beiscsi_process_cq(struct beiscsi_hba *phba)
+{
+	struct hwi_controller_ws *phwi_controller;
+	struct hwi_context_memory *phwi_context;
+	struct be_queue_info *cq;
+	struct sol_cqe *sol;
+	struct dmsg_cqe *dmsg;
+	unsigned int num_processed = 0;
+	struct beiscsi_conn *beiscsi_conn;
+
+	phwi_controller = GET_HWI_CONTROLLER_WS(phba);
+	phwi_context = phwi_controller->phwic;
+	cq = &phwi_context->be_cq;
+	sol = queue_tail_node(cq);
+	be_dws_le_to_cpu(sol, sizeof(struct sol_cqe));
+
+	beiscsi_conn = beiscsi_conn_frm_cid(phba, (u32) ((sol->
+			 dw[offsetof(struct amap_sol_cqe, cid)
+			    / 32] & SOL_CID_MASK)) >> 6);
+
+	if (!beiscsi_conn || !beiscsi_conn->ep) {
+		dev_warn(&phba->pcidev->dev,
+			"beiscsi_conn Invalid for cid=%d\n",
+			 (u32) ((sol->dw[offsetof(struct amap_sol_cqe, cid) /
+			 32] & SOL_CID_MASK)) >> 6);
+		return;
+	}
+
+
+	while ((sol->dw[offsetof(struct amap_sol_cqe, valid) /
+		   32] & CQE_VALID_MASK)) {
+		if (num_processed >= 32) {
+			/* Occassionally free space in CQ for the hardware to
+			 * write more entries without enabling the interrupt
+			 * yet.
+			 */
+			hwi_ring_cq_db(phba, phwi_context->be_cq.id,
+					num_processed, 0, 0);
+			num_processed = 0;
+		}
+
+		switch ((u32) sol->dw[offsetof(struct amap_sol_cqe, code) /
+			   32] & CQE_CODE_MASK) {
+		case SOL_CMD_COMPLETE:
+			hwi_complete_cmd(beiscsi_conn, phba,
+					(struct sol_cqe *)sol);
+			break;
+
+		case DRIVERMSG_NOTIFY:
+
+			dmsg = (struct dmsg_cqe *)sol;
+			hwi_complete_drvr_msgs(beiscsi_conn, phba,
+					       (struct sol_cqe *)sol);
+			break;
+
+		case UNSOL_HDR_NOTIFY:
+		case UNSOL_DATA_NOTIFY:
+			hwi_process_default_pdu_ring(beiscsi_conn, phba,
+						     (struct i_t_dpdu_cqe *)
+						     sol);
+			break;
+
+		case CXN_INVALIDATE_INDEX_NOTIFY:
+			break;
+
+		case CMD_INVALIDATED_NOTIFY:
+		case CXN_INVALIDATE_NOTIFY:
+			SE_DEBUG(DBG_LVL_1,
+				 "Ignoring CQ Error notification for cmd/cxn"
+				 "invalidate\n");
+			break;
+
+		case SOL_CMD_KILLED_DATA_DIGEST_ERR:
+		case CMD_KILLED_INVALID_STATSN_RCVD:
+		case CMD_KILLED_INVALID_R2T_RCVD:
+		case CMD_CXN_KILLED_LUN_INVALID:
+		case CMD_CXN_KILLED_ICD_INVALID:
+		case CMD_CXN_KILLED_ITT_INVALID:
+		case CMD_CXN_KILLED_SEQ_OUTOFORDER:
+		case CMD_CXN_KILLED_INVALID_DATASN_RCVD:
+			/* Though some of the above code say CMD_CXN, it only
+			 * affects the command in initiator mode.
+			 * */
+
+			SE_DEBUG(DBG_LVL_1,
+				 "CQ Error notification for cmd.. code 0x%x cid"
+				 "0x%x\n",
+				 sol->dw[offsetof(struct amap_sol_cqe, code) /
+					 32] & CQE_CODE_MASK,
+				 (sol->
+				  dw[offsetof(struct amap_sol_cqe, cid) /
+				     32] & SOL_CID_MASK));
+
+			iscsi_conn_failure((struct iscsi_conn *)beiscsi_conn->
+					   conn, ISCSI_ERR_CONN_FAILED);
+			break;
+
+		case UNSOL_DATA_DIGEST_ERROR_NOTIFY:
+			SE_DEBUG(DBG_LVL_1,
+				 "Digest error on def pdu ring, dropping..\n");
+			iscsi_conn_failure((struct iscsi_conn *)beiscsi_conn->
+					   conn, ISCSI_ERR_CONN_FAILED);
+			/* Increment default PDU producer index and post
+			 * it back
+			 * */
+			hwi_flush_default_pdu_buffer(phba, beiscsi_conn,
+						     (struct i_t_dpdu_cqe *)
+						     sol);
+			break;
+
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
+
+			SE_DEBUG(DBG_LVL_1,
+				 "CQ Error 0x%x, resetting CID 0x%x...\n",
+				 sol->dw[offsetof(struct amap_sol_cqe, code) /
+					 32] & CQE_CODE_MASK,
+				 sol->dw[offsetof(struct amap_sol_cqe, cid) /
+					 32] & CQE_CID_MASK);
+			iscsi_conn_failure((struct iscsi_conn *)beiscsi_conn->
+					   conn, ISCSI_ERR_CONN_FAILED);
+			break;
+
+		case CXN_KILLED_RST_SENT:
+		case CXN_KILLED_RST_RCVD:
+
+			SE_DEBUG(DBG_LVL_1,
+				 "CQ Error 0x%x, reset received/sent on"
+				 "CID 0x%x...\n",
+				 sol->dw[offsetof(struct amap_sol_cqe, code) /
+					 32] & CQE_CODE_MASK,
+				 sol->dw[offsetof(struct amap_sol_cqe, cid) /
+					 32] & CQE_CID_MASK);
+			iscsi_conn_failure((struct iscsi_conn *)beiscsi_conn->
+					   conn, ISCSI_ERR_CONN_FAILED);
+			break;
+
+		default:
+			break;
+
+		}
+
+		AMAP_SET_BITS(struct amap_sol_cqe, valid, sol, 0);
+		queue_tail_inc(cq);
+		sol = queue_tail_node(cq);
+		num_processed++;
+	}
+
+	if (num_processed > 0) {
+		hwi_ring_cq_db(phba, phwi_context->be_cq.id, num_processed,
+			       1, 0);
+	}
+
+	return;
+}
+
+static void beiscsi_find_mem_req(struct beiscsi_hba *phba)
+{
+
+	unsigned int num_cq_pages, num_eq_pages, num_async_pdu_buf_pages,
+	    num_async_pdu_data_pages;
+	unsigned int num_async_pdu_buf_sgl_pages, num_async_pdu_data_sgl_pages;
+
+	num_cq_pages =
+	    PAGES_REQUIRED((phba->params.num_cq_entries * \
+				    sizeof(struct sol_cqe)));
+	num_eq_pages =
+	    PAGES_REQUIRED(phba->params.num_eq_entries * \
+			    sizeof(struct be_eq_entry));
+	num_async_pdu_buf_pages =
+	    PAGES_REQUIRED((phba->params.asyncpdus_per_ctrl * \
+			phba->params.defpdu_hdr_sz));
+	num_async_pdu_buf_sgl_pages =
+	    PAGES_REQUIRED(phba->params.asyncpdus_per_ctrl * \
+		       sizeof(struct phys_addr));
+	num_async_pdu_data_pages =
+	    PAGES_REQUIRED((phba->params.asyncpdus_per_ctrl * \
+			phba->params.defpdu_data_sz));
+	num_async_pdu_data_sgl_pages =
+	    PAGES_REQUIRED(phba->params.asyncpdus_per_ctrl * \
+		       sizeof(struct phys_addr));
+
+	phba->params.hwi_ws_sz = sizeof(struct hwi_controller_ws);
+
+	phba->mem_req[ISCSI_MEM_GLOBAL_HEADER] = 2 *
+		sizeof(BE_ISCSI_PDU_HEADER_SIZE);	/* g_header_sz */
+
+	/* hwi_ctxt_sz      */
+	phba->mem_req[HWI_MEM_ADDN_CONTEXT] =
+	    sizeof(struct hwi_context_memory);
+	phba->mem_req[HWI_MEM_MAILBOX] = sizeof(struct mcc_wrb) +
+		sizeof(struct be_mcc_compl);	/* mailbox_sz */
+
+	phba->mem_req[HWI_MEM_CQ] = num_cq_pages * PAGE_SIZE;
+	/* cq_sz            */
+	phba->mem_req[HWI_MEM_EQ] = num_eq_pages * PAGE_SIZE;
+	/* eq_sz            */
+
+	phba->mem_req[HWI_MEM_WRB] = sizeof(struct iscsi_wrb)
+	    * (phba->params.wrbs_per_cxn)
+	    * phba->params.cxns_per_ctrl;	/* queue depth */
+	phba->mem_req[HWI_MEM_WRBH] =
+	    sizeof(struct wrb_handle) * (phba->params.wrbs_per_cxn) *
+	    phba->params.cxns_per_ctrl;
+
+	phba->mem_req[HWI_MEM_SGLH] = sizeof(struct sgl_handle) *
+		phba->params.icds_per_ctrl;
+	phba->mem_req[HWI_MEM_SGE] = sizeof(struct iscsi_sge) *
+	    phba->params.num_sge_per_io * phba->params.icds_per_ctrl;
+	/* sge_sz   */
+
+	phba->mem_req[HWI_MEM_ASYNC_HEADER_BUF] =
+		num_async_pdu_buf_pages * PAGE_SIZE;	/* async_hdr_sz  */
+	phba->mem_req[HWI_MEM_ASYNC_DATA_BUF] =
+		num_async_pdu_data_pages * PAGE_SIZE;	/* def_hdr_sz  */
+	phba->mem_req[HWI_MEM_ASYNC_HEADER_RING] =
+		num_async_pdu_buf_sgl_pages * PAGE_SIZE;
+	/* async_hdr_ring_sz */
+	phba->mem_req[HWI_MEM_ASYNC_DATA_RING] =
+	    num_async_pdu_data_sgl_pages * PAGE_SIZE;
+	/* def_buf_ring_sz  */
+	phba->mem_req[HWI_MEM_ASYNC_HEADER_HANDLE] =
+	    phba->params.asyncpdus_per_ctrl * sizeof(struct async_pdu_handle);
+	/* async_hdr_h_sz   */
+	phba->mem_req[HWI_MEM_ASYNC_DATA_HANDLE] =
+	    phba->params.asyncpdus_per_ctrl * sizeof(struct async_pdu_handle);
+	/* def_buf_h_sz     */
+	phba->mem_req[HWI_MEM_ASYNC_PDU_CONTEXT] =
+	    sizeof(struct hwi_async_pdu_context) +
+	    (phba->params.cxns_per_ctrl * sizeof(struct hwi_async_entry));
+	/* ctxt_sz    */
+
+}
+
+static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
+{
+	struct be_mem_descriptor *mem_descr;
+	dma_addr_t bus_add;
+	unsigned int num_size, i, j;
+	phba->phwi_ws = kmalloc(phba->params.hwi_ws_sz, GFP_KERNEL);
+	if (!phba->phwi_ws)
+		return -ENOMEM;
+	phba->phwi_ws->pbe_ws = phba;
+	phba->init_mem =
+	    kzalloc(sizeof(struct be_mem_descriptor) * SE_MEM_MAX, GFP_KERNEL);
+	mem_descr = phba->init_mem;
+
+	for (i = 0; i < SE_MEM_MAX; i++) {
+		j = 0;
+
+		num_size = phba->mem_req[i];
+		while (num_size) {
+			if (j >= BEISCSI_MAX_FRAGS_INIT) {
+				SE_DEBUG(DBG_LVL_1,
+				 "Memory Fragment exceeded %d for"
+				 "index=%d. Failing to Load thedriver\n",
+				 BEISCSI_MAX_FRAGS_INIT, i);
+				goto free_mem;
+			}
+
+			if (num_size >= 131072) {
+				mem_descr->mem_array[j].virtual_address =
+				    (void *)pci_alloc_consistent(phba->pcidev,
+						 131072, &bus_add);
+				if (!mem_descr->mem_array[j].virtual_address) {
+					SE_DEBUG(DBG_LVL_1, "Memory too"
+					"fragmented to Load the driver");
+					goto free_mem;
+				} else {
+					mem_descr->mem_array[j].bus_address.u.
+					    a64.address = (__u64) bus_add;
+					mem_descr->mem_array[j].size = 131072;
+					memset(mem_descr->mem_array[j].
+					       virtual_address, 0x0, 131072);
+					j++;
+					num_size -= 131072;
+				}
+			} else if (num_size >= 65536) {
+				mem_descr->mem_array[j].virtual_address =
+				    (void *)pci_alloc_consistent(phba->pcidev,
+						 num_size, &bus_add);
+				if (!mem_descr->mem_array[j].virtual_address) {
+					goto free_mem;
+				} else {
+					mem_descr->mem_array[j].bus_address.u.
+					    a64.address = (__u64) bus_add;
+					mem_descr->mem_array[j].size = num_size;
+					memset(mem_descr->mem_array[j].
+					       virtual_address, 0x0, num_size);
+					j++;
+					num_size -= num_size;
+				}
+			} else {
+				mem_descr->mem_array[j].virtual_address =
+				    (void *)pci_alloc_consistent(phba->pcidev,
+						 num_size, &bus_add);
+				if (!mem_descr->mem_array[j].virtual_address) {
+					SE_DEBUG(DBG_LVL_1,
+						 "Memory too fragmented to Load"
+						 "the driver");
+					goto free_mem;
+				} else {
+					mem_descr->mem_array[j].bus_address.u.
+					    a64.address = (__u64) bus_add;
+					mem_descr->mem_array[j].size = num_size;
+					memset(mem_descr->mem_array[j].
+					       virtual_address, 0x0, num_size);
+					j++;
+					num_size -= num_size;
+				}
+			}
+		}
+		mem_descr->num_elements = j;
+		mem_descr->size_in_bytes = phba->mem_req[i];
+		SE_DEBUG(DBG_LVL_1,
+			 "In alloc_mem, i=%d , mem_descr=%p"
+			"mem_descr->num_elements=%d  mem_descr->size_in_bytes"
+			"=%d \n", i, mem_descr, mem_descr->num_elements,
+			mem_descr->size_in_bytes);
+		mem_descr++;
+	}
+	return 0;
+free_mem:
+	mem_descr->num_elements = j;
+	while ((i) || (j)) {
+		for (j = mem_descr->num_elements; j > 0; j--) {
+			pci_free_consistent(phba->pcidev,
+					    mem_descr->mem_array[j - 1].size,
+					    (void *)mem_descr->mem_array[j -
+									 1].
+					    virtual_address,
+					    mem_descr->mem_array[j -
+								 1].bus_address.
+					    u.a64.address);
+
+		}
+		if (i) {
+			i--;
+			mem_descr--;
+		}
+	}
+	kfree(phba->init_mem);
+	kfree(phba->phwi_ws);
+	return -ENOMEM;
+}
+
+static int beiscsi_get_memory(struct beiscsi_hba *phba)
+{
+	int ret;
+	beiscsi_find_mem_req(phba);
+	ret = beiscsi_alloc_mem(phba);
+	if (0 != ret)
+		return ret;
+	return 0;
+}
+
+static void iscsi_init_global_templates(struct beiscsi_hba *phba)
+{
+	struct pdu_data_out *pdata_out;
+	struct pdu_nop_out *pnop_out;
+	struct be_mem_descriptor *mem_descr;
+
+	/*
+	 * Patch the opcode field of global template headers with write code.
+	 * The rest  will be patched up by the EP
+	 */
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
+				   virtual_address +
+				   BE_ISCSI_PDU_HEADER_SIZE);
+
+	memset(pnop_out, 0, BE_ISCSI_PDU_HEADER_SIZE);
+
+	AMAP_SET_BITS(struct amap_pdu_nop_out, ttt, pnop_out, 0xFFFFFFFF);
+	AMAP_SET_BITS(struct amap_pdu_nop_out, f_bit, pnop_out, 1);
+	AMAP_SET_BITS(struct amap_pdu_nop_out, i_bit, pnop_out, 0);
+}
+
+static void beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
+{
+
+	struct be_mem_descriptor *mem_descr_wrbh, *mem_descr_wrb;
+	struct wrb_handle *pwrb_handle;
+	struct hwi_controller_ws *phwi;
+	struct hwi_wrb_context *pwrb_context;
+	struct iscsi_wrb *pwrb;
+	unsigned short arr_index;
+	unsigned int num_cxn_wrbh;
+	/* The number of arrays of wrb_handles in this mem_array[i].size */
+	unsigned int num_cxn_wrb, j, idx, index;
+
+	/* Initiallize IO Handle */
+	mem_descr_wrbh = phba->init_mem;
+	mem_descr_wrbh += HWI_MEM_WRBH;
+
+	mem_descr_wrb = phba->init_mem;
+	mem_descr_wrb += HWI_MEM_WRB;
+
+	idx = 0;
+	pwrb_handle = mem_descr_wrbh->mem_array[idx].virtual_address;
+	num_cxn_wrbh =
+	    ((mem_descr_wrbh->mem_array[idx].size) /
+	     ((sizeof(struct wrb_handle)) * phba->params.wrbs_per_cxn));
+	phwi = phba->phwi_ws;
+
+	for (index = 0; index < phba->params.cxns_per_ctrl * 2; index += 2) {
+		arr_index = 0;
+		pwrb_context = &phwi->wrb_context[index];
+		SE_DEBUG(DBG_LVL_8, "cid=%d pwrb_context=%p \n", index,
+			 pwrb_context);
+		pwrb_context->pwrb_handle_base =
+		    kmalloc(sizeof(struct wrb_handle *) *
+			    phba->params.wrbs_per_cxn, GFP_KERNEL);
+		pwrb_context->pwrb_handle_basestd =
+		    kmalloc(sizeof(struct wrb_handle *) *
+			    phba->params.wrbs_per_cxn, GFP_KERNEL);
+		if (num_cxn_wrbh) {
+			pwrb_context->alloc_index = 0;
+			pwrb_context->wrb_handles_available = 0;
+			for (j = 0; j < phba->params.wrbs_per_cxn; j++) {
+				pwrb_handle->wrb_index =
+				    (unsigned short)arr_index++;
+				pwrb_context->pwrb_handle_base[j] = pwrb_handle;
+				pwrb_context->pwrb_handle_basestd[j] =
+				    pwrb_handle;
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
+				pwrb_handle->wrb_index =
+				    (unsigned short)arr_index++;
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
+
+	/* Initiallize pwrb */
+	idx = 0;
+	pwrb = mem_descr_wrb->mem_array[idx].virtual_address;
+	num_cxn_wrb =
+	    ((mem_descr_wrb->mem_array[idx].size) / (sizeof(struct iscsi_wrb)) *
+	     phba->params.wrbs_per_cxn);
+
+	for (index = 0; index < phba->params.cxns_per_ctrl; index += 2) {
+		pwrb_context = &phwi->wrb_context[index];
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
+			num_cxn_wrb =
+			    ((mem_descr_wrb->mem_array[idx].size) /
+			     (sizeof(struct iscsi_wrb)) *
+			     phba->params.wrbs_per_cxn);
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
+	struct hwi_controller_ws *phwi;
+	struct hba_parameters *p = &phba->params;
+	struct hwi_async_pdu_context *pasync_ctx;
+	struct async_pdu_handle *pasync_header_h, *pasync_data_h;
+	unsigned int index;
+	struct be_mem_descriptor *mem_descr;
+	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+	mem_descr += HWI_MEM_ASYNC_PDU_CONTEXT;
+
+	/* Initializes the ASYNC_PDU_CONTEXT structure. This will setup the
+	 *  context to enable posting of buffers later.
+	 *  */
+
+	phwi = GET_HWI_CONTROLLER_WS(phba);
+	phwi->phwic->pasync_ctx = (struct hwi_async_pdu_context *)
+	    mem_descr->mem_array[0].virtual_address;
+	pasync_ctx = phwi->phwic->pasync_ctx;
+	memset(pasync_ctx, 0, sizeof(*pasync_ctx));
+
+	pasync_ctx->async_header.num_entries = p->asyncpdus_per_ctrl;
+	pasync_ctx->async_header.buffer_size = p->defpdu_hdr_sz;
+	pasync_ctx->async_data.buffer_size = p->defpdu_data_sz;
+	pasync_ctx->async_data.num_entries = p->asyncpdus_per_ctrl;
+
+	/* The Header */
+	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+	mem_descr += HWI_MEM_ASYNC_HEADER_BUF;
+	if (mem_descr->mem_array[0].virtual_address) {
+		SE_DEBUG(DBG_LVL_8,
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_BUF"
+			 "va=%p \n", mem_descr->mem_array[0].virtual_address);
+	} else {
+		dev_warn(&phba->pcidev->dev, "No Virtual address \n");
+	}
+	pasync_ctx->async_header.va_base =
+	    mem_descr->mem_array[0].virtual_address;
+
+	pasync_ctx->async_header.pa_base.u.a64.address =
+	    mem_descr->mem_array[0].bus_address.u.a64.address;
+
+	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+	mem_descr += HWI_MEM_ASYNC_HEADER_RING;
+	if (mem_descr->mem_array[0].virtual_address) {
+		SE_DEBUG(DBG_LVL_8,
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_RING"
+			 "va=%p \n", mem_descr->mem_array[0].virtual_address);
+	} else {
+		dev_warn(&phba->pcidev->dev, "No Virtual address \n");
+	}
+	pasync_ctx->async_header.ring_base =
+	    mem_descr->mem_array[0].virtual_address;
+
+	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+	mem_descr += HWI_MEM_ASYNC_HEADER_HANDLE;
+	if (mem_descr->mem_array[0].virtual_address) {
+		SE_DEBUG(DBG_LVL_8,
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_HANDLE"
+			 "va=%p \n", mem_descr->mem_array[0].virtual_address);
+	} else {
+		dev_warn(&phba->pcidev->dev, "No Virtual address \n");
+	}
+	pasync_ctx->async_header.handle_base =
+	    mem_descr->mem_array[0].virtual_address;
+	pasync_ctx->async_header.writables = 0;
+	INIT_LIST_HEAD(&pasync_ctx->async_header.free_list);
+
+	/* Now, for Data */
+
+	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+	mem_descr += HWI_MEM_ASYNC_DATA_BUF;
+	if (mem_descr->mem_array[0].virtual_address) {
+		SE_DEBUG(DBG_LVL_8,
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_BUF"
+			"va=%p \n", mem_descr->mem_array[0].virtual_address);
+	} else {
+		dev_warn(&phba->pcidev->dev, "No Virtual address \n");
+	}
+	pasync_ctx->async_data.va_base =
+	    mem_descr->mem_array[0].virtual_address;
+	pasync_ctx->async_data.pa_base.u.a64.address =
+	    mem_descr->mem_array[0].bus_address.u.a64.address;
+
+	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+	mem_descr += HWI_MEM_ASYNC_DATA_RING;
+	if (mem_descr->mem_array[0].virtual_address) {
+		SE_DEBUG(DBG_LVL_8,
+			 "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_RING"
+			 "va=%p \n", mem_descr->mem_array[0].virtual_address);
+	} else {
+		dev_warn(&phba->pcidev->dev, "No Virtual address \n");
+	}
+
+	pasync_ctx->async_data.ring_base =
+	    mem_descr->mem_array[0].virtual_address;
+
+	mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+	mem_descr += HWI_MEM_ASYNC_DATA_HANDLE;
+	if (!mem_descr->mem_array[0].virtual_address)
+		dev_warn(&phba->pcidev->dev, "No Virtual address \n");
+
+	pasync_ctx->async_data.handle_base =
+	    mem_descr->mem_array[0].virtual_address;
+	pasync_ctx->async_data.writables = 0;
+	INIT_LIST_HEAD(&pasync_ctx->async_data.free_list);
+
+	pasync_header_h =
+	    (struct async_pdu_handle *)pasync_ctx->async_header.handle_base;
+	pasync_data_h =
+	    (struct async_pdu_handle *)pasync_ctx->async_data.handle_base;
+
+	for (index = 0; index < p->asyncpdus_per_ctrl; index++) {
+
+		/*
+		   initialize the header part
+		   setup the free_list */
+		pasync_header_h->cri = -1;
+		pasync_header_h->index = (char)index;
+		INIT_LIST_HEAD(&pasync_header_h->link);
+		pasync_header_h->pbuffer =
+		    (void *)((unsigned long)(pasync_ctx->async_header.va_base) +
+			     (p->defpdu_hdr_sz * index));
+
+		pasync_header_h->pa.u.a64.address =
+		    pasync_ctx->async_header.pa_base.u.a64.address +
+		    (p->defpdu_hdr_sz * index);
+
+		list_add_tail(&pasync_header_h->link,
+			      &pasync_ctx->async_header.free_list);
+		pasync_header_h++;
+		pasync_ctx->async_header.free_entries++;
+		pasync_ctx->async_header.writables++;
+
+		/* initialize the common part
+		   initialize wait queue */
+		INIT_LIST_HEAD(&pasync_ctx->async_entry[index].wait_queue.list);
+		/* initialize the busy list */
+		INIT_LIST_HEAD(&pasync_ctx->async_entry[index].
+			       header_busy_list);
+
+		/*      initialize the data part        */
+
+		/*      setup the free_list     */
+		pasync_data_h->cri = -1;
+		pasync_data_h->index = (char)index;
+		INIT_LIST_HEAD(&pasync_data_h->link);
+		pasync_data_h->pbuffer =
+		    (void *)((unsigned long)(pasync_ctx->async_data.va_base) +
+			     (p->defpdu_data_sz * index));
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
+		/*      initialize the busy list        */
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
+	WARN_ON(!sgl);
+	memset(sgl, 0x0, sizeof(*sgl));
+}
+
+
+static void hwi_build_be_sgl_arr(struct beiscsi_hba *phba,
+		struct mem_array *pmem, struct be_dma_mem *sgl)
+{
+	struct hwi_controller_ws *phwi_controller;
+
+	WARN_ON(!sgl);
+	WARN_ON(!phba);
+	phwi_controller = GET_HWI_CONTROLLER_WS(phba);
+	WARN_ON(!phwi_controller);
+
+	/*  Destroy any existing SGL */
+	if (sgl->va)
+		be_sgl_destroy_contiguous(sgl);
+
+	be_sgl_create_contiguous(pmem->virtual_address,
+				 pmem->bus_address.u.a64.address,
+				 pmem->size, sgl);
+}
+
+static void hwi_build_be_sgl_by_offset(struct beiscsi_hba *phba,
+		struct mem_array *pmem, struct be_dma_mem *sgl)
+{
+	struct hwi_controller_ws *phwi_controller;
+
+	WARN_ON(!sgl);
+	WARN_ON(!phba);
+	phwi_controller = GET_HWI_CONTROLLER_WS(phba);
+	WARN_ON(!phwi_controller);
+
+	/* Destroy any existing SGL */
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
+		return -1;
+	memset(mem->va, 0, mem->size);
+	return 0;
+}
+
+static int
+beiscsi_create_eq(struct beiscsi_hba *phba,
+		struct hwi_context_memory *phwi_context)
+{
+	uint idx;
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
+	if (be_fill_queue
+	    (eq, phba->params.num_eq_entries, sizeof(struct be_eq_entry),
+	     eq_vaddress)) {
+		dev_err(&phba->pcidev->dev, "be_fill_queue Failed for EQ \n");
+		return -1;
+	}
+	mem->dma = mem_descr->mem_array[idx].bus_address.u.a64.address;
+
+	if (be_cmd_eq_create(&phba->ctrl, eq, phwi_context->be_eq.cur_eqd)) {
+		dev_err(&phba->pcidev->dev, "be_cmd_eq_creat Failed for EQ \n");
+		return -1;
+	}
+	SE_DEBUG(DBG_LVL_8, "eq id is %d\n", phwi_context->be_eq.q.id);
+
+	return 0;
+}
+
+static int
+beiscsi_create_cq(struct beiscsi_hba *phba,
+		struct hwi_context_memory *phwi_context)
+{
+	uint idx;
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
+	if (be_fill_queue(cq, phba->params.icds_per_ctrl / 2,
+		sizeof(struct sol_cqe), cq_vaddress)) {
+		dev_err(&phba->pcidev->dev,
+				"be_fill_queue Failed for ISCSI CQ \n");
+		return -1;
+	}
+
+	mem->dma = mem_descr->mem_array[idx].bus_address.u.a64.address;
+	if (be_cmd_cq_create(&phba->ctrl, cq, eq, false, false, 0)) {
+		dev_err(&phba->pcidev->dev,
+				"be_cmd_eq_creat Failed for ISCSI CQ \n");
+		return -1;
+	}
+	SE_DEBUG(DBG_LVL_8, "iscsi cq id is %d\n", phwi_context->be_cq.id);
+	SE_DEBUG(DBG_LVL_8, "ISCSI CQ CREATED\n");
+	return 0;
+}
+
+static int
+beiscsi_create_def_hdr(struct beiscsi_hba *phba,
+		struct hwi_context_memory *phwi_context,
+		struct hwi_controller_ws *phwc,
+		unsigned int def_pdu_ring_sz)
+{
+	uint idx;
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
+	if (be_fill_queue
+	    (dq, mem_descr->mem_array[0].size / sizeof(struct phys_addr),
+	     sizeof(struct phys_addr), dq_vaddress)) {
+		dev_err(&phba->pcidev->dev,
+				"be_fill_queue Failed for DEF PDU HDR\n");
+		return -1;
+	}
+	mem->dma = mem_descr->mem_array[idx].bus_address.u.a64.address;
+	if (be_cmd_create_default_pdu_queue
+	    (&phba->ctrl, cq, dq, def_pdu_ring_sz,
+	     phba->params.defpdu_hdr_sz)) {
+		dev_err(&phba->pcidev->dev,
+				"be_cmd_eq_creat Failed for DEF PDU HDR\n");
+		return -1;
+	}
+	phwc->default_pdu_hdr.id = phwi_context->be_def_hdrq.id;
+	SE_DEBUG(DBG_LVL_8, "iscsi def pdu id is %d\n",
+		 phwi_context->be_def_hdrq.id);
+	/*  Now that the default PDU ring header has been
+	 *  created, let the EP know  about it... */
+	hwi_post_async_buffers(phba, 1);	/* header */
+	return 0;
+}
+
+static int
+beiscsi_create_def_data(struct beiscsi_hba *phba,
+		struct hwi_context_memory *phwi_context,
+		struct hwi_controller_ws *phwc,
+		unsigned int def_pdu_ring_sz)
+{
+	uint idx;
+	struct be_queue_info *dataq, *cq;
+	struct be_dma_mem *mem;
+	struct be_mem_descriptor *mem_descr;
+	void *dq_vaddress;
+
+	/* Now, for default Data Ring     */
+	idx = 0;
+	dataq = &phwi_context->be_def_dataq;
+	cq = &phwi_context->be_cq;
+	mem = &dataq->dma_mem;
+	mem_descr = phba->init_mem;
+	mem_descr += HWI_MEM_ASYNC_DATA_RING;
+	dq_vaddress = mem_descr->mem_array[idx].virtual_address;
+	if (be_fill_queue
+	    (dataq, mem_descr->mem_array[0].size / sizeof(struct phys_addr),
+	     sizeof(struct phys_addr), dq_vaddress)) {
+		dev_err(&phba->pcidev->dev,
+				"be_fill_queue Failed for DEF PDU DATA\n");
+		return -1;
+	}
+	mem->dma = mem_descr->mem_array[idx].bus_address.u.a64.address;
+	if (be_cmd_create_default_pdu_queue
+	    (&phba->ctrl, cq, dataq, def_pdu_ring_sz,
+	     phba->params.defpdu_data_sz)) {
+		dev_err(&phba->pcidev->dev,
+			 "be_cmd_eq_creat Failed for DEF PDU DATA\n");
+		return -1;
+	}
+	phwc->default_pdu_data.id = phwi_context->be_def_dataq.id;
+	SE_DEBUG(DBG_LVL_8, "iscsi def data id is %d\n",
+		 phwi_context->be_def_dataq.id);
+	hwi_post_async_buffers(phba, 0);	/* data */
+
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
+
+	mem_descr = phba->init_mem;
+	mem_descr += HWI_MEM_SGE;
+	pm_arr = mem_descr->mem_array;
+
+	page_offset =
+	    (sizeof(struct iscsi_sge) * phba->params.num_sge_per_io *
+	     phba->fw_config.iscsi_icd_start) / PAGE_SIZE;
+	for (i = 0; i < mem_descr->num_elements; i++) {
+		hwi_build_be_sgl_arr(phba, pm_arr, (struct be_dma_mem *)&sgl);
+		status =
+		    be_cmd_iscsi_post_sgl_pages(&phba->ctrl,
+			(struct be_dma_mem *)&sgl, page_offset,
+				(pm_arr->size / PAGE_SIZE));
+		page_offset += pm_arr->size / PAGE_SIZE;
+		if (status != 0) {
+			dev_err(&phba->pcidev->dev,
+					"post sgl failed.\n");
+			return status;
+		}
+		pm_arr++;
+	}
+
+	SE_DEBUG(DBG_LVL_8, "POSTED PAGES \n");
+	return 0;
+}
+
+static int
+beiscsi_create_wrb_rings(struct beiscsi_hba *phba,
+		struct hwi_context_memory *phwi_context,
+		struct hwi_controller_ws *phwc)
+{
+	unsigned int wrb_mem_index, offset, size, num_wrb_rings;
+	u64 pa_addr_lo;
+	uint idx, num, i;
+	struct mem_array *pwrb_arr;
+	void *wrb_vaddr;
+	struct be_dma_mem sgl;
+	struct be_mem_descriptor *mem_descr;
+	int status;
+
+	idx = 0;
+	mem_descr = phba->init_mem;
+	mem_descr += HWI_MEM_WRB;
+	pwrb_arr = kmalloc(sizeof(*pwrb_arr)
+			* phba->params.cxns_per_ctrl, GFP_KERNEL);
+	if (!pwrb_arr) {
+		dev_err(&phba->pcidev->dev,
+			"Memory alloc failed in create wrb ring.\n");
+		return -1;
+	}
+	wrb_vaddr = mem_descr->mem_array[idx].virtual_address;
+	pa_addr_lo = mem_descr->mem_array[idx].bus_address.u.a64.address;
+	num_wrb_rings = mem_descr->mem_array[idx].size /
+	    (phba->params.wrbs_per_cxn * sizeof(struct iscsi_wrb));
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
+				     bus_address.u.a64.address;
+			num_wrb_rings = mem_descr->mem_array[idx].size /
+			    (phba->params.wrbs_per_cxn *
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
+
+		wrb_mem_index = 0;
+		offset = 0;
+		size = 0;
+
+		hwi_build_be_sgl_by_offset(phba, &pwrb_arr[i],
+					   (struct be_dma_mem *)&sgl);
+		status = be_cmd_wrbq_create(&phba->ctrl,
+			 (struct be_dma_mem *)&sgl, &phwi_context->be_wrbq[i]);
+		if (status != 0) {
+			dev_err(&phba->pcidev->dev, "wrbq create failed.");
+			return -1;
+		}
+		phwc->wrb_context[i].cid = phwi_context->be_wrbq[i].id;
+	}
+	kfree(pwrb_arr);
+	return 0;
+}
+
+
+static int hwi_init_port(struct beiscsi_hba *phba)
+{
+
+	struct hwi_controller_ws *phwc;
+	struct hwi_context_memory *phwi_context;
+	unsigned int def_pdu_ring_sz;
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	int status;
+	unsigned int num_sge = 0;
+	unsigned int sebits = 0;
+
+	def_pdu_ring_sz =
+	    phba->params.asyncpdus_per_ctrl * sizeof(struct phys_addr);
+	phwc = GET_HWI_CONTROLLER_WS(phba);
+	WARN_ON(!phwc);
+
+	phwi_context = phwc->phwic;
+	WARN_ON(!phwi_context);
+	phwi_context->be_eq.max_eqd = 0;
+	phwi_context->be_eq.min_eqd = 0;
+	phwi_context->be_eq.cur_eqd = 64;
+	phwi_context->be_eq.enable_aic = false;
+
+	be_cmd_fw_initiallize(&phba->ctrl);
+	status = beiscsi_create_eq(phba, phwi_context);
+	if (status != 0) {
+		dev_err(&phba->pcidev->dev, "EQ not created \n");
+		goto error;
+	}
+
+	status = mgmt_check_supported_fw(ctrl);
+	if (status != 0) {
+		dev_err(&phba->pcidev->dev, "Unsupported fw version \n");
+		goto error;
+	}
+
+	status = mgmt_get_fw_config(ctrl, phba);
+	if (status != 0) {
+		dev_err(&phba->pcidev->dev, "Error getting fw config\n");
+		goto error;
+	}
+
+	status = beiscsi_create_cq(phba, phwi_context);
+	if (status != 0) {
+		dev_err(&phba->pcidev->dev, "CQ not created \n");
+		goto error;
+	}
+
+
+	status = beiscsi_create_def_hdr(phba,
+					phwi_context, phwc, def_pdu_ring_sz);
+	if (status != 0) {
+		dev_err(&phba->pcidev->dev, "Default Header not created \n");
+		goto error;
+	}
+
+	status = beiscsi_create_def_data(phba, phwi_context,
+						phwc, def_pdu_ring_sz);
+	if (status != 0) {
+		dev_err(&phba->pcidev->dev, "Default Data not created \n");
+		goto error;
+	}
+
+	status = beiscsi_post_pages(phba);
+	if (status != 0) {
+		dev_err(&phba->pcidev->dev, "Post SGL Pages Failed \n");
+		goto error;
+	}
+
+	status = beiscsi_create_wrb_rings(phba,	phwi_context, phwc);
+	if (status != 0) {
+		dev_err(&phba->pcidev->dev, "WRB Rings not created\n");
+		goto error;
+	}
+	WARN_ON(!phba->params.num_sge_per_io);
+	num_sge = phba->params.num_sge_per_io;
+
+	/* Set the frag_num sebits. Used when driver does
+	 * not use 32 ISCSI_SGEs.
+	 */
+	if (num_sge != 32) {
+		while (num_sge != 0x1) {
+			num_sge = (num_sge >> 1);
+			sebits++;
+		}
+
+		SE_DEBUG(DBG_LVL_8, "Using %d sebits for frag_num "
+				"in ISCSI_SGL_CRA\n", sebits);
+		status = mgmt_set_fragnum_bits(phba, sebits);
+		if (status != 0) {
+			dev_err(&phba->pcidev->dev, "Cannot set fragnum"
+					"sebits\n");
+			goto error;
+		}
+
+	}
+
+	SE_DEBUG(DBG_LVL_8, "hwi_init_port success\n");
+	return 0;
+
+error:
+	dev_err(&phba->pcidev->dev, "hwi_init_port failed");
+	hwi_cleanup(phba);
+	return 1;
+
+}
+
+static int hwi_init_controller(struct beiscsi_hba *phba)
+{
+	struct hwi_controller_ws *phwi_controller;
+
+	phwi_controller = GET_HWI_CONTROLLER_WS(phba);
+	if (1 == phba->init_mem[HWI_MEM_ADDN_CONTEXT].num_elements) {
+		phwi_controller->phwic = (struct hwi_context_memory *)phba->
+		    init_mem[HWI_MEM_ADDN_CONTEXT].mem_array[0].virtual_address;
+		SE_DEBUG(DBG_LVL_8, " phwi_controller->phwic=%p \n",
+			 phwi_controller->phwic);
+	} else {
+		dev_err(&phba->pcidev->dev,
+			 "HWI_MEM_ADDN_CONTEXT is more than one element."
+			 "Failing to load\n");
+		return -ENOMEM;
+	}
+
+	iscsi_init_global_templates(phba);
+	beiscsi_init_wrb_handle(phba);
+	hwi_init_async_pdu_ctx(phba);
+	if (hwi_init_port(phba) != 0) {
+		dev_err(&phba->pcidev->dev,
+			"hwi_init_controller failed\n");
+		return 1;
+	}
+
+	return 0;
+
+}
+
+void beiscsi_free_mem(struct beiscsi_hba *phba)
+{
+	struct be_mem_descriptor *mem_descr;
+	int i, j;
+
+	mem_descr = phba->init_mem;
+	i = 0;
+	j = 0;
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_free_mem phba=%p init_mem=%p \n", phba,
+		 phba->init_mem);
+
+	for (i = 0; i < SE_MEM_MAX; i++) {
+
+		for (j = mem_descr->num_elements; j > 0; j--) {
+			pci_free_consistent(phba->pcidev,
+			  mem_descr->mem_array[j - 1].size,
+			  (void *)mem_descr->mem_array[j - 1].virtual_address,
+			  mem_descr->mem_array[j - 1].bus_address.
+				u.a64.address);
+		}
+		mem_descr++;
+	}
+	kfree(phba->init_mem);
+	kfree(phba->phwi_ws);
+}
+
+static int beiscsi_init_controller(struct beiscsi_hba *phba)
+{
+	int ret = -1;
+
+	ret = beiscsi_get_memory(phba);
+	if (ret < 0) {
+		dev_err(&phba->pcidev->dev, "beiscsi_dev_probe - Failed in"
+			 "beiscsi_alloc_memory \n");
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
+	void *puse_sgl_handle;
+	struct iscsi_sge *pfrag;
+	unsigned int arr_index, i, idx;
+
+	/* Initiallize IO Handle */
+
+	phba->io_sgl_handles_available = 0;
+	phba->eh_sgl_handles_available = 0;
+	mem_descr_sglh = phba->init_mem;
+	mem_descr_sglh += HWI_MEM_SGLH;
+	if (1 == mem_descr_sglh->num_elements) {
+		phba->io_sgl_handle_base =
+		    kmalloc(sizeof(struct sgl_handle *) *
+			    phba->params.ios_per_ctrl, GFP_KERNEL);
+		phba->eh_sgl_handle_base =
+		    kmalloc(sizeof(struct sgl_handle *) *
+			    (phba->params.icds_per_ctrl -
+			     phba->params.ios_per_ctrl), GFP_KERNEL);
+	} else {
+		dev_err(&phba->pcidev->dev,
+			 "HWI_MEM_SGLH is more than one element."
+			 "Failing to load\n");
+		return -ENOMEM;
+	}
+	puse_sgl_handle = phba->io_sgl_handle_base;
+	memset(phba->io_sgl_handle_base, 0x0,
+	       (sizeof(struct sgl_handle *) * phba->params.ios_per_ctrl));
+
+	arr_index = 0;
+	idx = 0;
+	while (idx < mem_descr_sglh->num_elements) {
+		psgl_handle = mem_descr_sglh->mem_array[idx].virtual_address;
+
+		for (i = 0; i < (mem_descr_sglh->mem_array[idx].size /
+		      sizeof(struct sgl_handle)); i++) {
+			if (arr_index < phba->params.ios_per_ctrl) {
+				phba->io_sgl_handle_base[arr_index] =
+				    psgl_handle;
+				phba->io_sgl_handles_available++;
+				arr_index++;
+			} else {
+
+				phba->eh_sgl_handle_base[arr_index -
+				 phba->params.ios_per_ctrl] = psgl_handle;
+				arr_index++;
+				phba->eh_sgl_handles_available++;
+			}
+			psgl_handle++;
+		}
+		idx++;
+	}
+
+	SE_DEBUG(DBG_LVL_8,
+		 "phba->io_sgl_handles_available=%d"
+		 "phba->eh_sgl_handles_available=%d \n",
+		 phba->io_sgl_handles_available,
+		 phba->eh_sgl_handles_available);
+	/* Initiallize sge_frags and indices */
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
+		     i <
+		     (mem_descr_sg->mem_array[idx].size) /
+		     (sizeof(struct iscsi_sge) * phba->params.num_sge_per_io);
+		     i++) {
+			if (arr_index < phba->params.ios_per_ctrl) {
+				psgl_handle =
+				    (struct sgl_handle *)phba->
+				    io_sgl_handle_base[arr_index];
+			} else {
+				psgl_handle =
+				    (struct sgl_handle *)phba->
+				    eh_sgl_handle_base[arr_index -
+						       phba->params.
+						       ios_per_ctrl];
+			}
+			psgl_handle->pfrag = pfrag;
+			AMAP_SET_BITS(struct amap_iscsi_sge, addr_hi, pfrag, 0);
+			AMAP_SET_BITS(struct amap_iscsi_sge, addr_lo, pfrag, 0);
+			pfrag += phba->params.num_sge_per_io;
+			psgl_handle->sgl_index =
+			    phba->fw_config.iscsi_cid_start + arr_index++;
+		}
+		idx++;
+	}
+
+	phba->io_sgl_free_index = 0;
+	phba->io_sgl_alloc_index = 0;
+
+	phba->eh_sgl_free_index = 0;
+	phba->eh_sgl_alloc_index = 0;
+	return 0;
+}
+
+static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
+{
+	int i, new_cid;
+
+	phba->cid_array =
+	    kmalloc(sizeof(void *) * phba->params.cxns_per_ctrl * 2,
+			    GFP_KERNEL);
+	if (!phba->cid_array) {
+		dev_err(&phba->pcidev->dev,
+			 "Failed to allocate memory in hba_setup_cid_tbls \n");
+		return -1;
+	}
+	phba->ep_array =
+	    kmalloc(sizeof(unsigned long *) *
+			    phba->params.cxns_per_ctrl * 2, GFP_KERNEL);
+	if (!phba->ep_array) {
+		dev_err(&phba->pcidev->dev,
+			 "Failed to allocate memory in hba_setup_cid_tbls \n");
+		return -1;
+	}
+	new_cid = phba->fw_config.iscsi_icd_start;
+	for (i = 0; i < phba->params.cxns_per_ctrl; i++) {
+		phba->cid_array[i] = new_cid;
+		/*for even cid, cid_array contains 0,2,4, etc at locatio
+		 * n 0,1,2,...
+		 * */
+		new_cid += 2;
+	}
+	phba->avlbl_cids = phba->params.cxns_per_ctrl;
+	return 0;
+}
+
+void hwi_cleanup(struct beiscsi_hba *phba)
+{
+	struct be_queue_info *q;
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct hwi_controller_ws *phwc;
+	struct hwi_context_memory *phwi_context;
+	int i;
+	phwc = GET_HWI_CONTROLLER_WS(phba);
+	phwi_context = phwc->phwic;
+
+	/*Destroy all wrbq's */
+	for (i = 0; i < phba->params.cxns_per_ctrl; i++) {
+		q = &phwi_context->be_wrbq[i];
+		if (q->created)
+			be_cmd_q_destroy(ctrl, q, QTYPE_WRBQ);
+	}
+
+
+	/*Destroy the default PDU queues */
+	q = &phwi_context->be_def_hdrq;
+	if (q->created)
+		be_cmd_q_destroy(ctrl, q, QTYPE_DPDUQ);
+
+	/*Destroy the default PDU data queues */
+	q = &phwi_context->be_def_dataq;
+	if (q->created)
+		be_cmd_q_destroy(ctrl, q, QTYPE_DPDUQ);
+
+	/*Destroy the SGL pages */
+
+	be_cmd_q_destroy(ctrl, NULL, QTYPE_SGL);
+
+	/*Destroy iscsi CQ */
+	q = &phwi_context->be_cq;
+	if (q->created)
+		be_cmd_q_destroy(ctrl, q, QTYPE_CQ);
+
+	/*Destroy EQ */
+	q = &phwi_context->be_eq.q;
+	if (q->created)
+		be_cmd_q_destroy(ctrl, q, QTYPE_EQ);
+
+}
+
+ void hwi_ring_cq_db(struct beiscsi_hba *phba,
+		unsigned int id, unsigned int num_processed,
+		unsigned char rearm, unsigned char event)
+{
+	u32 val = 0;
+	val |= id & DB_CQ_RING_ID_MASK;
+	if (rearm)
+		val |= 1 << DB_CQ_REARM_SHIFT;
+	val |= num_processed << DB_CQ_NUM_POPPED_SHIFT;
+	iowrite32(val, phba->db_va + DB_CQ_OFFSET);
+}
+
+void hwi_ring_eq_db(struct beiscsi_hba *phba,
+		unsigned int id, unsigned int clr_interrupt,
+		unsigned int num_processed,
+		unsigned char rearm, unsigned char event)
+{
+	u32 val = 0;
+	val |= id & DB_EQ_RING_ID_MASK;
+	if (rearm)
+		val |= 1 << DB_EQ_REARM_SHIFT;
+	if (clr_interrupt)
+		val |= 1 << DB_EQ_CLR_SHIFT;
+	val |= 1 << DB_EQ_EVNT_SHIFT;
+	val |= num_processed << DB_EQ_NUM_POPPED_SHIFT;
+	iowrite32(val, phba->db_va + DB_EQ_OFFSET);
+}
+
+unsigned char hwi_enable_intr(struct beiscsi_hba *phba)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct hwi_controller_ws *phwi_controller;
+	struct hwi_context_memory *phwi_context;
+	struct be_queue_info *eq;
+	u8 __iomem *addr;
+	u32 reg;
+	u32 enabled;
+
+	phwi_controller = GET_HWI_CONTROLLER_WS(phba);
+	phwi_context = phwi_controller->phwic;
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
+		hwi_ring_eq_db(phba, eq->id, 0,	/* clear interrupt */
+			       0, 1, 1);
+
+	} else
+		dev_warn(&phba->pcidev->dev,
+				"In hwi_enable_intr, Not Enabled \n");
+
+	return true;
+
+}
+
+void hwi_disable_intr(struct beiscsi_hba *phba)
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
+		dev_warn(&phba->pcidev->dev,
+				"In hwi_enable_intr, Not Disbaled \n");
+
+}
+
+int beiscsi_init_port(struct beiscsi_hba *phba)
+{
+	int ret = -1;
+
+	ret = beiscsi_init_controller(phba);
+	if (ret < 0) {
+		dev_err(&phba->pcidev->dev,
+			 "beiscsi_dev_probe - Failed in"
+			 "beiscsi_init_controller \n");
+		goto do_cleanup_ctrlr;
+	}
+	ret = beiscsi_init_sgl_handle(phba);
+	if (ret < 0) {
+		dev_err(&phba->pcidev->dev,
+			 "beiscsi_dev_probe - Failed in"
+			 "beiscsi_init_sgl_handle \n");
+		goto do_cleanup_ctrlr;
+	}
+
+	if (hba_setup_cid_tbls(phba)) {
+		dev_err(&phba->pcidev->dev,
+			"Failed in hba_setup_cid_tbls\n");
+		goto do_cleanup_ctrlr;
+	}
+
+	return ret;
+
+do_cleanup_ctrlr:
+	hwi_cleanup(phba);
+
+	return ret;
+}
+static void hwi_purge_eq(struct beiscsi_hba *phba)
+{
+	struct hwi_controller_ws *phwi_controller;
+	struct hwi_context_memory *phwi_context;
+	struct be_queue_info *eq;
+	struct be_eq_entry *eqe = NULL;
+
+	phwi_controller = GET_HWI_CONTROLLER_WS(phba);
+	phwi_context = phwi_controller->phwic;
+
+	eq = &phwi_context->be_eq.q;
+
+	eqe = queue_tail_node(eq);
+
+	while ((eqe->
+		dw[offsetof(struct amap_eq_entry, valid) /
+		   32] & EQE_VALID_MASK)) {
+
+		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
+		queue_tail_inc(eq);
+		eqe = queue_tail_node(eq);
+	}
+}
+
+void beiscsi_clean_port(struct beiscsi_hba *phba)
+{
+	struct hwi_controller_ws *phwc;
+	unsigned char mgmt_status;
+
+	/* initiate cleanup of EP firmware */
+	mgmt_status = mgmt_epfw_cleanup(phba, CMD_CONNECTION_CHUTE_0);
+
+	/* destroy all rings */
+	hwi_cleanup(phba);
+
+	/* purge all EQ entries that may have been left out
+	 * This is to workaround a problem we've seen occasionally where
+	 * we exit from be_stop_controller and we get an interrupt
+	 * with EQ entry bit set
+	 */
+	hwi_purge_eq(phba);
+
+	/* destroy SA device object  */
+	phwc = GET_HWI_CONTROLLER_WS(phba);
+}
+
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
+	do {
+		pwrb_handle = alloc_wrb_handle(phba,
+				beiscsi_conn->beiscsi_conn_cid);
+	} while (!pwrb_handle);
+
+	pwrb = (struct iscsi_target_context_update_wrb *)pwrb_handle->pwrb;
+	memset(pwrb, 0x0, sizeof(*pwrb));
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb,
+		      max_burst_length, pwrb, params->dw[offsetof
+			 (struct amap_beiscsi_offload_params,
+			  max_burst_length) / 32]);
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb,
+	      max_send_data_segment_length, pwrb,
+	      params->dw[offsetof(struct amap_beiscsi_offload_params,
+			  max_send_data_segment_length) / 32]);
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb,
+		first_burst_length,
+		pwrb, params->dw[offsetof(struct amap_beiscsi_offload_params,
+			  first_burst_length) / 32]);
+
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, erl, pwrb,
+		(params->dw[offsetof(struct amap_beiscsi_offload_params, erl) /
+			  32] & OFFLD_PARAMS_ERL));
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, dde, pwrb,
+		(params->dw[offsetof(struct amap_beiscsi_offload_params, dde) /
+			  32] & OFFLD_PARAMS_DDE) >> 2);
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, hde, pwrb,
+		(params->dw[offsetof(struct amap_beiscsi_offload_params, hde) /
+			  32] & OFFLD_PARAMS_HDE) >> 3);
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, ir2t, pwrb,
+		(params->dw[offsetof(struct amap_beiscsi_offload_params, ir2t) /
+			  32] & OFFLD_PARAMS_IR2T) >> 4);
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, imd, pwrb,
+		(params->dw[offsetof(struct amap_beiscsi_offload_params, imd) /
+			  32] & OFFLD_PARAMS_IMD) >> 5);
+	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb, stat_sn,
+		pwrb, (params->dw[offsetof(struct amap_beiscsi_offload_params,
+			   exp_statsn) / 32] + 1));
+
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
+
+	be_dws_le_to_cpu(pwrb, sizeof(struct iscsi_target_context_update_wrb));
+
+	doorbell |= beiscsi_conn->beiscsi_conn_cid & DB_WRB_POST_CID_MASK;
+	doorbell |= (pwrb_handle->wrb_index & DB_DEF_PDU_WRB_INDEX_MASK) <<
+					DB_DEF_PDU_WRB_INDEX_SHIFT;
+	doorbell |= 1 << DB_DEF_PDU_NUM_POSTED_SHIFT;
+
+	iowrite32(doorbell, phba->db_va + DB_TXULP0_OFFSET);
+	return;
+}
+
+
+/*
+ * beiscsi_task_xmit
+ * task: iscsi_command_task
+ */
+int beiscsi_task_xmit(struct iscsi_task *task)
+{
+	struct iscsi_conn *conn = task->conn;
+	struct beiscsi_io_task *io_task = task->dd_data;
+	struct iscsi_task *old_task = NULL;
+	struct scsi_cmnd *sc = task->sc;
+	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
+	struct scatterlist *sg;
+	unsigned int num_sg, writedir = 0, xferlen = 0;
+
+	SE_DEBUG(DBG_LVL_8,
+		 "\n\n In beiscsi_task_xmit task=%p conn=%p"
+		 "beiscsi_conn=%p \n", task, conn, beiscsi_conn);
+	io_task->conn = beiscsi_conn;
+
+	if (!sc) {
+		if (ISCSI_OP_SCSI_TMFUNC ==
+		    (task->hdr->opcode & ISCSI_OPCODE_MASK)) {
+			old_task =
+			    (struct iscsi_task *)iscsi_itt_to_task
+					(conn, ((struct iscsi_tm *)
+						task->hdr)->rtt);
+			io_task->old_task = old_task->dd_data;
+		}
+
+		return beiscsi_mtask(task);
+	}
+
+	io_task->scsi_cmnd = sc;
+	num_sg = scsi_dma_map(sc);
+	SE_DEBUG(DBG_LVL_8, "xferlen=0x%08x  sc=%p num_sg=%d \n",
+		 (scsi_bufflen(sc)), sc, num_sg);
+	xferlen = scsi_bufflen(sc);
+	sg = (struct scatterlist *)sc->sdb.table.sgl;
+	if (sc->sc_data_direction == DMA_TO_DEVICE) {
+		writedir = 1;
+		SE_DEBUG(DBG_LVL_8, "task->imm_count=0x%08x \n",
+			 task->imm_count);
+	} else {
+		writedir = 0;
+	}
+
+	return beiscsi_iotask(task, sg, num_sg, xferlen, writedir);
+}
+
+/* pdu management */
+
+int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
+		   unsigned int num_sg, unsigned int xferlen,
+		   unsigned int writedir)
+{
+
+	struct beiscsi_io_task *io_task = task->dd_data;
+	struct iscsi_conn *conn = task->conn;
+	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
+	struct beiscsi_hba *phba = beiscsi_conn->phba;
+	struct iscsi_cmd *hdr;
+	struct iscsi_wrb *pwrb = NULL;
+	unsigned int doorbell = 0;
+
+	io_task->pwrb_handle =
+	    alloc_wrb_handle(phba, beiscsi_conn->beiscsi_conn_cid);
+	spin_lock(&phba->sgl_lock);
+	io_task->psgl_handle = alloc_io_sgl_handle(phba);
+	spin_unlock(&phba->sgl_lock);
+
+	if (!io_task->pwrb_handle || !io_task->psgl_handle) {
+		/* We are in session-lock, so can't loop here untill
+		 * free wrb is available
+		 * have to free sgl-icd index as well
+		 */
+		SE_DEBUG(DBG_LVL_1,
+			 "Alloc of WRB/SGL_ICD Failed,Not yet handled");
+		return -1;
+	}
+
+	io_task->pwrb_handle->pio_handle = task;
+	pwrb = io_task->pwrb_handle->pwrb;
+	SE_DEBUG(DBG_LVL_8, "In iotask task=%p, io_task=%p, pwrb=%p \n", task,
+		 io_task, pwrb);
+
+	SE_DEBUG(DBG_LVL_8, "pwrb_handle=%p\n", io_task->pwrb_handle);
+	SE_DEBUG(DBG_LVL_8, "wrb_index=%d\n", io_task->pwrb_handle->wrb_index);
+
+	hdr = (struct iscsi_cmd *)task->hdr;
+	/* Oh, we use a different itt for fw */
+	io_task->fw_itt = (itt_t)
+	    cpu_to_be32((uint)((io_task->pwrb_handle->wrb_index) << 16) |
+			(uint)(io_task->psgl_handle->sgl_index));
+	io_task->itt = io_task->cmd_bhs.iscsi_hdr.itt;
+
+	io_task->cmd_bhs.iscsi_hdr.itt = io_task->fw_itt;
+	io_task->cmd_bhs.iscsi_hdr.exp_statsn = 0;
+
+	io_task->bhs_len = sizeof(struct be_cmd_bhs);
+	io_task->bhs_pa.u.a64.address = virt_to_bus(&io_task->cmd_bhs);
+
+	if (writedir) {
+		/* Setting up data_pdu */
+		SE_DEBUG(DBG_LVL_8, " WRITE Command \t");
+		memset(&io_task->cmd_bhs.iscsi_data_pdu, 0, 48);
+		AMAP_SET_BITS(struct amap_pdu_data_out, itt,
+			      &io_task->cmd_bhs.iscsi_data_pdu,
+			      (unsigned int)io_task->fw_itt);
+		AMAP_SET_BITS(struct amap_pdu_data_out, opcode,
+			      &io_task->cmd_bhs.iscsi_data_pdu,
+			      ISCSI_OPCODE_SCSI_DATA_OUT);
+		AMAP_SET_BITS(struct amap_pdu_data_out, final_bit,
+			      &io_task->cmd_bhs.iscsi_data_pdu, 1);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, INI_WR_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
+
+		/* for writes, use r2t_buf_offset field to communicate number
+		 * of sg  elements in order to turn on the EP firmware's
+		 * fast path
+		 * */
+	} else {
+		SE_DEBUG(DBG_LVL_8, "READ Command \t");
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, INI_RD_CMD);
+
+	}
+	memcpy(&io_task->cmd_bhs.iscsi_data_pdu.
+	       dw[offsetof(struct amap_pdu_data_out, lun) / 32],
+	       io_task->cmd_bhs.iscsi_hdr.lun, sizeof(struct scsi_lun));
+
+	if ((hdr->opcode & ISCSI_OPCODE_MASK) == 0x1) {
+		io_task->resp_len = hdr->data_length;
+		if ((hdr->cdb[0] == 0x12) || (hdr->cdb[0] == 0xa0)
+		    || (hdr->cdb[0] == 0x25) || (hdr->cdb[0] == 0x1a)
+		    || (hdr->cdb[0] == 0x28)) {
+			io_task->resp_opcode = 0x25;
+		} else if ((hdr->cdb[0] == 0x00) || (hdr->cdb[0] == 0x2a)) {
+			io_task->resp_opcode = 0x21;
+		} else
+			SE_DEBUG(DBG_LVL_8, "cdb[0] == 0x%x NOT HANDLED\n",
+				 hdr->cdb[0]);
+	} else {
+		if ((hdr->opcode & ISCSI_OPCODE_MASK) == 0x05) {
+			io_task->resp_opcode = 0x21;
+		} else
+			SE_DEBUG(DBG_LVL_8,
+				 "Not yet supported hdr->opcode=0x%x\n",
+				 (hdr->opcode & ISCSI_OPCODE_MASK));
+	}
+
+	/* 14 bits of LUN info, from the first level in bigendian format */
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
+	SE_DEBUG(DBG_LVL_8, "IO Posting Done \n\n");
+	return 0;
+}
+
+int beiscsi_mtask(struct iscsi_task *task)
+{
+	struct beiscsi_io_task *io_task = task->dd_data;
+	struct iscsi_conn *conn = task->conn;
+	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
+	struct beiscsi_hba *phba = beiscsi_conn->phba;
+	struct iscsi_wrb *pwrb = NULL;
+	unsigned int doorbell = 0;
+
+	io_task->scsi_cmnd = NULL;
+	io_task->conn = beiscsi_conn;
+	io_task->pwrb_handle =
+	    alloc_wrb_handle(phba, beiscsi_conn->beiscsi_conn_cid);
+	if (!io_task->pwrb_handle) {
+		/* We are in session-lock, so can't loop here untill
+		 * free wrb is available
+		 * */
+		SE_DEBUG(DBG_LVL_1, "Not yet handled");
+		return -1;
+	}
+	io_task->pwrb_handle->pio_handle = task;
+	pwrb = io_task->pwrb_handle->pwrb;
+
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_mtask, opcode=0x%x \n",
+		 (task->hdr->opcode & ISCSI_OPCODE_MASK));
+	SE_DEBUG(DBG_LVL_8, "In mtask task=%p, io_task=%p, pwrb=%p \n", task,
+		 io_task, pwrb);
+	SE_DEBUG(DBG_LVL_8, "pwrb_handle=%p \n", io_task->pwrb_handle);
+	SE_DEBUG(DBG_LVL_8, "wrb_index=%d \n", io_task->pwrb_handle->wrb_index);
+
+	if (((task->hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN)) {
+		beiscsi_conn->task = task;
+		if (!beiscsi_conn->login_in_progress) {
+
+			do {
+				io_task->psgl_handle = (struct sgl_handle *)
+						alloc_eh_sgl_handle(phba);
+			} while (!io_task->psgl_handle);
+
+			beiscsi_conn->login_in_progress = 1;
+			beiscsi_conn->plogin_sgl_handle = io_task->psgl_handle;
+		} else {
+			io_task->psgl_handle = beiscsi_conn->plogin_sgl_handle;
+		}
+	} else {
+		beiscsi_conn->task = task;
+
+		do {
+			io_task->psgl_handle =
+				(struct sgl_handle *)alloc_eh_sgl_handle(phba);
+		} while (!io_task->psgl_handle);
+	}
+
+	/* Oh, we use a different itt for fw */
+	io_task->fw_itt = (itt_t) cpu_to_be32((((uint)(io_task->pwrb_handle->
+			 wrb_index) << 16) | (uint)(io_task->psgl_handle->
+				sgl_index)));
+	io_task->itt = io_task->cmd_bhs.iscsi_hdr.itt;
+	io_task->cmd_bhs.iscsi_hdr.itt = io_task->fw_itt;
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
+		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 0);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, cmdsn_itt, pwrb, 1);
+		hwi_write_buffer(pwrb, task);
+		break;
+	case ISCSI_OP_NOOP_OUT:
+		io_task->resp_opcode = 0x20;
+		if (task->data_count) {
+			AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, 1);
+			AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
+		} else {
+			AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 0);
+		}
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, INI_RD_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 0);
+		hwi_write_buffer(pwrb, task);
+		break;
+	case ISCSI_OP_SCSI_TMFUNC:
+		{
+
+			if (!io_task->old_task || !io_task->old_task->scsi_cmnd)
+				return 0;
+			mgmt_invalidate_icds(phba,
+					     io_task->old_task->psgl_handle->
+					     sgl_index,
+					     beiscsi_conn->beiscsi_conn_cid);
+			((struct iscsi_tm *)task->hdr)->rtt =
+				io_task->old_task->fw_itt;	/* Not storing
+								 * original rtt
+								 * here
+								 */
+		}
+		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 0);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, INI_TMF_CMD);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
+		hwi_write_buffer(pwrb, task);
+		break;
+	case ISCSI_OP_LOGOUT:
+		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 0);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
+		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
+				HWH_TYPE_LOGOUT);
+		hwi_write_buffer(pwrb, task);
+		break;
+
+	default:
+		SE_DEBUG(DBG_LVL_1, "opcode =%d Not supported \n",
+			 task->hdr->opcode & ISCSI_OPCODE_MASK);
+		return -1;
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
+
+	SE_DEBUG(DBG_LVL_8, "mtask posted");
+	return 0;
+}
+
+/* pdu processing */
+
+static void
+be_complete_login(struct beiscsi_conn *beiscsi_conn,
+		  struct iscsi_task *task, struct iscsi_login_rsp *ppdu,
+		  char *pbuffer, unsigned int buf_len)
+{
+	struct beiscsi_io_task *io_task = task->dd_data;
+
+	ppdu->itt = io_task->itt;
+	return;
+}
+
+unsigned int
+beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
+			  struct beiscsi_hba *phba,
+			  unsigned short cid,
+			  struct pdu_base *ppdu,
+			  unsigned long pdu_len,
+			  void *pbuffer, unsigned long buf_len)
+{
+
+	struct iscsi_task *task;
+	struct beiscsi_io_task *io_task;
+	unsigned long flags;
+	struct iscsi_conn *conn = beiscsi_conn->conn;
+	struct iscsi_session *session = conn->session;
+
+	unsigned int status = 0;
+
+	/* async pdus include
+	 * a. unsolicited NOP-In (target initiated NOP-In)
+	 * b. Async Messages
+	 * c. Reject PDU
+	 * d. Login response
+	 * These headers arrive unprocessed by the EP firmware and iSCSI layer
+	 * process them
+	 */
+	switch (ppdu->
+		dw[offsetof(struct amap_pdu_base, opcode) /
+		   32] & PDUBASE_OPCODE_MASK) {
+	case ISCSI_OP_NOOP_IN:
+		pbuffer = NULL;
+		buf_len = 0;
+		break;
+
+	case ISCSI_OP_ASYNC_EVENT:
+		break;
+
+	case ISCSI_OP_REJECT:
+
+		WARN_ON(!pbuffer);
+		WARN_ON(!(buf_len == 48));
+
+		SE_DEBUG(DBG_LVL_1, "In ISCSI_OP_REJECT\n");
+		break;
+
+	case ISCSI_OP_LOGIN_RSP:
+		/* saved login request task is used */
+		task = beiscsi_conn->task;
+		if (!task) {
+			SE_DEBUG(DBG_LVL_1, "\n No Task\n");
+			status = 1;
+			return status;
+		}
+
+		io_task = task->dd_data;
+		/* make sure that we got the login response for
+		 * the login request received on this connection
+		 */
+		if (io_task->fw_itt != ((struct iscsi_login_rsp *)ppdu)->itt) {
+			SE_DEBUG(DBG_LVL_8,
+					"Error: itt in login request 0x%x ,"
+					"itt in login response 0x%x\n",
+					io_task->fw_itt,
+					((struct iscsi_login_rsp *)ppdu)->itt);
+		}
+		be_complete_login(beiscsi_conn, task,
+				  (struct iscsi_login_rsp *)ppdu,
+				  (char *)pbuffer, buf_len);
+		break;
+
+	default:
+
+		dev_warn(&phba->pcidev->dev,
+			"Unrecognized opcode 0x%x in async msg \n",
+			 (ppdu->
+			  dw[offsetof(struct amap_pdu_base, opcode) /
+			     32] & PDUBASE_OPCODE_MASK));
+
+		status = 1;
+
+		return status;
+	}
+
+
+	/* as per open iscsi API, __iscsi_complete_pdu()
+	 * should be invoked under iscsi_session->lock
+	 */
+	SE_DEBUG(DBG_LVL_8, "In %s , grabbing session->lock\n", __func__);
+	spin_lock_irqsave(&session->lock, flags);
+	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)ppdu, pbuffer, buf_len);
+	spin_unlock_irqrestore(&session->lock, flags);
+
+	return 0;
+
+
+}
+
+static void
+be_complete_io(struct beiscsi_conn *beiscsi_conn,
+	       struct iscsi_task *task, struct sol_cqe *psol)
+{
+
+	struct iscsi_cmd_rsp *hdr;
+	struct beiscsi_io_task *io_task = task->dd_data;
+	struct be_status_bhs *sts_bhs =
+	    (struct be_status_bhs *)&io_task->cmd_bhs;
+	struct iscsi_conn *conn = beiscsi_conn->conn;
+	struct beiscsi_hba *phba = beiscsi_conn->phba;
+	unsigned int sense_len = 0;
+	unsigned int urlen;
+	hdr = (struct iscsi_cmd_rsp *)task->hdr;
+	hdr->opcode = io_task->resp_opcode;
+	hdr->exp_cmdsn = be32_to_cpu((psol->
+			dw[offsetof(struct amap_sol_cqe, i_exp_cmd_sn) /
+			    32] & SOL_EXP_CMD_SN_MASK));
+	hdr->max_cmdsn = be32_to_cpu((psol->
+			 dw[offsetof(struct amap_sol_cqe, i_exp_cmd_sn) /
+			    32] & SOL_EXP_CMD_SN_MASK) +
+			((psol->dw[offsetof(struct amap_sol_cqe, i_cmd_wnd) /
+			     32] & SOL_CMD_WND_MASK) >> 24) - 1);
+	hdr->response = ((psol->dw[offsetof(struct amap_sol_cqe, i_resp) /
+			 32] & SOL_RESP_MASK) >> 16);
+	hdr->cmd_status = ((psol->dw[offsetof(struct amap_sol_cqe, i_sts) /
+			 32] & SOL_STS_MASK) >> 8);
+	hdr->flags = ((psol->dw[offsetof(struct amap_sol_cqe, i_flags) /
+			 32] & SOL_FLAGS_MASK) >> 24) | 0x80;
+	hdr->itt = io_task->itt;
+	hdr->rsvd1 = 0xFFFFFFFF;
+
+	if (hdr->flags & 0x06) {
+		hdr->residual_count = ((psol->
+				dw[offsetof(struct amap_sol_cqe, i_res_cnt) /
+				32] & SOL_RES_CNT_MASK));
+		if ((hdr->flags & 0x02)) {
+			urlen = be32_to_cpu(io_task->resp_len);
+			urlen = urlen - hdr->residual_count;
+			io_task->resp_len = cpu_to_be32(urlen);
+		} else
+			SE_DEBUG(DBG_LVL_1, "\nOVERRUN\n");
+
+		hdr->bi_residual_count = 0x00;
+		hdr->residual_count =  cpu_to_be32((psol->
+				dw[offsetof(struct amap_sol_cqe, i_res_cnt) /
+				    32] & SOL_RES_CNT_MASK));
+
+	} else
+		hdr->residual_count = 0;
+
+	if ((io_task->resp_len & 0xff000000)) {
+		hdr->dlength[2] = (io_task->resp_len & 0xff000000) >> 24;
+		hdr->dlength[1] = (io_task->resp_len & 0x00ff0000) >> 16;
+		hdr->dlength[0] = (io_task->resp_len & 0x0000ff00) >> 8;
+	} else if (io_task->resp_len & 0x00ff0000) {
+		hdr->dlength[2] = 0x00;
+		hdr->dlength[1] = (io_task->resp_len & 0x00ff0000) >> 16;
+		hdr->dlength[0] = (io_task->resp_len & 0x0000ff00) >> 8;
+	} else if (io_task->resp_len & 0x0000ff00) {
+		hdr->dlength[2] = 0x00;
+		hdr->dlength[1] = 0x00;
+		hdr->dlength[0] = (io_task->resp_len & 0x0000ff00) >> 8;
+	}
+
+	if (hdr->opcode == ISCSI_OP_SCSI_DATA_IN)
+		goto io_done;
+
+	if (hdr->cmd_status == SAM_STAT_CHECK_CONDITION) {
+		conn->data = (unsigned char *)(sts_bhs->sense_info +
+					sizeof(unsigned short));
+		sense_len =
+		    cpu_to_be16((unsigned short)(sts_bhs->sense_info[0]));
+	} else {
+		conn->data = NULL;
+	}
+
+io_done:
+	if (io_task->cmd_bhs.iscsi_hdr.flags & ISCSI_FLAG_CMD_READ) {
+		conn->datain_pdus_cnt += 0;
+		if (psol->dw[offsetof(struct amap_sol_cqe, i_res_cnt) / 32]
+				& SOL_RES_CNT_MASK)
+			 conn->rxdata_octets += ((psol->
+			      dw[offsetof(struct amap_sol_cqe, i_res_cnt) /
+				 32] & SOL_RES_CNT_MASK));
+	} else {
+		conn->dataout_pdus_cnt += 0;
+		conn->txdata_octets += 0;
+	}
+	scsi_dma_unmap(io_task->scsi_cmnd);
+
+	spin_lock(&phba->sgl_lock);
+	free_io_sgl_handle(phba, io_task->psgl_handle);
+	spin_unlock(&phba->sgl_lock);
+	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, conn->data,
+			     sense_len);
+
+
+
+	return;
+}
+
+static void
+be_complete_logout(struct beiscsi_conn *beiscsi_conn,
+		   struct iscsi_task *task, struct sol_cqe *psol)
+{
+
+	struct iscsi_logout_rsp *hdr;
+	struct beiscsi_io_task *io_task = task->dd_data;
+	struct iscsi_conn *conn = beiscsi_conn->conn;
+	struct beiscsi_hba *phba = beiscsi_conn->phba;
+
+	hdr = (struct iscsi_logout_rsp *)task->hdr;
+	hdr->t2wait = 5;
+	hdr->t2retain = 0;
+	hdr->flags = ((psol->dw[offsetof(struct amap_sol_cqe, i_flags) /
+		 32] & SOL_FLAGS_MASK) >> 24) | 0x80;
+	hdr->response = (psol->dw[offsetof(struct amap_sol_cqe, i_resp) /
+		32] & SOL_RESP_MASK);
+	hdr->exp_cmdsn = cpu_to_be32(psol->
+			dw[offsetof(struct amap_sol_cqe, i_exp_cmd_sn) /
+			   32] & SOL_EXP_CMD_SN_MASK);
+	hdr->max_cmdsn = be32_to_cpu((psol->
+			 dw[offsetof(struct amap_sol_cqe, i_exp_cmd_sn) /
+			    32] & SOL_EXP_CMD_SN_MASK) +
+			((psol->dw[offsetof(struct amap_sol_cqe, i_cmd_wnd) /
+			     32] & SOL_CMD_WND_MASK) >> 24) - 1);
+	hdr->hlength = 0;
+	hdr->itt = io_task->itt;
+
+	spin_lock(&phba->sgl_lock);
+	free_eh_sgl_handle(phba, io_task->psgl_handle);
+	spin_unlock(&phba->sgl_lock);
+	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
+
+	return;
+}
+
+static void
+be_complete_tmf(struct beiscsi_conn *beiscsi_conn,
+		struct iscsi_task *task, struct sol_cqe *psol)
+{
+
+	struct iscsi_tm_rsp *hdr;
+	struct beiscsi_io_task *io_task = task->dd_data;
+	struct iscsi_conn *conn = beiscsi_conn->conn;
+	struct beiscsi_hba *phba = beiscsi_conn->phba;
+
+	hdr = (struct iscsi_tm_rsp *)task->hdr;
+	hdr->flags =
+	    ((psol->
+	      dw[offsetof(struct amap_sol_cqe, i_flags) /
+		 32] & SOL_FLAGS_MASK) >> 24) | 0x80;
+	hdr->response =
+	    (psol->
+	     dw[offsetof(struct amap_sol_cqe, i_resp) /
+		32] & SOL_RESP_MASK);
+	hdr->exp_cmdsn =
+	    cpu_to_be32(psol->
+			dw[offsetof(struct amap_sol_cqe, i_exp_cmd_sn) /
+			   32] & SOL_EXP_CMD_SN_MASK);
+	hdr->max_cmdsn =
+	    be32_to_cpu((psol->
+			 dw[offsetof(struct amap_sol_cqe, i_exp_cmd_sn) /
+			    32] & SOL_EXP_CMD_SN_MASK) +
+			((psol->
+			  dw[offsetof(struct amap_sol_cqe, i_cmd_wnd) /
+			     32] & SOL_CMD_WND_MASK) >> 24) - 1);
+	hdr->itt = io_task->itt;
+
+	spin_lock(&phba->sgl_lock);
+	free_eh_sgl_handle(phba, io_task->old_task->psgl_handle);
+	free_eh_sgl_handle(phba, io_task->psgl_handle);
+	spin_unlock(&phba->sgl_lock);
+	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
+
+	return;
+}
+
+/* This handles only NOPIN Resp , Req are processed by def pdu */
+static void
+be_complete_nopin_resp(struct beiscsi_conn *beiscsi_conn,
+		       struct iscsi_task *task, struct sol_cqe *psol)
+{
+
+	struct iscsi_nopin *hdr;
+	struct beiscsi_io_task *io_task = task->dd_data;
+	struct iscsi_conn *conn = beiscsi_conn->conn;
+	struct beiscsi_hba *phba = beiscsi_conn->phba;
+
+	SE_DEBUG(DBG_LVL_8, "In be_complete_nopin_resp \n");
+	hdr = (struct iscsi_nopin *)task->hdr;
+	hdr->flags =
+	    ((psol->
+	      dw[offsetof(struct amap_sol_cqe, i_flags) /
+		 32] & SOL_FLAGS_MASK) >> 24) | 0x80;
+	hdr->exp_cmdsn =
+	    cpu_to_be32(psol->
+			dw[offsetof(struct amap_sol_cqe, i_exp_cmd_sn) /
+			   32] & SOL_EXP_CMD_SN_MASK);
+	hdr->max_cmdsn =
+	    be32_to_cpu((psol->
+			 dw[offsetof(struct amap_sol_cqe, i_exp_cmd_sn) /
+			    32] & SOL_EXP_CMD_SN_MASK) +
+			((psol->
+			  dw[offsetof(struct amap_sol_cqe, i_cmd_wnd) /
+			     32] & SOL_CMD_WND_MASK) >> 24) - 1);
+	hdr->itt = io_task->itt;
+	hdr->opcode = io_task->resp_opcode;
+
+	spin_lock(&phba->sgl_lock);
+	free_eh_sgl_handle(phba, io_task->psgl_handle);
+	spin_unlock(&phba->sgl_lock);
+	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
+
+	return;
+}
+
+void
+hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
+		 struct beiscsi_hba *phba, struct sol_cqe *psol)
+{
+	struct hwi_wrb_context *pwrb_context;
+	struct wrb_handle *pwrb_handle;
+	struct iscsi_wrb *pwrb = NULL;
+	struct hwi_controller_ws *phwi_controller;
+	struct iscsi_task *task;
+	struct beiscsi_io_task *io_task;
+	struct iscsi_conn *conn = beiscsi_conn->conn;
+	unsigned long flags;
+	struct iscsi_session *session = conn->session;
+
+	phwi_controller = GET_HWI_CONTROLLER_WS(phba);
+
+	pwrb_context =
+	    &phwi_controller->
+	    wrb_context[((psol->
+			  dw[offsetof(struct amap_sol_cqe, cid) /
+			     32] & SOL_CID_MASK) >> 6)];
+	SE_DEBUG(DBG_LVL_8, "\t\t wrb_index=%d \n",
+		 ((psol->
+		   dw[offsetof(struct amap_sol_cqe, wrb_index) /
+		      32] & SOL_WRB_INDEX_MASK) >> 16));
+	pwrb_handle =
+	    (struct wrb_handle *)pwrb_context->
+	    pwrb_handle_basestd[((psol->
+				  dw[offsetof(struct amap_sol_cqe, wrb_index)
+				     / 32] & SOL_WRB_INDEX_MASK) >> 16)];
+	SE_DEBUG(DBG_LVL_8, "\t\t pwrb_handle=%p \n", pwrb_handle);
+	task = (struct iscsi_task *)pwrb_handle->pio_handle;
+	io_task = task->dd_data;
+
+	spin_lock_irqsave(&session->lock, flags);
+	pwrb = pwrb_handle->pwrb;
+	SE_DEBUG(DBG_LVL_8, "task=%p, io_task=%p, pwrb=%p \n", task, io_task,
+		 pwrb);
+
+	SE_DEBUG(DBG_LVL_8, "\t\t type=%d \n", ((pwrb->
+		 dw[offsetof(struct amap_iscsi_wrb, type) /
+		    32] & WRB_TYPE_MASK) >> 28));
+	switch ((pwrb->
+		 dw[offsetof(struct amap_iscsi_wrb, type) /
+		    32] & WRB_TYPE_MASK) >> 28) {
+	case HWH_TYPE_IO:
+	case HWH_TYPE_IO_RD:
+		SE_DEBUG(DBG_LVL_8,
+			 "be_complete_nopin_resp or  be_complete_io\n");
+		if ((task->hdr->opcode & ISCSI_OPCODE_MASK) ==
+		    ISCSI_OP_NOOP_OUT)
+			be_complete_nopin_resp(beiscsi_conn, task, psol);
+		else
+			be_complete_io(beiscsi_conn, task, psol);
+		break;
+
+	case HWH_TYPE_LOGOUT:
+		be_complete_logout(beiscsi_conn, task, psol);
+		break;
+
+	case HWH_TYPE_LOGIN:
+		SE_DEBUG(DBG_LVL_8,
+			 "\t\t No HWH_TYPE_LOGIN Expected in hwi_complete_cmd"
+			 "- Solicited path \n");
+		break;
+
+	case HWH_TYPE_TMF:
+
+		be_complete_tmf(beiscsi_conn, task, psol);
+
+		break;
+
+	case HWH_TYPE_NOP:
+		/* This is only in case initiator sent out a NOPOut and gets
+		 * back a NOPIn response. Async NOPIns end up in default PDU
+		 * queue
+		 */
+		be_complete_nopin_resp(beiscsi_conn, task, psol);
+		break;
+
+	default:
+		dev_warn(&phba->pcidev->dev,
+			 "wrb_index 0x%x CID 0x%x\n",
+			 ((psol->
+			   dw[offsetof(struct amap_iscsi_wrb, type) /
+			      32] & SOL_WRB_INDEX_MASK) >> 16),
+			 ((psol->
+			   dw[offsetof(struct amap_sol_cqe, cid) /
+			      32] & SOL_CID_MASK) >> 6));
+		break;
+	}
+
+	free_wrb_handle(phba, pwrb_context, pwrb_handle);
+	spin_unlock_irqrestore(&session->lock, flags);
+
+}
+
+void
+hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
+		       struct beiscsi_hba *phba, struct sol_cqe *psol)
+{
+	struct hwi_wrb_context *pwrb_context;
+	struct wrb_handle *pwrb_handle;
+	struct hwi_controller_ws *phwi_controller;
+	unsigned long flags;
+	struct iscsi_conn *conn = beiscsi_conn->conn;
+	struct iscsi_session *session = conn->session;
+
+	phwi_controller = GET_HWI_CONTROLLER_WS(phba);
+	pwrb_context =
+	    &phwi_controller->
+	    wrb_context[((psol->
+			  dw[offsetof(struct amap_sol_cqe, cid) /
+			     32] & SOL_CID_MASK) >> 6)];
+	pwrb_handle =
+	    (struct wrb_handle *)pwrb_context->
+	    pwrb_handle_basestd[((psol->
+				  dw[offsetof(struct amap_sol_cqe, wrb_index)
+				     / 32] & SOL_WRB_INDEX_MASK) >> 16)];
+	spin_lock_irqsave(&session->lock, flags);
+	free_wrb_handle(phba, pwrb_context, pwrb_handle);
+	spin_unlock_irqrestore(&session->lock, flags);
+
+}
+
+/*
+ *  This is the remove function reported in struct pci_driver.
+ */
+void beiscsi_remove(struct pci_dev *pcidev)
+{
+	struct beiscsi_hba *phba = NULL;
+
+	phba = (struct beiscsi_hba *)pci_get_drvdata(pcidev);
+	if (!phba) {
+		dev_err(&pcidev->dev, "beiscsi_remove called with no phba \n");
+		return;
+	}
+	hwi_disable_intr(phba);
+		if (phba->pcidev->irq)
+			free_irq(phba->pcidev->irq, phba);
+
+	/*
+	 * Lastly stop the hardware
+	 */
+
+	beiscsi_clean_port(phba);
+
+	beiscsi_unmap_pci_function(phba);
+	pci_dev_put(phba->pcidev);
+	pci_disable_device(phba->pcidev);
+	beiscsi_free_mem(phba);
+	iscsi_host_remove(phba->shost);
+	iscsi_host_free(phba->shost);
+
+}
+
+
+static int __init beiscsi_module_init(void)
+{
+	int ret;
+
+	beiscsi_scsi_transport =
+	    iscsi_register_transport(&beiscsi_iscsi_transport);
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
-- 
1.6.3
