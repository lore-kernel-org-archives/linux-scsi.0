From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 2/3] SCSI: Rework list handling in scsi_target_remove
Date: Wed, 14 Oct 2015 15:50:07 +0200
Message-ID: <b43bba6ec61bae1166bd4f9677450117bf5cde0e.1444829611.git.jthumshirn@suse.de>
References: <cover.1444829611.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1444829611.git.jthumshirn@suse.de>
In-Reply-To: <cover.1444829611.git.jthumshirn@suse.de>
References: <cover.1444829611.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Rework the list handling in scsi_target_remove(). The new version introduces a
reap list for targets. Targets that shall be removed are placed on the reap
list and can then be reaped later on.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_sysfs.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d7afea9..b41dcb3 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1156,31 +1156,28 @@ static void __scsi_remove_target(struct scsi_target *starget)
 void scsi_remove_target(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
-	struct scsi_target *starget, *last = NULL;
+	struct scsi_target *starget, *tmp;
 	unsigned long flags;
+	LIST_HEAD(reap_list);
 
 	/* remove targets being careful to lookup next entry before
 	 * deleting the last
 	 */
 	spin_lock_irqsave(&shost->target_lock, flags);
-	list_for_each_entry(starget, &shost->__targets, siblings) {
+	list_for_each_entry_safe(starget, tmp, &shost->__targets, siblings) {
 		if (starget->state == STARGET_DEL)
 			continue;
 		if (starget->dev.parent == dev || &starget->dev == dev) {
-			/* assuming new targets arrive at the end */
 			kref_get(&starget->reap_ref);
-			spin_unlock_irqrestore(&shost->target_lock, flags);
-			if (last)
-				scsi_target_reap(last);
-			last = starget;
-			__scsi_remove_target(starget);
-			spin_lock_irqsave(&shost->target_lock, flags);
+			list_move_tail(&starget->siblings, &reap_list);
 		}
 	}
 	spin_unlock_irqrestore(&shost->target_lock, flags);
 
-	if (last)
-		scsi_target_reap(last);
+	list_for_each_entry_safe(starget, tmp, &reap_list, siblings) {
+		__scsi_remove_target(starget);
+		scsi_target_reap(starget);
+	}
 }
 EXPORT_SYMBOL(scsi_remove_target);
 
-- 
1.8.5.6
