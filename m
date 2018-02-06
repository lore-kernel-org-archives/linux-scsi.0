From: Nilesh Javali <nilesh.javali@cavium.com>
Subject: [PATCH V2 1/2] qedi: Fix truncation of CHAP name and secret
Date: Tue, 6 Feb 2018 05:12:18 -0800
Message-ID: <20180206131219.18184-2-nilesh.javali@cavium.com>
References: <20180206131219.18184-1-nilesh.javali@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0061.outbound.protection.outlook.com ([104.47.33.61]:3779
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753037AbeBFNM1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Feb 2018 08:12:27 -0500
In-Reply-To: <20180206131219.18184-1-nilesh.javali@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

From: Andrew Vasquez <andrew.vasquez@cavium.com>

The data in NVRAM is not guaranteed to be NUL terminated.
Copy the data upto the element size or to the first NUL
in the byte-stream and then append a NUL.

Signed-off-by: Andrew Vasquez <andrew.vasquez@cavium.com>
Signed-off-by: Nilesh Javali <nilesh.javali@cavium.com>
---
 drivers/scsi/qedi/qedi_main.c | 45 +++++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 8808f0d..f3dd438 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1705,6 +1705,27 @@ void qedi_reset_host_mtu(struct qedi_ctx *qedi, u16 mtu)
 	qedi_ops->ll2->start(qedi->cdev, &params);
 }
 
+static ssize_t
+qedi_show_copy_data(char *buf, size_t size, u8 *data)
+{
+	size_t i;
+
+	if (!data)
+		return sprintf(buf, "\n");
+
+	/*
+	 * Data not guaranteed to be NUL terminated. Copy until NUL found or
+	 * complete copy done.
+	 */
+	for (i = 0; i < size && data[i]; i++)
+		buf[i] = data[i];
+
+	/* Data copy complete, append NEWLINE and NUL terminator. */
+	buf[i] = '\n';
+	buf[i + 1] = '\0';
+	return strlen(buf);
+}
+
 /**
  * qedi_get_nvram_block: - Scan through the iSCSI NVRAM block (while accounting
  * for gaps) for the matching absolute-pf-id of the QEDI device.
@@ -1842,8 +1863,8 @@ static ssize_t qedi_show_boot_ini_info(void *data, int type, char *buf)
 
 	switch (type) {
 	case ISCSI_BOOT_INI_INITIATOR_NAME:
-		rc = snprintf(str, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN, "%s\n",
-			      initiator->initiator_name.byte);
+		rc = qedi_show_copy_data(str, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN,
+					 initiator->initiator_name.byte);
 		break;
 	default:
 		rc = 0;
@@ -1910,8 +1931,8 @@ static umode_t qedi_ini_get_attr_visibility(void *data, int type)
 
 	switch (type) {
 	case ISCSI_BOOT_TGT_NAME:
-		rc = snprintf(str, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN, "%s\n",
-			      block->target[idx].target_name.byte);
+		rc = qedi_show_copy_data(str, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN,
+					 block->target[idx].target_name.byte);
 		break;
 	case ISCSI_BOOT_TGT_IP_ADDR:
 		if (ipv6_en)
@@ -1932,20 +1953,20 @@ static umode_t qedi_ini_get_attr_visibility(void *data, int type)
 			      block->target[idx].lun.value[0]);
 		break;
 	case ISCSI_BOOT_TGT_CHAP_NAME:
-		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN, "%s\n",
-			      chap_name);
+		rc = qedi_show_copy_data(str, NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
+					 chap_name);
 		break;
 	case ISCSI_BOOT_TGT_CHAP_SECRET:
-		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN, "%s\n",
-			      chap_secret);
+		rc = qedi_show_copy_data(str, NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN,
+					 chap_secret);
 		break;
 	case ISCSI_BOOT_TGT_REV_CHAP_NAME:
-		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN, "%s\n",
-			      mchap_name);
+		rc = qedi_show_copy_data(str, NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
+					 mchap_name);
 		break;
 	case ISCSI_BOOT_TGT_REV_CHAP_SECRET:
-		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN, "%s\n",
-			      mchap_secret);
+		rc = qedi_show_copy_data(str, NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN,
+					 mchap_secret);
 		break;
 	case ISCSI_BOOT_TGT_FLAGS:
 		rc = snprintf(str, 3, "%hhd\n", SYSFS_FLAG_FW_SEL_BOOT);
-- 
1.8.3.1
