From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] [6/8] zfcp: several bug fixes
Date: Mon, 13 Jun 2005 12:52:35 +0200
Message-ID: <20050613105235.GF8892@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:15502 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S261489AbVFMKwe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 06:52:34 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.12.10/8.12.10) with ESMTP id j5DAqXa6109808
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 10:52:33 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5DAqX2H162118
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 12:52:33 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j5DAqXPv032749
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 12:52:33 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

This is patch 6 of 8 in a series of zfcp bug fixes.  Patches are based
on 2.6.12-rc6 plus "remove flags_dump feature"-patch from June, 10th.

This one fixes a race between zfcp_fsf_req_dismiss_all and
zfcp_qdio_reqid_check. During adapter shutdown it occurred that a
request was cleaned up twice. First during its normal
completion. Second when dismiss_all was called.  The fix is to
serialize access to fsf request list between zfcp_fsf_req_dismiss_all
and zfcp_qdio_reqid_check and delete a fsf request from the list if
its completion is triggered.
(Additionally a rwlock was replaced by a spinlock and fsf_req_cleanup
was elimitad.)


Regards,

Andreas


zfcp: fix bug during adapter shutdown

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

 zfcp_aux.c  |    8 +++---
 zfcp_def.h  |    2 -
 zfcp_erp.c  |    4 +--
 zfcp_ext.h  |    2 -
 zfcp_fsf.c  |   79 ++++++++++++++++--------------------------------------------
 zfcp_qdio.c |   28 ++++++++++-----------
 zfcp_scsi.c |    2 -
 7 files changed, 45 insertions(+), 80 deletions(-)

diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_aux.c linux-2.6.12-rc6/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_aux.c	2005-06-13 09:50:52.000000000 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_aux.c	2005-06-13 09:54:28.000000000 +0200
@@ -520,7 +520,7 @@
 
  out:
 	if (fsf_req != NULL)
-		zfcp_fsf_req_cleanup(fsf_req);
+		zfcp_fsf_req_free(fsf_req);
 
 	if ((adapter != NULL) && (retval != -ENXIO))
 		zfcp_adapter_put(adapter);
@@ -1149,7 +1149,7 @@
 	INIT_LIST_HEAD(&adapter->port_remove_lh);
 
 	/* initialize list of fsf requests */
-	rwlock_init(&adapter->fsf_req_list_lock);
+	spin_lock_init(&adapter->fsf_req_list_lock);
 	INIT_LIST_HEAD(&adapter->fsf_req_list_head);
 
 	/* initialize abort lock */
@@ -1234,9 +1234,9 @@
 	zfcp_sysfs_adapter_remove_files(&adapter->ccw_device->dev);
 	dev_set_drvdata(&adapter->ccw_device->dev, NULL);
 	/* sanity check: no pending FSF requests */
-	read_lock_irqsave(&adapter->fsf_req_list_lock, flags);
+	spin_lock_irqsave(&adapter->fsf_req_list_lock, flags);
 	retval = !list_empty(&adapter->fsf_req_list_head);
