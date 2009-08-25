From: giridhar.malavali@qlogic.com
Subject: [PATCH 1/7] qla2xxx: Add firmware-dump kobject uevent notification.
Date: Tue, 25 Aug 2009 11:36:15 -0700
Message-ID: <1251225381-768-2-git-send-email-giridhar.malavali@qlogic.com>
References: <1251225381-768-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47027 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755831AbZHYSgV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 14:36:21 -0400
In-Reply-To: <1251225381-768-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |   78 ++++++++++++----------------------------
 drivers/scsi/qla2xxx/qla_def.h |    5 +++
 drivers/scsi/qla2xxx/qla_gbl.h |    1 +
 drivers/scsi/qla2xxx/qla_os.c  |   36 ++++++++++++++++++
 4 files changed, 65 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index cca8e4a..cb2eca4 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -377,6 +377,24 @@ qla25xx_copy_mq(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 	return ptr + sizeof(struct qla2xxx_mq_chain);
 }
 
+static void
+qla2xxx_dump_post_process(scsi_qla_host_t *vha, int rval)
+{
+	struct qla_hw_data *ha = vha->hw;
+
+	if (rval != QLA_SUCCESS) {
+		qla_printk(KERN_WARNING, ha,
+		    "Failed to dump firmware (%x)!!!\n", rval);
+		ha->fw_dumped = 0;
+	} else {
+		qla_printk(KERN_INFO, ha,
+		    "Firmware dump saved to temp buffer (%ld/%p).\n",
+		    vha->host_no, ha->fw_dump);
+		ha->fw_dumped = 1;
+		qla2x00_post_uevent_work(vha, QLA_UEVENT_CODE_FW_DUMP);
+	}
+}
+
 /**
  * qla2300_fw_dump() - Dumps binary data from the 2300 firmware.
  * @ha: HA context
@@ -530,17 +548,7 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	if (rval == QLA_SUCCESS)
 		qla2xxx_copy_queues(ha, nxt);
 
-	if (rval != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
-		    "Failed to dump firmware (%x)!!!\n", rval);
-		ha->fw_dumped = 0;
-
-	} else {
-		qla_printk(KERN_INFO, ha,
-		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    base_vha->host_no, ha->fw_dump);
-		ha->fw_dumped = 1;
-	}
+	qla2xxx_dump_post_process(base_vha, rval);
 
 qla2300_fw_dump_failed:
 	if (!hardware_locked)
@@ -737,17 +745,7 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	if (rval == QLA_SUCCESS)
 		qla2xxx_copy_queues(ha, &fw->risc_ram[cnt]);
 
-	if (rval != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
-		    "Failed to dump firmware (%x)!!!\n", rval);
-		ha->fw_dumped = 0;
-
-	} else {
-		qla_printk(KERN_INFO, ha,
-		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    base_vha->host_no, ha->fw_dump);
-		ha->fw_dumped = 1;
-	}
+	qla2xxx_dump_post_process(base_vha, rval);
 
 qla2100_fw_dump_failed:
 	if (!hardware_locked)
@@ -984,17 +982,7 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	qla24xx_copy_eft(ha, nxt);
 
 qla24xx_fw_dump_failed_0:
-	if (rval != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
-		    "Failed to dump firmware (%x)!!!\n", rval);
-		ha->fw_dumped = 0;
-
-	} else {
-		qla_printk(KERN_INFO, ha,
-		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    base_vha->host_no, ha->fw_dump);
-		ha->fw_dumped = 1;
-	}
+	qla2xxx_dump_post_process(base_vha, rval);
 
 qla24xx_fw_dump_failed:
 	if (!hardware_locked)
@@ -1305,17 +1293,7 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	}
 
 qla25xx_fw_dump_failed_0:
-	if (rval != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
-		    "Failed to dump firmware (%x)!!!\n", rval);
-		ha->fw_dumped = 0;
-
-	} else {
-		qla_printk(KERN_INFO, ha,
-		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    base_vha->host_no, ha->fw_dump);
-		ha->fw_dumped = 1;
-	}
+	qla2xxx_dump_post_process(base_vha, rval);
 
 qla25xx_fw_dump_failed:
 	if (!hardware_locked)
@@ -1628,17 +1606,7 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	}
 
 qla81xx_fw_dump_failed_0:
-	if (rval != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
-		    "Failed to dump firmware (%x)!!!\n", rval);
-		ha->fw_dumped = 0;
-
-	} else {
-		qla_printk(KERN_INFO, ha,
-		    "Firmware dump saved to temp buffer (%ld/%p).\n",
-		    base_vha->host_no, ha->fw_dump);
-		ha->fw_dumped = 1;
-	}
+	qla2xxx_dump_post_process(base_vha, rval);
 
 qla81xx_fw_dump_failed:
 	if (!hardware_locked)
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index bdc7283..f19a936 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2146,6 +2146,7 @@ enum qla_work_type {
 	QLA_EVT_ASYNC_LOGIN_DONE,
 	QLA_EVT_ASYNC_LOGOUT,
 	QLA_EVT_ASYNC_LOGOUT_DONE,
+	QLA_EVT_UEVENT,
 };
 
 
@@ -2169,6 +2170,10 @@ struct qla_work_evt {
 #define QLA_LOGIO_LOGIN_RETRIED	BIT_0
 			u16 data[2];
 		} logio;
+		struct {
+			u32 code;
+#define QLA_UEVENT_CODE_FW_DUMP	0
+		} uevent;
 	} u;
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 00cf2ec..4619e35 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -94,6 +94,7 @@ extern int qla2x00_post_async_logout_work(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 extern int qla2x00_post_async_logout_done_work(struct scsi_qla_host *,
     fc_port_t *, uint16_t *);
+extern int qla2x00_post_uevent_work(struct scsi_qla_host *, u32);
 
 extern int qla81xx_restart_mpi_firmware(scsi_qla_host_t *);
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3331137..7d56692 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -11,6 +11,7 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/mutex.h>
+#include <linux/kobject.h>
 
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
@@ -2650,6 +2651,38 @@ qla2x00_post_async_work(login_done, QLA_EVT_ASYNC_LOGIN_DONE);
 qla2x00_post_async_work(logout, QLA_EVT_ASYNC_LOGOUT);
 qla2x00_post_async_work(logout_done, QLA_EVT_ASYNC_LOGOUT_DONE);
 
+int
+qla2x00_post_uevent_work(struct scsi_qla_host *vha, u32 code)
+{
+	struct qla_work_evt *e;
+
+	e = qla2x00_alloc_work(vha, QLA_EVT_UEVENT);
+	if (!e)
+		return QLA_FUNCTION_FAILED;
+
+	e->u.uevent.code = code;
+	return qla2x00_post_work(vha, e);
+}
+
+static void
+qla2x00_uevent_emit(struct scsi_qla_host *vha, u32 code)
+{
+	char event_string[40];
+	char *envp[] = { event_string, NULL };
+
+	switch (code) {
+	case QLA_UEVENT_CODE_FW_DUMP:
+		snprintf(event_string, sizeof(event_string), "FW_DUMP=%ld",
+		    vha->host_no);
+		break;
+	default:
+		/* do nothing */
+		break;
+	}
+	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
+	    KOBJ_CHANGE, envp);
+}
+
 void
 qla2x00_do_work(struct scsi_qla_host *vha)
 {
@@ -2687,6 +2720,9 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 			qla2x00_async_logout_done(vha, e->u.logio.fcport,
 			    e->u.logio.data);
 			break;
+		case QLA_EVT_UEVENT:
+			qla2x00_uevent_emit(vha, e->u.uevent.code);
+			break;
 		}
 		if (e->flags & QLA_EVT_FLAG_FREE)
 			kfree(e);
-- 
1.6.2.rc1.30.gd43c

