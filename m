From: Jens Axboe <axboe@suse.de>
Subject: Re: writable mmc profiles actually are writable
Date: Mon, 6 Oct 2003 22:33:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031006203357.GI972@suse.de>
References: <1064271322.4797.9.camel@patehci2> <1064847281.24854.2.camel@patehci2> <1064850600.25057.7.camel@patehci2> <20030929164654.GS15415@suse.de> <1064855570.3184.3.camel@patehci2> <1064865746.4262.63.camel@patehci2> <1065460336.10804.1.camel@patehci2> <1065463946.5185.8.camel@patehci2> <20031006182223.GF972@suse.de> <1065471683.5185.52.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:65422 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261735AbTJFUeJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2003 16:34:09 -0400
Content-Disposition: inline
In-Reply-To: <1065471683.5185.52.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Oct 06 2003, Pat LaVarre wrote:
> > CDC_DVD_RAM ...
> > the only thing the kernel supports out of the box.
> 
> Do we understand this choice?  I'm new to linux, new to t10 mmc, old to
> unix, old to t10 scsi.  I think I see:

You conviniently snipped the rest of the message. I said that media that
is _like_ DVD-RAM. I'll grant you that it isn't quite obvious, but that
is the way it was done. That covers stuff like MO drives, too.

> 1) In mmc, seven of the standard profiles imply feature x0020
> random_writable, specifically profiles x 0001 0002 0003 0005 0012 001A
> 0022 i.e. non_removable_disk, removable_disk, magneto_optical_erasable,
> as_mo, dvd_ram, dvd+rw, ddcd_rw.

the disk profiles aren't driven by ide-cd or sr. mo and dvd-ram have
been supported for a long time and should be set with CDC_DVD_RAM, I
haven't yet had to deal with dvd+rw or ddcd_rw (is this like mtr?). Feel
free to extend that to cover those, too. I know of patches for dvd+rw
floating around, they have never been sent for kernel inclusion though.
Which either means that they don't work too well (they probably do), or
that people just don't care enough for that feature.

> 2) In sr_mod.ko and ide-cd.ko, we conservatively fetch only mode page
> x2A Capabilities.  Specifically we do not yet try the op x46 Get
> Configuration of 1999 mmc 2, not even after we see mode page x2A.
>
> 3) Omitting op x46 by definition precludes linux from distinguishing
> from legacy cd_rom all the new writable kinds of pdt x05 dvd/cd,
> excepting only the 1997 mmc 1 choices that /proc/sys/dev/cdrom already
> offers i.e. cd_r, cd_rw, dvd, dvd_r, and dvd_ram.
> 
> How wrong am I?

You are not wrong, and I'd be happy to review patches to make the
detection more modern. And this is what you should have done from the
beginning, instead of just hacking around the write open. This is what
my objection was for, not supporting other devices.

-- 
Jens Axboe

