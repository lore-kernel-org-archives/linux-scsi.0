From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 24/24] bfa: add debugfs support
Date: Thu, 8 Jul 2010 20:02:55 -0700
Message-ID: <1278644575-4928-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:55964 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753763Ab0GIDDB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 23:03:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: kgudipat@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

- Add debugfs support to obtain firmware trace, driver trace
  and read/write to registers.

- debugfs hierarchy:
  /sys/kernel/debug/bfa/host#
   where the host number corresponds to the one under /sys/class/scsi_host/host#

- Following are the new debugfs entries added:
  drvtrc: collect current driver trace
  fwtrc: collect current firmware trace.
  fwsave: collect last saved fw trace as a result of firmware crash.
  regwr: write one word to chip register
  regrd: read one or more words from chip register.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/Makefile       |    2 +-
 drivers/scsi/bfa/bfad.c         |   12 +
 drivers/scsi/bfa/bfad_debugfs.c |  547 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfad_drv.h     |   12 +-
 4 files changed, 571 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/bfa/bfad_debugfs.c

diff --git a/drivers/scsi/bfa/Makefile b/drivers/scsi/bfa/Makefile
index 17e06ca..ac3fdf0 100644
--- a/drivers/scsi/bfa/Makefile
+++ b/drivers/scsi/bfa/Makefile
@@ -1,7 +1,7 @@
 obj-$(CONFIG_SCSI_BFA_FC) := bfa.o
 
 bfa-y := bfad.o bfad_intr.o bfad_os.o bfad_im.o bfad_attr.o bfad_fwimg.o
-
+bfa-y += bfad_debugfs.o
 bfa-y += bfa_core.o bfa_ioc.o bfa_ioc_ct.o bfa_ioc_cb.o bfa_iocfc.o bfa_fcxp.o
 bfa-y += bfa_lps.o bfa_hw_cb.o bfa_hw_ct.o bfa_intr.o bfa_timer.o bfa_rport.o
 bfa-y += bfa_fcport.o bfa_port.o bfa_uf.o bfa_sgpg.o bfa_module.o bfa_ioim.o
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index a17800e..915a29d 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -57,6 +57,7 @@ static int      ipfc_enable = BFA_FALSE;
 static int	fdmi_enable = BFA_TRUE;
 int 		bfa_lun_queue_depth = BFAD_LUN_QUEUE_DEPTH;
 int      	bfa_linkup_delay = -1;
