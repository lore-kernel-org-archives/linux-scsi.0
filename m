From: Jens Axboe <axboe@suse.de>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: Sun, 13 Jun 2004 22:00:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040613200048.GB2566@suse.de>
References: <1086710016.3647.4.camel@patibmrh9> <40C8FB79.1050706@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:28362 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S265258AbUFMUAx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jun 2004 16:00:53 -0400
Content-Disposition: inline
In-Reply-To: <40C8FB79.1050706@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Pat LaVarre <p.lavarre@ieee.org>, linux-scsi@vger.kernel.org

On Fri, Jun 11 2004, Douglas Gilbert wrote:
> Pat LaVarre wrote:
> >Doug G:
> >
> >Did I do something wrong, or does "everyone know" already,
> >
> >SCSI pass thru in 2.6 omits ide-floppy, except if we do resort to the
> >ide-scsi deprecated there?
> 
> Pat,
> In lk 2.6 the ide-scsi driver is "deprecated" for cd/dvd device types
> but not other device types that use the ATAPI protocol. The ide-scsi

Direct-device is still clearly superior. ide-scsi is deprecated for any
ATAPI type device using SG_IO, other uses may vary.

> Anyway ide-scsi probably needs some repair work in lk 2.6. Both
> Willem Riede and I have tried. IMO the ide-scsi driver looks ok
> from the scsi subsystem side ....

Should work since months.

> >Or more specifically,
> >
> >Can ioctl SG_IO fetch the offset 7 Additional Length field of op x03
> >"REQUEST SENSE" data?
> >
> >Naively I thought yes of course, I know that works with /dev/scd$n.
> >
> >But then I tried a /dev/hd$v ide-floppy.  No joy.  perror tells me ioctl
> >SG_IO fails via "Invalid argument", dmesg has no comment.  sg_scan you
> >know.  ~/bin/sgio source is the trivial exercise quoted in source far
> >below, specifically with an O_NONBLOCK|O_RDWR open as you can see.
> 
> My method with the SG_IO ioctl was to yield errnos
> if the SCSI command could not be sent (or was rejected
> at the point of transmission). So if there is an errno
> there will be no sense buffer (or any other valid
> response data). It is only when a response to the SCSI
> command is received that errno will be clear (and the
> various status variables should be checked).

The issue here is that ide-floppy doesn't grok REQ_BLOCK_PC requests
correctly, so when SG_IO generates them they are failed.

-- 
Jens Axboe

