From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 2/2] bfa: Add sysfs support to obtain debug info.
Date: Fri, 21 May 2010 14:41:27 -0700
Message-ID: <1274478087-19104-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:33081 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753014Ab0EUVlg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 May 2010 17:41:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, rvadivel@brocade.com, vravindr@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Add sysfs support to obtain firmware trace, driver trace
	  and read/write to registers.

	- Following are the new sysfs attributes added:
		fwtrc: To collect current firmware trace.
		drvtrc: To collect current driver trace
		fwsave: To collect last saved fw trace as a result of firmware crash.
		regwr:  To write one word to chip register
		regrd: To read one or more words from chip register.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfad.c      |   10 +
 drivers/scsi/bfa/bfad_attr.c |  387 +++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/bfa/bfad_drv.h  |    8 +-
 3 files changed, 401 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index d4fc428..cc835e9 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -845,6 +845,13 @@ bfad_cfg_pport(struct bfad_s *bfad, enum bfa_port_role role)
 		if (rc != BFA_STATUS_OK)
 			goto out;
 
+		rc = bfad_sysfs_alloc_attr(bfad);
+
+		if (rc) {
+			printk(KERN_WARNING "bfad_sysfs_alloc_attr failed\n");
+			goto out;
+		}
+
 		bfad->pport.roles |= BFA_PORT_ROLE_FCP_IM;
 	}
 
@@ -864,6 +871,7 @@ bfad_uncfg_pport(struct bfad_s *bfad)
 
 	if ((bfad_supported_fc4s & BFA_PORT_ROLE_FCP_IM)
 	    && (bfad->pport.roles & BFA_PORT_ROLE_FCP_IM)) {
+		bfad_sysfs_remove_attr(bfad);
 		bfad_im_scsi_host_free(bfad, bfad->pport.im_port);
 		bfad_im_port_clean(bfad->pport.im_port);
 		kfree(bfad->pport.im_port);
@@ -1146,6 +1154,8 @@ remove_sysfs:
 	mutex_unlock(&bfad_mutex);
 	bfad_pci_uninit(pdev, bfad);
 
+	if (bfad->fwtrc)
+		vfree(bfad->fwtrc);
 	kfree(bfad->trcmod);
 	kfree(bfad);
 }
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index e477bfb..79baaa6 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -25,9 +25,390 @@
 #include "bfad_trcmod.h"
 #include "bfad_attr.h"
 
