From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Wed, 18 Mar 2009 16:26:51 -0400
Message-ID: <1237408011.3350.44.camel@localhost.localdomain>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
	 <20090318013621.26548.10529.sendpatchset@chandra-ubuntu>
	 <1237402051.3350.29.camel@localhost.localdomain>
	 <1237403542.14147.23.camel@chandra-ubuntu>
	 <1237406940.3350.39.camel@localhost.localdomain>
	 <ac3eb2510903181324s6bc442e0ka3448b53567e1dce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52590 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652AbZCRU06 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2009 16:26:58 -0400
In-Reply-To: <ac3eb2510903181324s6bc442e0ka3448b53567e1dce@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: sekharan@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, pjones@redhat.com, michaelc@cs.wisc.edu

On Wed, 2009-03-18 at 21:24 +0100, Kay Sievers wrote:
> On Wed, Mar 18, 2009 at 21:09, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Wed, 2009-03-18 at 12:12 -0700, Chandra Seetharaman wrote:
> >> On Wed, 2009-03-18 at 18:47 +0000, James Bottomley wrote:
> >> > On Tue, 2009-03-17 at 18:36 -0700, Chandra Seetharaman wrote:
> >> > > From: Peter Jones <pjones@redhat.com>
> >> > >
> >> > > This patch allows the use of modaliases on scsi targets to correctly
> >> > > load scsi device handler modules when the devices are found.
> >> > >
> >> > > Signed-off-by: Peter Jones <pjones@redhat.com>
> >> > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> >> >
> >> > I have to say this is a bit icky.
> >> >
> >> > overloading the modalias type like this produces several nasty effects:
> >> >
> >> >      1. You don't actually care about type for any of the scsi_dh
> >> >         handlers, so they all have it as a useless extra field
> >> >      2. TYPE_ANY is a bogus (non SAM) definition ... I suppose it's
> >> >         unlikely ever to clash, but you never know
> >>
> >> >From (1) and (2) are you suggesting _not_ to use the TYPE field for
> >> scsi_dh handlers ?
> >
> > Well, you don't ever set it to anything other than TYPE_ANY, do you? so
> > it's completely superfluous as far as you're concerned.  That's why
> > overloading the SCSI ULD modalias looks rather contrived.
> >
> >> >      3. scsi_dh handlers would now get loaded on *any* system ...
> >> >         regardless of whether it's using multipathing or not ... that's
> >> >         going to cause problems with other multi path solutions, I bet.
> >>
> >> Actually that is the intent. We _do_ want scsi_dh handlers to be loaded
> >> before multipath comes into picture.
> >>
> >> Basically we want the handlers to be available ASAP after the device is
> >> configured. The reason is:
> >>  - These devices are active/passive, SCSI doesn't know about it and
> >>    any I/O sent to SCSI will be sent down to the device, irrespective
> >>    of the active/passive nature of the device in that path. When the
> >>    device (path) is passive, I/O leads to time delay and extraneous
> >>    error message (these are the two main reasons we moved the
> >>    device handler code from dm-multipath layer to SCSI(scsi_dh)).
> >>
> >> With scsi_dh, I/O to the passive path will be short circuited in
> >> prep_fn() and errors are REQ_QUIET'd.
> >>
> >> Currently I suggest users to add these modules to their initrd to make
> >> them available ASAP (as described at
> >> http://sources.redhat.com/lvm2/wiki/MultipathUsageGuide#head-fb3efbb82fa69ca86b7db26423c235ae6c280caa)
> >>
> >> If we have the support thru modalias, then appropriate modules will be
> >> included in initrd by the installer, thereby making it easier for the
> >> user.
> >
> > Um, is that correct?  the MODALIAS env is lost as soon as it goes
> > through udev.  For initrd to base module selection on the MODALIAS, it
> > will have to reconstruct it after the fact (and so need modifying to use
> > the new modalias).
> 
> A device's modalias is usually also available as an attribute called
> "modalias". The entire device uevent environment is in almost all
> cases also available by reading the "uevent" file of the device at any
> time later.
> 
> Does that help? I might misread your "MODALIAS env is lost" sentence.

Yes .. I'd forgotten that; I was thinking of the environment as it
passes through udev.

James


