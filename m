From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 02/13] zfcp: Acquire qdio_stat_lock when reading the queue utilization
Date: Mon, 13 Jul 2009 15:06:03 +0200
Message-ID: <20090713131042.886390000@de.ibm.com>
References: <20090713130601.304914000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:36193 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbZGMNKz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2009 09:10:55 -0400
Content-Disposition: inline; filename=707-zfcp-qdio_stat_lock.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

req_q_util is not atomic, so the qdio_stat_lock must be held when
reading this variable.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_sysfs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_sysfs.c linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c
--- linux-2.6/drivers/s390/scsi/zfcp_sysfs.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c	2009-07-12 21:08:58.000000000 +0200
@@ -494,9 +494,14 @@ static ssize_t zfcp_sysfs_adapter_q_full
 	struct Scsi_Host *scsi_host = class_to_shost(dev);
 	struct zfcp_adapter *adapter =
 		(struct zfcp_adapter *) scsi_host->hostdata[0];
+	u64 util;
+
+	spin_lock_bh(&adapter->qdio_stat_lock);
+	util = adapter->req_q_util;
+	spin_unlock_bh(&adapter->qdio_stat_lock);
 
 	return sprintf(buf, "%d %llu\n", atomic_read(&adapter->qdio_outb_full),
-		       (unsigned long long)adapter->req_q_util);
+		       (unsigned long long)util);
 }
 static DEVICE_ATTR(queue_full, S_IRUGO, zfcp_sysfs_adapter_q_full_show, NULL);
 

