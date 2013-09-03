From: Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 2/5] uas: properly reinitialize in uas_eh_bus_reset_handler
Date: Tue,  3 Sep 2013 15:46:42 +0200
Message-ID: <1378216005-10326-3-git-send-email-kraxel@redhat.com>
References: <1378216005-10326-1-git-send-email-kraxel@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1378216005-10326-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-usb@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "open list:USB ATTACHED SCSI" <linux-scsi@vger.kernel.org>, "open list:USB MASS STORAGE..." <usb-storage@lists.one-eyed-alien.net>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/usb/storage/uas.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index d966b59..fc08ee9 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -85,6 +85,8 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 				struct uas_dev_info *devinfo, gfp_t gfp);
 static void uas_do_work(struct work_struct *work);
 static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller);
+static void uas_configure_endpoints(struct uas_dev_info *devinfo);
+static void uas_free_streams(struct uas_dev_info *devinfo);
 
 static DECLARE_WORK(uas_work, uas_do_work);
 static DEFINE_SPINLOCK(uas_work_lock);
@@ -800,7 +802,10 @@ static int uas_eh_bus_reset_handler(struct scsi_cmnd *cmnd)
 	usb_kill_anchored_urbs(&devinfo->cmd_urbs);
 	usb_kill_anchored_urbs(&devinfo->sense_urbs);
 	usb_kill_anchored_urbs(&devinfo->data_urbs);
+	uas_free_streams(devinfo);
 	err = usb_reset_device(udev);
+	if (!err)
+		uas_configure_endpoints(devinfo);
 	devinfo->resetting = 0;
 
 	if (err) {
-- 
1.8.3.1
