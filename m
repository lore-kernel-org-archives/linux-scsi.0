From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: 22 Sep 2003 16:55:22 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064271322.4797.9.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:6549 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261164AbTIVWyr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 18:54:47 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-usb-devel@vger.kernel.org
Cc: torvalds@osdl.org, mdharm-scsi@one-eyed-alien.net, stern@rowland.harvard.edu, hch@infradead.org, james.bottomley@steeleye.com, andries.brouwer@cwi.nl


> From: Linus Torvalds <torvalds () osdl ! org>
> Date: 2003-09-22 19:55:30
> ...
> How about just trusting the size ...
> and capping it at 20?

Besides dramatic overestimates of mode sense additional length, I've
also seen the off-by-one slight overestimate and the high-byte-zeroed
dramatic underestimate.

> General MODE SENSE stuff is in:
> http://www.t10.org/ftp/t10/drafts/spc3/spc3r15.pdf

Yes, but t10 mmc often quietly contradicts & overrides t10 spc for pdt
x05 dvd/cd and for atapi pdt x00 hdd/rmb.  For t10 newbies wanting to
fetch the bleeding edge, latest final draft, oldest still available,
etc. I sometimes recommend the index:

http://www.t10.org/scsi-3.htm

> > A scsi device declares its level of scsi compliance.
> ...
> From: Matthew Dharm <mdharm-scsi () one-eyed-alien ! net>
> Date: 2003-09-22 20:51:59
> ...
> reporting of 0, 1, 2, or something random ...
> appears ... unrelated to the capabilities of the device ...

The pernicious idea of zeroing the scsi revision in byte 2 of op x12
inquiry forms part of how mmc quietly redefines spc.  Misapplying the
sff precursor of the pdt x05 mmc spec to pdt x00 devices is part of how
msft whql qualified atapi pdt x00 devices for sale thru oem's in the
late 1990's.

> > > > From: Alan Stern <stern () rowland ! harvard ! edu>
> > > > Date: 2003-09-22 14:25:28
> > > > ...
> > > > many, many USB storage devices.  
> > > > They just don't handle MODE-SENSE page 8 correctly.
> > >
> > > From: Linus Torvalds <torvalds () osdl ! org>
> > > Date: 2003-09-22 16:09:47
> > > ...
> > > How about just making the sd.c layer more robust? 
> >
> > From: Alan Stern <stern () rowland ! harvard ! edu>
> > Date: 2003-09-22 16:42:52
> > ...
> > variety of ways ... fail ... truly amazing.
>
> From:  Christoph Hellwig <hch () infradead ! org>
> Date: 2003-09-22 17:21:42
> ...
> for those usb-storage devices where ...
> nothing that isn't excercised by the windows drivers
> has the slightest chance of working..

In the sd world, usb hdd/rmb (pdt x00) may handle specifically the mode
sense of page 8 that win sends.

For usb bInterfaceSubClass = x06 TransparentScsi that cdb might be:
x 1A 00:08:00 18 00

For usb bInterfaceSubClass != x06 TransparentScsi that cdb might be:
x 5A 00 08:00:00:00 00 00:1C 00

usb dvd/cd (pdt x05) sell into the sr/ide-cd world instead, of course.

Tell me we care to hear specifically what some win sends to some of my
usb hdd/rmb, and I'll go collect a few sample usb bus traces.  I do NOT
know that the above cdb's are correct.  Those are just my guesses,
summing up little clues from years of messing around near here.  I hear
in particular that win 9x/me differs from win 2k/xp near hear.

> Subject:  Re: [linux-usb-devel] Re: USB storage problems on OHCI..
> From: Linus Torvalds <torvalds () osdl ! org>
> Date: 2003-09-22 17:41:47
> ...
> is it saner to try to read just the bytes we need
> (3 bytes: page code, page size and the cache bits),
> or the full 20 bytes?

I thought "everyone knew" sanest was to always fetch header + block
descriptors + whole pages?

Trouble is, that's a circular definition in that the host can't know
whether the device will volunteer an optional block descriptor or not. 
mmc says shall not, spc says maybe not but should.

We only have to care if we have to know how many Data bytes to expect to
copy In.

> From: Andries.Brouwer () cwi ! nl
> Date: 2003-09-22 18:55:22
> ...
> Similarly, USB storage devices tend to ...
> only systematically work
> if one does precisely what Windows does.

Yes, what ain't tested don't work.

> USB is hot pluggable,
> so it should not be necessary
> to send a flush cache command at shutdown.

Who has tested this rule?  I know I've seen ata hdd lose data in
response to a pin 1 reset issued without op x35 sync cache.  I've heard
same of dvd.  And loss of bus power can kill any write cache in a drive,
of course.

> From: James Bottomley <James.Bottomley () steeleye ! com>
> Date: 2003-09-22 17:55:09 ...
> ...
> I think we could try 4 bytes

We know that isn't talk like windows.  msdn.microsoft.com tells us the
win 2k kernel crashes if a root-privileged app asks for just the 4 byte
header from devices for which Win translates to x5A MODE_SENSE_10 from
x1A MODE_SENSE  Because the win 2k kernel crashes so reliably, we can
confidently guess no working win 2k apps talk that way.

> From: James Bottomley <James.Bottomley () steeleye ! com>
> Date: 2003-09-22 19:28:56
> ...
> sd? ... the most conservative ..., we could probably
> dump spin up, read write protect, and read cache type ...

Aye, although in sr/ide-cd we have a default of not writable to overcome
somehow.

Pat LaVarre



