From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 0/6] marginalize HCIL a bit
Date: Mon, 24 Oct 2005 16:12:33 -0500
Message-ID: <1130188353.3325.123.camel@mulgrave>
References: <20051023013618.GA18201@havoc.gtf.org>
	 <1130081372.3437.33.camel@mulgrave>  <435D0283.40505@adaptec.com>
	 <1130172627.3325.57.camel@mulgrave>  <435D176E.5000201@adaptec.com>
	 <1130185688.3325.88.camel@mulgrave>  <435D46DD.9030009@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:48560 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751296AbVJXVMi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 17:12:38 -0400
In-Reply-To: <435D46DD.9030009@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

On Mon, 2005-10-24 at 16:41 -0400, Luben Tuikov wrote:
> > The best commented file is scsi_transport_spi.c; you can see how it adds
> > spi specific pieces to the scsi_target structure using the generic
> > transport class capabilities.
> 
> Again, no file name or line number, plus at that point I can see that
> this is going nowhere, well past the "all of this functinality...".

I consider scsi_transport_spi.c to be a file name.  Try lines 38-1219.

> > I think you don't quite understand what a generic device is:  It's a
> 
> Hey, in those recent threads, I've been told by you and Jeff that I don't
> understand anything.  Why does this now surprise you?  Apparently only you
> and Jeff understand everything.  Can we move on now.
> 
> > structure which is embedded within other structures, exactly like a
> > kobject.  The reason for using generic devices instead of kobjects is
> > that they provide a wider range of useful functionality.
> 
> Again, domain devices should stay only in the transport layer.  There
> is no _need_ to represent them with "generic device" as they have
> no _meaning_ outisde the transport (layer).

Um, that's not what you said here:

http://marc.theaimsgroup.com/?l=linux-scsi&m=112887522221936&w=2

You said:

> struct scsi_domain_device { ... }; (to be created) is your friend.
> 
> The only way that that design
> 	"should be capable of representing any 
> 	 SCSI domain (FC/SPI/SBP etc ..)"
> 
> Is if it _does not_ have any knowlege about the underlying
> physical domain -- just as it is shown in SAM (and that is the whole point).
> Else you get in this neverending cat-and-mouse game.  If you have the
> abstraction right, then whatever new transport comes along, it would
> be properly represented.

So that's precisely a generic domain device.

But my point is that what's in include/device.h which the kernel calls a
generic device is simply an abstraction that has certain useful
properties; properties which we make use of.  Identical to the way a
kobject has a more limited set of useful properties.

> >>>scsi_target contains a variable space for
> >>>the transport classes to use for their transport specific pieces (which
> >>>is where you could have put all the sas specific bits).
> >>
> >>Absolutely NOT.  Those "transport specific pieces" should be completely
> >>OPAQUE to SCSI Core -- as you saw in my previous email, the
> >>"transport specific pieces" as you called them were 
> >>"void *domain_device;  /* opaque to SCSI Core */".
> > 
> > 
> > They *are* opaque to the scsi mid-layer.  Refer to the code in the
> > vanilla kernel.
> 
> The vanilla kernel has nothing, not even remotely similar to what
> I have in the SAS Stack.  Other than the USB and SBP code.

You've changed the grounds.  Your original claim was that the added
properties weren't opaque, which they are.

> >>>The only real difference is that under the current infrastructure scsi
> >>>targets aren't designed to stack.  Realistically, the way you have it
> >>>implemented, you have several different devices lumped into your domain
> >>>device (end, edge, fanout, sata) with different initialisations and
> >>
> >>1. How this is implemented is Layer dependent (USB/SBP/FC/SAS/iSCSI/etc).
> >>2. A struct domain_device can be _only_ one of end/edge/fanout/sata/etc,
> >>   and only one of those.
> >>Only devices which _make_sense_ to SCSI Core are registered with SCSI Core,
> >>i.e. end devices.  Other type of devices (e.g. expanders) that are
> >>NOT SCSI devices are not registered with SCSI Core, neither should they
> >>be visible anywhere outside of the respective Layer (SAS in this case).
> > 
> > 
> > That *is* how the transport classes work.  The obvious example being a
> 
> It *is not*.  What your "transport attribute classes" are is a work around
> SDI.  The template they stem off of, transport_class, is just exporting
> _attributes_.

No, that's what you keep trying to claim they are.  In fact they're
attributes coupled with library functions.  A good example being
spi_dv_device(struct scsi_device *sdev) which performs Domain Validation
(an SPI specific function) on a given SCSI device.  That is contained
within the SPI transport class and definitely isn't an attribute, it's a
service used by SPI specific drivers.

> For example take a look at the event management in the SAS Stack.  Take
> a look at all other things it implements.  Such concepts belong to
> a separate layer, which doesn't yield to generalization as you've tried
> to do.

In the transport classes, layer specific code is confined, that's what
the spi_ functions do in the spi transport class.  There's no equivalent
in the generic code, it's just a template builder for the transport
specific code.

> > FC rport which has no existence outside of the FC transport class and is
> > not understood at all by the mid-layer.  Refer to the code in the
> > vanilla kernel.
> 
> FC is the last example I'd look at as far as anything "proper" is to
> be implemented.  I mean how many variations did it go over?

Ah, so you accept that the FC transport class does do this but you just
don't want it to be admitted as a valid example because the class grew
organically?  As Jeff has tried to explain, that's how linux development
goes.

James


