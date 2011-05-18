From: vikas.chaudhary@qlogic.com
Subject: [PATCH 07/10] qla4xxx: Remove AF_DPC_SCHEDULED flag from ha.
Date: Tue, 17 May 2011 23:17:09 -0700
Message-ID: <1305699432-13225-8-git-send-email-vikas.chaudhary@qlogic.com>
References: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:50934 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754522Ab1ERGXq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 02:23:46 -0400
In-Reply-To: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Since queue_work does not requeue, there is no need to check
if a work is in progress using the AF_DPC_SCHEDULED flag.
queue_work would return if work is pending without adding the
work, do_dpc would again get invoked from qla4xxx_timer if
there is still DPC flags set.

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |    1 -
 drivers/scsi/qla4xxx/ql4_os.c  |   17 +++++------------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 75edfba..8e3a28e 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -368,7 +368,6 @@ struct scsi_qla_host {
 #define AF_INIT_DONE			1 /* 0x00000002 */
 #define AF_MBOX_COMMAND			2 /* 0x00000004 */
 #define AF_MBOX_COMMAND_DONE		3 /* 0x00000008 */
-#define AF_DPC_SCHEDULED		5 /* 0x00000020 */
 #define AF_INTERRUPTS_ON		6 /* 0x00000040 */
 #define AF_GET_CRASH_RECORD		7 /* 0x00000080 */
 #define AF_LINK_UP			8 /* 0x00000100 */
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 302938e..9c1c845 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -859,7 +859,7 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 	}
 
 	/* Wakeup the dpc routine for this adapter, if needed. */
-	if ((start_dpc ||
+	if (start_dpc ||
 	     test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
 	     test_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags) ||
 	     test_bit(DPC_RELOGIN_DEVICE, &ha->dpc_flags) ||
@@ -869,9 +869,7 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 	     test_bit(DPC_LINK_CHANGED, &ha->dpc_flags) ||
 	     test_bit(DPC_HA_UNRECOVERABLE, &ha->dpc_flags) ||
 	     test_bit(DPC_HA_NEED_QUIESCENT, &ha->dpc_flags) ||
-	     test_bit(DPC_AEN, &ha->dpc_flags)) &&
-	     !test_bit(AF_DPC_SCHEDULED, &ha->flags) &&
-	     ha->dpc_thread) {
+	     test_bit(DPC_AEN, &ha->dpc_flags)) {
 		DEBUG2(printk("scsi%ld: %s: scheduling dpc routine"
 			      " - dpc flags = 0x%lx\n",
 			      ha->host_no, __func__, ha->dpc_flags));
@@ -1261,11 +1259,8 @@ static void qla4xxx_relogin_all_devices(struct scsi_qla_host *ha)
 
 void qla4xxx_wake_dpc(struct scsi_qla_host *ha)
 {
-	if (ha->dpc_thread &&
-	    !test_bit(AF_DPC_SCHEDULED, &ha->flags)) {
-		set_bit(AF_DPC_SCHEDULED, &ha->flags);
+	if (ha->dpc_thread)
 		queue_work(ha->dpc_thread, &ha->dpc_work);
-	}
 }
 
 /**
@@ -1292,12 +1287,12 @@ static void qla4xxx_do_dpc(struct work_struct *work)
 
 	/* Initialization not yet finished. Don't do anything yet. */
 	if (!test_bit(AF_INIT_DONE, &ha->flags))
-		goto do_dpc_exit;
+		return;
 
 	if (test_bit(AF_EEH_BUSY, &ha->flags)) {
 		DEBUG2(printk(KERN_INFO "scsi%ld: %s: flags = %lx\n",
 		    ha->host_no, __func__, ha->flags));
-		goto do_dpc_exit;
+		return;
 	}
 
 	if (is_qla8022(ha)) {
@@ -1404,8 +1399,6 @@ dpc_post_reset_ha:
 		}
 	}
 
-do_dpc_exit:
-	clear_bit(AF_DPC_SCHEDULED, &ha->flags);
 }
 
 /**
-- 
1.7.3.2

