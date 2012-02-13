From: vikas.chaudhary@qlogic.com
Subject: [PATCH 04/11] qla4xxx: Modified debug log messages for boot info.
Date: Mon, 13 Feb 2012 18:30:43 +0530
Message-ID: <1329138050-1042-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:14802
	"HELO magana.localdomain" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1756611Ab2BMNJy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2012 08:09:54 -0500
In-Reply-To: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com, vikas.chaudhary@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

In some configurations user may not have boot targets configured.
In such cases the debug messages printed out by driver look like
some kind of failure happening. However this could be a valid
case, so modified the messages to appear as warning messages
versus failure messages.

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a9ff05e..3339cc1 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3393,9 +3393,8 @@ static int get_fw_boot_info(struct scsi_qla_host *ha, uint16_t ddb_index[])
 		/* Check Boot Mode */
 		val = rd_nvram_byte(ha, addr);
 		if (!(val & 0x07)) {
-			DEBUG2(ql4_printk(KERN_ERR, ha,
-					  "%s: Failed Boot options : 0x%x\n",
-					  __func__, val));
+			DEBUG2(ql4_printk(KERN_INFO, ha, "%s: Adapter boot "
+					  "options : 0x%x\n", __func__, val));
 			ret = QLA_ERROR;
 			goto exit_boot_info;
 		}
@@ -3440,9 +3439,8 @@ static int get_fw_boot_info(struct scsi_qla_host *ha, uint16_t ddb_index[])
 		}
 		/* Check Boot Mode */
 		if (!(buf[1] & 0x07)) {
-			DEBUG2(ql4_printk(KERN_INFO, ha,
-					  "Failed: Boot options : 0x%x\n",
-					  buf[1]));
+			DEBUG2(ql4_printk(KERN_INFO, ha, "Firmware boot options"
+					  " : 0x%x\n", buf[1]));
 			ret = QLA_ERROR;
 			goto exit_boot_info_free;
 		}
@@ -3548,8 +3546,8 @@ static int qla4xxx_get_boot_target(struct scsi_qla_host *ha,
 
 	if (qla4xxx_bootdb_by_index(ha, fw_ddb_entry,
 				   fw_ddb_entry_dma, ddb_index)) {
-		DEBUG2(ql4_printk(KERN_ERR, ha,
-				  "%s: Flash DDB read Failed\n", __func__));
+		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: No Flash DDB found at "
+				  "index [%d]\n", __func__, ddb_index));
 		ret = QLA_ERROR;
 		goto exit_boot_target;
 	}
@@ -3627,8 +3625,8 @@ static int qla4xxx_get_boot_info(struct scsi_qla_host *ha)
 	ddb_index[1] = 0xffff;
 	ret = get_fw_boot_info(ha, ddb_index);
 	if (ret != QLA_SUCCESS) {
-		DEBUG2(ql4_printk(KERN_ERR, ha,
-				  "%s: Failed to set boot info.\n", __func__));
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				"%s: No boot target configured.\n", __func__));
 		return ret;
 	}
 
@@ -3641,8 +3639,8 @@ static int qla4xxx_get_boot_info(struct scsi_qla_host *ha)
 	rval = qla4xxx_get_boot_target(ha, &(ha->boot_tgt.boot_pri_sess),
 				      ddb_index[0]);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2(ql4_printk(KERN_ERR, ha, "%s: Failed to get "
-				  "primary target\n", __func__));
+		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: Primary boot target not "
+				  "configured\n", __func__));
 	} else
 		ret = QLA_SUCCESS;
 
@@ -3653,8 +3651,8 @@ sec_target:
 	rval = qla4xxx_get_boot_target(ha, &(ha->boot_tgt.boot_sec_sess),
 				      ddb_index[1]);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2(ql4_printk(KERN_ERR, ha, "%s: Failed to get "
-				  "secondary target\n", __func__));
+		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: Secondary boot target not"
+				  " configured\n", __func__));
 	} else
 		ret = QLA_SUCCESS;
 
-- 
1.7.8.247.g10f4e

