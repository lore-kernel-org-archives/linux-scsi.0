From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [RESEND PATCH v2 1/2] Revert "scsi: fix soft lockup in scsi_remove_target() on module removal"
Date: Wed, 30 Mar 2016 09:09:52 +0200
Message-ID: <1d6331c085cbf189b2ead0baf92646068768c81c.1459249252.git.jthumshirn__19728.8090516397$1459322117$gmane$org@suse.de>
References: <cover.1459249252.git.jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbcC3HJ6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2016 03:09:58 -0400
In-Reply-To: <cover.1459249252.git.jthumshirn@suse.de>
In-Reply-To: <cover.1459249252.git.jthumshirn@suse.de>
References: <cover.1459249252.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Ewan D. Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org

This reverts commit 90a88d6ef88edcfc4f644dddc7eef4ea41bccf8b.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: stable@vger.kernel.org
---
 drivers/scsi/scsi_sysfs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 00bc721..4f18a85 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1272,18 +1272,16 @@ static void __scsi_remove_target(struct scsi_target *starget)
 void scsi_remove_target(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
-	struct scsi_target *starget, *last_target = NULL;
+	struct scsi_target *starget;
 	unsigned long flags;
 
 restart:
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_for_each_entry(starget, &shost->__targets, siblings) {
-		if (starget->state == STARGET_DEL ||
-		    starget == last_target)
+		if (starget->state == STARGET_DEL)
 			continue;
 		if (starget->dev.parent == dev || &starget->dev == dev) {
 			kref_get(&starget->reap_ref);
-			last_target = starget;
 			spin_unlock_irqrestore(shost->host_lock, flags);
 			__scsi_remove_target(starget);
 			scsi_target_reap(starget);
-- 
1.8.5.6

