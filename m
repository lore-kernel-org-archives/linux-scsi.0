From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 17/21] uas: Do not log urb status error on cancellation
Date: Wed, 10 Sep 2014 13:46:47 +0200
Message-ID: <1410349611-17573-18-git-send-email-hdegoede@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Check for both type of cancellation codes for sense and data urbs.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 685eb37..46b8788 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -315,10 +315,7 @@ static void uas_stat_cmplt(struct urb *urb)
 		goto out;
 
 	if (urb->status) {
-		if (urb->status == -ENOENT) {
-			dev_err(&urb->dev->dev, "stat urb: killed, stream %d\n",
-				urb->stream_id);
-		} else {
+		if (urb->status != -ENOENT && urb->status != -ECONNRESET) {
 			dev_err(&urb->dev->dev, "stat urb: status %d\n",
 				urb->status);
 		}
@@ -425,7 +422,7 @@ static void uas_data_cmplt(struct urb *urb)
 	}
 
 	if (urb->status) {
-		if (urb->status != -ECONNRESET) {
+		if (urb->status != -ENOENT && urb->status != -ECONNRESET) {
 			uas_log_cmd_state(cmnd, __func__);
 			scmd_printk(KERN_ERR, cmnd,
 				"data cmplt err %d stream %d\n",
-- 
2.1.0
