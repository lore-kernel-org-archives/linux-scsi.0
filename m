From: vikas.chaudhary@qlogic.com
Subject: [PATCH 10/13] qla4xxx: added new function qla4xxx_relogin_all_devices
Date: Mon, 21 Mar 2011 03:34:33 -0700
Message-ID: <1300703676-27398-10-git-send-email-vikas.chaudhary@qlogic.com>
References: <1300703676-27398-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46146 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753009Ab1CUKqF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 06:46:05 -0400
In-Reply-To: <1300703676-27398-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com, vikas.chaudhary@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Move relogin to all devices code from do_dpc to new
fuction qla4xxx_relogin_all_devices()

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   54 +++++++++++++++++-----------------------
 1 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 4a599d3..e70b6bf 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1218,6 +1218,27 @@ recover_ha_init_adapter:
 	return status;
 }
 
+static void qla4xxx_relogin_all_devices(struct scsi_qla_host *ha)
+{
+	struct ddb_entry *ddb_entry, *dtemp;
+
+	list_for_each_entry_safe(ddb_entry, dtemp, &ha->ddb_list, list) {
+		if ((atomic_read(&ddb_entry->state) == DDB_STATE_MISSING) ||
+		    (atomic_read(&ddb_entry->state) == DDB_STATE_DEAD)) {
+			if (ddb_entry->fw_ddb_device_state ==
+			    DDB_DS_SESSION_ACTIVE) {
+				atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
+				ql4_printk(KERN_INFO, ha, "scsi%ld: %s: ddb[%d]"
+				    " marked ONLINE\n",	ha->host_no, __func__,
+				    ddb_entry->fw_ddb_index);
+
+				iscsi_unblock_session(ddb_entry->sess);
+			} else
+				qla4xxx_relogin_device(ha, ddb_entry);
+		}
+	}
+}
+
 void qla4xxx_wake_dpc(struct scsi_qla_host *ha)
 {
 	if (ha->dpc_thread &&
@@ -1326,13 +1347,7 @@ dpc_post_reset_ha:
 	if (test_and_clear_bit(DPC_LINK_CHANGED, &ha->dpc_flags)) {
 		if (!test_bit(AF_LINK_UP, &ha->flags)) {
 			/* ---- link down? --- */
-			list_for_each_entry_safe(ddb_entry, dtemp,
-						 &ha->ddb_list, list) {
-				if (atomic_read(&ddb_entry->state) ==
-						DDB_STATE_ONLINE)
-					qla4xxx_mark_device_missing(ha,
-							ddb_entry);
-			}
+			qla4xxx_mark_all_devices_missing(ha);
 		} else {
 			/* ---- link up? --- *
 			 * F/W will auto login to all devices ONLY ONCE after
@@ -1341,30 +1356,7 @@ dpc_post_reset_ha:
 			 * manually relogin to devices when recovering from
 			 * connection failures, logouts, expired KATO, etc. */
 
-			list_for_each_entry_safe(ddb_entry, dtemp,
-							&ha->ddb_list, list) {
-				if ((atomic_read(&ddb_entry->state) ==
-						 DDB_STATE_MISSING) ||
-				    (atomic_read(&ddb_entry->state) ==
-						 DDB_STATE_DEAD)) {
-					if (ddb_entry->fw_ddb_device_state ==
-					    DDB_DS_SESSION_ACTIVE) {
-						atomic_set(&ddb_entry->state,
-							   DDB_STATE_ONLINE);
-						ql4_printk(KERN_INFO, ha,
-						    "scsi%ld: %s: ddb[%d]"
-						    " marked ONLINE\n",
-						    ha->host_no, __func__,
-						    ddb_entry->fw_ddb_index);
-
-						iscsi_unblock_session(
-						    ddb_entry->sess);
-					} else
-						qla4xxx_relogin_device(
-						    ha, ddb_entry);
-				}
-
-			}
+			qla4xxx_relogin_all_devices(ha);
 		}
 	}
 
-- 
1.7.3.2

