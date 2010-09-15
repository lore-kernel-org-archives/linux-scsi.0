From: <kgudipat@brocade.com>
Subject: [PATCH 16/33] bfa: Add cleaned up (2.3.2.0) BFA driver specific code .
Date: Wed, 15 Sep 2010 12:08:34 -0700
Message-ID: <1284577714-19172-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:34384 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753605Ab0IOTKN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 15:10:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- The following patch adds back cleaned up (2.3.2.0) based BFA driver specific code:

	  bfad.c      : Contains the BFA module load/unload, pci probe/remove,
					interrupt handlers and user space firmware handling.
	  bfad_im.c   : Contains the scsi_host_template definitions, entries
					& IM specific code.
	  bfad_attr.c : Contains the fc_transport_template definitions and entries.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfad.c         | 1649 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfad_attr.c    |  241 ++++---
 drivers/scsi/bfa/bfad_debugfs.c |   10 +-
 drivers/scsi/bfa/bfad_im.c      |  257 +++----
 4 files changed, 1922 insertions(+), 235 deletions(-)
 create mode 100644 drivers/scsi/bfa/bfad.c

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
new file mode 100644
index 0000000..28f15f9
--- /dev/null
+++ b/drivers/scsi/bfa/bfad.c
@@ -0,0 +1,1649 @@
+/*
+ * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ *  bfad.c Linux driver PCI interface module.
+ */
+#include <linux/module.h>
+#include <linux/kthread.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/pci.h>
+#include <linux/firmware.h>
+#include <asm/uaccess.h>
+#include <asm/fcntl.h>
+
+#include "bfad_drv.h"
+#include "bfad_im.h"
+#include "bfa_fcs.h"
+#include "bfa_os_inc.h"
+#include "bfa_defs.h"
+#include "bfa.h"
+
+BFA_TRC_FILE(LDRV, BFAD);
+DEFINE_MUTEX(bfad_mutex);
+LIST_HEAD(bfad_list);
+
+static int	bfad_inst;
+static int      num_sgpgs_parm;
+int		supported_fc4s;
+char		*host_name, *os_name, *os_patch;
+int		num_rports, num_ios, num_tms;
+int		num_fcxps, num_ufbufs;
+int		reqq_size, rspq_size, num_sgpgs;
+int		rport_del_timeout = BFA_FCS_RPORT_DEF_DEL_TIMEOUT;
+int		bfa_lun_queue_depth = BFAD_LUN_QUEUE_DEPTH;
+int		bfa_io_max_sge = BFAD_IO_MAX_SGE;
+int		log_level = 3; /* WARNING log level */
+int		ioc_auto_recover = BFA_TRUE;
+int		bfa_linkup_delay = -1;
+int		fdmi_enable = BFA_TRUE;
+int		pcie_max_read_reqsz;
+int		bfa_debugfs_enable = 1;
+int		msix_disable_cb = 0, msix_disable_ct = 0;
+
+u32	bfi_image_ct_fc_size, bfi_image_ct_cna_size, bfi_image_cb_fc_size;
+u32     *bfi_image_ct_fc, *bfi_image_ct_cna, *bfi_image_cb_fc;
+
+const char *msix_name_ct[] = {
+	"cpe0", "cpe1", "cpe2", "cpe3",
+	"rme0", "rme1", "rme2", "rme3",
+	"ctrl" };
+
+const char *msix_name_cb[] = {
+	"cpe0", "cpe1", "cpe2", "cpe3",
+	"rme0", "rme1", "rme2", "rme3",
+	"eemc", "elpu0", "elpu1", "epss", "mlpu" };
+
+MODULE_FIRMWARE(BFAD_FW_FILE_CT_FC);
+MODULE_FIRMWARE(BFAD_FW_FILE_CT_CNA);
+MODULE_FIRMWARE(BFAD_FW_FILE_CB_FC);
+
+module_param(os_name, charp, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(os_name, "OS name of the hba host machine");
+module_param(os_patch, charp, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(os_patch, "OS patch level of the hba host machine");
+module_param(host_name, charp, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(host_name, "Hostname of the hba host machine");
+module_param(num_rports, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(num_rports, "Max number of rports supported per port "
+				"(physical/logical), default=1024");
+module_param(num_ios, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(num_ios, "Max number of ioim requests, default=2000");
+module_param(num_tms, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(num_tms, "Max number of task im requests, default=128");
+module_param(num_fcxps, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(num_fcxps, "Max number of fcxp requests, default=64");
+module_param(num_ufbufs, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(num_ufbufs, "Max number of unsolicited frame "
+				"buffers, default=64");
+module_param(reqq_size, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(reqq_size, "Max number of request queue elements, "
+				"default=256");
+module_param(rspq_size, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(rspq_size, "Max number of response queue elements, "
+				"default=64");
+module_param(num_sgpgs, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(num_sgpgs, "Number of scatter/gather pages, default=2048");
+module_param(rport_del_timeout, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(rport_del_timeout, "Rport delete timeout, default=90 secs, "
+					"Range[>0]");
+module_param(bfa_lun_queue_depth, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(bfa_lun_queue_depth, "Lun queue depth, default=32, Range[>0]");
+module_param(bfa_io_max_sge, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(bfa_io_max_sge, "Max io scatter/gather elements, default=255");
+module_param(log_level, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(log_level, "Driver log level, default=3, "
+				"Range[Critical:1|Error:2|Warning:3|Info:4]");
+module_param(ioc_auto_recover, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(ioc_auto_recover, "IOC auto recovery, default=1, "
+				"Range[off:0|on:1]");
+module_param(bfa_linkup_delay, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(bfa_linkup_delay, "Link up delay, default=30 secs for "
+			"boot port. Otherwise 10 secs in RHEL4 & 0 for "
+			"[RHEL5, SLES10, ESX40] Range[>0]");
+module_param(msix_disable_cb, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(msix_disable_cb, "Disable Message Signaled Interrupts "
+			"for Brocade-415/425/815/825 cards, default=0, "
+			" Range[false:0|true:1]");
+module_param(msix_disable_ct, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(msix_disable_ct, "Disable Message Signaled Interrupts "
+			"if possible for Brocade-1010/1020/804/1007/902/1741 "
+			"cards, default=0, Range[false:0|true:1]");
+module_param(fdmi_enable, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(fdmi_enable, "Enables fdmi registration, default=1, "
+				"Range[false:0|true:1]");
+module_param(pcie_max_read_reqsz, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(pcie_max_read_reqsz, "PCIe max read request size, default=0 "
+		"(use system setting), Range[128|256|512|1024|2048|4096]");
+module_param(bfa_debugfs_enable, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(bfa_debugfs_enable, "Enables debugfs feature, default=1,"
+		" Range[false:0|true:1]");
+
+static void
+bfad_sm_uninit(struct bfad_s *bfad, enum bfad_sm_event event);
+static void
+bfad_sm_created(struct bfad_s *bfad, enum bfad_sm_event event);
+static void
+bfad_sm_initializing(struct bfad_s *bfad, enum bfad_sm_event event);
+static void
+bfad_sm_operational(struct bfad_s *bfad, enum bfad_sm_event event);
+static void
+bfad_sm_stopping(struct bfad_s *bfad, enum bfad_sm_event event);
+static void
+bfad_sm_failed(struct bfad_s *bfad, enum bfad_sm_event event);
+static void
+bfad_sm_fcs_exit(struct bfad_s *bfad, enum bfad_sm_event event);
+
+/**
+ * Beginning state for the driver instance, awaiting the pci_probe event
+ */
+static void
+bfad_sm_uninit(struct bfad_s *bfad, enum bfad_sm_event event)
+{
+	bfa_trc(bfad, event);
+
+	switch (event) {
+	case BFAD_E_CREATE:
+		bfa_sm_set_state(bfad, bfad_sm_created);
+		bfad->bfad_tsk = kthread_create(bfad_worker, (void *) bfad,
+						"%s", "bfad_worker");
+		if (IS_ERR(bfad->bfad_tsk)) {
+			printk(KERN_INFO "bfad[%d]: Kernel thread "
+				"creation failed!\n", bfad->inst_no);
+			bfa_sm_send_event(bfad, BFAD_E_KTHREAD_CREATE_FAILED);
+		}
+		bfa_sm_send_event(bfad, BFAD_E_INIT);
+		break;
+
+	case BFAD_E_STOP:
+		/* Ignore stop; already in uninit */
+		break;
+
+	default:
+		bfa_sm_fault(bfad, event);
+	}
+}
+
+/**
+ * Driver Instance is created, awaiting event INIT to initialize the bfad
+ */
+static void
+bfad_sm_created(struct bfad_s *bfad, enum bfad_sm_event event)
+{
+	unsigned long flags;
+
+	bfa_trc(bfad, event);
+
+	switch (event) {
+	case BFAD_E_INIT:
+		bfa_sm_set_state(bfad, bfad_sm_initializing);
+
+		init_completion(&bfad->comp);
+
+		/* Enable Interrupt and wait bfa_init completion */
+		if (bfad_setup_intr(bfad)) {
+			printk(KERN_WARNING "bfad%d: bfad_setup_intr failed\n",
+					bfad->inst_no);
+			bfa_sm_send_event(bfad, BFAD_E_INTR_INIT_FAILED);
+			break;
+		}
+
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		bfa_init(&bfad->bfa);
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+		/* Set up interrupt handler for each vectors */
+		if ((bfad->bfad_flags & BFAD_MSIX_ON) &&
+			bfad_install_msix_handler(bfad)) {
+			printk(KERN_WARNING "%s: install_msix failed, bfad%d\n",
+				__func__, bfad->inst_no);
+		}
+
+		bfad_init_timer(bfad);
+
+		wait_for_completion(&bfad->comp);
+
+		if ((bfad->bfad_flags & BFAD_HAL_INIT_DONE)) {
+			bfa_sm_send_event(bfad, BFAD_E_INIT_SUCCESS);
+		} else {
+			bfad->bfad_flags |= BFAD_HAL_INIT_FAIL;
+			bfa_sm_send_event(bfad, BFAD_E_INIT_FAILED);
+		}
+
+		break;
+
+	case BFAD_E_KTHREAD_CREATE_FAILED:
+		bfa_sm_set_state(bfad, bfad_sm_uninit);
+		break;
+
+	default:
+		bfa_sm_fault(bfad, event);
+	}
+}
+
+static void
+bfad_sm_initializing(struct bfad_s *bfad, enum bfad_sm_event event)
+{
+	int	retval;
+	unsigned long	flags;
+
+	bfa_trc(bfad, event);
+
+	switch (event) {
+	case BFAD_E_INIT_SUCCESS:
+		kthread_stop(bfad->bfad_tsk);
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		bfad->bfad_tsk = NULL;
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+		retval = bfad_start_ops(bfad);
+		if (retval != BFA_STATUS_OK)
+			break;
+		bfa_sm_set_state(bfad, bfad_sm_operational);
+		break;
+
+	case BFAD_E_INTR_INIT_FAILED:
+		bfa_sm_set_state(bfad, bfad_sm_uninit);
+		kthread_stop(bfad->bfad_tsk);
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		bfad->bfad_tsk = NULL;
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		break;
+
+	case BFAD_E_INIT_FAILED:
+		bfa_sm_set_state(bfad, bfad_sm_failed);
+		break;
+	default:
+		bfa_sm_fault(bfad, event);
+	}
+}
+
+static void
+bfad_sm_failed(struct bfad_s *bfad, enum bfad_sm_event event)
+{
+	int	retval;
+
+	bfa_trc(bfad, event);
+
+	switch (event) {
+	case BFAD_E_INIT_SUCCESS:
+		retval = bfad_start_ops(bfad);
+		if (retval != BFA_STATUS_OK)
+			break;
+		bfa_sm_set_state(bfad, bfad_sm_operational);
+		break;
+
+	case BFAD_E_STOP:
+		if (bfad->bfad_flags & BFAD_CFG_PPORT_DONE)
+			bfad_uncfg_pport(bfad);
+		if (bfad->bfad_flags & BFAD_FC4_PROBE_DONE) {
+			bfad_im_probe_undo(bfad);
+			bfad->bfad_flags &= ~BFAD_FC4_PROBE_DONE;
+		}
+		bfad_stop(bfad);
+		break;
+
+	case BFAD_E_EXIT_COMP:
+		bfa_sm_set_state(bfad, bfad_sm_uninit);
+		bfad_remove_intr(bfad);
+		del_timer_sync(&bfad->hal_tmo);
+		break;
+
+	default:
+		bfa_sm_fault(bfad, event);
+	}
+}
+
+static void
+bfad_sm_operational(struct bfad_s *bfad, enum bfad_sm_event event)
+{
+	bfa_trc(bfad, event);
+
+	switch (event) {
+	case BFAD_E_STOP:
+		bfa_sm_set_state(bfad, bfad_sm_fcs_exit);
+		bfad_fcs_stop(bfad);
+		break;
+
+	default:
+		bfa_sm_fault(bfad, event);
+	}
+}
+
+static void
+bfad_sm_fcs_exit(struct bfad_s *bfad, enum bfad_sm_event event)
+{
+	bfa_trc(bfad, event);
+
+	switch (event) {
+	case BFAD_E_FCS_EXIT_COMP:
+		bfa_sm_set_state(bfad, bfad_sm_stopping);
+		bfad_stop(bfad);
+		break;
+
+	default:
+		bfa_sm_fault(bfad, event);
+	}
+}
+
+static void
+bfad_sm_stopping(struct bfad_s *bfad, enum bfad_sm_event event)
+{
+	bfa_trc(bfad, event);
+
+	switch (event) {
+	case BFAD_E_EXIT_COMP:
+		bfa_sm_set_state(bfad, bfad_sm_uninit);
+		bfad_remove_intr(bfad);
+		del_timer_sync(&bfad->hal_tmo);
+		bfad_im_probe_undo(bfad);
+		bfad->bfad_flags &= ~BFAD_FC4_PROBE_DONE;
+		bfad_uncfg_pport(bfad);
+		break;
+
+	default:
+		bfa_sm_fault(bfad, event);
+		break;
+	}
+}
+
+/**
+ *  BFA callbacks
+ */
+void
+bfad_hcb_comp(void *arg, bfa_status_t status)
+{
+	struct bfad_hal_comp *fcomp = (struct bfad_hal_comp *)arg;
+
+	fcomp->status = status;
+	complete(&fcomp->comp);
+}
+
+/**
+ * bfa_init callback
+ */
+void
+bfa_cb_init(void *drv, bfa_status_t init_status)
+{
+	struct bfad_s	      *bfad = drv;
+
+	if (init_status == BFA_STATUS_OK) {
+		bfad->bfad_flags |= BFAD_HAL_INIT_DONE;
+
+		/*
+		 * If BFAD_HAL_INIT_FAIL flag is set:
+		 * Wake up the kernel thread to start
+		 * the bfad operations after HAL init done
+		 */
+		if ((bfad->bfad_flags & BFAD_HAL_INIT_FAIL)) {
+			bfad->bfad_flags &= ~BFAD_HAL_INIT_FAIL;
+			wake_up_process(bfad->bfad_tsk);
+		}
+	}
+
+	complete(&bfad->comp);
+}
+
+/**
+ *  BFA_FCS callbacks
+ */
+struct bfad_port_s *
+bfa_fcb_lport_new(struct bfad_s *bfad, struct bfa_fcs_lport_s *port,
+		 enum bfa_lport_role roles, struct bfad_vf_s *vf_drv,
+		 struct bfad_vport_s *vp_drv)
+{
+	bfa_status_t	rc;
+	struct bfad_port_s    *port_drv;
+
+	if (!vp_drv && !vf_drv) {
+		port_drv = &bfad->pport;
+		port_drv->pvb_type = BFAD_PORT_PHYS_BASE;
+	} else if (!vp_drv && vf_drv) {
+		port_drv = &vf_drv->base_port;
+		port_drv->pvb_type = BFAD_PORT_VF_BASE;
+	} else if (vp_drv && !vf_drv) {
+		port_drv = &vp_drv->drv_port;
+		port_drv->pvb_type = BFAD_PORT_PHYS_VPORT;
+	} else {
+		port_drv = &vp_drv->drv_port;
+		port_drv->pvb_type = BFAD_PORT_VF_VPORT;
+	}
+
+	port_drv->fcs_port = port;
+	port_drv->roles = roles;
+
+	if (roles & BFA_LPORT_ROLE_FCP_IM) {
+		rc = bfad_im_port_new(bfad, port_drv);
+		if (rc != BFA_STATUS_OK) {
+			bfad_im_port_delete(bfad, port_drv);
+			port_drv = NULL;
+		}
+	}
+
+	return port_drv;
+}
+
+void
+bfa_fcb_lport_delete(struct bfad_s *bfad, enum bfa_lport_role roles,
+		    struct bfad_vf_s *vf_drv, struct bfad_vport_s *vp_drv)
+{
+	struct bfad_port_s    *port_drv;
+
+	/* this will be only called from rmmod context */
+	if (vp_drv && !vp_drv->comp_del) {
+		port_drv = (vp_drv) ? (&(vp_drv)->drv_port) :
+				((vf_drv) ? (&(vf_drv)->base_port) :
+				(&(bfad)->pport));
+		bfa_trc(bfad, roles);
+		if (roles & BFA_LPORT_ROLE_FCP_IM)
+			bfad_im_port_delete(bfad, port_drv);
+	}
+}
+
+/**
+ * FCS RPORT alloc callback, after successful PLOGI by FCS
+ */
+bfa_status_t
+bfa_fcb_rport_alloc(struct bfad_s *bfad, struct bfa_fcs_rport_s **rport,
+		    struct bfad_rport_s **rport_drv)
+{
+	bfa_status_t	rc = BFA_STATUS_OK;
+
+	*rport_drv = kzalloc(sizeof(struct bfad_rport_s), GFP_ATOMIC);
+	if (*rport_drv == NULL) {
+		rc = BFA_STATUS_ENOMEM;
+		goto ext;
+	}
+
+	*rport = &(*rport_drv)->fcs_rport;
+
+ext:
+	return rc;
+}
+
+/**
+ * FCS PBC VPORT Create
+ */
+void
+bfa_fcb_pbc_vport_create(struct bfad_s *bfad, struct bfi_pbc_vport_s pbc_vport)
+{
+
+	struct bfa_lport_cfg_s port_cfg = {0};
+	struct bfad_vport_s   *vport;
+	int rc;
+
+	vport = kzalloc(sizeof(struct bfad_vport_s), GFP_KERNEL);
+	if (!vport) {
+		bfa_trc(bfad, 0);
+		return;
+	}
+
+	vport->drv_port.bfad = bfad;
+	port_cfg.roles = BFA_LPORT_ROLE_FCP_IM;
+	port_cfg.pwwn = pbc_vport.vp_pwwn;
+	port_cfg.nwwn = pbc_vport.vp_nwwn;
+	port_cfg.preboot_vp  = BFA_TRUE;
+
+	rc = bfa_fcs_pbc_vport_create(&vport->fcs_vport, &bfad->bfa_fcs, 0,
+				  &port_cfg, vport);
+
+	if (rc != BFA_STATUS_OK) {
+		bfa_trc(bfad, 0);
+		return;
+	}
+
+	list_add_tail(&vport->list_entry, &bfad->pbc_vport_list);
+}
+
+void
+bfad_hal_mem_release(struct bfad_s *bfad)
+{
+	int		i;
+	struct bfa_meminfo_s *hal_meminfo = &bfad->meminfo;
+	struct bfa_mem_elem_s *meminfo_elem;
+
+	for (i = 0; i < BFA_MEM_TYPE_MAX; i++) {
+		meminfo_elem = &hal_meminfo->meminfo[i];
+		if (meminfo_elem->kva != NULL) {
+			switch (meminfo_elem->mem_type) {
+			case BFA_MEM_TYPE_KVA:
+				vfree(meminfo_elem->kva);
+				break;
+			case BFA_MEM_TYPE_DMA:
+				dma_free_coherent(&bfad->pcidev->dev,
+					meminfo_elem->mem_len,
+					meminfo_elem->kva,
+					(dma_addr_t) meminfo_elem->dma);
+				break;
+			default:
+				bfa_assert(0);
+				break;
+			}
+		}
+	}
+
+	memset(hal_meminfo, 0, sizeof(struct bfa_meminfo_s));
+}
+
+void
+bfad_update_hal_cfg(struct bfa_iocfc_cfg_s *bfa_cfg)
+{
+	if (num_rports > 0)
+		bfa_cfg->fwcfg.num_rports = num_rports;
+	if (num_ios > 0)
+		bfa_cfg->fwcfg.num_ioim_reqs = num_ios;
+	if (num_tms > 0)
+		bfa_cfg->fwcfg.num_tskim_reqs = num_tms;
+	if (num_fcxps > 0)
+		bfa_cfg->fwcfg.num_fcxp_reqs = num_fcxps;
+	if (num_ufbufs > 0)
+		bfa_cfg->fwcfg.num_uf_bufs = num_ufbufs;
+	if (reqq_size > 0)
+		bfa_cfg->drvcfg.num_reqq_elems = reqq_size;
+	if (rspq_size > 0)
+		bfa_cfg->drvcfg.num_rspq_elems = rspq_size;
+	if (num_sgpgs > 0)
+		bfa_cfg->drvcfg.num_sgpgs = num_sgpgs;
+
+	/*
+	 * populate the hal values back to the driver for sysfs use.
+	 * otherwise, the default values will be shown as 0 in sysfs
+	 */
+	num_rports = bfa_cfg->fwcfg.num_rports;
+	num_ios = bfa_cfg->fwcfg.num_ioim_reqs;
+	num_tms = bfa_cfg->fwcfg.num_tskim_reqs;
+	num_fcxps = bfa_cfg->fwcfg.num_fcxp_reqs;
+	num_ufbufs = bfa_cfg->fwcfg.num_uf_bufs;
+	reqq_size = bfa_cfg->drvcfg.num_reqq_elems;
+	rspq_size = bfa_cfg->drvcfg.num_rspq_elems;
+	num_sgpgs = bfa_cfg->drvcfg.num_sgpgs;
+}
+
+bfa_status_t
+bfad_hal_mem_alloc(struct bfad_s *bfad)
+{
+	int		i;
+	struct bfa_meminfo_s *hal_meminfo = &bfad->meminfo;
+	struct bfa_mem_elem_s *meminfo_elem;
+	dma_addr_t	phys_addr;
+	void	       *kva;
+	bfa_status_t	rc = BFA_STATUS_OK;
+	int retry_count = 0;
+	int reset_value = 1;
+	int min_num_sgpgs = 512;
+
+	bfa_cfg_get_default(&bfad->ioc_cfg);
+
+retry:
+	bfad_update_hal_cfg(&bfad->ioc_cfg);
+	bfad->cfg_data.ioc_queue_depth = bfad->ioc_cfg.fwcfg.num_ioim_reqs;
+	bfa_cfg_get_meminfo(&bfad->ioc_cfg, hal_meminfo);
+
+	for (i = 0; i < BFA_MEM_TYPE_MAX; i++) {
+		meminfo_elem = &hal_meminfo->meminfo[i];
+		switch (meminfo_elem->mem_type) {
+		case BFA_MEM_TYPE_KVA:
+			kva = vmalloc(meminfo_elem->mem_len);
+			if (kva == NULL) {
+				bfad_hal_mem_release(bfad);
+				rc = BFA_STATUS_ENOMEM;
+				goto ext;
+			}
+			memset(kva, 0, meminfo_elem->mem_len);
+			meminfo_elem->kva = kva;
+			break;
+		case BFA_MEM_TYPE_DMA:
+			kva = dma_alloc_coherent(&bfad->pcidev->dev,
+				meminfo_elem->mem_len, &phys_addr, GFP_KERNEL);
+			if (kva == NULL) {
+				bfad_hal_mem_release(bfad);
+				/*
+				 * If we cannot allocate with default
+				 * num_sgpages try with half the value.
+				 */
+				if (num_sgpgs > min_num_sgpgs) {
+					printk(KERN_INFO
+					"bfad[%d]: memory allocation failed"
+					" with num_sgpgs: %d\n",
+						bfad->inst_no, num_sgpgs);
+					nextLowerInt(&num_sgpgs);
+					printk(KERN_INFO
+					"bfad[%d]: trying to allocate memory"
+					" with num_sgpgs: %d\n",
+						bfad->inst_no, num_sgpgs);
+					retry_count++;
+					goto retry;
+				} else {
+					if (num_sgpgs_parm > 0)
+						num_sgpgs = num_sgpgs_parm;
+					else {
+						reset_value =
+							(1 << retry_count);
+						num_sgpgs *= reset_value;
+					}
+					rc = BFA_STATUS_ENOMEM;
+					goto ext;
+				}
+			}
+
+			if (num_sgpgs_parm > 0)
+				num_sgpgs = num_sgpgs_parm;
+			else {
+				reset_value = (1 << retry_count);
+				num_sgpgs *= reset_value;
+			}
+
+			memset(kva, 0, meminfo_elem->mem_len);
+			meminfo_elem->kva = kva;
+			meminfo_elem->dma = phys_addr;
+			break;
+		default:
+			break;
+
+		}
+	}
+ext:
+	return rc;
+}
+
+/**
+ * Create a vport under a vf.
+ */
+bfa_status_t
+bfad_vport_create(struct bfad_s *bfad, u16 vf_id,
+		  struct bfa_lport_cfg_s *port_cfg, struct device *dev)
+{
+	struct bfad_vport_s   *vport;
+	int		rc = BFA_STATUS_OK;
+	unsigned long	flags;
+	struct completion fcomp;
+
+	vport = kzalloc(sizeof(struct bfad_vport_s), GFP_KERNEL);
+	if (!vport) {
+		rc = BFA_STATUS_ENOMEM;
+		goto ext;
+	}
+
+	vport->drv_port.bfad = bfad;
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	rc = bfa_fcs_vport_create(&vport->fcs_vport, &bfad->bfa_fcs, vf_id,
+				  port_cfg, vport);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (rc != BFA_STATUS_OK)
+		goto ext_free_vport;
+
+	if (port_cfg->roles & BFA_LPORT_ROLE_FCP_IM) {
+		rc = bfad_im_scsi_host_alloc(bfad, vport->drv_port.im_port,
+							dev);
+		if (rc != BFA_STATUS_OK)
+			goto ext_free_fcs_vport;
+	}
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_fcs_vport_start(&vport->fcs_vport);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	return BFA_STATUS_OK;
+
+ext_free_fcs_vport:
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	vport->comp_del = &fcomp;
+	init_completion(vport->comp_del);
+	bfa_fcs_vport_delete(&vport->fcs_vport);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	wait_for_completion(vport->comp_del);
+ext_free_vport:
+	kfree(vport);
+ext:
+	return rc;
+}
+
+/**
+ * Create a vf and its base vport implicitely.
+ */
+bfa_status_t
+bfad_vf_create(struct bfad_s *bfad, u16 vf_id,
+	       struct bfa_lport_cfg_s *port_cfg)
+{
+	struct bfad_vf_s      *vf;
+	int		rc = BFA_STATUS_OK;
+
+	vf = kzalloc(sizeof(struct bfad_vf_s), GFP_KERNEL);
+	if (!vf) {
+		rc = BFA_STATUS_FAILED;
+		goto ext;
+	}
+
+	rc = bfa_fcs_vf_create(&vf->fcs_vf, &bfad->bfa_fcs, vf_id, port_cfg,
+			       vf);
+	if (rc != BFA_STATUS_OK)
+		kfree(vf);
+ext:
+	return rc;
+}
+
+void
+bfad_bfa_tmo(unsigned long data)
+{
+	struct bfad_s	      *bfad = (struct bfad_s *) data;
+	unsigned long	flags;
+	struct list_head	       doneq;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+
+	bfa_timer_tick(&bfad->bfa);
+
+	bfa_comp_deq(&bfad->bfa, &doneq);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (!list_empty(&doneq)) {
+		bfa_comp_process(&bfad->bfa, &doneq);
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		bfa_comp_free(&bfad->bfa, &doneq);
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	}
+
+	mod_timer(&bfad->hal_tmo,
+		  jiffies + msecs_to_jiffies(BFA_TIMER_FREQ));
+}
+
+void
+bfad_init_timer(struct bfad_s *bfad)
+{
+	init_timer(&bfad->hal_tmo);
+	bfad->hal_tmo.function = bfad_bfa_tmo;
+	bfad->hal_tmo.data = (unsigned long)bfad;
+
+	mod_timer(&bfad->hal_tmo,
+		  jiffies + msecs_to_jiffies(BFA_TIMER_FREQ));
+}
+
+int
+bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
+{
+	int		rc = -ENODEV;
+
+	if (pci_enable_device(pdev)) {
+		printk(KERN_ERR "pci_enable_device fail %p\n", pdev);
+		goto out;
+	}
+
+	if (pci_request_regions(pdev, BFAD_DRIVER_NAME))
+		goto out_disable_device;
+
+	pci_set_master(pdev);
+
+
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0)
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0) {
+			printk(KERN_ERR "pci_set_dma_mask fail %p\n", pdev);
+			goto out_release_region;
+		}
+
+	bfad->pci_bar0_kva = pci_iomap(pdev, 0, pci_resource_len(pdev, 0));
+
+	if (bfad->pci_bar0_kva == NULL) {
+		printk(KERN_ERR "Fail to map bar0\n");
+		goto out_release_region;
+	}
+
+	bfad->hal_pcidev.pci_slot = PCI_SLOT(pdev->devfn);
+	bfad->hal_pcidev.pci_func = PCI_FUNC(pdev->devfn);
+	bfad->hal_pcidev.pci_bar_kva = bfad->pci_bar0_kva;
+	bfad->hal_pcidev.device_id = pdev->device;
+	bfad->pci_name = pci_name(pdev);
+
+	bfad->pci_attr.vendor_id = pdev->vendor;
+	bfad->pci_attr.device_id = pdev->device;
+	bfad->pci_attr.ssid = pdev->subsystem_device;
+	bfad->pci_attr.ssvid = pdev->subsystem_vendor;
+	bfad->pci_attr.pcifn = PCI_FUNC(pdev->devfn);
+
+	bfad->pcidev = pdev;
+
+	/* Adjust PCIe Maximum Read Request Size */
+	if (pcie_max_read_reqsz > 0) {
+		int pcie_cap_reg;
+		u16 pcie_dev_ctl;
+		u16 mask = 0xffff;
+
+		switch (pcie_max_read_reqsz) {
+		case 128:
+			mask = 0x0;
+			break;
+		case 256:
+			mask = 0x1000;
+			break;
+		case 512:
+			mask = 0x2000;
+			break;
+		case 1024:
+			mask = 0x3000;
+			break;
+		case 2048:
+			mask = 0x4000;
+			break;
+		case 4096:
+			mask = 0x5000;
+			break;
+		default:
+			break;
+		}
+
+		pcie_cap_reg = pci_find_capability(pdev, PCI_CAP_ID_EXP);
+		if (mask != 0xffff && pcie_cap_reg) {
+			pcie_cap_reg += 0x08;
+			pci_read_config_word(pdev, pcie_cap_reg, &pcie_dev_ctl);
+			if ((pcie_dev_ctl & 0x7000) != mask) {
+				printk(KERN_WARNING "BFA[%s]: "
+				"pcie_max_read_request_size is %d, "
+				"reset to %d\n", bfad->pci_name,
+				(1 << ((pcie_dev_ctl & 0x7000) >> 12)) << 7,
+				pcie_max_read_reqsz);
+
+				pcie_dev_ctl &= ~0x7000;
+				pci_write_config_word(pdev, pcie_cap_reg,
+						pcie_dev_ctl | mask);
+			}
+		}
+	}
+
+	return 0;
+
+out_release_region:
+	pci_release_regions(pdev);
+out_disable_device:
+	pci_disable_device(pdev);
+out:
+	return rc;
+}
+
+void
+bfad_pci_uninit(struct pci_dev *pdev, struct bfad_s *bfad)
+{
+	pci_iounmap(pdev, bfad->pci_bar0_kva);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+}
+
+void
+bfad_fcs_port_cfg(struct bfad_s *bfad)
+{
+	struct bfa_lport_cfg_s  port_cfg;
+	struct bfa_port_attr_s attr;
+	char		symname[BFA_SYMNAME_MAXLEN];
+
+	sprintf(symname, "%s-%d", BFAD_DRIVER_NAME, bfad->inst_no);
+	memcpy(port_cfg.sym_name.symname, symname, strlen(symname));
+	bfa_fcport_get_attr(&bfad->bfa, &attr);
+	port_cfg.nwwn = attr.nwwn;
+	port_cfg.pwwn = attr.pwwn;
+}
+
+bfa_status_t
+bfad_drv_init(struct bfad_s *bfad)
+{
+	bfa_status_t	rc;
+	unsigned long	flags;
+
+	bfad->cfg_data.rport_del_timeout = rport_del_timeout;
+	bfad->cfg_data.lun_queue_depth = bfa_lun_queue_depth;
+	bfad->cfg_data.io_max_sge = bfa_io_max_sge;
+	bfad->cfg_data.binding_method = FCP_PWWN_BINDING;
+
+	rc = bfad_hal_mem_alloc(bfad);
+	if (rc != BFA_STATUS_OK) {
+		printk(KERN_WARNING "bfad%d bfad_hal_mem_alloc failure\n",
+		       bfad->inst_no);
+		printk(KERN_WARNING
+			"Not enough memory to attach all Brocade HBA ports, %s",
+			"System may need more memory.\n");
+		goto out_hal_mem_alloc_failure;
+	}
+
+	bfa_init_trc(&bfad->bfa, bfad->trcmod);
+	bfa_init_plog(&bfad->bfa, &bfad->plog_buf);
+	bfa_plog_init(&bfad->plog_buf);
+	bfa_plog_str(&bfad->plog_buf, BFA_PL_MID_DRVR, BFA_PL_EID_DRIVER_START,
+		     0, "Driver Attach");
+
+	bfa_attach(&bfad->bfa, bfad, &bfad->ioc_cfg, &bfad->meminfo,
+		   &bfad->hal_pcidev);
+
+	/* FCS INIT */
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_fcs_trc_init(&bfad->bfa_fcs, bfad->trcmod);
+	bfa_fcs_attach(&bfad->bfa_fcs, &bfad->bfa, bfad, BFA_FALSE);
+	bfa_fcs_set_fdmi_param(&bfad->bfa_fcs, fdmi_enable);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	bfad->bfad_flags |= BFAD_DRV_INIT_DONE;
+
+	return BFA_STATUS_OK;
+
+out_hal_mem_alloc_failure:
+	return BFA_STATUS_FAILED;
+}
+
+void
+bfad_drv_uninit(struct bfad_s *bfad)
+{
+	unsigned long   flags;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	init_completion(&bfad->comp);
+	bfa_stop(&bfad->bfa);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	wait_for_completion(&bfad->comp);
+
+	del_timer_sync(&bfad->hal_tmo);
+	bfa_isr_disable(&bfad->bfa);
+	bfa_detach(&bfad->bfa);
+	bfad_remove_intr(bfad);
+	bfad_hal_mem_release(bfad);
+
+	bfad->bfad_flags &= ~BFAD_DRV_INIT_DONE;
+}
+
+void
+bfad_drv_start(struct bfad_s *bfad)
+{
+	unsigned long	flags;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_start(&bfad->bfa);
+	bfa_fcs_start(&bfad->bfa_fcs);
+	bfad->bfad_flags |= BFAD_HAL_START_DONE;
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (bfad->im)
+		flush_workqueue(bfad->im->drv_workq);
+}
+
+void
+bfad_fcs_stop(struct bfad_s *bfad)
+{
+	unsigned long	flags;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	init_completion(&bfad->comp);
+	bfad->pport.flags |= BFAD_PORT_DELETE;
+	bfa_fcs_exit(&bfad->bfa_fcs);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	wait_for_completion(&bfad->comp);
+
+	bfa_sm_send_event(bfad, BFAD_E_FCS_EXIT_COMP);
+}
+
+void
+bfad_stop(struct bfad_s *bfad)
+{
+	unsigned long	flags;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	init_completion(&bfad->comp);
+	bfa_stop(&bfad->bfa);
+	bfad->bfad_flags &= ~BFAD_HAL_START_DONE;
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	wait_for_completion(&bfad->comp);
+
+	bfa_sm_send_event(bfad, BFAD_E_EXIT_COMP);
+}
+
+bfa_status_t
+bfad_cfg_pport(struct bfad_s *bfad, enum bfa_lport_role role)
+{
+	int		rc = BFA_STATUS_OK;
+
+	/* Allocate scsi_host for the physical port */
+	if ((supported_fc4s & BFA_LPORT_ROLE_FCP_IM) &&
+	    (role & BFA_LPORT_ROLE_FCP_IM)) {
+		if (bfad->pport.im_port == NULL) {
+			rc = BFA_STATUS_FAILED;
+			goto out;
+		}
+
+		rc = bfad_im_scsi_host_alloc(bfad, bfad->pport.im_port,
+						&bfad->pcidev->dev);
+		if (rc != BFA_STATUS_OK)
+			goto out;
+
+		bfad->pport.roles |= BFA_LPORT_ROLE_FCP_IM;
+	}
+
+	/* Setup the debugfs node for this scsi_host */
+	if (bfa_debugfs_enable)
+		bfad_debugfs_init(&bfad->pport);
+
+	bfad->bfad_flags |= BFAD_CFG_PPORT_DONE;
+
+out:
+	return rc;
+}
+
+void
+bfad_uncfg_pport(struct bfad_s *bfad)
+{
+	/* Remove the debugfs node for this scsi_host */
+	kfree(bfad->regdata);
+	bfad_debugfs_exit(&bfad->pport);
+
+	if ((supported_fc4s & BFA_LPORT_ROLE_FCP_IM) &&
+	    (bfad->pport.roles & BFA_LPORT_ROLE_FCP_IM)) {
+		bfad_im_scsi_host_free(bfad, bfad->pport.im_port);
+		bfad_im_port_clean(bfad->pport.im_port);
+		kfree(bfad->pport.im_port);
+		bfad->pport.roles &= ~BFA_LPORT_ROLE_FCP_IM;
+	}
+
+	bfad->bfad_flags &= ~BFAD_CFG_PPORT_DONE;
+}
+
+bfa_status_t
+bfad_start_ops(struct bfad_s *bfad) {
+
+	int	retval;
+	unsigned long	flags;
+	struct bfad_vport_s *vport, *vport_new;
+	struct bfa_fcs_driver_info_s driver_info;
+
+	/* Fill the driver_info info to fcs*/
+	memset(&driver_info, 0, sizeof(driver_info));
+	strncpy(driver_info.version, BFAD_DRIVER_VERSION,
+		sizeof(driver_info.version) - 1);
+	if (host_name)
+		strncpy(driver_info.host_machine_name, host_name,
+			sizeof(driver_info.host_machine_name) - 1);
+	if (os_name)
+		strncpy(driver_info.host_os_name, os_name,
+			sizeof(driver_info.host_os_name) - 1);
+	if (os_patch)
+		strncpy(driver_info.host_os_patch, os_patch,
+			sizeof(driver_info.host_os_patch) - 1);
+
+	strncpy(driver_info.os_device_name, bfad->pci_name,
+		sizeof(driver_info.os_device_name - 1));
+
+	/* FCS INIT */
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_fcs_driver_info_init(&bfad->bfa_fcs, &driver_info);
+	bfa_fcs_init(&bfad->bfa_fcs);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	/* PPORT FCS config */
+	bfad_fcs_port_cfg(bfad);
+
+	retval = bfad_cfg_pport(bfad, BFA_LPORT_ROLE_FCP_IM);
+	if (retval != BFA_STATUS_OK) {
+		if (bfa_sm_cmp_state(bfad, bfad_sm_initializing))
+			bfa_sm_set_state(bfad, bfad_sm_failed);
+		bfad_stop(bfad);
+		return BFA_STATUS_FAILED;
+	}
+
+	/* BFAD level FC4 IM specific resource allocation */
+	retval = bfad_im_probe(bfad);
+	if (retval != BFA_STATUS_OK) {
+		printk(KERN_WARNING "bfad_im_probe failed\n");
+		if (bfa_sm_cmp_state(bfad, bfad_sm_initializing))
+			bfa_sm_set_state(bfad, bfad_sm_failed);
+		bfad_im_probe_undo(bfad);
+		bfad->bfad_flags &= ~BFAD_FC4_PROBE_DONE;
+		bfad_uncfg_pport(bfad);
+		bfad_stop(bfad);
+		return BFA_STATUS_FAILED;
+	} else
+		bfad->bfad_flags |= BFAD_FC4_PROBE_DONE;
+
+	bfad_drv_start(bfad);
+
+	/* Complete pbc vport create */
+	list_for_each_entry_safe(vport, vport_new, &bfad->pbc_vport_list,
+				list_entry) {
+		struct fc_vport_identifiers vid;
+		struct fc_vport *fc_vport;
+		char pwwn_buf[BFA_STRING_32];
+
+		memset(&vid, 0, sizeof(vid));
+		vid.roles = FC_PORT_ROLE_FCP_INITIATOR;
+		vid.vport_type = FC_PORTTYPE_NPIV;
+		vid.disable = false;
+		vid.node_name = wwn_to_u64((u8 *)
+				(&((vport->fcs_vport).lport.port_cfg.nwwn)));
+		vid.port_name = wwn_to_u64((u8 *)
+				(&((vport->fcs_vport).lport.port_cfg.pwwn)));
+		fc_vport = fc_vport_create(bfad->pport.im_port->shost, 0, &vid);
+		if (!fc_vport) {
+			wwn2str(pwwn_buf, vid.port_name);
+			printk(KERN_WARNING "bfad%d: failed to create pbc vport"
+				" %s\n", bfad->inst_no, pwwn_buf);
+		}
+		list_del(&vport->list_entry);
+		kfree(vport);
+	}
+
+	/*
+	 * If bfa_linkup_delay is set to -1 default; try to retrive the
+	 * value using the bfad_os_get_linkup_delay(); else use the
+	 * passed in module param value as the bfa_linkup_delay.
+	 */
+	if (bfa_linkup_delay < 0) {
+		bfa_linkup_delay = bfad_os_get_linkup_delay(bfad);
+		bfad_os_rport_online_wait(bfad);
+		bfa_linkup_delay = -1;
+	} else
+		bfad_os_rport_online_wait(bfad);
+
+	BFA_LOG(KERN_INFO, bfad, log_level, "bfa device claimed\n");
+
+	return BFA_STATUS_OK;
+}
+
+int
+bfad_worker(void *ptr)
+{
+	struct bfad_s *bfad;
+	unsigned long   flags;
+
+	bfad = (struct bfad_s *)ptr;
+
+	while (!kthread_should_stop()) {
+
+		/* Send event BFAD_E_INIT_SUCCESS */
+		bfa_sm_send_event(bfad, BFAD_E_INIT_SUCCESS);
+
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		bfad->bfad_tsk = NULL;
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+		break;
+	}
+
+	return 0;
+}
+
+/**
+ *  BFA driver interrupt functions
+ */
+irqreturn_t
+bfad_intx(int irq, void *dev_id)
+{
+	struct bfad_s	*bfad = dev_id;
+	struct list_head	doneq;
+	unsigned long	flags;
+	bfa_boolean_t rc;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	rc = bfa_intx(&bfad->bfa);
+	if (!rc) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		return IRQ_NONE;
+	}
+
+	bfa_comp_deq(&bfad->bfa, &doneq);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (!list_empty(&doneq)) {
+		bfa_comp_process(&bfad->bfa, &doneq);
+
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		bfa_comp_free(&bfad->bfa, &doneq);
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		bfa_trc_fp(bfad, irq);
+	}
+
+	return IRQ_HANDLED;
+
+}
+
+static irqreturn_t
+bfad_msix(int irq, void *dev_id)
+{
+	struct bfad_msix_s *vec = dev_id;
+	struct bfad_s *bfad = vec->bfad;
+	struct list_head doneq;
+	unsigned long   flags;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+
+	bfa_msix(&bfad->bfa, vec->msix.entry);
+	bfa_comp_deq(&bfad->bfa, &doneq);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (!list_empty(&doneq)) {
+		bfa_comp_process(&bfad->bfa, &doneq);
+
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		bfa_comp_free(&bfad->bfa, &doneq);
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * Initialize the MSIX entry table.
+ */
+static void
+bfad_init_msix_entry(struct bfad_s *bfad, struct msix_entry *msix_entries,
+			 int mask, int max_bit)
+{
+	int	i;
+	int	match = 0x00000001;
+
+	for (i = 0, bfad->nvec = 0; i < MAX_MSIX_ENTRY; i++) {
+		if (mask & match) {
+			bfad->msix_tab[bfad->nvec].msix.entry = i;
+			bfad->msix_tab[bfad->nvec].bfad = bfad;
+			msix_entries[bfad->nvec].entry = i;
+			bfad->nvec++;
+		}
+
+		match <<= 1;
+	}
+
+}
+
+int
+bfad_install_msix_handler(struct bfad_s *bfad)
+{
+	int i, error = 0;
+
+	for (i = 0; i < bfad->nvec; i++) {
+		sprintf(bfad->msix_tab[i].name, "bfa-%s-%s",
+				bfad->pci_name,
+				((bfa_asic_id_ct(bfad->hal_pcidev.device_id)) ?
+				msix_name_ct[i] : msix_name_cb[i]));
+
+		error = request_irq(bfad->msix_tab[i].msix.vector,
+				    (irq_handler_t) bfad_msix, 0,
+				    bfad->msix_tab[i].name, &bfad->msix_tab[i]);
+		bfa_trc(bfad, i);
+		bfa_trc(bfad, bfad->msix_tab[i].msix.vector);
+		if (error) {
+			int	j;
+
+			for (j = 0; j < i; j++)
+				free_irq(bfad->msix_tab[j].msix.vector,
+						&bfad->msix_tab[j]);
+
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * Setup MSIX based interrupt.
+ */
+int
+bfad_setup_intr(struct bfad_s *bfad)
+{
+	int error = 0;
+	u32 mask = 0, i, num_bit = 0, max_bit = 0;
+	struct msix_entry msix_entries[MAX_MSIX_ENTRY];
+	struct pci_dev *pdev = bfad->pcidev;
+
+	/* Call BFA to get the msix map for this PCI function.  */
+	bfa_msix_getvecs(&bfad->bfa, &mask, &num_bit, &max_bit);
+
+	/* Set up the msix entry table */
+	bfad_init_msix_entry(bfad, msix_entries, mask, max_bit);
+
+	if ((bfa_asic_id_ct(pdev->device) && !msix_disable_ct) ||
+	    (!bfa_asic_id_ct(pdev->device) && !msix_disable_cb)) {
+
+		error = pci_enable_msix(bfad->pcidev, msix_entries, bfad->nvec);
+		if (error) {
+			/*
+			 * Only error number of vector is available.
+			 * We don't have a mechanism to map multiple
+			 * interrupts into one vector, so even if we
+			 * can try to request less vectors, we don't
+			 * know how to associate interrupt events to
+			 *  vectors. Linux doesn't dupicate vectors
+			 * in the MSIX table for this case.
+			 */
+
+			printk(KERN_WARNING "bfad%d: "
+				"pci_enable_msix failed (%d),"
+				" use line based.\n", bfad->inst_no, error);
+
+			goto line_based;
+		}
+
+		/* Save the vectors */
+		for (i = 0; i < bfad->nvec; i++) {
+			bfa_trc(bfad, msix_entries[i].vector);
+			bfad->msix_tab[i].msix.vector = msix_entries[i].vector;
+		}
+
+		bfa_msix_init(&bfad->bfa, bfad->nvec);
+
+		bfad->bfad_flags |= BFAD_MSIX_ON;
+
+		return error;
+	}
+
+line_based:
+	error = 0;
+	if (request_irq
+	    (bfad->pcidev->irq, (irq_handler_t) bfad_intx, BFAD_IRQ_FLAGS,
+	     BFAD_DRIVER_NAME, bfad) != 0) {
+		/* Enable interrupt handler failed */
+		return 1;
+	}
+
+	return error;
+}
+
+void
+bfad_remove_intr(struct bfad_s *bfad)
+{
+	int	i;
+
+	if (bfad->bfad_flags & BFAD_MSIX_ON) {
+		for (i = 0; i < bfad->nvec; i++)
+			free_irq(bfad->msix_tab[i].msix.vector,
+					&bfad->msix_tab[i]);
+
+		pci_disable_msix(bfad->pcidev);
+		bfad->bfad_flags &= ~BFAD_MSIX_ON;
+	} else {
+		free_irq(bfad->pcidev->irq, bfad);
+	}
+}
+
+/**
+ * PCI probe entry.
+ */
+int
+bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid)
+{
+	struct bfad_s	*bfad;
+	int		error = -ENODEV, retval;
+
+	/* For single port cards - only claim function 0 */
+	if ((pdev->device == BFA_PCI_DEVICE_ID_FC_8G1P) &&
+		(PCI_FUNC(pdev->devfn) != 0))
+		return -ENODEV;
+
+	bfad = kzalloc(sizeof(struct bfad_s), GFP_KERNEL);
+	if (!bfad) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	bfad->trcmod = kzalloc(sizeof(struct bfa_trc_mod_s), GFP_KERNEL);
+	if (!bfad->trcmod) {
+		printk(KERN_WARNING "Error alloc trace buffer!\n");
+		error = -ENOMEM;
+		goto out_alloc_trace_failure;
+	}
+
+	/* TRACE INIT */
+	bfa_trc_init(bfad->trcmod);
+	bfa_trc(bfad, bfad_inst);
+
+	if (!(bfad_load_fwimg(pdev))) {
+		kfree(bfad->trcmod);
+		goto out_alloc_trace_failure;
+	}
+
+	retval = bfad_pci_init(pdev, bfad);
+	if (retval) {
+		printk(KERN_WARNING "bfad_pci_init failure!\n");
+		error = retval;
+		goto out_pci_init_failure;
+	}
+
+	mutex_lock(&bfad_mutex);
+	bfad->inst_no = bfad_inst++;
+	list_add_tail(&bfad->list_entry, &bfad_list);
+	mutex_unlock(&bfad_mutex);
+
+	/* Initializing the state machine: State set to uninit */
+	bfa_sm_set_state(bfad, bfad_sm_uninit);
+
+	spin_lock_init(&bfad->bfad_lock);
+	pci_set_drvdata(pdev, bfad);
+
+	bfad->ref_count = 0;
+	bfad->pport.bfad = bfad;
+	INIT_LIST_HEAD(&bfad->pbc_vport_list);
+
+	retval = bfad_drv_init(bfad);
+	if (retval != BFA_STATUS_OK)
+		goto out_drv_init_failure;
+
+	bfa_sm_send_event(bfad, BFAD_E_CREATE);
+
+	if (bfa_sm_cmp_state(bfad, bfad_sm_uninit))
+		goto out_bfad_sm_failure;
+
+	return 0;
+
+out_bfad_sm_failure:
+	bfa_detach(&bfad->bfa);
+	bfad_hal_mem_release(bfad);
+out_drv_init_failure:
+	mutex_lock(&bfad_mutex);
+	bfad_inst--;
+	list_del(&bfad->list_entry);
+	mutex_unlock(&bfad_mutex);
+	bfad_pci_uninit(pdev, bfad);
+out_pci_init_failure:
+	kfree(bfad->trcmod);
+out_alloc_trace_failure:
+	kfree(bfad);
+out:
+	return error;
+}
+
+/**
+ * PCI remove entry.
+ */
+void
+bfad_pci_remove(struct pci_dev *pdev)
+{
+	struct bfad_s	      *bfad = pci_get_drvdata(pdev);
+	unsigned long	flags;
+
+	bfa_trc(bfad, bfad->inst_no);
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	if (bfad->bfad_tsk != NULL) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		kthread_stop(bfad->bfad_tsk);
+	} else {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	}
+
+	/* Send Event BFAD_E_STOP */
+	bfa_sm_send_event(bfad, BFAD_E_STOP);
+
+	/* Driver detach and dealloc mem */
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_detach(&bfad->bfa);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	bfad_hal_mem_release(bfad);
+
+	/* Cleaning the BFAD instance */
+	mutex_lock(&bfad_mutex);
+	bfad_inst--;
+	list_del(&bfad->list_entry);
+	mutex_unlock(&bfad_mutex);
+	bfad_pci_uninit(pdev, bfad);
+
+	kfree(bfad->trcmod);
+	kfree(bfad);
+}
+
+struct pci_device_id bfad_id_table[] = {
+	{
+		.vendor = BFA_PCI_VENDOR_ID_BROCADE,
+		.device = BFA_PCI_DEVICE_ID_FC_8G2P,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+	},
+	{
+		.vendor = BFA_PCI_VENDOR_ID_BROCADE,
+		.device = BFA_PCI_DEVICE_ID_FC_8G1P,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+	},
+	{
+		.vendor = BFA_PCI_VENDOR_ID_BROCADE,
+		.device = BFA_PCI_DEVICE_ID_CT,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+		.class = (PCI_CLASS_SERIAL_FIBER << 8),
+		.class_mask = ~0,
+	},
+	{
+		.vendor = BFA_PCI_VENDOR_ID_BROCADE,
+		.device = BFA_PCI_DEVICE_ID_CT_FC,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+		.class = (PCI_CLASS_SERIAL_FIBER << 8),
+		.class_mask = ~0,
+	},
+
+	{0, 0},
+};
+
+MODULE_DEVICE_TABLE(pci, bfad_id_table);
+
+static struct pci_driver bfad_pci_driver = {
+	.name = BFAD_DRIVER_NAME,
+	.id_table = bfad_id_table,
+	.probe = bfad_pci_probe,
+	.remove = __devexit_p(bfad_pci_remove),
+};
+
+/**
+ * Driver module init.
+ */
+static int __init
+bfad_init(void)
+{
+	int		error = 0;
+
+	printk(KERN_INFO "Brocade BFA FC/FCOE SCSI driver - version: %s\n",
+			BFAD_DRIVER_VERSION);
+
+	if (num_sgpgs > 0)
+		num_sgpgs_parm = num_sgpgs;
+
+	error = bfad_im_module_init();
+	if (error) {
+		error = -ENOMEM;
+		printk(KERN_WARNING "bfad_im_module_init failure\n");
+		goto ext;
+	}
+
+	if (strcmp(FCPI_NAME, " fcpim") == 0)
+		supported_fc4s |= BFA_LPORT_ROLE_FCP_IM;
+
+	bfa_ioc_auto_recover(ioc_auto_recover);
+	bfa_fcs_rport_set_del_timeout(rport_del_timeout);
+
+	error = pci_register_driver(&bfad_pci_driver);
+	if (error) {
+		printk(KERN_WARNING "pci_register_driver failure\n");
+		goto ext;
+	}
+
+	return 0;
+
+ext:
+	bfad_im_module_exit();
+	return error;
+}
+
+/**
+ * Driver module exit.
+ */
+static void __exit
+bfad_exit(void)
+{
+	pci_unregister_driver(&bfad_pci_driver);
+	bfad_im_module_exit();
+	bfad_free_fwimg();
+}
+
+/* Firmware handling */
+u32 *
+bfad_read_firmware(struct pci_dev *pdev, u32 **bfi_image,
+		u32 *bfi_image_size, char *fw_name)
+{
+	const struct firmware *fw;
+
+	if (request_firmware(&fw, fw_name, &pdev->dev)) {
+		printk(KERN_ALERT "Can't locate firmware %s\n", fw_name);
+		goto error;
+	}
+
+	*bfi_image = vmalloc(fw->size);
+	if (NULL == *bfi_image) {
+		printk(KERN_ALERT "Fail to allocate buffer for fw image "
+			"size=%x!\n", (u32) fw->size);
+		goto error;
+	}
+
+	memcpy(*bfi_image, fw->data, fw->size);
+	*bfi_image_size = fw->size/sizeof(u32);
+
+	return *bfi_image;
+
+error:
+	return NULL;
+}
+
+u32 *
+bfad_get_firmware_buf(struct pci_dev *pdev)
+{
+	if (pdev->device == BFA_PCI_DEVICE_ID_CT_FC) {
+		if (bfi_image_ct_fc_size == 0)
+			bfad_read_firmware(pdev, &bfi_image_ct_fc,
+				&bfi_image_ct_fc_size, BFAD_FW_FILE_CT_FC);
+		return bfi_image_ct_fc;
+	} else if (pdev->device == BFA_PCI_DEVICE_ID_CT) {
+		if (bfi_image_ct_cna_size == 0)
+			bfad_read_firmware(pdev, &bfi_image_ct_cna,
+				&bfi_image_ct_cna_size, BFAD_FW_FILE_CT_CNA);
+		return bfi_image_ct_cna;
+	} else {
+		if (bfi_image_cb_fc_size == 0)
+			bfad_read_firmware(pdev, &bfi_image_cb_fc,
+				&bfi_image_cb_fc_size, BFAD_FW_FILE_CB_FC);
+		return bfi_image_cb_fc;
+	}
+}
+
+module_init(bfad_init);
+module_exit(bfad_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Brocade Fibre Channel HBA Driver" BFAD_PROTO_NAME);
+MODULE_AUTHOR("Brocade Communications Systems, Inc.");
+MODULE_VERSION(BFAD_DRIVER_VERSION);
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 0818eb0..d884372 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
  * All rights reserved
  * www.brocade.com
  *
@@ -19,15 +19,8 @@
  *  bfa_attr.c Linux driver configuration interface module.
  */
 
-#include <linux/slab.h>
 #include "bfad_drv.h"
 #include "bfad_im.h"
-#include "bfad_trcmod.h"
-#include "bfad_attr.h"
-
-/**
- *  FC_transport_template FC transport template
- */
 
 /**
  * FC transport template entry, get SCSI target port ID.
@@ -42,7 +35,7 @@ bfad_im_get_starget_port_id(struct scsi_target *starget)
 	u32        fc_id = -1;
 	unsigned long   flags;
 
-	shost = bfad_os_starget_to_shost(starget);
+	shost = dev_to_shost(starget->dev.parent);
 	im_port = (struct bfad_im_port_s *) shost->hostdata[0];
 	bfad = im_port->bfad;
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
@@ -68,7 +61,7 @@ bfad_im_get_starget_node_name(struct scsi_target *starget)
 	u64             node_name = 0;
 	unsigned long   flags;
 
-	shost = bfad_os_starget_to_shost(starget);
+	shost = dev_to_shost(starget->dev.parent);
 	im_port = (struct bfad_im_port_s *) shost->hostdata[0];
 	bfad = im_port->bfad;
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
@@ -94,7 +87,7 @@ bfad_im_get_starget_port_name(struct scsi_target *starget)
 	u64             port_name = 0;
 	unsigned long   flags;
 
-	shost = bfad_os_starget_to_shost(starget);
+	shost = dev_to_shost(starget->dev.parent);
 	im_port = (struct bfad_im_port_s *) shost->hostdata[0];
 	bfad = im_port->bfad;
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
@@ -118,17 +111,7 @@ bfad_im_get_host_port_id(struct Scsi_Host *shost)
 	struct bfad_port_s    *port = im_port->port;
 
 	fc_host_port_id(shost) =
-			bfa_os_hton3b(bfa_fcs_port_get_fcid(port->fcs_port));
-}
-
-
-
-
-
-struct Scsi_Host *
-bfad_os_starget_to_shost(struct scsi_target *starget)
-{
-	return dev_to_shost(starget->dev.parent);
+			bfa_os_hton3b(bfa_fcs_lport_get_fcid(port->fcs_port));
 }
 
 /**
@@ -140,21 +123,21 @@ bfad_im_get_host_port_type(struct Scsi_Host *shost)
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s         *bfad = im_port->bfad;
-	struct bfa_pport_attr_s attr;
+	struct bfa_lport_attr_s port_attr;
 
-	bfa_fcport_get_attr(&bfad->bfa, &attr);
+	bfa_fcs_lport_get_attr(&bfad->bfa_fcs.fabric.bport, &port_attr);
 
-	switch (attr.port_type) {
-	case BFA_PPORT_TYPE_NPORT:
+	switch (port_attr.port_type) {
+	case BFA_PORT_TYPE_NPORT:
 		fc_host_port_type(shost) = FC_PORTTYPE_NPORT;
 		break;
-	case BFA_PPORT_TYPE_NLPORT:
+	case BFA_PORT_TYPE_NLPORT:
 		fc_host_port_type(shost) = FC_PORTTYPE_NLPORT;
 		break;
-	case BFA_PPORT_TYPE_P2P:
+	case BFA_PORT_TYPE_P2P:
 		fc_host_port_type(shost) = FC_PORTTYPE_PTP;
 		break;
-	case BFA_PPORT_TYPE_LPORT:
+	case BFA_PORT_TYPE_LPORT:
 		fc_host_port_type(shost) = FC_PORTTYPE_LPORT;
 		break;
 	default:
@@ -172,25 +155,28 @@ bfad_im_get_host_port_state(struct Scsi_Host *shost)
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s         *bfad = im_port->bfad;
-	struct bfa_pport_attr_s attr;
+	struct bfa_port_attr_s attr;
 
 	bfa_fcport_get_attr(&bfad->bfa, &attr);
 
 	switch (attr.port_state) {
-	case BFA_PPORT_ST_LINKDOWN:
+	case BFA_PORT_ST_LINKDOWN:
 		fc_host_port_state(shost) = FC_PORTSTATE_LINKDOWN;
 		break;
-	case BFA_PPORT_ST_LINKUP:
+	case BFA_PORT_ST_LINKUP:
 		fc_host_port_state(shost) = FC_PORTSTATE_ONLINE;
 		break;
-	case BFA_PPORT_ST_UNINIT:
-	case BFA_PPORT_ST_ENABLING_QWAIT:
-	case BFA_PPORT_ST_ENABLING:
-	case BFA_PPORT_ST_DISABLING_QWAIT:
-	case BFA_PPORT_ST_DISABLING:
-	case BFA_PPORT_ST_DISABLED:
-	case BFA_PPORT_ST_STOPPED:
-	case BFA_PPORT_ST_IOCDOWN:
+	case BFA_PORT_ST_DISABLED:
+	case BFA_PORT_ST_STOPPED:
+	case BFA_PORT_ST_IOCDOWN:
+	case BFA_PORT_ST_IOCDIS:
+		fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
+		break;
+	case BFA_PORT_ST_UNINIT:
+	case BFA_PORT_ST_ENABLING_QWAIT:
+	case BFA_PORT_ST_ENABLING:
+	case BFA_PORT_ST_DISABLING_QWAIT:
+	case BFA_PORT_ST_DISABLING:
 	default:
 		fc_host_port_state(shost) = FC_PORTSTATE_UNKNOWN;
 		break;
@@ -210,13 +196,9 @@ bfad_im_get_host_active_fc4s(struct Scsi_Host *shost)
 	memset(fc_host_active_fc4s(shost), 0,
 	       sizeof(fc_host_active_fc4s(shost)));
 
-	if (port->supported_fc4s &
-		(BFA_PORT_ROLE_FCP_IM | BFA_PORT_ROLE_FCP_TM))
+	if (port->supported_fc4s & BFA_LPORT_ROLE_FCP_IM)
 		fc_host_active_fc4s(shost)[2] = 1;
 
-	if (port->supported_fc4s & BFA_PORT_ROLE_FCP_IPFC)
-		fc_host_active_fc4s(shost)[3] = 0x20;
-
 	fc_host_active_fc4s(shost)[7] = 1;
 }
 
@@ -229,29 +211,29 @@ bfad_im_get_host_speed(struct Scsi_Host *shost)
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s         *bfad = im_port->bfad;
-	struct bfa_pport_attr_s attr;
-	unsigned long   flags;
+	struct bfa_port_attr_s attr;
 
-	spin_lock_irqsave(shost->host_lock, flags);
 	bfa_fcport_get_attr(&bfad->bfa, &attr);
 	switch (attr.speed) {
-	case BFA_PPORT_SPEED_8GBPS:
+	case BFA_PORT_SPEED_10GBPS:
+		fc_host_speed(shost) = FC_PORTSPEED_10GBIT;
+		break;
+	case BFA_PORT_SPEED_8GBPS:
 		fc_host_speed(shost) = FC_PORTSPEED_8GBIT;
 		break;
-	case BFA_PPORT_SPEED_4GBPS:
+	case BFA_PORT_SPEED_4GBPS:
 		fc_host_speed(shost) = FC_PORTSPEED_4GBIT;
 		break;
-	case BFA_PPORT_SPEED_2GBPS:
+	case BFA_PORT_SPEED_2GBPS:
 		fc_host_speed(shost) = FC_PORTSPEED_2GBIT;
 		break;
-	case BFA_PPORT_SPEED_1GBPS:
+	case BFA_PORT_SPEED_1GBPS:
 		fc_host_speed(shost) = FC_PORTSPEED_1GBIT;
 		break;
 	default:
 		fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
 		break;
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
 /**
@@ -265,7 +247,7 @@ bfad_im_get_host_fabric_name(struct Scsi_Host *shost)
 	struct bfad_port_s    *port = im_port->port;
 	wwn_t           fabric_nwwn = 0;
 
-	fabric_nwwn = bfa_fcs_port_get_fabric_name(port->fcs_port);
+	fabric_nwwn = bfa_fcs_lport_get_fabric_name(port->fcs_port);
 
 	fc_host_fabric_name(shost) = bfa_os_htonll(fabric_nwwn);
 
@@ -281,23 +263,44 @@ bfad_im_get_stats(struct Scsi_Host *shost)
 			(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s         *bfad = im_port->bfad;
 	struct bfad_hal_comp fcomp;
+	union bfa_port_stats_u *fcstats;
 	struct fc_host_statistics *hstats;
 	bfa_status_t    rc;
 	unsigned long   flags;
 
+	fcstats = kzalloc(sizeof(union bfa_port_stats_u), GFP_KERNEL);
+	if (fcstats == NULL)
+		return NULL;
+
 	hstats = &bfad->link_stats;
 	init_completion(&fcomp.comp);
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	memset(hstats, 0, sizeof(struct fc_host_statistics));
-	rc =  bfa_port_get_stats(BFA_FCPORT(&bfad->bfa),
-				     (union bfa_pport_stats_u *) hstats,
-				     bfad_hcb_comp, &fcomp);
+	rc = bfa_port_get_stats(BFA_FCPORT(&bfad->bfa),
+				fcstats, bfad_hcb_comp, &fcomp);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 	if (rc != BFA_STATUS_OK)
 		return NULL;
 
 	wait_for_completion(&fcomp.comp);
 
+	/* Fill the fc_host_statistics structure */
+	hstats->seconds_since_last_reset = fcstats->fc.secs_reset;
+	hstats->tx_frames = fcstats->fc.tx_frames;
+	hstats->tx_words  = fcstats->fc.tx_words;
+	hstats->rx_frames = fcstats->fc.rx_frames;
+	hstats->rx_words  = fcstats->fc.rx_words;
+	hstats->lip_count = fcstats->fc.lip_count;
+	hstats->nos_count = fcstats->fc.nos_count;
+	hstats->error_frames = fcstats->fc.error_frames;
+	hstats->dumped_frames = fcstats->fc.dropped_frames;
+	hstats->link_failure_count = fcstats->fc.link_failures;
+	hstats->loss_of_sync_count = fcstats->fc.loss_of_syncs;
+	hstats->loss_of_signal_count = fcstats->fc.loss_of_signals;
+	hstats->prim_seq_protocol_err_count = fcstats->fc.primseq_errs;
+	hstats->invalid_crc_count = fcstats->fc.invalid_crcs;
+
+	kfree(fcstats);
 	return hstats;
 }
 
@@ -317,7 +320,7 @@ bfad_im_reset_stats(struct Scsi_Host *shost)
 	init_completion(&fcomp.comp);
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	rc = bfa_port_clear_stats(BFA_FCPORT(&bfad->bfa), bfad_hcb_comp,
-		&fcomp);
+					&fcomp);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
 	if (rc != BFA_STATUS_OK)
@@ -372,8 +375,8 @@ bfad_im_vport_create(struct fc_vport *fc_vport, bool disable)
 	struct bfad_im_port_s *im_port =
 		(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s *bfad = im_port->bfad;
-	struct bfa_port_cfg_s port_cfg;
-	struct bfad_pcfg_s *pcfg;
+	struct bfa_lport_cfg_s port_cfg;
+	struct bfad_vport_s *vp;
 	int status = 0, rc;
 	unsigned long flags;
 
@@ -382,12 +385,14 @@ bfad_im_vport_create(struct fc_vport *fc_vport, bool disable)
 	u64_to_wwn(fc_vport->port_name, (u8 *)&port_cfg.pwwn);
 	if (strlen(vname) > 0)
 		strcpy((char *)&port_cfg.sym_name, vname);
-	port_cfg.roles = BFA_PORT_ROLE_FCP_IM;
+	port_cfg.roles = BFA_LPORT_ROLE_FCP_IM;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	list_for_each_entry(pcfg, &bfad->pbc_pcfg_list, list_entry) {
-		if (port_cfg.pwwn == pcfg->port_cfg.pwwn) {
-			port_cfg.preboot_vp = pcfg->port_cfg.preboot_vp;
+	list_for_each_entry(vp, &bfad->pbc_vport_list, list_entry) {
+		if (port_cfg.pwwn ==
+				vp->fcs_vport.lport.port_cfg.pwwn) {
+			port_cfg.preboot_vp =
+				vp->fcs_vport.lport.port_cfg.preboot_vp;
 			break;
 		}
 	}
@@ -638,7 +643,7 @@ bfad_im_serial_num_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfad_s         *bfad = im_port->bfad;
+	struct bfad_s *bfad = im_port->bfad;
 	char serial_num[BFA_ADAPTER_SERIAL_NUM_LEN];
 
 	bfa_get_adapter_serial_num(&bfad->bfa, serial_num);
@@ -652,7 +657,7 @@ bfad_im_model_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfad_s         *bfad = im_port->bfad;
+	struct bfad_s *bfad = im_port->bfad;
 	char model[BFA_ADAPTER_MODEL_NAME_LEN];
 
 	bfa_get_adapter_model(&bfad->bfa, model);
@@ -666,10 +671,54 @@ bfad_im_model_desc_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfad_s         *bfad = im_port->bfad;
+	struct bfad_s *bfad = im_port->bfad;
+	char model[BFA_ADAPTER_MODEL_NAME_LEN];
 	char model_descr[BFA_ADAPTER_MODEL_DESCR_LEN];
 
-	bfa_get_adapter_model(&bfad->bfa, model_descr);
+	bfa_get_adapter_model(&bfad->bfa, model);
+	if (!strcmp(model, "Brocade-425"))
+		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
+			"Brocade 4Gbps PCIe dual port FC HBA");
+	else if (!strcmp(model, "Brocade-825"))
+		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
+			"Brocade 8Gbps PCIe dual port FC HBA");
+	else if (!strcmp(model, "Brocade-42B"))
+		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
+			"HP 4Gbps PCIe dual port FC HBA");
+	else if (!strcmp(model, "Brocade-82B"))
+		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
+			"HP 8Gbps PCIe dual port FC HBA");
+	else if (!strcmp(model, "Brocade-1010"))
+		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
+			"Brocade 10Gbps single port CNA");
+	else if (!strcmp(model, "Brocade-1020"))
+		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
+			"Brocade 10Gbps dual port CNA");
+	else if (!strcmp(model, "Brocade-1007"))
+		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
+			"Brocade 10Gbps CNA");
+	else if (!strcmp(model, "Brocade-415"))
+		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
+			"Brocade 4Gbps PCIe single port FC HBA");
+	else if (!strcmp(model, "Brocade-815"))
+		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
+			"Brocade 8Gbps PCIe single port FC HBA");
+	else if (!strcmp(model, "Brocade-41B"))
+		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
+			"HP 4Gbps PCIe single port FC HBA");
+	else if (!strcmp(model, "Brocade-81B"))
+		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
+			"HP 8Gbps PCIe single port FC HBA");
+	else if (!strcmp(model, "Brocade-804"))
+		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
+			"HP Bladesystem C-class 8Gbps FC HBA");
+	else if (!strcmp(model, "Brocade-902"))
+		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
+			"Brocade 10Gbps CNA");
+	else
+		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
+			"Invalid Model");
+
 	return snprintf(buf, PAGE_SIZE, "%s\n", model_descr);
 }
 
@@ -683,7 +732,7 @@ bfad_im_node_name_show(struct device *dev, struct device_attribute *attr,
 	struct bfad_port_s    *port = im_port->port;
 	u64        nwwn;
 
-	nwwn = bfa_fcs_port_get_nwwn(port->fcs_port);
+	nwwn = bfa_fcs_lport_get_nwwn(port->fcs_port);
 	return snprintf(buf, PAGE_SIZE, "0x%llx\n", bfa_os_htonll(nwwn));
 }
 
@@ -694,14 +743,14 @@ bfad_im_symbolic_name_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfad_s         *bfad = im_port->bfad;
-	char model[BFA_ADAPTER_MODEL_NAME_LEN];
-	char fw_ver[BFA_VERSION_LEN];
+	struct bfad_s *bfad = im_port->bfad;
+	struct bfa_lport_attr_s port_attr;
+	char symname[BFA_SYMNAME_MAXLEN];
 
-	bfa_get_adapter_model(&bfad->bfa, model);
-	bfa_get_adapter_fw_ver(&bfad->bfa, fw_ver);
-	return snprintf(buf, PAGE_SIZE, "Brocade %s FV%s DV%s\n",
-		model, fw_ver, BFAD_DRIVER_VERSION);
+	bfa_fcs_lport_get_attr(&bfad->bfa_fcs.fabric.bport, &port_attr);
+	strncpy(symname, port_attr.port_cfg.sym_name.symname,
+			BFA_SYMNAME_MAXLEN);
+	return snprintf(buf, PAGE_SIZE, "%s\n", symname);
 }
 
 static ssize_t
@@ -711,7 +760,7 @@ bfad_im_hw_version_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfad_s         *bfad = im_port->bfad;
+	struct bfad_s *bfad = im_port->bfad;
 	char hw_ver[BFA_VERSION_LEN];
 
 	bfa_get_pci_chip_rev(&bfad->bfa, hw_ver);
@@ -732,7 +781,7 @@ bfad_im_optionrom_version_show(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfad_s         *bfad = im_port->bfad;
+	struct bfad_s *bfad = im_port->bfad;
 	char optrom_ver[BFA_VERSION_LEN];
 
 	bfa_get_adapter_optrom_ver(&bfad->bfa, optrom_ver);
@@ -746,7 +795,7 @@ bfad_im_fw_version_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfad_s         *bfad = im_port->bfad;
+	struct bfad_s *bfad = im_port->bfad;
 	char fw_ver[BFA_VERSION_LEN];
 
 	bfa_get_adapter_fw_ver(&bfad->bfa, fw_ver);
@@ -760,10 +809,10 @@ bfad_im_num_of_ports_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfad_s         *bfad = im_port->bfad;
+	struct bfad_s *bfad = im_port->bfad;
 
 	return snprintf(buf, PAGE_SIZE, "%d\n",
-		bfa_get_nports(&bfad->bfa));
+			bfa_get_nports(&bfad->bfa));
 }
 
 static ssize_t
@@ -788,10 +837,10 @@ bfad_im_num_of_discovered_ports_show(struct device *dev,
 
 	rports = kzalloc(sizeof(wwn_t) * nrports , GFP_ATOMIC);
 	if (rports == NULL)
-		return -ENOMEM;
+		return snprintf(buf, PAGE_SIZE, "Failed\n");
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	bfa_fcs_port_get_rports(port->fcs_port, rports, &nrports);
+	bfa_fcs_lport_get_rports(port->fcs_port, rports, &nrports);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 	kfree(rports);
 
@@ -837,19 +886,19 @@ struct device_attribute *bfad_im_host_attrs[] = {
 };
 
 struct device_attribute *bfad_im_vport_attrs[] = {
-    &dev_attr_serial_number,
-    &dev_attr_model,
-    &dev_attr_model_description,
-    &dev_attr_node_name,
-    &dev_attr_symbolic_name,
-    &dev_attr_hardware_version,
-    &dev_attr_driver_version,
-    &dev_attr_option_rom_version,
-    &dev_attr_firmware_version,
-    &dev_attr_number_of_ports,
-    &dev_attr_driver_name,
-    &dev_attr_number_of_discovered_ports,
-    NULL,
+	&dev_attr_serial_number,
+	&dev_attr_model,
+	&dev_attr_model_description,
+	&dev_attr_node_name,
+	&dev_attr_symbolic_name,
+	&dev_attr_hardware_version,
+	&dev_attr_driver_version,
+	&dev_attr_option_rom_version,
+	&dev_attr_firmware_version,
+	&dev_attr_number_of_ports,
+	&dev_attr_driver_name,
+	&dev_attr_number_of_discovered_ports,
+	NULL,
 };
 
 
diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
index 4b82f12..cbb7dea 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -17,8 +17,8 @@
 
 #include <linux/debugfs.h>
 
-#include <bfad_drv.h>
-#include <bfad_im.h>
+#include "bfad_drv.h"
+#include "bfad_im.h"
 
 /*
  * BFA debufs interface
@@ -28,7 +28,7 @@
  * mount -t debugfs none /sys/kernel/debug
  *
  * BFA Hierarchy:
- * 	- bfa/host#
+ *	- bfa/host#
  * where the host number corresponds to the one under /sys/class/scsi_host/host#
  *
  * Debugging service available per host:
@@ -217,7 +217,7 @@ bfad_debugfs_read(struct file *file, char __user *buf,
 #define BFA_REG_ADDRSZ(__bfa)	\
 	((bfa_ioc_devid(&(__bfa)->ioc) == BFA_PCI_DEVICE_ID_CT) ?	\
 		BFA_REG_CT_ADDRSZ : BFA_REG_CB_ADDRSZ)
-#define BFA_REG_ADDRMSK(__bfa)  ((uint32_t)(BFA_REG_ADDRSZ(__bfa) - 1))
+#define BFA_REG_ADDRMSK(__bfa)  ((u32)(BFA_REG_ADDRSZ(__bfa) - 1))
 
 static bfa_status_t
 bfad_reg_offset_check(struct bfa_s *bfa, u32 offset, u32 len)
@@ -359,7 +359,7 @@ bfad_debugfs_write_regwr(struct file *file, const char __user *buf,
 		return -EINVAL;
 	}
 
-	reg_addr = (uint32_t *) ((uint8_t *) bfa_ioc_bar0(ioc) + addr);
+	reg_addr = (u32 *) ((u8 *) bfa_ioc_bar0(ioc) + addr);
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	bfa_reg_write(reg_addr, val);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 6ef87f6..d950ee4 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
  * All rights reserved
  * www.brocade.com
  *
@@ -19,12 +19,10 @@
  *  bfad_im.c Linux driver IM module.
  */
 
-#include <linux/slab.h>
 #include "bfad_drv.h"
 #include "bfad_im.h"
-#include "bfad_trcmod.h"
-#include "bfa_cb_ioim_macros.h"
-#include <fcb/bfa_fcb_fcpim.h>
+#include "bfa_cb_ioim.h"
+#include "bfa_fcs.h"
 
 BFA_TRC_FILE(LDRV, IM);
 
@@ -33,8 +31,10 @@ struct scsi_transport_template *bfad_im_scsi_transport_template;
 struct scsi_transport_template *bfad_im_scsi_vport_transport_template;
 static void bfad_im_itnim_work_handler(struct work_struct *work);
 static int bfad_im_queuecommand(struct scsi_cmnd *cmnd,
-		void (*done)(struct scsi_cmnd *));
+				void (*done)(struct scsi_cmnd *));
 static int bfad_im_slave_alloc(struct scsi_device *sdev);
+static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
+				struct bfad_itnim_s *itnim);
 
 void
 bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,
@@ -58,6 +58,7 @@ bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,
 				sns_len = SCSI_SENSE_BUFFERSIZE;
 			memcpy(cmnd->sense_buffer, sns_info, sns_len);
 		}
+
 		if (residue > 0) {
 			bfa_trc(bfad, residue);
 			scsi_set_resid(cmnd, residue);
@@ -76,7 +77,8 @@ bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,
 	case BFI_IOIM_STS_TIMEDOUT:
 	case BFI_IOIM_STS_PATHTOV:
 	default:
-		cmnd->result = ScsiResult(DID_ERROR, 0);
+		host_status = DID_ERROR;
+		cmnd->result = ScsiResult(host_status, 0);
 	}
 
 	/* Unmap DMA, if host is NULL, it means a scsi passthru cmd */
@@ -162,11 +164,6 @@ bfa_cb_tskim_done(void *bfad, struct bfad_tskim_s *dtsk,
 		wake_up(wq);
 }
 
-void
-bfa_cb_ioim_resfree(void *drv)
-{
-}
-
 /**
  *  Scsi_Host_template SCSI host template
  */
@@ -179,15 +176,23 @@ bfad_im_info(struct Scsi_Host *shost)
 	static char     bfa_buf[256];
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfad_s         *bfad = im_port->bfad;
+	struct bfad_s *bfad = im_port->bfad;
+	struct bfa_s *bfa = &bfad->bfa;
+	struct bfa_ioc_s *ioc = &bfa->ioc;
 	char model[BFA_ADAPTER_MODEL_NAME_LEN];
 
-	bfa_get_adapter_model(&bfad->bfa, model);
+	bfa_get_adapter_model(bfa, model);
 
 	memset(bfa_buf, 0, sizeof(bfa_buf));
-	snprintf(bfa_buf, sizeof(bfa_buf),
-		"Brocade FC/FCOE Adapter, " "model: %s hwpath: %s driver: %s",
+	if (ioc->ctdev)
+		snprintf(bfa_buf, sizeof(bfa_buf),
+		"Brocade FCOE Adapter, " "model: %s hwpath: %s driver: %s",
+		 model, bfad->pci_name, BFAD_DRIVER_VERSION);
+	else
+		snprintf(bfa_buf, sizeof(bfa_buf),
+		"Brocade FC Adapter, " "model: %s hwpath: %s driver: %s",
 		model, bfad->pci_name, BFAD_DRIVER_VERSION);
+
 	return bfa_buf;
 }
 
@@ -221,9 +226,9 @@ bfad_im_abort_handler(struct scsi_cmnd *cmnd)
 	}
 
 	bfa_trc(bfad, hal_io->iotag);
-	bfa_log(bfad->logmod, BFA_LOG_LINUX_SCSI_ABORT,
+	BFA_LOG(KERN_INFO, bfad, log_level, "scsi%d: abort cmnd %p iotag %x\n",
 		im_port->shost->host_no, cmnd, hal_io->iotag);
-	bfa_ioim_abort(hal_io);
+	(void) bfa_ioim_abort(hal_io);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
 	/* Need to wait until the command get aborted */
@@ -237,7 +242,8 @@ bfad_im_abort_handler(struct scsi_cmnd *cmnd)
 
 	cmnd->scsi_done(cmnd);
 	bfa_trc(bfad, hal_io->iotag);
-	bfa_log(bfad->logmod, BFA_LOG_LINUX_SCSI_ABORT_COMP,
+	BFA_LOG(KERN_INFO, bfad, log_level,
+		"scsi%d: complete abort 0x%p iotag 0x%x\n",
 		im_port->shost->host_no, cmnd, hal_io->iotag);
 	return SUCCESS;
 out:
@@ -255,8 +261,8 @@ bfad_im_target_reset_send(struct bfad_s *bfad, struct scsi_cmnd *cmnd,
 
 	tskim = bfa_tskim_alloc(&bfad->bfa, (struct bfad_tskim_s *) cmnd);
 	if (!tskim) {
-		BFA_DEV_PRINTF(bfad, BFA_ERR,
-			       "target reset, fail to allocate tskim\n");
+		BFA_LOG(KERN_ERR, bfad, log_level,
+			"target reset, fail to allocate tskim\n");
 		rc = BFA_STATUS_FAILED;
 		goto out;
 	}
@@ -306,7 +312,7 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
 
 	tskim = bfa_tskim_alloc(&bfad->bfa, (struct bfad_tskim_s *) cmnd);
 	if (!tskim) {
-		BFA_DEV_PRINTF(bfad, BFA_ERR,
+		BFA_LOG(KERN_ERR, bfad, log_level,
 				"LUN reset, fail to allocate tskim");
 		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 		rc = FAILED;
@@ -331,8 +337,8 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
 
 	task_status = cmnd->SCp.Status >> 1;
 	if (task_status != BFI_TSKIM_STS_OK) {
-		BFA_DEV_PRINTF(bfad, BFA_ERR, "LUN reset failure, status: %d\n",
-			       task_status);
+		BFA_LOG(KERN_ERR, bfad, log_level,
+			"LUN reset failure, status: %d\n", task_status);
 		rc = FAILED;
 	}
 
@@ -375,7 +381,7 @@ bfad_im_reset_bus_handler(struct scsi_cmnd *cmnd)
 
 			task_status = cmnd->SCp.Status >> 1;
 			if (task_status != BFI_TSKIM_STS_OK) {
-				BFA_DEV_PRINTF(bfad, BFA_ERR,
+				BFA_LOG(KERN_ERR, bfad, log_level,
 					"target reset failure,"
 					" status: %d\n", task_status);
 				err_cnt++;
@@ -438,6 +444,7 @@ bfa_fcb_itnim_free(struct bfad_s *bfad, struct bfad_itnim_s *itnim_drv)
 	wwn_t wwpn;
 	u32 fcid;
 	char wwpn_str[32], fcid_str[16];
+	struct bfad_im_s	*im = itnim_drv->im;
 
 	/* online to free state transtion should not happen */
 	bfa_assert(itnim_drv->state != ITNIM_STATE_ONLINE);
@@ -454,10 +461,14 @@ bfa_fcb_itnim_free(struct bfad_s *bfad, struct bfad_itnim_s *itnim_drv)
 	fcid = bfa_fcs_itnim_get_fcid(&itnim_drv->fcs_itnim);
 	wwn2str(wwpn_str, wwpn);
 	fcid2str(fcid_str, fcid);
-	bfa_log(bfad->logmod, BFA_LOG_LINUX_ITNIM_FREE,
+	BFA_LOG(KERN_INFO, bfad, log_level,
+		"ITNIM FREE scsi%d: FCID: %s WWPN: %s\n",
 		port->im_port->shost->host_no,
 		fcid_str, wwpn_str);
-	bfad_os_itnim_process(itnim_drv);
+
+	/* ITNIM processing */
+	if (itnim_drv->queue_work)
+		queue_work(im->drv_workq, &itnim_drv->itnim_work);
 }
 
 /**
@@ -468,13 +479,17 @@ void
 bfa_fcb_itnim_online(struct bfad_itnim_s *itnim_drv)
 {
 	struct bfad_port_s    *port;
+	struct bfad_im_s	*im = itnim_drv->im;
 
 	itnim_drv->bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim_drv->fcs_itnim);
 	port = bfa_fcs_itnim_get_drvport(&itnim_drv->fcs_itnim);
 	itnim_drv->state = ITNIM_STATE_ONLINE;
 	itnim_drv->queue_work = 1;
 	itnim_drv->im_port = port->im_port;
-	bfad_os_itnim_process(itnim_drv);
+
+	/* ITNIM processing */
+	if (itnim_drv->queue_work)
+		queue_work(im->drv_workq, &itnim_drv->itnim_work);
 }
 
 /**
@@ -486,6 +501,7 @@ bfa_fcb_itnim_offline(struct bfad_itnim_s *itnim_drv)
 {
 	struct bfad_port_s    *port;
 	struct bfad_s *bfad;
+	struct bfad_im_s	*im = itnim_drv->im;
 
 	port = bfa_fcs_itnim_get_drvport(&itnim_drv->fcs_itnim);
 	bfad = port->bfad;
@@ -497,16 +513,10 @@ bfa_fcb_itnim_offline(struct bfad_itnim_s *itnim_drv)
 	itnim_drv->im_port = port->im_port;
 	itnim_drv->state = ITNIM_STATE_OFFLINE_PENDING;
 	itnim_drv->queue_work = 1;
-	bfad_os_itnim_process(itnim_drv);
-}
 
-/**
- * BFA FCS itnim timeout callback.
- * Context: Interrupt. bfad_lock is held
- */
-void bfa_fcb_itnim_tov(struct bfad_itnim_s *itnim)
-{
-	itnim->state = ITNIM_STATE_TIMEOUT;
+	/* ITNIM processing */
+	if (itnim_drv->queue_work)
+		queue_work(im->drv_workq, &itnim_drv->itnim_work);
 }
 
 /**
@@ -514,7 +524,7 @@ void bfa_fcb_itnim_tov(struct bfad_itnim_s *itnim)
  */
 int
 bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port,
-				struct device *dev)
+			struct device *dev)
 {
 	int error = 1;
 
@@ -580,7 +590,7 @@ void
 bfad_im_scsi_host_free(struct bfad_s *bfad, struct bfad_im_port_s *im_port)
 {
 	bfa_trc(bfad, bfad->inst_no);
-	bfa_log(bfad->logmod, BFA_LOG_LINUX_SCSI_HOST_FREE,
+	BFA_LOG(KERN_INFO, bfad, log_level, "Free scsi%d\n",
 			im_port->shost->host_no);
 
 	fc_remove_host(im_port->shost);
@@ -598,14 +608,11 @@ bfad_im_port_delete_handler(struct work_struct *work)
 {
 	struct bfad_im_port_s *im_port =
 		container_of(work, struct bfad_im_port_s, port_delete_work);
-	struct bfad_s *bfad = im_port->bfad;
 
 	if (im_port->port->pvb_type != BFAD_PORT_PHYS_BASE) {
 		im_port->flags |= BFAD_PORT_DELETE;
 		fc_vport_terminate(im_port->fc_vport);
-		atomic_dec(&bfad->wq_reqcnt);
 	}
-
 }
 
 bfa_status_t
@@ -636,11 +643,8 @@ bfad_im_port_delete(struct bfad_s *bfad, struct bfad_port_s *port)
 {
 	struct bfad_im_port_s *im_port = port->im_port;
 
-	if (im_port->port->pvb_type != BFAD_PORT_PHYS_BASE) {
-		atomic_inc(&bfad->wq_reqcnt);
-		queue_work(bfad->im->drv_workq,
+	queue_work(bfad->im->drv_workq,
 				&im_port->port_delete_work);
-	}
 }
 
 void
@@ -663,16 +667,6 @@ bfad_im_port_clean(struct bfad_im_port_s *im_port)
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 }
 
-void
-bfad_im_port_online(struct bfad_s *bfad, struct bfad_port_s *port)
-{
-}
-
-void
-bfad_im_port_offline(struct bfad_s *bfad, struct bfad_port_s *port)
-{
-}
-
 bfa_status_t
 bfad_im_probe(struct bfad_s *bfad)
 {
@@ -701,27 +695,12 @@ void
 bfad_im_probe_undo(struct bfad_s *bfad)
 {
 	if (bfad->im) {
-		while (atomic_read(&bfad->wq_reqcnt)) {
-			printk(KERN_INFO "bfa %s: waiting workq processing,"
-				" wq_reqcnt:%x\n", bfad->pci_name,
-				atomic_read(&bfad->wq_reqcnt));
-			schedule_timeout_uninterruptible(HZ);
-		}
 		bfad_os_destroy_workq(bfad->im);
 		kfree(bfad->im);
 		bfad->im = NULL;
 	}
 }
 
-/**
- * Call back function to handle IO redirection state change
- */
-void
-bfa_cb_ioredirect_state_change(void *hcb_bfad, bfa_boolean_t ioredirect)
-{
-	/* Do nothing */
-}
-
 struct Scsi_Host *
 bfad_os_scsi_host_alloc(struct bfad_im_port_s *im_port, struct bfad_s *bfad)
 {
@@ -751,6 +730,7 @@ void
 bfad_os_destroy_workq(struct bfad_im_s *im)
 {
 	if (im && im->drv_workq) {
+		flush_workqueue(im->drv_workq);
 		destroy_workqueue(im->drv_workq);
 		im->drv_workq = NULL;
 	}
@@ -762,7 +742,7 @@ bfad_os_thread_workq(struct bfad_s *bfad)
 	struct bfad_im_s      *im = bfad->im;
 
 	bfa_trc(bfad, 0);
-	snprintf(im->drv_workq_name, BFAD_KOBJ_NAME_LEN, "bfad_wq_%d",
+	snprintf(im->drv_workq_name, KOBJ_NAME_LEN, "bfad_wq_%d",
 		 bfad->inst_no);
 	im->drv_workq = create_singlethread_workqueue(im->drv_workq_name);
 	if (!im->drv_workq)
@@ -832,12 +812,6 @@ struct scsi_host_template bfad_im_vport_template = {
 	.max_sectors = 0xFFFF,
 };
 
-void
-bfad_im_probe_post(struct bfad_im_s *im)
-{
-	flush_workqueue(im->drv_workq);
-}
-
 bfa_status_t
 bfad_im_module_init(void)
 {
@@ -861,20 +835,12 @@ bfad_im_module_exit(void)
 {
 	if (bfad_im_scsi_transport_template)
 		fc_release_transport(bfad_im_scsi_transport_template);
+
 	if (bfad_im_scsi_vport_transport_template)
 		fc_release_transport(bfad_im_scsi_vport_transport_template);
 }
 
 void
-bfad_os_itnim_process(struct bfad_itnim_s *itnim_drv)
-{
-	struct bfad_im_s      *im = itnim_drv->im;
-
-	if (itnim_drv->queue_work)
-		queue_work(im->drv_workq, &itnim_drv->itnim_work);
-}
-
-void
 bfad_os_ramp_up_qdepth(struct bfad_itnim_s *itnim, struct scsi_device *sdev)
 {
 	struct scsi_device *tmp_sdev;
@@ -916,9 +882,6 @@ bfad_os_handle_qfull(struct bfad_itnim_s *itnim, struct scsi_device *sdev)
 	}
 }
 
-
-
-
 struct bfad_itnim_s *
 bfad_os_get_itnim(struct bfad_im_port_s *im_port, int id)
 {
@@ -949,44 +912,64 @@ bfad_im_slave_alloc(struct scsi_device *sdev)
 	return 0;
 }
 
+static u32
+bfad_im_supported_speeds(struct bfa_s *bfa)
+{
+	struct bfa_ioc_attr_s ioc_attr;
+	u32 supported_speed = 0;
+
+	bfa_get_attr(bfa, &ioc_attr);
+	if (ioc_attr.adapter_attr.max_speed == BFA_PORT_SPEED_8GBPS) {
+		if (ioc_attr.adapter_attr.is_mezz) {
+			supported_speed |= FC_PORTSPEED_8GBIT |
+				FC_PORTSPEED_4GBIT |
+				FC_PORTSPEED_2GBIT | FC_PORTSPEED_1GBIT;
+		} else {
+			supported_speed |= FC_PORTSPEED_8GBIT |
+				FC_PORTSPEED_4GBIT |
+				FC_PORTSPEED_2GBIT;
+		}
+	} else if (ioc_attr.adapter_attr.max_speed == BFA_PORT_SPEED_4GBPS) {
+		supported_speed |=  FC_PORTSPEED_4GBIT | FC_PORTSPEED_2GBIT |
+				FC_PORTSPEED_1GBIT;
+	} else if (ioc_attr.adapter_attr.max_speed == BFA_PORT_SPEED_10GBPS) {
+		supported_speed |= FC_PORTSPEED_10GBIT;
+	}
+	return supported_speed;
+}
+
 void
 bfad_os_fc_host_init(struct bfad_im_port_s *im_port)
 {
 	struct Scsi_Host *host = im_port->shost;
 	struct bfad_s         *bfad = im_port->bfad;
 	struct bfad_port_s    *port = im_port->port;
-	struct bfa_pport_attr_s pattr;
-	char model[BFA_ADAPTER_MODEL_NAME_LEN];
-	char fw_ver[BFA_VERSION_LEN];
+	struct bfa_port_attr_s pattr;
+	struct bfa_lport_attr_s port_attr;
+	char symname[BFA_SYMNAME_MAXLEN];
 
 	fc_host_node_name(host) =
-		bfa_os_htonll((bfa_fcs_port_get_nwwn(port->fcs_port)));
+		bfa_os_htonll((bfa_fcs_lport_get_nwwn(port->fcs_port)));
 	fc_host_port_name(host) =
-		bfa_os_htonll((bfa_fcs_port_get_pwwn(port->fcs_port)));
+		bfa_os_htonll((bfa_fcs_lport_get_pwwn(port->fcs_port)));
 	fc_host_max_npiv_vports(host) = bfa_lps_get_max_vport(&bfad->bfa);
 
 	fc_host_supported_classes(host) = FC_COS_CLASS3;
 
 	memset(fc_host_supported_fc4s(host), 0,
 	       sizeof(fc_host_supported_fc4s(host)));
-	if (bfad_supported_fc4s & (BFA_PORT_ROLE_FCP_IM | BFA_PORT_ROLE_FCP_TM))
+	if (supported_fc4s & BFA_LPORT_ROLE_FCP_IM)
 		/* For FCP type 0x08 */
 		fc_host_supported_fc4s(host)[2] = 1;
-	if (bfad_supported_fc4s & BFA_PORT_ROLE_FCP_IPFC)
-		/* For LLC/SNAP type 0x05 */
-		fc_host_supported_fc4s(host)[3] = 0x20;
 	/* For fibre channel services type 0x20 */
 	fc_host_supported_fc4s(host)[7] = 1;
 
-	bfa_get_adapter_model(&bfad->bfa, model);
-	bfa_get_adapter_fw_ver(&bfad->bfa, fw_ver);
-	sprintf(fc_host_symbolic_name(host), "Brocade %s FV%s DV%s",
-		model, fw_ver, BFAD_DRIVER_VERSION);
+	bfa_fcs_lport_get_attr(&bfad->bfa_fcs.fabric.bport, &port_attr);
+	strncpy(symname, port_attr.port_cfg.sym_name.symname,
+		BFA_SYMNAME_MAXLEN);
+	sprintf(fc_host_symbolic_name(host), "%s", symname);
 
-	fc_host_supported_speeds(host) = 0;
-	fc_host_supported_speeds(host) |=
-		FC_PORTSPEED_8GBIT | FC_PORTSPEED_4GBIT | FC_PORTSPEED_2GBIT |
-		FC_PORTSPEED_1GBIT;
+	fc_host_supported_speeds(host) = bfad_im_supported_speeds(&bfad->bfa);
 
 	bfa_fcport_get_attr(&bfad->bfa, &pattr);
 	fc_host_maxframe_size(host) = pattr.pport_cfg.maxfrsize;
@@ -1065,7 +1048,9 @@ bfad_im_itnim_work_handler(struct work_struct *work)
 			fcid2str(fcid_str, fcid);
 			list_add_tail(&itnim->list_entry,
 				&im_port->itnim_mapped_list);
-			bfa_log(bfad->logmod, BFA_LOG_LINUX_ITNIM_ONLINE,
+			BFA_LOG(KERN_INFO, bfad, log_level,
+				"ITNIM ONLINE Target: %d:0:%d "
+				"FCID: %s WWPN: %s\n",
 				im_port->shost->host_no,
 				itnim->scsi_tgt_id,
 				fcid_str, wwpn_str);
@@ -1096,7 +1081,9 @@ bfad_im_itnim_work_handler(struct work_struct *work)
 			wwn2str(wwpn_str, wwpn);
 			fcid2str(fcid_str, fcid);
 			list_del(&itnim->list_entry);
-			bfa_log(bfad->logmod, BFA_LOG_LINUX_ITNIM_OFFLINE,
+			BFA_LOG(KERN_INFO, bfad, log_level,
+				"ITNIM OFFLINE Target: %d:0:%d "
+				"FCID: %s WWPN: %s\n",
 				im_port->shost->host_no,
 				itnim->scsi_tgt_id,
 				fcid_str, wwpn_str);
@@ -1142,7 +1129,7 @@ bfad_im_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 	struct bfa_ioim_s *hal_io;
 	unsigned long   flags;
 	int             rc;
-	s16        sg_cnt = 0;
+	int       sg_cnt = 0;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 
 	rc = fc_remote_port_chkready(rport);
@@ -1153,7 +1140,6 @@ bfad_im_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 	}
 
 	sg_cnt = scsi_dma_map(cmnd);
-
 	if (sg_cnt < 0)
 		return SCSI_MLQUEUE_HOST_BUSY;
 
@@ -1168,6 +1154,7 @@ bfad_im_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 		goto out_fail_cmd;
 	}
 
+
 	itnim = itnim_data->itnim;
 	if (!itnim) {
 		cmnd->result = ScsiResult(DID_IMM_RETRY, 0);
@@ -1206,47 +1193,49 @@ bfad_os_rport_online_wait(struct bfad_s *bfad)
 	int rport_delay = 10;
 
 	for (i = 0; !(bfad->bfad_flags & BFAD_PORT_ONLINE)
-		 && i < bfa_linkup_delay; i++)
-		schedule_timeout_uninterruptible(HZ);
+		&& i < bfa_linkup_delay; i++) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(HZ);
+	}
 
 	if (bfad->bfad_flags & BFAD_PORT_ONLINE) {
 		rport_delay = rport_delay < bfa_linkup_delay ?
-				 rport_delay : bfa_linkup_delay;
+			rport_delay : bfa_linkup_delay;
 		for (i = 0; !(bfad->bfad_flags & BFAD_RPORT_ONLINE)
-			 && i < rport_delay; i++)
-			schedule_timeout_uninterruptible(HZ);
+			&& i < rport_delay; i++) {
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout(HZ);
+		}
 
-		if (rport_delay > 0 && (bfad->bfad_flags & BFAD_RPORT_ONLINE))
-			schedule_timeout_uninterruptible(rport_delay * HZ);
+		if (rport_delay > 0 && (bfad->bfad_flags & BFAD_RPORT_ONLINE)) {
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_timeout(rport_delay * HZ);
+		}
 	}
 }
 
 int
 bfad_os_get_linkup_delay(struct bfad_s *bfad)
 {
-
-	u8      nwwns = 0;
-	wwn_t	wwns[BFA_PREBOOT_BOOTLUN_MAX];
-	int     ldelay;
+	u8		nwwns = 0;
+	wwn_t		wwns[BFA_PREBOOT_BOOTLUN_MAX];
+	int		linkup_delay;
 
 	/*
 	 * Querying for the boot target port wwns
 	 * -- read from boot information in flash.
-	 * If nwwns > 0 => boot over SAN and set bfa_linkup_delay = 30
-	 * else => local boot machine set bfa_linkup_delay = 10
+	 * If nwwns > 0 => boot over SAN and set linkup_delay = 30
+	 * else => local boot machine set linkup_delay = 0
 	 */
 
 	bfa_iocfc_get_bootwwns(&bfad->bfa, &nwwns, wwns);
 
-	if (nwwns > 0) {
-		/* If boot over SAN; linkup_delay = 30sec */
-		ldelay = 30;
-	} else {
-		/* If local boot; linkup_delay = 10sec */
-		ldelay = 0;
-	}
+	if (nwwns > 0)
+		/* If Boot over SAN set linkup_delay = 30sec */
+		linkup_delay = 30;
+	else
+		/* If local boot; no linkup_delay */
+		linkup_delay = 0;
 
-	return ldelay;
+	return linkup_delay;
 }
-
-
-- 
1.7.3.rc1

