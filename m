From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 01/11] zfcp: receiving an unsolicted status can lead to I/O stall
Date: Mon, 19 May 2008 12:17:37 +0200
Message-ID: <20080519101826.226658000@de.ibm.com>
References: <20080519101736.590943000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:43278 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbYESKS6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 06:18:58 -0400
Content-Disposition: inline; filename=zfcp_status_read_locking_race.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Processing of an unsolicted status request can lead to a locking race
of the request_queue's queue_lock during the recreation of the 
used up status read request while still in interrupt context 
of the response handler.

Detaching the 'refill' of the long running status read requests from
the handler to a scheduled work is solving this issue.

In addition, each refill-run is trying to re-establish the full amount 
of status read requests, which might have failed in earlier runs.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c |   23 +++++++++++++++++++++++
 drivers/s390/scsi/zfcp_dbf.c |    2 +-
 drivers/s390/scsi/zfcp_def.h |    4 ++--
 drivers/s390/scsi/zfcp_erp.c |   19 ++-----------------
 drivers/s390/scsi/zfcp_ext.h |    1 +
 drivers/s390/scsi/zfcp_fsf.c |   18 +++---------------
 6 files changed, 32 insertions(+), 35 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2008-05-19 11:22:35.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-05-19 11:28:32.000000000 +0200
@@ -970,6 +970,27 @@ static void zfcp_dummy_release(struct de
 	return;
 }
 
+int zfcp_status_read_refill(struct zfcp_adapter *adapter)
+{
+	while (atomic_read(&adapter->stat_miss) > 0)
+		if (zfcp_fsf_status_read(adapter, ZFCP_WAIT_FOR_SBAL))
+			break;
+	else
+		atomic_dec(&adapter->stat_miss);
+
+	if (ZFCP_STATUS_READS_RECOM <= atomic_read(&adapter->stat_miss)) {
+		zfcp_erp_adapter_reopen(adapter, 0, 103, NULL);
+		return 1;
+	}
+	return 0;
+}
+
+static void _zfcp_status_read_scheduler(struct work_struct *work)
+{
+	zfcp_status_read_refill(container_of(work, struct zfcp_adapter,
+					     stat_work));
+}
+
 /*
  * Enqueues an adapter at the end of the adapter list in the driver data.
  * All adapter internal structures are set up.
@@ -1063,6 +1084,7 @@ zfcp_adapter_enqueue(struct ccw_device *
 
 	/* initialize lock of associated request queue */
 	rwlock_init(&adapter->request_queue.queue_lock);
+	INIT_WORK(&adapter->stat_work, _zfcp_status_read_scheduler);
 
 	/* mark adapter unusable as long as sysfs registration is not complete */
 	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
