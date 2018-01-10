From: Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH] uas: Unblock scsi-requests on failure to alloc streams
 in post_reset
Date: Wed, 10 Jan 2018 16:23:35 +0100
Message-ID: <1515597815.2578.2.camel@suse.com>
References: <20180110071323.3183-1-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48870 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751293AbeAJP2Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jan 2018 10:28:25 -0500
In-Reply-To: <20180110071323.3183-1-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, stable@vger.kernel.org

Am Mittwoch, den 10.01.2018, 08:13 +0100 schrieb Hans de Goede:
> If we return 1 from our post_reset handler, then our disconnect handler
> will be called immediately afterwards. Since pre_reset blocks all scsi
> requests our disconnect handler will then hang in the scsi_remove_host
> call.

Hi Hans,

it seems to me that the diagnosis is spot on. But why do we
keep different code paths at all in this case? I do not see
the point of not reporting the reset to the SCSI subsystem,
even if we are not operational afterwards.
So how about something like this?

>From 4d1e26154bc5d09913bfba34d7adc39cce98d20a Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Wed, 10 Jan 2018 16:16:03 +0100
Subject: [PATCH] usb: uas: unconditionally bring back host after reset

Quoting Hans:

If we return 1 from our post_reset handler, then our disconnect handler
will be called immediately afterwards. Since pre_reset blocks all scsi
requests our disconnect handler will then hang in the scsi_remove_host
call.

This is esp. bad because our disconnect handler hanging for ever also
stops the USB subsys from enumerating any new USB devices, causes
commands
like lsusb to hang, etc.

In practice this happens when unplugging some uas devices because the
hub
code may see the device as needing a warm-reset and calls
usb_reset_device
before seeing the disconnect. In this case uas_configure_endpoints
fails
with -ENODEV. We do not want to print an error for this, so this commit
also silences the shost_printk for -ENODEV.

ENDQUOTE

However, if we do that we better drop any unconditional execution
and report to the SCSI subsystem that we have undergone a reset
but we are not operational now.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: Hans de Goede <hdegoede@redhat.com>
---
 Makefile                  | 2 +-
 drivers/usb/storage/uas.c | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 5d04c40ee40a..3b1b9695177a 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -1076,20 +1076,19 @@ static int uas_post_reset(struct usb_interface
*intf)
 		return 0;
 
 	err = uas_configure_endpoints(devinfo);
-	if (err) {
+	if (err && err != ENODEV)
 		shost_printk(KERN_ERR, shost,
 			     "%s: alloc streams error %d after reset",
 			     __func__, err);
-		return 1;
-	}
 
+	/* we must unblock the host in every case lest we deadlock */
 	spin_lock_irqsave(shost->host_lock, flags);
 	scsi_report_bus_reset(shost, 0);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	scsi_unblock_requests(shost);
 
-	return 0;
+	return err ? 1 : 0;
 }
 
 static int uas_suspend(struct usb_interface *intf, pm_message_t
message)
-- 
2.13.6
