From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] usb: storage: Fix a possible data race in uas_queuecommand_lck
Date: Tue,  8 May 2018 15:47:43 +0800
Message-ID: <20180508074743.13622-1-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: oneukum@suse.com, stern@rowland.harvard.edu, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The write operations to "cmnd->result" and "cmnd->scsi_done" 
are protected by the lock on line 642-643, but the write operations 
to these data on line 634-635 are not protected by the lock.
Thus, there may exist a data race for "cmnd->result" 
and "cmnd->scsi_done".

To fix this data race, the write operations on line 634-635 
should be also protected by the lock.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/usb/storage/uas.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 6034c39b67d1..dde7a43ad491 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -627,17 +627,18 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 	if (cmnd->device->host->host_self_blocked)
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 
+	spin_lock_irqsave(&devinfo->lock, flags);
+
 	if ((devinfo->flags & US_FL_NO_ATA_1X) &&
 			(cmnd->cmnd[0] == ATA_12 || cmnd->cmnd[0] == ATA_16)) {
 		memcpy(cmnd->sense_buffer, usb_stor_sense_invalidCDB,
 		       sizeof(usb_stor_sense_invalidCDB));
 		cmnd->result = SAM_STAT_CHECK_CONDITION;
 		cmnd->scsi_done(cmnd);
+		spin_unlock_irqrestore(&devinfo->lock, flags);
 		return 0;
 	}
 
-	spin_lock_irqsave(&devinfo->lock, flags);
-
 	if (devinfo->resetting) {
 		cmnd->result = DID_ERROR << 16;
 		cmnd->scsi_done(cmnd);
-- 
2.17.0
