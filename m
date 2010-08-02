From: <gregkh@suse.de>
Subject: patch "USB: usb-storage: implement autosuspend" added to gregkh-2.6 tree
Date: Mon, 02 Aug 2010 16:47:34 -0700
Message-ID: <1280792854321@site>
References: <Pine.LNX.4.44L0.1007281702030.1744-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:36280 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab0HBXsN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Aug 2010 19:48:13 -0400
In-Reply-To: <Pine.LNX.4.44L0.1007281702030.1744-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu, gregkh@suse.de, greg@kroah.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, mdharm-usb@one-eyed-alien.net, oliver@neukum.org, usb-storage@lists.one


This is a note to let you know that I've just added the patch titled

    USB: usb-storage: implement autosuspend

to my gregkh-2.6 tree which can be found in directory form at:
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/
 and in git form at:
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/patches.git

The filename of this patch is:
    usb-usb-storage-implement-autosuspend.patch

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

If this patch meets the merge guidelines for a bugfix, it should be
merged into Linus's tree before the next major kernel release.
If not, it will be merged into Linus's tree during the next merge window.

Either way, you will probably be copied on the patch when it gets sent
to Linus for merging so that others can see what is happening in kernel
development.

If you have any questions about this process, please let me know.


>From stern+4c5c36d6@rowland.harvard.edu  Mon Aug  2 16:02:08 2010
Date: Wed, 28 Jul 2010 17:12:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: James Bottomley <James.Bottomley@suse.de>, Greg KH <greg@kroah.com>
cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, 
    Oliver Neukum <oliver@neukum.org>, 
    SCSI development list <linux-scsi@vger.kernel.org>, 
    USB Storage list <usb-storage@lists.one-eyed-alien.net>
Subject: USB: usb-storage: implement autosuspend
Message-ID: <Pine.LNX.4.44L0.1007281702030.1744-100000@iolanthe.rowland.org>

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
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/usb.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
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
 

