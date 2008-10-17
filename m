From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: [PATCH 1/2] qla2xxx: Refactored qla data structure and functionss
Date: Thu, 16 Oct 2008 18:07:48 -0700 (PDT)
Message-ID: <alpine.OSX.1.00.0810161730130.857@n4012av9w19yf1.qlogic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:30976 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYJQBKO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Oct 2008 21:10:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org
Cc: linux-driver@qlogic.com

I have compressed the five patches I sent earlier into two. Please disregard my 
earlier patch series 0-5 under Code Refactoring subject line.
Following changes have been made to the qla2xxx FC driver in preparation for the 
multi- queue and future SR IOV hardware. 

1. scsi_qla_host structure has been changed to contain scsi host specific data only.
2. A new structure, qla_hw_data is created to contain HBA specific hardware data.
3. Request and response IO specific data strucures are created.
4. The global list of fcports for the hba is not maintained anymore, instead a 
fcport list is construted on per scsi_qla_host.

Thanks,
Anirban Chakraborty

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |  298 +++++++++-------
 drivers/scsi/qla2xxx/qla_dbg.c  |   61 ++--
 drivers/scsi/qla2xxx/qla_def.h  |  525 ++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_dfs.c  |   21 +-
 drivers/scsi/qla2xxx/qla_gbl.h  |   13 +-
 drivers/scsi/qla2xxx/qla_gs.c   |  479 +++++++++++++------------
 drivers/scsi/qla2xxx/qla_mbx.c  |  759 ++++++++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_mid.c  |  173 ++++------
 drivers/scsi/qla2xxx/qla_sup.c  |  537 ++++++++++++++-------------
 9 files changed, 1479 insertions(+), 1387 deletions(-)

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
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 83c8192..6dc45f0 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -185,7 +185,7 @@
  * SCSI Request Block
  */
 typedef struct srb {
-	struct scsi_qla_host *ha;	/* HA the SP is queued on */
+	struct scsi_qla_host *vha;	/* HA the SP is queued on */
 	struct fc_port *fcport;
 
 	struct scsi_cmnd *cmd;		/* Linux SCSI command pkt */
@@ -1524,7 +1524,7 @@ typedef struct {
  */
 typedef struct fc_port {
 	struct list_head list;
-	struct scsi_qla_host *ha;
+	struct scsi_qla_host *vha;
 
 	uint8_t node_name[WWN_SIZE];
 	uint8_t port_name[WWN_SIZE];
@@ -1550,7 +1550,6 @@ typedef struct fc_port {
 	unsigned long last_queue_full;
 	unsigned long last_ramp_up;
 
-	struct list_head vp_fcport;
 	uint16_t vp_idx;
 } fc_port_t;
 
@@ -2037,6 +2036,8 @@ typedef struct vport_params {
 #define VP_RET_CODE_NO_MEM		5
 #define VP_RET_CODE_NOT_FOUND		6
 
+struct qla_hw_data;
+
 /*
  * ISP operations
  */
@@ -2055,8 +2056,8 @@ struct isp_operations {
 	char * (*fw_version_str) (struct scsi_qla_host *, char *);
 
 	irq_handler_t intr_handler;
-	void (*enable_intrs) (struct scsi_qla_host *);
-	void (*disable_intrs) (struct scsi_qla_host *);
+	void (*enable_intrs) (struct qla_hw_data *);
+	void (*disable_intrs) (struct qla_hw_data *);
 
 	int (*abort_command) (struct scsi_qla_host *, srb_t *);
 	int (*target_reset) (struct fc_port *, unsigned int);
@@ -2089,6 +2090,7 @@ struct isp_operations {
 		uint32_t);
 
 	int (*get_flash_version) (struct scsi_qla_host *, void *);
+	int (*start_scsi) (srb_t *);
 };
 
 /* MSI-X Support *************************************************************/
@@ -2160,208 +2162,108 @@ struct qla_statistics {
 	uint64_t output_bytes;
 };
 
-/*
- * Linux Host Adapter structure
- */
-typedef struct scsi_qla_host {
-	struct list_head list;
+/* Response queue data structure */
+struct rsp_que {
+	dma_addr_t  dma;
+	response_t *ring;
+	response_t *ring_ptr;
+	uint16_t  ring_index;
+	uint16_t  out_ptr;
+	uint16_t  length;
+	uint16_t  options;
+	uint16_t  msix_vector;
+	uint16_t  rid;
+	struct qla_hw_data *hw;
+};
 
-	/* Commonly used flags and state information. */
-	struct Scsi_Host *host;
-	struct pci_dev	*pdev;
+/* Request queue data structure */
+struct req_que {
+	dma_addr_t  dma;
+	request_t *ring;
+	request_t *ring_ptr;
+	uint16_t  ring_index;
+	uint16_t  in_ptr;
+	uint16_t  cnt;
+	uint16_t  length;
+	uint16_t  options;
+	uint16_t  rid;
+	uint16_t  qos;
+	uint16_t  vp_idx;
+	struct rsp_que *asso_que;
+	/* Outstandings ISP commands. */
+	srb_t *outstanding_cmds[MAX_OUTSTANDING_COMMANDS];
+	uint32_t current_outstanding_cmd;
+	int max_q_depth;
+};
 
-	unsigned long	host_no;
+/*
+ * Qlogic host adapter specific data structure.
+*/
+struct qla_hw_data {
+	struct pci_dev  *pdev;
+	/* SRB cache. */
+#define SRB_MIN_REQ     128
+	mempool_t       *srb_mempool;
 
 	volatile struct {
-		uint32_t	init_done		:1;
-		uint32_t	online			:1;
 		uint32_t	mbox_int		:1;
 		uint32_t	mbox_busy		:1;
-		uint32_t	rscn_queue_overflow	:1;
-		uint32_t	reset_active		:1;
-
-		uint32_t	management_server_logged_in :1;
-                uint32_t	process_response_queue	:1;
 
 		uint32_t	disable_risc_code_load	:1;
 		uint32_t	enable_64bit_addressing	:1;
 		uint32_t	enable_lip_reset	:1;
-		uint32_t	enable_lip_full_login	:1;
 		uint32_t	enable_target_reset	:1;
+		uint32_t	enable_lip_full_login	:1;
 		uint32_t	enable_led_scheme	:1;
 		uint32_t	inta_enabled		:1;
 		uint32_t	msi_enabled		:1;
 		uint32_t	msix_enabled		:1;
 		uint32_t	disable_serdes		:1;
 		uint32_t	gpsc_supported		:1;
-		uint32_t        vsan_enabled            :1;
+		uint32_t	vsan_enabled		:1;
 		uint32_t	npiv_supported		:1;
 		uint32_t	fce_enabled		:1;
-		uint32_t	hw_event_marker_found	:1;
+		uint32_t	hw_event_marker_found:1;
 	} flags;
 
-	atomic_t	loop_state;
-#define LOOP_TIMEOUT	1
-#define LOOP_DOWN	2
-#define LOOP_UP		3
-#define LOOP_UPDATE	4
-#define LOOP_READY	5
-#define LOOP_DEAD	6
-
-	unsigned long   dpc_flags;
-#define	RESET_MARKER_NEEDED	0	/* Send marker to ISP. */
-#define	RESET_ACTIVE		1
-#define	ISP_ABORT_NEEDED	2	/* Initiate ISP abort. */
-#define	ABORT_ISP_ACTIVE	3	/* ISP abort in progress. */
-#define	LOOP_RESYNC_NEEDED	4	/* Device Resync needed. */
-#define	LOOP_RESYNC_ACTIVE	5
-#define LOCAL_LOOP_UPDATE       6	/* Perform a local loop update. */
-#define RSCN_UPDATE             7	/* Perform an RSCN update. */
-#define MAILBOX_RETRY           8
-#define ISP_RESET_NEEDED        9	/* Initiate a ISP reset. */
-#define FAILOVER_EVENT_NEEDED   10
-#define FAILOVER_EVENT		11
-#define FAILOVER_NEEDED   	12
-#define SCSI_RESTART_NEEDED	13	/* Processes SCSI retry queue. */
-#define PORT_RESTART_NEEDED	14	/* Processes Retry queue. */
-#define RESTART_QUEUES_NEEDED	15	/* Restarts the Lun queue. */
-#define ABORT_QUEUES_NEEDED	16
-#define RELOGIN_NEEDED	        17
-#define LOGIN_RETRY_NEEDED	18	/* Initiate required fabric logins. */
-#define REGISTER_FC4_NEEDED	19	/* SNS FC4 registration required. */
-#define ISP_ABORT_RETRY         20      /* ISP aborted. */
-#define FCPORT_RESCAN_NEEDED	21      /* IO descriptor processing needed */
-#define IODESC_PROCESS_NEEDED	22      /* IO descriptor processing needed */
-#define IOCTL_ERROR_RECOVERY	23
-#define LOOP_RESET_NEEDED	24
-#define BEACON_BLINK_NEEDED	25
-#define REGISTER_FDMI_NEEDED	26
-#define FCPORT_UPDATE_NEEDED	27
-#define VP_DPC_NEEDED		28	/* wake up for VP dpc handling */
-#define UNLOADING		29
-#define NPIV_CONFIG_NEEDED	30
-
-	uint32_t	device_flags;
-#define DFLG_LOCAL_DEVICES		BIT_0
-#define DFLG_RETRY_LOCAL_DEVICES	BIT_1
-#define DFLG_FABRIC_DEVICES		BIT_2
-#define	SWITCH_FOUND			BIT_3
-#define	DFLG_NO_CABLE			BIT_4
-
-#define PCI_DEVICE_ID_QLOGIC_ISP2532	0x2532
-#define PCI_DEVICE_ID_QLOGIC_ISP8432	0x8432
-	uint32_t	device_type;
-#define DT_ISP2100			BIT_0
-#define DT_ISP2200			BIT_1
-#define DT_ISP2300			BIT_2
-#define DT_ISP2312			BIT_3
-#define DT_ISP2322			BIT_4
-#define DT_ISP6312			BIT_5
-#define DT_ISP6322			BIT_6
-#define DT_ISP2422			BIT_7
-#define DT_ISP2432			BIT_8
-#define DT_ISP5422			BIT_9
-#define DT_ISP5432			BIT_10
-#define DT_ISP2532			BIT_11
-#define DT_ISP8432			BIT_12
-#define DT_ISP_LAST			(DT_ISP8432 << 1)
-
-#define DT_IIDMA			BIT_26
-#define DT_FWI2				BIT_27
-#define DT_ZIO_SUPPORTED		BIT_28
-#define DT_OEM_001			BIT_29
-#define DT_ISP2200A			BIT_30
-#define DT_EXTENDED_IDS			BIT_31
-
-#define DT_MASK(ha)	((ha)->device_type & (DT_ISP_LAST - 1))
-#define IS_QLA2100(ha)	(DT_MASK(ha) & DT_ISP2100)
-#define IS_QLA2200(ha)	(DT_MASK(ha) & DT_ISP2200)
-#define IS_QLA2300(ha)	(DT_MASK(ha) & DT_ISP2300)
-#define IS_QLA2312(ha)	(DT_MASK(ha) & DT_ISP2312)
-#define IS_QLA2322(ha)	(DT_MASK(ha) & DT_ISP2322)
-#define IS_QLA6312(ha)	(DT_MASK(ha) & DT_ISP6312)
-#define IS_QLA6322(ha)	(DT_MASK(ha) & DT_ISP6322)
-#define IS_QLA2422(ha)	(DT_MASK(ha) & DT_ISP2422)
-#define IS_QLA2432(ha)	(DT_MASK(ha) & DT_ISP2432)
-#define IS_QLA5422(ha)	(DT_MASK(ha) & DT_ISP5422)
-#define IS_QLA5432(ha)	(DT_MASK(ha) & DT_ISP5432)
-#define IS_QLA2532(ha)	(DT_MASK(ha) & DT_ISP2532)
-#define IS_QLA8432(ha)	(DT_MASK(ha) & DT_ISP8432)
-
-#define IS_QLA23XX(ha)	(IS_QLA2300(ha) || IS_QLA2312(ha) || IS_QLA2322(ha) || \
-    			 IS_QLA6312(ha) || IS_QLA6322(ha))
-#define IS_QLA24XX(ha)	(IS_QLA2422(ha) || IS_QLA2432(ha))
-#define IS_QLA54XX(ha)	(IS_QLA5422(ha) || IS_QLA5432(ha))
-#define IS_QLA25XX(ha)	(IS_QLA2532(ha))
-#define IS_QLA84XX(ha)	(IS_QLA8432(ha))
-#define IS_QLA24XX_TYPE(ha)	(IS_QLA24XX(ha) || IS_QLA54XX(ha) || \
-			IS_QLA84XX(ha))
-
-#define IS_IIDMA_CAPABLE(ha)	((ha)->device_type & DT_IIDMA)
-#define IS_FWI2_CAPABLE(ha)	((ha)->device_type & DT_FWI2)
-#define IS_ZIO_SUPPORTED(ha)	((ha)->device_type & DT_ZIO_SUPPORTED)
-#define IS_OEM_001(ha)		((ha)->device_type & DT_OEM_001)
-#define HAS_EXTENDED_IDS(ha)	((ha)->device_type & DT_EXTENDED_IDS)
-
-	/* SRB cache. */
-#define SRB_MIN_REQ	128
-	mempool_t	*srb_mempool;
-
 	/* This spinlock is used to protect "io transactions", you must
-	 * acquire it before doing any IO to the card, eg with RD_REG*() and
-	 * WRT_REG*() for the duration of your entire commandtransaction.
-	 *
-	 * This spinlock is of lower priority than the io request lock.
-	 */
-
-	spinlock_t		hardware_lock ____cacheline_aligned;
+	* acquire it before doing any IO to the card, eg with RD_REG*() and
+	* WRT_REG*() for the duration of your entire commandtransaction.
+	*
+	* This spinlock is of lower priority than the io request lock.
+	*/
 
+	spinlock_t	hardware_lock ____cacheline_aligned;
 	int		bars;
 	int		mem_only;
-	device_reg_t __iomem *iobase;		/* Base I/O address */
+	device_reg_t __iomem *iobase;           /* Base I/O address */
 	resource_size_t pio_address;
-#define MIN_IOBASE_LEN		0x100
-
-	/* ISP ring lock, rings, and indexes */
-	dma_addr_t	request_dma;        /* Physical address. */
-	request_t       *request_ring;      /* Base virtual address */
-	request_t       *request_ring_ptr;  /* Current address. */
-	uint16_t        req_ring_index;     /* Current index. */
-	uint16_t        req_q_cnt;          /* Number of available entries. */
-	uint16_t	request_q_length;
-
-	dma_addr_t	response_dma;       /* Physical address. */
-	response_t      *response_ring;     /* Base virtual address */
-	response_t      *response_ring_ptr; /* Current address. */
-	uint16_t        rsp_ring_index;     /* Current index. */
-	uint16_t	response_q_length;
 
-	struct isp_operations *isp_ops;
+#define MIN_IOBASE_LEN          0x100
+	struct req_que *req;
+	struct rsp_que *rsp;
 
-	/* Outstandings ISP commands. */
-	srb_t		*outstanding_cmds[MAX_OUTSTANDING_COMMANDS];
-	uint32_t	current_outstanding_cmd;
-	srb_t		*status_srb;	/* Status continuation entry. */
+	uint16_t        switch_cap;
+#define FLOGI_SEQ_DEL           BIT_8
+#define FLOGI_MID_SUPPORT       BIT_10
+#define FLOGI_VSAN_SUPPORT      BIT_12
+#define FLOGI_SP_SUPPORT        BIT_13
+	/* Timeout timers. */
+	uint8_t 	loop_down_abort_time;    /* port down timer */
+	atomic_t	loop_down_timer;         /* loop down timer */
+	uint8_t		link_down_timeout;       /* link down timeout */
+	uint16_t	max_loop_id;
 
-	/* ISP configuration data. */
-	uint16_t	loop_id;		/* Host adapter loop id */
-	uint16_t	switch_cap;
-#define FLOGI_SEQ_DEL		BIT_8
-#define FLOGI_MID_SUPPORT	BIT_10
-#define FLOGI_VSAN_SUPPORT	BIT_12
-#define FLOGI_SP_SUPPORT	BIT_13
 	uint16_t	fb_rev;
-
-	port_id_t	d_id;			/* Host adapter port id */
 	uint16_t	max_public_loop_ids;
-	uint16_t	min_external_loopid;	/* First external loop Id */
+	uint16_t	min_external_loopid;    /* First external loop Id */
 
 #define PORT_SPEED_UNKNOWN 0xFFFF
-#define PORT_SPEED_1GB	0x00
-#define PORT_SPEED_2GB	0x01
-#define PORT_SPEED_4GB	0x03
-#define PORT_SPEED_8GB	0x04
-	uint16_t	link_data_rate;		/* F/W operating speed */
+#define PORT_SPEED_1GB  0x00
+#define PORT_SPEED_2GB  0x01
+#define PORT_SPEED_4GB  0x03
+#define PORT_SPEED_8GB  0x04
+	uint16_t	link_data_rate;         /* F/W operating speed */
 
 	uint8_t		current_topology;
 	uint8_t		prev_topology;
@@ -2370,15 +2272,69 @@ typedef struct scsi_qla_host {
 #define ISP_CFG_FL	4
 #define ISP_CFG_F	8
 
-	uint8_t		operating_mode;		/* F/W operating mode */
+	uint8_t		operating_mode;         /* F/W operating mode */
 #define LOOP      0
 #define P2P       1
 #define LOOP_P2P  2
 #define P2P_LOOP  3
-
-        uint8_t		marker_needed;
-
 	uint8_t		interrupts_on;
+	uint32_t	isp_abort_cnt;
+
+#define PCI_DEVICE_ID_QLOGIC_ISP2532    0x2532
+#define PCI_DEVICE_ID_QLOGIC_ISP8432    0x8432
+	uint32_t	device_type;
+#define DT_ISP2100                      BIT_0
+#define DT_ISP2200                      BIT_1
+#define DT_ISP2300                      BIT_2
+#define DT_ISP2312                      BIT_3
+#define DT_ISP2322                      BIT_4
+#define DT_ISP6312                      BIT_5
+#define DT_ISP6322                      BIT_6
+#define DT_ISP2422                      BIT_7
+#define DT_ISP2432                      BIT_8
+#define DT_ISP5422                      BIT_9
+#define DT_ISP5432                      BIT_10
+#define DT_ISP2532                      BIT_11
+#define DT_ISP8432                      BIT_12
+#define DT_ISP_LAST                     (DT_ISP8432 << 1)
+
+#define DT_IIDMA                        BIT_26
+#define DT_FWI2                         BIT_27
+#define DT_ZIO_SUPPORTED                BIT_28
+#define DT_OEM_001                      BIT_29
+#define DT_ISP2200A                     BIT_30
+#define DT_EXTENDED_IDS                 BIT_31
+#define DT_MASK(ha)     ((ha)->device_type & (DT_ISP_LAST - 1))
+#define IS_QLA2100(ha)  (DT_MASK(ha) & DT_ISP2100)
+#define IS_QLA2200(ha)  (DT_MASK(ha) & DT_ISP2200)
+#define IS_QLA2300(ha)  (DT_MASK(ha) & DT_ISP2300)
+#define IS_QLA2312(ha)  (DT_MASK(ha) & DT_ISP2312)
+#define IS_QLA2322(ha)  (DT_MASK(ha) & DT_ISP2322)
+#define IS_QLA6312(ha)  (DT_MASK(ha) & DT_ISP6312)
+#define IS_QLA6322(ha)  (DT_MASK(ha) & DT_ISP6322)
+#define IS_QLA2422(ha)  (DT_MASK(ha) & DT_ISP2422)
+#define IS_QLA2432(ha)  (DT_MASK(ha) & DT_ISP2432)
+#define IS_QLA5422(ha)  (DT_MASK(ha) & DT_ISP5422)
+#define IS_QLA5432(ha)  (DT_MASK(ha) & DT_ISP5432)
+#define IS_QLA2532(ha)  (DT_MASK(ha) & DT_ISP2532)
+#define IS_QLA8432(ha)  (DT_MASK(ha) & DT_ISP8432)
+
+#define IS_QLA23XX(ha)  (IS_QLA2300(ha) || IS_QLA2312(ha) || IS_QLA2322(ha) || \
+			IS_QLA6312(ha) || IS_QLA6322(ha))
+#define IS_QLA24XX(ha)  (IS_QLA2422(ha) || IS_QLA2432(ha))
+#define IS_QLA54XX(ha)  (IS_QLA5422(ha) || IS_QLA5432(ha))
+#define IS_QLA25XX(ha)  (IS_QLA2532(ha))
+#define IS_QLA84XX(ha)  (IS_QLA8432(ha))
+#define IS_QLA24XX_TYPE(ha)     (IS_QLA24XX(ha) || IS_QLA54XX(ha) || \
+				IS_QLA84XX(ha))
+#define IS_QLA2XXX_MIDTYPE(ha)	(IS_QLA24XX(ha) || IS_QLA84XX(ha) || \
+				IS_QLA25XX(ha))
+
+#define IS_IIDMA_CAPABLE(ha)    ((ha)->device_type & DT_IIDMA)
+#define IS_FWI2_CAPABLE(ha)     ((ha)->device_type & DT_FWI2)
+#define IS_ZIO_SUPPORTED(ha)    ((ha)->device_type & DT_ZIO_SUPPORTED)
+#define IS_OEM_001(ha)          ((ha)->device_type & DT_OEM_001)
+#define HAS_EXTENDED_IDS(ha)    ((ha)->device_type & DT_EXTENDED_IDS)
 
 	/* HBA serial number */
 	uint8_t		serial0;
@@ -2386,8 +2342,8 @@ typedef struct scsi_qla_host {
 	uint8_t		serial2;
 
 	/* NVRAM configuration data */
-#define MAX_NVRAM_SIZE	4096
-#define VPD_OFFSET	MAX_NVRAM_SIZE / 2
+#define MAX_NVRAM_SIZE  4096
+#define VPD_OFFSET      MAX_NVRAM_SIZE / 2
 	uint16_t	nvram_size;
 	uint16_t	nvram_base;
 	void		*nvram;
@@ -2401,22 +2357,8 @@ typedef struct scsi_qla_host {
 	uint16_t	r_a_tov;
 	int		port_down_retry_count;
 	uint8_t		mbx_count;
-	uint16_t	last_loop_id;
-	uint16_t	mgmt_svr_loop_id;
-
-        uint32_t	login_retry_count;
-	int		max_q_depth;
-
-	struct list_head	work_list;
-
-	/* Fibre Channel Device List. */
-	struct list_head	fcports;
-
-	/* RSCN queue. */
-	uint32_t rscn_queue[MAX_RSCN_COUNT];
-	uint8_t rscn_in_ptr;
-	uint8_t rscn_out_ptr;
 
+	uint32_t	login_retry_count;
 	/* SNS command interfaces. */
 	ms_iocb_entry_t		*ms_iocb;
 	dma_addr_t		ms_iocb_dma;
@@ -2426,28 +2368,20 @@ typedef struct scsi_qla_host {
 	struct sns_cmd_pkt	*sns_cmd;
 	dma_addr_t		sns_cmd_dma;
 
-#define SFP_DEV_SIZE	256
-#define SFP_BLOCK_SIZE	64
-	void			*sfp_data;
-	dma_addr_t		sfp_data_dma;
+#define SFP_DEV_SIZE    256
+#define SFP_BLOCK_SIZE  64
+	void		*sfp_data;
+	dma_addr_t	sfp_data_dma;
 
 	struct task_struct	*dpc_thread;
 	uint8_t dpc_active;                  /* DPC routine is active */
 
-	/* Timeout timers. */
-	uint8_t         loop_down_abort_time;    /* port down timer */
-	atomic_t        loop_down_timer;         /* loop down timer */
-	uint8_t         link_down_timeout;       /* link down timeout */
-
-	uint32_t        timer_active;
-	struct timer_list        timer;
-
 	dma_addr_t	gid_list_dma;
 	struct gid_list_info *gid_list;
 	int		gid_list_info_size;
 
 	/* Small DMA pool allocations -- maximum 256 bytes in length. */
-#define DMA_POOL_SIZE	256
+#define DMA_POOL_SIZE   256
 	struct dma_pool *s_dma_pool;
 
 	dma_addr_t	init_cb_dma;
@@ -2459,17 +2393,17 @@ typedef struct scsi_qla_host {
 
 	mbx_cmd_t	*mcp;
 	unsigned long	mbx_cmd_flags;
-#define MBX_INTERRUPT	1
-#define MBX_INTR_WAIT	2
+#define MBX_INTERRUPT		1
+#define MBX_INTR_WAIT		2
 #define MBX_UPDATE_FLASH_ACTIVE	3
 
-	struct mutex vport_lock;	/* Virtual port synchronization */
-	struct completion mbx_cmd_comp;	/* Serialize mbx access */
+	struct mutex vport_lock;        /* Virtual port synchronization */
+	struct completion mbx_cmd_comp; /* Serialize mbx access */
 	struct completion mbx_intr_comp;  /* Used for completion notification */
 
 	uint32_t	mbx_flags;
 #define  MBX_IN_PROGRESS	BIT_0
-#define  MBX_BUSY		BIT_1	/* Got the Access */
+#define  MBX_BUSY		BIT_1   /* Got the Access */
 #define  MBX_SLEEPING_ON_SEM	BIT_2
 #define  MBX_POLLING_FOR_COMP	BIT_3
 #define  MBX_COMPLETED		BIT_4
@@ -2488,7 +2422,7 @@ typedef struct scsi_qla_host {
 #define RISC_START_ADDRESS_2300 0x800
 #define RISC_START_ADDRESS_2400 0x100000
 
-	uint16_t	fw_options[16];		/* slots: 1,2,3,10,11 */
+	uint16_t	fw_options[16];         /* slots: 1,2,3,10,11 */
 	uint8_t		fw_seriallink_options[4];
 	uint16_t	fw_seriallink_options24[4];
 
@@ -2509,10 +2443,10 @@ typedef struct scsi_qla_host {
 	uint64_t	fce_wr, fce_rd;
 	struct mutex	fce_mutex;
 
+	uint32_t	hw_event_start;
 	uint32_t	hw_event_ptr;
 	uint32_t	hw_event_pause_errors;
 
-	uint8_t		host_str[16];
 	uint32_t	pci_attr;
 	uint16_t	chip_revision;
 
@@ -2523,11 +2457,6 @@ typedef struct scsi_qla_host {
 	char		model_desc[80];
 	uint8_t		adapter_id[16+1];
 
-	uint8_t		*node_name;
-	uint8_t		*port_name;
-	uint8_t		fabric_node_name[WWN_SIZE];
-	uint32_t    isp_abort_cnt;
-
 	/* Option ROM information. */
 	char		*optrom_buffer;
 	uint32_t	optrom_size;
@@ -2538,13 +2467,13 @@ typedef struct scsi_qla_host {
 	uint32_t	optrom_region_start;
 	uint32_t	optrom_region_size;
 
-        /* PCI expansion ROM image information. */
+/* PCI expansion ROM image information. */
 #define ROM_CODE_TYPE_BIOS	0
 #define ROM_CODE_TYPE_FCODE	1
 #define ROM_CODE_TYPE_EFI	3
-	uint8_t		bios_revision[2];
-	uint8_t		efi_revision[2];
-	uint8_t		fcode_revision[16];
+	uint8_t 	bios_revision[2];
+	uint8_t 	efi_revision[2];
+	uint8_t 	fcode_revision[16];
 	uint32_t	fw_revision[4];
 
 	uint16_t	fdt_odd_index;
@@ -2554,39 +2483,145 @@ typedef struct scsi_qla_host {
 	uint32_t	fdt_unprotect_sec_cmd;
 	uint32_t	fdt_protect_sec_cmd;
 
-	uint32_t	flt_region_flt;
-	uint32_t	flt_region_fdt;
-	uint32_t	flt_region_boot;
-	uint32_t	flt_region_fw;
-	uint32_t	flt_region_vpd_nvram;
-	uint32_t	flt_region_hw_event;
-	uint32_t	flt_region_npiv_conf;
+	uint32_t        flt_region_flt;
+	uint32_t        flt_region_fdt;
+	uint32_t        flt_region_boot;
+	uint32_t        flt_region_fw;
+	uint32_t        flt_region_vpd_nvram;
+	uint32_t        flt_region_hw_event;
+	uint32_t        flt_region_npiv_conf;
 
 	/* Needed for BEACON */
-	uint16_t	beacon_blink_led;
-	uint8_t		beacon_color_state;
+	uint16_t        beacon_blink_led;
+	uint8_t         beacon_color_state;
 #define QLA_LED_GRN_ON		0x01
 #define QLA_LED_YLW_ON		0x02
 #define QLA_LED_ABR_ON		0x04
 #define QLA_LED_ALL_ON		0x07	/* yellow, green, amber. */
 					/* ISP2322: red, green, amber. */
-
-	uint16_t	zio_mode;
-	uint16_t	zio_timer;
+	uint16_t        zio_mode;
+	uint16_t        zio_timer;
 	struct fc_host_statistics fc_host_stat;
 
 	struct qla_msix_entry msix_entries[QLA_MSIX_ENTRIES];
 
-	struct list_head	vp_list;	/* list of VP */
+	struct list_head        vp_list;        /* list of VP */
+	unsigned long   vp_idx_map[(MAX_MULTI_ID_FABRIC / 8) /
+			sizeof(unsigned long)];
+	uint16_t        num_vhosts;     /* number of vports created */
+	uint16_t        num_vsans;      /* number of vsan created */
+	uint16_t        max_npiv_vports;        /* 63 or 125 per topoloty */
+	int             cur_vport_count;
+
+	struct qla_chip_state_84xx *cs84xx;
+	struct qla_statistics qla_stats;
+	struct isp_operations *isp_ops;
+};
+
+/*
+ * Qlogic scsi host structure
+ */
+typedef struct scsi_qla_host {
+	struct list_head list;
+	struct list_head vp_fcports;	/* list of fcports */
+	struct list_head work_list;
+
+	/* Commonly used flags and state information. */
+	struct Scsi_Host *host;
+	unsigned long	host_no;
+	uint8_t		host_str[16];
+
+	volatile struct {
+		uint32_t	init_done		:1;
+		uint32_t	online			:1;
+		uint32_t	rscn_queue_overflow	:1;
+		uint32_t	reset_active		:1;
+
+		uint32_t	management_server_logged_in :1;
+		uint32_t	process_response_queue	:1;
+	} flags;
+
+	atomic_t	loop_state;
+#define LOOP_TIMEOUT	1
+#define LOOP_DOWN	2
+#define LOOP_UP		3
+#define LOOP_UPDATE	4
+#define LOOP_READY	5
+#define LOOP_DEAD	6
+
+	unsigned long   dpc_flags;
+#define RESET_MARKER_NEEDED	0	/* Send marker to ISP. */
+#define RESET_ACTIVE		1
+#define ISP_ABORT_NEEDED	2	/* Initiate ISP abort. */
+#define ABORT_ISP_ACTIVE	3	/* ISP abort in progress. */
+#define LOOP_RESYNC_NEEDED	4	/* Device Resync needed. */
+#define LOOP_RESYNC_ACTIVE	5
+#define LOCAL_LOOP_UPDATE	6	/* Perform a local loop update. */
+#define RSCN_UPDATE		7	/* Perform an RSCN update. */
+#define MAILBOX_RETRY		8
+#define ISP_RESET_NEEDED	9	/* Initiate a ISP reset. */
+#define FAILOVER_EVENT_NEEDED	10
+#define FAILOVER_EVENT		11
+#define FAILOVER_NEEDED		12
+#define SCSI_RESTART_NEEDED	13	/* Processes SCSI retry queue. */
+#define PORT_RESTART_NEEDED	14	/* Processes Retry queue. */
+#define RESTART_QUEUES_NEEDED	15	/* Restarts the Lun queue. */
+#define ABORT_QUEUES_NEEDED	16
+#define RELOGIN_NEEDED		17
+#define LOGIN_RETRY_NEEDED	18	/* Initiate required fabric logins. */
+#define REGISTER_FC4_NEEDED	19	/* SNS FC4 registration required. */
+#define ISP_ABORT_RETRY		20	/* ISP aborted. */
+#define FCPORT_RESCAN_NEEDED	21	/* IO descriptor processing needed */
+#define IODESC_PROCESS_NEEDED	22	/* IO descriptor processing needed */
+#define IOCTL_ERROR_RECOVERY	23
+#define LOOP_RESET_NEEDED	24
+#define BEACON_BLINK_NEEDED	25
+#define REGISTER_FDMI_NEEDED	26
+#define FCPORT_UPDATE_NEEDED	27
+#define VP_DPC_NEEDED		28	/* wake up for VP dpc handling */
+#define UNLOADING		29
+#define NPIV_CONFIG_NEEDED	30
+
+	uint32_t	device_flags;
+#define DFLG_LOCAL_DEVICES		BIT_0
+#define DFLG_RETRY_LOCAL_DEVICES	BIT_1
+#define DFLG_FABRIC_DEVICES		BIT_2
+#define SWITCH_FOUND			BIT_3
+#define DFLG_NO_CABLE			BIT_4
+
+	srb_t		*status_srb;	/* Status continuation entry. */
+
+	/* ISP configuration data. */
+	uint16_t	loop_id;		/* Host adapter loop id */
+
+	port_id_t	d_id;			/* Host adapter port id */
+	uint8_t		marker_needed;
+	uint16_t	mgmt_svr_loop_id;
+
+
+
+	/* RSCN queue. */
+	uint32_t rscn_queue[MAX_RSCN_COUNT];
+	uint8_t rscn_in_ptr;
+	uint8_t rscn_out_ptr;
+
+	/* Timeout timers. */
+	uint8_t         loop_down_abort_time;    /* port down timer */
+	atomic_t        loop_down_timer;         /* loop down timer */
+	uint8_t         link_down_timeout;       /* link down timeout */
+
+	uint32_t        timer_active;
+	struct timer_list        timer;
+
+	uint8_t		node_name[WWN_SIZE];
+	uint8_t		port_name[WWN_SIZE];
+	uint8_t		fabric_node_name[WWN_SIZE];
+	uint32_t   	vp_abort_cnt;
+
 	struct fc_vport	*fc_vport;	/* holds fc_vport * for each vport */
-	unsigned long	vp_idx_map[(MAX_MULTI_ID_FABRIC / 8) / sizeof(unsigned long)];
-	uint16_t        num_vhosts;	/* number of vports created */
-	uint16_t        num_vsans;	/* number of vsan created */
 	uint16_t        vp_idx;		/* vport ID */
 
-	struct scsi_qla_host	*parent;	/* holds pport */
 	unsigned long		vp_flags;
-	struct list_head	vp_fcports;	/* list of fcports */
 #define VP_IDX_ACQUIRED		0	/* bit no 0 */
 #define VP_CREATE_NEEDED	1
 #define VP_BIND_NEEDED		2
@@ -2605,11 +2640,7 @@ typedef struct scsi_qla_host {
 #define VP_ERR_FAB_NORESOURCES	3
 #define VP_ERR_FAB_LOGOUT	4
 #define VP_ERR_ADAP_NORESOURCES	5
-	uint16_t	max_npiv_vports;	/* 63 or 125 per topoloty */
-	int		cur_vport_count;
-
-	struct qla_chip_state_84xx *cs84xx;
-	struct qla_statistics qla_stats;
+	struct qla_hw_data *hw;
 } scsi_qla_host_t;
 
 
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
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 753dbe6..c0cc686 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -72,7 +72,10 @@ extern int qla2x00_post_hwe_work(struct scsi_qla_host *, uint16_t , uint16_t,
     uint16_t, uint16_t);
 
 extern void qla2x00_abort_fcport_cmds(fc_port_t *);
-
+extern struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *,
+	struct qla_hw_data *);
+extern void qla2x00_free_host(struct scsi_qla_host *);
+extern void qla2x00_relogin(struct scsi_qla_host *);
 /*
  * Global Functions in qla_mid.c source file.
  */
@@ -105,10 +108,10 @@ extern struct fw_blob *qla2x00_request_firmware(scsi_qla_host_t *);
 
 extern int qla2x00_wait_for_hba_online(scsi_qla_host_t *);
 
-extern void qla2xxx_wake_dpc(scsi_qla_host_t *);
-extern void qla2x00_alert_all_vps(scsi_qla_host_t *, uint16_t *);
+extern void qla2xxx_wake_dpc(struct scsi_qla_host *);
+extern void qla2x00_alert_all_vps(struct qla_hw_data *, uint16_t *);
 extern void qla2x00_async_event(scsi_qla_host_t *, uint16_t *);
-extern void qla2x00_vp_abort_isp(scsi_qla_host_t *);
+extern int  qla2x00_vp_abort_isp(scsi_qla_host_t *);
 
 /*
  * Global Function Prototypes in qla_iocb.c source file.
@@ -267,7 +270,7 @@ extern irqreturn_t qla24xx_intr_handler(int, void *);
 extern void qla2x00_process_response_queue(struct scsi_qla_host *);
 extern void qla24xx_process_response_queue(struct scsi_qla_host *);
 
-extern int qla2x00_request_irqs(scsi_qla_host_t *);
+extern int qla2x00_request_irqs(struct qla_hw_data *);
 extern void qla2x00_free_irqs(scsi_qla_host_t *);
 
 /*
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
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 36bc685..f65b629 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -29,7 +29,7 @@
  *	Kernel context.
  */
 static int
-qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
+qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 {
 	int		rval;
 	unsigned long    flags = 0;
@@ -42,15 +42,16 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 	uint32_t	cnt;
 	uint32_t	mboxes;
 	unsigned long	wait_time;
-	scsi_qla_host_t *ha = to_qla_parent(pvha);
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	reg = ha->iobase;
-	io_lock_on = ha->flags.init_done;
+	io_lock_on = base_vha->flags.init_done;
 
 	rval = QLA_SUCCESS;
-	abort_active = test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
+	abort_active = test_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, pvha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, base_vha->host_no));
 
 	/*
 	 * Wait for active mailbox commands to finish by waiting at most tov
@@ -62,7 +63,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 		    mcp->tov * HZ)) {
 			/* Timeout occurred. Return error. */
 			DEBUG2_3_11(printk("%s(%ld): cmd access timeout. "
-			    "Exiting.\n", __func__, ha->host_no));
+			    "Exiting.\n", __func__, base_vha->host_no));
 			return QLA_FUNCTION_TIMEOUT;
 		}
 	}
@@ -72,7 +73,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 	ha->mcp = mcp;
 
 	DEBUG11(printk("scsi(%ld): prepare to issue mbox cmd=0x%x.\n",
-	    ha->host_no, mcp->mb[0]));
+	    base_vha->host_no, mcp->mb[0]));
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
@@ -100,15 +101,16 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 
 #if defined(QL_DEBUG_LEVEL_1)
 	printk("%s(%ld): Loaded MBX registers (displayed in bytes) = \n",
-	    __func__, ha->host_no);
+	    __func__, base_vha->host_no);
 	qla2x00_dump_buffer((uint8_t *)mcp->mb, 16);
 	printk("\n");
 	qla2x00_dump_buffer(((uint8_t *)mcp->mb + 0x10), 16);
 	printk("\n");
 	qla2x00_dump_buffer(((uint8_t *)mcp->mb + 0x20), 8);
 	printk("\n");
-	printk("%s(%ld): I/O address = %p.\n", __func__, ha->host_no, optr);
-	qla2x00_dump_regs(ha);
+	printk("%s(%ld): I/O address = %p.\n", __func__, base_vha->host_no,
+		optr);
+	qla2x00_dump_regs(base_vha);
 #endif
 
 	/* Issue set host interrupt command to send cmd out. */
@@ -117,7 +119,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 
 	/* Unlock mbx registers and wait for interrupt */
 	DEBUG11(printk("%s(%ld): going to unlock irq & waiting for interrupt. "
-	    "jiffies=%lx.\n", __func__, ha->host_no, jiffies));
+	    "jiffies=%lx.\n", __func__, base_vha->host_no, jiffies));
 
 	/* Wait for mbx cmd completion until timeout */
 
