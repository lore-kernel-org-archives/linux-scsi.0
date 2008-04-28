From: Daniel Walker <dwalker@mvista.com>
Subject: [PATCH] qla2xxx: firmware semaphore to mutex
Date: Mon, 28 Apr 2008 10:47:42 -0700
Message-ID: <20080428174742.163523860@mvista.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([63.81.120.158]:53811 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935792AbYD1RuL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Apr 2008 13:50:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: mingo@elte.hu, matthew@wil.cx, linux-driver@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/scsi/qla2xxx/qla_os.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6.23/drivers/scsi/qla2xxx/qla_os.c
===================================================================
--- linux-2.6.23.orig/drivers/scsi/qla2xxx/qla_os.c
+++ linux-2.6.23/drivers/scsi/qla2xxx/qla_os.c
@@ -10,6 +10,7 @@
 #include <linux/vmalloc.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/mutex.h>
 
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
@@ -2782,7 +2783,7 @@ qla2x00_down_timeout(struct semaphore *s
 #define FW_FILE_ISP24XX	"ql2400_fw.bin"
 #define FW_FILE_ISP25XX	"ql2500_fw.bin"
 
-static DECLARE_MUTEX(qla_fw_lock);
+static DEFINE_MUTEX(qla_fw_lock);
 
 static struct fw_blob qla_fw_blobs[FW_BLOBS] = {
 	{ .name = FW_FILE_ISP21XX, .segs = { 0x1000, 0 }, },
@@ -2813,7 +2814,7 @@ qla2x00_request_firmware(scsi_qla_host_t
 		blob = &qla_fw_blobs[FW_ISP25XX];
 	}
 
-	down(&qla_fw_lock);
+	mutex_lock(&qla_fw_lock);
 	if (blob->fw)
 		goto out;
 
@@ -2826,7 +2827,7 @@ qla2x00_request_firmware(scsi_qla_host_t
 	}
 
 out:
-	up(&qla_fw_lock);
+	mutex_unlock(&qla_fw_lock);
 	return blob;
 }
 
@@ -2835,11 +2836,11 @@ qla2x00_release_firmware(void)
 {
 	int idx;
 
-	down(&qla_fw_lock);
+	mutex_lock(&qla_fw_lock);
 	for (idx = 0; idx < FW_BLOBS; idx++)
 		if (qla_fw_blobs[idx].fw)
 			release_firmware(qla_fw_blobs[idx].fw);
-	up(&qla_fw_lock);
+	mutex_unlock(&qla_fw_lock);
 }
 
 static pci_ers_result_t
-- 

-- 
