From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 10/21] uas: zap_pending: data urbs should have completed at this time
Date: Wed, 10 Sep 2014 13:46:40 +0200
Message-ID: <1410349611-17573-11-git-send-email-hdegoede@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410349611-17573-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The data urbs are all killed before calling zap_pending, and their completion
handler should have cleared their inflight flag.

Do not 0 the data inflight flags, and add a check for try_complete succeeding,
as it should always succeed when called from zap_pending.

Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/usb/storage/uas.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index bba5498..ec6547d 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -150,12 +150,10 @@ static void uas_zap_pending(struct uas_dev_info *devinfo, int result)
 		struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd,
 						      SCp);
 		uas_log_cmd_state(cmnd, __func__);
-		/* all urbs are killed, clear inflight bits */
-		cmdinfo->state &= ~(COMMAND_INFLIGHT |
-				    DATA_IN_URB_INFLIGHT |
-				    DATA_OUT_URB_INFLIGHT);
+		/* Sense urbs were killed, clear COMMAND_INFLIGHT manually */
+		cmdinfo->state &= ~COMMAND_INFLIGHT;
 		cmnd->result = result << 16;
-		uas_try_complete(cmnd, __func__);
+		WARN_ON(uas_try_complete(cmnd, __func__) != 0);
 	}
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 }
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
