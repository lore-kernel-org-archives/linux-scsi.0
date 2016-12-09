From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] qla2xxx/qla4xxx: use kobj_to_dev
Date: Fri,  9 Dec 2016 22:27:59 +0800
Message-ID: <d8b9b2a8ad034e974c52d5c1c0eb61a863dd2819.1480486145.git.geliangtang@gmail.com>
References: <9bb02ed75e099a2bba8fb53069b955cfe60ce622.1480487321.git.geliangtang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9bb02ed75e099a2bba8fb53069b955cfe60ce622.1480487321.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Geliang Tang <geliangtang@gmail.com>, qla2xxx-upstream@qlogic.com, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use kobj_to_dev() instead of open-coding it.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 42 ++++++++++++++---------------------------
 drivers/scsi/qla4xxx/ql4_attr.c |  6 ++----
 2 files changed, 16 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index fe7469c..820b416 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -21,8 +21,7 @@ qla2x00_sysfs_read_fw_dump(struct file *filp, struct kobject *kobj,
 			   struct bin_attribute *bin_attr,
 			   char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(kobj_to_dev(kobj)));
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
 
@@ -54,8 +53,7 @@ qla2x00_sysfs_write_fw_dump(struct file *filp, struct kobject *kobj,
 			    struct bin_attribute *bin_attr,
 			    char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(kobj_to_dev(kobj)));
 	struct qla_hw_data *ha = vha->hw;
 	int reading;
 
@@ -151,8 +149,7 @@ qla2x00_sysfs_read_nvram(struct file *filp, struct kobject *kobj,
 			 struct bin_attribute *bin_attr,
 			 char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(kobj_to_dev(kobj)));
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -170,8 +167,7 @@ qla2x00_sysfs_write_nvram(struct file *filp, struct kobject *kobj,
 			  struct bin_attribute *bin_attr,
 			  char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(kobj_to_dev(kobj)));
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t	cnt;
 
@@ -238,8 +234,7 @@ qla2x00_sysfs_read_optrom(struct file *filp, struct kobject *kobj,
 			  struct bin_attribute *bin_attr,
 			  char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(kobj_to_dev(kobj)));
 	struct qla_hw_data *ha = vha->hw;
 	ssize_t rval = 0;
 
@@ -259,8 +254,7 @@ qla2x00_sysfs_write_optrom(struct file *filp, struct kobject *kobj,
 			   struct bin_attribute *bin_attr,
 			   char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(kobj_to_dev(kobj)));
 	struct qla_hw_data *ha = vha->hw;
 
 	if (ha->optrom_state != QLA_SWRITING)
@@ -292,8 +286,7 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 			       struct bin_attribute *bin_attr,
 			       char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(kobj_to_dev(kobj)));
 	struct qla_hw_data *ha = vha->hw;
 	uint32_t start = 0;
 	uint32_t size = ha->optrom_size;
@@ -473,8 +466,7 @@ qla2x00_sysfs_read_vpd(struct file *filp, struct kobject *kobj,
 		       struct bin_attribute *bin_attr,
 		       char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(kobj_to_dev(kobj)));
 	struct qla_hw_data *ha = vha->hw;
 	uint32_t faddr;
 
@@ -502,8 +494,7 @@ qla2x00_sysfs_write_vpd(struct file *filp, struct kobject *kobj,
 			struct bin_attribute *bin_attr,
 			char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(kobj_to_dev(kobj)));
 	struct qla_hw_data *ha = vha->hw;
 	uint8_t *tmp_data;
 
@@ -555,8 +546,7 @@ qla2x00_sysfs_read_sfp(struct file *filp, struct kobject *kobj,
 		       struct bin_attribute *bin_attr,
 		       char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(kobj_to_dev(kobj)));
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t iter, addr, offset;
 	int rval;
@@ -616,8 +606,7 @@ qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
 			struct bin_attribute *bin_attr,
 			char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(kobj_to_dev(kobj)));
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 	int type;
@@ -750,8 +739,7 @@ qla2x00_issue_logo(struct file *filp, struct kobject *kobj,
 			struct bin_attribute *bin_attr,
 			char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(kobj_to_dev(kobj)));
 	int type;
 	int rval = 0;
 	port_id_t did;
@@ -785,8 +773,7 @@ qla2x00_sysfs_read_xgmac_stats(struct file *filp, struct kobject *kobj,
 		       struct bin_attribute *bin_attr,
 		       char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(kobj_to_dev(kobj)));
 	struct qla_hw_data *ha = vha->hw;
 	int rval;
 	uint16_t actual_size;
@@ -837,8 +824,7 @@ qla2x00_sysfs_read_dcbx_tlv(struct file *filp, struct kobject *kobj,
 		       struct bin_attribute *bin_attr,
 		       char *buf, loff_t off, size_t count)
 {
-	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(kobj_to_dev(kobj)));
 	struct qla_hw_data *ha = vha->hw;
 	int rval;
 
diff --git a/drivers/scsi/qla4xxx/ql4_attr.c b/drivers/scsi/qla4xxx/ql4_attr.c
index 463239c..53fb004 100644
--- a/drivers/scsi/qla4xxx/ql4_attr.c
+++ b/drivers/scsi/qla4xxx/ql4_attr.c
@@ -14,8 +14,7 @@ qla4_8xxx_sysfs_read_fw_dump(struct file *filep, struct kobject *kobj,
 			     struct bin_attribute *ba, char *buf, loff_t off,
 			     size_t count)
 {
-	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
-					       struct device, kobj)));
+	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(kobj_to_dev(kobj)));
 
 	if (is_qla40XX(ha))
 		return -EINVAL;
@@ -32,8 +31,7 @@ qla4_8xxx_sysfs_write_fw_dump(struct file *filep, struct kobject *kobj,
 			      struct bin_attribute *ba, char *buf, loff_t off,
 			      size_t count)
 {
-	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
-					       struct device, kobj)));
+	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(kobj_to_dev(kobj)));
 	uint32_t dev_state;
 	long reading;
 	int ret = 0;
-- 
2.9.3
