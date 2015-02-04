From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] Sync iscsi fw boot flags
Date: Tue,  3 Feb 2015 20:28:58 -0600
Message-ID: <1423016938-28552-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46690 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874AbbBDC3I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Feb 2015 21:29:08 -0500
Received: from rh2.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id t142T3SW013136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 3 Feb 2015 20:29:07 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

iBFT and non-iBFT drivers use the same iscsi boot sysfs
interface. For iBFT we just directly export whatever
is left by the FW. For non-iBFT drivers we do vendor
specific commands to get the info or its just hard coded.

This patch syncs up how non-iBFT drivers export boot flag
info. The boot flags being defined in this patch match
the iBFT flags that indicate if the boot info found was
valid and if it was used for to boot with.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c  | 8 +++++---
 drivers/scsi/qla4xxx/ql4_def.h   | 1 -
 drivers/scsi/qla4xxx/ql4_os.c    | 6 ++++--
 include/linux/iscsi_boot_sysfs.h | 3 +++
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index f319340..cd4aff9 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -429,7 +429,8 @@ static ssize_t beiscsi_show_boot_tgt_info(void *data, int type, char *buf)
 			     auth_data.chap.intr_secret);
 		break;
 	case ISCSI_BOOT_TGT_FLAGS:
-		rc = sprintf(str, "2\n");
+		rc = sprintf(str, "%u\n",
+			     ISCSI_BOOT_FLAG_VALID | ISCSI_BOOT_FLAG_FW_BOOT_SEL);
 		break;
 	case ISCSI_BOOT_TGT_NIC_ASSOC:
 		rc = sprintf(str, "0\n");
@@ -466,8 +467,9 @@ static ssize_t beiscsi_show_boot_eth_info(void *data, int type, char *buf)
 
 	switch (type) {
 	case ISCSI_BOOT_ETH_FLAGS:
-		rc = sprintf(str, "2\n");
-		break;
+		rc = sprintf(str, "%u\n",
+			     ISCSI_BOOT_FLAG_VALID | ISCSI_BOOT_FLAG_FW_BOOT_SEL);
+  		break;
 	case ISCSI_BOOT_ETH_INDEX:
 		rc = sprintf(str, "0\n");
 		break;
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 8f6d0fb..0380669 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -796,7 +796,6 @@ struct scsi_qla_host {
 #define CHAP_DMA_BLOCK_SIZE    512
 	struct workqueue_struct *task_wq;
 	unsigned long ddb_idx_map[MAX_DDB_ENTRIES / BITS_PER_LONG];
-#define SYSFS_FLAG_FW_SEL_BOOT 2
 	struct iscsi_boot_kset *boot_kset;
 	struct ql4_boot_tgt_info boot_tgt;
 	uint16_t phy_port_num;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6d25879..b63985f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5705,7 +5705,8 @@ static ssize_t qla4xxx_show_boot_eth_info(void *data, int type, char *buf)
 
 	switch (type) {
 	case ISCSI_BOOT_ETH_FLAGS:
-		rc = sprintf(str, "%d\n", SYSFS_FLAG_FW_SEL_BOOT);
+		rc = sprintf(str, "%d\n",
+			     ISCSI_BOOT_FLAG_VALID | ISCSI_BOOT_FLAG_FW_BOOT_SEL);
 		break;
 	case ISCSI_BOOT_ETH_INDEX:
 		rc = sprintf(str, "0\n");
@@ -5814,7 +5815,8 @@ qla4xxx_show_boot_tgt_info(struct ql4_boot_session_info *boot_sess, int type,
 			     (char *)&boot_conn->chap.intr_secret);
 		break;
 	case ISCSI_BOOT_TGT_FLAGS:
-		rc = sprintf(str, "%d\n", SYSFS_FLAG_FW_SEL_BOOT);
+		rc = sprintf(str, "%d\n",
+			     ISCSI_BOOT_FLAG_VALID | ISCSI_BOOT_FLAG_FW_BOOT_SEL);
 		break;
 	case ISCSI_BOOT_TGT_NIC_ASSOC:
 		rc = sprintf(str, "0\n");
diff --git a/include/linux/iscsi_boot_sysfs.h b/include/linux/iscsi_boot_sysfs.h
index 2a8b165..3f273d6 100644
--- a/include/linux/iscsi_boot_sysfs.h
+++ b/include/linux/iscsi_boot_sysfs.h
@@ -16,6 +16,9 @@
 #ifndef _ISCSI_BOOT_SYSFS_
 #define _ISCSI_BOOT_SYSFS_
 
+#define ISCSI_BOOT_FLAG_VALID		0x1
+#define ISCSI_BOOT_FLAG_FW_BOOT_SEL	0x2
+
 /*
  * The text attributes names for each of the kobjects.
 */
-- 
1.8.3.1