@@ -137,7 +139,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 
 	} else {
 		DEBUG3_11(printk("%s(%ld): cmd=%x POLLING MODE.\n", __func__,
-		    ha->host_no, command));
+		    base_vha->host_no, command));
 
 		if (IS_FWI2_CAPABLE(ha))
 			WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_SET_HOST_INT);
@@ -151,7 +153,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 				break;
 
 			/* Check for pending interrupts. */
-			qla2x00_poll(ha);
+			qla2x00_poll(ha->rsp);
 
 			if (command != MBC_LOAD_RISC_RAM_EXTENDED &&
 			    !ha->flags.mbox_int)
@@ -164,7 +166,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 		uint16_t *iptr2;
 
 		DEBUG3_11(printk("%s(%ld): cmd %x completed.\n", __func__,
-		    ha->host_no, command));
+		    base_vha->host_no, command));
 
 		/* Got interrupt. Clear the flag. */
 		ha->flags.mbox_int = 0;
@@ -200,12 +202,12 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 			ictrl = RD_REG_WORD(&reg->isp.ictrl);
 		}
 		printk("%s(%ld): **** MB Command Timeout for cmd %x ****\n",
-		    __func__, ha->host_no, command);
+		    __func__, base_vha->host_no, command);
 		printk("%s(%ld): icontrol=%x jiffies=%lx\n", __func__,
-		    ha->host_no, ictrl, jiffies);
+		    base_vha->host_no, ictrl, jiffies);
 		printk("%s(%ld): *** mailbox[0] = 0x%x ***\n", __func__,
-		    ha->host_no, mb0);
-		qla2x00_dump_regs(ha);
+		    base_vha->host_no, mb0);
+		qla2x00_dump_regs(base_vha);
 #endif
 
 		rval = QLA_FUNCTION_TIMEOUT;
@@ -218,10 +220,10 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 
 	if (abort_active || !io_lock_on) {
 		DEBUG11(printk("%s(%ld): checking for additional resp "
-		    "interrupt.\n", __func__, ha->host_no));
+		    "interrupt.\n", __func__, base_vha->host_no));
 
 		/* polling mode for non isp_abort commands. */
-		qla2x00_poll(ha);
+		qla2x00_poll(ha->rsp);
 	}
 
 	if (rval == QLA_FUNCTION_TIMEOUT &&
@@ -229,35 +231,37 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 		if (!io_lock_on || (mcp->flags & IOCTL_CMD)) {
 			/* not in dpc. schedule it for dpc to take over. */
 			DEBUG(printk("%s(%ld): timeout schedule "
-			    "isp_abort_needed.\n", __func__, ha->host_no));
+			"isp_abort_needed.\n", __func__,
+			base_vha->host_no));
 			DEBUG2_3_11(printk("%s(%ld): timeout schedule "
-			    "isp_abort_needed.\n", __func__, ha->host_no));
+			"isp_abort_needed.\n", __func__,
+			base_vha->host_no));
 			qla_printk(KERN_WARNING, ha,
 			    "Mailbox command timeout occurred. Scheduling ISP "
 			    "abort.\n");
-			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-			qla2xxx_wake_dpc(ha);
+			set_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
+			qla2xxx_wake_dpc(vha);
 		} else if (!abort_active) {
 			/* call abort directly since we are in the DPC thread */
 			DEBUG(printk("%s(%ld): timeout calling abort_isp\n",
-			    __func__, ha->host_no));
+			    __func__, base_vha->host_no));
 			DEBUG2_3_11(printk("%s(%ld): timeout calling "
-			    "abort_isp\n", __func__, ha->host_no));
+			    "abort_isp\n", __func__, base_vha->host_no));
 			qla_printk(KERN_WARNING, ha,
 			    "Mailbox command timeout occurred. Issuing ISP "
 			    "abort.\n");
 
-			set_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
-			clear_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-			if (qla2x00_abort_isp(ha)) {
+			set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
+			clear_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
+			if (qla2x00_abort_isp(base_vha)) {
 				/* Failed. retry later. */
-				set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+				set_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
 			}
-			clear_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
+			clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 			DEBUG(printk("%s(%ld): finished abort_isp\n", __func__,
-			    ha->host_no));
+			    base_vha->host_no));
 			DEBUG2_3_11(printk("%s(%ld): finished abort_isp\n",
-			    __func__, ha->host_no));
+			    __func__, base_vha->host_no));
 		}
 	}
 
@@ -267,24 +271,26 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 
 	if (rval) {
 		DEBUG2_3_11(printk("%s(%ld): **** FAILED. mbx0=%x, mbx1=%x, "
-		    "mbx2=%x, cmd=%x ****\n", __func__, ha->host_no,
+		    "mbx2=%x, cmd=%x ****\n", __func__, base_vha->host_no,
 		    mcp->mb[0], mcp->mb[1], mcp->mb[2], command));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__,
+		base_vha->host_no));
 	}
 
 	return rval;
 }
 
 int
-qla2x00_load_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t risc_addr,
+qla2x00_load_ram(scsi_qla_host_t *vha, dma_addr_t req_dma, uint32_t risc_addr,
     uint32_t risc_code_size)
 {
 	int rval;
+	struct qla_hw_data *ha = vha->hw;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	if (MSW(risc_addr) || IS_FWI2_CAPABLE(ha)) {
 		mcp->mb[0] = MBC_LOAD_RISC_RAM_EXTENDED;
@@ -312,13 +318,13 @@ qla2x00_load_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t risc_addr,
 	mcp->in_mb = MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x.\n", __func__,
-		    ha->host_no, rval, mcp->mb[0]));
+		    vha->host_no, rval, mcp->mb[0]));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -340,13 +346,14 @@ qla2x00_load_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t risc_addr,
  *     Kernel context.
  */
 int
