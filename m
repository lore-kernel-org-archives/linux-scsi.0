From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: FW: [RFC PATCH 1/2] qla4xxx: set correct value in sess->recovery_tmo
Date: Wed, 7 Jul 2010 06:15:56 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87128B124C5@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:59353 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab0GGNQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2010 09:16:00 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "james.bottomley@suse.de" <james.bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>


Look like following patch never made to reflector so resending.

-----Original Message-----
From: Vikas Chaudhary [mailto:vikas.chaudhary@qlogic.com] 
Sent: Tuesday, July 06, 2010 10:48 AM
To: michaelc@cs.wisc.edu
Cc: james.bottomley@suse.de; linux-scsi@vger.kernel.org; Ravi Anand; Vikas Chaudhary
Subject: [RFC PATCH 1/2] qla4xxx: set correct value in sess->recovery_tmo

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |    2 --
 drivers/scsi/qla4xxx/ql4_init.c |    3 ---
 drivers/scsi/qla4xxx/ql4_mbx.c  |    1 -
 drivers/scsi/qla4xxx/ql4_os.c   |   10 ++++++----
 4 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 2bcba45..b5353f9 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -249,7 +249,6 @@ struct ddb_entry {
 	uint32_t default_time2wait; /* Default Min time between
 				     * relogins (+aens) */
 
-	atomic_t port_down_timer; /* Device connection timer */
 	atomic_t retry_relogin_timer; /* Min Time between relogins
 				       * (4000 only) */
 	atomic_t relogin_timer;	/* Max Time to wait for relogin to complete */
@@ -474,7 +473,6 @@ struct scsi_qla_host {
 	uint32_t timer_active;
 
 	/* Recovery Timers */
-	uint32_t port_down_retry_count;
 	uint32_t discovery_wait;
 	atomic_t check_relogin_timeouts;
 	uint32_t retry_reset_ha_cnt;
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 56f6d75..2bcd1a4 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -668,7 +668,6 @@ static struct ddb_entry * qla4xxx_alloc_ddb(struct scsi_qla_host *ha,
 	}
 
 	ddb_entry->fw_ddb_index = fw_ddb_index;
-	atomic_set(&ddb_entry->port_down_timer, ha->port_down_retry_count);
 	atomic_set(&ddb_entry->retry_relogin_timer, INVALID_ENTRY);
 	atomic_set(&ddb_entry->relogin_timer, 0);
 	atomic_set(&ddb_entry->relogin_retry_count, 0);
@@ -1555,8 +1554,6 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 	/* Device is back online. */
 	if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_ACTIVE) {
 		atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
-		atomic_set(&ddb_entry->port_down_timer,
-			   ha->port_down_retry_count);
 		atomic_set(&ddb_entry->relogin_retry_count, 0);
 		atomic_set(&ddb_entry->relogin_timer, 0);
 		clear_bit(DF_RELOGIN, &ddb_entry->flags);
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 88db1d4..583b9b3 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -360,7 +360,6 @@ qla4xxx_update_local_ifcb(struct scsi_qla_host *ha,
 	       min(sizeof(ha->alias), sizeof(init_fw_cb->Alias)));*/
 
 	/* Save Command Line Paramater info */
-	ha->port_down_retry_count = le16_to_cpu(init_fw_cb->conn_ka_timeout);
 	ha->discovery_wait = ql4xdiscoverywait;
 
 	if (ha->acb_version == ACB_SUPPORTED) {
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 686103d..b8895fc 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -54,7 +54,8 @@ MODULE_PARM_DESC(ql4xenablemsix,
 		" 1 = enable MSI-X interrupt mechanism (Default).\n"
 		" 2 = enable MSI interrupt mechanism.");
 
-#define QL4_DEF_QDEPTH 32
+#define QL4_DEF_QDEPTH		32
+#define QL4_RECOVERY_TMO	30
 
 /*
  * SCSI host template entry points
@@ -163,10 +164,10 @@ static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session)
 	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
 		atomic_set(&ddb_entry->state, DDB_STATE_DEAD);
 
-		DEBUG2(printk("scsi%ld: %s: ddb [%d] port down retry count "
+		DEBUG2(printk("scsi%ld: %s: ddb [%d] session recovery timeout "
 			      "of (%d) secs exhausted, marking device DEAD.\n",
 			      ha->host_no, __func__, ddb_entry->fw_ddb_index,
-			      ha->port_down_retry_count));
+			      QL4_RECOVERY_TMO));
 
 		qla4xxx_wake_dpc(ha);
 	}
@@ -298,7 +299,8 @@ int qla4xxx_add_sess(struct ddb_entry *ddb_entry)
 {
 	int err;
 
-	ddb_entry->sess->recovery_tmo = ddb_entry->ha->port_down_retry_count;
+	ddb_entry->sess->recovery_tmo = QL4_RECOVERY_TMO;
+
 	err = iscsi_add_session(ddb_entry->sess, ddb_entry->fw_ddb_index);
 	if (err) {
 		DEBUG2(printk(KERN_ERR "Could not add session.\n"));
-- 
1.7.0.5

