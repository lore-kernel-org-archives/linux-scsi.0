From: Tejun Heo <tj@kernel.org>
Subject: [PATCH] SCSI: kill compat SDEV_MEDIA_CHANGE event
Date: Tue, 28 Dec 2010 16:20:47 +0100
Message-ID: <20101228152047.GJ488@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f66.google.com ([209.85.214.66]:45813 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab0L1PUw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Dec 2010 10:20:52 -0500
Received: by bwz7 with SMTP id 7so3810196bwz.1
        for <linux-scsi@vger.kernel.org>; Tue, 28 Dec 2010 07:20:50 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Kay Sievers <kay.sievers@vrfy.org>

SDEV_MEDIA_CHANGE event was first added by commit a341cd0f (SCSI: add
asynchronous event notification API) for SATA AN support and then
extended to cover generic media change events by commit 285e9670
([SCSI] sr,sd: send media state change modification events).

This event was mapped to block device in userland with all properties
stripped to simulate CHANGE event on the block device, which, in turn,
was used to trigger further userspace action on media change.

The recent addition of disk event framework kept this event for
backward compatibility but it turns out to be unnecessary and causes
erratic and inefficient behavior.  The new disk event generates proper
events on the block devices and the compat events are mapped to block
device with all properties stripped, so the block device ends up
generating multiple duplicate events for single actual event.

This patch removes the compat event generation from both sr and sd as
suggested by Kay Sievers.  Both existing and newer versions of udev
and the associated tools will behave better with the removal of these
events as they from the beginning were expecting events on the block
devices.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/scsi/sd.c |    5 -----
 drivers/scsi/sr.c |    4 ----
 2 files changed, 9 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7d25746..e567302 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1086,13 +1086,8 @@ out:
 	 *
 	 *	Medium present state has changed in either direction.
 	 *	Device has indicated UNIT_ATTENTION.
-	 *
-	 * Report SDEV_EVT_MEDIA_CHANGE too for backward compatibility.
 	 */
-	if (sdp->changed)
-		sdev_evt_send_simple(sdp, SDEV_EVT_MEDIA_CHANGE, GFP_KERNEL);
 	kfree(sshdr);
-
 	retval = sdp->changed ? DISK_EVENT_MEDIA_CHANGE : 0;
 	sdp->changed = 0;
 	return retval;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index be6baf8..aefadc6 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -249,10 +249,6 @@ skip_tur:
 		cd->device->changed = 0;
 	}
 
-	/* for backward compatibility */
-	if (events & DISK_EVENT_MEDIA_CHANGE)
-		sdev_evt_send_simple(cd->device, SDEV_EVT_MEDIA_CHANGE,
-				     GFP_KERNEL);
 	return events;
 }
 
