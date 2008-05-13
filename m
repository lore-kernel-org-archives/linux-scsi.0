From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 04/10] qla2xxx: firmware semaphore to mutex
Date: Mon, 12 May 2008 22:21:10 -0700
Message-ID: <1210656076-54720-4-git-send-email-andrew.vasquez@qlogic.com>
References: <20080513051948.GN22377@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:52305 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679AbYEMFVR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 May 2008 01:21:17 -0400
In-Reply-To: <20080513051948.GN22377@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Daniel Walker <dwalker@mvista.com>

From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index dd1e117..9982ecd 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -10,6 +10,7 @@
 #include <linux/vmalloc.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/mutex.h>
 
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
@@ -2634,7 +2635,7 @@ qla2x00_timer(scsi_qla_host_t *ha)
 #define FW_FILE_ISP24XX	"ql2400_fw.bin"
 #define FW_FILE_ISP25XX	"ql2500_fw.bin"
 
-static DECLARE_MUTEX(qla_fw_lock);
+static DEFINE_MUTEX(qla_fw_lock);
 
 static struct fw_blob qla_fw_blobs[FW_BLOBS] = {
 	{ .name = FW_FILE_ISP21XX, .segs = { 0x1000, 0 }, },
@@ -2665,7 +2666,7 @@ qla2x00_request_firmware(scsi_qla_host_t *ha)
 		blob = &qla_fw_blobs[FW_ISP25XX];
 	}
 
-	down(&qla_fw_lock);
+	mutex_lock(&qla_fw_lock);
 	if (blob->fw)
 		goto out;
 
@@ -2678,7 +2679,7 @@ qla2x00_request_firmware(scsi_qla_host_t *ha)
 	}
 
 out:
-	up(&qla_fw_lock);
+	mutex_unlock(&qla_fw_lock);
 	return blob;
 }
 
@@ -2687,11 +2688,11 @@ qla2x00_release_firmware(void)
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
1.5.5.1.211.g65ea3