-qla2x00_execute_fw(scsi_qla_host_t *ha, uint32_t risc_addr)
+qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 {
 	int rval;
+	struct qla_hw_data *ha = vha->hw;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_EXECUTE_FIRMWARE;
 	mcp->out_mb = MBX_0;
@@ -369,18 +376,18 @@ qla2x00_execute_fw(scsi_qla_host_t *ha, uint32_t risc_addr)
 
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x.\n", __func__,
-		    ha->host_no, rval, mcp->mb[0]));
+		    vha->host_no, rval, mcp->mb[0]));
 	} else {
 		if (IS_FWI2_CAPABLE(ha)) {
 			DEBUG11(printk("%s(%ld): done exchanges=%x.\n",
-			    __func__, ha->host_no, mcp->mb[1]));
+			    __func__, vha->host_no, mcp->mb[1]));
 		} else {
 			DEBUG11(printk("%s(%ld): done.\n", __func__,
-			    ha->host_no));
+			    vha->host_no));
 		}
 	}
 
@@ -404,28 +411,28 @@ qla2x00_execute_fw(scsi_qla_host_t *ha, uint32_t risc_addr)
  *	Kernel context.
  */
 void
-qla2x00_get_fw_version(scsi_qla_host_t *ha, uint16_t *major, uint16_t *minor,
+qla2x00_get_fw_version(scsi_qla_host_t *vha, uint16_t *major, uint16_t *minor,
     uint16_t *subminor, uint16_t *attributes, uint32_t *memory)
 {
 	int		rval;
 	mbx_cmd_t	mc;
 	mbx_cmd_t	*mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_GET_FIRMWARE_VERSION;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->flags = 0;
 	mcp->tov = MBX_TOV_SECONDS;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	/* Return mailbox data. */
 	*major = mcp->mb[1];
 	*minor = mcp->mb[2];
 	*subminor = mcp->mb[3];
 	*attributes = mcp->mb[6];
-	if (IS_QLA2100(ha) || IS_QLA2200(ha))
+	if (IS_QLA2100(vha->hw) || IS_QLA2200(vha->hw))
 		*memory = 0x1FFFF;			/* Defaults to 128KB. */
 	else
 		*memory = (mcp->mb[5] << 16) | mcp->mb[4];
@@ -433,10 +440,10 @@ qla2x00_get_fw_version(scsi_qla_host_t *ha, uint16_t *major, uint16_t *minor,
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 }
 
@@ -455,32 +462,32 @@ qla2x00_get_fw_version(scsi_qla_host_t *ha, uint16_t *major, uint16_t *minor,
  *	Kernel context.
  */
 int
-qla2x00_get_fw_options(scsi_qla_host_t *ha, uint16_t *fwopts)
+qla2x00_get_fw_options(scsi_qla_host_t *vha, uint16_t *fwopts)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_GET_FIRMWARE_OPTION;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
 		fwopts[0] = mcp->mb[0];
 		fwopts[1] = mcp->mb[1];
 		fwopts[2] = mcp->mb[2];
 		fwopts[3] = mcp->mb[3];
 
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -502,13 +509,13 @@ qla2x00_get_fw_options(scsi_qla_host_t *ha, uint16_t *fwopts)
  *	Kernel context.
  */
 int
-qla2x00_set_fw_options(scsi_qla_host_t *ha, uint16_t *fwopts)
+qla2x00_set_fw_options(scsi_qla_host_t *vha, uint16_t *fwopts)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_SET_FIRMWARE_OPTION;
 	mcp->mb[1] = fwopts[1];
@@ -516,7 +523,7 @@ qla2x00_set_fw_options(scsi_qla_host_t *ha, uint16_t *fwopts)
 	mcp->mb[3] = fwopts[3];
 	mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
-	if (IS_FWI2_CAPABLE(ha)) {
+	if (IS_FWI2_CAPABLE(vha->hw)) {
 		mcp->in_mb |= MBX_1;
 	} else {
 		mcp->mb[10] = fwopts[10];
@@ -526,17 +533,17 @@ qla2x00_set_fw_options(scsi_qla_host_t *ha, uint16_t *fwopts)
 	}
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	fwopts[0] = mcp->mb[0];
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x/%x).\n", __func__,
-		    ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		    vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -558,13 +565,14 @@ qla2x00_set_fw_options(scsi_qla_host_t *ha, uint16_t *fwopts)
  *	Kernel context.
  */
 int
-qla2x00_mbx_reg_test(scsi_qla_host_t *ha)
+qla2x00_mbx_reg_test(scsi_qla_host_t *vha)
 {
 	int rval;
+	struct qla_hw_data *ha = vha->hw;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("qla2x00_mbx_reg_test(%ld): entered.\n", ha->host_no));
+	DEBUG11(printk("qla2x00_mbx_reg_test(%ld): entered.\n", vha->host_no));
 
 	mcp->mb[0] = MBC_MAILBOX_REGISTER_TEST;
 	mcp->mb[1] = 0xAAAA;
@@ -578,7 +586,7 @@ qla2x00_mbx_reg_test(scsi_qla_host_t *ha)
 	mcp->in_mb = MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval == QLA_SUCCESS) {
 		if (mcp->mb[1] != 0xAAAA || mcp->mb[2] != 0x5555 ||
@@ -591,7 +599,7 @@ qla2x00_mbx_reg_test(scsi_qla_host_t *ha)
 			struct device_reg_24xx __iomem *reg =
 			    &ha->iobase->isp24;
 
-			qla2xxx_hw_event_log(ha, HW_EVENT_ISP_ERR, 0,
+			qla2xxx_hw_event_log(vha, HW_EVENT_ISP_ERR, 0,
 			    LSW(RD_REG_DWORD(&reg->hccr)),
 			    LSW(RD_REG_DWORD(&reg->istatus)));
 		}
@@ -600,11 +608,11 @@ qla2x00_mbx_reg_test(scsi_qla_host_t *ha)
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_mbx_reg_test(%ld): failed=%x.\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_mbx_reg_test(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -626,18 +634,18 @@ qla2x00_mbx_reg_test(scsi_qla_host_t *ha)
  *	Kernel context.
  */
 int
-qla2x00_verify_checksum(scsi_qla_host_t *ha, uint32_t risc_addr)
+qla2x00_verify_checksum(scsi_qla_host_t *vha, uint32_t risc_addr)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_VERIFY_CHECKSUM;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_0;
-	if (IS_FWI2_CAPABLE(ha)) {
+	if (IS_FWI2_CAPABLE(vha->hw)) {
 		mcp->mb[1] = MSW(risc_addr);
 		mcp->mb[2] = LSW(risc_addr);
 		mcp->out_mb |= MBX_2|MBX_1;
@@ -650,14 +658,14 @@ qla2x00_verify_checksum(scsi_qla_host_t *ha, uint32_t risc_addr)
 
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x chk sum=%x.\n", __func__,
-		    ha->host_no, rval, IS_FWI2_CAPABLE(ha) ?
+		    vha->host_no, rval, IS_FWI2_CAPABLE(vha->hw) ?
 		    (mcp->mb[2] << 16) | mcp->mb[1]: mcp->mb[1]));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -682,7 +690,7 @@ qla2x00_verify_checksum(scsi_qla_host_t *ha, uint32_t risc_addr)
  *	Kernel context.
  */
 static int
-qla2x00_issue_iocb_timeout(scsi_qla_host_t *ha, void *buffer,
+qla2x00_issue_iocb_timeout(scsi_qla_host_t *vha, void *buffer,
     dma_addr_t phys_addr, size_t size, uint32_t tov)
 {
 	int		rval;
@@ -699,30 +707,30 @@ qla2x00_issue_iocb_timeout(scsi_qla_host_t *ha, void *buffer,
 	mcp->in_mb = MBX_2|MBX_0;
 	mcp->tov = tov;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG(printk("qla2x00_issue_iocb(%ld): failed rval 0x%x\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 		DEBUG2(printk("qla2x00_issue_iocb(%ld): failed rval 0x%x\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
 		sts_entry_t *sts_entry = (sts_entry_t *) buffer;
 
 		/* Mask reserved bits. */
 		sts_entry->entry_status &=
-		    IS_FWI2_CAPABLE(ha) ? RF_MASK_24XX :RF_MASK;
+		    IS_FWI2_CAPABLE(vha->hw) ? RF_MASK_24XX : RF_MASK;
 	}
 
 	return rval;
 }
 
 int
-qla2x00_issue_iocb(scsi_qla_host_t *ha, void *buffer, dma_addr_t phys_addr,
+qla2x00_issue_iocb(scsi_qla_host_t *vha, void *buffer, dma_addr_t phys_addr,
     size_t size)
 {
-	return qla2x00_issue_iocb_timeout(ha, buffer, phys_addr, size,
+	return qla2x00_issue_iocb_timeout(vha, buffer, phys_addr, size,
 	    MBX_TOV_SECONDS);
 }
 
@@ -741,7 +749,7 @@ qla2x00_issue_iocb(scsi_qla_host_t *ha, void *buffer, dma_addr_t phys_addr,
  *	Kernel context.
  */
 int
-qla2x00_abort_command(scsi_qla_host_t *ha, srb_t *sp)
+qla2x00_abort_command(scsi_qla_host_t *vha, srb_t *sp)
 {
 	unsigned long   flags = 0;
 	fc_port_t	*fcport;
@@ -749,14 +757,16 @@ qla2x00_abort_command(scsi_qla_host_t *ha, srb_t *sp)
 	uint32_t	handle;
 	mbx_cmd_t	mc;
 	mbx_cmd_t	*mcp = &mc;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
-	DEBUG11(printk("qla2x00_abort_command(%ld): entered.\n", ha->host_no));
+	DEBUG11(printk("qla2x00_abort_command(%ld): entered.\n", vha->host_no));
 
 	fcport = sp->fcport;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (handle = 1; handle < MAX_OUTSTANDING_COMMANDS; handle++) {
-		if (ha->outstanding_cmds[handle] == sp)
+		if (req->outstanding_cmds[handle] == sp)
 			break;
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -778,14 +788,14 @@ qla2x00_abort_command(scsi_qla_host_t *ha, srb_t *sp)
 	mcp->in_mb = MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("qla2x00_abort_command(%ld): failed=%x.\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
 		DEBUG11(printk("qla2x00_abort_command(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -797,40 +807,40 @@ qla2x00_abort_target(struct fc_port *fcport, unsigned int l)
 	int rval, rval2;
 	mbx_cmd_t  mc;
 	mbx_cmd_t  *mcp = &mc;
-	scsi_qla_host_t *ha;
+	scsi_qla_host_t *vha;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->vha->host_no));
 
 	l = l;
-	ha = fcport->ha;
+	vha = fcport->vha;
 	mcp->mb[0] = MBC_ABORT_TARGET;
 	mcp->out_mb = MBX_9|MBX_2|MBX_1|MBX_0;
-	if (HAS_EXTENDED_IDS(ha)) {
+	if (HAS_EXTENDED_IDS(vha->hw)) {
 		mcp->mb[1] = fcport->loop_id;
 		mcp->mb[10] = 0;
 		mcp->out_mb |= MBX_10;
 	} else {
 		mcp->mb[1] = fcport->loop_id << 8;
 	}
-	mcp->mb[2] = ha->loop_reset_delay;
-	mcp->mb[9] = ha->vp_idx;
+	mcp->mb[2] = vha->hw->loop_reset_delay;
+	mcp->mb[9] = vha->vp_idx;
 
 	mcp->in_mb = MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	}
 
 	/* Issue marker IOCB. */
-	rval2 = qla2x00_marker(ha, fcport->loop_id, 0, MK_SYNC_ID);
+	rval2 = qla2x00_marker(vha, fcport->loop_id, 0, MK_SYNC_ID);
 	if (rval2 != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Marker IOCB "
-		    "(%x).\n", __func__, ha->host_no, rval2));
+		    "(%x).\n", __func__, vha->host_no, rval2));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -842,37 +852,37 @@ qla2x00_lun_reset(struct fc_port *fcport, unsigned int l)
 	int rval, rval2;
 	mbx_cmd_t  mc;
 	mbx_cmd_t  *mcp = &mc;
-	scsi_qla_host_t *ha;
+	scsi_qla_host_t *vha;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->vha->host_no));
 
-	ha = fcport->ha;
+	vha = fcport->vha;
 	mcp->mb[0] = MBC_LUN_RESET;
 	mcp->out_mb = MBX_9|MBX_3|MBX_2|MBX_1|MBX_0;
-	if (HAS_EXTENDED_IDS(ha))
+	if (HAS_EXTENDED_IDS(vha->hw))
 		mcp->mb[1] = fcport->loop_id;
 	else
 		mcp->mb[1] = fcport->loop_id << 8;
 	mcp->mb[2] = l;
 	mcp->mb[3] = 0;
-	mcp->mb[9] = ha->vp_idx;
+	mcp->mb[9] = vha->vp_idx;
 
 	mcp->in_mb = MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	}
 
 	/* Issue marker IOCB. */
-	rval2 = qla2x00_marker(ha, fcport->loop_id, l, MK_SYNC_ID_LUN);
+	rval2 = qla2x00_marker(vha, fcport->loop_id, l, MK_SYNC_ID_LUN);
 	if (rval2 != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Marker IOCB "
-		    "(%x).\n", __func__, ha->host_no, rval2));
+		    "(%x).\n", __func__, vha->host_no, rval2));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -899,7 +909,7 @@ qla2x00_lun_reset(struct fc_port *fcport, unsigned int l)
  *	Kernel context.
  */
 int
-qla2x00_get_adapter_id(scsi_qla_host_t *ha, uint16_t *id, uint8_t *al_pa,
+qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
     uint8_t *area, uint8_t *domain, uint16_t *top, uint16_t *sw_cap)
 {
 	int rval;
@@ -907,15 +917,15 @@ qla2x00_get_adapter_id(scsi_qla_host_t *ha, uint16_t *id, uint8_t *al_pa,
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_get_adapter_id(%ld): entered.\n",
-	    ha->host_no));
+	    vha->host_no));
 
 	mcp->mb[0] = MBC_GET_ADAPTER_LOOP_ID;
-	mcp->mb[9] = ha->vp_idx;
+	mcp->mb[9] = vha->vp_idx;
 	mcp->out_mb = MBX_9|MBX_0;
 	mcp->in_mb = MBX_9|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 	if (mcp->mb[0] == MBS_COMMAND_ERROR)
 		rval = QLA_COMMAND_ERROR;
 	else if (mcp->mb[0] == MBS_INVALID_COMMAND)
@@ -932,11 +942,11 @@ qla2x00_get_adapter_id(scsi_qla_host_t *ha, uint16_t *id, uint8_t *al_pa,
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_get_adapter_id(%ld): failed=%x.\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_get_adapter_id(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -958,7 +968,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *ha, uint16_t *id, uint8_t *al_pa,
  *	Kernel context.
  */
 int
-qla2x00_get_retry_cnt(scsi_qla_host_t *ha, uint8_t *retry_cnt, uint8_t *tov,
+qla2x00_get_retry_cnt(scsi_qla_host_t *vha, uint8_t *retry_cnt, uint8_t *tov,
     uint16_t *r_a_tov)
 {
 	int rval;
@@ -967,19 +977,19 @@ qla2x00_get_retry_cnt(scsi_qla_host_t *ha, uint8_t *retry_cnt, uint8_t *tov,
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_get_retry_cnt(%ld): entered.\n",
-			ha->host_no));
+			vha->host_no));
 
 	mcp->mb[0] = MBC_GET_RETRY_COUNT;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_get_retry_cnt(%ld): failed = %x.\n",
-		    ha->host_no, mcp->mb[0]));
+		    vha->host_no, mcp->mb[0]));
 	} else {
 		/* Convert returned data and check our values. */
 		*r_a_tov = mcp->mb[3] / 2;
@@ -991,7 +1001,7 @@ qla2x00_get_retry_cnt(scsi_qla_host_t *ha, uint8_t *retry_cnt, uint8_t *tov,
 		}
 
 		DEBUG11(printk("qla2x00_get_retry_cnt(%ld): done. mb3=%d "
-		    "ratov=%d.\n", ha->host_no, mcp->mb[3], ratov));
+		    "ratov=%d.\n", vha->host_no, mcp->mb[3], ratov));
 	}
 
 	return rval;
@@ -1015,14 +1025,15 @@ qla2x00_get_retry_cnt(scsi_qla_host_t *ha, uint8_t *retry_cnt, uint8_t *tov,
  *	Kernel context.
  */
 int
-qla2x00_init_firmware(scsi_qla_host_t *ha, uint16_t size)
+qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
+	struct qla_hw_data *ha = vha->hw;
 
 	DEBUG11(printk("qla2x00_init_firmware(%ld): entered.\n",
-	    ha->host_no));
+	    vha->host_no));
 
 	if (ha->flags.npiv_supported)
 		mcp->mb[0] = MBC_MID_INITIALIZE_FIRMWARE;
@@ -1040,17 +1051,17 @@ qla2x00_init_firmware(scsi_qla_host_t *ha, uint16_t size)
 	mcp->buf_size = size;
 	mcp->flags = MBX_DMA_OUT;
 	mcp->tov = MBX_TOV_SECONDS;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_init_firmware(%ld): failed=%x "
 		    "mb0=%x.\n",
-		    ha->host_no, rval, mcp->mb[0]));
+		    vha->host_no, rval, mcp->mb[0]));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_init_firmware(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -1073,7 +1084,7 @@ qla2x00_init_firmware(scsi_qla_host_t *ha, uint16_t size)
  *	Kernel context.
  */
 int
-qla2x00_get_port_database(scsi_qla_host_t *ha, fc_port_t *fcport, uint8_t opt)
+qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 {
 	int rval;
 	mbx_cmd_t mc;
@@ -1081,14 +1092,15 @@ qla2x00_get_port_database(scsi_qla_host_t *ha, fc_port_t *fcport, uint8_t opt)
 	port_database_t *pd;
 	struct port_database_24xx *pd24;
 	dma_addr_t pd_dma;
+	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	pd24 = NULL;
 	pd = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
 	if (pd  == NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Port Database "
-		    "structure.\n", __func__, ha->host_no));
+		    "structure.\n", __func__, vha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(pd, 0, max(PORT_DATABASE_SIZE, PORT_DATABASE_24XX_SIZE));
@@ -1100,7 +1112,7 @@ qla2x00_get_port_database(scsi_qla_host_t *ha, fc_port_t *fcport, uint8_t opt)
 	mcp->mb[3] = LSW(pd_dma);
 	mcp->mb[6] = MSW(MSD(pd_dma));
 	mcp->mb[7] = LSW(MSD(pd_dma));
-	mcp->mb[9] = ha->vp_idx;
+	mcp->mb[9] = vha->vp_idx;
 	mcp->out_mb = MBX_9|MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
 	mcp->in_mb = MBX_0;
 	if (IS_FWI2_CAPABLE(ha)) {
@@ -1120,7 +1132,7 @@ qla2x00_get_port_database(scsi_qla_host_t *ha, fc_port_t *fcport, uint8_t opt)
 	    PORT_DATABASE_24XX_SIZE : PORT_DATABASE_SIZE;
 	mcp->flags = MBX_DMA_IN;
 	mcp->tov = (ha->login_timeout * 2) + (ha->login_timeout / 2);
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS)
 		goto gpd_error_out;
 
@@ -1132,7 +1144,7 @@ qla2x00_get_port_database(scsi_qla_host_t *ha, fc_port_t *fcport, uint8_t opt)
 		    pd24->last_login_state != PDS_PRLI_COMPLETE) {
 			DEBUG2(printk("%s(%ld): Unable to verify "
 			    "login-state (%x/%x) for loop_id %x\n",
-			    __func__, ha->host_no,
+			    __func__, vha->host_no,
 			    pd24->current_login_state,
 			    pd24->last_login_state, fcport->loop_id));
 			rval = QLA_FUNCTION_FAILED;
@@ -1192,9 +1204,9 @@ gpd_error_out:
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
-		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -1217,21 +1229,21 @@ gpd_error_out:
  *	Kernel context.
  */
 int
-qla2x00_get_firmware_state(scsi_qla_host_t *ha, uint16_t *states)
+qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_get_firmware_state(%ld): entered.\n",
-	    ha->host_no));
+	    vha->host_no));
 
 	mcp->mb[0] = MBC_GET_FIRMWARE_STATE;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	/* Return firmware states. */
 	states[0] = mcp->mb[1];
@@ -1241,11 +1253,11 @@ qla2x00_get_firmware_state(scsi_qla_host_t *ha, uint16_t *states)
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_get_firmware_state(%ld): "
-		    "failed=%x.\n", ha->host_no, rval));
+		    "failed=%x.\n", vha->host_no, rval));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_get_firmware_state(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -1270,7 +1282,7 @@ qla2x00_get_firmware_state(scsi_qla_host_t *ha, uint16_t *states)
  *	Kernel context.
  */
 int
-qla2x00_get_port_name(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t *name,
+qla2x00_get_port_name(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t *name,
     uint8_t opt)
 {
 	int rval;
@@ -1278,12 +1290,12 @@ qla2x00_get_port_name(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t *name,
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_get_port_name(%ld): entered.\n",
-	    ha->host_no));
+	    vha->host_no));
 
 	mcp->mb[0] = MBC_GET_PORT_NAME;
-	mcp->mb[9] = ha->vp_idx;
+	mcp->mb[9] = vha->vp_idx;
 	mcp->out_mb = MBX_9|MBX_1|MBX_0;
