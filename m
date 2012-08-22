From: vikas.chaudhary@qlogic.com
Subject: [PATCH 07/12] qla4xxx: Replace all !is_qla8022() with is_qla40XX()
Date: Wed, 22 Aug 2012 07:55:05 -0400
Message-ID: <1345636510-23131-8-git-send-email-vikas.chaudhary@qlogic.com>
References: <1345636510-23131-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:48325 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755911Ab2HVML4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 08:11:56 -0400
In-Reply-To: <1345636510-23131-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_attr.c |   10 +++++-----
 drivers/scsi/qla4xxx/ql4_isr.c  |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c   |   12 ++++++------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_attr.c b/drivers/scsi/qla4xxx/ql4_attr.c
index befe4f9..a24008f 100644
--- a/drivers/scsi/qla4xxx/ql4_attr.c
+++ b/drivers/scsi/qla4xxx/ql4_attr.c
@@ -17,7 +17,7 @@ qla4_8xxx_sysfs_read_fw_dump(struct file *filep, struct kobject *kobj,
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 					       struct device, kobj)));
 
-	if (!is_qla8022(ha))
+	if (is_qla40XX(ha))
 		return -EINVAL;
 
 	if (!test_bit(AF_82XX_DUMP_READING, &ha->flags))
@@ -38,7 +38,7 @@ qla4_8xxx_sysfs_write_fw_dump(struct file *filep, struct kobject *kobj,
 	long reading;
 	int ret = 0;
 
-	if (!is_qla8022(ha))
+	if (is_qla40XX(ha))
 		return -EINVAL;
 
 	if (off != 0)
@@ -214,7 +214,7 @@ qla4xxx_phy_port_cnt_show(struct device *dev, struct device_attribute *attr,
 {
 	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
 
-	if (!is_qla8022(ha))
+	if (is_qla40XX(ha))
 		return -ENOSYS;
 
 	return snprintf(buf, PAGE_SIZE, "0x%04X\n", ha->phy_port_cnt);
@@ -226,7 +226,7 @@ qla4xxx_phy_port_num_show(struct device *dev, struct device_attribute *attr,
 {
 	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
 
-	if (!is_qla8022(ha))
+	if (is_qla40XX(ha))
 		return -ENOSYS;
 
 	return snprintf(buf, PAGE_SIZE, "0x%04X\n", ha->phy_port_num);
@@ -238,7 +238,7 @@ qla4xxx_iscsi_func_cnt_show(struct device *dev, struct device_attribute *attr,
 {
 	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
 
-	if (!is_qla8022(ha))
+	if (is_qla40XX(ha))
 		return -ENOSYS;
 
 	return snprintf(buf, PAGE_SIZE, "0x%04X\n", ha->iscsi_pci_func_cnt);
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index dda602c..55d366b 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -1193,7 +1193,7 @@ int qla4xxx_request_irqs(struct scsi_qla_host *ha)
 {
 	int ret;
 
-	if (!is_qla8022(ha))
+	if (is_qla40XX(ha))
 		goto try_intx;
 
 	if (ql4xenablemsix == 2)
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ea8845b..519f666 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2658,7 +2658,7 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 		qla4_8xxx_watchdog(ha);
 	}
 
-	if (!is_qla8022(ha)) {
+	if (is_qla40XX(ha)) {
 		/* Check for heartbeat interval. */
 		if (ha->firmware_options & FWOPT_HEARTBEAT_ENABLE &&
 		    ha->heartbeat_interval != 0) {
@@ -2982,8 +2982,8 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha)
 	/* Issue full chip reset if recovering from a catastrophic error,
 	 * or if stop_firmware fails for ISP-82xx.
 	 * This is the default case for ISP-4xxx */
-	if (!is_qla8022(ha) || reset_chip) {
-		if (!is_qla8022(ha))
+	if (is_qla40XX(ha) || reset_chip) {
+		if (is_qla40XX(ha))
 			goto chip_reset;
 
 		/* Check if 82XX firmware is alive or not
@@ -3023,7 +3023,7 @@ recover_ha_init_adapter:
 		/* For ISP-4xxx, force function 1 to always initialize
 		 * before function 3 to prevent both funcions from
 		 * stepping on top of the other */
-		if (!is_qla8022(ha) && (ha->mac_index == 3))
+		if (is_qla40XX(ha) && (ha->mac_index == 3))
 			ssleep(6);
 
 		/* NOTE: AF_ONLINE flag set upon successful completion of
@@ -5238,7 +5238,7 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	 * so that irqs will be registered after crbinit but before
 	 * mbx_intr_enable.
 	 */
-	if (!is_qla8022(ha)) {
+	if (is_qla40XX(ha)) {
 		ret = qla4xxx_request_irqs(ha);
 		if (ret) {
 			ql4_printk(KERN_WARNING, ha, "Failed to reserve "
@@ -5373,7 +5373,7 @@ static void __devexit qla4xxx_remove_adapter(struct pci_dev *pdev)
 
 	ha = pci_get_drvdata(pdev);
 
-	if (!is_qla8022(ha))
+	if (is_qla40XX(ha))
 		qla4xxx_prevent_other_port_reinit(ha);
 
 	/* destroy iface from sysfs */
-- 
1.7.8.GIT

