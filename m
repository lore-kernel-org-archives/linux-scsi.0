From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Broadcom 8603 SAS/SATA driver, rough draft
Date: Sun, 23 Sep 2007 18:59:07 -0500
Message-ID: <1190591947.3378.31.camel@localhost.localdomain>
References: <20070923040437.GA30170@havoc.gtf.org>
	 <1190588723.3378.25.camel@localhost.localdomain>
	 <46F6FA11.2070501@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:49398 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755052AbXIWX7K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Sep 2007 19:59:10 -0400
In-Reply-To: <46F6FA11.2070501@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Sun, 2007-09-23 at 19:43 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > On Sun, 2007-09-23 at 00:04 -0400, Jeff Garzik wrote:
> >> Rather than sitting on this for far too long, I wanted to go ahead and
> >> get this out there.  I heard some chips might be trickling out into
> >> public hands.
> > 
> > The first thing to note is about the specs and the pre-production
> > hardware: the Linux Foundation has mechanism to get both into the hands
> > of interested developers; if you can point me to contacts, I can at
> > least get the NDA documentation programme ball rolling.
> 
> Well, are there interested, motivated, skilled developers with time?  :)
> 
> Otherwise it's a moot point.

We have GregKH's minions ... this would be a good project for them.

> >> This is a bare bones Broadcom 8603 SAS+SATA driver, attempting to use
> >> the vaunted libsas.  Notes:
> > 
> > I wouldn't call it "vaunted" but it's been a fun project.
> 
> That was sarcasm :)
> 
> libsas is a big 'ole pain, that I'm finding has many aic94xx-isms buried 
> in the lib.

Well, that's hardly surprising ... it was written by Adaptec and there
was no other device to help with its production.

> >> * A quick glance at the FIXMEs will tell you obviously doesn't work.
> > 
> > The first thing I really noted is that SMP and STP protocol support is
> > stubbed out ... you really can't do anything other than direct device
> > connection without them.
> 
> That's sorta the way I read the hardware docs, too.
> 
> I have some engineering questions pending with Broadcom, but from my 
> read, SMP and STP don't seem supported.

That would effectively render the device pretty much useless.  The maing
benefit of SAS is that you can support expanders, which are the
predominant connection infrastructure.  Direct connect SAS is OK, but
SATA tends to be cheaper.

> >> * The hardware is quite simple and straightforward and easy to program
> >>   in an efficient way:  each SAS port has a command queue (DMA ring) and
> >>   a response queue (DMA ring).  Or if in SATA mode, just a command
> >>   queue.
> > 
> > That's not such a bad way of doing it ... it pretty much mimics the wire
> > protocol, which is simply frame in/frame out for SAS.
> 
> Yep.  The hardware (on my end of the spectrum) seems to be moving 
> towards forcing software to generate all "packets," except (a) data 
> frames [generated via DMA engine] or (b) special frames that need to 
> modify the software-generate frame.

SMP and STP, by the way, are simple frame in, frame out.  If it
identifies the initiator and target protocols and allows us to send
frames, we can probably transmit both protocols.

> >> * The SAS/SATA negotiation is largely out of our hands.  The silicon
> >>   does its thing, and then tells us what type of device connected.  We
> >>   are then expected to switch the port to either SAS mode or SATA mode,
> >>   accordingly.
> >>
> >> * There is no firmware or anything.  Just DMA and register bitbanging.
> >>   We have plenty of low-level control.
> >>
> >> * The state of SAS/SATA integration is perpetually pathetic.  Updates
> >>   in this area are likely.  There's a rumor Brian King @ IBM may look
> >>   into this area too.
> >>
> >> * This driver pretty much completely lacks exception handling.
> > 
> > I also note there's a slight nomenclature issue which will trip up SAS
> > people.  All through the driver, you seem to use the word "port" to
> > refer to a physical phy.  the struct bs_port seems to actually be a phy
> > descriptor ... unless there's some missing phy<->port setup logic that
> > will be in the final driver?  The trouble is that phys and ports are
> > distinct (and not equivalent) objects in SAS.
> 
> Nomemclature came straight from the hardware docs, I'm afraid.
> 
> Comparing with the Marvell hardware, I can see how (with Marvell) wide 
> ports can be set up, and the port/phy distinction is easily programmable 
> depending on the situation.
> 
> Not so with BCM8603.

That's going to be a bit of a bit oops ...

> The only places where the docs mention SMP and STP at all is in the SAS 
> outgoing DMA descriptor docs, when you fill in connection type.  The 
> _only_ other mention of SMP or STP at all is a note saying neither is 
> supported.  So, even the docs contradict themselves, but overall I have 
> the feeling that SMP/STP are out of my hands.

Heh, well, I suppose it was designed for simple direct connection ...

> I wonder if Broadcom's interface is born out of the closed RAID-on-chip 
> product that this is descended from.
> 
> Hopefully more knowledge will be gained soon, as I debug simple SAS and 
> SATA device plug/unplug, and ask Broadcom questions.
> 
> 
> >> As an aside, I am also writing a driver for Marvell chips that behave
> >> quite similarly to this chip.  It seems the future of storage might look
> >> like these Broadcom and Marvell SAS+SATA DMA ring interfaces, in the
> >> volume marketspace at least.
> > 
> > If you have a contact here too, I can get the LF NDA and hardware
> > programmes rolling.
> 
> Same response as at the top :)  Marvell is actually better at responding 
> than Broadcom, but I'm quite reluctant to make /another/ introduction 
> (already did so for one hacker) that leads nowhere.

Same answer ... GregKH has a legion ... lets use it.

James


