From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Wed, 18 Mar 2009 13:59:36 -0700
Message-ID: <1237409976.14147.31.camel@chandra-ubuntu>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
	 <20090318013621.26548.10529.sendpatchset@chandra-ubuntu>
	 <1237402051.3350.29.camel@localhost.localdomain>
	 <1237403542.14147.23.camel@chandra-ubuntu>
	 <1237406940.3350.39.camel@localhost.localdomain>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:39993 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZCRU4r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2009 16:56:47 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n2IKs4BZ005250
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2009 14:54:04 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2IKubDg023832
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2009 14:56:41 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2IKuasG020549
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2009 14:56:37 -0600
In-Reply-To: <1237406940.3350.39.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: sekharan@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, pjones@redhat.com, michaelc@cs.wisc.edu


On Wed, 2009-03-18 at 20:09 +0000, James Bottomley wrote:
> On Wed, 2009-03-18 at 12:12 -0700, Chandra Seetharaman wrote:
> > On Wed, 2009-03-18 at 18:47 +0000, James Bottomley wrote:
> > > On Tue, 2009-03-17 at 18:36 -0700, Chandra Seetharaman wrote:
> > > > From: Peter Jones <pjones@redhat.com>
> > > > 
> > > > This patch allows the use of modaliases on scsi targets to correctly
> > > > load scsi device handler modules when the devices are found.
> > > > 
> > > > Signed-off-by: Peter Jones <pjones@redhat.com>
> > > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > > 
> > > I have to say this is a bit icky.
> > > 
> > > overloading the modalias type like this produces several nasty effects:
> > > 
> > >      1. You don't actually care about type for any of the scsi_dh
> > >         handlers, so they all have it as a useless extra field
> > >      2. TYPE_ANY is a bogus (non SAM) definition ... I suppose it's
> > >         unlikely ever to clash, but you never know
> > 
> > >From (1) and (2) are you suggesting _not_ to use the TYPE field for
> > scsi_dh handlers ?
> 
> Well, you don't ever set it to anything other than TYPE_ANY, do you? so
> it's completely superfluous as far as you're concerned.  That's why
> overloading the SCSI ULD modalias looks rather contrived.
> 
> > >      3. scsi_dh handlers would now get loaded on *any* system ...
> > >         regardless of whether it's using multipathing or not ... that's
> > >         going to cause problems with other multi path solutions, I bet.
> > 
> > Actually that is the intent. We _do_ want scsi_dh handlers to be loaded
> > before multipath comes into picture.
> > 
> > Basically we want the handlers to be available ASAP after the device is
> > configured. The reason is:
> >  - These devices are active/passive, SCSI doesn't know about it and
> >    any I/O sent to SCSI will be sent down to the device, irrespective 
> >    of the active/passive nature of the device in that path. When the
> >    device (path) is passive, I/O leads to time delay and extraneous 
> >    error message (these are the two main reasons we moved the
> >    device handler code from dm-multipath layer to SCSI(scsi_dh)).
> > 
> > With scsi_dh, I/O to the passive path will be short circuited in
> > prep_fn() and errors are REQ_QUIET'd.
> > 
> > Currently I suggest users to add these modules to their initrd to make
> > them available ASAP (as described at
> > http://sources.redhat.com/lvm2/wiki/MultipathUsageGuide#head-fb3efbb82fa69ca86b7db26423c235ae6c280caa)
> > 
> > If we have the support thru modalias, then appropriate modules will be
> > included in initrd by the installer, thereby making it easier for the
> > user.
> 
> Um, is that correct?  the MODALIAS env is lost as soon as it goes
> through udev.  For initrd to base module selection on the MODALIAS, it
> will have to reconstruct it after the fact (and so need modifying to use
> the new modalias).
> 

The idea is that installer would see the module thru modalias and would
add it to initrd. So, initrd would have the module only in systems where
the specific storage is found (and is done automatically).

> > BTW, dm-multipath currently have code to insert appropriate modules if
> > needed (if they are not already made available).
> 
> So all of this is just to keep the initrd boot quiet?

to keep boot quiet and fast (with about 100 luns, boot time delay is
about 50 mins, and it increases proportionately)

> 
> James
> 
> 

