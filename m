From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 1/2] bfa: Files to support BFA debugfs node creation, node query and node deletion.
Date: Mon, 11 Jan 2010 15:56:12 -0800
Message-ID: <1263254172-18675-1-git-send-email-kgudipat@blc-10-2.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:35033 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab0ALABT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2010 19:01:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, xmzhang@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

include/bfa_dbcmd.h
	- Holds the DBCMD data structures needed for handling user space requests.

bfad_debugfs.h
	- Header file containing the data structures needed for BFAD debugfs support.

bfad_debugfs.c
	- Source code for BFA debugfs node creation / node deletion and for handling
	  the user space application requests such as driver stats query.
---
 drivers/scsi/bfa/bfad_debugfs.c      |  543 ++++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfad_debugfs.h      |   56 ++++
 drivers/scsi/bfa/include/bfa_dbcmd.h |   98 ++++++
 3 files changed, 697 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/bfa/bfad_debugfs.c
 create mode 100644 drivers/scsi/bfa/bfad_debugfs.h
 create mode 100644 drivers/scsi/bfa/include/bfa_dbcmd.h

diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
new file mode 100644
index 0000000..15a09b6
--- /dev/null
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -0,0 +1,543 @@
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
+#include "bfad_debugfs.h"
+
+/* BFAD debugfs node - /sys/kernel/debug/bfa/bfa_ctl */
+
+static struct dentry *bfa_debugfs_root;
+static struct dentry *bfa_ctl;
+
+static void
+bfad_set_driver_attr(struct bfad_s *bfad,
+		struct bfa_ioc_driver_attr_s *driver_attr)
+{
+	strcpy(driver_attr->driver, BFAD_DRIVER_NAME);
+	strncpy(driver_attr->driver_ver, BFAD_DRIVER_VERSION, BFA_VERSION_LEN);
+}
+
+
+int
+bfad_ioc_get_version(void *cmd)
+{
+	bfa_dbcmd_ioc_get_version_s *dbcmd = (bfa_dbcmd_ioc_get_version_s *)cmd;
+	int             rc = 0;
+
+	dbcmd->version = BFA_DEBUGFS_VERSION;
+	dbcmd->status = BFA_STATUS_OK;
+
+	return rc;
+}
+
+/*
+ * Assume the instance numbers are in ascending order.
+ * Returns the number of ioc instances in dbcmd.cnt;
+ * dbcmd.bm[] has the bits set corresponding to the instances numbers
+ */
+int
+bfad_ioc_get_inst(void *cmd)
+{
+	struct bfad_s         *bfad = NULL;
+	bfa_dbcmd_ioc_get_inst_s *dbcmd =
+			(bfa_dbcmd_ioc_get_inst_s *)cmd;
+	int idx = 0, bt_idx, rc = 0;
+	int bt_sz = sizeof(dbcmd->bm[0]) * 8;
+
+	memset(dbcmd, 0, sizeof(bfa_dbcmd_ioc_get_inst_s));
+
+	mutex_lock(&bfad_mutex);
+	while (!bfad_scan_done) {
+		mutex_unlock(&bfad_mutex);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(HZ);
+		mutex_lock(&bfad_mutex);
+	}
+
+	list_for_each_entry(bfad, &bfad_list, list_entry) {
+		if (bfad->inst_no >= (idx + 1) * bt_sz) {
+			idx++;
+			if (idx > sizeof(dbcmd->bm)) {
+				/*
+				 * too many instances
+				 */
+				rc = EIO;
+				goto ext;
+			}
+		}
+
+		bt_idx = bfad->inst_no - idx * bt_sz;
+		if (bt_idx < 0) {
+			rc = EIO;   /* inst_no not in ascending order */
+			goto ext;
+		}
+		dbcmd->bm[idx] |= (1 << bt_idx);
+		dbcmd->cnt++;
+	}
+
+ext:
+	mutex_unlock(&bfad_mutex);
+	return rc;
+}
+
+int
+bfad_ioc_get_info(void *cmd)
+{
+	int             i;
+	bfa_dbcmd_ioc_info_s *dbcmd = (bfa_dbcmd_ioc_info_s *)cmd;
+	struct bfa_pport_attr_s pattr;
+	struct bfad_s         *bfad;
+	unsigned long   flags;
+
+	bfad = bfad_find_bfad_by_inst_no(dbcmd->bfad_num);
+	if (bfad == NULL)
+		return EINVAL;
+
+	memset(dbcmd, 0, sizeof(bfa_dbcmd_ioc_info_s));
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_fcport_get_attr(&bfad->bfa, &pattr);
+	dbcmd->nwwn = pattr.nwwn;
+	dbcmd->pwwn = pattr.pwwn;
+
+	dbcmd->ioc_type = bfa_get_type(&bfad->bfa);
+	dbcmd->mac = bfa_get_mac(&bfad->bfa);
+	bfa_get_adapter_serial_num(&bfad->bfa, dbcmd->serialnum);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	strcpy(dbcmd->name, bfad->adapter_name);
+	strcpy(dbcmd->port_name, bfad->port_name);
+	strcpy(dbcmd->hwpath, bfad->pci_name);
+	/*
+	 * set adapter hw path
+	 */
+	strcpy(dbcmd->adapter_hwpath, bfad->pci_name);
+	i = strlen(dbcmd->adapter_hwpath) - 1;
+	while (dbcmd->adapter_hwpath[i] != '.')
+		i--;
+	dbcmd->adapter_hwpath[i] = '\0';
+
+	dbcmd->status = BFA_STATUS_OK;
+
+	return 0;
+}
+
+int
+bfad_ioc_get_attr(void *cmd)
+{
+	bfa_dbcmd_ioc_attr_s *dbcmd = (bfa_dbcmd_ioc_attr_s *)cmd;
+	struct bfad_s         *bfad;
+	unsigned long   flags;
+
+	bfad = bfad_find_bfad_by_inst_no(dbcmd->bfad_num);
+	if (bfad == NULL)
+		return EINVAL;
+
+	memset(&dbcmd->ioc_attr, 0, sizeof(struct bfa_ioc_attr_s));
+	dbcmd->status = BFA_STATUS_OK;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_get_attr(&bfad->bfa, &dbcmd->ioc_attr);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	bfad_set_driver_attr(bfad, &dbcmd->ioc_attr.driver_attr);
+
+	strcpy(dbcmd->ioc_attr.driver_attr.fw_ver,
+		dbcmd->ioc_attr.adapter_attr.fw_ver);
+	strcpy(dbcmd->ioc_attr.driver_attr.bios_ver,
+		dbcmd->ioc_attr.adapter_attr.optrom_ver);
+
+	/* copy chip rev info first otherwise it will be overwritten */
+	memcpy(bfad->pci_attr.chip_rev, dbcmd->ioc_attr.pci_attr.chip_rev,
+		sizeof(bfad->pci_attr.chip_rev));
+	memcpy(&dbcmd->ioc_attr.pci_attr, &bfad->pci_attr,
+		sizeof(struct bfa_ioc_pci_attr_s));
+
+	return 0;
+}
+
+int
+bfad_port_get_attr(void *cmd)
+{
+	bfa_dbcmd_port_attr_s *dbcmd = (bfa_dbcmd_port_attr_s *)cmd;
+	struct bfa_port_attr_s port_attr;
+	struct bfad_s         *bfad;
+	unsigned long   flags;
+
+
+	bfad = bfad_find_bfad_by_inst_no(dbcmd->bfad_num);
+	if (bfad == NULL)
+		return EINVAL;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_fcport_get_attr(&bfad->bfa, &dbcmd->attr);
+	bfa_fcs_port_get_attr(&bfad->bfa_fcs.fabric.bport, &port_attr);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (dbcmd->attr.topology != BFA_PPORT_TOPOLOGY_NONE)
+		dbcmd->attr.pid = port_attr.pid;
+	else
+		dbcmd->attr.pid = 0;
+
+	dbcmd->attr.port_type = port_attr.port_type;
+	dbcmd->attr.loopback = port_attr.loopback;
+	dbcmd->attr.authfail = port_attr.authfail;
+	strncpy(dbcmd->attr.port_symname.symname,
+		port_attr.port_cfg.sym_name.symname,
+		sizeof(port_attr.port_cfg.sym_name.symname));
+
+	dbcmd->status = BFA_STATUS_OK;
+
+	return 0;
+}
+
+int
+bfad_cee_attr(void *cmd)
+{
+	bfa_dbcmd_cee_attr_s *dbcmd = (bfa_dbcmd_cee_attr_s *)cmd;
+	struct bfad_s *bfad;
+	void *buffer;
+	struct bfad_hal_comp cee_comp;
+	unsigned long flags;
+
+	bfad = bfad_find_bfad_by_inst_no(dbcmd->bfad_num);
+	if (bfad == NULL)
+		return EINVAL;
+
+	buffer = kzalloc(dbcmd->buf_size, GFP_KERNEL);
+	if (!buffer)
+		return ENOMEM;
+
+	cee_comp.status = 0;
+	init_completion(&cee_comp.comp);
+	mutex_lock(&bfad_mutex);
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	dbcmd->status = bfa_cee_get_attr(&bfad->bfa.modules.cee, buffer,
+					bfad_hcb_comp, &cee_comp);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	if (dbcmd->status != BFA_STATUS_OK) {
+		mutex_unlock(&bfad_mutex);
+		goto out_free_buffer;
+	}
+	wait_for_completion(&cee_comp.comp);
+	mutex_unlock(&bfad_mutex);
+	if (copy_to_user((void __user *)(size_t)dbcmd->buf_ptr,
+			(uint8_t *) buffer, dbcmd->buf_size)) {
+		kfree(buffer);
+		return EIO;
+	}
+out_free_buffer:
+	kfree(buffer);
+	return 0;
+}
+
+int
+bfad_iocfc_get_attr(void *cmd)
+{
+	bfa_dbcmd_iocfc_attr_s  *dbcmd = (bfa_dbcmd_iocfc_attr_s *)cmd;
+	struct bfad_s           *bfad;
+
+	bfad = bfad_find_bfad_by_inst_no(dbcmd->bfad_num);
+	if (bfad == NULL)
+		return EINVAL;
+
+	dbcmd->status = BFA_STATUS_OK;
+	bfa_iocfc_get_attr(&bfad->bfa, &dbcmd->iocfc_attr);
+
+	return 0;
+}
+
+int
+bfad_debug_get_drv_trace(void *cmd)
+{
+	bfa_dbcmd_debug_s *dbcmd = (bfa_dbcmd_debug_s *)cmd;
+	struct bfad_s         *bfad;
+
+	bfad = bfad_find_bfad_by_inst_no(dbcmd->bfad_num);
+	if (bfad == NULL)
+		return EINVAL;
+
+	if (dbcmd->bufsz < sizeof(struct bfa_trc_mod_s)) {
+		dbcmd->status = BFA_STATUS_EINVAL;
+		goto out;
+	}
+
+	if (copy_to_user
+		((void __user *)(size_t) dbcmd->buf_ptr,
+		(uint8_t *) bfad->trcmod,
+		dbcmd->bufsz))
+		return EIO;
+
+	dbcmd->status = BFA_STATUS_OK;
+out:
+	return 0;
+}
+
+int
+bfad_debug_get_fw_trace(bfa_boolean_t saved, void *cmd)
+{
+	bfa_dbcmd_debug_s *dbcmd = (bfa_dbcmd_debug_s *)cmd;
+	void           *buf;
+	struct bfad_s         *bfad;
+	unsigned long   flags;
+
+	bfad = bfad_find_bfad_by_inst_no(dbcmd->bfad_num);
+	if (bfad == NULL)
+		return EINVAL;
+
+	if (dbcmd->bufsz < sizeof(struct bfa_trc_mod_s)) {
+		dbcmd->status = BFA_STATUS_EINVAL;
+		goto out;
+	}
+
+	buf = vmalloc(dbcmd->bufsz);
+	if (!buf)
+		return ENOMEM;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	if (!saved)
+		dbcmd->status = bfa_debug_fwtrc(&bfad->bfa, buf, &dbcmd->bufsz);
+	else
+		dbcmd->status = bfa_debug_fwsave(&bfad->bfa, buf,
+						&dbcmd->bufsz);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (dbcmd->status != BFA_STATUS_OK)
+		goto out_free_buf;
+
+	if (copy_to_user
+		((void __user *)(size_t) dbcmd->buf_ptr, (uint8_t *) buf,
+		dbcmd->bufsz)) {
+		vfree(buf);
+		return EIO;
+	}
+
+out_free_buf:
+	vfree(buf);
+out:
+	return 0;
+}
+
+/**
+ * bfa_debugfs_ctl - Interface to the Brocade driver.
+ *
+ * Description:
+ * This routine is the debufs entry point for the Brocade HBA.
+ * We receive the buf from the user space which contains the command code
+ * to be processed and the expected data structure to be returned;
+ * We process the request and fill the user space buf as per the command code.
+ *
+ * Returns:
+ * This function returns number of bytes written. On error it will return a
+ * negative error value.
+ **/
+static ssize_t
+bfa_debugfs_ctl(struct file *file, const char __user *buf,
+				size_t nbytes, loff_t *ppos)
+{
+	/* Fetching the inode */
+	struct inode *inode = file->f_path.dentry->d_inode;
+	bfa_ctl_s	*dbcmd;
+	bfa_ctl_s __user *usr_buf = (bfa_ctl_s __user *) buf;
+	int rc = EINVAL;
+
+	/* Don't allow parallel writes to the same file */
+	mutex_lock(&inode->i_mutex);
+
+	if (!buf)
+		return -rc;
+
+	if (!bfad_is_ready()) {
+		rc = EAGAIN;
+		return -rc;
+	}
+
+	dbcmd = kzalloc(sizeof(bfa_ctl_s), GFP_KERNEL);
+	if (!dbcmd) {
+		printk(KERN_INFO "Memory allocation failed for dbcmd buf\n");
+		goto ext;
+	}
+
+	if (copy_from_user((bfa_ctl_s *) dbcmd,
+			(void __user *) usr_buf,
+			sizeof(bfa_ctl_s))) {
+		rc = EIO;
+		goto out;
+	}
+
+	dbcmd->cmddata = kzalloc((nbytes - sizeof(bfa_ctl_s)), GFP_KERNEL);
+	if (!dbcmd->cmddata) {
+		printk(KERN_INFO
+			"Memory alloc failed for dbcmd cmddata\n");
+		goto ext;
+	}
+
+	if (copy_from_user((void *) dbcmd->cmddata,
+			(void __user *) usr_buf->cmddata,
+			(nbytes - sizeof(bfa_ctl_s)))) {
+		rc = EIO;
+		goto out;
+	}
+
+	switch (dbcmd->cmd_code) {
+
+	/* IOC */
+	case DEBUG_DBCMD_IOC_GET_VERSION:
+		rc = bfad_ioc_get_version(dbcmd->cmddata);
+		break;
+
+	case DEBUG_DBCMD_IOC_GET_INSTS:
+		rc = bfad_ioc_get_inst(dbcmd->cmddata);
+		break;
+
+	case DEBUG_DBCMD_IOC_GET_ATTR:
+		rc = bfad_ioc_get_attr(dbcmd->cmddata);
+		break;
+
+	case DEBUG_DBCMD_IOC_GET_INFO:
+		rc = bfad_ioc_get_info(dbcmd->cmddata);
+		break;
+
+	/* PORT */
+	case DEBUG_DBCMD_PORT_GET_ATTR:
+		rc = bfad_port_get_attr(dbcmd->cmddata);
+		break;
+
+	/* CEE */
+	case DEBUG_DBCMD_CEE_GET_ATTR:
+		rc = bfad_cee_attr(dbcmd->cmddata);
+		break;
+
+	/* IOCFC */
+	case DEBUG_DBCMD_IOCFC_GET_ATTR:
+		rc = bfad_iocfc_get_attr(dbcmd->cmddata);
+		break;
+
+	/* Driver / FW trace */
+	case DEBUG_DBCMD_GET_DRV_TRACE:
+		rc = bfad_debug_get_drv_trace(dbcmd->cmddata);
+		break;
+
+	case DEBUG_DBCMD_GET_FW_TRACE:
+		rc = bfad_debug_get_fw_trace(BFA_FALSE, dbcmd->cmddata);
+		break;
+
+	default:
+		printk(KERN_INFO "Command code %d not supported\n",
+					dbcmd->cmd_code);
+		rc = EINVAL;
+		break;
+	}
+
+	if (rc == 0)
+		rc = nbytes;
+
+	if (copy_to_user((void __user *)usr_buf->cmddata,
+			(uint8_t *)dbcmd->cmddata,
+			(nbytes - sizeof(bfa_ctl_s)))) {
+		kfree(dbcmd->cmddata);
+		return EIO;
+	}
+
+	if (copy_to_user((void __user *)usr_buf,
+			(uint8_t *)dbcmd,
+			sizeof(bfa_ctl_s))) {
+		kfree(dbcmd);
+		return EIO;
+	}
+
+out:
+	kfree(dbcmd->cmddata);
+	kfree(dbcmd);
+ext:
+	mutex_unlock(&inode->i_mutex);
+	return rc;
+}
+
+#undef bfa_ctl_fops
+static const struct file_operations bfa_ctl_fops = {
+	.owner   =      THIS_MODULE,
+	.write   =      bfa_debugfs_ctl,
+};
+
+/**
+ * bfad_debugfs_init - Function that creates the bfad debugfs hierarchy.
+ *
+ * Description:
+ * 	This routine creates the debugfs hierarchy for BFA driver.
+ * 	Node bfa_ctl is created under /sys/kernel/debug/bfa
+ * 	All the user space applications query this node to get debug info
+ * 	regarding the BFA driver.
+ *
+ * Returns:
+ * 	This function does not return anything.
+ **/
+inline void
+bfad_debugfs_init(void)
+{
+	char name[64];
+
+	/* Setup the bfad root directory */
+	if (!bfa_debugfs_root) {
+		bfa_debugfs_root = debugfs_create_dir("bfa", NULL);
+		if (!bfa_debugfs_root) {
+			printk(KERN_INFO "Unable to create debugfs dir for bfa\n");
+			goto debug_fail;
+		}
+	}
+
+	/* Setup the bfa_ctl */
+	snprintf(name, sizeof(name), "bfa_ctl");
+	bfa_ctl = debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
+					bfa_debugfs_root,
+					NULL,
+					&bfa_ctl_fops);
+
+	if (!bfa_ctl) {
+		debugfs_remove(bfa_debugfs_root);
+		printk(KERN_INFO "Unable to create the bfa_ctl node\n");
+		goto debug_fail;
+	}
+
+debug_fail:
+	return;
+}
+
+/**
+ * bfad_debugfs_exit - Function that clears the bfad debugfs hierarchy.
+ *
+ * Description:
+ *      This routine clears the debugfs hierarchy of the BFA driver.
+ *
+ * Returns:
+ *      This function does not return anything.
+ **/
+inline void
+bfad_debugfs_exit(void)
+{
+	/* Remove the BFA debugfs control node bfa_ctl */
+	if (bfa_ctl) {
+		debugfs_remove(bfa_ctl);
+		bfa_ctl = NULL;
+	}
+
+	/* Remove the BFA debugfs root */
+	if (bfa_debugfs_root) {
+		debugfs_remove(bfa_debugfs_root);
+		bfa_debugfs_root = NULL;
+	}
+	return;
+}
+
diff --git a/drivers/scsi/bfa/bfad_debugfs.h b/drivers/scsi/bfa/bfad_debugfs.h
new file mode 100644
index 0000000..d2e1b78
--- /dev/null
+++ b/drivers/scsi/bfa/bfad_debugfs.h
@@ -0,0 +1,56 @@
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
+#ifndef __BFAD_DEBUGFS_H__
+#define __BFAD_DEBUGFS_H__
+
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <asm/uaccess.h>
+
+#include "bfa_os_inc.h"
+#include <cs/bfa_trc.h>
+#include "bfa_dbcmd.h"
+
+#include "bfad_drv.h"
+#include "bfad_ipfc.h"
+#include "bfad_im.h"
+#include "fcs/bfa_fcs_fcpim.h"
+#include "fcs/bfa_fcs_auth.h"
+#include "bfad_trcmod.h"
+
+#define BFA_DEBUGFS_VERSION 0x101f
+
+enum bfad_debug_dbcmd_type {
+	DEBUG_DBCMD_IOC_GET_VERSION = 1,
+	DEBUG_DBCMD_IOC_GET_INSTS   = 2,
+	DEBUG_DBCMD_IOC_GET_INFO    = 3,
+	DEBUG_DBCMD_IOC_GET_ATTR    = 4,
+	DEBUG_DBCMD_PORT_GET_ATTR   = 5,
+	DEBUG_DBCMD_CEE_GET_ATTR    = 6,
+	DEBUG_DBCMD_IOCFC_GET_ATTR  = 7,
+	DEBUG_DBCMD_GET_DRV_TRACE   = 8,
+	DEBUG_DBCMD_GET_FW_TRACE    = 9,
+};
+
+struct bfa_ctl_s {
+	uint32_t        cmd_code;
+	uint32_t        rsvd;
+	void            *cmddata;
+};
+
+#endif
diff --git a/drivers/scsi/bfa/include/bfa_dbcmd.h b/drivers/scsi/bfa/include/bfa_dbcmd.h
new file mode 100644
index 0000000..bf5274a
--- /dev/null
+++ b/drivers/scsi/bfa/include/bfa_dbcmd.h
@@ -0,0 +1,98 @@
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
+#ifndef __BFA_DBCMD_H__
+#define __BFA_DBCMD_H__
+
+#include "defs/bfa_defs_aen.h"
+#include "defs/bfa_defs_ioc.h"
+#include "defs/bfa_defs_pport.h"
+#include "defs/bfa_defs_iocfc.h"
+
+struct bfa_dbcmd_ioc_get_inst_s {
+	uint32_t        cnt;    /* total number of ioc instances */
+	uint32_t        rsvd;
+	char            bm[256 / 8];    /* bit mask with instances positions */
+};
+
+struct bfa_dbcmd_ioc_get_version_s {
+	bfa_status_t    status;
+	uint32_t        version;
+};
+
+struct bfa_dbcmd_ioc_info_s {
+	bfa_status_t    status;
+	uint16_t        bfad_num;
+	uint16_t        rsvd;
+	char            serialnum[64];
+	char            hwpath[BFA_STRING_32];
+	char            adapter_hwpath[BFA_STRING_32];
+	char            guid[BFA_ADAPTER_SYM_NAME_LEN*2];
+	char            name[BFA_ADAPTER_SYM_NAME_LEN];
+	char            port_name[BFA_ADAPTER_SYM_NAME_LEN];
+	char            eth_name[BFA_ADAPTER_SYM_NAME_LEN];
+	wwn_t           pwwn;
+	wwn_t           nwwn;
+	wwn_t           factorypwwn;
+	wwn_t           factorynwwn;
+	struct mac_s	mac; /* Burnt-in mac address */
+	struct mac_s	current_mac; /* Currently assigned mac address */
+	enum bfa_ioc_type_e ioc_type;
+	uint16_t        pvid; /* Port vlan id */
+	uint16_t        rsvd1[3];
+};
+
+struct bfa_dbcmd_ioc_attr_s {
+	bfa_status_t    status;
+	uint16_t        bfad_num;
+	uint16_t        rsvd;
+	struct bfa_ioc_attr_s  ioc_attr;
+};
+
+struct bfa_dbcmd_port_attr_s {
+	bfa_status_t    status;
+	uint16_t        bfad_num;
+	uint16_t        rsvd;
+	struct bfa_pport_attr_s attr;
+};
+
+struct bfa_dbcmd_cee_attr_s {
+	bfa_status_t    status;
+	uint16_t        bfad_num;
+	uint16_t        rsvd;
+	uint32_t        buf_size;
+	uint32_t        rsvd1;
+	uint64_t        buf_ptr;
+};
+
+struct bfa_dbcmd_iocfc_attr_t {
+	bfa_status_t    status;
+	uint16_t        bfad_num;
+	uint16_t        rsvd;
+	struct bfa_iocfc_attr_s  iocfc_attr;
+};
+
+struct bfa_dbcmd_debug_s {
+	bfa_status_t    status;
+	uint16_t        bfad_num;
+	uint16_t        rsvd;
+	uint32_t        bufsz;
+	int             inst_no;
+	uint64_t        buf_ptr;
+};
+
+#endif /* __BFA_DBCMD_H__ */
-- 
1.6.5.3

