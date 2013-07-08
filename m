From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH 6/7] qla4xxx: Export more firmware info in sysfs
Date: Mon, 8 Jul 2013 08:33:10 -0400
Message-ID: <1373286791-29659-7-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1373286791-29659-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:47494
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752215Ab3GHNAr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jul 2013 09:00:47 -0400
Received: from mail9-co9 (localhost [127.0.0.1])	by mail9-co9-R.bigfish.com
 (Postfix) with ESMTP id CED6BC40574	for <linux-scsi@vger.kernel.org>; Mon,  8
 Jul 2013 13:00:46 +0000 (UTC)
Received: from CO9EHSMHS010.bigfish.com (unknown [10.236.132.233])	by
 mail9-co9.bigfish.com (Postfix) with ESMTP id 346A5AC0053	for
 <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2013 13:00:44 +0000 (UTC)
In-Reply-To: <1373286791-29659-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_attr.c |   86 ++++++++++++++++++++++++++++++++++-----
 drivers/scsi/qla4xxx/ql4_def.h  |    9 +---
 drivers/scsi/qla4xxx/ql4_fw.h   |    2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c  |   33 ++++++++++-----
 drivers/scsi/qla4xxx/ql4_os.c   |    4 +-
 5 files changed, 105 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_attr.c b/drivers/scsi/qla4xxx/ql4_attr.c
index 19ee55a..687c07f 100644
--- a/drivers/scsi/qla4xxx/ql4_attr.c
+++ b/drivers/scsi/qla4xxx/ql4_attr.c
@@ -158,14 +158,12 @@ qla4xxx_fw_version_show(struct device *dev,
 
 	if (is_qla80XX(ha))
 		return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d (%x)\n",
-				ha->firmware_version[0],
-				ha->firmware_version[1],
-				ha->patch_number, ha->build_number);
+				ha->fw_info.fw_major, ha->fw_info.fw_minor,
+				ha->fw_info.fw_patch, ha->fw_info.fw_build);
 	else
 		return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d.%02d\n",
-				ha->firmware_version[0],
-				ha->firmware_version[1],
-				ha->patch_number, ha->build_number);
+				ha->fw_info.fw_major, ha->fw_info.fw_minor,
+				ha->fw_info.fw_patch, ha->fw_info.fw_build);
 }
 
 static ssize_t
@@ -181,8 +179,8 @@ qla4xxx_iscsi_version_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
 	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "%d.%02d\n", ha->iscsi_major,
-			ha->iscsi_minor);
+	return snprintf(buf, PAGE_SIZE, "%d.%02d\n", ha->fw_info.iscsi_major,
+			ha->fw_info.iscsi_minor);
 }
 
 static ssize_t
@@ -191,8 +189,8 @@ qla4xxx_optrom_version_show(struct device *dev, struct device_attribute *attr,
 {
 	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
 	return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d.%02d\n",
-			ha->bootload_major, ha->bootload_minor,
-			ha->bootload_patch, ha->bootload_build);
+			ha->fw_info.bootload_major, ha->fw_info.bootload_minor,
+			ha->fw_info.bootload_patch, ha->fw_info.bootload_build);
 }
 
 static ssize_t
@@ -259,6 +257,63 @@ qla4xxx_hba_model_show(struct device *dev, struct device_attribute *attr,
 	return snprintf(buf, PAGE_SIZE, "%s\n", ha->model_name);
 }
 
