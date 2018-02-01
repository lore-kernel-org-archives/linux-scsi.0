From: Nilesh Javali <nilesh.javali@cavium.com>
Subject: [PATCH] qedi: Fix truncation of name and secret
Date: Wed, 31 Jan 2018 22:57:34 -0800
Message-ID: <20180201065734.20441-1-nilesh.javali@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0089.outbound.protection.outlook.com ([104.47.36.89]:61920
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751727AbeBAG5i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Feb 2018 01:57:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

Adjust the NULL byte added by snprintf.

Signed-off-by: Nilesh Javali <nilesh.javali@cavium.com>
---
 drivers/scsi/qedi/qedi_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index cccc34a..cf8badb 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1840,7 +1840,7 @@ static ssize_t qedi_show_boot_ini_info(void *data, int type, char *buf)
 
 	switch (type) {
 	case ISCSI_BOOT_INI_INITIATOR_NAME:
-		rc = snprintf(str, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN, "%s\n",
+		rc = snprintf(str, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN + 1, "%s",
 			      initiator->initiator_name.byte);
 		break;
 	default:
@@ -1908,7 +1908,7 @@ static umode_t qedi_ini_get_attr_visibility(void *data, int type)
 
 	switch (type) {
 	case ISCSI_BOOT_TGT_NAME:
-		rc = snprintf(str, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN, "%s\n",
+		rc = snprintf(str, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN + 1, "%s",
 			      block->target[idx].target_name.byte);
 		break;
 	case ISCSI_BOOT_TGT_IP_ADDR:
@@ -1930,19 +1930,19 @@ static umode_t qedi_ini_get_attr_visibility(void *data, int type)
 			      block->target[idx].lun.value[0]);
 		break;
 	case ISCSI_BOOT_TGT_CHAP_NAME:
-		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN, "%s\n",
+		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN + 1, "%s",
 			      chap_name);
 		break;
 	case ISCSI_BOOT_TGT_CHAP_SECRET:
-		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN, "%s\n",
+		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN + 1, "%s",
 			      chap_secret);
 		break;
 	case ISCSI_BOOT_TGT_REV_CHAP_NAME:
-		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN, "%s\n",
+		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN + 1, "%s",
 			      mchap_name);
 		break;
 	case ISCSI_BOOT_TGT_REV_CHAP_SECRET:
-		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN, "%s\n",
+		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN + 1, "%s",
 			      mchap_secret);
 		break;
 	case ISCSI_BOOT_TGT_FLAGS:
-- 
1.8.3.1