-	if (HAS_EXTENDED_IDS(ha)) {
+	if (HAS_EXTENDED_IDS(vha->hw)) {
 		mcp->mb[1] = loop_id;
 		mcp->mb[10] = opt;
 		mcp->out_mb |= MBX_10;
@@ -1294,12 +1306,12 @@ qla2x00_get_port_name(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t *name,
 	mcp->in_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_get_port_name(%ld): failed=%x.\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
 		if (name != NULL) {
 			/* This function returns name in big endian. */
@@ -1314,7 +1326,7 @@ qla2x00_get_port_name(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t *name,
 		}
 
 		DEBUG11(printk("qla2x00_get_port_name(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -1336,45 +1348,45 @@ qla2x00_get_port_name(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t *name,
  *	Kernel context.
  */
 int
-qla2x00_lip_reset(scsi_qla_host_t *ha)
+qla2x00_lip_reset(scsi_qla_host_t *vha)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
-	if (IS_FWI2_CAPABLE(ha)) {
+	if (IS_FWI2_CAPABLE(vha->hw)) {
 		mcp->mb[0] = MBC_LIP_FULL_LOGIN;
 		mcp->mb[1] = BIT_6;
 		mcp->mb[2] = 0;
-		mcp->mb[3] = ha->loop_reset_delay;
+		mcp->mb[3] = vha->hw->loop_reset_delay;
 		mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	} else {
 		mcp->mb[0] = MBC_LIP_RESET;
 		mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
-		if (HAS_EXTENDED_IDS(ha)) {
+		if (HAS_EXTENDED_IDS(vha->hw)) {
 			mcp->mb[1] = 0x00ff;
 			mcp->mb[10] = 0;
 			mcp->out_mb |= MBX_10;
 		} else {
 			mcp->mb[1] = 0xff00;
 		}
-		mcp->mb[2] = ha->loop_reset_delay;
+		mcp->mb[2] = vha->hw->loop_reset_delay;
 		mcp->mb[3] = 0;
 	}
 	mcp->in_mb = MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n",
-		    __func__, ha->host_no, rval));
+		    __func__, vha->host_no, rval));
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -1399,7 +1411,7 @@ qla2x00_lip_reset(scsi_qla_host_t *ha)
  *	Kernel context.
  */
 int
-qla2x00_send_sns(scsi_qla_host_t *ha, dma_addr_t sns_phys_address,
+qla2x00_send_sns(scsi_qla_host_t *vha, dma_addr_t sns_phys_address,
     uint16_t cmd_size, size_t buf_size)
 {
 	int rval;
@@ -1407,10 +1419,11 @@ qla2x00_send_sns(scsi_qla_host_t *ha, dma_addr_t sns_phys_address,
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_send_sns(%ld): entered.\n",
-	    ha->host_no));
+	    vha->host_no));
 
 	DEBUG11(printk("qla2x00_send_sns: retry cnt=%d ratov=%d total "
-	    "tov=%d.\n", ha->retry_count, ha->login_timeout, mcp->tov));
+		"tov=%d.\n", vha->hw->retry_count, vha->hw->login_timeout,
+		mcp->tov));
 
 	mcp->mb[0] = MBC_SEND_SNS_COMMAND;
 	mcp->mb[1] = cmd_size;
@@ -1422,25 +1435,25 @@ qla2x00_send_sns(scsi_qla_host_t *ha, dma_addr_t sns_phys_address,
 	mcp->in_mb = MBX_0|MBX_1;
 	mcp->buf_size = buf_size;
 	mcp->flags = MBX_DMA_OUT|MBX_DMA_IN;
-	mcp->tov = (ha->login_timeout * 2) + (ha->login_timeout / 2);
-	rval = qla2x00_mailbox_command(ha, mcp);
+	mcp->tov = (vha->hw->login_timeout * 2) + (vha->hw->login_timeout / 2);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG(printk("qla2x00_send_sns(%ld): failed=%x mb[0]=%x "
-		    "mb[1]=%x.\n", ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		    "mb[1]=%x.\n", vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 		DEBUG2_3_11(printk("qla2x00_send_sns(%ld): failed=%x mb[0]=%x "
-		    "mb[1]=%x.\n", ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		    "mb[1]=%x.\n", vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("qla2x00_send_sns(%ld): done.\n", ha->host_no));
+		DEBUG11(printk("qla2x00_send_sns(%ld): done.\n", vha->host_no));
 	}
 
 	return rval;
 }
 
 int
-qla24xx_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
+qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
     uint8_t area, uint8_t al_pa, uint16_t *mb, uint8_t opt)
 {
 	int		rval;
@@ -1448,13 +1461,14 @@ qla24xx_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 	struct logio_entry_24xx *lg;
 	dma_addr_t	lg_dma;
 	uint32_t	iop[2];
+	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	lg = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
 	if (lg == NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Login IOCB.\n",
-		    __func__, ha->host_no));
+		    __func__, vha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(lg, 0, sizeof(struct logio_entry_24xx));
@@ -1470,14 +1484,14 @@ qla24xx_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 	lg->port_id[0] = al_pa;
 	lg->port_id[1] = area;
 	lg->port_id[2] = domain;
-	lg->vp_index = ha->vp_idx;
-	rval = qla2x00_issue_iocb(ha, lg, lg_dma, 0);
+	lg->vp_index = vha->vp_idx;
+	rval = qla2x00_issue_iocb(vha, lg, lg_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Login IOCB "
-		    "(%x).\n", __func__, ha->host_no, rval));
+		    "(%x).\n", __func__, vha->host_no, rval));
 	} else if (lg->entry_status != 0) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- error status (%x).\n", __func__, ha->host_no,
+		    "-- error status (%x).\n", __func__, vha->host_no,
 		    lg->entry_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else if (lg->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
@@ -1486,7 +1500,7 @@ qla24xx_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
 		    "-- completion status (%x)  ioparam=%x/%x.\n", __func__,
-		    ha->host_no, le16_to_cpu(lg->comp_status), iop[0],
+		    vha->host_no, le16_to_cpu(lg->comp_status), iop[0],
 		    iop[1]));
 
 		switch (iop[0]) {
@@ -1515,7 +1529,7 @@ qla24xx_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 			break;
 		}
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 
 		iop[0] = le32_to_cpu(lg->io_parameter[0]);
 
@@ -1562,14 +1576,15 @@ qla24xx_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
  *	Kernel context.
  */
 int
-qla2x00_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
+qla2x00_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
     uint8_t area, uint8_t al_pa, uint16_t *mb, uint8_t opt)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
+	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG11(printk("qla2x00_login_fabric(%ld): entered.\n", ha->host_no));
+	DEBUG11(printk("qla2x00_login_fabric(%ld): entered.\n", vha->host_no));
 
 	mcp->mb[0] = MBC_LOGIN_FABRIC_PORT;
 	mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
@@ -1586,7 +1601,7 @@ qla2x00_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 	mcp->in_mb = MBX_7|MBX_6|MBX_2|MBX_1|MBX_0;
 	mcp->tov = (ha->login_timeout * 2) + (ha->login_timeout / 2);
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	/* Return mailbox statuses. */
 	if (mb != NULL) {
@@ -1613,12 +1628,12 @@ qla2x00_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_login_fabric(%ld): failed=%x "
-		    "mb[0]=%x mb[1]=%x mb[2]=%x.\n", ha->host_no, rval,
+		    "mb[0]=%x mb[1]=%x mb[2]=%x.\n", vha->host_no, rval,
 		    mcp->mb[0], mcp->mb[1], mcp->mb[2]));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_login_fabric(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -1641,19 +1656,20 @@ qla2x00_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
  *
  */
 int
-qla2x00_login_local_device(scsi_qla_host_t *ha, fc_port_t *fcport,
+qla2x00_login_local_device(scsi_qla_host_t *vha, fc_port_t *fcport,
     uint16_t *mb_ret, uint8_t opt)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (IS_FWI2_CAPABLE(ha))
-		return qla24xx_login_fabric(ha, fcport->loop_id,
+		return qla24xx_login_fabric(vha, fcport->loop_id,
 		    fcport->d_id.b.domain, fcport->d_id.b.area,
 		    fcport->d_id.b.al_pa, mb_ret, opt);
 
-	DEBUG3(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG3(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_LOGIN_LOOP_PORT;
 	if (HAS_EXTENDED_IDS(ha))
@@ -1665,7 +1681,7 @@ qla2x00_login_local_device(scsi_qla_host_t *ha, fc_port_t *fcport,
  	mcp->in_mb = MBX_7|MBX_6|MBX_1|MBX_0;
 	mcp->tov = (ha->login_timeout * 2) + (ha->login_timeout / 2);
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
  	/* Return mailbox statuses. */
  	if (mb_ret != NULL) {
@@ -1686,33 +1702,34 @@ qla2x00_login_local_device(scsi_qla_host_t *ha, fc_port_t *fcport,
  			rval = QLA_SUCCESS;
 
 		DEBUG(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x "
-		    "mb[6]=%x mb[7]=%x.\n", __func__, ha->host_no, rval,
+		    "mb[6]=%x mb[7]=%x.\n", __func__, vha->host_no, rval,
 		    mcp->mb[0], mcp->mb[1], mcp->mb[6], mcp->mb[7]));
 		DEBUG2_3(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x "
-		    "mb[6]=%x mb[7]=%x.\n", __func__, ha->host_no, rval,
+		    "mb[6]=%x mb[7]=%x.\n", __func__, vha->host_no, rval,
 		    mcp->mb[0], mcp->mb[1], mcp->mb[6], mcp->mb[7]));
 	} else {
 		/*EMPTY*/
-		DEBUG3(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG3(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return (rval);
 }
 
 int
-qla24xx_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
+qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
     uint8_t area, uint8_t al_pa)
 {
 	int		rval;
 	struct logio_entry_24xx *lg;
 	dma_addr_t	lg_dma;
+	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	lg = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
 	if (lg == NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Logout IOCB.\n",
-		    __func__, ha->host_no));
+		    __func__, vha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(lg, 0, sizeof(struct logio_entry_24xx));
@@ -1725,25 +1742,25 @@ qla24xx_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 	lg->port_id[0] = al_pa;
 	lg->port_id[1] = area;
 	lg->port_id[2] = domain;
-	lg->vp_index = ha->vp_idx;
-	rval = qla2x00_issue_iocb(ha, lg, lg_dma, 0);
+	lg->vp_index = vha->vp_idx;
+	rval = qla2x00_issue_iocb(vha, lg, lg_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Logout IOCB "
-		    "(%x).\n", __func__, ha->host_no, rval));
+		    "(%x).\n", __func__, vha->host_no, rval));
 	} else if (lg->entry_status != 0) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- error status (%x).\n", __func__, ha->host_no,
+		    "-- error status (%x).\n", __func__, vha->host_no,
 		    lg->entry_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else if (lg->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
 		    "-- completion status (%x)  ioparam=%x/%x.\n", __func__,
-		    ha->host_no, le16_to_cpu(lg->comp_status),
+		    vha->host_no, le16_to_cpu(lg->comp_status),
 		    le32_to_cpu(lg->io_parameter[0]),
 		    le32_to_cpu(lg->io_parameter[1])));
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	dma_pool_free(ha->s_dma_pool, lg, lg_dma);
@@ -1768,7 +1785,7 @@ qla24xx_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
  *	Kernel context.
  */
 int
-qla2x00_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
+qla2x00_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
     uint8_t area, uint8_t al_pa)
 {
 	int rval;
@@ -1776,11 +1793,11 @@ qla2x00_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_fabric_logout(%ld): entered.\n",
-	    ha->host_no));
+	    vha->host_no));
 
 	mcp->mb[0] = MBC_LOGOUT_FABRIC_PORT;
 	mcp->out_mb = MBX_1|MBX_0;
-	if (HAS_EXTENDED_IDS(ha)) {
+	if (HAS_EXTENDED_IDS(vha->hw)) {
 		mcp->mb[1] = loop_id;
 		mcp->mb[10] = 0;
 		mcp->out_mb |= MBX_10;
@@ -1791,16 +1808,16 @@ qla2x00_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 	mcp->in_mb = MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_fabric_logout(%ld): failed=%x "
-		    "mbx1=%x.\n", ha->host_no, rval, mcp->mb[1]));
+		    "mbx1=%x.\n", vha->host_no, rval, mcp->mb[1]));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_fabric_logout(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -1822,33 +1839,33 @@ qla2x00_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
  *	Kernel context.
  */
 int
-qla2x00_full_login_lip(scsi_qla_host_t *ha)
+qla2x00_full_login_lip(scsi_qla_host_t *vha)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_full_login_lip(%ld): entered.\n",
-	    ha->host_no));
+	    vha->host_no));
 
 	mcp->mb[0] = MBC_LIP_FULL_LOGIN;
-	mcp->mb[1] = IS_FWI2_CAPABLE(ha) ? BIT_3: 0;
+	mcp->mb[1] = IS_FWI2_CAPABLE(vha->hw) ? BIT_3 : 0;
 	mcp->mb[2] = 0;
 	mcp->mb[3] = 0;
 	mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_full_login_lip(%ld): failed=%x.\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_full_login_lip(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -1867,7 +1884,7 @@ qla2x00_full_login_lip(scsi_qla_host_t *ha)
  *	Kernel context.
  */
 int
-qla2x00_get_id_list(scsi_qla_host_t *ha, void *id_list, dma_addr_t id_list_dma,
+qla2x00_get_id_list(scsi_qla_host_t *vha, void *id_list, dma_addr_t id_list_dma,
     uint16_t *entries)
 {
 	int rval;
@@ -1875,20 +1892,20 @@ qla2x00_get_id_list(scsi_qla_host_t *ha, void *id_list, dma_addr_t id_list_dma,
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_get_id_list(%ld): entered.\n",
-	    ha->host_no));
+	    vha->host_no));
 
 	if (id_list == NULL)
 		return QLA_FUNCTION_FAILED;
 
 	mcp->mb[0] = MBC_GET_ID_LIST;
 	mcp->out_mb = MBX_0;
-	if (IS_FWI2_CAPABLE(ha)) {
+	if (IS_FWI2_CAPABLE(vha->hw)) {
 		mcp->mb[2] = MSW(id_list_dma);
 		mcp->mb[3] = LSW(id_list_dma);
 		mcp->mb[6] = MSW(MSD(id_list_dma));
 		mcp->mb[7] = LSW(MSD(id_list_dma));
 		mcp->mb[8] = 0;
-		mcp->mb[9] = ha->vp_idx;
+		mcp->mb[9] = vha->vp_idx;
 		mcp->out_mb |= MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2;
 	} else {
 		mcp->mb[1] = MSW(id_list_dma);
@@ -1900,16 +1917,16 @@ qla2x00_get_id_list(scsi_qla_host_t *ha, void *id_list, dma_addr_t id_list_dma,
 	mcp->in_mb = MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_get_id_list(%ld): failed=%x.\n",
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
 		*entries = mcp->mb[1];
 		DEBUG11(printk("qla2x00_get_id_list(%ld): done.\n",
-		    ha->host_no));
+		    vha->host_no));
 	}
 
 	return rval;
@@ -1929,7 +1946,7 @@ qla2x00_get_id_list(scsi_qla_host_t *ha, void *id_list, dma_addr_t id_list_dma,
  *	Kernel context.
  */
 int
-qla2x00_get_resource_cnts(scsi_qla_host_t *ha, uint16_t *cur_xchg_cnt,
+qla2x00_get_resource_cnts(scsi_qla_host_t *vha, uint16_t *cur_xchg_cnt,
     uint16_t *orig_xchg_cnt, uint16_t *cur_iocb_cnt,
     uint16_t *orig_iocb_cnt, uint16_t *max_npiv_vports)
 {
@@ -1937,22 +1954,22 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *ha, uint16_t *cur_xchg_cnt,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_GET_RESOURCE_COUNTS;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_11|MBX_10|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("%s(%ld): failed = %x.\n", __func__,
-		    ha->host_no, mcp->mb[0]));
+		    vha->host_no, mcp->mb[0]));
 	} else {
 		DEBUG11(printk("%s(%ld): done. mb1=%x mb2=%x mb3=%x mb6=%x "
-		    "mb7=%x mb10=%x mb11=%x.\n", __func__, ha->host_no,
+		    "mb7=%x mb10=%x mb11=%x.\n", __func__, vha->host_no,
 		    mcp->mb[1], mcp->mb[2], mcp->mb[3], mcp->mb[6], mcp->mb[7],
 		    mcp->mb[10], mcp->mb[11]));
 
@@ -1964,7 +1981,7 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *ha, uint16_t *cur_xchg_cnt,
 			*cur_iocb_cnt = mcp->mb[7];
 		if (orig_iocb_cnt)
 			*orig_iocb_cnt = mcp->mb[10];
-		if (max_npiv_vports)
+		if (IS_FWI2_CAPABLE(vha->hw) && max_npiv_vports)
 			*max_npiv_vports = mcp->mb[11];
 	}
 
@@ -1987,18 +2004,19 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *ha, uint16_t *cur_xchg_cnt,
  *	Kernel context.
  */
 int
-qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map)
+qla2x00_get_fcal_position_map(scsi_qla_host_t *vha, char *pos_map)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 	char *pmap;
 	dma_addr_t pmap_dma;
+	struct qla_hw_data *ha = vha->hw;
 
 	pmap = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &pmap_dma);
 	if (pmap  == NULL) {
 		DEBUG2_3_11(printk("%s(%ld): **** Mem Alloc Failed ****",
-		    __func__, ha->host_no));
+		    __func__, vha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(pmap, 0, FCAL_MAP_SIZE);
@@ -2013,11 +2031,11 @@ qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map)
 	mcp->buf_size = FCAL_MAP_SIZE;
 	mcp->flags = MBX_DMA_IN;
 	mcp->tov = (ha->login_timeout * 2) + (ha->login_timeout / 2);
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval == QLA_SUCCESS) {
 		DEBUG11(printk("%s(%ld): (mb0=%x/mb1=%x) FC/AL Position Map "
-		    "size (%x)\n", __func__, ha->host_no, mcp->mb[0],
+		    "size (%x)\n", __func__, vha->host_no, mcp->mb[0],
 		    mcp->mb[1], (unsigned)pmap[0]));
 		DEBUG11(qla2x00_dump_buffer(pmap, pmap[0] + 1));
 
@@ -2028,9 +2046,9 @@ qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map)
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -2051,15 +2069,16 @@ qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map)
  *	BIT_1 = mailbox error.
  */
 int
-qla2x00_get_link_status(scsi_qla_host_t *ha, uint16_t loop_id,
+qla2x00_get_link_status(scsi_qla_host_t *vha, uint16_t loop_id,
     struct link_statistics *stats, dma_addr_t stats_dma)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 	uint32_t *siter, *diter, dwords;
+	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_GET_LINK_STATUS;
 	mcp->mb[2] = MSW(stats_dma);
@@ -2084,12 +2103,12 @@ qla2x00_get_link_status(scsi_qla_host_t *ha, uint16_t loop_id,
 	}
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = IOCTL_CMD;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval == QLA_SUCCESS) {
 		if (mcp->mb[0] != MBS_COMMAND_COMPLETE) {
 			DEBUG2_3_11(printk("%s(%ld): cmd failed. mbx0=%x.\n",
-			    __func__, ha->host_no, mcp->mb[0]));
+			    __func__, vha->host_no, mcp->mb[0]));
 			rval = QLA_FUNCTION_FAILED;
 		} else {
 			/* Copy over data -- firmware data is LE. */
@@ -2101,14 +2120,14 @@ qla2x00_get_link_status(scsi_qla_host_t *ha, uint16_t loop_id,
 	} else {
 		/* Failed. */
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	}
 
 	return rval;
 }
 
 int
-qla24xx_get_isp_stats(scsi_qla_host_t *ha, struct link_statistics *stats,
+qla24xx_get_isp_stats(scsi_qla_host_t *vha, struct link_statistics *stats,
     dma_addr_t stats_dma)
 {
 	int rval;
@@ -2116,7 +2135,7 @@ qla24xx_get_isp_stats(scsi_qla_host_t *ha, struct link_statistics *stats,
 	mbx_cmd_t *mcp = &mc;
 	uint32_t *siter, *diter, dwords;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_GET_LINK_PRIV_STATS;
 	mcp->mb[2] = MSW(stats_dma);
@@ -2124,18 +2143,18 @@ qla24xx_get_isp_stats(scsi_qla_host_t *ha, struct link_statistics *stats,
 	mcp->mb[6] = MSW(MSD(stats_dma));
 	mcp->mb[7] = LSW(MSD(stats_dma));
 	mcp->mb[8] = sizeof(struct link_statistics) / 4;
-	mcp->mb[9] = ha->vp_idx;
+	mcp->mb[9] = vha->vp_idx;
 	mcp->mb[10] = 0;
 	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = IOCTL_CMD;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval == QLA_SUCCESS) {
 		if (mcp->mb[0] != MBS_COMMAND_COMPLETE) {
 			DEBUG2_3_11(printk("%s(%ld): cmd failed. mbx0=%x.\n",
-			    __func__, ha->host_no, mcp->mb[0]));
+			    __func__, vha->host_no, mcp->mb[0]));
 			rval = QLA_FUNCTION_FAILED;
 		} else {
 			/* Copy over data -- firmware data is LE. */
@@ -2147,14 +2166,14 @@ qla24xx_get_isp_stats(scsi_qla_host_t *ha, struct link_statistics *stats,
 	} else {
 		/* Failed. */
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	}
 
 	return rval;
 }
 
 int
-qla24xx_abort_command(scsi_qla_host_t *ha, srb_t *sp)
+qla24xx_abort_command(scsi_qla_host_t *vha, srb_t *sp)
 {
 	int		rval;
 	fc_port_t	*fcport;
@@ -2163,18 +2182,19 @@ qla24xx_abort_command(scsi_qla_host_t *ha, srb_t *sp)
 	struct abort_entry_24xx *abt;
 	dma_addr_t	abt_dma;
 	uint32_t	handle;
-	scsi_qla_host_t *pha = to_qla_parent(ha);
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	fcport = sp->fcport;
 
-	spin_lock_irqsave(&pha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (handle = 1; handle < MAX_OUTSTANDING_COMMANDS; handle++) {
-		if (pha->outstanding_cmds[handle] == sp)
+		if (req->outstanding_cmds[handle] == sp)
 			break;
 	}
-	spin_unlock_irqrestore(&pha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	if (handle == MAX_OUTSTANDING_COMMANDS) {
 		/* Command not found. */
 		return QLA_FUNCTION_FAILED;
@@ -2183,7 +2203,7 @@ qla24xx_abort_command(scsi_qla_host_t *ha, srb_t *sp)
 	abt = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &abt_dma);
 	if (abt == NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Abort IOCB.\n",
-		    __func__, ha->host_no));
+		    __func__, vha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(abt, 0, sizeof(struct abort_entry_24xx));
@@ -2196,22 +2216,22 @@ qla24xx_abort_command(scsi_qla_host_t *ha, srb_t *sp)
 	abt->port_id[1] = fcport->d_id.b.area;
 	abt->port_id[2] = fcport->d_id.b.domain;
 	abt->vp_index = fcport->vp_idx;
-	rval = qla2x00_issue_iocb(ha, abt, abt_dma, 0);
+	rval = qla2x00_issue_iocb(vha, abt, abt_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue IOCB (%x).\n",
-		    __func__, ha->host_no, rval));
+		    __func__, vha->host_no, rval));
 	} else if (abt->entry_status != 0) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- error status (%x).\n", __func__, ha->host_no,
+		    "-- error status (%x).\n", __func__, vha->host_no,
 		    abt->entry_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else if (abt->nport_handle != __constant_cpu_to_le16(0)) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- completion status (%x).\n", __func__, ha->host_no,
+		    "-- completion status (%x).\n", __func__, vha->host_no,
 		    le16_to_cpu(abt->nport_handle)));
 		rval = QLA_FUNCTION_FAILED;
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	dma_pool_free(ha->s_dma_pool, abt, abt_dma);
@@ -2233,16 +2253,17 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 	int		rval, rval2;
 	struct tsk_mgmt_cmd *tsk;
 	dma_addr_t	tsk_dma;
-	scsi_qla_host_t *ha, *pha;
+	scsi_qla_host_t *vha;
+	struct qla_hw_data *ha;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->ha->host_no));
 
-	ha = fcport->ha;
-	pha = to_qla_parent(ha);
-	tsk = dma_pool_alloc(pha->s_dma_pool, GFP_KERNEL, &tsk_dma);
+	vha = fcport->vha;
+	ha = vha->hw;
+	tsk = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &tsk_dma);
 	if (tsk == NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Task Management "
-		    "IOCB.\n", __func__, ha->host_no));
+		    "IOCB.\n", __func__, vha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(tsk, 0, sizeof(struct tsk_mgmt_cmd));
@@ -2262,34 +2283,34 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 		    sizeof(tsk->p.tsk.lun));
 	}
 
