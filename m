From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] mode sense blacklist how
Date: 20 Nov 2003 08:57:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069343835.6663.16.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
	 <1068767049.2851.166.camel@patrh9>
	 <1068768796.3fb41e1c8d075@webmail.netregistry.net>
	 <1068775834.2851.321.camel@patrh9>
	 <20031113181945.I30194@one-eyed-alien.net>
	 <1068777510.2851.359.camel@patrh9>
	 <1068779468.3fb447ccc6e60@webmail.netregistry.net>
	 <1068838908.2852.34.camel@patrh9>
	 <1069246502.3fbb6826955dd@webmail.netregistry.net>
	 <1069261377.2867.37.camel@patrh9>
	 <1069337187.3fbcca6395f44@webmail.netregistry.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:39592 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262009AbTKTP54
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 10:57:56 -0500
In-Reply-To: <1069337187.3fbcca6395f44@webmail.netregistry.net>
List-Id: linux-scsi@vger.kernel.org
To: dmitrik@users.sourceforge.net
Cc: linux-scsi@vger.kernel.org

> The only really important question IMHO is
> how come SG_IO is not interruptible.

Yes, now being pursued by Doug G in this thread.

> > In the log I see this command repeated, time and again.  Did you ask for
> > this command repeatedly yourself, or is it the code of SG_IO and below
> > that is so helpfully retrying?
> 
> That wasn't me. I see these commands were sent *after* the device has 
> been unplugged. It must've been SCSI layer.

This also could matter.  In our kernel code who wrongly thinks we gave
permission to retry SG_IO?  This evidence echoes someone else's - may
have been Patrick M - who saw mode sense stuttering.  I don't remember
if that was different (rude mode sense from the kernel) or the same
(rude mode sense via SG_IO from plscsi).

> Anyway, it must be obvious by now that the device is broken or shall
> we say proprietary. There is a quick workaround already in place. I'd
> say blacklist it in unusual_devs and be done with it.

Not broken.

This device explicitly self-identifies itself as a proprietary kind of
SCSI via bInterfaceSubClass = xFF and also the almost-proprietary kind
of SCSI over USB that is bInterfaceProtocol != x50.

No separate blacklist needed.  Recently near here I think I heard:

We of usb-storage are instead choosing to blacklist all the reserved
bInterfaceSubClass codes altogether.  Already we blacklist such devices
in that we don't try talking unless they appear in unusual_devs.  Now
also we won't try non-Microsoft mode sense even if they do appear in
unusual_devs.

> > the plscsi workaround: -X time 5 0. 
> > Does that work for you?  
> 
> Yes, ... Still, ... device ... must be unplugged ...

Curious.  If the mode senses that work aren't the first mode senses that
Windows tries, then the resets of Windows must be working ...

> try more MODE SENSE(10) ... finally found some that work:
> 
> ./plscsi /dev/sg1 -v -p -X time 10 0 -i xC0 -x "5A 00 3F 00 00 00 00 00 C0 00"
> produces the following output:
> 
> x 00000000 5A 00 3F:00:00:00 00 00:C0 00 .. .. .. .. .. .. "Z@?@@@@@@@"
> x 00000000 00:32:00:00 00:00:00:00 05:1E:00:12 04:20:02:00 "@2@@@@@@E^@RD B@"
> x 00000010 01:00:00:00 00:00:00:00 00:00:00:00 00:00:00:00 "A@@@@@@@@@@@@@@@"
> x 00000020 00:00:00:00 00:B4:00:00 1B:0A:C0:00 00:00:00:00 "@@@@@4@@[J@@@@@@"
> x 00000030 00:00:00:00 00:00:00:00 00:00:00:00 00:00:00:00 "@@@@@@@@@@@@@@@@"
> ...
> x 000000B0 00:00:00:00 00:00:00:00 00:00:00:00 00:00:00:00 "@@@@@@@@@@@@@@@@"

Ah.  Eight byte header claiming x34 bytes available.  No optional block
descriptor.  x20 bytes of page x05 for boot H:S:C.  x0C bytes of page
x1B to please Windows.    x 8 + 20 + 0C = 34, good.

> // 0 = plscsi.main exit int
> 
> It looks like the device does support MODE SENSE(10) for pages 5 and 1B only.

Perhaps that is all that PC boot BIOS and Windows require.  This could
be a sample of design-by-test: edit, compile, test, ship when it does
not crash.  Do you know if the device firmware is upgradable?

> "5A 00 05 00 00 00 00 00 C0 00" and "5A 00 1B 00 00 00 00 00 C0 00" also work.
> 
> There is not much useful info on those 2 pages, what was the point 
> of implementing them I wonder?

t10.org as we speak is hashing over the value or not of reporting a
fictional C:H:S geometry in the mode page x05 that can report C:H:S up
to about 8 GiB.

Page x1B I don't remember the t10.org name of but it appears in Windows
traces, so someone on Earth thinks it can be useful.  Name might be
something like "power conditions".

> > Have you tried `modprobe -r usb-storage`?
> "Module in use"
> Not entirely unexpected since plscsi holds an open handle at this point.

I'm sure I'm enough of a kernelnewbie to be deeply confused here, but I
don't understand why we can kill the plscsi process without gaining
permission to kill the SG_IO.
 
> > Adding -v might tell us more.
>
> Not really:) It just shows the command going down and that's it.

Thanks for saying, now I feel less bad about not suggesting -v to begin
with.

> > Here we see "auto-sense" "code: 0x70, key: 0x5, ASC: 0x24, ASCQ: 0x0".
> > 
> > In the t10.org English, x 5 24 means cdb[0] opcode understood, but whole
> > cdb not understood.  x 5 20 means cdb[0] opcode not understood.
> > 
> > This result suggests, without guaranteeing, that the vendor-specific
> > bInterfaceSubClass = xFF SCSI of this device includes some cdb's that
> > begin with op x1A Mode Sense (6).
> 
> Hmm, I tried MODE SENSE(6) with the same pages (5,1B and 3F) that worked 
> with MODE SENSE(10) and I've got the same error: x 5 24.

Ouch, maybe this device is creatively reporting x 5 24 to mean x 5 20.

Pat LaVarre