+static ssize_t
+qla4xxx_fw_timestamp_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
+	return snprintf(buf, PAGE_SIZE, "%s %s\n", ha->fw_info.fw_build_date,
+			ha->fw_info.fw_build_time);
+}
+
+static ssize_t
+qla4xxx_fw_build_user_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
+	return snprintf(buf, PAGE_SIZE, "%s\n", ha->fw_info.fw_build_user);
+}
+
+static ssize_t
+qla4xxx_fw_ext_timestamp_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
+{
+	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
+	return snprintf(buf, PAGE_SIZE, "%s\n", ha->fw_info.extended_timestamp);
+}
+
+static ssize_t
+qla4xxx_fw_load_src_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
+	char *load_src = NULL;
+
+	switch (ha->fw_info.fw_load_source) {
+	case 1:
+		load_src = "Flash Primary";
+		break;
+	case 2:
+		load_src = "Flash Secondary";
+		break;
+	case 3:
+		load_src = "Host Download";
+		break;
+	}
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", load_src);
+}
+
+static ssize_t
+qla4xxx_fw_uptime_show(struct device *dev, struct device_attribute *attr,
+		       char *buf)
+{
+	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
+	qla4xxx_about_firmware(ha);
+	return snprintf(buf, PAGE_SIZE, "%u.%u secs\n", ha->fw_uptime_secs,
+			ha->fw_uptime_msecs);
+}
+
 static DEVICE_ATTR(fw_version, S_IRUGO, qla4xxx_fw_version_show, NULL);
 static DEVICE_ATTR(serial_num, S_IRUGO, qla4xxx_serial_num_show, NULL);
 static DEVICE_ATTR(iscsi_version, S_IRUGO, qla4xxx_iscsi_version_show, NULL);
@@ -269,6 +324,12 @@ static DEVICE_ATTR(phy_port_cnt, S_IRUGO, qla4xxx_phy_port_cnt_show, NULL);
 static DEVICE_ATTR(phy_port_num, S_IRUGO, qla4xxx_phy_port_num_show, NULL);
 static DEVICE_ATTR(iscsi_func_cnt, S_IRUGO, qla4xxx_iscsi_func_cnt_show, NULL);
 static DEVICE_ATTR(hba_model, S_IRUGO, qla4xxx_hba_model_show, NULL);
