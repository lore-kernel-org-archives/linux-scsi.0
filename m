From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] scsi: make 'state' device attribute pollable
Date: Thu, 10 Aug 2017 09:05:31 +0200
Message-ID: <1502348731-63534-4-git-send-email-hare@suse.de>
References: <1502348731-63534-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41439 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752275AbdHJHFg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 03:05:36 -0400
In-Reply-To: <1502348731-63534-1-git-send-email-hare@suse.de>
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
 drivers/scsi/scsi_lib.c           | 3 +++
 drivers/scsi/scsi_transport_srp.c | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 035aa4c..3abef85 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2655,6 +2655,7 @@ void scsi_exit_queue(void)
 
 	}
 	sdev->sdev_state = state;
+	sysfs_notify(&sdev->sdev_gendev.kobj, NULL, "state");
 	return 0;
 
  illegal:
@@ -3078,6 +3079,7 @@ int scsi_internal_device_unblock_nowait(struct scsi_device *sdev,
 	case SDEV_BLOCK:
 	case SDEV_TRANSPORT_OFFLINE:
 		sdev->sdev_state = new_state;
+		sysfs_notify(&sdev->sdev_gendev.kobj, NULL, "state");
 		break;
 	case SDEV_CREATED_BLOCK:
 		if (new_state == SDEV_TRANSPORT_OFFLINE ||
@@ -3085,6 +3087,7 @@ int scsi_internal_device_unblock_nowait(struct scsi_device *sdev,
 			sdev->sdev_state = new_state;
 		else
 			sdev->sdev_state = SDEV_CREATED;
+		sysfs_notify(&sdev->sdev_gendev.kobj, NULL, "state");
 		break;
 	case SDEV_TRANSPORT_OFFLINE:
 	case SDEV_CANCEL:
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
