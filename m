From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: writable mmc profiles actually are writable
Date: 09 Oct 2003 17:01:12 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065740472.2628.19.camel@patehci2>
References: <1065463946.5185.8.camel@patehci2>
	 <20031006182223.GF972@suse.de> <20031006182510.GG972@suse.de>
	 <1065469831.5185.44.camel@patehci2> <20031006203816.GJ972@suse.de>
	 <1065473899.6835.41.camel@patehci2> <1065478448.2361.1.camel@patehci2>
	 <1065484607.2899.7.camel@patehci2> <20031007053858.GL972@suse.de>
	 <1065559619.2875.63.camel@patehci2>  <20031007210020.GJ1704@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:7920 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262590AbTJIXB3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Oct 2003 19:01:29 -0400
In-Reply-To: <20031007210020.GJ1704@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: mdharm-scsi@one-eyed-alien.net, linux-scsi@vger.kernel.org

> > Before now, I did not know I could find any
> > one place in the kernel source to tweak CDC
> > decisions.  To my confused newbie eye,
> > ide-cd.c and sr.c appeared coded
> > independently to fetch mode page x2A
> > Capabilities and neglect op x46 ...
>
> The ->generic_packet() hook and
> cdrom_generic_command was invented to solve
> this code duplication.

News to me, thanks.

> So in cdrom.c you just setup the cgc as
> needed, and pass it down to ide-cd or sr. See
> cdrom_mode_sense() for one of the many
> examples ...
> ...
> The idea ... make CDC_DVD_RAM really be the
> hardware type indication and not the pseudo
> randomly writable flag that it is now ...
> ...
> please proceed ...

Will do, now diff'ing against 2.6.0-test7.

> > > I haven't yet had to deal with dvd+rw or
> > > ddcd_rw (is this like mtr?
> > 
> > Sorry I do not know mtr.
> 
> mt rainier, different in spirit

Eh?  Different in spirit than what & how?

> mt rainier, different in spirit but allows the same 2kb
> writes and handles the rest in hardware.

Ah.  Yes some of the buzz re Mt Rainier has reached me before now.  But
I had not heard that writes work well unless actually aligned to more
like 64 KiB boundaries.  I had only heard that the hardware tolerated
misaligned writes, not that misaligned writes work well.

> > mo and dvd-ram have been supported for a long
> > > time and should be set with CDC_DVD_RAM,
> > 
> > ... CDC_MO_DRIVE appears only drivers/ide/ not in
> > drivers/scsi/.  Weakly I conclude mo doesn't
> > work the same in atapi and usb-storage.
> 
> IIRC, scsi mo drives are handled by sd, not sr.

Cluelessly I wonder.  I see if scsi mo works via scsi/sd.c, it works
without benefit of CDC_MO_DRIVE, which makes me wonder why drivers/ide
has a use for CDC_MO_DRIVE.  If I hear no reply, I will assume grep
CDC_MO_DRIVE drivers/ide/* would answer my question for me.  I have no
mo drive, so I do not find the question compelling.

> > > the disk profiles aren't driven by ide-cd or
> > > sr.
> > 
> > In drivers/scsi/sr.c I find: ...
> > In drivers/ide/ide-cd.c I find:
> > ...mask |= CDC_DVD_RAM;
> 
> ->mask is an inverted capability mask, so if you set
> CDC_DVD_RAM you mask that capability.

Ouch, that detail I actually did know already.

Sorry I was unclear.

I meant to say I find a default of & CDC_DVD_RAM == 0 and then the |= to
1 executed only conditionally e.g. sr.c:

        ... [fetch mode page x2A Capabilities] ...
        ...
        if ((buffer[n + 3] & 0x20) == 0) {
                /* can't write DVD-RAM media */
                cd->cdi.mask |= CDC_DVD_RAM;
        } else {
                cd->device->writeable = 1;
        }

In my newbie ignorance, that made me guess that sr_mod.ko, not cdrom.ko,
was deciding whether my usb-storage.ko drive was writable.

Pat LaVarre