-	read_unlock_irqrestore(&adapter->fsf_req_list_lock, flags);
+	spin_unlock_irqrestore(&adapter->fsf_req_list_lock, flags);
 	if (retval) {
 		ZFCP_LOG_NORMAL("bug: adapter %s (%p) still in use, "
 				"%i requests outstanding\n",
diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_def.h linux-2.6.12-rc6/drivers/s390/scsi/zfcp_def.h
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_def.h	2005-06-13 09:54:37.000000000 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_def.h	2005-06-13 09:54:28.000000000 +0200
@@ -861,7 +861,7 @@
 	u32			ports;	           /* number of remote ports */
         struct timer_list       scsi_er_timer;     /* SCSI err recovery watch */
 	struct list_head	fsf_req_list_head; /* head of FSF req list */
-	rwlock_t		fsf_req_list_lock; /* lock for ops on list of
+	spinlock_t		fsf_req_list_lock; /* lock for ops on list of
 						      FSF requests */
         atomic_t       		fsf_reqs_active;   /* # active FSF reqs */
 	struct zfcp_qdio_queue	request_queue;	   /* request queue */
diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_erp.c linux-2.6.12-rc6/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_erp.c	2005-06-13 09:54:37.000000000 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_erp.c	2005-06-13 09:54:28.000000000 +0200
@@ -891,7 +891,7 @@
 
 	if (erp_action->fsf_req) {
 		/* take lock to ensure that request is not being deleted meanwhile */
-		write_lock(&adapter->fsf_req_list_lock);
+		spin_lock(&adapter->fsf_req_list_lock);
 		/* check whether fsf req does still exist */
 		list_for_each_entry(fsf_req, &adapter->fsf_req_list_head, list)
 		    if (fsf_req == erp_action->fsf_req)
@@ -934,7 +934,7 @@
 			 */
 			erp_action->fsf_req = NULL;
 		}
-		write_unlock(&adapter->fsf_req_list_lock);
+		spin_unlock(&adapter->fsf_req_list_lock);
 	} else
 		debug_text_event(adapter->erp_dbf, 3, "a_ca_noreq");
 
diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_ext.h linux-2.6.12-rc6/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_ext.h	2005-06-13 09:15:31.000000000 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_ext.h	2005-06-13 09:54:28.000000000 +0200
@@ -116,7 +116,7 @@
 					   struct timer_list*, int);
 extern int  zfcp_fsf_req_complete(struct zfcp_fsf_req *);
 extern void zfcp_fsf_incoming_els(struct zfcp_fsf_req *);
