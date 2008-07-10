From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 04/18] qla2xxx: Track total number of ISP aborts.
Date: Thu, 10 Jul 2008 16:55:49 -0700
Message-ID: <1215734163-40825-4-git-send-email-andrew.vasquez@qlogic.com>
References: <20080710235458.GQ29099@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45262 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbYGJX4H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 19:56:07 -0400
In-Reply-To: <20080710235458.GQ29099@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

This parameter counts the total number of ISP aborts during
driver execution.  The value is exported through a DEVICE_ATTR()
off the scsi_host.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   13 +++++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |    5 +++++
 drivers/scsi/qla2xxx/qla_init.c |    1 +
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 2a3bc35..5538fa9 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -784,6 +784,16 @@ qla2x00_optrom_fw_version_show(struct device *dev,
 	    ha->fw_revision[3]);
 }
 
+static ssize_t
+qla2x00_total_isp_aborts_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+	    ha->qla_stats.total_isp_aborts);
+}
+
 static DEVICE_ATTR(driver_version, S_IRUGO, qla2x00_drvr_version_show, NULL);
 static DEVICE_ATTR(fw_version, S_IRUGO, qla2x00_fw_version_show, NULL);
 static DEVICE_ATTR(serial_num, S_IRUGO, qla2x00_serial_num_show, NULL);
@@ -806,6 +816,8 @@ static DEVICE_ATTR(optrom_fcode_version, S_IRUGO,
 		   qla2x00_optrom_fcode_version_show, NULL);
 static DEVICE_ATTR(optrom_fw_version, S_IRUGO, qla2x00_optrom_fw_version_show,
 		   NULL);
+static DEVICE_ATTR(total_isp_aborts, S_IRUGO, qla2x00_total_isp_aborts_show,
+		   NULL);
 
 struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_driver_version,
@@ -824,6 +836,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_optrom_efi_version,
 	&dev_attr_optrom_fcode_version,
 	&dev_attr_optrom_fw_version,
+	&dev_attr_total_isp_aborts,
 	NULL,
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 7b0ddc8..fe1eada 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2154,6 +2154,10 @@ struct qla_chip_state_84xx {
 	uint32_t gold_fw_version;
 };
 
+struct qla_statistics {
+	uint32_t total_isp_aborts;
+};
+
 /*
  * Linux Host Adapter structure
  */
@@ -2595,6 +2599,7 @@ typedef struct scsi_qla_host {
 	int		cur_vport_count;
 
 	struct qla_chip_state_84xx *cs84xx;
+	struct qla_statistics qla_stats;
 } scsi_qla_host_t;
 
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c7388fa..833a642 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3237,6 +3237,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 	if (ha->flags.online) {
 		ha->flags.online = 0;
 		clear_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+		ha->qla_stats.total_isp_aborts++;
 
 		qla_printk(KERN_INFO, ha,
 		    "Performing ISP error recovery - ha= %p.\n", ha);
-- 
1.5.6.2.292.ga9a3

