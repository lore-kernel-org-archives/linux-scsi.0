From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 24/24] uas: Add response iu handling
Date: Sat, 13 Sep 2014 12:26:51 +0200
Message-ID: <1410604011-3828-25-git-send-email-hdegoede@redhat.com>
References: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbaIMK1d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Sep 2014 06:27:33 -0400
In-Reply-To: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

If something goes wrong in our communication with an uas device we may get
a response iu in reaction to a cmnd, rather then a status iu. In this case
propagate an error upwards, rather then logging a bogus iu message.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 1dcaeee..bebf861 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -328,6 +328,16 @@ static void uas_stat_cmplt(struct urb *urb)
 		}
 		uas_xfer_data(urb, cmnd, SUBMIT_DATA_OUT_URB);
 		break;
+	case IU_ID_RESPONSE:
+		uas_log_cmd_state(cmnd, "unexpected response iu",
+				  ((struct response_iu *)iu)->response_code);
+		/* Error, cancel data transfers */
+		data_in_urb = usb_get_urb(cmdinfo->data_in_urb);
+		data_out_urb = usb_get_urb(cmdinfo->data_out_urb);
+		cmdinfo->state &= ~COMMAND_INFLIGHT;
+		cmnd->result = DID_ERROR << 16;
+		uas_try_complete(cmnd, __func__);
+		break;
 	default:
 		uas_log_cmd_state(cmnd, "bogus IU", iu->iu_id);
 	}
-- 
2.1.0

