From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Advanced Format SAT devices show incorrect physical block size
Date: Wed, 11 Jan 2017 10:23:29 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1701110954060.1900-100000@iolanthe.rowland.org>
References: <1484086345.2518.9.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57086 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S935779AbdAKPYO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2017 10:24:14 -0500
In-Reply-To: <1484086345.2518.9.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Dainius =?UTF-8?Q?Masili=C5=ABnas?= <pastas4@gmail.com>, Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Tom Yan <tom.ty89@gmail.com>

On Tue, 10 Jan 2017, James Bottomley wrote:

> On Tue, 2017-01-10 at 16:00 -0500, Alan Stern wrote:
> > In theory, I suppose we could change the kernel so that it would 
> > default to READ CAPACITY(16) for devices that report a SCSI level >= 
> > 3, or something along those lines.  In general we hesitate to make
> > changes of this sort, because they almost always end up breaking 
> > _some_ devices -- and if that happens then the change is reverted, 
> > with no exceptions.  Linus has a very strict rule about not breaking 
> > working systems.
> 
> You shouldn't have to change anything: it already does (otherwise how
> else would we detect physical exponent for proper SCSI devices) see
> sd.c:sd_try_rc16_first().  It always returns false for USB because you
> set sdev->try_rc_10_first

In fact, this approach probably won't work.  See Bugzilla entries
#43265 and #43391.  The devices in those reports claimed to be ANSI
level 4, but they failed anyway.

If you guys want to try the quirk flag, you can apply the patch below.  
Then set the usb-storage module parameter quirks=vvvv:pppp:k where
vvvv and pppp are the Vendor and Product ID codes for your device (as 4 
hex digits).

In the long run, however, this is not a viable approach.  We'd be 
better off with an explicit blacklist.

Alan Stern



Index: usb-4.x/drivers/usb/storage/usb.c
===================================================================
--- usb-4.x.orig/drivers/usb/storage/usb.c
+++ usb-4.x/drivers/usb/storage/usb.c
@@ -498,7 +498,7 @@ void usb_stor_adjust_quirks(struct usb_d
 			US_FL_INITIAL_READ10 | US_FL_WRITE_CACHE |
 			US_FL_NO_ATA_1X | US_FL_NO_REPORT_OPCODES |
 			US_FL_MAX_SECTORS_240 | US_FL_NO_REPORT_LUNS |
-			US_FL_ALWAYS_SYNC);
+			US_FL_ALWAYS_SYNC | US_FL_NEEDS_CAP16);
 
 	p = quirks;
 	while (*p) {
@@ -551,6 +551,9 @@ void usb_stor_adjust_quirks(struct usb_d
 		case 'j':
 			f |= US_FL_NO_REPORT_LUNS;
 			break;
+		case 'k':
+			f |= US_FL_NEEDS_CAP16;
+			break;
 		case 'l':
 			f |= US_FL_NOT_LOCKABLE;
 			break;

