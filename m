From: Jens Axboe <axboe@suse.de>
Subject: Re: writable mmc profiles actually are writable
Date: Tue, 7 Oct 2003 09:00:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031007070044.GT972@suse.de>
References: <20030929164654.GS15415@suse.de> <1064855570.3184.3.camel@patehci2> <1064865746.4262.63.camel@patehci2> <1065460336.10804.1.camel@patehci2> <1065463946.5185.8.camel@patehci2> <20031006182223.GF972@suse.de> <20031006182510.GG972@suse.de> <1065469831.5185.44.camel@patehci2> <20031006203816.GJ972@suse.de> <1065473899.6835.41.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:38623 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261863AbTJGHAu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2003 03:00:50 -0400
Content-Disposition: inline
In-Reply-To: <1065473899.6835.41.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Oct 06 2003, Pat LaVarre wrote:
> > patches to make the detection more modern ...
> 
> Below appears a copy of an old patch to try op x46 get_configuration any
> time mode page x2a doesn't already say the pdt x05 dvd/cd device is
> writable.

See my comments in another mail.

> > I haven't yet had to deal with dvd+rw or
> > ddcd_rw (is this like mtr?
> 
> Sorry I do not know mtr.

mt rainier, different in spirit but allows the same 2kb writes and
handles the rest in hardware.

> > mo and dvd-ram have been supported for a long
> > time and should be set with CDC_DVD_RAM,
> 
> Sorry I do not understand.  I remember noticing CDC_MO_DRIVE appears
> only drivers/ide/ not in drivers/scsi/.  Weakly I conclude mo doesn't
> work the same in atapi and usb-storage.

IIRC, scsi mo drives are handled by sd, not sr.

> > the disk profiles aren't driven by ide-cd or
> > sr.
> 
> Sorry I do not understand.
> 
> In drivers/scsi/sr.c I find:
> cd->cdi.mask |= CDC_DVD_RAM;
> 
> In drivers/ide/ide-cd.c I find:
> devinfo->mask |= CDC_DVD_RAM;
> 
> I conclude sr and ide-cd tell cdrom whether the device "profile" is
> writable or not.  Is that wrong?

->mask is an inverted capability mask, so if you set CDC_DVD_RAM you
mask that capability.

-- 
Jens Axboe

