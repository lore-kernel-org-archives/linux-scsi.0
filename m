From: Andries.Brouwer@cwi.nl
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 21:56:38 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200309221956.h8MJucs21996.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:60323 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S263310AbTIVT7p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 15:59:45 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, James.Bottomley@steeleye.com
Cc: david-b@pacbell.net, greg@kroah.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-usb@one-eyed-alien.net, patmans@us.ibm.com, stern@rowland.harvard.edu, torvalds@osdl.org

    From James.Bottomley@SteelEye.com  Mon Sep 22 21:29:06 2003

    On Mon, 2003-09-22 at 13:55, Andries.Brouwer@cwi.nl wrote:
    >         if (sdkp->media_present) {
    >                 sd_read_capacity(sdkp, disk->disk_name, sreq, buffer);
    >                 if (sdp->removable)
    >                         sd_read_write_protect_flag(sdkp, disk->disk_name,
    >                                         sreq, buffer);
    >                 sd_read_cache_type(sdkp, disk->disk_name, sreq, buffer);
    >         }
    > 
    > and I suppose we could skip sd_read_cache_type() in the
    > hot-pluggable case - a flag that USB storage could set.

    what about just having a conservative mode for sd?  This could still
    internally be a set of flags, just one single way of clearing them all
    from slave configure.  For the most conservative setting, we could
    probably dump spin up, read write protect, and read cache type.

Maybe.

[By the way - reading Write Protect is meaningful and works,
for my Smart Media card readers.]

I have seen proposals around here for flags that are far too specific
(like "do not ask for mode page 8"). If we go to that level of detail
then we'll soon have fifty flags.
Black lists, and flags that describe various ways of being broken
are a bad idea in my opinion. I will not deny that they may be needed
in some cases, but they are never the preferred solution.

Also "conservative mode" sounds like a flag that describes some
way of being broken.

On the other hand "hot-pluggable" describes a positive asset,
and if we can conclude from that that it is unnecessary to ask
for mode page 8 then we achieve the same effect in a positive way.


There is another comment here.
A scsi device declares its level of scsi compliance.
Most USB storage devices are not very scsi compliant at all,
and report 0 there.
To everybody's surprise USB storage does

        US_DEBUGP("Fixing INQUIRY data to show SCSI rev 2 - was %d\n",
                  data_ptr[2] & 7);

        /* Change the SCSI revision number */
        data_ptr[2] = (data_ptr[2] & ~7) | 2;

It claims that the device is SCSI-2 compliant, even when the
device itself does not make that claim at all.


Suppose that we stop changing this compliance level.
Then getting SCSI-1 or no compliance level could be a
"conservative mode" flag.

[Of course this was done for a reason - USB storage was written
assuming the SCSI layer given. If we stop changing the SCSI level
that may require changes in the SCSI code. Probably Matt remembers
what the problems were.]

Andries
