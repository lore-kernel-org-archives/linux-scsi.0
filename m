From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: [PATCH] [SCSI] qla4xxx: bug fix: driver hardware semaphore needs
	to be grabbed before soft reset
Date: Wed, 15 Nov 2006 16:41:09 -0800
Message-ID: <1163637669.3867.12.camel@dcslnxpc.site>
References: <1163548841.3938.14.camel@dcslnxpc.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6288 "EHLO
	avexch1.qlogic.com") by vger.kernel.org with ESMTP id S1162114AbWKPAlJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Nov 2006 19:41:09 -0500
In-Reply-To: <1163548841.3938.14.camel@dcslnxpc.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: open-iscsi@googlegroups.com, David Wagner <david.wagner@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>

On qla4xxx, the driver needs to grab the drvr semaphore provided by the hardware, 
prior to issuing a reset. This patches takes care of a couple of places 
where it was not being done. In addition there is minor clean up.

The patch has been generated with reference to scsi-misc-2.6.git

Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>


---
 drivers/scsi/qla4xxx/ql4_glbl.h    |    1 +
 drivers/scsi/qla4xxx/ql4_init.c    |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c      |   42 ++++++++++--------------------------
 drivers/scsi/qla4xxx/ql4_version.h |    7 +-----
 4 files changed, 15 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 2c803ed..79661c1 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -8,6 +8,7 @@
 #ifndef __QLA4x_GBL_H
 #define	__QLA4x_GBL_H
 
+int ql4xxx_lock_drvr_wait(struct scsi_qla_host *a);
 int qla4xxx_send_tgts(struct scsi_qla_host *ha, char *ip, uint16_t port);
 int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb);
 int qla4xxx_initialize_adapter(struct scsi_qla_host * ha,
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index bb3a1c1..9e81b81 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -978,7 +978,7 @@ static int qla4xxx_start_firmware_from_f
 	return status;
 }
 
-static int ql4xxx_lock_drvr_wait(struct scsi_qla_host *a)
+int ql4xxx_lock_drvr_wait(struct scsi_qla_host *a)
 {
 #define QL4_LOCK_DRVR_WAIT	300
 #define QL4_LOCK_DRVR_SLEEP	100
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 178fcdd..61f61d5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -919,18 +919,11 @@ static int qla4xxx_recover_adapter(struc
 	if (status == QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s - Performing soft reset..\n",
 			      ha->host_no, __func__));
-		status = qla4xxx_soft_reset(ha);
-	}
-	/* FIXMEkaren: Do we want to keep interrupts enabled and process
-	   AENs after soft reset */
-
-	/* If firmware (SOFT) reset failed, or if all outstanding
-	 * commands have not returned, then do a HARD reset.
-	 */
-	if (status == QLA_ERROR) {
-		DEBUG2(printk("scsi%ld: %s - Performing hard reset..\n",
-			      ha->host_no, __func__));
-		status = qla4xxx_hard_reset(ha);
+		qla4xxx_flush_active_srbs(ha);
+		if (ql4xxx_lock_drvr_wait(ha) == QLA_SUCCESS)
+			status = qla4xxx_soft_reset(ha);
+		else
+			status = QLA_ERROR;
 	}
 
 	/* Flush any pending ddb changed AENs */
@@ -1016,13 +1009,9 @@ static void qla4xxx_do_dpc(void *data)
 	struct scsi_qla_host *ha = (struct scsi_qla_host *) data;
 	struct ddb_entry *ddb_entry, *dtemp;
 
-	DEBUG2(printk("scsi%ld: %s: DPC handler waking up.\n",
-		      ha->host_no, __func__));
-
-	DEBUG2(printk("scsi%ld: %s: ha->flags = 0x%08lx\n",
-		      ha->host_no, __func__, ha->flags));
-	DEBUG2(printk("scsi%ld: %s: ha->dpc_flags = 0x%08lx\n",
-		      ha->host_no, __func__, ha->dpc_flags));
+	DEBUG2(printk("scsi%ld: %s: DPC handler waking up."
+		"flags = 0x%08lx, dpc_flags = 0x%08lx\n",
+		ha->host_no, __func__, ha->flags, ha->dpc_flags));
 
 	/* Initialization not yet finished. Don't do anything yet. */
 	if (!test_bit(AF_INIT_DONE, &ha->flags))
@@ -1032,16 +1021,8 @@ static void qla4xxx_do_dpc(void *data)
 	    test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
 	    test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
 	    test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags)) {
-		if (test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags))
-			/*
-			 * dg 09/23 Never initialize ddb list
-			 * once we up and running
-			 * qla4xxx_recover_adapter(ha,
-			 *    REBUILD_DDB_LIST);
-			 */
-			qla4xxx_recover_adapter(ha, PRESERVE_DDB_LIST);
-
-		if (test_bit(DPC_RESET_HA, &ha->dpc_flags))
+		if (test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags) ||
+			test_bit(DPC_RESET_HA, &ha->dpc_flags))
 			qla4xxx_recover_adapter(ha, PRESERVE_DDB_LIST);
 
 		if (test_and_clear_bit(DPC_RESET_HA_INTR, &ha->dpc_flags)) {
@@ -1122,7 +1103,8 @@ static void qla4xxx_free_adapter(struct 
 		destroy_workqueue(ha->dpc_thread);
 
 	/* Issue Soft Reset to put firmware in unknown state */
-	qla4xxx_soft_reset(ha);
+	if (ql4xxx_lock_drvr_wait(ha) == QLA_SUCCESS)
+		qla4xxx_soft_reset(ha);
 
 	/* Remove timer thread, if present */
 	if (ha->timer_active)
diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
index b3fe7e6..d05048b 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,9 +5,4 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.00.05b9-k"
-
-#define QL4_DRIVER_MAJOR_VER	5
-#define QL4_DRIVER_MINOR_VER	0
-#define QL4_DRIVER_PATCH_VER	5
-#define QL4_DRIVER_BETA_VER	9
+#define QLA4XXX_DRIVER_VERSION	"5.00.06-k"
-- 
1.4.2.3


