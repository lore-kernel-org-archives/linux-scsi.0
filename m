From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: READ CAPACITY 16
Date: Wed, 17 Dec 2008 14:04:52 -0500
Message-ID: <1229540692.3508.18.camel@localhost.localdomain>
References: <20081217164210.GC19967@parisc-linux.org>
	 <da824cf30812170950p393be2fq729e98e93edef5dc@mail.gmail.com>
	 <20081217180640.GE19967@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50033 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751588AbYLQTEn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Dec 2008 14:04:43 -0500
In-Reply-To: <20081217180640.GE19967@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@google.com>, linux-scsi@vger.kernel.org

On Wed, 2008-12-17 at 11:06 -0700, Matthew Wilcox wrote:
> On Wed, Dec 17, 2008 at 09:50:52AM -0800, Grant Grundler wrote:
> > > Algorithm A (a perfect world):
> > >
> > > Issue RC16
> > >  -> If it fails, issue RC10
> > >  -> If it times out, reset the device, issue RC10
> > >
> > > Algorithm B:
> > >
> > > Issue RC10
> > > Issue RC16
> > >  -> If it succeeds, use its results in preference to those from RC10
> > >  -> If it fails, carry on with the results from RC10
> > >  -> If it times out, reset the device, carry on with the results from RC10
> > 
> > I fail to see an effective difference between Algo A and B.
> 
> Whether to issue an RC10 before issuing an RC16 or not.  It matches what
> we currently do better (we currently issue an RC10 and then issue an
> RC16 if RC10 reports we have 0xffffffff LBAs).
> 
> > The question really is one you already asked:
> > > ...The question is what to do about devices that either
> > > hang or take a long time to respond to an RC16 command.
> > 
> > A few ideas:
> > 1) maintain a blacklist
> 
> Which is obviously what we're trying to avoid doing.

I don't really see a way of avoiding this ... for USB devices it's
probably going to be a requirement.

> > 2) anything in RC10 or IDENTIFY that would clue us about RC16 functionality?
> >     If so, then something like B or C would make sense.
> 
> RC10 only returns number of LBAs and how many bytes per LBA.  I don't
> see anything in the INQUIRY data (other than the protection bit, which
> we already use to know that RC16 is supported).  We could maybe key off
> scsi_level > SCSI_2 like scsi_device_protection() does.  This would work
> for ATA SSDs because libata reports SCSI ANSI revision 05, but it won't
> work for USB devices because they get mangled down to SCSI_2, no matter
> what they support.

That latter piece is fixable.  We can also go with the INQUIRY version
descriptor information which I don't think USB mangles.

> > 3) How long does Read Capacity16 normally take?  e.g. at boot time with drive
> >    that isn't spun up yet or equivalent from RAID device.
> >    If it's not that long (e.g < 1sec or so) then just use a shorter
> > timeout in general?
> >    With parallel scanning, it should be tolerably painful.
> 
> I don't know how long it'll take.  I was hoping people with experience
> in this matter would chime in.

Actually, we can't afford to send READ CAPACITY(16) to failing devices;
some of them never come back.

James


