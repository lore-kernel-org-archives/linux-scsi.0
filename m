From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCH 2/3] qla4xxx: qla4xxx: Add a timeout period and return status from ql4xxx_lock_drvr_wait()
Date: Sat, 05 Aug 2006 02:05:35 -0500
Message-ID: <20060805070535.23332.49867.stgit@bebe.enoyolf.org>
References: <20060805070514.23332.36344.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:34754 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S1422673AbWHEHHm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Aug 2006 03:07:42 -0400
In-Reply-To: <20060805070514.23332.36344.stgit@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, dwm@austin.ibm.com

From: Doug Maxey <dwm@enoyolf.org>

Change the func to only wait for QL4_LOCK_DRVR_WAIT ms.
Fix callers to use the return status.

Signed-off-by: Doug Maxey <dwm@enoyolf.org>
---

 drivers/scsi/qla4xxx/ql4_init.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 8608106..8fb39b5 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -988,25 +988,29 @@ static int qla4xxx_start_firmware_from_f
 	return status;
 }
 
-static void ql4xxx_lock_drvr_wait(struct scsi_qla_host *a)
+static int ql4xxx_lock_drvr_wait(struct scsi_qla_host *a)
 {
-	int i = 0;
-	while (1) {
+#define QL4_LOCK_DRVR_WAIT (20000)
+#define QL4_LOCK_DRVR_SLEEP (10)
+	int i = QL4_LOCK_DRVR_WAIT;
+
+	while (i > 0) {
 		if (ql4xxx_lock_drvr(a) == 0) {
-			msleep(10);
-			if (!i) {
+			msleep(QL4_LOCK_DRVR_SLEEP);
+			if (i == QL4_LOCK_DRVR_WAIT) {
 				DEBUG2(printk("scsi%ld: %s: Waiting for "
 					      "Global Init Semaphore...n",
 					      a->host_no,
 					      __func__));
-				i++;
 			}
+			i -= QL4_LOCK_DRVR_SLEEP;
 		} else {
 			DEBUG2(printk("scsi%ld: %s: Global Init Semaphore "
-				      "acquired.n", a->host_no, __func__));
-			break;
+				      "acquired\n", a->host_no, __func__));
+			return QLA_SUCCESS;
 		}
 	}
+	return QLA_ERROR;
 }
 
 /**
@@ -1030,7 +1034,8 @@ static int qla4xxx_start_firmware(struct
 	if (is_qla4022(ha))
 		ql4xxx_set_mac_number(ha);
 
-	ql4xxx_lock_drvr_wait(ha);
+	if (ql4xxx_lock_drvr_wait(ha))
+		return QLA_ERROR;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
@@ -1107,7 +1112,8 @@ static int qla4xxx_start_firmware(struct
 		config_chip = 1;
 
 		/* Reset clears the semaphore, so aquire again */
-		ql4xxx_lock_drvr_wait(ha);
+		if (ql4xxx_lock_drvr_wait(ha))
+			return QLA_ERROR;
 	}
 
 	if (config_chip) {
