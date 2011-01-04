From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 08/10] mpt2sas: Basic Code Cleanup in mpt2sas_base
Date: Tue, 4 Jan 2011 11:39:20 +0530
Message-ID: <20110104060912.GI5751@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:51750 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864Ab1ADHEc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2011 02:04:32 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Basic Code Cleanup:
(1) _base_get_cb_idx and mpt2sas_base_free_smid were reorganized in
similar fashion so the order of obtaining the cbx and smid are
scsiio,
hi_priority, and internal.
(2) The hi_priority and internal request queue struct was made
smaller
by removing the scmd and chain_tracker, thus saving memory
allocation.
(3) For scsiio request, a new structure was created having the same
elements from the former request tracker struct.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 51d50a1..e8a6f1c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -752,20 +752,19 @@ static u8
 _base_get_cb_idx(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 {
 	int i;
-	u8 cb_idx = 0xFF;
-
-	if (smid >= ioc->hi_priority_smid) {
-		if (smid < ioc->internal_smid) {
-			i = smid - ioc->hi_priority_smid;
-			cb_idx = ioc->hpr_lookup[i].cb_idx;
-		} else if (smid <= ioc->hba_queue_depth)  {
-			i = smid - ioc->internal_smid;
-			cb_idx = ioc->internal_lookup[i].cb_idx;
-		}
-	} else {
+	u8 cb_idx;
+
+	if (smid < ioc->hi_priority_smid) {
 		i = smid - 1;
 		cb_idx = ioc->scsi_lookup[i].cb_idx;
-	}
+	} else if (smid < ioc->internal_smid) {
+		i = smid - ioc->hi_priority_smid;
+		cb_idx = ioc->hpr_lookup[i].cb_idx;
+	} else if (smid <= ioc->hba_queue_depth) {
+		i = smid - ioc->internal_smid;
+		cb_idx = ioc->internal_lookup[i].cb_idx;
+	} else
+		cb_idx = 0xFF;
 	return cb_idx;
 }
 
@@ -1430,7 +1429,7 @@ mpt2sas_base_get_smid_scsiio(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx,
     struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
-	struct request_tracker *request;
+	struct scsiio_tracker *request;
 	u16 smid;
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
@@ -1442,7 +1441,7 @@ mpt2sas_base_get_smid_scsiio(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx,
 	}
 
 	request = list_entry(ioc->free_list.next,
-	    struct request_tracker, tracker_list);
+	    struct scsiio_tracker, tracker_list);
 	request->scmd = scmd;
 	request->cb_idx = cb_idx;
 	smid = request->smid;
@@ -1496,48 +1495,47 @@ mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 	struct chain_tracker *chain_req, *next;
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	if (smid >= ioc->hi_priority_smid) {
-		if (smid < ioc->internal_smid) {
-			/* hi-priority */
-			i = smid - ioc->hi_priority_smid;
-			ioc->hpr_lookup[i].cb_idx = 0xFF;
-			list_add_tail(&ioc->hpr_lookup[i].tracker_list,
-			    &ioc->hpr_free_list);
-		} else {
-			/* internal queue */
-			i = smid - ioc->internal_smid;
-			ioc->internal_lookup[i].cb_idx = 0xFF;
-			list_add_tail(&ioc->internal_lookup[i].tracker_list,
-			    &ioc->internal_free_list);
+	if (smid < ioc->hi_priority_smid) {
+		/* scsiio queue */
+		i = smid - 1;
+		if (!list_empty(&ioc->scsi_lookup[i].chain_list)) {
+			list_for_each_entry_safe(chain_req, next,
+			    &ioc->scsi_lookup[i].chain_list, tracker_list) {
+				list_del_init(&chain_req->tracker_list);
+				list_add_tail(&chain_req->tracker_list,
+				    &ioc->free_chain_list);
+			}
 		}
+		ioc->scsi_lookup[i].cb_idx = 0xFF;
+		ioc->scsi_lookup[i].scmd = NULL;
+		list_add_tail(&ioc->scsi_lookup[i].tracker_list,
+		    &ioc->free_list);
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-		return;
-	}
 
-	/* scsiio queue */
-	i = smid - 1;
-	if (!list_empty(&ioc->scsi_lookup[i].chain_list)) {
-		list_for_each_entry_safe(chain_req, next,
-		    &ioc->scsi_lookup[i].chain_list, tracker_list) {
-			list_del_init(&chain_req->tracker_list);
-			list_add_tail(&chain_req->tracker_list,
-			    &ioc->free_chain_list);
+		/*
+		 * See _wait_for_commands_to_complete() call with regards
+		 * to this code.
+		 */
+		if (ioc->shost_recovery && ioc->pending_io_count) {
+			if (ioc->pending_io_count == 1)
+				wake_up(&ioc->reset_wq);
+			ioc->pending_io_count--;
 		}
+		return;
+	} else if (smid < ioc->internal_smid) {
+		/* hi-priority */
+		i = smid - ioc->hi_priority_smid;
+		ioc->hpr_lookup[i].cb_idx = 0xFF;
+		list_add_tail(&ioc->hpr_lookup[i].tracker_list,
+		    &ioc->hpr_free_list);
+	} else if (smid <= ioc->hba_queue_depth) {
+		/* internal queue */
+		i = smid - ioc->internal_smid;
+		ioc->internal_lookup[i].cb_idx = 0xFF;
+		list_add_tail(&ioc->internal_lookup[i].tracker_list,
+		    &ioc->internal_free_list);
 	}
-	ioc->scsi_lookup[i].cb_idx = 0xFF;
-	ioc->scsi_lookup[i].scmd = NULL;
-	list_add_tail(&ioc->scsi_lookup[i].tracker_list,
-	    &ioc->free_list);
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-
-	/*
-	 * See _wait_for_commands_to_complete() call with regards to this code.
-	 */
-	if (ioc->shost_recovery && ioc->pending_io_count) {
-		if (ioc->pending_io_count == 1)
-			wake_up(&ioc->reset_wq);
-		ioc->pending_io_count--;
-	}
 }
 
 /**
@@ -2278,9 +2276,9 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	    ioc->name, (unsigned long long) ioc->request_dma));
 	total_sz += sz;
 
-	sz = ioc->scsiio_depth * sizeof(struct request_tracker);
+	sz = ioc->scsiio_depth * sizeof(struct scsiio_tracker);
 	ioc->scsi_lookup_pages = get_order(sz);
-	ioc->scsi_lookup = (struct request_tracker *)__get_free_pages(
+	ioc->scsi_lookup = (struct scsiio_tracker *)__get_free_pages(
 	    GFP_KERNEL, ioc->scsi_lookup_pages);
 	if (!ioc->scsi_lookup) {
 		printk(MPT2SAS_ERR_FMT "scsi_lookup: get_free_pages failed, "
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 82579fb..445f1cf 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -101,7 +101,8 @@
 #define MPT_NAME_LENGTH			32	/* generic length of strings */
 #define MPT_STRING_LENGTH		64
 
-#define	MPT_MAX_CALLBACKS		16
+#define MPT_MAX_CALLBACKS		16
+
 
 #define	 CAN_SLEEP			1
 #define  NO_SLEEP			0
@@ -445,14 +446,14 @@ struct chain_tracker {
 };
 
 /**
- * struct request_tracker - firmware request tracker
+ * struct scsiio_tracker - scsi mf request tracker
  * @smid: system message id
  * @scmd: scsi request pointer
  * @cb_idx: callback index
  * @chain_list: list of chains associated to this IO
  * @tracker_list: list of free request (ioc->free_list)
  */
-struct request_tracker {
+struct scsiio_tracker {
 	u16	smid;
 	struct scsi_cmnd *scmd;
 	u8	cb_idx;
@@ -461,6 +462,19 @@ struct request_tracker {
 };
 
 /**
+ * struct request_tracker - misc mf request tracker
+ * @smid: system message id
+ * @scmd: scsi request pointer
+ * @cb_idx: callback index
+ * @tracker_list: list of free request (ioc->free_list)
+ */
+struct request_tracker {
+	u16	smid;
+	u8	cb_idx;
+	struct list_head tracker_list;
+};
+
+/**
  * struct _tr_list - target reset list
  * @handle: device handle
  * @state: state machine
@@ -723,7 +737,7 @@ struct MPT2SAS_ADAPTER {
 	u8		*request;
 	dma_addr_t	request_dma;
 	u32		request_dma_sz;
-	struct request_tracker *scsi_lookup;
+	struct scsiio_tracker *scsi_lookup;
 	ulong		scsi_lookup_pages;
 	spinlock_t 	scsi_lookup_lock;
 	struct list_head free_list;
