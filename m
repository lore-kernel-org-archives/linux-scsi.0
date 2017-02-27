From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: lpfc: use div_u64 for 64-bit division
Date: Mon, 27 Feb 2017 21:31:43 +0100
Message-ID: <20170227203159.3272843-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:58252 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbdB0UnE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2017 15:43:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The new debugfs output causes a link error on 32-bit architectures:

ERROR: "__aeabi_uldivmod" [drivers/scsi/lpfc/lpfc.ko] undefined!

This code is not performance critical, so we can simply use div_u64().

Fixes: bd2cdd5e400f ("scsi: lpfc: NVME Initiator: Add debugfs support")
Fixes: 2b65e18202fd ("scsi: lpfc: NVME Target: Add debugfs support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 64 ++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 599fde4ea8b1..47c67bf0514e 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -873,8 +873,8 @@ lpfc_debugfs_nvmektime_data(struct lpfc_vport *vport, char *buf, int size)
 		len += snprintf(
 			buf + len, PAGE_SIZE - len,
 			"avg:%08lld min:%08lld max %08lld\n",
-			phba->ktime_seg1_total /
-			phba->ktime_data_samples,
+			div_u64(phba->ktime_seg1_total,
+			        phba->ktime_data_samples),
 			phba->ktime_seg1_min,
 			phba->ktime_seg1_max);
 		len += snprintf(
@@ -884,8 +884,8 @@ lpfc_debugfs_nvmektime_data(struct lpfc_vport *vport, char *buf, int size)
 		len += snprintf(
 			buf + len, PAGE_SIZE - len,
 			"avg:%08lld min:%08lld max %08lld\n",
-			phba->ktime_seg2_total /
-			phba->ktime_data_samples,
+			div_u64(phba->ktime_seg2_total,
+				phba->ktime_data_samples),
 			phba->ktime_seg2_min,
 			phba->ktime_seg2_max);
 		len += snprintf(
@@ -895,8 +895,8 @@ lpfc_debugfs_nvmektime_data(struct lpfc_vport *vport, char *buf, int size)
 		len += snprintf(
 			buf + len, PAGE_SIZE - len,
 			"avg:%08lld min:%08lld max %08lld\n",
-			phba->ktime_seg3_total /
-			phba->ktime_data_samples,
+			div_u64(phba->ktime_seg3_total,
+				phba->ktime_data_samples),
 			phba->ktime_seg3_min,
 			phba->ktime_seg3_max);
 		len += snprintf(
@@ -906,17 +906,17 @@ lpfc_debugfs_nvmektime_data(struct lpfc_vport *vport, char *buf, int size)
 		len += snprintf(
 			buf + len, PAGE_SIZE - len,
 			"avg:%08lld min:%08lld max %08lld\n",
-			phba->ktime_seg4_total /
-			phba->ktime_data_samples,
+			div_u64(phba->ktime_seg4_total,
+				phba->ktime_data_samples),
 			phba->ktime_seg4_min,
 			phba->ktime_seg4_max);
 		len += snprintf(
 			buf + len, PAGE_SIZE - len,
 			"Total IO avg time: %08lld\n",
-			((phba->ktime_seg1_total +
+			div_u64(phba->ktime_seg1_total +
 			phba->ktime_seg2_total  +
 			phba->ktime_seg3_total +
-			phba->ktime_seg4_total) /
+			phba->ktime_seg4_total,
 			phba->ktime_data_samples));
 		return len;
 	}
@@ -935,8 +935,8 @@ lpfc_debugfs_nvmektime_data(struct lpfc_vport *vport, char *buf, int size)
 			"cmd pass to NVME Layer\n");
 	len += snprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
-			phba->ktime_seg1_total /
-			phba->ktime_data_samples,
+			div_u64(phba->ktime_seg1_total,
+				phba->ktime_data_samples),
 			phba->ktime_seg1_min,
 			phba->ktime_seg1_max);
 	len += snprintf(buf + len, PAGE_SIZE-len,
@@ -944,8 +944,8 @@ lpfc_debugfs_nvmektime_data(struct lpfc_vport *vport, char *buf, int size)
 			"-to- Driver rcv cmd OP (action)\n");
 	len += snprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
-			phba->ktime_seg2_total /
-			phba->ktime_data_samples,
+			div_u64(phba->ktime_seg2_total,
+				phba->ktime_data_samples),
 			phba->ktime_seg2_min,
 			phba->ktime_seg2_max);
 	len += snprintf(buf + len, PAGE_SIZE-len,
@@ -953,8 +953,8 @@ lpfc_debugfs_nvmektime_data(struct lpfc_vport *vport, char *buf, int size)
 			"Firmware WQ doorbell: cmd\n");
 	len += snprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
-			phba->ktime_seg3_total /
-			phba->ktime_data_samples,
+			div_u64(phba->ktime_seg3_total,
+				phba->ktime_data_samples),
 			phba->ktime_seg3_min,
 			phba->ktime_seg3_max);
 	len += snprintf(buf + len, PAGE_SIZE-len,
@@ -962,8 +962,8 @@ lpfc_debugfs_nvmektime_data(struct lpfc_vport *vport, char *buf, int size)
 			"-to- MSI-X ISR for cmd cmpl\n");
 	len += snprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
