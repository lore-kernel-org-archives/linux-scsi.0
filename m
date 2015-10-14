From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 3/3]  SCSI: Rework list handling in __scsi_target_remove
Date: Wed, 14 Oct 2015 15:50:08 +0200
Message-ID: <1cfe37e6cb89ede18c88e60578d4293a6eb7430b.1444829611.git.jthumshirn@suse.de>
References: <cover.1444829611.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1444829611.git.jthumshirn@suse.de>
In-Reply-To: <cover.1444829611.git.jthumshirn@suse.de>
References: <cover.1444829611.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Rework the list handling in __scsi_target_remove(). The new version introduces
a reap list for devices. Devices that shall be removed are placed on the reap
list and can then be removed later on.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_sysfs.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b41dcb3..2bd88c6 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1129,20 +1129,24 @@ static void __scsi_remove_target(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	unsigned long flags;
-	struct scsi_device *sdev;
+	struct scsi_device *sdev, *tmp;
+	LIST_HEAD(reap_list);
 
 	spin_lock_irqsave(&shost->device_lock, flags);
  restart:
-	list_for_each_entry(sdev, &shost->__devices, siblings) {
+	list_for_each_entry_safe(sdev, tmp, &shost->__devices, siblings) {
 		if (sdev->channel != starget->channel ||
 		    sdev->id != starget->id ||
 		    scsi_device_get(sdev))
 			continue;
-		scsi_remove_device(sdev);
+		list_move_tail(&sdev->siblings, &reap_list);
 		scsi_device_put(sdev);
 		goto restart;
 	}
 	spin_unlock_irqrestore(&shost->device_lock, flags);
+
+	list_for_each_entry_safe(sdev, tmp, &reap_list, siblings)
+		scsi_remove_device(sdev);
 }
 
 /**
-- 
1.8.5.6