-extern void zfcp_fsf_req_cleanup(struct zfcp_fsf_req *);
+extern void zfcp_fsf_req_free(struct zfcp_fsf_req *);
 extern struct zfcp_fsf_req *zfcp_fsf_send_fcp_command_task_management(
 	struct zfcp_adapter *, struct zfcp_unit *, u8, int);
 extern struct zfcp_fsf_req *zfcp_fsf_abort_fcp_command(
diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_fsf.c linux-2.6.12-rc6/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_fsf.c	2005-06-13 09:54:37.000000000 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_fsf.c	2005-06-13 09:54:28.000000000 +0200
@@ -61,7 +61,6 @@
 static int zfcp_fsf_fsfstatus_qual_eval(struct zfcp_fsf_req *);
 static int zfcp_fsf_req_dispatch(struct zfcp_fsf_req *);
 static void zfcp_fsf_req_dismiss(struct zfcp_fsf_req *);
-static void zfcp_fsf_req_free(struct zfcp_fsf_req *);
 
 /* association between FSF command and FSF QTCB type */
 static u32 fsf_qtcb_type[] = {
@@ -149,13 +148,13 @@
  *
  * locks:       none
  */
-static void
+void
 zfcp_fsf_req_free(struct zfcp_fsf_req *fsf_req)
 {
 	if (likely(fsf_req->pool != NULL))
 		mempool_free(fsf_req, fsf_req->pool);
-		else
-			kfree(fsf_req);
+	else
+		kfree(fsf_req);
 }
 
 /*
@@ -170,30 +169,21 @@
 int
 zfcp_fsf_req_dismiss_all(struct zfcp_adapter *adapter)
 {
-	int retval = 0;
 	struct zfcp_fsf_req *fsf_req, *tmp;
+	unsigned long flags;
+	LIST_HEAD(remove_queue);
 
-	list_for_each_entry_safe(fsf_req, tmp, &adapter->fsf_req_list_head,
-				 list)
-	    zfcp_fsf_req_dismiss(fsf_req);
-	/* wait_event_timeout? */
-	while (!list_empty(&adapter->fsf_req_list_head)) {
-		ZFCP_LOG_DEBUG("fsf req list of adapter %s not yet empty\n",
-			       zfcp_get_busid_by_adapter(adapter));
-		/* wait for woken intiators to clean up their requests */
-		msleep(jiffies_to_msecs(ZFCP_FSFREQ_CLEANUP_TIMEOUT));
-	}
+	spin_lock_irqsave(&adapter->fsf_req_list_lock, flags);
+	list_splice_init(&adapter->fsf_req_list_head, &remove_queue);
+	atomic_set(&adapter->fsf_reqs_active, 0);
+	spin_unlock_irqrestore(&adapter->fsf_req_list_lock, flags);
 
-	/* consistency check */
-	if (atomic_read(&adapter->fsf_reqs_active)) {
-		ZFCP_LOG_NORMAL("bug: There are still %d FSF requests pending "
-				"on adapter %s after cleanup.\n",
-				atomic_read(&adapter->fsf_reqs_active),
-				zfcp_get_busid_by_adapter(adapter));
-		atomic_set(&adapter->fsf_reqs_active, 0);
+	list_for_each_entry_safe(fsf_req, tmp, &remove_queue, list) {
+		list_del(&fsf_req->list);
+		zfcp_fsf_req_dismiss(fsf_req);
 	}
 
-	return retval;
+	return 0;
 }
 
 /*
@@ -226,10 +216,6 @@
 {
 	int retval = 0;
 	int cleanup;
-	struct zfcp_adapter *adapter = fsf_req->adapter;
-
-	/* do some statistics */
-	atomic_dec(&adapter->fsf_reqs_active);
 
 	if (unlikely(fsf_req->fsf_command == FSF_QTCB_UNSOLICITED_STATUS)) {
 		ZFCP_LOG_DEBUG("Status read response received\n");
@@ -260,7 +246,7 @@
 		 * lock must not be held here since it will be
 		 * grabed by the called routine, too
 		 */
-		zfcp_fsf_req_cleanup(fsf_req);
+		zfcp_fsf_req_free(fsf_req);
 	} else {
 		/* notify initiator waiting for the requests completion */
 		ZFCP_LOG_TRACE("waking initiator of FSF request %p\n",fsf_req);
@@ -936,7 +922,7 @@
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_DISMISSED) {
 		mempool_free(status_buffer, adapter->pool.data_status_read);
-		zfcp_fsf_req_cleanup(fsf_req);
+		zfcp_fsf_req_free(fsf_req);
 		goto out;
 	}
 
@@ -1033,7 +1019,7 @@
 		break;
 	}
 	mempool_free(status_buffer, adapter->pool.data_status_read);
-	zfcp_fsf_req_cleanup(fsf_req);
+	zfcp_fsf_req_free(fsf_req);
 	/*
 	 * recycle buffer and start new request repeat until outbound
 	 * queue is empty or adapter shutdown is requested
@@ -2258,7 +2244,7 @@
 	wait_event(fsf_req->completion_wq,
 		   fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
 	del_timer_sync(timer);
-	zfcp_fsf_req_cleanup(fsf_req);
+	zfcp_fsf_req_free(fsf_req);
  out:
 	kfree(timer);
 	return retval;
@@ -4607,7 +4593,7 @@
 	*status = fsf_req->status;
 
 	/* cleanup request */
-	zfcp_fsf_req_cleanup(fsf_req);
+	zfcp_fsf_req_free(fsf_req);
  out:
 	return retval;
 }
@@ -4806,9 +4792,9 @@
 		inc_seq_no = 0;
 
 	/* put allocated FSF request at list tail */
-	write_lock_irqsave(&adapter->fsf_req_list_lock, flags);
+	spin_lock_irqsave(&adapter->fsf_req_list_lock, flags);
 	list_add_tail(&fsf_req->list, &adapter->fsf_req_list_head);
