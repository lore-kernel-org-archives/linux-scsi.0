From: Ravi Anand <ravi.anand@qlogic.com>
Subject: [PATCH 07/11] qla4xxx: Avoid relogin on device marked missing
Date: Fri, 29 Jan 2010 22:29:00 -0800
Message-ID: <20100130062900.GH10274@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:9025 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab0A3G1K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Jan 2010 01:27:10 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Nilesh Javali <nilesh.javali@qlogic.com>


From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   27 ++++++++++++++++++++++++---
 1 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 9057860..e5c9b85 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -370,6 +370,7 @@ void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
 		      ddb_entry->fw_ddb_index));
 	iscsi_block_session(ddb_entry->sess);
 	iscsi_conn_error_event(ddb_entry->conn, ISCSI_ERR_CONN_FAILED);
+	set_bit(DF_NO_RELOGIN, &ddb_entry->flags);
 }
 
 /***
@@ -642,6 +643,24 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 
 	/* Search for relogin's to time-out and port down retry. */
 	list_for_each_entry_safe(ddb_entry, dtemp, &ha->ddb_list, list) {
+		/* First check to see if the device has exhausted the
+		 * port down retry count */
+		if (atomic_read(&ddb_entry->state) == DDB_STATE_MISSING) {
+			if (atomic_read(&ddb_entry->port_down_timer) == 0)
+				continue;
+
+			if (atomic_dec_and_test(&ddb_entry->port_down_timer)) {
+				DEBUG2(printk("scsi%ld: %s: index [%d] "
+					"port down retry count of (%d) secs "
+					"exhausted.\n",
+					ha->host_no, __func__,
+					ddb_entry->fw_ddb_index,
+					ha->port_down_retry_count);)
+
+				atomic_set(&ddb_entry->state, DDB_STATE_DEAD);
+				start_dpc++;
+			}
+		}
 		/* Count down time between sending relogins */
 		if (adapter_up(ha) &&
 		    !test_bit(DF_RELOGIN, &ddb_entry->flags) &&
@@ -676,7 +695,8 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 			if (atomic_read(&ddb_entry->state) !=
 			    DDB_STATE_ONLINE &&
 			    ddb_entry->fw_ddb_device_state ==
-			    DDB_DS_SESSION_FAILED) {
+			    DDB_DS_SESSION_FAILED &&
+			    !test_bit(DF_NO_RELOGIN, &ddb_entry->flags)) {
 				/* Reset retry relogin timer */
 				atomic_inc(&ddb_entry->relogin_retry_count);
 				DEBUG2(printk("scsi%ld: index[%d] relogin"
@@ -1111,8 +1131,9 @@ static void qla4xxx_do_dpc(struct work_struct *work)
 	    test_and_clear_bit(DPC_RELOGIN_DEVICE, &ha->dpc_flags)) {
 		list_for_each_entry_safe(ddb_entry, dtemp,
 					 &ha->ddb_list, list) {
-			if (test_and_clear_bit(DF_RELOGIN, &ddb_entry->flags) &&
-			    atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE)
+			if ((test_and_clear_bit(DF_RELOGIN, &ddb_entry->flags)) &&
+			    (!test_bit(DF_NO_RELOGIN, &ddb_entry->flags)) &&
+			    (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE))
 				qla4xxx_relogin_device(ha, ddb_entry);
 
 			/*
-- 
1.6.0.2