+static DEVICE_ATTR(fw_timestamp, S_IRUGO, qla4xxx_fw_timestamp_show, NULL);
+static DEVICE_ATTR(fw_build_user, S_IRUGO, qla4xxx_fw_build_user_show, NULL);
+static DEVICE_ATTR(fw_ext_timestamp, S_IRUGO, qla4xxx_fw_ext_timestamp_show,
+		   NULL);
+static DEVICE_ATTR(fw_load_src, S_IRUGO, qla4xxx_fw_load_src_show, NULL);
+static DEVICE_ATTR(fw_uptime, S_IRUGO, qla4xxx_fw_uptime_show, NULL);
 
 struct device_attribute *qla4xxx_host_attrs[] = {
 	&dev_attr_fw_version,
@@ -281,5 +342,10 @@ struct device_attribute *qla4xxx_host_attrs[] = {
 	&dev_attr_phy_port_num,
 	&dev_attr_iscsi_func_cnt,
 	&dev_attr_hba_model,
+	&dev_attr_fw_timestamp,
+	&dev_attr_fw_build_user,
+	&dev_attr_fw_ext_timestamp,
+	&dev_attr_fw_load_src,
+	&dev_attr_fw_uptime,
 	NULL,
 };
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 50dc0c7..b0a0e93 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -735,12 +735,9 @@ struct scsi_qla_host {
 	struct iscsi_iface *iface_ipv6_1;
 
 	/* --- From About Firmware --- */
-	uint16_t iscsi_major;
-	uint16_t iscsi_minor;
-	uint16_t bootload_major;
-	uint16_t bootload_minor;
-	uint16_t bootload_patch;
-	uint16_t bootload_build;
+	struct about_fw_info fw_info;
+	uint32_t fw_uptime_secs;  /* seconds elapsed since fw bootup */
+	uint32_t fw_uptime_msecs; /* milliseconds beyond elapsed seconds */
 	uint16_t def_timeout; /* Default login timeout */
 
 	uint32_t flash_state;
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index c7b8892..9a46f59 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -955,7 +955,7 @@ struct about_fw_info {
 	uint16_t bootload_minor;	/* 46 - 47 */
 	uint16_t bootload_patch;	/* 48 - 49 */
 	uint16_t bootload_build;	/* 4A - 4B */
-	uint8_t reserved2[180];		/* 4C - FF */
+	uint8_t extended_timestamp[180];/* 4C - FF */
 };
 
 struct crash_record {
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index a501bea..3c18b7f 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -5,6 +5,7 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
+#include <linux/ctype.h>
 #include "ql4_def.h"
 #include "ql4_glbl.h"
 #include "ql4_dbg.h"
@@ -1270,16 +1271,28 @@ int qla4xxx_about_firmware(struct scsi_qla_host *ha)
 	}
 
 	/* Save version information. */
-	ha->firmware_version[0] = le16_to_cpu(about_fw->fw_major);
-	ha->firmware_version[1] = le16_to_cpu(about_fw->fw_minor);
-	ha->patch_number = le16_to_cpu(about_fw->fw_patch);
-	ha->build_number = le16_to_cpu(about_fw->fw_build);
-	ha->iscsi_major = le16_to_cpu(about_fw->iscsi_major);
-	ha->iscsi_minor = le16_to_cpu(about_fw->iscsi_minor);
-	ha->bootload_major = le16_to_cpu(about_fw->bootload_major);
-	ha->bootload_minor = le16_to_cpu(about_fw->bootload_minor);
-	ha->bootload_patch = le16_to_cpu(about_fw->bootload_patch);
-	ha->bootload_build = le16_to_cpu(about_fw->bootload_build);
+	ha->fw_info.fw_major = le16_to_cpu(about_fw->fw_major);
+	ha->fw_info.fw_minor = le16_to_cpu(about_fw->fw_minor);
+	ha->fw_info.fw_patch = le16_to_cpu(about_fw->fw_patch);
+	ha->fw_info.fw_build = le16_to_cpu(about_fw->fw_build);
+	memcpy(ha->fw_info.fw_build_date, about_fw->fw_build_date,
+	       sizeof(about_fw->fw_build_date));
+	memcpy(ha->fw_info.fw_build_time, about_fw->fw_build_time,
+	       sizeof(about_fw->fw_build_time));
+	strcpy((char *)ha->fw_info.fw_build_user,
+	       skip_spaces((char *)about_fw->fw_build_user));
+	ha->fw_info.fw_load_source = le16_to_cpu(about_fw->fw_load_source);
+	ha->fw_info.iscsi_major = le16_to_cpu(about_fw->iscsi_major);
+	ha->fw_info.iscsi_minor = le16_to_cpu(about_fw->iscsi_minor);
+	ha->fw_info.bootload_major = le16_to_cpu(about_fw->bootload_major);
+	ha->fw_info.bootload_minor = le16_to_cpu(about_fw->bootload_minor);
+	ha->fw_info.bootload_patch = le16_to_cpu(about_fw->bootload_patch);
+	ha->fw_info.bootload_build = le16_to_cpu(about_fw->bootload_build);
+	strcpy((char *)ha->fw_info.extended_timestamp,
+	       skip_spaces((char *)about_fw->extended_timestamp));
+
+	ha->fw_uptime_secs = le32_to_cpu(mbox_sts[5]);
+	ha->fw_uptime_msecs = le32_to_cpu(mbox_sts[6]);
 	status = QLA_SUCCESS;
 
 exit_about_fw:
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 52d01ae..14472b1 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -7220,8 +7220,8 @@ skip_retry_init:
 	       " QLogic iSCSI HBA Driver version: %s\n"
 	       "  QLogic ISP%04x @ %s, host#=%ld, fw=%02d.%02d.%02d.%02d\n",
 	       qla4xxx_version_str, ha->pdev->device, pci_name(ha->pdev),
-	       ha->host_no, ha->firmware_version[0], ha->firmware_version[1],
-	       ha->patch_number, ha->build_number);
+	       ha->host_no, ha->fw_info.fw_major, ha->fw_info.fw_minor,
+	       ha->fw_info.fw_patch, ha->fw_info.fw_build);
 
 	/* Set the driver version */
 	if (is_qla80XX(ha))
-- 
1.7.1