-			phba->ktime_seg4_total /
-			phba->ktime_data_samples,
+			div_u64(phba->ktime_seg4_total,
+				phba->ktime_data_samples),
 			phba->ktime_seg4_min,
 			phba->ktime_seg4_max);
 	len += snprintf(buf + len, PAGE_SIZE-len,
@@ -971,8 +971,8 @@ lpfc_debugfs_nvmektime_data(struct lpfc_vport *vport, char *buf, int size)
 			"-to- NVME layer passed cmd done\n");
 	len += snprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
-			phba->ktime_seg5_total /
-			phba->ktime_data_samples,
+			div_u64(phba->ktime_seg5_total,
+				phba->ktime_data_samples),
 			phba->ktime_seg5_min,
 			phba->ktime_seg5_max);
 
@@ -983,8 +983,8 @@ lpfc_debugfs_nvmektime_data(struct lpfc_vport *vport, char *buf, int size)
 		len += snprintf(buf + len, PAGE_SIZE-len,
 				"avg:%08lld min:%08lld "
 				"max %08lld\n",
-				phba->ktime_seg10_total /
-				phba->ktime_data_samples,
+				div_u64(phba->ktime_seg10_total,
+					phba->ktime_data_samples),
 				phba->ktime_seg10_min,
 				phba->ktime_seg10_max);
 		return len;
@@ -995,8 +995,8 @@ lpfc_debugfs_nvmektime_data(struct lpfc_vport *vport, char *buf, int size)
 			"-to- Driver rcv rsp status OP\n");
 	len += snprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
-			phba->ktime_seg6_total /
-			phba->ktime_status_samples,
+			div_u64(phba->ktime_seg6_total,
+				phba->ktime_status_samples),
 			phba->ktime_seg6_min,
 			phba->ktime_seg6_max);
 	len += snprintf(buf + len, PAGE_SIZE-len,
@@ -1004,8 +1004,8 @@ lpfc_debugfs_nvmektime_data(struct lpfc_vport *vport, char *buf, int size)
 			"-to- Firmware WQ doorbell: status\n");
 	len += snprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
-			phba->ktime_seg7_total /
-			phba->ktime_status_samples,
+			div_u64(phba->ktime_seg7_total,
+				phba->ktime_status_samples),
 			phba->ktime_seg7_min,
 			phba->ktime_seg7_max);
 	len += snprintf(buf + len, PAGE_SIZE-len,
@@ -1013,8 +1013,8 @@ lpfc_debugfs_nvmektime_data(struct lpfc_vport *vport, char *buf, int size)
 			" -to- MSI-X ISR for status cmpl\n");
 	len += snprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
-			phba->ktime_seg8_total /
-			phba->ktime_status_samples,
+			div_u64(phba->ktime_seg8_total,
+				phba->ktime_status_samples),
 			phba->ktime_seg8_min,
 			phba->ktime_seg8_max);
 	len += snprintf(buf + len, PAGE_SIZE-len,
@@ -1022,8 +1022,8 @@ lpfc_debugfs_nvmektime_data(struct lpfc_vport *vport, char *buf, int size)
 			"-to- NVME layer passed status done\n");
 	len += snprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
-			phba->ktime_seg9_total /
-			phba->ktime_status_samples,
+			div_u64(phba->ktime_seg9_total,
+				phba->ktime_status_samples),
 			phba->ktime_seg9_min,
 			phba->ktime_seg9_max);
 	len += snprintf(buf + len, PAGE_SIZE-len,
@@ -1031,8 +1031,8 @@ lpfc_debugfs_nvmektime_data(struct lpfc_vport *vport, char *buf, int size)
 			"cmd completed on wire\n");
 	len += snprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
-			phba->ktime_seg10_total /
-			phba->ktime_status_samples,
+			div_u64(phba->ktime_seg10_total,
+				phba->ktime_status_samples),
 			phba->ktime_seg10_min,
 			phba->ktime_seg10_max);
 	return len;
-- 
2.9.0
