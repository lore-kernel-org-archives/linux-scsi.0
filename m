From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Time to conclude the Sony USB mass storage thread
Date: Fri, 14 Nov 2003 09:26:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031114092644.A2794@beaverton.ibm.com>
References: <1068825146.2134.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:17033 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264574AbTKNR07 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 12:26:59 -0500
Content-Disposition: inline
In-Reply-To: <1068825146.2134.6.camel@mulgrave>; from James.Bottomley@steeleye.com on Fri, Nov 14, 2003 at 09:52:24AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: usb-storage@one-eyed-alien.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-scsi@one-eyed-alien.net

On Fri, Nov 14, 2003 at 09:52:24AM -0600, James Bottomley wrote:
> Since Patrick has already provided the mechanics for this, I suggest we
> do this by setting the skip_ms_page_3f and skip_ms_page_8 globally in
> the usb-storage slave configure routines.
> 
> If there are known good devices, it would probably be best to add them
> to the USB special devices list to have these flags reset for the
> capabilities.
> 
> The nice thing about this approach is that I don't have to do anything
> in SCSI, and the control of the USB black/white list is entirely in the
> USB subsystem.
> 
> Does this sound like a plan?

It would be best to just use the BLIST flags setting in the host .flags,
the following simple patch (only compile tested!) will not send any MODE
SENSE to sd devices (SCSI direct access inquiry type 0, or optical
memory/optical disks inquiry type 7).

It also allows the setting to be overwritten for specific vendor + model
via the scsi_devinfo/dev_flags code - so users or distributions can white
list devices without modifying the kernel (devinfo settings have priority
over shost->flags, see scsi_devinfo.c).

I did not give the flags very good names, for clarity:

BLIST_MS_SKIP_PAGE_08 means for sd assume write through cache.

BLIST_MS_SKIP_PAGE_3F means for sd assume writable media.

And we don't need any special code in a slave_configure or elsewhere to
check if it is a direct access device.

diff -uprN -X /home/patman/dontdiff bl-25/drivers/usb/storage/scsiglue.c usb-ms-flags/drivers/usb/storage/scsiglue.c
--- bl-25/drivers/usb/storage/scsiglue.c	Mon Oct 27 14:28:18 2003
+++ usb-ms-flags/drivers/usb/storage/scsiglue.c	Fri Nov 14 09:15:20 2003
@@ -322,7 +322,8 @@ struct scsi_host_template usb_stor_host_
 	.emulated =			TRUE,
 
 	/* modify scsi_device bits on probe */
-	.flags = (BLIST_MS_SKIP_PAGE_08 | BLIST_USE_10_BYTE_MS),
+	.flags = (BLIST_MS_SKIP_PAGE_08 | BLIST_MS_SKIP_PAGE_3F |
+		  BLIST_USE_10_BYTE_MS),
 
 	/* module management */
 	.module =			THIS_MODULE
