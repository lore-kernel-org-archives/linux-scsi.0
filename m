From: michaelc@cs.wisc.edu
Subject: [PATCH 05/12] qla4xxx: fix recovery timer and session unblock race
Date: Thu, 31 Jan 2008 13:36:47 -0600
Message-ID: <12018082161847-git-send-email-michaelc@cs.wisc.edu>
References: <12018082143359-git-send-email-michaelc@cs.wisc.edu>
 <12018082142447-git-send-email-michaelc@cs.wisc.edu>
 <1201808215968-git-send-email-michaelc@cs.wisc.edu>
 <1201808215955-git-send-email-michaelc@cs.wisc.edu>
 <12018082162624-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759386AbYAaTg7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 14:36:59 -0500
In-Reply-To: <12018082162624-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If qla4xxx is resetting up a session and the recovery timer
fires we do not want to just set it to dead, because
the dpc thread could have just set it to online and is in the
middle of resetting it up.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_os.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 437d169..d4dd149 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -124,16 +124,19 @@ static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session)
 	struct ddb_entry *ddb_entry = session->dd_data;
 	struct scsi_qla_host *ha = ddb_entry->ha;
 
-	DEBUG2(printk("scsi%ld: %s: index [%d] port down retry count of (%d) "
-		      "secs exhausted, marking device DEAD.\n", ha->host_no,
-		      __func__, ddb_entry->fw_ddb_index,
-		      ha->port_down_retry_count));
+	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
+		atomic_set(&ddb_entry->state, DDB_STATE_DEAD);
 
-	atomic_set(&ddb_entry->state, DDB_STATE_DEAD);
+		DEBUG2(printk("scsi%ld: %s: index [%d] port down retry count "
+			      "of (%d) secs exhausted, marking device DEAD.\n",
+			      ha->host_no, __func__, ddb_entry->fw_ddb_index,
+			      ha->port_down_retry_count));
 
-	DEBUG2(printk("scsi%ld: %s: scheduling dpc routine - dpc flags = "
-		      "0x%lx\n", ha->host_no, __func__, ha->dpc_flags));
-	queue_work(ha->dpc_thread, &ha->dpc_work);
+		DEBUG2(printk("scsi%ld: %s: scheduling dpc routine - dpc "
+			      "flags = 0x%lx\n",
+			      ha->host_no, __func__, ha->dpc_flags));
+		queue_work(ha->dpc_thread, &ha->dpc_work);
+	}
 }
 
 static int qla4xxx_host_get_param(struct Scsi_Host *shost,
-- 
1.5.2.1

