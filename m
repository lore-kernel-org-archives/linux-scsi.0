From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [patch 0/6] marginalize HCIL a bit
Date: Mon, 24 Oct 2005 16:41:01 -0400
Message-ID: <435D46DD.9030009@adaptec.com>
References: <20051023013618.GA18201@havoc.gtf.org>	 <1130081372.3437.33.camel@mulgrave>  <435D0283.40505@adaptec.com>	 <1130172627.3325.57.camel@mulgrave>  <435D176E.5000201@adaptec.com> <1130185688.3325.88.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:28344 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751265AbVJXUlH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 16:41:07 -0400
In-Reply-To: <1130185688.3325.88.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

On 10/24/05 16:28, James Bottomley wrote:
> On Mon, 2005-10-24 at 13:18 -0400, Luben Tuikov wrote:
> 
>>>>All of this functionality and infrastructure is present in the
>>>>SAS Stack and could be taken almost as is.
>>>
>>>
>>>Amazingly enough, it's also already present in the transport classes
>>>(see vanilla linux kernel source code).
>>
>>1. What are we talking about here?
>>2. File location, name and line please.  Thank you.
> 
> 
> The best commented file is scsi_transport_spi.c; you can see how it adds
> spi specific pieces to the scsi_target structure using the generic
> transport class capabilities.

Again, no file name or line number, plus at that point I can see that
this is going nowhere, well past the "all of this functinality...".

> I think you don't quite understand what a generic device is:  It's a

Hey, in those recent threads, I've been told by you and Jeff that I don't
understand anything.  Why does this now surprise you?  Apparently only you
and Jeff understand everything.  Can we move on now.

> structure which is embedded within other structures, exactly like a
> kobject.  The reason for using generic devices instead of kobjects is
> that they provide a wider range of useful functionality.

Again, domain devices should stay only in the transport layer.  There
is no _need_ to represent them with "generic device" as they have
no _meaning_ outisde the transport (layer).

>>>scsi_target contains a variable space for
>>>the transport classes to use for their transport specific pieces (which
>>>is where you could have put all the sas specific bits).
>>
>>Absolutely NOT.  Those "transport specific pieces" should be completely
>>OPAQUE to SCSI Core -- as you saw in my previous email, the
>>"transport specific pieces" as you called them were 
>>"void *domain_device;  /* opaque to SCSI Core */".
> 
> 
> They *are* opaque to the scsi mid-layer.  Refer to the code in the
> vanilla kernel.

The vanilla kernel has nothing, not even remotely similar to what
I have in the SAS Stack.  Other than the USB and SBP code.

Again: file location, name and line number please.

See how you just say: "the vanilla kernel has it all" and hope that
people will just believe, because let's face it, how many readers
will actually open the Linux source code and go and find it?

But you see when I say that it is there, I actually give
file names, locations, line numbers, function names and even
cut and paste code.

>>I guess the proper question to ask now is: "Can you envision it?"
>>
>>
>>>The only real difference is that under the current infrastructure scsi
>>>targets aren't designed to stack.  Realistically, the way you have it
>>>implemented, you have several different devices lumped into your domain
>>>device (end, edge, fanout, sata) with different initialisations and
>>
>>1. How this is implemented is Layer dependent (USB/SBP/FC/SAS/iSCSI/etc).
>>2. A struct domain_device can be _only_ one of end/edge/fanout/sata/etc,
>>   and only one of those.
>>Only devices which _make_sense_ to SCSI Core are registered with SCSI Core,
>>i.e. end devices.  Other type of devices (e.g. expanders) that are
>>NOT SCSI devices are not registered with SCSI Core, neither should they
>>be visible anywhere outside of the respective Layer (SAS in this case).
> 
> 
> That *is* how the transport classes work.  The obvious example being a

It *is not*.  What your "transport attribute classes" are is a work around
SDI.  The template they stem off of, transport_class, is just exporting
_attributes_.

For example take a look at the event management in the SAS Stack.  Take
a look at all other things it implements.  Such concepts belong to
a separate layer, which doesn't yield to generalization as you've tried
to do.

> FC rport which has no existence outside of the FC transport class and is
> not understood at all by the mid-layer.  Refer to the code in the
> vanilla kernel.

FC is the last example I'd look at as far as anything "proper" is to
be implemented.  I mean how many variations did it go over?

Actually, it is a good thing you refer people to that code, then
they can take a look at the SAS Stack and can make their own conlusions.

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
