From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 06/15] zfcp: avoid false ERP complete due to sema race
Date: Fri, 17 Apr 2009 15:08:06 +0200
Message-ID: <20090417131122.609921000@de.ibm.com>
References: <20090417130800.923944000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:52228 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbZDQNLZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 09:11:25 -0400
Content-Disposition: inline; filename=705-zfcp-false-complete.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The ERP thread is performing a task before it is executing the
corresponding down on the semaphore. The response handler of the
just started exchange config should wait for the completion by
performing a down on this semaphore. Since this semaphore is still
positive from the ERP enqueue the handler won't wait and therefore
the exchange config will always fail leaving the adapter in error.
The problem can be solved by performing the down on the semaphore 
before starting an ERP task. This is the logically correct order. 
Only walk the ERP loop if there is a task to perform.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/s390/scsi/zfcp_erp.c	2009-04-17 15:03:37.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2009-04-17 15:03:39.000000000 +0200
@@ -1311,6 +1311,11 @@ static int zfcp_erp_thread(void *data)
 
 	while (!(atomic_read(&adapter->status) &
 		 ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL)) {
+
+		zfcp_rec_dbf_event_thread_lock("erthrd1", adapter);
+		ignore = down_interruptible(&adapter->erp_ready_sem);
+		zfcp_rec_dbf_event_thread_lock("erthrd2", adapter);
+
 		write_lock_irqsave(&adapter->erp_lock, flags);
 		next = adapter->erp_ready_head.next;
 		write_unlock_irqrestore(&adapter->erp_lock, flags);
@@ -1322,10 +1327,6 @@ static int zfcp_erp_thread(void *data)
 			if (zfcp_erp_strategy(act) != ZFCP_ERP_DISMISSED)
 				zfcp_erp_wakeup(adapter);
 		}
-
-		zfcp_rec_dbf_event_thread_lock("erthrd1", adapter);
-		ignore = down_interruptible(&adapter->erp_ready_sem);
-		zfcp_rec_dbf_event_thread_lock("erthrd2", adapter);
 	}
 
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);

