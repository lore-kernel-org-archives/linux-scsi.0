From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] usb-storage: implement autosuspend
Date: Wed, 28 Jul 2010 17:12:39 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1007281702030.1744-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59202 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752580Ab0G1VMm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2010 17:12:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Greg KH <greg@kroah.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

This patch (as1400) adds runtime-PM support to usb-storage.  It
utilizes the SCSI layer's runtime-PM implementation, so its scope is
limited.  Currently the only effect is that disk-like devices (such as
card readers or flash drives) will be autosuspended if they aren't
mounted and their device files aren't open.  This would apply, for
example, to card readers that don't contain a memory card.

Unfortunately this won't interact very well with the removable-media
polling normally carried out by hal or DeviceKit.  Maybe those
programs can be changed to use a longer polling interval, or maybe the
default autosuspend time for usb-storage should be set to something
below 1 second.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Now that the SCSI runtime-PM patches have been accepted for the 
upcoming merge window, it's time to make use of the new mechanism in 
usb-storage.  That's what this does.

Because this patch depends on those SCSI changes, either it should also 
go via James's tree or else the SCSI patches should be imported into 
Greg's tree first.  James and Greg, which route is easier for you?

Alan Stern



Index: usb-2.6/drivers/usb/storage/usb.c
===================================================================
--- usb-2.6.orig/drivers/usb/storage/usb.c
+++ usb-2.6/drivers/usb/storage/usb.c
@@ -336,6 +336,7 @@ static int usb_stor_control_thread(void 
 		else {
 			US_DEBUG(usb_stor_show_command(us->srb));
 			us->proto_handler(us->srb, us);
+			usb_mark_last_busy(us->pusb_dev);
 		}
 
 		/* lock access to the state */
@@ -845,6 +846,7 @@ static int usb_stor_scan_thread(void * _
 		/* Should we unbind if no devices were detected? */
 	}
 
+	usb_autopm_put_interface(us->pusb_intf);
 	complete_and_exit(&us->scanning_done, 0);
 }
 
@@ -968,6 +970,7 @@ int usb_stor_probe2(struct us_data *us)
 		goto BadDevice;
 	}
 
+	usb_autopm_get_interface_no_resume(us->pusb_intf);
 	wake_up_process(th);
 
 	return 0;
@@ -1040,6 +1043,7 @@ static struct usb_driver usb_storage_dri
 	.pre_reset =	usb_stor_pre_reset,
 	.post_reset =	usb_stor_post_reset,
 	.id_table =	usb_storage_usb_ids,
+	.supports_autosuspend = 1,
 	.soft_unbind =	1,
 };
 

