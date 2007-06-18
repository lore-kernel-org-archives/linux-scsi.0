From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 11/11] State machine cleanup
Date: Mon, 18 Jun 2007 11:02:19 +0200
Message-ID: <20070618090219.28749D44CB@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654AbXFRJCT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jun 2007 05:02:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


sdev state SDEV_DEL should only be entered from SDEV_CANCEL. This way
we'll have a better check if all error paths are covered.
And we should always call scsi_destroy_device() after
scsi_sysfs_remove_sdev().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a97c889..e4d801a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1123,7 +1123,7 @@ static int scsi_probe_and_add_lun(struct
 					scsi_inq_str(mod, result, 16, 32));
 			});
 		}
-		
+
 		res = SCSI_SCAN_TARGET_PRESENT;
 		goto out_free_result;
 	}
@@ -1177,8 +1177,11 @@ static int scsi_probe_and_add_lun(struct
 				res = SCSI_SCAN_NO_RESPONSE;
 			}
 		}
-	} else
+	} else {
+		/* sysfs not attached from scsi_add_lun */
+		scsi_device_set_state(sdev, SDEV_CANCEL);
 		scsi_destroy_device(sdev);
+	}
  out:
 	return res;
 }
@@ -1745,6 +1748,7 @@ static void scsi_sysfs_add_devices(struc
 	struct scsi_device *sdev;
 	shost_for_each_device(sdev, shost) {
 		if (scsi_sysfs_add_sdev(sdev) != 0)
+			scsi_device_set_state(sdev, SDEV_CANCEL);
 			scsi_destroy_device(sdev);
 	}
 }
@@ -1890,8 +1894,10 @@ void scsi_forget_host(struct Scsi_Host *
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->sdev_state == SDEV_DEL)
 			continue;
+		scsi_device_set_state(sdev, SDEV_CANCEL);
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_sysfs_remove_sdev(sdev);
+		scsi_destroy_device(sdev);
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -1959,6 +1965,7 @@ void scsi_free_host_dev(struct scsi_devi
 {
 	BUG_ON(sdev->id != sdev->host->this_id);
 
+	scsi_device_set_state(SDEV_CANCEL);
 	scsi_destroy_device(sdev);
 }
 EXPORT_SYMBOL(scsi_free_host_dev);
-- 
1.4.3.4

