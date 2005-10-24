From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 0/6] marginalize HCIL a bit
Date: Mon, 24 Oct 2005 15:28:08 -0500
Message-ID: <1130185688.3325.88.camel@mulgrave>
References: <20051023013618.GA18201@havoc.gtf.org>
	 <1130081372.3437.33.camel@mulgrave>  <435D0283.40505@adaptec.com>
	 <1130172627.3325.57.camel@mulgrave>  <435D176E.5000201@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:16816 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751247AbVJXU2Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 16:28:16 -0400
In-Reply-To: <435D176E.5000201@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

On Mon, 2005-10-24 at 13:18 -0400, Luben Tuikov wrote:
> >>All of this functionality and infrastructure is present in the
> >>SAS Stack and could be taken almost as is.
> > 
> > 
> > Amazingly enough, it's also already present in the transport classes
> > (see vanilla linux kernel source code).
> 
> 1. What are we talking about here?
> 2. File location, name and line please.  Thank you.

The best commented file is scsi_transport_spi.c; you can see how it adds
spi specific pieces to the scsi_target structure using the generic
transport class capabilities.

> > If you look at your domain device with all the sas pieces removed,
> > you'll see that scsi_target actually covers all the remaining bits
> > (there are one or two pieces covered by struct generic_device which you
> > have to have extra components for because you implemented kobjects
> > instead of a generic device).
> 
> And there is a reason for this: domain devices are NOT and WILL NEVER
> BE "generic device".  Domain device representations exist only in
> the Transport Layer.  What you seem to suggest with your "transport
> attributes" is this "appendages-modules" which intersperse everywhere
> in SCSI Core and LLDD like octopus's arms.  See USB Storage and SBP.

I think you don't quite understand what a generic device is:  It's a
structure which is embedded within other structures, exactly like a
kobject.  The reason for using generic devices instead of kobjects is
that they provide a wider range of useful functionality.

> > scsi_target contains a variable space for
> > the transport classes to use for their transport specific pieces (which
> > is where you could have put all the sas specific bits).
> 
> Absolutely NOT.  Those "transport specific pieces" should be completely
> OPAQUE to SCSI Core -- as you saw in my previous email, the
> "transport specific pieces" as you called them were 
> "void *domain_device;  /* opaque to SCSI Core */".

They *are* opaque to the scsi mid-layer.  Refer to the code in the
vanilla kernel.

> I guess the proper question to ask now is: "Can you envision it?"
> 
> > The only real difference is that under the current infrastructure scsi
> > targets aren't designed to stack.  Realistically, the way you have it
> > implemented, you have several different devices lumped into your domain
> > device (end, edge, fanout, sata) with different initialisations and
> 
> 1. How this is implemented is Layer dependent (USB/SBP/FC/SAS/iSCSI/etc).
> 2. A struct domain_device can be _only_ one of end/edge/fanout/sata/etc,
>    and only one of those.
> Only devices which _make_sense_ to SCSI Core are registered with SCSI Core,
> i.e. end devices.  Other type of devices (e.g. expanders) that are
> NOT SCSI devices are not registered with SCSI Core, neither should they
> be visible anywhere outside of the respective Layer (SAS in this case).

That *is* how the transport classes work.  The obvious example being a
FC rport which has no existence outside of the FC transport class and is
not understood at all by the mid-layer.  Refer to the code in the
vanilla kernel.

James


