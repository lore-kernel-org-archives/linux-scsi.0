From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] [SCSI] Wake blockdev queue in scsi_internal_device_unblock() for SDEV_RUNNING
Date: Mon, 25 Feb 2013 09:55:05 -0800
Message-ID: <1361814905-7201-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:43397 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751924Ab3BYRzM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2013 12:55:12 -0500
Received: by mail-da0-f72.google.com with SMTP id k18so4053640dae.3
        for <linux-scsi@vger.kernel.org>; Mon, 25 Feb 2013 09:55:11 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

If a SCSI device's old state is already SDEV_RUNNING and we're moving
to the same SDEV_RUNNING state, still wake the blockdev queue in
scsi_internal_device_unblock().  This fixes a case where we silently
hang SCSI commands forever during device discovery.  One way this can
happen is when mpt2sas is discovering a reasonably big SAS topology,
and the sd driver has queued up a bunch of sd_probe_async() instances
that are queueing SCSI commands to various devices.

If at the same time a SAS fabric event goes to the HBA, what can
happen is the following:

     - mpt2sas calls _scsih_block_io_all_device() -> scsi_internal_device_block(sdev)

       (In response to some HBA firmware event like MPI2_EVENT_SAS_BROADCAST_PRIMITIVE)
       Now sdev state is SDEV_BLOCK and blockdev queue has QUEUE_FLAG_STOPPED set.

     - Someone like scsi_add_lun() calls scsi_device_set_state(sdev, SDEV_RUNNING)

       (SCSI bus scanning runs asynchronously to firmware event handling)
       Now sdev state is SDEV_RUNNING but blockdev queue still has QUEUE_FLAG_STOPPED set

     - mpt2sas calls _scsih_ublock_io_all_device() -> scsi_internal_device_unblock(sdev, SDEV_RUNNING)

       (Finishes handling the firmware event)

With the old scsi_lib code, scsi_internal_device_unblock() will return
an error at this point because the sdev state is already SDEV_RUNNING.
This means we skip the call to blk_start_queue() and never actually
start executing commands again.

Fix this by still going ahead and finishing scsi_internal_device_unblock()
even if the sdev state is already SDEV_RUNNING.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/scsi_lib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 765398c..75108ea 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2495,7 +2495,9 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
 		else
 			sdev->sdev_state = SDEV_CREATED;
 	} else if (sdev->sdev_state != SDEV_CANCEL &&
-		 sdev->sdev_state != SDEV_OFFLINE)
+		   sdev->sdev_state != SDEV_OFFLINE &&
+		   (sdev->sdev_state != SDEV_RUNNING ||
+		    new_state != SDEV_RUNNING))
 		return -EINVAL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-- 
1.8.1.2

