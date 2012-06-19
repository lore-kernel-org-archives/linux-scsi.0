From: Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 5/7] uas: improve error handling
Date: Tue, 19 Jun 2012 09:54:52 +0200
Message-ID: <1340092494-18876-6-git-send-email-kraxel@redhat.com>
References: <1340092494-18876-1-git-send-email-kraxel@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab2FSHy6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jun 2012 03:54:58 -0400
In-Reply-To: <1340092494-18876-1-git-send-email-kraxel@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>

(1) Handle data pipe errors: When the data urb failed we
    didn't transfer anything, update scsi_cmnd accordingly.
(2) Cancel data transfers when we got back an error on the
    status pipe.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/usb/storage/uas.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index b589b2e..d8b7bc6 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -242,6 +242,13 @@ static void uas_stat_cmplt(struct urb *urb)
 			uas_sense_old(urb, cmnd);
 		else
 			uas_sense(urb, cmnd);
+		if (cmnd->result != 0) {
+			/* cancel data transfers on error */
+			if (cmdinfo->state & DATA_IN_URB_INFLIGHT)
+				usb_unlink_urb(cmdinfo->data_in_urb);
+			if (cmdinfo->state & DATA_OUT_URB_INFLIGHT)
+				usb_unlink_urb(cmdinfo->data_out_urb);
+		}
 		cmdinfo->state &= ~COMMAND_INFLIGHT;
 		uas_try_complete(cmnd, __func__);
 		break;
@@ -272,7 +279,12 @@ static void uas_data_cmplt(struct urb *urb)
 		cmdinfo->state &= ~DATA_OUT_URB_INFLIGHT;
 	}
 	BUG_ON(sdb == NULL);
-	sdb->resid = sdb->length - urb->actual_length;
+	if (urb->status) {
+		/* error: no data transfered */
+		sdb->resid = sdb->length;
+	} else {
+		sdb->resid = sdb->length - urb->actual_length;
+	}
 	uas_try_complete(cmnd, __func__);
 }
 
-- 
1.7.1

