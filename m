From: Anirban Chakraborty <anirban@qlogic.com>
Subject: [PATCH 2/5] qla2xxx: Code Refactoring
Date: Wed, 15 Oct 2008 22:45:49 -0700 (PDT)
Message-ID: <alpine.OSX.1.00.0810152230240.24642@ac-mac.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:41949 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYJPF7f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Oct 2008 01:59:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org
Cc: linux-driver@qlogic.com

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |  298 +++++++++++++-----------
 drivers/scsi/qla2xxx/qla_dbg.c  |   61 +++---
 drivers/scsi/qla2xxx/qla_dfs.c  |   21 +-
 drivers/scsi/qla2xxx/qla_gs.c   |  479 ++++++++++++++++++++-------------------
 4 files changed, 451 insertions(+), 408 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 0ddfe71..4fc4670 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -19,8 +19,9 @@ qla2x00_sysfs_read_fw_dump(struct kobject *kobj,
 			   struct bin_attribute *bin_attr,
 			   char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
+	struct qla_hw_data *ha = vha->hw;
 
 	if (ha->fw_dump_reading == 0)
 		return 0;
@@ -34,8 +35,9 @@ qla2x00_sysfs_write_fw_dump(struct kobject *kobj,
 			    struct bin_attribute *bin_attr,
 			    char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
+	struct qla_hw_data *ha = vha->hw;
 	int reading;
 
 	if (off != 0)
@@ -48,7 +50,7 @@ qla2x00_sysfs_write_fw_dump(struct kobject *kobj,
 			break;
 
 		qla_printk(KERN_INFO, ha,
-		    "Firmware dump cleared on (%ld).\n", ha->host_no);
+		    "Firmware dump cleared on (%ld).\n", vha->host_no);
 
 		ha->fw_dump_reading = 0;
 		ha->fw_dumped = 0;
@@ -59,14 +61,14 @@ qla2x00_sysfs_write_fw_dump(struct kobject *kobj,
 
 			qla_printk(KERN_INFO, ha,
 			    "Raw firmware dump ready for read on (%ld).\n",
-			    ha->host_no);
+			    vha->host_no);
 		}
 		break;
 	case 2:
-		qla2x00_alloc_fw_dump(ha);
+		qla2x00_alloc_fw_dump(vha);
 		break;
 	case 3:
-		qla2x00_system_error(ha);
+		qla2x00_system_error(vha);
 		break;
 	}
 	return (count);
@@ -87,8 +89,9 @@ qla2x00_sysfs_read_nvram(struct kobject *kobj,
 			 struct bin_attribute *bin_attr,
 			 char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
+	struct qla_hw_data *ha = vha->hw;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return 0;
@@ -103,8 +106,9 @@ qla2x00_sysfs_write_nvram(struct kobject *kobj,
 			  struct bin_attribute *bin_attr,
 			  char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
+	struct qla_hw_data *ha = vha->hw;
 	uint16_t	cnt;
 
 	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->nvram_size)
@@ -134,11 +138,11 @@ qla2x00_sysfs_write_nvram(struct kobject *kobj,
 	}
 
 	/* Write NVRAM. */
-	ha->isp_ops->write_nvram(ha, (uint8_t *)buf, ha->nvram_base, count);
-	ha->isp_ops->read_nvram(ha, (uint8_t *)ha->nvram, ha->nvram_base,
+	ha->isp_ops->write_nvram(vha, (uint8_t *)buf, ha->nvram_base, count);
+	ha->isp_ops->read_nvram(vha, (uint8_t *)ha->nvram, ha->nvram_base,
 	    count);
 
-	set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+	set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 
 	return (count);
 }
@@ -158,8 +162,9 @@ qla2x00_sysfs_read_optrom(struct kobject *kobj,
 			  struct bin_attribute *bin_attr,
 			  char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
+	struct qla_hw_data *ha = vha->hw;
 
 	if (ha->optrom_state != QLA_SREADING)
 		return 0;
@@ -173,8 +178,9 @@ qla2x00_sysfs_write_optrom(struct kobject *kobj,
 			   struct bin_attribute *bin_attr,
 			   char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
+	struct qla_hw_data *ha = vha->hw;
 
 	if (ha->optrom_state != QLA_SWRITING)
 		return -EINVAL;
@@ -203,8 +209,10 @@ qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
 			       struct bin_attribute *bin_attr,
 			       char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
+	struct qla_hw_data *ha = vha->hw;
+
 	uint32_t start = 0;
 	uint32_t size = ha->optrom_size;
 	int val, valid;
@@ -262,7 +270,7 @@ qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
 		    ha->optrom_region_start, ha->optrom_region_size));
 
 		memset(ha->optrom_buffer, 0, ha->optrom_region_size);
-		ha->isp_ops->read_optrom(ha, ha->optrom_buffer,
+		ha->isp_ops->read_optrom(vha, ha->optrom_buffer,
 		    ha->optrom_region_start, ha->optrom_region_size);
 		break;
 	case 2:
@@ -333,7 +341,7 @@ qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
 		    "Writing flash region -- 0x%x/0x%x.\n",
 		    ha->optrom_region_start, ha->optrom_region_size));
 
