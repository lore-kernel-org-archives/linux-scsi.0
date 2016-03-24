From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] scsi: Add intermediate STARGET_REMOVE state to scsi_target_state
Date: Thu, 24 Mar 2016 10:56:13 +0100
Message-ID: <1458813373-7477-1-git-send-email-jthumshirn@suse.de>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The target state machine only knows 'STARGET_DEL', which is set once
scsi_target_destroy() is called.
However, by that time the structure is still part of the __stargets
list of the SCSI host, so any concurrent invocation will see this as
a valid target, causing an access to freed memory.

This patch adds an intermediate state 'STARGET_REMOVE', which is set
as soon as the target is scheduled to be removed.
With this any concurrent invocation will be able to skip these
targets and avoid the above scenario.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Fixes: 90a88d6ef 'scsi: fix soft lockup in scsi_remove_target() on module removal'
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_scan.c   | 1 +
 drivers/scsi/scsi_sysfs.c  | 2 ++
 include/scsi/scsi_device.h | 1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 6a82066..37459dfa 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -315,6 +315,7 @@ static void scsi_target_destroy(struct scsi_target *starget)
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
 	unsigned long flags;
 
+	BUG_ON(starget->state != STARGET_REMOVE);
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
