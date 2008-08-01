From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: SCSI device rescan, detection of disconnected
	device,or	switched devices.
Date: Fri, 01 Aug 2008 09:29:05 -0500
Message-ID: <1217600945.3347.10.camel@localhost.localdomain>
References: <1217248348.4133.51.camel@galr-linux>
	 <488DC55C.2050603@s5r6.in-berlin.de> <1217487434.25491.34.camel@galr-linux>
	 <4891792C.6020304@s5r6.in-berlin.de> <1217504895.25491.69.camel@galr-linux>
	 <1217513749.3333.7.camel@localhost.localdomain>
	 <1217520571.6768.14.camel@galr-linux.storwiz.com>
	 <1217521230.3333.16.camel@localhost.localdomain>
	 <0C22B6EFEE0DBB4A9F9F3801E8790B3A732C0C@swdc2.storwiz.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54009 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841AbYHAO3K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Aug 2008 10:29:10 -0400
In-Reply-To: <0C22B6EFEE0DBB4A9F9F3801E8790B3A732C0C@swdc2.storwiz.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gal Rosen <galr@storwize.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org

On Thu, 2008-07-31 at 21:52 +0300, Gal Rosen wrote:
> It won't change the device identification of the existing 10 LUNs, but
> it will report UA of "Power on, reset, or bus device reset occured",
> then I can send read capacity command.

Sending the same email four times doesn't help ... it likely got eaten
by linux-scsi each time because you sent a mixed text/html message ...
the lists only like plain text

But the point is that what happens is highly array dependent ... some
will change the id some won't.  There's nothing we can say for certain
without having knowledge of the array, which really belongs in policy
somewhere.

James

> 
> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Thu 7/31/2008 7:20 PM
> To: Gal Rosen
> Cc: Stefan Richter; linux-scsi@vger.kernel.org
> Subject: Re: SCSI device rescan, detection of disconnected device,or
> switched devices.
> 
> On Thu, 2008-07-31 at 19:09 +0300, Gal Rosen wrote:
> > On Thu, 2008-07-31 at 09:15 -0500, James Bottomley wrote:
> > > Oh ... you're not really talking about hotplug, which is why
> everyone is
> > > confused.  Hotplug is when you add or remove something from the
> bus.
> > > What you've done is reconfigure the array.
> > >
> > > Most of the hotplug we do depends on the transport model (because
> what's
> > > on the transport is changing).  Array reconfiguration has no
> hotplug
> > > event because SAM-3 has no real way of passing the information
> > > asynchronously.  The best it can do is Unit Attention/reported
> luns data
> > > has changed (asc=0x3f/ascq=0xe) on the next command.
> > >
> > > The problem is that there's no way to process the event correctly
> even
> > > when we get it.  All we can do is issue another report LUNS
> command and
> > > compare.  However, just because it looks like a single LUN
> disappeared
> > > doesn't mean the others weren't permuted or altered in some way
> (which
> > > data we cannot get).
> > >
> >
> > ?Why? if I keep a mapping between sg devices and device id (Inquiry
> page
> > 0x83) then I have all the data.
> 
> No we don't, it depends on array policy.  Most arrays when told to
> take
> 10% of space from 10 luns and create a new one won't change the WWN of
> the existing 10 LUNS, so we have no idea what just happened or what we
> should do about it (incidentally, this is an example of a
> reconfiguration you probably wanted to do offline anyway).
> 
> James
> 

