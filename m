From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 03/18] [Patch] zfcp: add measurement data for average qdio queue utilisation
Date: Mon, 02 Mar 2009 13:08:56 +0100
Message-ID: <20090302121002.420177000@de.ibm.com>
References: <20090302120853.279447000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:51345 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758679AbZCBMKG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 07:10:06 -0500
Content-Disposition: inline; filename=702-zfcp-queue-lock.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Martin Peschke <mpeschke@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mpeschke@linux.vnet.ibm.com>

Provide measurement data for the utilisation of the QDIO outbound queue.
The additional value allows to calculate an average queue utilisation
by looking at the deltas per time unit. Needed for capacity planning.
It is up to user space to handle wrap-arounds of the 64 bit value.

The new counter neatly complements the existing counter for queue full
conditions. That is why, both statistics counter have been integrated.

Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c   |    1 +
 drivers/s390/scsi/zfcp_def.h   |    3 +++
 drivers/s390/scsi/zfcp_qdio.c  |   20 ++++++++++++++++++++
 drivers/s390/scsi/zfcp_sysfs.c |    3 ++-
 4 files changed, 26 insertions(+), 1 deletion(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2009-03-01 16:41:30.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2009-03-01 16:41:30.000000000 +0100
@@ -501,6 +501,7 @@ int zfcp_adapter_enqueue(struct ccw_devi
 	spin_lock_init(&adapter->scsi_dbf_lock);
 	spin_lock_init(&adapter->rec_dbf_lock);
 	spin_lock_init(&adapter->req_q_lock);
+	spin_lock_init(&adapter->qdio_stat_lock);
 
 	rwlock_init(&adapter->erp_lock);
 	rwlock_init(&adapter->abort_lock);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2009-03-01 16:41:30.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2009-03-01 16:41:30.000000000 +0100
@@ -445,6 +445,9 @@ struct zfcp_adapter {
 	spinlock_t		req_q_lock;	   /* for operations on queue */
 	int			req_q_pci_batch;   /* SBALs since PCI indication
 						      was last set */
+	ktime_t			req_q_time; /* time of last fill level change */
+	u64			req_q_util; /* for accounting */
+	spinlock_t		qdio_stat_lock;
 	u32			fsf_req_seq_no;	   /* FSF cmnd seq number */
 	wait_queue_head_t	request_wq;	   /* can be used to wait for
 						      more avaliable SBALs */
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_qdio.c linux-2.6-patched/drivers/s390/scsi/zfcp_qdio.c
--- linux-2.6/drivers/s390/scsi/zfcp_qdio.c	2009-03-01 16:41:01.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_qdio.c	2009-03-01 16:41:30.000000000 +0100
@@ -77,6 +77,23 @@ static void zfcp_qdio_zero_sbals(struct 
 	}
 }
 
+/* this needs to be called prior to updating the queue fill level */
+static void zfcp_qdio_account(struct zfcp_adapter *adapter)
+{
+	ktime_t now;
+	s64 span;
+	int free, used;
+
+	spin_lock(&adapter->qdio_stat_lock);
+	now = ktime_get();
+	span = ktime_us_delta(now, adapter->req_q_time);
+	free = max(0, atomic_read(&adapter->req_q.count));
+	used = QDIO_MAX_BUFFERS_PER_Q - free;
+	adapter->req_q_util += used * span;
+	adapter->req_q_time = now;
+	spin_unlock(&adapter->qdio_stat_lock);
+}
+
 static void zfcp_qdio_int_req(struct ccw_device *cdev, unsigned int qdio_err,
 			      int queue_no, int first, int count,
 			      unsigned long parm)
@@ -93,6 +110,7 @@ static void zfcp_qdio_int_req(struct ccw
 	/* cleanup all SBALs being program-owned now */
 	zfcp_qdio_zero_sbals(queue->sbal, first, count);
 
+	zfcp_qdio_account(adapter);
 	atomic_add(count, &queue->count);
 	wake_up(&adapter->request_wq);
 }
@@ -359,6 +377,8 @@ int zfcp_qdio_send(struct zfcp_fsf_req *
 		sbale->flags |= SBAL_FLAGS0_PCI;
 	}
 
+	zfcp_qdio_account(adapter);
+
 	retval = do_QDIO(adapter->ccw_device, QDIO_FLAG_SYNC_OUTPUT, 0, first,
 			 count);
 	if (unlikely(retval)) {
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_sysfs.c linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c
--- linux-2.6/drivers/s390/scsi/zfcp_sysfs.c	2009-03-01 16:41:01.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c	2009-03-01 16:41:30.000000000 +0100
@@ -487,7 +487,8 @@ static ssize_t zfcp_sysfs_adapter_q_full
 	struct zfcp_adapter *adapter =
 		(struct zfcp_adapter *) scsi_host->hostdata[0];
 
-	return sprintf(buf, "%d\n", atomic_read(&adapter->qdio_outb_full));
+	return sprintf(buf, "%d %llu\n", atomic_read(&adapter->qdio_outb_full),
+		       (unsigned long long)adapter->req_q_util);
 }
 static DEVICE_ATTR(queue_full, S_IRUGO, zfcp_sysfs_adapter_q_full_show, NULL);
 