-	write_unlock_irqrestore(&adapter->fsf_req_list_lock, flags);
+	spin_unlock_irqrestore(&adapter->fsf_req_list_lock, flags);
 
 	/* figure out expiration time of timeout and start timeout */
 	if (unlikely(timer)) {
@@ -4852,9 +4838,9 @@
 		 */
 		if (timer)
 			del_timer(timer);
-		write_lock_irqsave(&adapter->fsf_req_list_lock, flags);
+		spin_lock_irqsave(&adapter->fsf_req_list_lock, flags);
 		list_del(&fsf_req->list);
-		write_unlock_irqrestore(&adapter->fsf_req_list_lock, flags);
+		spin_unlock_irqrestore(&adapter->fsf_req_list_lock, flags);
 		/*
 		 * adjust the number of free SBALs in request queue as well as
 		 * position of first one
@@ -4892,25 +4878,4 @@
 	return retval;
 }
 
-/*
- * function:    zfcp_fsf_req_cleanup
- *
- * purpose:	cleans up an FSF request and removes it from the specified list
- *
- * returns:
- *
- * assumption:	no pending SB in SBALEs other than QTCB
- */
-void
-zfcp_fsf_req_cleanup(struct zfcp_fsf_req *fsf_req)
-{
-	struct zfcp_adapter *adapter = fsf_req->adapter;
-	unsigned long flags;
-
-	write_lock_irqsave(&adapter->fsf_req_list_lock, flags);
-	list_del(&fsf_req->list);
-	write_unlock_irqrestore(&adapter->fsf_req_list_lock, flags);
-	zfcp_fsf_req_free(fsf_req);
-}
-
 #undef ZFCP_LOG_AREA
diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_qdio.c linux-2.6.12-rc6/drivers/s390/scsi/zfcp_qdio.c
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_qdio.c	2005-06-13 09:50:47.000000000 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_qdio.c	2005-06-13 09:54:28.000000000 +0200
@@ -446,37 +446,37 @@
 zfcp_qdio_reqid_check(struct zfcp_adapter *adapter, void *sbale_addr)
 {
 	struct zfcp_fsf_req *fsf_req;
-	int retval = 0;
 
 	/* invalid (per convention used in this driver) */
 	if (unlikely(!sbale_addr)) {
 		ZFCP_LOG_NORMAL("bug: invalid reqid\n");
-		retval = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	/* valid request id and thus (hopefully :) valid fsf_req address */
 	fsf_req = (struct zfcp_fsf_req *) sbale_addr;
 
+	/* serialize with zfcp_fsf_req_dismiss_all */
+	spin_lock(&adapter->fsf_req_list_lock);
+	if (list_empty(&adapter->fsf_req_list_head)) {
+		spin_unlock(&adapter->fsf_req_list_lock);
+		return 0;
+	}
+	list_del(&fsf_req->list);
+	atomic_dec(&adapter->fsf_reqs_active);
+	spin_unlock(&adapter->fsf_req_list_lock);
+	
 	if (unlikely(adapter != fsf_req->adapter)) {
 		ZFCP_LOG_NORMAL("bug: invalid reqid (fsf_req=%p, "
 				"fsf_req->adapter=%p, adapter=%p)\n",
 				fsf_req, fsf_req->adapter, adapter);
-		retval = -EINVAL;
-		goto out;
-	}
-
-	ZFCP_LOG_TRACE("fsf_req at %p, QTCB at %p\n", fsf_req, fsf_req->qtcb);
-	if (likely(fsf_req->qtcb)) {
-		ZFCP_LOG_TRACE("hex dump of QTCB:\n");
-		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_TRACE, (char *) fsf_req->qtcb,
-			      sizeof(struct fsf_qtcb));
+		return -EINVAL;
 	}
 
 	/* finish the FSF request */
 	zfcp_fsf_req_complete(fsf_req);
- out:
-	return retval;
+
+	return 0;
 }
 
 /**
diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_scsi.c linux-2.6.12-rc6/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_scsi.c	2005-06-13 09:15:31.000000000 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_scsi.c	2005-06-13 09:54:28.000000000 +0200
@@ -575,7 +575,7 @@
 	    *(u64 *) & new_fsf_req->qtcb->header.fsf_status_qual.word[0];
 	dbf_fsf_qual[1] =
 	    *(u64 *) & new_fsf_req->qtcb->header.fsf_status_qual.word[2];
-	zfcp_fsf_req_cleanup(new_fsf_req);
+	zfcp_fsf_req_free(new_fsf_req);
 #else
 	retval = zfcp_fsf_req_wait_and_cleanup(new_fsf_req,
 					       ZFCP_UNINTERRUPTIBLE, &status);