-	rval = qla2x00_issue_iocb(ha, tsk, tsk_dma, 0);
+	rval = qla2x00_issue_iocb(vha, tsk, tsk_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue %s Reset IOCB "
-		    "(%x).\n", __func__, ha->host_no, name, rval));
+		    "(%x).\n", __func__, vha->host_no, name, rval));
 	} else if (tsk->p.sts.entry_status != 0) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- error status (%x).\n", __func__, ha->host_no,
+		    "-- error status (%x).\n", __func__, vha->host_no,
 		    tsk->p.sts.entry_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else if (tsk->p.sts.comp_status !=
 	    __constant_cpu_to_le16(CS_COMPLETE)) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
 		    "-- completion status (%x).\n", __func__,
-		    ha->host_no, le16_to_cpu(tsk->p.sts.comp_status)));
+		    vha->host_no, le16_to_cpu(tsk->p.sts.comp_status)));
 		rval = QLA_FUNCTION_FAILED;
 	}
 
 	/* Issue marker IOCB. */
-	rval2 = qla2x00_marker(ha, fcport->loop_id, l,
+	rval2 = qla2x00_marker(vha, fcport->loop_id, l,
 	    type == TCF_LUN_RESET ? MK_SYNC_ID_LUN: MK_SYNC_ID);
 	if (rval2 != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Marker IOCB "
-		    "(%x).\n", __func__, ha->host_no, rval2));
+		    "(%x).\n", __func__, vha->host_no, rval2));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
-	dma_pool_free(pha->s_dma_pool, tsk, tsk_dma);
+	dma_pool_free(ha->s_dma_pool, tsk, tsk_dma);
 
 	return rval;
 }
@@ -2307,29 +2328,30 @@ qla24xx_lun_reset(struct fc_port *fcport, unsigned int l)
 }
 
 int
-qla2x00_system_error(scsi_qla_host_t *ha)
+qla2x00_system_error(scsi_qla_host_t *vha)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_QLA23XX(ha) && !IS_FWI2_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_GEN_SYSTEM_ERROR;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_0;
 	mcp->tov = 5;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -2342,14 +2364,14 @@ qla2x00_system_error(scsi_qla_host_t *ha)
  * Returns
  */
 int
-qla2x00_set_serdes_params(scsi_qla_host_t *ha, uint16_t sw_em_1g,
+qla2x00_set_serdes_params(scsi_qla_host_t *vha, uint16_t sw_em_1g,
     uint16_t sw_em_2g, uint16_t sw_em_4g)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_SERDES_PARAMS;
 	mcp->mb[1] = BIT_0;
@@ -2360,61 +2382,61 @@ qla2x00_set_serdes_params(scsi_qla_host_t *ha, uint16_t sw_em_1g,
 	mcp->in_mb = MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
-		    ha->host_no, rval, mcp->mb[0]));
+		    vha->host_no, rval, mcp->mb[0]));
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
 }
 
 int
-qla2x00_stop_firmware(scsi_qla_host_t *ha)
+qla2x00_stop_firmware(scsi_qla_host_t *vha)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_FWI2_CAPABLE(ha))
+	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_STOP_FIRMWARE;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_0;
 	mcp->tov = 5;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
 }
 
 int
-qla2x00_enable_eft_trace(scsi_qla_host_t *ha, dma_addr_t eft_dma,
+qla2x00_enable_eft_trace(scsi_qla_host_t *vha, dma_addr_t eft_dma,
     uint16_t buffers)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_FWI2_CAPABLE(ha))
+	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_TRACE_CONTROL;
 	mcp->mb[1] = TC_EFT_ENABLE;
@@ -2428,28 +2450,28 @@ qla2x00_enable_eft_trace(scsi_qla_host_t *ha, dma_addr_t eft_dma,
 	mcp->in_mb = MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
-		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
 }
 
 int
-qla2x00_disable_eft_trace(scsi_qla_host_t *ha)
+qla2x00_disable_eft_trace(scsi_qla_host_t *vha)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_FWI2_CAPABLE(ha))
+	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_TRACE_CONTROL;
 	mcp->mb[1] = TC_EFT_DISABLE;
@@ -2457,29 +2479,29 @@ qla2x00_disable_eft_trace(scsi_qla_host_t *ha)
 	mcp->in_mb = MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
-		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
 }
 
 int
-qla2x00_enable_fce_trace(scsi_qla_host_t *ha, dma_addr_t fce_dma,
+qla2x00_enable_fce_trace(scsi_qla_host_t *vha, dma_addr_t fce_dma,
     uint16_t buffers, uint16_t *mb, uint32_t *dwords)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_QLA25XX(ha))
+	if (!IS_QLA25XX(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_TRACE_CONTROL;
 	mcp->mb[1] = TC_FCE_ENABLE;
@@ -2497,12 +2519,12 @@ qla2x00_enable_fce_trace(scsi_qla_host_t *ha, dma_addr_t fce_dma,
 	mcp->in_mb = MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
-		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 
 		if (mb)
 			memcpy(mb, mcp->mb, 8 * sizeof(*mb));
@@ -2514,16 +2536,16 @@ qla2x00_enable_fce_trace(scsi_qla_host_t *ha, dma_addr_t fce_dma,
 }
 
 int
-qla2x00_disable_fce_trace(scsi_qla_host_t *ha, uint64_t *wr, uint64_t *rd)
+qla2x00_disable_fce_trace(scsi_qla_host_t *vha, uint64_t *wr, uint64_t *rd)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_FWI2_CAPABLE(ha))
+	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_TRACE_CONTROL;
 	mcp->mb[1] = TC_FCE_DISABLE;
@@ -2533,12 +2555,12 @@ qla2x00_disable_fce_trace(scsi_qla_host_t *ha, uint64_t *wr, uint64_t *rd)
 	    MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
-		    __func__, ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 
 		if (wr)
 			*wr = (uint64_t) mcp->mb[5] << 48 |
@@ -2556,17 +2578,17 @@ qla2x00_disable_fce_trace(scsi_qla_host_t *ha, uint64_t *wr, uint64_t *rd)
 }
 
 int
-qla2x00_read_sfp(scsi_qla_host_t *ha, dma_addr_t sfp_dma, uint16_t addr,
+qla2x00_read_sfp(scsi_qla_host_t *vha, dma_addr_t sfp_dma, uint16_t addr,
     uint16_t off, uint16_t count)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_FWI2_CAPABLE(ha))
+	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_READ_SFP;
 	mcp->mb[1] = addr;
@@ -2581,30 +2603,30 @@ qla2x00_read_sfp(scsi_qla_host_t *ha, dma_addr_t sfp_dma, uint16_t addr,
 	mcp->in_mb = MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
-		    ha->host_no, rval, mcp->mb[0]));
+		    vha->host_no, rval, mcp->mb[0]));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
 }
 
 int
-qla2x00_set_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
+qla2x00_set_idma_speed(scsi_qla_host_t *vha, uint16_t loop_id,
     uint16_t port_speed, uint16_t *mb)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_IIDMA_CAPABLE(ha))
+	if (!IS_IIDMA_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_PORT_PARAMS;
 	mcp->mb[1] = loop_id;
@@ -2615,7 +2637,7 @@ qla2x00_set_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
 	mcp->in_mb = MBX_5|MBX_4|MBX_3|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	/* Return mailbox statuses. */
 	if (mb != NULL) {
@@ -2628,28 +2650,29 @@ qla2x00_set_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
 }
 
 void
-qla24xx_report_id_acquisition(scsi_qla_host_t *ha,
+qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 	struct vp_rpt_id_entry_24xx *rptid_entry)
 {
 	uint8_t vp_idx;
 	uint16_t stat = le16_to_cpu(rptid_entry->vp_idx);
-	scsi_qla_host_t *vha;
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *vp;
 
 	if (rptid_entry->entry_status != 0)
 		return;
 
 	if (rptid_entry->format == 0) {
 		DEBUG15(printk("%s:format 0 : scsi(%ld) number of VPs setup %d,"
-			" number of VPs acquired %d\n", __func__, ha->host_no,
+			" number of VPs acquired %d\n", __func__, vha->host_no,
 			MSB(rptid_entry->vp_count), LSB(rptid_entry->vp_count)));
 		DEBUG15(printk("%s primary port id %02x%02x%02x\n", __func__,
 			rptid_entry->port_id[2], rptid_entry->port_id[1],
@@ -2658,7 +2681,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *ha,
 		vp_idx = LSB(stat);
 		DEBUG15(printk("%s:format 1: scsi(%ld): VP[%d] enabled "
 		    "- status %d - "
-		    "with port id %02x%02x%02x\n",__func__,ha->host_no,
+		    "with port id %02x%02x%02x\n", __func__, vha->host_no,
 		    vp_idx, MSB(stat),
 		    rptid_entry->port_id[2], rptid_entry->port_id[1],
 		    rptid_entry->port_id[0]));
@@ -2668,25 +2691,24 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *ha,
 		if (MSB(stat) == 1)
 			return;
 
-		list_for_each_entry(vha, &ha->vp_list, vp_list)
-			if (vp_idx == vha->vp_idx)
+		list_for_each_entry(vp, &ha->vp_list, list)
+			if (vp_idx == vp->vp_idx)
 				break;
-
-		if (!vha)
+		if (!vp)
 			return;
 
-		vha->d_id.b.domain = rptid_entry->port_id[2];
-		vha->d_id.b.area =  rptid_entry->port_id[1];
-		vha->d_id.b.al_pa = rptid_entry->port_id[0];
+		vp->d_id.b.domain = rptid_entry->port_id[2];
+		vp->d_id.b.area =  rptid_entry->port_id[1];
+		vp->d_id.b.al_pa = rptid_entry->port_id[0];
 
 		/*
 		 * Cannot configure here as we are still sitting on the
 		 * response queue. Handle it in dpc context.
 		 */
-		set_bit(VP_IDX_ACQUIRED, &vha->vp_flags);
-		set_bit(VP_DPC_NEEDED, &ha->dpc_flags);
+		set_bit(VP_IDX_ACQUIRED, &vp->vp_flags);
+		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 
-		qla2xxx_wake_dpc(ha);
+		qla2xxx_wake_dpc(vha);
 	}
 }
 
@@ -2709,15 +2731,15 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 	int		rval;
 	struct vp_config_entry_24xx *vpmod;
 	dma_addr_t	vpmod_dma;
-	scsi_qla_host_t *pha;
+	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
 	/* This can be called by the parent */
-	pha = to_qla_parent(vha);
 
-	vpmod = dma_pool_alloc(pha->s_dma_pool, GFP_KERNEL, &vpmod_dma);
+	vpmod = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &vpmod_dma);
 	if (!vpmod) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Modify VP "
-		    "IOCB.\n", __func__, pha->host_no));
+		    "IOCB.\n", __func__, vha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 
@@ -2732,26 +2754,27 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 	memcpy(vpmod->port_name_idx1, vha->port_name, WWN_SIZE);
 	vpmod->entry_count = 1;
 
-	rval = qla2x00_issue_iocb(pha, vpmod, vpmod_dma, 0);
+	rval = qla2x00_issue_iocb(base_vha, vpmod, vpmod_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue VP config IOCB"
-			"(%x).\n", __func__, pha->host_no, rval));
+			"(%x).\n", __func__, base_vha->host_no, rval));
 	} else if (vpmod->comp_status != 0) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-			"-- error status (%x).\n", __func__, pha->host_no,
+			"-- error status (%x).\n", __func__, base_vha->host_no,
 			vpmod->comp_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else if (vpmod->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- completion status (%x).\n", __func__, pha->host_no,
+		    "-- completion status (%x).\n", __func__, base_vha->host_no,
 		    le16_to_cpu(vpmod->comp_status)));
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		/* EMPTY */
-		DEBUG11(printk("%s(%ld): done.\n", __func__, pha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__,
+							base_vha->host_no));
 		fc_vport_set_state(vha->fc_vport, FC_VPORT_INITIALIZING);
 	}
-	dma_pool_free(pha->s_dma_pool, vpmod, vpmod_dma);
+	dma_pool_free(ha->s_dma_pool, vpmod, vpmod_dma);
 
 	return rval;
 }
@@ -2778,11 +2801,12 @@ qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	int		map, pos;
 	struct vp_ctrl_entry_24xx   *vce;
 	dma_addr_t	vce_dma;
-	scsi_qla_host_t *ha = vha->parent;
+	struct qla_hw_data *ha = vha->hw;
 	int	vp_index = vha->vp_idx;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
 	DEBUG11(printk("%s(%ld): entered. Enabling index %d\n", __func__,
-	    ha->host_no, vp_index));
+	    vha->host_no, vp_index));
 
 	if (vp_index == 0 || vp_index >= ha->max_npiv_vports)
 		return QLA_PARAMETER_ERROR;
@@ -2791,7 +2815,7 @@ qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	if (!vce) {
 		DEBUG2_3(printk("%s(%ld): "
 		    "failed to allocate VP Control IOCB.\n", __func__,
-		    ha->host_no));
+		    base_vha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(vce, 0, sizeof(struct vp_ctrl_entry_24xx));
@@ -2810,30 +2834,30 @@ qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	vce->vp_idx_map[map] |= 1 << pos;
 	mutex_unlock(&ha->vport_lock);
 
-	rval = qla2x00_issue_iocb(ha, vce, vce_dma, 0);
+	rval = qla2x00_issue_iocb(base_vha, vce, vce_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue VP control IOCB"
-		    "(%x).\n", __func__, ha->host_no, rval));
+		    "(%x).\n", __func__, base_vha->host_no, rval));
 		printk("%s(%ld): failed to issue VP control IOCB"
-		    "(%x).\n", __func__, ha->host_no, rval);
+		    "(%x).\n", __func__, base_vha->host_no, rval);
 	} else if (vce->entry_status != 0) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- error status (%x).\n", __func__, ha->host_no,
