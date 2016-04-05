From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v4 1/2] scsi: Add intermediate STARGET_REMOVE state to scsi_target_state
Date: Tue,  5 Apr 2016 11:50:44 +0200
Message-ID: <95ae7ee32dca23bb7f3ab432046fb7016b341049.1459848136.git.jthumshirn@suse.de>
References: <cover.1459848136.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1459848136.git.jthumshirn@suse.de>
In-Reply-To: <cover.1459848136.git.jthumshirn@suse.de>
References: <cover.1459848136.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Ewan D. Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add intermediate STARGET_REMOVE state to scsi_target_state to avoid
running into the BUG_ON() in scsi_target_reap(). The STARGET_REMOVE
state is only valid in the path from scsi_remove_target() to
scsi_target_destroy() indicating this target is going to be removed.

This re-fixes the problem introduced in commits
bc3f02a795d3b4faa99d37390174be2a75d091bd  and
40998193560dab6c3ce8d25f4fa58a23e252ef38 in a more comprehensive way.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Fixes: 40998193560dab6c3ce8d25f4fa58a23e252ef38
Cc: stable@vger.kernel.org
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: James Bottomley <jejb@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_scan.c   | 2 ++
 drivers/scsi/scsi_sysfs.c  | 2 ++
 include/scsi/scsi_device.h | 1 +
 3 files changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 6a82066..63b8bca 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -315,6 +315,8 @@ static void scsi_target_destroy(struct scsi_target *starget)
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
 	unsigned long flags;
 
+	BUG_ON(starget->state != STARGET_REMOVE &&
+	       starget->state != STARGET_CREATED);
 	starget->state = STARGET_DEL;
 	transport_destroy_device(dev);
 	spin_lock_irqsave(shost->host_lock, flags);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 00bc721..0df82e8 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1279,11 +1279,13 @@ restart:
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_for_each_entry(starget, &shost->__targets, siblings) {
 		if (starget->state == STARGET_DEL ||
+		    starget->state == STARGET_REMOVE ||
 		    starget == last_target)
 			continue;
 		if (starget->dev.parent == dev || &starget->dev == dev) {
 			kref_get(&starget->reap_ref);
 			last_target = starget;
+			starget->state = STARGET_REMOVE;
 			spin_unlock_irqrestore(shost->host_lock, flags);
 			__scsi_remove_target(starget);
 			scsi_target_reap(starget);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f63a167..2bffaa6 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -240,6 +240,7 @@ scmd_printk(const char *, const struct scsi_cmnd *, const char *, ...);
 enum scsi_target_state {
 	STARGET_CREATED = 1,
 	STARGET_RUNNING,
+	STARGET_REMOVE,
 	STARGET_DEL,
 };
 
-- 
1.8.5.6
