From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 08/24] uas: Free data urbs on completion
Date: Sat, 13 Sep 2014 12:26:35 +0200
Message-ID: <1410604011-3828-9-git-send-email-hdegoede@redhat.com>
References: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410604011-3828-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Now that we no longer drop our lock to unlink the data urbs, we can simply
free them on completion, making their handling consistent with the other urbs.

Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/usb/storage/uas.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 68853b5..70b44f0 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -288,8 +288,6 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 		return -EBUSY;
 	WARN_ON_ONCE(cmdinfo->state & COMMAND_COMPLETED);
 	cmdinfo->state |= COMMAND_COMPLETED;
-	usb_free_urb(cmdinfo->data_in_urb);
-	usb_free_urb(cmdinfo->data_out_urb);
 	if (cmdinfo->state & COMMAND_ABORTED)
 		scmd_printk(KERN_INFO, cmnd, "abort completed\n");
 	list_del(&cmdinfo->list);
@@ -418,9 +416,11 @@ static void uas_data_cmplt(struct urb *urb)
 	if (cmdinfo->data_in_urb == urb) {
 		sdb = scsi_in(cmnd);
 		cmdinfo->state &= ~DATA_IN_URB_INFLIGHT;
+		cmdinfo->data_in_urb = NULL;
 	} else if (cmdinfo->data_out_urb == urb) {
 		sdb = scsi_out(cmnd);
 		cmdinfo->state &= ~DATA_OUT_URB_INFLIGHT;
+		cmdinfo->data_out_urb = NULL;
 	}
 	if (sdb == NULL) {
 		WARN_ON_ONCE(1);
@@ -450,6 +450,7 @@ static void uas_data_cmplt(struct urb *urb)
 	}
 	uas_try_complete(cmnd, __func__);
 out:
+	usb_free_urb(urb);
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 }
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