+		    "-- error status (%x).\n", __func__, base_vha->host_no,
 		    vce->entry_status));
 		printk("%s(%ld): failed to complete IOCB "
-		    "-- error status (%x).\n", __func__, ha->host_no,
+		    "-- error status (%x).\n", __func__, base_vha->host_no,
 		    vce->entry_status);
 		rval = QLA_FUNCTION_FAILED;
 	} else if (vce->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- completion status (%x).\n", __func__, ha->host_no,
+		    "-- completion status (%x).\n", __func__, base_vha->host_no,
 		    le16_to_cpu(vce->comp_status)));
 		printk("%s(%ld): failed to complete IOCB "
-		    "-- completion status (%x).\n", __func__, ha->host_no,
+		    "-- completion status (%x).\n", __func__, base_vha->host_no,
 		    le16_to_cpu(vce->comp_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else {
-		DEBUG2(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG2(printk("%s(%ld): done.\n", __func__, base_vha->host_no));
 	}
 
 	dma_pool_free(ha->s_dma_pool, vce, vce_dma);
@@ -2863,7 +2887,7 @@ qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
  */
 
 int
-qla2x00_send_change_request(scsi_qla_host_t *ha, uint16_t format,
+qla2x00_send_change_request(scsi_qla_host_t *vha, uint16_t format,
 			    uint16_t vp_idx)
 {
 	int rval;
@@ -2884,7 +2908,7 @@ qla2x00_send_change_request(scsi_qla_host_t *ha, uint16_t format,
 	mcp->in_mb = MBX_0|MBX_1;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval == QLA_SUCCESS) {
 		if (mcp->mb[0] != MBS_COMMAND_COMPLETE) {
@@ -2897,16 +2921,16 @@ qla2x00_send_change_request(scsi_qla_host_t *ha, uint16_t format,
 }
 
 int
-qla2x00_dump_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t addr,
+qla2x00_dump_ram(scsi_qla_host_t *vha, dma_addr_t req_dma, uint32_t addr,
     uint32_t size)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
-	if (MSW(addr) || IS_FWI2_CAPABLE(ha)) {
+	if (MSW(addr) || IS_FWI2_CAPABLE(vha->hw)) {
 		mcp->mb[0] = MBC_DUMP_RISC_RAM_EXTENDED;
 		mcp->mb[8] = MSW(addr);
 		mcp->out_mb = MBX_8|MBX_0;
@@ -2920,7 +2944,7 @@ qla2x00_dump_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t addr,
 	mcp->mb[6] = MSW(MSD(req_dma));
 	mcp->mb[7] = LSW(MSD(req_dma));
 	mcp->out_mb |= MBX_7|MBX_6|MBX_3|MBX_2|MBX_1;
-	if (IS_FWI2_CAPABLE(ha)) {
+	if (IS_FWI2_CAPABLE(vha->hw)) {
 		mcp->mb[4] = MSW(size);
 		mcp->mb[5] = LSW(size);
 		mcp->out_mb |= MBX_5|MBX_4;
@@ -2932,13 +2956,13 @@ qla2x00_dump_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t addr,
 	mcp->in_mb = MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x.\n", __func__,
-		    ha->host_no, rval, mcp->mb[0]));
+		    vha->host_no, rval, mcp->mb[0]));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
@@ -2954,20 +2978,21 @@ struct cs84xx_mgmt_cmd {
 };
 
 int
-qla84xx_verify_chip(struct scsi_qla_host *ha, uint16_t *status)
+qla84xx_verify_chip(struct scsi_qla_host *vha, uint16_t *status)
 {
 	int rval, retry;
 	struct cs84xx_mgmt_cmd *mn;
 	dma_addr_t mn_dma;
 	uint16_t options;
 	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG16(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+	DEBUG16(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mn = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &mn_dma);
 	if (mn == NULL) {
 		DEBUG2_3(printk("%s(%ld): failed to allocate Verify ISP84XX "
-		    "IOCB.\n", __func__, ha->host_no));
+		    "IOCB.\n", __func__, vha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 
@@ -2986,19 +3011,19 @@ qla84xx_verify_chip(struct scsi_qla_host *ha, uint16_t *status)
 		mn->p.req.options = cpu_to_le16(options);
 
 		DEBUG16(printk("%s(%ld): Dump of Verify Request.\n", __func__,
-		    ha->host_no));
+		    vha->host_no));
 		DEBUG16(qla2x00_dump_buffer((uint8_t *)mn,
 		    sizeof(*mn)));
 
-		rval = qla2x00_issue_iocb_timeout(ha, mn, mn_dma, 0, 120);
+		rval = qla2x00_issue_iocb_timeout(vha, mn, mn_dma, 0, 120);
 		if (rval != QLA_SUCCESS) {
 			DEBUG2_16(printk("%s(%ld): failed to issue Verify "
-			    "IOCB (%x).\n", __func__, ha->host_no, rval));
+			    "IOCB (%x).\n", __func__, vha->host_no, rval));
 			goto verify_done;
 		}
 
 		DEBUG16(printk("%s(%ld): Dump of Verify Response.\n", __func__,
-		    ha->host_no));
+		    vha->host_no));
 		DEBUG16(qla2x00_dump_buffer((uint8_t *)mn,
 		    sizeof(*mn)));
 
@@ -3006,21 +3031,21 @@ qla84xx_verify_chip(struct scsi_qla_host *ha, uint16_t *status)
 		status[1] = status[0] == CS_VCS_CHIP_FAILURE ?
 		    le16_to_cpu(mn->p.rsp.failure_code) : 0;
 		DEBUG2_16(printk("%s(%ld): cs=%x fc=%x\n", __func__,
-		    ha->host_no, status[0], status[1]));
+		    vha->host_no, status[0], status[1]));
 
 		if (status[0] != CS_COMPLETE) {
 			rval = QLA_FUNCTION_FAILED;
 			if (!(options & VCO_DONT_UPDATE_FW)) {
 				DEBUG2_16(printk("%s(%ld): Firmware update "
 				    "failed. Retrying without update "
-				    "firmware.\n", __func__, ha->host_no));
+				    "firmware.\n", __func__, vha->host_no));
 				options |= VCO_DONT_UPDATE_FW;
 				options &= ~VCO_FORCE_UPDATE;
 				retry = 1;
 			}
 		} else {
 			DEBUG2_16(printk("%s(%ld): firmware updated to %x.\n",
-			    __func__, ha->host_no,
+			    __func__, vha->host_no,
 			    le32_to_cpu(mn->p.rsp.fw_ver)));
 
 			/* NOTE: we only update OP firmware. */
@@ -3037,9 +3062,9 @@ verify_done:
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_16(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval));
+		    vha->host_no, rval));
 	} else {
-		DEBUG16(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		DEBUG16(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
 
 	return rval;
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 93560cd..da3db3a 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -5,6 +5,7 @@
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
+#include "qla_gbl.h"
 
 #include <linux/moduleparam.h>
 #include <linux/vmalloc.h>
@@ -18,7 +19,7 @@
 void
 qla2x00_vp_stop_timer(scsi_qla_host_t *vha)
 {
-	if (vha->parent && vha->timer_active) {
+	if (vha->vp_idx && vha->timer_active) {
 		del_timer_sync(&vha->timer);
 		vha->timer_active = 0;
 	}
@@ -28,7 +29,7 @@ static uint32_t
 qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 {
 	uint32_t vp_id;
-	scsi_qla_host_t *ha = vha->parent;
+	struct qla_hw_data *ha = vha->hw;
 
 	/* Find an empty slot and assign an vp_id */
 	mutex_lock(&ha->vport_lock);
@@ -44,7 +45,7 @@ qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 	ha->num_vhosts++;
 	ha->cur_vport_count++;
 	vha->vp_idx = vp_id;
-	list_add_tail(&vha->vp_list, &ha->vp_list);
+	list_add_tail(&vha->list, &ha->vp_list);
 	mutex_unlock(&ha->vport_lock);
 	return vp_id;
 }
@@ -53,24 +54,24 @@ void
 qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 {
 	uint16_t vp_id;
-	scsi_qla_host_t *ha = vha->parent;
+	struct qla_hw_data *ha = vha->hw;
 
 	mutex_lock(&ha->vport_lock);
 	vp_id = vha->vp_idx;
 	ha->num_vhosts--;
 	ha->cur_vport_count--;
 	clear_bit(vp_id, ha->vp_idx_map);
-	list_del(&vha->vp_list);
+	list_del(&vha->list);
 	mutex_unlock(&ha->vport_lock);
 }
 
 static scsi_qla_host_t *
-qla24xx_find_vhost_by_name(scsi_qla_host_t *ha, uint8_t *port_name)
+qla24xx_find_vhost_by_name(struct qla_hw_data *ha, uint8_t *port_name)
 {
 	scsi_qla_host_t *vha;
 
 	/* Locate matching device in database. */
-	list_for_each_entry(vha, &ha->vp_list, vp_list) {
+	list_for_each_entry(vha, &ha->vp_list, list) {
 		if (!memcmp(port_name, vha->port_name, WWN_SIZE))
 			return vha;
 	}
@@ -94,12 +95,8 @@ static void
 qla2x00_mark_vp_devices_dead(scsi_qla_host_t *vha)
 {
 	fc_port_t *fcport;
-	scsi_qla_host_t *pha = to_qla_parent(vha);
-
-	list_for_each_entry(fcport, &pha->fcports, list) {
-		if (fcport->vp_idx != vha->vp_idx)
-			continue;
 
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
 		DEBUG15(printk("scsi(%ld): Marking port dead, "
 		    "loop_id=0x%04x :%x\n",
 		    vha->host_no, fcport->loop_id, fcport->vp_idx));
@@ -118,7 +115,6 @@ qla24xx_disable_vp(scsi_qla_host_t *vha)
 	atomic_set(&vha->loop_state, LOOP_DOWN);
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 
-	/* Delete all vp's fcports from parent's list */
 	qla2x00_mark_vp_devices_dead(vha);
 	atomic_set(&vha->vp_state, VP_FAILED);
 	vha->flags.management_server_logged_in = 0;
@@ -135,11 +131,12 @@ int
 qla24xx_enable_vp(scsi_qla_host_t *vha)
 {
 	int ret;
-	scsi_qla_host_t *ha = vha->parent;
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	/* Check if physical ha port is Up */
-	if (atomic_read(&ha->loop_state) == LOOP_DOWN  ||
-		atomic_read(&ha->loop_state) == LOOP_DEAD ) {
+	if (atomic_read(&base_vha->loop_state) == LOOP_DOWN  ||
+		atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
 		vha->vp_err_state =  VP_ERR_PORTDWN;
 		fc_vport_set_state(vha->fc_vport, FC_VPORT_LINKDOWN);
 		goto enable_failed;
@@ -177,8 +174,8 @@ qla24xx_configure_vp(scsi_qla_host_t *vha)
 	    vha->host_no, __func__));
 	ret = qla2x00_send_change_request(vha, 0x3, vha->vp_idx);
 	if (ret != QLA_SUCCESS) {
-		DEBUG15(qla_printk(KERN_ERR, vha, "Failed to enable receiving"
-		    " of RSCN requests: 0x%x\n", ret));
+		DEBUG15(qla_printk(KERN_ERR, vha->hw, "Failed to enable "
+		    "receiving of RSCN requests: 0x%x\n", ret));
 		return;
 	} else {
 		/* Corresponds to SCR enabled */
@@ -194,25 +191,13 @@ qla24xx_configure_vp(scsi_qla_host_t *vha)
 }
 
 void
-qla2x00_alert_all_vps(scsi_qla_host_t *ha, uint16_t *mb)
+qla2x00_alert_all_vps(struct qla_hw_data *ha, uint16_t *mb)
 {
-	int i, vp_idx_matched;
 	scsi_qla_host_t *vha;
+	int i = 0;
 
-	if (ha->parent)
-		return;
-
-	for_each_mapped_vp_idx(ha, i) {
-		vp_idx_matched = 0;
-
-		list_for_each_entry(vha, &ha->vp_list, vp_list) {
-			if (i == vha->vp_idx) {
-				vp_idx_matched = 1;
-				break;
-			}
-		}
-
-		if (vp_idx_matched) {
+	list_for_each_entry(vha, &ha->vp_list, list) {
+		if (vha->vp_idx) {
 			switch (mb[0]) {
 			case MBA_LIP_OCCURRED:
 			case MBA_LOOP_UP:
@@ -223,16 +208,17 @@ qla2x00_alert_all_vps(scsi_qla_host_t *ha, uint16_t *mb)
 			case MBA_PORT_UPDATE:
 			case MBA_RSCN_UPDATE:
 				DEBUG15(printk("scsi(%ld)%s: Async_event for"
-				    " VP[%d], mb = 0x%x, vha=%p\n",
-				    vha->host_no, __func__,i, *mb, vha));
+				" VP[%d], mb = 0x%x, vha=%p\n",
+				vha->host_no, __func__, i, *mb, vha));
 				qla2x00_async_event(vha, mb);
 				break;
 			}
 		}
+		i++;
 	}
 }
 
-void
+int
 qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
 {
 	/*
@@ -247,30 +233,49 @@ qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
 			atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 	}
 
+	/* To exclusively reset vport, we need to log it out first.*/
+	if (!test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
+		qla24xx_control_vp(vha, VCE_COMMAND_DISABLE_VPS_LOGO_ALL);
+
 	DEBUG15(printk("scsi(%ld): Scheduling enable of Vport %d...\n",
 	    vha->host_no, vha->vp_idx));
-	qla24xx_enable_vp(vha);
+	return qla24xx_enable_vp(vha);
 }
 
 static int
 qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 {
-	scsi_qla_host_t *ha = vha->parent;
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	if (test_and_clear_bit(VP_IDX_ACQUIRED, &vha->vp_flags)) {
 		/* VP acquired. complete port configuration */
-		if (atomic_read(&ha->loop_state) == LOOP_READY) {
+		if (atomic_read(&base_vha->loop_state) == LOOP_READY) {
 			qla24xx_configure_vp(vha);
 		} else {
 			set_bit(VP_IDX_ACQUIRED, &vha->vp_flags);
-			set_bit(VP_DPC_NEEDED, &ha->dpc_flags);
+			set_bit(VP_DPC_NEEDED, &base_vha->dpc_flags);
 		}
 
 		return 0;
 	}
 
-	if (test_and_clear_bit(ISP_ABORT_NEEDED, &vha->dpc_flags))
-		qla2x00_vp_abort_isp(vha);
+	if (test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags)) {
+		qla2x00_update_fcports(vha);
+		clear_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags);
+	}
+
+	if ((test_and_clear_bit(RELOGIN_NEEDED, &vha->dpc_flags)) &&
+		!test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags) &&
+		atomic_read(&vha->loop_state) != LOOP_DOWN) {
+
+		DEBUG(printk("scsi(%ld): qla2x00_port_login()\n",
+						vha->host_no));
+		qla2x00_relogin(vha);
+
+		DEBUG(printk("scsi(%ld): qla2x00_port_login - end\n",
+							vha->host_no));
+	}
 
 	if (test_and_clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags) &&
 	    (!(test_and_set_bit(RESET_ACTIVE, &vha->dpc_flags)))) {
@@ -289,38 +294,30 @@ qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 }
 
 void
-qla2x00_do_dpc_all_vps(scsi_qla_host_t *ha)
+qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 {
 	int ret;
-	int i, vp_idx_matched;
-	scsi_qla_host_t *vha;
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *vp;
 
-	if (ha->parent)
+	if (vha->vp_idx)
 		return;
 	if (list_empty(&ha->vp_list))
 		return;
 
-	clear_bit(VP_DPC_NEEDED, &ha->dpc_flags);
-
-	for_each_mapped_vp_idx(ha, i) {
-		vp_idx_matched = 0;
-
-		list_for_each_entry(vha, &ha->vp_list, vp_list) {
-			if (i == vha->vp_idx) {
-				vp_idx_matched = 1;
-				break;
-			}
-		}
+	clear_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 
-		if (vp_idx_matched)
-			ret = qla2x00_do_dpc_vp(vha);
+	list_for_each_entry(vp, &ha->vp_list, list) {
+		if (vp->vp_idx)
+			ret = qla2x00_do_dpc_vp(vp);
 	}
 }
 
 int
 qla24xx_vport_create_req_sanity_check(struct fc_vport *fc_vport)
 {
-	scsi_qla_host_t *ha = shost_priv(fc_vport->shost);
+	scsi_qla_host_t *base_vha = shost_priv(fc_vport->shost);
+	struct qla_hw_data *ha = base_vha->hw;
 	scsi_qla_host_t *vha;
 	uint8_t port_name[WWN_SIZE];
 
@@ -337,7 +334,7 @@ qla24xx_vport_create_req_sanity_check(struct fc_vport *fc_vport)
 
 	/* Check up unique WWPN */
 	u64_to_wwn(fc_vport->port_name, port_name);
-	if (!memcmp(port_name, ha->port_name, WWN_SIZE))
+	if (!memcmp(port_name, base_vha->port_name, WWN_SIZE))
 		return VPCERR_BAD_WWN;
 	vha = qla24xx_find_vhost_by_name(ha, port_name);
 	if (vha)
@@ -346,7 +343,7 @@ qla24xx_vport_create_req_sanity_check(struct fc_vport *fc_vport)
 	/* Check up max-npiv-supports */
 	if (ha->num_vhosts > ha->max_npiv_vports) {
 		DEBUG15(printk("scsi(%ld): num_vhosts %ud is bigger than "
-		    "max_npv_vports %ud.\n", ha->host_no,
+		    "max_npv_vports %ud.\n", base_vha->host_no,
 		    ha->num_vhosts, ha->max_npiv_vports));
 		return VPCERR_UNSUPPORTED;
 	}
@@ -356,59 +353,35 @@ qla24xx_vport_create_req_sanity_check(struct fc_vport *fc_vport)
 scsi_qla_host_t *
 qla24xx_create_vhost(struct fc_vport *fc_vport)
 {
-	scsi_qla_host_t *ha = shost_priv(fc_vport->shost);
+	scsi_qla_host_t *base_vha = shost_priv(fc_vport->shost);
+	struct qla_hw_data *ha = base_vha->hw;
 	scsi_qla_host_t *vha;
+	struct scsi_host_template *sht = &qla24xx_driver_template;
 	struct Scsi_Host *host;
 
-	host = scsi_host_alloc(&qla24xx_driver_template,
-	    sizeof(scsi_qla_host_t));
-	if (!host) {
-		printk(KERN_WARNING
-		    "qla2xxx: scsi_host_alloc() failed for vport\n");
+	vha = qla2x00_create_host(sht, ha);
+	if (!vha) {
+		DEBUG(printk("qla2xxx: scsi_host_alloc() failed for vport\n"));
 		return(NULL);
 	}
 
-	vha = shost_priv(host);
-
-	/* clone the parent hba */
-	memcpy(vha, ha, sizeof (scsi_qla_host_t));
-
+	host = vha->host;
 	fc_vport->dd_data = vha;
 
-	vha->node_name = kmalloc(WWN_SIZE * sizeof(char), GFP_KERNEL);
-	if (!vha->node_name)
-		goto create_vhost_failed_1;
-
-	vha->port_name = kmalloc(WWN_SIZE * sizeof(char), GFP_KERNEL);
-	if (!vha->port_name)
-		goto create_vhost_failed_2;
-
 	/* New host info */
 	u64_to_wwn(fc_vport->node_name, vha->node_name);
 	u64_to_wwn(fc_vport->port_name, vha->port_name);
 
-	vha->host = host;
-	vha->host_no = host->host_no;
-	vha->parent = ha;
 	vha->fc_vport = fc_vport;
 	vha->device_flags = 0;
 	vha->vp_idx = qla24xx_allocate_vp_id(vha);
 	if (vha->vp_idx > ha->max_npiv_vports) {
 		DEBUG15(printk("scsi(%ld): Couldn't allocate vp_id.\n",
 			vha->host_no));
-		goto create_vhost_failed_3;
+		goto create_vhost_failed;
 	}
 	vha->mgmt_svr_loop_id = 10 + vha->vp_idx;
 
-	init_completion(&vha->mbx_cmd_comp);
-	complete(&vha->mbx_cmd_comp);
-	init_completion(&vha->mbx_intr_comp);
-
-	INIT_LIST_HEAD(&vha->list);
-	INIT_LIST_HEAD(&vha->fcports);
-	INIT_LIST_HEAD(&vha->vp_fcports);
-	INIT_LIST_HEAD(&vha->work_list);
-
 	vha->dpc_flags = 0L;
 	set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
 	set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
@@ -423,7 +396,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 
 	qla2x00_start_timer(vha, qla2x00_timer, WATCH_INTERVAL);
 
-	host->can_queue = vha->request_q_length + 128;
+	host->can_queue = ha->req->length + 128;
 	host->this_id = 255;
 	host->cmd_per_lun = 3;
 	host->max_cmd_len = MAX_CMDSZ;
@@ -440,12 +413,6 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 
 	return vha;
 
-create_vhost_failed_3:
-	kfree(vha->port_name);
-
-create_vhost_failed_2:
-	kfree(vha->node_name);
-
-create_vhost_failed_1:
+create_vhost_failed:
 	return NULL;
 }
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 90a1321..376cd2a 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -10,10 +10,6 @@
 #include <linux/vmalloc.h>
 #include <asm/uaccess.h>
 
-static uint16_t qla2x00_nvram_request(scsi_qla_host_t *, uint32_t);
-static void qla2x00_nv_deselect(scsi_qla_host_t *);
-static void qla2x00_nv_write(scsi_qla_host_t *, uint16_t);
-
 /*
  * NVRAM support routines
  */
@@ -23,7 +19,7 @@ static void qla2x00_nv_write(scsi_qla_host_t *, uint16_t);
  * @ha: HA context
  */
 static void
-qla2x00_lock_nvram_access(scsi_qla_host_t *ha)
+qla2x00_lock_nvram_access(struct qla_hw_data *ha)
 {
 	uint16_t data;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -56,7 +52,7 @@ qla2x00_lock_nvram_access(scsi_qla_host_t *ha)
  * @ha: HA context
  */
 static void
-qla2x00_unlock_nvram_access(scsi_qla_host_t *ha)
+qla2x00_unlock_nvram_access(struct qla_hw_data *ha)
 {
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
@@ -67,6 +63,84 @@ qla2x00_unlock_nvram_access(scsi_qla_host_t *ha)
 }
 
 /**
+ * qla2x00_nv_write() - Prepare for NVRAM read/write operation.
+ * @ha: HA context
+ * @data: Serial interface selector
+ */
+static void
+qla2x00_nv_write(struct qla_hw_data *ha, uint16_t data)
+{
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+
+	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT | NVR_WRT_ENABLE);
+	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	NVRAM_DELAY();
+	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT | NVR_CLOCK |
+	    NVR_WRT_ENABLE);
+	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	NVRAM_DELAY();
+	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT | NVR_WRT_ENABLE);
+	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	NVRAM_DELAY();
+}
+
+/**
+ * qla2x00_nvram_request() - Sends read command to NVRAM and gets data from
+ *	NVRAM.
+ * @ha: HA context
+ * @nv_cmd: NVRAM command
+ *
+ * Bit definitions for NVRAM command:
+ *
+ *	Bit 26     = start bit
+ *	Bit 25, 24 = opcode
+ *	Bit 23-16  = address
+ *	Bit 15-0   = write data
+ *
+ * Returns the word read from nvram @addr.
+ */
+static uint16_t
+qla2x00_nvram_request(struct qla_hw_data *ha, uint32_t nv_cmd)
+{
+	uint8_t		cnt;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+	uint16_t	data = 0;
+	uint16_t	reg_data;
+
+	/* Send command to NVRAM. */
+	nv_cmd <<= 5;
+	for (cnt = 0; cnt < 11; cnt++) {
+		if (nv_cmd & BIT_31)
+			qla2x00_nv_write(ha, NVR_DATA_OUT);
+		else
+			qla2x00_nv_write(ha, 0);
+		nv_cmd <<= 1;
+	}
+
+	/* Read data from NVRAM. */
+	for (cnt = 0; cnt < 16; cnt++) {
+		WRT_REG_WORD(&reg->nvram, NVR_SELECT | NVR_CLOCK);
+		RD_REG_WORD(&reg->nvram);	/* PCI Posting. */
+		NVRAM_DELAY();
+		data <<= 1;
+		reg_data = RD_REG_WORD(&reg->nvram);
+		if (reg_data & NVR_DATA_IN)
+			data |= BIT_0;
+		WRT_REG_WORD(&reg->nvram, NVR_SELECT);
+		RD_REG_WORD(&reg->nvram);	/* PCI Posting. */
+		NVRAM_DELAY();
+	}
+
+	/* Deselect chip. */
+	WRT_REG_WORD(&reg->nvram, NVR_DESELECT);
+	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	NVRAM_DELAY();
+
+	return data;
+}
+
+
+/**
  * qla2x00_get_nvram_word() - Calculates word position in NVRAM and calls the
  *	request routine to get the word from NVRAM.
  * @ha: HA context
@@ -75,7 +149,7 @@ qla2x00_unlock_nvram_access(scsi_qla_host_t *ha)
  * Returns the word read from nvram @addr.
  */
 static uint16_t
-qla2x00_get_nvram_word(scsi_qla_host_t *ha, uint32_t addr)
+qla2x00_get_nvram_word(struct qla_hw_data *ha, uint32_t addr)
 {
 	uint16_t	data;
 	uint32_t	nv_cmd;
@@ -88,13 +162,27 @@ qla2x00_get_nvram_word(scsi_qla_host_t *ha, uint32_t addr)
 }
 
 /**
+ * qla2x00_nv_deselect() - Deselect NVRAM operations.
+ * @ha: HA context
+ */
+static void
+qla2x00_nv_deselect(struct qla_hw_data *ha)
+{
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+
+	WRT_REG_WORD(&reg->nvram, NVR_DESELECT);
+	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
+	NVRAM_DELAY();
+}
+
+/**
  * qla2x00_write_nvram_word() - Write NVRAM data.
  * @ha: HA context
  * @addr: Address in NVRAM to write
  * @data: word to program
  */
 static void
-qla2x00_write_nvram_word(scsi_qla_host_t *ha, uint32_t addr, uint16_t data)
+qla2x00_write_nvram_word(struct qla_hw_data *ha, uint32_t addr, uint16_t data)
 {
 	int count;
 	uint16_t word;
@@ -132,7 +220,7 @@ qla2x00_write_nvram_word(scsi_qla_host_t *ha, uint32_t addr, uint16_t data)
 	do {
 		if (!--wait_cnt) {
 			DEBUG9_10(printk("%s(%ld): NVRAM didn't go ready...\n",
-			    __func__, ha->host_no));
+			    __func__, vha->host_no));
 			break;
 		}
 		NVRAM_DELAY();
@@ -150,8 +238,8 @@ qla2x00_write_nvram_word(scsi_qla_host_t *ha, uint32_t addr, uint16_t data)
 }
 
 static int
-qla2x00_write_nvram_word_tmo(scsi_qla_host_t *ha, uint32_t addr, uint16_t data,
-    uint32_t tmo)
+qla2x00_write_nvram_word_tmo(struct qla_hw_data *ha, uint32_t addr,
+	uint16_t data, uint32_t tmo)
 {
 	int ret, count;
 	uint16_t word;
@@ -209,102 +297,11 @@ qla2x00_write_nvram_word_tmo(scsi_qla_host_t *ha, uint32_t addr, uint16_t data,
 }
 
 /**
- * qla2x00_nvram_request() - Sends read command to NVRAM and gets data from
- *	NVRAM.
- * @ha: HA context
- * @nv_cmd: NVRAM command
- *
- * Bit definitions for NVRAM command:
- *
- *	Bit 26     = start bit
- *	Bit 25, 24 = opcode
- *	Bit 23-16  = address
- *	Bit 15-0   = write data
- *
- * Returns the word read from nvram @addr.
- */
-static uint16_t
-qla2x00_nvram_request(scsi_qla_host_t *ha, uint32_t nv_cmd)
-{
-	uint8_t		cnt;
-	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
-	uint16_t	data = 0;
-	uint16_t	reg_data;
-
-	/* Send command to NVRAM. */
-	nv_cmd <<= 5;
-	for (cnt = 0; cnt < 11; cnt++) {
-		if (nv_cmd & BIT_31)
-			qla2x00_nv_write(ha, NVR_DATA_OUT);
-		else
-			qla2x00_nv_write(ha, 0);
-		nv_cmd <<= 1;
-	}
-
-	/* Read data from NVRAM. */
-	for (cnt = 0; cnt < 16; cnt++) {
-		WRT_REG_WORD(&reg->nvram, NVR_SELECT | NVR_CLOCK);
-		RD_REG_WORD(&reg->nvram);	/* PCI Posting. */
-		NVRAM_DELAY();
-		data <<= 1;
-		reg_data = RD_REG_WORD(&reg->nvram);
-		if (reg_data & NVR_DATA_IN)
-			data |= BIT_0;
-		WRT_REG_WORD(&reg->nvram, NVR_SELECT);
-		RD_REG_WORD(&reg->nvram);	/* PCI Posting. */
-		NVRAM_DELAY();
-	}
-
-	/* Deselect chip. */
-	WRT_REG_WORD(&reg->nvram, NVR_DESELECT);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
-	NVRAM_DELAY();
-
-	return (data);
-}
-
-/**
- * qla2x00_nv_write() - Clean NVRAM operations.
- * @ha: HA context
- */
-static void
-qla2x00_nv_deselect(scsi_qla_host_t *ha)
-{
-	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
-
-	WRT_REG_WORD(&reg->nvram, NVR_DESELECT);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
-	NVRAM_DELAY();
-}
-
-/**
- * qla2x00_nv_write() - Prepare for NVRAM read/write operation.
- * @ha: HA context
- * @data: Serial interface selector
- */
-static void
-qla2x00_nv_write(scsi_qla_host_t *ha, uint16_t data)
-{
-	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
-
-	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT | NVR_WRT_ENABLE);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
-	NVRAM_DELAY();
-	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT| NVR_CLOCK |
-	    NVR_WRT_ENABLE);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
-	NVRAM_DELAY();
-	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT | NVR_WRT_ENABLE);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
-	NVRAM_DELAY();
-}
-
-/**
  * qla2x00_clear_nvram_protection() -
  * @ha: HA context
  */
 static int
-qla2x00_clear_nvram_protection(scsi_qla_host_t *ha)
+qla2x00_clear_nvram_protection(struct qla_hw_data *ha)
 {
 	int ret, stat;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -352,9 +349,8 @@ qla2x00_clear_nvram_protection(scsi_qla_host_t *ha)
 		wait_cnt = NVR_WAIT_CNT;
 		do {
 			if (!--wait_cnt) {
-				DEBUG9_10(printk("%s(%ld): NVRAM didn't go "
-				    "ready...\n", __func__,
-				    ha->host_no));
+				DEBUG9_10(qla_printk(
+				    "NVRAM didn't go ready...\n"));
 				break;
 			}
 			NVRAM_DELAY();
@@ -370,7 +366,7 @@ qla2x00_clear_nvram_protection(scsi_qla_host_t *ha)
 }
 
 static void
-qla2x00_set_nvram_protection(scsi_qla_host_t *ha, int stat)
+qla2x00_set_nvram_protection(struct qla_hw_data *ha, int stat)
 {
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint32_t word, wait_cnt;
@@ -412,8 +408,7 @@ qla2x00_set_nvram_protection(scsi_qla_host_t *ha, int stat)
 	wait_cnt = NVR_WAIT_CNT;
 	do {
 		if (!--wait_cnt) {
-			DEBUG9_10(printk("%s(%ld): NVRAM didn't go ready...\n",
-			    __func__, ha->host_no));
+			DEBUG9_10(qla_printk("NVRAM didn't go ready...\n"));
 			break;
 		}
 		NVRAM_DELAY();
@@ -454,7 +449,7 @@ nvram_data_to_access_addr(uint32_t naddr)
 }
 
 static uint32_t
-qla24xx_read_flash_dword(scsi_qla_host_t *ha, uint32_t addr)
+qla24xx_read_flash_dword(struct qla_hw_data *ha, uint32_t addr)
 {
 	int rval;
 	uint32_t cnt, data;
@@ -482,21 +477,20 @@ qla24xx_read_flash_dword(scsi_qla_host_t *ha, uint32_t addr)
 }
 
 uint32_t *
-qla24xx_read_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
+qla24xx_read_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
     uint32_t dwords)
 {
 	uint32_t i;
-
 	/* Dword reads to flash. */
 	for (i = 0; i < dwords; i++, faddr++)
-		dwptr[i] = cpu_to_le32(qla24xx_read_flash_dword(ha,
+		dwptr[i] = cpu_to_le32(qla24xx_read_flash_dword(vha->hw,
 		    flash_data_to_access_addr(faddr)));
 
 	return dwptr;
 }
 
 static int
-qla24xx_write_flash_dword(scsi_qla_host_t *ha, uint32_t addr, uint32_t data)
+qla24xx_write_flash_dword(struct qla_hw_data *ha, uint32_t addr, uint32_t data)
 {
 	int rval;
 	uint32_t cnt;
@@ -519,7 +513,7 @@ qla24xx_write_flash_dword(scsi_qla_host_t *ha, uint32_t addr, uint32_t data)
 }
 
 static void
-qla24xx_get_flash_manufacturer(scsi_qla_host_t *ha, uint8_t *man_id,
+qla24xx_get_flash_manufacturer(struct qla_hw_data *ha, uint8_t *man_id,
     uint8_t *flash_id)
 {
 	uint32_t ids;
@@ -544,7 +538,7 @@ qla24xx_get_flash_manufacturer(scsi_qla_host_t *ha, uint8_t *man_id,
 }
 
 static int
-qla2xxx_find_flt_start(scsi_qla_host_t *ha, uint32_t *start)
+qla2xxx_find_flt_start(scsi_qla_host_t *vha, uint32_t *start)
 {
 	const char *loc, *locations[] = { "DEF", "PCI" };
 	uint32_t pcihdr, pcids;
@@ -552,6 +546,8 @@ qla2xxx_find_flt_start(scsi_qla_host_t *ha, uint32_t *start)
 	uint8_t *buf, *bcode, last_image;
 	uint16_t cnt, chksum, *wptr;
 	struct qla_flt_location *fltl;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
 	/*
 	 * FLT-location structure resides after the last PCI region.
@@ -563,20 +559,20 @@ qla2xxx_find_flt_start(scsi_qla_host_t *ha, uint32_t *start)
 	    FA_FLASH_LAYOUT_ADDR;
 
 	/* Begin with first PCI expansion ROM header. */
-	buf = (uint8_t *)ha->request_ring;
-	dcode = (uint32_t *)ha->request_ring;
+	buf = (uint8_t *)req->ring;
+	dcode = (uint32_t *)req->ring;
 	pcihdr = 0;
 	last_image = 1;
 	do {
 		/* Verify PCI expansion ROM header. */
-		qla24xx_read_flash_data(ha, dcode, pcihdr >> 2, 0x20);
+		qla24xx_read_flash_data(vha, dcode, pcihdr >> 2, 0x20);
 		bcode = buf + (pcihdr % 4);
 		if (bcode[0x0] != 0x55 || bcode[0x1] != 0xaa)
 			goto end;
 
 		/* Locate PCI data structure. */
 		pcids = pcihdr + ((bcode[0x19] << 8) | bcode[0x18]);
-		qla24xx_read_flash_data(ha, dcode, pcids >> 2, 0x20);
+		qla24xx_read_flash_data(vha, dcode, pcids >> 2, 0x20);
 		bcode = buf + (pcihdr % 4);
 
 		/* Validate signature of PCI data structure. */
@@ -591,14 +587,14 @@ qla2xxx_find_flt_start(scsi_qla_host_t *ha, uint32_t *start)
 	} while (!last_image);
 
 	/* Now verify FLT-location structure. */
-	fltl = (struct qla_flt_location *)ha->request_ring;
-	qla24xx_read_flash_data(ha, dcode, pcihdr >> 2,
+	fltl = (struct qla_flt_location *)req->ring;
+	qla24xx_read_flash_data(vha, dcode, pcihdr >> 2,
 	    sizeof(struct qla_flt_location) >> 2);
 	if (fltl->sig[0] != 'Q' || fltl->sig[1] != 'F' ||
 	    fltl->sig[2] != 'L' || fltl->sig[3] != 'T')
 		goto end;
 
-	wptr = (uint16_t *)ha->request_ring;
+	wptr = (uint16_t *)req->ring;
 	cnt = sizeof(struct qla_flt_location) >> 1;
 	for (chksum = 0; cnt; cnt--)
 		chksum += le16_to_cpu(*wptr++);
@@ -619,7 +615,7 @@ end:
 }
 
 static void
-qla2xxx_get_flt_info(scsi_qla_host_t *ha, uint32_t flt_addr)
+qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 {
 	const char *loc, *locations[] = { "DEF", "FLT" };
 	uint16_t *wptr;
@@ -627,12 +623,14 @@ qla2xxx_get_flt_info(scsi_qla_host_t *ha, uint32_t flt_addr)
 	uint32_t start;
 	struct qla_flt_header *flt;
 	struct qla_flt_region *region;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
 	ha->flt_region_flt = flt_addr;
-	wptr = (uint16_t *)ha->request_ring;
-	flt = (struct qla_flt_header *)ha->request_ring;
+	wptr = (uint16_t *)req->ring;
+	flt = (struct qla_flt_header *)req->ring;
 	region = (struct qla_flt_region *)&flt[1];
-	ha->isp_ops->read_optrom(ha, (uint8_t *)ha->request_ring,
+	ha->isp_ops->read_optrom(vha, (uint8_t *)req->ring,
 	    flt_addr << 2, OPTROM_BURST_SIZE);
 	if (*wptr == __constant_cpu_to_le16(0xffff))
 		goto no_flash_data;
@@ -720,7 +718,7 @@ done:
 }
 
 static void
-qla2xxx_get_fdt_info(scsi_qla_host_t *ha)
+qla2xxx_get_fdt_info(scsi_qla_host_t *vha)
 {
 #define FLASH_BLK_SIZE_32K	0x8000
 #define FLASH_BLK_SIZE_64K	0x10000
@@ -730,10 +728,12 @@ qla2xxx_get_fdt_info(scsi_qla_host_t *ha)
 	struct qla_fdt_layout *fdt;
 	uint8_t	man_id, flash_id;
 	uint16_t mid, fid;
+	struct qla_hw_data *ha = vha->hw;
+	struct req_que *req = ha->req;
 
-	wptr = (uint16_t *)ha->request_ring;
-	fdt = (struct qla_fdt_layout *)ha->request_ring;
-	ha->isp_ops->read_optrom(ha, (uint8_t *)ha->request_ring,
+	wptr = (uint16_t *)req->ring;
+	fdt = (struct qla_fdt_layout *)req->ring;
+	ha->isp_ops->read_optrom(vha, (uint8_t *)req->ring,
 	    ha->flt_region_fdt << 2, OPTROM_BURST_SIZE);
 	if (*wptr == __constant_cpu_to_le16(0xffff))
 		goto no_flash_data;
@@ -808,26 +808,27 @@ done:
 }
 
 int
-qla2xxx_get_flash_info(scsi_qla_host_t *ha)
+qla2xxx_get_flash_info(scsi_qla_host_t *vha)
 {
 	int ret;
 	uint32_t flt_addr;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha))
 		return QLA_SUCCESS;
 
-	ret = qla2xxx_find_flt_start(ha, &flt_addr);
+	ret = qla2xxx_find_flt_start(vha, &flt_addr);
 	if (ret != QLA_SUCCESS)
 		return ret;
 
-	qla2xxx_get_flt_info(ha, flt_addr);
-	qla2xxx_get_fdt_info(ha);
+	qla2xxx_get_flt_info(vha, flt_addr);
+	qla2xxx_get_fdt_info(vha);
 
 	return QLA_SUCCESS;
 }
 
 void
-qla2xxx_flash_npiv_conf(scsi_qla_host_t *ha)
+qla2xxx_flash_npiv_conf(scsi_qla_host_t *vha)
 {
 #define NPIV_CONFIG_SIZE	(16*1024)
 	void *data;
@@ -835,11 +836,12 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *ha)
 	uint16_t cnt, chksum;
 	struct qla_npiv_header hdr;
 	struct qla_npiv_entry *entry;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha))
 		return;
 
-	ha->isp_ops->read_optrom(ha, (uint8_t *)&hdr,
+	ha->isp_ops->read_optrom(vha, (uint8_t *)&hdr,
 	    ha->flt_region_npiv_conf << 2, sizeof(struct qla_npiv_header));
 	if (hdr.version == __constant_cpu_to_le16(0xffff))
 		return;
@@ -858,7 +860,7 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *ha)
 		return;
 	}
 
-	ha->isp_ops->read_optrom(ha, (uint8_t *)data,
+	ha->isp_ops->read_optrom(vha, (uint8_t *)data,
 	    ha->flt_region_npiv_conf << 2, NPIV_CONFIG_SIZE);
 
 	cnt = (sizeof(struct qla_npiv_header) + le16_to_cpu(hdr.entries) *
@@ -894,24 +896,22 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *ha)
 		vid.node_name = wwn_to_u64(entry->node_name);
 
 		DEBUG2(qla_printk(KERN_DEBUG, ha, "NPIV[%02x]: wwpn=%llx "
-		    "wwnn=%llx vf_id=0x%x qos=0x%x.\n", cnt,
-		    (unsigned long long)vid.port_name,
-		    (unsigned long long)vid.node_name,
-		    le16_to_cpu(entry->vf_id), le16_to_cpu(entry->qos)));
+		    "wwnn=%llx vf_id=0x%x qos=0x%x.\n", cnt, vid.port_name,
+		    vid.node_name, le16_to_cpu(entry->vf_id),
+		    le16_to_cpu(entry->qos)));
 
-		vport = fc_vport_create(ha->host, 0, &vid);
+		vport = fc_vport_create(vha->host, 0, &vid);
 		if (!vport)
 			qla_printk(KERN_INFO, ha, "NPIV-Config: Failed to "
 			    "create vport [%02x]: wwpn=%llx wwnn=%llx.\n", cnt,
-			    (unsigned long long)vid.port_name,
-			    (unsigned long long)vid.node_name);
+			    vid.port_name, vid.node_name);
 	}
 done:
 	kfree(data);
 }
 
 static void
-qla24xx_unprotect_flash(scsi_qla_host_t *ha)
+qla24xx_unprotect_flash(struct qla_hw_data *ha)
 {
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
@@ -930,7 +930,7 @@ qla24xx_unprotect_flash(scsi_qla_host_t *ha)
 }
 
 static void
-qla24xx_protect_flash(scsi_qla_host_t *ha)
+qla24xx_protect_flash(struct qla_hw_data *ha)
 {
 	uint32_t cnt;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
@@ -956,7 +956,7 @@ skip_wrt_protect:
 }
 
 static int
-qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
+qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
     uint32_t dwords)
 {
 	int ret;
@@ -966,6 +966,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 	dma_addr_t optrom_dma;
 	void *optrom = NULL;
 	uint32_t *s, *d;
+	struct qla_hw_data *ha = vha->hw;
 
 	ret = QLA_SUCCESS;
 
@@ -1007,9 +1008,8 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 			    (fdata & 0xff00) |((fdata << 16) &
 			    0xff0000) | ((fdata >> 16) & 0xff));
 			if (ret != QLA_SUCCESS) {
-				DEBUG9(printk("%s(%ld) Unable to flash "
-				    "sector: address=%x.\n", __func__,
-				    ha->host_no, faddr));
+				DEBUG9(qla_printk("Unable to flash sector: "
+				    "address=%x.\n", faddr));
 				break;
 			}
 		}
@@ -1021,7 +1021,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 			    miter < OPTROM_BURST_DWORDS; miter++, s++, d++)
 				*s = cpu_to_le32(*d);
 
-			ret = qla2x00_load_ram(ha, optrom_dma,
+			ret = qla2x00_load_ram(vha, optrom_dma,
 			    flash_data_to_access_addr(faddr),
 			    OPTROM_BURST_DWORDS);
 			if (ret != QLA_SUCCESS) {
@@ -1049,7 +1049,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 		if (ret != QLA_SUCCESS) {
 			DEBUG9(printk("%s(%ld) Unable to program flash "
 			    "address=%x data=%x.\n", __func__,
-			    ha->host_no, faddr, *dwptr));
+			    vha->host_no, faddr, *dwptr));
 			break;
 		}
 
@@ -1072,11 +1072,12 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 }
 
 uint8_t *
-qla2x00_read_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
+qla2x00_read_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
     uint32_t bytes)
 {
 	uint32_t i;
 	uint16_t *wptr;
+	struct qla_hw_data *ha = vha->hw;
 
 	/* Word reads to NVRAM via registers. */
 	wptr = (uint16_t *)buf;
@@ -1090,7 +1091,7 @@ qla2x00_read_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 }
 
 uint8_t *
-qla24xx_read_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
+qla24xx_read_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
     uint32_t bytes)
 {
 	uint32_t i;
@@ -1099,20 +1100,21 @@ qla24xx_read_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 	/* Dword reads to flash. */
 	dwptr = (uint32_t *)buf;
 	for (i = 0; i < bytes >> 2; i++, naddr++)
-		dwptr[i] = cpu_to_le32(qla24xx_read_flash_dword(ha,
+		dwptr[i] = cpu_to_le32(qla24xx_read_flash_dword(vha->hw,
 		    nvram_data_to_access_addr(naddr)));
 
 	return buf;
 }
 
 int
-qla2x00_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
+qla2x00_write_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
     uint32_t bytes)
 {
 	int ret, stat;
 	uint32_t i;
 	uint16_t *wptr;
 	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
 
 	ret = QLA_SUCCESS;
 
@@ -1139,12 +1141,13 @@ qla2x00_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 }
 
 int
-qla24xx_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
+qla24xx_write_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
     uint32_t bytes)
 {
 	int ret;
 	uint32_t i;
 	uint32_t *dwptr;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
 	ret = QLA_SUCCESS;
@@ -1167,9 +1170,8 @@ qla24xx_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 		    nvram_data_to_access_addr(naddr),
 		    cpu_to_le32(*dwptr));
 		if (ret != QLA_SUCCESS) {
-			DEBUG9(printk("%s(%ld) Unable to program "
-			    "nvram address=%x data=%x.\n", __func__,
-			    ha->host_no, naddr, *dwptr));
+			DEBUG9(qla_printk("Unable to program nvram address=%x "
+			    "data=%x.\n", naddr, *dwptr));
 			break;
 		}
 	}
