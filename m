From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: make 'state' device attribute pollable
Date: Wed,  9 Aug 2017 15:09:18 +0200
Message-ID: <1502284158-50201-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56617 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752064AbdHINJV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 09:09:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

While the 'state' attribute can (and will) change occasionally,
calling 'poll()' or 'select()' on it fails as sysfs is never
notified that the state has changed.
With this patch calling 'poll()' or 'select()' will work
properly.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_lib.c           | 7 +++++--
 drivers/scsi/scsi_transport_srp.c | 5 ++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 41c19c7..2101cfd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2654,6 +2654,7 @@ void scsi_exit_queue(void)
 
 	}
 	sdev->sdev_state = state;
+	sysfs_notify(&sdev->sdev_gendev.kobj, NULL, "state");
 	return 0;
 
  illegal:
@@ -3074,14 +3075,16 @@ int scsi_internal_device_unblock_nowait(struct scsi_device *sdev,
 	 * offlined states and goose the device queue if successful.
 	 */
 	if ((sdev->sdev_state == SDEV_BLOCK) ||
-	    (sdev->sdev_state == SDEV_TRANSPORT_OFFLINE))
+	    (sdev->sdev_state == SDEV_TRANSPORT_OFFLINE)) {
 		sdev->sdev_state = new_state;
-	else if (sdev->sdev_state == SDEV_CREATED_BLOCK) {
+		sysfs_notify(&sdev->sdev_gendev.kobj, NULL, "state");
+	} else if (sdev->sdev_state == SDEV_CREATED_BLOCK) {
 		if (new_state == SDEV_TRANSPORT_OFFLINE ||
 		    new_state == SDEV_OFFLINE)
 			sdev->sdev_state = new_state;
 		else
 			sdev->sdev_state = SDEV_CREATED;
+		sysfs_notify(&sdev->sdev_gendev.kobj, NULL, "state");
 	} else if (sdev->sdev_state != SDEV_CANCEL &&
 		 sdev->sdev_state != SDEV_OFFLINE)
 		return -EINVAL;
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index f617021..698cc46 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -556,8 +556,11 @@ int srp_reconnect_rport(struct srp_rport *rport)
 		 */
 		shost_for_each_device(sdev, shost) {
 			mutex_lock(&sdev->state_mutex);
-			if (sdev->sdev_state == SDEV_OFFLINE)
+			if (sdev->sdev_state == SDEV_OFFLINE) {
 				sdev->sdev_state = SDEV_RUNNING;
+				sysfs_notify(&sdev->sdev_gendev.kobj,
+					     NULL, "state");
+			}
 			mutex_unlock(&sdev->state_mutex);
 		}
 	} else if (rport->state == SRP_RPORT_RUNNING) {
-- 
1.8.5.6