-		ha->isp_ops->write_optrom(ha, ha->optrom_buffer,
+		ha->isp_ops->write_optrom(vha, ha->optrom_buffer,
 		    ha->optrom_region_start, ha->optrom_region_size);
 		break;
 	default:
@@ -356,8 +364,9 @@ qla2x00_sysfs_read_vpd(struct kobject *kobj,
 		       struct bin_attribute *bin_attr,
 		       char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
+	struct qla_hw_data *ha = vha->hw;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return 0;
@@ -371,15 +380,16 @@ qla2x00_sysfs_write_vpd(struct kobject *kobj,
 			struct bin_attribute *bin_attr,
 			char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
+	struct qla_hw_data *ha = vha->hw;
 
 	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->vpd_size)
 		return 0;
 
 	/* Write NVRAM. */
-	ha->isp_ops->write_nvram(ha, (uint8_t *)buf, ha->vpd_base, count);
-	ha->isp_ops->read_nvram(ha, (uint8_t *)ha->vpd, ha->vpd_base, count);
+	ha->isp_ops->write_nvram(vha, (uint8_t *)buf, ha->vpd_base, count);
+	ha->isp_ops->read_nvram(vha, (uint8_t *)ha->vpd, ha->vpd_base, count);
 
 	return count;
 }
@@ -399,8 +409,9 @@ qla2x00_sysfs_read_sfp(struct kobject *kobj,
 		       struct bin_attribute *bin_attr,
 		       char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *ha = shost_priv(dev_to_shost(container_of(kobj,
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
+	struct qla_hw_data *ha = vha->hw;
 	uint16_t iter, addr, offset;
 	int rval;
 
@@ -429,7 +440,7 @@ do_read:
 			offset = 0;
 		}
 
-		rval = qla2x00_read_sfp(ha, ha->sfp_data_dma, addr, offset,
+		rval = qla2x00_read_sfp(vha, ha->sfp_data_dma, addr, offset,
 		    SFP_BLOCK_SIZE);
 		if (rval != QLA_SUCCESS) {
 			qla_printk(KERN_WARNING, ha,
@@ -469,30 +480,31 @@ static struct sysfs_entry {
 };
 
 void
-qla2x00_alloc_sysfs_attr(scsi_qla_host_t *ha)
+qla2x00_alloc_sysfs_attr(scsi_qla_host_t *vha)
 {
-	struct Scsi_Host *host = ha->host;
+	struct Scsi_Host *host = vha->host;
 	struct sysfs_entry *iter;
 	int ret;
 
 	for (iter = bin_file_entries; iter->name; iter++) {
-		if (iter->is4GBp_only && !IS_FWI2_CAPABLE(ha))
+		if (iter->is4GBp_only && !IS_FWI2_CAPABLE(vha->hw))
 			continue;
 
 		ret = sysfs_create_bin_file(&host->shost_gendev.kobj,
 		    iter->attr);
 		if (ret)
-			qla_printk(KERN_INFO, ha,
+			qla_printk(KERN_INFO, vha->hw,
 			    "Unable to create sysfs %s binary attribute "
 			    "(%d).\n", iter->name, ret);
 	}
 }
 
 void
-qla2x00_free_sysfs_attr(scsi_qla_host_t *ha)
+qla2x00_free_sysfs_attr(scsi_qla_host_t *vha)
 {
-	struct Scsi_Host *host = ha->host;
+	struct Scsi_Host *host = vha->host;
 	struct sysfs_entry *iter;
+	struct qla_hw_data *ha = vha->hw;
 
 	for (iter = bin_file_entries; iter->name; iter++) {
 		if (iter->is4GBp_only && !IS_FWI2_CAPABLE(ha))
@@ -503,7 +515,7 @@ qla2x00_free_sysfs_attr(scsi_qla_host_t *ha)
 	}
 
 	if (ha->beacon_blink_led == 1)
-		ha->isp_ops->beacon_off(ha);
+		ha->isp_ops->beacon_off(vha);
 }
 
 /* Scsi_Host attributes. */
@@ -519,22 +531,24 @@ static ssize_t
 qla2x00_fw_version_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
-	char fw_str[30];
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
+	char fw_str[128];
 
 	return snprintf(buf, PAGE_SIZE, "%s\n",
-	    ha->isp_ops->fw_version_str(ha, fw_str));
+	    ha->isp_ops->fw_version_str(vha, fw_str));
 }
 
 static ssize_t
 qla2x00_serial_num_show(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
-	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
 	uint32_t sn;
 
 	if (IS_FWI2_CAPABLE(ha)) {
-		qla2xxx_get_vpd_field(ha, "SN", buf, PAGE_SIZE);
+		qla2xxx_get_vpd_field(vha, "SN", buf, PAGE_SIZE);
 		return snprintf(buf, PAGE_SIZE, "%s\n", buf);
 	}
 
@@ -547,15 +561,16 @@ static ssize_t
 qla2x00_isp_name_show(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
-	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "ISP%04X\n", ha->pdev->device);
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	return snprintf(buf, PAGE_SIZE, "ISP%04X\n", vha->hw->pdev->device);
 }
 
 static ssize_t
 qla2x00_isp_id_show(struct device *dev, struct device_attribute *attr,
 		    char *buf)
 {
-	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
 	return snprintf(buf, PAGE_SIZE, "%04x %04x %04x %04x\n",
 	    ha->product_id[0], ha->product_id[1], ha->product_id[2],
 	    ha->product_id[3]);
@@ -565,43 +580,44 @@ static ssize_t
 qla2x00_model_name_show(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
-	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "%s\n", ha->model_number);
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	return snprintf(buf, PAGE_SIZE, "%s\n", vha->hw->model_number);
 }
 
 static ssize_t
 qla2x00_model_desc_show(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
-	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	return snprintf(buf, PAGE_SIZE, "%s\n",
-	    ha->model_desc ? ha->model_desc: "");
+	    vha->hw->model_desc ? vha->hw->model_desc : "");
 }
 
 static ssize_t
 qla2x00_pci_info_show(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
-	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	char pci_info[30];
 
 	return snprintf(buf, PAGE_SIZE, "%s\n",
-	    ha->isp_ops->pci_info_str(ha, pci_info));
+	    vha->hw->isp_ops->pci_info_str(vha, pci_info));
 }
 
 static ssize_t
 qla2x00_link_state_show(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
-	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
 	int len = 0;
 
-	if (atomic_read(&ha->loop_state) == LOOP_DOWN ||
-	    atomic_read(&ha->loop_state) == LOOP_DEAD)
+	if (atomic_read(&vha->loop_state) == LOOP_DOWN ||
+	    atomic_read(&vha->loop_state) == LOOP_DEAD)
 		len = snprintf(buf, PAGE_SIZE, "Link Down\n");
-	else if (atomic_read(&ha->loop_state) != LOOP_READY ||
-	    test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags) ||
-	    test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags))
+	else if (atomic_read(&vha->loop_state) != LOOP_READY ||
+	    test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
+	    test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags))
 		len = snprintf(buf, PAGE_SIZE, "Unknown Link State\n");
 	else {
 		len = snprintf(buf, PAGE_SIZE, "Link Up - ");
@@ -632,10 +648,10 @@ static ssize_t
 qla2x00_zio_show(struct device *dev, struct device_attribute *attr,
 		 char *buf)
 {
-	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	int len = 0;
 
-	switch (ha->zio_mode) {
+	switch (vha->hw->zio_mode) {
 	case QLA_ZIO_MODE_6:
 		len += snprintf(buf + len, PAGE_SIZE-len, "Mode 6\n");
 		break;
@@ -650,7 +666,8 @@ static ssize_t
 qla2x00_zio_store(struct device *dev, struct device_attribute *attr,
 		  const char *buf, size_t count)
 {
-	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
 	int val = 0;
 	uint16_t zio_mode;
 
@@ -668,7 +685,7 @@ qla2x00_zio_store(struct device *dev, struct device_attribute *attr,
 	/* Update per-hba values and queue a reset. */
 	if (zio_mode != QLA_ZIO_DISABLED || ha->zio_mode != QLA_ZIO_DISABLED) {
 		ha->zio_mode = zio_mode;
-		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 	}
 	return strlen(buf);
 }
@@ -677,16 +694,16 @@ static ssize_t
 qla2x00_zio_timer_show(struct device *dev, struct device_attribute *attr,
 		       char *buf)
 {
-	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 
-	return snprintf(buf, PAGE_SIZE, "%d us\n", ha->zio_timer * 100);
+	return snprintf(buf, PAGE_SIZE, "%d us\n", vha->hw->zio_timer * 100);
 }
 
 static ssize_t
 qla2x00_zio_timer_store(struct device *dev, struct device_attribute *attr,
 			const char *buf, size_t count)
 {
-	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	int val = 0;
 	uint16_t zio_timer;
 
@@ -696,7 +713,7 @@ qla2x00_zio_timer_store(struct device *dev, struct device_attribute *attr,
 		return -ERANGE;
 
 	zio_timer = (uint16_t)(val / 100);
-	ha->zio_timer = zio_timer;
+	vha->hw->zio_timer = zio_timer;
 
 	return strlen(buf);
 }
@@ -705,10 +722,10 @@ static ssize_t
 qla2x00_beacon_show(struct device *dev, struct device_attribute *attr,
 		    char *buf)
 {
-	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	int len = 0;
 
-	if (ha->beacon_blink_led)
+	if (vha->hw->beacon_blink_led)
 		len += snprintf(buf + len, PAGE_SIZE-len, "Enabled\n");
 	else
 		len += snprintf(buf + len, PAGE_SIZE-len, "Disabled\n");
@@ -719,14 +736,15 @@ static ssize_t
 qla2x00_beacon_store(struct device *dev, struct device_attribute *attr,
 		     const char *buf, size_t count)
 {
-	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
 	int val = 0;
 	int rval;
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha))
 		return -EPERM;
 
-	if (test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags)) {
+	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags)) {
 		qla_printk(KERN_WARNING, ha,
 		    "Abort ISP active -- ignoring beacon request.\n");
 		return -EBUSY;
@@ -736,9 +754,9 @@ qla2x00_beacon_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	if (val)
-		rval = ha->isp_ops->beacon_on(ha);
+		rval = ha->isp_ops->beacon_on(vha);
 	else
-		rval = ha->isp_ops->beacon_off(ha);
+		rval = ha->isp_ops->beacon_off(vha);
 
 	if (rval != QLA_SUCCESS)
 		count = 0;
@@ -750,8 +768,8 @@ static ssize_t
 qla2x00_optrom_bios_version_show(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
-	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
-
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
 	return snprintf(buf, PAGE_SIZE, "%d.%02d\n", ha->bios_revision[1],
 	    ha->bios_revision[0]);
 }
@@ -760,8 +778,8 @@ static ssize_t
 qla2x00_optrom_efi_version_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
-
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
 	return snprintf(buf, PAGE_SIZE, "%d.%02d\n", ha->efi_revision[1],
 	    ha->efi_revision[0]);
 }
@@ -770,8 +788,8 @@ static ssize_t
 qla2x00_optrom_fcode_version_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
-	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
-
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
 	return snprintf(buf, PAGE_SIZE, "%d.%02d\n", ha->fcode_revision[1],
 	    ha->fcode_revision[0]);
 }
@@ -780,8 +798,8 @@ static ssize_t
 qla2x00_optrom_fw_version_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
 {
-	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
-
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
 	return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d %d\n",
 	    ha->fw_revision[0], ha->fw_revision[1], ha->fw_revision[2],
 	    ha->fw_revision[3]);
@@ -791,8 +809,8 @@ static ssize_t
 qla2x00_total_isp_aborts_show(struct device *dev,
 			      struct device_attribute *attr, char *buf)
 {
-	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
-
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 	    ha->qla_stats.total_isp_aborts);
 }
@@ -848,16 +866,17 @@ struct device_attribute *qla2x00_host_attrs[] = {
 static void
 qla2x00_get_host_port_id(struct Scsi_Host *shost)
 {
-	scsi_qla_host_t *ha = shost_priv(shost);
+	scsi_qla_host_t *vha = shost_priv(shost);
 
-	fc_host_port_id(shost) = ha->d_id.b.domain << 16 |
-	    ha->d_id.b.area << 8 | ha->d_id.b.al_pa;
+	fc_host_port_id(shost) = vha->d_id.b.domain << 16 |
+	    vha->d_id.b.area << 8 | vha->d_id.b.al_pa;
 }
 
 static void
 qla2x00_get_host_speed(struct Scsi_Host *shost)
 {
-	scsi_qla_host_t *ha = to_qla_parent(shost_priv(shost));
+	struct qla_hw_data *ha = ((struct scsi_qla_host *)
+					(shost_priv(shost)))->hw;
 	u32 speed = FC_PORTSPEED_UNKNOWN;
 
 	switch (ha->link_data_rate) {
@@ -880,14 +899,14 @@ qla2x00_get_host_speed(struct Scsi_Host *shost)
 static void
 qla2x00_get_host_port_type(struct Scsi_Host *shost)
 {
-	scsi_qla_host_t *ha = shost_priv(shost);
+	scsi_qla_host_t *vha = shost_priv(shost);
 	uint32_t port_type = FC_PORTTYPE_UNKNOWN;
 
-	if (ha->parent) {
+	if (vha->vp_idx) {
 		fc_host_port_type(shost) = FC_PORTTYPE_NPIV;
 		return;
 	}
-	switch (ha->current_topology) {
+	switch (vha->hw->current_topology) {
 	case ISP_CFG_NL:
 		port_type = FC_PORTTYPE_LPORT;
 		break;
@@ -908,11 +927,11 @@ static void
 qla2x00_get_starget_node_name(struct scsi_target *starget)
 {
 	struct Scsi_Host *host = dev_to_shost(starget->dev.parent);
-	scsi_qla_host_t *ha = shost_priv(host);
+	scsi_qla_host_t *vha = shost_priv(host);
 	fc_port_t *fcport;
 	u64 node_name = 0;
 
-	list_for_each_entry(fcport, &ha->fcports, list) {
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
 		if (fcport->rport &&
 		    starget->id == fcport->rport->scsi_target_id) {
 			node_name = wwn_to_u64(fcport->node_name);
@@ -927,11 +946,11 @@ static void
 qla2x00_get_starget_port_name(struct scsi_target *starget)
 {
 	struct Scsi_Host *host = dev_to_shost(starget->dev.parent);
-	scsi_qla_host_t *ha = shost_priv(host);
+	scsi_qla_host_t *vha = shost_priv(host);
 	fc_port_t *fcport;
 	u64 port_name = 0;
 
-	list_for_each_entry(fcport, &ha->fcports, list) {
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
 		if (fcport->rport &&
 		    starget->id == fcport->rport->scsi_target_id) {
 			port_name = wwn_to_u64(fcport->port_name);
@@ -946,11 +965,11 @@ static void
 qla2x00_get_starget_port_id(struct scsi_target *starget)
 {
 	struct Scsi_Host *host = dev_to_shost(starget->dev.parent);
-	scsi_qla_host_t *ha = shost_priv(host);
+	scsi_qla_host_t *vha = shost_priv(host);
 	fc_port_t *fcport;
 	uint32_t port_id = ~0U;
 
-	list_for_each_entry(fcport, &ha->fcports, list) {
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
 		if (fcport->rport &&
 		    starget->id == fcport->rport->scsi_target_id) {
 			port_id = fcport->d_id.b.domain << 16 |
@@ -999,9 +1018,9 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 	 * final cleanup of firmware resources (PCBs and XCBs).
 	 */
 	if (fcport->loop_id != FC_NO_LOOP_ID) {
-		fcport->ha->isp_ops->fabric_logout(fcport->ha, fcport->loop_id,
-		    fcport->d_id.b.domain, fcport->d_id.b.area,
-		    fcport->d_id.b.al_pa);
+		fcport->vha->hw->isp_ops->fabric_logout(fcport->vha,
+			fcport->loop_id, fcport->d_id.b.domain,
+			fcport->d_id.b.area, fcport->d_id.b.al_pa);
 		fcport->loop_id = FC_NO_LOOP_ID;
 	}
 
@@ -1012,16 +1031,18 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 static int
 qla2x00_issue_lip(struct Scsi_Host *shost)
 {
-	scsi_qla_host_t *ha = shost_priv(shost);
+	scsi_qla_host_t *vha = shost_priv(shost);
 
-	qla2x00_loop_reset(ha);
+	qla2x00_loop_reset(vha);
 	return 0;
 }
 
 static struct fc_host_statistics *
 qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 {
-	scsi_qla_host_t *ha = to_qla_parent(shost_priv(shost));
+	scsi_qla_host_t *vha = shost_priv(shost);
+	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 	int rval;
 	struct link_statistics *stats;
 	dma_addr_t stats_dma;
@@ -1033,21 +1054,21 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 	stats = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &stats_dma);
 	if (stats == NULL) {
 		DEBUG2_3_11(printk("%s(%ld): Failed to allocate memory.\n",
-		    __func__, ha->host_no));
+		    __func__, base_vha->host_no));
 		goto done;
 	}
 	memset(stats, 0, DMA_POOL_SIZE);
 
 	rval = QLA_FUNCTION_FAILED;
 	if (IS_FWI2_CAPABLE(ha)) {
-		rval = qla24xx_get_isp_stats(ha, stats, stats_dma);
-	} else if (atomic_read(&ha->loop_state) == LOOP_READY &&
-		    !test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags) &&
-		    !test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) &&
+		rval = qla24xx_get_isp_stats(base_vha, stats, stats_dma);
+	} else if (atomic_read(&base_vha->loop_state) == LOOP_READY &&
+		    !test_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags) &&
+		    !test_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags) &&
 		    !ha->dpc_active) {
 		/* Must be in a 'READY' state for statistics retrieval. */
-		rval = qla2x00_get_link_status(ha, ha->loop_id, stats,
-		    stats_dma);
+		rval = qla2x00_get_link_status(base_vha, base_vha->loop_id,
+						stats, stats_dma);
 	}
 
 	if (rval != QLA_SUCCESS)
@@ -1078,29 +1099,29 @@ done:
 static void
 qla2x00_get_host_symbolic_name(struct Scsi_Host *shost)
 {
-	scsi_qla_host_t *ha = shost_priv(shost);
+	scsi_qla_host_t *vha = shost_priv(shost);
 
-	qla2x00_get_sym_node_name(ha, fc_host_symbolic_name(shost));
+	qla2x00_get_sym_node_name(vha, fc_host_symbolic_name(shost));
 }
 
 static void
 qla2x00_set_host_system_hostname(struct Scsi_Host *shost)
 {
-	scsi_qla_host_t *ha = shost_priv(shost);
+	scsi_qla_host_t *vha = shost_priv(shost);
 
-	set_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags);
+	set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
 }
 
 static void
 qla2x00_get_host_fabric_name(struct Scsi_Host *shost)
 {
-	scsi_qla_host_t *ha = shost_priv(shost);
+	scsi_qla_host_t *vha = shost_priv(shost);
 	u64 node_name;
 
-	if (ha->device_flags & SWITCH_FOUND)
-		node_name = wwn_to_u64(ha->fabric_node_name);
+	if (vha->device_flags & SWITCH_FOUND)
+		node_name = wwn_to_u64(vha->fabric_node_name);
 	else
-		node_name = wwn_to_u64(ha->node_name);
+		node_name = wwn_to_u64(vha->node_name);
 
 	fc_host_fabric_name(shost) = node_name;
 }
@@ -1108,11 +1129,12 @@ qla2x00_get_host_fabric_name(struct Scsi_Host *shost)
 static void
 qla2x00_get_host_port_state(struct Scsi_Host *shost)
 {
-	scsi_qla_host_t *ha = to_qla_parent(shost_priv(shost));
+	scsi_qla_host_t *vha = shost_priv(shost);
+	struct scsi_qla_host *base_vha = pci_get_drvdata(vha->hw->pdev);
 
-	if (!ha->flags.online)
+	if (!base_vha->flags.online)
 		fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
-	else if (atomic_read(&ha->loop_state) == LOOP_TIMEOUT)
+	else if (atomic_read(&base_vha->loop_state) == LOOP_TIMEOUT)
 		fc_host_port_state(shost) = FC_PORTSTATE_UNKNOWN;
 	else
 		fc_host_port_state(shost) = FC_PORTSTATE_ONLINE;
@@ -1122,8 +1144,8 @@ static int
 qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 {
 	int	ret = 0;
-	scsi_qla_host_t *ha = shost_priv(fc_vport->shost);
-	scsi_qla_host_t *vha;
+	scsi_qla_host_t *base_vha = shost_priv(fc_vport->shost);
+	scsi_qla_host_t *vha = NULL;
 
 	ret = qla24xx_vport_create_req_sanity_check(fc_vport);
 	if (ret) {
@@ -1145,18 +1167,19 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 		atomic_set(&vha->vp_state, VP_FAILED);
 
 	/* ready to create vport */
-	qla_printk(KERN_INFO, vha, "VP entry id %d assigned.\n", vha->vp_idx);
+	qla_printk(KERN_INFO, vha->hw, "VP entry id %d assigned.\n",
+							vha->vp_idx);
 
 	/* initialized vport states */
 	atomic_set(&vha->loop_state, LOOP_DOWN);
 	vha->vp_err_state=  VP_ERR_PORTDWN;
 	vha->vp_prev_err_state=  VP_ERR_UNKWN;
 	/* Check if physical ha port is Up */
-	if (atomic_read(&ha->loop_state) == LOOP_DOWN ||
-	    atomic_read(&ha->loop_state) == LOOP_DEAD) {
+	if (atomic_read(&base_vha->loop_state) == LOOP_DOWN ||
+	    atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
 		/* Don't retry or attempt login of this virtual port */
 		DEBUG15(printk ("scsi(%ld): pport loop_state is not UP.\n",
-		    vha->host_no));
+		    base_vha->host_no));
 		atomic_set(&vha->loop_state, LOOP_DEAD);
 		if (!disable)
 			fc_vport_set_state(fc_vport, FC_VPORT_LINKDOWN);
@@ -1172,9 +1195,9 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 	fc_host_node_name(vha->host) = wwn_to_u64(vha->node_name);
 	fc_host_port_name(vha->host) = wwn_to_u64(vha->port_name);
 	fc_host_supported_classes(vha->host) =
-		fc_host_supported_classes(ha->host);
+		fc_host_supported_classes(base_vha->host);
 	fc_host_supported_speeds(vha->host) =
-		fc_host_supported_speeds(ha->host);
+		fc_host_supported_speeds(base_vha->host);
 
 	qla24xx_vport_disable(fc_vport, disable);
 
@@ -1182,8 +1205,6 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 vport_create_failed_2:
 	qla24xx_disable_vp(vha);
 	qla24xx_deallocate_vp_id(vha);
-	kfree(vha->port_name);
-	kfree(vha->node_name);
 	scsi_host_put(vha->host);
 	return FC_VPORT_FAILED;
 }
@@ -1192,17 +1213,25 @@ static int
 qla24xx_vport_delete(struct fc_vport *fc_vport)
 {
 	scsi_qla_host_t *vha = fc_vport->dd_data;
-	scsi_qla_host_t *pha = to_qla_parent(vha);
+	fc_port_t *fcport, *tfcport;
 
 	while (test_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags) ||
-	    test_bit(FCPORT_UPDATE_NEEDED, &pha->dpc_flags))
+	    test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags))
 		msleep(1000);
 
 	qla24xx_disable_vp(vha);
-	qla24xx_deallocate_vp_id(vha);
 
-	kfree(vha->node_name);
-	kfree(vha->port_name);
+	fc_remove_host(vha->host);
+
+	scsi_remove_host(vha->host);
+
+	list_for_each_entry_safe(fcport, tfcport, &vha->vp_fcports, list) {
+		list_del(&fcport->list);
+		kfree(fcport);
+		fcport = NULL;
+	}
+
+	qla24xx_deallocate_vp_id(vha);
 
 	if (vha->timer_active) {
 		qla2x00_vp_stop_timer(vha);
@@ -1211,10 +1240,6 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 		    vha->host_no, vha->vp_idx, vha));
         }
 
-	fc_remove_host(vha->host);
-
-	scsi_remove_host(vha->host);
-
 	scsi_host_put(vha->host);
 
 	return 0;
@@ -1319,15 +1344,16 @@ struct fc_function_template qla2xxx_transport_vport_functions = {
 };
 
 void
-qla2x00_init_host_attr(scsi_qla_host_t *ha)
+qla2x00_init_host_attr(scsi_qla_host_t *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	u32 speed = FC_PORTSPEED_UNKNOWN;
 
-	fc_host_node_name(ha->host) = wwn_to_u64(ha->node_name);
-	fc_host_port_name(ha->host) = wwn_to_u64(ha->port_name);
-	fc_host_supported_classes(ha->host) = FC_COS_CLASS3;
-	fc_host_max_npiv_vports(ha->host) = ha->max_npiv_vports;;
-	fc_host_npiv_vports_inuse(ha->host) = ha->cur_vport_count;
+	fc_host_node_name(vha->host) = wwn_to_u64(vha->node_name);
+	fc_host_port_name(vha->host) = wwn_to_u64(vha->port_name);
+	fc_host_supported_classes(vha->host) = FC_COS_CLASS3;
+	fc_host_max_npiv_vports(vha->host) = ha->max_npiv_vports;
+	fc_host_npiv_vports_inuse(vha->host) = ha->cur_vport_count;
 
 	if (IS_QLA25XX(ha))
 		speed = FC_PORTSPEED_8GBIT | FC_PORTSPEED_4GBIT |
@@ -1339,5 +1365,5 @@ qla2x00_init_host_attr(scsi_qla_host_t *ha)
 		speed = FC_PORTSPEED_2GBIT | FC_PORTSPEED_1GBIT;
 	else
 		speed = FC_PORTSPEED_1GBIT;
-	fc_host_supported_speeds(ha->host) = speed;
+	fc_host_supported_speeds(vha->host) = speed;
 }
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 510ba64..f15f903 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -9,7 +9,7 @@
 #include <linux/delay.h>
 
 static inline void
-qla2xxx_prep_dump(scsi_qla_host_t *ha, struct qla2xxx_fw_dump *fw_dump)
+qla2xxx_prep_dump(struct qla_hw_data *ha, struct qla2xxx_fw_dump *fw_dump)
 {
 	fw_dump->fw_major_version = htonl(ha->fw_major_version);
 	fw_dump->fw_minor_version = htonl(ha->fw_minor_version);
@@ -23,22 +23,25 @@ qla2xxx_prep_dump(scsi_qla_host_t *ha, struct qla2xxx_fw_dump *fw_dump)
 }
 
 static inline void *
-qla2xxx_copy_queues(scsi_qla_host_t *ha, void *ptr)
+qla2xxx_copy_queues(scsi_qla_host_t *vha, void *ptr)
 {
+	struct req_que *req = vha->hw->req;
+	struct rsp_que *rsp = vha->hw->rsp;
+
 	/* Request queue. */
-	memcpy(ptr, ha->request_ring, ha->request_q_length *
+	memcpy(ptr, req->ring, req->length *
 	    sizeof(request_t));
 
 	/* Response queue. */
-	ptr += ha->request_q_length * sizeof(request_t);
-	memcpy(ptr, ha->response_ring, ha->response_q_length  *
+	ptr += req->length * sizeof(request_t);
+	memcpy(ptr, rsp->ring, rsp->length  *
 	    sizeof(response_t));
 
-	return ptr + (ha->response_q_length * sizeof(response_t));
+	return ptr + (rsp->length * sizeof(response_t));
 }
 
 static int
-qla24xx_dump_ram(scsi_qla_host_t *ha, uint32_t addr, uint32_t *ram,
+qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, uint32_t *ram,
     uint32_t ram_dwords, void **nxt)
 {
 	int rval;
@@ -112,7 +115,7 @@ qla24xx_dump_ram(scsi_qla_host_t *ha, uint32_t addr, uint32_t *ram,
 }
 
 static int
-qla24xx_dump_memory(scsi_qla_host_t *ha, uint32_t *code_ram,
+qla24xx_dump_memory(struct qla_hw_data *ha, uint32_t *code_ram,
     uint32_t cram_size, void **nxt)
 {
 	int rval;
@@ -163,7 +166,7 @@ qla24xx_pause_risc(struct device_reg_24xx __iomem *reg)
 }
 
 static int
-qla24xx_soft_reset(scsi_qla_host_t *ha)
+qla24xx_soft_reset(struct qla_hw_data *ha)
 {
 	int rval = QLA_SUCCESS;
 	uint32_t cnt;
@@ -215,8 +218,8 @@ qla24xx_soft_reset(scsi_qla_host_t *ha)
 }
 
 static int
-qla2xxx_dump_ram(scsi_qla_host_t *ha, uint32_t addr, uint16_t *ram,
-    uint32_t ram_words, void **nxt)
+qla2xxx_dump_ram(struct qla_hw_data *ha, uint32_t addr, uint16_t *ram,
+    uint16_t ram_words, void **nxt)
 {
 	int rval;
 	uint32_t cnt, stat, timer, words, idx;
@@ -314,11 +317,11 @@ qla2xxx_read_window(struct device_reg_2xxx __iomem *reg, uint32_t count,
  * @hardware_locked: Called with the hardware_lock
  */
 void
-qla2300_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
+qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 {
 	int		rval;
 	uint32_t	cnt;
-
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint16_t __iomem *dmp_reg;
 	unsigned long	flags;
@@ -458,7 +461,7 @@ qla2300_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 		    ha->fw_memory_size - 0x11000 + 1, &nxt);
 
 	if (rval == QLA_SUCCESS)
-		qla2xxx_copy_queues(ha, nxt);
+		qla2xxx_copy_queues(vha, nxt);
 
 	if (rval != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
@@ -468,7 +471,7 @@ qla2300_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 	} else {
 		qla_printk(KERN_INFO, ha,
 		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    ha->host_no, ha->fw_dump);
+		    vha->host_no, ha->fw_dump);
 		ha->fw_dumped = 1;
 	}
 
@@ -483,12 +486,13 @@ qla2300_fw_dump_failed:
  * @hardware_locked: Called with the hardware_lock
  */
 void
-qla2100_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
+qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 {
 	int		rval;
 	uint32_t	cnt, timer;
 	uint16_t	risc_address;
 	uint16_t	mb0, mb2;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint16_t __iomem *dmp_reg;
 	unsigned long	flags;
@@ -663,7 +667,7 @@ qla2100_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 	}
 
 	if (rval == QLA_SUCCESS)
-		qla2xxx_copy_queues(ha, &fw->risc_ram[cnt]);
+		qla2xxx_copy_queues(vha, &fw->risc_ram[cnt]);
 
 	if (rval != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
@@ -673,7 +677,7 @@ qla2100_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 	} else {
 		qla_printk(KERN_INFO, ha,
 		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    ha->host_no, ha->fw_dump);
+		    vha->host_no, ha->fw_dump);
 		ha->fw_dumped = 1;
 	}
 
@@ -683,12 +687,12 @@ qla2100_fw_dump_failed:
 }
 
 void
-qla24xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
+qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 {
 	int		rval;
 	uint32_t	cnt;
 	uint32_t	risc_address;
-
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t __iomem *dmp_reg;
 	uint32_t	*iter_reg;
@@ -906,7 +910,7 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 	if (rval != QLA_SUCCESS)
 		goto qla24xx_fw_dump_failed_0;
 
-	nxt = qla2xxx_copy_queues(ha, nxt);
+	nxt = qla2xxx_copy_queues(vha, nxt);
 	if (ha->eft)
 		memcpy(nxt, ha->eft, ntohl(ha->fw_dump->eft_size));
 
@@ -919,7 +923,7 @@ qla24xx_fw_dump_failed_0:
 	} else {
 		qla_printk(KERN_INFO, ha,
 		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    ha->host_no, ha->fw_dump);
+		    vha->host_no, ha->fw_dump);
 		ha->fw_dumped = 1;
 	}
 
@@ -929,12 +933,12 @@ qla24xx_fw_dump_failed:
 }
 
 void
-qla25xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
+qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 {
 	int		rval;
 	uint32_t	cnt;
 	uint32_t	risc_address;
-
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t __iomem *dmp_reg;
 	uint32_t	*iter_reg;
@@ -1215,7 +1219,7 @@ qla25xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 		goto qla25xx_fw_dump_failed_0;
 
 	/* Fibre Channel Trace Buffer. */
-	nxt = qla2xxx_copy_queues(ha, nxt);
+	nxt = qla2xxx_copy_queues(vha, nxt);
 	if (ha->eft)
 		memcpy(nxt, ha->eft, ntohl(ha->fw_dump->eft_size));
 
@@ -1248,7 +1252,7 @@ qla25xx_fw_dump_failed_0:
 	} else {
 		qla_printk(KERN_INFO, ha,
 		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    ha->host_no, ha->fw_dump);
+		    vha->host_no, ha->fw_dump);
 		ha->fw_dumped = 1;
 	}
 
@@ -1262,9 +1266,10 @@ qla25xx_fw_dump_failed:
 /****************************************************************************/
 
 void
-qla2x00_dump_regs(scsi_qla_host_t *ha)
+qla2x00_dump_regs(scsi_qla_host_t *vha)
 {
 	int i;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	struct device_reg_24xx __iomem *reg24 = &ha->iobase->isp24;
 	uint16_t __iomem *mbx_reg;
@@ -1274,7 +1279,7 @@ qla2x00_dump_regs(scsi_qla_host_t *ha)
 
 	printk("Mailbox registers:\n");
 	for (i = 0; i < 6; i++)
-		printk("scsi(%ld): mbox %d 0x%04x \n", ha->host_no, i,
+		printk("scsi(%ld): mbox %d 0x%04x \n", vha->host_no, i,
 		    RD_REG_WORD(mbx_reg++));
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 561a441..0e366a1 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -15,10 +15,11 @@ static atomic_t qla2x00_dfs_root_count;
 static int
 qla2x00_dfs_fce_show(struct seq_file *s, void *unused)
 {
-	scsi_qla_host_t *ha = s->private;
+	scsi_qla_host_t *vha = s->private;
 	uint32_t cnt;
 	uint32_t *fce;
 	uint64_t fce_start;
+	struct qla_hw_data *ha = vha->hw;
 
 	mutex_lock(&ha->fce_mutex);
 
@@ -51,7 +52,8 @@ qla2x00_dfs_fce_show(struct seq_file *s, void *unused)
 static int
 qla2x00_dfs_fce_open(struct inode *inode, struct file *file)
 {
-	scsi_qla_host_t *ha = inode->i_private;
+	scsi_qla_host_t *vha = inode->i_private;
+	struct qla_hw_data *ha = vha->hw;
 	int rval;
 
 	if (!ha->flags.fce_enabled)
@@ -60,7 +62,7 @@ qla2x00_dfs_fce_open(struct inode *inode, struct file *file)
 	mutex_lock(&ha->fce_mutex);
 
 	/* Pause tracing to flush FCE buffers. */
-	rval = qla2x00_disable_fce_trace(ha, &ha->fce_wr, &ha->fce_rd);
+	rval = qla2x00_disable_fce_trace(vha, &ha->fce_wr, &ha->fce_rd);
 	if (rval)
 		qla_printk(KERN_WARNING, ha,
 		    "DebugFS: Unable to disable FCE (%d).\n", rval);
@@ -75,7 +77,8 @@ out:
 static int
 qla2x00_dfs_fce_release(struct inode *inode, struct file *file)
 {
-	scsi_qla_host_t *ha = inode->i_private;
+	scsi_qla_host_t *vha = inode->i_private;
+	struct qla_hw_data *ha = vha->hw;
 	int rval;
 
 	if (ha->flags.fce_enabled)
@@ -86,7 +89,7 @@ qla2x00_dfs_fce_release(struct inode *inode, struct file *file)
 	/* Re-enable FCE tracing. */
 	ha->flags.fce_enabled = 1;
 	memset(ha->fce, 0, fce_calc_size(ha->fce_bufs));
-	rval = qla2x00_enable_fce_trace(ha, ha->fce_dma, ha->fce_bufs,
+	rval = qla2x00_enable_fce_trace(vha, ha->fce_dma, ha->fce_bufs,
 	    ha->fce_mb, &ha->fce_bufs);
 	if (rval) {
 		qla_printk(KERN_WARNING, ha,
@@ -107,8 +110,9 @@ static const struct file_operations dfs_fce_ops = {
 };
 
 int
-qla2x00_dfs_setup(scsi_qla_host_t *ha)
+qla2x00_dfs_setup(scsi_qla_host_t *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	if (!IS_QLA25XX(ha))
 		goto out;
 	if (!ha->fce)
@@ -130,7 +134,7 @@ create_dir:
 		goto create_nodes;
 
 	mutex_init(&ha->fce_mutex);
-	ha->dfs_dir = debugfs_create_dir(ha->host_str, qla2x00_dfs_root);
+	ha->dfs_dir = debugfs_create_dir(vha->host_str, qla2x00_dfs_root);
 	if (!ha->dfs_dir) {
 		qla_printk(KERN_NOTICE, ha,
 		    "DebugFS: Unable to create ha directory.\n");
@@ -152,8 +156,9 @@ out:
 }
 
 int
-qla2x00_dfs_remove(scsi_qla_host_t *ha)
+qla2x00_dfs_remove(scsi_qla_host_t *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	if (ha->dfs_fce) {
 		debugfs_remove(ha->dfs_fce);
 		ha->dfs_fce = NULL;
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index c2a4bfb..db8de06 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -22,8 +22,9 @@ static int qla2x00_sns_rnn_id(scsi_qla_host_t *);
  * Returns a pointer to the @ha's ms_iocb.
  */
 void *
-qla2x00_prep_ms_iocb(scsi_qla_host_t *ha, uint32_t req_size, uint32_t rsp_size)
+qla2x00_prep_ms_iocb(scsi_qla_host_t *vha, uint32_t req_size, uint32_t rsp_size)
 {
+	struct qla_hw_data *ha = vha->hw;
 	ms_iocb_entry_t *ms_pkt;
 
 	ms_pkt = ha->ms_iocb;
@@ -59,8 +60,9 @@ qla2x00_prep_ms_iocb(scsi_qla_host_t *ha, uint32_t req_size, uint32_t rsp_size)
  * Returns a pointer to the @ha's ms_iocb.
  */
 void *
-qla24xx_prep_ms_iocb(scsi_qla_host_t *ha, uint32_t req_size, uint32_t rsp_size)
+qla24xx_prep_ms_iocb(scsi_qla_host_t *vha, uint32_t req_size, uint32_t rsp_size)
 {
+	struct qla_hw_data *ha = vha->hw;
 	struct ct_entry_24xx *ct_pkt;
 
 	ct_pkt = (struct ct_entry_24xx *)ha->ms_iocb;
@@ -82,7 +84,7 @@ qla24xx_prep_ms_iocb(scsi_qla_host_t *ha, uint32_t req_size, uint32_t rsp_size)
 	ct_pkt->dseg_1_address[0] = cpu_to_le32(LSD(ha->ct_sns_dma));
 	ct_pkt->dseg_1_address[1] = cpu_to_le32(MSD(ha->ct_sns_dma));
 	ct_pkt->dseg_1_len = ct_pkt->rsp_byte_count;
-	ct_pkt->vp_index = ha->vp_idx;
+	ct_pkt->vp_index = vha->vp_idx;
 
 	return (ct_pkt);
 }
@@ -110,16 +112,17 @@ qla2x00_prep_ct_req(struct ct_sns_req *ct_req, uint16_t cmd, uint16_t rsp_size)
 }
 
 static int
-qla2x00_chk_ms_status(scsi_qla_host_t *ha, ms_iocb_entry_t *ms_pkt,
+qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
     struct ct_sns_rsp *ct_rsp, const char *routine)
 {
 	int rval;
 	uint16_t comp_status;
+	struct qla_hw_data *ha = vha->hw;
 
 	rval = QLA_FUNCTION_FAILED;
 	if (ms_pkt->entry_status != 0) {
 		DEBUG2_3(printk("scsi(%ld): %s failed, error status (%x).\n",
-		    ha->host_no, routine, ms_pkt->entry_status));
+		    vha->host_no, routine, ms_pkt->entry_status));
 	} else {
 		if (IS_FWI2_CAPABLE(ha))
 			comp_status = le16_to_cpu(
@@ -133,7 +136,7 @@ qla2x00_chk_ms_status(scsi_qla_host_t *ha, ms_iocb_entry_t *ms_pkt,
 			if (ct_rsp->header.response !=
 			    __constant_cpu_to_be16(CT_ACCEPT_RESPONSE)) {
 				DEBUG2_3(printk("scsi(%ld): %s failed, "
-				    "rejected request:\n", ha->host_no,
+				    "rejected request:\n", vha->host_no,
 				    routine));
 				DEBUG2_3(qla2x00_dump_buffer(
 				    (uint8_t *)&ct_rsp->header,
@@ -144,7 +147,7 @@ qla2x00_chk_ms_status(scsi_qla_host_t *ha, ms_iocb_entry_t *ms_pkt,
 			break;
 		default:
 			DEBUG2_3(printk("scsi(%ld): %s failed, completion "
-			    "status (%x).\n", ha->host_no, routine,
+			    "status (%x).\n", vha->host_no, routine,
 			    comp_status));
 			break;
 		}
@@ -160,21 +163,21 @@ qla2x00_chk_ms_status(scsi_qla_host_t *ha, ms_iocb_entry_t *ms_pkt,
  * Returns 0 on success.
  */
 int
-qla2x00_ga_nxt(scsi_qla_host_t *ha, fc_port_t *fcport)
+qla2x00_ga_nxt(scsi_qla_host_t *vha, fc_port_t *fcport)
 {
 	int		rval;
 
 	ms_iocb_entry_t	*ms_pkt;
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
+	struct qla_hw_data *ha = vha->hw;
 
-	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
-		return (qla2x00_sns_ga_nxt(ha, fcport));
-	}
+	if (IS_QLA2100(ha) || IS_QLA2200(ha))
+		return qla2x00_sns_ga_nxt(vha, fcport);
 
 	/* Issue GA_NXT */
 	/* Prepare common MS IOCB */
-	ms_pkt = ha->isp_ops->prep_ms_iocb(ha, GA_NXT_REQ_SIZE,
+	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, GA_NXT_REQ_SIZE,
 	    GA_NXT_RSP_SIZE);
 
 	/* Prepare CT request */
@@ -188,13 +191,13 @@ qla2x00_ga_nxt(scsi_qla_host_t *ha, fc_port_t *fcport)
 	ct_req->req.port_id.port_id[2] = fcport->d_id.b.al_pa;
 
 	/* Execute MS IOCB */
-	rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
+	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
 	    sizeof(ms_iocb_entry_t));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3(printk("scsi(%ld): GA_NXT issue IOCB failed (%d).\n",
-		    ha->host_no, rval));
-	} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp, "GA_NXT") !=
+		    vha->host_no, rval));
+	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "GA_NXT") !=
 	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
@@ -216,7 +219,7 @@ qla2x00_ga_nxt(scsi_qla_host_t *ha, fc_port_t *fcport)
 		    "nn %02x%02x%02x%02x%02x%02x%02x%02x "
 		    "pn %02x%02x%02x%02x%02x%02x%02x%02x "
 		    "portid=%02x%02x%02x.\n",
-		    ha->host_no,
+		    vha->host_no,
 		    fcport->node_name[0], fcport->node_name[1],
 		    fcport->node_name[2], fcport->node_name[3],
 		    fcport->node_name[4], fcport->node_name[5],
@@ -242,7 +245,7 @@ qla2x00_ga_nxt(scsi_qla_host_t *ha, fc_port_t *fcport)
  * Returns 0 on success.
  */
 int
-qla2x00_gid_pt(scsi_qla_host_t *ha, sw_info_t *list)
+qla2x00_gid_pt(scsi_qla_host_t *vha, sw_info_t *list)
 {
 	int		rval;
 	uint16_t	i;
@@ -252,16 +255,16 @@ qla2x00_gid_pt(scsi_qla_host_t *ha, sw_info_t *list)
 	struct ct_sns_rsp	*ct_rsp;
 
 	struct ct_sns_gid_pt_data *gid_data;
+	struct qla_hw_data *ha = vha->hw;
 
-	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
-		return (qla2x00_sns_gid_pt(ha, list));
-	}
+	if (IS_QLA2100(ha) || IS_QLA2200(ha))
+		return qla2x00_sns_gid_pt(vha, list);
 
 	gid_data = NULL;
 
 	/* Issue GID_PT */
 	/* Prepare common MS IOCB */
-	ms_pkt = ha->isp_ops->prep_ms_iocb(ha, GID_PT_REQ_SIZE,
+	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, GID_PT_REQ_SIZE,
 	    GID_PT_RSP_SIZE);
 
 	/* Prepare CT request */
@@ -273,13 +276,13 @@ qla2x00_gid_pt(scsi_qla_host_t *ha, sw_info_t *list)
 	ct_req->req.gid_pt.port_type = NS_NX_PORT_TYPE;
 
 	/* Execute MS IOCB */
-	rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
+	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
 	    sizeof(ms_iocb_entry_t));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3(printk("scsi(%ld): GID_PT issue IOCB failed (%d).\n",
-		    ha->host_no, rval));
-	} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp, "GID_PT") !=
+		    vha->host_no, rval));
+	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "GID_PT") !=
 	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
@@ -320,7 +323,7 @@ qla2x00_gid_pt(scsi_qla_host_t *ha, sw_info_t *list)
  * Returns 0 on success.
  */
 int
-qla2x00_gpn_id(scsi_qla_host_t *ha, sw_info_t *list)
+qla2x00_gpn_id(scsi_qla_host_t *vha, sw_info_t *list)
 {
 	int		rval;
 	uint16_t	i;
@@ -328,15 +331,15 @@ qla2x00_gpn_id(scsi_qla_host_t *ha, sw_info_t *list)
 	ms_iocb_entry_t	*ms_pkt;
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
+	struct qla_hw_data *ha = vha->hw;
 
-	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
-		return (qla2x00_sns_gpn_id(ha, list));
-	}
+	if (IS_QLA2100(ha) || IS_QLA2200(ha))
+		return qla2x00_sns_gpn_id(vha, list);
 
 	for (i = 0; i < MAX_FIBRE_DEVICES; i++) {
 		/* Issue GPN_ID */
 		/* Prepare common MS IOCB */
-		ms_pkt = ha->isp_ops->prep_ms_iocb(ha, GPN_ID_REQ_SIZE,
+		ms_pkt = ha->isp_ops->prep_ms_iocb(vha, GPN_ID_REQ_SIZE,
 		    GPN_ID_RSP_SIZE);
 
 		/* Prepare CT request */
@@ -350,13 +353,13 @@ qla2x00_gpn_id(scsi_qla_host_t *ha, sw_info_t *list)
 		ct_req->req.port_id.port_id[2] = list[i].d_id.b.al_pa;
 
 		/* Execute MS IOCB */
-		rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
+		rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
 		    sizeof(ms_iocb_entry_t));
 		if (rval != QLA_SUCCESS) {
 			/*EMPTY*/
 			DEBUG2_3(printk("scsi(%ld): GPN_ID issue IOCB failed "
-			    "(%d).\n", ha->host_no, rval));
-		} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp,
+			    "(%d).\n", vha->host_no, rval));
+		} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp,
 		    "GPN_ID") != QLA_SUCCESS) {
 			rval = QLA_FUNCTION_FAILED;
 		} else {
@@ -381,23 +384,22 @@ qla2x00_gpn_id(scsi_qla_host_t *ha, sw_info_t *list)
  * Returns 0 on success.
  */
 int
-qla2x00_gnn_id(scsi_qla_host_t *ha, sw_info_t *list)
+qla2x00_gnn_id(scsi_qla_host_t *vha, sw_info_t *list)
 {
 	int		rval;
 	uint16_t	i;
-
+	struct qla_hw_data *ha = vha->hw;
 	ms_iocb_entry_t	*ms_pkt;
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
 
-	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
-		return (qla2x00_sns_gnn_id(ha, list));
-	}
+	if (IS_QLA2100(ha) || IS_QLA2200(ha))
+		return qla2x00_sns_gnn_id(vha, list);
 
 	for (i = 0; i < MAX_FIBRE_DEVICES; i++) {
 		/* Issue GNN_ID */
 		/* Prepare common MS IOCB */
-		ms_pkt = ha->isp_ops->prep_ms_iocb(ha, GNN_ID_REQ_SIZE,
+		ms_pkt = ha->isp_ops->prep_ms_iocb(vha, GNN_ID_REQ_SIZE,
 		    GNN_ID_RSP_SIZE);
 
 		/* Prepare CT request */
@@ -411,13 +413,13 @@ qla2x00_gnn_id(scsi_qla_host_t *ha, sw_info_t *list)
 		ct_req->req.port_id.port_id[2] = list[i].d_id.b.al_pa;
 
 		/* Execute MS IOCB */
-		rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
+		rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
 		    sizeof(ms_iocb_entry_t));
 		if (rval != QLA_SUCCESS) {
 			/*EMPTY*/
 			DEBUG2_3(printk("scsi(%ld): GNN_ID issue IOCB failed "
-			    "(%d).\n", ha->host_no, rval));
-		} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp,
+			    "(%d).\n", vha->host_no, rval));
+		} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp,
 		    "GNN_ID") != QLA_SUCCESS) {
 			rval = QLA_FUNCTION_FAILED;
 		} else {
@@ -429,7 +431,7 @@ qla2x00_gnn_id(scsi_qla_host_t *ha, sw_info_t *list)
 			    "nn %02x%02x%02x%02x%02x%02x%02x%02x "
 			    "pn %02x%02x%02x%02x%02x%02x%02x%02x "
 			    "portid=%02x%02x%02x.\n",
-			    ha->host_no,
+			    vha->host_no,
 			    list[i].node_name[0], list[i].node_name[1],
 			    list[i].node_name[2], list[i].node_name[3],
 			    list[i].node_name[4], list[i].node_name[5],
@@ -457,21 +459,20 @@ qla2x00_gnn_id(scsi_qla_host_t *ha, sw_info_t *list)
  * Returns 0 on success.
  */
 int
-qla2x00_rft_id(scsi_qla_host_t *ha)
+qla2x00_rft_id(scsi_qla_host_t *vha)
 {
 	int		rval;
-
+	struct qla_hw_data *ha = vha->hw;
 	ms_iocb_entry_t	*ms_pkt;
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
 
-	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
-		return (qla2x00_sns_rft_id(ha));
-	}
+	if (IS_QLA2100(ha) || IS_QLA2200(ha))
+		return qla2x00_sns_rft_id(vha);
 
 	/* Issue RFT_ID */
 	/* Prepare common MS IOCB */
-	ms_pkt = ha->isp_ops->prep_ms_iocb(ha, RFT_ID_REQ_SIZE,
+	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, RFT_ID_REQ_SIZE,
 	    RFT_ID_RSP_SIZE);
 
 	/* Prepare CT request */
@@ -480,25 +481,25 @@ qla2x00_rft_id(scsi_qla_host_t *ha)
 	ct_rsp = &ha->ct_sns->p.rsp;
 
 	/* Prepare CT arguments -- port_id, FC-4 types */
-	ct_req->req.rft_id.port_id[0] = ha->d_id.b.domain;
-	ct_req->req.rft_id.port_id[1] = ha->d_id.b.area;
-	ct_req->req.rft_id.port_id[2] = ha->d_id.b.al_pa;
+	ct_req->req.rft_id.port_id[0] = vha->d_id.b.domain;
+	ct_req->req.rft_id.port_id[1] = vha->d_id.b.area;
+	ct_req->req.rft_id.port_id[2] = vha->d_id.b.al_pa;
 
 	ct_req->req.rft_id.fc4_types[2] = 0x01;		/* FCP-3 */
 
 	/* Execute MS IOCB */
-	rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
+	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
 	    sizeof(ms_iocb_entry_t));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3(printk("scsi(%ld): RFT_ID issue IOCB failed (%d).\n",
-		    ha->host_no, rval));
-	} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp, "RFT_ID") !=
+		    vha->host_no, rval));
+	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "RFT_ID") !=
 	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		DEBUG2(printk("scsi(%ld): RFT_ID exiting normally.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return (rval);
@@ -511,23 +512,23 @@ qla2x00_rft_id(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 int
-qla2x00_rff_id(scsi_qla_host_t *ha)
+qla2x00_rff_id(scsi_qla_host_t *vha)
 {
 	int		rval;
-
+	struct qla_hw_data *ha = vha->hw;
 	ms_iocb_entry_t	*ms_pkt;
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
 		DEBUG2(printk("scsi(%ld): RFF_ID call unsupported on "
-		    "ISP2100/ISP2200.\n", ha->host_no));
+		    "ISP2100/ISP2200.\n", vha->host_no));
 		return (QLA_SUCCESS);
 	}
 
 	/* Issue RFF_ID */
 	/* Prepare common MS IOCB */
-	ms_pkt = ha->isp_ops->prep_ms_iocb(ha, RFF_ID_REQ_SIZE,
+	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, RFF_ID_REQ_SIZE,
 	    RFF_ID_RSP_SIZE);
 
 	/* Prepare CT request */
@@ -536,26 +537,26 @@ qla2x00_rff_id(scsi_qla_host_t *ha)
 	ct_rsp = &ha->ct_sns->p.rsp;
 
 	/* Prepare CT arguments -- port_id, FC-4 feature, FC-4 type */
-	ct_req->req.rff_id.port_id[0] = ha->d_id.b.domain;
-	ct_req->req.rff_id.port_id[1] = ha->d_id.b.area;
-	ct_req->req.rff_id.port_id[2] = ha->d_id.b.al_pa;
+	ct_req->req.rff_id.port_id[0] = vha->d_id.b.domain;
+	ct_req->req.rff_id.port_id[1] = vha->d_id.b.area;
+	ct_req->req.rff_id.port_id[2] = vha->d_id.b.al_pa;
 
 	ct_req->req.rff_id.fc4_feature = BIT_1;
 	ct_req->req.rff_id.fc4_type = 0x08;		/* SCSI - FCP */
 
 	/* Execute MS IOCB */
-	rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
+	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
 	    sizeof(ms_iocb_entry_t));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3(printk("scsi(%ld): RFF_ID issue IOCB failed (%d).\n",
-		    ha->host_no, rval));
-	} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp, "RFF_ID") !=
+		    vha->host_no, rval));
+	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "RFF_ID") !=
 	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		DEBUG2(printk("scsi(%ld): RFF_ID exiting normally.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return (rval);
@@ -568,21 +569,20 @@ qla2x00_rff_id(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 int
-qla2x00_rnn_id(scsi_qla_host_t *ha)
+qla2x00_rnn_id(scsi_qla_host_t *vha)
 {
 	int		rval;
-
+	struct qla_hw_data *ha = vha->hw;
 	ms_iocb_entry_t	*ms_pkt;
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
 
-	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
-		return (qla2x00_sns_rnn_id(ha));
-	}
+	if (IS_QLA2100(ha) || IS_QLA2200(ha))
+		return qla2x00_sns_rnn_id(vha);
 
 	/* Issue RNN_ID */
 	/* Prepare common MS IOCB */
-	ms_pkt = ha->isp_ops->prep_ms_iocb(ha, RNN_ID_REQ_SIZE,
+	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, RNN_ID_REQ_SIZE,
 	    RNN_ID_RSP_SIZE);
 
 	/* Prepare CT request */
@@ -591,33 +591,34 @@ qla2x00_rnn_id(scsi_qla_host_t *ha)
 	ct_rsp = &ha->ct_sns->p.rsp;
 
 	/* Prepare CT arguments -- port_id, node_name */
-	ct_req->req.rnn_id.port_id[0] = ha->d_id.b.domain;
-	ct_req->req.rnn_id.port_id[1] = ha->d_id.b.area;
-	ct_req->req.rnn_id.port_id[2] = ha->d_id.b.al_pa;
+	ct_req->req.rnn_id.port_id[0] = vha->d_id.b.domain;
+	ct_req->req.rnn_id.port_id[1] = vha->d_id.b.area;
+	ct_req->req.rnn_id.port_id[2] = vha->d_id.b.al_pa;
 
-	memcpy(ct_req->req.rnn_id.node_name, ha->node_name, WWN_SIZE);
+	memcpy(ct_req->req.rnn_id.node_name, vha->node_name, WWN_SIZE);
 
 	/* Execute MS IOCB */
-	rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
+	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
 	    sizeof(ms_iocb_entry_t));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3(printk("scsi(%ld): RNN_ID issue IOCB failed (%d).\n",
-		    ha->host_no, rval));
-	} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp, "RNN_ID") !=
+		    vha->host_no, rval));
+	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "RNN_ID") !=
 	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		DEBUG2(printk("scsi(%ld): RNN_ID exiting normally.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return (rval);
 }
 
 void
-qla2x00_get_sym_node_name(scsi_qla_host_t *ha, uint8_t *snn)
+qla2x00_get_sym_node_name(scsi_qla_host_t *vha, uint8_t *snn)
 {
+	struct qla_hw_data *ha = vha->hw;
 	sprintf(snn, "%s FW:v%d.%02d.%02d DVR:v%s",ha->model_number,
 	    ha->fw_major_version, ha->fw_minor_version,
 	    ha->fw_subminor_version, qla2x00_version_str);
@@ -630,23 +631,24 @@ qla2x00_get_sym_node_name(scsi_qla_host_t *ha, uint8_t *snn)
  * Returns 0 on success.
  */
 int
-qla2x00_rsnn_nn(scsi_qla_host_t *ha)
+qla2x00_rsnn_nn(scsi_qla_host_t *vha)
 {
 	int		rval;
+	struct qla_hw_data *ha = vha->hw;
 	ms_iocb_entry_t	*ms_pkt;
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
 		DEBUG2(printk("scsi(%ld): RSNN_ID call unsupported on "
-		    "ISP2100/ISP2200.\n", ha->host_no));
+		    "ISP2100/ISP2200.\n", vha->host_no));
 		return (QLA_SUCCESS);
 	}
 
 	/* Issue RSNN_NN */
 	/* Prepare common MS IOCB */
 	/*   Request size adjusted after CT preparation */
