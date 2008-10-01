From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 11/13] zfcp: fix erp list usage without using locks
Date: Wed, 01 Oct 2008 12:42:24 +0200
Message-ID: <20081001104804.968111000@de.ibm.com>
References: <20081001104213.585200000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:33717 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYJAKsK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 06:48:10 -0400
Content-Disposition: inline; filename=zfcp_use_dbf_lock_version.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The zfcp_erp_thread was using the nolock version of the dbf function.
This resulted in a list access while other tasks could modifying the
list. The symptom was an erp thread running at 100% CPU and never
returning from the dbf function.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_erp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_erp.c	2008-09-30 13:52:22.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-09-30 13:52:30.000000000 +0200
@@ -1395,9 +1395,9 @@ static int zfcp_erp_thread(void *data)
 				zfcp_erp_wakeup(adapter);
 		}
 
-		zfcp_rec_dbf_event_thread(4, adapter);
+		zfcp_rec_dbf_event_thread_lock(4, adapter);
 		down_interruptible(&adapter->erp_ready_sem);
-		zfcp_rec_dbf_event_thread(5, adapter);
+		zfcp_rec_dbf_event_thread_lock(5, adapter);
 	}
 
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);

-- 
