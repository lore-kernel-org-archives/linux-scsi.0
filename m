From: Nilesh Javali <nilesh.javali@cavium.com>
Subject: [PATCH v3 1/2] qedi: Fix truncation of CHAP name and secret
Date: Wed, 7 Feb 2018 08:12:35 -0800
Message-ID: <20180207161236.12975-2-nilesh.javali@cavium.com>
References: <20180207161236.12975-1-nilesh.javali@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0062.outbound.protection.outlook.com ([104.47.32.62]:57922
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754166AbeBGQMn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Feb 2018 11:12:43 -0500
In-Reply-To: <20180207161236.12975-1-nilesh.javali@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

From: Andrew Vasquez <andrew.vasquez@cavium.com>

The data in NVRAM is not guaranteed to be NUL terminated.
Since snprintf expects byte-stream to accommodate null byte,
the CHAP secret is truncated.
Use sprintf instead of snprintf to fix the truncation of
CHAP name and secret.

Signed-off-by: Andrew Vasquez <andrew.vasquez@cavium.com>
Signed-off-by: Nilesh Javali <nilesh.javali@cavium.com>
---
 drivers/scsi/qedi/qedi_main.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 8808f0d..deaed93 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1842,8 +1842,8 @@ static ssize_t qedi_show_boot_ini_info(void *data, int type, char *buf)
 
 	switch (type) {
 	case ISCSI_BOOT_INI_INITIATOR_NAME:
-		rc = snprintf(str, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN, "%s\n",
-			      initiator->initiator_name.byte);
+		rc = sprintf(str, "%.*s\n", NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN,
+			     initiator->initiator_name.byte);
 		break;
 	default:
 		rc = 0;
@@ -1910,8 +1910,8 @@ static umode_t qedi_ini_get_attr_visibility(void *data, int type)
 
 	switch (type) {
 	case ISCSI_BOOT_TGT_NAME:
-		rc = snprintf(str, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN, "%s\n",
-			      block->target[idx].target_name.byte);
+		rc = sprintf(str, "%.*s\n", NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN,
+			     block->target[idx].target_name.byte);
 		break;
 	case ISCSI_BOOT_TGT_IP_ADDR:
 		if (ipv6_en)
@@ -1932,20 +1932,20 @@ static umode_t qedi_ini_get_attr_visibility(void *data, int type)
 			      block->target[idx].lun.value[0]);
 		break;
 	case ISCSI_BOOT_TGT_CHAP_NAME:
-		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN, "%s\n",
-			      chap_name);
+		rc = sprintf(str, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
+			     chap_name);
 		break;
 	case ISCSI_BOOT_TGT_CHAP_SECRET:
-		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN, "%s\n",
-			      chap_secret);
+		rc = sprintf(str, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
+			     chap_secret);
 		break;
 	case ISCSI_BOOT_TGT_REV_CHAP_NAME:
-		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN, "%s\n",
-			      mchap_name);
+		rc = sprintf(str, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
+			     mchap_name);
 		break;
 	case ISCSI_BOOT_TGT_REV_CHAP_SECRET:
-		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN, "%s\n",
-			      mchap_secret);
+		rc = sprintf(str, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
+			     mchap_secret);
 		break;
 	case ISCSI_BOOT_TGT_FLAGS:
 		rc = snprintf(str, 3, "%hhd\n", SYSFS_FLAG_FW_SEL_BOOT);
-- 
1.8.3.1
