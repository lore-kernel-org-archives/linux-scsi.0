From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] USB: uas: Fix slave queue_depth not being set
Date: Mon, 23 May 2016 13:49:18 +0200
Message-ID: <1464004158-3062-1-git-send-email-hdegoede@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Commit 198de51dbc34 ("USB: uas: Limit qdepth at the scsi-host level")
removed the scsi_change_queue_depth() call from uas_slave_configure()
assuming that the slave would inherit the host's queue_depth, which
that commit sets to the same value.

This is incorrect, without the scsi_change_queue_depth() call the slave's
queue_depth defaults to 1, introducing a performance regression.

This commit restores the call, fixing the performance regression.

Cc: stable@vger.kernel.org
Fixes: 198de51dbc34 ("USB: uas: Limit qdepth at the scsi-host level")
Reported-by: Tom Yan <tom.ty89@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 16bc679..ecc7d4b 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -835,6 +835,7 @@ static int uas_slave_configure(struct scsi_device *sdev)
 	if (devinfo->flags & US_FL_BROKEN_FUA)
 		sdev->broken_fua = 1;
 
+	scsi_change_queue_depth(sdev, devinfo->qdepth - 2);
 	return 0;
 }
 
-- 
2.7.4
