From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: adding flag for 192 byte mode sense
Date: Tue, 16 Mar 2004 12:25:03 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0403161214510.815-100000@ida.rowland.org>
References: <20040313174651.A3054@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:1028 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264210AbUCPRZH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Mar 2004 12:25:07 -0500
In-Reply-To: <20040313174651.A3054@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: mdharm-usb@one-eyed-alien.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Sat, 13 Mar 2004, Patrick Mansfield wrote:

> Following are patches to support a flag for a 192 byte MODE SENSE, for use
> by USB.
> 
> First patch replaces the scsi_host flags with a per sdev bflag, and sets
> values in a new USB slave_alloc rather than the scsi_host template. I
> grepped code for other users of scsi_host flags, and did not find any, and
> do not recall seeing any added (flags is a bad name). slave_alloc is used
> so that if needed the devinfo code can overwrite any settings.
> 
> Second patch adds the 192 flag.
> 
> With both patches we should get the exact behaviour we have now.

Great work!  Thanks, Patrick.

> USB patches are still needed to set the BLIST_MS_192_BYTES_FOR_3F flag,
> and to conditionally use the BLIST_USE_10_BYTE_MS based on the transparent
> scsi versus all others. Alan or Matthew - can you send patches for that?

Patch below.  It's not ideal because these things depend on the device 
type, which isn't known until after slave_alloc().  Hence the scsi devinfo 
mechanism can't be used for overrides.  It probably won't matter though.
We might want to keep using MODE SENSE(10) always even though Windows 
doesn't.  Nobody has complained about it so far.

> The scsi core usage of use_10_for_ms might need to change to behave the
> way usb wants, though it probably will not matter. It currently demotes
> from 10 byte to 6 byte if there is an illegal request on the 10 byte
> command. Based on Alan's information, it sounds like USB wants the
> commands to always be 6 or 10 bytes, with no change on an illegal request.

There are devices that like MS(10) and dislike MS(6).  I haven't seen the 
reverse, but maybe Matt has.

> I tested with these usb mass storage devices: sony camera, olympus camera,
> and dazzle card reader with no problems. I thought the sony used to choke
> on the MODE SENSE, but it worked for both the short 8 byte and long 192
> byte requests (did get sense key Illegal Request but no hang on allow
> medium removal).

What we really need is testing by the few people whose devices couldn't 
handle page 3f at all, before.

Alan Stern

P.S.:  A separate question has come up recently.  There are error
conditions in which the USB Mass Storage protocols require a device reset.
Currently usb-storage has been doing its own resetting, but maybe it would
be better to let the SCSI error handler take care of things.  Is there a
result code the driver can return to indicate that error recovery should
commence immediately (no command retries)?  Better yet, is there a code
to indicate that the initial TEST UNIT READY should be skipped and the
error handler should go straight into a device reset?


--- 2.6/drivers/usb/storage/scsiglue.c1	Tue Mar 16 10:38:08 2004
+++ 2.6/drivers/usb/storage/scsiglue.c	Tue Mar 16 12:12:25 2004
@@ -48,6 +48,7 @@
 #include "usb.h"
 #include "debug.h"
 #include "transport.h"
+#include "protocol.h"
 
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -70,8 +71,15 @@
 	 * Set default bflags. These can be overridden for individual
 	 * models and vendors via the scsi devinfo mechanism.
 	 */
-	sdev->sdev_bflags = (BLIST_MS_SKIP_PAGE_08 | BLIST_MS_SKIP_PAGE_3F |
-			     BLIST_USE_10_BYTE_MS);
+
+	/* By default, USB mass storage devices use MODE SENSE(10).
+	 * Use 192 byte transfers for MODE SENSE page x3f.
+	 * We don't know yet whether MODE SENSE page x08 is reliable. */
+	sdev->sdev_bflags = (BLIST_USE_10_BYTE_MS |
+			BLIST_MS_192_BYTES_FOR_3F |
+			BLIST_MS_SKIP_PAGE_08);
+	/* Maybe add an unusual_devs flag for BLIST_MS_SKIP_PAGE_3F */
+
 	return 0;
 }
 
@@ -98,6 +106,23 @@
 	if (us->pusb_dev->descriptor.idVendor == USB_VENDOR_ID_GENESYS &&
 			us->pusb_dev->speed == USB_SPEED_HIGH)
 		blk_queue_max_sectors(sdev->request_queue, 128);
+
+	/* We can't put these settings in slave_alloc() because that gets
+	 * called before the device type is known.  Consequently these
+	 * settings can't be overridden via the scsi devinfo mechanism. */
+	if (sdev->type == TYPE_DISK) {
+
+		/* Disk-type devices use MODE SENSE(6) if the protocol
+		 * (SubClass) is Transparent SCSI */
+		if (us->subclass == US_SC_SCSI)
+			sdev->use_10_for_ms = 0;
+	} else {
+
+		/* Non-disk-type devices don't need to blacklist MS page x08
+		 * or to force 192 byte transfer lengths for MODE SENSE */
+		sdev->skip_ms_page_8 = 0;
+		sdev->use_192_bytes_for_3f = 0;
+	}
 
 	/* this is to satisify the compiler, tho I don't think the 
 	 * return code is ever checked anywhere. */

