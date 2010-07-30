From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 1/8] qla4xxx: set correct value in sess->recovery_tmo
Date: Fri, 30 Jul 2010 14:25:46 +0530
Message-ID: <20100730085545.GA12272@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:6167
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754775Ab0G3I7J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jul 2010 04:59:09 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vikas.chaudhary@qlogic.com, ravi.anand@qlogic.com, michaelc@cs.wisc.edu

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |    5 +++--
 drivers/scsi/qla4xxx/ql4_init.c |    3 ---
 drivers/scsi/qla4xxx/ql4_mbx.c  |    1 -
 drivers/scsi/qla4xxx/ql4_os.c   |    7 ++++---
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index a79da8d..6af5d04 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -137,6 +137,9 @@
 #define ISCSI_ALIAS_SIZE		32	/* ISCSI Alias name size */
 #define ISCSI_NAME_SIZE			0xE0	/* ISCSI Name size */
 
+#define QL4_SESS_RECOVERY_TMO		30	/* iSCSI session */
+						/* recovery timeout */
+
 #define LSDW(x) ((u32)((u64)(x)))
 #define MSDW(x) ((u32)((((u64)(x)) >> 16) >> 16))
 
@@ -249,7 +252,6 @@ struct ddb_entry {
 	uint32_t default_time2wait; /* Default Min time between
 				     * relogins (+aens) */
 
-	atomic_t port_down_timer; /* Device connection timer */
 	atomic_t retry_relogin_timer; /* Min Time between relogins
 				       * (4000 only) */
 	atomic_t relogin_timer;	/* Max Time to wait for relogin to complete */
@@ -474,7 +476,6 @@ struct scsi_qla_host {
 	uint32_t timer_active;
 
 	/* Recovery Timers */
-	uint32_t port_down_retry_count;
 	uint32_t discovery_wait;
 	atomic_t check_relogin_timeouts;
 	uint32_t retry_reset_ha_cnt;
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 266ebd4..de9f790 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -669,7 +669,6 @@ static struct ddb_entry * qla4xxx_alloc_ddb(struct scsi_qla_host *ha,
 	}
 
 	ddb_entry->fw_ddb_index = fw_ddb_index;
-	atomic_set(&ddb_entry->port_down_timer, ha->port_down_retry_count);
 	atomic_set(&ddb_entry->retry_relogin_timer, INVALID_ENTRY);
 	atomic_set(&ddb_entry->relogin_timer, 0);
 	atomic_set(&ddb_entry->relogin_retry_count, 0);
@@ -1556,8 +1555,6 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 	/* Device is back online. */
 	if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_ACTIVE) {
 		atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
-		atomic_set(&ddb_entry->port_down_timer,
-			   ha->port_down_retry_count);
 		atomic_set(&ddb_entry->relogin_retry_count, 0);
 		atomic_set(&ddb_entry->relogin_timer, 0);
 		clear_bit(DF_RELOGIN, &ddb_entry->flags);
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 940ee56..c4e036b 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -361,7 +361,6 @@ qla4xxx_update_local_ifcb(struct scsi_qla_host *ha,
 	       min(sizeof(ha->alias), sizeof(init_fw_cb->Alias)));*/
 
 	/* Save Command Line Paramater info */
-	ha->port_down_retry_count = le16_to_cpu(init_fw_cb->conn_ka_timeout);
 	ha->discovery_wait = ql4xdiscoverywait;
 
 	if (ha->acb_version == ACB_SUPPORTED) {
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 5529b2a..fd1af23 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -163,10 +163,10 @@ static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session)
 	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
 		atomic_set(&ddb_entry->state, DDB_STATE_DEAD);
 
-		DEBUG2(printk("scsi%ld: %s: ddb [%d] port down retry count "
+		DEBUG2(printk("scsi%ld: %s: ddb [%d] session recovery timeout "
 			      "of (%d) secs exhausted, marking device DEAD.\n",
 			      ha->host_no, __func__, ddb_entry->fw_ddb_index,
-			      ha->port_down_retry_count));
+			      QL4_SESS_RECOVERY_TMO));
 
 		qla4xxx_wake_dpc(ha);
 	}
@@ -298,7 +298,8 @@ int qla4xxx_add_sess(struct ddb_entry *ddb_entry)
 {
 	int err;
 
-	ddb_entry->sess->recovery_tmo = ddb_entry->ha->port_down_retry_count;
+	ddb_entry->sess->recovery_tmo = QL4_SESS_RECOVERY_TMO;
+
 	err = iscsi_add_session(ddb_entry->sess, ddb_entry->fw_ddb_index);
 	if (err) {
 		DEBUG2(printk(KERN_ERR "Could not add session.\n"));
-- 
1.6.6