@@ -1123,6 +1145,7 @@ zfcp_adapter_dequeue(struct zfcp_adapter
 	int retval = 0;
 	unsigned long flags;
 
+	cancel_work_sync(&adapter->stat_work);
 	zfcp_adapter_scsi_unregister(adapter);
 	device_unregister(&adapter->generic_services);
 	zfcp_sysfs_adapter_remove_files(&adapter->ccw_device->dev);
--- a/drivers/s390/scsi/zfcp_dbf.c	2008-05-19 11:22:35.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-05-19 11:28:32.000000000 +0200
@@ -268,7 +268,7 @@ void zfcp_hba_dbf_event_fsf_unsol(const 
 	strncpy(rec->tag, "stat", ZFCP_DBF_TAG_SIZE);
 	strncpy(rec->tag2, tag, ZFCP_DBF_TAG_SIZE);
 
-	rec->u.status.failed = adapter->status_read_failed;
+	rec->u.status.failed = atomic_read(&adapter->stat_miss);
 	if (status_buffer != NULL) {
 		rec->u.status.status_type = status_buffer->status_type;
 		rec->u.status.status_subtype = status_buffer->status_subtype;
--- a/drivers/s390/scsi/zfcp_def.h	2008-05-19 11:22:35.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-05-19 11:28:32.000000000 +0200
@@ -136,7 +136,6 @@ zfcp_address_to_sg(void *address, struct
 #define ZFCP_QTCB_VERSION	FSF_QTCB_CURRENT_VERSION
 /* ATTENTION: value must not be used by hardware */
 #define FSF_QTCB_UNSOLICITED_STATUS		0x6305
-#define ZFCP_STATUS_READ_FAILED_THRESHOLD	3
 #define ZFCP_STATUS_READS_RECOM		        FSF_STATUS_READS_RECOM
 
 /* Do 1st retry in 1 second, then double the timeout for each following retry */
@@ -759,7 +758,8 @@ struct zfcp_adapter {
 	rwlock_t		abort_lock;        /* Protects against SCSI
 						      stack abort/command
 						      completion races */
-	u16			status_read_failed; /* # failed status reads */
+	atomic_t		stat_miss;	   /* # missing status reads*/
+	struct work_struct	stat_work;
 	atomic_t		status;	           /* status of this adapter */
 	struct list_head	erp_ready_head;	   /* error recovery for this
 						      adapter/devices */
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-05-19 11:22:35.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-05-19 11:28:32.000000000 +0200
@@ -1029,21 +1029,9 @@ zfcp_fsf_status_read_handler(struct zfcp
 	 * FIXME:
 	 * allocation failure possible? (Is this code needed?)
 	 */
-	retval = zfcp_fsf_status_read(adapter, 0);
-	if (retval < 0) {
-		ZFCP_LOG_INFO("Failed to create unsolicited status read "
-			      "request for the adapter %s.\n",
-			      zfcp_get_busid_by_adapter(adapter));
-		/* temporary fix to avoid status read buffer shortage */
-		adapter->status_read_failed++;
-		if ((ZFCP_STATUS_READS_RECOM - adapter->status_read_failed)
-		    < ZFCP_STATUS_READ_FAILED_THRESHOLD) {
-			ZFCP_LOG_INFO("restart adapter %s due to status read "
-				      "buffer shortage\n",
-				      zfcp_get_busid_by_adapter(adapter));
-			zfcp_erp_adapter_reopen(adapter, 0, 103, fsf_req);
-		}
-	}
+
+	atomic_inc(&adapter->stat_miss);
+	schedule_work(&adapter->stat_work);
  out:
 	return retval;
 }
--- a/drivers/s390/scsi/zfcp_erp.c	2008-05-19 11:22:35.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-05-19 11:28:32.000000000 +0200
@@ -2139,25 +2139,10 @@ static int
 zfcp_erp_adapter_strategy_open_fsf_statusread(struct zfcp_erp_action
 					      *erp_action)
 {
-	int retval = ZFCP_ERP_SUCCEEDED;
-	int temp_ret;
 	struct zfcp_adapter *adapter = erp_action->adapter;
-	int i;
 
-	adapter->status_read_failed = 0;
-	for (i = 0; i < ZFCP_STATUS_READS_RECOM; i++) {
-		temp_ret = zfcp_fsf_status_read(adapter, ZFCP_WAIT_FOR_SBAL);
-		if (temp_ret < 0) {
-			ZFCP_LOG_INFO("error: set-up of unsolicited status "
-				      "notification failed on adapter %s\n",
-				      zfcp_get_busid_by_adapter(adapter));
-			retval = ZFCP_ERP_FAILED;
-			i--;
-			break;
-		}
-	}
-
-	return retval;
+	atomic_set(&adapter->stat_miss, 16);
+	return zfcp_status_read_refill(adapter);
 }
 
 /*
--- a/drivers/s390/scsi/zfcp_ext.h	2008-05-19 11:22:35.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-05-19 11:28:32.000000000 +0200
@@ -92,6 +92,7 @@ extern void zfcp_fsf_start_timer(struct 
 extern void zfcp_erp_start_timer(struct zfcp_fsf_req *);
 extern void zfcp_fsf_req_dismiss_all(struct zfcp_adapter *);
 extern int  zfcp_fsf_status_read(struct zfcp_adapter *, int);
+extern int zfcp_status_read_refill(struct zfcp_adapter *adapter);
 extern int zfcp_fsf_req_create(struct zfcp_adapter *, u32, int, mempool_t *,
 			       unsigned long *, struct zfcp_fsf_req **);
 extern int zfcp_fsf_send_ct(struct zfcp_send_ct *, mempool_t *,

-- 
