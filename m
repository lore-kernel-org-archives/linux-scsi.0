From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 10/13] qla4xxx: added new function
 qla4xxx_relogin_all_devices
Date: Sun, 13 Mar 2011 22:25:34 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872263B1510@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.181]:46638
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138Ab1CNFZk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 01:25:40 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

Move relogin to all devices code from do_dpc to new
fuction qla4xxx_relogin_all_devices()

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   54 +++++++++++++++++-----------------------
 1 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 61b599a..9d788e5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1223,6 +1223,27 @@ recover_ha_init_adapter:
        return status;
 }

+static void qla4xxx_relogin_all_devices(struct scsi_qla_host *ha)
+{
+       struct ddb_entry *ddb_entry, *dtemp;
+
+       list_for_each_entry_safe(ddb_entry, dtemp, &ha->ddb_list, list) {
+               if ((atomic_read(&ddb_entry->state) == DDB_STATE_MISSING) ||
+                   (atomic_read(&ddb_entry->state) == DDB_STATE_DEAD)) {
+                       if (ddb_entry->fw_ddb_device_state ==
+                           DDB_DS_SESSION_ACTIVE) {
+                               atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
+                               ql4_printk(KERN_INFO, ha, "scsi%ld: %s: ddb[%d]"
+                                   " marked ONLINE\n", ha->host_no, __func__,
+                                   ddb_entry->fw_ddb_index);
+
+                               iscsi_unblock_session(ddb_entry->sess);
+                       } else
+                               qla4xxx_relogin_device(ha, ddb_entry);
+               }
+       }
+}
+
 void qla4xxx_wake_dpc(struct scsi_qla_host *ha)
 {
        if (ha->dpc_thread &&
@@ -1331,13 +1352,7 @@ dpc_post_reset_ha:
        if (test_and_clear_bit(DPC_LINK_CHANGED, &ha->dpc_flags)) {
                if (!test_bit(AF_LINK_UP, &ha->flags)) {
                        /* ---- link down? --- */
-                       list_for_each_entry_safe(ddb_entry, dtemp,
-                                                &ha->ddb_list, list) {
-                               if (atomic_read(&ddb_entry->state) ==
-                                               DDB_STATE_ONLINE)
-                                       qla4xxx_mark_device_missing(ha,
-                                                       ddb_entry);
-                       }
+                       qla4xxx_mark_all_devices_missing(ha);
                } else {
                        /* ---- link up? --- *
                         * F/W will auto login to all devices ONLY ONCE after
@@ -1346,30 +1361,7 @@ dpc_post_reset_ha:
                         * manually relogin to devices when recovering from
                         * connection failures, logouts, expired KATO, etc. */

-                       list_for_each_entry_safe(ddb_entry, dtemp,
-                                                       &ha->ddb_list, list) {
-                               if ((atomic_read(&ddb_entry->state) ==
-                                                DDB_STATE_MISSING) ||
-                                   (atomic_read(&ddb_entry->state) ==
-                                                DDB_STATE_DEAD)) {
-                                       if (ddb_entry->fw_ddb_device_state ==
-                                           DDB_DS_SESSION_ACTIVE) {
-                                               atomic_set(&ddb_entry->state,
-                                                          DDB_STATE_ONLINE);
-                                               ql4_printk(KERN_INFO, ha,
-                                                   "scsi%ld: %s: ddb[%d]"
-                                                   " marked ONLINE\n",
-                                                   ha->host_no, __func__,
-                                                   ddb_entry->fw_ddb_index);
-
-                                               iscsi_unblock_session(
-                                                   ddb_entry->sess);
-                                       } else
-                                               qla4xxx_relogin_device(
-                                                   ha, ddb_entry);
-                               }
-
-                       }
+                       qla4xxx_relogin_all_devices(ha);
                }
        }

--
1.7.3.2


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

