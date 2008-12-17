From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: READ CAPACITY 16
Date: Wed, 17 Dec 2008 11:06:40 -0700
Message-ID: <20081217180640.GE19967@parisc-linux.org>
References: <20081217164210.GC19967@parisc-linux.org> <da824cf30812170950p393be2fq729e98e93edef5dc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54822 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbYLQSG5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Dec 2008 13:06:57 -0500
Content-Disposition: inline
In-Reply-To: <da824cf30812170950p393be2fq729e98e93edef5dc@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Dec 17, 2008 at 09:50:52AM -0800, Grant Grundler wrote:
> > Algorithm A (a perfect world):
> >
> > Issue RC16
> >  -> If it fails, issue RC10
> >  -> If it times out, reset the device, issue RC10
> >
> > Algorithm B:
> >
> > Issue RC10
> > Issue RC16
> >  -> If it succeeds, use its results in preference to those from RC10
> >  -> If it fails, carry on with the results from RC10
> >  -> If it times out, reset the device, carry on with the results from RC10
> 
> I fail to see an effective difference between Algo A and B.

Whether to issue an RC10 before issuing an RC16 or not.  It matches what
we currently do better (we currently issue an RC10 and then issue an
RC16 if RC10 reports we have 0xffffffff LBAs).

> The question really is one you already asked:
> > ...The question is what to do about devices that either
> > hang or take a long time to respond to an RC16 command.
> 
> A few ideas:
> 1) maintain a blacklist

Which is obviously what we're trying to avoid doing.

> 2) anything in RC10 or IDENTIFY that would clue us about RC16 functionality?
>     If so, then something like B or C would make sense.

RC10 only returns number of LBAs and how many bytes per LBA.  I don't
see anything in the INQUIRY data (other than the protection bit, which
we already use to know that RC16 is supported).  We could maybe key off
scsi_level > SCSI_2 like scsi_device_protection() does.  This would work
for ATA SSDs because libata reports SCSI ANSI revision 05, but it won't
work for USB devices because they get mangled down to SCSI_2, no matter
what they support.

> 3) How long does Read Capacity16 normally take?  e.g. at boot time with drive
>    that isn't spun up yet or equivalent from RAID device.
>    If it's not that long (e.g < 1sec or so) then just use a shorter
> timeout in general?
>    With parallel scanning, it should be tolerably painful.

I don't know how long it'll take.  I was hoping people with experience
in this matter would chime in.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
