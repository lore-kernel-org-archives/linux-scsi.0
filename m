From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [Suspected SPAM:###] RE: qla2xxx random device resets, eventual io errors, invalid con	text
Date: Fri, 26 Sep 2003 11:29:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0598C46@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:52908 "EHLO AVEXCH01.qlogic.org")
	by vger.kernel.org with ESMTP id S261546AbTIZS24 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 14:28:56 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Shoemaker Christopher A NPRI <ShoemakerCA@Npt.NUWC.Navy.Mil>
Cc: linux-scsi@vger.kernel.org

Christopher,

> > I have a feeling the kernel is using bounce-buffers for the
> > transfers.  Unfortunately, not all kernels (vary by version and
> > distribution) use a consistent nomenclature for scsi host template
> > members, i.e.  can_dma_32, highmem_io, vary_io, etc...  Earlier
> > versions of the drivers would attempt to infer names/existence of
> > members based on kernel CONFIG options and version -- the success
> > rate was rather poor.  Our next driver release will use a 'more'
> > intelligent method of determining host members with the help of
> > the compiler.  
> 
> By "next" do you mean ver 8 beta 6, or something more major?
> 

Sorry, in this context I'm referring to the next release of the 6.x
series driver for 2.4 support.

...
> > 
> > Given this information, my best guess would be the target may be
> > having some problems within the loop, since as you say, the
> > problems followed the HBA.
> > 
...
> Yes, I've pretty much convinced myself it's not a problem with the
> HBA.  I don't have a finisar immediately available, but if I find
> out more specifically what I need, there's a chance I could borrow
> one.  But OTOH, there's only one device on the HBA, and there's only
> the one copper cable (which I've tried replacing).  What detail
> could a FC trace give?
>

Given the simple configuration (no hub or other devices), and the
problem appears to trail the storage, none.

> If it would help, what type of Finisar would I need?
> 

Any one that supports 1GB/s fibre channel.

> Since there's only one device, is there any possibility other than
> to say that device is generating the "LIP reset primitive sequence"?
> I mean, it's not possible that this fault is on the
> HBA/server/driver side of things, is it?
> 

It's certainly possible for the initiator to be at fault.  If the
initiator cannot sustain a connection to the loop -- framing errors,
lost frames, etc., resets can occur.

> Are the LIP resets unique to loop mode?  Should I try some more
> tests with the card in point-to-point mode?
> 

I've spoken with several other firmware engineers, the overwhelming
consensus given the data points, points to a problem with the storage
device.

> By the way, the device is a 2TB Infortrend SentinelRAID 2500.  I
> don't know much about the RAID controller, except that it's running
> a PPC750.
> 

I'd suggest you speak with the manufacturer (or reseller) of the
storage box.

> Thanks for your help.  Somehow it's comforting to hear an
> authoritative voice say, "No, it's not you - you have real
> problems!"
> 

Good luck,

Andrew Vasquez
QLogic Corporation
