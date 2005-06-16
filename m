From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 5/5] scsi host / scsi target state model update
Date: Thu, 16 Jun 2005 11:16:11 -0700
Message-ID: <20050616181611.GF20923@us.ibm.com>
References: <20050616181058.GA20923@us.ibm.com> <20050616181238.GB20923@us.ibm.com> <20050616181342.GC20923@us.ibm.com> <20050616181433.GD20923@us.ibm.com> <20050616181518.GE20923@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:15836 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S261789AbVFPSPo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2005 14:15:44 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j5GIFg2h407390
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 14:15:42 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5GIFge9170266
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 12:15:42 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j5GIFfVL014870
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 12:15:41 -0600
Received: from hmsbounty.us.ibm.com (sig-9-48-50-108.mts.ibm.com [9.48.50.108])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j5GIFfV8014820
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 12:15:41 -0600
Content-Disposition: inline
In-Reply-To: <20050616181518.GE20923@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Use new SCSI target state model in scsi_forget_host to help with list
traversal and deletion of devices.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
---

 linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_scan.c  |   32 +++++++++--------
 linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_sysfs.c |    1 
 2 files changed, 18 insertions(+), 15 deletions(-)

diff -puN drivers/scsi/scsi_scan.c~tgt_remove drivers/scsi/scsi_scan.c
--- linux-2.6.12-rc6-mm1/drivers/scsi/scsi_scan.c~tgt_remove	2005-06-16 10:48:38.000000000 -0700
+++ linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_scan.c	2005-06-16 10:48:38.000000000 -0700
@@ -1414,25 +1414,27 @@ EXPORT_SYMBOL(scsi_scan_single_target);
 
 void scsi_forget_host(struct Scsi_Host *shost)
 {
-	struct scsi_target *starget, *tmp;
+	struct scsi_target *starget;
 	unsigned long flags;
 
-	/*
-	 * Ok, this look a bit strange.  We always look for the first device
-	 * on the list as scsi_remove_device removes them from it - thus we
-	 * also have to release the lock.
-	 * We don't need to get another reference to the device before
-	 * releasing the lock as we already own the reference from
-	 * scsi_register_device that's release in scsi_remove_device.  And
-	 * after that we don't look at sdev anymore.
-	 */
-	spin_lock_irqsave(shost->host_lock, flags);
-	list_for_each_entry_safe(starget, tmp, &shost->__targets, siblings) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		scsi_remove_target(&starget->dev);
+	while (1) {
+		starget = NULL;
 		spin_lock_irqsave(shost->host_lock, flags);
+		list_for_each_entry(starget, &shost->__targets, siblings) {
+			if (starget->stgt_state == STGT_DEL)
+				continue;
+			if (starget->stgt_state != STGT_CANCEL) {
+				scsi_target_set_state(starget, STGT_CANCEL);
+				break;
+			}
+		}
+		spin_unlock_irqrestore(shost->host_lock, flags);
+
+		if (starget && starget->stgt_state != STGT_DEL)
+			scsi_remove_target(&starget->dev);
+		else
+			return;
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
 /*
diff -puN drivers/scsi/scsi_sysfs.c~tgt_remove drivers/scsi/scsi_sysfs.c
--- linux-2.6.12-rc6-mm1/drivers/scsi/scsi_sysfs.c~tgt_remove	2005-06-16 10:48:38.000000000 -0700
+++ linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_sysfs.c	2005-06-16 10:48:38.000000000 -0700
@@ -750,6 +750,7 @@ void __scsi_remove_target(struct scsi_ta
 		scsi_remove_device(sdev);
 		spin_lock_irqsave(shost->host_lock, flags);
 	}
+	scsi_target_set_state(starget, STGT_DEL);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	scsi_target_reap(starget);
 }
_
