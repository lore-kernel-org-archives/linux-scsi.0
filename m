From: Dmitri Katchalov <dmitrik@users.sourceforge.net>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass	larger receive buffer
Date: Fri, 14 Nov 2003 11:13:16 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068768796.3fb41e1c8d075@webmail.netregistry.net>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org> <1068767049.2851.166.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from webmail.netregistry.net ([203.202.16.21]:39244 "EHLO
	webmail.netregistry.net") by vger.kernel.org with ESMTP
	id S264464AbTKNAN2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 19:13:28 -0500
In-Reply-To: <1068767049.2851.166.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>, "mdharm-scsi@one-eyed-alien.net" <mdharm-scsi@one-eyed-alien.net>, "patmans@us.ibm.com" <patmans@us.ibm.com>, "james.bottomley@steeleye.com" <james.bottomley@steeleye.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "usb-storage@one-eyed-alien.net" <usb-storage@one-eyed-alien.net>, "ronald@kuetemeier.com" <ronald@kuetemeier.com>, "idan@idanso.dyndns.org" <idan@idanso.dyndns.org>

Quoting Pat LaVarre <p.lavarre@ieee.org>:

> Alan S:
> 
> > > > > We may as well fix SCSI over IDE and SCSI over 1394/FireWire/iLink
> at
> > > > > the same time we fix SCSI over USB, yes?
> > > > 
> > > > Are they broken?
> > > 
> > > Aye, in much the same way: nothing but Talk Like Windows actually works
> > > well ...
> >
> > Those sound like different issues from the one we've been discussing in 
> > this thread, namely: how should sd.c try to determine the read/write 
> > status and cache-type of a disk device?
> 
> I mean to be saying sd.c should by default send the CDB's associated
> with buffer lengths that produce the same BBB CBW's as Windows XP/2K,
> and then determine the read/write status and cache-type from that info
> alone.
> 
> Do you agree that works for generic USB storage i.e. bInterfaceClass
> ...SubClass ...Protocol = x 08 (02|05|06) 50?
> 
> Do you disagree that is what we should do in sd for generic USB storage?
> 
> I'm confident Win XP/2K sometimes sends mode select to PDT x00
> HDD/Flash, because I remember some months back a friend fixed some
> firmware that didn't interpret mode select like Win wants nowadays.
> 
> I imagine that means Win sends mode sense too.
> 
> I haven't yet seen a trace of Win XP/2K.

I don't have W2K. I tried to get a trace on XP, it didn't work. 
USB Snoopy does not seem to work on XP. Let me know if you know 
of a better tool. 

Note that Win98 did not support my Sony Handycam Memory Stick out of 
the box, I had to install drivers from Sony installation CD. 
Obviously these drivers do not attempt to issue any commands that 
the device does not understand. XP did detect Sony out of the box but 
it is very likely that it still loaded proprietary Sony driver based 
on USB Device/Vendor ID. 

Also note: the device does not claim any SCSI compliance as indicated 
by reserved values in its device descriptor and by scsi version being 
set to 0 in reply to INQUIRY. It is a miracle it worked at all.

IMHO the solution is either or both of:
* Blacklist it
* Define an absolute bare minimum safe subset of SCSI commands and 
fall back to it whenever you see a non-compliant device like this one.

Regards,
Dmitri


