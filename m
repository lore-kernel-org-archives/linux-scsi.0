From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi: restart list search after unlock in
	scsi_remove_target
Date: Mon, 19 Oct 2015 16:35:46 +0200
Message-ID: <20151019143546.GA7486@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53904 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbbJSOfu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2015 10:35:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: jthumshirn@suse.de

When dropping a lock while iterating a list we must restart the search
as other threads could have manipulated the list under us.  Without this
we can get stuck in an endless loop.

Reported-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b333389f..d3b34d8 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1158,31 +1158,23 @@ static void __scsi_remove_target(struct scsi_target *starget)
 void scsi_remove_target(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
-	struct scsi_target *starget, *last = NULL;
+	struct scsi_target *starget;
 	unsigned long flags;
 
-	/* remove targets being careful to lookup next entry before
-	 * deleting the last
-	 */
+restart:
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_for_each_entry(starget, &shost->__targets, siblings) {
 		if (starget->state == STARGET_DEL)
 			continue;
 		if (starget->dev.parent == dev || &starget->dev == dev) {
-			/* assuming new targets arrive at the end */
 			kref_get(&starget->reap_ref);
 			spin_unlock_irqrestore(shost->host_lock, flags);
-			if (last)
-				scsi_target_reap(last);
-			last = starget;
 			__scsi_remove_target(starget);
-			spin_lock_irqsave(shost->host_lock, flags);
+			scsi_target_reap(starget);
+			goto restart;
 		}
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	if (last)
-		scsi_target_reap(last);
 }
 EXPORT_SYMBOL(scsi_remove_target);
 