-/**
- *  FC_transport_template FC transport template
- */
+static ssize_t
+bfad_sysfs_read_fwtrc(struct kobject *kobj, struct bin_attribute *bin_attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct Scsi_Host *shost = dev_to_shost(container_of(kobj,
+					struct device, kobj));
+	struct bfad_im_port_s *im_port = (struct bfad_im_port_s *)
+					shost->hostdata[0];
+	struct bfad_s *bfad = im_port->bfad;
+
+	if (!bfad->fwtrc)
+		return 0;
+
+	return memory_read_from_buffer(buf, count, &off, bfad->fwtrc,
+			bfad->fwtrc_len);
+}
+
+static ssize_t
+bfad_sysfs_write_fwtrc(struct kobject *kobj, struct bin_attribute *bin_attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct Scsi_Host *shost = dev_to_shost(container_of(kobj,
+					struct device, kobj));
+	struct bfad_im_port_s *im_port = (struct bfad_im_port_s *)
+					 shost->hostdata[0];
+	struct bfad_s *bfad = im_port->bfad;
+	unsigned long flags;
+	int rc;
+
+	bfad->fwtrc_len = sizeof(struct bfa_trc_mod_s);
+	if (!bfad->fwtrc)
+		bfad->fwtrc = vmalloc(bfad->fwtrc_len);
+
+	if (!bfad->fwtrc) {
+		printk(KERN_INFO "bfad]%d]: Failed to allocate fwtrc buffer\n",
+					bfad->inst_no);
+		return count;
+	}
+
+	memset(bfad->fwtrc, 0, bfad->fwtrc_len);
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	rc = bfa_debug_fwtrc(&bfad->bfa, bfad->fwtrc, &bfad->fwtrc_len);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	if (rc != BFA_STATUS_OK) {
+		vfree(bfad->fwtrc);
+		bfad->fwtrc = NULL;
+		printk(KERN_INFO "bfad[%d]: Failed to collect fwtrc\n",
+					bfad->inst_no);
+		return -ENOMEM;
+	}
+
+	return count;
+}
+
+static ssize_t
+bfad_sysfs_read_fwsave(struct kobject *kobj, struct bin_attribute *bin_attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct Scsi_Host *shost = dev_to_shost(container_of(kobj,
+					struct device, kobj));
+	struct bfad_im_port_s *im_port = (struct bfad_im_port_s *)
+					shost->hostdata[0];
+	struct bfad_s *bfad = im_port->bfad;
+
+	if (!bfad->fwtrc)
+		return 0;
+
+	return memory_read_from_buffer(buf, count, &off, bfad->fwtrc,
+			bfad->fwtrc_len);
+}
+
+static ssize_t
+bfad_sysfs_write_fwsave(struct kobject *kobj, struct bin_attribute *bin_attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct Scsi_Host *shost = dev_to_shost(container_of(kobj,
+					struct device, kobj));
+	struct bfad_im_port_s *im_port = (struct bfad_im_port_s *)
+					shost->hostdata[0];
+	struct bfad_s *bfad = im_port->bfad;
+	unsigned long flags;
+	int rc;
+
+	bfad->fwtrc_len = sizeof(struct bfa_trc_mod_s);
+	if (!bfad->fwtrc)
+		bfad->fwtrc = vmalloc(bfad->fwtrc_len);
+
+	if (!bfad->fwtrc) {
+		printk(KERN_INFO "bfad[%d]: Failed to allocate fwtrc buffer\n",
+				bfad->inst_no);
+		return count;
+	}
+
+	memset(bfad->fwtrc, 0, bfad->fwtrc_len);
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	rc = bfa_debug_fwsave(&bfad->bfa, bfad->fwtrc, &bfad->fwtrc_len);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	if (rc != BFA_STATUS_OK) {
+		vfree(bfad->fwtrc);
+		bfad->fwtrc = NULL;
+		printk(KERN_INFO "bfad[%d]: Failed to collect fwsave\n",
+				bfad->inst_no);
+		return -ENOMEM;
+	}
+
+	return count;
+}
+
+
+static ssize_t
+bfad_sysfs_read_drvtrc(struct kobject *kobj, struct bin_attribute *bin_attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct Scsi_Host *shost = dev_to_shost(container_of(kobj,
+					struct device, kobj));
+	struct bfad_im_port_s *im_port = (struct bfad_im_port_s *)
+					shost->hostdata[0];
+	struct bfad_s *bfad = im_port->bfad;
+
+	return memory_read_from_buffer(buf, count, &off, bfad->trcmod,
+					sizeof(struct bfa_trc_mod_s));
+}
+
+static ssize_t
+bfad_sysfs_read_regrd(struct kobject *kobj, struct bin_attribute *bin_attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct Scsi_Host *shost = dev_to_shost(container_of(kobj,
+					struct device, kobj));
+	struct bfad_im_port_s *im_port = (struct bfad_im_port_s *)
+					shost->hostdata[0];
+	struct bfad_s *bfad = im_port->bfad;
+	ssize_t rc;
+
+	if (!bfad->regdata)
+		return 0;
+
+	rc = memory_read_from_buffer(buf, count, &off, bfad->regdata,
+			bfad->reglen);
+
+	if (off + count >= bfad->reglen) {
+		kfree(bfad->regdata);
+		bfad->regdata = NULL;
+		bfad->reglen = 0;
+	}
+
+	return rc;
+}
+
+#define BFA_REG_CT_ADDRSZ       (0x40000)
+#define BFA_REG_CB_ADDRSZ       (0x20000)
+#define BFA_REG_ADDRSZ(__bfa)   \
+	((bfa_ioc_devid(&(__bfa)->ioc) == BFA_PCI_DEVICE_ID_CT) ?       \
+		BFA_REG_CT_ADDRSZ : BFA_REG_CB_ADDRSZ)
+#define BFA_REG_ADDRMSK(__bfa)  ((uint32_t)(BFA_REG_ADDRSZ(__bfa) - 1))
+
+static bfa_status_t
+bfad_reg_offset_check(struct bfa_s *bfa, u32 offset, u32 len)
+{
+	u8         area;
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
+bfad_sysfs_write_regrd(struct kobject *kobj, struct bin_attribute *bin_attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct Scsi_Host *shost = dev_to_shost(container_of(kobj,
+					struct device, kobj));
+	struct bfad_im_port_s *im_port = (struct bfad_im_port_s *)
+					 shost->hostdata[0];
+	struct bfad_s *bfad = im_port->bfad;
+	unsigned long flags;
+	int rc, i;
+	int addr, len;
+	u32 *regbuf;
+	void __iomem *rb, *reg_addr;
+	struct bfa_s *bfa = &bfad->bfa;
+	struct bfa_ioc_s  *ioc = &bfa->ioc;
+
+	rc = sscanf(buf, "%x:%x", &addr, &len);
+	if (rc < 2) {
+		printk(KERN_INFO
+			"bfad[%d]: sysfs_write_regrd failed to read buf\n",
+			bfad->inst_no);
+		return -EINVAL;
+	}
+
+	if (bfad->regdata) {
+		kfree(bfad->regdata);
+		bfad->regdata = NULL;
+		bfad->reglen = 0;
+	}
+
+	bfad->regdata = kzalloc(len << 2, GFP_KERNEL);
+	if (!bfad->regdata) {
+		printk(KERN_INFO
+			"bfad[%d]: Failed to allocate memory for regdata\n",
+			bfad->inst_no);
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
+	return count;
+}
+
+static ssize_t
+bfad_sysfs_write_regwr(struct kobject *kobj, struct bin_attribute *bin_attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct Scsi_Host *shost = dev_to_shost(container_of(kobj,
+					struct device, kobj));
+	struct bfad_im_port_s *im_port = (struct bfad_im_port_s *)
+					 shost->hostdata[0];
+	struct bfad_s *bfad = im_port->bfad;
+	unsigned long flags;
+	int rc;
+	int addr, val;
+	void __iomem *reg_addr;
+	struct bfa_s *bfa = &bfad->bfa;
+	struct bfa_ioc_s  *ioc = &bfa->ioc;
+
+	rc = sscanf(buf, "%x:%x", &addr, &val);
+	if (rc < 2) {
+		printk(KERN_INFO
+			"bfad[%d]: sysfs_write_regwr failed to read buf\n",
+			bfad->inst_no);
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
+	return count;
+}
+
+static struct bin_attribute sysfs_fwtrc_attr = {
+	.attr = {
+		.name = "fwtrc",
+		.mode = S_IRUSR | S_IWUSR,
+	},
+	.size = 0,
+	.read = bfad_sysfs_read_fwtrc,
+	.write = bfad_sysfs_write_fwtrc,
+};
+
+static struct bin_attribute sysfs_fwsave_attr = {
+	.attr = {
+		.name = "fwsave",
+		.mode = S_IRUSR | S_IWUSR,
+	},
+	.size = 0,
+	.read = bfad_sysfs_read_fwsave,
+	.write = bfad_sysfs_write_fwsave,
+};
+
+static struct bin_attribute sysfs_drvtrc_attr = {
+	.attr = {
+		.name = "drvtrc",
+		.mode = S_IRUSR,
+	},
+	.size = 0,
+	.read = bfad_sysfs_read_drvtrc,
+};
+
+static struct bin_attribute sysfs_regrd_attr = {
+	.attr = {
+		.name = "regrd",
+		.mode = S_IRUSR | S_IWUSR,
+	},
+	.size = 0,
+	.read = bfad_sysfs_read_regrd,
+	.write = bfad_sysfs_write_regrd,
+};
+
+static struct bin_attribute sysfs_regwr_attr = {
+	.attr = {
+		.name = "regwr",
+		.mode = S_IWUSR,
+	},
+	.size = 0,
+	.write = bfad_sysfs_write_regwr,
+};
+
+static struct bin_attribute *bfad_bin_attr[] = {
+	&sysfs_fwtrc_attr,
+	&sysfs_fwsave_attr,
+	&sysfs_drvtrc_attr,
+	&sysfs_regrd_attr,
+	&sysfs_regwr_attr,
+	NULL,
+};
+
+int
+bfad_sysfs_alloc_attr(struct bfad_s *bfad)
+{
+	struct Scsi_Host *shost = bfad->pport.im_port->shost;
+	int i, j, rc;
+
+	for (i = 0; bfad_bin_attr[i]; i++)
+		rc = sysfs_create_bin_file(&shost->shost_gendev.kobj,
+			bfad_bin_attr[i]);
+
+		if (rc) {
+			printk(KERN_INFO
+				"bfad[%d]: Unable to create %s bin attribute\n",
+				bfad->inst_no, bfad_bin_attr[i]->attr.name);
+			goto out;
+	}
+
+	return 0;
+
+out:
+	for (j = 0; j < i; j++)
+		sysfs_remove_bin_file(&shost->shost_gendev.kobj,
+			bfad_bin_attr[j]);
+	return rc;
+}
+
+void
+bfad_sysfs_remove_attr(struct bfad_s *bfad)
+{
+	struct Scsi_Host *shost = bfad->pport.im_port->shost;
+	int i;
+
+	for (i = 0; bfad_bin_attr[i]; i++)
+		sysfs_remove_bin_file(&shost->shost_gendev.kobj,
+			bfad_bin_attr[i]);
+}
 
 /**
  * FC transport template entry, get SCSI target port ID.
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 6c920c1..2797723 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -195,6 +195,10 @@ struct bfad_s {
 	bfa_boolean_t	ipfc_enabled;
 	union bfad_tmp_buf tmp_buf;
 	struct fc_host_statistics link_stats;
+	u32 fwtrc_len;
+	char *fwtrc;
+	u32 reglen;
+	char *regdata;
 };
 
 /*
@@ -280,13 +284,15 @@ void		bfad_drv_uninit(struct bfad_s *bfad);
 void		bfad_drv_log_level_set(struct bfad_s *bfad);
 bfa_status_t	bfad_fc4_module_init(void);
 void		bfad_fc4_module_exit(void);
-int		bfad_worker (void *ptr);
+int		bfad_worker(void *ptr);
 
 void bfad_pci_remove(struct pci_dev *pdev);
 int bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid);
 void bfad_os_rport_online_wait(struct bfad_s *bfad);
 int bfad_os_get_linkup_delay(struct bfad_s *bfad);
 int bfad_install_msix_handler(struct bfad_s *bfad);
+int bfad_sysfs_alloc_attr(struct bfad_s *bfad);
+void bfad_sysfs_remove_attr(struct bfad_s *bfad);
 
 extern struct idr bfad_im_port_index;
 extern struct list_head bfad_list;
-- 
1.7.1.96.gc06ee

