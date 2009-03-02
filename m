From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 12/18] [PATCH] zfcp: Remove PCI flag
Date: Mon, 02 Mar 2009 13:09:05 +0100
Message-ID: <20090302121003.642226000@de.ibm.com>
References: <20090302120853.279447000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:34911 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758755AbZCBMKH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 07:10:07 -0500
Content-Disposition: inline; filename=q.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The usage of the PCI flag to trigger interrupts is optional. Even
without setting the flag, qdio still receives interrupts to continue
working on the queue.  Remove the PCI flag from zfcp, it is not
necessary.

Acked-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
--- a/drivers/s390/scsi/zfcp_qdio.c	2009-03-02 09:47:50.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_qdio.c	2009-03-02 09:47:50.000000000 +0100
@@ -11,9 +11,6 @@
 
 #include "zfcp_ext.h"
 
-/* FIXME(tune): free space should be one max. SBAL chain plus what? */
-#define ZFCP_QDIO_PCI_INTERVAL	(QDIO_MAX_BUFFERS_PER_Q \
-				- (FSF_MAX_SBALS_PER_REQ + 4))
 #define QBUFF_PER_PAGE		(PAGE_SIZE / sizeof(struct qdio_buffer))
 
 static int zfcp_qdio_buffers_enqueue(struct qdio_buffer **sbal)
@@ -364,23 +361,12 @@ int zfcp_qdio_send(struct zfcp_fsf_req *
 	struct zfcp_qdio_queue *req_q = &adapter->req_q;
 	int first = fsf_req->sbal_first;
 	int count = fsf_req->sbal_number;
-	int retval, pci, pci_batch;
-	struct qdio_buffer_element *sbale;
-
-	/* acknowledgements for transferred buffers */
-	pci_batch = adapter->req_q_pci_batch + count;
-	if (unlikely(pci_batch >= ZFCP_QDIO_PCI_INTERVAL)) {
-		pci_batch %= ZFCP_QDIO_PCI_INTERVAL;
-		pci = first + count - (pci_batch + 1);
-		pci %= QDIO_MAX_BUFFERS_PER_Q;
-		sbale = zfcp_qdio_sbale(req_q, pci, 0);
-		sbale->flags |= SBAL_FLAGS0_PCI;
-	}
+	int retval;
+	unsigned int qdio_flags = QDIO_FLAG_SYNC_OUTPUT;
 
 	zfcp_qdio_account(adapter);
 
-	retval = do_QDIO(adapter->ccw_device, QDIO_FLAG_SYNC_OUTPUT, 0, first,
-			 count);
+	retval = do_QDIO(adapter->ccw_device, qdio_flags, 0, first, count);
 	if (unlikely(retval)) {
 		zfcp_qdio_zero_sbals(req_q->sbal, first, count);
 		return retval;
@@ -390,7 +376,6 @@ int zfcp_qdio_send(struct zfcp_fsf_req *
 	atomic_sub(count, &req_q->count);
 	req_q->first += count;
 	req_q->first %= QDIO_MAX_BUFFERS_PER_Q;
-	adapter->req_q_pci_batch = pci_batch;
 	return 0;
 }
 
@@ -461,7 +446,6 @@ void zfcp_qdio_close(struct zfcp_adapter
 	}
 	req_q->first = 0;
 	atomic_set(&req_q->count, 0);
-	adapter->req_q_pci_batch = 0;
 	adapter->resp_q.first = 0;
 	atomic_set(&adapter->resp_q.count, 0);
 }
@@ -499,7 +483,6 @@ int zfcp_qdio_open(struct zfcp_adapter *
 	/* set index of first avalable SBALS / number of available SBALS */
 	adapter->req_q.first = 0;
 	atomic_set(&adapter->req_q.count, QDIO_MAX_BUFFERS_PER_Q);
-	adapter->req_q_pci_batch = 0;
 
 	return 0;
 
--- a/drivers/s390/scsi/zfcp_def.h	2009-03-02 09:47:50.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2009-03-02 09:55:14.000000000 +0100
@@ -443,8 +443,6 @@ struct zfcp_adapter {
 	spinlock_t		req_list_lock;	   /* request list lock */
 	struct zfcp_qdio_queue	req_q;		   /* request queue */
 	spinlock_t		req_q_lock;	   /* for operations on queue */
-	int			req_q_pci_batch;   /* SBALs since PCI indication
-						      was last set */
 	ktime_t			req_q_time; /* time of last fill level change */
 	u64			req_q_util; /* for accounting */
 	spinlock_t		qdio_stat_lock;

