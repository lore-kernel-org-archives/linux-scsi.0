From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 17/24] uas: Do not log urb status error on cancellation
Date: Sat, 13 Sep 2014 12:26:44 +0200
Message-ID: <1410604011-3828-18-git-send-email-hdegoede@redhat.com>
References: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbaIMK1W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Sep 2014 06:27:22 -0400
In-Reply-To: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

Check for both type of cancellation codes for sense and data urbs.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 187e7bf..90afe4a 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -318,10 +318,7 @@ static void uas_stat_cmplt(struct urb *urb)
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
@@ -428,7 +425,7 @@ static void uas_data_cmplt(struct urb *urb)
 	}
 
 	if (urb->status) {
-		if (urb->status != -ECONNRESET) {
+		if (urb->status != -ENOENT && urb->status != -ECONNRESET) {
 			uas_log_cmd_state(cmnd, __func__);
 			scmd_printk(KERN_ERR, cmnd,
 				"data cmplt err %d stream %d\n",
-- 
2.1.0