-	ms_pkt = ha->isp_ops->prep_ms_iocb(ha, 0, RSNN_NN_RSP_SIZE);
+	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, 0, RSNN_NN_RSP_SIZE);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, RSNN_NN_CMD,
@@ -654,10 +656,10 @@ qla2x00_rsnn_nn(scsi_qla_host_t *ha)
 	ct_rsp = &ha->ct_sns->p.rsp;
 
 	/* Prepare CT arguments -- node_name, symbolic node_name, size */
-	memcpy(ct_req->req.rsnn_nn.node_name, ha->node_name, WWN_SIZE);
+	memcpy(ct_req->req.rsnn_nn.node_name, vha->node_name, WWN_SIZE);
 
 	/* Prepare the Symbolic Node Name */
-	qla2x00_get_sym_node_name(ha, ct_req->req.rsnn_nn.sym_node_name);
+	qla2x00_get_sym_node_name(vha, ct_req->req.rsnn_nn.sym_node_name);
 
 	/* Calculate SNN length */
 	ct_req->req.rsnn_nn.name_len =
@@ -669,18 +671,18 @@ qla2x00_rsnn_nn(scsi_qla_host_t *ha)
 	ms_pkt->dseg_req_length = ms_pkt->req_bytecount;
 
 	/* Execute MS IOCB */
