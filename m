From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 2/2] Restart list search after unlock in scsi_remove_target
Date: Fri, 30 Oct 2015 15:09:28 -0700
Message-ID: <5633EA98.8050604@sandisk.com>
References: <5633E9F2.5080209@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0087.outbound.protection.outlook.com ([207.46.100.87]:14693
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031208AbbJ3WJd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 18:09:33 -0400
In-Reply-To: <5633E9F2.5080209@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

When dropping a lock while iterating a list we must restart the search
as other threads could have manipulated the list under us. Without this
we can get stuck in an endless loop.

This is a slightly modified version of a patch from Christoph Hellwig
(see also https://www.spinics.net/lists/linux-scsi/msg89416.html).

Reported-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: stable <stable@vger.kernel.org>
---
 drivers/scsi/scsi_sysfs.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b9fb61a..5a183d1 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1158,32 +1158,24 @@ static void __scsi_remove_target(struct scsi_target *starget)
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
 		if (starget->reaped)
 			continue;
 		if (starget->dev.parent == dev || &starget->dev == dev) {
-			/* assuming new targets arrive at the end */
 			kref_get(&starget->reap_ref);
 			starget->reaped = true;
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
 
-- 
2.6.2.307.g37023ba