+int		bfa_debugfs_enable = 1;
 
 module_param(os_name, charp, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(os_name, "OS name of the hba host machine");
@@ -106,6 +107,9 @@ MODULE_PARM_DESC(bfa_linkup_delay, "Link up delay, default=30 secs for boot"
 module_param(fdmi_enable, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(fdmi_enable, "Enables fdmi registration, default=1,"
 		" Range[false:0|true:1]");
+module_param(bfa_debugfs_enable, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(bfa_debugfs_enable, "Enables debugfs feature, default=1,"
+		" Range[false:0|true:1]");
 
 /*
  * Stores the module parm num_sgpgs value;
@@ -903,6 +907,10 @@ bfad_cfg_pport(struct bfad_s *bfad, enum bfa_port_role role)
 		bfad->pport.roles |= BFA_PORT_ROLE_FCP_IM;
 	}
 
+	/* Setup the debugfs node for this scsi_host */
+	if (bfa_debugfs_enable)
+		bfad_debugfs_init(&bfad->pport);
+
 	bfad->bfad_flags |= BFAD_CFG_PPORT_DONE;
 
 out:
@@ -912,6 +920,10 @@ out:
 void
 bfad_uncfg_pport(struct bfad_s *bfad)
 {
+	 /* Remove the debugfs node for this scsi_host */
+	kfree(bfad->regdata);
+	bfad_debugfs_exit(&bfad->pport);
+
 	if ((bfad->pport.roles & BFA_PORT_ROLE_FCP_IPFC) && ipfc_enable) {
 		bfad_ipfc_port_delete(bfad, &bfad->pport);
 		bfad->pport.roles &= ~BFA_PORT_ROLE_FCP_IPFC;
diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
new file mode 100644
index 0000000..4b82f12
--- /dev/null
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -0,0 +1,547 @@
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
+#include <linux/debugfs.h>
+
+#include <bfad_drv.h>
+#include <bfad_im.h>
+
+/*
+ * BFA debufs interface
+ *
+ * To access the interface, debugfs file system should be mounted
+ * if not already mounted using:
+ * mount -t debugfs none /sys/kernel/debug
+ *
+ * BFA Hierarchy:
+ * 	- bfa/host#
+ * where the host number corresponds to the one under /sys/class/scsi_host/host#
+ *
+ * Debugging service available per host:
+ * fwtrc:  To collect current firmware trace.
+ * drvtrc: To collect current driver trace
+ * fwsave: To collect last saved fw trace as a result of firmware crash.
+ * regwr:  To write one word to chip register
+ * regrd:  To read one or more words from chip register.
+ */
+
+struct bfad_debug_info {
+	char *debug_buffer;
+	void *i_private;
+	int buffer_len;
+};
+
+static int
+bfad_debugfs_open_drvtrc(struct inode *inode, struct file *file)
+{
+	struct bfad_port_s *port = inode->i_private;
+	struct bfad_s *bfad = port->bfad;
+	struct bfad_debug_info *debug;
+
+	debug = kzalloc(sizeof(struct bfad_debug_info), GFP_KERNEL);
+	if (!debug)
+		return -ENOMEM;
+
+	debug->debug_buffer = (void *) bfad->trcmod;
+	debug->buffer_len = sizeof(struct bfa_trc_mod_s);
+
+	file->private_data = debug;
+
+	return 0;
+}
+
+static int
+bfad_debugfs_open_fwtrc(struct inode *inode, struct file *file)
+{
+	struct bfad_port_s *port = inode->i_private;
+	struct bfad_s *bfad = port->bfad;
+	struct bfad_debug_info *fw_debug;
+	unsigned long flags;
+	int rc;
+
+	fw_debug = kzalloc(sizeof(struct bfad_debug_info), GFP_KERNEL);
+	if (!fw_debug)
+		return -ENOMEM;
+
+	fw_debug->buffer_len = sizeof(struct bfa_trc_mod_s);
+
+	fw_debug->debug_buffer = vmalloc(fw_debug->buffer_len);
+	if (!fw_debug->debug_buffer) {
+		kfree(fw_debug);
+		printk(KERN_INFO "bfad[%d]: Failed to allocate fwtrc buffer\n",
+				bfad->inst_no);
+		return -ENOMEM;
+	}
+
+	memset(fw_debug->debug_buffer, 0, fw_debug->buffer_len);
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	rc = bfa_debug_fwtrc(&bfad->bfa,
+			fw_debug->debug_buffer,
+			&fw_debug->buffer_len);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	if (rc != BFA_STATUS_OK) {
+		vfree(fw_debug->debug_buffer);
+		fw_debug->debug_buffer = NULL;
+		kfree(fw_debug);
+		printk(KERN_INFO "bfad[%d]: Failed to collect fwtrc\n",
+				bfad->inst_no);
+		return -ENOMEM;
+	}
+
+	file->private_data = fw_debug;
+
+	return 0;
+}
+
+static int
+bfad_debugfs_open_fwsave(struct inode *inode, struct file *file)
+{
+	struct bfad_port_s *port = inode->i_private;
+	struct bfad_s *bfad = port->bfad;
+	struct bfad_debug_info *fw_debug;
+	unsigned long flags;
+	int rc;
+
+	fw_debug = kzalloc(sizeof(struct bfad_debug_info), GFP_KERNEL);
+	if (!fw_debug)
+		return -ENOMEM;
+
+	fw_debug->buffer_len = sizeof(struct bfa_trc_mod_s);
+
+	fw_debug->debug_buffer = vmalloc(fw_debug->buffer_len);
+	if (!fw_debug->debug_buffer) {
+		kfree(fw_debug);
+		printk(KERN_INFO "bfad[%d]: Failed to allocate fwsave buffer\n",
+				bfad->inst_no);
+		return -ENOMEM;
+	}
+
+	memset(fw_debug->debug_buffer, 0, fw_debug->buffer_len);
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	rc = bfa_debug_fwsave(&bfad->bfa,
+			fw_debug->debug_buffer,
+			&fw_debug->buffer_len);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	if (rc != BFA_STATUS_OK) {
+		vfree(fw_debug->debug_buffer);
+		fw_debug->debug_buffer = NULL;
+		kfree(fw_debug);
+		printk(KERN_INFO "bfad[%d]: Failed to collect fwsave\n",
+				bfad->inst_no);
+		return -ENOMEM;
+	}
+
+	file->private_data = fw_debug;
+
+	return 0;
+}
+
+static int
+bfad_debugfs_open_reg(struct inode *inode, struct file *file)
+{
+	struct bfad_debug_info *reg_debug;
+
+	reg_debug = kzalloc(sizeof(struct bfad_debug_info), GFP_KERNEL);
+	if (!reg_debug)
+		return -ENOMEM;
+
+	reg_debug->i_private = inode->i_private;
+
+	file->private_data = reg_debug;
+
+	return 0;
+}
+
+/* Changes the current file position */
+static loff_t
+bfad_debugfs_lseek(struct file *file, loff_t offset, int orig)
+{
+	struct bfad_debug_info *debug;
+	loff_t pos = file->f_pos;
+
+	debug = file->private_data;
+
+	switch (orig) {
+	case 0:
+		file->f_pos = offset;
+		break;
+	case 1:
+		file->f_pos += offset;
+		break;
+	case 2:
+		file->f_pos = debug->buffer_len - offset;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (file->f_pos < 0 || file->f_pos > debug->buffer_len) {
+		file->f_pos = pos;
+		return -EINVAL;
+	}
+
+	return file->f_pos;
+}
+
+static ssize_t
+bfad_debugfs_read(struct file *file, char __user *buf,
+			size_t nbytes, loff_t *pos)
+{
+	struct bfad_debug_info *debug = file->private_data;
+
+	if (!debug || !debug->debug_buffer)
+		return 0;
+
+	return memory_read_from_buffer(buf, nbytes, pos,
+				debug->debug_buffer, debug->buffer_len);
+}
+
+#define BFA_REG_CT_ADDRSZ	(0x40000)
+#define BFA_REG_CB_ADDRSZ	(0x20000)
+#define BFA_REG_ADDRSZ(__bfa)	\
+	((bfa_ioc_devid(&(__bfa)->ioc) == BFA_PCI_DEVICE_ID_CT) ?	\
+		BFA_REG_CT_ADDRSZ : BFA_REG_CB_ADDRSZ)
+#define BFA_REG_ADDRMSK(__bfa)  ((uint32_t)(BFA_REG_ADDRSZ(__bfa) - 1))
+
+static bfa_status_t
+bfad_reg_offset_check(struct bfa_s *bfa, u32 offset, u32 len)
+{
+	u8	area;
+
+	/* check [16:15] */
+	area = (offset >> 15) & 0x7;
+	if (area == 0) {
+		/* PCIe core register */
+		if ((offset + (len<<2)) > 0x8000)    /* 8k dwords or 32KB */
+			return BFA_STATUS_EINVAL;
+	} else if (area == 0x1) {
+		/* CB 32 KB memory page */
+		if ((offset + (len<<2)) > 0x10000)    /* 8k dwords or 32KB */
+			return BFA_STATUS_EINVAL;
+	} else {
+		/* CB register space 64KB */
+		if ((offset + (len<<2)) > BFA_REG_ADDRMSK(bfa))
+			return BFA_STATUS_EINVAL;
+	}
+	return BFA_STATUS_OK;
+}
+
+static ssize_t
+bfad_debugfs_read_regrd(struct file *file, char __user *buf,
+		size_t nbytes, loff_t *pos)
+{
+	struct bfad_debug_info *regrd_debug = file->private_data;
+	struct bfad_port_s *port = (struct bfad_port_s *)regrd_debug->i_private;
+	struct bfad_s *bfad = port->bfad;
+	ssize_t rc;
+
+	if (!bfad->regdata)
+		return 0;
+
+	rc = memory_read_from_buffer(buf, nbytes, pos,
+			bfad->regdata, bfad->reglen);
+
+	if ((*pos + nbytes) >= bfad->reglen) {
+		kfree(bfad->regdata);
+		bfad->regdata = NULL;
+		bfad->reglen = 0;
+	}
+
+	return rc;
+}
+
+static ssize_t
+bfad_debugfs_write_regrd(struct file *file, const char __user *buf,
+		size_t nbytes, loff_t *ppos)
+{
+	struct bfad_debug_info *regrd_debug = file->private_data;
+	struct bfad_port_s *port = (struct bfad_port_s *)regrd_debug->i_private;
+	struct bfad_s *bfad = port->bfad;
+	struct bfa_s *bfa = &bfad->bfa;
+	struct bfa_ioc_s *ioc = &bfa->ioc;
+	int addr, len, rc, i;
+	u32 *regbuf;
+	void __iomem *rb, *reg_addr;
+	unsigned long flags;
+
+	rc = sscanf(buf, "%x:%x", &addr, &len);
+	if (rc < 2) {
+		printk(KERN_INFO
+			"bfad[%d]: %s failed to read user buf\n",
+			bfad->inst_no, __func__);
+		return -EINVAL;
+	}
+
+	kfree(bfad->regdata);
+	bfad->regdata = NULL;
+	bfad->reglen = 0;
+
+	bfad->regdata = kzalloc(len << 2, GFP_KERNEL);
+	if (!bfad->regdata) {
+		printk(KERN_INFO "bfad[%d]: Failed to allocate regrd buffer\n",
+				bfad->inst_no);
+		return -ENOMEM;
+	}
+
+	bfad->reglen = len << 2;
+	rb = bfa_ioc_bar0(ioc);
+	addr &= BFA_REG_ADDRMSK(bfa);
+
+	/* offset and len sanity check */
+	rc = bfad_reg_offset_check(bfa, addr, len);
+	if (rc) {
+		printk(KERN_INFO "bfad[%d]: Failed reg offset check\n",
+				bfad->inst_no);
+		kfree(bfad->regdata);
+		bfad->regdata = NULL;
+		bfad->reglen = 0;
+		return -EINVAL;
+	}
+
+	reg_addr = rb + addr;
+	regbuf =  (u32 *)bfad->regdata;
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	for (i = 0; i < len; i++) {
+		*regbuf = bfa_reg_read(reg_addr);
+		regbuf++;
+		reg_addr += sizeof(u32);
+	}
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	return nbytes;
+}
+
+static ssize_t
+bfad_debugfs_write_regwr(struct file *file, const char __user *buf,
+		size_t nbytes, loff_t *ppos)
+{
+	struct bfad_debug_info *debug = file->private_data;
+	struct bfad_port_s *port = (struct bfad_port_s *)debug->i_private;
+	struct bfad_s *bfad = port->bfad;
+	struct bfa_s *bfa = &bfad->bfa;
+	struct bfa_ioc_s *ioc = &bfa->ioc;
+	int addr, val, rc;
+	void __iomem *reg_addr;
+	unsigned long flags;
+
+	rc = sscanf(buf, "%x:%x", &addr, &val);
+	if (rc < 2) {
+		printk(KERN_INFO
+			"bfad[%d]: %s failed to read user buf\n",
+			bfad->inst_no, __func__);
+		return -EINVAL;
+	}
+
+	addr &= BFA_REG_ADDRMSK(bfa); /* offset only 17 bit and word align */
+
+	/* offset and len sanity check */
+	rc = bfad_reg_offset_check(bfa, addr, 1);
+	if (rc) {
+		printk(KERN_INFO
+			"bfad[%d]: Failed reg offset check\n",
+			bfad->inst_no);
+		return -EINVAL;
+	}
+
+	reg_addr = (uint32_t *) ((uint8_t *) bfa_ioc_bar0(ioc) + addr);
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_reg_write(reg_addr, val);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	return nbytes;
+}
+
+static int
+bfad_debugfs_release(struct inode *inode, struct file *file)
+{
+	struct bfad_debug_info *debug = file->private_data;
+
+	if (!debug)
+		return 0;
+
+	file->private_data = NULL;
+	kfree(debug);
+	return 0;
+}
+
+static int
+bfad_debugfs_release_fwtrc(struct inode *inode, struct file *file)
+{
+	struct bfad_debug_info *fw_debug = file->private_data;
+
+	if (!fw_debug)
+		return 0;
+
+	if (fw_debug->debug_buffer)
+		vfree(fw_debug->debug_buffer);
+
+	file->private_data = NULL;
+	kfree(fw_debug);
+	return 0;
+}
+
+static const struct file_operations bfad_debugfs_op_drvtrc = {
+	.owner		=	THIS_MODULE,
+	.open		=	bfad_debugfs_open_drvtrc,
+	.llseek		=	bfad_debugfs_lseek,
+	.read		=	bfad_debugfs_read,
+	.release	=	bfad_debugfs_release,
+};
+
+static const struct file_operations bfad_debugfs_op_fwtrc = {
+	.owner		=	THIS_MODULE,
+	.open		=	bfad_debugfs_open_fwtrc,
+	.llseek		=	bfad_debugfs_lseek,
+	.read		=	bfad_debugfs_read,
+	.release	=	bfad_debugfs_release_fwtrc,
+};
+
+static const struct file_operations bfad_debugfs_op_fwsave = {
+	.owner		=	THIS_MODULE,
+	.open		=	bfad_debugfs_open_fwsave,
+	.llseek		=	bfad_debugfs_lseek,
+	.read		=	bfad_debugfs_read,
+	.release	=	bfad_debugfs_release_fwtrc,
+};
+
+static const struct file_operations bfad_debugfs_op_regrd = {
+	.owner		=	THIS_MODULE,
+	.open		=	bfad_debugfs_open_reg,
+	.llseek		=	bfad_debugfs_lseek,
+	.read		=	bfad_debugfs_read_regrd,
+	.write		=	bfad_debugfs_write_regrd,
+	.release	=	bfad_debugfs_release,
+};
+
+static const struct file_operations bfad_debugfs_op_regwr = {
+	.owner		=	THIS_MODULE,
+	.open		=	bfad_debugfs_open_reg,
+	.llseek		=	bfad_debugfs_lseek,
+	.write		=	bfad_debugfs_write_regwr,
+	.release	=	bfad_debugfs_release,
+};
+
+struct bfad_debugfs_entry {
+	const char *name;
+	mode_t	mode;
+	const struct file_operations *fops;
+};
+
+static const struct bfad_debugfs_entry bfad_debugfs_files[] = {
+	{ "drvtrc", S_IFREG|S_IRUGO, &bfad_debugfs_op_drvtrc, },
+	{ "fwtrc",  S_IFREG|S_IRUGO, &bfad_debugfs_op_fwtrc,  },
+	{ "fwsave", S_IFREG|S_IRUGO, &bfad_debugfs_op_fwsave, },
+	{ "regrd",  S_IFREG|S_IRUGO|S_IWUSR, &bfad_debugfs_op_regrd,  },
+	{ "regwr",  S_IFREG|S_IWUSR, &bfad_debugfs_op_regwr,  },
+};
+
+static struct dentry *bfa_debugfs_root;
+static atomic_t bfa_debugfs_port_count;
+
+inline void
+bfad_debugfs_init(struct bfad_port_s *port)
+{
+	struct bfad_im_port_s *im_port = port->im_port;
+	struct bfad_s *bfad = im_port->bfad;
+	struct Scsi_Host *shost = im_port->shost;
+	const struct bfad_debugfs_entry *file;
+	char name[16];
+	int i;
+
+	if (!bfa_debugfs_enable)
+		return;
+
+	/* Setup the BFA debugfs root directory*/
+	if (!bfa_debugfs_root) {
+		bfa_debugfs_root = debugfs_create_dir("bfa", NULL);
+		atomic_set(&bfa_debugfs_port_count, 0);
+		if (!bfa_debugfs_root) {
+			printk(KERN_WARNING
+				"BFA debugfs root dir creation failed\n");
+			goto err;
+		}
+	}
+
+	/*
+	 * Setup the host# directory for the port,
+	 * corresponds to the scsi_host num of this port.
+	 */
+	snprintf(name, sizeof(name), "host%d", shost->host_no);
+	if (!port->port_debugfs_root) {
+		port->port_debugfs_root =
+			debugfs_create_dir(name, bfa_debugfs_root);
+		if (!port->port_debugfs_root) {
+			printk(KERN_WARNING
+				"BFA host root dir creation failed\n");
+			goto err;
+		}
+
+		atomic_inc(&bfa_debugfs_port_count);
+
+		for (i = 0; i < ARRAY_SIZE(bfad_debugfs_files); i++) {
+			file = &bfad_debugfs_files[i];
+			bfad->bfad_dentry_files[i] =
+					debugfs_create_file(file->name,
+							file->mode,
+							port->port_debugfs_root,
+							port,
+							file->fops);
+			if (!bfad->bfad_dentry_files[i]) {
+				printk(KERN_WARNING
+					"BFA host%d: create %s entry failed\n",
+					shost->host_no, file->name);
+				goto err;
+			}
+		}
+	}
+
+err:
+	return;
+}
+
+inline void
+bfad_debugfs_exit(struct bfad_port_s *port)
+{
+	struct bfad_im_port_s *im_port = port->im_port;
+	struct bfad_s *bfad = im_port->bfad;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(bfad_debugfs_files); i++) {
+		if (bfad->bfad_dentry_files[i]) {
+			debugfs_remove(bfad->bfad_dentry_files[i]);
+			bfad->bfad_dentry_files[i] = NULL;
+		}
+	}
+
+	/*
+	 * Remove the host# directory for the port,
+	 * corresponds to the scsi_host num of this port.
+	*/
+	if (port->port_debugfs_root) {
+		debugfs_remove(port->port_debugfs_root);
+		port->port_debugfs_root = NULL;
+		atomic_dec(&bfa_debugfs_port_count);
+	}
+
+	/* Remove the BFA debugfs root directory */
+	if (atomic_read(&bfa_debugfs_port_count) == 0) {
+		debugfs_remove(bfa_debugfs_root);
+		bfa_debugfs_root = NULL;
+	}
+}
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index fb6ac1d..465b8b8 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -111,6 +111,9 @@ struct bfad_port_s {
 	struct bfad_im_port_s *im_port;	/* IM specific data */
 	struct bfad_tm_port_s *tm_port;	/* TM specific data */
 	struct bfad_ipfc_port_s *ipfc_port;	/* IPFC specific data */
+
+	/* port debugfs specific data */
+	struct dentry *port_debugfs_root;
 };
 
 /*
@@ -186,6 +189,10 @@ struct bfad_s {
 	struct fc_host_statistics link_stats;
 	struct list_head pbc_pcfg_list;
 	atomic_t wq_reqcnt;
+	/* debugfs specific data */
+	char *regdata;
+	u32 reglen;
+	struct dentry *bfad_dentry_files[5];
 };
 
 struct bfad_pcfg_s {
@@ -276,7 +283,9 @@ void		bfad_drv_uninit(struct bfad_s *bfad);
 void		bfad_drv_log_level_set(struct bfad_s *bfad);
 bfa_status_t	bfad_fc4_module_init(void);
 void		bfad_fc4_module_exit(void);
-int		bfad_worker (void *ptr);
+int		bfad_worker(void *ptr);
+void		bfad_debugfs_init(struct bfad_port_s *port);
+void		bfad_debugfs_exit(struct bfad_port_s *port);
 
 void bfad_pci_remove(struct pci_dev *pdev);
 int bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid);
@@ -289,6 +298,7 @@ extern struct list_head bfad_list;
 extern int bfa_lun_queue_depth;
 extern int bfad_supported_fc4s;
 extern int bfa_linkup_delay;
+extern int bfa_debugfs_enable;
 extern struct mutex bfad_mutex;
 
 #endif /* __BFAD_DRV_H__ */
-- 
1.6.5.2