-	rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
+	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
 	    sizeof(ms_iocb_entry_t));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3(printk("scsi(%ld): RSNN_NN issue IOCB failed (%d).\n",
-		    ha->host_no, rval));
-	} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp, "RSNN_NN") !=
+		    vha->host_no, rval));
+	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "RSNN_NN") !=
 	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		DEBUG2(printk("scsi(%ld): RSNN_NN exiting normally.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return (rval);
@@ -696,11 +698,12 @@ qla2x00_rsnn_nn(scsi_qla_host_t *ha)
  * Returns a pointer to the @ha's sns_cmd.
  */
 static inline struct sns_cmd_pkt *
-qla2x00_prep_sns_cmd(scsi_qla_host_t *ha, uint16_t cmd, uint16_t scmd_len,
+qla2x00_prep_sns_cmd(scsi_qla_host_t *vha, uint16_t cmd, uint16_t scmd_len,
     uint16_t data_size)
 {
 	uint16_t		wc;
 	struct sns_cmd_pkt	*sns_cmd;
+	struct qla_hw_data *ha = vha->hw;
 
 	sns_cmd = ha->sns_cmd;
 	memset(sns_cmd, 0, sizeof(struct sns_cmd_pkt));
@@ -726,15 +729,15 @@ qla2x00_prep_sns_cmd(scsi_qla_host_t *ha, uint16_t cmd, uint16_t scmd_len,
  * Returns 0 on success.
  */
 static int
-qla2x00_sns_ga_nxt(scsi_qla_host_t *ha, fc_port_t *fcport)
+qla2x00_sns_ga_nxt(scsi_qla_host_t *vha, fc_port_t *fcport)
 {
 	int		rval;
-
+	struct qla_hw_data *ha = vha->hw;
 	struct sns_cmd_pkt	*sns_cmd;
 
 	/* Issue GA_NXT. */
 	/* Prepare SNS command request. */
-	sns_cmd = qla2x00_prep_sns_cmd(ha, GA_NXT_CMD, GA_NXT_SNS_SCMD_LEN,
+	sns_cmd = qla2x00_prep_sns_cmd(vha, GA_NXT_CMD, GA_NXT_SNS_SCMD_LEN,
 	    GA_NXT_SNS_DATA_SIZE);
 
 	/* Prepare SNS command arguments -- port_id. */
@@ -743,16 +746,16 @@ qla2x00_sns_ga_nxt(scsi_qla_host_t *ha, fc_port_t *fcport)
 	sns_cmd->p.cmd.param[2] = fcport->d_id.b.domain;
 
 	/* Execute SNS command. */
-	rval = qla2x00_send_sns(ha, ha->sns_cmd_dma, GA_NXT_SNS_CMD_SIZE / 2,
+	rval = qla2x00_send_sns(vha, ha->sns_cmd_dma, GA_NXT_SNS_CMD_SIZE / 2,
 	    sizeof(struct sns_cmd_pkt));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3(printk("scsi(%ld): GA_NXT Send SNS failed (%d).\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else if (sns_cmd->p.gan_data[8] != 0x80 ||
 	    sns_cmd->p.gan_data[9] != 0x02) {
 		DEBUG2_3(printk("scsi(%ld): GA_NXT failed, rejected request, "
-		    "ga_nxt_rsp:\n", ha->host_no));
+		    "ga_nxt_rsp:\n", vha->host_no));
 		DEBUG2_3(qla2x00_dump_buffer(sns_cmd->p.gan_data, 16));
 		rval = QLA_FUNCTION_FAILED;
 	} else {
@@ -772,7 +775,7 @@ qla2x00_sns_ga_nxt(scsi_qla_host_t *ha, fc_port_t *fcport)
 		    "nn %02x%02x%02x%02x%02x%02x%02x%02x "
 		    "pn %02x%02x%02x%02x%02x%02x%02x%02x "
 		    "portid=%02x%02x%02x.\n",
-		    ha->host_no,
+		    vha->host_no,
 		    fcport->node_name[0], fcport->node_name[1],
 		    fcport->node_name[2], fcport->node_name[3],
 		    fcport->node_name[4], fcport->node_name[5],
@@ -800,33 +803,33 @@ qla2x00_sns_ga_nxt(scsi_qla_host_t *ha, fc_port_t *fcport)
  * Returns 0 on success.
  */
 static int
-qla2x00_sns_gid_pt(scsi_qla_host_t *ha, sw_info_t *list)
+qla2x00_sns_gid_pt(scsi_qla_host_t *vha, sw_info_t *list)
 {
 	int		rval;
-
+	struct qla_hw_data *ha = vha->hw;
 	uint16_t	i;
 	uint8_t		*entry;
 	struct sns_cmd_pkt	*sns_cmd;
 
 	/* Issue GID_PT. */
 	/* Prepare SNS command request. */
-	sns_cmd = qla2x00_prep_sns_cmd(ha, GID_PT_CMD, GID_PT_SNS_SCMD_LEN,
+	sns_cmd = qla2x00_prep_sns_cmd(vha, GID_PT_CMD, GID_PT_SNS_SCMD_LEN,
 	    GID_PT_SNS_DATA_SIZE);
 
 	/* Prepare SNS command arguments -- port_type. */
 	sns_cmd->p.cmd.param[0] = NS_NX_PORT_TYPE;
 
 	/* Execute SNS command. */
-	rval = qla2x00_send_sns(ha, ha->sns_cmd_dma, GID_PT_SNS_CMD_SIZE / 2,
+	rval = qla2x00_send_sns(vha, ha->sns_cmd_dma, GID_PT_SNS_CMD_SIZE / 2,
 	    sizeof(struct sns_cmd_pkt));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3(printk("scsi(%ld): GID_PT Send SNS failed (%d).\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else if (sns_cmd->p.gid_data[8] != 0x80 ||
 	    sns_cmd->p.gid_data[9] != 0x02) {
 		DEBUG2_3(printk("scsi(%ld): GID_PT failed, rejected request, "
-		    "gid_rsp:\n", ha->host_no));
+		    "gid_rsp:\n", vha->host_no));
 		DEBUG2_3(qla2x00_dump_buffer(sns_cmd->p.gid_data, 16));
 		rval = QLA_FUNCTION_FAILED;
 	} else {
@@ -867,17 +870,17 @@ qla2x00_sns_gid_pt(scsi_qla_host_t *ha, sw_info_t *list)
  * Returns 0 on success.
  */
 static int
-qla2x00_sns_gpn_id(scsi_qla_host_t *ha, sw_info_t *list)
+qla2x00_sns_gpn_id(scsi_qla_host_t *vha, sw_info_t *list)
 {
 	int		rval;
-
+	struct qla_hw_data *ha = vha->hw;
 	uint16_t	i;
 	struct sns_cmd_pkt	*sns_cmd;
 
 	for (i = 0; i < MAX_FIBRE_DEVICES; i++) {
 		/* Issue GPN_ID */
 		/* Prepare SNS command request. */
-		sns_cmd = qla2x00_prep_sns_cmd(ha, GPN_ID_CMD,
+		sns_cmd = qla2x00_prep_sns_cmd(vha, GPN_ID_CMD,
 		    GPN_ID_SNS_SCMD_LEN, GPN_ID_SNS_DATA_SIZE);
 
 		/* Prepare SNS command arguments -- port_id. */
@@ -886,16 +889,16 @@ qla2x00_sns_gpn_id(scsi_qla_host_t *ha, sw_info_t *list)
 		sns_cmd->p.cmd.param[2] = list[i].d_id.b.domain;
 
 		/* Execute SNS command. */
-		rval = qla2x00_send_sns(ha, ha->sns_cmd_dma,
+		rval = qla2x00_send_sns(vha, ha->sns_cmd_dma,
 		    GPN_ID_SNS_CMD_SIZE / 2, sizeof(struct sns_cmd_pkt));
 		if (rval != QLA_SUCCESS) {
 			/*EMPTY*/
 			DEBUG2_3(printk("scsi(%ld): GPN_ID Send SNS failed "
-			    "(%d).\n", ha->host_no, rval));
+			    "(%d).\n", vha->host_no, rval));
 		} else if (sns_cmd->p.gpn_data[8] != 0x80 ||
 		    sns_cmd->p.gpn_data[9] != 0x02) {
 			DEBUG2_3(printk("scsi(%ld): GPN_ID failed, rejected "
-			    "request, gpn_rsp:\n", ha->host_no));
+			    "request, gpn_rsp:\n", vha->host_no));
 			DEBUG2_3(qla2x00_dump_buffer(sns_cmd->p.gpn_data, 16));
 			rval = QLA_FUNCTION_FAILED;
 		} else {
@@ -922,17 +925,17 @@ qla2x00_sns_gpn_id(scsi_qla_host_t *ha, sw_info_t *list)
  * Returns 0 on success.
  */
 static int
-qla2x00_sns_gnn_id(scsi_qla_host_t *ha, sw_info_t *list)
+qla2x00_sns_gnn_id(scsi_qla_host_t *vha, sw_info_t *list)
 {
 	int		rval;
-
+	struct qla_hw_data *ha = vha->hw;
 	uint16_t	i;
 	struct sns_cmd_pkt	*sns_cmd;
 
 	for (i = 0; i < MAX_FIBRE_DEVICES; i++) {
 		/* Issue GNN_ID */
 		/* Prepare SNS command request. */
-		sns_cmd = qla2x00_prep_sns_cmd(ha, GNN_ID_CMD,
+		sns_cmd = qla2x00_prep_sns_cmd(vha, GNN_ID_CMD,
 		    GNN_ID_SNS_SCMD_LEN, GNN_ID_SNS_DATA_SIZE);
 
 		/* Prepare SNS command arguments -- port_id. */
@@ -941,16 +944,16 @@ qla2x00_sns_gnn_id(scsi_qla_host_t *ha, sw_info_t *list)
 		sns_cmd->p.cmd.param[2] = list[i].d_id.b.domain;
 
 		/* Execute SNS command. */
-		rval = qla2x00_send_sns(ha, ha->sns_cmd_dma,
+		rval = qla2x00_send_sns(vha, ha->sns_cmd_dma,
 		    GNN_ID_SNS_CMD_SIZE / 2, sizeof(struct sns_cmd_pkt));
 		if (rval != QLA_SUCCESS) {
 			/*EMPTY*/
 			DEBUG2_3(printk("scsi(%ld): GNN_ID Send SNS failed "
-			    "(%d).\n", ha->host_no, rval));
+			    "(%d).\n", vha->host_no, rval));
 		} else if (sns_cmd->p.gnn_data[8] != 0x80 ||
 		    sns_cmd->p.gnn_data[9] != 0x02) {
 			DEBUG2_3(printk("scsi(%ld): GNN_ID failed, rejected "
-			    "request, gnn_rsp:\n", ha->host_no));
+			    "request, gnn_rsp:\n", vha->host_no));
 			DEBUG2_3(qla2x00_dump_buffer(sns_cmd->p.gnn_data, 16));
 			rval = QLA_FUNCTION_FAILED;
 		} else {
@@ -962,7 +965,7 @@ qla2x00_sns_gnn_id(scsi_qla_host_t *ha, sw_info_t *list)
 			    "nn %02x%02x%02x%02x%02x%02x%02x%02x "
 			    "pn %02x%02x%02x%02x%02x%02x%02x%02x "
 			    "portid=%02x%02x%02x.\n",
-			    ha->host_no,
+			    vha->host_no,
 			    list[i].node_name[0], list[i].node_name[1],
 			    list[i].node_name[2], list[i].node_name[3],
 			    list[i].node_name[4], list[i].node_name[5],
@@ -992,40 +995,40 @@ qla2x00_sns_gnn_id(scsi_qla_host_t *ha, sw_info_t *list)
  * Returns 0 on success.
  */
 static int
-qla2x00_sns_rft_id(scsi_qla_host_t *ha)
+qla2x00_sns_rft_id(scsi_qla_host_t *vha)
 {
 	int		rval;
-
+	struct qla_hw_data *ha = vha->hw;
 	struct sns_cmd_pkt	*sns_cmd;
 
 	/* Issue RFT_ID. */
 	/* Prepare SNS command request. */
-	sns_cmd = qla2x00_prep_sns_cmd(ha, RFT_ID_CMD, RFT_ID_SNS_SCMD_LEN,
+	sns_cmd = qla2x00_prep_sns_cmd(vha, RFT_ID_CMD, RFT_ID_SNS_SCMD_LEN,
 	    RFT_ID_SNS_DATA_SIZE);
 
 	/* Prepare SNS command arguments -- port_id, FC-4 types */
-	sns_cmd->p.cmd.param[0] = ha->d_id.b.al_pa;
-	sns_cmd->p.cmd.param[1] = ha->d_id.b.area;
-	sns_cmd->p.cmd.param[2] = ha->d_id.b.domain;
+	sns_cmd->p.cmd.param[0] = vha->d_id.b.al_pa;
+	sns_cmd->p.cmd.param[1] = vha->d_id.b.area;
+	sns_cmd->p.cmd.param[2] = vha->d_id.b.domain;
 
 	sns_cmd->p.cmd.param[5] = 0x01;			/* FCP-3 */
 
 	/* Execute SNS command. */
-	rval = qla2x00_send_sns(ha, ha->sns_cmd_dma, RFT_ID_SNS_CMD_SIZE / 2,
+	rval = qla2x00_send_sns(vha, ha->sns_cmd_dma, RFT_ID_SNS_CMD_SIZE / 2,
 	    sizeof(struct sns_cmd_pkt));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3(printk("scsi(%ld): RFT_ID Send SNS failed (%d).\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else if (sns_cmd->p.rft_data[8] != 0x80 ||
 	    sns_cmd->p.rft_data[9] != 0x02) {
 		DEBUG2_3(printk("scsi(%ld): RFT_ID failed, rejected request, "
-		    "rft_rsp:\n", ha->host_no));
+		    "rft_rsp:\n", vha->host_no));
 		DEBUG2_3(qla2x00_dump_buffer(sns_cmd->p.rft_data, 16));
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		DEBUG2(printk("scsi(%ld): RFT_ID exiting normally.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return (rval);
@@ -1041,47 +1044,47 @@ qla2x00_sns_rft_id(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 static int
-qla2x00_sns_rnn_id(scsi_qla_host_t *ha)
+qla2x00_sns_rnn_id(scsi_qla_host_t *vha)
 {
 	int		rval;
-
+	struct qla_hw_data *ha = vha->hw;
 	struct sns_cmd_pkt	*sns_cmd;
 
 	/* Issue RNN_ID. */
 	/* Prepare SNS command request. */
-	sns_cmd = qla2x00_prep_sns_cmd(ha, RNN_ID_CMD, RNN_ID_SNS_SCMD_LEN,
+	sns_cmd = qla2x00_prep_sns_cmd(vha, RNN_ID_CMD, RNN_ID_SNS_SCMD_LEN,
 	    RNN_ID_SNS_DATA_SIZE);
 
 	/* Prepare SNS command arguments -- port_id, nodename. */
-	sns_cmd->p.cmd.param[0] = ha->d_id.b.al_pa;
-	sns_cmd->p.cmd.param[1] = ha->d_id.b.area;
-	sns_cmd->p.cmd.param[2] = ha->d_id.b.domain;
-
-	sns_cmd->p.cmd.param[4] = ha->node_name[7];
-	sns_cmd->p.cmd.param[5] = ha->node_name[6];
-	sns_cmd->p.cmd.param[6] = ha->node_name[5];
-	sns_cmd->p.cmd.param[7] = ha->node_name[4];
-	sns_cmd->p.cmd.param[8] = ha->node_name[3];
-	sns_cmd->p.cmd.param[9] = ha->node_name[2];
-	sns_cmd->p.cmd.param[10] = ha->node_name[1];
-	sns_cmd->p.cmd.param[11] = ha->node_name[0];
+	sns_cmd->p.cmd.param[0] = vha->d_id.b.al_pa;
+	sns_cmd->p.cmd.param[1] = vha->d_id.b.area;
+	sns_cmd->p.cmd.param[2] = vha->d_id.b.domain;
+
+	sns_cmd->p.cmd.param[4] = vha->node_name[7];
+	sns_cmd->p.cmd.param[5] = vha->node_name[6];
+	sns_cmd->p.cmd.param[6] = vha->node_name[5];
+	sns_cmd->p.cmd.param[7] = vha->node_name[4];
+	sns_cmd->p.cmd.param[8] = vha->node_name[3];
+	sns_cmd->p.cmd.param[9] = vha->node_name[2];
+	sns_cmd->p.cmd.param[10] = vha->node_name[1];
+	sns_cmd->p.cmd.param[11] = vha->node_name[0];
 
 	/* Execute SNS command. */
-	rval = qla2x00_send_sns(ha, ha->sns_cmd_dma, RNN_ID_SNS_CMD_SIZE / 2,
+	rval = qla2x00_send_sns(vha, ha->sns_cmd_dma, RNN_ID_SNS_CMD_SIZE / 2,
 	    sizeof(struct sns_cmd_pkt));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3(printk("scsi(%ld): RNN_ID Send SNS failed (%d).\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else if (sns_cmd->p.rnn_data[8] != 0x80 ||
 	    sns_cmd->p.rnn_data[9] != 0x02) {
 		DEBUG2_3(printk("scsi(%ld): RNN_ID failed, rejected request, "
-		    "rnn_rsp:\n", ha->host_no));
+		    "rnn_rsp:\n", vha->host_no));
 		DEBUG2_3(qla2x00_dump_buffer(sns_cmd->p.rnn_data, 16));
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		DEBUG2(printk("scsi(%ld): RNN_ID exiting normally.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return (rval);
@@ -1094,25 +1097,25 @@ qla2x00_sns_rnn_id(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 static int
-qla2x00_mgmt_svr_login(scsi_qla_host_t *ha)
+qla2x00_mgmt_svr_login(scsi_qla_host_t *vha)
 {
 	int ret;
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
-
+	struct qla_hw_data *ha = vha->hw;
 	ret = QLA_SUCCESS;
-	if (ha->flags.management_server_logged_in)
+	if (vha->flags.management_server_logged_in)
 		return ret;
 
-	ha->isp_ops->fabric_login(ha, ha->mgmt_svr_loop_id, 0xff, 0xff, 0xfa,
+	ha->isp_ops->fabric_login(vha, vha->mgmt_svr_loop_id, 0xff, 0xff, 0xfa,
 	    mb, BIT_1);
 	if (mb[0] != MBS_COMMAND_COMPLETE) {
 		DEBUG2_13(printk("%s(%ld): Failed MANAGEMENT_SERVER login: "
 		    "loop_id=%x mb[0]=%x mb[1]=%x mb[2]=%x mb[6]=%x mb[7]=%x\n",
-		    __func__, ha->host_no, ha->mgmt_svr_loop_id, mb[0], mb[1],
+		    __func__, vha->host_no, vha->mgmt_svr_loop_id, mb[0], mb[1],
 		    mb[2], mb[6], mb[7]));
 		ret = QLA_FUNCTION_FAILED;
 	} else
-		ha->flags.management_server_logged_in = 1;
+		vha->flags.management_server_logged_in = 1;
 
 	return ret;
 }
@@ -1126,17 +1129,17 @@ qla2x00_mgmt_svr_login(scsi_qla_host_t *ha)
  * Returns a pointer to the @ha's ms_iocb.
  */
 void *
-qla2x00_prep_ms_fdmi_iocb(scsi_qla_host_t *ha, uint32_t req_size,
+qla2x00_prep_ms_fdmi_iocb(scsi_qla_host_t *vha, uint32_t req_size,
     uint32_t rsp_size)
 {
 	ms_iocb_entry_t *ms_pkt;
-
+	struct qla_hw_data *ha = vha->hw;
 	ms_pkt = ha->ms_iocb;
 	memset(ms_pkt, 0, sizeof(ms_iocb_entry_t));
 
 	ms_pkt->entry_type = MS_IOCB_TYPE;
 	ms_pkt->entry_count = 1;
-	SET_TARGET_ID(ha, ms_pkt->loop_id, ha->mgmt_svr_loop_id);
+	SET_TARGET_ID(ha, ms_pkt->loop_id, vha->mgmt_svr_loop_id);
 	ms_pkt->control_flags = __constant_cpu_to_le16(CF_READ | CF_HEAD_TAG);
 	ms_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
 	ms_pkt->cmd_dsd_count = __constant_cpu_to_le16(1);
@@ -1164,17 +1167,18 @@ qla2x00_prep_ms_fdmi_iocb(scsi_qla_host_t *ha, uint32_t req_size,
  * Returns a pointer to the @ha's ms_iocb.
  */
 void *
-qla24xx_prep_ms_fdmi_iocb(scsi_qla_host_t *ha, uint32_t req_size,
+qla24xx_prep_ms_fdmi_iocb(scsi_qla_host_t *vha, uint32_t req_size,
     uint32_t rsp_size)
 {
 	struct ct_entry_24xx *ct_pkt;
+	struct qla_hw_data *ha = vha->hw;
 
 	ct_pkt = (struct ct_entry_24xx *)ha->ms_iocb;
 	memset(ct_pkt, 0, sizeof(struct ct_entry_24xx));
 
 	ct_pkt->entry_type = CT_IOCB_TYPE;
 	ct_pkt->entry_count = 1;
-	ct_pkt->nport_handle = cpu_to_le16(ha->mgmt_svr_loop_id);
+	ct_pkt->nport_handle = cpu_to_le16(vha->mgmt_svr_loop_id);
 	ct_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
 	ct_pkt->cmd_dsd_count = __constant_cpu_to_le16(1);
 	ct_pkt->rsp_dsd_count = __constant_cpu_to_le16(1);
@@ -1188,14 +1192,15 @@ qla24xx_prep_ms_fdmi_iocb(scsi_qla_host_t *ha, uint32_t req_size,
 	ct_pkt->dseg_1_address[0] = cpu_to_le32(LSD(ha->ct_sns_dma));
 	ct_pkt->dseg_1_address[1] = cpu_to_le32(MSD(ha->ct_sns_dma));
 	ct_pkt->dseg_1_len = ct_pkt->rsp_byte_count;
-	ct_pkt->vp_index = ha->vp_idx;
+	ct_pkt->vp_index = vha->vp_idx;
 
 	return ct_pkt;
 }
 
 static inline ms_iocb_entry_t *
-qla2x00_update_ms_fdmi_iocb(scsi_qla_host_t *ha, uint32_t req_size)
+qla2x00_update_ms_fdmi_iocb(scsi_qla_host_t *vha, uint32_t req_size)
 {
+	struct qla_hw_data *ha = vha->hw;
 	ms_iocb_entry_t *ms_pkt = ha->ms_iocb;
 	struct ct_entry_24xx *ct_pkt = (struct ct_entry_24xx *)ha->ms_iocb;
 
@@ -1240,7 +1245,7 @@ qla2x00_prep_ct_fdmi_req(struct ct_sns_req *ct_req, uint16_t cmd,
  * Returns 0 on success.
  */
 static int
-qla2x00_fdmi_rhba(scsi_qla_host_t *ha)
+qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 {
 	int rval, alen;
 	uint32_t size, sn;
@@ -1250,11 +1255,12 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *ha)
 	struct ct_sns_rsp *ct_rsp;
 	uint8_t *entries;
 	struct ct_fdmi_hba_attr *eiter;
+	struct qla_hw_data *ha = vha->hw;
 
 	/* Issue RHBA */
 	/* Prepare common MS IOCB */
 	/*   Request size adjusted after CT preparation */
-	ms_pkt = ha->isp_ops->prep_ms_fdmi_iocb(ha, 0, RHBA_RSP_SIZE);
+	ms_pkt = ha->isp_ops->prep_ms_fdmi_iocb(vha, 0, RHBA_RSP_SIZE);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_fdmi_req(&ha->ct_sns->p.req, RHBA_CMD,
@@ -1262,9 +1268,9 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *ha)
 	ct_rsp = &ha->ct_sns->p.rsp;
 
 	/* Prepare FDMI command arguments -- attribute block, attributes. */
-	memcpy(ct_req->req.rhba.hba_identifier, ha->port_name, WWN_SIZE);
+	memcpy(ct_req->req.rhba.hba_identifier, vha->port_name, WWN_SIZE);
 	ct_req->req.rhba.entry_count = __constant_cpu_to_be32(1);
-	memcpy(ct_req->req.rhba.port_name, ha->port_name, WWN_SIZE);
+	memcpy(ct_req->req.rhba.port_name, vha->port_name, WWN_SIZE);
 	size = 2 * WWN_SIZE + 4 + 4;
 
 	/* Attributes */
@@ -1276,11 +1282,11 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *ha)
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_HBA_NODE_NAME);
 	eiter->len = __constant_cpu_to_be16(4 + WWN_SIZE);
-	memcpy(eiter->a.node_name, ha->node_name, WWN_SIZE);
+	memcpy(eiter->a.node_name, vha->node_name, WWN_SIZE);
 	size += 4 + WWN_SIZE;
 
 	DEBUG13(printk("%s(%ld): NODENAME=%02x%02x%02x%02x%02x%02x%02x%02x.\n",
-	    __func__, ha->host_no,
+	    __func__, vha->host_no,
 	    eiter->a.node_name[0], eiter->a.node_name[1], eiter->a.node_name[2],
 	    eiter->a.node_name[3], eiter->a.node_name[4], eiter->a.node_name[5],
 	    eiter->a.node_name[6], eiter->a.node_name[7]));
@@ -1294,7 +1300,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *ha)
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
 
-	DEBUG13(printk("%s(%ld): MANUFACTURER=%s.\n", __func__, ha->host_no,
+	DEBUG13(printk("%s(%ld): MANUFACTURER=%s.\n", __func__, vha->host_no,
 	    eiter->a.manufacturer));
 
 	/* Serial number. */
@@ -1307,7 +1313,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *ha)
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
 
-	DEBUG13(printk("%s(%ld): SERIALNO=%s.\n", __func__, ha->host_no,
+	DEBUG13(printk("%s(%ld): SERIALNO=%s.\n", __func__, vha->host_no,
 	    eiter->a.serial_num));
 
 	/* Model name. */
@@ -1319,7 +1325,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *ha)
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
 
-	DEBUG13(printk("%s(%ld): MODEL_NAME=%s.\n", __func__, ha->host_no,
+	DEBUG13(printk("%s(%ld): MODEL_NAME=%s.\n", __func__, vha->host_no,
 	    eiter->a.model));
 
 	/* Model description. */
@@ -1332,7 +1338,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *ha)
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
 
-	DEBUG13(printk("%s(%ld): MODEL_DESC=%s.\n", __func__, ha->host_no,
+	DEBUG13(printk("%s(%ld): MODEL_DESC=%s.\n", __func__, vha->host_no,
 	    eiter->a.model_desc));
 
 	/* Hardware version. */
@@ -1344,7 +1350,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *ha)
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
 
-	DEBUG13(printk("%s(%ld): HARDWAREVER=%s.\n", __func__, ha->host_no,
+	DEBUG13(printk("%s(%ld): HARDWAREVER=%s.\n", __func__, vha->host_no,
 	    eiter->a.hw_version));
 
 	/* Driver version. */
@@ -1356,7 +1362,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *ha)
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
 
-	DEBUG13(printk("%s(%ld): DRIVERVER=%s.\n", __func__, ha->host_no,
+	DEBUG13(printk("%s(%ld): DRIVERVER=%s.\n", __func__, vha->host_no,
 	    eiter->a.driver_version));
 
 	/* Option ROM version. */
@@ -1368,27 +1374,27 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *ha)
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
 
-	DEBUG13(printk("%s(%ld): OPTROMVER=%s.\n", __func__, ha->host_no,
+	DEBUG13(printk("%s(%ld): OPTROMVER=%s.\n", __func__, vha->host_no,
 	    eiter->a.orom_version));
 
 	/* Firmware version */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_HBA_FIRMWARE_VERSION);
-	ha->isp_ops->fw_version_str(ha, eiter->a.fw_version);
+	ha->isp_ops->fw_version_str(vha, eiter->a.fw_version);
 	alen = strlen(eiter->a.fw_version);
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
 
-	DEBUG13(printk("%s(%ld): FIRMWAREVER=%s.\n", __func__, ha->host_no,
+	DEBUG13(printk("%s(%ld): FIRMWAREVER=%s.\n", __func__, vha->host_no,
 	    eiter->a.fw_version));
 
 	/* Update MS request size. */
-	qla2x00_update_ms_fdmi_iocb(ha, size + 16);
+	qla2x00_update_ms_fdmi_iocb(vha, size + 16);
 
 	DEBUG13(printk("%s(%ld): RHBA identifier="
 	    "%02x%02x%02x%02x%02x%02x%02x%02x size=%d.\n", __func__,
-	    ha->host_no, ct_req->req.rhba.hba_identifier[0],
+	    vha->host_no, ct_req->req.rhba.hba_identifier[0],
 	    ct_req->req.rhba.hba_identifier[1],
 	    ct_req->req.rhba.hba_identifier[2],
 	    ct_req->req.rhba.hba_identifier[3],
@@ -1399,25 +1405,25 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *ha)
 	DEBUG13(qla2x00_dump_buffer(entries, size));
 
 	/* Execute MS IOCB */
-	rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
+	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
 	    sizeof(ms_iocb_entry_t));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3(printk("scsi(%ld): RHBA issue IOCB failed (%d).\n",
-		    ha->host_no, rval));
-	} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp, "RHBA") !=
+		    vha->host_no, rval));
+	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "RHBA") !=
 	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 		if (ct_rsp->header.reason_code == CT_REASON_CANNOT_PERFORM &&
 		    ct_rsp->header.explanation_code ==
 		    CT_EXPL_ALREADY_REGISTERED) {
 			DEBUG2_13(printk("%s(%ld): HBA already registered.\n",
-			    __func__, ha->host_no));
+			    __func__, vha->host_no));
 			rval = QLA_ALREADY_REGISTERED;
 		}
 	} else {
 		DEBUG2(printk("scsi(%ld): RHBA exiting normally.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -1430,17 +1436,17 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 static int
-qla2x00_fdmi_dhba(scsi_qla_host_t *ha)
+qla2x00_fdmi_dhba(scsi_qla_host_t *vha)
 {
 	int rval;
-
+	struct qla_hw_data *ha = vha->hw;
 	ms_iocb_entry_t *ms_pkt;
 	struct ct_sns_req *ct_req;
 	struct ct_sns_rsp *ct_rsp;
 
 	/* Issue RPA */
 	/* Prepare common MS IOCB */
-	ms_pkt = ha->isp_ops->prep_ms_fdmi_iocb(ha, DHBA_REQ_SIZE,
+	ms_pkt = ha->isp_ops->prep_ms_fdmi_iocb(vha, DHBA_REQ_SIZE,
 	    DHBA_RSP_SIZE);
 
 	/* Prepare CT request */
@@ -1449,28 +1455,28 @@ qla2x00_fdmi_dhba(scsi_qla_host_t *ha)
 	ct_rsp = &ha->ct_sns->p.rsp;
 
 	/* Prepare FDMI command arguments -- portname. */
-	memcpy(ct_req->req.dhba.port_name, ha->port_name, WWN_SIZE);
+	memcpy(ct_req->req.dhba.port_name, vha->port_name, WWN_SIZE);
 
 	DEBUG13(printk("%s(%ld): DHBA portname="
-	    "%02x%02x%02x%02x%02x%02x%02x%02x.\n", __func__, ha->host_no,
+	    "%02x%02x%02x%02x%02x%02x%02x%02x.\n", __func__, vha->host_no,
 	    ct_req->req.dhba.port_name[0], ct_req->req.dhba.port_name[1],
 	    ct_req->req.dhba.port_name[2], ct_req->req.dhba.port_name[3],
 	    ct_req->req.dhba.port_name[4], ct_req->req.dhba.port_name[5],
 	    ct_req->req.dhba.port_name[6], ct_req->req.dhba.port_name[7]));
 
 	/* Execute MS IOCB */
-	rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
+	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
 	    sizeof(ms_iocb_entry_t));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3(printk("scsi(%ld): DHBA issue IOCB failed (%d).\n",
-		    ha->host_no, rval));
-	} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp, "DHBA") !=
+		    vha->host_no, rval));
+	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "DHBA") !=
 	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		DEBUG2(printk("scsi(%ld): DHBA exiting normally.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -1483,11 +1489,11 @@ qla2x00_fdmi_dhba(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 static int
-qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
+qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 {
 	int rval, alen;
 	uint32_t size, max_frame_size;
-
+	struct qla_hw_data *ha = vha->hw;
 	ms_iocb_entry_t *ms_pkt;
 	struct ct_sns_req *ct_req;
 	struct ct_sns_rsp *ct_rsp;
@@ -1498,7 +1504,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 	/* Issue RPA */
 	/* Prepare common MS IOCB */
 	/*   Request size adjusted after CT preparation */
-	ms_pkt = ha->isp_ops->prep_ms_fdmi_iocb(ha, 0, RPA_RSP_SIZE);
+	ms_pkt = ha->isp_ops->prep_ms_fdmi_iocb(vha, 0, RPA_RSP_SIZE);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_fdmi_req(&ha->ct_sns->p.req, RPA_CMD,
@@ -1506,7 +1512,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 	ct_rsp = &ha->ct_sns->p.rsp;
 
 	/* Prepare FDMI command arguments -- attribute block, attributes. */
-	memcpy(ct_req->req.rpa.port_name, ha->port_name, WWN_SIZE);
+	memcpy(ct_req->req.rpa.port_name, vha->port_name, WWN_SIZE);
 	size = WWN_SIZE + 4;
 
 	/* Attributes */
@@ -1521,8 +1527,9 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 	eiter->a.fc4_types[2] = 0x01;
 	size += 4 + 32;
 
-	DEBUG13(printk("%s(%ld): FC4_TYPES=%02x %02x.\n", __func__, ha->host_no,
-	    eiter->a.fc4_types[2], eiter->a.fc4_types[1]));
+	DEBUG13(printk("%s(%ld): FC4_TYPES=%02x %02x.\n", __func__,
+		vha->host_no, eiter->a.fc4_types[2],
+		eiter->a.fc4_types[1]));
 
 	/* Supported speed. */
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
@@ -1544,7 +1551,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 		    FDMI_PORT_SPEED_1GB);
 	size += 4 + 4;
 
-	DEBUG13(printk("%s(%ld): SUPPORTED_SPEED=%x.\n", __func__, ha->host_no,
+	DEBUG13(printk("%s(%ld): SUPPORTED_SPEED=%x.\n", __func__, vha->host_no,
 	    eiter->a.sup_speed));
 
 	/* Current speed. */
@@ -1575,7 +1582,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 	}
 	size += 4 + 4;
 
-	DEBUG13(printk("%s(%ld): CURRENT_SPEED=%x.\n", __func__, ha->host_no,
+	DEBUG13(printk("%s(%ld): CURRENT_SPEED=%x.\n", __func__, vha->host_no,
 	    eiter->a.cur_speed));
 
 	/* Max frame size. */
@@ -1588,7 +1595,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 	eiter->a.max_frame_size = cpu_to_be32(max_frame_size);
 	size += 4 + 4;
 
-	DEBUG13(printk("%s(%ld): MAX_FRAME_SIZE=%x.\n", __func__, ha->host_no,
+	DEBUG13(printk("%s(%ld): MAX_FRAME_SIZE=%x.\n", __func__, vha->host_no,
 	    eiter->a.max_frame_size));
 
 	/* OS device name. */
@@ -1600,32 +1607,32 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
 
-	DEBUG13(printk("%s(%ld): OS_DEVICE_NAME=%s.\n", __func__, ha->host_no,
+	DEBUG13(printk("%s(%ld): OS_DEVICE_NAME=%s.\n", __func__, vha->host_no,
 	    eiter->a.os_dev_name));
 
 	/* Hostname. */
-	if (strlen(fc_host_system_hostname(ha->host))) {
+	if (strlen(fc_host_system_hostname(vha->host))) {
 		ct_req->req.rpa.attrs.count =
 		    __constant_cpu_to_be32(FDMI_PORT_ATTR_COUNT);
 		eiter = (struct ct_fdmi_port_attr *) (entries + size);
 		eiter->type = __constant_cpu_to_be16(FDMI_PORT_HOST_NAME);
 		snprintf(eiter->a.host_name, sizeof(eiter->a.host_name),
-		    "%s", fc_host_system_hostname(ha->host));
+		    "%s", fc_host_system_hostname(vha->host));
 		alen = strlen(eiter->a.host_name);
 		alen += (alen & 3) ? (4 - (alen & 3)) : 4;
 		eiter->len = cpu_to_be16(4 + alen);
 		size += 4 + alen;
 
 		DEBUG13(printk("%s(%ld): HOSTNAME=%s.\n", __func__,
-		    ha->host_no, eiter->a.host_name));
+		    vha->host_no, eiter->a.host_name));
 	}
 
 	/* Update MS request size. */
-	qla2x00_update_ms_fdmi_iocb(ha, size + 16);
+	qla2x00_update_ms_fdmi_iocb(vha, size + 16);
 
 	DEBUG13(printk("%s(%ld): RPA portname="
 	    "%02x%02x%02x%02x%02x%02x%02x%02x size=%d.\n", __func__,
-	    ha->host_no, ct_req->req.rpa.port_name[0],
+	    vha->host_no, ct_req->req.rpa.port_name[0],
 	    ct_req->req.rpa.port_name[1], ct_req->req.rpa.port_name[2],
 	    ct_req->req.rpa.port_name[3], ct_req->req.rpa.port_name[4],
 	    ct_req->req.rpa.port_name[5], ct_req->req.rpa.port_name[6],
@@ -1633,18 +1640,18 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 	DEBUG13(qla2x00_dump_buffer(entries, size));
 
 	/* Execute MS IOCB */
-	rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
+	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
 	    sizeof(ms_iocb_entry_t));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3(printk("scsi(%ld): RPA issue IOCB failed (%d).\n",
-		    ha->host_no, rval));
-	} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp, "RPA") !=
+		    vha->host_no, rval));
+	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "RPA") !=
 	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		DEBUG2(printk("scsi(%ld): RPA exiting normally.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -1657,34 +1664,34 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 int
-qla2x00_fdmi_register(scsi_qla_host_t *ha)
+qla2x00_fdmi_register(scsi_qla_host_t *vha)
 {
 	int rval;
 
-	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
+	if (IS_QLA2100(vha->hw) || IS_QLA2200(vha->hw)) {
 		DEBUG2(printk("scsi(%ld): FDMI unsupported on "
-		    "ISP2100/ISP2200.\n", ha->host_no));
+		    "ISP2100/ISP2200.\n", vha->host_no));
 		return QLA_SUCCESS;
 	}
 
-	rval = qla2x00_mgmt_svr_login(ha);
+	rval = qla2x00_mgmt_svr_login(vha);
 	if (rval)
 		return rval;
 
-	rval = qla2x00_fdmi_rhba(ha);
+	rval = qla2x00_fdmi_rhba(vha);
 	if (rval) {
 		if (rval != QLA_ALREADY_REGISTERED)
 			return rval;
 
-		rval = qla2x00_fdmi_dhba(ha);
+		rval = qla2x00_fdmi_dhba(vha);
 		if (rval)
 			return rval;
 
-		rval = qla2x00_fdmi_rhba(ha);
+		rval = qla2x00_fdmi_rhba(vha);
 		if (rval)
 			return rval;
 	}
-	rval = qla2x00_fdmi_rpa(ha);
+	rval = qla2x00_fdmi_rpa(vha);
 
 	return rval;
 }
@@ -1697,11 +1704,11 @@ qla2x00_fdmi_register(scsi_qla_host_t *ha)
  * Returns 0 on success.
  */
 int
-qla2x00_gfpn_id(scsi_qla_host_t *ha, sw_info_t *list)
+qla2x00_gfpn_id(scsi_qla_host_t *vha, sw_info_t *list)
 {
 	int		rval;
 	uint16_t	i;
-
+	struct qla_hw_data *ha = vha->hw;
 	ms_iocb_entry_t	*ms_pkt;
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
@@ -1712,7 +1719,7 @@ qla2x00_gfpn_id(scsi_qla_host_t *ha, sw_info_t *list)
 	for (i = 0; i < MAX_FIBRE_DEVICES; i++) {
 		/* Issue GFPN_ID */
 		/* Prepare common MS IOCB */
-		ms_pkt = ha->isp_ops->prep_ms_iocb(ha, GFPN_ID_REQ_SIZE,
+		ms_pkt = ha->isp_ops->prep_ms_iocb(vha, GFPN_ID_REQ_SIZE,
 		    GFPN_ID_RSP_SIZE);
 
 		/* Prepare CT request */
@@ -1726,13 +1733,13 @@ qla2x00_gfpn_id(scsi_qla_host_t *ha, sw_info_t *list)
 		ct_req->req.port_id.port_id[2] = list[i].d_id.b.al_pa;
 
 		/* Execute MS IOCB */
-		rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
+		rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
 		    sizeof(ms_iocb_entry_t));
 		if (rval != QLA_SUCCESS) {
 			/*EMPTY*/
 			DEBUG2_3(printk("scsi(%ld): GFPN_ID issue IOCB "
-			    "failed (%d).\n", ha->host_no, rval));
-		} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp,
+			    "failed (%d).\n", vha->host_no, rval));
+		} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp,
 		    "GFPN_ID") != QLA_SUCCESS) {
 			rval = QLA_FUNCTION_FAILED;
 		} else {
@@ -1750,17 +1757,17 @@ qla2x00_gfpn_id(scsi_qla_host_t *ha, sw_info_t *list)
 }
 
 static inline void *
-qla24xx_prep_ms_fm_iocb(scsi_qla_host_t *ha, uint32_t req_size,
+qla24xx_prep_ms_fm_iocb(scsi_qla_host_t *vha, uint32_t req_size,
     uint32_t rsp_size)
 {
 	struct ct_entry_24xx *ct_pkt;
-
+	struct qla_hw_data *ha = vha->hw;
 	ct_pkt = (struct ct_entry_24xx *)ha->ms_iocb;
 	memset(ct_pkt, 0, sizeof(struct ct_entry_24xx));
 
 	ct_pkt->entry_type = CT_IOCB_TYPE;
 	ct_pkt->entry_count = 1;
-	ct_pkt->nport_handle = cpu_to_le16(ha->mgmt_svr_loop_id);
+	ct_pkt->nport_handle = cpu_to_le16(vha->mgmt_svr_loop_id);
 	ct_pkt->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
 	ct_pkt->cmd_dsd_count = __constant_cpu_to_le16(1);
 	ct_pkt->rsp_dsd_count = __constant_cpu_to_le16(1);
@@ -1774,7 +1781,7 @@ qla24xx_prep_ms_fm_iocb(scsi_qla_host_t *ha, uint32_t req_size,
 	ct_pkt->dseg_1_address[0] = cpu_to_le32(LSD(ha->ct_sns_dma));
 	ct_pkt->dseg_1_address[1] = cpu_to_le32(MSD(ha->ct_sns_dma));
 	ct_pkt->dseg_1_len = ct_pkt->rsp_byte_count;
-	ct_pkt->vp_index = ha->vp_idx;
+	ct_pkt->vp_index = vha->vp_idx;
 
 	return ct_pkt;
 }
@@ -1803,11 +1810,11 @@ qla24xx_prep_ct_fm_req(struct ct_sns_req *ct_req, uint16_t cmd,
  * Returns 0 on success.
  */
 int
-qla2x00_gpsc(scsi_qla_host_t *ha, sw_info_t *list)
+qla2x00_gpsc(scsi_qla_host_t *vha, sw_info_t *list)
 {
 	int		rval;
 	uint16_t	i;
-
+	struct qla_hw_data *ha = vha->hw;
 	ms_iocb_entry_t	*ms_pkt;
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
@@ -1817,14 +1824,14 @@ qla2x00_gpsc(scsi_qla_host_t *ha, sw_info_t *list)
 	if (!ha->flags.gpsc_supported)
 		return QLA_FUNCTION_FAILED;
 
-	rval = qla2x00_mgmt_svr_login(ha);
+	rval = qla2x00_mgmt_svr_login(vha);
 	if (rval)
 		return rval;
 
 	for (i = 0; i < MAX_FIBRE_DEVICES; i++) {
 		/* Issue GFPN_ID */
 		/* Prepare common MS IOCB */
-		ms_pkt = qla24xx_prep_ms_fm_iocb(ha, GPSC_REQ_SIZE,
+		ms_pkt = qla24xx_prep_ms_fm_iocb(vha, GPSC_REQ_SIZE,
 		    GPSC_RSP_SIZE);
 
 		/* Prepare CT request */
@@ -1837,13 +1844,13 @@ qla2x00_gpsc(scsi_qla_host_t *ha, sw_info_t *list)
 		    WWN_SIZE);
 
 		/* Execute MS IOCB */
-		rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
+		rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
 		    sizeof(ms_iocb_entry_t));
 		if (rval != QLA_SUCCESS) {
 			/*EMPTY*/
 			DEBUG2_3(printk("scsi(%ld): GPSC issue IOCB "
-			    "failed (%d).\n", ha->host_no, rval));
-		} else if ((rval = qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp,
+			    "failed (%d).\n", vha->host_no, rval));
+		} else if ((rval = qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp,
 		    "GPSC")) != QLA_SUCCESS) {
 			/* FM command unsupported? */
 			if (rval == QLA_INVALID_COMMAND &&
@@ -1853,7 +1860,7 @@ qla2x00_gpsc(scsi_qla_host_t *ha, sw_info_t *list)
 				CT_REASON_COMMAND_UNSUPPORTED)) {
 				DEBUG2(printk("scsi(%ld): GPSC command "
 				    "unsupported, disabling query...\n",
-				    ha->host_no));
+				    vha->host_no));
 				ha->flags.gpsc_supported = 0;
 				rval = QLA_FUNCTION_FAILED;
 				break;
@@ -1878,7 +1885,7 @@ qla2x00_gpsc(scsi_qla_host_t *ha, sw_info_t *list)
 
 			DEBUG2_3(printk("scsi(%ld): GPSC ext entry - "
 			    "fpn %02x%02x%02x%02x%02x%02x%02x%02x speeds=%04x "
-			    "speed=%04x.\n", ha->host_no,
+			    "speed=%04x.\n", vha->host_no,
 			    list[i].fabric_port_name[0],
 			    list[i].fabric_port_name[1],
 			    list[i].fabric_port_name[2],
