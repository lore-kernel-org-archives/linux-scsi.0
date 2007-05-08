From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH 3/5] zfcp: rework request ID management.
Date: Tue, 8 May 2007 11:17:54 +0200
Message-ID: <200705081117.54437.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:27406 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934565AbXEHJPa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 05:15:30 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Simplify request ID management and make sure that frequently used
functions are inlined. Also fix a memory leak in zfcp_adapter_enqueue()
which only gets hit in error handling.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c  |   82 ++++--------------------------------------
 drivers/s390/scsi/zfcp_def.h  |   36 ++++++++++++++++++
 drivers/s390/scsi/zfcp_erp.c  |    3 -
 drivers/s390/scsi/zfcp_ext.h  |    4 --
 drivers/s390/scsi/zfcp_fsf.c  |    2 -
 drivers/s390/scsi/zfcp_qdio.c |   17 +++++---
 drivers/s390/scsi/zfcp_scsi.c |    4 +-
 7 files changed, 59 insertions(+), 89 deletions(-)

--- linux-2.6.orig/drivers/s390/scsi/zfcp_aux.c	2007-05-07 15:50:19.000000000 +0200
+++ linux-2.6/drivers/s390/scsi/zfcp_aux.c	2007-05-07 16:26:34.000000000 +0200
@@ -118,97 +118,32 @@

 #define ZFCP_LOG_AREA			ZFCP_LOG_AREA_FSF

-static int zfcp_reqlist_init(struct zfcp_adapter *adapter)
+static int zfcp_reqlist_alloc(struct zfcp_adapter *adapter)
 {
-	int i;
+	int idx;

 	adapter->req_list = kcalloc(REQUEST_LIST_SIZE, sizeof(struct list_head),
 				    GFP_KERNEL);
-
 	if (!adapter->req_list)
 		return -ENOMEM;

-	for (i=0; i<REQUEST_LIST_SIZE; i++)
-		INIT_LIST_HEAD(&adapter->req_list[i]);
-
+	for (idx = 0; idx < REQUEST_LIST_SIZE; idx++)
+		INIT_LIST_HEAD(&adapter->req_list[idx]);
 	return 0;
 }

 static void zfcp_reqlist_free(struct zfcp_adapter *adapter)
 {
-	struct zfcp_fsf_req *request, *tmp;
-	unsigned int i;
-
-	for (i=0; i<REQUEST_LIST_SIZE; i++) {
-		if (list_empty(&adapter->req_list[i]))
-			continue;
-
-		list_for_each_entry_safe(request, tmp,
-					 &adapter->req_list[i], list)
-			list_del(&request->list);
-	}
-
 	kfree(adapter->req_list);
 }

-void zfcp_reqlist_add(struct zfcp_adapter *adapter,
-		      struct zfcp_fsf_req *fsf_req)
-{
-	unsigned int i;
-
-	i = fsf_req->req_id % REQUEST_LIST_SIZE;
-	list_add_tail(&fsf_req->list, &adapter->req_list[i]);
-}
-
-void zfcp_reqlist_remove(struct zfcp_adapter *adapter, unsigned long req_id)
-{
-	struct zfcp_fsf_req *request, *tmp;
-	unsigned int i, counter;
-	u64 dbg_tmp[2];
-
-	i = req_id % REQUEST_LIST_SIZE;
-	BUG_ON(list_empty(&adapter->req_list[i]));
-
-	counter = 0;
-	list_for_each_entry_safe(request, tmp, &adapter->req_list[i], list) {
-		if (request->req_id == req_id) {
-			dbg_tmp[0] = (u64) atomic_read(&adapter->reqs_active);
-			dbg_tmp[1] = (u64) counter;
-			debug_event(adapter->erp_dbf, 4, (void *) dbg_tmp, 16);
-			list_del(&request->list);
-			break;
-		}
-		counter++;
-	}
-}
-
-struct zfcp_fsf_req *zfcp_reqlist_ismember(struct zfcp_adapter *adapter,
-					   unsigned long req_id)
-{
-	struct zfcp_fsf_req *request, *tmp;
-	unsigned int i;
-
-	/* 0 is reserved as an invalid req_id */
-	if (req_id == 0)
-		return NULL;
-
-	i = req_id % REQUEST_LIST_SIZE;
-
-	list_for_each_entry_safe(request, tmp, &adapter->req_list[i], list)
-		if (request->req_id == req_id)
-			return request;
-
-	return NULL;
-}
-
 int zfcp_reqlist_isempty(struct zfcp_adapter *adapter)
 {
-	unsigned int i;
+	unsigned int idx;

-	for (i=0; i<REQUEST_LIST_SIZE; i++)
-		if (!list_empty(&adapter->req_list[i]))
+	for (idx = 0; idx < REQUEST_LIST_SIZE; idx++)
+		if (!list_empty(&adapter->req_list[idx]))
 			return 0;
-
 	return 1;
 }

