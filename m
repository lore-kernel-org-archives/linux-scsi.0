From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: fixup kernel warning during rmmod()
Date: Wed,  4 Oct 2017 10:28:56 +0200
Message-ID: <1507105736-19148-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56520 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751819AbdJDI27 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Oct 2017 04:28:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Calling rmmod() on a FC driver will results in warnings like

WARNING: CPU: 60 PID: 14640 at fs/sysfs/group.c:237 device_del+0x54/0x240()
sysfs group ffffffff81eff140 not found for kobject '3:0:0:3'

The problem here is that during scsi_remove_target() we will iterate
over all devices, but fail to remove any of those as the call to
scsi_device_get() fails the check to module_is_live().
Hence the devices will not be removed at this point, but all
intermediate structures like fc rport etc. will be.
Later on during scsi_forget_host() the devices are removed for
real, but the device parent is already removed and causes
this warning.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_sysfs.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 1889761..995539f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1336,13 +1336,19 @@ static void __scsi_remove_target(struct scsi_target *starget)
 	spin_lock_irqsave(shost->host_lock, flags);
  restart:
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
+		/*
+		 * We cannot call scsi_device_get() here, as
+		 * we might've been called from rmmod() causing
+		 * scsi_device_get() to fail the module_is_live()
+		 * check.
+		 */
 		if (sdev->channel != starget->channel ||
 		    sdev->id != starget->id ||
-		    scsi_device_get(sdev))
+		    !get_device(&sdev->sdev_gendev))
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_remove_device(sdev);
-		scsi_device_put(sdev);
+		put_device(&sdev->sdev_gendev);
 		spin_lock_irqsave(shost->host_lock, flags);
 		goto restart;
 	}
-- 
1.8.5.6