@@ -1187,11 +1189,12 @@ qla24xx_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 }
 
 uint8_t *
-qla25xx_read_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
+qla25xx_read_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
     uint32_t bytes)
 {
 	uint32_t i;
 	uint32_t *dwptr;
+	struct qla_hw_data *ha = vha->hw;
 
 	/* Dword reads to flash. */
 	dwptr = (uint32_t *)buf;
@@ -1204,19 +1207,20 @@ qla25xx_read_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 }
 
 int
-qla25xx_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
+qla25xx_write_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
     uint32_t bytes)
 {
+	struct qla_hw_data *ha = vha->hw;
 #define RMW_BUFFER_SIZE	(64 * 1024)
 	uint8_t *dbuf;
 
 	dbuf = vmalloc(RMW_BUFFER_SIZE);
 	if (!dbuf)
 		return QLA_MEMORY_ALLOC_FAILED;
-	ha->isp_ops->read_optrom(ha, dbuf, ha->flt_region_vpd_nvram << 2,
+	ha->isp_ops->read_optrom(vha, dbuf, ha->flt_region_vpd_nvram << 2,
 	    RMW_BUFFER_SIZE);
 	memcpy(dbuf + (naddr << 2), buf, bytes);
-	ha->isp_ops->write_optrom(ha, dbuf, ha->flt_region_vpd_nvram << 2,
+	ha->isp_ops->write_optrom(vha, dbuf, ha->flt_region_vpd_nvram << 2,
 	    RMW_BUFFER_SIZE);
 	vfree(dbuf);
 
@@ -1224,7 +1228,7 @@ qla25xx_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 }
 
 static inline void
-qla2x00_flip_colors(scsi_qla_host_t *ha, uint16_t *pflags)
+qla2x00_flip_colors(struct qla_hw_data *ha, uint16_t *pflags)
 {
 	if (IS_QLA2322(ha)) {
 		/* Flip all colors. */
@@ -1254,12 +1258,13 @@ qla2x00_flip_colors(scsi_qla_host_t *ha, uint16_t *pflags)
 #define PIO_REG(h, r) ((h)->pio_address + offsetof(struct device_reg_2xxx, r))
 
 void
-qla2x00_beacon_blink(struct scsi_qla_host *ha)
+qla2x00_beacon_blink(struct scsi_qla_host *vha)
 {
 	uint16_t gpio_enable;
 	uint16_t gpio_data;
 	uint16_t led_color = 0;
 	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -1303,17 +1308,18 @@ qla2x00_beacon_blink(struct scsi_qla_host *ha)
 }
 
 int
-qla2x00_beacon_on(struct scsi_qla_host *ha)
+qla2x00_beacon_on(struct scsi_qla_host *vha)
 {
 	uint16_t gpio_enable;
 	uint16_t gpio_data;
 	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	ha->fw_options[1] &= ~FO1_SET_EMPHASIS_SWING;
 	ha->fw_options[1] |= FO1_DISABLE_GPIO6_7;
 
-	if (qla2x00_set_fw_options(ha, ha->fw_options) != QLA_SUCCESS) {
+	if (qla2x00_set_fw_options(vha, ha->fw_options) != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to update fw options (beacon on).\n");
 		return QLA_FUNCTION_FAILED;
@@ -1359,9 +1365,10 @@ qla2x00_beacon_on(struct scsi_qla_host *ha)
 }
 
 int
-qla2x00_beacon_off(struct scsi_qla_host *ha)
+qla2x00_beacon_off(struct scsi_qla_host *vha)
 {
 	int rval = QLA_SUCCESS;
+	struct qla_hw_data *ha = vha->hw;
 
 	ha->beacon_blink_led = 0;
 
@@ -1371,12 +1378,12 @@ qla2x00_beacon_off(struct scsi_qla_host *ha)
 	else
 		ha->beacon_color_state = QLA_LED_GRN_ON;
 
-	ha->isp_ops->beacon_blink(ha);	/* This turns green LED off */
+	ha->isp_ops->beacon_blink(vha);	/* This turns green LED off */
 
 	ha->fw_options[1] &= ~FO1_SET_EMPHASIS_SWING;
 	ha->fw_options[1] &= ~FO1_DISABLE_GPIO6_7;
 
-	rval = qla2x00_set_fw_options(ha, ha->fw_options);
+	rval = qla2x00_set_fw_options(vha, ha->fw_options);
 	if (rval != QLA_SUCCESS)
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to update fw options (beacon off).\n");
@@ -1385,7 +1392,7 @@ qla2x00_beacon_off(struct scsi_qla_host *ha)
 
 
 static inline void
-qla24xx_flip_colors(scsi_qla_host_t *ha, uint16_t *pflags)
+qla24xx_flip_colors(struct qla_hw_data *ha, uint16_t *pflags)
 {
 	/* Flip all colors. */
 	if (ha->beacon_color_state == QLA_LED_ALL_ON) {
@@ -1400,11 +1407,12 @@ qla24xx_flip_colors(scsi_qla_host_t *ha, uint16_t *pflags)
 }
 
 void
-qla24xx_beacon_blink(struct scsi_qla_host *ha)
+qla24xx_beacon_blink(struct scsi_qla_host *vha)
 {
 	uint16_t led_color = 0;
 	uint32_t gpio_data;
 	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
 	/* Save the Original GPIOD. */
@@ -1433,20 +1441,21 @@ qla24xx_beacon_blink(struct scsi_qla_host *ha)
 }
 
 int
-qla24xx_beacon_on(struct scsi_qla_host *ha)
+qla24xx_beacon_on(struct scsi_qla_host *vha)
 {
 	uint32_t gpio_data;
 	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
 	if (ha->beacon_blink_led == 0) {
 		/* Enable firmware for update */
 		ha->fw_options[1] |= ADD_FO1_DISABLE_GPIO_LED_CTRL;
 
-		if (qla2x00_set_fw_options(ha, ha->fw_options) != QLA_SUCCESS)
+		if (qla2x00_set_fw_options(vha, ha->fw_options) != QLA_SUCCESS)
 			return QLA_FUNCTION_FAILED;
 
-		if (qla2x00_get_fw_options(ha, ha->fw_options) !=
+		if (qla2x00_get_fw_options(vha, ha->fw_options) !=
 		    QLA_SUCCESS) {
 			qla_printk(KERN_WARNING, ha,
 			    "Unable to update fw options (beacon on).\n");
@@ -1474,16 +1483,17 @@ qla24xx_beacon_on(struct scsi_qla_host *ha)
 }
 
 int
-qla24xx_beacon_off(struct scsi_qla_host *ha)
+qla24xx_beacon_off(struct scsi_qla_host *vha)
 {
 	uint32_t gpio_data;
 	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
 	ha->beacon_blink_led = 0;
 	ha->beacon_color_state = QLA_LED_ALL_ON;
 
-	ha->isp_ops->beacon_blink(ha);	/* Will flip to all off. */
+	ha->isp_ops->beacon_blink(vha);	/* Will flip to all off. */
 
 	/* Give control back to firmware. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -1497,13 +1507,13 @@ qla24xx_beacon_off(struct scsi_qla_host *ha)
 
 	ha->fw_options[1] &= ~ADD_FO1_DISABLE_GPIO_LED_CTRL;
 
-	if (qla2x00_set_fw_options(ha, ha->fw_options) != QLA_SUCCESS) {
+	if (qla2x00_set_fw_options(vha, ha->fw_options) != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to update fw options (beacon off).\n");
 		return QLA_FUNCTION_FAILED;
 	}
 
-	if (qla2x00_get_fw_options(ha, ha->fw_options) != QLA_SUCCESS) {
+	if (qla2x00_get_fw_options(vha, ha->fw_options) != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to get fw options (beacon off).\n");
 		return QLA_FUNCTION_FAILED;
@@ -1522,7 +1532,7 @@ qla24xx_beacon_off(struct scsi_qla_host *ha)
  * @ha: HA context
  */
 static void
-qla2x00_flash_enable(scsi_qla_host_t *ha)
+qla2x00_flash_enable(struct qla_hw_data *ha)
 {
 	uint16_t data;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -1538,7 +1548,7 @@ qla2x00_flash_enable(scsi_qla_host_t *ha)
  * @ha: HA context
  */
 static void
-qla2x00_flash_disable(scsi_qla_host_t *ha)
+qla2x00_flash_disable(struct qla_hw_data *ha)
 {
 	uint16_t data;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -1559,7 +1569,7 @@ qla2x00_flash_disable(scsi_qla_host_t *ha)
  * Returns the byte read from flash @addr.
  */
 static uint8_t
-qla2x00_read_flash_byte(scsi_qla_host_t *ha, uint32_t addr)
+qla2x00_read_flash_byte(struct qla_hw_data *ha, uint32_t addr)
 {
 	uint16_t data;
 	uint16_t bank_select;
@@ -1620,7 +1630,7 @@ qla2x00_read_flash_byte(scsi_qla_host_t *ha, uint32_t addr)
  * @data: Data to write
  */
 static void
-qla2x00_write_flash_byte(scsi_qla_host_t *ha, uint32_t addr, uint8_t data)
+qla2x00_write_flash_byte(struct qla_hw_data *ha, uint32_t addr, uint8_t data)
 {
 	uint16_t bank_select;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -1683,7 +1693,7 @@ qla2x00_write_flash_byte(scsi_qla_host_t *ha, uint32_t addr, uint8_t data)
  * Returns 0 on success, else non-zero.
  */
 static int
-qla2x00_poll_flash(scsi_qla_host_t *ha, uint32_t addr, uint8_t poll_data,
+qla2x00_poll_flash(struct qla_hw_data *ha, uint32_t addr, uint8_t poll_data,
     uint8_t man_id, uint8_t flash_id)
 {
 	int status;
@@ -1723,8 +1733,8 @@ qla2x00_poll_flash(scsi_qla_host_t *ha, uint32_t addr, uint8_t poll_data,
  * Returns 0 on success, else non-zero.
  */
 static int
-qla2x00_program_flash_address(scsi_qla_host_t *ha, uint32_t addr, uint8_t data,
-    uint8_t man_id, uint8_t flash_id)
+qla2x00_program_flash_address(struct qla_hw_data *ha, uint32_t addr,
+    uint8_t data, uint8_t man_id, uint8_t flash_id)
 {
 	/* Write Program Command Sequence. */
 	if (IS_OEM_001(ha)) {
@@ -1760,7 +1770,7 @@ qla2x00_program_flash_address(scsi_qla_host_t *ha, uint32_t addr, uint8_t data,
  * Returns 0 on success, else non-zero.
  */
 static int
-qla2x00_erase_flash(scsi_qla_host_t *ha, uint8_t man_id, uint8_t flash_id)
+qla2x00_erase_flash(struct qla_hw_data *ha, uint8_t man_id, uint8_t flash_id)
 {
 	/* Individual Sector Erase Command Sequence */
 	if (IS_OEM_001(ha)) {
@@ -1796,7 +1806,7 @@ qla2x00_erase_flash(scsi_qla_host_t *ha, uint8_t man_id, uint8_t flash_id)
  * Returns 0 on success, else non-zero.
  */
 static int
-qla2x00_erase_flash_sector(scsi_qla_host_t *ha, uint32_t addr,
+qla2x00_erase_flash_sector(struct qla_hw_data *ha, uint32_t addr,
     uint32_t sec_mask, uint8_t man_id, uint8_t flash_id)
 {
 	/* Individual Sector Erase Command Sequence */
@@ -1822,7 +1832,7 @@ qla2x00_erase_flash_sector(scsi_qla_host_t *ha, uint32_t addr,
  * @flash_id: Flash ID
  */
 static void
-qla2x00_get_flash_manufacturer(scsi_qla_host_t *ha, uint8_t *man_id,
+qla2x00_get_flash_manufacturer(struct qla_hw_data *ha, uint8_t *man_id,
     uint8_t *flash_id)
 {
 	qla2x00_write_flash_byte(ha, 0x5555, 0xaa);
@@ -1836,8 +1846,8 @@ qla2x00_get_flash_manufacturer(scsi_qla_host_t *ha, uint8_t *man_id,
 }
 
 static void
-qla2x00_read_flash_data(scsi_qla_host_t *ha, uint8_t *tmp_buf, uint32_t saddr,
-        uint32_t length)
+qla2x00_read_flash_data(struct qla_hw_data *ha, uint8_t *tmp_buf,
+	uint32_t saddr, uint32_t length)
 {
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint32_t midpoint, ilength;
@@ -1861,14 +1871,15 @@ qla2x00_read_flash_data(scsi_qla_host_t *ha, uint8_t *tmp_buf, uint32_t saddr,
 }
 
 static inline void
-qla2x00_suspend_hba(struct scsi_qla_host *ha)
+qla2x00_suspend_hba(struct scsi_qla_host *vha)
 {
 	int cnt;
 	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	/* Suspend HBA. */
-	scsi_block_requests(ha->host);
+	scsi_block_requests(vha->host);
 	ha->isp_ops->disable_intrs(ha);
 	set_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
 
@@ -1889,26 +1900,29 @@ qla2x00_suspend_hba(struct scsi_qla_host *ha)
 }
 
 static inline void
-qla2x00_resume_hba(struct scsi_qla_host *ha)
+qla2x00_resume_hba(struct scsi_qla_host *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
+
 	/* Resume HBA. */
 	clear_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
-	set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-	qla2xxx_wake_dpc(ha);
-	qla2x00_wait_for_hba_online(ha);
-	scsi_unblock_requests(ha->host);
+	set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+	qla2xxx_wake_dpc(vha);
+	qla2x00_wait_for_hba_online(vha);
+	scsi_unblock_requests(vha->host);
 }
 
 uint8_t *
-qla2x00_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
+qla2x00_read_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
     uint32_t offset, uint32_t length)
 {
 	uint32_t addr, midpoint;
 	uint8_t *data;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	/* Suspend HBA. */
-	qla2x00_suspend_hba(ha);
+	qla2x00_suspend_hba(vha);
 
 	/* Go with read. */
 	midpoint = ha->optrom_size / 2;
@@ -1927,13 +1941,13 @@ qla2x00_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 	qla2x00_flash_disable(ha);
 
 	/* Resume HBA. */
-	qla2x00_resume_hba(ha);
+	qla2x00_resume_hba(vha);
 
 	return buf;
 }
 
 int
-qla2x00_write_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
+qla2x00_write_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
     uint32_t offset, uint32_t length)
 {
 
@@ -1941,10 +1955,11 @@ qla2x00_write_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 	uint8_t man_id, flash_id, sec_number, data;
 	uint16_t wd;
 	uint32_t addr, liter, sec_mask, rest_addr;
+	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	/* Suspend HBA. */
-	qla2x00_suspend_hba(ha);
+	qla2x00_suspend_hba(vha);
 
 	rval = QLA_SUCCESS;
 	sec_number = 0;
@@ -2144,55 +2159,58 @@ update_flash:
 	qla2x00_flash_disable(ha);
 
 	/* Resume HBA. */
-	qla2x00_resume_hba(ha);
+	qla2x00_resume_hba(vha);
 
 	return rval;
 }
 
 uint8_t *
-qla24xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
+qla24xx_read_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
     uint32_t offset, uint32_t length)
 {
+	struct qla_hw_data *ha = vha->hw;
+
 	/* Suspend HBA. */
-	scsi_block_requests(ha->host);
+	scsi_block_requests(vha->host);
 	set_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
 
 	/* Go with read. */
-	qla24xx_read_flash_data(ha, (uint32_t *)buf, offset >> 2, length >> 2);
+	qla24xx_read_flash_data(vha, (uint32_t *)buf, offset >> 2, length >> 2);
 
 	/* Resume HBA. */
 	clear_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
-	scsi_unblock_requests(ha->host);
+	scsi_unblock_requests(vha->host);
 
 	return buf;
 }
 
 int
-qla24xx_write_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
+qla24xx_write_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
     uint32_t offset, uint32_t length)
 {
 	int rval;
+	struct qla_hw_data *ha = vha->hw;
 
 	/* Suspend HBA. */
-	scsi_block_requests(ha->host);
+	scsi_block_requests(vha->host);
 	set_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
 
 	/* Go with write. */
-	rval = qla24xx_write_flash_data(ha, (uint32_t *)buf, offset >> 2,
+	rval = qla24xx_write_flash_data(vha, (uint32_t *)buf, offset >> 2,
 	    length >> 2);
 
 	/* Resume HBA -- RISC reset needed. */
 	clear_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
-	set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-	qla2xxx_wake_dpc(ha);
-	qla2x00_wait_for_hba_online(ha);
-	scsi_unblock_requests(ha->host);
+	set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+	qla2xxx_wake_dpc(vha);
+	qla2x00_wait_for_hba_online(vha);
+	scsi_unblock_requests(vha->host);
 
 	return rval;
 }
 
 uint8_t *
-qla25xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
+qla25xx_read_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
     uint32_t offset, uint32_t length)
 {
 	int rval;
@@ -2200,6 +2218,7 @@ qla25xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 	void *optrom;
 	uint8_t *pbuf;
 	uint32_t faddr, left, burst;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (offset & 0xfff)
 		goto slow_read;
@@ -2224,7 +2243,7 @@ qla25xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 		if (burst > left)
 			burst = left;
 
-		rval = qla2x00_dump_ram(ha, optrom_dma,
+		rval = qla2x00_dump_ram(vha, optrom_dma,
 		    flash_data_to_access_addr(faddr), burst);
 		if (rval) {
 			qla_printk(KERN_WARNING, ha,
@@ -2253,7 +2272,7 @@ qla25xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 	return buf;
 
 slow_read:
-    return qla24xx_read_optrom_data(ha, buf, offset, length);
+    return qla24xx_read_optrom_data(vha, buf, offset, length);
 }
 
 /**
@@ -2275,7 +2294,7 @@ slow_read:
  * Returns QLA_SUCCESS on successful retrieval of version.
  */
 static void
-qla2x00_get_fcode_version(scsi_qla_host_t *ha, uint32_t pcids)
+qla2x00_get_fcode_version(struct qla_hw_data *ha, uint32_t pcids)
 {
 	int ret = QLA_FUNCTION_FAILED;
 	uint32_t istart, iend, iter, vend;
@@ -2349,13 +2368,14 @@ qla2x00_get_fcode_version(scsi_qla_host_t *ha, uint32_t pcids)
 }
 
 int
-qla2x00_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
+qla2x00_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 {
 	int ret = QLA_SUCCESS;
 	uint8_t code_type, last_image;
 	uint32_t pcihdr, pcids;
 	uint8_t *dbyte;
 	uint16_t *dcode;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (!ha->pio_address || !mbuf)
 		return QLA_FUNCTION_FAILED;
@@ -2375,8 +2395,8 @@ qla2x00_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 		if (qla2x00_read_flash_byte(ha, pcihdr) != 0x55 ||
 		    qla2x00_read_flash_byte(ha, pcihdr + 0x01) != 0xaa) {
 			/* No signature */
-			DEBUG2(printk("scsi(%ld): No matching ROM "
-			    "signature.\n", ha->host_no));
+			DEBUG2(qla_printk(KERN_DEBUG, ha, "No matching ROM "
+			    "signature.\n"));
 			ret = QLA_FUNCTION_FAILED;
 			break;
 		}
@@ -2392,8 +2412,8 @@ qla2x00_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 		    qla2x00_read_flash_byte(ha, pcids + 0x2) != 'I' ||
 		    qla2x00_read_flash_byte(ha, pcids + 0x3) != 'R') {
 			/* Incorrect header. */
-			DEBUG2(printk("%s(): PCI data struct not found "
-			    "pcir_adr=%x.\n", __func__, pcids));
+			DEBUG2(qla_printk(KERN_INFO, ha, "PCI data struct not "
+			    "found pcir_adr=%x.\n", pcids));
 			ret = QLA_FUNCTION_FAILED;
 			break;
 		}
@@ -2407,7 +2427,7 @@ qla2x00_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 			    qla2x00_read_flash_byte(ha, pcids + 0x12);
 			ha->bios_revision[1] =
 			    qla2x00_read_flash_byte(ha, pcids + 0x13);
-			DEBUG3(printk("%s(): read BIOS %d.%d.\n", __func__,
+			DEBUG3(qla_printk(KERN_DEBUG, ha, "read BIOS %d.%d.\n",
 			    ha->bios_revision[1], ha->bios_revision[0]));
 			break;
 		case ROM_CODE_TYPE_FCODE:
@@ -2421,12 +2441,12 @@ qla2x00_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 			    qla2x00_read_flash_byte(ha, pcids + 0x12);
 			ha->efi_revision[1] =
 			    qla2x00_read_flash_byte(ha, pcids + 0x13);
-			DEBUG3(printk("%s(): read EFI %d.%d.\n", __func__,
+			DEBUG3(qla_printk(KERN_DEBUG, ha, "read EFI %d.%d.\n",
 			    ha->efi_revision[1], ha->efi_revision[0]));
 			break;
 		default:
-			DEBUG2(printk("%s(): Unrecognized code type %x at "
-			    "pcids %x.\n", __func__, code_type, pcids));
+			DEBUG2(qla_printk(KERN_INFO, ha, "Unrecognized code "
+			    "type %x at pcids %x.\n", code_type, pcids));
 			break;
 		}
 
@@ -2446,16 +2466,16 @@ qla2x00_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 
 		qla2x00_read_flash_data(ha, dbyte, ha->flt_region_fw * 4 + 10,
 		    8);
-		DEBUG3(printk("%s(%ld): dumping fw ver from flash:\n",
-		    __func__, ha->host_no));
+		DEBUG3(qla_printk(KERN_DEBUG, ha, "dumping fw ver from "
+		    "flash:\n"));
 		DEBUG3(qla2x00_dump_buffer((uint8_t *)dbyte, 8));
 
 		if ((dcode[0] == 0xffff && dcode[1] == 0xffff &&
 		    dcode[2] == 0xffff && dcode[3] == 0xffff) ||
 		    (dcode[0] == 0 && dcode[1] == 0 && dcode[2] == 0 &&
 		    dcode[3] == 0)) {
-			DEBUG2(printk("%s(): Unrecognized fw revision at "
-			    "%x.\n", __func__, ha->flt_region_fw * 4));
+			DEBUG2(qla_printk(KERN_INFO, ha, "Unrecognized fw "
+			    "revision at %x.\n", ha->flt_region_fw * 4));
 		} else {
 			/* values are in big endian */
 			ha->fw_revision[0] = dbyte[0] << 16 | dbyte[1];
@@ -2470,7 +2490,7 @@ qla2x00_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 }
 
 int
-qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
+qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 {
 	int ret = QLA_SUCCESS;
 	uint32_t pcihdr, pcids;
@@ -2478,6 +2498,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 	uint8_t *bcode;
 	uint8_t code_type, last_image;
 	int i;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (!mbuf)
 		return QLA_FUNCTION_FAILED;
@@ -2494,12 +2515,12 @@ qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 	last_image = 1;
 	do {
 		/* Verify PCI expansion ROM header. */
-		qla24xx_read_flash_data(ha, dcode, pcihdr >> 2, 0x20);
+		qla24xx_read_flash_data(vha, dcode, pcihdr >> 2, 0x20);
 		bcode = mbuf + (pcihdr % 4);
 		if (bcode[0x0] != 0x55 || bcode[0x1] != 0xaa) {
 			/* No signature */
-			DEBUG2(printk("scsi(%ld): No matching ROM "
-			    "signature.\n", ha->host_no));
+			DEBUG2(qla_printk(KERN_DEBUG, ha, "No matching ROM "
+			    "signature.\n"));
 			ret = QLA_FUNCTION_FAILED;
 			break;
 		}
@@ -2507,15 +2528,15 @@ qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 		/* Locate PCI data structure. */
 		pcids = pcihdr + ((bcode[0x19] << 8) | bcode[0x18]);
 
-		qla24xx_read_flash_data(ha, dcode, pcids >> 2, 0x20);
+		qla24xx_read_flash_data(vha, dcode, pcids >> 2, 0x20);
 		bcode = mbuf + (pcihdr % 4);
 
 		/* Validate signature of PCI data structure. */
 		if (bcode[0x0] != 'P' || bcode[0x1] != 'C' ||
 		    bcode[0x2] != 'I' || bcode[0x3] != 'R') {
 			/* Incorrect header. */
-			DEBUG2(printk("%s(): PCI data struct not found "
-			    "pcir_adr=%x.\n", __func__, pcids));
+			DEBUG2(qla_printk(KERN_INFO, ha, "PCI data struct not "
+			    "found pcir_adr=%x.\n", pcids));
 			ret = QLA_FUNCTION_FAILED;
 			break;
 		}
@@ -2527,26 +2548,26 @@ qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 			/* Intel x86, PC-AT compatible. */
 			ha->bios_revision[0] = bcode[0x12];
 			ha->bios_revision[1] = bcode[0x13];
-			DEBUG3(printk("%s(): read BIOS %d.%d.\n", __func__,
+			DEBUG3(qla_printk(KERN_DEBUG, ha, "read BIOS %d.%d.\n",
 			    ha->bios_revision[1], ha->bios_revision[0]));
 			break;
 		case ROM_CODE_TYPE_FCODE:
 			/* Open Firmware standard for PCI (FCode). */
 			ha->fcode_revision[0] = bcode[0x12];
 			ha->fcode_revision[1] = bcode[0x13];
-			DEBUG3(printk("%s(): read FCODE %d.%d.\n", __func__,
+			DEBUG3(qla_printk(KERN_DEBUG, ha, "read FCODE %d.%d.\n",
 			    ha->fcode_revision[1], ha->fcode_revision[0]));
 			break;
 		case ROM_CODE_TYPE_EFI:
 			/* Extensible Firmware Interface (EFI). */
 			ha->efi_revision[0] = bcode[0x12];
 			ha->efi_revision[1] = bcode[0x13];
-			DEBUG3(printk("%s(): read EFI %d.%d.\n", __func__,
+			DEBUG3(qla_printk(KERN_DEBUG, ha, "read EFI %d.%d.\n",
 			    ha->efi_revision[1], ha->efi_revision[0]));
 			break;
 		default:
-			DEBUG2(printk("%s(): Unrecognized code type %x at "
-			    "pcids %x.\n", __func__, code_type, pcids));
+			DEBUG2(qla_printk(KERN_INFO, ha, "Unrecognized code "
+			    "type %x at pcids %x.\n", code_type, pcids));
 			break;
 		}
 
@@ -2560,7 +2581,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 	memset(ha->fw_revision, 0, sizeof(ha->fw_revision));
 	dcode = mbuf;
 
-	qla24xx_read_flash_data(ha, dcode, ha->flt_region_fw + 4, 4);
+	qla24xx_read_flash_data(vha, dcode, ha->flt_region_fw + 4, 4);
 	for (i = 0; i < 4; i++)
 		dcode[i] = be32_to_cpu(dcode[i]);
 
@@ -2568,8 +2589,8 @@ qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 	    dcode[2] == 0xffffffff && dcode[3] == 0xffffffff) ||
 	    (dcode[0] == 0 && dcode[1] == 0 && dcode[2] == 0 &&
 	    dcode[3] == 0)) {
-		DEBUG2(printk("%s(): Unrecognized fw version at %x.\n",
-		    __func__, ha->flt_region_fw));
+		DEBUG2(qla_printk(KERN_INFO, ha, "Unrecognized fw "
+		    "revision at %x.\n", ha->flt_region_fw * 4));
 	} else {
 		ha->fw_revision[0] = dcode[0];
 		ha->fw_revision[1] = dcode[1];
@@ -2598,8 +2619,9 @@ qla2xxx_is_vpd_valid(uint8_t *pos, uint8_t *end)
 }
 
 int
-qla2xxx_get_vpd_field(scsi_qla_host_t *ha, char *key, char *str, size_t size)
+qla2xxx_get_vpd_field(scsi_qla_host_t *vha, char *key, char *str, size_t size)
 {
+	struct qla_hw_data *ha = vha->hw;
 	uint8_t *pos = ha->vpd;
 	uint8_t *end = pos + ha->vpd_size;
 	int len = 0;
@@ -2626,9 +2648,10 @@ qla2xxx_get_vpd_field(scsi_qla_host_t *ha, char *key, char *str, size_t size)
 }
 
 static int
-qla2xxx_hw_event_store(scsi_qla_host_t *ha, uint32_t *fdata)
+qla2xxx_hw_event_store(scsi_qla_host_t *vha, uint32_t *fdata)
 {
 	uint32_t d[2], faddr;
+	struct qla_hw_data *ha = vha->hw;
 
 	/* Locate first empty entry. */
 	for (;;) {
@@ -2639,7 +2662,7 @@ qla2xxx_hw_event_store(scsi_qla_host_t *ha, uint32_t *fdata)
 			return QLA_MEMORY_ALLOC_FAILED;
 		}
 
-		qla24xx_read_flash_data(ha, d, ha->hw_event_ptr, 2);
+		qla24xx_read_flash_data(vha, d, ha->hw_event_ptr, 2);
 		faddr = flash_data_to_access_addr(ha->hw_event_ptr);
 		ha->hw_event_ptr += FA_HW_EVENT_ENTRY_SIZE;
 		if (d[0] == __constant_cpu_to_le32(0xffffffff) &&
@@ -2660,12 +2683,12 @@ qla2xxx_hw_event_store(scsi_qla_host_t *ha, uint32_t *fdata)
 }
 
 int
-qla2xxx_hw_event_log(scsi_qla_host_t *ha, uint16_t code, uint16_t d1,
+qla2xxx_hw_event_log(scsi_qla_host_t *vha, uint16_t code, uint16_t d1,
     uint16_t d2, uint16_t d3)
 {
 #define QMARK(a, b, c, d) \
     cpu_to_le32(LSB(a) << 24 | LSB(b) << 16 | LSB(c) << 8 | LSB(d))
-
+	struct qla_hw_data *ha = vha->hw;
 	int rval;
 	uint32_t marker[2], fdata[4];
 
@@ -2686,7 +2709,7 @@ qla2xxx_hw_event_log(scsi_qla_host_t *ha, uint16_t code, uint16_t d1,
 		/* Locate marker. */
 		ha->hw_event_ptr = ha->flt_region_hw_event;
 		for (;;) {
-			qla24xx_read_flash_data(ha, fdata, ha->hw_event_ptr,
+			qla24xx_read_flash_data(vha, fdata, ha->hw_event_ptr,
 			    4);
 			if (fdata[0] == __constant_cpu_to_le32(0xffffffff) &&
 			    fdata[1] == __constant_cpu_to_le32(0xffffffff))
@@ -2705,7 +2728,7 @@ qla2xxx_hw_event_log(scsi_qla_host_t *ha, uint16_t code, uint16_t d1,
 		}
 		/* No marker, write it. */
 		if (!ha->flags.hw_event_marker_found) {
-			rval = qla2xxx_hw_event_store(ha, marker);
+			rval = qla2xxx_hw_event_store(vha, marker);
 			if (rval != QLA_SUCCESS) {
 				DEBUG2(qla_printk(KERN_WARNING, ha,
 				    "HW event -- Failed marker write=%x.!\n",
@@ -2719,7 +2742,7 @@ qla2xxx_hw_event_log(scsi_qla_host_t *ha, uint16_t code, uint16_t d1,
 	/* Store error.  */
 	fdata[0] = cpu_to_le32(code << 16 | d1);
 	fdata[1] = cpu_to_le32(d2 << 16 | d3);
-	rval = qla2xxx_hw_event_store(ha, fdata);
+	rval = qla2xxx_hw_event_store(vha, fdata);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2(qla_printk(KERN_WARNING, ha,
 		    "HW event -- Failed error write=%x.!\n",
