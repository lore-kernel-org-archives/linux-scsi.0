From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v4 2/2] Revert "scsi: fix soft lockup in scsi_remove_target() on module removal"
Date: Tue,  5 Apr 2016 11:50:45 +0200
Message-ID: <6fd7396e87d983aa307be2228d364dbe4f34f892.1459848136.git.jthumshirn@suse.de>
References: <cover.1459848136.git.jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbcDEJut (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Apr 2016 05:50:49 -0400
In-Reply-To: <cover.1459848136.git.jthumshirn@suse.de>
In-Reply-To: <cover.1459848136.git.jthumshirn@suse.de>
References: <cover.1459848136.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Ewan D. Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org

Now that we've done a more comprehensive fix with the intermediate
target state we can remove the previous hack introduced with commit
90a88d6ef88edcfc4f644dddc7eef4ea41bccf8b.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: stable@vger.kernel.org
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_sysfs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 0df82e8..9e5f893 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1272,19 +1272,17 @@ static void __scsi_remove_target(struct scsi_target *starget)
 void scsi_remove_target(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
-	struct scsi_target *starget, *last_target = NULL;
+	struct scsi_target *starget;
 	unsigned long flags;
 
 restart:
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_for_each_entry(starget, &shost->__targets, siblings) {
 		if (starget->state == STARGET_DEL ||
-		    starget->state == STARGET_REMOVE ||
-		    starget == last_target)
+		    starget->state == STARGET_REMOVE)
 			continue;
 		if (starget->dev.parent == dev || &starget->dev == dev) {
 			kref_get(&starget->reap_ref);
-			last_target = starget;
 			starget->state = STARGET_REMOVE;
 			spin_unlock_irqrestore(shost->host_lock, flags);
 			__scsi_remove_target(starget);
-- 
1.8.5.6

