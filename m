From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 07/13] qla4xxx: cleanup function qla4xxx_process_ddb_changed
Date: Sun, 13 Mar 2011 22:24:30 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872263B150D@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:46377
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752192Ab1CNFYk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 01:24:40 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

We don't need to check ddb old state, we can take action
based on ddb new state.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 8b5453a..bbb2e90 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1409,7 +1409,6 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
                uint32_t state, uint32_t conn_err)
 {
        struct ddb_entry * ddb_entry;
-       uint32_t old_fw_ddb_device_state;

        /* check for out of range index */
        if (fw_ddb_index >= MAX_DDB_ENTRIES)
@@ -1425,22 +1424,14 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
        }

        /* Device already exists in our database. */
-       old_fw_ddb_device_state = ddb_entry->fw_ddb_device_state;
        DEBUG2(printk("scsi%ld: %s DDB - old state= 0x%x, new state=0x%x for "
                      "index [%d]\n", ha->host_no, __func__,
                      ddb_entry->fw_ddb_device_state, state, fw_ddb_index));
-       if (old_fw_ddb_device_state == state &&
-           state == DDB_DS_SESSION_ACTIVE) {
-               if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
-                       atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
-                       iscsi_unblock_session(ddb_entry->sess);
-               }
-               return QLA_SUCCESS;
-       }

        ddb_entry->fw_ddb_device_state = state;
        /* Device is back online. */
-       if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_ACTIVE) {
+       if ((ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_ACTIVE) &&
+          (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE)) {
                atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
                atomic_set(&ddb_entry->relogin_retry_count, 0);
                atomic_set(&ddb_entry->relogin_timer, 0);
@@ -1452,7 +1443,7 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
                 * Change the lun state to READY in case the lun TIMEOUT before
                 * the device came back.
                 */
-       } else {
+       } else if (ddb_entry->fw_ddb_device_state != DDB_DS_SESSION_ACTIVE) {
                /* Device went away, mark device missing */
                if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE) {
                        DEBUG2(ql4_printk(KERN_INFO, ha, "%s mark missing "
--
1.7.3.2


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