@@ -1106,7 +1041,7 @@

 	/* initialize list of fsf requests */
 	spin_lock_init(&adapter->req_list_lock);
-	retval = zfcp_reqlist_init(adapter);
+	retval = zfcp_reqlist_alloc(adapter);
 	if (retval) {
 		ZFCP_LOG_INFO("request list initialization failed\n");
 		goto failed_low_mem_buffers;
@@ -1167,6 +1102,7 @@
 	zfcp_sysfs_adapter_remove_files(&adapter->ccw_device->dev);
  sysfs_failed:
 	dev_set_drvdata(&ccw_device->dev, NULL);
+	zfcp_reqlist_free(adapter);
  failed_low_mem_buffers:
 	zfcp_free_low_mem_buffers(adapter);
 	if (qdio_free(ccw_device) != 0)
--- linux-2.6.orig/drivers/s390/scsi/zfcp_def.h	2007-05-07 15:54:46.000000000 +0200
+++ linux-2.6/drivers/s390/scsi/zfcp_def.h	2007-05-07 16:26:34.000000000 +0200
@@ -1090,6 +1090,42 @@
 #define zfcp_get_busid_by_unit(unit) (zfcp_get_busid_by_port(unit->port))

 /*
+ * Helper functions for request ID management.
+ */
+static inline int zfcp_reqlist_hash(unsigned long req_id)
+{
+	return req_id % REQUEST_LIST_SIZE;
+}
+
+static inline void zfcp_reqlist_add(struct zfcp_adapter *adapter,
+				    struct zfcp_fsf_req *fsf_req)
+{
+	unsigned int idx;
+
+	idx = zfcp_reqlist_hash(fsf_req->req_id);
+	list_add_tail(&fsf_req->list, &adapter->req_list[idx]);
+}
+
+static inline void zfcp_reqlist_remove(struct zfcp_adapter *adapter,
+				       struct zfcp_fsf_req *fsf_req)
+{
+	list_del(&fsf_req->list);
+}
+
+static inline struct zfcp_fsf_req *
+zfcp_reqlist_find(struct zfcp_adapter *adapter, unsigned long req_id)
+{
+	struct zfcp_fsf_req *request;
+	unsigned int idx;
+
+	idx = zfcp_reqlist_hash(req_id);
+	list_for_each_entry(request, &adapter->req_list[idx], list)
+		if (request->req_id == req_id)
+			return request;
+	return NULL;
+}
+
+/*
  *  functions needed for reference/usage counting
  */

--- linux-2.6.orig/drivers/s390/scsi/zfcp_erp.c	2007-05-07 15:50:19.000000000 +0200
+++ linux-2.6/drivers/s390/scsi/zfcp_erp.c	2007-05-07 16:26:34.000000000 +0200
@@ -847,8 +847,7 @@
 	if (erp_action->fsf_req) {
 		/* take lock to ensure that request is not deleted meanwhile */
 		spin_lock(&adapter->req_list_lock);
-		if (zfcp_reqlist_ismember(adapter,
-					    erp_action->fsf_req->req_id)) {
+		if (zfcp_reqlist_find(adapter, erp_action->fsf_req->req_id)) {
 			/* fsf_req still exists */
 			debug_text_event(adapter->erp_dbf, 3, "a_ca_req");
 			debug_event(adapter->erp_dbf, 3, &erp_action->fsf_req,
--- linux-2.6.orig/drivers/s390/scsi/zfcp_ext.h	2007-04-26 14:53:13.000000000 +0200
+++ linux-2.6/drivers/s390/scsi/zfcp_ext.h	2007-05-07 16:26:34.000000000 +0200
@@ -184,10 +184,6 @@
 				      unsigned long);
 extern void zfcp_scsi_dbf_event_devreset(const char *, u8, struct zfcp_unit *,
 					 struct scsi_cmnd *);
-extern void zfcp_reqlist_add(struct zfcp_adapter *, struct zfcp_fsf_req *);
-extern void zfcp_reqlist_remove(struct zfcp_adapter *, unsigned long);
-extern struct zfcp_fsf_req *zfcp_reqlist_ismember(struct zfcp_adapter *,
-						  unsigned long);
 extern int zfcp_reqlist_isempty(struct zfcp_adapter *);

 #endif	/* ZFCP_EXT_H */
--- linux-2.6.orig/drivers/s390/scsi/zfcp_fsf.c	2007-05-07 13:57:34.000000000 +0200
+++ linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2007-05-07 16:26:34.000000000 +0200
@@ -4787,7 +4787,7 @@
 		retval = -EIO;
 		del_timer(&fsf_req->timer);
 		spin_lock(&adapter->req_list_lock);
-		zfcp_reqlist_remove(adapter, fsf_req->req_id);
+		zfcp_reqlist_remove(adapter, fsf_req);
 		spin_unlock(&adapter->req_list_lock);
 		/* undo changes in request queue made for this request */
 		zfcp_qdio_zero_sbals(req_queue->buffer,
--- linux-2.6.orig/drivers/s390/scsi/zfcp_qdio.c	2007-05-07 13:22:45.000000000 +0200
+++ linux-2.6/drivers/s390/scsi/zfcp_qdio.c	2007-05-07 16:26:34.000000000 +0200
@@ -283,7 +283,7 @@
 }

 /**
- * zfcp_qdio_reqid_check - checks for valid reqids or unsolicited status
+ * zfcp_qdio_reqid_check - checks for valid reqids.
  */
 static void zfcp_qdio_reqid_check(struct zfcp_adapter *adapter, 
 				  unsigned long req_id)
@@ -294,14 +294,17 @@
 	debug_long_event(adapter->erp_dbf, 4, req_id);

 	spin_lock_irqsave(&adapter->req_list_lock, flags);
-	fsf_req = zfcp_reqlist_ismember(adapter, req_id);
+	fsf_req = zfcp_reqlist_find(adapter, req_id);

-	if (!fsf_req) {
-		spin_unlock_irqrestore(&adapter->req_list_lock, flags);
-		panic("error: unknown request id (%ld).\n", req_id);
-	}
+	if (!fsf_req)
+		/*
+		 * Unknown request means that we have potentially memory
+		 * corruption and must stop the machine immediatly.
+		 */
+		panic("error: unknown request id (%ld) on adapter %s.\n",
+		      req_id, zfcp_get_busid_by_adapter(adapter));

-	zfcp_reqlist_remove(adapter, req_id);
+	zfcp_reqlist_remove(adapter, fsf_req);
 	atomic_dec(&adapter->reqs_active);
 	spin_unlock_irqrestore(&adapter->req_list_lock, flags);

--- linux-2.6.orig/drivers/s390/scsi/zfcp_scsi.c	2007-05-07 15:50:19.000000000 +0200
+++ linux-2.6/drivers/s390/scsi/zfcp_scsi.c	2007-05-07 16:26:34.000000000 +0200
@@ -407,8 +407,8 @@

 	/* Check whether corresponding fsf_req is still pending */
 	spin_lock(&adapter->req_list_lock);
-	fsf_req = zfcp_reqlist_ismember(adapter, (unsigned long)
-					scpnt->host_scribble);
+	fsf_req = zfcp_reqlist_find(adapter,
+				    (unsigned long) scpnt->host_scribble);
 	spin_unlock(&adapter->req_list_lock);
 	if (!fsf_req) {
 		write_unlock_irqrestore(&adapter->abort_lock, flags);


-------------------------------------------------------
